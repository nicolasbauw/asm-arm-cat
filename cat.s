.global _start
.text

_start:
    ldr r0,[sp, #8]     @ argv[1]
    mov r1,#0           @ flags
    mov r2,#0           @ mode
    mov r7,#5           @ "open" system call
    svc #0
    cmp r0,#0           @ Error ? we exit
    blt exit

    mov r5,r0           @ we save the file descriptor in r5
    mov r1,#0           @ offset
    mov r2,#2           @ SEEK_END
    mov r7,#0x13        @ "lseek" system call
    svc #0
    cmp r0,#0           @ Error ? we close the FD and exit
    blt close_exit
    mov r6,r0           @ we save the file size in r6

    mov r0,r5           @ first argument : the file descriptor (saved in r5)
    mov r1,#0           @ offset
    mov r2,#0           @ SEEK_SET
    mov r7,#0x13        @ "lseek" system call
    svc #0
    cmp r0,#0           @ Error ? we close the FD and exit
    blt close_exit

    mov r0,#1           @ Output to stdout (file descriptor 1)
    mov r1,r5           @ Input = the FD we opened (saved in r5)
    mov r2,#0           @ offset 0 = start from beginning
    mov r3,r6           @ count = file size saved in r6 
    mov r7,#0xbb        @ "sendfile" system call
    svc #0

close_exit:
    mov r0,r5           @ file descriptor was saved in r5
    mov r7,#6           @ "close" system call
    svc #0

exit:
    mov r7, #1          @ "exit" system call
    svc #0
