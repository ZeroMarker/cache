Class BILL.EINV.DTO.TBTCA.ItemResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 有效时间
Property Item As list Of BILL.EINV.DTO.TBTCA.ItemInfo(XMLPROJECTION = "ELEMENT");

}
