.data
prompt_n: .asciiz "Digite o valor de n: "
alphabet: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
newline: .asciiz "\n"
comma: .asciiz ", "

.text
.globl main
main:
    # Solicita ao usuário o valor de n
    li $v0, 4
    la $a0, prompt_n
    syscall

    # Lê o valor de n
    li $v0, 5
    syscall
    move $s0, $v0 # salva n em $s0

    # Verifica se n é um número positivo
    blez $s0, error

    # Calcula o número de combinações possíveis (n!)
    move $t0, $s0
    move $t1, $s0
    li $t2, 1 # inicializa o fatorial com 1
    factorial_loop:
        subi $t0, $t0, 1
        bgtz $t0, factorial_loop
        mul $t2, $t2, $t1 # fatorial *= n
        subi $t1, $t1, 1
    move $s1, $t2 # salva o fatorial em $s1

    # Inicializa o array de índices para as combinações
    move $t3, $s0 # $t3 contém o valor de n
    li $t4, 0 # inicializa o índice atual com 0
    li $t5, 1 # inicializa o índice do próximo elemento com 1

    # Loop para gerar as combinações
    combinations_loop:
        blt $t4, $t3, print_combination # se o índice atual < n, imprime a combinação
        j end_combinations_loop # senão, termina o loop

    print_combination:
        # Imprime a combinação atual
        move $a0, $t4 # carrega o índice atual
        move $a1, $a0 # carrega o índice atual
        li $v0, 4
        la $a0, alphabet
        syscall # imprime a letra correspondente ao índice atual
        li $v0, 4
        la $a0, comma
        syscall # imprime a vírgula
        move $a0, $t5 # carrega o índice do próximo elemento
        move $a1, $a0 # carrega o índice do próximo elemento
        li $v0, 4
        la $a0, alphabet
        syscall # imprime a letra correspondente ao índice do próximo elemento
        li $v0, 4
        la $a0, newline
        syscall # imprime uma nova linha
        addi $t4, $t4, 1 # incrementa o índice atual
        addi $t5, $t5, 1 # incrementa o índice do próximo elemento
        j combinations_loop # volta ao início do loop

    end_combinations_loop:
        # Termina o programa
        li $v0, 10
        syscall

error:
    # Imprime a mensagem de erro
    li $v0, 4
    la $a0, error_message
    syscall

    # Termina o programa com código de erro
    li $v0, 10
    syscall