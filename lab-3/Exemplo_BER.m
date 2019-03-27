%Neste exemplo N0 é mantido fixo e a amplitude dos símbolos varia em função de
%Eb/N0. Outra alternativa é manter a amplitude dos símbolos fixa e variar
%N0 em função de Eb/N0.

%A resposta ao impulso do filtro casado é considerada de energia unitária
%(EMF=1)
%Os símbolos 's' são gerados originalmente como +1 e -1, com energia
%unitária portanto, e sua amplitude é variada de acordo com o valor de Eb necessário para obter a razão Eb/N0 pretendida.

%A simulação é discreta, a partir dos símbolos a serem transmitidos (s)
%geramos a saída amostrada do filtro casado (y).

close all;
%clear all;

rand('state', 0);
randn('state', 0);


% Número de bits a serem simulados.
bits = 1e6;

% 2-PAM, dois símbolos possíveis na modulação.
M = 2;

% Geração de bits 0 e 1 equiprováveis.
b =  rand(1, bits) > 0.5;

% N0 será fixa em 1.
N0 = 1;

% Eb a princípio seria 1, já que as amplitudes são +1 e -1. 
% Es também seria 1, já que a modulação é binária (1 bit -> 1 símbolo).

% EMF foi suposto como 1, portanto a variância do ruído após o filtro casado é N0/2 apenas.
n = randn(1, bits) * sqrt(N0/2); 

%%%%%%%%%%%%%CASO ANTIPODAL%%%%%%%%%%%%%%%%

% Transforma os bits em uma onda analógica (ou seja, no sinal)
s = 2 * b - 1;

EbN0Step = 1;
EbN0dBMax = 10;

berValues = zeros(1, EbN0dBMax + 1);
PbValues = zeros(1, EbN0dBMax + 1);

% Valor de Eb/N0 a ser considerado na simulação.
x = 0 : EbN0Step : EbN0dBMax;

for EbN0dB = x

  % Eb/N0 em escala linear.
  EbN0 = 10^(EbN0dB/10); 

  %Eb requerido para atingir a razão Eb/N0 de interesse.
  Eb = EbN0 * N0; 

  % Es calculado a partir de Eb. Como a modulação é binária Es=Eb.
  Es=Eb * log2(M); 

  % A amplitude dos símbolos transmitidos é alterada de modo que a energia média seja Es, e consequentemente Eb seja aquela desejada.
  y = (sqrt(Es) * s) + n; 

  % Decisor.
  b_est = y > 0;

  % Contagem de erros.
  erros = sum(b ~= b_est); 

  % Cálculo da BER.
  ber = erros/bits; 

  % BER teórica.
  Pb = qfunc(sqrt(2 * EbN0));

  
  berValues(floor((EbN0dB/EbN0Step) + 1)) = ber;
  PbValues(floor((EbN0dB/EbN0Step) + 1)) = Pb;
end

%%%%%%%%%%%%%CASO ORTOGONAL%%%%%%%%%%%%%%%%

semilogy(x, berValues, 'r', x, PbValues, 's');
grid on;


