public class SRecordImpl implements SRecord{
    String name;
    String email;

    public SRecordImpl(String name, String email){
        this.name = name;
        this.email=email;
    }
    public String getName (){
        return this.name;
    }
	public String getEmail (){
        return this.email;
    }
}
