u0 = [[32,18],[43,7],[32,18],[41,9],[47,3],[48,2],[50,0],[49,1],[32,18],[43,7],[31,19],[41,9],[47,3],[49,1],[50,0],[48,2],[37,13],[43,7],[32,18],[41,9],[49,1],[50,0],[50,0],[49,1],[38,12],[43,7],[33,17],[41,9],[47,3],[49,1],[50,0],[48,2]]

zz0 = Array.new(8, 0.0)
zf0 = Array.new(8, 0.0)
fz0 = Array.new(8, 0.0)
ff0 = Array.new(8, 0.0)
zz1 = Array.new(8, 0.0)
zf1 = Array.new(8, 0.0)
fz1 = Array.new(8, 0.0)
ff1 = Array.new(8, 0.0)
zz2 = Array.new(8, 0.0)
zf2 = Array.new(8, 0.0)
fz2 = Array.new(8, 0.0)
ff2 = Array.new(8, 0.0)
zz3 = Array.new(8, 0.0)
zf3 = Array.new(8, 0.0)
fz3 = Array.new(8, 0.0)
ff3 = Array.new(8, 0.0)
sum0 = 0.0
sum1 = 0.0
sum2 = 0.0

for i in 0...8
  zz0[i] = 23.0
  zf0[i] = 27.0
  fz0[i] = u0[i][1]
  ff0[i] = u0[i][0]
  sum0 = sum0 + (zz0[i]+ff0[i])/100.0
  sum1 = sum1 + zf0[i]/(zf0[i]+ff0[i])
  sum2 = sum2 + fz0[i]/(fz0[i]+zz0[i])
  puts ((zz0[i]+ff0[i])/100.0).to_s+", "+(zf0[i]/(zf0[i]+ff0[i])).to_s+", "+(fz0[i]/(fz0[i]+zz0[i])).to_s
end

for i in 0...8
  zz1[i] = 21.0
  zf1[i] = 29.0
  fz1[i] = u0[i+8][1]
  ff1[i] = u0[i+8][0]
  sum0 = sum0 + (zz1[i]+ff1[i])/100.0
  sum1 = sum1 + zf1[i]/(zf1[i]+ff1[i])
  sum2 = sum2 + fz1[i]/(fz1[i]+zz1[i])
  puts ((zz1[i]+ff1[i])/100.0).to_s+", "+(zf1[i]/(zf1[i]+ff1[i])).to_s+", "+(fz1[i]/(fz1[i]+zz1[i])).to_s
end

for i in 0...8
  zz2[i] = 18.0
  zf2[i] = 32.0
  fz2[i] = u0[i+16][1]
  ff2[i] = u0[i+16][0]
  sum0 = sum0 + (zz2[i]+ff2[i])/100.0
  sum1 = sum1 + zf2[i]/(zf2[i]+ff2[i])
  sum2 = sum2 + fz2[i]/(fz2[i]+zz2[i])
  puts ((zz2[i]+ff2[i])/100.0).to_s+", "+(zf2[i]/(zf2[i]+ff2[i])).to_s+", "+(fz2[i]/(fz2[i]+zz2[i])).to_s
end

for i in 0...8
  zz3[i] = 33.0
  zf3[i] = 17.0
  fz3[i] = u0[i+24][1]
  ff3[i] = u0[i+24][0]
  sum0 = sum0 + (zz3[i]+ff3[i])/100.0
  sum1 = sum1 + zf3[i]/(zf3[i]+ff3[i])
  sum2 = sum2 + fz3[i]/(fz3[i]+zz3[i])
  puts ((zz3[i]+ff3[i])/100.0).to_s+", "+(zf3[i]/(zf3[i]+ff3[i])).to_s+", "+(fz3[i]/(fz3[i]+zz3[i])).to_s
end

puts (sum0/32).to_s
puts (sum1/32).to_s
puts (sum2/32).to_s
