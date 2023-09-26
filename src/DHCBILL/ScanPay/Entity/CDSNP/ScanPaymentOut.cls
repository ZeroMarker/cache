Class DHCBILL.ScanPay.Entity.CDSNP.ScanPaymentOut Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Property 第三方属性名  XMLNAME  His端名称 
Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

/// ResultCode	交易结果,错误代码表0000：成功
Property ETPRc As %String(TRUNCATE = 1, XMLNAME = "PayState");

/// ResultContent	对错误/异常的详细描述信息
Property ETPRcDetail As %String(TRUNCATE = 1, XMLNAME = "PayStateDesc");

/// HisTradeNo	His订单
Property ETPHISTradeID As %String(TRUNCATE = 1, XMLNAME = "OutTradeNo");

// Property IBPHISTradeID As %String(TRUNCATE = 1, XMLNAME = "HisOrderNo");

/// BarTradeNo	唯一流水号
Property ETPExtTradeNo As %String(TRUNCATE = 1, XMLNAME = "ThirdTradeNo");

Property ETPRRN As %String(TRUNCATE = 1, XMLNAME = "YuntaiTradeNo");

Property ETPExtDate As %String(TRUNCATE = 1, XMLNAME = "GmtTime");

/// PayAmt	扣款总金额
Property ETPExtAmt As %String(TRUNCATE = 1, XMLNAME = "TradeFee");

/// 支付宝、微信流水号
Property ETPPan As %String(TRUNCATE = 1, XMLNAME = "Buyer");

/// 扩展参数
Property ETPAppendInfo As %String(TRUNCATE = 1, XMLNAME = "ExtendParams");

Property ETPStatus As %String(TRUNCATE = 1, XMLNAME = "OrderState");

}
