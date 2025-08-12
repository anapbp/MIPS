.data
prompt_N: .asciiz "Digite o valor de N: "
result: .asciiz "O %d-ésimo número de Catalan é %d\n"
error_message: .asciiz "Por favor, insira um número inteiro positivo.\n"

.text
.globl main
main:
    # Solicita ao usuário o valor de N
    li $v0, 4
    la $a0, prompt_N
    syscall

    # Lê o valor de N
    li $v0, 5
    syscall
    move $s0, $v0 # salva N em $s0

    # Verifica se N é um número positivo
    blez $s0, error

    # Calcula o N-ésimo número de Catalan
    move $a0, $s0
    jal catalan

    # Imprime o resultado
    move $a1, $v0
    move $a0, $s0
    li $v0, 4
    la $a0, result
    syscall

    # Termina o programa
    li $v0, 10
    syscall

# Procedimento recursivo para calcular o N-ésimo número de Catalan
# $a0 = N
catalan:
    beq $a0, $zero, catalan_base # Caso base: N = 0
    subi $a0, $a0, 1 # Decrementa N
    jal catalan # Chama recursivamente catalan(N - 1)
    move $t0, $v0 # Salva o resultado da chamada recursiva

    move $a0, $t0 # Prepara o argumento para o cálculo de catalan(N - 1)
    subi $a0, $a0, 1 # Decrementa N
    jal catalan # Chama recursivamente catalan(N - 2)
    move $t1, $v0 # Salva o resultado da chamada recursiva

    add $v0, $t0, $t1 # Calcula o N-ésimo número de Catalan
    jr $ra

catalan_base:
    li $v0, 1 # Caso base: Primeiro número de Catalan é 1
    jr $ra

error:
    # Imprime a mensagem de erro
    li $v0, 4
    la $a0, error_message
    syscall

    # Termina o programa com código de erro
    li $v0, 10
    syscall
