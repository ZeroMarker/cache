/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:自助机结算发票信息类
Class DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ResultContent As %String(TRUNCATE = 1);

/// 发票集合
Property Invoices As list Of DHCExternalService.BillInterface.DHCEntity.Invoice;

}
