Class BILL.EINV.DTO.TBTCA.InvoicingParty Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 开票单位代码
Property InvoicingPartyCode As %String(XMLPROJECTION = "ELEMENT");

/// 开票单位名称
Property InvoicingPartyName As %String(XMLPROJECTION = "ELEMENT");

}
