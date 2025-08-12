.data
	mensagem_entrada: .asciiz "Digite o nome do arquivo de entrada: "
	entrada: .space 50
	saida: .asciiz "output.txt"
	erro: .asciiz "Erro para abrir o arquivo\n"
	mem: .space 1

.text
main:
	# Nomde do Arquivo
	li $v0, 4              
	la $a0, mensagem_entrada
	syscall

	# Lendo o nome
	li $v0, 8              
	la $a0, entrada
	li $a1, 49          
	syscall

	li $t0, 0            
	move $t1, $a0        

tamanho:
	# Carrega caractere
        lb $t2, ($t1)
        
        # Fim da string
        beqz $t2, fim_string
        
        addi $t1, $t1, 1 # Próx
        addi $t0, $t0, 1 # Incrementa
        
        j tamanho

fim_string:
	addi $t0, $t0, -1
	add $t1, $a0, $t0 
	sb $zero, ($t1) # Para o último caractere

	# Abrindo o arquivo
	li $v0, 13
	la $a0, entrada 
	li $a1, 0
	syscall
    
    	# Analisa se deu erro para abrir o arquivo
    	bltz $v0, deu_erro 
    	move $s0, $v0          

	# ...
	li $v0, 13           
	la $a0, saida 
	li $a1, 1           
	syscall
	
	# Analisa se deu erro para abrir o arquivo
	bltz $v0, deu_erro 
	move $s1, $v0
	li $t2, '*'

loop:
	# Lendo arquivo
 	li $v0, 14            
	move $a0, $s0         
	la $a1, mem        
	li $a2, 1           
	syscall

	blez $v0, fim_arquivo
	lb $t3, ($a1)
    
    	# Para as letras minúsculas
	beq     $t3, 'a', substituir
	beq     $t3, 'e', substituir
	beq     $t3, 'i', substituir
	beq     $t3, 'o', substituir
	beq     $t3, 'u', substituir
	
	# Para as letras maiúsculas
	beq     $t3, 'A', substituir
	beq     $t3, 'E', substituir
	beq     $t3, 'I', substituir
	beq     $t3, 'O', substituir
	beq     $t3, 'U', substituir
	
	j continuar_loop # Reinicia

substituir:
	sb $t2, ($a1) # Substituindo a vogal por *

continuar_loop:
	# Escrevendo no arquivo
	li $v0, 15             
	move $a0, $s1         
	la $a1, mem         
	li $a2, 1        
	syscall

	j loop # Continua

fim_arquivo:
    # Fechar arquivos
    li $v0, 16            
    move $a0, $s0           
    syscall

    # ...
    li $v0, 16          
    move $a0, $s1           
    syscall                     

    # Finaliza
    li $v0, 10           
    syscall

deu_erro:
    # Erro
    li $v0, 4              
    la $a0, erro
    syscall
    
    # Finaliza
    li $v0, 10   
    syscall
