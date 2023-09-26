Class BILL.EINV.DTO.BWA.PResComBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 返回代码
Property returncode As %String(XMLPROJECTION = "ELEMENT");

/// 返回信息
Property returnmsg As %String(XMLPROJECTION = "ELEMENT");

/// 返回数据
Property returndata As BILL.EINV.DTO.BWA.PInvResultData(XMLPROJECTION = "ELEMENT");

}
