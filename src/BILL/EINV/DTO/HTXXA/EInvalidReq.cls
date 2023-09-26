/// 红冲参数
Class BILL.EINV.DTO.HTXXA.EInvalidReq Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiCancelRequest";

Property HoldSerialBiz As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

Property PlaceCode As %String(CAPTION = "开票点编码", XMLPROJECTION = "ELEMENT");

Property CancelDate As %String(CAPTION = "冲红时间", XMLPROJECTION = "ELEMENT");

Property BillState As %String(CAPTION = "业务类型", XMLPROJECTION = "ELEMENT");

Property Reason As %String(CAPTION = "冲红原因", XMLPROJECTION = "ELEMENT");

Property IsLost As %String(CAPTION = "是否遗失", XMLPROJECTION = "ELEMENT");

}
