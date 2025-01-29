% Fonction tirages_aleatoires (exercice_3.m)

function [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen)
    
    random = rand(2, n_tirages);
    G_bar = repmat(G, 1, n_tirages);
    tirages_C = G_bar + (R_moyen * 2 * (random - 0.5));

    random_r = rand(1, n_tirages);
    R_bar = repmat(R_moyen, 1, n_tirages);
    tirages_R = R_bar + (R_moyen * (random_r - 0.5));

end