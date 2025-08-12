.data
prompt_N: .asciiz "Digite um número: "
result: .asciiz "O %d-ésimo hiperfatorial é %llu\n"
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

    # Calcula o hiperfatorial de N
    move $a0, $s0
    jal hiperfatorial

    # Imprime o resultado
    move $a1, $v0
    li $v0, 1
    syscall

    # Imprime a mensagem final
    move $a0, $s0
    move $a1, $v0
    li $v0, 4
    la $a0, result
    syscall

    # Termina o programa
    li $v0, 10
    syscall

hiperfatorial:
    # Procedimento recursivo para calcular o hiperfatorial
    # $a0 = N
    beq $a0, $zero, hiperfatorial_base # Caso base: N = 0
    subi $a0, $a0, 1 # Decrementa N
    jal hiperfatorial # Chama recursivamente hiperfatorial(N - 1)
    move $t0, $v0 # Salva o resultado da chamada recursiva
    move $a0, $t0 # Prepara o argumento para calcular o fatorial
    jal fatorial # Calcula o fatorial de T0
    move $v0, $t0 # Retorna o resultado do hiperfatorial

hiperfatorial_base:
    li $v0, 1 # Caso base: Hiperfatorial de 0 é 1
    jr $ra

fatorial:
    # Procedimento recursivo para calcular o fatorial
    # $a0 = N
    beq $a0, $zero, fatorial_base # Caso base: N = 0
    subi $a0, $a0, 1 # Decrementa N
    jal fatorial # Chama recursivamente fatorial(N - 1)
    mul $v0, $a0, $v0 # Calcula o fatorial de N = N * fatorial(N - 1)
    jr $ra

fatorial_base:
    li $v0, 1 # Caso base: Fatorial de 0 é 1
    jr $ra

error:
    # Imprime a mensagem de erro
    li $v0, 4
    la $a0, error_message
    syscall

    # Termina o programa com código de erro
    li $v0, 10
    syscall
