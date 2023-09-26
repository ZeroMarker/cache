Class BILL.EINV.DTO.AXNHTA.OPInvoiceRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property sendbackinv As BILL.EINV.DTO.AXNHTA.SendBackInv;

Storage Default
{
<Data name="OPInvoiceResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>machinetaxnr</Value>
</Value>
<Value name="3">
<Value>machinenr</Value>
</Value>
<Value name="4">
<Value>invkind</Value>
</Value>
<Value name="5">
<Value>doctype</Value>
</Value>
<Value name="6">
<Value>docnr</Value>
</Value>
<Value name="7">
<Value>docdate</Value>
</Value>
<Value name="8">
<Value>custnr</Value>
</Value>
<Value name="9">
<Value>custname</Value>
</Value>
<Value name="10">
<Value>custtaxnr</Value>
</Value>
<Value name="11">
<Value>custaddrtel</Value>
</Value>
<Value name="12">
<Value>custbankacct</Value>
</Value>
<Value name="13">
<Value>memo</Value>
</Value>
<Value name="14">
<Value>memo2</Value>
</Value>
<Value name="15">
<Value>refinvcode</Value>
</Value>
<Value name="16">
<Value>refinvnr</Value>
</Value>
<Value name="17">
<Value>rednoticenr</Value>
</Value>
<Value name="18">
<Value>issuer</Value>
</Value>
<Value name="19">
<Value>checker</Value>
</Value>
<Value name="20">
<Value>payee</Value>
</Value>
<Value name="21">
<Value>sellerbankacct</Value>
</Value>
<Value name="22">
<Value>selleraddresstel</Value>
</Value>
<Value name="23">
<Value>consignerName</Value>
</Value>
<Value name="24">
<Value>consignerTaxNr</Value>
</Value>
<Value name="25">
<Value>shipperName</Value>
</Value>
<Value name="26">
<Value>shipperTaxNr</Value>
</Value>
<Value name="27">
<Value>originViaArrivalPlace</Value>
</Value>
<Value name="28">
<Value>vehicleKindNo</Value>
</Value>
<Value name="29">
<Value>vehicleTonnage</Value>
</Value>
<Value name="30">
<Value>freightMemo</Value>
</Value>
<Value name="31">
<Value>taxdeduction</Value>
</Value>
<Value name="32">
<Value>listName</Value>
</Value>
<Value name="33">
<Value>emails</Value>
</Value>
<Value name="34">
<Value>invrecorditem</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV.DTO2530.OPInvoiceResD</DataLocation>
<DefaultData>OPInvoiceResDefaultData</DefaultData>
<IdLocation>^BILL.EINV.DTO2530.OPInvoiceResD</IdLocation>
<IndexLocation>^BILL.EINV.DTO2530.OPInvoiceResI</IndexLocation>
<StreamLocation>^BILL.EINV.DTO2530.OPInvoiceResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
