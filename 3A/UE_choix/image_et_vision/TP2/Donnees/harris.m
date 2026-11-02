function [XY,R]=harris(Im,TailleFenetre,NbPoints,k);
%[XY,Res]=harris(Im,TailleFenetre,NbPoints,k);
%
% Im -> image
% TailleFenetre -> taille (impaire) de la fenetre du voisinage
%                  valeurs conseillees : entre 9 et 25
% NbPoints -> nombre de points desires
% k -> poids utilise dans le calcul de la reponse R, k dans [0.04,0.06]
% XY -> Matrice de taille NbPointsx2 contenant 
%         respectivement les abscisses et les oordonnees des points 
%         d'interets extraits
%      ATTENTION : La fonction de Harris ne doit pas retourner des points sur les bords 
% R -> Image des reponses par le detecteur de Harris

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nota bene : les coordonnees utilisees sont x=j (numero de colonne) et y=i (numero de ligne). %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Verification et correction eventuelle des parametres donnes
if nargin < 4, k=0.05;      end;
if nargin < 3, NbPoints=50;      end;
if nargin < 2, TailleFenetre=9;  end;

% (1.1) Calcul des dérivées images suivant les lignes et les colonnes 
%       en utilisant la fonction gradient
Im = double(Im);
%%% A COMPLETER %%%
[Ii,Ij] = gradient(Im);

% (1.2) Calcul du filtre de lissage gaussien
% Calcul de sigma en fonction de la taille de la fenetre  
sig = (TailleFenetre - 1)/4;
% Utilisation de fspecial
%%% A COMPLETER %%%
L = fspecial("gaussian", TailleFenetre, sig) ;

% (1.3) Calcul de la reponse R
% Calcul des elements A, B et C puis calcul de la reponse suivant l'equation (1)
% Utiliser conv2 avec l'option 'same' pour appliquer le filtre de lissage L
%%% A COMPLETER %%%

A=conv2(Ii.*Ii,L, "same");
B=conv2(Ij.*Ij,L, "same");
C=conv2((Ii.*Ij),L,"same");
R=(A.*B - C.*C) - k*(A+B).*(A+B);

% (2.1) Suppression des non-maxima locaux suivant l'equation (2)
% ATTENTION : il faut gérer le cas particulier des bords
% 1) Il est impossible de calculer le maximum local car une partie du voisinage n'existe pas
% 2) Il faut leur attribuer la valeur minimale afin qu'il ne soit pas selectionne par la suite
%%% A COMPLETER %%%
n2=floor(TailleFenetre/2);
[l,c]=size(Im);
Res=zeros(l,c);

for i=(n2+1):(l-n2)
    for j=(n2+1):(c-n2)
        V=R(i-n2:i+n2, j-n2:j+n2);
        if R(i,j)==max(V(:)) 
            Res(i,j)=R(i,j);
        end
    end
end

% (2.2) Selection des NbPoints en fonction de "NbPoints" reponses les plus fortes
% Tri des reponses : utiliser sort en LINEARISANT Res au préalable
%%% A COMPLETER %%%
[s,is]=sort(Res(:), "descend");

% Selection des indices de NbPoints de plus fortes reponses
%%% A COMPLETER %%%
is= is(1:NbPoints);

% Calcul des indices dans l'image 
% Utiliser ind2sub, attention a l'ordre pour recuperer les coordonnees

[Y,X]= ind2sub(size(Res), is);


XY = [X,Y];
