## Contém procedimentos necessários para a execução da lógica central do jogo.
 
.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

# Constantes que representam possíveis resultados para cada tentativa. 
.eqv LOST_LEVEL 0
.eqv WON_GAME 1
.eqv WON_LEVEL 2

# Exibe o menu principal do jogo e retorna a opção selecionada através do registrador $v0.  
.macro show_menu
	sub $sp, $sp, 4
 	print_string("Por favor, selecione a opcao desejada:\n")
	print_string("1 = jogar, 2 = exibir pontuacao atual, 3 = exibir ajuda e 0 = sair: ")
	read_integer($a0)
	sw $a0, 0 ($sp)
	clear
	lw $v0, 0 ($sp)
	addi $sp, $sp, 4
.end_macro

# Permite ao usuário selecionar o nível de dificuldade do jogo se desejado.
.macro prompt_select_level($level)
	.data
		yes: .byte 's'
		no: .byte 'n'
	.text
		sub $sp, $sp, 4 # stack frame
		prompt: print_string("Deseja selecionar o nivel de dificuldade do jogo?\n")
		print_string("s = sim, n = nao (comeca pelo nivel 1):")
		read_character($t0)
		sw $t0, 0 ($sp) # salva a resposta na stack
		clear

		lw $t0, 0 ($sp) # restaura a resposta da stack
		# Carrega da memória os caractéres de comparação.
		lb $t1, yes
		lb $t2, no

		beq $t0, $t1, get_level
		beq $t0, $t2, use_first_level
		# Se nenhum dos dois desvios foi executado, a opção é inválida.
		print_string("Opcao invalida. Por favor, tente novamente\n\n")
		j prompt 
 
		get_level:
			print_string("Informe o nivel desejado (somente valores que estejam no intervalo [1-5]): ")
			read_integer($t0)
			# A seguir, validamos se a entrada está no intervalo informado.
			slt $t1, $0, $t0
			slti $t2, $t0, 6
			and $t3, $t1, $t2  
			li $t4, 1 # valor para comparação
			beq $t3, $t4, end_prompt_select_level
			# Se esse trecho foi executado, então o valor digitado é inválido.
			clear
			print_string("Valor invalido, por favor, tente novamente\n\n")
			j get_level 

		use_first_level:
			li $t0, 1 # primeiro nível

			end_prompt_select_level:
				sw $t0, $level # armazena na memória o nível a ser utilizado 
				addi $sp, $sp, 4 # restaura a stack frame  
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
# $random_numbers e $user_numbers: labels para os respectivos arrays na memória.
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

# Função que calcula o índice atual de acertos do usuário e atualiza a pontuação geral.
# Após a execução o índice de acertos da tentativa é retornado através do registrador $v0. 
.macro compute_score($random_numbers, $user_numbers, $size, $score)
	# Ponteiros para os arrays na memória
	la $t0, $random_numbers
	la $t1, $user_numbers
	li $t2, 0 # acertos na tentativa atual

	loop_compute_score:
		sub $size, $size, 1 # decrementa o contador
		# Obtém os valores nos índices atuais dos arrays
		lw $t3, 0 ($t0)
		lw $t4, 0 ($t1)
		# Incrementa os ponteiros para a iteração seguinte.
		addi $t0, $t0, 4
		addi $t1, $t1, 4 

		# Se os valores dos registradores forem diferentes, desvia para a instrução
			# que verifica se o loop deve continuar. 
		bne $t3, $t4, end_loop_compute_score
		# Caso contrário, incrementa o valor dos acertos atuais.
		addi $t2, $t2, 1 
		end_loop_compute_score: 
		bne $size, $0, loop_compute_score

	# Atualiza a pontuação geral do jogador
	lw $t5, $score
	add $t5, $t5, $t2
	sw $t5, $score
	# Deixa o valor dos acertos atuais no registrador $v0
	move $v0, $t2 
.end_macro

