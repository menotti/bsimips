#################################################################################################
#
# NOME DO PROGRAMA: JOGO DA IDOSA
# AUTORES: CRISTIANO SANTANA, JESILENE GODOY E LUIS MIRANDA
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
#  jogo da Idosa! ------------->UFSCar BSI.g5 - AC ----
#  ----------------------------------------------------
#  ------------------------------- aline figueiredo ---
#     |     |      ---------------- cristiano santana -
#  1  |  2  | 3     ---------------- jesilene godoy ---
# ----|-----|----     ---------------- luis miranda ---
#  4  |  5  | 6         -------------------------------
# ----|-----|----       -------------------------------
#  7  |  8  | 9         ------------------------------- 
#     |     |           -------------------------------
# ESCOLHA UMA POSICAO: 
#
#
#
# 11/4/13 23:55 
# Nesta versao foi acrescentado:
#    - a checagem para ver se foi escolhida a mesma posicao duas vezes (e armazenado de $t1 a $t9 as escolhas de X(1) e O(0))
#    - os locais que usava as variaveis $t2 mudei para $a1 que nao estava sendo usada
#    - os locais que usava as variaveis $t7 mudei para $a3 que nao era usada
#    - incrementei na funcao do Luis (verposicao) a possibilidade de retornar em $v1 se a posicao de $t1 a $t9 estava desocupada para atribuir o valor entrado pelo teclado
#    - se em algum momento algum jogador tecla 0 (zero) o jogo acaba.
#  FALTA: checar se teclou mais de 9 vezes ($verificar se $a3>9)
#         checar fazendo comparacoes com os registros $t1 a $t9 se alguem ganhou (lembrando que se eles valem 2 estao livres, se valem 1 eh X e se valem 0 eh 0) 
#  PROPOSTA: nao fazer pontuacao ou oportunidade de jogar mais de uma vez. O jogo so permite uma partida, e no final diz se deu velha se X ganhou ou se O ganhou.
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
msg1:    .asciiz "  jogo da Idosa! ------------->UFSCar BSI.g5 - AC ----\n"
msg2:    .asciiz "  ----------------------------------------------------\n"
msg3:    .asciiz "  ------------------------------- aline figueiredo ---\n"
msg4:    .asciiz "     |     |      ---------------- cristiano santana -\n"
msg5:    .asciiz "  1  |  2  | 3     ---------------- jesilene godoy ---\n"
msg6:    .asciiz " ----|-----|----     ---------------- luis miranda ---\n"
msg7:    .asciiz "  4  |  5  | 6         -------------------------------\n"
msg8:    .asciiz " ----|-----|----       -------------------------------\n"
msg9:    .asciiz "  7  |  8  | 9         ------ (0) ZERO SAI DO JOGO ---\n"
msgA:    .asciiz "     |     |           -------------------------------\n"
msgB:    .asciiz " ESCOLHA UMA POSICAO: \n"

msgFIM_X:    .asciiz " FIM DO JOGO - X VENCEU \n"
msgFIM_O:    .asciiz " FIM DO JOGO - 0 VENCEU \n"
msgFIM:    .asciiz " FIM DO JOGO - TECLOU 0 (ZERO) \n"
# cores
black:      	.word 0x0
white:      	.word 0xffffff
red:      	.word 0xff8888
green:      	.word 0x00ff00
blue:      	.word 0x8888ff

.text
#
# Definicoes:
# pontuacao do jogador X $k1
# pontuacao do jogador O $k0
#
# vez do jogador X BIT MENOS SIGNFICATIVO DE $t0 = 1  -NUMEROS IMPARES
# vez do jogador O BIT MENOS SIGNFICATIVO DE $t0 = 0  -NUMEROS PARES
#
#     |     |     
#  1  |  2  | 3   
# ----|-----|---- 
#  4  |  5  | 6   
# ----|-----|---- 
#  7  |  8  | 9   
#     |     |     
# posicao 1 $t1
# posicao 2 $t2 
# posicao 3 $t3
# posicao 4 $t4
# posicao 5 $t5
# posicao 6 $t6
# posicao 7 $t7
# posicao 8 $t8
# posicao 9 $t9



#INÍCIO DO PROGRAMA!
	#Zera a pontuacao do jogador X
	li $k1, 0
	#Zera a pontuaçao do jogador O
	li $k0, 0
	#inicia o jogo com o X
	li $a3, 1 
	
	li $t1, 2 #INICIALIZA AS POSICOES SEM NENHUM VALOR (NEM X NEM O)
	li $t2, 2
	li $t3, 2
	li $t4, 2
	li $t5, 2
	li $t6, 2
	li $t7, 2
	li $t8, 2
	li $t9, 2
	
	
main:
	j tabuleiro #DESENHA O TABULEIRO
	
	
