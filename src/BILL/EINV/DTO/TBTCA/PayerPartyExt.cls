Class BILL.EINV.DTO.TBTCA.PayerPartyExt Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 病人信息 Id
Property SickId As %String(XMLPROJECTION = "ELEMENT");

/// 卡号信息
Property CardInfos As BILL.EINV.DTO.TBTCA.CardInfos(XMLPROJECTION = "ELEMENT");

}
