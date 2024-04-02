% fonction moyenne_normalisee_3v (pour l'exercice 1bis)

function x = moyenne_normalisee_3v(I)

    % Conversion en flottants :
    I = single(I);

    d = 2;
    h = 5;
    
    % Calcul des couleurs normalisees :
    somme_canaux = max(1,sum(I,3));
    r = I(:,:,1)./somme_canaux;
    v = I(:,:,2)./somme_canaux;
    
    bord_gauche = I(:, 1:d, :);
    bord_droit = I(:, (size(I,2)-d):end, :);
    bord_haut = I(1:d, d:(size(I,2)-d), :);
    bord_bas = I((size(I,1)-d):end, d:(size(I,2)-d), :);

    s_g = size(bord_gauche,1) * size(bord_gauche,2);
    s_d = size(bord_droit,1) * size(bord_droit,2);
    bord_gauche_reshape = reshape(bord_gauche, s_g, 3);
    bord_droit_reshape = reshape(bord_droit, s_d, 3);
    
    pourtour = [bord_gauche_reshape bord_droit_reshape bord_haut bord_bas];

    


    % Calcul des couleurs moyennes :
    r_barre = mean(r(:));
    v_barre = mean(v(:));
    x = [r_barre v_barre ];

end
