function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Gauss_Newton(residu, J_residu, beta0, option)
%*****************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/TP-ref/GN_ref.m   *
% Novembre 2020                                                  *
% Université de Toulouse, INP-ENSEEIHT                           *
%*****************************************************************
%
% GN resout par l'algorithme de Gauss-Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in \IR^p
%
% Paramètres en entrés
% --------------------
% residu : fonction qui code les résidus
%          r : \IR^p --> \IR^n
% J_residu : fonction qui code la matrice jacobienne
%            Jr : \IR^p --> real(n,p)
% beta0 : point de départ
%         real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : n_itmax, nombre d'itérations maximum
%             integer
%
% Paramètres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta : f(beta)
%          real
% r_beta : r(beta)
%          real(n)
% norm_delta : ||delta||
%              real
% nbit : nombre d'itérations
%        integer
% exitflag   : indicateur de sortie
%              integer entre 1 et 4
% exitflag = 1 : ||gradient f(beta)|| < max(Tol_rel||gradient f(beta0)||,Tol_abs)
% exitflag = 2 : |f(beta^{k+1})-f(beta^k)| < max(Tol_rel|f(beta^k)|,Tol_abs)
% exitflag = 3 : ||delta)|| < max(Tol_rel delta^k),Tol_abs)
% exitflag = 4 : nombre maximum d'itérations atteint
%      
% ---------------------------------------------------------------------------------

 %Déclaration variables
    beta = beta0;
    norm_grad_f_beta =sqrt(sum((J_residu(beta)'*residu(beta)).^2));
    f_beta = (1/2)*sum(residu(beta).^2);
    f_beta_ancien = f_beta;
    beta_ancien = beta;
    norm_delta = norm(beta-beta_ancien);
    nb_it = 0;
    exitflag = 0;
    continuer = true;

    while  continuer
        %Calcul
        f_beta_ancien = f_beta;
        beta_ancien = beta;
        delta = (-J_residu(beta_ancien)'*J_residu(beta_ancien))\(J_residu(beta_ancien)'*residu(beta_ancien));
        beta=delta+beta_ancien;
        norm_delta=norm(delta);
        norm_grad_f_beta = sqrt(sum((J_residu(beta)'*residu(beta)).^2));
        f_beta = (1/2)*sum(residu(beta).^2);
        nb_it=nb_it+1;
        %Vérification conditions
        if norm_grad_f_beta <= max(option(2)*norm_grad_f_beta,option(1))
            exitflag = 1;
            continuer = false;
        elseif abs(f_beta-f_beta_ancien) <= max(option(2)*abs(f_beta_ancien),option(1))
            exitflag = 2;
            continuer = false;
        elseif norm_delta <= max (option(2)*norm(beta_ancien),option(1))
            exitflag = 3;
            continuer=false;
        elseif nb_it >= option(3)
            exitflag=4;
            continuer=false;
        end
    end
end
