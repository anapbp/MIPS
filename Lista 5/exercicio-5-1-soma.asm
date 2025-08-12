# Aluna: Ana Paula Barbosa Pereira
# Exercício MIPS 5 - n1 - soma pares - ímpares

.data
	ent1: .asciiz "Tamanho dos vetores: "
	ent2: .asciiz "Vetor_1 ["
	ent3: .asciiz "]: "
	ent4: .asciiz "Vetor_2 ["
	ent5: .asciiz " --> Elementos das posições pares do Vetor 1 - Elementos das posições ímpares do Vetor 2: "
.text

main:
	# Realiza a leitura do tamanho do vetor e dos elementos do Vetor 1 e do Vetor 2	
	jal leitura

	# Realizando os cálculos
	move $t2, $t0 # elemento atual
	li $t7, 0 # auxiliar para a soma
	mul $t4, $s0, 4 # t4 = n * 4
	add $t4, $t4, $t0
		
soma_pares:	
	lw $t3, ($t2) # elemento atual do vetor
	add $t7, $t7, $t3 # soma
	addi $t2, $t2, 8 # vai para o próximo par
	blt $t2, $t4, soma_pares # analisa se acabou o Vetor 1
			
	# Iniciando a Soma dos elementos ímpares			
	move $t2, $t1 # elemento atual
	addi $t2, $t2, 4 # começa na posição ímpar
	li $t8, 0 # auxiliar para a soma dos ímpares
	mul $t4, $s0, 4 
	add $t4, $t4, $t1
	
soma_impares:
	lw $t3, ($t2) # elemento atual
	add $t8, $t8, $t3 # soma
	addi $t2, $t2, 8 # pula de ímpar em ímpar
	blt $t2, $t4, soma_impares # analisa se acabou o Vetor 2
		
	sub $t9, $t7, $t8 # resultado final
		
	# Imprime a mensagem 5
	la $a0, ent5
	li $v0, 4
	syscall
		
	# Escreve o resultado
	move $a0, $t9
	li $v0, 1
	syscall
		
	# Finaliza
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