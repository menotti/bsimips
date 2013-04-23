.kdata

      L1:      .space 28                                      #Armazena a 1º Linha
      L2:      .space 28                                      #Armazena a 1º Linha
      L3:      .space 28                                      #Armazena a 1º Linha 
      L4:      .space 28                                      #Armazena a 1º Linha
      L5:      .space 28                                      #Armazena a 1º Linha
      L6:      .space 28                                      #Armazena a 1º Linha
      L7:      .space 28                                      #Armazena a 1º Linha
      teclin:  .word                                          #Cria a Variável para guardar o que o usuário digita para linha 
      teccol:  .word                                          #Cria a Variável para guardar o que o usuário digita para coluna 
      ponto:   .space 128                                     #Cria um espaço na memória para guardar a pontuação que no máximo será 32 pontos                                    
      tecNome: .space 40                                      #Cria um array para guardar o nome do jogador
      
      
                                                            #abaixo segue as frases utilizadas durante o jogo
      fim:    .ascii "Fim do Jogo"                          
      err:    .ascii "Jogada Invalida"
      inicio: .ascii "Inicio da Jogo"
      linha:  .ascii "Digite a linha\n "
      col:    .ascii "Digite a Coluna "
      escnome:.ascii "Digite seu nome"
      plinha: .ascii "\n"
      
 #Macro para imprimir a linha que o usuário deseja movimentar 
.macro imprimeLinha
.data
      msg:   .asciiz "Digite a linha que deseja movimentar"                 #Mensagem que será impressa na chamada do SO
   .text    
   li $v0, 4
   la $a0, msg                                                              #Mensagem que será impressa na chamada do SO
   syscall
.end_macro

.macro imprimeColuna
    .data
      msgc:   .asciiz "Digite a coluna que deseja movimentar"               #Mensagem que será impressa na chamada do SO
   .text    
    la $a0, msgc                                                            #Mensagem que será impressa na chamada do SO
    li $v0, 4
    syscall
.end_macro

#Macro que inicia o vetor com espaço e 'o' pque são a peças do jogo nas linha com apenas 3 peças
.macro inicio0(%linha)

    .text
                la $t0, %linha 
        	li $t1, ' '		
		sw $t1, ($t0)
		li $t1, ' '		
		sw $t1, 4($t0)
		li $t1, 'o'				
		sw $t1, 8($t0)
        	li $t1, 'o'		
		sw $t1, 8($t0)		
                li $t1, 'o'		
		sw $t1, 12($t0)
		li $t1, 'o'		
		sw $t1, 16($t0)
.end_macro            

#Macro que inicia o vetor com espaço e 'o' pque são a peças do jogo nas linha com 7 peças         
.macro inicio (%linha)

    .text
                la $t0, %linha 
        	li $t1, 'o'		
		sw $t1, ($t0)		
		li $t1, 'o'		
		sw $t1, 4($t0)		
		li $t1, 'o'		
		sw $t1, 8($t0)		
                li $t1, 'o'		
		sw $t1, 12($t0)
		li $t1, 'o'		
		sw $t1, 16($t0)
		li $t1, 'o'		
		sw $t1, 20($t0)
		li $t1, 'o'		
		sw $t1, 24($t0)

 .end_macro

# macro para imprimir o jogo na tela
.macro print(%pl)
             
          	la $t0, %pl
		la $a0, ($t0)
		li $v0, 4
		syscall

		la $a0, 4($t0)
		li $v0, 4
		syscall
		
		la $a0, 8($t0)
		li $v0, 4
		syscall
		
		la $a0, 12($t0)
		li $v0, 4
		syscall
		
		la $a0, 16($t0)
		li $v0, 4
		syscall
	
		la $a0, 20($t0)
		li $v0, 4
		syscall
		
	        la $a0, 24($t0)
		li $v0, 4
		syscall

.end_macro

#macro para pular linha
.macro pulalinha
      la $a0, plinha
      li $v0, 4
      syscall      
.end_macro


# programa principal
.text

jogo: 

    
main:
    inicio0(L1)                                                     # Chama a macro para inserir a variável   
    inicio0(L2)
    inicio(L3)
    inicio(L4)
    inicio(L5)
    inicio0(L6)
    inicio0(L7)
    
    la $t0, L4
    li $t1, ' '		
    sw $t1, 12($t0)
  
    print(L1)
    pulalinha
    print(L2)
    pulalinha
    print(L3)
    pulalinha
    print(L4)
    pulalinha
    print(L5)
    pulalinha
    print(L6)
    pulalinha
    print(L7)
    pulalinha
    pulalinha
    
    imprimeLinha
    
    li $v0, 5
    syscall
    sw $v0, teclin
    
    imprimeColuna
    
    li $v0, 5
    syscall
    sw $v0, teccol
    
    