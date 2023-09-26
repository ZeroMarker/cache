Class web.DHCST.SoapModel.AdrRepProc Extends %Persistent
{

Parameter XMLNAME = "child";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ADRRPTherapMeas As %String(TRUNCATE = 1);

Property ADRRPSymptom As %String(TRUNCATE = 1);

Property ADRRPOtherExplanation As %String(TRUNCATE = 1);

Property ADRRPProcessDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdrRepProcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ADRRPTherapMeas</Value>
</Value>
<Value name="3">
<Value>ADRRPSymptom</Value>
</Value>
<Value name="4">
<Value>ADRRPOtherExplanation</Value>
</Value>
<Value name="5">
<Value>ADRRPProcessDesc</Value>
</Value>
</Data>
<DataLocation>^web.DHCST.SoapM693C.AdrRepProcD</DataLocation>
<DefaultData>AdrRepProcDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCST.SoapM693C.AdrRepProcD</IdLocation>
<IndexLocation>^web.DHCST.SoapM693C.AdrRepProcI</IndexLocation>
<StreamLocation>^web.DHCST.SoapM693C.AdrRepProcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
