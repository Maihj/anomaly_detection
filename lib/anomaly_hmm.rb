include Math

class AnomalyHmm
  
  @@N = 0
  @@MaxIters = 10000
  
  def getN
	puts "Please input N (the number of hidden states): "
	@@N = gets
	@@N = @@N.chomp.to_i
  end

  def initial(unique_seq)
	@unique_seq = unique_seq
	@@M = @unique_seq.length
	@@A = Array.new(@@N){Array.new(@@N, 0.0)}
	@@B = Array.new(@@N){Array.new(@@M, 0.0)}
	@@pi = Array.new(@@N, 0.0)
	
	#initialize A
	if @@N % 2 == 0
	  for i in 0...@@N
		k = 1
		while @@N / 2 - 1 * k >= 0 
		  @@A[i][@@N / 2 - 1 * k] = 1.0 / @@N - 0.1 * k
		  @@A[i][@@N / 2 + 1 * (k - 1)] = 1.0 / @@N + 0.1 * k
		  k = k + 1
		end
	  end
	else
	  for i in 0...@@N
		k = 1
		@@A[i][(@@N - 1) / 2 ] = 1.0 / @@N
		while (@@N - 1) / 2 - 1 * k >= 0
		  @@A[i][(@@N - 1) / 2 - 1 * k] = 1.0 / @@N - 0.1 * k
		  @@A[i][(@@N - 1) / 2 + 1 * k] = 1.0 / @@N + 0.1 * k
		  k = k + 1
		end
	  end
	end
	
	#initialze B
	if @@M % 2 == 0
	  for i in 0...@@N
		k = 1
		while @@M / 2 - 1 * k >= 0 
		  @@B[i][@@M / 2 - 1 * k] = 1.0 / @@M - 0.000001 * k
		  @@B[i][@@M / 2 + 1 * (k - 1)] = 1.0 / @@M + 0.000001 * k
		  k = k + 1
		end
	  end
	else
	  for i in 0...@@N
		k = 1
		@@B[i][(@@M - 1) / 2 ] = 1.0 / @@M
		while (@@M - 1) / 2 - 1 * k >= 0
		  @@B[i][(@@M - 1) / 2 - 1 * k] = 1.0 / @@M - 0.000001 * k
		  @@B[i][(@@M - 1) / 2 + 1 * k] = 1.0 / @@M + 0.000001 * k
		  k = k + 1
		end
	  end
	end
	
	#initialize pi	
	if @@N % 2 == 0
	  k = 1
	  while @@N / 2 - 1 * k >= 0 
		@@pi[@@N / 2 - 1 * k] = 1.0 / @@N - 0.001 * k
		@@pi[@@N / 2 + 1 * (k - 1)] = 1.0 / @@N + 0.001 * k
		k = k + 1
	  end
	else
	  k = 1
	  @@pi[(@@N - 1) / 2 ] = 1.0 / @@N
	  while (@@N - 1) / 2 - 1 * k >= 0
		@@pi[(@@N - 1) / 2 - 1 * k] = 1.0 / @@N - 0.001 * k
		@@pi[(@@N - 1) / 2 + 1 * k] = 1.0 / @@N + 0.001 * k
		k = k + 1
	  end
	end
  end
  
  def forward(observation_seq)
	@observation_seq = observation_seq
	@@T = @observation_seq.length
	@@alpha = Array.new(@@T){Array.new(@@N, 0.0)}
	@@c = Array.new(@@T, 0.0)

	#compute alpha[0][i]
	for i in 0...@@N
	  @@alpha[0][i] = @@pi[i] * @@B[i][@observation_seq[0]]  
	  @@c[0] = @@c[0] + @@alpha[0][i]
	end
	
	#scale the alpha[0][i]
	@@c[0] = 1.0 / @@c[0]
	for i in 0...@@N
	  @@alpha[0][i] = @@c[0] * @@alpha[0][i]
	end
	
	#compute alpha[t][i] iteratively
	for t in 1...@@T
	  @@c[t] = 0.0
	  for i in 0...@@N
		@@alpha[t][i] = 0.0
		for j in 0...@@N
		  @@alpha[t][i] = @@alpha[t][i] + @@alpha[t-1][j] * @@A[j][i]
		end
		@@alpha[t][i] = @@alpha[t][i] * @@B[i][@observation_seq[t]]
		@@c[t] = @@c[t] + @@alpha[t][i]
	  end

	  #scale alpha[t][i]
	  @@c[t] = 1.0 / @@c[t]
	  for i in 0...@@N
		@@alpha[t][i] = @@c[t] * @@alpha[t][i]
	  end
	end
  end
  
  def backward(observation_seq)
	@observation_seq = observation_seq
	@@beta = Array.new(@@T){Array.new(@@N, 0.0)}
	
	#let beta[T-1][i] = 1 scaled by c[T-1]
	for i in 0...@@N
	  @@beta[@@T-1][i] = @@c[@@T-1]
	end
	
	#compute beta[t][i] iteratively
	(@@T-2).downto(0) do |t|
	  for i in 0...@@N
		@@beta[t][i] = 0.0
		for j in 0...@@N
		  @@beta[t][i] = @@beta[t][i] + @@A[i][j] * @@B[j][@observation_seq[t+1]] * @@beta[t+1][j]
		end
		
		#scale beta[t][i] with same scale factor as alpha[t][i]
		@@beta[t][i] = @@c[t] * @@beta[t][i]
	  end
	end
  end

  def gamma(observation_seq)
	@observation_seq = observation_seq
	@@gamma = Array.new(@@T){Array.new(@@N, 0.0)}
	@@gama = Array.new(@@T){Array.new(@@N){Array.new(@@N, 0.0)}}
	
	#compute gamma[t][i]
	for t in 0...(@@T-1)
	  temp = 0.0
	  for i in 0...@@N
		for j in 0...@@N
		  temp = temp + @@alpha[t][i] * @@A[i][j] * @@B[j][@observation_seq[t+1]] * @@beta[t+1][j]
		end
	  end
	  for i in 0...@@N
		@@gamma[t][i] = 0.0
		for j in 0...@@N
		  @@gama[t][i][j] = (@@alpha[t][i] * @@A[i][j] * @@B[j][@observation_seq[t+1]] * @@beta[t+1][j]) / temp
		  @@gamma[t][i] = @@gamma[t][i] + @@gama[t][i][j]
		end
	  end
	end
  end

  def logProb
	#compute log[P(O|lambda)]
	@@logProb = 0.0
	for i in 0...@@T
	  @@logProb = @@logProb + log(@@c[i])
	end
	@@logProb = -@@logProb
  end
  
  def train(unique_seq, observation_seq)	
	@unique_seq = unique_seq
	@observation_seq = observation_seq
	iter = 0
	oldLogProb = -1.0 / 0
	getN
	initial(@unique_seq)
	forward(@observation_seq)
	backward(@observation_seq)
	logProb
	gamma(@observation_seq)

	#iterate or not?
	while iter < @@MaxIters && @@logProb > oldLogProb
	  iter = iter + 1
	  oldLogProb = @@logProb
	  puts @@logProb
	  
	  #re-estimate pi
	  for i in 0...@@N
		@@pi[i] = @@gamma[0][i]
	  end
	  
	  #re-estimate A
	  for i in 0...@@N
		for j in 0...@@N
		  temp1 = 0.0
		  temp2 = 0.0
		  for t in 0...(@@T-1)
			temp1 = temp1 + @@gama[t][i][j]
			temp2 = temp2 + @@gamma[t][i]
		  end
		  @@A[i][j] = temp1 / temp2
		end
	  end
	  
	  #re-estimate B
	  for i in 0...@@N
		for j in 0...@@M
		  temp1 = 0.0
		  temp2 = 0.0
		  for t in 0...(@@T-1)
			if @observation_seq[t] == j
			  temp1 = temp1 + @@gamma[t][i]
			end
			temp2 = temp2 + @@gamma[t][i]
		  end
		  @@B[i][j] = temp1 / temp2
		end
	  end

	  forward(@observation_seq)
	  backward(@observation_seq)
	  logProb
	  gamma(@observation_seq)
	end
  end

  def test(observation_seq)
	@observation_seq = observation_seq
	t1 = @observation_seq.length
	alpha = Array.new(t1){Array.new(@@N, 0.0)}

	#compute alpha[0][i]
	for i in 0...@@N
	  alpha[0][i] = @@pi[i] * @@B[i][@observation_seq[0]]  
	end
	
	#compute alpha[t][i] iteratively
	for t in 1...t1
	  for i in 0...@@N
		alpha[t][i] = 0.0
		for j in 0...@@N
		  alpha[t][i] = alpha[t][i] + alpha[t-1][j] * @@A[j][i]
		end
		alpha[t][i] = alpha[t][i] * @@B[i][@observation_seq[t]]
	  end
	end
	
	#compute probability
	@@prob = 0.0
	for i in 0...@@N
	  @@prob = @@prob + alpha[t1-1][i]
	end
  end

  def printA
	@@A	
  end

  def printB
	@@B	
  end

  def printPi
	@@pi	
  end
  
  def printProb
	@@prob
  end
end
