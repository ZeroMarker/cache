Class BILL.EINV.DTO.TBTCA.PlaceCodeQryMsgPlaceInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 开票点编码
Property PlaceCode As %String(XMLPROJECTION = "ELEMENT");

/// 开票点名称
Property PlaceName As %String(XMLPROJECTION = "ELEMENT");

/// 开票点级次
Property Level As %String(XMLPROJECTION = "ELEMENT");

/// 是否有效
Property ValidFlag As %String(XMLPROJECTION = "ELEMENT");

}
