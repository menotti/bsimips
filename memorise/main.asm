## Memorize
## Jogo de memorização em modo texto compatível com o simulador MARS 4.3 ou superiores.
## Autores:
## Alan Ghelardi
## Bruna Barbosa dos Santos
## Danilo Trabuco do Amaral
## Eronaldo José da Silva
## Criado em: Abril de 2013

.include "core.asm"

# Constante que define a quantidade máxima de níveis do jogo.
# Para alterar, modifique o valor da diretiva a seguir e acrescente ou retire valores dos arrays
# situados na sessão .data abaixo e que contém as "configurações" de cada nível do jogo.
.eqv LAST_LEVEL 5
 
.data
	# Altere os valores dos três arrays a seguir para modificar as configurações padrão para
	# a quantidade de números, número de sequências e tempo de memorização de cada nível do jogo.
	# Note que por padrão o jogo terá cinco níveis.
	numbers_per_level: .word 3, 5, 7, 9, 10
	sequences_per_level: .word 5, 4, 3, 2, 1
	time_per_level: .word 3, 4, 4, 5, 6
	# Arrays para armazenar os números gerados pelo jogo e os números digitados pelo usuário.   
	random_numbers: .word 0:10
	user_numbers: .word 0:10
	# Armazenará o nível atual do jogo. Por padrão, é inicializado em 1.
	current_level: .word 1
	# Armazenará a pontuação geral do usuário no jogo.
	score: .word 0

.text

	main:
		# Define a seed para a geração de números randômicos uma só vez no startup do jogo.
		set_seed

		# Subrotina que executa as instruções centrais para a mecânica do jogo.  
		play:
		sub $sp, $sp, 12 # stack frame para a subrotina

			# Define as configurações do nível atual.
			# A quantidade de números, sequências e o tempo de memorização do nível atual ficarão nos registradores $a0, $a1 e $a2
			# e serão utilizadas no procedimento seguinte.
			set_level_configurations(current_level, numbers_per_level, sequences_per_level, time_per_level)

			# Salvamos na stack os parâmetros que serão necessários posteriormente.
			sw $a0, 0 ($sp) # quantidade de números
			sw $a1, 4 ($sp) # número de sequências

			# Executa a tentativa atual.
			# Veja core.asm para maiores detalhes.
			run_attempt(random_numbers, user_numbers, current_level, $a0, $a1, $a2, score)
			# Move para $a2 o número de acertos que foi deixado pelo procedimento anterior em $v0.
			move $a2, $v0
			# Salva o valor na stack para posterior utilização.
			sw $a2, 8 ($sp) 

			# Restauramos da stack os parâmetros necessários.
			lw $a0, 0 ($sp)
			lw $a1, 4 ($sp)

			# Determina o resultado da tentativa ($v0) e o total de números utilizados no nível ($v1)    
			compute_attempt_results(LAST_LEVEL, $a0, $a1, $a2)

			# Define os parâmetros para a subrotina a seguir.
			lw $a0, 8 ($sp) # número de acertos
			move $a1, $v1 # total de números do nível
			move $a2, $v0 # resultado da tentativa

			# Exibe os resultados da tentativa atual.
			print_attempt_results(current_level, $a0, $a1, $a2)

			# Restaura a stack.
			end_play: addi $sp, $sp, 12

		exit_program # encerra o programa
