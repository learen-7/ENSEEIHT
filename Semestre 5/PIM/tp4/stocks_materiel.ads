
-- Auteur: 
-- Gérer un stock de matériel informatique.
generic
    type T_Num_Serie is private;


package Stocks_Materiel is


    CAPACITE : constant Integer := 10;      -- nombre maximum de matériels dans un stock

    type T_Nature is (UNITE_CENTRALE, DISQUE, ECRAN, CLAVIER, IMPRIMANTE);

    type T_Materiel is private;

    type Tab_mat is private;

    type T_Stock is limited private;


    -- Créer un stock vide.
    --
    -- paramètres
    --     Stock : le stock à créer
    --
    -- Assure
    --     Nb_Materiels (Stock) = 0
    --
    procedure Creer (Stock : out T_Stock) with
        Post => Nb_Materiels (Stock) = 0;


    -- Obtenir le nombre de matériels dans le stock Stock.
    --
    -- Paramètres
    --    Stock : le stock dont ont veut obtenir la taille
    --
    -- Nécessite
    --     Vrai
    --
    -- Assure
    --     Résultat >= 0 Et Résultat <= CAPACITE
    --
    function Nb_Materiels (Stock: in T_Stock) return Integer with
        Post => Nb_Materiels'Result >= 0 and Nb_Materiels'Result <= CAPACITE;

    -- Enregistrer un nouveau métériel dans le stock.  Il est en
    -- fonctionnement.  Le stock ne doit pas être plein.
    -- 
    -- Paramètres
    --    Stock : le stock à compléter
    --    Numero_Serie : le numéro de série du nouveau matériel
    --    Nature       : la nature du nouveau matériel
    --    Annee_Achat  : l'année d'achat du nouveau matériel
    -- 
    -- Nécessite
    --    Nb_Materiels (Stock) < CAPACITE
    -- 
    -- Assure
    --    Nouveau matériel ajouté
    --    Nb_Materiels (Stock) = Nb_Materiels (Stock)'Avant + 1
    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     T_Num_Serie;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
        ) with
            Pre => Nb_Materiels (Stock) < CAPACITE,
            Post => Nb_Materiels (Stock) = Nb_Materiels (Stock)'Old + 1;
    
    -- Indique si un numero de série correspond à un materiel du stock
    -- Paramètres
    --      Stock : Le stock à interroger
    --      Numero_Serie : Le numéro de série du matériel dont l'on souhaite connaître la présence dans le stock
    function Contient (Stock : in T_Stock; Numero_serie : in T_Num_Serie) return Boolean;

    -- Obtenir l'état d'un matériel.
    -- Paramètres
    --     materiel : le materiel dont on veut obtenir l'état
    function Get_etat (materiel : in T_Materiel) return Boolean;

    -- Obtenir un Materiel depuis le stock à l'aide de son numéro de série.
    -- le numero de série correspond à un matériel du stock
    -- Paramètres
    --      Stock : Le stock contenant le matériel
    --      Numero_Serie : Le numéro de série du matériel que l'on souhaite récuperer
    -- Nécessite
    --      contient(Stock, Numero_Serie)
    function Get_Materiel (Stock : in T_Stock; Numero_Serie : in T_Num_Serie) return T_Materiel 
        with
        Pre => Contient(Stock, Numero_serie);

    -- Modifier l'état d'un matériel dans le stock depuis son numéro de série. 
    -- Il est dans le stock.
    --
    -- Paramètres
    --      Stock : Le stock contenant le matériel à modifier
    --      Numero_Serie : Le numéro de série du matériel à modifier
    --
    -- Nécessite
    --      Nb_Materiels (Stock) > 0
    --      contient (Stock,Numero_Serie)
    --
    -- Assure
    --      etat du matériel correspondant au numéro de série est modifié
    procedure Update_mat_state(
        Stock           : in out T_Stock;
        Numero_Serie    : in T_Num_Serie
    ) with 
        Pre => Nb_Materiels (Stock) > 0 and then Contient(Stock, Numero_serie),
        Post => Get_etat(Get_Materiel(Stock, Numero_Serie)) =/= Get_etat(Get_Materiel(Stock, Numero_Serie))'Old ;

    -- Renvoie le nombre de materiel Hors-service du stock
    -- Parametre
    --      Stock : Le stock à interroger
    -- Assure 
    --      result >= 0
    function Get_nbr_hs (Stock : in T_Stock) return Integer
        with
            Pre => Get_nbr_hs'Result >=0;
    
    -- Supprime un materiel du stock. Le materiel est dans le stock
    -- Paramètres
    --      Stock : Le stock contenant le matériel à supprimer
    --      Numero_Serie : Le numéro de série du matériel à supprimer
    -- Nécessite
    --      contient (Stock,Numero_Serie)
    -- Assure
    --      Nb_Materiels(Stock) < Nb_Materiel(Stock)'Old
    procedure Delete_mat (Stock : in out T_Stock; Numero_serie : in T_Num_Serie)
        with 
            Pre => Contient(Stock, Numero_serie),
            Post => Nb_Materiels(Stock) < Nb_Materiels(Stock)'Old;
    
    -- Affiche les matériaux du stock
    -- Paramètre
    --      Stock : le stock à afficher
    procedure Afficher_Stock (Stock : in T_Stock);

    -- Supprime tous les matériaux hors-service du stock
    -- Paramètre
    --      Stock : le stock dont on souhaite supprimer les matériaux hors-service
    -- Assure
    --      Get_nbr_hs(Stock) = 0
    procedure Delete_all_hs (Stock: in out T_Stock) 
        with
            Post => Get_nbr_hs(Stock) = 0;


    private

        type T_Materiel is
            record
                nature : T_Nature;
                num_serie : T_Num_Serie;
                annee_achat : Integer;
                etat : Boolean;
                -- Invariant
                    -- etat = False -> materiel hors-service
            end record;

        type Tab_mat is array(1..CAPACITE) of T_Materiel;

        type T_Stock is
            record
                table : Tab_mat;
                nb_elem : Integer;
            end record;

end Stocks_Materiel;
