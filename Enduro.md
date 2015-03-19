# Introdução #

O jogo selecionado para ser desenvolvido é o _**Enduro**_.
Enduro é um jogo de Vídeo game que foi produzido pela Activision em 1983 para o console Atari 2600.

<img src='https://bsimips.googlecode.com/svn/trunk/Enduro/atari.png'>
Console Atari<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Enduro/cartucho.png'>
Cartucho Atari<br>
<br>
É um jogo de corrida, onde o jogador controla um carro, algo que lembra a um carro de Fórmula 1, durante uma corrida de resistência de longa distância, cujo percurso era aleatório. O objetivo da corrida é passar certa quantidade de carros a cada dia, para permitir ao jogador continuar correndo no dia seguinte. O jogador deve desviar o seu carro dos outros carros para que possa ultrapassar a quantidade necessária para avançar de fase.<br>
Conforme o tempo passa no jogo, a visibilidade também muda. Quando é noite no jogo o jogador só consegue ver as luzes da traseira dos carros. Conforme os dias passam, os carros se tornam mais difíceis de ultrapassar. O clima e o tempo do dia também influenciam o nível de dificuldade, podendo surgir pistas com neve que dificultam o controle do veículo, ou pistas com neblina reduzindo a visibilidade.<br>
<br>
Abaixo algumas imagens do jogo para dar uma melhor visão das dificuldades em cada fase:<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Enduro/cenas.png'>

<h1>Regras</h1>

A visão do jogo sendo desenvolvido é uma vista superior, diferente do que apresentado pelo Enduro da Atari que era uma vista traseira do carro.<br>
<br>
Ainda não está implementada a parte do programa para a pontuação em função de cada ultrapassagem.<br>
<br>
A intenção é que o jogador ganhe pontos ao ultrapassar os adversários, perca pontos caso ocorra colisões laterais e perca o jogo casso haja colisões frontais.<br>
<br>
Pretendemos fazer com que o nível de dificuldade seja randômico, no momento tem um ciclo e este se repete.<br>
<br>
<h1>Telas</h1>

<img src='https://bsimips.googlecode.com/svn/trunk/Enduro/keyboard.png'>
Keyboard and Display MMIO Simulator<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Enduro/display.png'>
Bitmap Display<br>
<br>
<h1>Código</h1>
<pre><code># -------------------------------------------------------------------------------------------------------<br>
#					ENDURO<br>
#	<br>
#		ALUNOS:	Cleber Augusto Borges	RA483168<br>
#                               Rafael Eugênio Borges	RA483265<br>
#                                   Antonio Pantalena	RA483060<br>
#<br>
# -------------------------------------------------------------------------------------------------------<br>
#				INTRUCOES DE USO<br>
#<br>
# Para executar o jogo Enduro adequandamente, execute os seguintes passos:<br>
# - Faca o Assemble (F3) do programa, atraves do Menu 'Run/Assemble'<br>
# - Abra a ferramenta 'Bitmap Display' atraves do menu 'Tools'<br>
# - Nesta ferramente insira os seguintes parametros: Display Width = 256 ; Display Height = 256 ; Base address = 0x10008000 ($gp)<br>
# - Clique em 'Connect to MIPS'<br>
# - Abra a ferramenta 'Keyboard and Display MMIO Simulator' atraves do menu 'Tools'<br>
# - Clique em 'Connect to MIPS'<br>
# - No menu 'Run", clique em 'Go' para iniciar o programa<br>
# - Atraves do campo 'Keyboard' na ferramenta 'Keyboard and Display MMIO Simulator', utilize as teclas 'a,s,d,w' para movimentar o carro<br>
# - Atraves da tecla 'p' eh possivel para a execucao do programa<br>
#<br>
# -------------------------------------------------------------------------------------------------------<br>
#				DESCRI??O DO PROGRAMA<br>
#<br>
# Uso dos Registros<br>
#<br>
#	$a0 - Grava cor na memoria - Usado para apagar e imprimir carro<br>
#	$a1 - Endereca na memoria a posicao do carro - Usado para apagar e imprimir carro<br>
#	$a2 - Registro que guarda posicao do carro principal<br>
#	$a3 - Registro para auxiliar a impressao de margens e da pista<br>
#<br>
#	$s0 - Auxiliar para detecao de colisao<br>
#	$s1 - Auxiliar para detecao de colisao<br>
#	$s2<br>
#	$s3 - Registrado para guardar batidas<br>
#	$s4 - Registro que guarda pontuacao<br>
#	$s6 - contador linhas<br>
#	$s5 - contador colunas<br>
#	$s7 - Registrador que guarda cor usada<br>
#	<br>
#	$t0 - le se teclado foi pressionado<br>
#	$t1 - Registro para fazer faixa da pista ficar em movimento<br>
#	$t2 - Guarda valor da tecla pressionada<br>
#	$t3 - Registro para auxiliar a faixa da pista ficar em movimento<br>
#	$t4 - Posicao do Carro Adversario 1<br>
#	$t5 - Posicao do Carro Adversario 2<br>
#	$t6 - Posicao do Carro Adversario 3<br>
#	$t7 - Posicao do Carro Adversario 4<br>
#	$t8 - Registro para determinar limites laterais do carro principal<br>
#	$t9 - Posicao do Carro Adversario 5<br>
<br>
.include	"numeros.asm"<br>
<br>
.data<br>
Cor:		.word	0x00FF0000		# Escolhe a cor do jogo<br>
Cor2:		.word	0x00FF00FF<br>
MemInicio:	.word	0x10008000		# Posicao inicial de memoria para exibicao<br>
MemCarro:	.word	0x000361A0		# Posicao relativa do carro principal na exibicao<br>
MemAdv1	:	.word	0x00006120<br>
MemAdv2	:	.word	0x00006180<br>
MemAdv3	:	.word	0x000061E0<br>
MemAdv4	:	.word	0x00006240<br>
MemAdv5	:	.word	0x000062A0<br>
Digito1:	.word	0x0003BAA0<br>
<br>
.text<br>
#--------------------------------------------------------------------------------<br>
		# Rotina preliminar para carregar dados e graficos preliminares<br>
