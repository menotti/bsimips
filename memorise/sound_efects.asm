## Contém procedimentos relacionados a geração de sons para o jogo.
 
# Procedimento que emite um som de contagem a cada segundo, indicando a passagem do tempo e interrompendo a thread atual.
# O procedimento será utilizado para marcar o tempo em que os números ficarão visíveis na tela.
# Após o fim do tempo determinado, um som é emitido indicando que o tempo para o jogador memorizar os números acabou.    
.macro clock($time)
	move $t0, $time
	# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 61 # pitch
	li $a1, 900 # duração em milisegundos
	li $a2, 12 # percussão cromática 
	li $a3, 127 # volume máximo

	loop_clock:
		sub $t0, $t0, 1
		syscall
		bne $t0, $0, loop_clock

	# A seguir, notificamos que o tempo acabou através de um aviso sonoro
	li $a0, 55 # pitch
	li $a1, 1000 # duração em milisegundos
	li $a2, 120 # efeito sonoro 

	syscall
	.end_macro

# Cria um efeito sonoro (ou uma tentativa de) para ser utilizado no início do jogo.  
	.macro welcome
	# Carrega o MIDI out synchronous service
	li $v0, 33
li $a0, 60 # pitch
li $a1, 900 # duração em milisegundos
li $a2, 24 # guitarra
li $a3, 127 # volume máximo
li $t0, 4 # contador para o loop

	loop_welcome:
		sub $t0, $t0, 1
		syscall
		addi $a0, $a0, 2
		sub $a1, $a1, 100
		bne $t0, $0, loop_welcome
	.end_macro
