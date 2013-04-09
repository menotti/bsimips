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
		# Cria a stack frame para a instrução main.
		sub $sp, $sp, 16

		# Define a seed para a geração de números randômicos uma só vez no startup do jogo.
		set_seed

		# Executa as instruções responsáveis pela exibição do menu principal do jogo.
		menu:
		# Não implementado ainda.

		# Conjunto de instruções que executam a lógica central do jogo. 
		play:
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
			# Salva na stack o resultado da tentativa para posterior utilização
			sw $v0, 12 ($sp)

			# Define os parâmetros para a subrotina a seguir.
			lw $a0, 8 ($sp) # número de acertos
			move $a1, $v1 # total de números do nível
			move $a2, $v0 # resultado da tentativa

			# Exibe os resultados da tentativa atual.
			print_attempt_results(current_level, $a0, $a1, $a2)

			# Restaura da stack o resultado da tentativa.
			lw $a0, 12 ($sp)
			# Chama o procedimento para a atualização do nível atual.
			modify_level(current_level, $a0)

			# Pergunta ao usuário se deseja ou não continuar jogando.
			prompt_continue

			# Verifica o resultado e desvia para a instrução correspondente.
			# Se o procedimento anterior retornou 0, desviamos para o menu.
			beq $v0, $0, menu
			# Caso contrário o resultado foi 1 e desviaremos para play (o usuário continuará jogando).
			j play   

		exit:
			# Restaura a stack ao estado original.
			addi $sp, $sp, 16
			print_string("Ate logo!")
		exit_program # encerra o programa