Main:<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7	<br>
		lw	$a2, Digito1<br>
		add	$a2, $gp, $a2		# Inicia posicao do carro principal<br>
		or	$a1, $zero, $a2	<br>
		<br>
		Print1#($a1, $a0)<br>
		<br>
		lw	$a2, MemCarro<br>
		add	$a2, $gp, $a2		# Inicia posicao do carro principal<br>
		lw 	$s7, Cor		# Guarda cor em s7<br>
		li	$t1, 4<br>
		li	$t8, 4<br>
		li	$s2, 1024<br>
		li	$s0, 0<br>
		li	$s3, 15<br>
<br>
		lw	$t4, MemAdv1		# Inicia posicao dos adversarios<br>
		add	$t4, $gp, $t4<br>
		lw	$t5, MemAdv2<br>
		add	$t5, $gp, $t5<br>
		lw	$t6, MemAdv3<br>
		add	$t6, $gp, $t6<br>
		lw	$t7, MemAdv4<br>
		add	$t7, $gp, $t7<br>
		lw	$t9, MemAdv5<br>
		add	$t9, $gp, $t9<br>
	<br>
		# Preparar a tela<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $a2		# grava endereco memoria em a1<br>
		jal	PrintCar		# Desenha Carro principal na posicao inicial<br>
		jal	PrintPista		# Desenha pista<br>
		jal	PrintFaixa<br>
		<br>
#--------------------------------------------------------------------------------<br>
		# Rotina Principal<br>
MainLoop:	<br>
		add	$t1, $t1, 1<br>
		bgt 	$t1, 4, ResetContFaixa<br>
		j	MainCont<br>
ResetContFaixa:<br>
		jal	PrintFaixa<br>
		li	$t1, 0<br>
		j	MainCont2<br>
MainCont:<br>
		jal	PrintFaixa<br>
MainCont2:<br>
		j	LeituraTec		# Rotina para ler teclado e atualizar carro principal<br>
RetTeclado:<br>
		j	Adversarios		# Rotina para atualizar posicao dos adversarios<br>
RetAdv:<br>
		j	ChecaColisao		# rotina pra checar se houbve colisao<br>
RetCol:<br>
		beq	$s3, 15, RetTipoCol	# Se nao houve colisao, nao precisa checar tipo de colisao<br>
		j	ChecaTipoCol		# Rotina para detetar tipo da colisao<br>
