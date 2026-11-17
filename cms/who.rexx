/*
 *        Name: WHO REXX (CMS Pipelines "gem")
 *        Date: 2006-Dec-05 (Tuesday)
 *              2010-May-20 (Thu)                                     *
 *              This program is part of the CMS Make package.         *
 *              2024-03-26 (Tue)                                      *
 */

make_version = "2.0.43"
g.nonames = 0               /* a flag to say if NAMES file is missing */

/* if no other output then attach the console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc ^= 0 Then Exit rc

/* attach a 'cp query names' as our input */
'ADDPIPE CP QUERY NAMES EXTENDED | SPLIT AT /,/ | STRIP' ,
    '| NLOCATE 9.6 / - DSC/' ,
    '| NLOCATE 1.10 /VSM     - /' ,
    '| *.INPUT:'

/* loop through 'q names' and make it look like a 'who' report */
Do Forever
    'PEEKTO RECORD'
    If rc /= 0 Then Leave
    Parse Var record +0 user +8 "-" term . . "FROM" from
    If Length(term) < 5 Then term = Right("     "||term,5)
    from = _hostname(from)
    name = _realname(user)
    'OUTPUT' user term name from
    If rc /= 0 Then Leave
    'READTO'
    If rc /= 0 Then Leave
End /* Do Forever */
lrc = rc * (rc /= 12)

Exit lrc

/* ---------------------------------------------------------------------
 */
_hostname: Procedure
Parse Arg h . , .
If h = "" Then Return h
var = "$" || h

/* if this host is already known then return it as-is */
val = Value(var,,"SESSION NSLOOKUP")
If val = "VAL" Then val = ""
If val /= "" Then Return val

/* if the remote address is IPv6 then skip the lookup */
If POS(":",h) > 0 Then Do
    val = "[" || h || "]"
    Call Value var, val, "SESSION NSLOOKUP"
    Return val
End

/* try the lookup */
Address "COMMAND" 'PIPE VAR H | HOSTBYADDR | VAR VAL'
If rc /= 0 Then val = ""
If val = "VAL" Then val = ""

/* wrap failing address in parenthesis */
If rc /= 0 Then Do
    val = "(" || h || ")"
    Call Value var, val, "SESSION NSLOOKUP"
    Return val
End

/* if we got nuthin then return address as-is */
If val = "" Then Return h

/* otherwise set this for future reference */
Call Value var, val, "SESSION NSLOOKUP"

Return val

/* ---------------------------------------------------------------------
 *  Try to find the personal name for this user.
 */
_realname: Procedure Expose g.
Parse Arg u . , .

/* if empty argument then return a padded dash */
If u = "" Then Return "-" || Copies(" ",21)

/* if lookup previously failed then return a padded dash */
If g.nonames Then Return "-" || Copies(" ",21)

/* try to do a lookup */
Address "COMMAND" 'PIPE CMS NAMEFIND :userid' u ':name | VAR N'

/* if the lookup failed then the return value is a dash */
If rc /= 0 Then n = "-"

/* if the return code was 28 (file not found) then no further lookups */
If rc = 28 Then g.nonames = 1

/* pad the falue (dash or name) and return */
l = Length(n)
If l < 22 Then n = n || Copies(" ",22-l)
Return n


