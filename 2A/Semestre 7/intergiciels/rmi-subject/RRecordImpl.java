import java.rmi.RemoteException;

public class RRecordImpl implements RRecord{
    String name;
    String email;

    public RRecordImpl(String name, String email){
        this.name = name;
        this.email=email;
    }

    public String getName () throws RemoteException{
        return this.name;
    }

	public String getEmail () throws RemoteException{
        return this.email;
    }
}
