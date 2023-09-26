Class BILL.EINV.DTO.AXNHTA.OPInvoiceInv Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property invrecord As BILL.EINV.DTO.AXNHTA.OPInvoiceRecord;

Storage Default
{
<Data name="OPInvoiceInvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>invrecord</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV.DTO2530.OPInvoiceInvD</DataLocation>
<DefaultData>OPInvoiceInvDefaultData</DefaultData>
<IdLocation>^BILL.EINV.DTO2530.OPInvoiceInvD</IdLocation>
<IndexLocation>^BILL.EINV.DTO2530.OPInvoiceInvI</IndexLocation>
<StreamLocation>^BILL.EINV.DTO2530.OPInvoiceInvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
