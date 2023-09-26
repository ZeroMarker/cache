Class BILL.EINV.DTO.TBTCA.CardInfos Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 卡号信息
Property CardInfo As BILL.EINV.DTO.TBTCA.CardInfo(XMLPROJECTION = "ELEMENT");

// Property CardInfo As list Of BILL.EINV.DTO.TBTCA.CardInfo;

}
