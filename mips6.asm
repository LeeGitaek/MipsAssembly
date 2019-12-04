.globl main 
.data
	select_str: .asciiz "Select Procedure :"
	a_input: .asciiz "a is : " 
	b_input: .asciiz "b is : "
	n_input: .asciiz "n is : "
	multiple_str: .asciiz " is multiple of three!"
	multiple_notstr: .asciiz " is not multiple of three!"
	err: .asciiz "value error!"
	space: .asciiz "\t"
# 1을 입력 받으면 a, b 두 수를 입력 받아, a-b가 3의 배수인지를 출력 후 종료
#단 (a-b > 0)
#2를 입력 받으면 a와 n의 두 수를 입력 받은 후 n까지의 점화식을 계산하여
#출력하는 MIPS assembly code를 작성하고, MARS로 수행하여라.
# T(0) = 1 , T(1) = 1 , T(n) = {T(n-1) + T(n-2)} + a
.text
main:
	la $a0 select_str # print "select procedure:"
	li $v0 4
	syscall 
	
	li $v0 5 # input procedure value 
	syscall
	
	beqz $v0,err_func # if value equal zero -> jump to err_func
	slt $t0, $v0, $zero # negative value < 0 check 
        bne $t0, $zero,err_func # jump to err_func
        bgt $v0,2,err_func # if value > 2 -> jump to err_func 
        
	add $a0,$v0,$zero # move v0 to a0
	addi $t0,$zero,1 # temporary value / t0 = 1
	bne $a0,$t0,procedure_two  # if procedure value != 1 branch to procedure_two
	j procedure_one # jump to procedure_one function
	
procedure_one: # 1을 입력 받으면 a, b 두 수를 입력 받아, a-b가 3의 배수인지를 출력 후 종료 , 단 (a-b > 0)
	la $a0 a_input # print input value of a 
	li $v0 4
	syscall 
	
	li $v0 5 # input value of a"
	syscall
	
	add $t1,$v0,$zero
	
	la $a0 b_input # print input value of a 
	li $v0 4
	syscall 
	
	li $v0 5 # input value of b"
	syscall
	
	add $t2,$v0,$zero
	
	sub $a0,$t1,$t2
	add $t3,$a0,$zero
	bgt $a0,$zero,by_three

by_three:
	addi $sp,$sp,-4
	sw $a0,0($sp)
	addi $t0, $zero,3 
        div $a0,$t0
        mfhi $t0          
        beq $t0,$zero,correct
        
	add $a0,$t3,$zero
	li $v0 1 # print integer
	syscall
	
	la $a0 multiple_notstr # print "is not multiply of three"
	li $v0 4
	syscall 
	
	lw $a0 0($sp)
	addi $sp,$sp,4
	j exit
correct:
	add $a0,$t3,$zero
	li $v0 1 # print integer
	syscall
	
	la $a0 multiple_str # print "is multiply of three"
	li $v0 4
	syscall 
	j exit
	
procedure_two: #2를 입력 받으면 a와 n의 두 수를 입력 받은 후 n까지의 점화식을 계산하여 출력 ,
# T(0) = 1 , T(1) = 1 , T(n) = {T(n-1) + T(n-2)} + a
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	
	la $a0 n_input # print n is :
	li $v0 4
	syscall 
	
	li $v0 5 # input value of n"
	syscall
	
	slt $t0, $v0, $zero # negative value < 0 check 
        bne $t0, $zero,err_func # jump to err_func
	addi $t5,$v0,1 # move n->t0
	add $t2,$zero,$zero
	
	la $a0 a_input # print a is :
	li $v0 4
	syscall 
	
	li $v0 5 # input value of a"
	syscall
	
	slt $t1, $v0, $zero # negative value < 0 check 
        bne $t1, $zero,err_func # jump to err_func
	add $t1,$v0,$zero # move a->t1
	
	# t5 = n; t1= a;
	# $s0 = 2
	# if n < 2 -> true: t2 = 1; false t2 = 0;
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
	bgt $t5,1,for
	j n_zero
	
	for:
		add $a1,$zero,$t1 # a
		add $a0,$zero,$t2 # n
    		jal T
    		move $a0 $v0
    		li $v0 1
    		syscall
    		la $a0 space
		li $v0 4
		syscall
		addi $t2,$t2,1
		bne $t2,$t5,for
		
 	lw $ra, 0($sp)
   	addi $sp, $sp, 4
    	j exit	
    	jr $ra

T:	 
    addi $sp,$sp,-12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    move $t3,$a1
    slti $t0,$a0,2
    beq $t0,$zero,else

    addi $v0, $zero, 1
    j quit

    else: 
        addi $s0,$a0,0
        addi $a0,$a0,-1
        jal T

        addi $s1,$v0,0
        addi $a0,$s0,-2
        jal T

        add $v0,$s1,$v0
	add $v0,$v0,$t3
    quit: 
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12

    jr $ra

n_zero:
	addi $sp,$sp,-4
	sw $ra 0($sp)
	
	addi $a0,$zero,1 # n < 2 -> print 1
	
	li $v0 1
	syscall
	
	la $a0 space
	li $v0 4
	syscall

	jr $ra 
	
	lw $ra 0($sp)
	addi $sp,$sp,4

err_func:
	la $a0 err # print value error string
	li $v0 4
	syscall 
	
	li $v0 10 # exit : err
	syscall

exit:
	li $v0 10 # exit : success
	syscall
	
	