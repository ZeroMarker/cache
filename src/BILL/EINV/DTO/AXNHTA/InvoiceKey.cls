Class BILL.EINV.DTO.AXNHTA.InvoiceKey Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property invkind As BILL.EINV.DTO.AXNHTA.OPInvoiceKind;

/// (发票代码)
Property invcode As %String(CAPTION = "发票代码");

Property invnr As %String(CAPTION = "发票号码");

}
