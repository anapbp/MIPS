.data
    str1: .asciiz "Número n de elementos na sequência: "
    str2: .asciiz "Sequência de números:\n"
    str3: .asciiz " ---> "
    str4: .asciiz " vezes\n"
    
.text

main:
	# imprime a mensagem 1
        la $a0, str1    
        li $v0, 4          
        syscall
        
        # leitura do número n
        li $v0, 5          
        syscall
        move $t4, $v0 # $t4 = n
        
        li $t0, 4 
        mult $t4, $t0
        mflo $t0
        
        # alocação dinâmica
        add $a0, $0, $t0
        li $v0, 9
        syscall				
        move $t5, $v0 # $t5 recebe o endereço do vetor

	# imprime mensagem 2
        la $a0, str2   
        li $v0, 4
        syscall

        li $t0, 0 # índice i
        
        # realiza do vetor de números reais
        j leitura
        
continua:
	# realiza a ánalise do exercício proposto
        jal analise_sequencia
        
        # escreve resultados
        j escrita
        
        # finalizar
        li $v0, 10
        syscall			
        
leitura:
        bge $t0, $t4, fim_leitura # analisa se leu todos os números n

        move $t2, $t5 # $t2 = endereço do vetor
        mul $t1, $t0, 4
        add $t2, $t2, $t1 # anda na posição do vetor
        li $v0, 6
        syscall
        s.s $f0, 0($t2)
        # incrementa índice i
        addi $t0, $t0, 1
        j leitura # volta para o loop
        
fim_leitura:
        move  $a0, $t5 # $a0 = endereço do vetor
        move  $a1, $t4
        j continua
          
escrita:
        li $s2, 1
        li $t0, 1 # índice auxiliar
        
loop_escrita:
        bge $t0, $t4, fim_loop_escrita # analisa se índice chegou ao fim
        move $t2, $t5
        mul $t1, $t0, 4
        add $t2, $t2, $t1 # anda no vetor
        l.s $f0, 0($t2)
        l.s $f1, -4($t2)

        c.eq.s $f0, $f1
        bc1t loop1 # incrementa $s2
        j loop2	# 
        
loop1:
        addi $s2,$s2,1 # incrementa
        j fim_loop2
         
loop2:
	# imprime float
        li $v0, 2		
        mov.s $f12, $f1
        syscall						
	
	# imprime mensagem 3
        li $v0, 4		
        la $a0, str3
        syscall						

	# imprime inteiro (ocorrências)
        li $v0, 1		
        add $a0, $0, $s2
        syscall						

	# imprime mensagem 4
        li $v0, 4	
        la $a0, str4
        syscall					
                
        li $s2, 1
                
fim_loop2:
        addi $t0, $t0, 1 # incrementa índice auxiliar
        j loop_escrita # volta
            										
fim_loop_escrita:
        
        # imprimir float
        li $v0, 2
        mov.s $f12, $f1
        syscall					

	# imprimir mensagem 3
        li $v0, 4	
        la $a0, str3
        syscall						

	# imprimir inteiro (ocorrências)
        li $v0, 1
        add $a0, $0, $s2
        syscall						

	# imprimir a mensagem 4
        li $v0, 4	
        la $a0, str4
        syscall					

	# Finalizar
        addi	$v0, $0, 10		
        syscall				

analise_sequencia:
        subi $a1, $a1, 1 # índice n
        li $t0, 0 # índice i auxiliar
        
for_externo:
        bge $t0, $a1, finalizar # vê se já analisou todo o vetor, se sim, finaliza
        # senão
        li $t1, 0 # auxiliar
        sub $t2, $a1, $t0
        
loop_sequencia:
        bge $t1, $t2, finaliza_loop_sequencia

        mul $t3, $t1, 4	
        add $t3, $t3, $a0
        l.s $f0, 0($t3) # carrega vetor
        l.s $f1, 4($t3) # carrega o próximo elemento do vetor
        c.lt.s $f0, $f1	# se vet[j] > vet[j+1] ---> incrementa $t1
        bc1f carregar
        # senão
        j incrementar
        
carregar: 
        s.s $f1, 0($t3)
        s.s $f0, 4($t3)
                    
incrementar: 
        addi $t1, $t1, 1 # incrementar auxiliar
        j loop_sequencia # continua loop
                    				
finaliza_loop_sequencia:
        addi $t0, $t0, 1 # incrementa índice auxiliar
	j for_externo	
            			
finalizar:
	jr $ra # volta para a main
