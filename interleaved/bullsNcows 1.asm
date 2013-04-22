# Esboco do jogo Bulls and Cows. 
# Bull: Digito certo no local certo. Cow: Digito certo no local errado.
# Cada registrador de $s0 a $s3 contera um digito da senha secreta, sendo $s0 o digito mais significativo
# Cada registrador de $s4 a $s7 contera um dígito do palpite, sendo $s4 o digito mais significativo
# Registradores $t*, conterao valores temporarios usados no processamento
# Registradores $a* e $v* serao utilizados na troca de informacoes nas syscalls e nos procedimentos

.data
	explicacao: .asciiz "Objetivo: Descobrir uma senha de 4 digitos.\nBull: Digito certo na posicao certa.\nCow: Digito certo na posicao errada.\n\n"
	pedirTentativa: .asciiz "Considerando os digitos de 1 a 6, digite uma sequencia de 4 deles, sem repeti-los (Ex: 3256): "

.text

main:
	# Apresenta a explicacao do jogo.
	la $a0, explicacao		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	# Gera a senha secreta
	jal geraSenha			# Salva 4 digitos (de 1 a 6) aleatorios em $s0-$s3
	
	# Leitura da tentativa
	jal leTentativa
	move $a0, $v0			# Copia o endereco do inteiro lido para $a0.
	
	# Distribui cada digito para um registrador. Ex.: 1235 -> $s4=1, $s5=2, $s6=3, $s7=5
	jal distDigitos
	
	# Compara o palpite com a senha secreta
	jal compara
	
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
# Compara a senha secreta com o palpite, dando feedback ao jogador
	li $t0, 0			# Zera o contador de "Bulls"
	li $t1, 0			# Zera o contador de "Cows"
	jr $ra
	
	
		
fimPrograma:
# Executa a syscall que indica o termino do programa. ATENCAO: Se nao colocado, a execucao continua linha a linha!
	
	addi $v0, $0, 10  # Agenda a syscall com o codigo de termino
	syscall		  # Executa a syscall terminando o programa

	
