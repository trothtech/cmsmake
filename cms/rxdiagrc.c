/*
 *
 *	  Name: rxdiagrc.c (C program source)
 *		DiagRC() and Diag() functions for Regina
 * Enable with: Call RxFuncAdd 'DiagRC', 'rxdiagrc', 'DiagRC'
 *
 *  References:
 *		http://regina.sourceforge.net/docs/index.html
 *		http://www.borg.com/~jglatt/rexx/funcs.htm
 *		http://www.quercus-sys.com/billp/api0104.html
 *		IBM publication SC24-6113
 *
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define INCL_REXXSAA
#include <rexxsaa.h>

#include "rxdiagrc.h"

APIRET APIENTRY
Diag08(ULONG numargs, RXSTRING args[], RXSTRING *retstr)
  {
    static char *_eye_catcher = "Diag08()";
    int  rc, cc, rl, fd;
    char  *rq, *rs;

    /* DIAG(08) requires at least one more argument */
    if (numargs < 1) return RXFUNC_BADTYPE;

    /* DIAG(08) only accepts two additional arguments */
    if (numargs > 2) return RXFUNC_BADTYPE;

    rq = args->strptr;  args++;  numargs--;
    rl = 4096;  /* IBM default for "sizebuf" argument */
    if (numargs > 0) rl = strtol(args->strptr,NULL,10);
    rl = 256;  /* Regina limit on returned strings */

    /* allocate a response buffer */
    rs = malloc(rl+1);
    if (rs == NULL) return RXFUNC_NOMEM;
    rs[0] = 0x00;  rs[rl] = 0x00;

    /* hope for the best */
    rc = 0;  cc = 0;

    /* try all three known methods for handling this DIAGnose */
    if (drcnaf08(rq,rs,rl,&rc,&cc) != 0 &&
	drcbvm08(rq,rs,rl,&rc,&cc) != 0 &&
	drczvm08(rq,rs,rl,&rc,&cc) != 0)
      {
	/* if none work, free the response buffer and fail out */
	(void) free(rs);
	return RXFUNC_MODNOTFND;
      }

    /* return the results */
    (void) sprintf(retstr->strptr,"%9d %1d     %s",rc,cc,rs);
    retstr->strlength = strlen(retstr->strptr);
    (void) free(rs);
    return RXFUNC_OK;
  }



/*
        name == name by which this function was called (C string)
     numargs == number of REXX arguments supplied on the call
        args == array of arguments (of type RXSTRING)
   queuename == name of the current queue (C string)
      retstr == 256 return buffer (of type RXSTRING)
 */
APIRET APIENTRY DiagRC(CONST CHAR *name, ULONG numargs,
	RXSTRING args[], CONST UCHAR *queuename, RXSTRING *retstr)
{
    static char *_eye_catcher = "DiagRC()";
    int  diagcode;

    /* must have at least one argument, the diag code */
    if (numargs < 1) return RXFUNC_BADTYPE;

    /* take the diag code and shift remaining args */
    diagcode = strtol(args->strptr,NULL,16);
    args++;  numargs--;

    /* call a code-specific function */
    switch (diagcode)
      {
        case 0x00:  return /* Diag00(); */ RXFUNC_MODNOTFND;
        case 0x08:  return Diag08(numargs,args,retstr);
        case 0x0C:  return /* Diag0C(); */ RXFUNC_MODNOTFND;
        case 0x14:  return /* Diag14(); */ RXFUNC_MODNOTFND;
        case 0x24:  return /* Diag24(); */ RXFUNC_MODNOTFND;
        case 0x5C:  return /* Diag5C(); */ RXFUNC_MODNOTFND;
        case 0x60:  return /* Diag60(); */ RXFUNC_MODNOTFND;
        case 0x64:  return /* Diag64(); */ RXFUNC_MODNOTFND;
        case 0x8C:  return /* Diag8C(); */ RXFUNC_MODNOTFND;
        case 0xBC:  return /* DiagBC(); */ RXFUNC_MODNOTFND;
        case 0xC8:  return /* DiagC8(); */ RXFUNC_MODNOTFND;
        case 0xCC:  return /* DiagCC(); */ RXFUNC_MODNOTFND;
        case 0xF8:  return /* DiagF8(); */ RXFUNC_MODNOTFND;
        case 0x210:  return /* Diag210(); */ RXFUNC_MODNOTFND;
        case 0x218:  return /* Diag218(); */ RXFUNC_MODNOTFND;
        case 0x270:  return /* Diag270(); */ RXFUNC_MODNOTFND;
        default:  return RXFUNC_BADTYPE;
      }

    /* th, th, that's all, folks! */
}



