# Esboco do jogo Bulls and Cows. 
# Bull: Digito certo no local certo. Cow: Digito certo no local errado.
# Cada registrador de $s0 a $s3 contera um digito da senha secreta, sendo $s0 o digito mais significativo
# Cada registrador de $s4 a $s7 contera um digito do palpite, sendo $s4 o digito mais significativo
# Registradores $t*, conterao valores temporarios usados no processamento
# Registradores $a* e $v* serao utilizados na troca de informacoes nas syscalls e nos procedimentos

.data
	explicacao: .asciiz "Objetivo: Descobrir uma senha de 4 digitos.\nBull: Digito certo na posicao certa.\nCow: Digito certo na posicao errada.\n\n"
	pedirTentativa: .asciiz "\nConsiderando os digitos de 1 a 6, digite uma sequencia de 4 deles, sem repeti-los (Ex: 3256): "
	qtdeBulls: .asciiz "Bulls: "
	qtdeCows: .asciiz ",  Cows: "
	venceu: .asciiz "Parabens, voce venceu!"

.text

main:
	# Apresenta a explicacao do jogo.
	la $a0, explicacao		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	# Gera a senha secreta
	jal geraSenha			# Salva 4 digitos (de 1 a 6) aleatorios em $s0-$s3
	
	tentativa:
	# Leitura da tentativa
	jal leTentativa
	move $a0, $v0			# Copia o endereco do inteiro lido para $a0.
	
	# Distribui cada digito para um registrador. Ex.: 1235 -> $s4=1, $s5=2, $s6=3, $s7=5
	jal distDigitos
	
	# Compara o palpite com a senha secreta
	jal compara
	
	# Se o jogador errou, volta a etapa de tentativa
	bne $v0, 1, tentativa
	
	# Termina o programa
	j fimPrograma

leTentativa:
# Le o palpite do jogador

	la $a0, pedirTentativa		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	li $v0, 5			# Informa o codigo de leitura de inteiro
	syscall				# Le o palpite
	
	jr $ra				# Retorna para a execucao no programa principal, retornando $v0
	
distDigitos:
# Distribui um inteiro de 4 digitos colocando cada digito em um registrador [$s4-$s7]

	divu $s4, $v0, 1000 		# Salva o 1o digito (o mais significativo) em $s4
	mulu $t0, $s4, 1000
	subu $t1, $v0, $t0
	divu $s5, $t1, 100		# Salva o 2o digito em $s5
	mulu $t0, $s5, 100
	subu $t1, $t1, $t0
	divu $s6, $t1, 10		# Salva o 3o digito em $s6
	mulu $t0, $s6, 10
	subu $s7, $t1, $t0		# Salva o 4o digito (o menos significativo) em $s7
	jr $ra
	
geraSenha:
# Retorna em $a0 um numero aleatorio de 1 a 6
	addi $a0, $0, 3			# Salva a semente em $a0
	addi $a1, $0, 6			# Salva o limite superior em $a1. Obs: [0, 6[
	addi $v0, $0, 42		# Informa o codigo de geracao de aleatorio
	syscall				# Gera um numero aleatorio de 0 a 5
	addi $s0, $a0, 1		# Adiciona 1 para gerar um valor no intervalo [1, 6] e armazena em $s0
	loop1:
	syscall				# Gera um numero aleatorio de 0 a 5
	addi $s1, $a0, 1		# Adiciona 1 para gerar um valor no intervalo [1, 6] e armazena em $s1
	beq $s0, $s1, loop1		# Se o segundo numero gerado for igual ao primeiro, tenta novamente
	loop2:
	syscall				# Gera um numero aleatorio de 0 a 5
	addi $s2, $a0, 1		# Adiciona 1 para gerar um valor no intervalo [1, 6] e armazena em $s2
	beq $s2, $s0, loop2		# Se o terceiro numero gerado for igual a algum dos primeiros, tenta novamente
	beq $s2, $s1, loop2
	loop3:
	syscall				# Gera um numero aleatorio de 0 a 5
	addi $s3, $a0, 1		# Adiciona 1 para gerar um valor no intervalo [1, 6] e armazena em $s3
	beq $s3, $s0, loop3		# Se o quarto numero gerado for igual a algum dos primeiros, tenta novamente
	beq $s3, $s1, loop3
	beq $s3, $s2, loop3
	jr $ra
	
