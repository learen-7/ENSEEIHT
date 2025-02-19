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
  *Prise de notes : Interconnexion*
])

#v(10pt)

#outline(indent: 2em)



= Définitions
#table(
  columns: 2,
  align: center,
  [Mot],[Definition],
  [FEC],[Forward equivalent class]
)

#pagebreak()

= MPLS (Multi Protocol Label Switching)
méthode d'interconnexion
- faire communiquer des réseaux qui n'ont pas forcément les même protocoles de routage sans changer les réseau en lui même
- apporte au monde datagramme une certaine forme de circuit virtuel

IP : non connecté
	- avantages : simple / reroutage
	- défauts : pas de mécanisme de contrôle de congestion / pas de fiabilisation / pas de mécanisme de contrôle de flux

Avec MPLS on a des *LSP (label Switch Path)* qui ressemble fortement a des circuit virtuel. Construit et définit 1 fois pour toutes où les paquets commutent. 
On commutent les paquets (n'importe quel type) donc on les route pas
	-  apporte à IP : ingéniérie de traffic / définir un chemin 
							-  on se prive de la dynamique d'IP qui est : un paquet peut passer par un chemin et un autre paquet par un autre chemin pour m^ src 							   et dest
commutation + perf que routage
	-> IP réduit écart de perf entre les deux

pour identifier quel paquet suit quel chemin il y a des numéros d'identification et différents id peuvent avoir différente priorité.

Dans le réseau il peut y avoir des milliers de LSP qui passent mais ils peuvent s'emboiter comme des poupées russes et donc il peut n'y en avoir que très peu de visible pour la taille de table de commutationau lieu d'y en avoir bcp en se retrouve avec peu (on peut passer de des centaines de milliers à des centaines de circuits)



les LSP ne changent pas si le routage change. 
En revanche, si il y a une panne il ya un blocage, là où, IP fait un reroutage

*Pile de protocole :*
#grid(
  columns: 2,
  column-gutter: 2em,
  table(
  columns: 1,
	align : center,
  [ICMP],
	[IP],
	[MPLS],
	[eth]
),
table(
  columns: 1,
	align : center,
	[eth],
	[MPLS],
	[IP]
)
)


*TTL : *
C'est la durée de vie des paquets. Il décrèmente à chque passage de routeur et si il atteint 0 alors le paquet est détruit. Permet d'éviter que des paquets errent indéfiniment.


*Conclusion*
 façon élégante d'apporter les avantages des circuit virtuel au monde IP sans avoir une mise en place lourde avec bcp d'états et sans changer IP


== Protocole LDP
1er plan de contrôle conçu specifiquement pour MPLS. Distrib label long LSP. Echange label entre routeur pour faire chemin.

Pour les message LDP il y a un 
entête commun pour tout les messages. ID pour connaître routeur qui transmet message.
Si longueur variable alors bit indiquant longueur. 


== Distribution
routeur aval définit label to routeur amont

#figure(
  image("image/schema_distri_label.jpg", width: 80%),
  caption: [schema de la distribution des label]
)

 
== Protocole RSVP
une routeur A dit à un routeur B qu'une source veut envoyer à une dest et le routeur B dit au routeur A qu'il a réservé (RSV) les ressources 

== ingeniérie de trafic
avoir bonne correspondant entre le trafic et la capacité du reseau.



