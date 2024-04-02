clear;
close all;
clc;

% Parametres pour l'affichage des donnees :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

%--------------------------------------------------------------------------
% Calcul des parametres du SVM sur les donnees d'apprentissage
%--------------------------------------------------------------------------

% Donnees non filtrees :
load donnees_carac;
X_app = X_app(:,1:2);
X_test = X_test(:,1:2);
Y_app(Y_app == 2) = -1; % Changement du label pour utiliser le SVM
Y_test(Y_test == 2) = -1; % Changement du label pour utiliser le SVM
nb_donnees_app = size(X_app,1);
nb_donnees_test = size(X_test,1);

% Estimation du SVM avec marge souple :
nb_classes = 2;
vecteur_lambda = 80:10:3000; % Hyperparametre de regularisation

% Recherche du parametre lambda optimal :
[pourcentage_meilleur_classification_SVM_test, lambda_opt_test, ...
 vecteur_pourcentages_bonnes_classifications_SVM_app, ...
 vecteur_pourcentages_bonnes_classifications_SVM_test] = ...
 maximisation_classification_SVM_marge(X_app,Y_app,X_test,Y_test,vecteur_lambda); % FONCTION A CODER

%--------------------------------------------------------------------------
% Affichage des courbes d'optimisation du parametre lambda
%--------------------------------------------------------------------------

figure('Name','Classification par SVM avec marge souple (optimisation)',...
       'Position',[0.1*L,0.1*H,0.8*L,0.7*H],...
       'Color',[0.7 0.75 0.85]);
    plot(vecteur_lambda,vecteur_pourcentages_bonnes_classifications_SVM_app,'LineWidth',2)
    hold on
    plot(vecteur_lambda,vecteur_pourcentages_bonnes_classifications_SVM_test,'LineWidth',2)
    plot(lambda_opt_test,pourcentage_meilleur_classification_SVM_test,'m+','MarkerSize',10,'LineWidth',3);
    xlim([vecteur_lambda(1) vecteur_lambda(end)])
    ylim([80 100])
    grid on
    
    title(['Maximum de classification des donnees de test = ' ...
           num2str(pourcentage_meilleur_classification_SVM_test,'%.1f') '% ' ...
           'pour \lambda^* = ' num2str(lambda_opt_test,'%d')])
    xlabel('\lambda')
    ylabel('% de bonnes classifications')
    legend('Apprentissage','Test','\lambda^*')
    set(gca,'FontSize',12)
   
save hyperparametre_exercice_3 lambda_opt_test;
