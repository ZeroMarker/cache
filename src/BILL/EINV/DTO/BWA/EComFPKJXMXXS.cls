/// 发票项目明细信息
Class BILL.EINV.DTO.BWA.EComFPKJXMXXS Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property size As %String(XMLPROJECTION = "ATTRIBUTE");

Property ComFPKJXMXX As list Of BILL.EINV.DTO.BWA.EComFPKJXMXX(XMLNAME = "COMMON_FPKJ_XMXX", XMLPROJECTION = "ELEMENT");

}
