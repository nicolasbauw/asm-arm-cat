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

    mov r1,r0           @ We pass the file we opened to the sendfile system call
    mov r0,#1           @ Output to stdout (file descriptor 1)
    mov r2,#0           @ offset 0 = start from beginning
    mov r3,#2048        @ count 2048 = transfer 2048 bytes between the files
    mov r7,#0xbb        @ "sendfile" system call
    svc #0

    mov r0,r1           @ file descriptor was saved in r1
    mov r7,#6           @ "close" system call
    svc #0

exit:
    mov r7, #1          @ "exit" system call
    svc #0
