/*
 *
 *        Name: ECHO REXX
 *        Date: 2024-04-23 (Tue)
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

Parse Arg args
'CALLPIPE VAR ARGS | *.OUTPUT:'

Exit rc


