/*
 *
 *        Name: CAT REXX (CMS Pipelines)
 *        Date: 2007-Jan-28 (Sunday)
 *
 */

Parse Arg args
pi = POS("<",args) ;  If pi = 0 Then pi = Length(args)
po = POS(">",args) ;  If po = 0 Then po = Length(args)
If pi < po Then Parse Var args argl "<" argi . ">" argo .
           Else Parse Var args argl ">" argo . "<" argi .

If argo ^= "" Then Do
  Parse Var argo fn "." ft "." .
  'ADDPIPE *.OUTPUT: | >' fn ft 'A'
  If rc ^= 0 Then Exit rc
End /* If .. Do */

/* look for output */
'STREAMSTATE OUTPUT'
If rc = 12 Then 'ADDPIPE *.OUTPUT: | CONSOLE'

If argl = "" Then argl = argi
Do While argl ^= ""
  Parse Var argl arg1 argl
  Parse Var arg1 fn "." ft "." .
  'CALLPIPE <' fn ft '| *.OUTPUT:'
  If rc ^= 0 Then Exit rc
End /* Do While */


