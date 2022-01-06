######### Cao Zheng ##########
######### 111506312 ##########
######### CAOZHENG ##########

.text
.globl initialize
initialize:
    li $v0,13
    move $t9,$a1
    li $a1,0
    li $a2,0
    syscall
    
    move $t8,$v0
    li $t1,0
    move $t5,$sp
    j ini_helper1
    
    jr $ra

ini_helper1:
    move $a0,$t8
    li $v0,14
    move $a1,$t9
    li $a2,1
    syscall
    
    beqz $v0,ini_helper2
    move $t8,$a0
    lw $t7,0($a1)
    li $t0,10
    beq $t7,$t0,ini_helper1
    li $t0,13
    beq $t7,$t0,ini_helper1
    li $t0,48
    blt $t7,$t0,bad_input
    li $t0,57
    bgt $t7,$t0,bad_input
    addi $sp,$sp,-4
    addi $t1,$t1,-4
    sw $t7,0($sp)
    
    move $a0,$t7
    
    j ini_helper1	
    
bad_input:
    move $a0,$t8
    li $v0,16
    syscall
    li $t0,0
    sw $t0,0($t9)
    move $sp,$t5
    li $v0,-1
    jr $ra
        
ini_helper2:
    sub $sp,$sp,$t1
    addi $sp,$sp,-4
    lw $t7,0($sp)
    li $t0,48
    beq $t0,$t7,bad_input
    addi $sp,$sp,-4
    lw $t7,0($sp)
    li $t0,48
    addi $sp,$sp,8
    add $sp,$sp,$t1
    beq $t0,$t7,bad_input
    sub $t9,$t9,$t1
    addi $t9,$t9,-4
    
copy_to_buffer:
    beqz $t1,return
    addi $t1,$t1,4
    lw $t7,0($sp)
    addi $t7,$t7,-48
    sw $t7,0($t9)
    addi $t9,$t9,-4
    addi $sp,$sp,4

    move $a0,$t7

    j copy_to_buffer
      
.globl write_file
write_file:
    li $v0,13
    move $t9,$a1
    li $a1,1
    li $a2,0
    syscall
    
    move $t8,$v0
    li $t0,0
    move $t7,$t9
    move $t5,$sp
    lw $t1,0($t7)
    lw $t2,4($t7)
    mul $t6,$t1,$t2
    li $t1,4
    mul $t6,$t6,$t1
    addi $t6,$t6,8
    j write_helper
    jr $ra

write_helper: #copy to stack
    lw $t1,0($t7)
    beq $t0,$t6,write_helper1
    addi $t7,$t7,4
    addi $sp,$sp,-4
    addi $t0,$t0,4
    addi $t1,$t1,48
    sw $t1,0($sp)
    j write_helper
   
write_helper1:
    add $sp,$sp,$t0
    addi $sp,$sp,-4
    move $a0,$t8
    li $v0,15
    li $a2,1
    move $a1,$t9
    lw $t2,0($sp)
    sw $t2,0($t9)
    syscall
    li $v0,15
    li $t1,10
    sw $t1,0($t9)
    syscall
    li $v0,15
    addi $sp,$sp,-4
    lw $t3,0($sp) 
    sw $t3,0($t9)
    syscall
    li $v0,15
    li $t1,10
    sw $t1,0($t9)
    syscall
    move $t7,$t3
    addi $t7,$t7,-48
    j write_helper2
write_helper2:
    li $v0,15
    addi $sp,$sp,-4
    lw $t1,0($sp)
    beqz $t1,write_return
    sw $t1,0($t9)
    syscall
    addi $t7,$t7,-1
    beqz $t7,write_newline
    j write_helper2
 write_newline:
    li $v0,15
    li $t1,10
    sw $t1,0($t9)
    move $t7,$t3
    addi $t7,$t7,-48
    syscall
    j write_helper2
 write_return:
    sw $t2,0($t9)
    li $v0,16
    move $a0,$t8
    move $sp,$t5
    syscall
    jr $ra   
    
   
.globl rotate_clkws_90
rotate_clkws_90:
    move $t5,$sp
    move $t8,$a0
    move $t9,$a1
    lw $t1,0($a0)
    lw $t2,4($a0)
    sw $t2,0($a0) 
    sw $t1,4($a0) 
    addi $a0,$a0,8
    mul $t3,$t1,$t2
    move $t4,$t3
    j r90_helper
    jr $ra

r90_helper:
	beqz $t3,r90_helper2
	addi $t3,$t3,-1
	lw $t1,0($a0)
	addi $a0,$a0,4
	addi $sp,$sp,-4
	sw $t1,0($sp)
	j r90_helper

r90_helper2:
	move $sp,$t5
	addi $sp,$sp,-4
	move $a0,$t8
	lw $t1,0($a0)
	lw $t2,4($a0)
	lw $t7,0($a0)
	lw $t0,4($a0)
	addi $a0,$a0,8
	li $t1,4
	mul $t3,$t1,$t2
	add $a0,$a0,$t3
	addi $a0,$a0,-4
	addi $t1,$t7,-1
	mul $t0,$t0,$t7
	li $t1,4
	mul $t0,$t0,$t1
	addi $t0,$t0,4
	move $t2,$t7
	j r90_helper3
	
r90_helper3:
	beqz $t4,r90_write
	beqz $t2,r90_helper4
	addi $t4,$t4,-1
	addi $t2,$t2,-1
	lw $t1,0($sp)
	addi $sp,$sp,-4
	sw $t1,0($a0)
	add $a0,$a0,$t3
	j r90_helper3

