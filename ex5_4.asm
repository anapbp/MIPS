# Aluna: Ana Paula Barbosa Pereira
# Exercício MIPS 5 - n4 - compactar

.data
	ent1: .asciiz "Tamanho do vetor: "
	ent2: .asciiz "Vetor ["
	ent3: .asciiz "]: "
	ent4: .asciiz "Vetor Compactado: "
	ent5: .asciiz " "

.text

main:
	# Realiza a leitura do tamanho do vetor e dos seus elementos:	
	jal leitura
	
	# Realizando operações para compactar
	li $t1, 0 # auxiliar para quantidade de números diferentes de zero
	move $t2, $t0 # endereco do elemento atual
		
	li $s4, 0 # auxiliar
		
loop:
	lw $t3, ($t2) # carrega o elemento atual do vetor
			
	beqz $t3, eh_zero # se o elemento for igual a zero, não incrementar contador
	# senão, incrementar
	addi $t1, $t1, 1 # incrementa não zeros

eh_zero:
	addi $t2, $t2, 4 # próx
	addi $s4, $s4, 1 # incrementa não zeros
	blt $s4, $s0, loop # continua o loop se o endereco final nao for atingido
			
	li $v0, 9 # alocacao dinamica heap
	mul $a0, $t1, 4
	syscall
	move $s3, $v0 # Novo Vetor
	move $s5, $s3
	move $t2, $t0 # reseta vetor com elementos para a primeira posição
	
	li $s4, 0 # reseta auxiliar
		
loopArmazenar:
	lw $t3, ($t2) # carrega o elemento atual do vetor
			
	beqz $t3, fim2 # se o numero for zero va para o fim
	sw $t3, ($s5) # armazena o elemento no vetor novo
	addi $s5, $s5, 4 # próx

fim2:
	addi $t2, $t2, 4 # atualiza endero (proximo elemento)
	blt $s4, $t1, loopArmazenar # continua o loop se o endereco final nao for atingido

	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall
	
	# imprimir a mensagem 4
	li $v0, 4
	la $a0, ent4
	syscall
		
	li $t7, 0 # índice
	move $s5, $s3 # Vetor Novo

vetor_final:
	# Imprime o valor do Vetor com as posições corretas
	li $v0, 1 
	lw $a0, ($s5)
	syscall 
		
	# imprimir a mensagem 5
	li $v0, 4
	la $a0, ent5
	syscall
		
	addi $t7, $t7, 1 # incrementa índice
	addi $s5, $s5, 4 # vai para a próxima posição
	blt $t7, $t1, vetor_final # analisa se o Vetor chegou ao fim		
		
				
finalizar:
	# Finalizar
	li $v0, 10
	syscall				
								
leitura:

	# imprimir a mensagem 1
	li $v0, 4
	la $a0, ent1
	syscall
	# ler o tamanho do Vetor
	li $v0, 5 
	syscall
	move $s0, $v0
	
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall 

	mul $t2, $s0, 4 # t2 = n * 4
	move $a0, $t2 # quantidade de bytes para serem alocados
	li $v0, 9 # codigo de alocacao dinamica heap
	syscall # aloca n * 4 bytes 
	move $t0, $v0 # t0 armazena o endereco do Vetor
		
	li $t2, 1 
	move $t3, $t0 
	add $t8, $s0, 1 # auxiliar para escrever os índices (primeira posição = 1)
	
l:
	# Imprime a mensagem 2
	li $v0, 4
	la, $a0, ent2
	syscall
	
	# imprime índice
	li $v0, 1 
	move $a0, $t2 
	syscall
	
	# imprime mensagem 3
	li $v0, 4 
	la $a0, ent3 
	syscall 
	
	# leitura do valor a ser inserido no Vetor
	li $v0, 5 
	syscall
	sw $v0, ($t3) # armazena o valor em t3
	addi $t3, $t3, 4 # vai para o próximo 
	addi $t2, $t2, 1 # incrementa i
	blt $t2, $t8, l # analisa se acabou o Vetor
		
	# se acabou...
	jr $ra # volta para a função inicial	