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
	erro: .asciiz "Erro ao abrir arquivo!\n"
	buffer: .space 1
	arquivo: .asciiz "Arq-exer2.txt"
    
.text
main:
	# Abrindo arquivo
	li $v0, 13       
        la $a0, arquivo 
        li $a1, 0       
        syscall
        
        # Analisa se deu erro para abrir arquivo
        bltz $v0, deu_erro
        j sem_erro 
        
deu_erro:
	# Imprime que deu erro
	li $v0, 4     
	la $a0, erro
	syscall    
	
	# Finalizar
	li $v0, 10 
	syscall    
	
sem_erro:
        move $s0, $v0
        li $t8, 0 # Índice
        
loop:
	jal leitura               
	blez $v0, finalizar_loop  
	addi $t8, $t8, 1 
	
	# Loop
	j loop
            
finalizar_loop:
        # Fechando arquivo
        li $v0, 16  
        move $a0, $s0  
        syscall    

	# Abrindo arquivo
        li $v0, 13
        la $a0, arquivo
        li $a1, 0 
        syscall
        
        # Analisa se deu erro para abrir arquivo
        bltz $v0, deu_erro_2 
        j sem_erro_2
        
deu_erro_2:
	# Imprimindo que deu erro
	li $v0, 4 
	la $a0, erro
	syscall             
	
	# Finalizar
	li $v0, 10 
	syscall   
	
sem_erro_2:
        move $s0, $v0          

	# Alocação
        li $t0, 4  
        mult $t8, $t0  
        mflo $t0 
        add $a0, $0, $t0
        li  $v0, 9
        syscall

        move $t9, $v0 
        li $t0, 0
        
loop2:
	jal leitura  
	                
	blez $v0, finalizar_loop2  
	
	move $t2, $t9 
	sll $t1, $t0, 2        
	add $t2, $t2, $t1       
	sw $v0, 0($t2)        
	addi $t0, $t0, 1 # Incrementa
	
	# Loop
	j loop2
	
finalizar_loop2:
        # Fechando arquivo
        li $v0, 16      
        move $a0, $s0    
        syscall 

	# Imprimindo mensagem 1
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
        li  $v0, 4
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
        
       	# Imprimindo inteiro
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
        
        # Imprimindo inteiro
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
        syscall               

	# Imprimindo mensagem 7
        li $v0, 4    
        la $a0, str7
        syscall       
                      
        move $a0, $t9    
        move $a1, $t8     
        
        jal procedimento_G
        syscall              

	# Imprimindo mensagem 8
        li $v0, 4  
        la $a0, str8
        syscall 
                          
        move $a0, $t9     
        move $a1, $t8       
        
        jal procedimento_H
        
        # Imprimindo inteiro
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
        
        # Imprimindo inteiro
        move $a0, $v0 
        li $v0, 1
        syscall
	
	# Finalizar
        li $v0, 10
        syscall

leitura:
	# Realizando a leitura
	li $v0, 14
	syscall  
                     
	jr $ra # Voltando para a função principal
	
procedimento_I: # i) o número de caracteres do arquivo;
	# Abrindo arquivo
	li $v0, 13  
	la $a0, arquivo    
	li $a1, 0     
	syscall  
	                      
	move $s0, $v0       

	li $t0, 0           
	li $t1, 1    
	
loopI:
	# Realizando a leitura
	li $v0, 14    
	move $a0, $s0        
	la $a1, buffer   
	li $a2, 1
	syscall 
	
	beq $v0, $zero, finalizar_loopI 
	addi $t0, $t0, 1 # Incrementa
	
	j loopI
	
finalizar_loopI:
	# Fechando arquivo
	li $v0, 16         
	move $a0, $s0         
	syscall                       

	move $v0, $t0      
	jr $ra # Voltando para a função principal

procedimento_A: # a) o maior valor;
	move $t0, $zero   
	li $t1, 0
	
loopA:
        lw $t2, 0($a0)  
        bge $t2, $t0, eh_maior
        
        j pulaA
        
eh_maior:
	move $t0, $t2
            
