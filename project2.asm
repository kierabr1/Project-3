.data
str: .space 1000  #sets aside 1000 bytes
strArray : .space 10
Isempty: .asciiz "Input is empty."
IsInvalid: .asciiz "Invalid base-30 number."
infoMessage: .asciiz "This is the length of the input."
messageTooLong: .aciiz "Your input is too long."
#delta: .byte 'T'
#beta: .byte 't'
.text

main:
li $v0, 8     #takes user input
la $a0, str  #stores string in register
li $a1, 1000 
IsEmptyMessage:
	la $a0, IsEmpty
	li $v0, 4
	syscall
j exit
	
IsInvalidMessage:    #Prints error message that there is an invalid base number
	la $a0, IsInvalid
	li $v0, 4 
loop:
li $v0, 1
la $s0, 4   #stores integer in register
bne $a0, $s0, exit  #compares integer to string size 
 
li $v0, 10  //exit call
syscall

