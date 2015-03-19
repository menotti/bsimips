# Introdução #

O jogo da velha, homenageado aqui com o nome de Jogo da Idosa ou  ainda "Figth for Old", é um jogo de regras muito simples.

Historicamente, de acordo com estudos e pesquisadores, o seu nome tem se originado na Inglaterra, que nos finais de tarde as mulheres se reuniam para bordar e colocar o papo em dia, enquanto as mulheres idosas por não mais terem condições de bordar devido à fraqueza na vista e nos movimentos, jogavam este simples jogo. É por este motivo que o jogo recebe o nome de jogo da ‘velha’, apesar de que há quem diga que sua origem tenha sido ainda mais antiga, pois fala-se que em tabuleiros escavados na rocha de tempos antigos do Egito, os quais teriam sido feitos por escravos há 3.500 anos. Logo, poderíamos chamá-lo como o velho jogo da velha! :)

# Regras #
O tabuleiro possui uma matriz de três linhas por três colunas;

-Dois jogadores escolhem uma marcação, ou seja, um escolhe o círculo (O) e o outro o xis (X);

-Se inicia o jogo através de par ou ímpar (no nosso caso sempre começa-se com o X), e segue a sequência alternada, ou seja, uma marcação por vez, em uma lacuna que esteja vazia.

-O principal objetivo do jogo é fazer com que três xis ou três círculos fiquem em linha horizontal, diagonal ou vertical, simultaneamente, quando possível impedir que o adversário ganhe na próxima jogada.

-Quando um jogador consegue conquistar o objetivo, tem-se o costume de riscar os três símbolos.



# Implementação #

A implementação foi elaborada seguindo os seguintes passos:
| Passos |
|:-------|
| 1) | Inicialização as diversas constantes (Endereçamento para o BitmapDisplay, Mensagens de texto, cores)|
| 2) | Inicialização das variáveis (todas armazenadas em registradores)|
| 3) |Desenha o tabuleiro no BitmapDisplay|
| 4) |Imprime o menu de opções|
| 5) |Recebe uma tecla|
| 6) |Avaliando a paridade do contador de jogadas determina se é a vez do X(ímpar) ou O (par)|
| 7) |Verifica se posição teclada já ocupada se sim (volta ao passo 4) |
| 8) |Se posição desocupada desenha o X, ou o O na posição escolhida|
| 9) |Incrementa o contador|
| 10) |Se o contador for maior que 4, verifica se alguém ganhou (passo 12)|
| 11) |Se contador for maior que 9 (empate) termina o jogo.|
| 12) |Se ninguem ganhou volta ao passo 4|
| 13) |Se alguem ganhou, anuncia o ganhador e termina o jogo.|


# Tabuleiro #


<img src='https://bsimips.googlecode.com/svn/trunk/IdosaGame/Imagens/tabuleiro.PNG'>


<h1>Considerações para simulação do código</h1>

O código abaixo fornecido foi desenvolvido para o microprocessador MIPS por meio do simulador MARS. Para simulá-lo será necessário abrir o BitmapDisplay, configurá-lo em 64x64, e conectá-lo ao MARS.<br>
<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/IdosaGame/Imagens/FinalJogo.PNG'>



<h1>O código</h1>