volta_ao_principal:
	j menu
volta_menu:
	


tecla19:	li $v0,5 #tecla de 1 até 9
		syscall

		# Entrada de teclado posicao 1 a 9
		andi $s1, $a3, 1
		j verPosicao
volta_verPosicao:

	bnez $v1, volta_ao_principal #se foi escolhido uma posicao ja ocupada em outra jogada nao desenha nada
			
	
	
	# ver quem e o jogador extrair  LSB 0 ou 1
	# andi $s1, $a3, 1  

	#  se 0 fazX  se 1 fazO
	beq  $s1,$zero,fazo	
fazx:	jal faz_x
	bne $s1,$zero,fimfaz    
fazo:	jal faz_o	

	# incrementa contador - proxima jogada
fimfaz:	addi $a3,$a3,1

	bgt $a3, 9, fim_do_jogo
	bgt $a3, 4, alguem_ganhou #ainda nao implementada
volta_alguem_ganhou:
	j tecla19  

	li $v0,10
	syscall
	
	

###########################################################
#  SUBROTINA faz_x
#  FINCAO: desenha o X na posicao determinada por $a1
#  UTILIZA: $s2 $s3, $a2
###########################################################
	
faz_x:
	li $s3, 20 # 256 #16384    altura da linha
	lw $a2,blue #0x00ffffff

pulo_xa:
	sw $a2, bitmap_address($a1)
	addi $s2, $s2, 4 #diagonal
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 256	
	subi $s3, $s3, 1
	beq $s3, $zero, fim_xa
	j pulo_xa
fim_xa:
	
	subi $s2, $s2, 5376
	li $s3, 20
	lw $a2,blue
	
	
pulo_xb:	
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #diagonal
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 256	##########
	subi $s3, $s3, 1
	beq $s3, $zero, fim_xb
	j pulo_xb
fim_xb:
	jr $ra
	
	

###########################################################
#  SUBROTINA faz_o
#  FINCAO: desenha o O na posicao determinada por $a1
#  UTILIZA: $s2 $s3, $s4, $s5, $a2
###########################################################

faz_o: 

	addi $s2, $s2, 40 #posiciona na metade da casa do jogo da velha
	li $s3, 10 # contador que determina a altura da metade de cuma do circulo
	li $s4,0  # controle de espacamento
	lw $a2,red #cor da bola

pulo_oa:
	sub	$s5,$s2,$s4 #mecanismo de controle de espacamento
	#desenho da metade de cima do circulo
	#primeiro desenho dois pontos
	sw 	$a2, bitmap_address($s5)
	addi 	$s5, $s5, 4 
	sw 	$a2, bitmap_address($s5)	
	#depois acrescento o espaçamento que cresce dentor da bola
	add	$s5,$s5,$s4
	add	$s5,$s5,$s4
	#enfim desenho os dois pontos depois do espacamento
	sw 	$a2, bitmap_address($s5)
	addi 	$s5, $s5, 4 
	sw 	$a2, bitmap_address($s5)	
			
	#pulo pra linha (BITMAP) debaixo
	add	$s2, $s2, 256
	
	#incremento espacamento
	addi 	$s4, $s4, 4	
	
	#decremento contador que conta ate a metade da "bola"
	subi 	$s3, $s3, 1
	beq 	$s3, $zero, fim_oa
	j 	pulo_oa
fim_oa:
	
	li $s3, 10 #contador que determina a altura da metade debaixo do circulo

pulo_ob:	
	
	sub	$s5,$s2,$s4
	
	#desenho dois pontos
	sw 	$a2, bitmap_address($s5)
	addi 	$s5, $s5, 4 
	sw 	$a2, bitmap_address($s5)	
	#acrescento o espaçamento que cresce dentor do 0
	add	$s5,$s5,$s4
	add	$s5,$s5,$s4
	#desenho os ponots depois do espacamento
	sw 	$a2, bitmap_address($s5)
	addi 	$s5, $s5, 4 
	sw 	$a2, bitmap_address($s5)	
	
		
	#pulo pra linha (BITMAP) debaixo
	add	$s2, $s2, 256
	#decremento espacamento
	subi 	$s4, $s4, 4	
	#decremento contador que conta ate a metade da "bola"
	subi 	$s3, $s3, 1
	beq 	$s3, $zero, fim_ob
	j 	pulo_ob
fim_ob:
		
		
	jr $ra


###########################################################
#  SUBROTINA tabuleiro
#  FUNCAO: desenha o tabuleiro no BitMapDisplay
#  UTILIZA: $s2, $s3 e $a2
###########################################################
tabuleiro:	
	#monta jogo da velha
