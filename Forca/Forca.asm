#**********************************************************************************************************************************#
#  UFSCar - Sistema de Informação												   #
#  Discipina: Arquitetura de Computadores											   #
#  Professor: Ricardo Menotti													   #												   #
#  																   #
#  Projeto Jogo em Assembly - Jogo da Forca											   #
#																   #
#  Autores: Adriano Marinho de Oliveira - RA: 482340										   #
#	    Alessandro L. Santos	- RA: 482358										   #
#	    Eurico Borges da Silva	- RA: 482374										   #
#    	    Fabiano Henrique da Silva	- RA: 482366 									           #
#																   #
#   														Março/2013   	   #
#**********************************************************************************************************************************#

.data
	str1: .space 4 	# reserva 4 byte (31 bits) espaço em memória

	boneco0:  .asciiz "===========\n|#|      ||\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n"
	boneco1:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n"
	boneco2:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n"
	boneco3:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|  / /\n|#| / /\n|#|(_)\n|#|\n|#|\n|#|\n|#|\n"	
	boneco4:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|  / /\    \\ \\ \n|#| / /      \\ \\ \n|#|(_)        (_)\n|#|\n|#|\n|#|\n|#|\n"
	boneco5:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|  / /\    \\ \\ \n|#| / / |   |\\ \\ \n|#|(_)  |___| (_)\n|#|\n|#|\n|#|\n|#|\n"
	boneco6:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|  / /\    \\ \\ \n|#| / / |   |\\ \\ \n|#|(_)  |___| (_)\n|#|     /  \n|#|    / / \n|#|  _/ /  \n|#| (__/   \n"
	boneco7:  .asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|      | |\n|#|    --   --\n|#|  / /\    \\ \\ \n|#| / / |   |\\ \\ \n|#|(_)  |___| (_)\n|#|     / __\\     \n|#|    / / \\ \\    \n|#|  _/ /   \\ \\_  \n|#| (__/     \\__) \n"
	
	palavra:  .asciiz "    Palavra: "
	perdeu:   .asciiz "   Voce Perdeu....."
	ganhou:   .asciiz "   Parabens voce descobriu a palavra"
	mensDL:	  .asciiz "\n  Digite uma letra: "
	
	fase1:	  .word 'U','F','S','C','A','R'
	dica:	  .asciiz "  Dica:  Universidade"
	campo1:	  .word 64,64,64,64,64,64
	tamanho:  .byte 6
	

.text
	li $2, 0 	#Erros 
	li $t9, 1	#verificar vitória
	li $3, 0	#contador tamanho da palavra
	lw $t7, tamanho	#tamanho palavra

#Exibir a Forca e boneco
exibir_boneco:
	j desenhar_boneco

main:	 

	la $a0, mensDL		#Escrever Digte uma Letra e aguarde o usuário digitar uma letra	
	jal print_string	#método imprimir uma string
	
	#Manipulação de String
	li $v0,8		#receber um String
	la $a0,str1
	addi $a1,$zero,20
	syscall             
	
    	la $a0,str1         	#passar o endereço da String  
    	jal letra_dig		#Método verificar a letra digitada com a palavra a ser adivinhada

	j desenhar_boneco	#desenhar boneco


#Subrotina para imprimir String
print_string:
	li $v0, 4
	syscall
	jr $ra			

#Subrotina para imprimir no cmapo a posição da letra
print_achou:

	loopc:	beq $3, $t7, exitloopc  #while enquanto $3 != $t7
		lw $t1, ($a0)		#Imprimir o valores do Campo
		li $v0, 4
		syscall
		addi $a0, $a0, 4	#incremento 
		addi $3, $3, 1		#contador do loop
		j loopc			#loop
		
	exitloopc:
		li $3, 0		#definir valor do registrador $3 -> 0
		jr $ra


#Verificar letra digitada se existe na palavra a ser adivinhada
letra_dig:
		add $t1,$zero,$a0
		la $t2, fase1
		la $t0, campo1
		
	loopL: 	beq $3, $t7, exitloopL  	#compara se chegou no final do vetor
		lb $t3, ($t1) 			#Carrega o byte da string
		lw $t4, ($t2) 			#carregar palavra a ser adivinhada
		lw $t5, ($t0) 			#Carregar campo da palavra para ser preenchido
		beq $t4, $t3, gravaLvetor  	#comparação de caracteres, se for iguais usuário acertou a letra grava na posição do campo
		addi $t2, $t2, 4 		#incremento palavra
		addi $t0, $t0, 4 		#incremento posição da palavra
		addi $3, $3, 1  		#incremento $3 com número de repetição
		j loopL
	exitloopL:
		beq $t6, 1, acertou
		addi $t8, $t8, 1 		#contador de número de erro	
		li $3, 0
		jr $ra
	acertou:
		li $t6, 0
		li $3, 0
		jr $ra
	gravaLvetor:
		li $t6, 1
		sw $t3, ($t0)     #grava a letra que foi adivinha no campo da palavra
		addi $t2, $t2, 4  #incremento palavra
		addi $t0, $t0, 4  #incremento posição da palavra
		addi $3, $3, 1    #incremento $3 com número de repetição
		j loopL


#  D e s e n  h a r   B o n e c o
desenhar_boneco:
	
	beq $t9, 0, jogador_ganhou
	beq $t8, 0, b0
	beq $t8, 1, b1
	beq $t8, 2, b2
	beq $t8, 3, b3
	beq $t8, 4, b4
	beq $t8, 5, b5
	beq $t8, 6, b6
	beq $t8, 7, b7
	beq $t8, 8, jogador_perdeu
	
	
	b0:
	   la $a0, boneco0	#Desenhar apenas a Forca
	   li $v0, 4		#imprimi uma string
	   syscall		#executar
	   la $a0, dica		#Exibir dica
	   jal print_string
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b1:
	   la $a0, boneco1
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b2:
	   la $a0, boneco2
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b3:
	   la $a0, boneco3
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b4:
	   la $a0, boneco4
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b5:
	   la $a0, boneco5
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b6:
	   la $a0, boneco6
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
	b7:
	   la $a0, boneco7
	   li $v0, 4
	   syscall
	   la $a0, palavra	#Exibir a palavra campos
	   jal print_string
	   la $a0, campo1	#Exibir Campo da Palavra a ser preenchido
	   jal print_achou	#método imprimir letras encontradas
	   j main
		
	jogador_perdeu:
	   la $a0, perdeu
	   jal print_string
	   
	   li $v0, 10	#Finalizar o Programa
	   syscall
	   
	jogador_ganhou:
	   la $a0, ganhou
	   jal print_string
	   
	   li $v0, 10   #Finalizar o programa
	   syscall
	  
#------------------------------------------------------------------------------				
# finalizar programa	
#------------------------------------------------------------------------------				
  exit:
	
#
#	"===========\n"
#	"|#|      ||\n"
#	"|#|    \\||//\n"
#	"|#|     | ..|\n"
#	"|#|      \./\n"
#	"|#|      | |\n"
#	"|#|    --   --\n"
#	"|#|  / /\   /\ \n"
#	"|#| / / |   | \ \\n"
#	"|#|(_)  |___|  (_)\n"
#	"|#|     / __ \\n"
#	"|#|    / /  \ \\n"
#	"|#|  _/ /    \ \_\n"
#	"|#| (__/      \__)\n"
