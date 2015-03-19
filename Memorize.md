**Um jogo de memória para experts!**


</ g:plusone>





## Visão Geral ##


O Memorize é um jogo simplificado de memorização em modo texto, desenvolvido através da linguagem Assemply para o processador MIPS e compatível

com o simulador [MARS](http://courses.missouristate.edu/kenvollmar/mars/) (versão 4.3 ou superiores).


O projeto foi desenvolvido dentro da disciplina Arquitetura e Organização de Computadores, ministrada pelo Prof. Dr. [Ricardo Menotti](http://ufscar.academia.edu/RicardoMenotti), no Bacharelado em Sistemas de Informação da [UFSCar](http://www2.ufscar.br/home/index.php) (Universidade Federal de São Carlos), objetivando a consolidação dos conceitos de programação em baixo nível abordados ao longo do

curso.


## Autores ##


  * Alan Ghelardi
  * Bruna Barbosa dos Santos
  * Danilo Trabuco do Amaral
  * Eronaldo José da Silva


## Como executar ##

Para executar o Memorize, abra o arquivo main.asm no simulador [MARS](http://courses.missouristate.edu/kenvollmar/mars/) (versão 4.3 ou

superiores) e proceda normalmente: monte o arquivo através do menu Run > Assemble e após clique em Run > Go. Alternativamente, execute o jogo
através da linha de comando do sistema. Para isso, considerando que o arquivo .jar do MARS está no mesmo diretório dos fontes do jogo,
navegue até esse diretório e digite o seguinte comando: `java -jar Mars4_3.jar main.asm`


Caso esteja utilizando uma versão do simulador [MARS](http://courses.missouristate.edu/kenvollmar/mars/) superior a 4.3, substitua o nome do

arquivo .jar no comando acima pelo nome correto da sua distribuição.


**Importante:** como o Memorize utiliza macros do MARS incluídas na versão 4.3 do simulador, você necessitará
dessa versão ou de superiores para rodar o jogo. Em versões anteriores, as diretivas .macro, .include e .equiv não serão reconhecidas e os
arquivos não serão montados.


## Regras e funcionamento ##


O memorize é um jogo de memorização baseado em números aleatórios. O principal objetivo do jogador é memorizar os números aleatórios gerados em

cada nível de dificuldade do jogo e digitá-los em ordem.


O jogo apresenta um menu inicial com as opções **Jogar**, **Exibir pontuação**, **Exibir ajuda** e **Sair**. Após selecionar a opção **Jogar**, é exibida

uma mensagem perguntando ao usuário se ele deseja selecionar o nível de dificuldade do jogo. Caso o jogador selecione a opção "sim", é possível

definir o nível de dificuldade em que o jogo será iniciado. Selecionando a opção "não", o Memorize inicia no nível 1.


Por padrão, o jogo apresenta cinco níveis de dificuldade. No primeiro nível,
o jogador deverá acertar cinco sequências contendo três números cada. Nesse nível, os números permanecerão visíveis por 3 segundos. No segundo

nível, o jogador deverá acertar quatro sequências de cinco números cada. No terceiro nível, o jogador deverá acertar três sequências de sete

números cada. Nesses dois níveis os números aleatórios permanecem visíveis por 4 segundos. No quarto nível, o jogador deverá acertar duas

sequências contendo nove números, os quais permanecerão visíveis por 5 segundos. No quinto e último nível, o jogador deverá acertar uma

sequência de 10 números. Nesse nível os números permanecem visíveis por 6 segundos. Salienta-se que o jogador não possui tempo limite para

digitar cada número.


A cada sequência numérica exibida, o Memorize informa o nível atual, o número da sequência atual, a quantidade de sequências a serem memorizadas

no nível e o tempo de memorização. Além disso, um efeito sonoro (que varia de acordo com a plataforma em que o jogo é executado) indica a

passagem de cada segundo. Após informar todos os números da última sequência do nível, o Memorize exibe o índice de acertos do jogador e lhe

oferece a possibilidade de continuar jogando ou de retornar ao menu principal. Novamente, efeitos sonoros e mensagens customizadas são

utilizados para indicar o resultado da tentativa, isto é, informar ao jogador se ele está ou não apto a passar ao próximo nível de dificuldade

do jogo.


Quando o jogador decide progredir entre os níveis do Memorize, isto é, opta por seguir a sequência natural dos níveis de dificuldade em vez de

selecionar um nível árbitrário através do menu do programa, a única forma de avançar de um nível para outro é acertando todos os números

exibidos em cada sequência pertencente ao nível atual.


A qualquer momento é possível verificar sua pontuação geral a partir da opção **Exibir pontuação** no menu principal do Memorize. Essa pontuação

corresponde a somatória dos acertos obtidos em cada tentativa ao longo dos níveis do jogo. Ainda no menu principal do programa, a opção **Exibir**

ajuda**mostra um pequeno guia sobre o funcionamento do jogo, enquanto que a opção**Sair**encerra o Memorize.**


## Estrutura interna ##


Para o desenvolvimento do Memorize optou-se pela ampla utilização das diretivas **.macro**, **.include** e **.equiv**, introduzidas na versão 4.3 do

simulador [MARS](http://courses.missouristate.edu/kenvollmar/mars/). Ainda que o emprego de tais recursos tenha comprometido a compatibilidade do

projeto com versões anteriores do simulador, observou-se um acréscimo indiscutível na legibilidade e na qualidade do código, possibilitando uma

maior modularização do software, evitando a duplicação de código e por conseguinte, favorecendo consideravelmente o reaproveitamento de

componentes.


Em suma, a diretiva **.macro** possibilita a declaração de sequências de instruções utilizadas com certa frequência ao longo do programa. Uma vez

definida, a macro pode ser invocada através da declaração do seu identificador, de forma semelhante ao que ocorre na chamada de procedimentos em

linguagens de mais alto nível. Durante o processo de montagem do arquivo, o assembler se encarrega de substituir as ocorrências do identificador

pelas instruções declaradas no corpo da macro em questão.


Uma característica importante das macros presentes no [MARS](http://courses.missouristate.edu/kenvollmar/mars/) é a possibilidade de definir-se

uma lista de parâmetros formais, de forma análoga à declaração de parâmetros em procedimentos. Novamente, durante o processo de montagem o

assembler substitui os identificadores dos parâmetros utilizados nas instruções presentes no corpo da macro, pelos parâmetros informados na

invocação desta (em geral, _labels_ para endereços na memória, identificadores de registradores e valores literais). Esse recurso possibilita a

emulação de procedimentos de uma forma diferente à apresentada pelas convenções seguidas na linguagem Assembly do MIPS para a criação e

invocação de subrotinas, passagem de parâmetros e retorno de valores (baseadas no emprego de _labels_, utilização da instrução `jal` e do

registrador `$ra`, na manipulação da _stack_ e em um protocolo para a utilização de registradores para a passagem de argumentos e retorno de

resultados).


No Memorize, as macros foram amplamente empregadas para a criação de procedimentos utilizados em diversos módulos do software (evitando a

duplicação do código) e para uma melhor organização do processamento (facilitando a legibilidade e futuras manutenções). A seguir, a fim de

ilustrarmos tais práticas, demonstramos uma macro declarada no arquivo utilities.asm, cuja finalidade é abrir um arquivo presente no disco

rígido, ler seu conteúdo para a memória, imprimir esse conteúdo e fechar o arquivo. Essa macro foi utilizada para carregar e imprimir o

cabeçalho do memorize e o conteúdo da ajuda a partir de arquivos externos.
```
# Procedimento que abre o arquivo informado como parâmetro, lê seu conteúdo e o imprime no output padrão.
# Após ter impresso o conteúdo do arquivo, este é fechado. 
# Parâmetros:
# $file_name: nome do arquivo a ser lido e impresso.
# $maximum_numbers_of_characters: número máximo de caracteres a serem lidos no arquivo.
.macro print_from_file($file_name, $maximum_numbers_of_characters)
	.data
		# Buffer para armazenar o conteúdo do arquivo lido.
		buffer: .space $maximum_numbers_of_characters
	.text
		# Carrega o open file service.
		li $v0, 13
		# Carrega o endereço que contém o nome do arquivo.
		la $a0, $file_name
		# Flag indicando que o arquivo será aberto em modo de leitura.
		li $a1, 0
		li $a2, 0 
		# Abre o arquivo indicado e retorna o "file descriptor" através de $v0.
		syscall
		# Salva o file descriptor em $t0.
		move $t0, $v0

		# Carrega o read file service.
		li $v0, 14
		move $a0, $t0 # file descriptor
		la $a1, buffer # buffer para o qual será copiado o conteúdo do arquivo.
		li $a2, $maximum_numbers_of_characters # número máximo de caracteres a serem lidos
		syscall # lê o conteúdo do arquivo

		# Carrega o print string service
		li $v0, 4
		la $a0, buffer # carrega o buffer com o conteúdo do arquivo
		syscall # imprime o conteúdo do arquivo carregado

				# Carrega o close file service
		li $v0, 16
		move $a0, $t0 # file descriptor a ser fechado
		syscall # fecha o arquivo
.end_macro
```


Outro aspecto importante a ser citado, diz respeito a manipulação da _stack_ em procedimentos que invocam outros procedimentos, a fim de

evitar-se conflitos entre os registradores utilizados. Para criar um software modular e minimamente organizado, tirando proveito da reutilização

de código proporcionada pelas macros do [MARS](http://courses.missouristate.edu/kenvollmar/mars/), foi preciso utilizar, com certa frequência, a

chamada a procedimentos a partir de outros procedimentos, tornando necessário emular _stack frames_ para evitar que valores de registradores

fossem sobreescritos, gerando _bugs_ de difícil detecção. O código a seguir, extraído do arquivo core.asm, ilustra uma macro na qual uma _stack_

frame_é criada no início da sessão de instruções do procedimento. Ao longo da sequência de instruções o valor presente no registrador $t0 é_

salvo na _stack_ e restaurado após a chamada do procedimento _clear_, assumindo a possibilidade de que esse procedimento possa ter utilizado o

registrador temporário $t0 em sua implementação. Por fim, a macro restaura o _stack pointer_ a sua posição original, "destruindo" a _stack_

frame_criada._

```
# Permite ao usuário selecionar o nível de dificuldade do jogo se desejado.
.macro prompt_select_level($level)
	.data
		yes: .byte 's'
		no: .byte 'n'
	.text
		sub $sp, $sp, 4 # stack frame
		prompt: print_string("Deseja selecionar o nivel de dificuldade do jogo?\n")
		print_string("s = sim, n = nao (comeca pelo nivel 1):")
		read_character($t0)
		sw $t0, 0 ($sp) # salva a resposta na stack
		clear

		lw $t0, 0 ($sp) # restaura a resposta da stack
		# Carrega da memória os caractéres de comparação.
		lb $t1, yes
		lb $t2, no

		beq $t0, $t1, get_level
		beq $t0, $t2, use_first_level
		# Se nenhum dos dois desvios foi executado, a opção é inválida.
		print_string("Opcao invalida. Por favor, tente novamente\n\n")
		j prompt 
 
		get_level:
			print_string("Informe o nivel desejado (somente valores que estejam no intervalo [1-5]): ")
			read_integer($t0)
			# A seguir, validamos se a entrada está no intervalo informado.
			slt $t1, $0, $t0
			slti $t2, $t0, 6
			and $t3, $t1, $t2  
			li $t4, 1 # valor para comparação
			beq $t3, $t4, end_prompt_select_level
			# Se esse trecho foi executado, então o valor digitado é inválido.
			clear
			print_string("Valor invalido, por favor, tente novamente\n\n")
			j get_level 

		use_first_level:
			li $t0, 1 # primeiro nível

			end_prompt_select_level:
				sw $t0, $level # armazena na memória o nível a ser utilizado 
				addi $sp, $sp, 4 # restaura a stack frame  
.end_macro
```


As diretivas **.include** e **.equiv** presentes no [MARS](http://courses.missouristate.edu/kenvollmar/mars/) apresentam funções semelhantes às

macros de pré-processamento **#include** e **#define** presentes na linguagem C. Em particular, a diretiva **.include** foi empregada no Memorize para

possibilitar a divisão de responsabilidades sobre o processamento das operações necessárias para o funcionamento do software através de cinco

módulos, quais sejam:
  * main.asm: contém as instruções responsáveis pela lógica de execução do software, variáveis e constantes de escopo global, etc.
  * core.asm: contém os procedimentos relacionados à lógica central do jogo.
  * random.asm: contém procedimentos responsáveis pela geração de números aleatórios.
  * sound\_efects.asm: contém procedimentos relacionados à geração de efeitos sonoros para o jogo.
  * utilities.asm: contém procedimentos utilitários empregados nos demais módulos.


Para maiores informações sobre a utilização das diretivas **.macro**, **.include** e **.equiv** introduzidas na versão 4.3 do

[MARS](http://courses.missouristate.edu/kenvollmar/mars/), sugerimos a leitura da documentação oficial disponível em

http://courses.missouristate.edu/kenvollmar/mars/help/MacrosHelp.html.


Por fim, cita-se a ampla utilização das _systemcalls_ suportadas pelo simulador [MARS](http://courses.missouristate.edu/kenvollmar/mars/) para o

desenvolvimento do Memorize. Algumas das _syscalls_ empregadas no programa são descritas na tabela a seguir.

| **Syscall(s)** | **Código(s) em $v0** | **Utilização** |
|:---------------|:----------------------|:-----------------|
| _Print Integer_, _Print String_, _Read Integer_ e _Read Character_ | 1, 4, 5 e 12 | operações básicas de _I_/_O_ |
| _Exit_ | 10 | encerramento do programa |
| _Open File_, _Read from File_ e _Close File_ | 13, 14 e 16 | leitura de arquivos externos (cabeçalho do programa e conteúdo da ajuda) |
| _Time_, _Set Seed_ e _Random Int Range_ | 30, 40 e 42 | geração de números randômicos |
| _Sleep_ | 32 | interrupção da thread atual (inserção de pausas na execução) |
| _MIDI out synchronous_ | 33 | geração de efeitos sonoros |


Para uma referência completa sobre as _systemcalls_ suportadas pelo simulador MARS, recomendamos a leitura da documentação oficial disponível em

http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html.