% fonction classification_foret (pour l'exercice 2)

function Y_pred = classification_foret(foret, X)

    preds = zeros(length(foret), length(X));
    for i = 1:length(foret)
        preds(i, :) = predict(foret{i}, X);
    end
    Y_pred = mode(preds)';

end
