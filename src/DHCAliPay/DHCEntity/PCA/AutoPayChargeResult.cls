Class DHCAliPay.DHCEntity.PCA.AutoPayChargeResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// 发票集合
Property Invoices As list Of DHCAliPay.DHCEntity.PCA.Invoice;

}
