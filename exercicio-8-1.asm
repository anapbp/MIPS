.data
	str1: .asciiz "Valor de n: "
	pulaLinha: .asciiz " \n"
	traco: .asciiz " --- "
	erro: .asciiz "Erro para abrir arquivo\n"
	Arq: .asciiz "gemeos-ex1.txt"
	mem: .space 20
    
.text
main:
	# Abrir o arquivo
        li $v0, 13      
        la $a0, Arq 
        li $a1, 1    
        syscall
        
        bltz $v0, com_erro # Analise de erro
        j sem_erro  # Caso não deu erro
        
com_erro: # Deu erro
	# Mensagem de erro
	li $v0, 4		
	la $a0, erro
	syscall
            
	# Finaliza						
	addi $v0, $0, 10		
	syscall
            					
sem_erro: # Sem erro
        move $s5, $v0

	# Imprime mensagem 1
        li $v0, 4	
        la $a0, str1
        syscall						

	# Lendo valor inteiro
        li $v0, 5		
        syscall						
        move $s0, $v0	
	
analise_gemeo:
        subi $s2, $s0, 2
        li $s1, 2
        
loop_analise:
        bgt $s1, $s2, finaliza_loop # Ve se finalzia o loop
        
        jal ehPrimo # Eh primo
        beqz $v0, caso_nao_loop1 # Nao eh primo
        
        addi $s3, $s1, 2   
        jal ehPrimo # Eh primo
        
        bnez $v0, caso_loop1 
        j caso_nao_loop1 
        
caso_loop1:
	move $a0, $s1   # $a0 = $s1
	jal imprimir_valor   # Imprime $s1
            
	la $a1, traco
	li $a2, 3
	li $v0, 15      # Código para escrita em arquivo
	syscall         # Escreve o " - " no arquivo
            
	move $a0, $s3   # $a0 = $s3
	jal imprimir_valor   # Imprime $s3
            
	# Pulando uma linha no arquivo
	la $a1, pulaLinha
	li $a2, 2
	li $v0, 15     
	syscall      
        
caso_nao_loop1:
        addi $s1, $s1, 1   # incrementa variável auxiliar
        j loop_analise # Reinicia
        
finaliza_loop:
	# Fechando arquivo
	li $v0, 16       
	move $a0, $s5    
	syscall

	# Finaliza
	li $v0, 10      
	syscall

ehPrimo:
	li $t0, 1
	ble $a0, $t0, eh_menor
	j continua_analise_primo
    
eh_menor:
	li $v0, 0 # Return False
	j fim

continua_analise_primo:
	li $t1, 2          
	
loop1:
        mul $t2, $t1, $t1   
        bgt $t2, $a0, fim_loop 
        div $a0, $t1
        mfhi $t3
        beqz $t3, eh_divisivel
        j fim_eh_divisivel
        
eh_divisivel:
	li $v0, 0 # Falso
	j fim
            
fim_eh_divisivel:
	addi $t1, $t1, 1 # Incrementa
        j loop1
        
fim_loop:
	li $v0, 1 # Verdadeiro

fim:
	jr $ra # Volta para a função

imprimir_valor:
	move $a3, $ra           
	la $a1, mem
	li $v0, 0
	li $t2, 0
    
convertendo_valores:
	div $a0, $a0, 10        
	mfhi $t3               
	subi $sp, $sp, 4
	sw $t3, ($sp)            
	li $v0, 1       
	bnez $a0, convertendo_valores   # Reinicia

loop_convertendo:
        lw $t3, ($sp)      
        addi $sp, $sp, 4

	# Convertendo unidades para caracteres
        add $t3, $t3, 48   
        sb $t3, ($a1)
        addi $a1, $a1, 1    
        addi $t2, $t2, 1 # Incrementa
        bne $t2, $v0, loop_convertendo  # Reinicia

        sb $zero, ($a1)

continua:
	move $a0, $s5   
	la $a1, mem
	
	# Escrevendo no arquivo
	move $a2, $v0
	li $v0, 15             
	syscall       

	jr $a3 # Volta para a função