Class BILL.EINV.DTO.AXNHTA.OPInvoiceRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// invrecordhead
Property invrecordhead As BILL.EINV.DTO.AXNHTA.OPInvoiceRecordHead;

Property invrecorditem As list Of BILL.EINV.DTO.AXNHTA.OPListDetail(CAPTION = "清单项目明细", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="OPInvoiceRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV2530.OPInvoiceRe3CA9D</DataLocation>
<DefaultData>OPInvoiceRecordDefaultData</DefaultData>
<IdLocation>^BILL.EINV2530.OPInvoiceRe3CA9D</IdLocation>
<IndexLocation>^BILL.EINV2530.OPInvoiceRe3CA9I</IndexLocation>
<StreamLocation>^BILL.EINV2530.OPInvoiceRe3CA9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
