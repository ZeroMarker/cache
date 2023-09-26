Class DHCExternalService.BillInterface.DHCEntity.PayDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// PaySeqNo	支付小票号HIS生成，唯一
Property ResultCode As %String(TRUNCATE = 1);

/// Charge	*金额
Property ResultContent As %String(TRUNCATE = 1);

Property OEOrdItems As list Of DHCExternalService.BillInterface.DHCEntity.OEOrdItem(XMLITEMNAME = "OEOrdItem", XMLPROJECTION = "COLLECTION");

}
