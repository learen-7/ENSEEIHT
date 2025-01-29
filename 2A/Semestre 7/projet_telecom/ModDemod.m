clear all 
close all


%% Déclaration des paramètres 

% Paramètres
N = 188*10*8;              % Nombre d'échantillons
Te = 1;                % Temps échantillonages
Fe = 1/Te;             % Fréquence d'échantillonage
Ns = 5;                % Nombre de symboles
Ts = Ns*Te;            % Temps symboles
Rs = 1/Ts;             % Débit binaire 
alpha = 0.35;          % Roll off
span=6;                % Nombre des points filtre de mise en forme 
M = 4;                 % Ordre de modulation

% Facteur de suréchantillonage
Eb_N0_db=[-4:4];  % rapport signal sur bruit en dB
Eb_N0=10.^(Eb_N0_db/10);  % rapport signal sur bruit

%% Filtres
% Génération du filtre de mise en forme
h=rcosdesign(alpha,span,Ns);
% Filtre de réception 
hr=fliplr(h);

%% Retard    
retard=span*Ns/2;

%% Génération symboles
% Génération des bits
bits=randi([0 1],1,N);
% Mapping complexe
symboles = 1-2*bits(1:2:N) + 1i * (1-2*bits(2:2:N));
% Suréchantillonnage
Dirac=kron(symboles,[1 zeros(1,Ns-1)]);

%% Canal
% Filtrage de mise en forme 
xe=filter(h,1,[Dirac zeros(1,retard)]);
xe=xe(1+retard:end);

%% Construction de la chaine complète sans bruit

% Filtrage de réception du signal sans bruit
s_filtresb=filter(hr, 1, [xe zeros(1,retard)]);
s_filtresb=s_filtresb(1+retard:end);

% Echantillonnage 
s_ech=s_filtresb(1:Ns:end);
% Demapping
bits_recup=zeros(1,N);

bits_recup(1:2:N)=real(s_ech)<0;
bits_recup(2:2:N)=imag(s_ech)<0;

TEB_Sans_Canal=length(find(bits_recup~=bits))/N;
fprintf("TEB sans canal %f \n",TEB_Sans_Canal);

%% Construction de la chaine complète avec bruit

% Initialisation du TEB
TEB=zeros(1, length(Eb_N0_db));
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
    s_filtre=s_filtre(1+retard:end);
    % Echantillonnage 
    s_ech=s_filtre(1:Ns:end);
    % Demapping
    bits_recup=zeros(1,N);
    bits_recup(1:2:N)=real(s_ech)<0;
    bits_recup(2:2:N)=imag(s_ech)<0;
    TEB(i)=sum(bits ~= bits_recup)/N;
end

% Traçage de la TEB
figure();
TEB_theorique = qfunc(sqrt(2*Eb_N0));
semilogy(Eb_N0_db, TEB, 'b');
hold on;
semilogy(Eb_N0_db, TEB_theorique, 'r');
grid on;
legend('Simulé','Theorique');
ylabel('TEB');
xlabel('E_b/N_0  (dB)');
title("TEB de la chaine passe-bas équivalente");


