Class DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property CardTypeCode As %String(TRUNCATE = 1);

Property CardNo As %String(TRUNCATE = 1);

Property SecrityNo As %String(TRUNCATE = 1);

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property Adm As %String(TRUNCATE = 1);

}
