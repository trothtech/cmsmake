/*
 *
 *        Name: HOST REXX
 *        Date: 2017-01-12
 *
 *              This program is part of the CMS Make package.
 */

make_version = "2.0.43"

/* if no other output then attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | UNIQ | CONSOLE'
If rc ^= 0 Then Exit rc

Parse Arg host . "(" . ")" .

tcpipid = "TCPIP"
tcpipid = "TCPDMZ1"
subtaskid = "#RESOLVE"
Parse Value Socket("INITIALIZE",subtaskid,,tcpipid) With rc rs
If rc ^= 0 Then Do
  If rs ^= "" Then Say rs
  Exit rc
End

ipv4.0 = 0
ipv6.0 = 0

Parse Value Socket("RESOLVE",host) With rc rs
If rc ^= 0 Then Do
  If rs ^= "" Then Say rs
  Call Socket "TERMINATE", subtaskid
  Exit rc
End

Parse Var rs addr fqdn .
fqdn = Translate(fqdn,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
ipv4.1 = addr ; ipv4.0 = 1

Do i = 1 to ipv4.0
/* Say      fqdn "has address" ipv4.i                                 */
  'OUTPUT' fqdn "has address" ipv4.i
End
Do i = 1 to ipv6.0
/* Say      fqdn "has IPv6 address" ipv6.i                            */
  'OUTPUT' fqdn "has IPv6 address" ipv6.i
End

Call Socket "TERMINATE", subtaskid

Exit 0


