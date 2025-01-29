/* ------------------------------------------------------- 
		Les packages Java qui doivent etre importes.
*/
import java.awt.*;
import java.awt.event.*;
import java.rmi.*;
import java.util.Hashtable;

import javax.swing.*;



/* ------------------------------------------------------- 
		Implementation de l'application
*/

public class GUI extends JFrame {
	TextField name, email;
	Choice pads;
	Label message;
	static Pad Pad1 = new PadImpl();
	static Pad Pad2 = new PadImpl();
	Hashtable <String, Pad> padsTable= new Hashtable<String, Pad>();
	public GUI() {
		setSize(300,200);
		setLayout(new GridLayout(6,2));
		add(new Label("  Name : "));
		name = new TextField(30);
		add(name);
		add(new Label("  Email : "));
		email = new TextField(30);
		add(email);
		add(new Label("  Pad : "));
		pads = new Choice();
		pads.addItem("Pad1");
		pads.addItem("Pad2");
		add(pads);
		add(new Label(""));
		add(new Label(""));
		Button Abutton = new Button("add");
		Abutton.addActionListener(new AButtonAction());
		add(Abutton);
		Button Cbutton = new Button("consult");
		Cbutton.addActionListener(new CButtonAction());
		add(Cbutton);
		message = new Label();
		add(message);
		padsTable.put("Pad1", Pad1);
		padsTable.put("Pad2", Pad2);

	}

	class CButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			RRecord rr;
			String n, c;
			Pad p;
			n = name.getText();
			c = pads.getSelectedItem();
			p = padsTable.get(c);
			try{
				rr = p.consult(n, false);
				message.setText("consult("+n+","+c+") : "+rr.getEmail()+"");
			}catch(RemoteException e){System.out.println(e);}
			
		}
	}
	class AButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			String n, e, c;
			Pad p;
			n = name.getText();
			e = email.getText();
			c = pads.getSelectedItem();
			p = padsTable.get(c);
			try{
				SRecord sr = new SRecordImpl(n, e);
				p.add(sr);
			}catch(RemoteException ex){System.out.println(ex);}
			message.setText("add("+n+","+e+","+c+")");
		}
	}
	
	public static void main(String args[]) {
		GUI s = new GUI();
        s.setSize(400,200);
        s.setVisible(true);
		try{
			Naming.bind("//localHost/Pad1", Pad1);
			Naming.bind("//localHost/Pad2", Pad2);
		}catch(Exception e){System.out.println(e);}
	}
}


