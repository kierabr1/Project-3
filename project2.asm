.data
str:
 .space 64  #sets aside 64 bytes
.text

main:
li $v0, 8     #takes user input
la $a0, str  #stores string in register
li $a1, 64   
loop:

li $v0, 1
la $s0, 4   #stores integer in register
bne $a0, $s0, exit  #compares integer to string size 
 
li $v0, 10  //exit call
syscall

