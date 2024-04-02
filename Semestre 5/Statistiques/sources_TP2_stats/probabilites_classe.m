% Fonction probabilites_classe (exercice_3.m)

function [probas_classe_1,probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2)

    residus_1 = y_donnees_bruitees - a_1 * x_donnees_bruitees - b_1;
    residus_2 = y_donnees_bruitees - a_2 * x_donnees_bruitees - b_2;

    f1 = proportion_1*exp((-residus_1.^2)/(2*sigma^2));
    f2 = proportion_2*exp((-residus_2.^2)/(2*sigma^2));

    probas_classe_1 = f1./(f1+f2);
    probas_classe_2 = f2./(f1+f2);

end