% Fonction calcul_G_et_R_moyen (exercice_3.m)

function [G, R_moyen, distances] = ...
         calcul_G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)

    m_xdb = mean(x_donnees_bruitees);
    m_ydb = mean(y_donnees_bruitees);
    G = [m_xdb; m_ydb];

    distances = sqrt((x_donnees_bruitees - m_xdb).^2 + (y_donnees_bruitees - m_ydb).^2);
    R_moyen = mean(distances);

end