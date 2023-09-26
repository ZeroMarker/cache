Class DHCBILL.ScanPay.Entity.HSYT.ScanHead Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
/// 安全校验码
Property SecurityCode As %String(TRUNCATE = 1, XMLNAME = "SecurityCode");

/// 服务接口名	
Property BizName As %String(TRUNCATE = 1, XMLNAME = "BizName");

/// 请求方发送请求的唯一流水号，由请求方生成，应答方不保存，应答方原样返回。
Property RequestSn As %String(TRUNCATE = 1, XMLNAME = "RequestSn");

/// 错误代码
Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

/// 错误提示
Property ErrorMsg As %String(TRUNCATE = 1, XMLNAME = "ErrorMsg");

}
