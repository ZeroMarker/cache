/// 开票信息返回值
Class BILL.EINV.DTO.BSB.EInvReceiceInfoReq Extends %RegisteredObject
{

/// issueState		开票状态		Number	2	是	1-开票成功，2-开票失败
Property issueState As %String(TRUNCATE = 1, XMLNAME = "issueState");

/// issueDesc		开票描述		String	200	是	开票失败原因
Property issueDesc As %String(TRUNCATE = 1, XMLNAME = "issueDesc");

/// invoiceCode		发票代码		String	12	否	开票状态为开票成功时不为空。
Property invoiceCode As %String(TRUNCATE = 1, XMLNAME = "invoiceCode");

/// invoiceNum		发票号码		String	8	否	
Property invoiceNum As %String(TRUNCATE = 1, XMLNAME = "invoiceNum");

/// checkCode		发票校验码		String	20	否
Property checkCode As %String(TRUNCATE = 1, XMLNAME = "checkCode");

/// invoiceAmt	发票金额（价税合计	Number	18,2	否）			
Property invoiceAmt As %String(TRUNCATE = 1, XMLNAME = "invoiceAmt");

/// invoiceDate	开票日期	String	10	否
Property invoiceDate As %String(TRUNCATE = 1, XMLNAME = "invoiceDate");

}
