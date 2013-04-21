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
		acertos: 0		# quantidade de acertos do usuario
		chances_restantes: 5 	# quantidade de chances que o usuario tem
		
.text

# declaração de procedimentos
# procedimento criado para exibir mensagens		
.macro	ExibeMensagem(%texto)
	.data
		mensagemTexto: .asciiz %texto
	.text
		la $a0, mensagemTexto	
		li $v0, 4
		syscall
		
.end_macro 

# Le um caracter alfanumerico
.macro LerCaracter($valorCaracter)
.end_macro 		

# Le um caracter numerico
.macro LerInteiro($valorInteiro)
.end_macro 	

# Le uma coordenada do quadro naval
.macro LerCoordenada($coordX,$coordY)	
.end_macro 

# Le um caracter alfanumerico
.macro contabilizaAcerto($coordX, $coordY, $acerto, $chances)
.end_macro 				
	


# declaração de mensagens 

.data  # armazena os itens declarados	
	
	# declaracao de variaveis
	
	# Quadro da Batalha Naval vetores de caracteres
	linha1: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha2: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' 
	linha3: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha4: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha5: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha6: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha7: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha8: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha9: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	linha0: .word ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
	
	caracter: .asciiz " "
	espacamento: .asciiz "\t"
	quebraLinha: .asciiz "\n"
	
	# strings de mensagem
	tituloJogo: .asciiz ""
	avisoFimDeJogo: .asciiz "\n\nFim de jogo!\n\n\n"							
	
.text # a palavra reservada .text permite armazenar cadeia de caracteres em variaveis	
	
	# inicializacao de registradores
	
	li $t1, 0				# contador de enderecos
	li $t2, 10				# contador regressivo iniciado com 9 unidades		
	
	# declaracao de sub rotinas
		
	TelaInicial:	# tela inicial do jogo
	
		la $a0, tituloJogo
		ExibeMensagem("Batalha Naval\t-\tVersao 1.0 \n\n")
		#jal ExibeMensagem		# salta para a sub rotina "ExibeMensagem"
		
		Loop:
		
			
		        #sw $s1, ($s2)		# escreve um caracter na memoria		            
			lw $a0, linha1($t1)		# recebe o conteudo do vetor
			jal ExibeCaracter						
			addi $t1, $t1, 	4	# incrementa para a proxima posicao			
			subi $t2, $t2 1		# decrementa o contador de controle do loop			
			
									
			bgtz $t2, Loop
		
		la $a0, avisoFimDeJogo	# armazena a o título do jogo no registrador $a0		
		
		jal FimJogo		# salta para a sub rotina "FimJogo"
		
		
	ExibeCaracter:		# exibe caracteres
		li $v0, 11
		syscall
		jr $ra	
		
		
	FimJogo:		# fim do jogo	
