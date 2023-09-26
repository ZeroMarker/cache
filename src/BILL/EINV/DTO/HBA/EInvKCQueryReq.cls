/// 发票库存查询信息
Class BILL.EINV.DTO.HBA.EInvKCQueryReq Extends %RegisteredObject
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property NSRSBH As %String(CAPTION = "纳税人识别号", XMLNAME = "NSRSBH");

}
