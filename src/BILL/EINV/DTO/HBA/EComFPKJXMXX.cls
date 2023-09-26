/// 发票明细信息对象
Class BILL.EINV.DTO.HBA.EComFPKJXMXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property XMMC As %String(CAPTION = "项目名称", XMLNAME = "XMMC");

Property XMDW As %String(CAPTION = "项目单位", XMLNAME = "XMDW");

Property GGXH As %String(CAPTION = "规格型号", XMLNAME = "GGXH");

Property XMSL As %String(CAPTION = "项目数量", XMLNAME = "XMSL");

Property HSBZ As %String(CAPTION = "含税标志", XMLNAME = "HSBZ");

Property XMDJ As %String(CAPTION = "项目单价", XMLNAME = "XMDJ");

Property XMBM As %String(CAPTION = "项目编码", XMLNAME = "XMBM");

Property XMJE As %String(CAPTION = "项目金额", XMLNAME = "XMJE");

Property SL As %String(CAPTION = "税率", XMLNAME = "SL");

Property SE As %String(CAPTION = "税额", XMLNAME = "SE");

Property FPHXZ As %String(CAPTION = "发票行性质", XMLNAME = "FPHXZ");

Property SPBM As %String(CAPTION = "商品编码", XMLNAME = "SPBM");

Property ZXBM As %String(CAPTION = "自行编码", XMLNAME = "ZXBM");

Property YHZCBS As %String(CAPTION = "优惠政策标识", XMLNAME = "YHZCBS");

Property LSLBS As %String(CAPTION = "零税率标识", XMLNAME = "LSLBS");

Property ZZSTSGL As %String(CAPTION = "增值税特殊管理", XMLNAME = "ZZSTSGL");

Property BYZD1 As %String(CAPTION = "备用字段", XMLNAME = "BYZD1");

Property BYZD2 As %String(CAPTION = "备用字段", XMLNAME = "BYZD2");

Property BYZD3 As %String(CAPTION = "备用字段", XMLNAME = "BYZD1");

Property BYZD4 As %String(CAPTION = "备用字段", XMLNAME = "BYZD2");

Property BYZD5 As %String(CAPTION = "备用字段", XMLNAME = "BYZD1");

}
