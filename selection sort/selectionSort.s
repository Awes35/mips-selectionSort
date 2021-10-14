	# Program to sort an array of values in ascending order, using Selection Sort.
	# Uses functions "findSmallest" and "swap" repeatedly as needed,
	# uses function printList at the beginning and end of program to display list values.
	# array "values" and length of array "valueCount" are given.
	# 3 display strings are also added for the printList function.
	

	# Written by Kollen G


        .data
        .align  2
displayPre:	.asciiz	"\nBeginning list: "
displayPost:	.asciiz	"\nSorted list: "
comma:	.asciiz	", "
valueCount:	.word   10
values:	.word   42, 66, 613, -29, 57, 212, 87, 2, -86, 9

#--------------------------------
        .text
       	.globl	main
       	
main:
	la	$s3, values	# s3 : address of array
        lw	$s0, valueCount	# s0 : cnt
        move	$s1, $0		# s1 : outer index "i"
        move	$s2, $0		# s2 : index of min value
        
        # setup printList func call
        move	$a1, $s0
	move	$a2, $s3
	la 	$a0, displayPre	#load display string
	li 	$v0, 4		#code to print string
	syscall	
	jal printList

loopO:	bge	$s1, $s0, brk	# while (i < cnt) "outer loop"
	move	$s2, $s1	# s2: index of min value = s1: outer index "i"
	
	#setup findSmallest func call
	move	$a0, $s1
	move	$a1, $s0
	move	$a2, $s3
	move	$a3, $s2
	jal findSmallest
	move	$s2, $v0
	
	beq	$s1, $s2, cont	# if (i != index of min)
	# setup swap func call
	move	$a0, $s1
	move	$a1, $s2
	move	$a2, $s3
	jal swap

cont:	addi	$s1,$s1,1	# increment i++
	j loopO
	
brk:	# setup printList func call
	move	$a1, $s0
	move	$a2, $s3
	la 	$a0, displayPost#load display string
	li 	$v0, 4		#code to print string
	syscall	
	jal printList
	j exit

#----------------- Exit ---------------------
exit:	li	$v0, 10
	syscall
	
	
#******************************************************************
	# printList function
	#
	# a0 - outer index "i"
	# a1 - cnt
	# a2 - address of array
	# 
printList:
#--------------- Usual stuff at function beginning  ---------------
        addi    $sp, $sp, -24	# allocate stack space for 6 values
        sw	$ra, 20($sp)	# store off the return addr, etc 
        sw	$s0, 16($sp)
        sw	$s1, 12($sp)
        sw	$s2, 8($sp)
        sw	$s3, 4($sp)
        sw	$s4, 0($sp)
#-------------------------- function body -------------------------	
	move	$s0, $0		# s0 : n
	move	$s1, $a1	# s1 : cnt
	move	$s3, $a2	# s3 : address of array
	
loopF:	bge	$s0, $s1, d	# while (n < cnt)

	sll     $s4, $s0, 2	# s4: offset 4 for array[n] (4*n)
        add     $s4, $s4, $s3	# s4: addr of array[n]
        lw      $t1, 0($s4)	# t1 <-- array[n] value
	
	li 	$v0, 1		#code to print int
	move	$a0, $t1	#load array[n] value
	syscall			#print
	la 	$a0, comma	#load display string
	li 	$v0, 4		#code to print string
	syscall	
	
	addi	$s0,$s0,1	#increment n++
	j loopF
	
d:	move	$v0, $s0	
#-------------------- Usual stuff at function end -----------------
        lw  	$ra, 20($sp)	# restore the return address and
        lw	$s0, 16($sp)	# other used registers...
        lw	$s1, 12($sp)
        lw	$s2, 8($sp)
        lw	$s3, 4($sp)
        lw	$s4, 0($sp)        
        addi	$sp, $sp, 24
        jr      $ra
	
	
#******************************************************************
	# findSmallest function
	#
	# a0 - outer index "i"
	# a1 - cnt
    	# a2 - address of array
    	# a3 - index of min
    	#
    	# v0 - index of min value	
findSmallest:
#--------------- Usual stuff at function beginning  ---------------
        addi    $sp, $sp, -24	# allocate stack space for 6 values
        sw	$ra, 20($sp)	# store off the return addr, etc 
        sw	$s0, 16($sp)
        sw	$s1, 12($sp)
        sw	$s2, 8($sp)
        sw	$s3, 4($sp)
        sw	$s4, 0($sp)
#-------------------------- function body -------------------------
	move	$s0, $a0	# s0 : outer index "i"
	addi	$s1, $s0, 1	# s1 : inner index "j" = i + 1
	move	$s2, $a1	# s2 : cnt
	move	$s3, $a2	# s3 : address of array
	move	$s4, $a3	# s4 : min index
	
loopI:	bge	$s1, $s2, brk2	# while (j < cnt) "inner loop"
	
	sll     $s5, $s1, 2     # s5: offset 4 for array[j]
        add     $s5, $s5, $s3   # s5: address of array[j]
	lw	$t1, 0($s5)	# t1 : value array[j]
	
	sll	$s6, $s4, 2	# s6 : offset 4 for array[min]
	add	$s6, $s6, $s3	# s6 : address of array[min]
	lw	$t2, 0($s6)	# t2 : value array[min]
	
	bge	$t1, $t2, cont2	# if (array[j] < array[min]) 
	move	$s4, $s1	# s4 : min index = j
cont2:	addi	$s1, $s1, 1	# increment j++
	j loopI
	
brk2:	move	$v0, $s4

#-------------------- Usual stuff at function end -----------------
        lw  	$ra, 20($sp)	# restore the return address and
        lw	$s0, 16($sp)	# other used registers...
        lw	$s1, 12($sp)
        lw	$s2, 8($sp)
        lw	$s3, 4($sp)
        lw	$s4, 0($sp)        
        addi	$sp, $sp, 24
        jr      $ra


#******************************************************************
	# swap function
	#
	# a0 - outer index "i"
	# a1 - index of min value
    	# a2 - address of array
    	#
swap:
#--------------- Usual stuff at function beginning  ---------------
        addi    $sp, $sp, -24	# allocate stack space for 6 values
        sw	$ra, 20($sp)	# store off the return addr, etc 
        sw	$s0, 16($sp)		
        sw	$s1, 12($sp)
        sw	$s2, 8($sp)
        sw	$s3, 4($sp)
        sw	$s4, 0($sp)
#-------------------------- function body -------------------------
    	sll     $s0, $a0, 2     # s0 : offset for array[i] of 4
        add     $s0, $s0, $a2   # s0 : address of array[i]
        lw      $s1, 0($s0)     # s1 : value array[i]

        sll     $s2, $a1, 2     # s2 : offset for array[min] of 4
        add     $s2, $s2, $a2   # s2 : address of array[min]
        lw      $s3, 0($s2)     # s3 : value array[min]

        sw      $s1, 0($s2)     # array[min] = array[i]
        sw      $s3, 0($s0)     # array[i] = array[min]
        
        
#-------------------- Usual stuff at function end -----------------
        lw  	$ra, 20($sp)	# restore the return address and
        lw	$s0, 16($sp)	# other used registers...
        lw	$s1, 12($sp)
        lw	$s2, 8($sp)
        lw	$s3, 4($sp)
        lw	$s4, 0($sp)        
        addi	$sp, $sp, 24
        jr      $ra

