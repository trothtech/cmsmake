/*
 *
 *	  Name: rxdrcnaf.c (C program source)
 *		Functions for CPINT/HCP for RXDIAGRC package.
 *
 *  References:
 *		(Neale's code ... URL here)
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <linux/ioctl.h>
#include "rxdiagrc.h"

/* use 'k' as magic number - had to steal this from Neale's source */
#define  CPCMD_IOC_MAGIC  'k'
#define  CPCMD_IOCRESET   _IO(CPCMD_IOC_MAGIC,0)
#define  CPIOCRC          _IOR(CPCMD_IOC_MAGIC,1,int)

/* DIAG 00 wrapper for Ferguson module */
int drcnaf00(char*rq,char*rs,int rl,int*rc,int*cc) { return -1; }

/* DIAG 08 wrapper for Ferguson module */
int drcnaf08(char*rq,char*rs,int rl,int*rc,int*cc)
  {
    static char *_eye_catcher = "drcnaf08()";
    int  fd, i;

#if RXDIAGRC_DEBUG
    (void) fprintf(stderr,"RXDRC: trying Ferguson method %d\n",rl);
#endif

    /* try to open CPINT device handling DIAG 08 */
    fd=open("/dev/cpint8",O_RDWR);
    if (fd < 0)
    fd=open("/dev/cpcmd",O_RDWR);
    if (fd < 0) return -1;

    /* write the hypervisor command */
    i = write(fd,rq,strlen(rq));

    /* read the hypervisor command response or result */
    i = read(fd,rs,rl);
    /* and terminate the string */
    if (i >= 0) rs[i] = 0x00;

    /* recover the command return code */
    (void) ioctl(fd,CPIOCRC,rc);

    /* close the file */
    (void) close(fd);

    /* set an "okay" condition code */
    *cc = 0;

    return 0;
  }


/* DIAG 76 wrapper for Ferguson module */
int drcnaf76(char*rq,char*rs,int rl,int*rc,int*cc) { return -1; }

/* DIAG 220 wrapper for Ferguson module */
int drcnaf220(char*rq,char*rs,int rl,int*rc,int*cc) { return -1; }





