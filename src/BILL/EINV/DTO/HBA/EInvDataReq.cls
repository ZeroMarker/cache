Class BILL.EINV.DTO.HBA.EInvDataReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property dataDescription As BILL.EINV.DTO.HBA.EInvdataDescription(CAPTION = "数据描述", XMLNAME = "dataDescription");

// Property content As %String(CAPTION = "请求数据内容或返回数据内容", XMLNAME = "content");

Property content As BILL.EINV.DTO.HBA.EINVFPKJReq(CAPTION = "请求数据内容或返回数据内容", XMLNAME = "content");

// Property content As BILL.EINV.DTO.HBA.EReqComFPKJ(CAPTION = "请求数据内容或返回数据内容", XMLNAME = "content");

}
