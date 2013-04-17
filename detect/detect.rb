require 'anomaly_hmm'

$username = `whoami`.chomp
$filename = 'commands.txt'
$unique_seq, $observation_seq = [], []

#read .bash_history
def read_commands
  newfile = File.new("/home/#{$username}/#{$filename}", "w")
  File.foreach "/home/#{$username}/.bash_history" do |line|
	if (i = line.index(" ")) != nil
	  if line[0...i] == "sudo"
		if (j = line[(i+1)..-1].index(" ")) != nil
		  j = j + i + 1
		  newfile.puts line[0...i]+"_"+line[(i+1)...j]
		else
		  newfile.puts line[0...i]+"_"+line[(i+1)..-1]
		end
	  else
		newfile.puts line[0...i]
	  end
	else
	  newfile.puts line
	end
  end
  newfile.close
end

#index the commands in commands.txt
def index_commands
  File.foreach "/home/#{$username}/#{$filename}" do |line|
	line = line.chomp
	if !$unique_seq.include?(line)
	  $unique_seq << line
	end
  end
  File.foreach "/home/#{$username}/#{$filename}" do |line|
	line = line.chomp
	$observation_seq << $unique_seq.index(line)
  end
end

read_commands
index_commands

t1 = Time.now.to_i
u = AnomalyHmm.new
u.train($unique_seq, $observation_seq)
t2 = Time.now.to_i
total = t2 - t1
if total == 1 || total == 0
  puts "The pragram costs "+total.to_s+" second.\n"
else
  puts "The pragram costs "+total.to_s+" seconds.\n"
end

loop do
  count = 1
  new_observation = []
  while count <= 10
	print "$ "
	command = gets
	#execute the command
	`#{command}`
	command = command.chomp
	count = count + 1
	
	#truncate the coming command and store it in new_observation
	if (i = command.index(" ")) != nil
	  if command[0...i] == "sudo"
		if (j = command[(i+1)..-1].index(" ")) != nil
		  j = j + i + 1
		  new_observation << command[0...i]+"_"+command[(i+1)...j]
		else
		  new_observation << command[0...i]+"_"+command[(i+1)..-1]
		end
	  else
		new_observation << command[0...i]
	  end
	else
	  new_observation << command
	end
  end

  #test this new observation sequence, probability = 0.0 indicates the sequence comes from the masquerader
  observation = []
  new_observation.each do |s|
	if !$unique_seq.include?(s)
	  probability = 0.0
	  puts "the probability is: 0.0"
	  `exit`
	else
	  observation << $unique_seq.index(s)
	end
  end
  
  u.test(observation)
  puts "the probability is: "+u.printProb.to_s
  if u.printProb == 0.0
	`exit`
  else
	openfile = File.open("/home/#{$username}/#{$filename}", "a+")
	for i in 0...new_observation.length
	  openfile.puts new_observation[i]
	end
	openfile.close
  end
end
