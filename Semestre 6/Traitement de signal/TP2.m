%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TP1 de Traitement Num�rique du Signal
%                   SCIENCES DU NUMERIQUE 1A
%                       Fevrier 2024 
%                        L�a HOUOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=1;                %amplitude du cosinus
f1=1000;            %fr�quence du cosinus en Hz
T1=1/f1;
f2=3000;
T2=1/f2;
N=100;               %nombre d'�chantillons souhait�s pour le cosinus
Fe=10000;           %fr�quence d'�chantillonnage en Hz
Te=1/Fe;            %p�riode d'�chantillonnage en secondes
SNR="� completer";  %SNR souhait� en dB pour le cosinus bruit�


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GENERATION DE LA SOMME DE COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%D�finition de l'�chelle temporelle
temps=0:Te:(N-1)*Te;
%G�n�ration de N �chantillons de cosinus � la fr�quence f0
x=A*(cos(2*pi*f1*temps)+cos(2*pi*f2*temps));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Trac� avec une �chelle temporelle en secondes
%des labels sur les axes et un titre (utilisation de xlabel, ylabel et
%title)
figure
plot(temps, x);
grid
xlabel('Temps (s)')
ylabel('signal')
title(['Trac� d''une somme de cosinus num�rique de fr�quence ' num2str(f1) 'Hz et ' num2str(f2) 'Hz' ]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DE LA TRANSFORMEE DE FOURIER NUMERIQUE (TFD) DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sans zero padding 
X=fft(x);
%Avec zero padding (ZP : param�tre de zero padding � d�finir)
N2 = 4096;
X_ZP=fft(x, N2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU MODULE DE LA TFD DU COSINUS NUMERIQUE EN ECHELLE LOG
%SANS PUIS AVEC ZERO PADDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Avec une �chelle fr�quentielle en Hz
%des labels sur les axes et des titres
%Trac�s en utilisant plusieurs zones de la figure (utilisation de subplot) 
figure('name',['Trac� du module de la TFD d''une somme de cosinus num�rique de fr�quence '  num2str(f1) 'Hz et ' num2str(f2) 'Hz'])

subplot(2,1,1)
echelle_frequentielle=0:(Fe/N):(Fe/N)*(N-1);
semilogy(echelle_frequentielle, abs(X));
grid
title('Sans zero padding')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')

subplot(2,1,2)
echelle_frequentielle=0:(Fe/N2):(Fe/N2)*(N2-1);
semilogy(echelle_frequentielle, abs(X_ZP));
grid
title('Avec zero padding')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')

%Avec une �chelle fr�quentielle en Hz
%des labels sur les axes et des titres
%Trac�s superpos�s sur une m�me figure 
% (utilisation de hold, de couleurs diff�rentes et de legend)
% !! UTILISER ICI fftshit POUR LE TRACE !!
figure
echelle_frequentielle=(-Fe/2):(Fe/N):(Fe/(2*N))*(N-1);
semilogy(echelle_frequentielle, abs(fftshift(X)), 'b');    %Trac� en bleu : 'b'
hold on
echelle_frequentielle=(-Fe/2):(Fe/N2):(Fe/(2*N2))*(N2-1);
semilogy(echelle_frequentielle,abs(fftshift(X_ZP)), 'r'); %Trac� en rouge : 'r'
grid
legend('Sans zero padding','Avec zero padding')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')
title(['Trac� du module de la TFD d''une somme de cosinus num�rique de fr�quence '  num2str(f1) 'Hz et ' num2str(f2) 'Hz'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EXERCICE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
