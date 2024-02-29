public with sharing class OppClass {
  public static void oppMethod() {
    Opportunity o = [SELECT Id FROM Opportunity WITH USER_MODE LIMIT 10];
    System.debug(o);
  }

  public static Opportunity oppMethod(String something) {
    Opportunity op = oppMethod().o;
    if (!Schema.sObjectType.Opportunity.fields.Name.isUpdateable()) {
      return null;
    }
    op.Name += something;
    Database.update(op, false);
    System.debug(op);
    return op;
  }

  public static void oppMethod2() {
    Opportunity opp = oppMethod('Updated');
    System.debug(opp);
  }
}
