% fonction classification_SVM_avec_noyau (pour l'exercice 2)

function Y_pred = classification_SVM_avec_noyau(X,sigma,X_VS,Y_VS,Alpha_VS,c)
    n = size(X, 1);
    m = size(X_VS,1);
    G = zeros(m, n);
    for j = 1:m
        for i = 1:n
            G(i,j) = exp((X_VS(j, :) - X(i, :))'*(X_VS(j, :) - X(i, :))/(2*sigma^2));
        end
    end
    Y_pred = zeros(n, 1);
    for i = 1:n
        somme = -c;
        for j = 1:m
            somme = somme + Alpha_VS(j)*Y_VS(j)*G(i,j);
        end
        Y_pred(i) = sign(somme);
    end
end