RetTipoCol:<br>
		j	ChecaPontos		# Rotina para exibir e atualizar pontuacao<br>
RetPontos:<br>
		j	MainLoop		# Termina leitura e retorna ao inicio<br>
<br>
#--------------------------------------------------------------------------------<br>
		# Rotina de leitura do teclado<br>
LeituraTec:<br>
		lw	$t0, 0xFFFF0000		# Checa se alguma tecla foi pressionada<br>
		blez	$t0, TecladoOK		# Pula caso nao tenha sido pressionada<br>
		lw 	$t2, 0xFFFF0004		# Guarda valor da tecla pressionada em $t2<br>
ChecaBaixo:<br>
		bne	$t2, 115, ChecaCima	# Testa se tecla pressionada foi 's' (Baixo)<br>
		bge 	$a2, 268689696, ChecaCima<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$a2, $a2, 8192		# Shifta posicao de memoria para baixo<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	TecladoOK		# Termina leitura teclado<br>
ChecaCima:<br>
		bne	$t2, 119, ChecaDir	# Testa se tecla pressionada foi 'w' (Cima)<br>
		ble 	$a2, 268493504, ChecaDir<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		sub	$a2, $a2, 8192		# Shifta posicao de memoria para cima<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	TecladoOK		# Termina leitura teclado<br>
ChecaDir:<br>
		bne	$t2, 100, ChecaEsq	# Testa se tecla pressionada foi 'd' (Direita)<br>
		beq 	$t8, 12, ChecaEsq<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$a2, $a2, 32		# Shifta posicao de memoria para direita<br>
		add	$t8, $t8, 1		# incrementa contador de limite lateral<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	TecladoOK		# Termina leitura teclado<br>
		<br>
ChecaEsq:<br>
		bne	$t2, 97, TecladoOK	# Testa se tecla pressionada foi 'a' (Esquerda)<br>
		beq	$t8, 0, TecladoOK<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		sub	$a2, $a2, 32		# Shifta posicao de memoria para esquerda<br>
		sub	$t8, $t8, 1		# decrementa contador de limite lateral<br>
		lw 	$s7, Cor		<br>
		or	$a0, $zero, $s7		# Grava cor verde em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
TecladoOK:<br>
		j	RetTeclado<br>
#--------------------------------------------------------------------------------<br>
		# Rotina de atraso<br>
Sleep:<br>
		ori 	$v0, $zero, 32		# Syscall sleep<br>
		ori 	$a0, $zero, 60		# 60 milisegundos<br>
		syscall<br>
		jr 	$ra			# Retorno<br>
		nop<br>
<br>
#--------------------------------------------------------------------------------<br>
		# Adversarios<br>
		# Adversario 1<br>
Adversarios:	<br>
		or	$a1, $zero, $t4		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$t4, $t4, 4096		# Shifta posicao de memoria para baixo<br>
		bge 	$t4, 268689696, RenovaAdv<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $t4		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	Adv2<br>
RenovaAdv:<br>
		lw	$t4, MemAdv1<br>
		add	$t4, $gp, $t4<br>
		# Adversario 2<br>
Adv2:<br>
		or	$a1, $zero, $t5		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$t5, $t5, 1024		# Shifta posicao de memoria para baixo<br>
		bge 	$t5, 268689696, RenovaAdv2<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $t5		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	Adv3<br>
RenovaAdv2:<br>
		lw	$t5, MemAdv2<br>
		add	$t5, $gp, $t5	<br>
		# Adversario 3			<br>
Adv3:<br>
		or	$a1, $zero, $t6		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$t6, $t6, 3072		# Shifta posicao de memoria para baixo<br>
		bge 	$t6, 268689696, RenovaAdv3<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $t6		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	Adv4<br>
RenovaAdv3:<br>
		lw	$t6, MemAdv3<br>
		add	$t6, $gp, $t6<br>
		# Adversario 4	<br>
Adv4:<br>
		or	$a1, $zero, $t7		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$t7, $t7, 2048		# Shifta posicao de memoria para baixo<br>
		bge 	$t7, 268689696, RenovaAdv4<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $t7		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	Adv5<br>
