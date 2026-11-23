# Milestone 3 - O Modularizador
# Compilar: gcc milestone3_modularizador.s -o modularizador

.section .data

contentor:
    .long  2000000000
    .long  2000000000
    .long  1500000000
    .long  -500000000
    .long  1000000000
    .long  -250000000
    .long  2100000000
    .long  1750000000

tamanho:
    .long 8

resultado_baixo:
    .long 0
resultado_alto:
    .long 0

.section .bss

.lcomm positivos, 4
.lcomm negativos, 4
.lcomm zeros, 4

.section .text
.globl main

# obter_elemento(indice): devolve contentor[indice] em EAX
obter_elemento:
    pushq %rbp
    movq  %rsp, %rbp
    movl  16(%rbp), %ecx        # indice (parametro na pilha)
    leaq  contentor(%rip), %rdx
    movl  (%rdx,%rcx,4), %eax   # base + indice*4
    movq  %rbp, %rsp
    popq  %rbp
    ret

# classificar(valor): incrementa positivos, negativos ou zeros
classificar:
    pushq %rbp
    movq  %rsp, %rbp
    movl  16(%rbp), %eax        # valor (parametro na pilha)
    cmpl  $0, %eax
    jg    cl_positivo
    jl    cl_negativo
    incl  zeros(%rip)
    jmp   cl_fim
cl_positivo:
    incl  positivos(%rip)
    jmp   cl_fim
cl_negativo:
    incl  negativos(%rip)
cl_fim:
    movq  %rbp, %rsp
    popq  %rbp
    ret

main:
    pushq %rbp
    movq  %rsp, %rbp
    pushq %rbx

    xorl  %ebx, %ebx

ciclo:
    cmpl  tamanho(%rip), %ebx
    jge   fim

    pushq %rbx
    call  obter_elemento
    addq  $8, %rsp

    movl  %eax, %ecx
    cltd
    addl  %eax, resultado_baixo(%rip)   # soma; CF = transporte
    adcl  %edx, resultado_alto(%rip)    # soma o transporte a parte alta

    pushq %rcx
    call  classificar
    addq  $8, %rsp

    incl  %ebx
    jmp   ciclo

fim:
    popq  %rbx
    movl  $0, %eax
    popq  %rbp
    ret

.section .note.GNU-stack,"",@progbits
