Página do jogo Bulls'n'Cows, criado por alunos do Bacharelado em Sistemas de Informação da UFSCar.

# Introdução #

**1. O jogo**

Dado um número  escolhido aleatoriamente,  formado por quatro algarismos de 1 a 6, o jogador tem que advinhar os algarismos, inclusive sua sequência, que formam este número.  Este jogo lê o número de quatro dígitos digitado pelo usuário, retorna acertos “cows” (dígito certo na posição errada) e acertos “bulls” (dígito certo na posição certa), mantendo o histórico de tentativas do usuário na tela. Ao acertar o número secreto o jogador é declarado vencedor.

> De acordo com referências na Wikipedia este é um jogo secular que se jogava usando lápis e papel. Precursor do hoje conhecido como “senha” (ou “mastermind”), há referências de que foi implementado pela primeira vez para o computador na década de 1970.

# Código #

```asm

# Bull: Digito certo no local certo. Cow: Digito certo no local errado.
# Cada registrador de $s0 a $s3 contera um digito da senha secreta, sendo $s0 o digito mais significativo
# Cada registrador de $s4 a $s7 contera um digito do palpite, sendo $s4 o digito mais significativo
# Registradores $t*, conterao valores temporarios usados no processamento
# Registradores $a* e $v* serao utilizados na troca de informacoes nas syscalls e nos procedimentos


#INTERFACE GRÁFICA
# A utilização do bitmap display para o jogo Bulls and Cows será feita utilizando o endereço do ponteiro global para enviar informações.
# Para configurar o ambiente utilize 16 unit pixels para Largura e Altura, configure o bitmap display para 256 largura x 512 altura.
# Altere o base address for display para 0x10008000 ($gp)
# Conecte com o MIPS e execute o programa
# Cada linha tem 64 de tamanho, sendo que cada "pixel" tem 4 de tamanho, então são 16 "pixeis" utilizáveis por linha
# Serão utilizados os registradores $s6 e $s7 para cor de fundo e cor mutável duranto o jogo (Como esses registradores serão utilizados durante o jogo para armazenar os dados da senha mudarei o da cor mutável para t5)
# Para manipular a localização no display serão utilizados os registradores a0...a3 na inicialização da tela e durante o jogo somente os registradores a2 e a3

.data
explicacao: .asciiz "Objetivo: Descobrir uma senha de 4 digitos.\nBull: Digito certo na posicao certa.\nCow: Digito certo na posicao errada.\n\n"
pedirTentativa: .asciiz "\nConsiderando os digitos de 1 a 6, digite uma sequencia de 4 deles, sem repeti-los (Ex: 3256): "
qtdeBulls: .asciiz "Bulls: "
qtdeCows: .asciiz ",  Cows: "
venceu: .asciiz "Parabens, voce venceu!"
placar: .asciiz " Pontuacao: "
falhou: .asciiz "O máximo de tentativas é de 11 rodadas."


Largura:		.half 16			# Armazena a altura e largura da tela para colorir
Altura:			.half 32			# Utiliza o global pointer ($gp) do bitmap display com a configuração 256x512 com 8 unidades cada pixel

CorPrincipal:		.word 0x00000000		# Cor para titulo e bordas - preto
Cor1:			.word 0x00AA0000		# Cor 1 - vermelho
Cor2:			.word 0x00FFEF00		# Cor 2 - amarelo
Cor3:			.word 0x000000FF		# Cor 3 - azul
Cor4:			.word 0x0000AA00		# Cor 4 - verde
Cor5:			.word 0x0000FFFF		# Cor 5 - azul claro
Cor6:			.word 0x00FF8900		# Cor 6 - laranja
Fundo:			.word 0xFFC2C2C2		# Cor do fundo da tela - cinza

.text

main:
# inicialização dos gráficos antes de iniciar o jogo
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
# Fim da inicialização gráfica da tela, jogo inicia a partir daqui, registradores usados na inicialização da tela e no jogo estão agora livres para o jogo
```


# Detalhes #

Documentação - Jogo Bulls and Cows (parcial)

**2. O trabalho de desenvolvimento**

