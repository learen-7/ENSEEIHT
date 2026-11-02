% Fonction calculant pour chaque appariement de points possible
% ZNCC (Zero-mean Normalized Cross Correlation) definie par :
%                     (P1-/P1).(P2-/P2)            Cov(P1,P2)
%       ZNCC(P1,P2) = --------------------- = -----------------------
%                     ||P1 - /P1||||P2-/P2||   sqrt(Var(P1)*Var(P2)) 
%  * P1 = l'ensemble des niveaux de gris du voisinage du point p1=(p1x,p1y)
%    sur l'image I1
%  * P2 = l'ensemble des niveaux de gris du voisinage du point p2=(p2x,p2y) 
%    sur l'image I2
%  * Cov(P1,P2) = E[(P1-E[P1])*(P2-E[P2])]
%               = Sum_{i=-k}^k Sum_{j=-k}^k  (I1(p1x+i,p1y+j)-E[P1])
%                                           *(I2(p2x+i,p2y+j)-E[P2])/(2*k+1)^2
%  * E[P1] = esperance de P1
%          = Sum_{i=-k}^k  Sum_{j=-k}^k I1(p1x+i,p1y+j)/(2*k+1)^2,
%  * E[P2] = esperance de P2
%          = Sum_{i=-k}^k  Sum_{j=-k}^k I2(p2x+i,p2y+j)/(2*k+1)^2,
%  * Var(P1) = variance de P1
%            = Sum_{i=-k}^k  Sum_{j=-k}^k (I1(p1x+i,p1y+j)-E[P1])^2/(2*k+1)^2
%
%  * Var(P2) = variance de P2
function C = apparier_Points(I1,Ptint1,I2,Ptint2,K) 
% I1, I2 : les deux images
% Ptint1, Ptint2 : les coordonnees des points detectes sur l'image 1, resp. 2
% C : matrice contenant, pour chaque paire de points (en ligne : les points 
%     de l'image 1, en colonne : les points de l'image 2), la valeur de la 
%     mesure de correlation pour ces paires de points
% K : Taille de la fenetre de correlation utilisee

% Dimensions des images
[htI1 lgI1] = size(I1); [htI2 lgI2] = size(I2);
% Nombres de points d'interet de l'image 1 et de l'image 2
nptI1 = size(Ptint1,1); nptI2 = size(Ptint2,1);
% Construction de la matrice des mesures de correlation
% Suppression de tous les points pour lesquels la fenêtre de corrélation
% n'est pas appliquable
C = zeros(nptI1,nptI2);

% Determination des points dont le voisinage est dans l'image
indptI1 = find(  Ptint1(:,1)-K>=1 & Ptint1(:,1)+K<=lgI1 ... 
               & Ptint1(:,2)-K>=1 & Ptint1(:,2)+K<=htI1);   
indptI2 = find(  Ptint2(:,1)-K>=1 & Ptint2(:,1)+K<=lgI2 ...
               & Ptint2(:,2)-K>=1 & Ptint2(:,2)+K<=htI2);
nbptintI1 = size(indptI1,1); nbptintI2 = size(indptI2,1);

% Determination du voisinage : vois1, vois2 matrices composees 
% pour chaque ligne des niveaux de gris du voisinage du point
% Appel a la fonction voisinage
vois1 = voisinage(I1, Ptint1(indptI1, :), K);
vois2 = voisinage(I2, Ptint2(indptI2, :), K);



% Nb Pixels par fenetre de correlation
NbPix = K*K;
% Calcul de tous les appariements possibles
[i1 i2] = meshgrid(1:nbptintI1,1:nbptintI2); 
i1 = i1(:); i2 = i2(:);

% Pour les images I1 et I2
% Moyenne des niveaux de gris du voisinage de chaque point
% Utilisation de mean
mean1 = mean(vois1, 2);
mean2 = mean(vois2, 2);

% Variance des niveaux de gris du voisinage de chaque point
% Utilisation de var
var1 = var(vois1, 0, 2);
var2 = var(vois2, 0, 2);

% Pour chaque combinaison de paires de points, la covariance 
% entre les deux voisinages : le numerateur dans la formule ZNCC
cov = mean((vois1(i1,:) - mean1(i1)) .* (vois2(i2, :) - mean2(i2)), 2);

% Calcul du score de correlation : 
% ajouter le denominateur dans la formule ZNCC 
% (le produit des variances)
cor = cov ./ sqrt(var1(i1) .* var2(i2));

% Affectation a la matrice C
C(indptI1(i1)+(indptI2(i2)-1)*nptI1) = cor';


