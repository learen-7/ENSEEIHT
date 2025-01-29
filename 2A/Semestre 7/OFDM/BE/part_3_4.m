clear all;
close all;


%% paramètres
N = 16;
N_actif = 16;
nb_bits = 1000;
taille_prefixe = 2;

% réponse impulsionelle 
h = [0.407,0.815,0.407];
% réponse en fréquence
Ck = fft(h,16);
M_Ck = repmat(Ck(:),1, 1000);


 %% modulateur 
    % Mapping
    S=zeros(N, nb_bits);
    for i=1:N_actif
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end 

    %% Canal
    Xe = ifft(S,N);

    %intervalle de garde
    C = Xe(end-(taille_prefixe-1):end, :);
    Xe = [C; Xe];

    Y = reshape(Xe, 1, nb_bits*(N+taille_prefixe)); 


    %filtre 
    SignalSortieCanal=filter(h,1,Y) ;

 %% Démodulation 
 %démodulation
 Y_reshape = reshape(SignalSortieCanal, size(Xe));
 SignalSortieSansInter=Y_reshape(taille_prefixe+1:end, :);
 Y_recep = fft(SignalSortieSansInter,N);

 %% Egalisation
 %ZFE
     Y_zfe = (1./M_Ck).*Y_recep;
        
     % Constellation porteuse 6 et 15
     porteuse6_zfe = Y_zfe(6, :);
     porteuse15_zfe = Y_zfe(15, :);


     figure
     scatter(real(porteuse6_zfe), imag(porteuse6_zfe))
     title('Constellation obtenue sur la porteuse 6 : ZFE')
     xlabel('Partie réel')
     ylabel('Partie imaginaire')


     figure
     scatter(real(porteuse15_zfe), imag(porteuse15_zfe))
     title('Constellation obtenue sur la porteuse 15 : ZFE')
     xlabel('Partie réel')
     ylabel('Partie imaginaire')  
% ML
    Y_ml = conj(M_Ck).*Y_recep;

     % Constellation porteuse 6 et 15 
     porteuse6_ml = Y_ml(6, :);
     porteuse15_ml = Y_ml(15, :);


     figure
     scatter(real(porteuse6_ml), imag(porteuse6_ml))
     title('Constellation obtenue sur la porteuse 6 : ML')
     xlabel('Partie réel')
     ylabel('Partie imaginaire')


     figure
     scatter(real(porteuse15_ml), imag(porteuse15_ml))
     title('Constellation obtenue sur la porteuse 15 : ML')
     xlabel('Partie réel')
     ylabel('Partie imaginaire')
    


 %% TEB
 Y_zfe(Y_zfe<0) = -1;
 Y_zfe(Y_zfe>0) = 1;

 TEB_zfe = mean(S~=Y_zfe, "all")

 Y_ml(Y_ml<0) = -1;
 Y_ml(Y_ml>0) = 1;

 TEB_ml = mean(S~=Y_ml, "all")