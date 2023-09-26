/// 发票查询返回值对象
Class BILL.EINV.DTO.HBA.EInvFPQueryRes Extends %RegisteredObject
{

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property FPQQLSH As %String(CAPTION = "发票请求唯一流水号", XMLNAME = "FPQQLSH");

Property FPDM As %String(CAPTION = "发票代码", XMLNAME = "FP_DM");

Property FPHM As %String(CAPTION = "发票号码", XMLNAME = "FP_HM");

Property KPRQ As %String(CAPTION = "开票日期", XMLNAME = "KPRQ");

Property PDFURL As %String(CAPTION = "PDF下载路径", XMLNAME = "PDF_URL");

Property GHFMC As %String(CAPTION = "购货方名称", XMLNAME = "GHFMC");

Property GHFNSRSBZ As %String(CAPTION = "购货方纳税人识别号", XMLNAME = "GHF_NSRSBZ");

Property GHFDZ As %String(CAPTION = "购货方地址", XMLNAME = "GHF_DZ");

Property GHFGDDH As %String(CAPTION = "购货方固定电话", XMLNAME = "GHF_GDDH");

Property GHFSJ As %String(CAPTION = "购货方手机号", XMLNAME = "GHF_SJ");

Property GHFYHZH As %String(CAPTION = "购货方银行账号", XMLNAME = "GHF_YHZH");

Property RETURNCODE As %String(CAPTION = "结果代码", XMLNAME = "RETURNCODE");

Property RETURNMSG As %String(CAPTION = "结果描述", XMLNAME = "RETURNMSG");

}
