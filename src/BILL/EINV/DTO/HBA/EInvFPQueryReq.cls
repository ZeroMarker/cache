/// 发票查询对象
Class BILL.EINV.DTO.HBA.EInvFPQueryReq Extends %RegisteredObject
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property DDH As %String(CAPTION = "订单号", XMLNAME = "DDH");

Property FPQQLSH As %String(CAPTION = "发票请求唯一流水号", XMLNAME = "FPQQLSH");

Property DSPTBM As %String(CAPTION = "平台编码", XMLNAME = "DSPTBM");

Property NSRSBH As %String(CAPTION = "纳税人识别号", XMLNAME = "NSRSBH");

Property PDFXZFS As %String(CAPTION = "下载方式", XMLNAME = "PDF_XZFS");

}
