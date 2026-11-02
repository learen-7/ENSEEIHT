% Fonction permettant d'afficher les images avec les points d'interet
% detectes
% ENTREES
% Im : Image
% points : les points a afficher
% message : le titre de la figure
% l, c, numero : le nombre de lignes et colonnes de la figure et le numero
% dans la sous-figure
% SORTIE : la figure
function [] = affichage_POI(Im,points,message,l,c,numero)
% Affichage de l'image
subplot(l,c,numero);
colormap(gray);imshow(Im); hold on;
plot_points(points,length(points),'o'); 
title(message);
hold off; 
end
