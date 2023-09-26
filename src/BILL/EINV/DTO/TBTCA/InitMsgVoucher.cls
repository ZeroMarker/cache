Class BILL.EINV.DTO.TBTCA.InitMsgVoucher Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "Voucher";

Property AppId As %String(XMLPROJECTION = "ELEMENT");

Property AppKey As %String(XMLPROJECTION = "ELEMENT");

/// 开票点编码
Property PlaceCode As %String(XMLPROJECTION = "ELEMENT");

}