pulaA:
        addi $t1, $t1, 1 # Incrementa
        addi $a0, $a0, 4
        blt $t1, $a1, loopA
	move $v0, $t0
	
	jr $ra # Voltando para a função principal
	
procedimento_B: # b) o menor valor;
	move $t0, $zero 
	li $t1, 0  
	
loopB:
        lw $t2, 0($a0) 
        ble $t2, $t0, eh_menor 
        
        j pulaB     
        
eh_menor:
	move $t0, $t2 
	
pulaB:
        addi $t1, $t1, 1 # Incrementa
        addi $a0, $a0, 4   
        blt $t1, $a1, loopB
	move $v0, $t0 
	
	jr $ra # Voltando para a função principal
	
procedimento_D: # d) o número de elementos pares;
	li $t0, 0 	
	li $t1, 0 	
	
loopD:
        lw $t2, 0($a0) 	
        andi $t3, $t2, 1 # Incrementa	
        beq $t3, $zero, pulaD 	
        addi $t0, $t0, 1 	
        
pulaD:
        addi $t1, $t1, 1 # Incrementa	
        addi $a0, $a0, 4 
        blt $t1, $a1, loopD  
	move $v0, $t0  
	
	jr $ra # Voltando para a função principal

procedimento_C: # c) o número de elementos ímpares;
	li $t0, 0	
	li $t1, 0 	
	
loopC:
        lw $t2, 0($a0)  
        andi $t3, $t2, 1 # Incrementa
        bne $t3, $zero, pulaC 
        addi $t0, $t0, 1  # Incrementa
        
pulaC:
        addi $t1, $t1, 1  # Incrementa
        addi $a0, $a0, 4 
        blt $t1, $a1, loopC 
	move $v0, $t0 
	
	jr $ra # Voltando para a função principal

procedimento_E: # e) a soma dos valores;
	li $t0, 0    
	li $t1, 0         
	
loopE:
        lw $t2, 0($a0)  
        add $t0, $t0, $t2 
        addi $t1, $t1, 1  # Incrementa
        addi $a0, $a0, 4  
        blt $t1, $a1, loopE 
	move $v0, $t0         
	
	jr $ra # Voltando para a função principal

procedimento_F: # f) os valores em ordem crescente;
	li $t0, 0 
	li $t1, 0  
	
	# Imprimindo mensagem 6
	li $v0, 4 
	la $a0, str6 
	syscall 
	
loopF:
        lw $t2, 0($a0)
        
        # Imprimindo inteiro
        li $v0, 1
        move $a0, $t2
        syscall       
        
        # Imprimindo
        li $v0, 4           
        la $a0, buffer
        syscall           
        
        addi $t1, $t1, 1 # Incrementa
        addi $a0, $a0, 4  
        blt $t1, $t8, loopF 
        
        # Imprimindo
	li $v0, 4 
	la $a0, buffer
	syscall      
	
	jr $ra # Voltando para a função principal

procedimento_G: # g) os valores em ordem decrescente;
	li $t0, 0
	li $t1, 0
	
	# Imprimindo mensagem 7
	li $v0, 4 
	la $a0, str7     
	syscall             
	
	sub $a0, $a0, 4
	
loopG:
        lw $t2, 0($a0)    
        
        # Imprimindo inteiro
        li $v0, 1
        move $a0, $t2
        syscall   
        
        # Imprimindo
        li $v0, 4
        la $a0, buffer 
        syscall  
        
        addi $t1, $t1, 1 # Incrementa
        sub $a0, $a0, 4
        blt $t1, $t8, loopG
        
        # Imprimindo
	li $v0, 4
	la $a0, buffer       
	syscall            
    
	jr $ra # Voltando para a função principal

procedimento_H: # h) o produto dos elementos;
	li $t0, 1  
	li $t1, 0    
	
loopH:
        lw $t2, 0($a0)  
        
        mul $t0, $t0, $t2
        addi $t1, $t1, 1 # Incrementa
        addi $a0, $a0, 4 
        blt $t1, $t8, loopH  
	move $v0, $t0 
    
	jr $ra # Voltando para a função principal