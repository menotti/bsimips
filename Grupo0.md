# Introdução #

Este jogo não foi realmente desenvolvido, mas serviu como exemplo para os demais grupos de como usar os recursos do repositório.

# Código #

É possível listar trechos relevantes do código

```
#------------------------------------------------------------------------------
# grupo0.asm
# Jogo de adivinhar um numero gerado aleatoriamente
# Autor: Ricardo Menotti
#------------------------------------------------------------------------------

.data

msgSemente:	.asciiz "Informe um numero qualquer para comecar"
msgAdivinhe:	.asciiz "Adivinhe qual numero foi gerado!"
msgPalpite:	.asciiz "Informe um palpite:"
msgMaior:	.asciiz "O numero eh maior..."
msgMenor:	.asciiz "O numero eh menor..."
msgAcertou:	.asciiz "Voce acerto!"
msgDesculpe:	.asciiz "Desculpe, nosso jogo ainda nao foi implementado :-("

.text

main:

la $a0, msgSemente
li $v0, 51
syscall

la $a0, msgDesculpe
li $v0, 55
syscall

li $v0, 10
syscall
```

Para incluir uma imagem, crie uma pasta no diretório do seu grupo e faça commit das imagens que deseja incluir. Depois é só usar o link para o arquivo diretamente:

<img src='https://bsimips.googlecode.com/svn/trunk/grupo0/imagens/sorry.png'>

As imagens não devem ser hospedadas fora do projeto, pois podem sair do ar posteriormente.