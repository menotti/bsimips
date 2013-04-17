#**********************************************************************************************************************************#
#  UFSCar - Sistema de Informação												   #
#  Discipina: Arquitetura de Computadores											   #
#  Professor: Ricardo Menotti													   #												   #
#  																   #
#  Projeto Jogo em Assembly - Jogo da Velha											   #
#																   #
#  Autores: Adriano Marinho de Oliveira - RA: 482340										   #
#	    Alessandro L. Santos	- RA: 482358										   #
#	    Eurico Borges da Silva	- RA: 482374
#	    Fabiano										   #
#																   #
#   														Março/2013   	   #
#**********************************************************************************************************************************#

.data

	

	forca:  .asciiz "===========\n|#|      ||\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n"
	cabeca:	.asciiz "===========\n|#|      ||\n|#|     \\||//\n|#|     | ..|\n|#|      \\./\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n|#|\n"
	f1:	.asciiz "|#|      ||\n"
	f2:	.asciiz "|#|    \\||//\n"
	f3:	.asciiz "|#|     | ..|\n"
	f4:	.asciiz "|#|      \./\n"
	f5:	.asciiz "|#|      | |\n"
	f6:	.asciiz "|#|    --   --\n"
	f7:	.asciiz "|#|  / /\   /\ \n"
	f8:	.asciiz "|#| / / |   | \ \\n"
	f9:	.asciiz "|#|(_)  |___|  (_)\n"
	f10:	.asciiz "|#|     / __ \\n"
	f11:	.asciiz "|#|    / /  \ \\n"
	f12:	.asciiz "|#|  _/ /    \ \_\n"
	f13:	.asciiz "|#| (__/      \__)\n"
	

	
	mens:	  .asciiz "Digite uma letra: "
	fase1:	  .word 'U','F','S','C','A','R'
	campo1:	  .word '_','_','_','_','_','_'
	

.text
	li $3, 0
	la $a0, fase1
	 
	 jal des_forca
	 
	  loop:
		lw $t2, ($a0)
		li $v0, 4
		syscall
		addi $3, $3, 1
		addi $a0, $a0, 4
		beq $3, 6, exit
		j loop

	
#------------------------------------------------------------------------------
# DESENHAR FORCA
#------------------------------------------------------------------------------
des_forca:
	li  $v0, 4
	la $a0, cabeca
	syscall
	
	li $v0, 4
	la $a0, mens
	syscall
								
#------------------------------------------------------------------------------				
# finalizar programa	
#------------------------------------------------------------------------------				
  exit:
	