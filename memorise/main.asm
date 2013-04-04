.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

.data
	random_numbers: .word 0:10
	current_size: .word 10  
	max_value: .word 100
	time: .word 5

.text

	main:
		# Define a seed para a geração de números randômicos uma só vez no startup do jogo.
		set_seed

		generate_random_numbers(random_numbers, current_size, max_value)
		# imprime os números gerados.
		print_numbers(random_numbers, current_size)
		clock(time)
		clear
		exit_program # encerra o programa
