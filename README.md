#Introduction#

Effective masquerade detection in computers is a hard question. This program tackles this problem in such ways: 

1. Profiling user behavior using Hidden Markov Model(HMM).
2. Testing the coming user data.

#Installation#

To install this program, simply run:

    $ gem build anomaly_hmm.gemspec

    $ sudo gem install anomaly_hmm

#Command Line Based#
Using command lines from *.bash_history*, without parameters and options to train a HMM for a specific user. Then, testing every 10 coming command the user issued to get the probability of this command sequence(after data processing).

To detect masquerades, just run:

    $ cd detect/

    $ ruby detect_cl.rb

##GUI Based##
Using data in */dev/input/eventX* to train a HMM for a specific user, and then testing every 50 lines in that file to get probability of it. The input devices we choose are keyboard and mouse. See file */proc/bus/input/devices* to find which events match the keyboard and mouse.

To capture the input event data, run:

    $ cd data_input/

    $ make input.c

    $ sudo ./input /dev/input/eventX /dev/input/eventX

If you want to collect the input event data and redirect it to a file, you can run:

    $ sudo ./input /dev/input/eventX /dev/input/eventX >> filename.txt

We provide three files for testing, you should make your own:

    kbd_mouse_data0.txt
    kbd_mouse_data0.txt
    kbd_mouse_data0.txt

To train HMM models for above three files, run:

    $ ruby test_input.rb

After training, we can find three files showing the results:
  
    result0.txt
    result1.txt
    result2.txt

To detect masquerades, you should first collect your input data in a file, for example, *test_events.txt*, and then run:

    $ ruby detect_gui.rb

to build up the user profile, finally test the coming input data.