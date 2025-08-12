.data
	str1: .asciiz "insira o tamanho do vetor:"
	str2: .asciiz "elemento["
	str3: .asciiz "] do vetor1:"
	str5: .asciiz "maior elemento: "
	str6: .asciiz " menor elemtno: "
	str7: .asciiz "(posicao "
	str8: .asciiz ")"
.text
	main:
		
		jal leitura
		jal operacao
		
		li $v0, 10
		syscall
		
	leitura:
		li $v0, 4# impressao de string
		la $a0, str1
		syscall
		li $v0, 5 # leitura de n
		syscall
		move $s0, $v0
		
		sll $t2, $s0, 2 # t2 = n * 4 = bytes para inteiros dos vetores
		move $a0, $t2 # carrega a quantidade de bytes para serem alocados
		li $v0, 9 # codigo de alocacao dinamica heap
		syscall # aloca n * 4 bytes 
		move $t0, $v0 # t0 = endereco do primeiro vetoe
		
		li $t2, 0 # i = 0
		move $t3, $t0 # t3 = endereco do vetor 1 temporario
		loopLeitura1:
			li $v0, 4 # codigo impressao string
			la, $a0, str2 # endereco string
			syscall # imprime string
			li $v0, 1 # codigo impressao inteiro
			move $a0, $t2 # i
			syscall # imprime inteiro
			li $v0, 4 # codigo impressao string
			la $a0, str3 # endereco string
			syscall # imprime string
			li $v0, 5 # codigo leitura inteiro
			syscall # le inteiro
			sw $v0, ($t3) # salva inteiro em $t3
			addi $t3, $t3, 4 # atualiza endereco
			addi $t2, $t2, 1 # atualiza i
			blt $t2, $s0, loopLeitura1 # continua loop se i < n
			
		jr $ra
		
	operacao:
		li $t1, 0 #quantidade de nao zeros = 0
		move $t2, $t0 # endereco do elemento atual
		sll $s4, $s0, 2 # s4 = n * 4 = bytes para inteiros dos vetores
		add $s4, $s4, $t0 # adiciona o endereco do vetor a t4
		
		li $t4, 0 # maior ($t5 = posicao no vetor)
		lw $t6, ($t2) # carrega o menor com o valor do primeiro elemento ($t7 = posicao no vetor)
		
		
		loopQuantidade:
			lw $t3, ($t2) # carrega o elemento atual do vetor
			
			beqz $t3, fim # se o elemento for zero va para fim
			addi $t1, $t1, 1 # aumenta a quantidade de nao zeros

			fim:
			addi $t2, $t2, 4 # atualiza endero (proximo elemento)
			blt $t2, $s4, loopQuantidade # continua o loop se o endereco final nao for atingido
			
		li $v0, 9 # codigo alocacao dinamica heap
		sll $a0, $t1, 2 # a0 = t1 * 4
		syscall
		
		move $s3, $v0 # endereco do vetor novo = $s3
		move $s5, $s3 # copia do endereco
		move $t2, $t0 # endereco do elemento atual
		
		loopArmazenar:
			lw $t3, ($t2) # carrega o elemento atual do vetor
			
			beqz $t3, fim2 # se o numero for zero va para o fim
			sw $t3, ($s5) # armazena o elemento no vetor novo
			addi $s5, $s5, 4 # atualiza a posicao

			fim2:
			addi $t2, $t2, 4 # atualiza endero (proximo elemento)
			blt $t2, $s4, loopArmazenar # continua o loop se o endereco final nao for atingido
			
		li $a0, 10 # imprime \n
		li $v0, 11
		syscall
		
		li $t7, 0 # i = 0
		move $s5, $s3 # s5 = endereco do vetor novo
			
		loopEscrita: # escreve o novo vetor
			li $v0, 1 # codigo impressao int
			lw $a0, ($s5) # carrega elemento do vetor novo
			syscall # imprime inteiro
			addi $s5, $s5, 4 # atualiza posicao
			
			li $a0, 32 # imprime espaco
			li $v0, 11
			syscall
			
			addi $t7, $t7, 1 # i++
			blt $t7, $t1, loopEscrita # if i < n continue loop
		
		#retorna para main
		jr $ra
		