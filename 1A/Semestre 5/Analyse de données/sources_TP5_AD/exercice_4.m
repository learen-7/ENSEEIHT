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

% Estimation du SVM avec noyau gaussien et marge souple :
nb_classes = 2;
vecteur_sigma = 0.002:0.0005:0.04; % Ecart-type du noyau gaussien
vecteur_lambda = 0.5:0.5:30; % Hyperparametre de regularisation

% Recherche des parametres sigma et lambda optimaux :
[pourcentage_meilleur_classification_SVM_test,sigma_opt_test,lambda_opt_test, ...
 matrice_pourcentages_bonnes_classifications_SVM_app, ...
 matrice_pourcentages_bonnes_classifications_SVM_test] = ...
 maximisation_classification_SVM_noyau_marge(X_app,Y_app,X_test,Y_test,vecteur_sigma,vecteur_lambda); % FONCTION A CODER

%--------------------------------------------------------------------------
% Affichage des images d'optimisation des parametres sigma et lambda
%--------------------------------------------------------------------------

pct_min = min([matrice_pourcentages_bonnes_classifications_SVM_app(:); ...
               matrice_pourcentages_bonnes_classifications_SVM_test(:)]);
pct_max = max([matrice_pourcentages_bonnes_classifications_SVM_app(:); ....
               matrice_pourcentages_bonnes_classifications_SVM_test(:)]);

figure('Name','Classification par SVM avec noyau gaussien et marge souple (optimisation)', ...
       'Position',[0.1*L,0.2*H,0.8*L,0.5*H],...
       'Color',[0.7 0.75 0.85]);

% Affichage des courbes de bonnes classifications en fonction de sigma et lambda
subplot 121
    imagesc(vecteur_sigma,vecteur_lambda,matrice_pourcentages_bonnes_classifications_SVM_app)
    axis xy
    xlim([vecteur_sigma(1) vecteur_sigma(end)])
    ylim([vecteur_lambda(1) vecteur_lambda(end)])
    clim([pct_min pct_max])
    colorbar
    
    title('Pourcentage de classification des donnees d''apprentissage')
    xlabel('$\sigma$','Interpreter','latex')
    ylabel('$\lambda$','Interpreter','latex')
    set(gca,'FontSize',12)

subplot 122
    imagesc(vecteur_sigma,vecteur_lambda,matrice_pourcentages_bonnes_classifications_SVM_test)
    hold on
    plot(sigma_opt_test,lambda_opt_test,'m+','MarkerSize',10,'LineWidth',3);
    axis xy
    xlim([vecteur_sigma(1) vecteur_sigma(end)])
    ylim([vecteur_lambda(1) vecteur_lambda(end)])
    clim([pct_min pct_max])
    colorbar

    title({['Maximum de classification des donnees de test = ' ...
           num2str(pourcentage_meilleur_classification_SVM_test,'%.1f') '% '] ...
           ['pour \sigma^* = ' num2str(sigma_opt_test,'%.4f') ' et \lambda^* = ' num2str(lambda_opt_test,'%.1f')]})
    xlabel('\sigma')
    ylabel('\lambda')
    legend('(\sigma^*,\lambda^*)')
    set(gca,'FontSize',12)
   
save hyperparametres_exercice_4 sigma_opt_test lambda_opt_test;
