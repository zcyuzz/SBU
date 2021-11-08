# This is a test file. Use this file to run the functions in hw3.asm
#
# Change data section as you deem fit.
# Change filepath if necessary.
.data
Filename: .asciiz "inputs/input6.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 7	# num rows
    .word 2	# num columns
    # matrix
    .word   1 2 4 5 9 3 3 7 3 8 2 2 1 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
 la $a0, Buffer
 la $a1, OutFile

 
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
 jal rotate_clkws_270

 # write additional test code as you deem fit.

 li $v0, 10
 syscall

.include "hw3.asm"
