function [XY_C1,XY_C2] = apparier_POI(Im1,XY_1,Im2,XY_2,TailleFenetre,seuil)
% apparierPOI apparie les points d'interet stockes dans XY_1 et XY_2 entre
% les images Im1 et Im2 avec une fenetre de correlation de taille
% TailleFenetre
% seuil correspond au seuil utilise pour eliminer les erreurs d'appariement
% XY_C1 et XY_C2 sont les coordonnees des points de l'image 1 
% apparies avec les points XY_C2 de l'image 2

% Nombre de points a mettre en correspondance
NbPoints=size(XY_1,1);

% Calcul de ZNCC
C = apparier_Points(Im1,XY_1,Im2,XY_2,TailleFenetre);
C = abs(C);

% Recherche par methode WTA (Winner Takes All)
% Indices des maxima sur les lignes
[maxI1 ind1_2] = max(C');
ind1_2 = ind1_2(:);

% Indices des maxima sur les colonnes
[maxI2 ind2_1] = max(C);
ind2_1 = ind2_1(:);

% Verification de la contrainte de symetrie 
% + seuillage du score de correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE A MODIFIER AFIN D'APPLIQUER SYMETRIE ET SEUILLAGE %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cette premiere ligne doit etre modifiee pour appliquer les contraintes souhaitees % 
ind1=find(ind2_1(ind1_2) == (1:NbPoints)' & (maxI1(:) > seuil)); % j'ai utilisé l'IAg pour trouver comment valider la contrainte de symétrie

% Cette deuxieme doit etre gardee telle quelle
ind2 = ind1_2(ind1);

% Affichage des appariements
mesurex1 = XY_1(ind1,1);
mesurey1 = XY_1(ind1,2);
mesurex2 = XY_2(ind2,1);
mesurey2 = XY_2(ind2,2);

figure;
affichage_appariement(Im1,mesurex1,mesurey1,'Points d''interet Image 1',1,2,1);
affichage_appariement(Im2,mesurex2,mesurey2,'Points d''interet correspondants Image 2',1,2,2);

XY_C1 = [mesurex1(:) mesurey1(:)];
XY_C2 = [mesurex2(:) mesurey2(:)];
end

