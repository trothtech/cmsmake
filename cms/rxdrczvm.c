/*
 *	  Name: rxdrczvm.c (C program source)
 *		DiagRC support for Regina REXX for use on z/VM.
 *		If we had logic for performing DIAGnose calls
 *		on z/VM in C it would go here.
 */

#include <stdio.h>
#include "rxdiagrc.h"

/* DIAG 08 wrapper for z/VM */
int drczvm08(char*rq,char*rs,int rl,int*rc,int*cc)
  {
    static char *_eye_catcher = "drczvm08()";

#if RXDIAGRC_DEBUG
    (void) fprintf(stderr,"RXDRC: trying z/VM method\n");
#endif
    return -1;
  }



