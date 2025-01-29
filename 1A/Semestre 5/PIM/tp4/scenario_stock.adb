with Ada.Text_IO;          use Ada.Text_IO;
-- with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Stocks_Materiel; 

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
procedure Scenario_Stock is

    package Stock_int is new Stocks_Materiel(T_Num_Serie => Integer);
    use Stock_int;

    Mon_Stock : T_Stock;
begin
    -- Créer un stock vide
    Creer (Mon_Stock);
    pragma Assert (Nb_Materiels (Mon_Stock) = 0);

    -- Enregistrer quelques matériels
    Enregistrer (Mon_Stock, 1012, UNITE_CENTRALE, 2016);
    pragma Assert (Nb_Materiels (Mon_Stock) = 1);

    Enregistrer (Mon_Stock, 2143, ECRAN, 2016);
    pragma Assert (Nb_Materiels (Mon_Stock) = 2);

    Enregistrer (Mon_Stock, 3001, IMPRIMANTE, 2017);
    pragma Assert (Nb_Materiels (Mon_Stock) = 3);

    Enregistrer (Mon_Stock, 3012, UNITE_CENTRALE, 2017);
    pragma Assert (Nb_Materiels (Mon_Stock) = 4);

    -- Afficher le nouveau stock
    Afficher_Stock(Mon_Stock);

    -- modifier l'état d'un materiel
    pragma Assert (Get_etat(Get_Materiel(Mon_Stock,1012)));
    pragma Assert (Get_nbr_hs(Mon_Stock) = 0);
    Update_mat_state(Mon_Stock, 1012);
    pragma Assert (not(Get_etat(Get_Materiel(Mon_Stock,1012))));
    pragma Assert (Get_nbr_hs(Mon_Stock) = 1);

    -- supprimer un matériel du stock
    Delete_mat(Mon_Stock, 2143);
    pragma Assert (not(Contient(Mon_Stock, 2143)));
    pragma Assert (Nb_Materiels (Mon_Stock) = 3);

    -- supprimer tous les matériaux hors-service
    Delete_all_hs(Mon_Stock);
    pragma Assert (Get_nbr_hs(Mon_Stock) = 0);
    pragma Assert (Nb_Materiels (Mon_Stock) = 2);

    -- Afficher le Stock modifié
    Afficher_Stock(Mon_Stock);


    -- Signaler la fin du test
    Put("Scénario réussi.");

end Scenario_Stock;
