.data
	str1: .asciiz "O maior valor é --> : "
	str2: .asciiz "\nO menor valor é --> "
	str3: .asciiz "\nQuantidade de ímpares --> "
	str4: .asciiz "\nQuantidade de pares --> "
	str5: .asciiz "\nSoma --> "
	str6: .asciiz "\nOrdem crescente --> "
	str7: .asciiz "\nOrdem decrescente --> "
	str8: .asciiz "\nProduto --> "
	str9: .asciiz "\nQuantidade caracteres --> "
	erro: .asciiz "Erro para abrir arquivo :(\n"
	buffer: .asciiz " "
	Arq: .asciiz "Arq-exer1.txt"

.text
main:
	# Abrir arquivo
        li $v0, 13
        la $a0, Arq 
        li $a1, 0
        syscall
        
        # Analisa erro apra abrir arquivo
        bltz $v0, deu_erro 
        j sem_erro  
        
# Caso der erro
deu_erro:
	# Imprimir que deu erro
	li $v0, 4         
	la $a0, erro      
	syscall          
	
	# Finaliza
	li $v0, 10   
	syscall       
	  
sem_erro:
        move $s0, $v0           
	li $t8, 0 # Índice auxiliar
	
loop1:
	jal leitura 
	blez $v0, finalizar_loop1
	
	# Incrementa
	addi $t8, $t8, 1
	# Loop
	j loop1
            
finalizar_loop1:
        # Fechar o Arq
        li $v0, 16 
        move $a0, $s0  
        syscall

        # Abrir arquivo
        li $v0, 13
        la $a0, Arq
        li $a1, 0 
        syscall
        
        # Analisa erro apra abrir arquivo
        bltz $v0, deu_erro_2 
        j sem_erro_2 
        
# Caso der erro
deu_erro_2:
	# Imprimir que deu erro
	li $v0, 4      
	la $a0, erro 
	syscall  
	
	# Finaliza
	li $v0, 10 
	syscall 
	
sem_erro_2:
        move $s0, $v0       

        # Alocação
        li $t0, 4          
        mult $t8, $t0 
        mflo $t0 
        add $a0, $0, $t0
        li $v0, 9  
        syscall
        
	# Salvando     
        move $t9, $v0          

        # Ler os números do Arq e armazená-los na memória
        li $t0, 0
        
loop2:
	jal leitura 
	
	blez $v0, finalizar_loop2  
	move $t2, $t9	
	sll $t1, $t0, 2
	add $t2, $t2, $t1  
	sw $v0, 0($t2)
	addi $t0, $t0, 1
	
	# Loop
	j loop2
            
finalizar_loop2:
        # Fechar arquivo
        li $v0, 16 
        move $a0, $s0 
        syscall 

        # Imprimir mensagem 1
        li $v0, 4
        la $a0, str1
        syscall
        
        move $a0, $t9
        move $a1, $t8
        
        jal procedimento_A
        
	# Imprimindo inteiro
        move $a0, $v0
        li $v0, 1
        syscall

        # Imprimindo mensagem 2
        li $v0, 4        
        la $a0, str2    
        syscall             
        
        move $a0, $t9    
        move $a1, $t8     
        
        jal procedimento_B
        
        # Imprimindo inteiro
        move $a0, $v0 
        li $v0, 1 
        syscall 

        # Imprimindo mensagem 3
        li $v0, 4       
        la $a0, str3 
        syscall 
        
        move $a0, $t9 
        move $a1, $t8 
        
        jal procedimento_C
        
        # Imprimindo inteiro
        move $a0, $v0
        li $v0, 1
        syscall

        # Imprimindo mensagem 4
        li $v0, 4  
        la $a0, str4
        syscall
        
        move $a0, $t9  
        move $a1, $t8  
        
        jal procedimento_D
        
        # Impprimindo inteiro
        move $a0, $v0 
        li $v0, 1
        syscall 

        # Imprimindo mensagem 5
        li $v0, 4       
        la $a0, str5    
        syscall     
        
        move $a0, $t9    
	move $a1, $t8      
	
        jal procedimento_E
        
        # Impprimindo inteiro
        move $a0, $v0 
        li $v0, 1 
        syscall  

        # Imprimindo mensagem 6
        li $v0, 4   
        la $a0, str6    
        syscall         
        
        move $a0, $t9       
        move $a1, $t8    
        
        jal procedimento_F

        # Impprimindo mensagem 7
        li $v0, 4   
        la $a0, str7    
        syscall          
        
        move $a0, $t9     
        move $a1, $t8    
        
        jal procedimento_G

        # Imprimindo mensagem 8
        li $v0, 4 
        la $a0, str8   
        syscall  
        
        move $a0, $t9    
        move $a1, $t8     
        
        jal procedimento_H
        
        # Impprimindo inteiro
        move $a0, $v0   
        li $v0, 1         
        syscall           

        # Imprimindo mensagem 9
        li $v0, 4       
        la $a0, str9    
        syscall   
        
        move $a0, $t9       
        move $a1, $t8 
        
        jal procedimento_I
        
        # Impprimindo inteiro
        move $a0, $v0     
        li $v0, 1          
        syscall     

        # Finalizar
        li $v0, 10       
        syscall    

leitura:
	# Ler arquivo
        li $v0, 14
        syscall
        
        jr $ra

