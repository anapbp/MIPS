.data
    str1: .asciiz "---> Tamanho (n) da sequência: "
    str2: .asciiz "---> Digite a sequência:\n"
    str3: .asciiz "---> A soma do maior segmento é "
    str4: .asciiz " ("
    str5: .asciiz " - "
    str6: .asciiz ")"
    .align 3  # Alinha os próximos dados em uma fronteira de 2^3 = 8 bytes
    max_seg: .space 16  # Tamanho total da estrutura (4 bytes para int + 4 bytes para int + 8 bytes para double)
    atual_seg: .space 16  # Tamanho total da estrutura (4 bytes para int + 4 bytes para int + 8 bytes para double)
    float0: .float 0.0
    
.text

main:
	jal leitura
	jal calcula_maior_segmento
	
	# Resultados
	# Imprime a mensagem 3
	li $v0, 4		
        la $a0, str3
        syscall						
        
        li $v0, 3		# system call #3 - print double
        l.d $f12, max_seg+8
        syscall						

	# Imprime a mensagem 4
        li $v0, 4		
        la $a0, str4
        syscall						

        addi $v0, $0, 3		# system call #3 - print double
        lw $t0, max_seg
        mul $t0, $t0, 8         # 8 bytes por double
        add $t0, $s1, $t0       # Endereço de numeros[i]
        l.d $f12, 0($t0)
        syscall						

        # Imprime a mensagem 5
        li $v0, 4		
        la $a0, str5
        syscall						

        addi $v0, $0, 3		# system call #3 - print double
        lw $t0, max_seg+4
        mul $t0, $t0, 8         # 8 bytes por double
        add $t0, $s1, $t0       # Endereço de numeros[i]
        l.d $f12, 0($t0)
        syscall		
        
        # Imprime a mensagem 6
        li $v0, 4		
        la $a0, str6
        syscall					

	# Finalizar
	li $v0, 10
        syscall		
	
leitura:
	# Imprime a mensagem 1
        li $v0, 4
        la $a0, str1
        syscall

        # Tamanho da sequencia
        li $v0, 5
        syscall
        move $s0, $v0

        li $t0, 8  # double
        mul $t0, $t0, $s0
        move $a0, $t0
        li $v0, 9  # alcacao dinamica
        syscall
        move $s1, $v0  # $s1 = endereço
	
	# Imprime a mensagem 2
        la $a0, str2   
        li $v0, 4  
        syscall

	li $t0, 0 # indice auxiliar
	
loop_leitura:
        bge $t0, $s0, finalizar  # Se i >= n, vai para fim_for
	# Leitura da osição atual	
        mul $t1, $t0, 8 
        add $t2, $s1, $t1  
        li $v0, 7
        syscall
        s.d $f0, 0($t2)
        addi $t0, $t0, 1 # Incrementa indice auxiliar
        # continua loop
        j loop_leitura

finalizar:
	jr $ra # volta para a função principal
            
calcula_maior_segmento:
        l.d $f0, 0($s1)
        s.d $f0, max_seg+8  # Armazena o valor em max_seg+8
        s.d $f0, atual_seg+8  # Armazena o valor em atual_seg+8

        # for(i = 1; i < $s0; i++)
        li $t0, 1 # Inicializa a varíavel contadora i = 1
        for_procura:
            bge $t0, $s0, fim_for_procura # Se i >= $s0 então vai para fim_for
        
            l.d	$f0, atual_seg+8 # atual_seg.soma
            l.d	$f2, float0 # 0.0
            c.lt.d $f0,$f2 # atual_seg.soma < 0
            bc1t if_1
            j else_1	# senão jump para else_1
            if_1:
                
                sw		$t0, atual_seg		    # atual_seg.inicio = i
                sw		$t0, atual_seg+4		# atual_seg.fim = i

                mul $t1, $t0, 8         # 8 bytes por double
                add $t2, $s1, $t1       # Endereço de numeros[i]
                l.d $f4, 0($t2)         # *numeros[i]
                s.d $f4, atual_seg+8    # atual_seg.soma = numeros[i]
            
                j fim_else_1	# jump para fim_else_1
            else_1:
            
                lw		$t1, atual_seg+4		# t1 = atual_seg.fim
                addi    $t1, $t1, 1             # fim++
                sw		$t1, atual_seg+4		# atual_seg.fim++

                mul $t1, $t0, 8         # 8 bytes por double
                add $t2, $s1, $t1       # Endereço de numeros[i]
                l.d $f4, 0($t2)         # *numeros[i]
                add.d $f0, $f0, $f4      # atual_seg.soma += numeros[i]
                s.d  $f0, atual_seg+8    # Atualiza atual_seg.soma
            
            fim_else_1:

            l.d $f2, max_seg+8   # $f2 recebe max_seg.soma
            c.lt.d $f2,$f0 # atual_seg.soma > max_seg.soma
            bc1t if_2
            j fim_if_2  # senão jump para fim_if_2
            if_2:
            
                # max_seg = atual_seg
                lw		$t1, atual_seg
                lw		$t2, atual_seg+4
                l.d     $f0, atual_seg+8

                sw		$t1, max_seg	  # max_seg.inicio = atual_seg.inicio
                sw		$t2, max_seg+4    # max_seg.fim = atual_seg.fim
                s.d     $f0, max_seg+8    # max_seg.soma = atual_seg.soma
            
            fim_if_2:
        
            addi $t0, $t0, 1 # i++
            j for_procura				# jump para for_procura
        fim_for_procura:

        jr		$ra					# jump to $ra
        
