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

add $s5, $0, 0   #initializing registers
add $t4, $0, 0	 #counter
addi $s1, $0, 0  #pointer

addi $t3, $0, 0          #Base number
addi $s7, $0, 1
addi $s2, $0, 30    
addi $t7, $0, 0
addi $t6, $0, 0
        

                                
la $t2, str              # loads input into register $t2
CheckIfEmpty:
       lb $s5, 0($t2)   # loads first element of string into register $s2
	   beq $s5, 10, IsEmptyError       # If the first element is a newline or nothing then the string is empty
       beq $s5, 0, IsEmptyError		


            
RemoveLeftSpaces:  #Remove leading spaces
	lb $s5, 0($t2)
	addi $t2, $t2, 1  #increase counter and pointer
	addi $t4, $t4, 1
	beq $s5, 32, RemoveLeftSpaces
	beq $s5, 0, IsEmptyError
	beq $s5, 10, IsEmptyError
	
CheckValidityOne:                        # This label iterates through the string until a space, new line, or nothing is detected 
       lb $s5, 0($t2)
	   addi $t2, $t2, 1			#increment counter and pointer
       addi $t4, $t4, 1
	   addi $t6, $t6, 1
       beq $s5, 10, resetButtonOne  #restart if newline is found 
	   beq $s5, 0, resetButtonOne      #restart if nothing is found
       bne $s5, 32, CheckValidityOne    # If a space is not found, then loop


CheckValidityTwo:                  # Check to see if there is another set of characters after the space found
       lb $s5, 0($t2)                  
       addi $t2, $t2, 1         # increment pointer  
	   addi $t4, $t4, 1		#increment counter
	   addi $t6, $t6, 1         
       beq $s5, 0, resetButtonOne    #Once end of the string is reached, reset pointer
       beq $s5, 10, resetButtonOne 
	   bne $s5, 32, Base_or_Len_Error    # checks for invalid or invalid base by default
	   j CheckValidityTwo

resetButtonOne:
       sub $t2, $t2, $t4               # restart the pointer
       la $t4, 0                       # restart the counter

GoToStart:
       lb $s5, 0($t2)                   # Loops and skips over any
       addi $t2, $t2, 1        
       beq $s5, 32, GoToStart        # this line stops looping when it detects a character


addi $t2, $t2, -1                       # aligning the pointer with the first character found in the string

LengthCount:   #Count the characters in the string
	lb $s5, ($t2)
	addi $t2, $t2, 1  #Increment counter and pointer
	addi $t4, $t4, 1  
	beq $s5, 0, ResetButtonTwo         # looking for end of the string
    beq $s5, 10, ResetButtonTwo	  #if end is found, reset the pointer again
	beq $s5, 32, ResetButtonTwo
    beq $t4, 5, MessageTooLongError     #if more than 4 characters found, Error is called    
    j LengthCount


ResetButtonTwo:                              # resets pointer to the start of string
       sub $t2, $t2, $t4
       sub $t4, $t4, $s7                # subtracts 1 from counter / length
       lb $s5, 0($t2)                   # load first byte
       sub $s4, $t4, $s7     #decremented and stored in $s4

move $s6, $t4 puts length into $s5

HighPow:          #finding the higher power
       beq $s4, 0, AlmostThere         
       mult $s7, $s2            # Multiplying power by base number
       mflo $s7           #stores value in $s3
	   sub $s4, $s4, 1       #decrements power           
       j HighPow

AlmostThere:
	   addi $sp, $sp, -16  #allocating memory for the stack
	   sw $s5, 0($sp)
	   sw $t2, 4($sp) 		
	   sw $s1, 8($sp)
	   sw $s6, 12($sp)
       jal ConvertTheString
       lw $a0, 0($sp)                   # loads result in $a0
	   addi $sp, $sp, 4					#deallocate memory from stack
	   li $v0, 1                       # prints result
       syscall
       li $v0, 10                       # terminate program
       syscall

.globl ConvertTheString
ConvertTheString: 
               # deallocate memory
       lw $s5, 0($sp)                   # store the return address
       lw $t2, 4($sp)                   # store the byte
	   lw $s1, 8($sp)
	   lw $s6, 12($sp)
	   addi $sp, $sp, 16

	   addi $sp, $sp, -8
	   sw $ra, 0($sp)
	   sw $s5, 4($sp)
	   beq $s1, $s6, ReturnBack	# BaseCase
	   lb $s5, 0($t2) #loads first character into $s5
	   addi $t2, $t2, 1	# increment pointer and counter
	   addi $s1, $s1, 1	
       
	   blt $s5, 48, InvalidMessage # is character is before the number 0 in ASCII chart, invalid if so
	   blt $s5, 58, numbers # is character is between 48 and 57, valid if true
	   blt $s5, 65, InvalidMessage # is character is between 58 and 64, invalid if so
	   blt $s5, 85, capitalLetters # is character is between 65 and 84, valid if so
	   blt $s5, 97, InvalidMessage # is character is between 76 and 96, invalid if so, out of bounds
	   blt $s5, 117, regLetters # is character is between 97 and 116, valid if so
	   blt $s5, 128, InvalidMessage # is character is between 118 and 127, invalid if so

	#subtract the ascii value from these values to get the actual value represented under base 30
	 capitalLetters:
		addi $s5, $s5, -55	
		j Next			# 'A' in base 30 = 10, 65 - 55 = 10
	regLetters:
		addi $s5, $s5, -87	
		j Next
	 
	 numbers:
		 addi $s5, $s5, -48 
		 j Next

	 Next:
		mul $s5, $s5, $s7	# ascii value of byte multiplied by base ^pow
		div $s7, $s7, 31	# decrement the power 
		
		addi $sp, $sp, -16	
		sw $s5, 0($sp) #character/byte
		sw $t2, 4($sp) #address
		sw $s1, 8($sp) #power/ exponent
		sw $s6, 12($sp) #length 
		jal ConvertTheString  #loop through recursion 
		
		lw $v0, 0($sp)
		addi $sp, $sp, 4 
		add $v0, $s5, $v0	# adding the values converted
	 
		lw $ra, 0($sp)	
		lw $s5, 4($sp)	
		addi $sp, $sp, 8	# deallocating memory in the stack
		
		addi $sp, $sp, -4
		sw $v0, 0($sp)
	 
		jr $ra	# jumps to the return address


		ReturnBack:  #end of recursion
			li $v0, 0	
			lw $ra, 0($sp)	#deallocating memory in the stack
			lw $s5, 4($sp)	
			addi $sp, $sp, 8    
			addi $sp, $sp, -4
			sw $v0, 0($sp)
			
			jr $ra # jumps to the return address        

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

