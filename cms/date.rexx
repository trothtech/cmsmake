/*                                                                    *
 *                                                                    *
 *        Name: DATE REXX (CMS Pipelines stage in Rexx)               *
 *        Date: 2006-12-06                                            *
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

Parse Arg args
If Left(args,1) = "+" Then fs = Substr(args,2)
                      Else fs = "%a %b %e %H:%M:%S %Z %Y"
os = ""
Do While fs ^= ""
  Select
    When Left(fs,2) = "%a" Then Do
      os = os || Left(Date('W'),3)
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%b" Then Do
      os = os || Left(Date('M'),3)
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%e" Then Do
      os = os || Substr(Date('S'),7,2)
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%H" Then Do
      Parse Value Time() With hh ":" .
      os = os || hh
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%M" Then Do
      Parse Value Time() With . ":" mm ":" .
      os = os || mm
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%S" Then Do
      Parse Value Time() With . ":" . ":" ss .
      os = os || mm
      fs = Substr(fs,3)
    End /* When .. Do */

    When Left(fs,2) = "%Z" Then Do
      Parse Value Diag(08,'Q TIME') With . . . tz .
      os = os || tz
      fs = Substr(fs,3)
    End /* When .. Do */
    When Left(fs,2) = "%Y" Then Do
      os = os || Left(Date('S'),4)
      fs = Substr(fs,3)
    End /* When .. Do */
    Otherwise Do
      os = os || Left(fs,1)
      fs = Substr(fs,2)
    End /* Otherwise Do */
  End /* Select */
End /* Do While */

'OUTPUT' os