#como foi elaborado quando estávamos aprendendo a desenhar no BitmapDisplay foi feito linha
#por linha sem a criacao de subrotinas

	li $s2, 0x1500# 16384 posicao da primeira linha
	li $s3, 64 #16384    largura da primeira linha horizontal
	lw $a2,white #cor da linha
pulo_a:
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 #derementa contador de largura
	beq $s3, $zero, fim_a #verifica fim
	j pulo_a
fim_a:

	li $s2, 0x2B00 #  posicao da segunda linha horizontal
	li $s3, 64  #largura
	lw $a2,white #cor da linha

#repete operacao para a segunda linha
pulo_b:
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4
	subi $s3, $s3, 1
	beq $s3, $zero, fim_b
	j pulo_b
fim_b:
#traco da coluna
	li $s2, 84 #posicao da primeira linha vertical
	li $s3, 64 #altura da linha
	lw $a2,white #cor da linha
pulo_c:
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)
	subi $s3, $s3, 1	#decrementa contador
	beq $s3, $zero, fim_c   #testa fim
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



	li $s2, 168# 0x14e0 # 16384 posicao da segunda linha horizontal	
	li $s3, 64# 256 #16384    altura da linha
	lw $a2,white #0x00ffffff
pulo_d:
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 256	
	subi $s3, $s3, 1
	beq $s3, $zero, fim_d
	j pulo_d
fim_d:
	j volta_ao_principal


###########################################################
#  SUBROTINA menu
#  FINCAO: so desenha o menu de escolha de posicao
#  UTILIZA: $v0, $a0
###########################################################
menu:
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
	
	j volta_menu




###########################################################
#  SUBROTINA verPosicao
#  Funcao: marca qual a posicao desenho
#  UTILIZA: 0, $v0, $s2, $t0, $s1 (recebe se e a jogada do X ou do O), usa de $t1 a $t9 (armazeando 0 se a posicao estiver com O e 1 se tiver com X), 
#  Retorna: $s2 com o endereco do bitmap onde deve ser desenhado
#           se $v1 igual a zero deve ser desenhado o X ou o 0, senao quer dizer que a posicao ja esta ocupada
###########################################################
verPosicao:

# falta Ver se Posicao Ocupada
	beqz	$v0, fim_do_jogo


	# aqui verifica a posicao  se 1 
	subi $t0, $v0, 1 
	bne $t0,$zero, posi2
	 
	subi $v1, $t1, 2 #verifica se a casa 1 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t1, $s1, 0 #$t1 recebe $s1 (1 se e X ou 0 se O)
	
	lw $s2, pos_1 
	# aqui verifica a posicao  se 2
posi2:	subi $t0, $v0,2 
	bne $t0,$zero,posi3	
	
	subi $v1, $t2, 2 #verifica se a casa 2 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t2, $s1, 0 #$t2 recebe $s1 (1 se e X ou 0 se O)
	
	lw $s2, pos_2 
	# aqui verifica a posicao  se 3
posi3:	subi $t0, $v0,3
	bne $t0,$zero,posi4
	
	subi $v1, $t3, 2 #verifica se a casa 3 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t3, $s1, 0 #$t3 recebe $s1 (1 se e X ou 0 se O)
	
	
	lw $s2, pos_3 
	# aqui verifica a posicao  se 4
posi4:	subi $t0, $v0, 4
	bne $t0,$zero,posi5
	
	subi $v1, $t4, 2 #verifica se a casa 4 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t4, $s1, 0 #$t4 recebe $s1 (1 se e X ou 0 se O)
	
	
	lw $s2, pos_4  
posi5:	subi $t0, $v0, 5
	bne $t0,$zero,posi6
	
	subi $v1, $t5, 2 #verifica se a casa 5 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t5, $s1, 0 #$t5 recebe $s1 (1 se e X ou 0 se O)
	
	
	lw $s2, pos_5	  
posi6:	subi $t0, $v0, 6
	bne $t0,$zero,posi7
	
	subi $v1, $t6, 2 #verifica se a casa 6 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t6, $s1, 0 #$t6 recebe $s1 (1 se e X ou 0 se O)
	
	
	lw $s2, pos_6  
posi7:	subi $t0, $v0, 7
	bne $t0,$zero,posi8
	
	subi $v1, $t7, 2 #verifica se a casa 7 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t7, $s1, 0 #$t7 recebe $s1 (1 se e X ou 0 se O)
	
	
	
	lw $s2, pos_7  
posi8:	subi $t0, $v0, 8
	bne $t0,$zero,posi9
	
	subi $v1, $t8, 2 #verifica se a casa 8 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t8, $s1, 0 #$t8 recebe $s1 (1 se e X ou 0 se O)
	
	
	
	lw $s2, pos_8  
