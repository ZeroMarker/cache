/// 订单项目信息
Class BILL.EINV.DTO.HBA.EComFPKJDDMXXXS Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property size As %String(XMLPROJECTION = "ATTRIBUTE");

Property EComFPKJDDMXXX As list Of BILL.EINV.DTO.HBA.EComFPKJDDMXXX(XMLNAME = "FPKJXX_DDMXXX", XMLPROJECTION = "ELEMENT");

}
