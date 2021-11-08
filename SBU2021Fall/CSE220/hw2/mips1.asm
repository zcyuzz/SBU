.data
Filename: .asciiz "inputs/input6.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 63	# num rows
    .word 55	# num columns
    # matrix
    .word 55 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
    li $v0,13
    la $a0,OutFile
    li $a1,1
    li $a2,0
    syscall
    
    move $a0,$v0
    li $v0,15
    la $a1,Buffer
    li $a2,1
    syscall
    
    li $v0,15
    syscall
 	
    li $v0,16
    syscall
 #li $v0,13
 #la $a0,Filename
 #li $a1,0
 #li $a2,0
# syscall
# move $s0,$v0
 
 #li $v0,14
# move $a0,$s0
 #la $a1,Buffer
 #li $a2,15
 #syscall
 
# li $v0,4
# la $a0,Buffer
# syscall
 
# li $v0,16
# move $a0,$s0
# syscall

 # write additional test code as you deem fit.

 li $v0, 10
 syscall

.include "hw3.asm"