# Função que executa a tentativa atual a partir dos parâmetros informados.
# Ao ser executada os seguintes passos ocorrem:
# 1- Os números randômicos são exibidos no console.
# 2- O "clock" sonoro contabiliza o tempo em que os números ficarão visíveis.
# 3- Ocorre a leitura dos números informados pelo usuário.
# 4- O índice de acertos da tentativa atual é calculado e a pontuação geral é atualizada.
# O número de acertos é retornado através do registrador $v0.      
.macro run_attempt($random_numbers, $user_numbers, $level, $quantity_of_numbers, $number_of_sequences, $time, $score)
	sub $sp, $sp, 24 # ajusta a stack

	move $t0, $number_of_sequences # contador para o loop
	move $t1, $0 # armazenará o valor da sequência tual
	li $t2, 0 # armazenará a quantidade de acertos 

	# Salvamos os valores a serem utilizados posteriormente na stack 
	sw $quantity_of_numbers, 0 ($sp)
	sw $number_of_sequences, 4 ($sp)
	sw $time, 8 ($sp)
	sw $t2, 20 ($sp)

	loop_make_attempt:
		sub $t0, $t0, 1 # decrementa o contador
		sw $t0, 12 ($sp) # salvamos na stack

		addi $t1, $t1, 1 # incrementa o número da sequência atual
		sw $t1, 16 ($sp) # salva na stack

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

		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		compute_score($random_numbers, $user_numbers, $quantity_of_numbers, $score)
		lw $t2, 20 ($sp) # restaura da stack
		# Incrementa os acertos com o valor retornado pela função compute_score
		add $t2, $t2, $v0 
		sw $t2, 20 ($sp) # salva novamente na stack

		# Restauramos os parâmetros necessários a próxima iteração 
		lw $quantity_of_numbers, 0 ($sp)
		lw $t0, 12 ($sp)
		lw $t1, 16 ($sp)
		bne $t0, $0, loop_make_attempt

		# Retorna o número de acertos da tentativa através de $v0
		lw $v0, 20 ($sp)

	# Restaura a stack à posição original
	addi $sp, $sp, 24  
.end_macro  

# Realiza o cômputo do resultado da tentativa.
# Após a execução, um valor numérico representando o resultado da tentativa atual é retornado através do registrador $v0. Adicionalmente, o total de números utilizados no níivel é retornado através do registrador $v1.  
.macro compute_attempt_results($level, $last_level, $quantity_of_numbers, $number_of_sequences, $hits)
	# Carrega da memória o nível atual.
	lw $t0, $level
	# Multiplica a quantidade de números pelo número de sequências.
	mult $quantity_of_numbers, $number_of_sequences
	# Obtém o resultado a partir do registrador $lo
	mflo $t1

	# Se o número de acertos não for igual ao total de acertos possíveis no nível, desviamos para lost. 
	bne $hits, $t1, lost
		# Se esse trecho foi executado, o jogador venceu o nível. 
		# Então vamos carregar o valor que representa o último nível.
		# O objetivo é verificarmos se o jogador venceu o jogo.  
		li $t2, $last_level

		# Se o nível atual não for o último, então desviamos para o label indicado. 
		bne $t0, $t2, just_won_level
			# O jogador venceu o jogo.
			# Retornamos a constante que indica isso.
			li $v0, WON_GAME
			# Desvia para o fim da subrotina, saltando as instruções a seguir.
			j end_compute_attempt_results 

		just_won_level:
			# Se esse trecho foi executado, então o jogador só venceu o nível atual.
			# Retornamos a constante que indica isso.
			li $v0, WON_LEVEL
			# Desvia para o fim da subrotina.
			j end_compute_attempt_results

	lost:
		# Retornamos a constante que indica que o jogador perdeu.
		li $v0, LOST_LEVEL
	end_compute_attempt_results:
		# Adicionalmente, retornamos o total de números utilizados no nível.
		move $v1, $t1
.end_macro

