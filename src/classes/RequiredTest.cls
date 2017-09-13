public class RequiredTest {
     public String Description{set;get;}
    public String Status{set;get;}
    public List<SelectOption> options{set;get;} 
    public List<configuration_Template_Master__C> CTMList  = new List<configuration_Template_Master__C>();
    
    public RequiredTest (){
      
        options =new List<SelectOption>();
        options.add(new SelectOption('None', '-None-'));
        Schema.DescribeFieldResult fieldResult = Configuration_Template_Master__c.Template_Status__c.getDescribe();

           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for(Schema.PicklistEntry e1:ple ){
                options.add(new SelectOption(e1.getLabel(), e1.getValue()));
            }
    
    }
    
    
    
    public List<configuration_Template_Master__C> getConfigurationTemplate(){
     CTMList =[select id,name,Template_status__C from configuration_Template_Master__C];
      return CTMList ;

    }
    
    public PageReference inserrtCTM(){
   
        configuration_Template_Master__C C1=new configuration_Template_Master__C();
        c1.name=Description;
        c1.Template_status__C=Status;
        CTMList = [select id,name,Template_status__C from configuration_Template_Master__C];
        insert c1;
       
        return null ;
        
    }
    
    public void save1() {
    update CTMList ;
     
    }
  
}