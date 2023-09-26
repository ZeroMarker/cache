/// 发票重新推送接口请求参数对象
Class BILL.EINV.DTO.HBA.EInvReInvoiceReq Extends %RegisteredObject
{

Property class As %String(XMLNAME = "REQUEST_FPXXTS_NEW", XMLPROJECTION = "ATTRIBUTE");

Property FPQQLSH As %String(CAPTION = "发票请求唯一流水号", XMLNAME = "FPQQLSH");

Property NSRSBH As %String(CAPTION = "纳税人识别号", XMLNAME = "NSRSBH");

Property FPDM As %String(CAPTION = "发票代码", XMLNAME = "FP_DM");

Property FPHM As %String(CAPTION = "发票号码", XMLNAME = "FP_HM");

Property GHFSJ As %String(CAPTION = "购货方手机", XMLNAME = "GHF_SJ");

Property GHFEMAIL As %String(CAPTION = "购货方邮箱", XMLNAME = "GHF_EMAIL");

}
