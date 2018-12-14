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
	   beq $s2, 0, resetButtonOne      #restart if nothing is found
       bne $s2, 32, CheckValidityOne    # If a space is not found, then loop


CheckValidityTwo:                  # Check to see if there is another set of characters after the space found
       lb $s2, 0($t2)                  
       addi $t2, $t2, 1         # increment pointer  
	   addi $t4, $t4, 1         # incrementing counter	
       beq $s2, 0, resetButtonOne    #Once end of the string is reached, reset pointer
       beq $s2, 10, resetButtonOne 
	   bne $s2, 32, InvalidBaseError    # once a character is found after a space is already found, then an error is called
	   j CheckValidityTwo

resetButtonOne:
       sub $t2, $t2, $t4               # restart the pointer
       la $t4, 0                       # restart the counter

GoToStart:
       lb $s2, 0($t2)                   # Loops and skips over any
       addi $t2, $t2, 1        
       beq $s2, 32, GoToStart        # this line stops looping when it detects a character


addi $t2, $t2, -1                       # aligning the pointer with the first character found in the string

LengthCount:   #Count the characters in the string
	lb $s2, ($t2)
	addi $t2, $t2, 1  #Increment counter and pointer
	addi $t4, $t4, 1  
	beq $s2, 0, ResetButtonTwo         # looking for end of the string
    beq $s2, 10, ResetButtonTwo	  #if end is found, reset the pointer again
	beq $s2, 32, ResetButtonTwo
    beq $t4, 5, MessageTooLongError     #if more than 4 characters found, Error is called    
    j LengthCount


ResetButtonTwo:                              # resets pointer to the start of string
       sub $t2, $t2, $t4
       sub $t4, $t4, $s3                # subtracts 1 from counter / length
       lb $s2, 0($t2)                   # load first byte
       sub $s4, $t4, $s3     #decremented and stored in $s4

move $s5, $t4 puts length into $s5

HighPow:          #finding the higher power
       beq $s4, 0, AlmostThere         
       mult $s3, $s1            # Multiplying power by base number
       mflo $s3           #stores value in $s3
	   sub $s4, $s4, 1       #decrements power           
       j HighPow

AlmostThere:
       jal ConvertTheString
       move $a0, $v0                   # moves sum to $a0 and prints

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

