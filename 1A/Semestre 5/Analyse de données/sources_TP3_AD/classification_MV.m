% fonction classification_MV (pour l'exercice 2)

function Y_pred_MV = classification_MV(X,mu_1,Sigma_1,mu_2,Sigma_2)
    
    taille_X = size(X, 1);
    
    P_1 = modelisation_vraisemblance(X, mu_1, Sigma_1);
    P_2 = modelisation_vraisemblance(X, mu_2, Sigma_2);
    
    Y_pred_MV = zeros(taille_X, 1);
    for i = 1:taille_X
        if P_1(i,1) > P_2(i,1)
            Y_pred_MV(i,1) = 1;
        else
            Y_pred_MV(i,1) = 2;
        end
    end

end
