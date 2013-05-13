require 'anomaly_hmm'

$unique_all_seq = []
$user0_seq = []
$user1_seq = []
$user2_seq = []

#read all 3 users' commands and index them
def index_all_commands
  #read user0's history and index the commands
  File.foreach "history0.txt" do |line|
	line = line.chomp
	if !$unique_all_seq.include?(line)
	  $unique_all_seq << line
	end
  end

  #read user1's history and index the commands
  File.foreach "history1.txt" do |line|
	line = line.chomp
	if !$unique_all_seq.include?(line)
	  $unique_all_seq << line
	end
  end

  #read user2's history and index the commands
  File.foreach "history2.txt" do |line|
	line = line.chomp
	if !$unique_all_seq.include?(line)
	  $unique_all_seq << line
	end
  end
end

#every user's command sequences
def user_sequence
  #user0
  File.foreach "history0.txt" do |line|
	line = line.chomp
	$user0_seq << $unique_all_seq.index(line)
  end

  #user1
  File.foreach "history1.txt" do |line|
	line = line.chomp
	$user1_seq << $unique_all_seq.index(line)
  end

  #user2
  File.foreach "history2.txt" do |line|
	line = line.chomp
	$user2_seq << $unique_all_seq.index(line)
  end
end

index_all_commands
user_sequence

u0 = AnomalyHmm.new

t1 = Time.now.to_i

#user0
newfile = File.new("result0.txt", "w")

newfile.puts "train user0[500...2000], test user0[0...500] & user1 & user2"
u0.train($unique_all_seq, $user0_seq[500...2000])
for i in 0...50
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user0[0...500]+user0[1000...2000], test user0[500...1000] & user1 & user2"
u0.train($unique_all_seq, $user0_seq[0...500] + $user0_seq[1000...2000])
for i in 0...50
  u0.test($user0_seq[(500 + 10 * i)...(500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user0[0...1000]+user0[1500...2000], test user0[1000...1500] & user1 & user2"
u0.train($unique_all_seq, $user0_seq[0...1000] + $user0_seq[1500...2000])
for i in 0...50
  u0.test($user0_seq[(1000 + 10 * i)...(1000 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user0[0...1500], test user0[1500...2000] & user1 & user2"
u0.train($unique_all_seq, $user0_seq[0...1500])
for i in 0...50
  u0.test($user0_seq[(1500 + 10 * i)...(1500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.close

#user1
newfile = File.new("result1.txt", "w")
newfile.puts "train user1[500...2000], test user1[0...500] & user0 & user2"
u0.train($unique_all_seq, $user1_seq[500...2000])
for i in 0...50
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user1[0...500]+user1[1000...2000], test user1[500...1000] & user0 & user2"
u0.train($unique_all_seq, $user1_seq[0...500] + $user1_seq[1000...2000])
for i in 0...50
  u0.test($user1_seq[(500 + 10 * i)...(500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user1[0...1000]+user1[1500...2000], test user1[1000...1500] & user0 & user2"
u0.train($unique_all_seq, $user1_seq[0...1000] + $user1_seq[1500...2000])
for i in 0...50
  u0.test($user1_seq[(1000 + 10 * i)...(1000 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user1[0...1500], test user1[1500...2000] & user0 & user2"
u0.train($unique_all_seq, $user1_seq[0...1500])
for i in 0...50
  u0.test($user1_seq[(1500 + 10 * i)...(1500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.close

#user2
newfile = File.new("result2.txt", "w")

newfile.puts "train user2[500...2000], test user2[0...500] & user0 & user1"
u0.train($unique_all_seq, $user2_seq[500...2000])
for i in 0...50
  u0.test($user2_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user2[0...500]+user2[1000...2000], test user2[500...1000] & user0 & user1"
u0.train($unique_all_seq, $user2_seq[0...500] + $user2_seq[1000...2000])
for i in 0...50
  u0.test($user2_seq[(500 + 10 * i)...(500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user2[0...1000]+user2[1500...2000], test user2[1000...1500] & user0 & user1"
u0.train($unique_all_seq, $user2_seq[0...1000] + $user2_seq[1500...2000])
for i in 0...50
  u0.test($user2_seq[(1000 + 10 * i)...(1000 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.puts "train user2[0...1500], test user2[1500...2000] & user0 & user1"
u0.train($unique_all_seq, $user2_seq[0...1500])
for i in 0...50
  u0.test($user2_seq[(1500 + 10 * i)...(1500 + 10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user0_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

for i in 0...200
  u0.test($user1_seq[(10 * i)...(10 * (i + 1))])
  newfile.puts u0.printProb
end

newfile.close

t2 = Time.now.to_i
total = t2 - t1
if total == 1 || total == 0
  puts "The pragram costs "+total.to_s+" second.\n"
else
  puts "The pragram costs "+total.to_s+" seconds.\n"
end
