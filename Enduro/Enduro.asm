# -------------------------------------------------------------------------------------------------------
#					ENDURO
#	
#		ALUNOS:	Antonio Pantalena	RA 
#			Cleber Augusto Borges	RA 483168
#
# -------------------------------------------------------------------------------------------------------
#				INTRU??ES DE USO
#
# Para executar o jogo Enduro adequandamente, execute os seguintes passos:
# - Fa?a o Assemble do programa, atrav?s do Menu 'Run/Assembly'
# - Abra a ferramenta 'Bitmap Display' atrav?s do menu 'Tools'
# - Nesta ferramente insira os seguintes par?metros: Display Width = 256 ; Display Height = 256 ; Base address = 0x10008000 ($gp)
# - Clique em 'Connect to MIPS'
# - Abra a ferramenta 'Keyboard and Display MMIO Simulator' atrav?s do menu 'Tools'
# - Clique em 'Connect to MIPS'
# - No menu 'Run", clique em 'Go' para iniciar o programa
# - Atrav?s do campo 'Keyboard' na ferramenta 'Keyboard and Display MMIO Simulator', utilize as teclas 'a,s,d,w' para movimentar o carro
# - Atrav?s da tecla 'p' ? poss?vel para a execu??o do programa
#
# -------------------------------------------------------------------------------------------------------
#				DESCRI??O DO PROGRAMA
#
# Uso dos Registros
#
#	$a0 - Grava cor na memoria - Usado para apagar e imprimir carro
#	$a1 - Endereca na memoria a posicao do carro - Usado para apagar e imprimir carro
#	$a2 - Registro que guarda posicao do carro principal
#	$a3 - Registro para auxiliar a impressao de margens e da pista
#
#	$s0 - Auxiliar para detecao de colisao
#	$s1 - Auxiliar para detecao de colisao
#	$s2
#	$s3 - Registrado para guardar batidas
#	$s4 - Registro que guarda pontua??o
#	$s6 - contador linhas
#	$s5 - contador colunas
#	$s7 - Registrador que guarda cor usada
#	
#	$t0 - le se teclado foi pressionado
#	$t1 - Registro para fazer faixa da pista ficar em movimento
#	$t2 - Guarda valor da tecla pressionada
#	$t3 - Registro para auxiliar a faixa da pista ficar em movimento
#	$t4 - Posicao do Carro Adversario 1
#	$t5 - Posicao do Carro Adversario 2
#	$t6 - Posicao do Carro Adversario 3
#	$t7 - Posicao do Carro Adversario 4
#	$t8 - Registro para determinar limites laterais do carro principal
#	$t9 - Posicao do Carro Adversario 5

.data
Cor:		.word	0x00FF0000		# Escolhe a cor do jogo
Cor2:		.word	0x00FF00FF
MemInicio:	.word	0x10008000		# Posicao inicial de memoria para exibicao
MemCarro:	.word	0x000361A0		# Posicao relativa do carro principal na exibicao
MemAdv1	:	.word	0x00006120
MemAdv2	:	.word	0x00006180
MemAdv3	:	.word	0x000061E0
MemAdv4	:	.word	0x00006240
MemAdv5	:	.word	0x000062A0

.text
#--------------------------------------------------------------------------------
		# Rotina preliminar para carregar dados e graficos preliminares
Main:
		lw	$a2, MemCarro
		add	$a2, $gp, $a2		# Inicia posicao do carro principal
		lw 	$s7, Cor		# Guarda cor em s7
		li	$t1, 4
		li	$t8, 4
		li	$s2, 1024
		li	$s0, 0
		li	$s3, 15

		lw	$t4, MemAdv1		# Inicia posicao dos adversarios
		add	$t4, $gp, $t4
		lw	$t5, MemAdv2
		add	$t5, $gp, $t5
		lw	$t6, MemAdv3
		add	$t6, $gp, $t6
		lw	$t7, MemAdv4
		add	$t7, $gp, $t7
		lw	$t9, MemAdv5
		add	$t9, $gp, $t9
	
		# Preparar a tela
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $a2		# grava endereco memoria em a1
		jal	PrintCar		# Desenha Carro principal na posicao inicial
		jal	PrintPista		# Desenha pista
		jal	PrintFaixa
		
#--------------------------------------------------------------------------------
		# Rotina Principal
