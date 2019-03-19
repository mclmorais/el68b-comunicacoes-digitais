%Exemplo Antipodal
close all
clc

Fs=100;
Ts=1;

erroAntipodalDKMF = [];
erroAntipodalFiltroCasado = [];
erroOrtogonalDKMF = [];
erroOrtogonalFiltroCasado = [];
numeroDeBits = 500;

noiseStep = 0.5;

for nivelRuido = 1:noiseStep:100

    % Antipodal
    
    % Define bits
    bit1=ones(1,Fs);
    bit0=-ones(1,Fs);

    % Cria array de bits
    arrayInicial = randi([0 1], numeroDeBits, 1)';
    
    % Cria onda analogica de bits
    y = CreateAnalogueArray(arrayInicial, bit0, bit1);
    t=0:1/Fs:numeroDeBits-1/Fs;
    
    % Soma ruido na onda de bits
    fim=length(y);
    ruido=randn(1,fim)*sqrt(nivelRuido);%Potencia do ruido=100
    y=y+ruido;


    somador=0;

    resultadoDKMF = BinaryDetector(y, Fs, 0);
    resultadoFiltroCasado = coupleFilterAntipodal(y, Fs, numeroDeBits);
    
    erroAntipodalDKMF = [erroAntipodalDKMF, CalculateError(arrayInicial, resultadoDKMF)];
    erroAntipodalFiltroCasado = [erroAntipodalFiltroCasado, CalculateError(arrayInicial, resultadoFiltroCasado)];

    %Exemplo Ortogonal


    %disp('Ortogonal')
    bit1=ones(1,Fs);
    bit0=[ones(1,Fs/2) -ones(1,Fs/2)];
    y = CreateAnalogueArray(arrayInicial, bit0, bit1);
    

    fim=length(y);
    ruido=randn(1,fim)*sqrt(nivelRuido); %Potencia do ruido=100
    y=y+ruido;

    resultadoDKMF = BinaryDetector(y, Fs, 0.7);
    resultadoFiltroCasado = coupleFilterOrtogonal(y, Fs, numeroDeBits);
    erroOrtogonalDKMF = [erroOrtogonalDKMF, CalculateError(arrayInicial, resultadoDKMF)];
    erroOrtogonalFiltroCasado = [erroOrtogonalFiltroCasado, CalculateError(arrayInicial, resultadoFiltroCasado)];

    yRx = CreateAnalogueArray(resultadoDKMF, bit0, bit1);
end
%concat = [erroAntipodal, erroOrtogonal];
%maxError = floor(max(concat));

figure
hold on
x = 1:noiseStep:100;
plot(x, erroAntipodalDKMF)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])
x = 1:noiseStep:100;
plot(x, erroAntipodalFiltroCasado)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])

x = 1:noiseStep:100;
plot(x, erroOrtogonalDKMF)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])
x = 1:noiseStep:100;
plot(x, erroOrtogonalFiltroCasado)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])
legend("Antipodal", "AntipodalFiltroCasado", "Ortogonal", "erroOrtogonalFiltroCasado");

hold off

