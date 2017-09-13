public class ActionFunction {

    public list<Account> Accrecords{get;set;}
    public list<contact> conrecords {get;set;}
    public string conid {get;set;}
    
    public ActionFunction(){
        string accid = ApexPages.CurrentPage().getParameters().get('conid');
        Accrecords = [select id,name from Account];
        
        conrecords = [select id,lastname from contact where accountid =: accid];
    }
    
    public void showconrecords(){
       string accid = ApexPages.CurrentPage().getParameters().get('conid');
       
        
        conrecords = [select id,lastname from contact where accountid =: accid];
        
    }
}