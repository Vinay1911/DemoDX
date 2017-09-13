public with sharing class calendarviewclasspopupwindow {

    public calendarviewclasspopupwindow(calendarviewclasspopupwindow controller) {
    
    

    }


    public String dateval { get; set; }
    private String soql {get;set;}
    public Map<string,List<file_transmission_log__c>> ftl{get;set;}
    public Map<string,List<file_transmission_log__c>> finalftl{get;set;}
    public date effectivedate;
    public map<string,boolean> showhide{get;set;}
    public string rec{get;set;}
    public string title{get;set;}
    
    public PageReference hideorshow(){
        if(showhide.get(rec))
            showhide.put(rec,false);
        else
            showhide.put(rec,true);
            
        system.debug(showhide);
        return null;
    }
    
    public calendarviewclasspopupwindow(){
    
    soql = 'select Name,effective_start_date__c, destination__c, file_name__c, file_type__c,Date_and_Time_Ran__c,Status__c,File_Sent_Time__c from file_transmission_log__c where Name!= null';
        runQuery();
        showhide = new map<string,boolean>();
        dateval = apexpages.currentpage().getparameters().get('dateval');
        effectivedate = Date.newInstance(system.today().year(),integer.valueof(dateval.substringafter(' ').substringbefore('/')),integer.valueof(dateval.substringafter('/')));
        DateTime dt=DateTime.newInstance(effectivedate, Time.newInstance(0, 0, 0, 0));
        title = dt.format('EEEE')+' '+dt.format('MMMMM')+' '+effectivedate.day()+','+' '+effectivedate.year();
        system.debug('+++ '+effectivedate);
        ftl = new Map<string,List<file_transmission_log__c>>();
        getrecords();
    
        
    }
    
    public Map<string,List<file_transmission_log__c>> getrecords(){
        List<file_transmission_log__c> ftllist = [select recordtype.name, effective_start_date__c, destination__c, file_name__c,Rating__c, file_type__c,client_processing_deadline__c,Status__c,File_Sent_Time__c from file_transmission_log__c where effective_start_date__c =: effectivedate];
        for(file_transmission_log__c eachftl : ftllist){
            List<file_transmission_log__c> temp = new list<file_transmission_log__c>();
            if(ftl == null){
                temp.add(eachftl);
                ftl.put(eachftl.recordtype.name,temp);
            }
            else{
                if(ftl.get(eachftl.recordtype.name) != null)
                    temp = ftl.get(eachftl.recordtype.name);
                temp.add(eachftl);
                ftl.put(eachftl.recordtype.name,temp);
            }
        }
        
        finalftl = new Map<string,List<file_transmission_log__c>>();
        
        for(string str : ftl.keyset()){
            integer i = 0;
            string newstr = str;
            for(file_transmission_log__c tempftl : ftl.get(str)){
                if(tempftl.File_Sent_Time__c < tempftl.client_processing_deadline__c)
                    i++;
            }
            str = str + ' ' +'('+string.valueof(ftl.get(str).size())+'/'+string.valueof(i)+')';
            finalftl.put(str,ftl.get(newstr));
        }
        
        for(string str:finalftl.keyset()){
            showhide.put(str,false);
        }
        
        return finalftl;
    }
    //Sorting
    
    public String sortDir {
            get { if (sortDir == null) { sortDir = 'asc'; } return sortDir; }
            set;
        }
        
        // the current field to sort by. defaults to Name
        public String sortField {
            get { if (sortField == null) {sortField = 'Destination__c'; } return sortField; }
            set;
        }
        
        // toggles the sorting of query from asc<-->desc    
        public void toggleSort() {
            
            sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
            // run the query again
            runQuery();
        }
        
        // runs the actual query
        public void runQuery() {
            try {
                
              ApexPages.StandardSetController sscAccounts = new ApexPages.StandardSetController(Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
            }
            
        }
}