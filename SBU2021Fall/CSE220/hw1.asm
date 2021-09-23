################# ENTER FULL NAME #################
################# ENTER NET ID #################
################# ENTER SBU ID #################

################# DO NOT CHANGE THE DATA SECTION #################


.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
 	li $t9,2 #check amount of arguments
 	bne $a0,$t9,print_args_err_msg 
	jal strlen
	
	move $a0,$v0
	li $v0,1
	syscall
	
	
	j exit

strlen:
	li $v0,0
	lw $t9,arg1_addr
strlen_helper:
	lbu $t0,0($t9)
	addi $t9,$t9,1
	addi $v0,$v0,1
	bne $t0,$zero,strlen_helper
	j jump_back
	
print_args_err_msg:
	la $a0,args_err_msg
	li $v0,4
	syscall	
	j exit

jump_back:
	jr $ra
	
exit:
	li $v0,10
	syscall
