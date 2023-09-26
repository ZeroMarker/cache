/// 发票开具项目信息
Class BILL.EINV.DTO.HBA.EComFPKJXMXXS Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property size As %String(XMLPROJECTION = "ATTRIBUTE");

/// 项目明细信息
Property EComFPKJXMXX As list Of BILL.EINV.DTO.HBA.EComFPKJXMXX(XMLNAME = "FPKJXX_XMXX", XMLPROJECTION = "ELEMENT");

}