O desenvolvimento deste projeto, sendo parte integrante das atividades previstas na disciplina de Arquitetura de Computadores, foi desenvolvido por um grupo de sete alunos do curso de BSI-UFSCar. O grupo, após organizar os seus meios de comunicação para o desenvolvimento do trabalho coletivo e dividir algumas tarefas entre os membros, investigou duas possibilidades de jogos a serem implementados - o “quadrado mágico” e o “bulls and cows”. Após alguns testes com exemplos desenvolvidos em linguagem de alto nível optou-se pelo “Bulls and Cows”. Paralelamente, algumas soluções foram desenvolvidas em linguagem Assembly do MIPS: geração aleatória de números, já utilizada; um timer, ainda não utilizado para pontuação; e gráficos, também ainda não utilizados.

Sendo assim, este projeto ainda se encontra em desenvolvimento.

**3. Algoritmo**

Considerando algoritmo como um procedimento passo a passo para solução de problemas, também, como sequência detalhada de ações a serem executadas para realizar alguma tarefa. (MEDINA, FERTIG, 2006). Iniciamos o projeto pela o algoritmo para conseguirmos orientar as ideias e planejar com mais eficiência e eficácia.

A proposta de criarmos um jogo nos fez remeter à ideia de aperfeiçoarmos a capacidade de criar programas de computador, e como sabemos, um programa de computador é um conjunto de instruções que será executado pelo processador em uma determinada sequência. As instruções que o processador executa são buscadas da memória. (MEDINA, FERTIG, 2006).

Programar em linguagem de baixo nível, ou linguagem de máquina, se distancia da linguagem natural. A linguagem de programação que um computador é capaz de compreender é composta apenas de números. Portanto, quando fazemos um algoritmo na linguagem de programação do computador ou em sua linguagem de máquina é um processo extremamente complicado. Para facilitar a programação de computadores, foi necessária a criação de um código que relacionasse a linguagem de máquina a uma linguagem mais fácil de ser compreendida.

Usar Assembly é utilizar a linguagem de montagem, é um código que tem uma instrução alfanumérica (ou mnemônica) para cada instrução numérica em linguagem de máquina. (MEDINA, FERTIG, 2006). Conhecer as regras do jogo, conseguir entender seu funcionamento, conseguir traduzir da linguagem natural para linguagem de máquinas, foi a estratégia para conseguirmos elaborar o algoritmo, linguagem de alto nível e depois traduzir para linguagem de baixo nível.

Algoritmo

Algoritmo\_Jogo Senha

Variáveis: inteiro i, geraSenha, letentativa, distDigitos, compara, tentativa, qtdeBulls, qtdeCowns

Inicio

Escreva: "Objetivo: Descobrir uma senha de 4 digitos. Bull: Digito certo na posicao certa. Cow: Digito certo na posicao errada.”

Escreva: "Considerando os digitos de 1 a 6, digite uma sequencia de 4 deles, sem repeti-los (Ex: 3256): "

Aleatório geraSenha();

Ler: lerTentativa;

lerTentativa = distDigitos;

Se compara = = lerTentativa;

Escreva: "Parabens, voce venceu!"

Senão

Para (tentativa = 0; tentativa < 10; tentativa++)
> Escreva “ A quantidade de cows eh: “, qtdeCowns;
> > Escreva “ A quantidade de bulls eh: “, qtdeBulls;

Fim-algoritmo


**4. Dicionário**

Registradores:

De $s0 a $s3: utilizados para guardarem um digito da senha secreta, sendo $s0 o digito mais
significativo;

De $s4 a $s7: utilizados para guardarem um digito do palpite, sendo $s4 o digito mais
significativo;

$t: utilizados para guardarem valores temporários usados no processamento;

$a e $v: utilizados na troca de informações nas syscalls e nos procedimentos.

Procedimentos:

geraSenha: gera a senha secreta - número de quatro dígitos (de 1 até 6);
tentativa: executa a leitura de cada tentativa do usuário, copiando o endereço do inteiro lido;
leTentativa: faz a leitura do número digitado pelo usuário;
distDigitos: distribui cada dígito para um registrador;
compara: compara os dígítos do palpite com os dígitos da senha secreta e registra o

> número de acertos;
feedback: imprime na tela o número de acertos;
fimPrograma: finaliza o programa.

**5. Conclusão**

A experiência com o desenvolvimento deste jogo foi bastante construtiva,  especialmente os testes e o melhoramento de seu código, além do interfaceamento da lógica do jogo com sua contraparte gráfica.