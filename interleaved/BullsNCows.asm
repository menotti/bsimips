# Esboco do jogo Bulls and Cows. 
# Bull: Digito certo no local certo. Cow: Digito certo no local errado.
# Cada registrador de $s0 a $s3 contera um digito da senha secreta, sendo $s0 o digito mais significativo
# Cada registrador de $s4 a $s7 contera um digito do palpite, sendo $s4 o digito mais significativo
# Registradores $t*, conterao valores temporarios usados no processamento
# Registradores $a* e $v* serao utilizados na troca de informacoes nas syscalls e nos procedimentos


#INTERFACE GRAFICA
# A utilizacao do bitmap display para o jogo Bulls and Cows sera feita utilizando o endereco do ponteiro global para enviar informacoes.
# Para configurar o ambiente utilize 16 unit pixels para Largura e Altura, configure o bitmap display para 256 largura x 512 altura.
# Altere o base address for display para 0x10008000 ($gp)
# Conecte com o MIPS e execute o programa
# Cada linha tem 64 de tamanho, sendo que cada "pixel" tem 4 de tamanho, entao sao 16 "pixeis" utilizaveis por linha
# Serao utilizados os registradores $s6 e $s7 para cor de fundo e cor mutavel duranto o jogo (Como esses registradores serao utilizados durante o jogo para armazenar os dados da senha mudarei o da cor mutavel para t5)
# Para manipular a localizacao no display serao utilizados os registradores a0...a3 na inicializacao da tela e durante o jogo somente os registradores a2 e a3

.data
	explicacao: .asciiz "Objetivo: Descobrir uma senha de 4 digitos.\nBull: Digito certo na posicao certa.\nCow: Digito certo na posicao errada.\n\n"
	pedirTentativa: .asciiz "\nConsiderando os digitos de 1 a 6, digite uma sequencia de 4 deles, sem repeti-los (Ex: 3256): "
	qtdeBulls: .asciiz "Bulls: "
	qtdeCows: .asciiz ",  Cows: "
	venceu: .asciiz "Parabens, voce venceu!"
	placar: .asciiz "Pontuacao: "
	falhou: .asciiz "O maximo de tentativas eh de 11 rodadas."
	

	Largura:		.half 16			# Armazena a altura e largura da tela para colorir
	Altura:			.half 32			# Utiliza o global pointer ($gp) do bitmap display com a configuracao 256x512 com 8 unidades cada pixel
		
	CorPrincipal:		.word 0x00000000		# Cor para titulo e bordas - preto
	Cor1:			.word 0x00AA0000		# Cor 1 - vermelho
	Cor2:			.word 0x00FFEF00		# Cor 2 - amarelo
	Cor3:			.word 0x000000FF		# Cor 3 - azul
	Cor4:			.word 0x0000AA00		# Cor 4 - verde
	Cor5:			.word 0x0000FFFF		# Cor 5 - azul claro
	Cor6:			.word 0x00FF8900		# Cor 6 - laranja
	Fundo:			.word 0xFFC2C2C2		# Cor do fundo da tela - cinza
	Pontuacao:		.word 0x100101e0
	
.text

main:	# inicializadao dos graficos antes de iniciar o jogo
	# Carrega Cores Iniciais
	lw $s6, CorPrincipal		# Armazena cor de desenho principal em s6
	lw $s7, Fundo			# Armazena cor do fundo em s7
	# Pinta o Fundo
	jal Preencher
	nop
	jal Bordas			# Desenhar Bordas
	nop
	jal Finalizar_tela
	nop
	# Fim da inicializacao grafica da tela, jogo inicia a partir daqui, registradores usados na inicializacao da tela e no jogo estao agora livres par ao jogo

	#inicializacao do placar - ALTERACAO BRUNA - troquei o placar do registrador $t0 para $k0, pois $t0 ja armazena os Bulls --- OOPS! $k* são usados pelo MARS OS
	# ori $k0, $0, 110		# joga o valor 110 (placar maximo = 100) para t0 (na primeira tentativa ele sera decrementado e ira para 100)
	li $t8, 110
	lw $t9, Pontuacao
	sw $t8, ($t9)

	# Apresenta a explicacao do jogo.
	la $a0, explicacao		# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela
	
	# Gera a senha secreta
	jal geraSenha			# Salva 4 digitos (de 1 a 6) aleatorios em $s0-$s3
	
	tentativa:
	# Acerto do placar para valor inicial ficar 100 e diminuir 10 a cada tentativa
	# subi $k0, $k0, 10 #subtrai 10 de cada tentativa

	lw $t9, Pontuacao
	lw $t8, ($t9)
	subi $t8, $t8, 10 #subtrai 10 de cada tentativa
	sw $t8, ($t9)

		
	# Leitura da tentativa
	jal leTentativa
	move $a0, $v0			# Copia o endereco do inteiro lido para $a0.
	
	# Distribui cada digito para um registrador. Ex.: 1235 -> $s4=1, $s5=2, $s6=3, $s7=5
	jal distDigitos
	
	# Imprime as cores da tentativa atual na tela e ja prepara os valores dos registradores para a proxima impressao
	jal ImprimeCoresTentativa
	
	
	# Pontuacao sendo 100 pontos maximos
	# MODIFICADO POR ANDRE -> ori $t0, $0, 100 #BRUNO TENTATIVA NAO PODE FICAR AQUI POIS ELE VOLTARA PARA 100 SEMPRE QUE A FUNCAO TENTATIVA FOR CHAMADA, VOU MUDAR PARA CIMA
	
	# Compara o palpite com a senha secreta
	jal compara
	
	# Se o jogador errou, volta a etapa de tentativa
	bne $v0, 1, tentativa

	
	# Termina o programa
	j fimPrograma
	

