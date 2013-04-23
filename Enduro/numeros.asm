#--------------------------------------------------------------------------------
		# Imprime 1 conforme endereco e cor dadas via $a1 e $a0
.macro Print1#($endereco, $cor)

		#la	$a1, $endereco
		#lw	$a0, $cor
		# Linha 1
		or 	$a3, $zero, $a1
		add 	$a1, $a1, 60
		or 	$a1, $zero, $a3
		
		# Linha 2
		add 	$a1, $a1, 1024
		or 	$a3, $zero, $a1
		add 	$a1, $a1, 28
		sw 	$a0, ($a1)
		add 	$a1, $a1, 4
		sw 	$a0, ($a1)
		add 	$a1, $a1, 28
		or 	$a1, $zero, $a3
		
		# Linha 3
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 24
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 4
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 20
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 5
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 16	
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 8
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 6
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 20
		sw $a0, ($a1)
		add $a1, $a1, 12
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 7
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 8		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 9		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 10
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 11
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 12
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 13		
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 14
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 15
		add $a1, $a1, 1024
		or $a3, $zero, $a1
		add $a1, $a1, 32
		sw $a0, ($a1)
		add $a1, $a1, 4
		sw $a0, ($a1)
		add $a1, $a1, 24
		or $a1, $zero, $a3
		
		# Linha 16
		or 	$a3, $zero, $a1
		add 	$a1, $a1, 60
		or 	$a1, $zero, $a3
		nop
#		jr	$ra
.end_macro 
#--------------------------------------------------------------------------------