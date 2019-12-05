# Benchquark
Benchquark is a tool to analyse compiled output from projects (Targeted at POSIX system using ELF) and also analyzing D source code in a project.
Commands are used as followed ``benchquark --overallOption command --option arguments``
# Config files
    Benchquark reads from a configuration file called ``bq.json`` in the project directory.
# Overall Commands
    * ``-j|json`` Output data as json
    * ``
# Tools available

## Feature Count 
    Parses D source files and counts information from those files (from the full dmd semantic information).

## outwatch
    Runs your build, then determines the size of the compiled output 
