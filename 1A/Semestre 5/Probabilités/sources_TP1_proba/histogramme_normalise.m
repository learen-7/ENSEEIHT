% Fonction histogramme_normalise (exercice_2.m)

function [vecteurs_frequences,vecteur_Imin_a_Imax] = histogramme_normalise(I)

    minI = min(I(:));
    maxI = max(I(:));
   
    vecteurs_frequences = histcounts(I(:),minI:maxI+1);
    vecteurs_frequences = vecteurs_frequences /sum(vecteurs_frequences);
    vecteur_Imin_a_Imax = minI:maxI;
    

end