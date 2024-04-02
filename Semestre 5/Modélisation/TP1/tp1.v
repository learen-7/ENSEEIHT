(* Les règles de la déduction naturelle doivent être ajoutées à Coq. *) 
Require Import Naturelle. 

(* Ouverture d'une section *) 
Section LogiqueProposition. 

(* Déclaration de variables propositionnelles *) 
Variable A B C E Y R : Prop. 

Theorem Thm_0 : A /\ B -> B /\ A.
I_imp HAetB.
I_et.
E_et_d A.
Hyp HAetB.
E_et_g B.
Hyp HAetB.
Qed.

Theorem Thm_1 : ((A \/ B) -> C) -> (B -> C).
I_imp H.
I_imp HB.
E_imp (A \/ B).
Hyp H.
I_ou_d.
Hyp HB.
Qed.

Theorem Thm_2 : A -> ~~A.
I_imp H.
I_non HA.
I_antiT A.
Hyp H.
Hyp HA.
Qed.

Theorem Thm_3 : (A -> B) -> (~B -> ~A).
I_imp H.
I_imp HnB.
I_non HA.
I_antiT B.
E_imp A.
Hyp H.
Hyp HA.
Hyp HnB.
Qed.

Theorem Thm_4 : (~~A) -> A.
I_imp H.
absurde HA.
E_non (~A).
Hyp HA.
Hyp H.
Qed.

Theorem Thm_5 : (~B -> ~A) -> (A -> B).
I_imp H.
I_imp HA.
absurde HB.
E_non (A).
Hyp HA.
E_imp (~B).
Hyp H.
Hyp HB.
Qed.

Theorem Thm_6 : ((E -> (Y \/ R)) /\ (Y -> R)) -> ~R -> ~E.
I_imp H.
I_imp HnR.
I_non HE.
I_antiT R.
E_ou (Y) (R).
E_imp E.
E_et_g (Y -> R).
Hyp H.
Hyp HE.
I_imp HY.
E_imp Y.
E_et_d (E -> (Y \/ R)).
Hyp H.
Hyp HY.
I_imp HR.
Hyp HR.
Hyp HnR.
Qed.

(* Version en Coq *)

Theorem Coq_Thm_0 : A /\ B -> B /\ A.
intro H.
destruct H as (HA,HB).  (* élimination conjonction *)
split.                  (* introduction conjonction *)
exact HB.               (* hypothèse *)
exact HA.               (* hypothèse *)
Qed.


Theorem Coq_E_imp : ((A -> B) /\ A) -> B.
intro H.
cut A.
cut ((A -> B )/\ A).
intro Ha.
elim Ha.
intros HA HB.
exact HA.
exact H.
cut ((A -> B )/\ A).
intro Ha.
elim Ha.
intros HA HB.
exact HB.
exact H.
Qed.

Theorem Coq_E_et_g : (A /\ B) -> A.
intro H.
cut (A /\ B).
intro H2.
elim H2.
intros Ha Hb.
exact Ha.
exact H.
Qed.

Theorem Coq_E_ou : ((A \/ B) /\ (A -> C) /\ (B -> C)) -> C.
intro H.
elim H.
Qed.

Theorem Coq_Thm_7 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).
(* A COMPLETER *)
Qed.

End LogiqueProposition.