procedimento_A: # a) o maior valor;
        li $v0, 0 
        move $t0, $t9 
        li $t1, 0
        
loopA:
	lw $t2, 0($t0) 
	bge $t2, $v0, pulaA 
	move $v0, $t2 
	
pulaA:
	addi $t1, $t1, 1 # Incrementa
	sll $t3, $t1, 2
	add $t0, $t9, $t3
	blt $t1, $t8, loopA  
            
        jr $ra # Volta para a função principal

procedimento_B: # b) o menor valor;
        li $v0, 1000000000
        move $t0, $t9 
        li $t1, 0
        
loopB:
	lw $t2, 0($t0) 
	ble $t2, $v0, pulaB 
	move $v0, $t2   
	
pulaB:
	addi $t1, $t1, 1 # Incrementa
	sll $t3, $t1, 2 
	add $t0, $t9, $t3 
	blt $t1, $t8, loopB 
	
        jr $ra # Volta para a função principal

procedimento_C: # c) o número de elementos ímpares;
        li $v0, 0      
        move $t0, $t9    
        li $t1, 0  
        
loopC:
	lw $t2, 0($t0)  
	andi $t3, $t2, 1 
	bnez $t3, adicionaC  
	addi $t1, $t1, 1 # Incrementa
	
adicionaC:
	addi $t1, $t1, 1  # Incrementa
	addi $t1, $t1, 1  # Incrementa
	sll $t4, $t1, 2
	add $t0, $t9, $t4 
	blt $t1, $t8, loopC
	
        move $v0, $t1 
        
        jr $ra # Volta para a função principal

procedimento_D: # d) o número de elementos pares;
        li $v0, 0          
        move $t0, $t9   
        li $t1, 0       
        
loopD:
	lw $t2, 0($t0)  
	andi $t3, $t2, 1 
	beqz $t3, adicionaD  
	addi $t1, $t1, 1  # Incrementa
	
adicionaD:
	addi $t1, $t1, 1  # Incrementa
	addi $t1, $t1, 1  # Incrementa
	sll $t4, $t1, 2  
	add $t0, $t9, $t4
	blt $t1, $t8, loopD
            
        move $v0, $t1
        jr $ra # Volta para a função principal

procedimento_E: # e) a soma dos valores;
        li $v0, 0          
        move $t0, $t9     
        li $t1, 0   
        
loopE:
	lw $t2, 0($t0) 
	add $v0, $v0, $t2  
	addi $t1, $t1, 1 # Incrementa
	sll $t3, $t1, 2
	add $t0, $t9, $t3
	blt $t1, $t8, loopE
            
        jr $ra # Volta para a função principal

procedimento_F: # f) os valores em ordem crescente;
        move $t0, $t9    
        li $t4, 0 
        
loopF_1:
	move $t1, $t0  
	li $t5, 0 
            
loopF_2:
	sll $t2, $t5, 2
	add $t3, $t0, $t2 
	lw $t6, 0($t3) 
	
	sll $t2, $t1, 2 
	add $t3, $t0, $t2  
	lw $t7, 0($t3)
	
	ble $t6, $t7, pulaF 
	
	sw $t7, 0($t3)  
	sw $t6, 0($t3)  
	
pulaF:
	addi $t5, $t5, 1  # Incrementa
	blt $t5, $t8, loopF_2
	
	addi $t4, $t4, 1  # Incrementa
	blt $t4, $t8, loopF_1
	
        jr $ra # Volta para a função principal

procedimento_G: # g) os valores em ordem decrescente;
        move $t0, $t9 
        li $t4, 0 
        
loopG_1:
	move $t1, $t0
	li $t5, 0
            
loopG_2:
	sll $t2, $t5, 2 
	add $t3, $t0, $t2  
	lw $t6, 0($t3)
	
	sll $t2, $t1, 2
	add $t3, $t0, $t2 
	lw $t7, 0($t3)
	
	bge $t6, $t7, pulaG
	
	sw $t7, 0($t3)   
	sw $t6, 0($t3)  
                
pulaG:
	addi $t5, $t5, 1  # Incrementa
	blt $t5, $t8, loopG_2  
	
	addi $t4, $t4, 1  # Incrementa
	blt $t4, $t8, loopG_1
            
	jr $ra # Volta para a função principal

procedimento_H: # h) o produto dos elementos;
        li $v0, 1
        move $t0, $t9   
        
        li $t1, 0      
        
loopH:
	lw $t2, 0($t0) 
	mul $v0, $v0, $t2  
	addi $t1, $t1, 1  # Incrementa
	sll $t3, $t1, 2  
	add $t0, $t9, $t3  
	blt $t1, $t8, loopH 
            
        jr $ra # Volta para a função principal

procedimento_I: # i) o número de caracteres do arquivo;
	# Abrindo arquivo
        li $v0, 13
        la $a0, Arq 
        li $a1, 0 
        syscall
        
        move $s0, $v0      
        li $v0, 8     
        move $a0, $s0       
        la $a1, buffer  
        li $a2, 1
        syscall
        
        # Fechando arquivo
        move $t0, $v0
        li $v0, 16 
        move $a0, $s0 
        syscall
        
        move $v0, $t0
        
        jr $ra # Volta para a função principal