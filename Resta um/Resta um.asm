# GAME: RESTA UM
# DISCIPLINA: ARQUITETURA DE COMPUTADORES

# DECLARAÇÃO DOS DADOS
	.data

# Globals
pino_coord:
	.space 	49	# vetor de 49 pinos
			
# TABULEIRO DO JOGO
casa_vazia:
	.asciiz " "

casa_cheia:
	.asciiz "O"
	
INICIALIZACAO:
	.ascii	"*GAME: RESTA UM*"
	
	
mensagem_mover:
	.asciiz	"\nDigite o local para onde a peça ira se mover: "
	
# Desenhar tabuleiro
tabuleiro_topo:
	.asciiz			"    0  1  2  3  4  5  6\n"
margem_vertical:
	.asciiz			"        -----------\n"
linha_0:
	.asciiz		"0       |"
linha_1:
	.asciiz		"1 -------"
linha_2:
	.asciiz		"2 |"
linha_3:
	.asciiz		"3 |"
linha_4:
	.asciiz		"4 |"
linha_5:
	.asciiz		"5 -------"
linha_6:
	.asciiz		"6       |"
margem_horizontal:
	.asciiz			"-------\n"
tabuleiro_fim:
	.asciiz			"|\n"

espaco:
	.asciiz			"|      \n"


# Texto
	.text

# 
# Programa principal
#
main:   
	# Mensagem inicial
	li	$v0, 4	
	la	$a0, INICIALIZACAO
	syscall			

	# Iniciar o tabuleiro
	jal 	alocacao_tabuleiro
		

desenhar:
	jal	desenhar_tabuleiro



# Preenchimento do tabuleiro 

alocacao_tabuleiro:
        addi    $sp, $sp, -40	# alocação do tabuleiro no vetor na memoria
        sw      $ra, 32($sp)    # armazenar vetores na memória
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)

	# Preparar para loops
	li	$s2, 7 		# Largura do tabuleiro
	
	li	$s0, 0 Linha atual

loop:
	# Repetidção para próxima linha enquanto linha for menor que largura do tabuleiro.
	slt 	$t0, $s0, $s2				
	beq	$t0, $zero,  desenho_tabuleiro	#retornar

	li	$s1, 0		# Coluna atual
loop1:
	# Repetidção para próxima coluna enquanto coluna for menor que largura do tabuleiro.
	slt	$t0, $s1, $s2				
	beq	$t0, $zero, loop3	
	
	# verificar se a coordenada é válida
	mul	$a0, $s0, 10		
	add	$a0, $a0, $s1			
	
	la	$t0, pino_coord
	add	$t1, $zero, $s0		
	mul	$t1, $t1, 7	
	add	$t1, $t1, $s1		
	
	add	$t0, $t0, $t1		
	sb	$v0, 0($t0)		
	
loop2:
	# loop interno
	addi	$s1, $s1, 1		# Coluna atual++
	j 	loop1	
	
loop3:
	#loop externo
	addi	$s0, $s0, 1		# Linha atual++
	j	loop		
desenho_tabuleiro:
        lw      $ra, 32($sp)   		# ler vetores do tabuleiro armazenados na memória
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 40      	# limpar os dados
	jr	$ra


#Desenhar pinos

pino:
        addi    $sp, $sp, -40		# Alocar dos pinos no vetor na memoria
        sw      $ra, 32($sp)    
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)
        
        move	$s0, $a0
        
        # imprimir casa vazia
        li	$v0, 4	
	la	$a0, casa_vazia
	syscall
	
	# confirmar o pino
	addi	$t0, $zero, 10	
	div	$s0, $t0	
	mflo	$s0		
	mfhi	$s1		
	
	# coordenada do pino
	la	$t0, pino_coord	
	add	$t1, $zero, $s0		
	mul	$t1, $t1, 7		
	add	$t1, $t1, $s1		
	
	add	$t0, $t0, $t1		
	lb	$t2, 0($t0)		
	beqz	$t2, desenhar_vazio
	
