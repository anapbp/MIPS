.data
	str1: .asciiz "Existe pelo menos uma mesma sequência de palavras de tamanho maior ou igual a cinco em ambos os arquivos.\n"
	str2: .asciiz "Não existe nenhuma mesma sequência de palavras de tamanho maior ou igual a cinco em ambos os arquivos.\n"
	
	Arq1: .asciiz "arquivo-1.txt"
	Arq2: .asciiz "arquivo-2.txt"
	erro: .asciiz "Erro para abrir o arquivo\n"
	
	mem: .space 100
	w1: .space 100
	w2: .space 100

.text
main:
 	# Abrindo arquivo
	li $t0, 13 
	la $a0, Arq1
	li $a1, 0 
	syscall
	
	bltz $v0, deu_erro # Não conseguiu abrir o arquivo
	j sem_erro # Conseguiu abrir o arquivo
	
deu_erro:
	# Imprime mensagem de erro
	li $v0, 4
	la $a0, erro
	syscall
	
	# Finaliza
	li $v0, 10   
	syscall
	
sem_erro:
	move $s0, $v0

	# Abrindo arquivo
	li $t0, 13        
	la $a0, Arq2 
	li $a1, 0        
	syscall
	
	bltz $v0, deu_erro
	move $s1, $v0
	
	li $s2, 0
	li $s3, 0

verifica_palavras:
	# Para o arquivo 1
	move $a0, $s0 
	la $a1, w1
	jal leitura
	
	blez $v0, finalizar_arquivo  # Fim do arquivo 1
	
	# Repete para o arquivo 2
	move $a0, $s1
	la $a1, w2
	jal leitura 
	
	blez $v0, finalizar_arquivo   # Fim do arquivo 2

	la $a0, w1
	la $a1, w2
	
	# Comparar palavras
	jal comparar_palavras
	
	beqz $v0, mesma_palavra
	
	j nao_eh_mesma_palavra
	                
mesma_palavra:
    addi $s2, $s2, 1
    j continua_palavras
    
nao_eh_mesma_palavra:
    bgt $s2, $s3, maior_sequencia 
    j continua_palavras2
    
maior_sequencia:
    move $s3, $s2      
    j continua_palavras2
    
continua_palavras2:
    li $s2, 0           
    
continua_palavras:
    j verifica_palavras 
   
finalizar_arquivo:
	li $t0, 5
	
	bge $s3, $t0, eh_maior_ou_igual_5 # Caso for >= 5
	j nao_eh_maior_ou_igual_5 # Caso não for
	
eh_maior_ou_igual_5:
	# Imprimir mensagem 1
	li $v0, 4
	la $a0, str1
	syscall
	
	j continua
	
nao_eh_maior_ou_igual_5:
	# Imprimir mensagem 2
	li $v0, 4
	la $a0, str2
	syscall
    
continua:
	# Fechando arquivos
	li   $v0, 16      
	move $a0, $s0     
	syscall
    
	li   $v0, 16      
	move $a0, $s1     
	syscall

	# Resultado
	li $v0, 4 
	li $t0, 5
	bge $s3, $t0, maior_ou_igual_a_cinco
	# Imprime mensagem 2
	la $a0, str2
	syscall

	j finalizar

maior_ou_igual_a_cinco:
	# Imprimir mensagem 1
	la $a0, str1
	syscall

finalizar:
	# Finalizar
	li  $v0, 10
	syscall

leitura:
	li $t0, 0
	move $t1, $a1

lfim1o_caracteres:
	# Lfim1o o arquivo
	li $v0, 14
	la $a1, mem
	li $a2, 1 
	syscall
	
	blez $v0, fim_lfim1o_caracteres  # Chegou ao fim do arquivo
	lb $t2, ($a1)
	beqz $t2, fim_lfim1o_caracteres  # Verifica se chegou ao final da string (caractere nulo)
	
	# Casos que significam que chegou ao fim
	beq $t2, ' ', fim_lfim1o_caracteres
	beq $t2, '\t', fim_lfim1o_caracteres
	beq $t2, '\n', fim_lfim1o_caracteres

	add $t3, $t1, $t0
	sb $t2, 0($t3)
	addi $t0, $t0, 1 # Próx
	
	j lfim1o_caracteres # Continua
    
fim_lfim1o_caracteres:
	add $t3, $t1, $t0
	sb $zero, 0($t3)
	jr $ra # Volta para a função anterior
    
comparar_palavras:
    li $v0, 0
    
loop:
    lb $t0, 0($a0)   # Carrega o próximo caractere da primeira string
    lb $t1, 0($a1)   # Carrega o próximo caractere da segunda string

    # Verifica se chegou ao final de alguma das strings
    beqz $t0, fim1    # Se chegou ao final da primeira string, termina
    beqz $t1, fim1    # Se chegou ao final da segunda string, termina

    # Compara os caracteres
    sub $t2, $t0, $t1
    bnez $t2, analises

    # Avança para o próximo caractere
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    
    j loop # Continua

analises:
	# Verifica se ambas as strings terminaram
	beqz $t0, primeira_analise
	beqz $t1, segunda_string_menor
    
primeira_analise:
	# Se a segunda string também terminou, as strings são iguais
	beqz $t1, strings_iguais
    
	# A primeira string é menor
	li $v0, -1
	j fim1
    
segunda_string_menor:
	# A segunda string é menor
	li $v0, 1
	j fim1
    
strings_iguais:
	# Strings iguais
	li $v0, 0
    
fim1:
    jr $ra # Volta para a funcao principal