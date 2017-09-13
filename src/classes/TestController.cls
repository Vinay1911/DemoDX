public class TestController {

    public list<contact> conlist{get;set;}
    public list<account> acclist{get;set;}
    public string paramval{get;set;}
    public list<contact> deleteconlst{get;set;}
    public string conid {get;set;}
    public integer test {get;set;}
    public list<contact> SaveNewConRecord{get;set;}
   
    public TestController(){
      string con =  ApexPages.currentPage().getParameters().get('accid');
       SaveNewConRecord = [select id,lastname,phone from contact where id=: conid ];
        acclist = [select id,name from account];
    }
    
    public void raditest(){
       conlist = [select id,lastname,phone from contact where AccountId =: paramval];
        system.debug('************'+paramval);
    }
    
    public void save(){
        update conlist;
    }
    
        public void AddNewConRow(){
           contact c = new contact();
           conlist.add(c);
           
            
        }
        
        public void RemoveContact(){
        deleteconlst = [select id,lastname,phone from contact where Accountid=: conid];
         system.debug('>>>>>>>>>>deleteconlist'+deleteconlst);
         system.debug('>>>>>>>>>>>'+deleteconlst.size() );
            
      }
      
      public void NewConRecord(){
          //SaveNewConRecord = [select id,lastname,phone from contact ];
          SaveNewConRecord = [select id,lastname,phone from contact where Accountid=: conid];
          system.debug('>>>>>>>>>>>'+SaveNewConRecord.size());
          insert SaveNewConRecord ;
       }  
}