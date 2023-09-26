/// 查询返回message信息
Class BILL.EINV.DTO.BSB.EInvoiceQuerymessageRes Extends %RegisteredObject
{

/// chargeDate	收费日期	String	10	是   ///格式：yyyy-MM-dd
Property chargeDate As %String(CAPTION = "收费日期");

/// agencyTaxNum	单位税号	String	20	是
Property agencyTaxNum As %String(CAPTION = "单位税号");

/// systemNoise	系统标识	String	32	是
Property systemNoise As %String(CAPTION = "系统标识");

/// busNo	流水号	String	32	是       ///收费流水转入开票时传入的流水号
Property busNo As %String(CAPTION = "流水号");

/// payer	交款人	String	100	是
Property payer As %String(CAPTION = "交款人");

/// chargeAmt	收费金额	Number	18,2	是
Property chargeAmt As %String(CAPTION = "收费金额");

/// state	开票状态	Number	2	是    ///0-待处理，1-开票中，2-开票成功，3-开票失败 
Property state As %String(CAPTION = "开票状态");

/// desc	开票描述	String	200	是        ///开票失败原因
Property desc As %String(CAPTION = "开票描述");

/// invoiceCode	发票代码	String	12	否   ///开票状态为开票成功时不为空。
Property invoiceCode As %String(CAPTION = "发票代码");

/// invoiceNum	发票号码	String	8	否
Property invoiceNum As %String(CAPTION = "发票号码");

/// checkCode	发票校验码	String	20	否
Property checkCode As %String(CAPTION = "发票校验码");

/// invoiceAmt	发票金额（价税合计）	Number	18,2	否
Property invoiceAmt As %String(CAPTION = "发票金额（价税合计）");

}
