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




# declaração de mensagens 

.data  # armazena os itens declarados	
	
	# declaracao de variaveis
	
	# strings de mensagem
	tituloJogo: .asciiz "Batalha Naval\t-\tVersao 1.0\n\n"			
	
.text # a palavra reservada .text permite armazenar cadeia de caracteres em variaveis	
	
	
	# declaracao de sub rotinas
		
	TelaInicial:	# tela inicial do jogo
	
		la $a0, tituloJogo	# armazena a o título do jogo no registrador $a0
		jal ExibeMensagem	# salta para a sub rotina "ExibeMensagem"
		jal FimJogo		# salta para a sub rotina "FimJogo"		
							
	
	ExibeMensagem:		# exibe mensagens
		li $v0, 4
		syscall
		jr $ra
	
			
	FimJogo:		# fim do jogo	
