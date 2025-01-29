with Ada.Text_IO;
use Ada.Text_IO;

-- Dans ce programme, les commentaires de spécification
-- ont **volontairement** été omis !

procedure Comprendre_Mode_Parametre is

    function Double (N : in Integer) return Integer is
    begin
        return 2 * N;
    end Double;

    procedure Incrementer (N : in out Integer) is
    begin
        N := N + 1;
    end Incrementer;

    procedure Mettre_A_Zero (N : out Integer) is
    begin
        N := 0;
    end Mettre_A_Zero;

    procedure Comprendre_Les_Contraintes_Sur_L_Appelant is
        A, B, R : Integer;
    begin
        A := 5;
        -- Indiquer pour chacune des instructions suivantes si elles sont
        -- acceptées par le compilateur.
        R := Double (A);   -- oui car A a une valeur
        R := Double (10);   -- oui
        R := Double (10 * A);   -- non
        R := Double (B);   -- non B n'a pas de valeur

        Incrementer (A);   -- oui
        Incrementer (10);   -- oui
        Incrementer (10 * A);   -- non
        Incrementer (B);   -- non

        Mettre_A_Zero (A);   -- oui
        Mettre_A_Zero (10);   -- oui
        Mettre_A_Zero (10 * A);   -- oui
        Mettre_A_Zero (B);   -- oui
    end Comprendre_Les_Contraintes_Sur_L_Appelant;


    procedure Comprendre_Les_Contrainte_Dans_Le_Corps (
            A      : in Integer;
            B1, B2 : in out Integer;
            C1, C2 : out Integer)
    is
        L: Integer;
    begin
        -- pour chaque affectation suivante indiquer si elle est autorisée
        L := A;   -- non L n'est pas bien définie
        A := 1;   -- oui

        B1 := 5;   -- oui

        L := B2;  -- non B2 n'a pas de valeur
        B2 := B2 + 1;   -- non B2 n'a pas de valeur

        C1 := L;   -- non L n'est pas bien définie

        L := C2;   -- non L n'est pas bien définie

        C2 := A;   -- oui A a une valeur
        C2 := C2 + 1;   -- oui C2 a une valeur
    end Comprendre_Les_Contrainte_Dans_Le_Corps;


begin
    Comprendre_Les_Contraintes_Sur_L_Appelant;
    Put_Line ("Fin");
end Comprendre_Mode_Parametre;
