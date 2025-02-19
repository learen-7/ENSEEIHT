package pack;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
    Facade facade = new Facade();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String op=request.getParameter("op");

        if (op.equals("ajoutPersonne")){
            String nom=request.getParameter("nom");
            String prenom=request.getParameter("prenom");
            facade.ajouterPersonne(nom, prenom);
            System.out.println("serv:"+nom);
            request.getRequestDispatcher("index.html").forward(request,response);
        }

        if (op.equals("ajoutAdresse")){
            String rue=request.getParameter("rue");
            String ville=request.getParameter("ville");
            facade.ajouterAdresse(rue, ville);
            
            request.getRequestDispatcher("index.html").forward(request,response);
        }

        if (op.equals("choix")){
            request.setAttribute("listePersonnes", facade.listePersonnes());
            request.setAttribute("listeAdresses", facade.listeAdresses());            
            request.getRequestDispatcher("choix.jsp").forward(request,response);
        }

        if (op.equals("associer")){
            int ida = Integer.parseInt(request.getParameter("ida"));
            int idp = Integer.parseInt(request.getParameter("idp"));
            facade.associer(idp, ida);
            request.getRequestDispatcher("index.html").forward(request,response);
        }

        if (op.equals("lister")){
            request.setAttribute("listePersonnes", facade.listePersonnes());
            request.getRequestDispatcher("lister.jsp").forward(request,response);

        }
    }
}