r90_helper4:
	move $t2,$t7
	sub $a0,$a0,$t0
	j r90_helper3

r90_write:
	move $a0,$t9
	move $a1,$t8
	move $sp,$t5
	move $t4,$ra
	jal write_file
	move $ra,$t4
	jr $ra
	
.globl rotate_clkws_180
rotate_clkws_180:
	move $t5,$sp
	move $t8,$a0
	move $t9,$a1
	li $t0,0
	lw $t1,0($a0)
	lw $t2,4($a0)
	addi $a0,$a0,8
	mul $t3,$t1,$t2
	move $t4,$t3
	j r180_helper
    jr $ra
    
 r180_helper:#copy matrix to stack
 	beqz $t3,r180_helper2
 	addi $t3,$t3,-1
 	lw $t1,0($a0)
 	addi $a0,$a0,4
 	addi $sp,$sp,-4
 	sw $t1,0($sp)
 	j r180_helper
 	
 	
r180_helper2:#prepare to copy back
      move $a0,$t8
      addi $a0,$a0,8
      j r180_helper3
 
r180_helper3:
	beqz $t4,r180_write
	addi $t4,$t4,-1
	lw $t1,0($sp)
	addi $sp,$sp,4
	sw $t1,0($a0)
	addi $a0,$a0,4
	j r180_helper3

r180_write:
	move $a0,$t9
	move $a1,$t8
	move $sp,$t5
	move $t4,$ra
	jal write_file
	move $ra,$t4
	jr $ra
	

.globl rotate_clkws_270
rotate_clkws_270:
   move $t5,$sp
    move $t8,$a0
    move $t9,$a1
    lw $t1,0($a0)
    lw $t2,4($a0)
    sw $t2,0($a0) 
    sw $t1,4($a0) 
    addi $a0,$a0,8
    mul $t3,$t1,$t2
    move $t4,$t3
    j r270_helper
    jr $ra

r270_helper:
	beqz $t3,r270_helper2
	addi $t3,$t3,-1
	lw $t1,0($a0)
	addi $a0,$a0,4
	addi $sp,$sp,-4
	sw $t1,0($sp)
	j r270_helper

r270_helper2:
	move $sp,$t5
	addi $sp,$sp,-4
	move $a0,$t8
	lw $t1,0($a0)
	lw $t2,4($a0)
	lw $t7,0($a0)
	lw $t0,4($a0)
	addi $a0,$a0,8
	li $t1,4
	mul $t3,$t1,$t0
	move $t1,$t7
	addi $t1,$t1,-1
	mul $t2,$t3,$t1
	add $a0,$a0,$t2
	move $a1,$a0
	move $t2,$t7
	j r270_helper3
	
r270_helper3:
	beqz $t4,r270_write
	beqz $t2,r270_helper4
	addi $t4,$t4,-1
	addi $t2,$t2,-1
	lw $t1,0($sp)
	addi $sp,$sp,-4
	sw $t1,0($a0)
	sub $a0,$a0,$t3
	j r270_helper3

r270_helper4:
	move $t2,$t7
	addi $a1,$a1,4
	move $a0,$a1
	j r270_helper3

r270_write:
	move $a0,$t9
	move $a1,$t8
	move $sp,$t5
	move $t4,$ra
	jal write_file
	move $ra,$t4
	jr $ra
    
.globl mirror
mirror:
	move $t5,$sp
	move $t8,$a0
	move $t9,$a1
	li $t0,0
	lw $t1,0($a0)
	lw $t2,4($a0)
	addi $a0,$a0,8
	mul $t3,$t1,$t2
	move $t4,$t3
	j mirror_helper
        jr $ra
        
mirror_helper:
	beqz $t3,mirror_helper2
	addi $t3,$t3,-1
	lw $t1,0($a0)
	addi $a0,$a0,4
	addi $sp,$sp,-4
	sw $t1,0($sp)
	j mirror_helper
	
mirror_helper2:
	move $sp,$t5
	addi $sp,$sp,-4
	move $a0,$t8
	lw $t1,0($a0)
	lw $t2,4($a0)
	addi $a0,$a0,8
	li $t1,4
	mul $t3,$t2,$t1
	add $a0,$a0,$t3
	addi $a0,$a0,-4
	li $t1,2
	mul $t3,$t3,$t1
	move $t7,$t2
	j mirror_helper3

mirror_helper3:
	beqz $t4,mirror_write
	beqz $t2,mirror_helper4
	addi $t4,$t4,-1
	addi $t2,$t2,-1
	lw $t1,0($sp)
	addi $sp,$sp,-4
	sw $t1,0($a0)
	addi $a0,$a0,-4
	j mirror_helper3

mirror_helper4:
	move $t2,$t7
	add $a0,$a0,$t3
	j mirror_helper3
	
mirror_write:
	move $a0,$t9
	move $a1,$t8
	move $sp,$t5
	move $t4,$ra
	jal write_file
	move $ra,$t4
	jr $ra
	
.globl duplicate
duplicate:
    move $t6,$ra
    move $ra,$t6
    li $v0,-1
    li $v1,0
    jr $ra
dplct:
	lw $t1,0($a0)
	li $v0,1
	move $a0,$t1
	syscall
	jr $ra	
return:
    move $a0,$t8
    li $v0,16
    syscall
    li $v0,1
    jr $ra
