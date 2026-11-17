/*
 *
 *        Date: 2024-04-23 (Tue)
 *
 *              This program is part of the CMS Make package.         *
 */

/* determine terminal linesize */
'CALLPIPE CP QUERY TERM' ,
    '| SPLIT AT /,/ | STRIP' ,
    '| LOCATE (1-8) /LINESIZE/' ,
    '| SPEC W 2 N | VAR LS'
If Datatype(ls,"W") = 0 Then ls = 255

/* establish some defaults */
n = 0
r = 0

Parse Arg args

Do While Left(Strip(args),1) = "-"

    Parse Var args opt1 args

    Select

        When opt1 = "-n" Then ,
            Parse Var args n args

        When opt1 = "-r" Then r = 1

        Otherwise Do ; 'XMITMSG 3 OPT1' ; Exit 24 ; End

    End /* Select */

End / Do While */

'PEEKTO RECORD'
If rc = 12 Then Exit 0

/* if no other output, attach console */
'STREAMSTATE OUTPUT'
If rc = 4 Then rc = 0
If rc = 8 Then rc = 0
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'
If rc /= 0 Then Exit rc

'CALLPIPE *.INPUT.0: | JOIN * / / | VAR IN'

If args = "" Then Do
    'CALLPIPE VAR IN | *.OUTPUT.0:'
    Exit rc
End /* If .. Do */

args = args in
'CALLPIPE VAR ARGS | CMS | *.OUTPUT.0:'
Exit rc


Exit rc * (rc /= 12)


/*


xargs [-I placeholder] [-i[placeholder]] [-L number] [-l number]
     [-n [number]] [-ptx] [-E [eofstr]] [-e [eofstr]] [-s size]
     [command [argument ...]]





-I placeholder
         With this option, xargs considers each full line in the standard
         input to be a single argument. placeholder is a string that can
         appear multiple times in the command template. xargs strips the input
         line of any leading white-space characters and inserts it in place of
         placeholder. For example, with:

         xargs -I {} mv dir1/{} dir2/{}

         the standard input should consist of lines giving names of files that
         you want moved from dir1 to dir2. xargs substitutes these names for
         the {} placeholder in each place that it appears in the command
         template.

         When xargs creates arguments for the template command, no single
         argument can be longer than 255 characters after the input has
         replaced the placeholders. The -x option is automatically in effect
         if -I or -i is used. See the -x explanation below in the "Other
         Options" section.

-i[placeholder]
         Behaves like -I, except that placeholder is optional. If you omit
         placeholder, it defaults to the string {}. Thus, the previous example
         could be written as either of:

         xargs -i mv dir1/{} dir2/{}
         xargs -i{} mv dir1/{} dir2/{}

-L number
         With this option, xargs reads number lines from the standard input
         and concatenates them into one long string (with a blank separating
         each of the original lines). xargs then appends this string to the
         command template and runs the resulting command. This process is
         repeated until xargs reaches the end of the standard input; if there
         are fewer than number lines left in the file the last time the
         command is run, xargs just uses what is there.

         With this option, a line must contain at least one nonblank
         character; blank lines are skipped and do not count toward the number
         of lines being added to the template. xargs considers a line to end
         at the first newline character, unless the last character of the line
         is a blank or a tab; in this case, the current line is considered to
         extend to the end of the next non-empty line.

         If you omit the -L or -l option, the default number of lines read
         from standard input is 1. The -x option is automatically in effect if
         -l is used. See the -x explanation below in the "Other Options"
         section.

-l number
         Acts like the -L option, but the number argument is optional. number
         defaults to 1.






Typically, an xargs command uses exactly one of the options just described. If
you specify more than one, xargs uses the one that appears last on the command
line. If the command has none of these options, xargs keeps reading input
until it fills up its internal buffer, concatenating arguments to the end of
the command template. When the buffer is full, xargs runs the resulting
command, and then starts constructing a new command. For example:

ls | xargs echo

prints the names of files in the working directory as one long line. When you
invoke xargs this way, the total length of all arguments must be less than the
size specified by the -s option (see "Other Options").

If no command template appears on the command line, xargs uses echo by
default. When xargs runs a command, it uses your search rules to find the
command; this means that you can run shell scripts as well as normal programs.

The command you want to execute should be in your search $PATH.

xargs ends prematurely if it cannot run a constructed command or if an
executed command returns a nonzero status.

If an executed command is a shell program, it should explicitly contain an
exit command to avoid returning a nonzero by accident; see sh for details.


You can use the following options with any of the three main options.


-s size
         Sets the maximum allowable size of an argument list to size
         characters (where size is an integer). The value of size must be less
         than or equal to the system variable LINE_MAX; if you omit the -s
         option, the default allowable size of an argument list is LINE_MAX.
         The length of the argument list is the length of the entire
         constructed command; this includes the length of the command name,
         the length of each argument, plus one blank for separating each item
         on the line.


*  LANG
*  LC_ALL
*  LC_CTYPE
*  LC_MESSAGES


 */


