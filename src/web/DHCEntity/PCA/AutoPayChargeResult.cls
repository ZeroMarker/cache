/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:自助机结算发票信息类
Class web.DHCEntity.PCA.AutoPayChargeResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// 发票集合
Property Invoices As list Of web.DHCEntity.PCA.Invoice;

}
