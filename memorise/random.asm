## Contém procedimentos para a geração dos números randômicos utilizados no jogo.

# Define uma constante que representa o maior valor possível para os números gerados pelo jogo. 
.eqv max_value 100	

# Procedimento que cria uma seed para o algorítmo de geração de números randômicos a partir da data atual do sistema.
# Estabelece-se que o id do gerador de números pseudo randômicos será 1.
# Esse id deverá ser utilizado pela syscall que gerará os números randômicos propriamente ditos.
.macro set_seed
	# carrega o time service.
	li $v0, 30
	# A syscall gerará um valor de 64 bits que corresponde a data atual do sistema em milisegundos.  
	syscall

	# Move os 32 bits menos significativos do tempo para o registrador $a1 (o segundo argumento para a syscall posterior). 
	move $a1, $a0
	# Carrega a syscall set seed.
	li $v0, 40
	# Define o id para o gerador de números randômicos.
	li $a0, 1
			syscall
	.end_macro

# Procedimento que gera números aleatórios e os armazena na memória (no endereço indicado pelo parâmetro $target).
.macro generate_random_numbers($target, $length)
	la $t0, $target # ponteiro para o array na memória.
	move $t1, $length # contador para o loop.

	loop_random:
		# id do gerador de números randômicos definido na subrotina set_seed.
		li $a0, 1 
		li $a1, max_value # o valor limite para o intervalo.  
		li $v0, 42 # carrega o random int range service.
		syscall
		sw $a0, 0 ($t0) # armazena o número aleatório na memória.
				sub $t1, $t1, 1 # decrementa o contador.
		addi $t0, $t0, 4 # incrementa o "ponteiro".
		bne $t1, $0, loop_random
.end_macro
