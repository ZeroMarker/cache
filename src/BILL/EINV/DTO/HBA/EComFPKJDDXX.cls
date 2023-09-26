/// 开具订单项目信息
Class BILL.EINV.DTO.HBA.EComFPKJDDXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property DDH As %String(CAPTION = "订单号", XMLNAME = "DDH");

Property THDH As %String(CAPTION = "退货单号", XMLNAME = "THDH");

Property DDDATE As %String(CAPTION = "订单时间", XMLNAME = "DDDATE");

}
