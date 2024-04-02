with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;


package analyse_ligne_commande is

    procedure get_param(alpha : OUT Float; epsilon : OUT Float;
        k : OUT Integer; mat_creuse : OUT Boolean ; prefixe : OUT Unbounded_String; fichier_source : OUT Unbounded_String);

end analyse_ligne_commande;