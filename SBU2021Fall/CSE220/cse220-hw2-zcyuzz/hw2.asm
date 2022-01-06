################# Cao Zheng #################
################# CaoZheng #################
################# 111506312#################

################# DO NOT CHANGE THE DATA SECTION #################

.text
.globl to_upper
to_upper:
	lb $t1,0($a0)
	beq $t1,$0,jump_back
	li $t0,96
	bgt $t1,$t0,upper
	addi $a0,$a0,1
	j to_upper
	 
upper:
	addi $t1,$t1,-32
	sb $t1,0($a0)
	addi $a0,$a0,1
	j to_upper	 

.globl remove
remove:
	add $a0,$a0,$a1
	li $v0,1
	lb $t1,0($a0)
	beq $t1,$0,remove_failed
	j remove_loop
		
remove_failed:
	li $v0,-1
	jr $ra
	
remove_loop:
	lb $t1,0($a0)
	lb $t2,1($a0)
	move $t1,$t2
	sb $t1,0($a0)
	beqz $t2,jump_back
	addi $a0,$a0,1
	j remove_loop
	
.globl getRandomInt
getRandomInt:
	blez $a0,negativeN
	li $v0,42
	move $a1,$a0
	syscall
	
	move $v0,$a0
	li $v1,1
 	jr $ra

negativeN:
	li $v0,-1
	li $v1,0
	jr $ra
	
.globl cpyElems
cpyElems:
	add $a0,$a0,$a1
	lb $t1,0($a0)
	sb $t1,0($a2)
	move $a0,$t1
	addi $a2,$a2,1
	move $v0,$a2
 	jr $ra

.globl genKey
genKey:
 	lb $t1,0($a0)
 	beqz $t1,jump_back
 	li $t0,78
 	blt $t1,$t0,genKey_lessthan78
 	addi $t1,$t1,-13
 	sb $t1,0($a1)
 	addi $a0,$a0,1
 	addi $a1,$a1,1
 	j genKey
 	
genKey_lessthan78:
	addi $t1,$t1,13
	sb $t1,0($a1)
 	addi $a0,$a0,1
 	addi $a1,$a1,1
 	j genKey

.globl contains
contains:
	li $t2,0
	li $v0,0
	j contains_loop
	
contains_loop:
 	lb $t1,0($a0)
 	beq $t1,$s0,contains_failed
	beq $t1,$a1,jump_back
 	addi $a0,$a0,1
 	addi $v0,$v0,1
 	j contains_loop
 
contains_failed:
	li $v0,-1
	jr $ra 	
 
.globl pair_exists
pair_exists:
	move $t1,$a0
	move $t2,$a1
	beq $t1,$t2,pair_exists_failed
	li $v0,1
	
pair_exists_loop:
	lb $t3,0($a2)
	li $t0,65
	blt $t3,$t0,pair_exists_failed
	li $t0,90
	bgt $t3,$t0,pair_exists_failed
	beqz $t3,pair_exists_failed
	beq $t3,$t1,pair_exists_c1c2
	beq $t3,$t2,pair_exists_c2c1
	addi $a2,$a2,1
	j pair_exists_loop
	
pair_exists_c1c2:
	lb $t4,1($a2)
	beqz $t4,pair_exists_failed
	beq $t4,$t2,jump_back
	addi $a2,$a2,1
	j pair_exists_loop

pair_exists_c2c1:
	lb $t4,1($a2)
	beqz $t4,pair_exists_failed
	beq $t4,$t1,jump_back
	addi $a2,$a2,1
	j pair_exists_loop
	
pair_exists_failed:
	li $v0,0
	jr $ra
 
.globl encrypt
encrypt:
	li $t9,0
	j encrypt_to_upper

encrypt_success:
	li $v0,1
	sub $a0,$a0,$t9
	li $v0,4
	syscall
	j encrypt_key
	
encrypt_key:
	lb $t1,0($a0)
	addi $a0,$a0,1
	beqz $t1,print
	li $t0,32
	beq $t0,$t1,encrypt_key_space
	li $t8,0
	j encrypt_key_index
	jr $ra

encrypt_key_space:
	sb $t1,0($a2)
	addi $a2,$a2,1
	j encrypt_key

print:
	sub $a2,$a2,$t9
	li $v0,1
	jr $ra

encrypt_key_index:
	lb $t2,0($a1)
	beq $t2,$t1,encrypt_odd
	addi $a1,$a1,1
	addi $t8,$t8,1
	j encrypt_key_index

encrypt_odd:
	andi $t4,$t8,1
	beqz $t4,encrypt_even
	addi $a1,$a1,-1
	lb $t1,0($a1)
	sb $t1,0($a2)
	addi $a2,$a2,1
	addi $a1,$a1,1
	sub $a1,$a1,$t8
	li $t8,0
	j encrypt_key
	
encrypt_even:
	addi $a1,$a1,1
	lb $t1,0($a1)
	sb $t1,0($a2)
	addi $a2,$a2,1
	addi $a1,$a1,-1
	sub $a1,$a1,$t8
	li $t8,0
	j encrypt_key

encrypt_isLetter_helper:
	sub $a0,$a0,$t9
	j encrypt_isLetter
	
encrypt_isLetter:
	lb $t1,0($a0)
	beqz $t1,encrypt_success
	li $t0,90
	bgt $t1,$t0,encrypt_isSpace
	li $t0,65
	blt $t1,$t0,encrypt_isSpace
	addi $a0,$a0,1
	j encrypt_isLetter
	
encrypt_isSpace:
	li $t0,32	
	addi $a0,$a0,1
	beq $t1,$t0,encrypt_isLetter
	j encrypt_failed
	
encrypt_failed:
	li $v0,0
	jr $ra 
	
encrypt_to_upper:
	lb $t1,0($a0)
	beq $t1,$0,encrypt_isLetter_helper
	li $t0,96
	bgt $t1,$t0,encrypt_upper
	addi $a0,$a0,1
	addi $t9,$t9,1
	j encrypt_to_upper	 
	
encrypt_upper:
	addi $t1,$t1,-32
	sb $t1,0($a0)
	addi $a0,$a0,1
	addi $t9,$t9,1
	j encrypt_to_upper
 	
.globl decipher_key_with_chosen_plaintext
decipher_key_with_chosen_plaintext:
	move $t5,$a2
	j decipher_helper
 decipher_helper:
 	li $t9,0
 	lb $t1,0($a0)
 	lb $t2,0($a1)
 	addi $a0,$a0,1
 	addi $a1,$a1,1
 	li $t0,32
 	beq $t1,$t0,decipher_helper
 	beqz $t1,addNull
 	move $t6,$t5
 	j not_contains
 	
 not_contains:
 	lb $t3,0($t6)
 	beq $t3,$0,append
 	addi $t6,$t6,1	
 	beq $t3,$t1,decipher_helper
 	j not_contains
 	
 append:
 	sb $t1,0($a2)
 	sb $t2,1($a2)
 	addi $a2,$a2,2
 	j decipher_helper
 
 addNull:
	sb $0,0($a2)
	jr $ra 	
	
 jump_back:
 	jr $ra
