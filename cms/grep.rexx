/*
 *        Name: GREP REXX (CMS Pipelines "gem")
 *        Date: 2024-05-09 (Thu)
 *              This program is part of the CMS Make package.
 */

make_version = "2.0.43"

case = 1
pref = 0

/* if no other output then attach the console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc /= 0 Then Exit rc

Parse Arg args

/* parse Unix-style options since 'grep' is originally a Unix command */
Do While Left(Strip(args),1) = "-"
    Parse Var args opt1 args
    Select
        When opt1 = "-i" Then case = 0
        Otherwise Do ; 'XMITMSG 3 OPT1' ; Exit 24 ; End
    End /* Select */
End /* Do While */

/* parse the string to search for */
delim = Left(Strip(args),1)
Parse Var args (delim) string (delim) args

/* if reading from input ... */
If args = "" Then Do
    string = "#" || string || "#"
    If case Then 'CALLPIPE *: | LOCATE' string '| *.OUTPUT:'
    Else 'CALLPIPE *: | LOCATE ANYCASE' string '| *.OUTPUT:'
End ; Else

/* step through all files indicated */
Do While args ^= ""
    Parse Var args fn args
    If Index(fn,".") > 0 Then Parse Var fn fn "." ft "." fm
                         Else Parse Var args ft fm args
    'CALLPIPE CMS LISTFILE' fn ft fm '| STEM FL.'
    Parse Var fl.1 fn ft fm .
    If fl.0 > 1 Then Do
        'CALLPIPE STEM FL. | DROP FIRST' ,
                '| SPEC W 1 NW W 2 NW W 3 NW | JOIN * / / | VAR REST'
        args = rest args ; End

    If args ^= "" Then pref = 1  /* if multiple files then tag output */
    If pref Then tag = fn || "." || ft || ":" ; Else tag = ""
    'CALLPIPE <' fn ft fm '| STEM FD.'
    Do i = 1 to fd.0
        If Index(fd.i,string) > 0 Then Do
            If pref Then out = tag || fd.i
                    Else out = fd.i
            'CALLPIPE VAR OUT | *.OUTPUT:'
            If rc ^= 0 Then Leave
        End /* If .. Do */
    End /* Do For */
End /* Do While */


