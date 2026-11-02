% Fonction permettant d'afficher les images 
% avec les points d'interet numerotes
% Les points portant le meme numero sont les correspondants
% ENTREES
% Im : Image
% mesurex1,mesurey1 : les points à afficher
% message : le titre de la figure
% l, c, numero : le nombre de lignes et colonnes de la figure et le numero
% dans la sous-figure
% SORTIE : la figure
function [] = affichage_appariement(Im,mesurex1,mesurey1,message,l,c,numero)
% Affichage de l'image
subplot(l,c,numero);
imshow(uint8(Im));
% Affichage des points
hold on;
plot(mesurex1,mesurey1,'r.','MarkerSize',15)
% Affichage des numeros
for i=1:size(mesurex1,1)
    if (i<10) 
        text(mesurex1(i)-15,mesurey1(i),num2str(i),'Color','g','FontSize',12)
    else
        text(mesurex1(i)-30,mesurey1(i),num2str(i),'Color','g','FontSize',12)           
    end
end
hold off;

end