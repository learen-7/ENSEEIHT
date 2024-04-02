% function ACP (pour exercice_2.m)

function [C,bornes_C,coefficients_RVG2gris] = ACP(X)

meanX = mean(X);
X_centree = X - repmat(meanX, size(X,1), 1);
sigma = (X_centree'*X_centree)/size(X,1);
[W, D] = eig(sigma);

[valeurs_propres, ind] = sort(diag(D), 'descend');
W_triee =  [W(:,ind(1)) W(:, ind(2)) W(:, ind(3))];

C = X * W_triee;

bornes_C = [min(C(:)) max(C(:))];

coefficients_RVG2gris = W_triee(:, 1)/sum(W_triee(:, 1));
    
end