<pre><code>#######################################################################################<br>
#<br>
# NOME DO PROGRAMA: JOGO DA IDOSA<br>
# AUTORES: ALINE FIGUEIREDO, CRISTIANO SANTANA, JESILENE GODOY E LUIS MIRANDA<br>
#<br>
# UM TIPICO JOGO DA VELHA, DESENVOLVIDO EM MARS PARA MIPS<br>
#<br>
# UNIVERSIDADE FEDERAL DE SÃO CARLOS<br>
# ARQUITETURA DE COMPUTADORES<br>
#<br>
# AGRADECIMENTOS: Ao prezado Jerrekedb, um Belga que ao divulgar seu confuso código <br>
# permitiu que nós aprendêssemos a usar o BitMapDisplay.<br>
# http://www.cppgameprogramming.com/newforums/viewtopic.php?f=7&amp;t=1920<br>
#<br>
# -----------------------------------------------------<br>
#  jogo da Idosa! -------------&gt;UFSCar BSI.g5 - AC ----<br>
#  ----------------------------------------------------<br>
#  ------------------------------- aline figueiredo ---<br>
#     |     |      ---------------- cristiano santana -<br>
#  1  |  2  | 3     ---------------- jesilene godoy ---<br>
# ----|-----|----     ---------------- luis miranda ---<br>
#  4  |  5  | 6         -------------------------------<br>
# ----|-----|----       -------------------------------<br>
#  7  |  8  | 9         ------ (0) ZERO SAI DO JOGO ---<br>
#     |     |           -------------------------------<br>
# ESCOLHA UMA POSICAO: <br>
#<br>
# 18/4/13<br>
# Acertos de formatação e correções ortográficas<br>
# o que faltava, foi implementada na versão anterior mesmo.<br>
#<br>
# 11/4/13 23:55 <br>
# Nesta versao foi acrescentado:<br>
#  - a checagem para ver se foi escolhida a mesma posicao duas vezes (e armazenado <br>
#    de $t1 a $t9 as escolhas de X(1) e O(0))<br>
#  - os locais que usava as variaveis $t2 mudei para $a1 que nao estava sendo usada<br>
#  - os locais que usava as variaveis $t7 mudei para $a3 que nao era usada<br>
#  - incrementei na funcao do Luis (verposicao) a possibilidade de retornar em $v1 <br>
#    se a posicao de $t1 a $t9 estava desocupada para atribuir o valor entrado pelo <br>
#    teclado.<br>
#  - se em algum momento algum jogador tecla 0 (zero) o jogo acaba.<br>
#  <br>
#######################################################################################<br>
<br>
.data<br>
#inicialização do bitmap<br>
bitmap_address:   .space 0x8000<br>
<br>
#posicao no bitmap<br>
pos_1:	.word 0<br>
pos_2:	.word 84<br>
pos_3:	.word 168<br>
pos_4:	.word 5376<br>
pos_5:	.word 5460<br>
pos_6:	.word 5544<br>
pos_7:	.word 10752<br>
pos_8:	.word 10836<br>
pos_9:	.word 10920<br>
<br>
# menu para jogar<br>
msg0:    .asciiz " -----------------------------------------------------\n"<br>
msg1:    .asciiz "  jogo da Idosa! -------------&gt;UFSCar BSI.g5 - AC ----\n"<br>
msg2:    .asciiz "  ----------------------------------------------------\n"<br>
msg3:    .asciiz "  ------------------------------- aline figueiredo ---\n"<br>
msg4:    .asciiz "     |     |      ---------------- cristiano santana -\n"<br>
msg5:    .asciiz "  1  |  2  | 3     ---------------- jesilene godoy ---\n"<br>
msg6:    .asciiz " ----|-----|----     ---------------- luis miranda ---\n"<br>
msg7:    .asciiz "  4  |  5  | 6         -------------------------------\n"<br>
msg8:    .asciiz " ----|-----|----       -------------------------------\n"<br>
msg9:    .asciiz "  7  |  8  | 9         ------ (0) ZERO SAI DO JOGO ---\n"<br>
msgA:    .asciiz "     |     |           -------------------------------\n"<br>
msgB:    .asciiz " ESCOLHA UMA POSICAO: \n"<br>
<br>
msgFIM_X:  .asciiz " FIM DO JOGO - X VENCEU \n"<br>
msgFIM_O:  .asciiz " FIM DO JOGO - 0 VENCEU \n"<br>
msgFIM:    .asciiz " FIM DO JOGO - NINGUEM VENCEU \n"<br>
<br>
# cores<br>
black:   .word 0x0<br>
white:   .word 0xffffff<br>
red:     .word 0xff8888<br>
green:   .word 0x00ff00<br>
blue:    .word 0x8888ff<br>
<br>
.text<br>
# Definicoes:<br>
# pontuacao do jogador X $k1<br>
# pontuacao do jogador O $k0<br>
#<br>
# vez do jogador X BIT MENOS SIGNFICATIVO DE $t0 = 1  -NUMEROS IMPARES<br>
# vez do jogador O BIT MENOS SIGNFICATIVO DE $t0 = 0  -NUMEROS PARES<br>
#<br>
#     |     |     <br>
#  1  |  2  | 3   <br>
# ----|-----|---- <br>
#  4  |  5  | 6   <br>
# ----|-----|---- <br>
#  7  |  8  | 9   <br>
#     |     |     <br>
<br>
# posicao 1 $t1<br>
# posicao 2 $t2 <br>
# posicao 3 $t3<br>
# posicao 4 $t4<br>
# posicao 5 $t5<br>
# posicao 6 $t6<br>
# posicao 7 $t7<br>
# posicao 8 $t8<br>
# posicao 9 $t9<br>
<br>
######################################################################<br>
#INÍCIO DO PROGRAMA!<br>
	#Zera a pontuacao do jogador X<br>
	li $k1, 0<br>
	#Zera a pontuaçao do jogador O<br>
	li $k0, 0<br>
	#inicia o jogo com o X<br>
	li $a3, 1 <br>
	<br>
	li $t1, 2 #INICIALIZA AS POSICOES COM VALOR 2 (NEM X, NEM O)<br>
	li $t2, 2<br>
	li $t3, 2<br>
	li $t4, 2<br>
	li $t5, 2<br>
	li $t6, 2<br>
	li $t7, 2<br>
	li $t8, 2<br>
	li $t9, 2<br>
	<br>
	<br>
