%Exemplo Antipodal
close all
clear all

Fs=100;
Ts=1;

bit1=ones(1,Fs);
bit0=-ones(1,Fs);
y=[bit1 bit0 bit1 bit0 bit1];
t=0:1/Fs:5-1/Fs;

figure
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -2 2])

figure
fim=length(y);
ruido=randn(1,fim)*sqrt(100);%Potencia do ruido=100
y=y+ruido;

t=0:1/Fs:5-1/Fs;
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -10 10])

%Exemplo Ortogonal

bit1=ones(1,Fs);
bit0=[ones(1,Fs/2) -ones(1,Fs/2)];
y=[bit1 bit0 bit1 bit0 bit1];
t=0:1/Fs:5-1/Fs;

figure
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -2 2])

figure
fim=length(y);
ruido=randn(1,fim)*sqrt(100); %Potencia do ruido=100
y=y+ruido;

t=0:1/Fs:5-1/Fs;
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -10 10])
