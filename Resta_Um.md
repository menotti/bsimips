# **GAME: RESTA 1** #

### **Integrantes:** ###


Clodoaldo Ribeiro dos Santos 482773

Maiara Guimaraes Flausino 435589

Marcelo Vieira Arjona 434558

Paula Gabriela Mota Alves 483125

Vanderli Gilson de Sousa 482765

Vitor Alves de Andrade 435970


## **INTRODUÇÃO** ##

Como foi proposto na matéria de Arquitetura de Computadores um desenvolvimento de um jogo em Assembly, decidi-se pelo jogo resta-um, que é um jogo solitário cujo objetivo é conseguir deixar apenas uma peça no tabuleiro que comportavam inicialmente várias peças.

Como todo jogo, há regras, as quais permitem que um peça no tabuleiro possa “eliminar” outra peça em posição adjacente horizontal ou verticalmente aquela, sendo que a posição alcançada é a posição vizinha da peça eliminada.

<img src='https://bsimips.googlecode.com/svn/trunk/Resta um/Imagens/resta1.png'>


<h2>Resta 1: como jogar</h2>

O objetivo é deixar apenas uma peça no tabuleiro. Para começar, coloque as 32 peças no jogo, deixando o espaço do centro vazio. Escolha uma peça para começar: ela deve “saltar” sobre outra peça, fazendo movimentos na horizontal ou vertical, para chegar ao espaço vazio. A peça que foi “comida” sai do jogo. Só vale comer uma peça por vez. O jogo acaba quando restar só uma peça (vitória!) ou não der mais para fazer movimentos – sinal de que você perdeu!<br>
<br>
<br>
<h2><b>OBJETIVO</b></h2>

O objetivo deste trabalho é consolidar os conhecimentos sobre a linguegem assembly, desenvolvendo um jogo “resta-um”, a fim de colocar em prática os conhecimentos teóricos adquiridos na matéria.<br>
<br>
<br>
<h2><b>RESTA 1</b></h2>


A figura 1 ilustra um tabuleiro do jogo RESTA UM. Começa-se o jogo com peças em todas as casas, exceto em uma, que está inicialmente vazia. Nesse jogo, todas as peças podem ser movimentadas. No entanto, cada casa comporta, no máximo, uma peça.<br>
<br>
Nesse jogo, a única jogada possível consiste em: dadas três casas consecutivas em linha, na horizontal ou na vertical, se uma das casas, que não a central, estiver vazia e as outras duas, ocupadas, uma das peças salta a outra, adjacente, retirando-se do jogo a que foi pulada. Se não for possível realizar a jogada, o jogo acaba.<br>
<br>
Na Figura 2, vê-se a casa A vazia e as casas B e C ocupadas. A peça que está em C pula a que está em B e passa a ocupar a casa A. A peça da casa B, que foi pulada, é retirada do jogo (Figura 3).<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Resta um/Imagens/figura1.png'>


Para eliminar uma bolinha, você precisa "pular" sobre ela, como no jogo de Damas. Para fazer isso, clique sobre a bolinha que vai pular outra que tenha uma casa vazia ao lado.<br>
<br>
Se houver mais de um movimento possível com a bolinha escolhida, aparecem sinais em vermelho para você escolher, clicando sobre um deles.<br>
<br>
Ganha-se o jogo quando resta apenas uma bolinha.<br>
<br>
<h2><b>DESENVOLVIMENTO DO JOGO</b></h2>

Para a manipulação foi preciso a construção de um tabuleiro, como um vetor de 33 buracos.<br>
<br>
Foi preciso também definir algumas variáveis, como:<br>
<br>
origem, buraco de onde o jogador selecionou a peça para movê-la;<br>
<br>
pula, buraco vizinho imediato da origem que vai ser eliminado no final de um passo sucedido;<br>
<br>
final, buraco onde a peça ficará depois de uma  jogada;<br>
<br>
pecas, número de peças sobre o tabuleiro (atualizado a cada passo);<br>
<br>
vencedor, 1 quando o jogador ganhou e 0 quando perdeu.<br>
<br>
Passo a passo do jogo<br>
Um passo do jogo consiste na seleção de uma peça pelo jogador, no deslocamento desta e termina quando a peça é solta.<br>
<br>
<h2><b>RESULTADOS</b></h2>

<h3>Manual do usuário</h3>

