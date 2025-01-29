clear all 
close all

%% Déclaration des paramètres 

% Paramétres
N = 188*10*8;             % Nombre d'échantillons
Ns = 5;                % Nombre de symboles
alpha = 0.35;          % Roll off
span=6;                % Nombre des points filtre de mise en forme 
M = 4;                 % Ordre de modulation

% Facteur de suréchantillonage
Eb_N0_db=[-4:4];%rapport signal sur bruit en dB
Eb_N0=10.^(Eb_N0_db/10);%rapport signal sur bruit

% Génération des symboles
bits=randi([0 1],1,N);

% Filtres
% Génération du filtre de mise en forme
h=rcosdesign(alpha,span,Ns);
% Filtre de réception 
hr=fliplr(h);

% Retard
retard=span*Ns/2;

%codage canal
trellis = poly2trellis(7, [171 133]);
codeout = convenc(bits,trellis);

commcnv_plotnextstates(trellis.nextStates);

% Mapping complexe
symboles = 1-2*codeout(1:2:N*2) + 1i * (1-2*codeout(2:2:N*2));

% Suréchantillonnage
Dirac=kron(symboles,[1 zeros(1,Ns-1)]);
% Filtrage de mise en forme 
xe=filter(h,1,[Dirac zeros(1,retard)]);


%% Construction de la chaine complète avec bruit

% Initialisation du TEB
TEB_hard=zeros(1, length(Eb_N0_db));
TEB_soft=zeros(1, length(Eb_N0_db));
for i=1:length(Eb_N0_db)
    % Calcul de la puissance du signal transmis
    P_signal=mean(abs(xe).^2);
    % Calcul de la puissance du bruit à introduire
    P_bruit=(P_signal*Ns)/(2*log2(M)*Eb_N0(i));
    % Génération du bruit
    bruit=(sqrt(P_bruit)*randn(1,length(xe)))*1;
    bruit = bruit + (sqrt(P_bruit)*randn(1,length(xe)))*1i;
    % Ajout du bruit
    signal_bruite=xe+bruit;
    % Filtrage du signal avec bruit
    s_filtre=filter(hr, 1, [signal_bruite zeros(1,retard)]);
    %s_filtre=s_filtre(1+retard:end);
    % Echantillonnage 
    s_ech=s_filtre(length(h):Ns:length(s_filtre)-1);
    
    % Demapping
    bits_recup_soft(1:2:N*2)=real(s_ech);
    bits_recup_soft(2:2:N*2)=imag(s_ech);


    bits_recup(1:2:N*2)=real(s_ech)<0;
    bits_recup(2:2:N*2)=imag(s_ech)<0;
    %décodage 
    decodeout=vitdec(bits_recup,trellis,5*(7-1),'trunc','hard');
    %décode unquant
    decodeunquant=vitdec(bits_recup_soft,trellis,5*(7-1),'trunc','unquant');
    %TEB
    TEB_hard(i)=mean(bits ~= decodeout);
    TEB_soft(i)=mean(bits ~= decodeunquant);

end

% Traçage de la TEB
figure();
TEB_theorique = qfunc(sqrt(2*Eb_N0));
semilogy(Eb_N0_db, TEB_hard, 'g');
hold on;
semilogy(Eb_N0_db, TEB_soft, 'b');
hold on;
semilogy(Eb_N0_db, TEB_theorique, 'r');
grid on;
legend('Simulé-hard','Simulé-soft','Theorique');
ylabel('TEB');
xlabel('E_b/N_0  (dB)');
title("TEB de la chaine passe-bas équivalente");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Précision TEB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear bits_recup;

sum_TEB=0;
EbN0dB = 10;
EbN0 = 10*log10(EbN0dB);
k=0;
max_while = 100000;
while (sum_TEB<4) && (k<max_while)

    k=k+1;
    %% modulateur :
    % Mapping complexe
    symboles = 1-2*bits(1:2:N) + 1i * (1-2*bits(2:2:N));
    
    % Suréchantillonnage
    Dirac=kron(symboles,[1 zeros(1,Ns-1)]);
    % Filtrage de mise en forme 
    xe=filter(h,1,[Dirac zeros(1,retard)]);

    % Calcul de la puissance du signal transmis
    P_signal=mean(abs(xe).^2);
    % Calcul de la puissance du bruit à introduire
    P_bruit=(P_signal*Ns)/(2*log2(M)*Eb_N0(i));
    % Génération du bruit
    bruit=(sqrt(P_bruit)*randn(1,length(xe)))*1;
    bruit = bruit + (sqrt(P_bruit)*randn(1,length(xe)))*1i;
    % Ajout du bruit
    signal_bruite=xe+bruit;
    % Filtrage du signal avec bruit
    s_filtre=filter(hr, 1, [signal_bruite zeros(1,retard)]);
    %s_filtre=s_filtre(1+retard:end);
    % Echantillonnage 
    s_ech=s_filtre(length(h):Ns:length(s_filtre)-1);

    bits_recup(1:2:N)=real(s_ech)<0;
    bits_recup(2:2:N)=imag(s_ech)<0;

    sum_TEB = sum_TEB+sum(bits ~= bits_recup);
end

prec = (1/sum_TEB)^0.5;
TEB_precis = sum_TEB/(k*10000)


