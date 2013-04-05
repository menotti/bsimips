.include "core.asm"

.data
	numbers_per_level: .word 3, 5, 7, 9, 10
	sequences_per_level: .word 5, 4, 3, 2, 1
	time_per_level: .word 3, 4, 4, 5, 6   
	random_numbers: .word 0:10
	user_numbers: .word 0:10
	current_level: .word 1

.text

	main:
		# Define a seed para a geração de números randômicos uma só vez no startup do jogo.
		set_seed

		set_level_configurations(current_level, numbers_per_level, sequences_per_level, time_per_level)
		make_attempt(random_numbers, user_numbers, $a0, $a1, $a2)
		exit_program
			
