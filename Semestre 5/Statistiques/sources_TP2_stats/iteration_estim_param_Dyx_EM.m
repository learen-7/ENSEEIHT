% Fonction iteration_estim_param_Dyx_EM (exercice_4.m)

function [probas_classe_1,proportion_1,a_1,b_1,probas_classe_2,proportion_2,a_2,b_2] =...
         iteration_estim_param_Dyx_EM(x_donnees_bruitees,y_donnees_bruitees,sigma,...
         proportion_1,a_1,b_1,proportion_2,a_2,b_2)

    n=size(x_donnees_bruitees,1);
    %etape E
    [probas_classe_1, probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2);

    %etape M
    proportion_1 = (1/n)*sum(probas_classe_1);
    proportion_2 = (1/n)*sum(probas_classe_2);

    %etape estimation
    [a_1, b_1] = estim_param_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_1);
    [a_2, b_2] = estim_param_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_2);
end