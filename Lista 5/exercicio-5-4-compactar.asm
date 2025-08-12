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
	mul $t7, $s0, 4
	add $t7, $t7, $t0
		
loop:
	lw $t3, ($t2) # elemento atual
	beqz $t3, nao_incrementa # se o elemento for igual a zero nao incrementa a variável auxiliar
	# senao, caso for diferente de zero
	addi $t1, $t1, 1 # incrementa auxiliar

nao_incrementa:
	addi $t2, $t2, 4 # próx
	blt $t2, $t7, loop # analisa se terminou o Vetor
	
	# Pega um Novo Vetor com a quantidade de elementos correspondente ao número de elementos diferentes de zero		
	li $v0, 9 # alocacao dinamica heap
	sll $a0, $t1, 2
	syscall
	move $t8, $v0 # Vetor Novo
	move $t5, $t8 
	move $t2, $t0 # reseta Vetor para sua primeira posição
		
inserir_novo_vetor:
	lw $t3, ($t2) # carrega o elemento atual do vetor
			
	beqz $t3, proximo # se for igual a zero, não insere no Novo Vetor
	# senão
	sw $t3, ($t5) # armazena o elemento no Novo Vetor
	addi $t5, $t5, 4 # como inseriu, anda para o próximo

proximo:
	addi $t2, $t2, 4 # próx
	blt $t2, $t7, inserir_novo_vetor # analisa se chegou no final do Novo Vetor

escrevendo_novo_vetor:
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall
	
	# imprimir a mensagem 4
	li $v0, 4
	la $a0, ent4
	syscall
		
	li $t7, 0 # índice
	move $t5, $t8 # Vetor Novo

vetor_final:
	# Imprime o valor do Vetor com as posições corretas
	li $v0, 1 
	lw $a0, ($t5)
	syscall 
		
	# imprimir a mensagem 5
	li $v0, 4
	la $a0, ent5
	syscall
		
	addi $t7, $t7, 1 # incrementa índice
	addi $t5, $t5, 4 # vai para a próxima posição
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