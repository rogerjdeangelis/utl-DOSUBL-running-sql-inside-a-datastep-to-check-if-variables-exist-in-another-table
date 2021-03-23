DOSUBL Running sql inside a datastep to check in variables exist in another table

Dosubl provides a log og missing and presnt variables;

GitHub
https://tinyurl.com/r8nhvrmy
https://github.com/rogerjdeangelis/utl-DOSUBL-running-sql-inside-a-datastep-to-check-if-variables-exist-in-another-table

Inspired by
https://stackoverflow.com/questions/66755081/sas-simple-use-of-macros-combined-with-a-query

I realize there are better ways to do this. But this is a nice example of 'DOSUBL';


Problem

   1. i Have a table students with thousands of names (all students in the school)
   2. I need to check which students are enrolled in extracurricular activities

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

* all students enrolled in high school;

  sashelp.class

* enrolled in extracurricular activities;

data havXtr;
  input name $;
cards;
John
Becca
William
;;;
run;quit;

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

%symdel sqlobs name / nowarn;

data want ;
  set havXtr;
  call symputx('name',name);
  rc=dosubl('
     proc sql;
        select
           name
        from
           sashelp.class
        where
          name = "&name"
     ;quit;
     %let nobs=&sqlobs;
  ');

   if symgetn('nobs') ne 0 then status = catx(" ",'FOUND',name,"in table have");
   else status = catx(" ",name,"NOT in table have");

run;quit;

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

 WANT total obs=3

  NAME       RC              STATUS

  John        0    FOUND John in table have
  Becca       0    Becca NOT in table have
  William     0    FOUND William in table have
