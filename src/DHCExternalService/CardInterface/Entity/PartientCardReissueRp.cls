Class DHCExternalService.CardInterface.Entity.PartientCardReissueRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock, SoapBodyUse = literal ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(MAXLEN = 256, TRUNCATE = 1);

Property SecurityNo As %String(TRUNCATE = 1);

}
