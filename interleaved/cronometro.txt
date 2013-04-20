# Imprime o tempo decorrido em segundos entre as instruções marcadas como
# CRONOMETRO ON e CRONOMETRO OFF.

addi $v0, $0, 30  # Agenda a syscall para pegar o tempo do sistema

syscall		  # CRONOMETRO ON: Guarda em $a0 o tempo em milissegundos decorrido
		  # deade a meia-noite em ponto do dia 01/01/1970 (OBS: Na realidade,
		  # o valor corresponde aos 32 bits menos significativos do
		  # total decorrido. Os bits mais significativos são salvos
		  # no registrador $a1, mas podem ser desprezados para o
		  # propósito do jogo.
		 
add $t1, $0, $a0  # Grava o tempo de início da cronometragem em $t1

syscall		  # CRONOMETRO OFF: Novamente guarda em $a0 o tempo decorrido desde
		  # a meia-noite do dia 01/01/1970.
		 
add $t2, $0, $a0  # Grava o tempo de fim da cronometragem em $t2

sub $t3, $t2, $t1   # Subtrai os tempos obtidos e salva a diferença em $t3
divu $t3, $t3, 1000 # Converte de milissegundos para segundos

add $a0, $0, $t3  # Salva a diferença em $a0, para possibilitar a impressão
addi $v0, $0, 1   # Agenda a syscall para imprimir um inteiro na tela
syscall		  # Imprime a diferença na tela
	
	
		

