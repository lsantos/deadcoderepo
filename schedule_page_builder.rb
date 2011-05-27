#! /usr/bin/ruby
 require 'rubygems'
 require 'open-uri'
 require 'nokogiri'

$keys = {"Soccer City Stadium" => "soccercity", "Moses Mabhida Stadium" =>"durbam", "Ellis Park"=>"ellis",\
"Peter Mokaba Stadium"=>"peter", "Free State Stadium"=>"freestate","Royal Bafokeng Stadium"=>"royalbafkeng",\
"Mbombela Stadium"=>"mbombela","Loftus Versfeld Stadium"=>"loftus","Nelson Mandela Bay Stadium"=>"portelizabeth",\
"Cape Town Stadium"=>"greenpoint"}
doc = Nokogiri::HTML.parse(open("http://soccernet.espn.go.com/world-cup/fixtures"))

team_visitor = doc.css("div.team.visitor p a").map{|node| node.text}
team_home = doc.css("div.team.home p a").map{|node| node.text}
$match_lks = doc.css("div.match-links p").map{|node| node.text}

lines = File.open("groups.txt").readlines
output = []

def find_key(stadium)
  stadium = stadium[1..stadium.size]
 $keys[stadium]
end


def join_teams(team_visitor, team_home)
    new_team = []
    team_home.each_with_index do |team,idx|
      new_st = team +" vs. "+ team_visitor[idx] unless team.nil?
      new_team << new_st
    end
    new_team
end

$joined_teams = join_teams(team_visitor, team_home)

def find_stadium_by_teams(team_to_comp)
  stadium = ""
  team_to_comp = team_to_comp.split("vs.")
  team_to_comp = team_to_comp.collect{|t| t.gsub(/\s/,"")}


  $joined_teams.each_with_index do |team,idx|
    team =  team.split("vs.")
    team = team.collect {|t| t.gsub(/\s/,"") }
    team = team.collect {|t| t == "UnitedStates" ? t.replace("USA") : t }

    match = team_to_comp.collect {|te| team.include?(te) }

    if !match.include?(false)
     stadium = $match_lks[idx]
    end
  end
  stadium
end

lines.each_with_index do |line,idx|
  line = line.split("\t")
  a = line[0]
  b = line[1]
  b = b.sub(/Group/,''  )
  c = line[2]
  d = find_stadium_by_teams(c)
  e = d.sub(/at/, '')
  s =   %{\s\s\s\s\s %tr
        %td{:style => "text-align: justify;"}="#{a}"
        %td{:style => "text-align: center;"}="#{b}"
        %td{:style => "text-align: justify;"}="#{c}"
        %td{:style => "text-align: justify;"}= link_to("#{d[3..d.size]}", { :controller => "venues", :params =>{:stadium_name =>"#{d[3..d.size]}", :stadium_key => "#{find_key(e)}"} })
        }

  output << s

  if idx == 47
    break
  end

end



out = File.new("page_outcome","w")
out << output.join("\n")
out.close()

