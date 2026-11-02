function plot_points(XY,NbPoints,motif);
% Affichage de points numerotes sur une image. 
% Cet affichage est superpose a la fenetre courante. 
% I-> vecteur colonne des numeros de lignes des points
% J-> vecteur colonne des numeros de colonnes des points
% NbPoints -> nombre de points a afficher
%             si ce parametre est absent, tous les points seront affiches
% motif -> motif utilise pour l'affichage

if nargin < 3, NbPoints=length(I); end;

hold on;
for p=1:NbPoints
 plot(XY(p,1),XY(p,2),motif,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',10);
end
hold off;