RenovaAdv4:<br>
		lw	$t7, MemAdv4<br>
		add	$t7, $gp, $t7<br>
		# Adversario 5	<br>
Adv5:<br>
		or	$a1, $zero, $t9		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$t9, $t9, 1024		# Shifta posicao de memoria para baixo<br>
		bge 	$t9, 268689696, RenovaAdv5<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $t9		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	TerminaAdv<br>
RenovaAdv5:<br>
		lw	$t9, MemAdv5<br>
		add	$t9, $gp, $t9					<br>
TerminaAdv:<br>
		j	RetAdv<br>
		<br>
#--------------------------------------------------------------------------------<br>
		# Checa colisao dos carros<br>
		# Adversario 1<br>
ChecaColisao:<br>
		bge 	$t8, 2, ColisaoAdv2	# Pula se coluna eh diferente da onde esta o carro<br>
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal<br>
		or	$s1, $zero, $t4		# Grava em s1 posicao de memoria do carro adversario<br>
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro<br>
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s0			# Obtem resultado da divisao<br>
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s1			# Obtem resultado da divisao<br>
		bge 	$s1, $s0, ChecaLinha	# Se esta na mesma linha, pula para checar coluna<br>
		j	ColisaoAdv2		# Se nao, checa proximo adversario<br>
ChecaLinha:<br>
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior<br>
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior<br>
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna<br>
		<br>
		# Adversario 2<br>
ColisaoAdv2:<br>
		blt   	$t8, 2, ColisaoAdv3	# Pula se coluna eh diferente da onde esta o carro<br>
		bgt 	$t8, 4, ColisaoAdv3<br>
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal<br>
		or	$s1, $zero, $t5		# Grava em s1 posicao de memoria do carro adversario<br>
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro<br>
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s0			# Obtem resultado da divisao<br>
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s1			# Obtem resultado da divisao<br>
		bge 	$s1, $s0, ChecaLinha2	# Se for maior que linha superior, pula para checar linha inferior do carro<br>
		j	ColisaoAdv3		# Se nao, checa proximo adversario<br>
ChecaLinha2:<br>
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior<br>
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior<br>
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna<br>
		<br>
		# Adversario 3<br>
ColisaoAdv3:<br>
		blt   	$t8, 5, ColisaoAdv4	# Pula se coluna eh diferente da onde esta o carro<br>
		bgt 	$t8, 7, ColisaoAdv4<br>
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal<br>
		or	$s1, $zero, $t6		# Grava em s1 posicao de memoria do carro adversario<br>
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro<br>
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s0			# Obtem resultado da divisao<br>
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s1			# Obtem resultado da divisao<br>
		bge 	$s1, $s0, ChecaLinha3	# Se for maior que linha superior, pula para checar linha inferior do carro<br>
		j	ColisaoAdv4		# Se nao, checa proximo adversario<br>
ChecaLinha3:<br>
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior<br>
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior<br>
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna<br>
		<br>
		# Adversario 4<br>
ColisaoAdv4:<br>
		blt   	$t8, 8, ColisaoAdv5	# Pula se coluna eh diferente da onde esta o carro<br>
		bgt 	$t8, 10, ColisaoAdv5<br>
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal<br>
		or	$s1, $zero, $t7		# Grava em s1 posicao de memoria do carro adversario<br>
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro<br>
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s0			# Obtem resultado da divisao<br>
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s1			# Obtem resultado da divisao<br>
		bge 	$s1, $s0, ChecaLinha4	# Se for maior que linha superior, pula para checar linha inferior do carro<br>
		j	ColisaoAdv5		# Se nao, checa proximo adversario<br>
ChecaLinha4:<br>
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior<br>
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior<br>
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna<br>
		<br>
		# Adversario 5<br>
ColisaoAdv5:<br>
		blt   	$t8, 11, FimColisao	# Pula se coluna eh diferente da onde esta o carro<br>
		or	$s0, $zero, $a2		# Grava em s0 posicao de memoria do carro principal<br>
		or	$s1, $zero, $t9		# Grava em s1 posicao de memoria do carro adversario<br>
		add	$s1, $s1, 16384		# Soma valor para compensar corpo do carro<br>
		sub	$s0, $s0, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		sub	$s1, $s1, 268468224	# Subtrai 0x10008000 para obter posicao relativa<br>
		divu	$s0, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s0			# Obtem resultado da divisao<br>
		divu	$s1, $s2		# Divide Posi??o por 1024 para obter linha que esta<br>
		mflo	$s1			# Obtem resultado da divisao<br>
		bge 	$s1, $s0, ChecaLinha5	# Se for maior que linha superior, pula para checar linha inferior do carro<br>
		j	FimColisao		# Se nao, checa proximo adversario<br>