MainLoop:	
		add	$t1, $t1, 1
		bgt 	$t1, 4, ResetContFaixa
		j	MainCont
ResetContFaixa:
		jal	PrintFaixa
		li	$t1, 0
		j	MainCont2
MainCont:
		jal	PrintFaixa
MainCont2:
		j	LeituraTec		# Rotina para ler teclado e atualizar carro principal
RetTeclado:
		j	Adversarios		# Rotina para atualizar posicao dos adversarios
RetAdv:
		j	ChecaColisao		# rotina pra checar se houbve colisao
RetCol:
		beq	$s3, 15, RetTipoCol	# Se nao houve colisao, nao precisa checar tipo de colisao
		j	ChecaTipoCol		# Rotina para detetar tipo da colisao
RetTipoCol:
		j	ChecaPontos		# Rotina para exibir e atualizar pontuacao
RetPontos:
		j	MainLoop		# Termina leitura e retorna ao inicio

#--------------------------------------------------------------------------------
		# Rotina de leitura do teclado
LeituraTec:
		lw	$t0, 0xFFFF0000		# Checa se alguma tecla foi pressionada
		blez	$t0, TecladoOK		# Pula caso nao tenha sido pressionada
		lw 	$t2, 0xFFFF0004		# Guarda valor da tecla pressionada em $t2
ChecaBaixo:
		bne	$t2, 115, ChecaCima	# Testa se tecla pressionada foi 's' (Baixo)
		bge 	$a2, 268689696, ChecaCima
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$a2, $a2, 8192		# Shifta posicao de memoria para baixo
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	TecladoOK		# Termina leitura teclado
ChecaCima:
		bne	$t2, 119, ChecaDir	# Testa se tecla pressionada foi 'w' (Cima)
		ble 	$a2, 268493504, ChecaDir
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		sub	$a2, $a2, 8192		# Shifta posicao de memoria para cima
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	TecladoOK		# Termina leitura teclado
ChecaDir:
		bne	$t2, 100, ChecaEsq	# Testa se tecla pressionada foi 'd' (Direita)
		beq 	$t8, 12, ChecaEsq
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$a2, $a2, 32		# Shifta posicao de memoria para direita
		add	$t8, $t8, 1		# incrementa contador de limite lateral
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	TecladoOK		# Termina leitura teclado
		
ChecaEsq:
		bne	$t2, 97, TecladoOK	# Testa se tecla pressionada foi 'a' (Esquerda)
		beq	$t8, 0, TecladoOK
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		sub	$a2, $a2, 32		# Shifta posicao de memoria para esquerda
		sub	$t8, $t8, 1		# decrementa contador de limite lateral
		lw 	$s7, Cor		
		or	$a0, $zero, $s7		# Grava cor verde em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
TecladoOK:
		j	RetTeclado
#--------------------------------------------------------------------------------
		# Rotina de atraso
Sleep:
		ori 	$v0, $zero, 32		# Syscall sleep
		ori 	$a0, $zero, 60		# 60 milisegundos
		syscall
		jr 	$ra			# Retorno
		nop

#--------------------------------------------------------------------------------
		# Adversarios
		# Adversario 1
Adversarios:	
		or	$a1, $zero, $t4		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$t4, $t4, 4096		# Shifta posicao de memoria para baixo
		bge 	$t4, 268689696, RenovaAdv
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $t4		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	Adv2
RenovaAdv:
		lw	$t4, MemAdv1
		add	$t4, $gp, $t4
		# Adversario 2
Adv2:
		or	$a1, $zero, $t5		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$t5, $t5, 1024		# Shifta posicao de memoria para baixo
		bge 	$t5, 268689696, RenovaAdv2
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $t5		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	Adv3
RenovaAdv2:
		lw	$t5, MemAdv2
		add	$t5, $gp, $t5	
		# Adversario 3			
Adv3:
		or	$a1, $zero, $t6		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$t6, $t6, 3072		# Shifta posicao de memoria para baixo
		bge 	$t6, 268689696, RenovaAdv3
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $t6		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	Adv4
RenovaAdv3:
		lw	$t6, MemAdv3
		add	$t6, $gp, $t6
		# Adversario 4	
Adv4:
		or	$a1, $zero, $t7		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$t7, $t7, 2048		# Shifta posicao de memoria para baixo
		bge 	$t7, 268689696, RenovaAdv4
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $t7		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	Adv5
RenovaAdv4:
		lw	$t7, MemAdv4
		add	$t7, $gp, $t7
		# Adversario 5	
