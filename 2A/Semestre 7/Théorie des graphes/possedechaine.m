function possedechaine = possedechaine(G,chaine)
    for i=1 : length(chaine)-1
        if G(chaine(i), chaine(i+1)) ~= 1
            possedechaine = 0;
            break;
        end
        possedechaine = 1;
    end

end

