Class DHCINSU.Model.BJ.INSUFeeitem Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "feeitem          ";

Property itemno As %String(XMLPROJECTION = "ATTRIBUTE");

Property recipeno As %String(XMLPROJECTION = "ATTRIBUTE");

Property hiscode As %String(XMLPROJECTION = "ATTRIBUTE");

Property itemname As %String(XMLPROJECTION = "ATTRIBUTE");

Property itemtype As %String(XMLPROJECTION = "ATTRIBUTE");

Property unitprice As %String(XMLPROJECTION = "ATTRIBUTE");

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property fee As %String(XMLPROJECTION = "ATTRIBUTE");

Property dose As %String(XMLPROJECTION = "ATTRIBUTE");

Property specification As %String(XMLPROJECTION = "ATTRIBUTE");

Property unit As %String(XMLPROJECTION = "ATTRIBUTE");

Property howtouse As %String(XMLPROJECTION = "ATTRIBUTE");

Property dosage As %String(XMLPROJECTION = "ATTRIBUTE");

Property packaging As %String(XMLPROJECTION = "ATTRIBUTE");

Property minpackage As %String(XMLPROJECTION = "ATTRIBUTE");

Property conversion As %String(XMLPROJECTION = "ATTRIBUTE");

Property days As %String(XMLPROJECTION = "ATTRIBUTE");

Property babyflag As %String(XMLPROJECTION = "ATTRIBUTE");

Property drugapprovalnumber As %String(XMLPROJECTION = "ATTRIBUTE");

//output独有

Property feein As %String(XMLPROJECTION = "ATTRIBUTE");

Property feeout As %String(XMLPROJECTION = "ATTRIBUTE");

Property selfpay2 As %String(XMLPROJECTION = "ATTRIBUTE");

Property state As %String(XMLPROJECTION = "ATTRIBUTE");

Property feetype As %String(XMLNAME = "fee_type", XMLPROJECTION = "ATTRIBUTE");

Property preferentialfee As %String(XMLPROJECTION = "ATTRIBUTE");

Property preferentialscale As %String(XMLPROJECTION = "ATTRIBUTE");

Relationship feeitemarray As DHCINSU.Model.BJ.INSUFeeitemarray(XMLNAME = "feeitemarray", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = feeitem ];

Storage Default
{
<Data name="INSUFeeitemState">
<Value name="1">
<Value>itemno</Value>
</Value>
<Value name="2">
<Value>recipeno</Value>
</Value>
<Value name="3">
<Value>hiscode</Value>
</Value>
<Value name="4">
<Value>itemname</Value>
</Value>
<Value name="5">
<Value>itemtype</Value>
</Value>
<Value name="6">
<Value>unitprice</Value>
</Value>
<Value name="7">
<Value>count</Value>
</Value>
<Value name="8">
<Value>fee</Value>
</Value>
<Value name="9">
<Value>dose</Value>
</Value>
<Value name="10">
<Value>specification</Value>
</Value>
<Value name="11">
<Value>unit</Value>
</Value>
<Value name="12">
<Value>howtouse</Value>
</Value>
<Value name="13">
<Value>dosage</Value>
</Value>
<Value name="14">
<Value>packaging</Value>
</Value>
<Value name="15">
<Value>minpackage</Value>
</Value>
<Value name="16">
<Value>conversion</Value>
</Value>
<Value name="17">
<Value>days</Value>
</Value>
<Value name="18">
<Value>babyflag</Value>
</Value>
<Value name="19">
<Value>drugapprovalnumber</Value>
</Value>
</Data>
<State>INSUFeeitemState</State>
<StreamLocation>^DHCINSU.Model.BJ.INSUFeeitemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
