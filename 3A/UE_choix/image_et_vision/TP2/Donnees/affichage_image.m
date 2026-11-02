% Fonction permettant d'afficher les images 
% ENTREES
% Im : Image
% message : le titre de la figure
% l, c, numero : le nombre de lignes et colonnes de la figure et le numero
% dans la sous-figure
% SORTIE : la figure
function [] = affichage_image(Im,message,l,c,numero)
  subplot(l,c,numero);
  colormap(gray);
  imshow(Im); 
  title(message);
end