ChecaLinha5:<br>
		add	$s0, $s0, 16		# Soma 16 linhas para checar linha inferior<br>
		sub	$s1, $s1, 16		# Subtrai 16 para checar linha superior<br>
		bgt 	$s0, $s1, SetaBatida	# Se for maior, pula para checar coluna<br>
		j	FimColisao		# Se nao, termina check de colisao<br>
SetaBatida:	<br>
		or	$s3, $zero, $t8<br>
FimColisao:				<br>
		j	RetCol<br>
<br>
#--------------------------------------------------------------------------------<br>
		# Rotina para quantificar pontos<br>
		<br>
ChecaTipoCol:<br>
		beqz 	$s3, BatidaFrontal	# <br>
		beq	$s3, 3, BatidaFrontal	#<br>
		beq	$s3, 6, BatidaFrontal	<br>
		beq	$s3, 9, BatidaFrontal	<br>
		beq	$s3, 12, BatidaFrontal	<br>
		j	BatidaLateral<br>
BatidaFrontal:<br>
		j	GameOver		# Batida frontal acaba o jogo<br>
RetGOver:<br>
		j	FimTipoCol<br>
BatidaLateral:	<br>
		beq	$s3, 1, VoltaDir<br>
		beq	$s3, 2, VoltaEsq<br>
		beq	$s3, 4, VoltaDir<br>
		beq	$s3, 5, VoltaEsq<br>
		beq	$s3, 7, VoltaDir<br>
		beq	$s3, 8, VoltaEsq<br>
		beq	$s3, 10, VoltaDir<br>
		beq	$s3, 11, VoltaEsq<br>
		j	FimTipoCol<br>
VoltaDir:<br>
		# Volta para direita<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		add	$a2, $a2, 32		# Shifta posicao de memoria para direita<br>
		add	$t8, $t8, 1		# incrementa contador de limite lateral<br>
		lw 	$s7, Cor<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
		j	FimLateral<br>
VoltaEsq:		<br>
		# Volta para Esquerda<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	ApagaCar		# Apaga posicao antiga do carro<br>
		sub	$a2, $a2, 32		# Shifta posicao de memoria para esquerda<br>
		sub	$t8, $t8, 1		# decrementa contador de limite lateral<br>
		lw 	$s7, Cor		<br>
		or	$a0, $zero, $s7		# Grava cor verde em a0<br>
		or	$a1, $zero, $a2		# Grava posicao do carro em a1<br>
		jal	PrintCar		# Desenha carro na nova posicao<br>
FimLateral:		<br>
		sub	$s4, $s4, 30		# Desconta 30 pontos por batida lateral<br>
		li	$s3, 15<br>
FimTipoCol:<br>
		j	RetTipoCol		# retorna da funcao<br>
#--------------------------------------------------------------------------------<br>
		# Rotina para quantificar pontos<br>
ChecaPontos:<br>
 <br>
		j	RetPontos		<br>
		<br>
#--------------------------------------------------------------------------------<br>
		# Rotina de Fim de Jogo<br>
GameOver:<br>
		ori $v0, $zero, 32		# Syscall sleep<br>
		ori $a0, $zero, 1200		# Atraso de 1,2 Segundos<br>
		syscall<br>
		or	$a1, $zero, $t4		# Grava posicao do carro adversario1 em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		or	$a1, $zero, $t5		# Grava posicao do carro adversario2 em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		or	$a1, $zero, $t6		# Grava posicao do carro adversario3 em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		or	$a1, $zero, $t7		# Grava posicao do carro adversario4 em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		or	$a1, $zero, $t9		# Grava posicao do carro adversario5 em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		or	$a1, $zero, $a2		# Grava posicao do carro principal em a1<br>
		jal	ApagaCar		# Apaga carro<br>
		b Main				# Voce Perdeu! Reseta Jogo<br>
		nop<br>
		j	RetGOver<br>
		<br>
