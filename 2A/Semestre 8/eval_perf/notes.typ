#set text(
  lang: "fr"
)

#set heading(numbering: "1.")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}


#align(center, text(20pt)[
  *Prise de notes : évaluation de performances*
])

#v(10pt)



UE performances, simulation et interconnexion de réseaux
- 8 séances cours ;
- 3 TDS ;
- 1 prépa TP ;
- 7/8 TPs.
*Tout autorisé pour examen.*
examen plus orienté utilisation d'outils que maths

#outline(indent : 2em)

#pagebreak()

= Introduction (18/02/25)

Réseaux de communication est ensemble composants dont on veut connaître les performances indiv et globale.  Obj atteindre QoS attendu.

Pour globale juste généralisation, on prend les performances indiv et on multiplie ? V/F souvent F. Il faut que les compo soit indep et c'est faux. => compliqué

Echelle de tps ? pour bout en bout

Voir quoi retenir perf indiv et voir que qu'on peut se retrouver pour globale

- Qualitatif : protocole correct et correctement implémenter. Outils mathématiques automates... (parcours symbiot)
- Quantitatif : delai moy, taux de perte, gigue... Tout ce qui est quantifiable. outils math : probas, stats, algèbre
-> 2 mondes séparer. On va voir le côté quantitatif.

Chaque fam réseaux a ses pbl :
- rezo loco : méthode d'accès
- rezo longue distance : perte de paquet, controle flux/erreur, retransmission
- rezo telecom : ???

== rezo commutation de circuit
Les pbls de ces rezo c'est les pannes (e.g. coup de pelleteuse dans les câbles)
=> réseaux maillé pour solution secours si panne

*Proba quel nombre appels refusé pour eval perf.*

exemple:
2 commutateurs reliés par un lien. Déterminer proba qu'1 appel refusé car pas de place pour un lien.
Etudier avec un autre lien.

== rezo commutation de paquet
circuit virtuel et datagramme

rezo semaphore : datagramme en mode commutation de message -> pas de séquencement, fonctionne pour messages cours

multiplexage statistique

esperer debit fil d'attente baisse pour vider file d'attente

pbl : état fil d'attente

->  attente variable dependant de l'état d'engorgement quand paquet entre file d'attente => perte

*epee de damocles qui est qu'à des moments c'est engorgé*

necessiter implementer mecanisme de reprise (si on veut) (circuit virtuel).
pour datatgrame on envoie les pbl aux extrémitées.

*Problème théorie des files d'attentes.*

type longueur paquets:
- données : 1500 o
- signalisation : ack...

pbl pour sens communication. Sens montant bcp ack donc pourrir buffet avec bc pde petits paquets

== Evolution des réseaux
mode circuit remplacé par mode paquet

QoS différentiée : plus facile reseaux acces qu'internet car plus petit qu'internet, la topologie est connue

== couche MAC
stations homologue/homogène : pas de connections
comment avoir commun ? :
- polling (70's) 
- méthode d'acces de type décentralisées sans collision (e.g. token ring, token bus, FDDI (jeton temporisé)) 
- méthode d'accès avec accès aléatoire (e.g. ALOHA (avec ou sans ACK) / CSMA)

TDMA / FDMA : débit constant -> utile pour téléphonie

Un reseau d'accès a une topologie arboréscente.

ADSL : que des équipements actifs de réseaux

pour user entre dans le rezo : slot temporel laissé libre (tirage aléatoire temporel pour savoir qui rejoint en 1er puis en 2e...)

== modélisation 
(partie la + importante)

Le but est d'essayer de retenir ce qui est fondamental pour modéliser => simplifier le rézo

nécessite le plus d'expertise dans le domaine des rezo

pour un modèle pour un rezo il peut y a voir plusieurs modèles : on décide en fonction des critères de perf

plusieurs étude de perf en fonction des critères
