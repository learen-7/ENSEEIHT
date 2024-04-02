with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        null;
    end Creer;


    function Nb_Materiels (Stock: in T_Stock) return Integer is
    begin
        return -1;
    end;


    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     Integer;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
        ) is
    begin
        null;
    end;

    function Contient (Stock : in T_Stock) return Boolean is
    begin
       return True; 
    end;

    function Get_etat (materiel: in T_Materiel) return Boolean is
    begin
        return True;
    end;

    function Get_Materiel(
        Stock : in T_Stock; Numero_serie : in T_Num_Serie) 
        return T_Materiel 
    is
    begin
        return null;
    end;

    procedure Update_mat_state (
        Stock : in out T_Stock; Numero_Serie: in T_Num_Serie) 
    is
    begin
        null;
    end Update_mat_state;


end Stocks_Materiel;
