% fonction classification_MAP (pour l'exercice 3)

function Y_pred_MAP = classification_MAP(X,p1,mu_1,Sigma_1,mu_2,Sigma_2)

    taille_X = size(X, 1);
    p2 = 1 - p1;
    
    P_1 = modelisation_vraisemblance(X, mu_1, Sigma_1);
    P_2 = modelisation_vraisemblance(X, mu_2, Sigma_2);
    
    Y_pred_MAP = zeros(taille_X, 1);
    for i = 1:taille_X
        p_1_map = P_1(i,1).*p1;
        p_2_map = P_2(i,1).*p2;
        vector = [p_1_map p_2_map];
        [~,Y_pred_MAP(i,1)] = max(vector);
    end
    
end
