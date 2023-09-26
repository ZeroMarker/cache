Class web.DHCPE.NetPre.Entity.PayRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// 输出空值元素

Parameter XMLIGNORENULL = 1;

Property RecordID As %String(TRUNCATE = 1, XMLNAME = "admId");

Property CheckDate As %String(TRUNCATE = 1);

Property Amt As %String(TRUNCATE = 1);

Property SetsDesc As %String(TRUNCATE = 1);

Property TotalFee As %String(TRUNCATE = 1);

}
