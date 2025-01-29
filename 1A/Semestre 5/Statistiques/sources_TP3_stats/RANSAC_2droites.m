% Fonction RANSAC_2droites (exercice_2.m)

function [rho_F_estime,theta_F_estime] = RANSAC_2droites(rho,theta,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_donnees = length(rho);
    ecart_moyen_min = Inf;

    for i = 1:k_max
        indice = randperm(n_donnees, 2);
        rho_2 = rho(indice);
        theta_2 = theta(indice);
        [rho_F_2d, theta_F_2d, ~] = estim_param_F(rho_2, theta_2);
        res=rho-rho_F_2d*cos(theta-theta_F_2d);
        indice_proche = abs(res)<S_ecart;
        rho_proche = rho(indice_proche);
        theta_proche = theta(indice_proche);
        prop_droites = (length(rho_proche)/n_donnees);

        if prop_droites > S_prop 
            [rho_F_proche, theta_F_proche, ecart_moy] = estim_param_F(rho_proche, theta_proche);
            if ecart_moy<ecart_moyen_min
                ecart_moyen_min = ecart_moy;
                rho_F_estime = rho_F_proche;
                theta_F_estime = theta_F_proche;
            end
        end

    end

end