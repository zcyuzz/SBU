################# Cao Zheng#################
################# CaoZheng #################
################# 111506312 #################

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
	lw $t0, 0($a1)
	sw $t0, arg1_addr
	lw $s1, arg1_addr
	lw $t1, 4($a1)
	sw $t1, arg2_addr
	lw $s2, arg2_addr
   	j start_coding_here

start_coding_here:
	lw $t0, 0($a1)
	sw $t0, arg1_addr
	lw $s1, arg1_addr
	lw $t1, 4($a1)
	sw $t1, arg2_addr
	lw $s2, arg2_addr
 	li $t9,2 #check amount of arguments
 	bne $a0,$t9,print_args_err_msg 
	jal strlen#check strlen is not more than 2 characters long
	li $t0,1
	bgt $v0,$t0,print_invalid_arg_msg
	lbu $t0,0($s1)
	li $t1,	68
	beq $t0,$t1, operationO_helper
	
	j print_invalid_arg_msg

operationO_helper:
	lw $t9,arg2_addr
	li $v0,0
	j operationO
	
operationO:
	lbu $t0,0($t9)
	beq $t0,$zero,print_operationO
	li $t1,48
	blt $t0,$t1,print_invalid_arg_msg
	li $t1,57
	bgt $t0,$t1,print_invalid_arg_msg
	addi $t0,$t0,-48
	li $t1,10
	mul $v0,$v0,$t1
	add $v0,$v0,$t0
	addi $t9,$t9,1
	j operationO

print_operationO:
	move $a0,$v0
	li $v0,1
	syscall
	
	j exit

strlen:
	li $v0,-1
	lw $t9,arg1_addr
	j strlen_helper
	
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
	
print_invalid_arg_msg:
	la $a0, invalid_arg_msg
	li $v0,4
	syscall
	j exit 
print:
	la $a0,zero
	li $v0,4
	syscall
	j exit
	
jump_back:
	jr $ra
	
exit:
	li $v0,10
	syscall
