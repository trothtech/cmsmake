/*
 *
 *        Name: TTY REXX
 *        Date: 2026-11-05 (THU)
 *
 *              This program is part of the CMS Make package.
 */

make_version = "2.0.43"

/* if no other output then attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

Parse Value Diag(08,'QUERY VIRTUAL CONSOLE') With . . on . tty . '15'x .
'CALLPIPE VAR TTY | *.OUTPUT:'

Exit rc


