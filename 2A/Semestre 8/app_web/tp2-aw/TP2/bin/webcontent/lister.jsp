<%@ page language="java" import="java.util.*, pack.*"%>
<html>
<body>
	<% 
    Collection<Personne> personnes = (Collection<Personne>)request.getAttribute("listePersonnes");
	for (Personne p : personnes){
		out.println(p.getNom( ) + " " + p.getPrenom( ));
		for (Adresse a: p.getAdresses()){
			out.println(a.getRue( ) + " " +a.getVille());
        }
	}
    %>
</body>
</html>