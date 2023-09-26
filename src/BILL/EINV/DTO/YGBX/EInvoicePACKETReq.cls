Class BILL.EINV.DTO.YGBX.EInvoicePACKETReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLNAME = "PACKET";

Property type As %String(XMLPROJECTION = "ATTRIBUTE");

Property version As %String(XMLPROJECTION = "ATTRIBUTE");

Property MAIN As BILL.EINV.DTO.YGBX.EInvoicePACKETMAINReq(XMLNAME = "MAIN", XMLPROJECTION = "ELEMENT");

}
