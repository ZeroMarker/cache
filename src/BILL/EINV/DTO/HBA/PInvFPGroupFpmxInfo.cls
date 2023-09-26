/// 发票明细数据
Class BILL.EINV.DTO.HBA.PInvFPGroupFpmxInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property SPMC As %String(CAPTION = "商品名称", XMLNAME = "SPMC");

Property HSBZ As %String(CAPTION = "含税标志", XMLNAME = "HSBZ");

Property SLV As %String(CAPTION = "税率", XMLNAME = "SLV");

Property JE As %String(CAPTION = "金额", XMLNAME = "JE");

Property DJ As %String(CAPTION = "单价", XMLNAME = "DJ");

Property JLDW As %String(CAPTION = "计量单位", XMLNAME = "JLDW");

Property GGXH As %String(CAPTION = "规格型号", XMLNAME = "GGXH");

Property SE As %String(CAPTION = "税额", XMLNAME = "SE");

Property SL As %String(CAPTION = "数量", XMLNAME = "SL");

Property BMBBH As %String(CAPTION = "编码版本号", XMLNAME = "BMBBH");

Property SSFLBM As %String(CAPTION = "税收分类编码", XMLNAME = "SSFLBM");

Property YHZC As %String(CAPTION = "是否享受优惠政策", XMLNAME = "YHZC");

Property YHZCNR As %String(CAPTION = "享受优惠政策内容", XMLNAME = "YHZCNR");

Property LSLBS As %String(CAPTION = "零税率标识", XMLNAME = "LSLBS");

Property QYZBM As %String(CAPTION = "企业自编码", XMLNAME = "QYZBM");

Property KCE As %String(CAPTION = "扣除额", XMLNAME = "KCE");

}
