require 'rubygems'
require 'facets'

module James
  def name
    "James"
  end
end

module Lynn
  def name
    "Lynn"
  end
end

class FamilyMember
  include James
  include Lynn
end

puts FamilyMember.ancestors
member = FamilyMember.new
p member.name
p member.as(James).name