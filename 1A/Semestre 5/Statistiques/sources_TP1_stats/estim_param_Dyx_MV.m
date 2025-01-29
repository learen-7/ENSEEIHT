% Fonction estim_param_Dyx_MV (exercice_1.m)

function [a_Dyx,b_Dyx,residus_Dyx] = ...
           estim_param_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)

    n = size(tirages_psi,2);
    
    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    Y = repmat(y_donnees_bruitees_centrees, 1, n);
    X = x_donnees_bruitees_centrees * tan(tirages_psi);

    A1 = (Y - X).^2;
    SCR = sum(A1, 1);
    [~, index] = min(SCR);

    psi_star = tirages_psi(index);
    a_Dyx = tan(psi_star);
    b_Dyx = y_G - a_Dyx*x_G;

    residus_Dyx = y_donnees_bruitees_centrees - a_Dyx * x_donnees_bruitees_centrees;
end