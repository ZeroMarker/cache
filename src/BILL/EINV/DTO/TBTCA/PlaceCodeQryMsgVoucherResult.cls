Class BILL.EINV.DTO.TBTCA.PlaceCodeQryMsgVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Property PlaceInfos As BILL.EINV.DTO.TBTCA.PlaceCodeQryMsgPlaceInfos;

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
