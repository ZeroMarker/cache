/// 富深 上传电子票据明细数据入参对象
Class BILL.EINV.DTO.FSA.EInvDetailsUPReq Extends %RegisteredObject
{

Property Detail As list Of BILL.EINV.DTO.FSA.EInvDetailData(CAPTION = "开票明细");

}
