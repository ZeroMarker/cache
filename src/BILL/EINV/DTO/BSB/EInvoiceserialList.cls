/// 开票明细信息
Class BILL.EINV.DTO.BSB.EInvoiceserialList Extends %RegisteredObject
{

/// busNo	流水号	String	32	是	全局唯一
Property busNo As %String(TRUNCATE = 1, XMLNAME = "busNo");

/// chargeDate	收费日期	String	10	是	格式：yyyy-MM-dd
Property chargeDate As %String(TRUNCATE = 1, XMLNAME = "chargeDate");

/// agencyTaxNum	单位税号	String	20	是
Property agencyTaxNum As %String(TRUNCATE = 1, XMLNAME = "agencyTaxNum");

/// invoiceType	发票类型	String	2	是	0-电子票
Property invoiceType As %String(TRUNCATE = 1, XMLNAME = "invoiceType");

/// payer	交款人	String	100	是
Property payer As %String(TRUNCATE = 1, XMLNAME = "payer");

/// payerPhone	发票接收手机号	String	11	否	交付信息
Property payerPhone As %String(TRUNCATE = 1, XMLNAME = "payerPhone");

/// payerEmail	发票接收邮箱	String	64	否
Property payerEmail As %String(TRUNCATE = 1, XMLNAME = "payerEmail");

/// payerCode	交款人用户编号	String	100	是	确定交款人唯一业务身份的编号（身份证号、学号、报名流水号、车牌号、手机号等）
Property payerCode As %String(TRUNCATE = 1, XMLNAME = "payerCode");

/// chargeType	收费类型	String	2	是	0：收款 1：退款
Property chargeType As %String(TRUNCATE = 1, XMLNAME = "chargeType");

/// department	收费部门名称	String	100	是	
Property department As %String(TRUNCATE = 1, XMLNAME = "department");

/// channel	缴费渠道	String	32	否	渠道中文名或统一编码
Property channel As %String(TRUNCATE = 1, XMLNAME = "channel");

/// channelId	支付账户 id	String	100	否	缴费渠道是微信或者支付宝支付时，传对应的微信 id 或者支付宝id
Property channelId As %String(TRUNCATE = 1, XMLNAME = "channelId");

/// orderId	订单号	String	32	否	支付订单号
Property orderId As %String(TRUNCATE = 1, XMLNAME = "orderId");

/// recer	收款人	String	8	是	
Property recer As %String(TRUNCATE = 1, XMLNAME = "recer");

/// reviewer 复核人	String	8	否	
Property reviewer As %String(TRUNCATE = 1, XMLNAME = "reviewer");

/// operator	开票人	String	8	否	
Property operator As %String(TRUNCATE = 1, XMLNAME = "operator");

/// oldBusNo	原流水号	String	32	否	退款时必填，用于发票冲红填写原发票号码
Property oldBusNo As %String(TRUNCATE = 1, XMLNAME = "oldBusNo");

/// chargeAmt	收费金额	Number	18,2	是
Property chargeAmt As %String(TRUNCATE = 1, XMLNAME = "chargeAmt");

/// buyerName	购方名称	String	100	否
Property buyerName As %String(TRUNCATE = 1, XMLNAME = "buyerName");

/// buyerTaxNum	购方税号	String	20	否
Property buyerTaxNum As %String(TRUNCATE = 1, XMLNAME = "buyerTaxNum");

/// buyerAddress	购方地址	String	85	否	发票抬头信息
Property buyerAddress As %String(TRUNCATE = 1, XMLNAME = "buyerAddress");

/// buyerPhone	购方电话	String	11	否
Property buyerPhone As %String(TRUNCATE = 1, XMLNAME = "buyerPhone");

/// buyerBank	购方开户行	String	80	否
Property buyerBank As %String(TRUNCATE = 1, XMLNAME = "buyerBank");

/// buyerAccount	购方账号	String	18	否
Property buyerAccount As %String(TRUNCATE = 1, XMLNAME = "buyerAccount");

/// remark	备注	String	130	否
Property remark As %String(TRUNCATE = 1, XMLNAME = "remark");

/// extendInfo	扩展信息	JSON	不限	否	业务扩展数据
Property extendInfo As %String(TRUNCATE = 1, XMLNAME = "extendInfo");

/// custom1	发票版式定制字段	String	200	否
Property custom1 As %String(TRUNCATE = 1, XMLNAME = "custom1");

/// custom2	发票版式定制字段	String	200	否	发票定制字段
Property custom2 As %String(TRUNCATE = 1, XMLNAME = "custom2");

/// custom3	发票版式定制字段	String	200	否	
Property custom3 As %String(TRUNCATE = 1, XMLNAME = "custom3");

/// callBackUrl	回调地址	String	500	否	开票成功后的结果通知地址，规范详见：3.2
Property callBackUrl As %String(TRUNCATE = 1, XMLNAME = "callBackUrl");

/// callBackPwd	回调口令	String	100	否	
Property callBackPwd As %String(TRUNCATE = 1, XMLNAME = "callBackPwd");

/// ItemInfos	项目信息	节点	不限	是
Property ItemInfos As list Of BILL.EINV.DTO.BSB.EInvoiceserialItemInfos;

}
