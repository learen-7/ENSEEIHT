%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fonction renvoyant les niveaux de gris du voisinage de chaque point en ligne

function voisins = voisinage(I,xyPt,TailleFenetre)
% ENTREES
% I    : l'image
% xyPt : les coordonnees des points dont nous cherchons le voisinage. 
%        ATTENTION : on fait l'hypothese qu'il n'y a aucun point sur les bords
% TailleFenetre    : La taille de la fenêtre de correlation correspond 
%                    a TailleFenetre x TailleFenetre
% SORTIE
% voisins : une matrice contenant pour chaque ligne (= chaque point),
%           le voisinage du point associe
% Nombre de points pour lesquels leur voisinage est cherche
npt = size(xyPt,1); 

% Initialisation
voisins = zeros(npt,TailleFenetre*TailleFenetre);

% Calcul de la demi-fenetre de correlation
K = floor(TailleFenetre/2);

for i=1:npt
    x = xyPt(i, 2);
    y = xyPt(i, 1);
    v = I(x-K:x+K,y-K:y+K);
    voisins(i,:) = v(:);
end



