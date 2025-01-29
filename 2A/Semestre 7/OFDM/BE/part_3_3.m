clear all;
close all;

%% paramètres 
N = 16;
N_actif = 16;
nb_bits = 1000;
taille_prefixe = 2;

% réponse impulsionelle 
h = [0.407,0.815,0.407];

%% modulateur 
    % Mapping
    S=zeros(N, nb_bits);
    for i=1:N_actif
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end 

    % Canal
    Xe = ifft(S,N);

    % préfixe cyclique
    CP = Xe(end-(taille_prefixe-1):end, :);
    Xe = [CP; Xe];

    Y = reshape(Xe, 1, nb_bits*(N+taille_prefixe)); 

    %filtre 
    SignalSortieCanal=filter(h,1,Y) ;

%% Démodulation 
     %démodulation
     Y_reshape = reshape(SignalSortieCanal, size(Xe));
     SignalSortieSansInter=Y_reshape(taille_prefixe+1:end, :);
     Y_recep = fft(SignalSortieSansInter,N);

    
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