Adv5:
		or	$a1, $zero, $t9		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$t9, $t9, 1024		# Shifta posicao de memoria para baixo
		bge 	$t9, 268689696, RenovaAdv5
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $t9		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	TerminaAdv
RenovaAdv5:
		lw	$t9, MemAdv5
		add	$t9, $gp, $t9					
TerminaAdv:
		j	RetAdv
		
#--------------------------------------------------------------------------------
		# Checa colisao dos carros
		# Adversario 1
ChecaColisao:
		bge 	$t8, 2, ColisaoAdv2	# Pula se coluna eh diferente da onde esta o carro
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal
		or	$s1, $zero, $t4		# Grava em s1 posicao de memoria do carro adversario
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s0			# Obtem resultado da divisao
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s1			# Obtem resultado da divisao
		bge 	$s1, $s0, ChecaLinha	# Se esta na mesma linha, pula para checar coluna
		j	ColisaoAdv2		# Se nao, checa proximo adversario
ChecaLinha:
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna
		
		# Adversario 2
ColisaoAdv2:
		blt   	$t8, 2, ColisaoAdv3	# Pula se coluna eh diferente da onde esta o carro
		bgt 	$t8, 4, ColisaoAdv3
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal
		or	$s1, $zero, $t5		# Grava em s1 posicao de memoria do carro adversario
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s0			# Obtem resultado da divisao
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s1			# Obtem resultado da divisao
		bge 	$s1, $s0, ChecaLinha2	# Se for maior que linha superior, pula para checar linha inferior do carro
		j	ColisaoAdv3		# Se nao, checa proximo adversario
ChecaLinha2:
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna
		
		# Adversario 3
ColisaoAdv3:
		blt   	$t8, 5, ColisaoAdv4	# Pula se coluna eh diferente da onde esta o carro
		bgt 	$t8, 7, ColisaoAdv4
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal
		or	$s1, $zero, $t6		# Grava em s1 posicao de memoria do carro adversario
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s0			# Obtem resultado da divisao
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s1			# Obtem resultado da divisao
		bge 	$s1, $s0, ChecaLinha3	# Se for maior que linha superior, pula para checar linha inferior do carro
		j	ColisaoAdv4		# Se nao, checa proximo adversario
ChecaLinha3:
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna
		
		# Adversario 4
ColisaoAdv4:
		blt   	$t8, 8, ColisaoAdv5	# Pula se coluna eh diferente da onde esta o carro
		bgt 	$t8, 10, ColisaoAdv5
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal
		or	$s1, $zero, $t7		# Grava em s1 posicao de memoria do carro adversario
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s0			# Obtem resultado da divisao
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s1			# Obtem resultado da divisao
		bge 	$s1, $s0, ChecaLinha4	# Se for maior que linha superior, pula para checar linha inferior do carro
		j	ColisaoAdv5		# Se nao, checa proximo adversario
ChecaLinha4:
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna
		
		# Adversario 5
ColisaoAdv5:
		blt   	$t8, 11, FimColisao	# Pula se coluna eh diferente da onde esta o carro
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal
		or	$s1, $zero, $t9		# Grava em s1 posicao de memoria do carro adversario
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s0			# Obtem resultado da divisao
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta
		mflo	$s1			# Obtem resultado da divisao
		bge 	$s1, $s0, ChecaLinha5	# Se for maior que linha superior, pula para checar linha inferior do carro
		j	FimColisao		# Se nao, checa proximo adversario
ChecaLinha5:
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna
		j	FimColisao		# Se nao, termina check de colisao
SetaBatida:	
		or	$s3, $zero, $t8
FimColisao:				
		j	RetCol

#--------------------------------------------------------------------------------
		# Rotina para quantificar pontos
		
ChecaTipoCol:
		beqz 	$s3, BatidaFrontal	# 
		beq	$s3, 3, BatidaFrontal	#
		beq	$s3, 6, BatidaFrontal	
		beq	$s3, 9, BatidaFrontal	
		beq	$s3, 12, BatidaFrontal	
		j	BatidaLateral
BatidaFrontal:
		j	GameOver		# Batida frontal acaba o jogo
RetGOver:
		j	FimTipoCol
