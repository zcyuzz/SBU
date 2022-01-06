# This is a test file. Use this file to run the functions in hw3.asm
#
# Change data section as you deem fit.
# Change filepath if necessary.
.data
Filename: .asciiz "inputs/dup1p.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 0	# num rows
    .word 0	# num columns
    # matrix
    .word   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
 la $a0, Filename
 la $a1, Buffer
 jal initialize

 
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
la $a0,Buffer
 jal dplct

 # write additional test code as you deem fit.

 li $v0, 10
 syscall

.include "hw3.asm"
