# Aluna: Ana Paula Barbosa Pereira
# Atividade n2, exercício 1

.data
ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "Insira a stribg 2: "
ent3: .asciiz "String intercalada: "
str1: .space 100
str2: .space 100
str3: .space 200

.text
main:
	la $a0, ent1 # a0 recebeu mensagem 1
	la $a1, str1 # a1 recebeu string 1
	jal leitura 
	
	la $a0, ent2 # a0 recebeu mensagem 2
	la $a1, str2 # a1 recebeu string 2
	jal leitura
	
	la $a0, str1 # a0 recebeu string 1
	la $a1, str2 # a1 recebeu string 2
	la $a2, str3 # a2 recebe string 3
	
	jal intercala
	
	# imprime a mensagem 3
	la $a0, ent3 # a0 recebeu a mensagem 3
	li $v0, 4
	syscall
	
	# imprime o resultado (a String intercalada)
	la $a0, str3 # a0 recebeu string 3
	li $v0, 4
	syscall
	
	li $v0, 10 # finaliza
	syscall # ...

leitura:
	li $v0, 4 # imprime mensagem em a0
	syscall # ...
	
	move $a0, $a1 # a0 recebe a1
	
	li $a1, 100 # tamanho máximo da string
	li $v0, 8 # leitura da string
	syscall # ...
	
	jr $ra # voltando para a funcao inicial

intercala:
	li $t0, 1
	li $t1, 1
	
loop:
	bne $t0, 0, passo_1 # se $t0 nao for igual a 0, entao a string 1 nao foi intercalada por completo
	
continua:
	bne $t1, 0, passo_2 # se $t1 nao for igual a 0, entao a string 2 nao foi intercalada por completo
	
	jr $ra # voltando para a funcao inicial
	
passo_1:
	lb $t0, 0($a0) # carrega o próximo valor da String 1
	addi $a0, $a0, 1 
	beqz $t0, incrementa_aux0 # se for igual a 0, muda o registrador t0 em 0 e volta para o loop
	beq $t0, 10, incrementa_aux0 # outro caso para caso for o final da string 1
	# senao, ocorre a intercalação
	sb $t0, 0($a2)  # armazena o caractere na terceira string
        addi $a2, $a2, 1 # avança o ponteiro da terceira string
        
	j continua
	
incrementa_aux0: 
	li $t0, 0 # mostra que a String 1 foi intercalada por completo
	j loop

passo_2:
	lb $t1, 0($a1) # carrega o próximo valor da String 1
	addi $a1, $a1, 1 
	beqz $t1, incrementa_aux1 # se for igual a 0, muda o registrador t1 em 0 e volta para o loop
	beq $t1, 10, incrementa_aux1 # outro caso para caso for o final da string 2
	# senao, ocorre a intercalação
	sb $t1, 0($a2)  # armazena o caractere na terceira string
        addi $a2, $a2, 1 # avança o ponteiro da terceira string
        
	j loop

incrementa_aux1:
	li $t1, 0  # mostra que a String 2 foi intercalada por completo
	j loop
