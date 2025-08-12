.data
	zero: .float 0.0
	bimestres: .float 3.0
	media: .float 6.0
	
	str1: .asciiz "---> Número de alunos: "
	str2: .asciiz "---> Digite as 3 notas (aluno "
	str3: .asciiz " ): "
 	str4: .asciiz "\n ------ Média da Classe: ------\n"
 	str5: .asciiz "\n\n ------ Aprovados: ------\n"
	str6: .asciiz "\n ------ Reprovados: ------\n"
   
.text

main:
	# imprime a mensagem 1
        la $a0, str1   
        li $v0, 4
        syscall

	# le a quantidade de alunos
        li $v0, 5	
        syscall					

        move $s0, $v0
        li $t0, 12
        mult $s0, $t0
        mflo $t0

        # alocacao dinamica
        add $a0, $0, $t0  
        li $v0, 9
        syscall					
        move $t7, $v0 # $t7 recebe o endereco        
        move $a3, $t7 # $a3 também

        li $t0, 0 
        
        j calcula_notas
        
continua_main:

	jal resultados
        
        # Finaliza
         addi	$v0, $0, 10		# System call 10 - Exit
        syscall	
        
calcula_notas:
        bge $t0, $s0, continua_main # ve se leu a nota de todos os alunos
	# imprime a mensagem 2
        li $v0, 4		
        la $a0, str2
        syscall	
        	
        addi $a0, $t0, 1  								
        li $v0, 1		
        syscall	
        
        # imprime a mensagem 3	
        li $v0, 4		
        la $a0, str3
        syscall			

        li $a2, 3
        li $t1, 0 # variável auxiliar
        
# Lerá 3 notas
leitura:
        bge $t1, $a2, fim_leitura # Ve se ja leu as tres notas
            
        # Le nota
        li $v0, 6	
        syscall	
        
        # calcula indice da matriz
        jal matriz
        addi $t1, $t1, 1 # incrementa variável auxiliar
        s.s $f0, 0($v0) # armazena na Matriz
        # depois de lida uma nota, continua no loop      
        j leitura	
        			
fim_leitura: 
        l.s $f1, zero
        
        # soma 1
        li $t1, 0		    
        jal matriz # calcula indice da matriz
        l.s $f0, 0($v0)
        add.s $f1, $f1, $f0

	# soma 2 
        li $t1, 1		    
        jal matriz
        l.s     $f0, 0($v0)
        add.s   $f1, $f1, $f0 

	# soma 3
        li $t1, 2	
        jal matriz
        l.s     $f0, 0($v0)
        add.s   $f1, $f1, $f0   

        l.s $f0, bimestres
        div.s   $f1, $f1, $f0   # ( soma 1 + soma 2 + soma 3 ) / 3 = media

        add.s   $f12, $f12, $f1 # Média da Classe   
        l.s $f0, media
        # analisa se foi aprovado ou reprovado
        c.le.s $f0, $f1
        bc1t aprovado # incrementa auxiliar dos aprovados
        j reprovado # incrementa auxiliar dos reprovados
        
aprovado:
       addi $t8, $t8, 1	
       addi $t0, $t0, 1 
       j calcula_notas
                
reprovado:
       addi $t9, $t9, 1	
       addi $t0, $t0, 1 
       j calcula_notas		
            
matriz:
        mul $v0, $t0, $a2
        add $v0, $v0, $t1
        sll $v0, $v0, 2
        add $v0, $v0, $a3
        
        jr $ra # voltando      			
            							
resultados:
        mtc1.d $s0, $f0
        cvt.s.w $f0, $f0  
        
        # calculando a Media da Classe
        div.s $f12, $f12, $f0

	# imprime mensagem 4
        li $v0, 4	
        la $a0, str4
        syscall					

	# imprime media
        li $v0, 2		
        mov.s $f12, $f12
        syscall					

	# imprime mensagem 5
        li $v0, 4		
        la $a0, str5
        syscall						

	# imprime aprovados
        li $v0, 1
        add $a0, $0, $t8
        syscall					

	# imprime mensagem 6
        li $v0, 4		
        la $a0, str6
        syscall						

	# imprime reprovados
        li $v0, 1	
        add $a0, $0, $t9
        syscall	

       	jr $ra # volta para a main