# Calcula o próximo número pseudo-randômico através da fórmula (Z * U + I) mod M
# Z representa uma constante de multiplicação
# U representa o último número gerado (ou então a semente)
# I representa uma constante de incremento
# M representa um módulo constante
# Esta função assume que os argumentos estão em $a0, $a1, $a2 e $a3 e todos são
# números inteiros positivos (portanto não seta o bit de estouro ou overflow) 

mulu $r2, $a0, $a1                                    # Z * U
addu $r2, $a2, $r2                                    # Z * U + I
divu $r3, $r2, $a3
mulu $r3, $a3, $r3
subu $v0, $r2, $r3                                    # (Z * U + I) mod M

