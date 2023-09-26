Class BILL.EINV.DTO.JSD.EInvQueryOnlyData Extends %RegisteredObject
{

Property nsrsbh As %String(CAPTION = "销售方纳税人识别号");

Property ordernum As %String(CAPTION = "业务单据号；必须是唯一的", XMLNAME = "order_num");

Property fpdm As %String(CAPTION = "发票代码", XMLNAME = "fp_dm");

Property fphm As %String(CAPTION = "发票号码", XMLNAME = "fp_hm");

Property jym As %String(CAPTION = " 校验码");

}
