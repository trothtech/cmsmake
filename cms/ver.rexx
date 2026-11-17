/*                                                                    *
 *                                                                    *
 *        Name: VMCP REXX (CMS Pipelines stage in Rexx)               *
 *              a better name is 'hcp' but things cannot be forced    *
 *        Date: 2016-08-16 and prior
 *              This program is part of the CMS Make package.         *
 *                                                                    *
 *                                                                    */

make_version = "2.0.43"

/* if no other output then attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

Parse Value Diag(08,'QUERY CPLEVEL') With cpver '15'x .
'OUTPUT' "CP:" cpver

'CALLPIPE COMMAND QUERY CMSLEVEL | VAR CMSVER'
'OUTPUT' "CMS:" cmsver

Parse Version rexxver
'OUTPUT' "REXX:" rexxver

Parse Value Socket("VERSION") With rc . sockver
'OUTPUT' "REXX/Sockets:" sockver

'CALLPIPE QUERY VERSION | VAR PIPEVER'
Parse Var pipever . "," pipever "(" .
'OUTPUT' "Pipelines:" pipever


