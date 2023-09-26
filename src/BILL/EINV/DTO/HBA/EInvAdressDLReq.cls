/// 电子发票地址下载参数设置
Class BILL.EINV.DTO.HBA.EInvAdressDLReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property NSRSBH As %String(CAPTION = "纳税人识别号", XMLNAME = "NSRSBH");

Property DDH As %String(CAPTION = "订单号", XMLNAME = "DDH");

}