# Exibe os resultados da tentativa.
# Parâmetros:
# $level: endereço para o nível atual armazenado na memória.
# $hits: número de acertos para a tentativa atual.
# $total_of_numbers: total de números utilizados no nível
# $result_of_attempt: constante que indica o resultado da tentativa atual (0 = perdeu o nível, 1 = ganhou o jogo e 2 = ganhou o nível).
.macro print_attempt_results($level, $hits, $total_of_numbers, $result_of_attempt)
	sub $sp, $sp, 12 # stack frame 

		# Salva na stack os parâmetros a serem utilizados posteriormente.
	sw $hits, 0 ($sp)
	sw $total_of_numbers, 4 ($sp)
	sw $result_of_attempt, 8 ($sp)

	print_string("Voce acertou ")
	lw $hits, 0 ($sp)
	print_integer($hits)
	print_string(" de ")
	lw $total_of_numbers, 4 ($sp)
	print_integer($total_of_numbers)
	print_string(" numeros")

	lw $result_of_attempt, 8 ($sp)

	beq $result_of_attempt, WON_GAME, congratulations # venceu o jogo
	beq $result_of_attempt, WON_LEVEL, can_advance # venceu o nível atual
	j try_again # perdeu o nível e deve tentar novamente

		congratulations:
			print_string(" e venceu o Memorize! Parabens!!!")
			# Dispara o efeito sonoro de vitória.
			victory
			# Desvia para o fim da subrotina, saltando as instruções a seguir.
			j end_print_attempt_results

		can_advance:
			print_string(" e podera passar para o nivel ")
			# Incrementamos o valor do nível para mostrar ao usuário. 
			lw $t0, $level
			addi $t0, $t0, 1
			print_integer($t0)
			print_string("!")
			# Dispara o efeito sonoro associado ao acerto do jogador.
			hit
			# Desvia para o fim da subrotina.
			j end_print_attempt_results

		try_again:
			# Notificamos que o jogador perdeu e precisará tentar de novo.
			print_string(", o que nao e suficiente para passar de nivel. ")
			print_string("Voce tera que tentar vencer o nivel ")
			lw $t0, $level
			print_integer($t0)
			print_string(" novamente!")
			# Tocamos o som que indica o erro.
			error

	end_print_attempt_results:
		print_string("\n\n")
		addi $sp, $sp, 12 # restaura a stack 
.end_macro

# Modifica o nível atual se necessário, isto é, se o jogador venceu o nível atual ou o próprio jogo.
# Se o jogador venceu o nível atual, o procedimento atualiza o nível para o próximo.
# Se o jogador venceu o jogo, o nível de dificuldade retorna para 1. Caso contrário, o mesmo nível é mantido.
.macro modify_level($level, $result_of_attempt)
	# Carrega o nível atual da memória.
	lw $t0, $level
	# Carrega as constantes que representam os possíveis resultados da tentativa para posterior comparação.
	li $t1, WON_LEVEL
	li $t2, WON_GAME

	# Se o jogador venceu o nível, passamos para o próximo. 
	beq $result_of_attempt, $t1, pass_to_next
	# Se o jogador venceu o jogo, reiniciamos.
	beq $result_of_attempt, $t2, restart
	# Caso contrário, o jogador perdeu o nível e não faremos nada. 
	j keep_same_level

		# Incrementamos o nível atual. 
		pass_to_next: addi $t3, $t0, 1
		j update_level 

		# Retornamos ao nível 1.
		restart: li $t3, 1

		# Salvamos o novo valor na memória.
		update_level: sw $t3, $level

		keep_same_level:
	.end_macro

# Exibe uma mensagem ao usuário perguntando se ele deseja continuar jogando e obtém a resposta selecionada (s ou n).
# Após a execução o registrador $v0 conterá uma flag indicando se o jogo deve ou não continuar.
# Retorno (em $v0): 1 (verdadeiro), o usuário deseja continuar ou 0 (falso) a execução deve retornar ao menu principal.  
.macro prompt_continue
	.data
		yes: .byte 's'
		no: .byte 'n'
	.text
		sub $sp, $sp, 4
		print_string("Deseja continuar jogando?\n")
		print_string("s = sim, n = retorna ao menu: ")
		read_character($t0)
		sw $t0, 0 ($sp)
		clear
		lw $t0, 0 ($sp)
		# Carrega os caracteres de comparação da memória.
		lb $t1, yes 
		lb $t2, no

		beq $t0, $t1, return_true
		beq $t0, $t2, return_false
			return_true: li $v0, 1
			j end_prompt_continue
			return_false: li $v0, 0
			end_prompt_continue:
			addi $sp, $sp, 4 
.end_macro

# Procedimento para a exibição da pontuação geral do jogador.
.macro show_score($score)
	print_string("Sua pontuacao atual e ") 
	lw $t0, $score
	print_integer($t0)
	print_string("\n\n")
	print_string("Pressione qualquer letra para continuar")
	read_character($t0)
	clear
.end_macro  