compara:
# Compara a senha secreta com o palpite, dando feedback ao jogador e retornando 1 se ele acertou a senha.

	li $t0, 0			# Zera o contador de "Bulls"
	li $t1, 0			# Zera o contador de "Cows"
	
	# Compara o primeiro digito do palpite com cada um dos digitos da senha
	bne $s0, $s4, pulo1		# Se o primeiro digito do palpite for igual ao primeiro digito da senha, incrementa Bulls
	addi $t0, $t0, 1
	pulo1:
	bne $s0, $s5, pulo2		# Se o primeiro digito do palpite for igual ao segundo digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo2:
	bne $s0, $s6, pulo3		# Se o primeiro digito do palpite for igual ao terceiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo3:
	bne $s0, $s7, pulo4		# Se o primeiro digito do palpite foir igual ao quarto digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo4:
	
	# Compara o segundo digito do palpite com cada um dos digitos da senha
	bne $s1, $s5, pulo5		# Se o segundo digito do palpite for igual ao segundo digito da senha, incrementa Bulls
	addi $t0, $t0, 1
	pulo5:
	bne $s1, $s4, pulo6		# Se o segundo digito do palpite for igual ao primeiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo6:
	bne $s1, $s6, pulo7		# Se o segundo digito do palpite for igual ao terceiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo7:
	bne $s1, $s7, pulo8		# Se o segundo digito do palpite foir igual ao quarto digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo8:
	
	# Compara o terceiro digito do palpite com cada um dos digitos da senha
	bne $s2, $s6, pulo9		# Se o terceiro digito do palpite for igual ao terceiro digito da senha, incrementa Bulls
	addi $t0, $t0, 1
	pulo9:
	bne $s2, $s4, pulo10		# Se o terceiro digito do palpite for igual ao primeiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo10:
	bne $s2, $s5, pulo11		# Se o terceiro digito do palpite for igual ao segundo digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo11:
	bne $s2, $s7, pulo12		# Se o terceiro digito do palpite foir igual ao quarto digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo12:

	# Compara o quarto digito do palpite com cada um dos digitos da senha
	bne $s3, $s7, pulo13		# Se o quarto digito do palpite for igual ao quarto digito da senha, incrementa Bulls
	addi $t0, $t0, 1
	pulo13:
	bne $s3, $s4, pulo14		# Se o quarto digito do palpite for igual ao primeiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo14:
	bne $s3, $s5, pulo15		# Se o quarto digito do palpite for igual ao segundo digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo15:
	bne $s3, $s6, pulo16		# Se o quarto digito do palpite foir igual ao terceiro digito da senha, incrementa Cows
	addi $t1, $t1, 1
	pulo16:
	
	# Verifica se o jogador ganhou (Bulls = 4)
	
	bne $t0, 4, feedback
	la $a0, venceu			# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	li $v0, 1			# Sinaliza que o jogador ganhou
	jr $ra
	
	feedback:
	# Imprime na tela o numero de Bulls
	
	la $a0, qtdeBulls		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	add $a0, $0, $t0		# Salva a quantidade de Bulls em $a0, para impressao
	li $v0, 1			# Salva o valor 1 em $v0, indicando impressao de um inteiro
	syscall				# Imprime o inteiro na tela
	
	# Imprime na tela o numero de Cows
	
	la $a0, qtdeCows		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	add $a0, $0, $t1		# Salva a quantidade de Cows em $a0, para impressao
	li $v0, 1			# Salva o valor 1 em $v0, indicando impressao de um inteiro
	syscall				# Imprime o inteiro na tela
	
	li $t0, 0			# Zera o contador de "Bulls"
	li $t1, 0			# Zera o contador de "Cows"
	li $v0, 0			# Sinaliza que o jogador nao ganhou
	jr $ra
	
		
fimPrograma:
# Executa a syscall que indica o termino do programa. ATENCAO: Se nao colocado, a execucao continua linha a linha!
	
	addi $v0, $0, 10  # Agenda a syscall com o codigo de termino
	syscall		  # Executa a syscall terminando o programa

	
