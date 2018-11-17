.data
str: .space 1000  #sets aside 1000 bytes
strArray : .space 10
Isempty: .asciiz "Input is empty."
IsInvalid: .asciiz "Invalid base-30 number."
messageTooLong: .aciiz "Your input is too long."
.text

main:
li $v0, 8     #takes user input
la $a0, str  #stores string in register
li $a1, 1000 
RemoveFirstSpaces:  #Remove leading spaces
	li $t8, 32      #Save space character to t8
	lb $t9, 0($a0)
	beq $t8, $t9, removeFirstSpace #remove space if dtected
	move $t9, $a0
	j Qualifications

removeFirstSpace:   #Removes one space
	addi $a0, $a0, 1
	j removeFirstSpace
IsEmptyMessage:
	la $a0, IsEmpty
	li $v0, 4
	syscall
j exit
	
IsInvalidMessage:    #Prints error message that there is an invalid base number
	la $a0, IsInvalid
	li $v0, 4
	syscall
	j exit
	
	MessageTooLongError: #Prints error message that the user input is too long
	la $a0, MessageTooLong
	li $v0,4
	syscall
	j exit
loop:
	 
 
li $v0, 10  //exit call
syscall

