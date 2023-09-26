Class DHCBILL.ScanPay.Entity.TSL.ScanTradeInput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// 按接口需要增加字段

/// Property His端名称  XMLNAME  第三方属性名              
/// Property MerchId As %String(TRUNCATE = 1, XMLNAME = "MerchId");
Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = "inputonly";

/// Parameter XMLNAME = "Head";
/// 商户标识	
Property "mch_token" As %String(TRUNCATE = 1);

/// 设备号
Property "device_info" As %String(TRUNCATE = 1);

/// 随机字符串
Property "nonce_str" As %String(TRUNCATE = 1);

///  签名
Property sign As %String(TRUNCATE = 1);

/// 签名类型
Property "sign_type" As %String(TRUNCATE = 1);

/// 商品描述
Property body As %String(TRUNCATE = 1);

/// 商户订单号
Property "out_trade_no" As %String(TRUNCATE = 1);

/// 货币类型
Property "fee_type" As %String(TRUNCATE = 1);

/// 总金额
Property "total_fee" As %String(TRUNCATE = 1);

/// 申请扣款方式
Property "pay_type" As %String(TRUNCATE = 1);

/// 终端IP	
Property "spbill_create_ip" As %String(TRUNCATE = 1);

/// 交易起始时间
Property "time_start" As %String(TRUNCATE = 1);

/// 交易结束时间
Property "time_expire" As %String(TRUNCATE = 1);

/// 指定支付方式
Property "limit_pay" As %String(TRUNCATE = 1);

/// 收银员
Property cashier As %String(TRUNCATE = 1);

/// 附加数据
Property attach As %String(TRUNCATE = 1);

/// 微信订单号
Property "transaction_id" As %String(TRUNCATE = 1);

/// 商户退款单号
Property "out_refund_no" As %String(TRUNCATE = 1);

/// 申请退款金额
Property "refund_fee" As %String(TRUNCATE = 1);

/// 货币种类
Property "refund_fee_type" As %String(TRUNCATE = 1);

/// 授权码（付款码）
Property "auth_code" As %String(TRUNCATE = 1);

/// 开始时间 yyyyy-MM-dd HH:mm:ss
Property "start_date" As %String(TRUNCATE = 1);

/// 结束时间 yyyyy-MM-dd HH:mm:ss
Property "end_date" As %String(TRUNCATE = 1);

}
