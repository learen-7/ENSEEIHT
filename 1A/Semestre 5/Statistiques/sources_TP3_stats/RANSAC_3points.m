% Fonction RANSAC_3points (exercice_3)

function [C_estime,R_estime] = RANSAC_3points(x_donnees_bruitees,y_donnees_bruitees,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_tirages = parametres(4); 
    n_donnees = size(x_donnees_bruitees,1);
    ecart_moyen_min = Inf;

    [G, R_moyen, ~] = calcul_G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen);

    for i = 1:k_max
        indice = randperm(n_donnees, 3);
        x_3 = x_donnees_bruitees(indice);
        y_3 = y_donnees_bruitees(indice);
        [C_3p,R_3p] = estim_param_cercle_3points(x_3,y_3);
        distance = sqrt((x_donnees_bruitees - C_3p(1)).^2 + (y_donnees_bruitees - C_3p(2)).^2);
        indice_proche = abs(distance - R_3p)<S_ecart;
        x_proche = x_donnees_bruitees(indice_proche);
        y_proche = y_donnees_bruitees(indice_proche);

        if length(x_proche)/n_donnees > S_prop

            [C_proche_estime,R_proche_estime,ecart_moyen] = estimation_C_et_R(x_proche,y_proche,tirages_C,tirages_R);
            
            if ecart_moyen < ecart_moyen_min
                ecart_moyen_min = ecart_moyen;
                C_estime = C_proche_estime;
                R_estime = R_proche_estime;
            end
            
        end

    end

end