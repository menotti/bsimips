# Trabalho em Grupo da disciplina Arquitetura de Computadores.
# Objetivos: Desenvolver um jogo em linguagem de máquina Assembly
# 
# Jogo escolhido: Batalha Naval
# Justificatifa: A batalha naval constitui-se de um jogo simples de raciocínio lógico e que atende as regras do roteiro do trabalho.
# 
# Autores: 
# 
# Amarildo dos Reis Almeida 482927;
# 
# Fabiano de Almeida Sousa 482919;
# 
# Marcelo Barbosa 482811;
# 
# Marco Aurelio Reliquias 482960;
# 
# Paulo Cesar Candido 483028;
# 
# Rodolfo Aparecido de Souza 482862;
# 
# Wanderson Sampaio Lopes Pereira 482978;


########################################################################################################################
#														       #			
# 						DECLARAÇÕES GLOBAIS						       #
#  														       #
########################################################################################################################						

.data
		acertos: .word 0		# quantidade de acertos do usuario
		quantidade_elementos: .word 0	# quantidade elementos no quadro naval
		chances_restantes: .word 5 	# quantidade de chances que o usuario tem
		opcao: .word 0			# grava a opção escolhida pelo usuário
		
		
		
.text


########################################################################################################################
#														       #			
# 						SUB ROTINAS DE CONTROLE						       #
#  														       #
########################################################################################################################						


# exibe mensagens
.macro	ExibeMensagem(%texto)
	.data
		mensagemTexto: .asciiz %texto	# cria um identificador com o valor da string digitada
	.text
		la $a0, mensagemTexto	# pega o endereco do identificador e grava no registrador $a0
		li $v0, 4		# 
		syscall
		
.end_macro 

# exibe caracteres
.macro	ExibeCaracter($caracter)	
		move $a0, $caracter		
		li $v0, 11
		syscall		
.end_macro 

# exibe inteiros
.macro ExibeInteiro($inteiro)
	move $a0, $inteiro
	li $v0, 1
	syscall
.end_macro 

# Le um caracter alfanumerico
.macro LerCaracter($valorCaracter)
	li $v0, 12
	syscall
	move $valorCaracter, $v0
.end_macro 		

# Le um caracter numerico
.macro LerInteiro($valorInteiro)
	li $v0, 5
	syscall
	move $valorInteiro, $v0
.end_macro 		

