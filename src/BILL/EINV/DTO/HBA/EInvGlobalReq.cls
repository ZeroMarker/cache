Class BILL.EINV.DTO.HBA.EInvGlobalReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// (0:B/S请求来源；1:C/S请求来源)	
Property terminalCode As %String(CAPTION = "终端类型标识", XMLNAME = "terminalCode");

Property appId As %String(CAPTION = "业务服务的编码", XMLNAME = "appId");

Property version As %String(CAPTION = "接口版本", XMLNAME = "version");

Property interfaceCode As %String(CAPTION = "接口编码", XMLNAME = "interfaceCode");

Property userName As %String(CAPTION = "平台编码", XMLNAME = "userName");

/// ({(10位随机数+userName）MD5（小写16位）})
Property passWord As %String(CAPTION = "10位随机数+Base64", XMLNAME = "passWord");

Property taxpayerId As %String(CAPTION = "纳税人识别号", XMLNAME = "taxpayerId");

Property authorizationCode As %String(CAPTION = "接入系统平台授权码", XMLNAME = "authorizationCode");

Property requestCode As %String(CAPTION = "数据交换请求发出方代码", XMLNAME = "requestCode");

Property requestTime As %String(CAPTION = "数据交换请求发出时间", XMLNAME = "requestTime");

Property responseCode As %String(CAPTION = "数据交换请求接受方代码", XMLNAME = "responseCode");

Property dataExchangeId As %String(CAPTION = "数据交换流水号", XMLNAME = "dataExchangeId");

Property fjh As %String(CAPTION = "分机号", XMLNAME = "fjh");

Property jqbh As %String(CAPTION = "机器编号", XMLNAME = "jqbh");

Property ygid As %String(CAPTION = "员工id", XMLNAME = "ygid");

}