BatidaLateral:	
		beq	$s3, 1, VoltaDir
		beq	$s3, 2, VoltaEsq
		beq	$s3, 4, VoltaDir
		beq	$s3, 5, VoltaEsq
		beq	$s3, 7, VoltaDir
		beq	$s3, 8, VoltaEsq
		beq	$s3, 10, VoltaDir
		beq	$s3, 11, VoltaEsq
		j	FimTipoCol
VoltaDir:
		# Volta para direita
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		add	$a2, $a2, 32		# Shifta posicao de memoria para direita
		add	$t8, $t8, 1		# incrementa contador de limite lateral
		lw 	$s7, Cor
		or	$a0, $zero, $s7		# Grava cor em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
		j	FimLateral
VoltaEsq:		
		# Volta para Esquerda
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	ApagaCar		# Apaga posicao antiga do carro
		sub	$a2, $a2, 32		# Shifta posicao de memoria para esquerda
		sub	$t8, $t8, 1		# decrementa contador de limite lateral
		lw 	$s7, Cor		
		or	$a0, $zero, $s7		# Grava cor verde em a0
		or	$a1, $zero, $a2		# Grava posicao do carro em a1
		jal	PrintCar		# Desenha carro na nova posicao
FimLateral:		
		sub	$s4, $s4, 30		# Desconta 30 pontos por batida lateral
		li	$s3, 15
FimTipoCol:
		j	RetTipoCol		# retorna da funcao
#--------------------------------------------------------------------------------
		# Rotina para quantificar pontos
ChecaPontos:
 
		j	RetPontos		
		
#--------------------------------------------------------------------------------
		# Rotina de Fim de Jogo
GameOver:
		ori $v0, $zero, 32		# Syscall sleep
		ori $a0, $zero, 1200		# Atraso de 1,2 Segundos
		syscall
		or	$a1, $zero, $t4		# Grava posicao do carro adversario1 em a1
		jal	ApagaCar		# Apaga carro
		or	$a1, $zero, $t5		# Grava posicao do carro adversario2 em a1
		jal	ApagaCar		# Apaga carro
		or	$a1, $zero, $t6		# Grava posicao do carro adversario3 em a1
		jal	ApagaCar		# Apaga carro
		or	$a1, $zero, $t7		# Grava posicao do carro adversario4 em a1
		jal	ApagaCar		# Apaga carro
		or	$a1, $zero, $t9		# Grava posicao do carro adversario5 em a1
		jal	ApagaCar		# Apaga carro
		or	$a1, $zero, $a2		# Grava posicao do carro principal em a1
		jal	ApagaCar		# Apaga carro
		b Main				# Voce Perdeu! Reseta Jogo
		nop
		j	RetGOver
		
#--------------------------------------------------------------------------------
		# Desenha faixa da Pista
PrintFaixa:
		li	$t3, 28
		or	$s5, $zero, $t1
		add	$a3, $gp, 16896		# Posiciona o ponteiro de memoria para local da faixa da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
FaixaLoop3:
		lw 	$s7, Cor		# Guarda cor em s7	
		or	$a0, $zero, $s7		# Grava cor em a0
		li	$s6, 2			# Inicia contador de coluna
FaixaLoop1:
		sw	$a0,($a1)		# Grava cor na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, FaixaLoop1		# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, FaixaLoop1		# Checa se linhas acabaram
		
		li	$a0, 0			# coloca preto em a0
		li 	$s5, 4			# Inicia contador de Linha
		li	$s6, 2			# Inicia contador de coluna
FaixaLoop2:
		sw	$a0,($a1)		# Grava cor na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, FaixaLoop2		# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, FaixaLoop2		# Checa se linhas acabaram
		
		li 	$s5, 4			# Inicia contador de Linha
		sub	$t3, $t3, 1
		bnez	$t3, FaixaLoop3
fimfaixa:
		nop
		jr	$ra
	
#--------------------------------------------------------------------------------
		# Desenha Pista e Margens na tela
		# Pista Esquerda
PrintPista:
		#lw 	$s7, Cor		# Guarda cor em s7	
		or	$a0, $zero, $s7		# Grava cor em a0
		
		add	$a3, $gp, 16640		# Posicionao ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 2			# Inicia contador de coluna
		li 	$s5, 224		# Inicia contador de Linha