#################################################################################################################################
# Inicio das operacoes de cores e posicionamento do bitmap display
#
# Procedimento para pintar o fundo da tela totalmente de uma cor usando os parametros altura e largura informados anteriormente
# a0 = cor
Preencher:
		lh $a1, Largura			# Carrega valores de altura e largura em a2 e a1
		lh $a2, Altura
		multu $a1, $a2			# Multiplica a Largura por Altura para ter a quantidade de "pixels" da tela
		nop
		mflo $a2			# Recupera o total de "pixels"
		sll $a2, $a2, 2			# Faz o offset para encaixar na tela
		add $a2, $a2, $gp		# Adiciona o ponteiro global (gp)
		
		or $a1, $zero, $gp		# a1 aponta para ponteiro global (gp)
Preencher_l:	
		sw $s7, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, 4			# Faz o offset para encaixar na tela
		blt $a1, $a2, Preencher_l	# Condicional para repetir preenchimento ate chegar no final
		nop
		
		jr $ra				# Retorna para endereco de retorno
		nop


# Procedimento para adicionar as bordas
Bordas:
		lh $a1, Largura			# Carrega valor de largura em a1
		sll $a1, $a1, 2			# Offset para acertar na tela
		add $a2, $a1, $gp		# Adiciona o ponteiro global (gp)
		or $a1, $zero, $gp		# a1 aponta para ponteiro global (gp)
Bordas_topo:	
		sw $s6, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, 4			# Faz o offset para encaixar na tela
		blt $a1, $a2, Bordas_topo	# Condicional para repetir preenchimento ate chegar no final
		nop
		lh $a1, Largura			# Carrega valores de altura e largura em a2 e a1
		lh $a2, Altura
		multu $a1, $a2			# Multiplica a Largura por Altura para ter a quantidade de "pixels" da tela
		nop
		mflo $a2			# Recupera o total de "pixels"
		sub $a2, $a2, $a1		# Diminui um "pixel" na largura
		sll $a2, $a2, 2			# Offset para acertar na tela
		add $a2, $a2, $gp		# Adiciona o ponteiro global (gp)
		subi $a1, $a1, 1		# Diminui 1 na largura
		sll $a3, $a1, 2			# Faz o offset para encaixar na tela
		or $a1, $zero, $gp		# a1 aponta para ponteiro global (gp)
Bordas_lados:	
		sw $s6, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, $a3		# Soma a1 mais o Offset calculado
		sw $s6, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, 4			# Faz o offset para encaixar na tela
		blt $a1, $a2, Bordas_lados	# Condicional para repetir preenchimento ate chegar no final
		nop
		or $a3, $zero, $a1		# Guarda o valor atual de a1 (posicao mais baixa da tela) em a3
		lh $a1, Largura			# Carrega valores de altura e largura em a2 e a1
		lh $a2, Altura
		multu $a1, $a2			# Multiplica a Largura por Altura para ter a quantidade de "pixels" da tela
		nop
		mflo $a2			# Recupera o total de "pixels"
		sll $a2, $a2, 2			# Offset para acertar na tela
		add $a2, $a2, $gp		# Adiciona o ponteiro global (gp)
		or $a1, $zero, $a3		# Restaura o endereco da posicao mais baixa da tela guardad anteriormente em a3
