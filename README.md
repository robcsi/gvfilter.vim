# GVFilter.vim
VIm plugin to filter current buffer by given arguments, like :g or :v.

## Motivation
It is really useful to monitor continuously changing log files only for lines with specific expression in them. For this, you need to filter the file when it changes or on a timer interval and to show only the lines that you need to see (or all others, for some reason).
Doing this with pure :g or :v commands is a bit troublesome especially for the beginner VImmer: composing the command for deleting some lines is done easier with some simple commands rather than having to know the full syntax. Also, creating a timer which repeats the last command and repeating it by hand is not easy.

The plugin saves you the configuration time. All you need to do is evoke one of the desired commands, enter the filter arguments and start the process.

## Purpose
The plugin filters the current buffer so that only lines matching the given arguments
remain in the file or all others, non-matching lines.

It is a simplifying wrapper for the global/v commands, adding a bit more functionality
like being able to repeat the last command executed, or starting a timer to continuously
execute the last command.

It makes it easy for the user to assemble the global/v command by defining 
commands for each and letting the user just enumerate the filter arguments. 
The executed VIm command is always deletion.

General forms of the commands the plugin executes are:

- :g/pattern/d

- :v/pattern/d

'pattern' can be a list of arguments in case more than one argument is passed
to the plugin.

    :v/arg1\|arg2\|arg3/d

In this case only lines matching arg1 or arg2 or arg3 will be shown in the buffer
and all the other lines deleted.

Get the plugin from here on Github: https://github.com/robcsi/gvfilter.vim.git

Other features include:

- The last command can be repeated by calling a command created specially for that purpose. The plugin remembers the last assembled command

- The user is also able to continously filter the current buffer, by using two commands which use VIm's timer mechanisms. The _Start and _Stop commands facilitate this. This is very useful when wanting to filter growing files, like logs.

- The assembled command can be displayed for the user to see what has been executed.
  
Check the help file for more infomation: https://github.com/robcsi/gvfilter.vim/blob/master/doc/gvfilter.txt

## Version
0.1.0

## Copyright - 2016 - 2017
Robert Sarkozi

## Acknowledgements
Timer code inspired by the https://github.com/cosminadrianpopescu/vim-tail plugin.
