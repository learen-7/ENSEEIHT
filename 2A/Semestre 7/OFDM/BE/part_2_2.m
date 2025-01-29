clear all;
close all;

%% paramètres
N = 16;
port_active = 16;
nb_bits = 1000;

S=zeros(N, nb_bits);
%% modulateur 

    % Mapping
    for i=1:port_active
        S(i,:) = randi([0 1],1,nb_bits)*2 -1;
    end
    

    % filtrage
    Xe = ifft(S,N);
    Y = reshape(Xe, 1, []);

    Ybis = reshape(Y, 16, []);
    Ye = fft(Ybis, N);

TEB = mean(round(Ye)~=S, "all")