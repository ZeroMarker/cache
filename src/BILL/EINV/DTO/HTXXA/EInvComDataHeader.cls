/// 公共参数头文件
Class BILL.EINV.DTO.HTXXA.EInvComDataHeader Extends (%RegisteredObject, %XML.Adaptor)
{

Property AppId As %String(CAPTION = "应用id", XMLPROJECTION = "ELEMENT");

Property AppKey As %String(CAPTION = "应用密钥", XMLPROJECTION = "ELEMENT");

Property Version As %String(CAPTION = "接口版本", XMLPROJECTION = "ELEMENT");

Property HuCode As %String(CAPTION = "执收单位编码", XMLPROJECTION = "ELEMENT");

Property Cuscc As %String(CAPTION = "统一社会信用代码", XMLPROJECTION = "ELEMENT");

Property AuthorizeCode As %String(CAPTION = "执收单位授权码", XMLPROJECTION = "ELEMENT");

Property IfName As %String(CAPTION = "接口业务代码", XMLPROJECTION = "ELEMENT");

Property ReqTime As %String(CAPTION = "请求时间", XMLPROJECTION = "ELEMENT");

Property ReqSeq As %String(CAPTION = "请求顺序号", XMLPROJECTION = "ELEMENT");

}
