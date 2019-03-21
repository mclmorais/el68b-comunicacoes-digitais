%Exemplo Antipodal
close all
clc

Fs=100;
Ts=1;

erroAntipodalDKMF = [];
erroAntipodalFiltroCasado = [];
erroOrtogonalDKMF = [];
erroOrtogonalFiltroCasado = [];
erroOrtogonalPPM = [];
numeroDeBits = 100;

noiseStep = 0.5;

% Cria array de bits
arrayInicial = randi([0 1], numeroDeBits, 1)';

% Cria onda analogica de bits
ondaAntipodal = CreateAnalogueArray(arrayInicial, -ones(1,Fs), ones(1,Fs));

ondaOrtogonal = CreateAnalogueArray(arrayInicial, [ones(1,Fs/2) -ones(1,Fs/2)], ones(1,Fs));

ondaPPM = CreateAnalogueArray(arrayInicial, [ones(1,Fs/2) -ones(1,Fs/2)], [-ones(1,Fs/2) ones(1,Fs/2)]);


t=0:1/Fs:numeroDeBits-1/Fs;

figure
x = 1:noiseStep:100;
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])

for nivelRuido = 1:noiseStep:100

  


    ruido=randn(1, length(ondaAntipodal))*sqrt(nivelRuido);

    % Antipodal    

    % Soma ruido na onda de bits
    y=ondaAntipodal+ruido;

    resultadoDKMF = BinaryDetector(y, Fs, 0);
    resultadoFiltroCasado = coupleFilterAntipodal(y, Fs, numeroDeBits);
    
    erroAntipodalDKMF = [erroAntipodalDKMF, CalculateError(arrayInicial, resultadoDKMF)];
    erroAntipodalFiltroCasado = [erroAntipodalFiltroCasado, CalculateError(arrayInicial, resultadoFiltroCasado)];


    %Ortogonal

    % Soma ruido na onda de bits
    y=ondaAntipodal+ruido;

    resultadoDKMF = BinaryDetector(y, Fs, 0.7);
    resultadoFiltroCasado = coupleFilterOrtogonal(y, Fs, numeroDeBits);

    erroOrtogonalDKMF = [erroOrtogonalDKMF, CalculateError(arrayInicial, resultadoDKMF)];
    erroOrtogonalFiltroCasado = [erroOrtogonalFiltroCasado, CalculateError(arrayInicial, resultadoFiltroCasado)];

    % yRx = CreateAnalogueArray(resultadoDKMF, bit0, bit1);
    
    %PPM
    fim=length(y);
    ruido=randn(1,fim)*sqrt(nivelRuido); %Potencia do ruido=100
    y = ondaAntipodal + ruido;
    
    resultadoFiltroCasado = coupleFilterOrtogonal(y, Fs, numeroDeBits);
    erroOrtogonalPPM = [erroOrtogonalPPM, CalculateError(arrayInicial, resultadoFiltroCasado)]; 
   
  %  plot(1:nivelRuido, erroAntipodalDKMF)

end
%concat = [erroAntipodal, erroOrtogonal];
%maxError = floor(max(concat));


% x = 1:noiseStep:100;
% plot(x, erroAntipodalFiltroCasado)
% ylabel('erro (%)');
% xlabel('ruido (%)');
% axis([0 100 0 50])

% x = 1:noiseStep:100;
% plot(x, erroOrtogonalDKMF)
% ylabel('erro (%)');
% xlabel('ruido (%)');
% axis([0 100 0 50])
% x = 1:noiseStep:100;
% plot(x, erroOrtogonalFiltroCasado)
% ylabel('erro (%)');
% xlabel('ruido (%)');
% axis([0 100 0 50])
% x = 1:noiseStep:100;
% plot(x, erroOrtogonalPPM)
% ylabel('erro (%)');
% xlabel('ruido (%)');
% axis([0 100 0 50])
% legend("Antipodal", "AntipodalFiltroCasado", "Ortogonal", "erroOrtogonalFiltroCasado","erroOrtogonalPPM");

hold off