main:<br>
	j tabuleiro #DESENHA O TABULEIRO<br>
	<br>
volta_ao_principal:<br>
	j menu<br>
<br>
volta_menu:<br>
tecla19:	<br>
	li $v0,5  # tecla de 1 até 9<br>
	syscall   # Entrada de teclado posicao 1 a 9<br>
<br>
	#Verifica se é a vez do X ou do O. <br>
	#(se contador $a3 for impar vez do X, se for par vez do 0)<br>
	andi $s1, $a3, 1<br>
	j verPosicao # verifica se a posicao escolhida esta disponivel e zero em $v1 <br>
	             # se posicao estava disponivel<br>
		     # quando posicao disponivel, ocupa a posicao com 1 se X e 0 se O <br>
		     # de $t1 a $t9<br>
		     <br>
volta_verPosicao: #para apos a rotina verPosicao retornar no ponto certo<br>
<br>
	bnez $v1, volta_ao_principal # se foi escolhido uma posicao ja ocupada em <br>
	                             # outra jogada nao desenha nada<br>
			<br>
	# ver quem e o jogador extrair  LSB 0 ou 1<br>
	# andi $s1, $a3, 1  <br>
<br>
	#  se 0 fazO  se 1 fazX<br>
	beq  $s1,$zero,fazo<br>
		<br>
fazx:	jal faz_x<br>
	bne $s1,$zero,fimfaz    <br>
	<br>
fazo:	jal faz_o	<br>
<br>
# incrementa contador - proxima jogada<br>
fimfaz:	addi $a3,$a3,1<br>
<br>
	bgt $a3, 4, alguem_ganhou    # verifica se alguem ganhou<br>
<br>
volta_alguem_ganhou:<br>
	bgt $a3, 9, fim_do_jogo #ultrapassou 9 jogadas	<br>
	j volta_ao_principal    #tecla19 <br>
<br>
# anuncia_vencedor<br>
anuncia_vencedor:<br>
	subi $a3, $a3, 1 #decrementa ultimo incremento	<br>
	andi $s1, $a3, 1 #indentifica ganhador<br>
	beqz $s1, O_vence<br>
<br>
#X_vence:<br>
	li  $v0, 4<br>
	la $a0, msgFIM_X<br>
	syscall <br>
	j the_end   <br>
<br>
O_vence:<br>
	li  $v0, 4<br>
	la $a0, msgFIM_O<br>
	syscall <br>
	j the_end   <br>
<br>
the_end:<br>
	li $v0,10<br>
	syscall<br>
<br>
###########################################################<br>
#  SUBROTINA faz_x<br>
#  FUNCAO: desenha o X na posicao determinada por $a1<br>
#  UTILIZA: $s2 $s3, $a2<br>
###########################################################<br>
<br>
<br>
###########################################################<br>
#  SUBROTINA faz_o<br>
#  FUNCAO: desenha o O na posicao determinada por $a1<br>
#  UTILIZA: $s2 $s3, $s4, $s5, $a2<br>
###########################################################<br>
<br>
###########################################################<br>
#  SUBROTINA tabuleiro<br>
#  FUNCAO: desenha o tabuleiro no BitMapDisplay<br>
#  UTILIZA: $s2, $s3 e $a2<br>
###########################################################<br>
tabuleiro:	<br>
# monta jogo da velha<br>
# como foi elaborado quando estávamos aprendendo a desenhar no BitmapDisplay <br>
# foi feito linha por linha sem a criacao de subrotinas<br>
<br>
	j volta_ao_principal<br>
<br>
###########################################################<br>
#  SUBROTINA menu<br>
#  FUNCAO: so desenha o menu de escolha de posicao<br>
#  UTILIZA: $v0, $a0<br>
###########################################################<br>
menu:<br>
	li  $v0, 4<br>
	la $a0, msg0<br>
	syscall<br>
	la $a0, msg1<br>
	syscall<br>
	la $a0, msg2<br>
	syscall<br>
	la $a0, msg3<br>
	syscall<br>
	la $a0, msg4<br>
	syscall<br>
	la $a0, msg5<br>
	syscall	<br>
	la $a0, msg6<br>
	syscall<br>
	la $a0, msg7<br>
	syscall<br>
	la $a0, msg8<br>
	syscall<br>
	la $a0, msg9<br>
	syscall<br>
	la $a0, msgA<br>
	syscall<br>
	la $a0, msgB<br>
	syscall	<br>
	<br>
	j volta_menu<br>
