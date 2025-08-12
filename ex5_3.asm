# Aluna: Ana Paula Barbosa Pereira
# Exercício MIPS 5 - n3 - posições pares e ímpares

.data
	ent1: .asciiz "Tamanho dos vetores: "
	ent2: .asciiz "Vetor_1 ["
	ent3: .asciiz "]: "
	ent4: .asciiz "Vetor_2 ["
	ent5: .asciiz "VetE: "
	ent6: .asciiz " "

.text
main:
	# Realiza a leitura do tamanho do vetor e dos elementos do Vetor 1 e do Vetor 2	
	jal leitura
		
	# Realiza cálculos para colocar os elementos nas posições corretas
	li $v0, 9 # alocacao dinamina heap
	mul $a0, $s0, 4
	syscall
	
	move $t6, $v0 # Vetor novo
	move $t7, $t6
		
	li $t4, 0 # auxiliar
	
	# Pula 1 pq o Vetor 2 é para os ímpares
	addi $t1, $t1, 4 
	
analisando_posicoes:	
	# Carregando o valor do Vetor 1
	lw $t5, ($t0) # carrega o elemento do vetor 1
	sw $t5, ($t6) # salva o elemento no vetor final
	addi $t0, $t0, 8 # pula para o próximo par
	addi $t6, $t6, 4 # próx
	
	# Carregando o valor do Vetor 2
	lw $t5, ($t1) # carrega o elemento do vetor 1
	sw $t5, ($t6) # salva o elemento no vetor final
	addi $t1, $t1, 8 # pula para o próximo ímpar
	addi $t6, $t6, 4 # próx
				
	addi $t4, $t4, 1 # incrementa auxiliar			
							
	blt $t4, $s0, analisando_posicoes
			
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall
	
	# imprimir a mensagem 5
	li $v0, 4
	la $a0, ent5
	syscall
		
	li $t8, 0 # índice
		
vetor_final: # escreve o novo vetor
	# Imprime o valor do Vetor com as posições corretas
	li $v0, 1 
	lw $a0, ($t7)
	syscall 
		
	# imprimir a mensagem 6
	li $v0, 4
	la $a0, ent6
	syscall
		
	addi $t8, $t8, 1 # incrementa índice
	addi $t7, $t7, 4 # vai para a próxima posição
	blt $t8, $s0, vetor_final # analisa se o Vetor chegou ao fim		

fim:
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
	move $t0, $v0 # t0 armazena o endereco do Vetor 1
	# Repetindo o processo...
	move $a0, $t2 # quantidade de bytes para serem alocados
	li $v0, 9 # codigo de alocacao dinamica heap
	syscall # aloca n * 4 bytes 
	move $t1, $v0 # t1 armazena o endereco do Vetor 2
	
	# Auxiliar para o índice
	li $t2, 0 # i = 0
	move $t3, $t0 # t3 aramzena o endereco do Vetor 1
	
lendo_vetor_1:
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
	
	# leitura do valor a ser inserido no Vetor 1
	li $v0, 5 
	syscall
	sw $v0, ($t3) # armazena o valor em t3
	addi $t3, $t3, 4 # vai para o próximo 
	addi $t2, $t2, 1 # incrementa i
	blt $t2, $s0, lendo_vetor_1 # analisa se acabou o Vetor 1
			
	li $t2, 0 # i = 0
	move $t3, $t1 # t3 = endereco do vetor 1 temporario
	
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall 
	
lendo_vetor_2:
	# imprime a mensagem 4
	li $v0, 4 
	la, $a0, ent4 
	syscall 
	
	# imprime índice
	li $v0, 1 
	move $a0, $t2
	syscall
	
	# imprime mensagem 3
	li $v0, 4 
	la $a0, ent3 
	syscall 
	
	# leitura do valor a ser inserido no Vetor 2
	li $v0, 5 
	syscall 
	sw $v0, ($t3) # armazena o valor em $t3
	addi $t3, $t3, 4 # vai para o próximo 
	addi $t2, $t2, 1 # incrementa i
	blt $t2, $s0, lendo_vetor_2 # analisa se acabou a leitura do vetor 2
	# se acabou...
	jr $ra # volta para a função inicial