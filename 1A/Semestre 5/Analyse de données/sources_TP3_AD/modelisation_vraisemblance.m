% fonction modelisation_vraisemblance (pour l'exercice 1)

function modele_V = modelisation_vraisemblance(X,mu,Sigma)
    
    taille_X = size(X, 1);
    X_c = X - mu;
    det_Sigma = Sigma(1,1) * Sigma(2,2) - Sigma(1,2) * Sigma(2,1);
    denominateur = 2 * pi * sqrt(det_Sigma);
    exposant = (-1/2) * X_c * Sigma^(-1) * X_c';
    P = (1/denominateur) * exp(exposant);
    modele_V = zeros(taille_X, 1);
    for i = 1:taille_X
        modele_V(i,1) = P(i,i);
    end

end