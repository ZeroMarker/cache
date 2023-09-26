Class DHCBILL.ScanPay.Entity.HSYT.ScanRefundOut Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Property 第三方属性名  XMLNAME  His端名称 
Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

/// BarTradeNo	唯一流水号
Property IBPHISTradeID As %String(TRUNCATE = 1, XMLNAME = "OutTradeNo");

/// HisTradeNo	His订单
Property IBPRRN As %String(TRUNCATE = 1, XMLNAME = "ThirdCheckNo");

/// 支付宝、微信流水号
Property IBPExtTradeNo As %String(TRUNCATE = 1, XMLNAME = "ThirdRefundNo");

/// IBPTramt	金额
Property IBPTramt As %String(TRUNCATE = 1, XMLNAME = "RefundFee");

/// 扩展参数
Property IBPappendinfo As %String(TRUNCATE = 1, XMLNAME = "ExtendParams");

}
