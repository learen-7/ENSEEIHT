% Fonction estim_param_Dyx_MV_2droites (exercice_2.m) 

function [a_Dyx_1,b_Dyx_1,a_Dyx_2,b_Dyx_2] = ... 
         estim_param_Dyx_MV_2droites(x_donnees_bruitees,y_donnees_bruitees,sigma, ...
                                     tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2)    
    
    n = size(x_donnees_bruitees, 1);
    residus_1 = y_donnees_bruitees - tirages_G_1(2, :) - (x_donnees_bruitees - tirages_G_1(1, :)) .* tan(repmat(tirages_psi_1, n, 1));
    residus_2 = y_donnees_bruitees - tirages_G_2(2, :) - (x_donnees_bruitees - tirages_G_2(1, :)) .* tan(repmat(tirages_psi_2, n, 1));

    exp_1 = exp((-residus_1.^2)/(2*sigma^2));
    exp_2 = exp((-residus_2.^2)/(2*sigma^2));

    [~, index] = max(sum(log(exp_1 + exp_2)));
    
    G_1 = tirages_G_1(:, index);
    psi_1 = tirages_psi_1(index);

    a_Dyx_1 = tan(psi_1);
    b_Dyx_1 = G_1(2) - a_Dyx_1 * G_1(1);

    G_2 = tirages_G_2(:, index);
    psi_2 = tirages_psi_2(index);

    a_Dyx_2 = tan(psi_2);
    b_Dyx_2 = G_2(2) - a_Dyx_2 * G_2(1);

end