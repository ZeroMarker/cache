/// 查询 接口请求参数
Class BILL.EINV.DTO.HTXXA.EInvQueryReq Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiBasicQueryRequest";

Property HoldSerialBiz As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

}
