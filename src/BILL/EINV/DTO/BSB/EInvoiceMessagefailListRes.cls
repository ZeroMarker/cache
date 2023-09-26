Class BILL.EINV.DTO.BSB.EInvoiceMessagefailListRes Extends %RegisteredObject
{

/// busNo	流水号	String	32	是	全局唯一
Property busNo As %String(TRUNCATE = 1, XMLNAME = "busNo");

/// payer	交款人	String	100	是	
Property payer As %String(TRUNCATE = 1, XMLNAME = "payer");

/// chargeAmt	收费金额	Number	18,2	是	
Property chargeAmt As %String(TRUNCATE = 1, XMLNAME = "chargeAmt");

/// reason	失败原因	String	200	是
Property reason As %String(TRUNCATE = 1, XMLNAME = "reason");

}
