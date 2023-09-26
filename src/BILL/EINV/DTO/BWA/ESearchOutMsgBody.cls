Class BILL.EINV.DTO.BWA.ESearchOutMsgBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 应用类型代码
Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

Property input As BILL.EINV.DTO.BWA.ESearchMsgInput(XMLPROJECTION = "ELEMENT");

}
