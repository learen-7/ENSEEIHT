% fonction estim_param_SVM_dual (pour l'exercice 1)

function [X_VS,w,c,code_retour] = estim_param_SVM_dual(X,Y)
    
    n = size(X, 1);
    H = zeros(n,n);
    for i = 1:n
        for j = 1:n
            H(i,j) = Y(i)*X(i,:)*X(j,:)'*Y(j);
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
    w = [0 0];
    for i = 1:n
        w = w + alpha(i)*Y(i)*X(i,:);
    end
    c = w*X_VS(1, :)' - Y_VS(1);
end
