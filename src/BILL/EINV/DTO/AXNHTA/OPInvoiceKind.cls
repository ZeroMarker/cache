Class BILL.EINV.DTO.AXNHTA.OPInvoiceKind Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property value As %String;

Storage Default
{
<Data name="OPInvoiceKindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>value</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV.DT2530.OPInvoiceKindD</DataLocation>
<DefaultData>OPInvoiceKindDefaultData</DefaultData>
<IdLocation>^BILL.EINV.DT2530.OPInvoiceKindD</IdLocation>
<IndexLocation>^BILL.EINV.DT2530.OPInvoiceKindI</IndexLocation>
<StreamLocation>^BILL.EINV.DT2530.OPInvoiceKindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
