#Introduction#

Effective masquerade detection in computers is a hard question. This program tackles this problem in such ways: 

1. Profiling user behavior.
2. Testing the coming user data.

##Command line based##
Using command lines from .bash_history to train a HMM for a specific user. Then, testing every 10 coming command the user issued to get the probability of this command sequence(after data processing).

##GUI based##
Using data in /dev/input/eventX to train a HMM for a specific user, and then testing every 50 lines in that file to get probability of it.