PistaLoop1:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, PistaLoop1		# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, PistaLoop1		# Checa se linhas acabaram
		nop			
		
		# Pista Direita
		add	$a3, $gp, 17152		# Posicionao ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 2			# Inicia contador de coluna
		li 	$s5, 224		# Inicia contador de Linha
PistaLoop2:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, PistaLoop2		# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, PistaLoop2		# Checa se linhas acabaram
		nop
		
		# Margem Superior
		add	$a3, $gp, 16448		# Posicionao ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 224		# Inicia contador de coluna
		li 	$s5, 2			# Inicia contador de Linha
MargSupLoop:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, MargSupLoop	# Checa se linha acabou
		add	$a1, $a1, 128		# Pula de linha
		li	$s6, 224		# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, MargSupLoop	# Checa se linhas acabaram
		nop
		
		# Margem Direita
		add	$a3, $gp, 17344		# Posiciona o ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 2			# Inicia contador de coluna
		li 	$s5, 224		# Inicia contador de Linha
MargDirLoop:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, MargDirLoop	# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, MargDirLoop	# Checa se linhas acabaram
		nop
		
		# Margem Inferior
		add	$a3, $gp, 245824	# Posicionao ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 226		# Inicia contador de coluna
		li 	$s5, 2			# Inicia contador de Linha
MargInfLoop:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, MargInfLoop	# Checa se linha acabou
		add	$a1, $a1, 128		# Pula de linha
		li	$s6, 224		# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, MargInfLoop	# Checa se linhas acabaram
		nop
		
		# Margem Esquerda
		add	$a3, $gp, 16448		# Posiciona o ponteiro de memoria para local da pista
		or	$a1, $zero, $a3		# Grava posicao memoria em a1
		
		li	$s6, 2			# Inicia contador de coluna
		li 	$s5, 224		# Inicia contador de Linha
MargEsqLoop:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, MargEsqLoop	# Checa se linha acabou
		add	$a1, $a1, 1016		# Pula de linha
		li	$s6, 2			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, MargEsqLoop	# Checa se linhas acabaram
		nop
		jr	$ra			# Termina funcao
			
#--------------------------------------------------------------------------------
		# Apaga Carro da tela
ApagaCar:
		or	$a0, $zero, $zero	# Grava cor preto em a0
		li	$s6, 16			# Inicia contador de coluna
		li 	$s5, 17			# Inicia contador de Linha
ApagaLoop:
		sw	$a0,($a1)		# Grava preto na memoria
		add	$a1, $a1, 4		# Proxima coluna
		sub	$s6, $s6, 1		# decrementa contador de coluna
		bnez	$s6, ApagaLoop		# Checa se linha acabou
		add	$a1, $a1, 960		# Pula de linha
		li	$s6, 16			# Reinicia Contador de coluna
		sub	$s5, $s5, 1		# decrementa contador de linha
		bnez	$s5, ApagaLoop		# Checa se linhas acabaram
		nop			
		jr	$ra			# Termina funcao

#--------------------------------------------------------------------------------
		# Imprime Carro na tela conforme endereco e cor dadas via $a1 e $a0
PrintCar:		
		# Linha 1
		or 	$a3, $zero, $a1
		add 	$a1, $a1, 8
		sw 	$a0, ($a1)
		add 	$a1, $a1, 12
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 12
		sw 	$a0, ($a1)
		or 	$a1, $zero, $a3
		# Linha 2
		add 	$a1, $a1, 1024
		or 	$a3, $zero, $a1
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 8
		sw 	$a0, ($a1)
		add 	$a1, $a1, 16
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 16
		sw 	$a0, ($a1)
		add 	$a1, $a1, 8
		sw 	$a0, ($a1)
		or 	$a1, $zero, $a3
		# Linha 3
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 4
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 5
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 8	
		sw $a0, ($a1)
		add $a1, $a1, 20
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 20
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 6
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 24
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 7
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 24
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 8		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 24
		sw $a0, ($a1)
		add $a1, $a1, 12
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 9		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 16
		sw $a0, ($a1)
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 16
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 10
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 11
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 12
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 13		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 16
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 16
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 14
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 15
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		or $a1, $zero, $a3
		# Linha 16
		add $a1, $a1, 1024 
		or $a3, $zero, $a1
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 36
		sw $a0, ($a1)
		or $a1, $zero, $a3
		nop
		jr	$ra

#--------------------------------------------------------------------------------




