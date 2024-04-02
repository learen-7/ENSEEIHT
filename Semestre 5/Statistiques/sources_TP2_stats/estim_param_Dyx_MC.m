% Fonction estim_param_Dyx_MC (exercice_1.m)

function [a_Dyx,b_Dyx] = ...
                   estim_param_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)

    n = size(x_donnees_bruitees, 1);
    A = [x_donnees_bruitees , ones(n, 1)]; 
    B = y_donnees_bruitees;
  
    X = A\B;

    a_Dyx = X(1);
    b_Dyx = X(2);
    
end