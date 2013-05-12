require 'anomaly_hmm'

$userfile = 'kbd_mouse_data0.txt'
$testfile = 'test_events.txt'
$unique_seq, $observation_seq, $new_obs, $test_obs = [], [], [], []	

#index the commands in input_events.txt
def index_commands
  File.foreach "#{$userfile}" do |line|
	line = line.chomp
	if !$unique_seq.include?(line)
	  $unique_seq << line
	end
  end
  File.foreach "#{$userfile}" do |line|
	line = line.chomp
	$observation_seq << $unique_seq.index(line)
  end
end

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

File.foreach "#{$testfile}" do |line|
  line = line.chomp
  $new_obs << line
end

#test this observation sequence, probability = 0.0 indicates the sequence comes from the masquerader
$new_obs.each do |s|
  if !$unique_seq.include?(s)
	probability = 0.0
	puts "the probability is: 0.0"
	`exit`
  else
	$test_obs << $unique_seq.index(s)
  end
end

u.test($test_obs)
puts "the probability is: "+u.printProb.to_s
if u.printProb == 0.0
  `exit`
else
  puts "It is legal."
end
