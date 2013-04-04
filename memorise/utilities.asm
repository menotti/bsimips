## Contém procedimentos utilitários diversos para uso no jogo.

# Procedimento para imprimir a string informada como argumento.
.macro print_string($arg)
	.data
		the_string: .asciiz $arg
	.text
	la $a0, the_string 
		li $v0, 4
		syscall
.end_macro

# Procedimento para a impressão da sequência de números informada como argumento.
.macro print_numbers($sequence, $size)
	la $t0, $sequence # carrega o primeiro endereço da sequência de números 
	lw $t1, $size # contador do loop.

	loop_print_numbers:
		lw $a0, 0 ($t0) # carrega o número atual.
		li $v0, 1
		syscall
		print_string(" ") # imprime um espaço entre os números
		addi $t0, $t0, 4 # incrementa o ponteiro para o array.
		sub $t1, $t1, 1 # decrementa o contador.
		bne $t1, $0, loop_print_numbers
.end_macro

# Procedimento que simula uma função de limpeza do output.
# Na verdade, apenas imprimimos o caracter \n por repetidas vezes para que o conteúdo anterior desapareça.   
.macro clear
	li $t0, 1000

	loop_clear:
		sub $t0, $t0, 1
		print_string("\n")
			bne $t0, $0, loop_clear
.end_macro

# Subrotina para encerrar o programa.
.macro exit_program
	li $v0, 10
	syscall
	.end_macro
