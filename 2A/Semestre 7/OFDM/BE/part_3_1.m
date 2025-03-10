clear all;
close all;

%% paramètres 
N = 16;
N_actif = 16;
nb_bits = 1000;

%% réponse impulsionelle 
h = [0.407,0.815,0.407];

%% tracé du module et de la phase de la réponse en fréquence du canal de propagation.
freqz(h,1,1024,16,'whole')
title('Réponse en fréquence du canal de propagation');
grid on;


 %% modulateur 

    % Mapping
    S=zeros(N, nb_bits);
    for i=1:N_actif
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end 

    %% Canal
    Xe = ifft(S,N);
    Y = reshape(Xe, 1, nb_bits*N);

    %filtre 
    SignalSortieCanal=filter(h,1,Y) ;

    %dsp
    [dsp,f] = pwelch(SignalSortieCanal,[],[],[],16,'twosided');
    
    %% affichage DSP
    figure('Name','DSP')
    nexttile
    plot(f,10*log(dsp))
    title('DSP')
    xlabel('Fréquence (Hz)')
    ylabel('Puissance')

 %% Démodulation 

     %démodulation
     Y_reshape = reshape(SignalSortieCanal, size(Xe));
     Y_recep = fft(Y_reshape,N);
        
%% Constellation porteuse 6 et 15
 porteuse6 = Y_recep(6, :);
 porteuse15 = Y_recep(15, :);


 figure
 scatter(real(porteuse6), imag(porteuse6))
 title('Constellation obtenue sur la porteuse 6')
 xlabel('Partie réel')
 ylabel('Partie imaginaire')


 figure
 scatter(real(porteuse15), imag(porteuse15))
 title('Constellation obtenue sur la porteuse 15')
 xlabel('Partie réel')
 ylabel('Partie imaginaire')
 


 %% TEB
 Y_recep(Y_recep<0) = -1;
 Y_recep(Y_recep>0) = 1;

 TEB = mean(S~=Y_recep, "all")