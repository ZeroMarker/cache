/// Desc:用以组织查询操作员打印收费日结
Class DHCEPRFS.Entity.EQueryPrintDaily Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// 代码
Property UserID As %String(TRUNCATE = 1);

/// 名称
Property UserName As %String(TRUNCATE = 1);

/// 结算日期
Property FootDate As %String;

/// 起始发票号
Property StartInvoiceNo As %String;

/// 截止发票号
Property EndInvoiceNo As %String;

/// 笔数
Property Count As %Integer;

/// 正常笔数
Property NormalCount As %Integer;

/// 作废笔数
Property CancelCount As %Integer;

/// 金额
Property Amount As %Float;

/// 作废金额
Property CancelAmount As %Float;

/// 发票张数
Property InvoiceCount As %Integer;

/// 作废发票张数
Property CancelInvoiceCount As %Integer;

/// 作废发票号
Property CancelInvoices As %String;

}
