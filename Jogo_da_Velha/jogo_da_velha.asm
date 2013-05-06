# Este programa simula o jogo da velha.
# Autores: Andrea Cristina da Silva - 482188
#          Camila Monteiro Caetano Tomaz - 481840
#          Cristiana Freitas - 434299
#	   Jonas de Castro M M Santos - 482226

# Regras do Jogo:
# Composto por um tabuleiro, com 9 posições sendo formadas por 3 colunas e 3 linhas.
# Jogam duas pessoas. Na vez de cada jogador, este pode escolher uma posição no tabuleiro que ainda não tenha sido escolhido.
# Ganha o jogo aquele que conseguir completar uma linha na horizontal, vertical ou diagonal primeiro.
# Caso se complete o tabuleiro sem que nenhum jogador complete esta linha, este termina empatado.

	.text 
main:
	# Definição dos registradores que indicam a posição do tabuleiro
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $s0, 0
	
	# Contador para o processo de loop da aplicação
	li $s5, 9
	
	# Jogadores:
	li $s1, 1 # Jogador 1
	li $s2, 2 # Jogador 2
	
	#Mensagem informando o início do jogo
	la $a0, msg_inicio
	li $v0, 4
	syscall
	
	la $a0, msg_jog_1
	
L:
	#Mensagem informando a vez do jogador.
	li $v0, 4
	syscall
	
	move $s4, $s1
	
M:	
	#Mensagem solicitando a escolha de um quadrado do tabuleiro
	la $a0, msg_posicao
	li $v0, 4
	syscall
	
	#Realizando a leitura da posição solicitada
	li $v0, 5
	syscall
	
	move $s3, $v0

	#verificando a posição
	beq $s3, 11, pos_11
	beq $s3, 12, pos_12
	beq $s3, 13, pos_13
	beq $s3, 21, pos_21
	beq $s3, 22, pos_22
	beq $s3, 23, pos_23
	beq $s3, 31, pos_31
	beq $s3, 32, pos_32
	beq $s3, 33, pos_33
	
	la $a0, msg_posicao_invalida
	li $v0, 4
	syscall
	
	b M
	
volta:
	beq $s4, $s1, vez_jogador2
	move $s4, $s1
	la $a0, msg_jog_1
	b continue

continue:	
	sub $s5, $s5, 1
	
	bnez $s5, L
		
pos_11:
	bnez $t0, campo_ja_ecolhido
	add $t0, $t0, $s4
	seq $t8, $t1, $s4
	seq $t9, $t2, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_12:
	bnez $t1, campo_ja_ecolhido
	add $t1, $t1, $s4
	seq $t8, $t0, $s4
	seq $t9, $t2, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_13:
	bnez $t2, campo_ja_ecolhido
	add $t2, $t2, $s4
	seq $t8, $t1, $s4
	seq $t9, $t0, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou

	b volta

pos_21:
	bnez $t3, campo_ja_ecolhido
	add $t3, $t3, $s4
	seq $t8, $t4, $s4
	seq $t9, $t5, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou

	b volta

pos_22:
	bnez $t4, campo_ja_ecolhido
	add $t4, $t4, $s4
	seq $t8, $t3, $s4
	seq $t9, $t5, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_23:
	bnez $t5, campo_ja_ecolhido
	add $t5, $t5, $s4
	seq $t8, $t3, $s4
	seq $t9, $t4, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_31:
	bnez $t6, campo_ja_ecolhido
	add $t6, $t6, $s4
	seq $t8, $t7, $s4
	seq $t9, $s0, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_32:
	bnez $t7, campo_ja_ecolhido
	add $t7, $t6, $s4
	seq $t8, $s0, $s4
	seq $t9, $t2, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

pos_33:
	bnez $s0, campo_ja_ecolhido
	add $s0, $s0, $s4
	seq $t8, $t6, $s4
	seq $t9, $t7, $s4
	and $s7, $t8, $t9
	bnez $s7, msg_ganhou
	b volta

vez_jogador2:
	move $s4, $s2
	la $a0, msg_jog_2
	b continue
	
msg_ganhou:
	la $a0, msg_ganhou_jogo
	li $v0, 4
	syscall
	b exit
	
campo_ja_ecolhido:
	la $a0, msg_campo_ja_ecolhido
	li $v0, 4
	syscall
	b M
	
exit:	
	li $v0, 10
	syscall 
		
	.data	
msg_inicio:
	.asciiz "Inicio do Jogo.\n"

msg_jog_1:
	.asciiz "Vez do Primeiro Jogador.\n"

msg_jog_2:
	.asciiz "Vez do Segundo Jogador.\n"
	
msg_posicao:
	.asciiz "Informe a posição do tabuleiro. (Linha Coluna)\n"
	
nova_linha:
	.asciiz "\n"

msg_campo_ja_ecolhido:
	.asciiz "Campo já escolhido. Tente novamente.\n"
	
msg_ganhou_jogo:
	.asciiz "Você ganhou o jogo."
	
msg_posicao_invalida:
	.asciiz "Posicao invalida, tente novamente.\n"