% Estimation d'une matrice d'homographie H qui permet de passer d'une 
% image I1 a une autre image I2 a partir de paires de points (homologues) 
% 
% H = [ h11 h12 h13 ; h21 h22 h23 ; h31 h32 h33 ]
% H possede 8 parametres independants. 
% Chaque correspondance donne 2 equations. 
% Ainsi pour estimer H, il faut au moins 4 paires de points. 
%
% Il existe differentes manieres d'estimer H. 
% Nous choisissons la resolution sous la contrainte ||h33|| = 1, 
% au sens des moindres carres. 

function [H] = homographie(XY_C1,XY_C2)
% Entrees :
%
% XY_C1 : matrice (NbPointsx2) contenant les coordonnees des Nbpoints dans l'image I1
% XY_C2 : matrice (NbPointsx2) contenant les coordonnees des Nbpoints HOMOLOGUES dans l'image I2 
%	(colonne 1 : les x, colonne 2 : les y)
%
% Sortie :
% H : la matrice d'homographie estimee


% Les parametres hij de la matrice d'homographie H sont ranges dans 
% un vecteur : H = [ h11 ... h33 ]' tel que 
%           A * H = 0
% avec A qui depend des coordonnees de paires homologues, cf. equation (2)
% A = ( XY_C1(1,1) XY_C1(1,2) 1 0          0          0 -XY_C1(1,1)*XY_C2(1,1) -XY_C1(1,2)*XY_C2(1,1) -XY_C2(1,1) 
%       0          0          0 XY_C1(1,1) XY_C1(1,2) 1 -XY_C1(1,1)*XY_C2(1,2) -XY_C1(1,2)*XY_C2(1,2) -XY_C2(1,2)
%       ... etc ... )

% Stocker dans une variable le nombre de points apparies
nbPt = size(XY_C2, 1);

% Construction des matrices/vecteurs utiles pour construire la matrice A
% NE PAS UTILISER DE BOUCLE FOR
A = zeros(2 * nbPt, 9);
A(1:2:end, :) = [XY_C1(:,1) XY_C1(:,2) ones(nbPt, 1) zeros(nbPt,1) zeros(nbPt, 1) zeros(nbPt,1) -XY_C1(:,1).*XY_C2(:,1) -XY_C1(:,2).*XY_C2(:,1) -XY_C2(:,1)];
A(2:2:end, :) = [zeros(nbPt,1) zeros(nbPt,1) zeros(nbPt,1) XY_C1(:,1) XY_C1(:,2) ones(nbPt,1) -XY_C1(:,1).*XY_C2(:,2) -XY_C1(:,2).*XY_C2(:,2) -XY_C2(:,2)];


% Estimation des parametres de H par decomposition en valeurs singulieres
% Utiliser la fonction matlab svd : 
% H est le vecteur propre associee a la plus petite valeur propre de A^TA
[~, S, V] = svd(A, "vector");
minS = min(S);
H = V(:,S == minS);

% Former la matrice H de taille 3x3

H = reshape(H, [3, 3])';