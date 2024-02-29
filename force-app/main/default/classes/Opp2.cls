public with sharing class Opp2 {
  @AuraEnabled
  public static oppDataWrapper checkOppDuplicate(Id oppId) {
    List<Opportunity> ol = [
      SELECT Id, Email__c, Duplicate__c
      FROM Opportunity
      WHERE Id = :oppId
      WITH USER_MODE
    ];
    String email = ol[0].Email__c;
    List<Opportunity> lstOppty = [
      SELECT Id, Email__c
      FROM Opportunity
      WHERE Id != :oppId AND Email__c != NULL AND Email__c = :email
      WITH USER_MODE
    ];
    /*
        if(!allList.isEmpty()){
            if(ol[0].Duplicate__c == false){
                ol[0].Duplicate__c = true;
                isUpdate = true;
            }
        }else{
            if(ol[0].Duplicate__c == true){
                ol[0].Duplicate__c = false;
                isUpdate = true;
            }
        }
        if(isUpdate)
            Database.update(ol);
    */
    OppDataWrapper odwObj = new OppDataWrapper();
    List<Opportunity> oppListToUpdate = new List<Opportunity>();
    odwObj.isUpdate = false;
    odwObj.isDuplicate = false;
    if (!lstOppty.isEmpty() || (lstOppty.size() > 0)) {
      Opportunity oppObj = new Opportunity();
      oppObj.Id = oppId;

      if (!ol[0].Duplicate__c) {
        system.debug('enter if duplicate true');
        if (
          !Schema.sObjectType.Opportunity.fields.Duplicate__c.isUpdateable()
        ) {
          throw new Exception();
        }
        oppObj.Duplicate__c = true;
        //Siva Changes
        oppListToUpdate.add(oppObj);
        Database.update(oppListToUpdate, false);
        odwObj.isUpdate = true;
      }
      odwObj.isDuplicate = true;
      odwObj.oppList = lstOppty;
      system.debug('odwObj :' + odwObj);
      return odwObj;
    } else {
      if (ol[0].Duplicate__c) {
        //Siva Changes
        Opportunity oppObj = new Opportunity();
        oppObj.Id = oppId;
        if (
          !Schema.sObjectType.Opportunity.fields.Duplicate__c.isUpdateable()
        ) {
          throw new Exception();
        }
        oppObj.Duplicate__c = false;
        oppListToUpdate.add(oppObj);
        Database.update(oppListToUpdate, false);
        odwObj.isUpdate = true;
      }
      //odwObj.isDuplicate = false;
      system.debug('odwObj :' + odwObj);
      return odwObj;
    }
  }

  public class OppDataWrapper {
    @AuraEnabled
    public List<Opportunity> oppList;
    @AuraEnabled
    public Boolean isUpdate;
    @AuraEnabled
    public Boolean isDuplicate;
  }
}
