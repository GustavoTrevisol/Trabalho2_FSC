.data
msg_bemvindo: .ascii "Bem-vindo ao Blackjack!\n\0"
msg_sua_mao: .ascii "Sua mao: \0"
msg_dealer_mao: .ascii "Mao do Dealer: \0"
msg_hit_stand: .ascii "\nDigite 1 para Hit ou 2 para Stand: \0"
msg_vitoria: .ascii " Voce venceu!\n\0"
msg_derrota: .ascii " Dealer venceu.\n\0"
msg_empate: .ascii "Empate.\n\0"
msg_fim: .ascii "Obrigado por jogar!\n\0"
msg_bust: .ascii "Voce estourou com um total de: \0"  # Mensagem de estourar

.text
.globl main
main:
    # Exibe mensagem de boas-vindas
    li a7, 4
    la a0, msg_bemvindo
    ecall

    # Inicializa a mão do jogador com duas cartas
    jal ra, gerarCarta   # Primeira carta do jogador
    mv t0, a0            # Salva em t0
    jal ra, gerarCarta   # Segunda carta do jogador
    mv t1, a0            # Salva em t1

    # Calcula valor inicial da mão do jogador
    mv a0, t0
    mv a1, t1
    jal ra, calcularValorMao
    mv s0, a0            # Guarda o valor total da mão do jogador em s0

    # Inicializa a mão do dealer com duas cartas
    jal ra, gerarCarta   # Primeira carta do dealer
    mv t2, a0            # Salva em t2
    jal ra, gerarCarta   # Segunda carta do dealer
    mv t3, a0            # Salva em t3

jogada_jogador:
    # Exibe valor da mão do jogador
    la a0, msg_sua_mao
    li a7, 4
    ecall
    mv a0, s0            # Passa o valor total da mão do jogador para impressão
    jal ra, print_int

    # Pergunta ao jogador "Hit" ou "Stand"
    la a0, msg_hit_stand
    li a7, 4
    ecall

    # Lê a opção do jogador
    li a7, 5
    ecall
    mv s1, a0            # Salva escolha do jogador

    # Se escolha for "Hit" (1)
    li t4, 1
    beq s1, t4, hit_jogador

    # Se escolha for "Stand" (2), vai para a jogada do dealer
    li t4, 2
    beq s1, t4, jogada_dealer

hit_jogador:
    # Gera nova carta e adiciona ao total da mão do jogador
    jal ra, gerarCarta
    add s0, s0, a0       # Soma a nova carta ao total em s0

    # Verifica se a soma excede 21
    li t5, 21            # Limite máximo
    bgt s0, t5, jogador_bustou  # Se exceder 21, vai para mensagem de estourar

    j jogada_jogador     # Volta para a jogada do jogador

jogador_bustou:
    # Exibe mensagem de estourar com o valor total
    la a0, msg_bust
    li a7, 4
    ecall
    mv a0, s0            # Passa o total para impressão
    jal ra, print_int

    j fim                # Termina o jogo

jogada_dealer:
    # Calcula a mão do dealer
    mv a0, t2
    mv a1, t3
    jal ra, calcularValorMao
    mv s2, a0            # Valor total da mão do dealer

    # Exibe valor da mão do dealer
    la a0, msg_dealer_mao
    li a7, 4
    ecall
    mv a0, s2
    jal ra, print_int

resultado:
    # Verifica quem venceu
    blt s2, s0, vitoria  # Jogador vence se s0 (mão jogador) > s2 (mão dealer)
    blt s0, s2, derrota  # Dealer vence se s2 (mão dealer) > s0 (mão jogador)
    j empate             # Empate se valores iguais

vitoria:
    la a0, msg_vitoria
    li a7, 4
    ecall
    j fim

derrota:
    la a0, msg_derrota
    li a7, 4
    ecall
    j fim

empate:
    la a0, msg_empate
    li a7, 4
    ecall

fim:
    la a0, msg_fim
    li a7, 4
    ecall
    li a7, 10
    ecall              # Termina o programa

# Função para gerar cartas aleatórias entre 1 e 13
gerarCarta:
    li a0, 1            # Define limite inferior (1)
    li a1, 13           # Define limite superior (13)
    li a7, 42           # Syscall para gerar número aleatório
    ecall               # Chamada de sistema
    jr ra               # Retorna com valor em a0

# Função para calcular o valor da mão inicial com duas cartas
calcularValorMao:
    # a0 e a1 contêm as cartas
    mv s4, a0
    mv s5, a1
    li a0, 0            # Inicializa valor da mão
    li s6, 10           # Valor fixo para figuras

    # Soma valor da primeira carta
    blt s4, s6, carta_valida
    mv s4, s6           # Define 10 para figuras

carta_valida:
    add a0, a0, s4      # Soma primeira carta

    # Soma valor da segunda carta
    blt s5, s6, carta_valida2
    mv s5, s6           # Define 10 para figuras

carta_valida2:
    add a0, a0, s5      # Soma segunda carta
    jr ra

# Função auxiliar para imprimir inteiro
print_int:
    li a7, 1
    ecall
    jr ra
