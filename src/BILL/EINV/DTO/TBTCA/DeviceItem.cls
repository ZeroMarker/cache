Class BILL.EINV.DTO.TBTCA.DeviceItem Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 设备编码
Property DeviceCode As %String(XMLPROJECTION = "ELEMENT");

/// 设备名称
Property DeviceName As %String(XMLPROJECTION = "ELEMENT");

/// 治疗费用
Property TeachTreatmentCost As %String(XMLPROJECTION = "ELEMENT");

/// 治疗时间
Property TreatmentDate As %String(XMLPROJECTION = "ELEMENT");

}
