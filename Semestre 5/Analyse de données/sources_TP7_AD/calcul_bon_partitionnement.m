% fonction calcul_bon_partitionnement (pour l'exercice 1)

function meilleur_pourcentage_partitionnement = calcul_bon_partitionnement(Y_pred,Y)

    perm = perms(1:3);
    score_perm = zeros(6,1);
    for i = 1:length(perm)
        Y_copy = Y_pred;
        Y_copy(Y_pred == 1) = perm(i, 1);
        Y_copy(Y_pred == 2) = perm(i, 2);
        Y_copy(Y_pred == 3) = perm(i, 3);
        score_perm(i) = sum(Y_copy == Y);
    end

    [val_max,~] = max(score_perm);
    meilleur_pourcentage_partitionnement = (val_max/length(Y)) * 100 ;


end