#--------------------------------------------------------------------------------<br>
		# Desenha faixa da Pista<br>
PrintFaixa:<br>
		li	$t3, 28<br>
		or	$s5, $zero, $t1<br>
		add	$a3, $gp, 16896		# Posiciona o ponteiro de memoria para local da faixa da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
FaixaLoop3:<br>
		lw 	$s7, Cor		# Guarda cor em s7	<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		li	$s6, 2			# Inicia contador de coluna<br>
FaixaLoop1:<br>
		sw	$a0,($a1)		# Grava cor na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, FaixaLoop1		# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, FaixaLoop1		# Checa se linhas acabaram<br>
		<br>
		li	$a0, 0			# coloca preto em a0<br>
		li 	$s5, 4			# Inicia contador de Linha<br>
		li	$s6, 2			# Inicia contador de coluna<br>
FaixaLoop2:<br>
		sw	$a0,($a1)		# Grava cor na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, FaixaLoop2		# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, FaixaLoop2		# Checa se linhas acabaram<br>
		<br>
		li 	$s5, 4			# Inicia contador de Linha<br>
		sub	$t3, $t3, 1<br>
		bnez	$t3, FaixaLoop3<br>
fimfaixa:<br>
		nop<br>
		jr	$ra<br>
	<br>
#--------------------------------------------------------------------------------<br>
		# Desenha Pista e Margens na tela<br>
		# Pista Esquerda<br>
PrintPista:<br>
		#lw 	$s7, Cor		# Guarda cor em s7	<br>
		or	$a0, $zero, $s7		# Grava cor em a0<br>
		<br>
		add	$a3, $gp, 16640		# Posicionao ponteiro de memoria para local da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 2			# Inicia contador de coluna<br>
		li 	$s5, 218		# Inicia contador de Linha<br>
PistaLoop1:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, PistaLoop1		# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, PistaLoop1		# Checa se linhas acabaram<br>
		nop			<br>
		<br>
		# Pista Direita<br>
		add	$a3, $gp, 17152		# Posicionao ponteiro de memoria para local da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 2			# Inicia contador de coluna<br>
		li 	$s5, 218		# Inicia contador de Linha<br>
PistaLoop2:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, PistaLoop2		# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, PistaLoop2		# Checa se linhas acabaram<br>
		nop<br>
		<br>
		# Margem Superior<br>
		add	$a3, $gp, 16448		# Posicionao ponteiro de memoria para local da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 224		# Inicia contador de coluna<br>
		li 	$s5, 2			# Inicia contador de Linha<br>
MargSupLoop:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, MargSupLoop	# Checa se linha acabou<br>
		add	$a1, $a1, 128		# Pula de linha<br>
		li	$s6, 224		# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, MargSupLoop	# Checa se linhas acabaram<br>
		nop<br>
		<br>
		# Margem Direita<br>
		add	$a3, $gp, 17344		# Posiciona o ponteiro de memoria para local da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 2			# Inicia contador de coluna<br>
		li 	$s5, 218		# Inicia contador de Linha<br>
MargDirLoop:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, MargDirLoop	# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, MargDirLoop	# Checa se linhas acabaram<br>
		nop<br>
		<br>
		# Margem Inferior<br>
		add	$a3, $gp, 238656	# Posicionao ponteiro de memoria para local da pista 245824<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 226		# Inicia contador de coluna<br>
		li 	$s5, 2			# Inicia contador de Linha<br>
MargInfLoop:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, MargInfLoop	# Checa se linha acabou<br>
		add	$a1, $a1, 128		# Pula de linha<br>
		li	$s6, 224		# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, MargInfLoop	# Checa se linhas acabaram<br>
		nop<br>
		<br>
		# Margem Esquerda<br>
		add	$a3, $gp, 16448		# Posiciona o ponteiro de memoria para local da pista<br>
		or	$a1, $zero, $a3		# Grava posicao memoria em a1<br>
		<br>
		li	$s6, 2			# Inicia contador de coluna<br>
		li 	$s5, 218		# Inicia contador de Linha<br>
