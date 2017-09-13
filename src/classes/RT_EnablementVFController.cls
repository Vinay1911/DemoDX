public class RT_EnablementVFController {

     //Variables
    public String enablementType { get; set; }
    public String hiddenEID { get; set; }
    public String hiddenEnblTypeId { get; set; }
    public String categoryvalues{get;set;}
    public String categoryname{get;set;}
    public String categoryid{get;set;}
    public String deleteSelectedEnb{set;get;}

    //Lists
    public List<RT_Offer__C> offersList { get; set; }
    public List<RT_Benefit_Plan__c > plansList { get; set; }
    public LIst<CategoryWrapper> categoryWrapperList { get; set; }
    public List<RT_Category__c  > categoryList { get; set; }
    public List<RT_Enablement__c> enablementsList { get; set; }
 
    //Maps
    public Map<String,List<CategoryWrapper>> enablementMap {get;set;}
    public Map<String,String> categoryNameValuesMap {get;set;}
    public Map<String,Boolean> KeyExistsMap {get;set;}
    public Map<Id,Integer> countOfEnablementsMap{get;set;} 
   
    //Constructor 
    public  RT_EnablementVFController(){
    
        //Instantiate varibales
        KeyExistsMap          = new Map<String,Boolean>();
        countOfEnablementsMap = new Map<Id,Integer>();
        categoryNameValuesMap = new  Map<String,String> ();
        enablementMap         = new Map<String,List<CategoryWrapper>> ();
        
        //Get all categories
        
        categoryList =  [SELECT id,Name,Category_Name__c, Category_Values__c,Default_value__c FROM RT_Category__c ORDER BY NAME asc  ];
        
        
        //Build id values map for categories
        for(RT_Category__c  c : categoryList )
            
        {
            String cid = c.id;
            categoryNameValuesMap.put(cid.substring(0,15),c.Category_Values__c);
            
         }
        
      
        buildListsForPage();
        
        
    }
    
    
    private Void buildListsForPage(){
    
        //Get All the enablements
        enablementsList = [SELECT Plan__c ,CategoryIds__c ,name,Category__c,Category_Values__c,Offer__r.Name from RT_Enablement__c  order by name asc];
        
        //Build the offer enablement list
        offersList = [SELECT Id,Name FROM RT_Offer__c];
        
        for(RT_Offer__C offer : offersList )
        {
            List<RT_Enablement__c> offerEnabList = new List<RT_Enablement__c >();
            
            for(RT_Enablement__c enbl : enablementsList)
            {
                if(offer.Id == enbl.Offer__c )
                    offerEnabList.add(enbl);
            }
            
            
            if(offerEnabList.size() > 0)
              {
                KeyExistsMap.put(offer.Id,true);
               }
            else
              {
                KeyExistsMap.put(offer.Id,false);
              }
            
            //Add count of enablements for this offer
            countOfEnablementsMap.put(offer.Id,offerEnabList.size());
            getSplitOfEnabCategories(offer.Id,offerEnabList );
        }
        
   
        
        //Build Plan enablement List
        plansList = [SELECT Id,Name FROM RT_Benefit_Plan__c];
       
        for(RT_Benefit_Plan__c plan : plansList )
        {
            
               
            List<RT_Enablement__c> planEnabList = new List<RT_Enablement__c >();
            for(RT_Enablement__c enbl : enablementsList)
            {
                if(plan.Id == enbl.Plan__c )
                    planEnabList.add(enbl);
            }
            
             if(planEnabList.size() > 0)
                {
                 KeyExistsMap.put(plan.Id,true);
                 }
             else
                {
                 KeyExistsMap.put(plan.Id,false);
                }
            
            countOfEnablementsMap.put(plan.Id,planEnabList.size());
            getSplitOfEnabCategories(plan.Id,planEnabList);
        }
    
    }
    
    
    //Get the enablements and add to the Map
    private void   getSplitOfEnabCategories(String typeid,List<RT_Enablement__c> enablist){
        
       categoryWrapperList = new List<CategoryWrapper>(); 
        for(RT_Enablement__c enablement : enablist){
            
             
            CategoryWrapper cwo = new CategoryWrapper(enablement);
            
            categoryWrapperList.add(cwo );
           
            enablementMap.put(typeid,categoryWrapperList);
        }
        
    }
    
    
    
    
    //Insert new enablement after user selects to add
        
    public PageReference insertRow() {
      
        //If there are no categories, there cannot be any enablements
        if(categoryList.size() == 0)
          {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There are no categories available for selection; Please contact admin.'));

              return null;  
            }
        
        //Insert new enablement for specific type Offer / Plan    
        RT_Enablement__c newenblforinsert =  new RT_Enablement__c();
        
        if(enablementType == 'OFFER')
        {
         newenblforinsert.Offer__C= hiddenEnblTypeId ;
        }
        else
        {
            if(enablementType == 'PLAN')
            {
                newenblforinsert.Plan__c = hiddenEnblTypeId ;
            }
            
        }
      
    
        for ( RT_Category__c  category : categoryList )
            
        {
            if(newenblforinsert.Category__c  == null)
                
                newenblforinsert.Category__c  =  category.Category_Name__c ;
            else
              
                newenblforinsert.Category__c  = newenblforinsert.Category__c  + ','+ category.Category_Name__c ;
            
            String i = category.Id;
            if(newenblforinsert.CategoryIds__c == null)
            {
                newenblforinsert.CategoryIds__c = i.substring(0,15);
                
            }
            else
            {  
              newenblforinsert.CategoryIds__c = newenblforinsert.CategoryIds__c+';'+ i.substring(0,15);
                
            }
            
        }
        
        
        newenblforinsert.Category_Values__c = '';
        
        for(Integer count = 0; count < categoryList.size() ; count++)
            
        {  
            if(newenblforinsert.Category_Values__c == '')
                  {
                      newenblforinsert.Category_Values__c = 'All';
                   }
                 else
                 {
                 newenblforinsert.Category_Values__c = newenblforinsert.Category_Values__c+ ';' + 'All' ;
              }
        }
        
       
        
        insert newenblforinsert;
        
        buildListsForPage();
        
     
        PageReference pageRef = page.RT_Enablements;
        pageRef.setRedirect(true);
        //return pageRef;
        
        return null;
        
    }
   
    
    
    
    
    //Update enablement categories after user selection 
    public PageReference updateEnableCategory(){
        
        RT_Enablement__C enabToUpdate = new RT_Enablement__C();
       
        for( RT_Enablement__C enab : enablementsList)
        {
            if(enab.id == hiddenEID)
              {
                  enabToUpdate = enab;
               }
        }
        
        
        String oldIds    = enabToUpdate.CategoryIds__c ;
        String oldValues = enabToUpdate.Category_Values__c ;
       
        List<String> oldValuesList = oldValues.Split(';');
        List<String> oldIdList = oldIds.Split(';');
      
        Map<String,String> valueIdMap = new Map<String,String>();
       
        for(Integer i=0;i < oldIdList.size();i++)
            
        {
            if(  oldIdList[i].trim() == categoryid.trim())
                         {
                   valueIdMap.put(categoryid,categoryvalues);
                 }
            else
                {
                   valueIdMap.put(oldIdList[i], oldValuesList [i]);
                }
            
            
        }
        
        
        String newValues = '';
        String newIds = '';
        string newname = '';
      
        for(String s : valueIdMap.keySet())
            
        {
            if( newValues  == '')
            {
                newValues = valueIdMap.get(s);
            }
            else
            {
                newValues = newValues +';' + valueIdMap.get(s);
            }
            
            
        }
        
        List<String> newIdList =   new List<String>(valueIdMap.keySet());
        
        for(Integer  i = 0; i < newIdList.size(); i ++)
            
        {
            
            if( newIds == '')
            {
                newIds =newIdList[i];
            }
            else
            {
                newIds = newIds +';' + newIdList[i];
                
            }
        }
        
        enabToUpdate.CategoryIds__c = newIds ;
        
        enabToUpdate.Category_Values__c = newValues ;
        
        
        update enabToUpdate;
        
        PageReference pageRef = page.RT_Enablements;
        pageRef.setRedirect(true);
       // return pageRef;
        
        buildListsForPage();
       
       return null;
        
    }
    
   
   public PageReference deleteEnb( )
   {
             
       List<RT_Enablement__c> enbls=[SELECT id, name from RT_Enablement__c where id =:deleteSelectedEnb];
       
       Delete enbls;
       
        buildListsForPage();
       
       
       PageReference pageRef = page.RT_Enablements;
       pageRef.setRedirect(true);
     //  return pageRef;
     
     return null;
        
   }
    
    
   //Wrapper Classes
   
    
    public Class CategoryWrapper {
        
        public String enablementname {get;set;}
        public List<CategorySelectionWrapper> categorySelections {get;set;}
        
        public CategoryWrapper(RT_Enablement__c enablement){
         
            this.enablementname = enablement.Id;
            
            List<String> categoryValuesList = enablement.Category_Values__c.split(';');
            List<String> categoryNamesList = enablement.Category__c.split(',');
            List<String> categoryIds = enablement.CategoryIds__c.split(';');
         
            this.categorySelections = new List<CategorySelectionWrapper>();
            
            integer j;
            for(j=0 ; j < categoryIds.size() ; j++)
                
            {
                CategorySelectionWrapper newcategorySelections = new CategorySelectionWrapper(categoryValuesList[j] ,categoryNamesList[j], categoryIds[j]);
               
                categorySelections.add(newcategorySelections );
            }
            
        }
        
         
     }
     
     public Class CategorySelectionWrapper{
        
        public String categoryValues{get;set;}
        public String categoryName{get;set;}
        public String categoryId {get;set;}
       
        public CategorySelectionWrapper(String categoryValues, String categoryName,String categoryIds){
            
            this.categoryValues = categoryValues.trim() ;
            this.categoryName   = categoryName.trim();
            this.categoryId    = categoryIds.trim() ;
          
            
        }
        
    }
    
}