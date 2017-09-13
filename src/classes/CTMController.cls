public class CTMController {

    public List<configuration_Template_Master__C> CTMList{get;set;}
    public list<configuration_Template_Master__C> SaveandNew{get;set;}
  
    public configuration_Template_Master__C NewCTM {get {
              if (NewCTM == null)
                NewCTM = new configuration_Template_Master__C();
               return NewCTM;
                }
             set;
            }
    
    public CTMController(){
        CTMList = [select id,name,Template_status__C from configuration_Template_Master__C where Template_status__C !=: 'Inactive'];
    }
    
    public pagereference SaveandNew()
    {
         try {
              insert NewCTM ; // inserts the new record into the database
            } catch (DMLException e) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new SM Record.'));
              return null;
            }
        
            return null;
    }
    
    public void ConfigurationTestingCTM(){
    }
    
    public void savenew(){
    }
  

}