clear all;
close all;

%% paramètres
N = 16;
port_active = 4;
nb_bits = 1000;

S=zeros(N, nb_bits);

%% modulateur 
    % Mapping
    for i=1:port_active
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end

    for i=N-port_active:N
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end
    
    % filtrage
    Xe = ifft(S,N);
    Y = reshape(Xe, 1, []);

%dsp
dsp = pwelch(Y,[],[],[],N,'center');

%% affichage
figure('Name','dsp')
nexttile
plot(10*log(dsp))
title('DSP')
xlabel('Fréquence (Hz)')
ylabel('Puissance')