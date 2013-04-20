require 'anomaly_hmm'

$filename = 'a.txt'
$unique_seq, $observation_seq = [], []

#index the commands in a.txt
def index_commands
  File.foreach "#{$filename}" do |line|
	line = line.chomp
	if !$unique_seq.include?(line)
	  $unique_seq << line
	end
  end
  File.foreach "#{$filename}" do |line|
	line = line.chomp
	$observation_seq << $unique_seq.index(line)
  end
end

index_commands

puts $unique_seq.length.to_s

t1 = Time.now.to_i
u = AnomalyHmm.new
u.train($unique_seq, $observation_seq)
a = u.printA
b = u.printB
pi = u.printPi
print a
puts "\n"
print b
puts "\n"
print pi
puts "\n"
u.test($observation_seq[0...100])
t2 = Time.now.to_i
total = t2 - t1
if total == 1 || total == 0
  puts "The pragram costs "+total.to_s+" second.\n"
else
  puts "The pragram costs "+total.to_s+" seconds.\n"
end
