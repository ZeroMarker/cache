/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:单张发票信息
Class web.DHCEntity.PCA.Invoice Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// HIS交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 发票表Rowid
Property InvoiceNO As %String(TRUNCATE = 1);

/// 单张发票表金额
Property InvoiceAmt As %String(TRUNCATE = 1);

/// 发药窗口信息
Property PrescWindow As %String(TRUNCATE = 1);

/// 发票扩展信息
Property InvocieExpStr As %String(TRUNCATE = 1);

}
