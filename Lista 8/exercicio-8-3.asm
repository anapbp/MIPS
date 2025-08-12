.data
    vetor: .word 5, 10, 15, 20
    arq: .asciiz "vetor.dat"
    erro: .asciiz "Erro ao abrir o arquivo\n"
    elemento: .word 0 
    
.text
main:
	# Abrindo arquivo
        li $v0, 13             
        la $a0, arq            
        li $a1, 9 
        li $a2, 0
        syscall

        # Verificar se o arquivo foi aberto com sucesso
        beqz $v0, deu_erro
        jal iniciar_procedimento

fim_main:
        # Fechando o arquivo
        li $v0, 16 
        move $a0, $s0
        syscall

        # Finalizar
        li $v0, 10
        syscall

iniciar_procedimento:
        move $s0, $v0

        # Escrevendo no arquivo
        li $v0, 15 
        move $a0, $s0
        la $a1, vetor   
        li $a2, 16 
        syscall

        # Lendo índice
        li $v0, 5 
        syscall
        
        move $t0, $v0 # Armazenando o valor
        bltz $t0, fim_main 
        li $t1, 3
        bgt $t0, $t1, fim_main

        # Movendo cursor
        li $v0, 19
        move $a0, $s0
        li $v1, 0 
        move $a2, $t0 
        li $a3, 0 
        syscall

	# Lendo arquivo
        li $v0, 14
        move $a0, $s0
        la $a1, elemento
        li $a2, 4
        syscall

        # Incrementando
        lw $t2, elemento
        addi $t2, $t2, 1  
        sw $t2, elemento

        # Movendo cursor
        li $v0, 19
        move $a0, $s0
        li $v1, 0 
        li $a2, -4  
        li $a3, 1  
        syscall

        # Escrevendo no arquivo
        li $v0, 15           
        move $a0, $s0       
        la $a1, elemento         
        li $a2, 4             
        syscall

        li $v0, 19
        move $a0, $s0 
        li $v1, 0 
        li $a2, 0 
        li $a3, 0
        syscall
        
        li $v0, 14            
        move $a0, $s0         
        la $a1, vetor       
        li $a2, 16
        syscall

        # Imprimindo
        li $v0, 1             
        li $a1, 4    
        la $a0, vetor         
	imprimindo:
        	lw $a0, 0($a0)
        	syscall
        	
        	# Imprimindo espaco
        	li $v0, 11
        	li $a0, 32
        	syscall
        	
       		addiu $a1, $a1, -1
        	bnez $a1, imprimindo # Analisa se finaliza ou não
        
        jr $ra # Volta para a função principal
        
deu_erro: # Caso não conseguir abrir o arquivo
        # Imprime mensagem de erro
        li $v0, 4
        la $a0, erro 
        syscall
        
        # Fechando o arquivo
        li $v0, 16 
        move $a0, $s0
        syscall

        # Finalizar
        li $v0, 10
        syscall