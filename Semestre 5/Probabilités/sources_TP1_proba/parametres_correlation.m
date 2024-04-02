% Fonction parametres_correlation (exercice_1.m)

function [r,a,b] = parametres_correlation(Vd,Vg)
    
    et_D = sqrt(var(Vd));
    et_G = sqrt(var(Vg));
    cov_DG = (1/size(Vg,1)) * sum((Vd - mean(Vd)) .* (Vg - mean(Vg)));
    r = cov_DG/(et_G*et_D);
    a = cov_DG/(et_D^2);
    b = a*(-mean(Vd)) + mean(Vg);

end