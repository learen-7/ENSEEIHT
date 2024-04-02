% fonction estim_param_SVM_noyau (pour l'exercice 2)

function [X_VS,Y_VS,Alpha_VS,c,code_retour] = estim_param_SVM_noyau(X,Y,sigma)

    n = size(X, 1);
    G = zeros(n,n);
    for i = 1:n
        for j = 1:n
            G(i,j) = exp((X(i, :) - X(j, :))'*(X(i, :) - X(j, :))/(2*sigma^2));
        end
    end
    H = zeros(n,n);
    for i = 1:n
        for j = 1:n
            H(i,j) = Y(i)*G(i,j)*Y(j);
        end
    end
    f = -ones(n,1);
    A = [];
    b = [];
    Aeq = Y';
    beq = 0;
    lb = zeros(n,1);
    ub = [];
    [alpha, ~, exitflag, ~] = quadprog(H, f, A, b, Aeq, beq, lb, ub);
    code_retour = exitflag;
    mat_alpha_pos = (alpha >= 10^(-6));
    X_VS = X(mat_alpha_pos,:);
    Y_VS = Y(mat_alpha_pos);
    Alpha_VS = alpha(mat_alpha_pos);
    c = - Y_VS(1);
    for j = 1:n 
        c = c + alpha_VS(j) * Y_VS(j) *G(j, 1);
    end 
end