posi9:	subi $t0, $v0, 9
	bne $t0,$zero,fimPos
	
	subi $v1, $t9, 2 #verifica se a casa 9 esta vazia conferindo se ela eh igual a 2
	bnez $v1, fimPos
	addi $t9, $s1, 0 #$t9 recebe $s1 (1 se e X ou 0 se O)
	
	
	lw $s2, pos_9
	j fimPos  
####################### Termina JOGO ###############################	
fim_do_jogo:	
	li  $v0, 4
	la $a0, msgFIM
	syscall
	
	li $v0, 10 # termina programa se teclar 0
	syscall  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
###################################################################
		
						
# marcar posicao na Matriz para soma dos pontos
fimPos:	J volta_verPosicao

##################################################################
# Funcao alguem_ganhou
#
#
##################################################################
alguem_ganhou:
	jal traca_123
	j volta_alguem_ganhou
##################################################################
# Funcao traca_123
#
#
##################################################################
traca_123:
	# chame esta funcao com o comando abaixo que voltara sozinho
	#jal traca_123
	li $s2, 0x0B00# 16384 posicao da primeira linha
	li $s3, 64 #16384    largura da primeira linha horizontal
	lw $a2,red #cor da linha
pulo123_a:
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 #derementa contador de largura
	beq $s3, $zero, fim123_a #verifica fim
	j pulo123_a
fim123_a:	
	jr $ra
	
##################################################################
# Funcao traca_456
#
#
##################################################################	
traca_456:
	#jal traca_123
	li $s2, 0x2000# 16384 posicao da primeira linha
	li $s3, 64 #16384    largura da primeira linha horizontal
	lw $a2,green #cor da linha
pulo456_a:
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 #derementa contador de largura
	beq $s3, $zero, fim456_a #verifica fim
	j pulo456_a
fim456_a:	
	jr $ra
	
	
##################################################################
# Funcao traca_789
#
#
##################################################################	
traca_789:
	#jal traca_123
	li $s2, 0x3600# 16384 posicao da primeira linha
	li $s3, 64 #16384    largura da primeira linha horizontal
	lw $a2,blue #cor da linha
pulo789_a:
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap
	subi $s3, $s3, 1 #derementa contador de largura
	beq $s3, $zero, fim789_a #verifica fim
	j pulo789_a
fim789_a:	
	jr $ra
	
	
##################################################################
# Funcao traca_147
#
#
##################################################################	
traca_147:
	#jal traca_147
#traco da coluna
	li $s2, 40 #posicao da primeira linha vertical
	li $s3, 64 #altura da linha
	lw $a2, red #cor da linha
pulo147_c:
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)
	subi $s3, $s3, 1	#decrementa contador
	beq $s3, $zero, fim147_c   #testa fim
	j pulo147_c
fim147_c:
	jr $ra


##################################################################
# Funcao traca_258
#
#
##################################################################
traca_258:
	#jal traca_258
#traco da coluna
	li $s2, 124 #posicao da primeira linha vertical
	li $s3, 64 #altura da linha
	lw $a2, green #cor da linha
pulo258_c:
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)
	subi $s3, $s3, 1	#decrementa contador
	beq $s3, $zero, fim258_c   #testa fim
	j pulo258_c
fim258_c:
	jr $ra
	
	
	
##################################################################
# Funcao traca_369
#
#
##################################################################
traca_369:
	#jal traca_369
#traco da coluna
	li $s2, 208 #posicao da primeira linha vertical
	li $s3, 64 #altura da linha
	lw $a2, blue #cor da linha
pulo369_c:
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)
	subi $s3, $s3, 1	#decrementa contador
	beq $s3, $zero, fim369_c   #testa fim
	j pulo369_c
fim369_c:
	jr $ra


##################################################################
# Funcao traca_753
#
#
##################################################################
traca_753:
	#jal traca_753
faz753_x:
	li $s2, 0
	li $s3, 256 # 256 #16384    altura da linha
	lw $a2,blue #0x00ffffff

pulo753_xa:
	sw $a2, bitmap_address($a1)
	addi $s2, $s2, 4 #diagonal
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 256	
	subi $s3, $s3, 1
	beq $s3, $zero, fim753_xa
	j pulo753_xa
fim753_xa:
	jr $ra


	
	
##################################################################
# Funcao traca_159
#
#
##################################################################	
traca_159:
	#jal traca_159
	#subi $s2, $s2, 5376
	li $s2, 256
	li $s3, 64
	lw $a2,blue
	
	
pulo159_xb:	
	sw $a2, bitmap_address($s2)
	subi $s2, $s2, 4 #diagonal
	sw $a2, bitmap_address($s2)
	addi $s2, $s2, 256	##########
	subi $s3, $s3, 1
	beq $s3, $zero, fim159_xb
	j pulo159_xb
fim159_xb:
	jr $ra
	
