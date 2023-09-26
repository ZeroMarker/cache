Class BILL.EINV.DTO.TBTCA.PaperReceiveInfos Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 门诊纸质票据信息
Property CollectionRecord As BILL.EINV.DTO.TBTCA.PaperCollectionRecord(XMLPROJECTION = "ELEMENT");

}
