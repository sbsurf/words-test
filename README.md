README
======

This repository contains a Thor task which, given a dictionary, generates two output files, 'sequences.txt' and 'words.txt'.
* **sequences.txt** contains every sequence of four letters (A-z) that appears in exactly one word of the dictionary, one sequence per line.
* **words.txt** contains the corresponding words that contain the sequences, in the same order, again one per line.

Requirements
------------
* Ruby 2.2.0.

The Set Up
-----------

* Clone this repository:
```
git clone git@github.com:sbsurf/words-test.git
```

* *cd* into the newly-created **words-test** directory, and install the gems by running ```bundle install``` or simply ```bundle```.
You may want to create and use a new gemset before installing the gems.

* Still in the app directory, you can run
```
thor list
```
to see the list of Thor tasks. You should see the **hello_labs:parser:parse** task. This is the command you will run after completing the initial set up steps.

* Before running the task, create the dictionary **input** file, or download it from http://bit.ly/1jveLkY

Running the Task
-----------------

* The easiest way to run the task is with default options:
```
thor hello_labs:parser:parse
```
  * This assumes that:
    * The input file **input/dictionary.txt** exists and is not empty.
    * There are no **output/sequences.txt** or **output/words.txt** files yet.

* Pass in task parameters in order to specify a different input file, to change the default output directory, or to force the script to overwrite existing output files.
To see the expected parameters and their default values, run:
```
thor help hello_labs:parser:parse
```

* For more information on Thor, visit https://github.com/erikhuda/thor/wiki.

Running the Tests
------------------

* To run the test suite, simply use the Rspec command:
```
bundle exec rspec
```
or simply:
```
rspec
```
