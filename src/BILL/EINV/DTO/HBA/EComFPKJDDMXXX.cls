/// 订单项目明细信息
Class BILL.EINV.DTO.HBA.EComFPKJDDMXXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property DDMC As %String(CAPTION = "订单名称", XMLNAME = "DDMC");

Property DW As %String(CAPTION = "单位", XMLNAME = "DW");

Property GGXH As %String(CAPTION = "规格型号", XMLNAME = "GGXH");

Property SL As %String(CAPTION = "数量", XMLNAME = "SL");

Property DJ As %String(CAPTION = "单价", XMLNAME = "DJ");

Property JE As %String(CAPTION = "金额", XMLNAME = "JE");

Property BYZD1 As %String(CAPTION = "备用字段", XMLNAME = "BYZD1");

Property BYZD2 As %String(CAPTION = "备用字段", XMLNAME = "BYZD2");

Property BYZD3 As %String(CAPTION = "备用字段", XMLNAME = "BYZD3");

Property BYZD4 As %String(CAPTION = "备用字段", XMLNAME = "BYZD4");

Property BYZD5 As %String(CAPTION = "备用字段", XMLNAME = "BYZD5");

}