<br>
###########################################################<br>
#  SUBROTINA verPosicao<br>
#  Funcao: marca qual a posicao desenho<br>
#  UTILIZA: 0, $v0, $s2, $t0, $s1 (recebe se e a jogada do X ou do O), usa de <br>
#           $t1 a $t9 (armazeando 0 se a posicao estiver com O e 1 se tiver com X), <br>
#  RETORNA: $s2 com o endereco do bitmap onde deve ser desenhado se $v1 igual a zero<br>
#           deve ser desenhado o X ou o 0, senao quer dizer que a posicao ja esta <br>
#           ocupada.<br>
###########################################################<br>
	<br>
####################### Termina JOGO ###############################	<br>
fim_do_jogo:	<br>
	li  $v0, 4<br>
	la $a0, msgFIM<br>
	syscall<br>
	<br>
	li $v0, 10 # termina programa se teclar 0<br>
	syscall  <br>
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # <br>
###################################################################<br>
		<br>
						<br>
# marcar posicao na Matriz para soma dos pontos<br>
fimPos:	J volta_verPosicao<br>
<br>
##################################################################<br>
# Funcao alguem_ganhou<br>
#<br>
##################################################################<br>
alguem_ganhou:<br>
	bne  $t1, 2, casa_um_preenchida<br>
a_g_1:<br>
	bne  $t5, 2, casa_cinco_preenchida<br>
a_g_2:	<br>
	bne  $t9, 2, casa_nove_preenchida<br>
	j alguem_ganhou_fim<br>
	<br>
casa_um_preenchida:<br>
	bne $t1, $t2, cp1a<br>
	bne $t1, $t3, cp1a<br>
	jal traca_123<br>
	j anuncia_vencedor<br>
cp1a:	<br>
	bne $t1, $t4, cp1b<br>
	bne $t1, $t7, cp1b	<br>
	jal traca_147<br>
	j anuncia_vencedor<br>
cp1b:	<br>
	bne $t1, $t5, a_g_1<br>
	bne $t1, $t9, a_g_1	<br>
	jal traca_159<br>
	j anuncia_vencedor<br>
<br>
casa_cinco_preenchida:<br>
	bne $t5, $t7, cp5a<br>
	bne $t5, $t3, cp5a<br>
	jal traca_753<br>
	j anuncia_vencedor<br>
cp5a:<br>
	bne $t5, $t4, cp5b<br>
	bne $t5, $t6, cp5b<br>
	jal traca_456<br>
	j anuncia_vencedor<br>
cp5b:<br>
	bne $t5, $t2, a_g_2<br>
	bne $t5, $t8, a_g_2<br>
	jal traca_258<br>
	j anuncia_vencedor<br>
	<br>
casa_nove_preenchida:	<br>
	bne $t9, $t3, cp9a<br>
	bne $t9, $t6, cp9a<br>
	jal traca_369<br>
	j anuncia_vencedor<br>
cp9a:<br>
	bne $t9, $t7, alguem_ganhou_fim #<br>
	bne $t9, $t8, alguem_ganhou_fim #<br>
	jal traca_789<br>
	j anuncia_vencedor<br>
<br>
alguem_ganhou_fim:   # fim da rotina alguem ganhou <br>
                     # (passar por aqui significa que ninguem ganhou)<br>
	j volta_alguem_ganhou<br>
	<br>
##################################################################<br>
# Funcao traca_123<br>
#<br>
##################################################################<br>
traca_123:<br>
	# chame esta funcao com o comando abaixo que voltara sozinho<br>
	#jal traca_123<br>
	li $s2, 0x0B00# 16384 posicao da primeira linha<br>
	li $s3, 64 #16384    largura da primeira linha horizontal<br>
	lw $a2,green #cor da linha<br>
pulo123_a:<br>
	sw $a2, bitmap_address($s2)<br>
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap<br>
	subi $s3, $s3, 1 #derementa contador de largura<br>
	beq $s3, $zero, fim123_a #verifica fim<br>
	j pulo123_a<br>
fim123_a:	<br>
	jr $ra<br>
	<br>
##################################################################<br>
# Funcao traca_456<br>
#<br>
##################################################################	<br>
traca_456:<br>
	#jal traca_123<br>
	li $s2, 0x2000# 16384 posicao da primeira linha<br>
	li $s3, 64 #16384    largura da primeira linha horizontal<br>
	lw $a2,green #cor da linha<br>
