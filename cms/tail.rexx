/*
 *        Name: HEAD REXX (CMS Pipelines "gem")
 *              TAIL REXX
 *        Date: 2025-04-24 in response to Mike MacIsaac's HEAD and TAIL
 *
 *              This program is part of the CMS Make package.
 *
 *              Thanks to Mike MacIsaac for shining a light on this need.
 */

make_version = "2.0.43"

/* set some defaults */
Parse Arg argstring "(" opts ")" .
Parse Source . . arg0 .
n = 10
o = ""
f.0 = 0
q = "?"

/* process Unix-style options */
Do While Left(argstring,1) = "-" ,
       | Left(argstring,1) = "+"
    Parse Var argstring opt1 argstring
    Select /* opt1 */
        When Datatype(Substr(opt1,2),"W") Then o = opt1
        When opt1 = "-n" Then Parse Var argstring n argstring
        When Left(opt1,8) = "--lines=" Then ,
                              Parse Var argstring . "=" n argstring
        When opt1 = "-q" ,
           | opt1 = "--quiet" ,
           | opt1 = "--silent" Then q = 0
        When opt1 = "-v" ,
           | opt1 = "--verbose" Then q = 1
        When opt1 = "--help" Then Do
            Address "COMMAND" 'HELP CMS' arg0 ; Exit rc ; End
        When opt1 = "--version" Then Do
            Say arg0 "(CMS Make)" make_version ; Exit 0 ; End
        Otherwise Do
            Address "COMMAND" 'XMITMSG 3 OPT1' ; Exit 24 ; End
    End /* Select opt1 */
End /* Do While */

/* process remaining arguments */
Do While argstring ^= ""
    Parse Var argstring fn argstring
    If Index(fn,".") > 0 Then Parse Var fn fn "." ft "." fm "." .
                         Else Parse Var argstring ft fm argstring
    i = f.0 + 1
    f.i = fn ft fm
    f.0 = i
End /* Do While */
If q = "?" & f.0 > 1 Then q = 1
If q = "?" & f.0 < 2 Then q = 0

/* process CMS-style options */
Do While opts ^= ""
    Parse Upper Var opts opt1 opts
    Select /* opt1 */
        When opt1 = "HEAD" Then arg0 = "HEAD"
        When opt1 = "TAIL" Then arg0 = "TAIL"
        Otherwise Do
            Address "COMMAND" 'XMITMSG 3 OPT1'
            Exit 24
        End /* Otherwise Do */
    End /* Select opt1 */
End /* Do While */

/* if no other output then attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

/* git-er-dun */
If Left(n,1) = "-" Then Do
    n = Substr(n,2) ; verb = "DROP"
           End ; Else verb = "TAKE"
If arg0 = "HEAD" Then take = verb "FIRST" n
If arg0 = "TAIL" Then take = verb "LAST" n

If f.0 = 0 Then 'CALLPIPE *.INPUT: |' take '| *.OUTPUT:'
           Else Do i = 1 to f.0
               If q Then ,
               'CALLPIPE STRLITERAL /==>' f.i '<==/ | *.OUTPUT:'
                 'CALLPIPE <' f.i '|' take '| *.OUTPUT:'
               If rc ^= 0 Then Leave
           End /* Do For */

Exit rc


