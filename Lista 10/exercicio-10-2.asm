.data
prompt_k: .asciiz "Digite o valor de k: "
prompt_n: .asciiz "Digite o valor de n: "
result: .asciiz "%d elevado a %d é igual a %d\n"
error_message: .asciiz "Por favor, insira inteiros positivos para k e n.\n"

.text
.globl main
main:
    # Solicita ao usuário o valor de k
    li $v0, 4
    la $a0, prompt_k
    syscall

    # Lê o valor de k
    li $v0, 5
    syscall
    move $s0, $v0 # salva k em $s0

    # Solicita ao usuário o valor de n
    li $v0, 4
    la $a0, prompt_n
    syscall

    # Lê o valor de n
    li $v0, 5
    syscall
    move $s1, $v0 # salva n em $s1

    # Verifica se k e n são inteiros positivos
    bltz $s0, error
    bltz $s1, error

    # Calcula k^n
    move $a0, $s0
    move $a1, $s1
    jal potencia

    # Imprime o resultado
    move $a2, $v0
    li $v0, 1
    syscall

    # Imprime a mensagem final
    li $v0, 4
    la $a0, result
    syscall

    # Termina o programa
    li $v0, 10
    syscall

potencia:
    # Procedimento recursivo para calcular k^n
    # $a0 = k, $a1 = n
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a1, 0($sp)

    # Caso base: n = 0
    beq $a1, $zero, potencia_base

    # Caso base: n = 1
    li $v0, $a0
    lw $ra, 4($sp) # recupera ra
    addi $sp, $sp, 8
    jr $ra

    # Chamada recursiva: k * potencia(k, n - 1)
    addi $a1, $a1, -1
    jal potencia
    lw $a1, 0($sp) # recupera n
    lw $ra, 4($sp) # recupera ra
    addi $sp, $sp, 8
    mul $v0, $a0, $v0
    jr $ra

potencia_base:
    li $v0, 1 # k^0 = 1
    lw $ra, 4($sp) # recupera ra
    addi $sp, $sp, 8
    jr $ra

error:
    # Imprime a mensagem de erro
    li $v0, 4
    la $a0, error_message
    syscall

    # Termina o programa com código de erro
    li $v0, 10
    syscall