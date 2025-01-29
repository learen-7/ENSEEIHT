function isEulerien = isEulerien(G)
    %% On enlève les sommes de degre nul
    degree = sum(G);
    sommet_actif = find(degree);

    %% On regarde si le graphe est connexe
    visite = zeros(1, length(sommet_actif));
    visite(sommet_actif(1))=1;
    queue(1) = sommet_actif(1);
    while length(queue)>0
        sommet_courant = queue(1);
        queue(1)=[];
        for sommet = sommet_actif
            if possedechaine([sommet_courant, sommet], G) && visite(sommet) == 0
                visite(sommet)=1;
                queue(end+1) = sommet;
            end
        end
    end
    est_connexe = length(find(visite))==length(visite);
    
    %% max 2 sommet de degre impairs
    compt_sommet_impair = 0;
    for deg = degree
        if mod(deg,2)==1
            compt_sommet_impair = compt_sommet_impair + 1;
        end
    end

    isEulerien = (compt_sommet_impair <= 2) && est_connexe;
end

