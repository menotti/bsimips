#################################################################################################
#
# NOME DO PROGRAMA: JOGO DA IDOSA
# AUTORES: ALINE FIGUEIREDO, CRISTIANO SANTANA, JESILENE GODOY E LUIS MIRANDA
#
# UM TIPICO JOGO DA VELHA, DESENVOLVIDO EM MARS PARA MIPS
#
# UNIVERSIDADE FEDERAL DE SÃO CARLOS
# ARQUITETURA DE COMPUTADORES
#
# AGRADECIMENTOS: Ao prezado Jerrekedb, um Belga que ao divulgar seu confuso código permitiu que 
# nós aprendêssemos a usar o BitMapDisplay.
# http://www.cppgameprogramming.com/newforums/viewtopic.php?f=7&t=1920
#
# -----------------------------------------------------
#  jogo da Idosa!-------------->UFSCar BSI.g5 - AC ----                                      
#  ----------------------------------------------------
#  --------------------------------aline figueiredo ---
#     |     |      ---------------- cristiano santana -
#  1  |  2  | 3     ---------------- jesilene godoy ---
# ----|-----|----     ---------------- luis miranda ---
#  4  |  5  | 6         -------------------------------
# ----|-----|----       -------------------------------
#  7  |  8  | 9         ------------------------------- 
#     |     |           -------------------------------
# ESCOLHA UMA POSICAO: 
#
#################################################################################################
.data
#inicialização do bitmap
bitmap_address:   .space 0x8000

#posicao no bitmap
pos_1:	.word 0
pos_2:	.word 84
pos_3:	.word 168
pos_4:	.word 5376
pos_5:	.word 5460
pos_6:	.word 5544
pos_7:	.word 10752
pos_8:	.word 10836
pos_9:	.word 10920

# menu para jogar
msg0:    .asciiz " -----------------------------------------------------\n"
msg1:    .asciiz "  jogo da Idosa!-------------->UFSCar BSI.g5 - AC ----\n"
msg2:    .asciiz "  ----------------------------------------------------\n"
msg3:    .asciiz "  --------------------------------aline figueiredo ---\n"
msg4:    .asciiz "     |     |      ---------------- cristiano santana -\n"
msg5:    .asciiz "  1  |  2  | 3     ---------------- jesilene godoy ---\n"
msg6:    .asciiz " ----|-----|----     ---------------- luis miranda ---\n"
msg7:    .asciiz "  4  |  5  | 6         -------------------------------\n"
msg8:    .asciiz " ----|-----|----       -------------------------------\n"
msg9:    .asciiz "  7  |  8  | 9         -------------------------------\n"
msgA:    .asciiz "     |     |           -------------------------------\n"
msgB:    .asciiz " ESCOLHA UMA POSICAO: \n"

# cores
black:      	.word 0x0
white:      	.word 0xffffff
red:      	.word 0xff8888
green:      	.word 0x00ff00
blue:      	.word 0x8888ff

.text
#monta jogo da velha
#como foi elaborado quando estávamos aprendendo a desenhar no BitmapDisplay foi feito linha
#por linha sem a criacao de subrotinas

	li $t2, 0x1500# 16384 posicao da primeira linha
	li $t3, 64 #16384    largura da primeira linha horizontal
	lw $a2,white #cor da linha
pulo_a:
	sw $a2, bitmap_address($t2)
	subi $t2, $t2, 4 #muda para a proxima posicao do bitmap
	subi $t3, $t3, 1 #derementa contador de largura
	beq $t3, $zero, fim_a #verifica fim
	j pulo_a
fim_a:

	li $t2, 0x2B00 #  posicao da segunda linha horizontal
	li $t3, 64  #largura
	lw $a2,white #cor da linha

#repete operacao para a segunda linha
pulo_b:
	sw $a2, bitmap_address($t2)
	subi $t2, $t2, 4
	subi $t3, $t3, 1
	beq $t3, $zero, fim_b
	j pulo_b
fim_b:
#traco da coluna
	li $t2, 84 #posicao da primeira linha vertical
	li $t3, 64 #altura da linha
	lw $a2,white #cor da linha
pulo_c:
	sw $a2, bitmap_address($t2) #comando que desenha pixel no Bitmap Display
	addi $t2, $t2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)
	subi $t3, $t3, 1	#decrementa contador
	beq $t3, $zero, fim_c   #testa fim
	j pulo_c
fim_c:
#segunda linha vertical
#
#     |     |  
#     |     |
# ----|-----|----
#     |     |  
#     |     |
# ----|-----|----
#     |     |  
#     |     |
#           \--> Esta é a segunda linha vertical
#



	li $t2, 168# 0x14e0 # 16384 posicao da segunda linha horizontal	
	li $t3, 64# 256 #16384    altura da linha
	lw $a2,white #0x00ffffff
