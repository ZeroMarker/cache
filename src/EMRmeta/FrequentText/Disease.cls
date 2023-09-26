/// 病种分类
Class EMRmeta.FrequentText.Disease Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String;

Property Sequence As %Integer;

Property CTLocID As %String;

Index IdxCTLocIDSeq On (CTLocID, Sequence);

Storage Default
{
<Data name="DiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.FreqTxt.DiseaseD</DataLocation>
<DefaultData>DiseaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.FreqTxt.DiseaseD</IdLocation>
<IndexLocation>^DHCEMRM.FreqTxt.DiseaseI</IndexLocation>
<StreamLocation>^DHCEMRM.FreqTxt.DiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
