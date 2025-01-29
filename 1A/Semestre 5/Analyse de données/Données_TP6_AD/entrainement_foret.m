% fonction entrainement_foret (pour l'exercice 2)

function foret = entrainement_foret(X,Y,nb_arbres,proportion_individus)

        foret = cell(1, nb_arbres);
        racine_nvar = int16(sqrt(size(X,2)));
        for i = 1:nb_arbres
            n = size(X, 1);
            p = randperm(n, n*proportion_individus);
            Xi = X(p,:);
            Yi = Y(p);
            foret{i} = fitctree(Xi, Yi,'NumVariablesToSample', racine_nvar);
        end
        
end
