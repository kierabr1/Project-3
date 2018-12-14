.data
str: .space 1000  #sets aside 1000 bytes
IsEmpty: .asciiz "Input is empty."
IsInvalid: .asciiz "Invalid base-30 number."
messageTooLong: .aciiz "Your input is too long."

.text

main:
li $v0, 8     #takes user input
la $a0, str  #stores string in register
li $a1, 1000 
syscall

add $s2, $0, 0   #initializing registers
add $t4, $0, 0	 #counter
addi $s7, $0, 0  #pointer

addi $s1, $0, 30          #Base number
addi $t5, $0, 0
addi $s3, $0, 1     
addi $t6, $0, 0
addi $t8, $0, 0
        

                                
la $t2, str              # loads input into register $t2
CheckIfEmpty:
       lb $s2, 0($t2)   # loads first element of string into register $s2
	   beq $s2, 10, IsEmptyError       # If the first element is a newline or nothing then the string is empty
       beq $s2, 0, IsEmptyError		


            
RemoveLeftSpaces:  #Remove leading spaces
	lb $s2, 0($t2)
	addi $t2, $t2, 1  #increase counter and pointer
	addi $t4, $t4, 1
	beq $s2, 32, RemoveLeftSpaces
	beq $s2, 0, IsEmptyError
	beq $s2, 10, IsEmptyError
	
CheckValidityOne:                        # This label iterates through the string until a space, new line, or nothing is detected 
       lb $s2, 0($t2)
	   addi $t2, $t2, 1			#increment counter and pointer
       addi $t4, $t4, 1
       beq $s2, 10, resetButtonOne  #restart if newline is found    
FindLength:   #Count the characters in the string
	addi $t0, $t0, 0  #Initialize count to zero
	addi $t1, $t1, 10  #adds character to t1
	add $t4, $t4, $a0 
LengthLoop:
	lb $t2, 0($a0)   #Load the character to t2
	beqz $t2, TerminateLoop   #End loop if null
	beq $t2, $t1, TerminateLoop   #End loop if end-of-line 
	addi $a0, $a0, 1   #Increment 
	addi $t0, $t0, 1
	j LengthLoop

TerminateLoop:
	beqz $t0, EmptyError   #Branch to null error if length is 0
	slti $t5, $t0, 5      #Check that count is less than 5

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
Qualifications:
	lb $t3, 0($a0)
	beqz $t3, conversionInitializations  #End loop if null character is reached
	beq $t3, $t1, conversionInitializations  #End loop if end-of-line character is detected
	slti $t6, $t3, 48    #Checks if the character is less than 0 
	bne $t6, $zero, baseError
	slti $t6, $t3, 58    #Checks if the character is less than 58 
	bne $t6, $zero, NextStep
	slti $t6, $t3, 65    #Checks if the character is less than 65
	bne $t6, $zero, baseError
	slti $t6, $t3, 84    #Checks if the character is less than 89
	bne $t6, $zero, NextStep
	slti $t6, $t3, 97    #Checks if the character is less than 97
	bne $t6, $zero, baseError
	slti $t6, $t3, 116  #Checks if the character is less than 116
	bne $t6, $zero, NextStep
	bgt $t3, 120, baseError   #Checks if the character is greater than 116

	
NextStep:
	addi $a0, $a0, 1 #moves on to the next char
	j  checkString
ConversionInitializations:
	li $s3, 3	#stores exponents in registers
	li $s2, 2
	li $s1, 1
	li $s5, 0
ZeroPower:

FirstPower:

SecondPower:

Third Power:

 
exit:
li $v0, 10  //exit call
syscall