pulo_d:
	sw $a2, bitmap_address($t2)
	addi $t2, $t2, 256	
	subi $t3, $t3, 1
	beq $t3, $zero, fim_d
	j pulo_d
fim_d:

#aqui comecara a esperar a tecla do usuario
#ainda precisara ser implementado
#o usuario que teclar primeiro sera o x
#o usuario que teclar depois ser o y
#cada um devera teclar de 1 a 9
	li  $v0, 4
	la $a0, msg0
	syscall
	la $a0, msg1
	syscall
	la $a0, msg2
	syscall
	la $a0, msg3
	syscall
	la $a0, msg4
	syscall
	la $a0, msg5
	syscall	
	la $a0, msg6
	syscall
	la $a0, msg7
	syscall
	la $a0, msg8
	syscall
	la $a0, msg9
	syscall
	la $a0, msgA
	syscall
	la $a0, msgB
	syscall	

	
	lw $t2, pos_1 # 0x14e0 # 16384 posicao da segunda linha horizontal	
	jal faz_x

	lw $t2, pos_5 # 0x14e0 # 16384 posicao da segunda linha horizontal	
	jal faz_o
	
	lw $t2, pos_9 # 0x14e0 # 16384 posicao da segunda linha horizontal	
	jal faz_x
	
	lw $t2, pos_3 # 0x14e0 # 16384 posicao da segunda linha horizontal	
	jal faz_o
	
	li $v0,10
	syscall
	
	

###########################################################
#  SUBROTINA faz_x
#  FINCAO: desenha o X na posicao determinada por $t2
#
###########################################################
	
faz_x:
	li $t3, 20 # 256 #16384    altura da linha
	lw $a2,blue #0x00ffffff

pulo_xa:
	sw $a2, bitmap_address($t2)
	addi $t2, $t2, 4 #diagonal
	sw $a2, bitmap_address($t2)
	addi $t2, $t2, 256	
	subi $t3, $t3, 1
	beq $t3, $zero, fim_xa
	j pulo_xa
fim_xa:
	
	subi $t2, $t2, 5376
	li $t3, 20
	lw $a2,blue
	
	
pulo_xb:	
	sw $a2, bitmap_address($t2)
	subi $t2, $t2, 4 #diagonal
	sw $a2, bitmap_address($t2)
	addi $t2, $t2, 256	
	subi $t3, $t3, 1
	beq $t3, $zero, fim_xb
	j pulo_xb
fim_xb:
	jr $ra
	
	

###########################################################
#  SUBROTINA faz_o
#  FINCAO: desenha o O na posicao determinada por $t2
#
###########################################################

faz_o: 

	addi $t2, $t2, 40 #posiciona na metade da casa do jogo da velha
	li $t3, 10 # contador que determina a altura da metade de cuma do circulo
	li $t4,0  # controle de espacamento
	lw $a2,red #cor da bola

pulo_oa:
	sub	$t5,$t2,$t4 #mecanismo de controle de espacamento
	#desenho da metade de cima do circulo
	#primeiro desenho dois pontos
	sw 	$a2, bitmap_address($t5)
	addi 	$t5, $t5, 4 
	sw 	$a2, bitmap_address($t5)	
	#depois acrescento o espaçamento que cresce dentor da bola
	add	$t5,$t5,$t4
	add	$t5,$t5,$t4
	#enfim desenho os dois pontos depois do espacamento
	sw 	$a2, bitmap_address($t5)
	addi 	$t5, $t5, 4 
	sw 	$a2, bitmap_address($t5)	
			
	#pulo pra linha (BITMAP) debaixo
	add	$t2, $t2, 256
	
	#incremento espacamento
	addi 	$t4, $t4, 4	
	
	#decremento contador que conta ate a metade da "bola"
	subi 	$t3, $t3, 1
	beq 	$t3, $zero, fim_oa
	j 	pulo_oa
fim_oa:
	
	li $t3, 10 #contador que determina a altura da metade debaixo do circulo

pulo_ob:	
	
	sub	$t5,$t2,$t4
	
	#desenho dois pontos
	sw 	$a2, bitmap_address($t5)
	addi 	$t5, $t5, 4 
	sw 	$a2, bitmap_address($t5)	
	#acrescento o espaçamento que cresce dentor do 0
	add	$t5,$t5,$t4
	add	$t5,$t5,$t4
	#desenho os ponots depois do espacamento
	sw 	$a2, bitmap_address($t5)
	addi 	$t5, $t5, 4 
	sw 	$a2, bitmap_address($t5)	
	
		
	#pulo pra linha (BITMAP) debaixo
	add	$t2, $t2, 256
	#decremento espacamento
	subi 	$t4, $t4, 4	
	#decremento contador que conta ate a metade da "bola"
	subi 	$t3, $t3, 1
	beq 	$t3, $zero, fim_ob
	j 	pulo_ob
fim_ob:
		
		
	jr $ra
