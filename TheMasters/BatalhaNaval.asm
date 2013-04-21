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

# declaracoes globais
.data
		acertos: .word 0		# quantidade de acertos do usuario
		chances_restantes: .word 5 	# quantidade de chances que o usuario tem
		sim: .word 1			# resposta logica para afirmacao	
		nao: .word 0			# resposta logica para negacao
		
		
.text

# declaração de procedimentos
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

# Le uma coordenada do Quadro Naval
.macro LerCoordenada($coordX,$coordY)
       ExibeMensagem("Informe as coordenadas do alvo linha(0:9), coluna(a:j) :\n\n")
       ExibeMensagem("linha:\n")
       LerInteiro($coordX)
       ExibeMensagem("\ncoluna:\n")
       LerCaracter($coordY)		
.end_macro 

# Le um caracter alfanumerico
.macro contabilizaAcerto($coordX, $coordY, $acerto, $chances, $linha)
.end_macro 				

# Inicializa o Quadro Naval
.macro inicializaQuadroNaval($L0, $L1, $L2, $L3, $L4, $L5, $L6, $L7, $L8, $L9)
	
	# declaracao de variaveis
	.data
		caracter: .byte 'O'
		vazio: .byte ' '
	.text		
	
	# inicializacao de registrador local			
	lb $t1, caracter
	lb $t2, vazio 
	li $t3, 0

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
																																						
	# fixando os navios da primeira linha
	
	# Submarino
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
	
	# Porta Avioes				
		sw $t1, $L0($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4
	
	# Vazio				
		sw $t2, $L0($t3) # armazenando valor no nona elemento do vetor
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no decima elemento do vetor			

				
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	# fixando os navios da segunda linha
	
	# zera o contador
	li $t3, 0
	
	# Porta Avioes
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
		
	# Porta Avioes
		sw $t1, $L1($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
	# Vazio	
		sw $t2, $L1($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Vazio		
		sw $t2, $L1($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4
	
	# Encouracado				
		sw $t1, $L1($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L1($t3) # armazenando valor no nona elemento do vetor	
	
	# vazio		
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no decima elemento do vetor
		

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
		
	# fixando os navios da terceira linha
	
	# zera o contador
	li $t3, 0
	
	# Vazio
		sw $t2, $L2($t3) # armazenando valor no primeiro elemento do vetor
		addi $t3, $t3, 4
	# Porta Avioes	 
		sw $t1, $L2($t3) # armazenando valor no segundo elemento do vetor
		addi $t3, $t3, 4
		
	# Cruzador				
		sw $t1, $L2($t3) # armazenando valor no terceiro elemento do vetor
		addi $t3, $t3, 4		
		sw $t1, $L2($t3) # armazenando valor no quarto elemento do vetor
		addi $t3, $t3, 4	
		sw $t1, $L2($t3) # armazenando valor no quinto elemento do vetor
		addi $t3, $t3, 4
	# Vazio	
		sw $t2, $L2($t3) # armazenando valor no sexto elemento do vetor
		addi $t3, $t3, 4
		
	# Cruzador		
		sw $t1, $L2($t3) # armazenando valor no setimo elemento do vetor
		addi $t3, $t3, 4					
		sw $t1, $L2($t3) # armazenando valor no oitavo elemento do vetor
		addi $t3, $t3, 4			
		sw $t1, $L2($t3) # armazenando valor no nona elemento do vetor
			
	# vazio		
		addi $t3, $t3, 4
		sw $t2, $L0($t3) # armazenando valor no decima elemento do vetor	
	

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

	# fixando os navios da quarta linha
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da quinta linha
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da sexta linha

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
			
	# fixando os navios da setima linha
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da oitava linha
	
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
	
	# fixando os navios da nova linha	

# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

			
.end_macro 

# Fixa valores definidos pelo usuario no Quadro Naval
.macro FixarNavios($elemento)
	
.end_macro

# imprime todos os elementos de uma linha do Quadro Naval
.macro Imprimir_Linha_Do_Quador_Naval($linha)
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 9 unidades	
	
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
	Imprimir_Linha_Do_Quador_Naval(linha0)
	ExibeMensagem("\n1 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quador_Naval(linha1)
	ExibeMensagem("\n2 |---|---|---|---|---|---|---|---|---|---|\n")
	ExibeMensagem("  ")
	Imprimir_Linha_Do_Quador_Naval(linha2)	
	ExibeMensagem("\n3 |---------------------------------------|\n")
	
.end_macro 

# |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

.data  # armazena os itens declarados	
	
	# declaracao de variaveis
	
	# Quadro da Batalha Naval vetores de caracteres
	linha0: .word 'a', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha1: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha2: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' 
	linha3: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha4: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha5: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha6: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha7: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha8: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha9: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
								
	
.text # a palavra reservada .text permite armazenar cadeia de caracteres em variaveis	
	
	# inicializacao de registradores
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 9 unidades		
	
	# declaracao de sub rotinas
		
	TelaInicial:	# tela inicial do jogo	
		
		ExibeMensagem("Batalha Naval\t-\tVersao 1.0 \n\n")
		inicializaQuadroNaval(linha0, linha1, linha2, linha3, linha4, linha5, linha6, linha7, linha8, linha9)
		
		ImprimirQuadroNaval
		
		ExibeMensagem("\n\nFim de jogo!\n\n\n")		
		
		jal FimJogo		# salta para a sub rotina "FimJogo"	
		
	FimJogo:		# fim do jogo