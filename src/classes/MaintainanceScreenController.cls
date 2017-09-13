public class MaintainanceScreenController {

    public PageReference SaveNewSM() {
        return null;
    }

    public list<Configuration_Template_Master__c> CTMaster{get;set;}   
    public list<Scenario_Master__c> SMRelatedCTM1{get;set;}
    public list<Configuration_Template_Master__c> SMRelatedCTM{get;set;}
    public list<Scenario_Master__c> SaveNewCTM {get;set;}
    public Scenario_Master__c NewSM {get;set;}
    
    
    public Configuration_Template_Master__c NewCTM {get {
              if (NewCTM == null)
                NewCTM = new Configuration_Template_Master__c();
               return NewCTM ;
                }
             set;
            }
    
    public MaintainanceScreenController(){
        
        CTMaster = [select id,Name,Template_Status__C from Configuration_Template_Master__c where Template_Status__C !=: 'Inactive'];
     //   SMRelatedCTM = [SELECT Id,(Select Scenario_ID__c, Scenario_ID__r.name,Scenario_ID__r.Scenario_Short_Description__c  FROM Configuration_Template_Scenarios__r)FROM Configuration_Template_Master__c];
   }   
   
   
               public pagereference SaveNewCTM ()
                    {
                         try {
                              insert NewCTM ; // inserts the new record into the database
                            } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new CTM Record.'));
                              return null;
                            }
                        
                            return null;
                    }
        
}