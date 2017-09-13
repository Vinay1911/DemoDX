public class AccountController {
    @AuraEnabled
    public list<Account> getAccounts(){
        return[select id,name,AccountNumber,Active__C,Checked__c,SLAExpirationDate__c from Account];
}

}