/*
 *	  Name: rxdrcbvm.c (C program source)
 *		DiagRC support for Regina REXX on Linux
 *		where the Boeblingen/Borntraeger mod is available.
 */

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include "rxdiagrc.h"

/* see IBM's "s390-tools-1.5.4" package source for these */
#define VMCP_GETCODE _IOR(0x10, 1, int)
#define VMCP_SETBUF _IOW(0x10, 2, int)
#define VMCP_GETSIZE _IOR(0x10, 3, int)

/* DIAG 08 wrapper for Boeblingen/Borntraeger module */
int drcbvm08(char*rq,char*rs,int rl,int*rc,int*cc)
  {
    static char *_eye_catcher = "drcbvm08()";
    int  fd, i;

#if RXDIAGRC_DEBUG
    (void) fprintf(stderr,"RXDRC: trying Boeblingen/Borntraeger method\n");
#endif

    /* try to open VMCP device handling DIAG 08 */

    fd=open("/dev/vmcp",O_RDWR);
    if (fd < 0) return -1;

    /* set the buffer size used by the driver */
    if (ioctl(fd,VMCP_SETBUF,&rl) == -1) *rc = -1;

    /* write the hypervisor command */
    i = write(fd,rq,strlen(rq));

    /* read the hypervisor command response or result */
    i = read(fd,rs,rl);
    /* and terminate the string */
    if (i >= 0) rs[i] = 0x00;

    /* recover the command return code */
    if (ioctl(fd,VMCP_GETCODE,rc) == -1) *rc = -1;

    /* close the file */
    (void) close(fd);

    /* set an "okay" condition code */
    *cc = 0;

    return 0;
  }



