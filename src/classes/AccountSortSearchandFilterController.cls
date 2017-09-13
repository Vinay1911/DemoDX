public class AccountSortSearchandFilterController {
    //Variables
    private String soql {get;set;}
    public String searchText { get; set; }
    public Id selectedAccountId { get; set; }  
    
    public String selectedAccountName { get; set; }   
    public boolean bPortal {get; set;}
    public boolean bPortalDirect {get; set;}
    
    public List<Account> accounts { get; set; }   
    
    //public List<Id> listAttachmentID { get; set;}    
    
        public AccountSortSearchandFilterController()
        {         
            
            soql = 'select Name,Phone,Type from Account where Name != null';
            runQuery();
            searchText = '';
            bPortal = false;
            bPortalDirect = false;
            selectedAccountName = '';        
            
            accounts = new List<Account>();
            
            Map<String,String> mapParameter = apexpages.currentpage().getparameters();
            
            if(mapParameter != null && !mapParameter.isEmpty()) {
                String sPortal = mapParameter.get('portal');
                if(String.isNotBlank(sPortal)) {
                    bPortalDirect = true;
                }
                
            }
            
        }
        
        public List<Account> getAccountsForViewer( String accountSearchTermIn )
        {
                if( String.isBlank( accountSearchTermIn ) || accountSearchTermIn.length() < 2)
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, 'Please enter at least two characters!!');
                    ApexPages.addmessage(msg);  
                    return accounts; 
                }
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Accounts);
            
            String queryString = 'SELECT Id, Name,phone,Type FROM Account WHERE Name!= NULL';
            queryString += ' AND Name LIKE \'%' + accountSearchTermIn + '%\' ';
            List<Account> accList = new List<Account>();
            accList = Database.query( queryString );     
            
                if(accList.size() <= 0)
                {
                    
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'No records found for the entered  search criteria!!');
                    ApexPages.addmessage(msg);  
                    accList = new List<Account>();
                    
                } 
            selectedAccountId = null;
            accounts.clear();                
            return accList;
        
        }
        
        public void resetAccounts()
        {
            searchText = '';
            
            selectedAccountId = null;
            accounts.clear();
            
        }
        
        public void search()
        {
            accounts = getAccountsForViewer(searchText);
            
        }
        
        // the current sort direction. defaults to asc
        public String sortDir {
            get { if (sortDir == null) { sortDir = 'asc'; } return sortDir; }
            set;
        }
        
        // the current field to sort by. defaults to Name
        public String sortField {
            get { if (sortField == null) {sortField = 'Name'; } return sortField; }
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
                
                //ApexPages.StandardSetController sscAccounts = new ApexPages.StandardSetController(Accounts);
              ApexPages.StandardSetController sscAccounts = new ApexPages.StandardSetController(Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
            }
            
        }
        
}