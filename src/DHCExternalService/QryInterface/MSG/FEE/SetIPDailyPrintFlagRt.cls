Class DHCExternalService.QryInterface.MSG.FEE.SetIPDailyPrintFlagRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property CardTypeCode As %String(TRUNCATE = 1);

Property CardNo As %String(MAXLEN = 20, TRUNCATE = 1);

Property SecrityNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property BillNo As %String(TRUNCATE = 1);

Property QueryDate As %String(TRUNCATE = 1);

Property PrintFlag As %String(TRUNCATE = 1);

}
