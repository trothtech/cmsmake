/*
 *
 *        Name: HISTORY REXX (CMS Pipelines gem)
 *        Date: 2025-07-20 (Sunday)
 *              This program is part of the CMS Make package.         *
 *
 */

make_version = "2.0.43"

/* if no other output then attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

/* retrieve command history as CP remembers it */
'ADDPIPE CP QUERY RETRIEVE BUFFERS | DROP FIRST | *.INPUT:'
If rc ^= 0 Then Exit rc

/* step through the history because we need to resequence it */
i = 0
Do Forever
    'PEEKTO RECORD' ; If rc ^= 0 Then Leave
    i = i + 1
    Parse Var record n.i c.i
    'READTO' ; If rc ^= 0 Then Leave
End /* Do Forever */

/* spit-out command history with shell ordering of commands */
Do j = 1 to i
    k = Right(j,5," ") c.j
    'CALLPIPE VAR K | *:' ; If rc ^= 0 Then Leave
End /* Do For */



