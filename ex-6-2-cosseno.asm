.data
	d1: .double 1.0
	dneg: .double -1.0
	str1: .asciiz "---> X em radianos: "
	str2: .asciiz "---> Quantidade de termos: "
	str3: .asciiz "---> Cos("
	str4: .asciiz "): "
    
.text

main:
	# realiza a leitura do valor x e da quantidade de termos
	jal leitura

	# realiza aproximação do cosseno
        jal calcular_cos	
        
        # realiza a escrita da aproximação do cosseno
        jal escrita					

	# Finalizar
        li $v0, 10
        syscall					

leitura:
	# imprime a mensagem 1
        la $a0, str1
        li $v0, 4
        syscall

	# ler valor real
        li $v0, 7		
        syscall						

	# imprime a mensagem 2
        la $a0, str2
        li $v0, 4
        syscall

	# ler valor inteiro
        li $v0, 5
        syscall
        move $s0, $v0
        
        jr $ra # volta para a main

escrita:
	# imprime a mensagem 3
        li $v0, 4		
        la $a0, str3
        syscall						

	# imprime os radianos
        li $v0, 3		
        mov.d $f12, $f0
        syscall	

	# imprime a mensagem 4
        li $v0, 4		
        la $a0, str4
        syscall						
        
        # imprime o resultado da aproximação
        li $v0, 3		
        mov.d $f12, $f2
        syscall	
        
	jr $ra # volta para a main

calcular_cos:
	l.d $f12, dneg
        l.d $f14, dneg
        l.d $f2, d1
        l.d $f4, d1
        li $t0, 1 # índice i = 1
        
loop:
        bgt $t0, $s0, finalizar # analisa se acabou o loop
        mul $t1, $t0, 2	 
        
        mtc1.d $t1, $f6
        cvt.d.w $f6, $f6        
        add.d $f8, $f6, $f12       
        
        mul.d $f10, $f0, $f0 # numerador
        mul.d $f6, $f6, $f8 # denominador
        div.d $f10, $f10, $f6  # numerador/denominador
        mul.d $f4, $f4, $f10 

        mul.d $f10, $f14, $f4
        add.d $f2, $f2, $f10
        mul.d $f14, $f14, $f12
            
        addi $t0, $t0, 1 # incrementa i
	j loop
            
finalizar:
        jr $ra # volta para a main