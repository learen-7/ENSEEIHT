% fonction qualite_classification (pour l'exercice 2)

function [pourcentage_bonnes_classifications_total,pourcentage_bonnes_classifications_fibrome, ...
          pourcentage_bonnes_classifications_melanome] = qualite_classification(Y_pred,Y)

    taille_Y = size(Y, 1);
    nb_fibrome = sum(Y==1);
    nb_melanome = sum(Y==2);

    bonnes_classifications_total = 0;
    bonnes_classifications_fibrome = 0;
    bonnes_classifications_melanome = 0;
    for i=1:taille_Y
        if Y_pred(i,1) == Y(i,1)
            bonnes_classifications_total = bonnes_classifications_total + 1;
        end
        if Y_pred(i,1) == 1 && Y(i,1) == 1
            bonnes_classifications_fibrome = bonnes_classifications_fibrome + 1;
        elseif Y_pred(i,1) == 2 && Y(i,1) == 2
            bonnes_classifications_melanome = bonnes_classifications_melanome + 1;
        end

    end
    pourcentage_bonnes_classifications_total = bonnes_classifications_total/taille_Y * 100;
    pourcentage_bonnes_classifications_fibrome = bonnes_classifications_fibrome/nb_fibrome * 100;
    pourcentage_bonnes_classifications_melanome = bonnes_classifications_melanome/nb_melanome * 100;

end