Bordas_baixo:
		sw $s6, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, 4			# Faz o offset para encaixar na tela
		blt $a1, $a2, Bordas_baixo	# Condicional para repetir preenchimento ate chegar no final
		nop
		subi $a1, $a1, 192		# Reposiciona a posicao 4 linhas acima para desenhar barra preta de fundo
Barra_adicional:
		sw $s6, ($a1)			# Armazena a cor no endereco de memoria
		add $a1, $a1, 4			# Faz o offset para encaixar na tela
		blt $a1, $a2, Barra_adicional	# Condicional para repetir preenchimento ate chegar no final
		nop
		jr $ra				# Retorna para endereco de retorno
		nop
Finalizar_tela:		
		or $a1, $zero, $a3		# Recupera em a1 o valor de baixo da tela guardado em a3
		subi $a1, $a1, 64		# Sobe 3 linhas da posicao mais abaixo
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor1			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor2			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor3			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor4			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor5			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		addi $a1, $a1, 8		# Avanca 2 "pixels" para frente para desenhar a primeira cor
		lw $t5, Cor6			# Carrega cor em t5
		sw $t5, ($a1)			# Armazena a cor no endereco de memoria
		
		subi $a3, $a3, 256		# Atualiza valor de a3 para se posicionar 4 linhas acima para iniciar a impressao das cores do usuario
		or $a2, $zero, $a3		# guarda o endereco da posicao da primeira linha do jogo que esta em a3 para o registrador a2
		jr $ra				# Retorna para endereco de retorno
		nop

	
