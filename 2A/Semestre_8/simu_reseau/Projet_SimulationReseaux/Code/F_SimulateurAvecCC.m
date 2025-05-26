function [ThroughputSlots,Stats] = F_SimulateurAvecCC(ProfilTrafic,PhyParam,MACParam,CCParam,idxSlotStats)
% ProfilTrafic : Profil de trafic, nombre de nouveaux utilisateurs par time slot
% PhyParam : Parametres de couche physique
% MACParam : Parametres de couche MAC
% CCParam : Parameters de controle de charge
% idxSlotStats : indice des slots ou on calcule les stats.
NbSlots = length(ProfilTrafic); % Nombre de time slots simules.
Utilisateurs = zeros(sum(ProfilTrafic),6); % Matrice Utilisateurs, attention differente de la precedente..
idxArriveeUtilisateurs = 1; % Pour remplir la matrice utilisateurs.
% Colonne numero 1 - Time slot actuel
% Colonne numero 2 - Flag Stats
% Colonne numero 3 - Time slot d'arrivee dans le systeme
% Colonne numero 4 - Time slot sortie du systeme
% Colonne numero 5 - Nombre de transmissions
% Colonne numero 6 - Bool Reussite Transmission


for Slot = 1:NbSlots
    
    if min(abs(idxSlotStats-Slot)) == 0
        FlagStats = 1;
    else
        FlagStats = 0;
    end
    
    % Arrivee des nouveaux utilisateurs
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),1) = Slot;
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),2) = FlagStats;
    Utilisateurs(idxArriveeUtilisateurs:(idxArriveeUtilisateurs+ProfilTrafic(Slot)-1),3) = Slot;
    idxArriveeUtilisateurs = idxArriveeUtilisateurs + ProfilTrafic(Slot);
    
    % Controle de charge
    nombre_opti = 0.36*PhyParam.Ncodes;
    if (idxArriveeUtilisateurs>nombre_opti)% Condition activation controle de charge
        Utilisateurs = ApplicationControleDeCharge(Utilisateurs,Slot,CCParam);
    end
    
    % Simulation des transmissions
    
    [Utilisateurs, ThroughputSlots(Slot)] = SimulationTransmission(Utilisateurs,Slot,PhyParam,MACParam);
    
    
    % ---- Stats ---- %
    matStats = Utilisateurs;
    matStats(matStats(:,2)==0, :)=[];
    nbTransmission_moy = mean(matStats(:, 5));
    slotSortie=matStats(:,4);
    slotEntree = matStats(:,3);
    TempsReponse = slotSortie-slotEntree;
    tempsReponse_moy = mean(TempsReponse);
    transmission_moy = mean(matStats(:, 6));
    Stats = [nbTransmission_moy, tempsReponse_moy, transmission_moy];


    
end

    function [Utilisateurs, ThroughputSlot] = SimulationTransmission(Utilisateurs,Slot,PhyParam,MACParam)
        
        IdxUtilisateursEnTransmission = find((Utilisateurs(:,1)-Slot) == 0);
        NbRequeteTransmisesDurantSlot = length(IdxUtilisateursEnTransmission);
        PLRSlot = 1 - exp(-NbRequeteTransmisesDurantSlot/PhyParam.Ncodes);
        
        ThroughputSlot = 0;
        
        for k = 1:length(IdxUtilisateursEnTransmission) 
            % ---- A remplir ----
            index = IdxUtilisateursEnTransmission(k);
            random_number = rand();
            random_slot = randi(3) + MACParam.Traitement + 1 + 1 + Utilisateurs(index,1);
            if (Utilisateurs(index, 5) + 1 >= 10)
                Utilisateurs(index, 5) = 11;
                Utilisateurs(index, 6) = 0;
                Utilisateurs(index, 4) = Slot;
            elseif (random_slot > length(ProfilTrafic))
                Utilisateurs(index,2) = 0;
            elseif (random_number > PLRSlot)
                Utilisateurs(index, 5) = Utilisateurs(index, 5) + 1;
                Utilisateurs(index, 4) = Utilisateurs(index,1);
                Utilisateurs(index, 6) = 1;                
                ThroughputSlot = ThroughputSlot + 1;
            else
                Utilisateurs(index, 1) = random_slot;
                Utilisateurs(index, 5) = Utilisateurs(index, 5) + 1;
            
            end           

        end
        
    end

    function Utilisateurs = ApplicationControleDeCharge(Utilisateurs,Slot,CCParam)
        
        IdxUtilisateursEnTransmission = find((Utilisateurs(:,1)-Slot) == 0);
        for k = 1:length(IdxUtilisateursEnTransmission) % Boucle sur tous les utilisateurs qui transmettent
            
            % ---- A remplir ----
            index = IdxUtilisateursEnTransmission(k);
            random_number = rand();
            random_slot = randi(CCParam.NslotBarringMax) + Slot;

            if (random_number>CCParam.paccess)
                Utilisateurs(index,1) = Utilisateurs(index,1) - 1;
                if (Utilisateurs(index, 5) + 1 >= 10)
                    Utilisateurs(index, 5) = 11;
                    Utilisateurs(index, 6) = 0;
                    Utilisateurs(index, 4) = Slot;
                elseif (random_slot<=length(ProfilTrafic))
                    Utilisateurs(index, 1) = random_slot;
                    Utilisateurs(index, 5) = Utilisateurs(index, 5) + 1;
                else
                    Utilisateurs(index,2) = 0;
                end
            end
            
        end
    end
end