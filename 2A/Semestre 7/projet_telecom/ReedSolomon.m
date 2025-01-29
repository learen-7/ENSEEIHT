clear all 
close all


%% Déclaration des paramètres 

% Paramètres
N = 188*10*8;              % Nombre d'échantillons 188 = MessageLenght / 204 = CodeWorthLegth / 8 = M =ceil(log2(204+1))
Te = 1;                % Temps échantillonages
Fe = 1/Te;             % Fréquence d'échantillonnage
Ns = 5;                % Nombre de symboles
Ts = Ns*Te;            % Temps symboles
Rs = 1/Ts;             % Débit binaire 
alpha = 0.35;          % Roll off
span=6;                % Nombre des points filtre de mise en forme 
M = 4;                 % Ordre de modulation

% Facteur de suréchantillonage
Eb_N0_db=[-4:4];%rapport signal sur bruit en dB
Eb_N0=10.^(Eb_N0_db/10);%rapport signal sur bruit

P = [1 1 0 1];

% Filtres
% Génération du filtre de mise en forme
h=rcosdesign(alpha,span,Ns);
% Filtre de réception 
hr=fliplr(h);

% Retard
retard=span*Ns/2;


%% Reed Solomon
RS_encode = comm.RSEncoder(204,188, BitInput=true);
RS_decode = comm.RSDecoder(204,188, BitInput=true);
RS_decode_Soft = comm.RSDecoder(204,188, BitInput=true);


%% Génération des symboles
bits=randi([0 1],1,N);
RS_bits = step(RS_encode,bits.').';

%codage canal
trellis = poly2trellis(7, [171 133]);
codeout = convenc(RS_bits,trellis,P);

commcnv_plotnextstates(trellis.nextStates);

% Mapping complexe
symboles = 1-2*codeout(1:2:length(RS_bits)*(3/2)) + 1i * (1-2*codeout(2:2:length(RS_bits)*(3/2)));

% Suréchantillonnage
Dirac=kron(symboles,[1 zeros(1,Ns-1)]);

% Filtrage de mise en forme 
xe=filter(h,1,[Dirac zeros(1,retard)]);
%xe=xe(1+retard:end);

%% Construction de la chaine complète avec bruit

% Initialisation du TEB
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
    bits_recup_soft(1:2:length(RS_bits)*(3/2))=real(s_ech);
    bits_recup_soft(2:2:length(RS_bits)*(3/2))=imag(s_ech);
   
    %décodage 
    decodeunquant=vitdec(bits_recup_soft,trellis,5*(7-1),'trunc','unquant', P);
    decode_soft_RS = step(RS_decode_Soft,decodeunquant.').';
   
    %TEB
    TEB_soft(i)=mean(bits ~= decode_soft_RS);

end

% Traçage de la TEB
figure();
TEB_theorique = qfunc(sqrt(2*Eb_N0));
semilogy(Eb_N0_db, TEB_soft, 'b');
hold on;
semilogy(Eb_N0_db, TEB_theorique, 'r');
grid on;
legend('Simulé-RS','Theorique');
ylabel('TEB');
xlabel('E_b/N_0  (dB)');
title("TEB de la chaine passe-bas équivalente");


