## Memorize
## Jogo de memorização em modo texto compatível com o simulador MARS 4.3 ou superiores.
## Autores:
## Alan Ghelardi
## Bruna Barbosa dos Santos
## Danilo Trabuco do Amaral
## Eronaldo José da Silva
## Criado em: Abril de 2013

.include "core.asm"

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

		# Define as configurações do nível atual.
		# A quantidade de números, sequências e o tempo de memorização do nível atual ficarão nos registradores $a0, $a1 e $a2
		# e serão utilizadas no procedimento seguinte.
		set_level_configurations(current_level, numbers_per_level, sequences_per_level, time_per_level)
		# Executa a tentativa atual.
		# Veja core.asm para maiores detalhes.
		run_attempt(random_numbers, user_numbers, current_level, $a0, $a1, $a2, score)

		exit_program # encerra o programa
