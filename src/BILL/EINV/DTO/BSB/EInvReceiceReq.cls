/// 接收开票请求参数
Class BILL.EINV.DTO.BSB.EInvReceiceReq Extends %RegisteredObject
{

/// orgId		机构标识		String	32	是
Property orgId As %String(TRUNCATE = 1, XMLNAME = "orgId");

/// busNo		业务流水号		String	50	是	收费流水转入开票时传入的流水号
Property busNo As %String(TRUNCATE = 1, XMLNAME = "busNo");

/// chargeDate		收费日期		String	10	是	格式：yyyy-MM-dd
Property chargeDate As %String(TRUNCATE = 1, XMLNAME = "chargeDate");

/// taxNum		单位税号		String	20	是
Property taxNum As %String(TRUNCATE = 1, XMLNAME = "taxNum");

/// systemNoise		系统标识		String	32	是
Property systemNoise As %String(TRUNCATE = 1, XMLNAME = "systemNoise");

/// amount		总金额		Number	18,2	是
Property amount As %String(TRUNCATE = 1, XMLNAME = "amount");

/// invoiceInfo		开票信息		节点	不限	是
Property invoiceInfo As BILL.EINV.DTO.BSB.EInvReceiceInfoReq;

/// callBackPwd		回调口令		String	100	否
Property callBackPwd As %String(TRUNCATE = 1, XMLNAME = "callBackPwd");

}
