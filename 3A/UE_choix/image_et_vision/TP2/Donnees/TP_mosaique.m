clear all;
close all;

Im1 = imread('cancale1.pgm');
Im2 = imread('cancale3.pgm');

Im1_coul = imread('cancale1.jpg');
Im2_coul = imread('cancale3.jpg');

% Affichage des deux premières images en niveaux de gris
figure;
affichage_image(Im1,'Image 1',1,2,1);
affichage_image(Im2,'Image 2',1,2,2);

% Choix des parametres
TailleFenetre = 15;
NbPoints = 100 ;
k = 0.05;
seuil = 0.85;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detection des points d'interet avec Harris %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER POUR OBSERVER LA DETECTION DE HARRIS
[XY_1,Res_1] = harris(Im1,TailleFenetre,NbPoints,k);
[XY_2,Res_2] = harris(Im2,TailleFenetre,NbPoints,k);
figure;
affichage_POI(Im1,XY_1,'POI Image 1',1,2,1);
affichage_POI(Im2,XY_2,'POI Image 2',1,2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Appariement des points d'interet %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER POUR OBSERVER LA MISE EN CORRESPONDANCE 
% avec/sans verification des contraintes
 [XY_C1,XY_C2] = apparier_POI(Im1,XY_1,Im2,XY_2,TailleFenetre,seuil);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation (et verification) de l'homographie %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER QUAND HOMOGRAPHIE AURA ETE COMPLETEE
H = homographie(XY_C1,XY_C2)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul de la mosaique %
%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER QUAND HOMOGRAPHIE AURA ETE VALIDEE
Imos = mosaique(Im1,Im2,H);
 figure; 
affichage_image(uint8(Imos),'Mosaique obtenue a partir des 2 images initiales',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES
imwrite(uint8(Imos),'mosaique2.pgm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2 pour la reconstruction                %
% A DECOMMENTER QUAND MOSAIQUEBIS AURA ETE ECRITE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imosbis = mosaiquebis(Im1,Im2,H);
% figure; 
% affichage_image(uint8(Imosbis),'Mosaique obtenue a partir des 2 images initiales (version 2)',1,1,1);
% SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES VERSION 2
% imwrite(uint8(Imosbis),'mosaique2_bis.pgm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 3 pour la reconstruction avec les couleurs R, G et B %
% A DECOMMENTER QUAND MOSAIQUECOUL AURA ETE ECRITE             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imoscoul = mosaiquecoul(Im1_coul,Im2_coul,H);
% figure;
% affichage_image(uint8(Imoscoul),'Mosaique obtenue a partir des 2 images couleur initiales (version 2)',1,1,1);
% SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2
% imwrite(uint8(Imoscoul),'mosaique2_coul.pgm');

