# RC4_mvn
Implementação do algoritmo de encriptação RC4 em assembly utilizando o padrão MVN da disciplina PCS3616 (Sistemas de Programação) da Poli-USP.

Co-autor : [Matheus Tavares](https://github.com/skyandee)

## Algoritmo RC4
  Em criptografia, RC4 é um algoritmo simétrico de encriptação de fluxo. De uma forma geral, o algoritmo consiste em utilizar um array que a cada utilização tem os seus
  valores permutados e misturados com a chave.
  
  Seu funcionamento consiste na definição de um vetor identidade S e uma variável j = 0. Em seguida, para cada posição de S redefine-se
  
  j = (j + S[i] + K[i mod len(K)]) mod len(S)
  
  e, em seguida, S[i] é permutado com S[j]. K é uma chave utilizada na inicialização do array, podendo ter até 256 bytes, embora o algoritmo seja mais eficiente quando     ela é menor, pois a perturbação aleatória induzida no array é superior.

## Estudo da Proposta
  Para o escopo da disciplina, operações de escalabilidade serão desconsideradas. Além disso, para fins de estudo, serão tomados valores constantes para os tamanhos de S (10) e de K (3).
  
  Em C, o algoritmo correspondente seria o seguinte:
  
  ```C
  
  int s[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  int i, j, tamanho_chave = 3, tamanho_entrada = 10;
  char resultado[10];

  void troca() {
      int aux;
      aux = s[i];
      s[i] = s[j];
      s[j] = aux;
  }

  void KSA() {

      i = 0, j = 0;

      for (i = 0; i < 10; i++) {
          j = (j + s[i] + chave[i % tamanho_chave]) % 10;
          troca(i, j);
      }
  }
  
  ```
  
  Então, primeiramente, o vetor S é preenchido:
  
  S = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  
  O próximo passo consiste em calcular j para cada valor de i, com 0 ≤ i < 10. Para i = 0, o que
  temos, então, é
  
  j = (0 + S[0] + K[0 mod 3]) mod 10
  
  j = K[0] mod 10
  
  j = 5
  
  Permutando S[0] com S[5], o novo vetor S será
  
  S = 5 | 1 | 2 | 3 | 4 | 0 | 6 | 7 | 8 | 9
  
  Ao final do processo, teremos o seguinte:
  
  S = 5 | 0 | 1 | 4 | 7 | 3 | 6 | 8 | 9 | 2
  
  Com o vetor S definido, Podemos passar para a parte de criptografia da mensagem. Devemos
  fazer uma rotina tal que, em cada repetição:
  
  1. Incrementa em 1 a variável i;
  
  2. Adiciona o valor de S[i] com j e armazena o resultado em j;
  
  3. Troca os valores entre S[i] e S[j];
  
  4. Realiza operação XOR entre o valor de S[S[i] + S[j]] e a mensagem original na posição k,
  em que k é um contador.
  
  Os 3 primeiros passos geram um vetor aqui designado como "vetor chave". No último passo, é
  gerada a mensagem criptografada propriamente dita.
  
  ```C
  void PRGA() {
      i = 0,  j = 0;
      for (int k = 0; k < tamanho_entrada; k++) {
          i = (i + 1) % tamanho_s;
          j = (j + s[i]) % tamanho_s;
          troca(i, j);
          resultado[k] = (s[(s[i] + s[j]) % tamanho_s] ^ entrada[k]);
      }
  }
  ```
  A mensagem "PAZ E BEM!", ao final do processo, ficaria como
  
  M = P | A | Z | E | B | E | M | !
  
  C = S | G | R | ’ | E | % | K | E | J
  
  O processo de descriptografia é análogo – A mensagem criptografada torna-se a entrada, ao
  passo que a mensagem resultante do processo é a mesma que foi usada no processo de cripto-
  grafia.
  
  ## Algoritmo em Assembly
  
  O script [encripta.asm](https://github.com/IzabelaMarina/RC4_mvn/blob/main/encripta.asm) lê a mensagem guardada em file.txt, encripta e escreve em file_enc.txt, utilizando disp.lst para reconhecer os arquivos de texto.