MargEsqLoop:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, MargEsqLoop	# Checa se linha acabou<br>
		add	$a1, $a1, 1016		# Pula de linha<br>
		li	$s6, 2			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, MargEsqLoop	# Checa se linhas acabaram<br>
		nop<br>
		jr	$ra			# Termina funcao<br>
			<br>
#--------------------------------------------------------------------------------<br>
		# Apaga Carro da tela<br>
ApagaCar:<br>
		or	$a0, $zero, $zero	# Grava cor preto em a0<br>
		li	$s6, 16			# Inicia contador de coluna<br>
		li 	$s5, 17			# Inicia contador de Linha<br>
ApagaLoop:<br>
		sw	$a0,($a1)		# Grava preto na memoria<br>
		add	$a1, $a1, 4		# Proxima coluna<br>
		sub	$s6, $s6, 1		# decrementa contador de coluna<br>
		bnez	$s6, ApagaLoop		# Checa se linha acabou<br>
		add	$a1, $a1, 960		# Pula de linha<br>
		li	$s6, 16			# Reinicia Contador de coluna<br>
		sub	$s5, $s5, 1		# decrementa contador de linha<br>
		bnez	$s5, ApagaLoop		# Checa se linhas acabaram<br>
		nop			<br>
		jr	$ra			# Termina funcao<br>
<br>
#--------------------------------------------------------------------------------<br>
		# Imprime Carro na tela conforme endereco e cor dadas via $a1 e $a0<br>
PrintCar:		<br>
		# Linha 1<br>
		or 	$a3, $zero, $a1<br>
		add 	$a1, $a1, 8<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 12<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 12<br>
		sw 	$a0, ($a1)<br>
		or 	$a1, $zero, $a3<br>
		# Linha 2<br>
		add 	$a1, $a1, 1024<br>
		or 	$a3, $zero, $a1<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 8<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 16<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 4<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 16<br>
		sw 	$a0, ($a1)<br>
		add 	$a1, $a1, 8<br>
		sw 	$a0, ($a1)<br>
		or 	$a1, $zero, $a3<br>
		# Linha 3<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 4<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 5<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 8	<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 20<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 20<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 6<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 24<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 7<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 24<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 8		<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 24<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 9		<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 16<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 16<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 10<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 11<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 12<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 13		<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 16<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 16<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 14<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 8<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 15<br>
		add $a1, $a1, 1024<br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 4<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		# Linha 16<br>
		add $a1, $a1, 1024 <br>
		or $a3, $zero, $a1<br>
		add $a1, $a1, 12<br>
		sw $a0, ($a1)<br>
		add $a1, $a1, 36<br>
		sw $a0, ($a1)<br>
		or $a1, $zero, $a3<br>
		nop<br>
		jr	$ra<br>
<br>
#--------------------------------------------------------------------------------<br>
</code></pre>

<h1>Comentários</h1>

Tivemos algumas dificuldades com o programa MARS, o qual só conseguia rodar adequadamente a partir da versão 4.3, pois as versões anteriores travavam ao rodar o Keyboard Simulator. Também estamos notando que a velocidade do programa está ficando comprometida, pois em alguns computadores com menor desempenho o jogo roda mais lento.<br>
Também notamos que a dificuldade do jogo será dada pela combinação de velocidade e localização dos adversários, estes detalhes terão nossa maior atenção para a próxima versão do jogo.<br>
<br>
<h1>Alunos</h1>

Cleber Augusto Borges	RA483168<br>
Rafael Eugênio Borges	RA483265<br>
Antonio Pantalena	RA483060<br>
<br>
<h1>Referências</h1>

<li><a href='http://pt.wikipedia.org/wiki/Enduro_(jogo_eletr%C3%B4nico'>http://pt.wikipedia.org/wiki/Enduro_(jogo_eletr%C3%B4nico</a>)<br>
Acessado em 22 de Abril de 2013.<br>
<br>
<li><a href='http://courses.missouristate.edu/kenvollmar/mars/'>http://courses.missouristate.edu/kenvollmar/mars/</a>
Acessado em 20 de março de 2013.<br>
<br>
<li><a href='http://dtconfect.wordpress.com/2011/11/15/mips-snake-primlib/'>http://dtconfect.wordpress.com/2011/11/15/mips-snake-primlib/</a>
Acessado em 20 de março de 2013.