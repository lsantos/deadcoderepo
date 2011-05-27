require "rubygems"
require 'perftools'
require 'nokogiri'

def html_truncate(input, num_words = 15, truncate_string = "...")
	doc = Nokogiri::HTML(input)

	current = doc.children.first
	count = 0

	while true
		# we found a text node
		if current.is_a?(Nokogiri::XML::Text)
			count += current.text.split.length
			# we reached our limit, let's get outta here!
			break if count > num_words
			previous = current
		end

		if current.children.length > 0
			# this node has children, can't be a text node,
			# lets descend and look for text nodes
			current = current.children.first
		elsif !current.next.nil?
			#this has no children, but has a sibling, let's check it out
			current = current.next
		else 
			# we are the last child, we need to ascend until we are
			# either done or find a sibling to continue on to
			n = current
			while !n.is_a?(Nokogiri::HTML::Document) and n.parent.next.nil?
				n = n.parent
			end

			# we've reached the top and found no more text nodes, break
			if n.is_a?(Nokogiri::HTML::Document)
				break;
			else
				current = n.parent.next
			end
		end
	end

	if count >= num_words
	  unless count == num_words
  		new_content = current.text.split

      # If we're here, the last text node we counted eclipsed the number of words
      # that we want, so we need to cut down on words.  The easiest way to think about
      # this is that without this node we'd have fewer words than the limit, so all
      # the previous words plus a limited number of words from this node are needed.
      # We simply need to figure out how many words are needed and grab that many.
      # Then we need to -subtract- an index, because the first word would be index zero.

      # For example, given:
      # <p>Testing this HTML truncater.</p><p>To see if its working.</p>
      # Let's say I want 6 words.  The correct returned string would be:
      # <p>Testing this HTML truncater.</p><p>To see...</p>
      # All the words in both paragraphs = 9
      # The last paragraph is the one that breaks the limit.  How many words would we
      # have without it? 4.  But we want up to 6, so we might as well get that many.
      # 6 - 4 = 2, so we get 2 words from this node, but words #1-2 are indices #0-1, so
      # we subtract 1.  If this gives us -1, we want nothing from this node. So go back to
      # the previous node instead.
      index = num_words-(count-new_content.length)-1
      if index >= 0
        new_content = new_content[0..index]
  		  current.content = new_content.join(' ') + truncate_string
		  else
		    current = previous
		    current.content = current.content + truncate_string
	    end
	  end

		# remove everything else
		while !current.is_a?(Nokogiri::HTML::Document)
			while !current.next.nil?
				current.next.remove
			end
			current = current.parent
		end
	end

	# now we grab the html and not the text.
	# we do first because nokogiri adds html and body tags
	# which we don't want
	doc.root.children.first.inner_html
end

