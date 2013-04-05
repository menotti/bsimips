## Contém procedimentos necessários para a execução da lógica central do jogo.
 
.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

# Procedimento para imprimir as informações de cada tentativa.
# Parâmetros:
# $level: registrador com o dado correspondente ao nível atual do jogo
# $current_sequence: registrador com o dado da sequência atual
# $sequences: registrador com o número total de sequências
# $time: registrador com o tempo de duração dos números na tela 
.macro print_attempt_info($level, $current_sequence, $sequences, $time)
	sub $sp, $sp, 16  # cria uma stack frame para esse procedimento

	# Armazena os parâmetros na stack para evitar conflitos com os procedimentos posteriores
	sw $level, 0 ($sp)
	sw $current_sequence, 4 ($sp)
	sw $sequences, 8 ($sp)
	sw $time, 12 ($sp) 

	print_string("Nivel ")
	lw $level, 0 ($sp)
	print_integer($level)
	print_string(", sequencia ")
	lw $current_sequence, 4 ($sp) 
	print_integer($current_sequence)
	print_string(" de ")
	lw $sequences, 8 ($sp)
	print_integer($sequences)
	print_string("\n\n")
	print_string("Veja os numeros a seguir com bastante atencao. Voce tera cerca de ")
	lw $time, 12 ($sp)
	print_integer($time)
	print_string(" segundos para memoriza-los.\n\n")
	sleep(2000) # aguarda 2 segundos antes de retornar

	addi $sp, $sp, 16 # restaura a stack
.end_macro

# Procedimento para a impressão da sequência de números informada como argumento.
.macro print_numbers($numbers, $size)
	la $t0, $numbers # carrega o primeiro endereço da sequência de números 
	move $t1, $size # contador do loop.

	loop_print_numbers:
		sub $t1, $t1, 1 # decrementa o contador.
		lw $t2, 0 ($t0) # carrega o número atual.
		print_integer($t2)
		print_string(" ") # imprime um espaço entre os números
		addi $t0, $t0, 4 # incrementa o ponteiro para o array.
		bne $t1, $0, loop_print_numbers
	print_string("\n") # quebra a linha após o último número
.end_macro

# Lê os números digitados pelo usuário e os insere na memória.
# Parâmetros:
# $random_numbers e $user_numbers: labels para os arrays na memória que.
# $size: quantidade de números nos arrays 
.macro read_numbers($random_numbers, $user_numbers, $size)
	sub $sp, $sp, 4 # cria a stack frame

	sw $size, 0 ($sp) # armazena o parâmetro na stack

	# Ponteiro para o array de números randômicos.
	la $t0, $random_numbers
	# Ponteiro para o array de números que serão informados pelo usuário.
	la $t1, $user_numbers
	# Posição atual que será exibida ao usuário. 
	li $t2, 0

	print_string("A seguir, informe o numero correspondente a cada posicao\n\n")
	lw $size, 0 ($sp) # restaura da stack

	loop_read_numbers:
		sub $size, $size, 1 # decrementa o contador
		sw $size, 0 ($sp) # salva o novo valor na stack
		addi $t2, $t2, 1 # incrementa a posição
		print_integer($t2)
		print_string(": ")
		# Obtém o número e o atribui ao registrador $t3
		read_integer($t3)
		# Armazena o valor no array 
		sw $t3, 0 ($t1)
		addi $t1, $t1, 4 # incrementa o ponteiro
		lw $size, 0 ($sp) # restaura novamente da stack
		bne $size, $0, loop_read_numbers

	clear
	addi $sp, $sp, 4
.end_macro

# Define as configurações do nível atual do jogo, isto é, determina a quantidade de números a ser exibida,
# a quantidade de sequências e o tempo de memorização.
# Após ser chamado o procedimento armazena os resultados nos registradores $a0, $a1 e $a2. 
.macro set_level_configurations($level, $numbers_per_level, $sequences_per_level, $time_per_level)
	# A seguir, carregamos os endereços dos arrays na memória que contém as configurações para o nível atual do jogo.    
	la $t0, $numbers_per_level
	la $t1, $sequences_per_level
	la $t2, $time_per_level

	# A seguir, determinamos qual o índice dos arrays contém as configurações para o nível atual do jogo.
	lw $t3, $level # carrega o nível da memória
	sub $t3, $t3, 1
	li $t4, 4
	mult $t3, $t4
	# move o valor de LO para o registrador $t3.
	mflo $t3

	# O registrador $t3 contém o valor base para o deslocamento pelos arrays. 
	add $t0, $t0, $t3
	add $t1, $t1, $t3
		add $t2, $t2, $t3
   
	# Por fim, deixamos os valores de retorno nos registradores $a0, $a1 e $a2
	lw $a0, 0 ($t0)
		lw $a1, 0 ($t1)
			lw $a2, 0 ($t2)
.end_macro

.macro make_attempt($random_numbers, $user_numbers, $level, $quantity_of_numbers, $number_of_sequences, $time)
	sub $sp, $sp, 20 # ajusta a stack

	# Salvamos os valores dos parâmetros na stack.
	sw $quantity_of_numbers, 0 ($sp)
	sw $number_of_sequences, 4 ($sp)
	sw $time, 8 ($sp)

	move $t0, $number_of_sequences # contador para o loop
	move $t1, $0 # armazenará o valor da sequência tual 

	loop_make_attempt:
		sub $t0, $t0, 1 # decrementa o contador
		sw $t0, 12 ($sp) # salvamos na stack
		addi $t1, $t1, 1 # incrementa o número da sequência atual
		sw $t1, 16 ($sp)

		# Gera os números randômicos
		generate_random_numbers($random_numbers, $quantity_of_numbers)

		# Carrega a informação do nível atual
		lw $t3, $level  

	# Restauramos da stack os parâmetros necessários ao próximo procedimento
		lw $number_of_sequences, 4 ($sp)
		lw $time, 8 ($sp)
		lw $t1, 16 ($sp)
		print_attempt_info($t3, $t1, $number_of_sequences, $time)
		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		print_numbers($random_numbers, $quantity_of_numbers)
		lw $time, 8 ($sp) # restaura da stack 
		clock($time)
		clear
		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		read_numbers($random_numbers, $user_numbers, $quantity_of_numbers)

		# Restauramos os parâmetros necessários a próxima iteração 
		lw $quantity_of_numbers, 0 ($sp)
		lw $t0, 12 ($sp)
		lw $t1, 16 ($sp)
		bne $t0, $0, loop_make_attempt

	# Restaura a stack à posição original
	addi $sp, $sp, 20  
.end_macro  