# Inicializa o Quadro Naval
.macro inicializaQuadroNaval($L0, $L1, $L2, $L3, $L4, $L5, $L6, $L7, $L8, $L9, $quantidadeElementos)
	
	# declaracao de variaveis
	.data
		caracter: .byte 'O'
		vazio: .byte ' '
	.text		
	
	# inicializacao de registrador local			
	lb $t1, caracter
	lb $t2, vazio 
	li $t3, 0
	li $s0, 0

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
																																						
	# fixando os navios da primeira linha
	
	# Encouraçado
		sw $t1, $L0($t3) # armazenando valor no primeiro elemento do vetor		
		addi $t3, $t3, 4		 
		sw $t1, $L0($t3) # armazenando valor no segundo elemento do vetor		
		addi $t3, $t3, 4
		sw $t1, $L0($t3) # armazenando valor no terceiro elemento do vetor		
		addi $t3, $t3, 4 
		sw $t1, $L0($t3) # armazenando valor no quarto elemento do vetor		
		addi $t3, $t3, 4		
		
	# Vazio
		sw $t2, $L0($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4
	
	# Submarino				
		sw $t1, $L0($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4
	
	# Vazio				
		sw $t2, $L0($t3) # armazenando valor no nona elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no decima elemento do vetor
		
	# Soma total		
		addi $s0, $s0, 5 # somando elementos						

				
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	# fixando os navios da segunda linha
	
	# zera o contador
	li $t3, 0
	
	# Submarino
		sw $t1, $L1($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
	# Vazio	 
		sw $t2, $L1($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio				
		sw $t2, $L1($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4 
		
	# Vazio		
		sw $t2, $L1($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		
	# Submarino
		sw $t1, $L1($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
	# Vazio	
		sw $t2, $L1($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio		
		sw $t2, $L1($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4
	
	# Cruzador				
		sw $t1, $L1($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L1($t3) # armazenando valor no nona elemento do vetor	
	
	# Vazio		
		addi $t3, $t3, 4
		sw $t2, $L1($t3) # armazenando valor no decima elemento do vetor
		
	# Soma total		
		addi $s0, $s0, 4 # somando elementos	
		

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
		
	# fixando os navios da terceira linha
	
	# zera o contador
	li $t3, 0
	
	# Vazio
		sw $t2, $L2($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
	# Submarino	 
		sw $t1, $L2($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
		
	# Hidro Avião				
		sw $t1, $L2($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L2($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4	
		sw $t1, $L2($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
	# Vazio	
		sw $t2, $L2($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Hidro Avião		
		sw $t1, $L2($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4					
		sw $t1, $L2($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L2($t3) # armazenando valor no nona elemento do vetor
			
	# vazio		
		addi $t3, $t3, 4
		sw $t2, $L2($t3) # armazenando valor no decima elemento do vetor	
		
	# Soma total		
		addi $s0, $s0, 7 # somando elementos	
	

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

	# fixando os navios da quarta linha
	
	# zera o contador
	li $t3, 0
	
	# Submarino
		sw $t1, $L3($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
	# Vazio	 
		sw $t2, $L3($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
		
	# Submarino				
		sw $t1, $L3($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio			
		sw $t2, $L3($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4	
		sw $t2, $L3($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4		
		sw $t2, $L3($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Submarino		
		sw $t1, $L3($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4
	
	# Vazio												
		sw $t2, $L3($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t2, $L3($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		sw $t2, $L3($t3) # armazenando valor no decima elemento do vetor
		
	# Soma total		
		addi $s0, $s0, 3 # somando elementos			
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da quinta linha

	# zera o contador
	li $t3, 0
	
	# Hidro Avião
		sw $t1, $L4($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L4($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L4($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio			
		sw $t2, $L4($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		
	# Encouraçado		
		sw $t1, $L4($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L4($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L4($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4												
		sw $t1, $L4($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio					
		sw $t2, $L4($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		
	# Submarino		
		sw $t1, $L4($t3) # armazenando valor no decima elemento do vetor		
		
	# Soma total		
		addi $s0, $s0, 8 # somando elementos	
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da sexta linha

	# zera o contador
	li $t3, 0
	
	# Cruzador
		sw $t1, $L5($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L5($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
	
	# vazio						
		sw $t2, $L5($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4
		
	# Porta Aviões			
		sw $t1, $L5($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L5($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L5($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L5($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4												
		sw $t1, $L5($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio					
		sw $t2, $L5($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		
	# Porta Aviões		
		sw $t1, $L5($t3) # armazenando valor no decima elemento do vetor
		
	# Soma total		
		addi $s0, $s0, 8 # somando elementos			

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
			
	# fixando os navios da setima linha
	
	# zera o contador
	li $t3, 0
	
	# Porta Aviõe
		sw $t1, $L6($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L6($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L6($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4	
		sw $t1, $L6($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L6($t3) # armazenando valor no quinto elemento do vetor
		
	# vazio	
		addi $t3, $t3, 4		
		sw $t2, $L6($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4			
		sw $t2, $L6($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4												
		sw $t2, $L6($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4
		
	# Submarino					
		sw $t1, $L6($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		
	# Vazio		
		sw $t2, $L6($t3) # armazenando valor no decima elemento do vetor	
		
	# Soma total		
		addi $s0, $s0, 6 # somando elementos	
	
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da oitava linha
	

	# zera o contador
	li $t3, 0
	
	# Cruzador
		sw $t1, $L7($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L7($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
	
	# Vazio								
		sw $t2, $L7($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4
		
	# Cruzador			
		sw $t1, $L7($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		sw $t1, $L7($t3) # armazenando valor no quinto elemento do vetor
		
	# Vazio	
		addi $t3, $t3, 4		
		sw $t2, $L7($t3) # armazenando valor no sexto elemento do vetor
		
	# Encouraçado	
		addi $t3, $t3, 4			
		sw $t1, $L7($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4												
		sw $t1, $L7($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L7($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		sw $t1, $L7($t3) # armazenando valor no decima elemento do vetor	
		
	# Soma total		
		addi $s0, $s0, 8 # somando elementos	
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da nona linha
	
	# zera o contador
	li $t3, 0
	
	# Submarino
		sw $t1, $L8($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio	
		sw $t2, $L8($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4					
		sw $t2, $L8($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4	
		sw $t2, $L8($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L8($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4		
		sw $t2, $L8($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4			
		sw $t2, $L8($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4
		
	# Hidro Avião													
		sw $t1, $L8($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L8($t3) # armazenando valor no nona elemento do vetor	
		addi $t3, $t3, 4
		sw $t1, $L8($t3) # armazenando valor no decima elemento do vetor			
		
	# Soma total		
		addi $s0, $s0, 4 # somando elementos	

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

	# fixando os navios da décima linha
	
	# zera o contador
	li $t3, 0
	
	# Vazio
		sw $t2, $L9($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
	# Submarino	 
		sw $t1, $L9($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
		
	# Hidro Avião				
		sw $t1, $L9($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L9($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4	
		sw $t1, $L9($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
	# Vazio	
		sw $t2, $L9($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Cruzador		
		sw $t1, $L9($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4					
		sw $t1, $L9($t3) # armazenando valor no oitavo elemento do vetor
		
	# vazio	
		addi $t3, $t3, 4			
		sw $t2, $L9($t3) # armazenando valor no nona elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L9($t3) # armazenando valor no decima elemento do vetor	
		
	# Soma total		
		addi $s0, $s0, 6 # somando elementos	
	
	# Movendo total
	sw $s0, $quantidadeElementos
	


			
.end_macro 

# conta a quantidade de navios
.macro contarNavios($contador)
	
	
	
	beq $t3, 'O', Incrementar_Contador
	beq $t3, 'o', Incrementar_Contador
	bne $t3, 'O', final_macro
	bne $t3, 'o', final_macro
	
	
   	Incrementar_Contador:
		lw $a3, $contador
		addi $a3, $a3, 1
		sw $a3, $contador
		
	final_macro:
		
	
.end_macro 

# Lê uma linha do Quadro Naval
.macro LerLinha($linha)

	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 10 unidades	
	li $t4, 1				# contador progressivo iniciado com 1 unidade
	
	ExibeMensagem("\nPreencha a linha com 'O' - letra ô - para elemento e ' ' - espaço - para vazio ")
	ExibeMensagem("\nEntre com todos os elementos desta linha\n")
	# laço de repeticao
	
	Loop:	
		ExibeMensagem("Conteúdo da posição:\t")
		ExibeInteiro($t4)
		ExibeMensagem("\n")
		LerCaracter($t3)
		contarNavios(quantidade_elementos)		 
		sw $t3, $linha($t1)
		addi $t1, $t1, 4		# incrementa para a proxima posicao
		addi $t4, $t4, 1		# incrementa o contador 
		subi $t2, $t2, 1		# decrementa o contador de controle do loop			
		ExibeMensagem("\n")		# quebra de linha
		bgtz $t2, Loop			# retorna ao inicio do loop
					 	 	

.end_macro 


# Fixa valores definidos pelo usuario no Quadro Naval
.macro FixarNavios

	# Le a primeira linha do quadro naval
	ExibeMensagem("Leitura dos navios da primeira linha do quadro naval: \n")	# mensagem de orientação da entrada de dados
	LerLinha(linha0)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a segunda linha do quadro naval
	ExibeMensagem("Leitura dos navios da segunda linha do quadro naval: \n")	# mensagem de orientação da entrada de dados
	LerLinha(linha1)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a terceira linha do quadro naval
	ExibeMensagem("Leitura dos navios da terceira linha do quadro naval: \n")	# mensagem de orientação da entrada de dados
	LerLinha(linha2)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a quarta linha do quadro naval
	ExibeMensagem("Leitura dos navios da quarta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha3)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a quinta linha do quadro naval
	ExibeMensagem("Leitura dos navios da quinta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha4)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a sexta linha do quadro naval
	ExibeMensagem("Leitura dos navios da sexta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha5)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a setima linha do quadro naval
	ExibeMensagem("Leitura dos navios da setima linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha6)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a oitava linha do quadro naval
	ExibeMensagem("Leitura dos navios da oitava linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha7)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a nona linha do quadro naval
	ExibeMensagem("Leitura dos navios da nona linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha8)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
	# Le a decima linha do quadro naval
	ExibeMensagem("Leitura dos navios da decima linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha9)
	ExibeMensagem("\n\n\n\n\n\n\n")							# quebra de linha
	
.end_macro

# imprime todos os elementos de uma linha do Quadro Naval
.macro Imprimir_Linha_Do_Quadro_Naval($linha)
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 10 unidades	
	
	# laço de repeticao
	Loop:		
	 	lw $a1, $linha($t1)		# le um caracter da linha do quadro naval
	 	ExibeMensagem("|")		# linha horizontal	 		 	
	 	ExibeMensagem(" ")		# controla o espacamento
		ExibeCaracter($a1)		# recebe e imprime o caracter da linha do quadro naval		
		ExibeMensagem(" ")		# controla o espacamento			 	
		addi $t1, $t1, 	4		# incrementa para a proxima posicao			
		subi $t2, $t2, 1		# decrementa o contador de controle do loop			
		bgtz $t2, Loop			# retorna ao inicio do loop
		ExibeMensagem("|")		# linha horizontal
.end_macro 

# imprime uma quebra de linha que posiciona o conteudo da tela adequadamente
.macro QuebraDeEspaco
	ExibeMensagem("\n\n\n\n\n")
.end_macro 

# imprime todo o quadro naval
.macro ImprimirQuadroNaval
	
	# a impressao eh feita com formatacao pre-definida
	ExibeMensagem("\n  |-A-|-B-|-C-|-D-|-E-|-F-|-G-|-H-|-I-|-J-|")
	ExibeMensagem("\n  -----------------------------------------\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_0)					# Linha 1
	ExibeMensagem("\n1 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_1)					# Linha 2
	ExibeMensagem("\n2 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_2)					# Linha 3	
	ExibeMensagem("\n3 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_3)					# Linha 4
	ExibeMensagem("\n4 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_4)					# Linha 5
	ExibeMensagem("\n5 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_5)					# Linha 6
	ExibeMensagem("\n6 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_6)					# Linha 7
	ExibeMensagem("\n7 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_7)					# Linha 8
	ExibeMensagem("\n8 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_8)					# Linha 9
	ExibeMensagem("\n9 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha_9)					# Linha 10		
	ExibeMensagem("\n10|---------------------------------------|\n")
	
.end_macro 

# imprime todo o quadro naval de resposta
.macro ImprimirQuadroNavalDeResposta
	
	# a impressao eh feita com formatacao pre-definida
	ExibeMensagem("\n  |-A-|-B-|-C-|-D-|-E-|-F-|-G-|-H-|-I-|-J-|")
	ExibeMensagem("\n  -----------------------------------------\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha0)					# Linha 1
	ExibeMensagem("\n1 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha1)					# Linha 2
	ExibeMensagem("\n2 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha2)					# Linha 3	
	ExibeMensagem("\n3 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha3)					# Linha 4
	ExibeMensagem("\n4 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha4)					# Linha 5
	ExibeMensagem("\n5 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha5)					# Linha 6
	ExibeMensagem("\n6 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha6)					# Linha 7
	ExibeMensagem("\n7 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha7)					# Linha 8
	ExibeMensagem("\n8 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha8)					# Linha 9
	ExibeMensagem("\n9 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quadro_Naval(linha9)					# Linha 10		
	ExibeMensagem("\n10|---------------------------------------|\n")
	
.end_macro

# Exibe o menu principal
.macro MenuPrincipal
	ExibeMensagem("Deseja posicionar os navios no quadro naval?\n")
	ExibeMensagem("1 - Sim, 2 - Não (caso seja 'não' o jogo utilizará o preenchimento automático de navios no quadro naval)\nInsira a opção e tecle ENTER:  ")
	LerInteiro($s1)
	sw $s1, opcao
	
.end_macro 

# Define a configuração a ser utilizada para o jogo
.macro FixarConfiguracaoJogo
	lw $s2, opcao
	
	beq $s2, 1, Jogo_Personalizado		# move para o jogo personalizado
	beq $s2, 2, Jogo_PreDefinido		# move para o jogo pré-definido
	jal final_macroConfiguracao		# move para o final da macro
	
	Jogo_Personalizado:
		# fixa os navios com definições do usuário
		FixarNavios	
		jal final_macroConfiguracao	# salta para o final da macro
	
	Jogo_PreDefinido:
		# fixa os navios com pré-definições do jogo	
		inicializaQuadroNaval(linha0, linha1, linha2, linha3, linha4, linha5, linha6, linha7, linha8, linha9, quantidade_elementos)
		jal final_macroConfiguracao	# salta para o final da macro

	
	final_macroConfiguracao:	# final da macro
	
	
.end_macro 

# Le uma coordenada do Quadro Naval
.macro LerCoordenada($coordX,$coordY)
       ExibeMensagem("Informe as coordenadas do alvo linha(1:10), coluna(a:j) :\n\n")
       ExibeMensagem("linha:\n")
       LerInteiro($coordX)
       ExibeMensagem("\ncoluna:\n")
       LerCaracter($coordY)		
.end_macro 

# verifica se o tiro foi certeiro
.macro VerificarTiro($coluna, $acerto, $chances)
.end_macro 

# Verifica se houve acerto e caso haja
.macro verificaAcerto($coordX, $coordY)
	# verificando qual a linha a ser consultada
	beq $coordX, 1, linha_1_do_quadro
	beq $coordX, 2, linha_2_do_quadro
	beq $coordX, 3, linha_3_do_quadro
	beq $coordX, 4, linha_4_do_quadro
	beq $coordX, 5, linha_5_do_quadro
	beq $coordX, 6, linha_6_do_quadro
	beq $coordX, 7, linha_7_do_quadro
	beq $coordX, 8, linha_8_do_quadro
	beq $coordX, 9, linha_9_do_quadro
	beq $coordX, 10, linha_10_do_quadro
	
	linha_1_do_quadro:
		jal final_macroAcerto
		
	linha_2_do_quadro:	
		jal final_macroAcerto
		
	linha_3_do_quadro:	
		jal final_macroAcerto
			
	linha_4_do_quadro:
		jal final_macroAcerto
		
	linha_5_do_quadro:
		jal final_macroAcerto
		
	linha_6_do_quadro:
		jal final_macroAcerto
		
	linha_7_do_quadro:
		jal final_macroAcerto
		
	linha_8_do_quadro:
		jal final_macroAcerto
			
	linha_9_do_quadro:
		jal final_macroAcerto
		
	linha_10_do_quadro:
		jal final_macroAcerto
		
	final_macroAcerto:	
				
.end_macro 	



########################################################################################################################
#														       #			
# 						DECLARAÇÃO DOS QUADROS NAVAIS					       #
#  														       #
########################################################################################################################						


.data  # armazena os itens declarados	
	
	# declaracao de variaveis
	
	# Quadro da Batalha Naval de comparação
	linha0: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha1: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha2: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' 
	linha3: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha4: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha5: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha6: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha7: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha8: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha9: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	
	# Quadro da Batalha Naval
	linha_0: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_1: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_2: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' 
	linha_3: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_4: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_5: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_6: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_7: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_8: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha_9: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
								
	
.text # a palavra reservada .text permite armazenar cadeia de caracteres em variaveis	
	
	# inicializacao de registradores
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 9 unidades		
	
	# declaracao de sub rotinas

########################################################################################################################
#														       #			
# 						TELA PRINCIPAL DO JOGO:						       #
#  														       #
########################################################################################################################						

TelaInicial:	# tela inicial do jogo	
		
		ExibeMensagem("Batalha Naval\t-\tVersao 1.0 \n\n")
		
		
		MenuPrincipal
		ExibeMensagem("\n")
		FixarConfiguracaoJogo
		
		lw $t5, quantidade_elementos
		ExibeMensagem("\nTotal elementos: ")
		ExibeInteiro($t5)
		ExibeMensagem("\n")
		
		
		
		
		
		ExibeMensagem("\n\nFim de jogo!\n\n\n")		
		
		jal FimJogo		# salta para a sub rotina "FimJogo"	
		
	FimJogo:		# fim do jogo
