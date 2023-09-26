Class BILL.EINV.DTO.TBTCA.ItemStands Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 标准编码
Property StandCode As %String(XMLPROJECTION = "ELEMENT");

/// 标准名称
Property StandLowLimit As %String(XMLPROJECTION = "ELEMENT");

/// 标准上限
Property StandName As %String(XMLPROJECTION = "ELEMENT");

/// 标准上限
Property StandUpLimit As %String(XMLPROJECTION = "ELEMENT");

/// 计量单位
Property Unit As %String(XMLPROJECTION = "ELEMENT");

}
