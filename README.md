# tasks_scheduling

Exercise about ordering tasks(jobs) where some tasks depend on 
other tasks being completed first, also no circular
dependencies are allowed.

Solution implemented using topological sort.

To install dependencies execute: `cpanm --installdeps . `

To run exercise execute `perl -I lib j.pl` or `perl -I lib j.pl -j "a,b,c=>a"`

to run tests execute `prove -I lib t`