Quando a janela de jogo se abre, o usuario pode começar a jogar selecionando uma peça com um clique e rastreando-a aonde quiser mantendo-se o botão esquerdo do mouse apertado. Uma vez a posição de destino atingida, é só liberar o botão do mouse. Se a jogada for impossível, a peça voltará ao seu lugar anterior. Caso contrário, ela ficará nesta posição e a peça pulada sumirá.<br>
<br>
No fim do jogo aparecerá na janela como as possíveis mensagens: você ganhou ou você perdeu.<br>
<br>
<h3>1 - Documentação da sequência do projeto</h3>


- <b>INÍCIO DO JOGO</b> : Tabuleiro na tela<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Resta um/Imagens/imagem 1.png'>

- Movimento das pedras<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Resta um/Imagens/mov pedras.png'>

- Movimentos inválidos<br>
<br>
<img src='https://bsimips.googlecode.com/svn/trunk/Resta um/Imagens/mensagem jogada inválida.png'>

<h3>2 - Documentação dos métodos utilizados</h3>


<b>a. Demonstrar o jogo em tela</b>

# macro para imprimir o jogo na tela<br>
<br>
.macro print(%pl)<br>
<br>
la $t0, %pl<br>
<br>
la $a0, ($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 4($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 8($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 12($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 16($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 20($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
la $a0, 24($t0)<br>
<br>
li $v0, 4<br>
<br>
syscall<br>
<br>
<br>
.end_macro<br>
<br>
<br>
<b>b. Movimentar pedras</b>

imprimeLinha<br>
<br>
li $v0, 5 # Macro para solicitar ao usuário a linha que deseja consultar<br>
<br>
syscall<br>
<br>
sw $v0, teclin<br>
<br>
<br>
imprimeColuna<br>
<br>
li $v0, 5<br>
<br>
syscall # Macro para solicitar ao usuário a coluna que deseja consultar<br>
<br>
sw $v0, teccol<br>
<br>
<br>
impLinha<br>
<br>
li $v0, 5 # Macro para solicitar ao usuário a linha que deseja consultar<br>
<br>
syscall<br>
<br>
sw $v0, tlin<br>
<br>
<br>
impColuna<br>
<br>
li $v0, 5<br>
<br>
syscall # Macro para solicitar ao usuário a coluna que deseja consultar<br>
<br>
sw $v0, tcol<br>
<br>
<br>
<b>c. Operação de retirada de pedras do tabuleiro ("Comer")</b>




<h2><b>CONCLUSÃO</b></h2>

Este trabalho permitiu aplicar os conhecimentos teóricos da matéria Arquiterura de computado, sendo que o projeto de um jogo interativo obrigou os componentes do grupo a estudar mais detalhadamente a linguegem assembly.<br>
<br>
<h2>CURIOSIDADES</h2>

Gottfried von Leibniz, o filósofo e matemático alemão, numa carta de 1716, exaltava as virtudes de um passatempo que tem atravessado os séculos e, ainda hoje, continua despertando o interesse, tanto do jogador ocasional, disposto a matar meia-hora agradavelmente, quanto do estudioso, mais interessado em descobrir as leis que governam suas soluções. Seu nome é Solitaire (solitário), mas é muito mais conhecido no Brasil como Resta Um. Sua origem é um quebra-cabeça à parte, repleto de peças que não se encaixam bem. Uma das histórias não confirmadas, porém das mais difundidas, diz que ele foi inventado por um prisioneiro encarcerado numa solitária da Bastilha, como lenitivo para seu tédio.<br>
<br>
De uma coisa temos certeza: o tabuleiro utilizado no Solitaire é muito semelhante a outro usado em jogos mais antigos, como por exemplo o medieval Raposa e gansos e, com toda a probabilidade, evoluiu a partir dele.<br>
<br>
Seja como for, o século XVIII já assistia à sua extraordinária difusão pela Europa. Modernamente, distinguimos dois tabuleiros de Solitaire: o inglês e o francês. Este último apresenta, em relação ao primeiro, quatro casas a mais. O inglês, tradicionalmente, é trabalhado numa única peça circular de madeira, na qual se fazem 33 concavidades e um sulco ao longo da borda.<br>
<br>
Neste modelo, utilizam-se bolas de gude como peças e o sulco se destina à colocação das bolas capturadas. O modelo francês é usualmente composto de um quadrado perfurado, onde se introduzem pinos de madeira. Embora seja muito fácil encontrar no comércio jogos de Solitaire de variados tamanhos, aspectos e preços, bastará ao leitor o diagrama da mais 32 grãos de feijão para se iniciar nos mistérios desse passatempo, que Leibniz recomendava como boa forma de exercitar o raciocínio. Muitos problemas podem ser propostos sobre um tabuleiro de Solitaire, mas, infelizmente, as regras fornecidas nos jogos industrializados invariavelmente fazem referência a apenas um. Vamos a ele.<br>
<br>
O leitor deve colocar um feijão em cima de cada casa (pontos pretos), exceto a central. As peças se movem pulando as outras na horizontal e na vertical, nunca na diagonal. Para mover-se, uma peça deve pular outra que lhe seja adjacente, caindo numa casa vazia imediatamente seguinte. A peça que foi pulada é retirada do jogo. Se aquela que acabou de se mover puder fazer um novo pulo, o leitor pode prosseguir movendo-a numa sucessão de pulos (isso é considerado uma única jogada). Entretanto, não é obrigatório pular todas as peças disponíveis, podendo-se interromper a jogada após qualquer um dos pulos da seqüência. O objetivo do passatempo é deixar uma única peça sobre o tabuleiro.<br>
<br>
Os números inscritos nas casas servem para anotar as jogadas e registrar as soluções. Em quantas jogadas o leitor conseguirá resolver este primeiro problema? Depois de consegui-lo, tente repetir o feito, mas diminuindo o número de lances. O número mínimo de movimentos para a solução depende da casa em que se pretenda deixar a última peça. Em outras palavras, esse número tem relação direta com o par de casas que se escolha para iniciar e terminar o jogo.<br>
<br>
Isto nos leva a um segundo problema, mais específico: começar com a casa central vaga e terminar com o último pino também colocado nessa mesma casa. O leitor quer tentar? Saiba que o famoso inventor de quebra-cabeças inglês, Henry Ernest Dudeney, apresentou para este caso uma solução em dezenove lances, publicada em abril de 1908. Em seu comentário, ele afirmava não acreditar que essa marca pudesse ser melhorada. Todavia, doze anos mais tarde, Ernest Bergholt publicou o livro chamado The Game of Solitaire, onde apresentava uma solução em dezoito lances. Ela está à disposição do leitor aflito no armário de tranqüilizantes, isto é, na seção de soluções.<br>
<br>
Nada nos obriga a começar com a casa vazia no centro. Se deixarmos vaga, no início, a casa de número 11, ou a de número 30, é possível resolver o problema em apenas quinze lances, o que constitui, até onde estou informado, o recorde absoluto. E preciso alertar o leitor, contudo, para o fato de que nem todos os pares de casas que sejam escolhidos para início e término serão capazes de gerar uma solução. O livro de Bergholt propunha vários outros problemas para o Solitaire. Por exemplo, manter uma das peças "na espera", sem ser movida até o último lance, quando então ela captura uma ou mais peças e se torna a última sobrevivente.<br>
<br>
Ou, em outro desafio, manter uma peça congelada, sem se mexer até a última jogada, quando acaba sendo capturada. Ou ainda tentar concluir o passatempo com um espetacular salto múltiplo que, segundo ele, pode capturar até nove peças na última jogada - um autêntico salto mortal, para quem tiver pouca paciência. A seção de soluções tem uma providencial rede de segurança, mas apenas para um salto múltiplo de seis peças. Acrobacias maiores correm por conta e risco do leitor.<br>
<br>
<br>
<h2><b>REFERÊNCIAS</b></h2>

Definição de blocos de asm como Macros C. Visual Studio, Microsoft. Disponpivel em: <<a href='http://msdn.microsoft.com/pt-br/library/vstudio/352sth8z.aspx>'>http://msdn.microsoft.com/pt-br/library/vstudio/352sth8z.aspx&gt;</a>. Acesso em: 29 Abr 2013.<br>
<br>
<br>
High Level Assembler for z/OS & z/VM & z/VSE V1R6 (HLASM V1R6) Language Reference: How to specify macro definitions. IBM. Disponível em: <<a href='http://publib.boulder.ibm.com/infocenter/zos/v1r11/index.jsp?topic=/com.ibm.zos.r11.asma400/prepmac.htm>'>http://publib.boulder.ibm.com/infocenter/zos/v1r11/index.jsp?topic=/com.ibm.zos.r11.asma400/prepmac.htm&gt;</a>. Acesso em: 29 Abr 2013.<br>
<br>
<br>
NETO, Luiz Dal Monte. Jogo Resta-um. Super Interessante, Jul. 1990. Disponível em: <<a href='http://super.abril.com.br/cotidiano/resta-um-pula-sela-mental-439520.shtml>'>http://super.abril.com.br/cotidiano/resta-um-pula-sela-mental-439520.shtml&gt;</a>. Acesso em: 29 Abr 2013.