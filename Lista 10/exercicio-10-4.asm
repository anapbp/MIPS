.data
prompt_n: .asciiz "Digite o valor de n: "
prompt_a: .asciiz "Digite o valor de a: "
prompt_b: .asciiz "Digite o valor de b: "
result: .asciiz "Os %d primeiros inteiros positivos múltiplos de %d ou %d ou ambos são:\n"
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

    # Solicita ao usuário o valor de a
    li $v0, 4
    la $a0, prompt_a
    syscall

    # Lê o valor de a
    li $v0, 5
    syscall
    move $s1, $v0 # salva a em $s1

    # Solicita ao usuário o valor de b
    li $v0, 4
    la $a0, prompt_b
    syscall

    # Lê o valor de b
    li $v0, 5
    syscall
    move $s2, $v0 # salva b em $s2

    # Verifica se n, a e b são números positivos
    blez $s0, error
    blez $s1, error
    blez $s2, error

    # Imprime o cabeçalho
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    li $v0, 4
    la $a0, result
    syscall

    # Inicializa o contador de múltiplos
    li $t0, 0 # contador
    li $t1, 1 # valor atual

    # Loop para encontrar e imprimir os múltiplos
    find_multiples_loop:
        blt $t0, $s0, print_multiple # se o contador < n, imprime o múltiplo
        j end_find_multiples_loop # senão, termina o loop

    print_multiple:
        # Verifica se o valor atual é múltiplo de a ou b
        move $a0, $t1
        move $a1, $s1
        move $a2, $s2
        jal is_multiple
        move $t2, $v0 # armazena o resultado em $t2

        # Se o valor atual é múltiplo de a ou b, imprime-o
        bnez $t2, print_value

        # Incrementa o valor atual
        addi $t1, $t1, 1
        j find_multiples_loop

    print_value:
        # Imprime o valor atual
        move $a0, $t1
        li $v0, 1
        syscall

        # Incrementa o contador
        addi $t0, $t0, 1
        addi $t1, $t1, 1
        j find_multiples_loop

    end_find_multiples_loop:
        # Imprime uma nova linha
        li $v0, 4
        la $a0, newline
        syscall

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

# Função para verificar se um número é múltiplo de outro
is_multiple:
    # $a0 = número, $a1 = divisor, $a2 = segundo divisor
    move $t0, $a0
    div $t0, $a1
    mfhi $t1
    move $t2, $t1
    move $t0, $a0
    div $t0, $a2
    mfhi $t1
    or $v0, $t1, $t2
    jr $ra