desenhar_pino:
	li	$v0, 4	
	la	$a0, casa_cheia
	syscall

	
desenhar_vazio:
	li	$v0, 4	
	la	$a0, casa_vazia
	syscall
	
        
desenhar_casas:
        lw      $ra, 32($sp)    	# Ler vetores dos pinos armazenados na memoria
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 40      	# limpar
        jr	$ra
        	
	

# Desenhar tabuleiro

desenhar_tabuleiro:
        addi    $sp, $sp, -40		# alocar vetores do tabuleiro na memoria para desenhar o tabuleiro
        sw      $ra, 32($sp)    
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)
        
        # desenhar linhas inicio
        li	$v0, 4	
	la	$a0, tabuleiro_topo
	syscall	
	
	li	$v0, 4	
	la	$a0, margem_vertical
	syscall
	
	# desenhar linha 0
	li	$v0, 4	
	la	$a0, linha_0
	syscall
	
	li	$a0, 2
	jal	pino
	
	li	$a0, 3
	jal	pino
	
	li	$a0, 4
	jal	pino
	
	li	$v0, 4	
	la	$a0, espaco
	syscall
	
	# desenhar linha 1
	li	$v0, 4	
	la	$a0, linha_1
	syscall
	
	li	$a0, 12
	jal	pino
	
	li	$a0, 13
	jal	pino
	
	li	$a0, 14
	jal	pino
	
	li	$v0, 4	
	la	$a0, margem_horizontal
	syscall
	
	
	# desenhar linha 2
	li	$v0, 4	
	la	$a0, linha_2
	syscall
	
	li	$a0, 20
	jal	pino
	
	li	$a0, 21
	jal	pino
	
	li	$a0, 22
	jal	pino
	
	li	$a0, 23
	jal	pino
	
	li	$a0, 24
	jal	pino
	
	li	$a0, 25
	jal	pino
	
	li	$a0, 26
	jal	pino
	
	li	$v0, 4	
	la	$a0, tabuleiro_fim
	syscall
	
	# desenhar linha 3
	li	$v0, 4	
	la	$a0, linha_3
	syscall
	
	li	$a0, 30
	jal	pino
	
	li	$a0, 31
	jal	pino
	
	li	$a0, 32
	jal	pino
	
	li	$a0, 33
	jal	pino
	
	li	$a0, 34
	jal	pino
	
	li	$a0, 35
	jal	pino
	
	li	$a0, 36
	jal	pino
	
	li	$v0, 4	
	la	$a0, tabuleiro_fim
	syscall
	
	# desenhar linha 4
	li	$v0, 4
	la	$a0, linha_4
	syscall
	
	li	$a0, 40
	jal	pino
	
	li	$a0, 41
	jal	pino
	
	li	$a0, 42
	jal	pino
	
	li	$a0, 43
	jal	pino
	
	li	$a0, 44
	jal	pino
	
	li	$a0, 45
	jal	pino
	
	li	$a0, 46
	jal	pino
	
	li	$v0, 4	
	la	$a0, tabuleiro_fim
	syscall
	
	# desenhar linha 5
	li	$v0, 4	
	la	$a0, linha_5
	syscall
	
	li	$a0, 52
	jal	pino
	
	li	$a0, 53
	jal	pino
	
	li	$a0, 54
	jal	pino
	
	li	$v0, 4	
	la	$a0, margem_horizontal
	syscall
	
	# desenhar linha 6
	li	$v0, 4	
	la	$a0, linha_6
	syscall
	
	li	$a0, 62
	jal	pino
	
	li	$a0, 63
	jal	pino
	
	li	$a0, 64
	jal	pino
	
	li	$v0, 4	
	la	$a0, espaco
	syscall
	
	#fim do desenho
	li	$v0, 4	
	la	$a0, margem_vertical
	syscall
	
