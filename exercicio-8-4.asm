.data
	str1: .asciiz "Erro para abrir o arquivo\n"
	ArqEntrada: .asciiz "ex4-entrada.txt"
	ArqSaida: .asciiz "ex4-saida.txt"
	espaco: .asciiz " "
	pulaLinha: .asciiz "\r\n"
	mem: .asciiz " "
    
.text
main:
	# Abrindo arquivo
        li $v0, 13
        la $a0, ArqEntrada
        li $a1, 0
        syscall
        
        bltz $v0, deu_erro # Nao conseguiu abrir o arquivo
        j sem_erro  # Conseguiu abrir o arquivo
        
deu_erro:
	# Imprimir mensagem 1
        li $v0, 4
        la $a0, str1
        syscall	
        
        # Finalizar				
        li $v0, 10
        syscall
        
sem_erro:
        move $s0, $v0
	# Para Linhas
        jal leitura_inteiros
        move $s1, $v0
        		
        # Para colunas
        jal leitura_inteiros
        move $s2, $v0
        	
        # Para posicoes anuladas
        jal leitura_inteiros
        move $s3, $v0	

        mul $t0, $s1, $s2   
        mul $t0, $t0, 4
        
        # Alocando
        move $a0, $t0		
        li $v0, 9	
        syscall	
        				
        move 	$a3, $v0		
        move 	$a2, $s2

        li $t0, 0 # Variável auxiliar para linhas
        
passando_pelas_linhas:
        bge $t0, $s1, fim2 
        li $t1, 0 # Variável auxiliar para colunas 

passando_pelas_colunas:
        bge $t1, $s2, fim1 
            
         jal indice 
         li $t2, 1
         sw $t2, ($v0)
            
        addi $t1, $t1, 1 # Incrementa colunas
        j passando_pelas_colunas
        
fim1:
        
        addi $t0, $t0, 1 # Incrementa linhas
        j passando_pelas_linhas

fim2:
        li $t9, 0 # Variável auxiliar reiniciada
                 
passando_pelas_posicoes_anuladas:
        bge $t9, $s3, fim3 
        
        jal leitura_inteiros
        jal leitura_inteiros  
                 
        move 	$t8, $v0
        
        jal leitura_inteiros
        
        move 	$t0, $t8
        move 	$t1, $v0
        move 	$a2, $s2
        
        jal indice # Calcula o índice com base nas linhas e colunas
        sw	$zero, ($v0) 
        
        addi $t9, $t9, 1 # Incrementa
        j passando_pelas_posicoes_anuladas
            
fim3:
        # Fechando o arquivo
        li   $v0, 16 
        move $a0, $s0 
        syscall

        # Abrindo arquivo
        li $v0, 13 
        la $a0, ArqSaida
        li $a1, 1
        syscall
        bltz $v0, deu_erro
        
        move $s0, $v0
        li $t0, 0 # Variável auxiliar
        
passando_pelas_linhas2:
        bge $t0, $s1, finalizando_programa 
        li $t1, 0 # Variável auxiliar
        
passando_pelas_colunas2:
        bge $t1, $s2, fim2.2 
        move $a2, $s2
        jal indice # Calcula indice com base nas linhas e nas colunas
        
        lw $a0, ($v0)
        jal impressao_inteiros
        
        # Imprimindo espaço        
        la $a1, espaco
        li $a2, 1
        li $v0, 15							
        syscall									
            
        addi $t1, $t1, 1 # Incrementando variável das colunas
        j passando_pelas_colunas2
        
fim2.2:
	# Imprimindo quebra de linha
        la $a1, pulaLinha
        li $a2, 2
        li $v0, 15								
        syscall	
        
        addi $t0, $t0, 1 # Incrementando variável das linhas
        j passando_pelas_linhas2		
            
finalizando_programa:
        # Fechando arquivo
        li   $v0, 16 
        move $a0, $s0   
        syscall

	# Finaliza
        li $v0, 10
        syscall	

indice:
        mul $v0, $t0, $a2 
        add $v0, $v0, $t1 
        sll $v0, $v0, 2 
        add $v0, $v0, $a3 
        jr $ra # Volta para a função anterior

leitura_inteiros:
        li $t1, 0
        
        # Caracteres
        li $t3, 48
        li $t4, 57
        
loop:
	# Lendo arquivo
        li $v0, 14
        
        move $a0, $s0
        la $a1, mem
        li $a2, 1
        syscall	
        
        # Vê se chegou no fim do arquivo
        blez $v0, fim_loop
        
        lb $t2, ($a1)
        blt $t2, $t3, fim_loop
        bgt $t2, $t4, fim_loop
        sub $t2, $t2, $t3 
        mul $t1, $t1, 10 
        add $t1, $t1, $t2

        j loop
        
fim_loop:
        move $v0, $t1
        jr $ra # Volta para a função anterior

impressao_inteiros:
        subi $sp, $sp, 4 
        sw $ra, ($sp) 

	la $a1, mem
	li $v0, 0							
	li $t2, 0	
	
	# Convertendo valores			
	jal convertendo_valores	

	move $a0, $s0
	
	# Escrevendo no arquivo												
	la $a1, mem
	move $a2, $v0							
	li $v0, 15								
	syscall		
								
        lw $ra, ($sp) 
        addi $sp, $sp, 4 
        
        jr $ra # Volta para a função anterior

convertendo_valores:
	div $a0, $a0, 10						
	mfhi $t3								
	subi $sp, $sp, 4
	sw $t3, ($sp)							
	addi $v0, $v0, 1						

	bnez $a0, convertendo_valores	
					#se n for diferente de 0 salta pro intString novamente
loop2:
	lw $t3, ($sp)						
	addi $sp, $sp, 4
	add $t3, $t3, 48
	sb $t3, ($a1)						
	addi $a1, $a1, 1				
	addi $t2, $t2, 1 # Incrementa
	bne $t2, $v0, loop2
	sb $zero, ($a1)		
				
	jr $ra # Volta para a função anterior