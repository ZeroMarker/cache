Class DHCExternalService.CardInterface.Entity.OPAcc.ChangeAccountPasswordRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property TerminalID As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property AccountID As %String(TRUNCATE = 1);

Property AccountPassword As %String(TRUNCATE = 1);

Property NewAccountPassword As %String(TRUNCATE = 1);

}
