# GVFilter.vim
VIm plugin to filter current buffer by given arguments, like :g or :v.

## Purpose
The plugin filters the current buffer so that only lines matching the given arguments
remain in the file or all others, non-matching lines.

It is a wrapper for the global/v commands, adding a bit more functionality
like being able to repeat the last command executed, or starting a timer to continuously
execute the last command.

It makes it easy for the user to assemble the global/v command by defining 
commands for each and letting the user just enumerate the filter arguments. 
The executed VIm command is deletion.

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
