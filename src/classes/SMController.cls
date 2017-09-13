public class SMController {

    public List<Scenario_Master__c> SMList{get;set;}
    public list<Scenario_Master__c> SaveandNewSM{get;set;}
  
    public Scenario_Master__c NewSM {get {
              if (NewSM == null)
                NewSM = new Scenario_Master__c();
               return NewSM;
                }
             set;
            }
    
    public SMController(){
        SMList = [select id,scenario_short_description__C,scenario_Long_description__C,Scenario_Status__c,Template_Id__c,Template_Id__r.Name from Scenario_Master__c where Scenario_Status__c !=: 'Inactive'];
    }
    
    public pagereference SaveandNewSM()
    {
         try {
              insert NewSM ; // inserts the new record into the database
            } catch (DMLException e) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new SM Record.'));
              return null;
            }
        
            return null;
    }

}