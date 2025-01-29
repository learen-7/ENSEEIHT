import java.rmi.*;
import java.util.*;

public class PadImpl implements Pad{
    Hashtable <String, String> tab = new Hashtable<String, String>();

    public PadImpl(){
        this.tab.put("", "");
    }

    public void add(SRecord sr) throws RemoteException{
        this.tab.put(sr.getName(),sr.getEmail());
    }

    public RRecord consult(String n, boolean forward) throws RemoteException{
        String email = tab.get(n);
        RRecord stub = new RRecordImpl(n, email);
        return stub;
    }

}

