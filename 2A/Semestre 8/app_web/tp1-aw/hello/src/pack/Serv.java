package pack;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Serv")
public class Serv extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        try {
            response.setContentType("text/html");
            String op = request.getParameter("op");
            if (op.equals("compute")) {
                String s1 = request.getParameter("nb1 :");
                String s2 = request.getParameter("nb2 :");
                int result = Integer.parseInt(s2) + Integer.parseInt(s1);
                out.print("<html><body>La somme de "+ s1 +" et " +s2+" est "+ String.valueOf(result)+" </body></html>");
            }
        } catch (Exception ex) {
            ex.printStackTrace(out);
        }
    }
}
