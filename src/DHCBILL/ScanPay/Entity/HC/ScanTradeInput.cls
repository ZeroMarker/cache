Class DHCBILL.ScanPay.Entity.HC.ScanTradeInput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
/// 商户ID	
Property ResourceType As %String(TRUNCATE = 1, XMLNAME = "ResourceType");

/// 商户开通用户
Property OutTradeNo As %String(TRUNCATE = 1, XMLNAME = "OutTradeNo");

/// 商户用户密码
Property AuthCode As %String(TRUNCATE = 1, XMLNAME = "AuthCode");

/// TradeType 业务类型
Property TradeFee As %String(TRUNCATE = 1, XMLNAME = "TradeFee");

/// HisTradeNo	His订单
Property Channel As %String(TRUNCATE = 1, XMLNAME = "Channel");

/// 订单支付金额
Property Subject As %String(TRUNCATE = 1, XMLNAME = "Subject");

/// 退款金额
Property HisOrderNo As %String(TRUNCATE = 1, XMLNAME = "HisOrderNo");

/// PayMode	支付方式
Property HisBizType As %String(TRUNCATE = 1, XMLNAME = "HisBizType");

/// TradeMsg	订单简述
Property PatName As %String(TRUNCATE = 1, XMLNAME = "PatName");

/// PatientID	患者主索引
Property PatSex As %String(TRUNCATE = 1, XMLNAME = "PatSex");

/// 病人姓名	
Property PatAge As %String(TRUNCATE = 1, XMLNAME = "PatAge");

Property CertificateType As %String(TRUNCATE = 1, XMLNAME = "CertificateType");

/// PatientAge	年龄
Property CertificateNo As %String(TRUNCATE = 1, XMLNAME = "CertificateNo");

/// 证件类型
Property DeptName As %String(TRUNCATE = 1, XMLNAME = "DeptName");

/// 证件号
Property DoctorName As %String(TRUNCATE = 1, XMLNAME = "DoctorName");

/// 科室名称
Property ExtendParams As %String(TRUNCATE = 1, XMLNAME = "ExtendParams");

/// 医生名称
Property PayChannel As %String(TRUNCATE = 1, XMLNAME = "PayChannel");

/// 补充参数
Property ThirdCheckNo As %String(TRUNCATE = 1, XMLNAME = "ThirdCheckNo");

Property RefundFee As %String(TRUNCATE = 1, XMLNAME = "RefundFee");

}
