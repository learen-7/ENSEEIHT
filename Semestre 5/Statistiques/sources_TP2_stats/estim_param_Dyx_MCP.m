% Fonction estim_param_Dyx_MCP (exercice_4.m)

function [a_Dyx,b_Dyx] = estim_param_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe)

    n = size(x_donnees_bruitees, 1);
    A = probas_classe.*[x_donnees_bruitees , ones(n, 1)]; 
    B = probas_classe.*y_donnees_bruitees;
  
    X = A\B;

    a_Dyx = X(1);
    b_Dyx = X(2);
    
end