################# Cao Zheng #################
################# CaoZheng#################
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
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
	li $t1,2
	bne $t1,$a0,print_args_err_msg
	lbu $t1,1($a1)
	bnez $t1,print_invalid_arg_msg #check if second character of first argument is null, which means strlength = 2 include null
	lbu $t1,0($a1)
	li $t2,68
	beq $t1,$t2,operationD_helper
	li $t2,88
	beq $t1,$t2,operationX_helper
	li $t2,70
	beq $t1,$t2,operationF_helper
	li $t2,76
	beq $t1,$t2,operationL_helper
	j print_invalid_arg_msg
	
operationF_helper:
	j operationF
	
operationF:
	j print_operationF
	
print_operationF:
	j print_invalid_arg_msg
	
	
operationL_helper:
	j operationL
	
operationL:
	j print_operationL
	
print_operationL:
	li $a0,0xFFFFFFFF
	li $v0,1
	syscall
	
	j print_invalid_arg_msg

operationX_helper:
	jal strlen_helper
	move $t2,$v0
	li $t1,3
	blt $t2,$t1,print_invalid_arg_msg
	li $t1,10
	bgt $t2,$t1,print_invalid_arg_msg
	lw $t9,arg2_addr
	lbu $t0,0($t9)
	li $t1,48
	bne $t0,$t1,print_invalid_arg_msg # 0
	lbu $t0,1($t9)
	li $t1,120
	bne $t0,$t1,print_invalid_arg_msg # x
	li $v0,0
	addi $t9,$t9,2
	j operationX

operationX:
	li $t1,10
	li $t3,0 #boolean negative
	blt $t2,$t1,X_always_pos
	beq $t2,$t1,X_eight_digits
	j print_invalid_arg_msg

X_eight_digits:
	lw $t9,arg2_addr
	lbu $t0,2($t9)
	addi $t9,$t9,3
	addi $t0,$t0,-48
	li $t1,9
	blt $t0,$t1,X_setv0_1
	li $t3,1
	j X_setv0_2
X_setv0_1:
	addi $t0,$t0,-48
	move $v0,$t0
	j X_always_pos
	
X_setv0_2:
	li $t1,10
	blt $t0,$t1,X_setv0_2_number
	j X_setv0_2_letter
	
X_setv0_2_number:
	addi $t0,$t0,-8
	move $v0,$t0
	
X_setv0_2_letter:
	addi $t0,$t0,-15
	move $v0,$t0
	
X_always_pos:
	lbu $t0,0($t9)
	addi $t9,$t9,1
	beqz $t0,X_value
	li $t1,48
	blt $t0,$t1,print_invalid_arg_msg
	li $t1,70
	bgt $t0,$t1,print_invalid_arg_msg
	li  $t1,57
	ble $t0,$t1,X_number
	li $t1,65
	bge $t0,$t1,X_letter
	j print_invalid_arg_msg

X_number:
	addi $t0,$t0,-48
	li $t1,16
	mul $v0,$v0,$t1
	add $v0,$v0,$t0
	j X_always_pos
	
X_letter:
	addi $t0,$t0,-55
	li $t1,16
	mul $v0,$v0,$t1
	add $v0,$v0,$t0
	j X_always_pos

X_value:
	li $t1,0
	beq $t3,$t1,print_operationX_pos
	j print_operationX_neg
	
print_operationX_pos:
	move $a0,$v0
	li $v0,1
	syscall
	
	j exit

print_operationX_neg:
	li $t0,-2147483648
	add $a0,$v0,$t0
	li $v0,1
	syscall
	
	j exit
	
operationD_helper:
	jal strlen_helper
	li $t1,0
	beq $v0,$t1,print_invalid_arg_msg
	lw $t9,arg2_addr
	li $v0,0
	j operationD
	
operationD:
	lbu $t0,0($t9)
	beqz $t0,print_operationD
	li $t1,48
	blt $t0,$t1,print_invalid_arg_msg
	li $t1,57
	bgt $t0,$t1,print_invalid_arg_msg
	addi $t0,$t0,-48
	li $t1,10
	mul $v0,$v0,$t1
	add $v0,$v0,$t0
	addi $t9,$t9,1
	j operationD
	
print_operationD:
	move $a0,$v0
	li $v0,1
	syscall
	
	j exit

strlen_helper:
	lw $t9,arg2_addr
	li $v0,0
	j strlen
	
strlen:
	lbu $t0,0($t9)
	beqz $t0,jump_back
	addi $v0,$v0,1
	addi $t9,$t9,1
	j strlen
	
jump_back:
	jr $ra
	
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

print_zero:
	la $a0,zero
	li $v0,4
	syscall
	
	j exit
	
print_nan:
	la $a0,nan
	li $v0,4
	syscall
	
	j exit
	
print_inf_pos:
	la $a0,inf_pos
	li $v0,4
	syscall
	
	j exit

print_inf_neg:
	la $a0,inf_neg
	li $v0,4
	syscall
	
	j exit
	
exit:
	li $v0,10
	syscall
	