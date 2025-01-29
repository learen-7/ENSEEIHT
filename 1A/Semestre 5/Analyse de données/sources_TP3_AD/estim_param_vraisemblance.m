% fonction estim_param_vraisemblance (pour l'exercice 1)

function [mu,Sigma] = estim_param_vraisemblance(X)

   mu = mean(X);
   X_c = X - mu;
   Sigma = (X_c'*X_c) ./ size(X_c, 1) ;

end