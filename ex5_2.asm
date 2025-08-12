# Aluna: Ana Paula Barbosa Pereira
# Exercício MIPS 5 - n2 - maior e menor elemento

.data
	ent1: .asciiz "Tamanho do vetor: "
	ent2: .asciiz "Vetor ["
	ent3: .asciiz "]: "
	ent5: .asciiz "Maior Número: "
	ent6: .asciiz "Menor Número: "
	ent7: .asciiz "Localização: "
	
.text

main:
	# Realiza a leitura do tamanho do vetor e dos seus elementos:	
	jal leitura
	
	# Realizando analises para encontrar o maior e o menor elemento do Vetor
	li $t1, 1 # índice auxiliar (primeira posição = 1)
	move $t2, $t0 # endereco do elemento atual
	
	# Iniciando iteração	
	li $t5, 0 # armazena o maior valor e t7 armazena a sua localização
	lw $t6, ($t2) # armazena o menor valor e t8 armazena a sua localização
		
	addi $s0, $s0, 1
		
loop_maior_menor:
	lw $t3, ($t2) # carrega o elemento atual
			
analise_maior:
	blt $t3, $t5, analise_menor # Se for menor, já pula para a próxima análise
	# senão
	move $t5, $t3 # Vira o novo maior elemento
	move $t7, $t1 # guarda a posição
			
analise_menor:
	bgt $t3, $t6, continua # Se for maior, já pula para a próxima iteração
	# senão
	move $t6, $t3 # Vira o novo menor elemento
	move $t8, $t1 # guarda a posição
			
continua:
	addi $t1, $t1, 1 # incrementa o índice
	addi $t2, $t2, 4 # próx
	blt $t1, $s0, loop_maior_menor # analisa se chegou no final do Vetor
			
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall
			
imprimindo_maior_valor:				
	# imprime a mensagem 5
	la $a0, ent5
	li $v0, 4
	syscall
	
	# imprime o maior valor
	move $a0, $t5
	li $v0, 1
	syscall
	
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall 
		
	# imprime a mensagem 7
	la $a0, ent7
	li $v0, 4
	syscall
	
	# imprime a posição do maior número
	move $a0, $t7
	li $v0, 1
	syscall
		
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall 
	
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall

imprimindo_menor_valor:
	# imprime mensagem 6
	la $a0, ent6
	li $v0, 4
	syscall
	
	# imprime o menor valor
	move $a0, $t6
	li $v0, 1
	syscall
		
	# Quebra de Linha
	li $v0, 11
	la, $a0, 10
	syscall 
		
	# imprime a mensagem 7
	la $a0, ent7
	li $v0, 4
	syscall
	
	# imprime a posição do menor número
	move $a0, $t8
	li $v0, 1
	syscall

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