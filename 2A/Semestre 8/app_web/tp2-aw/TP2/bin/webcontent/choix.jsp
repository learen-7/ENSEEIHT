<%@ page language="java" import="java.util.*, pack.*"%>
<html>

<body>
    <form method="post" action="Serv">
        Choisir la personne : <br>
        <% Collection<Personne> personnes = (Collection<Personne>)request.getAttribute("listePersonnes");
            for (Personne p:personnes){
                int idp = p.getId();
                String np = p.getNom() + " " + p.getPrenom();
            %>
            <input type="radio" name="idp" value=<%=idp %> ><%=np %>
            <% } %> <br>

        Choisir l'adresse : <br>
        <% Collection<Adresse> adresses = (Collection<Adresse>)request.getAttribute("listeAdresses");
                for (Adresse a:adresses){
                    int ida = a.getId();
                    String na = a.getRue() + " " + a.getVille();
                %>
                <input type="radio" name="ida" value=<%=ida %> ><%=na %>
                <%}%> <br>
        <input type="Submit" value="ok">
        <input type="hidden" name="op" value="associer">
    </form>
</body>
</html>