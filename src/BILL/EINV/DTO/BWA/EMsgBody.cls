/// 电子票据外部报文body节点电一
Class BILL.EINV.DTO.BWA.EMsgBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 应用类型代码
Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

Property input As BILL.EINV.DTO.BWA.EMsgInput(XMLPROJECTION = "ELEMENT");

}
