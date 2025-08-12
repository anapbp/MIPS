.data
Mat: .space 36 # pq é uma Matriz 3x3, entao tem 9 elementos, por isso 9x4 = 36

Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

.text
main:
	la $a0, Mat
	li $a1, 3 # quantidade de linhas
	li $a2, 3 # quantidade de colunas
	
	# realizando o processo de leitura da Matriz
	jal leitura
	move $a0, $v0
	
	# realizando o processo de escrita da Matriz
	jal escrita
	
	# finalizando
	li $v0, 10
	syscall

indice:
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2 
	add $v0, $v0, $a3
	jr $ra

leitura:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0

l:
	la $a0, Ent1
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, Ent2
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, Ent3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t2, $v0
	jal indice
	sw $t2, ($v0)
	addi $t1, $t1, 1
	blt $t1, $a2, l
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, l
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra
	
escrita:
	subi $sp, $sp, 4 
	sw $ra, ($sp)
	move $a3, $a0
	
e:
	jal indice
	lw $a0, ($v0)
	li $v0, 1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	blt $t1, $a2, e
	la $a0, 10
	syscall
	li $t1, 1
	addi $t0, $t0, 1
	blt $t0, $a1, e
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra