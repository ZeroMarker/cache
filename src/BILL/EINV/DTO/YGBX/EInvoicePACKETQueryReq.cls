Class BILL.EINV.DTO.YGBX.EInvoicePACKETQueryReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLNAME = "PACKET";

Property type As %String(XMLPROJECTION = "ATTRIBUTE");

Property version As %String(XMLPROJECTION = "ATTRIBUTE");

Property FPDM As %String(XMLNAME = "FPDM", XMLPROJECTION = "ELEMENT");

Property FPHM As %String(XMLNAME = "FPHM", XMLPROJECTION = "ELEMENT");

}
