/*
 *        Name: WHO REXX (CMS Pipelines "gem")                        *
 *              FINGER REXX                                           *
 *              PINKY REXX                                            *
 *        Date: 2006-Dec-05 (Tuesday)                                 *
 *              2010-May-20 (Thu)                                     *
 *              2010-Oct-23 (Sat)                                     *
 *              This program is part of the CMS Make package.         *
 */

make_version = "2.0.43"

/* if no other output then attach the console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

/* attach a 'q names' as our primary input */
'ADDPIPE CP Q NAMES EXT | SPLIT AT /,/ | STRIP' ,
  '| NLOCATE 9.6 / - DSC/' ,
  '| NLOCATE 1.10 /VSM     - /' ,
  '| *.INPUT:'

/* loop thru 'q names' getting info for 'who', 'finger', or 'pinky' */
Do Forever
  'PEEKTO RECORD'
  If rc ^= 0 Then Leave
  Parse Var record +0 user +8 "-" term . . "FROM" from
  'OUTPUT' user term Copies(" ",22) from
  If rc ^= 0 Then Leave
  'READTO'
  If rc ^= 0 Then Leave
End /* Do Forever */

Exit rc * (rc ^= 12)


/* REXX */


Select

  When Abbrev("FINGER",arg0,1) Then Do
    'OUTPUT' ,
"Login      Name                  Tty      Idle  Login Time   Where"

/*
Login      Name                  Tty      Idle  Login Time   Where
rmt        Rick Troth            pts/0     13d  Oct  9 15:06 rmt-m700
root       root                  pts/21     17  Oct 11 10:34 192.168.29.199
user/10
name/21
term/8
idle/5
when/12 - with varying content - "Sep 12 2009" or "Oct 11 10:34"
from/18
 */


  When Abbrev("PINKY",arg0,1) Then Do
    'OUTPUT' ,
"Login    Name                 TTY      Idle   When             Where"


/*

'who'

rmt      pts/17       2010-10-22 12:23 (vsitprmt.casita.net)
........ ........ /// .......... ..... (...................)

user/8
term/8 plus blanks
date/10
time/5
where (in parens)

 */






