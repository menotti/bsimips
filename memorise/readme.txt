 O Memorize é um jogo de memória baseado em números aleatórios desenvolvido por Alan Ghelardi, Bruna Barbosa dos Santos, Danilo Trabuco do Amaral e Eronaldo José da Silva.
 Para executá-lo, abra o arquivo main.asm no simulador MARS e proceda normalmente: monte o arquivo através do menu Run > Assemble e após clique em Run > Go. Alternativamente, execute o jogo através da linha de comando do sistema. Para isso, considerando que o arquivo .jar do MARS está no mesmo diretório dos fontes do jogo, navegue até esse diretório e digite o seguinte comando:
java -jar mars.jar main.asm
 Note que não incluímos a versão do simulador no nome do arquivo .jar do MARS.
 Importante: como o Memorize utiliza macros do MARS incluídas na versão 4.3 do simulador, você necessitará dessa versão ou de superiores para rodar o jogo. Em versões anteriores, as diretivas .macro, .include e .equiv não serão reconhecidas e os arquivos não serão montados.         