PerfTools::CpuProfiler.start("html_truncate_profile") do
  150_000.times { html_truncate(%Q{<div class="entry">
  <!--
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
       xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
       xmlns:dc="http://purl.org/dc/elements/1.1/">
  <rdf:Description
      rdf:about="http://betabug.ch/blogs/ch-athens/"
      trackback:ping="http://betabug.ch/blogs/ch-athens/227/tbping"
      dc:title="Checking System Activity on Mac OS X on the Command Line"
      dc:identifier="http://betabug.ch/blogs/ch-athens/227"
      dc:subject="mac"
      dc:description="So I'm logging into a Mac OS X machine (Server or not) remotely by ssh to do some maintenance and
  check on the health of the system. What I might be interested in is how CPU, memory and disk usage
  is coping with the jobs the server has to do. If I was sitting in front of the machine I could open
  "Activity Monitor" and click my way through the GUI. Not an option for this machine, since
  there is no GUI level remote access. So what do I do? There are some command line tools to give me
  the information I need..."
      dc:creator="betabug"
      dc:date="2005/11/02 13:20:52.110 GMT+1" />
  </rdf:RDF>
  -->


  <a name="227"></a>
  <h3 class="title">Checking System Activity on Mac OS X on the Command Line</h3>
  <div class="subtitle">Logging into server, no GUI, see?</div>
  <div class="category">
  <a rel="tag" href="http://betabug.ch/blogs/ch-athens/categoryname/12/mac">[mac]</a>&nbsp;
  </div>


  <p>So I'm logging into a Mac OS X machine (Server or not) remotely by ssh to
  do some maintenance and check on the health of the system. What I might 
  be interested in is how CPU, memory and disk usage is coping with the
  jobs the server has to do. If I was sitting in front of the machine I
  could open "Activity Monitor" and click my way through the GUI. Not an
  option for this machine, since there is no GUI level remote access.
  So what do I do? There are some command line tools to give me the
  information I need, let me show you top, vm_stat and iostat...</p>


  <br clear="all">

  <p>
  <a name="more"></a>
  </p><p>On my OpenBSD box "systat vmstat" is what I use for a full
  overview. That is not available for OS X, but some other tools are there.
  Most often used is "top", followed by "vm_stat" and "iostat".
  </p>

  <h4>top</h4>

  <p>"top" is
  well known and you likely have heard about it and probably used it
  before. The version on OS X is
  quite useable. After switching to "compatibility mode" (with 'x'), one
  can see only the processes of a single user (with 'U' and entering the
  user id or name). Top is good for checking what eats all the CPU time.
  </p>

  <h4>vm_stat</h4>
  <p>
  If it comes to memory usage, especially for the question "how much swap
  space am I using", then vm_stat can help. On Mac OS X that's vm_stat
  with an underscore, not vmstat. You just give vm_stat a delay in seconds
  (by calling it like "vm_stat 10" on the command line) and it updates the
  display repeatedly. Go on, try that out and then open a bunch of
  applications to see if pageouts are going up (which would mean that your
  machine has to page memory out on disk to make room for the new ones).
  </p><pre>$ vm_stat 5
  Mach Virtual Memory Statistics: (page size of 4096 bytes, cache hits 58%)
    free active inac wire   faults     copy zerofill reactive  pageins pageout
   49314  97619 154001 26746 42361341   320895 24148787   145786    50308 3459
   49341  97814 153974 26551     2902       21     1429        0        0 0
   45297  98409 157246 26728    12056      805     5639        0      272 0
   40400 101288 158727 27265    14663      841     6746        0     1261 0
   36365 103524 160004 27787     8302      712     3519        0     1630 0
  </pre>
  ...looks like my workstation is OK, even with starting up Acrobat Reader and a bunch of smaller programs at once.
  <p></p>
  <h4>iostat</h4>
  <p>
  It took me longer to discover iostat. The man page says that "Iostat
  displays kernel I/O statistics on terminal, device and cpu operations."
  Which is quite a lot and probably more than I usually want. I just use
  it with a line like:
  </p><pre>iostat -d -K -w 5
  </pre>
  to show me only devices (-d),
  kilobytes instead of blocks (-K), and have a wait interval of 5 seconds
  (-w 5). Go ahead, try it and watch it while doing a find for "foobar" on
  your disks. As usual with all command line tools, read the fine man
  pages.
  <pre>$ iostat -d -K -w 5
            disk0
    KB/t tps  MB/s
   16.90   1  0.01
   31.79 131  4.07
   32.00 752 23.51
   32.00  35  1.10
    4.00   1  0.00
    0.00   0  0.00
  ^C
  </pre>
  Finding all files that start with "pimp" on my single disk got the
  activity up a bit, then I stopped it with control-C. The display shows me Kilobytes per transfer, transfers per second, and Megabytes per second. Interpretation is of course up to you not to the tool :-). Playing with the -I switch might be interesting.
  <p></p>
  <p></p>
  <div class="posted">Posted by <b>betabug</b> at <a href="http://betabug.ch/blogs/ch-athens/227">13:20</a>
  	| <a href="http://betabug.ch/blogs/ch-athens/227#comments">Comments (0)</a>
  	| <a href="http://betabug.ch/blogs/ch-athens/227#trackbacks">Trackbacks (0)</a>	
  </div>

  </div>}, 25) }
end

PerfTools::CpuProfiler.stop