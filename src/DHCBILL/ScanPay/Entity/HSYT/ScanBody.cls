Class DHCBILL.ScanPay.Entity.HSYT.ScanBody Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 按接口需要增加字段
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
/// 产品类型  固定5	
Property ResourceType As %String(TRUNCATE = 1, XMLNAME = "ResourceType");

/// 医院订单号
Property HisOrderNo As %String(TRUNCATE = 1, XMLNAME = "HisOrderNo");

/// 支付流水号
Property OutTradeNo As %String(TRUNCATE = 1, XMLNAME = "OutTradeNo");

/// 付款码
Property AuthCode As %String(TRUNCATE = 1, XMLNAME = "AuthCode");

/// 订单金额
Property TradeFee As %String(TRUNCATE = 1, XMLNAME = "TradeFee");

/// 支付渠道 25支付宝 26微信
Property Channel As %String(TRUNCATE = 1, XMLNAME = "Channel");

/// 订单简述
Property Subject As %String(TRUNCATE = 1, XMLNAME = "Subject");

/// 医院业务类型
Property HisBizType As %String(TRUNCATE = 1, XMLNAME = "HisBizType");

/// 患者姓名
Property PatName As %String(TRUNCATE = 1, XMLNAME = "PatName");

/// 性别
Property PatSex As %String(TRUNCATE = 1, XMLNAME = "PatSex");

/// 年龄	
Property PatAge As %String(TRUNCATE = 1, XMLNAME = "PatAge");

/// 证件类型
Property CertificateType As %String(TRUNCATE = 1, XMLNAME = "CertificateType");

/// 证件号
Property CertificateNo As %String(TRUNCATE = 1, XMLNAME = "CertificateNo");

/// 科室名称
Property DeptName As %String(TRUNCATE = 1, XMLNAME = "DeptName");

/// 医生名称
Property DoctorName As %String(TRUNCATE = 1, XMLNAME = "DoctorName");

/// 扩展参数
Property ExtendParams As %String(TRUNCATE = 1, XMLNAME = "ExtendParams");

/// 支付方式 0：患者扫二维1：窗口扫条码(默认)
Property PayChannel As %String(TRUNCATE = 1, XMLNAME = "PayChannel");

/// 退款金额
Property RefundFee As %String(TRUNCATE = 1, XMLNAME = "RefundFee");

/// 退款流水号
Property ThirdCheckNo As %String(TRUNCATE = 1, XMLNAME = "ThirdCheckNo");

}
