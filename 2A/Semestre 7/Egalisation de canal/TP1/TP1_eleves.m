
% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;

%% Simulation parameters
% On d�crit ci-apr�s les param�tres g�n�raux de la simulation

%Frame length
M=4; %2:BPSK, 4: QPSK
N  = 1000000; % Number of transmitted bits or symbols
Es_N0_dB = [0:30]; % Eb/N0 values
%Multipath channel parameters
%hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
a=1.2;
hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps

%Preallocations
nErr_zfinf=zeros(1,length(Es_N0_dB));
nErr_zf_fir = zeros(1,length(Es_N0_dB));
nErr_mmse_fir = zeros(1,length(Es_N0_dB));
nErr_mmseinf = zeros(1,length(Es_N0_dB));
nErr = zeros(1,length(Es_N0_dB));
for ii = 1:length(Es_N0_dB)

   % BPSK symbol generations
%    bits = rand(1,N)>0.5; % generating 0,1 with equal probability
%    s = 1-2*bits; % BPSK modulation following: {0 -> +1; 1 -> -1} 
   
    % QPSK symbol generations
   bits = rand(2,N)>0.5; % generating 0,1 with equal probability
   s = 1/sqrt(2)*((1-2*bits(1,:))+1j*(1-2*bits(2,:))); % QPSK modulation following the BPSK rule for each quadatrure component: {0 -> +1; 1 -> -1} 
   sigs2=var(s);
   
   % Channel convolution: equivalent symbol based representation
   z = conv(hc,s);  
   
   %Generating noise
   sig2b=10^(-Es_N0_dB(ii)/10);
   %n = sqrt(sig2b)*randn(1,N+Lc-1); % white gaussian noise, BPSK Case
    n = sqrt(sig2b/2)*randn(1,N+Lc-1)+1j*sqrt(sig2b/2)*randn(1,N+Lc-1); % white gaussian noise, QPSK case
   
   % Adding Noise
   y = z + n; % additive white gaussian noise

   bhat = zeros(2,length(bits));
   bhat(1,:)= real(y(1:N)) < 0;
   bhat(2,:)= imag(y(1:N)) < 0;
   nErr(1,ii) = size(find([bits(:)- bhat(:)]),1);

    
   %% zero forcing equalization
   % We now study ZF equalization
   
   %Unconstrained ZF equalization, only if stable inverse filtering
   
   
   %%
   % 
   %  The unconstrained ZF equalizer, when existing is given by 
   % 
   % $w_{,\infty,zf}=\frac{1}{h(z)}$
   % 
   %%
   % 
   
    s_zf=filter(1,hc,y);%if stable causal filter is existing
    s_zf_sans_bruit = filter(1,hc,z);
    bhat_zf = zeros(2,length(bits));
    bhat_zf(1,:)= real(s_zf(1:N)) < 0;
    bhat_zf(2,:)= imag(s_zf(1:N)) < 0;
    nErr_zfinfdirectimp(1,ii) = size(find([bits(:)- bhat_zf(:)]),1);
    %Otherwise, to handle the non causal case
    Nzf=200;
    [r, p, k]=residuez(1, hc);
    [w_zfinf]=ComputeRI( Nzf, r, p, k );
    s_zf=conv(w_zfinf,y);
    bhat_zf = zeros(2,length(bits));
    bhat_zf(1,:)= real(s_zf(Nzf:N+Nzf-1)) < 0;
    bhat_zf(2,:)= imag(s_zf(Nzf:N+Nzf-1)) < 0;
    
    nErr_zfinf(1,ii) = size(find([bits(:)- bhat_zf(:)]),1);
    %bias_zf(1, ii) = mean(bhat_zf - bits, "all");
    
    %% mmse
    deltac= zeros( 1 , 2 * Lc - 1 ) ;
    deltac(Lc) = 1 ;
    Nmmse = 200;%causal part
    [r, p, k] = residuez(fliplr(conj(hc)),(conv(hc,fliplr(conj(hc)))+(sig2b/sigs2)*deltac));
    [w_mmseinf] = ComputeRI(Nmmse,r,p,k);

    s_mmse=conv(w_mmseinf,y);
    

    bhat_mmse = zeros(2,length(bits));
    bhat_mmse(1,:)= real(s_mmse(Nzf:N+Nzf-1)) < 0;
    bhat_mmse(2,:)= imag(s_mmse(Nzf:N+Nzf-1)) < 0;
    
    nErr_mmseinf(1,ii) = size(find([bits(:)- bhat_mmse(:)]),1);

    %bias_mmse(1, ii) = mean(bhat_mmse - bits, "all");
    
    %% zf rif
    Nw=10;
    d = 5;
    H = toeplitz([hc(1) zeros(1,Nw-1)]',[hc, zeros(1,Nw-1)]);
    Ry = (conj(H)*H.');
    p = zeros(Nw+Lc-1,1);

    P= (H.'*inv((Ry))*conj(H));
    [alpha,dopt]=max(diag(abs(P)));
    %p(d+1))=1
    p(dopt)=2;
    Gamma = conj(H)*p;
    w_zf_fir = (inv(Ry)*Gamma).';

    sig_e_opt = sigs2 -conj(w_zf_fir)*Gamma;
    bias_zf(1, ii) = 1-sig_e_opt/sigs2;
    shat = conv(w_zf_fir,y);
    shat = shat(dopt:end);

    bHat = zeros(2,length(bits));
    bHat(1,:)=real(shat(1:N))<0;
    bHat(2,:)=imag(shat(1:N))<0;

    nErr_zf_fir(1,ii) = size(find([bits(:)- bHat(:)]),1);

    %% MMSE rif
    Nw=10;
    d = 5;
    H = toeplitz([hc(1) zeros(1,Nw-1)]',[hc, zeros(1,Nw-1)]);
    Ry = sigs2*(conj(H)*H.')+sig2b*eye(Nw);
    p = zeros(Nw+Lc-1,1);

    P=1/sigs2*(H.'*inv((Ry/sigs2))*conj(H));
    [alpha,dopt]=max(diag(abs(P)));
    %p(d+1) = 1;
    p(dopt) = 1;
    Gamma = sigs2*conj(H)*p;
    w_mmse_fir = (inv(Ry)*Gamma).';

    sig_e_opt = sigs2 -conj(w_mmse_fir)*Gamma;
    bias_mmse(1,ii) = 1-sig_e_opt/sigs2;
    shat = conv(w_mmse_fir,y);
    shat = shat(dopt:end);

    bHat = zeros(2,length(bits));
    bHat(1,:)=real(shat(1:N))<0;
    bHat(2,:)=imag(shat(1:N))<0;

    nErr_mmse_fir(1,ii) = size(find([bits(:)- bHat(:)]),1);




end

%DSP
dspEmisAvecBruit=pwelch(y);
dspEmisSansBruit=pwelch(z);
dspRecepAvecBruit=pwelch(s_zf);
%dspRecepSansBruit=pwelch(s_zf_sans_bruit);

%s_zf_sans_bruit = filter(1, hc, z);
%dspRecepSansBruit=pwelch(s_zf_sans_bruit);
simBer = nErr/N/log2(M);

simBer_zfinf = nErr_zfinf/N/log2(M); % simulated ber

simBer_mmseinf = nErr_mmseinf/N/log2(M); % simulated ber

simBer_zffir= nErr_zf_fir/N/log2(M); % simulated ber

simBer_mmsefir = nErr_mmse_fir/N/log2(M); % simulated ber
% plot

figure
semilogy(Es_N0_dB,simBer_zffir(1,:),'m*-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_mmsefir(1,:),'y*-','Linewidth',2);

hold on
semilogy(Es_N0_dB,simBer_zfinf(1,:),'rs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_mmseinf(1,:),'gs-','Linewidth',2);

grid on
legend('sim-zf-fir','sim-mmse-fir','sim-zf-inf','sim-mmse-inf');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for 4QAM in ISI with ZF and MMSE equalizers')


figure
plot(Es_N0_dB,bias_zf(1,:),'rs-','Linewidth',2);
hold on
plot(Es_N0_dB,bias_mmse(1,:),'gs-','Linewidth',2);
grid on
legend('sim-zf-fir','sim-mmse-fir');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Bias')


figure
title('Impulse response')
stem(real(w_zfinf))
stem(real(w_mmseinf))
hold on
stem(real(w_zfinf),'r-')
stem(real(w_mmseinf), 'b-')
legend('mmse','zf');
ylabel('Amplitude');
xlabel('time index')

% figure
% subplot(1, 2, 1)
% plot(10*log(dspRecepSansBruit))
% title("DSP � la reception sans bruit")
% 
% 
% subplot(1, 2, 2)
% plot(10*log(dspRecepAvecBruit))
% title("DSP � la reception avec bruit")

figure
 scatter(real(s_zf), imag(s_zf))
 grid on
 title('4QAM constellation')
 xlabel('Real')
 ylabel('Imaginary')






