public class JavaScriptCalendarviewController {

     public PageReference myTest() {
        return null;
    }


    public String events { get; set; }
    
    public List<File_Transmission_Log__c>  FTrtpes { get; set; }
     public  list<RecordType> rts { get; set; }
           Public string myProperty   { get; set; }   
     
     Public integer Ftlpass{get;set;}
     Public integer Ftlfail{get;set;}
    
    
    
    public List<fileTransmissionLogWrap> ftWrapList{set;get;}
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';

  
//public Summary[] Summaries { get; set; }
public wrapperInfo[] counts{ get; set; }

    public JavaScriptCalendarviewController() {
    
    
    
        //Id theId = ApexPages.currentPage().getParameters().get('id');
        
       FTrtpes  = new List<File_Transmission_Log__c> ();
       
      rts  = [SELECT ID, name FROM RecordType WHERE SObjectType = 'File_Transmission_Log__c' ORDER BY name];
      
       system.debug(rts );
        
     // FTrtpes   = [SELECT Name FROM File_Transmission_Log__c];
      
      
        
      System.debug(FTrtpes);
      FTrtpes =[select RecordTypeid,RecordType.name,Destination__c,  File_Name__c,Effective_Start_Date__c from File_Transmission_Log__c where Status__c  ='complete' ];
       //RecordType RecType = [SELECT ID, name FROM RecordType];
       
          // system.debug(RecType );
            // system.debug(theId);
            
        AggregateResult[] results = [select RecordTypeid,RecordType.name,  count(status__c), File_Name__c,count(SLA_Met__c),Effective_Start_Date__c from File_Transmission_Log__c where Status__c  ='complete' and SLA_Met__c= 'Yes' group by RecordType.name, Effective_Start_Date__c,RecordTypeid,File_Name__c];
        system.debug(results );
        counts = new List<wrapperInfo>();
        for (AggregateResult ar : results) {
            counts.add(new wrapperInfo(ar));
            system.debug(counts);
        }
    }
    
    public PageReference pageLoad() {
    
     // FTrtpes   = [SELECT Name, toLabel(RecordType.Name) FROM File_Transmission_Log__c];
      
   ftWrapList = new List<fileTransmissionLogWrap> ();
   
 
            
          
        
    For(File_Transmission_Log__c trans : FTrtpes ){
    
    //Ftlpass = database.countQuery('select count() from File_Transmission_Log__c where   File_Sent_Time__c > Client_Processing_Deadline__c');
      //datetime  Processedcount = trans.Effective_Start_Date__c;
    
    Datetime startDT = trans.Effective_Start_Date__c;
    fileTransmissionLogWrap ftLogs = new fileTransmissionLogWrap();
    ftLogs.title = trans.RecordType.name;
     ftLogs.name = trans.RecordType.name;
            ftLogs.allDay = true;
           // ftLogs.sucCount= trans.Quantity;
         //   ftLogs.failcount= trans.Quantityfail;
          //  ftLogs.fname= trans.filename;
            
            ftLogs.startString = startDT.format(dtFormat);
            ftLogs.endString = '';
            ftLogs.color = 'white';
            ftLogs.backgroundcolor = '#00BF6F';
            ftLogs.borderColor = '#00BF6F';
            ftLogs.className = 'event-birthday';
            ftWrapList.add(ftLogs);
    
    
    
  
    
    }
    
    
        return null;
        
        
        
    }
    
    
    
    
    
    

    // wrapper class to hold aggregate data
    
    
        public class wrapperInfo {
        public String  recordtypename {get;set;}
        public datetime Processedcount{get;set;}    
        public string Schedulecount{get;set;}
        public string filename {get;set;}
        public string filetype{get;set;}
         public string destination{get;set;}
        public Integer Quantity { get; set; }
        public Integer Quantityfail { get; set; }
        
        public wrapperInfo (AggregateResult ar) {
            
           recordtypename  = (String) ar.get('RecordTypeid');
           Schedulecount = (string)ar.get('name');
           filename = (string)ar.get('File_Name__c');
           
           Quantity  = (Integer)ar.get('expr0');
           Quantityfail=(Integer)ar.get('expr1');
        }
    }

 //Class to hold calendar fileTransmissionLog data
public class fileTransmissionLogWrap {
        public String title {set;get;}
        public Boolean allDay {set;get;}
        public String startString{set;get;}
        public String url {set;get;}
        public String endString {set;get;}
        public String className{set;get;}
        public String color{set;get;} 
        public String description {set;get;}
        public String backgroundColor{set;get;}
        public String textColor{set;get;}
        public string id {set;get;}
        public String borderColor {set;get;}
        public integer sucCount{set;get;}
        public integer failcount{set;get;}
         public String name{set;get;}
         public String fname{set;get;}
         
    }
  
}