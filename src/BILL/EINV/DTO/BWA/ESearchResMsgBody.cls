Class BILL.EINV.DTO.BWA.ESearchResMsgBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 应用类型代码
Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 返回代码
Property returncode As %String(XMLPROJECTION = "ELEMENT");

/// 返回信息
Property returnmsg As %String(XMLPROJECTION = "ELEMENT");

Property returndata As BILL.EINV.DTO.BWA.ESearchResMsgRetData(XMLPROJECTION = "ELEMENT");

}
