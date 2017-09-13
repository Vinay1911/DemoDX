public class ConfigurationTestingController {
    
    public List<Project_Scenario_Results__c> ProjectSCResult{get;set;}
    public list<Configuration_Template_Master__c> TemplateMaster{get;set;}
    public list<Scenario_Master__c> ScMaster {get;set;}
    public list<Project_Scenario_Results__c> deleteLatestcycle{get;set;}
    public list<Scenario_Master__c> SaveNewSM {get;set;}   
     
 
        // Variables
        
        public Date UpdateDate{get;set;}        
        public Configuration_Template_Master__c NewCTM{get; set;}
          
        public Project_Scenario_Results__c SaveNewPSRRecord {
            get {
              if (SaveNewPSRRecord == null)
                SaveNewPSRRecord = new Project_Scenario_Results__c();
               return SaveNewPSRRecord ;
                }
             set;
            }
            
        public Scenario_Master__C NewSM {get {
              if (NewSM == null)
                NewSM = new Scenario_Master__c();
               return NewSM ;
                }
             set;
            }
     
    Public ConfigurationTestingController()
    {
    
        ProjectSCResult = [Select id,Name,External_Status__c,External_User__c,Internal_User__c,Internal_Status__c,Scenario_Long_Description__c,Scenario_Short_Description__c,
                                            Internal_Status_Date__c,External_Status_Date__c From Project_Scenario_Results__c];  
       
        TemplateMaster = [Select id,Name, Template_Status__c from Configuration_Template_Master__c];
        
        ScMaster = [Select id,Scenario_Short_Description__c,Scenario_Long_Description__c,Scenario_Status__c from Scenario_Master__c];
        
    }
    
    public pagereference NewPTS()
    {        
        return Null;
    }
    
    public pagereference UpdateDate()
    {
         return null;
        
    }
    
        public pagereference deleteLatestcycle()
        {
        
            deleteLatestcycle = [select id,name,lastmodifieddate from Project_Scenario_Results__c order by lastmodifieddate desc limit 1 ];
            
            delete deleteLatestcycle ;           
           
         return null;
        }    
        
        public pagereference save()
        {
            
            insert ScMaster;
           return null;
        } 
    
                    
                    
                    public pagereference SaveNewSM ()
                    {
                         try {
                              insert NewSM ; // inserts the new record into the database
                            } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new SM.'));
                              return null;
                            }
                        
                            return null;
                    }
                    
                    public pagereference SaveNewPSR()
                    {
                        try {
                              insert SaveNewPSRRecord ; // inserts the new record into the database
                            } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new PSR.'));
                              return null;
                            }
                        
                            return null;
                    } 
}