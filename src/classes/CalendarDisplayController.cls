public class CalendarDisplayController {

    public List<string> tableheadder{get;set;}
    public datetime dateflag{get;set;}
    public list<wrapclass> wrap{get;set;}
    public list<date> weekdates{get;set;}
    public boolean displayPopup {get; set;} 
    
    public List<file_transmission_log__c> ftllist{get;set;}
    
    public String dateval { get; set; }
    private String soql {get;set;}
    public Map<string,List<file_transmission_log__c>> ftl{get;set;}
    public Map<string,List<file_transmission_log__c>> finalftl{get;set;}
    public date effectivedate;
    public map<string,boolean> showhide{get;set;}
    public string rec{get;set;}
    public string title{get;set;}
    
    public PageReference next() {
        dateflag = dateflag.adddays(7);
        getrecords();
        return null;
    }
    

    public PageReference previous() {
        dateflag = dateflag.adddays(-7);
        getrecords();
        return null;
    }
    
    public CalendarDisplayController(){
        ftllist = new List<file_transmission_log__c>();
        if(system.now().format('E') == 'Sun')
            dateflag = system.now();
        else if(system.now().format('E') == 'Mon')
            dateflag = system.now().addDays(6);
        else if(system.now().format('E') == 'Tue')
            dateflag = system.now().addDays(5);
        else if(system.now().format('E') == 'Wed')
            dateflag = system.now().addDays(4);
        else if(system.now().format('E') == 'Thu')
            dateflag = system.now().addDays(3);
        else if(system.now().format('E') == 'Fri')
            dateflag = system.now().addDays(2);
        else
            dateflag = system.now().addDays(1);
        system.debug('++: '+dateflag);
        wrap = new List<wrapclass>();
        weekdates = new List<date>();
        getRecords();
    }
    
    public list<wrapclass> getRecords(){
        weekdates.clear();
        weekdates.add(dateflag.adddays(-6).date());
        weekdates.add(dateflag.adddays(-5).date());
        weekdates.add(dateflag.adddays(-4).date());
        weekdates.add(dateflag.adddays(-3).date());
        weekdates.add(dateflag.adddays(-2).date());
        weekdates.add(dateflag.adddays(-1).date());
        weekdates.add(dateflag.date());
        
        map<date,integer> colcount = new map<date,integer>();
        colcount.put(weekdates[0],1);
        colcount.put(weekdates[1],3);
        colcount.put(weekdates[2],5);
        colcount.put(weekdates[3],7);
        colcount.put(weekdates[4],9);
        colcount.put(weekdates[5],11);
        colcount.put(weekdates[6],13);
        
        wrap.clear();
        wrapclass newwrap = new wrapclass('','','','','','','','','','','','','','','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6');
        newwrap.col1 = dateflag.adddays(-6).format('E') + ' ' + dateflag.adddays(-6).month() + '/' + dateflag.adddays(-6).day();
        newwrap.col3 = dateflag.adddays(-5).format('E') + ' ' + dateflag.adddays(-5).month() + '/' + dateflag.adddays(-5).day();
        newwrap.col5 = dateflag.adddays(-4).format('E') + ' ' + dateflag.adddays(-4).month() + '/' + dateflag.adddays(-4).day();
        newwrap.col7 = dateflag.adddays(-3).format('E') + ' ' + dateflag.adddays(-3).month() + '/' + dateflag.adddays(-3).day();
        newwrap.col9 = dateflag.adddays(-2).format('E') + ' ' + dateflag.adddays(-2).month() + '/' + dateflag.adddays(-2).day();
        newwrap.col11 = dateflag.adddays(-1).format('E') + ' ' + dateflag.adddays(-1).month() + '/' + dateflag.adddays(-1).day();
        newwrap.col13 = dateflag.format('E') + ' ' + dateflag.month() + '/' + dateflag.day();
        wrap.add(newwrap);
        
        List<file_transmission_log__c> ftl = [select recordtype.name,effective_start_date__c,sla_met__c,file_sent_time__c,Contractual_SLA__c ,client_processing_deadline__c from file_transmission_log__c where effective_start_date__c in: weekdates];
        system.debug('>>'+ftl);
        Map<string,map<date,list<file_transmission_log__c>>> ftlmap = new Map<string,map<date,list<file_transmission_log__c>>>();
        
        for(file_transmission_log__c eachftl : ftl){
            if(!ftlmap.containskey(eachftl.recordtype.name))
                ftlmap.put(eachftl.recordtype.name,new map<date,List<file_transmission_log__c>>{eachftl.effective_start_date__c => new list<file_transmission_log__c>{eachftl}});
            else{
                List<file_transmission_log__c> templist = ftlmap.get(eachftl.recordtype.name).get(eachftl.effective_start_date__c);
                system.debug('@@ '+templist);
                if(templist == null)
                    templist = new list<file_transmission_log__c>();
                    templist.add(eachftl);
                ftlmap.get(eachftl.recordtype.name).put(eachftl.effective_start_date__c,templist);
            }
        }
        
        for(string str : ftlmap.keyset()){
            newwrap = new wrapclass('','','','','','','','','','','','','','','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6','#F4F6F6');
            for(date dt: ftlmap.get(str).keyset()){
                integer j = 0;
                integer i = colcount.get(dt);
                for(file_transmission_log__c eachftl : ftlmap.get(str).get(dt)){
                    if(eachftl.file_sent_time__c < eachftl.client_processing_deadline__c & eachftl.Recordtype.name !='Payroll')
                        j++;
                    if(eachftl.File_Sent_Time__c < eachftl.Contractual_SLA__c & eachftl.Recordtype.name =='Payroll')
                        j++;
                }
                
                if(i == 1){
                    newwrap.col1 = str;
                    newwrap.col2 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg1 = '#2ECC71';
                    else
                        newwrap.bg1 = '#CA6F1E';
                }
                if(i == 3){
                    newwrap.col3 = str;
                    newwrap.col4 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg2 = '#CA6F1E';    
                    else
                        newwrap.bg2 = '#2ECC71';
                }
                if(i == 5){
                    newwrap.col5 = str;
                    newwrap.col6 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg3 = '#CA6F1E';    
                    else
                        newwrap.bg3 = '#2ECC71';
                }
                if(i == 7){
                    newwrap.col7 = str;
                    newwrap.col8 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg4 = '#CA6F1E';    
                    else
                        newwrap.bg4 = '#2ECC71';
                }
                if(i == 9){
                    newwrap.col9 = str;
                    newwrap.col10 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg5 = '#CA6F1E';    
                    else
                        newwrap.bg5 = '#2ECC71';
                }
                if(i == 11){
                    newwrap.col11 = str;
                    newwrap.col12 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg6 = '#CA6F1E';    
                    else
                        newwrap.bg6 = '#2ECC71';
                }
                if(i == 13){
                    newwrap.col13 = str;
                    newwrap.col14 = string.valueof(ftlmap.get(str).get(dt).size())+'/'+string.valueof(j);
                    if(j == 0)
                        newwrap.bg7 = '#CA6F1E';    
                    else
                        newwrap.bg7 = '#2ECC71';
                }
            }
            wrap.add(newwrap);
        }
        
        for(wrapclass wp : wrap){
            system.debug(wp);
        }
        
        return wrap;
    }

    public class wrapclass{
    
        public string col1{get;set;}
        public string col2{get;set;}
        public string col3{get;set;}
        public string col4{get;set;}
        public string col5{get;set;}
        public string col6{get;set;}
        public string col7{get;set;}
        public string col8{get;set;}
        public string col9{get;set;}
        public string col10{get;set;}
        public string col11{get;set;}
        public string col12{get;set;}
        public string col13{get;set;}
        public string col14{get;set;}
        public string bg1{get;set;}
        public string bg2{get;set;}
        public string bg3{get;set;}
        public string bg4{get;set;}
        public string bg5{get;set;}
        public string bg6{get;set;}
        public string bg7{get;set;}
        
        public wrapclass(string col1, string col2, string col3, string col4, string col5, string col6, string col7,string col8, string col9, string col10, string col11, string col12, string col13, string col14, string bg1,string bg2,string bg3,string bg4,string bg5,string bg6,string bg7){
            this.col1 = col1;
            this.col2 = col2;
            this.col3 = col3;
            this.col4 = col4;
            this.col5 = col5;
            this.col6 = col6;
            this.col7 = col7;
            this.col8 = col8;
            this.col9 = col9;
            this.col10 = col10;
            this.col11 = col11;
            this.col12 = col12;
            this.col13 = col13;
            this.col14 = col14;
            this.bg1 = bg1;
            this.bg2 = bg2;
            this.bg3 = bg3;
            this.bg4 = bg4;
            this.bg5 = bg5;
            this.bg6 = bg6;
            this.bg7 = bg7;
        }
    }
    
    public PageReference hideorshow(){
        if(showhide.get(rec))
            showhide.put(rec,false);
        else
            showhide.put(rec,true);
            
        system.debug(showhide);
        return null;
    }    
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() { 
      
        soql = 'select Name,effective_start_date__c, destination__c, file_name__c, file_type__c,Date_and_Time_Ran__c,Status__c,File_Sent_Time__c from file_transmission_log__c where Name!= null';
        runQuery();
        showhide = new map<string,boolean>();
        dateval = apexpages.currentpage().getparameters().get('dateval');
        system.debug(dateval);
        effectivedate = Date.newInstance(system.today().year(),integer.valueof(dateval.substringafter(' ').substringbefore('/')),integer.valueof(dateval.substringafter('/')));
        DateTime dt=DateTime.newInstance(effectivedate, Time.newInstance(0, 0, 0, 0));
        title = dt.format('EEEE')+' '+dt.format('MMMMM')+' '+effectivedate.day()+','+' '+effectivedate.year();
        system.debug('+++ '+effectivedate);
        ftl = new Map<string,List<file_transmission_log__c>>();
        getrecords1();
    
        displayPopup = true;    
    }
    
     public Map<string,List<file_transmission_log__c>> getrecords1(){
      ftllist = [select recordtype.name, effective_start_date__c, destination__c, file_name__c,Rating__c, file_type__c,client_processing_deadline__c,Status__c,File_Sent_Time__c from file_transmission_log__c where effective_start_date__c =: effectivedate];
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