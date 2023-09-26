/// 返回信息
Class BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Property ReturnCode As %String(CAPTION = "返回码", XMLPROJECTION = "ELEMENT");

Property ReturnMessage As %String(CAPTION = "返回信息", XMLPROJECTION = "ELEMENT");

}
