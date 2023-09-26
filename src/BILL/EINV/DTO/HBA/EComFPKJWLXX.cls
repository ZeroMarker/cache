/// 物流信息
Class BILL.EINV.DTO.HBA.EComFPKJWLXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property CYGS As %String(CAPTION = "承运公司", XMLNAME = "CYGS");

Property SHSJ As %String(CAPTION = "送货时间", XMLNAME = "SHSJ");

Property WLDH As %String(CAPTION = "物流单号", XMLNAME = "WLDH");

Property SHDZ As %String(CAPTION = "送货地址", XMLNAME = "SHDZ");

}
