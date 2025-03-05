package pack;

import java.util.Collection;
import java.util.HashMap;

public class Facade {

    int indexA = 0;
    int indexP = 0;
    HashMap<Integer, Personne>personnes = new HashMap<Integer, Personne>();
    HashMap<Integer, Adresse>adresses = new HashMap<Integer, Adresse>();

    public void ajouterPersonne(String nom, String prenom){
        Personne p = new Personne();
        p.setId(indexP);
        p.setNom(nom);
        p.setPrenom(prenom);
        personnes.put(indexP, p);
        indexP ++;
        System.out.println("facade:"+p.getNom());
    }

    public Collection<Personne> listePersonnes(){
        Collection<Personne> l = personnes.values();
        System.out.println("les personnes (qqq) : ");
        for (Personne p : l) System.out.println(p.getNom());
        return l;
    }

    public void ajouterAdresse(String rue, String ville){
        Adresse a =new Adresse();
        a.setId(indexA);
        a.setRue(rue);
        a.setVille(ville);
        adresses.put(indexA, a);
        indexA ++;
    }
    
    public Collection<Adresse> listeAdresses(){
        return adresses.values();
    }

    public void associer(int idp, int ida){
        Personne p = personnes.get(idp);
        p.adresses.add(adresses.get(ida));
    }
}
