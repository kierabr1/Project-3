.data
str:
 .space 64  #sets aside 64 bytes
.text

main:
li $v0, 8     #takes user input
la $a0, str
li $a1, 64

li $v0, 10  //exit call
syscall