# Procedimento para imprimir as cores das 4 tentativas na tela e posicionar o cursor duas linhas cima para proxima impressao
ImprimeCoresTentativa:
		or $t4, $zero, $ra		# backup do endereco de retorno em t4 para voltar para o programa depois
		or $a2, $zero, $a3		# backup da posicao de a3 em a2
		Digito1:
		addi $a3, $a3, 12
		beq $s4, 1, Selecionacor11	# condicional para verificar o numero da cor e selecionar
		beq $s4, 2, Selecionacor12	# condicional para verificar o numero da cor e selecionar
		beq $s4, 3, Selecionacor13	# condicional para verificar o numero da cor e selecionar
		beq $s4, 4, Selecionacor14	# condicional para verificar o numero da cor e selecionar
		beq $s4, 5, Selecionacor15	# condicional para verificar o numero da cor e selecionar
		beq $s4, 6, Selecionacor16	# condicional para verificar o numero da cor e selecionar
		Selecionacor10:
		lw $t5, CorPrincipal		# carrega cor preta para emergencia da cor selecionada nao for de 1 a 6
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2
		Selecionacor11:
		lw $t5, Cor1			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop
		Selecionacor12:
		lw $t5, Cor2			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop		
		Selecionacor13:
		lw $t5, Cor3			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop		
		Selecionacor14:
		lw $t5, Cor4			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop		
		Selecionacor15:
		lw $t5, Cor5			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop		
		Selecionacor16:
		lw $t5, Cor6			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito2			# Pula para a cor do proximo digito
		nop
		Digito2:
		addi $a3, $a3, 12
		beq $s5, 1, Selecionacor21	# condicional para verirficar o numero da cor e selecionar
		beq $s5, 2, Selecionacor22	# condicional para verirficar o numero da cor e selecionar
		beq $s5, 3, Selecionacor23	# condicional para verirficar o numero da cor e selecionar
		beq $s5, 4, Selecionacor24	# condicional para verirficar o numero da cor e selecionar
		beq $s5, 5, Selecionacor25	# condicional para verirficar o numero da cor e selecionar
		beq $s5, 6, Selecionacor26	# condicional para verirficar o numero da cor e selecionar
		Selecionacor20:
		lw $t5, CorPrincipal		# carrega cor preta para emergencia da cor selecionada nao for de 1 a 6
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3
		Selecionacor21:
		lw $t5, Cor1			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop
		Selecionacor22:
		lw $t5, Cor2			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop		
		Selecionacor23:
		lw $t5, Cor3			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop		
		Selecionacor24:
		lw $t5, Cor4			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop		
		Selecionacor25:
		lw $t5, Cor5			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop		
		Selecionacor26:
		lw $t5, Cor6			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito3			# Pula para a cor do proximo digito
		nop
		Digito3:
		addi $a3, $a3, 12
		beq $s6, 1, Selecionacor31	# condicional para verirficar o numero da cor e selecionar
		beq $s6, 2, Selecionacor32	# condicional para verirficar o numero da cor e selecionar
		beq $s6, 3, Selecionacor33	# condicional para verirficar o numero da cor e selecionar
		beq $s6, 4, Selecionacor34	# condicional para verirficar o numero da cor e selecionar
		beq $s6, 5, Selecionacor35	# condicional para verirficar o numero da cor e selecionar
		beq $s6, 6, Selecionacor36	# condicional para verirficar o numero da cor e selecionar
		Selecionacor30:
		lw $t5, CorPrincipal		# carrega cor preta para emergencia da cor selecionada nao for de 1 a 6
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4
		Selecionacor31:
		lw $t5, Cor1			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop
		Selecionacor32:
		lw $t5, Cor2			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop		
		Selecionacor33:
		lw $t5, Cor3			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop		
		Selecionacor34:
		lw $t5, Cor4			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop		
		Selecionacor35:
		lw $t5, Cor5			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop		
		Selecionacor36:
		lw $t5, Cor6			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Digito4			# Pula para a cor do proximo digito
		nop
		Digito4:
		addi $a3, $a3, 12
		beq $s7, 1, Selecionacor41	# condicional para verirficar o numero da cor e selecionar
		beq $s7, 2, Selecionacor42	# condicional para verirficar o numero da cor e selecionar
		beq $s7, 3, Selecionacor43	# condicional para verirficar o numero da cor e selecionar
		beq $s7, 4, Selecionacor44	# condicional para verirficar o numero da cor e selecionar
		beq $s7, 5, Selecionacor45	# condicional para verirficar o numero da cor e selecionar
		beq $s7, 6, Selecionacor46	# condicional para verirficar o numero da cor e selecionar
		Selecionacor40:
		lw $t5, CorPrincipal		# carrega cor preta para emergencia da cor selecionada nao for de 1 a 6
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao
		Selecionacor41:
		lw $t5, Cor1			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop
		Selecionacor42:
		lw $t5, Cor2			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop		
		Selecionacor43:
		lw $t5, Cor3			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop		
		Selecionacor44:
		lw $t5, Cor4			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop		
		Selecionacor45:
		lw $t5, Cor5			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop		
		Selecionacor46:
		lw $t5, Cor6			# Carrega cor em t5
		sw $t5, ($a3)			# Exibe a cor na tela na posicao indicada
		j Finaliza_impressao		# Pula para a finalizacao da impressao de cores
		nop
		Finaliza_impressao:
		or $a3, $zero, $a2		#retorna o valor de a3 que estava salvo em a2
		subi $a3, $a3, 128		# subtrai 128 de a3 fazendo com que ele retorne 2 linhas para a proxima tentativa
		or $ra, $zero, $t4		# retornando o backup do endereco de retorno que estava em t4 para voltar para o programa
		jr $ra				# Retorna para endereco de retorno
		nop

# Fim das operacoes do bitmap display
########################################################################################################################################


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
	
	bne $t0, 4, limite
	la $a0, venceu			# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	beq $t0, $0, feedback		# mostrar pontuacao do jogo
	syscall				# Imprime a string na tela
	
	# Imprime na tela o placar
	
	la $a0, placar			# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	syscall				# Imprime a string na tela

	lw $t9, Pontuacao
	lw $t8, ($t9)
	add $a0, $0, $t8		# Salva a pontuacao em $a0, para impressao
	sw $t8, ($t9)
		
	li $v0, 1			# Salva o valor 1 em $v0, indicando impressao de um inteiro
	syscall				# Imprime o inteiro na tela
	
	li $v0, 1			# Sinaliza que o jogador ganhou
	jr $ra
	
	# Valida limite de tentativas
	limite:
	
	lw $t9, Pontuacao
	lw $t8, ($t9)
	bnez $t8, feedback		# Se o placar chegou a zero, as tentativas se esgotaram e o placar eh impresso.
	sw $t8, ($t9)
	la $a0, falhou			# Salva o endereco da string em $a0, para impressao
	li $v0, 4			# Salva o valor 4 em $v0, indicando impressao de uma string
	beq $t0, $0, feedback		# mostrar pontuacao do jogo
	syscall				# Imprime a string na tela
	
	li $v0, 1			# Sinaliza que esta foi a ultima rodada
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
