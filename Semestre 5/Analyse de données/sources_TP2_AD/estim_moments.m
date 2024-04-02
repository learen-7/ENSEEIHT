% fonction estim_moments (pour exercice_3.m)

function [moyennes,ecarts_types] = estim_moments(liste_parametres)

moyennes = mean(liste_parametres);
ecarts_types = sqrt(var(liste_parametres,1));

end
