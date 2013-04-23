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

#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#														       /			
# 						FONTE DE REFERENCIAS						       /
#						--------------------						       /
#  														       /
#  	UTILIZAMOS COMO FONTE DE REFERENCIA EM COMANDOS, SYSCALLS E OUTROS RECURSOS DO ASSEMBLY			       /
#  	A PRÓPRIA FONTE DE AJUDA DO MARS, NELA ENCONTRAMOS EXEMPLOS E RECURSOS QUE NOS AJUDARAM			       /
#  	A CONSTRUIR ESTE JOGO.											       /
#  														       /
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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

# imprime uma quebra de linha que posiciona o conteudo da tela adequadamente
.macro QuebraDeEspaco
	ExibeMensagem("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
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
	QuebraDeEspaco									# quebra de espaço
	
	# Le a segunda linha do quadro naval
	ExibeMensagem("Leitura dos navios da segunda linha do quadro naval: \n")	# mensagem de orientação da entrada de dados
	LerLinha(linha1)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a terceira linha do quadro naval
	ExibeMensagem("Leitura dos navios da terceira linha do quadro naval: \n")	# mensagem de orientação da entrada de dados
	LerLinha(linha2)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a quarta linha do quadro naval
	ExibeMensagem("Leitura dos navios da quarta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha3)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a quinta linha do quadro naval
	ExibeMensagem("Leitura dos navios da quinta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha4)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a sexta linha do quadro naval
	ExibeMensagem("Leitura dos navios da sexta linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha5)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a setima linha do quadro naval
	ExibeMensagem("Leitura dos navios da setima linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha6)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a oitava linha do quadro naval
	ExibeMensagem("Leitura dos navios da oitava linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha7)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a nona linha do quadro naval
	ExibeMensagem("Leitura dos navios da nona linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha8)
	QuebraDeEspaco									# quebra de espaço
	
	# Le a decima linha do quadro naval
	ExibeMensagem("Leitura dos navios da decima linha do quadro naval: \n")		# mensagem de orientação da entrada de dados
	LerLinha(linha9)
	QuebraDeEspaco									# quebra de espaço
	
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
.macro VerificarTiro($linha_de_resposta, $linha, $posicao, $acerto, $chances)
	
	move $a0, $posicao			# move a posição alfanumerica do tiro	
	lw $a2, $acerto				# pega o numero de acertos corrente	
	lw $a3, $chances			# pega o numero de chances atual	
	
	# verificando a posicao
	beq $a0, 'A', posicao_0
	beq $a0, 'a', posicao_0
	beq $a0, 'B', posicao_1
	beq $a0, 'b', posicao_1
	beq $a0, 'C', posicao_2
	beq $a0, 'c', posicao_2
	beq $a0, 'D', posicao_3
	beq $a0, 'd', posicao_3
	beq $a0, 'E', posicao_4
	beq $a0, 'e', posicao_4
	beq $a0, 'F', posicao_5
	beq $a0, 'f', posicao_5
	beq $a0, 'G', posicao_6
	beq $a0, 'g', posicao_6
	beq $a0, 'H', posicao_7
	beq $a0, 'h', posicao_7
	beq $a0, 'I', posicao_8
	beq $a0, 'i', posicao_8
	beq $a0, 'J', posicao_9
	beq $a0, 'j', posicao_9
	
	
	posicao_0:					# posicao 0
	
		li $a0, 0				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro0		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro0
		bne $a1, 'O', TiroNaAgua0		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua0
	
		MarcarTiro0:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua0:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro	

	posicao_1:					# posicao 1
	
		li $a0, 4				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro1		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro1
		bne $a1, 'O', TiroNaAgua1		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua1
	
		MarcarTiro1:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua1:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
	
	posicao_2:					# posicao 2
	
		li $a0, 8				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro2		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro2
		bne $a1, 'O', TiroNaAgua2		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua2
	
		MarcarTiro2:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua2:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							


	posicao_3:					# posicao 3
	
		li $a0, 12				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro3		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro3
		bne $a1, 'O', TiroNaAgua3		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua3
	
		MarcarTiro3:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua3:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
			

	posicao_4:					# posicao 4
	
		li $a0, 16				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro4		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro4
		bne $a1, 'O', TiroNaAgua4		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua4
	
		MarcarTiro4:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos			
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua4:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
						

	posicao_5:					# posicao 5
	
		li $a0, 20				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro5		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro5
		bne $a1, 'O', TiroNaAgua5		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua5
	
		MarcarTiro5:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua5:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
			
	posicao_6:					# posicao 6
	
		li $a0, 24				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro6		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro6
		bne $a1, 'O', TiroNaAgua6		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua6
	
		MarcarTiro6:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua6:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
	
	posicao_7:					# posicao 7
	
		li $a0, 28				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro7		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro7
		bne $a1, 'O', TiroNaAgua7		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua7
	
		MarcarTiro7:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua7:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro

	posicao_8:					# posicao 8
	
		li $a0, 32				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro8		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro8
		bne $a1, 'O', TiroNaAgua8		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua8
	
		MarcarTiro8:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua8:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
																				

	posicao_9:					# posicao 9
	
		li $a0, 36				#fixando posicao numerica
		lw $a1, $linha_de_resposta($a0)		# pega o elemento da posicao a ser atingido
		beq $a1, 'O', MarcarTiro9		# caso o elemento seja certeiro ele marca no quadro naval e incrementa o numero de acertos
		beq $a1, 'o', MarcarTiro9
		bne $a1, 'O', TiroNaAgua9		# caso não seja certeiro ele decrementa a quantidade de chances
		bne $a1, 'o', TiroNaAgua9
	
		MarcarTiro9:				# marca o tiro no quadro naval
			addi $a2, $a2, 1		# incrementando o numero de acertos
			sw $a2, $acerto			# escreve o numero de acertos incrementado
			sw $a1, $linha($a0)		# fixando tiro no quadro naval	
			ExibeMensagem(" Legal você acertou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro
	
		TiroNaAgua9:
			subi $a3, $a3, 1		# decrementa o numero de chances
			sw $a3, $chances		# escreve o numero de chances decrementado 
			ExibeMensagem(" Que pena você errou o tiro! Pressione <ENTER> para continuar... \n")	# mensagem interna
			LerCaracter($t8)
			jal fim_macroVerificaTiro	# move para o fim da macro							
										
			
								
	fim_macroVerificaTiro:			# fim da macro
	
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
	
	
	# consulta de linhas
	linha_1_do_quadro:									# verifica os elementos da linha 1
		VerificarTiro(linha0, linha_0, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_2_do_quadro:									# verifica os elementos da linha 2
		VerificarTiro(linha1, linha_1, $coordY, acertos, chances_restantes)	
		jal final_macroAcerto
		
	linha_3_do_quadro:									# verifica os elementos da linha 3
		VerificarTiro(linha2, linha_2, $coordY, acertos, chances_restantes)	
		jal final_macroAcerto
			
	linha_4_do_quadro:									# verifica os elementos da linha 4
		VerificarTiro(linha3, linha_3, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_5_do_quadro:									# verifica os elementos da linha 5
		VerificarTiro(linha4, linha_4, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_6_do_quadro:									# verifica os elementos da linha 6
		VerificarTiro(linha5, linha_5, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_7_do_quadro:									# verifica os elementos da linha 7
		VerificarTiro(linha6, linha_6, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_8_do_quadro:									# verifica os elementos da linha 8
		VerificarTiro(linha7, linha_7, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
			
	linha_9_do_quadro:									# verifica os elementos da linha 9
		VerificarTiro(linha8, linha_8, $coordY, acertos, chances_restantes)
		jal final_macroAcerto
		
	linha_10_do_quadro:									# verifica os elementos da linha 10
		VerificarTiro(linha9, linha_9, $coordY, acertos, chances_restantes)
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
		
		ExibeMensagem("Batalha Naval\t-\tVersao 1.0 \n\n")				# titulo do jogo	
		MenuPrincipal									# exibe o menu principal
		ExibeMensagem("\n")								# imprime quebra de linha	
		FixarConfiguracaoJogo								# seleciona o modo de configuração do jogo
			
		
		ExecucaoCorrenteDoJogo:					   	
			
			QuebraDeEspaco								# quebra de espaço
			
			lw $t5, quantidade_elementos						# quantidade de elementos no quadro naval
			lw $t6, acertos								# quantidade de acertos
			lw $t7, chances_restantes						# chances restantes	
			sub $s0, $t5, $t6							# grava o totalde elementos que restam no quadro
			
			beqz $t7, GameOver							# salta para o GameOver
		   	beq $t6, $t5, Vitoria							# Salta para a vitória
			
			ExibeMensagem("\nTotal elementos: ")					# Exibe o total de elementos
			ExibeInteiro($t5)							
			ExibeMensagem("\tNavios atingidos:  ")					# Exibe os navios atingidos
			ExibeInteiro($t6)
			ExibeMensagem("\tNavios restantes:  ")					# Exibe os navios restantes
			ExibeInteiro($s0)
			ExibeMensagem("\tChances restantes restantes:  ")			# Exibe os navios restantes
			ExibeInteiro($t7)
			
			ExibeMensagem("\n")							# quebra de linha
			ImprimirQuadroNaval							# imprime o quadro naval para o jogo
			ExibeMensagem("\n")							# quebra de linha
			
			LerCoordenada($s1,$s2)							# le uma coordenada para atirar
			ExibeMensagem("\n")							# quebra de linha
			verificaAcerto($s1, $s2)						# verificando se houve acerto
		   
		bne $t6, $t5, ExecucaoCorrenteDoJogo						# Executa o jogo enquanto não afundar todos os navios		
										 	
		
		GameOver:									# fim de jogo para quem perde	
			QuebraDeEspaco								# quebra de espaço
			ExibeMensagem("\n\nFim de jogo!\n\n\n")					# mensagem de fim de jogo
			ExibeMensagem("Infelizmente você perdeu todas as chances!")		# mensage explicativa	
			ExibeMensagem("\nVeja a sua pontuação: ")				# pontuação feita
			ExibeInteiro($t6)			
			ImprimirQuadroNavalDeResposta						# imprime o quadro de resposta com as imbarcações da batalha naval
			jal FimExecucaoJogo							# salta para a sub rotina "FimJogo"			
		
		Vitoria:
			QuebraDeEspaco								# quebra de espaço
			ExibeMensagem("\n\nFim de jogo!\n\n\n")					# mensagem de fim de jogo
			ExibeMensagem("Parabéns você acertou todas as embarcações!")		# mensage explicativa	
			ExibeMensagem("\nVeja a sua pontuação: ")				# pontuação feita
			ExibeInteiro($t6)			
			ImprimirQuadroNavalDeResposta						# imprime o quadro de resposta com as imbarcações da batalha naval
			jal FimExecucaoJogo
		
		
		
	FimExecucaoJogo:		# fim do jogo
