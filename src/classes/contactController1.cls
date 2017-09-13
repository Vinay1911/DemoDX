public class contactController1 {


    public List<Contact> getContacts() {
        return [SELECT Id, Name, Account.Name from Contact];
    }
        
    public Contact getContact() {
        Id id = System.currentPageReference().getParameters().get('id');
        return id == null ? new Contact() : [SELECT Id, Name  FROM Contact WHERE Id = :id];
    }


}