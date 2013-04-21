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
		mensagemTexto: .asciiz %texto
	.text
		la $a0, mensagemTexto	
		li $v0, 4
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
.macro contabilizaAcerto($coordX, $coordY, $acerto, $chances)
.end_macro 				

# Inicializa o Quadro Naval
.macro inicializaQuadroNaval($elemento)
.end_macro 

# Fixa valores definidos pelo usuario no Quadro Naval
.macro FixarNavios($elemento)
.end_macro

# declaração de mensagens 

.data  # armazena os itens declarados	
	
	# declaracao de variaveis
	
	# Quadro da Batalha Naval vetores de caracteres
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
								
	
.text # a palavra reservada .text permite armazenar cadeia de caracteres em variaveis	
	
	# inicializacao de registradores
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 9 unidades		
	
	# declaracao de sub rotinas
		
	TelaInicial:	# tela inicial do jogo	
		
		ExibeMensagem("Batalha Naval\t-\tVersao 1.0 \n\n")
		#jal ExibeMensagem		# salta para a sub rotina "ExibeMensagem"
		
		Loop:		
			
		        #sw $s1, ($s2)			# escreve um caracter na memoria		            
		        lw $a1, linha1($t1)
			ExibeCaracter($a1)	# recebe e imprime o conteudo do vetor			
			addi $t1, $t1, 	4	# incrementa para a proxima posicao			
			subi $t2, $t2 1		# decrementa o contador de controle do loop			
									
			bgtz $t2, Loop		# realiza o loop ate que o contador zere		
		
		
		ExibeMensagem("\n\nFim de jogo!\n\n\n")		
		
		jal FimJogo		# salta para a sub rotina "FimJogo"	
		
	FimJogo:		# fim do jogo