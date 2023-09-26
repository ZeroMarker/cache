/// 需要支付记录
Class web.DHCPE.NetPre.Entity.NeedPayRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property Name As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property PayRecords As list Of web.DHCPE.NetPre.Entity.PayRecord;

}
