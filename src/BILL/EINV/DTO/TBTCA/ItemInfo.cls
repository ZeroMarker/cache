Class BILL.EINV.DTO.TBTCA.ItemInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 项目编码
Property ItemCode As %String(XMLPROJECTION = "ELEMENT");

/// 项目名称
Property ItemName As %String(XMLPROJECTION = "ELEMENT");

Property Stands As BILL.EINV.DTO.TBTCA.ItemStands(XMLPROJECTION = "ELEMENT");

}
