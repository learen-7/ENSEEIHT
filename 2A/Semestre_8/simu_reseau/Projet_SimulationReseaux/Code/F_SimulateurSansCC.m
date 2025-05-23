function ThroughputSlots = F_SimulateurSansCC(ProfilTrafic,PhyParam,MACParam)

% ------- Param?tres -----------
% ProfilTrafic : Le profil de trafic, ProfilTrafic(k) est le nombre d'utilisateurs qui transmettent pour la premiere fois au slot k.
% PhyParam : Les parametres couche physique.
% MACParam : Parametres couche MAC. 

NbSlots = length(ProfilTrafic); % Nombre de slots simules.
MatriceUtilisateur = zeros(MACParam.NMaxTransmission,NbSlots); % Matrice permettant de stocker les utilisateurs. 
ThroughputSlots = zeros(1,NbSlots); % Debit par time slot. 

for Slot = 1:NbSlots
    
    % Arrivee des nouveaux utilisateurs
    %------- A Remplir ------%
    MatriceUtilisateur(1,Slot) = ProfilTrafic(1);
    %------------------------%
    % Simulation des transmissions
    [MatriceUtilisateur, ThroughputSlots(Slot)] = SimulationTransmission(MatriceUtilisateur,Slot,NbSlots,PhyParam,MACParam);
    
end


end

function [MatriceUtilisateur, ThroughputSlot] = SimulationTransmission(MatriceUtilisateur,Slot,NbSlots,PhyParam,MACParam)

NbRequeteTransmisesDurantSlot = sum(MatriceUtilisateur(:,Slot)); 
PLRSlot = 1 - exp(-NbRequeteTransmisesDurantSlot/PhyParam.Ncodes); % PLR du slot

ThroughputSlot = 0;
for k = 1:MACParam.NMaxTransmission
    
    if(MatriceUtilisateur(k,Slot) > 0)
        for l = 1:MatriceUtilisateur(k,Slot) % Boucle sur tous les utilisateurs qui vont transmettre
        
            %--------- A Remplir -------%    
            random_number = rand();
            random_slot = randi(3) + 1 + 1 + MACParam.Traitement +Slot;

            if (random_number > PLRSlot)
                MatriceUtilisateur(k,Slot) = MatriceUtilisateur(k, Slot) - 1;
                ThroughputSlot = ThroughputSlot + 1;
            elseif (k+1 <= MACParam.NMaxTransmission && random_slot <= NbSlots)
                MatriceUtilisateur(k+1, random_slot)= MatriceUtilisateur(k+1, random_slot)+1;
            end
            
            %----------------------------%
        end    
    end    
end

end