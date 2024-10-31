import java.util.Random;
import java.util.Scanner;

public class Blackjack {

    // Método para gerar cartas aleatórias
    public static int gerarCarta() {
        Random random = new Random();
        return random.nextInt(13) + 1; // Gera número entre 1 e 13
    }
    

    // Método para calcular o valor da mão
    public static int calcularValorMao(int[] cartas) {
        int valor = 0;
        int ases = 0;
        for (int carta : cartas) {
            if (carta == 1) {
                ases++;
                valor += 11;
            } else if (carta >= 11 && carta <= 13) {
                valor += 10; // Valete, Dama e Rei valem 10
            } else {
                valor += carta;
            }
        }
        // Ajuste do valor do Ás
        while (valor > 21 && ases > 0) {
            valor -= 10;
            ases--;
        }
        return valor;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Random random = new Random();
        boolean jogarNovamente = true;

        System.out.println("Bem-vindo ao Blackjack!");

        while (jogarNovamente) {
            // Distribuir cartas iniciais
            int[] cartasJogador = {gerarCarta(), gerarCarta()};
            int[] cartasDealer = {gerarCarta(), gerarCarta()};

            System.out.println("O jogador recebe: " + cartasJogador[0] + " e " + cartasJogador[1]);
            System.out.println("O dealer revela: " + cartasDealer[0] + " e uma carta oculta.");

            // Jogada do jogador
            boolean jogadorParou = false;
            while (!jogadorParou && calcularValorMao(cartasJogador) <= 21) {
                System.out.println("Sua mão: " + calcularValorMao(cartasJogador));
                System.out.println("O que você deseja fazer? (1 - Hit, 2 - Stand): ");
                int escolha = scanner.nextInt();
                if (escolha == 1) { // Hit
                    int novaCarta = gerarCarta();
                    System.out.println("O jogador recebe: " + novaCarta);
                    cartasJogador = adicionarCarta(cartasJogador, novaCarta);
                } else if (escolha == 2) { // Stand
                    jogadorParou = true;
                }
            }

            // Verifica se o jogador estourou
            if (calcularValorMao(cartasJogador) > 21) {
                System.out.println("Sua mão: " + calcularValorMao(cartasJogador));
                System.out.println("Você estourou! Dealer vence.");
            } else {
                // Jogada do dealer
                System.out.println("O dealer revela sua mão: " + cartasDealer[0] + " e " + cartasDealer[1]);
                while (calcularValorMao(cartasDealer) < 17) {
                    int novaCarta = gerarCarta();
                    System.out.println("O dealer recebe: " + novaCarta);
                    cartasDealer = adicionarCarta(cartasDealer, novaCarta);
                }
                System.out.println("O dealer tem: " + calcularValorMao(cartasDealer));

                // Verificar resultado
                if (calcularValorMao(cartasDealer) > 21) {
                    System.out.println("O dealer estourou! Você venceu!");
                } else if (calcularValorMao(cartasJogador) > calcularValorMao(cartasDealer)) {
                    System.out.println("Você venceu!");
                } else if (calcularValorMao(cartasJogador) < calcularValorMao(cartasDealer)) {
                    System.out.println("Dealer vence.");
                } else {
                    System.out.println("Empate.");
                }
            }

            // Pergunta se quer jogar novamente
            System.out.println("Deseja jogar novamente? (1 - Sim, 2 - Não): ");
            int resposta = scanner.nextInt();
            jogarNovamente = resposta == 1;
        }

        System.out.println("Obrigado por jogar!");
        scanner.close();
    }

    // Função para adicionar uma nova carta à mão
    public static int[] adicionarCarta(int[] mao, int novaCarta) {
        int[] novaMao = new int[mao.length + 1];
        System.arraycopy(mao, 0, novaMao, 0, mao.length);
        novaMao[mao.length] = novaCarta;
        return novaMao;
    }
}