pulo456_a:<br>
	sw $a2, bitmap_address($s2)<br>
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap<br>
	subi $s3, $s3, 1 #derementa contador de largura<br>
	beq $s3, $zero, fim456_a #verifica fim<br>
	j pulo456_a<br>
fim456_a:	<br>
	jr $ra<br>
		<br>
##################################################################<br>
# Funcao traca_789<br>
#<br>
##################################################################	<br>
traca_789:<br>
	#jal traca_123<br>
	li $s2, 0x3600# 16384 posicao da primeira linha<br>
	li $s3, 64 #16384    largura da primeira linha horizontal<br>
	lw $a2,green #cor da linha<br>
pulo789_a:<br>
	sw $a2, bitmap_address($s2)<br>
	subi $s2, $s2, 4 #muda para a proxima posicao do bitmap<br>
	subi $s3, $s3, 1 #derementa contador de largura<br>
	beq $s3, $zero, fim789_a #verifica fim<br>
	j pulo789_a<br>
fim789_a:	<br>
	jr $ra<br>
		<br>
##################################################################<br>
# Funcao traca_147<br>
#<br>
##################################################################	<br>
traca_147:<br>
	#jal traca_147<br>
#traco da coluna<br>
	li $s2, 40 #posicao da primeira linha vertical<br>
	li $s3, 64 #altura da linha<br>
	lw $a2, green #cor da linha<br>
pulo147_c:<br>
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display<br>
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)<br>
	subi $s3, $s3, 1	#decrementa contador<br>
	beq $s3, $zero, fim147_c   #testa fim<br>
	j pulo147_c<br>
fim147_c:<br>
	jr $ra<br>
<br>
##################################################################<br>
# Funcao traca_258<br>
#<br>
##################################################################<br>
traca_258:<br>
	#jal traca_258<br>
#traco da coluna<br>
	li $s2, 124 #posicao da primeira linha vertical<br>
	li $s3, 64 #altura da linha<br>
	lw $a2, green #cor da linha<br>
pulo258_c:<br>
	sw $a2, bitmap_address($s2) #comando que desenha pixel no Bitmap Display<br>
	addi $s2, $s2, 256	#passa para linha debaixo 256 = 64(posicoes) * 4 (bytes por posicao ocupados no BitmapDisplay)<br>
	subi $s3, $s3, 1	#decrementa contador<br>
	beq $s3, $zero, fim258_c   #testa fim<br>
	j pulo258_c<br>
fim258_c:<br>
	jr $ra	<br>
	<br>
##################################################################<br>
# Funcao traca_369<br>
#<br>
##################################################################<br>
	<br>
##################################################################<br>
# Funcao traca_753<br>
#<br>
##################################################################<br>
	<br>
##################################################################<br>
# Funcao traca_159<br>
#<br>
##################################################################	<br>
	<br>
####################################################################<br>
</code></pre>
<h1>Autores</h1>

<a href='ALINE.md'>FIGUEIREDO</a>
<hr />

<a href='.md'>CRISTIANO SANTANA CUNHA DE OLIVEIRA</a>
<hr />

<a href='JESILENE.md'>GODOY</a>

<a href='Idosa_Aut_LM.md'>LUIS MIRANDA</a>
<hr />


<h1>Referências</h1>

<li><a href='http://situado.net/como-jogar-o-jogo-da-velha/'>http://situado.net/como-jogar-o-jogo-da-velha/</a>
<li><a href='http://www.cppgameprogramming.com/newforums/viewtopic.php?f=7&t=1920'>http://www.cppgameprogramming.com/newforums/viewtopic.php?f=7&amp;t=1920</a>
<li><a href='http://ellard.org/dan/www/Courses/cs50-asm.pdf'>http://ellard.org/dan/www/Courses/cs50-asm.pdf</a>
<li><a href='http://www.tik.ee.ethz.ch/education/lectures/TI1/materials/assemblylanguageprogdoc.pdf'>http://www.tik.ee.ethz.ch/education/lectures/TI1/materials/assemblylanguageprogdoc.pdf</a>
<li><a href='http://courses.missouristate.edu/kenvollmar/mars/'>http://courses.missouristate.edu/kenvollmar/mars/</a>
<li><a href='https://aur.archlinux.org/packages/mars-mips/?setlang=pt_BR'>https://aur.archlinux.org/packages/mars-mips/?setlang=pt_BR</a>
<li><a href='http://cs.slu.edu/~fritts/csci140/schedule/MARS%20Tutorial.pdf'>http://cs.slu.edu/~fritts/csci140/schedule/MARS%20Tutorial.pdf</a>