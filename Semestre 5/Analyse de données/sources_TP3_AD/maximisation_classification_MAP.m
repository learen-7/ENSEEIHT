% fonction maximisation_classification_MAP (pour l'exercice 3)

function [pourcentage_meilleur_classification_MAP, p1_max, ...
          vecteur_pourcentages_bonnes_classifications_MAP] = ...
         maximisation_classification_MAP(X,Y,valeurs_p1,mu_1,Sigma_1,mu_2,Sigma_2)

taille_Y = size(Y, 1);
taille_valeurs_p1 = size(valeurs_p1,1);
vecteur_pourcentages_bonnes_classifications_MAP = zeros(taille_valeurs_p1, 1);
for i=1:taille_valeurs_p1
    Y_pred_MAP = classification_MAP(X,valeurs_p1(i, 1),mu_1,Sigma_1,mu_2,Sigma_2);
    bonnes_classifications_total = 0;
    for j=1:taille_Y
        if Y_pred_MAP(j,1) == Y(j,1)
            bonnes_classifications_total = bonnes_classifications_total + 1;
        end
    end
    vecteur_pourcentages_bonnes_classifications_MAP(i,1) = bonnes_classifications_total/taille_Y * 100;
end
[pourcentage_meilleur_classification_MAP, index_p1_max] = max(vecteur_pourcentages_bonnes_classifications_MAP);
p1_max = valeurs_p1(index_p1_max, 1);
end
