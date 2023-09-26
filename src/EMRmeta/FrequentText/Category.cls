/// 自定义分类 - 病种的子分类
Class EMRmeta.FrequentText.Category Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String;

Property Sequence As %Integer;

Property DiseaseID As %String;

Index IdxDiseaseIDSeq On (DiseaseID, Sequence);

Storage Default
{
<Data name="CategoryDefaultData">
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
<Value name="5">
<Value>DiseaseID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.FreqTxt.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.FreqTxt.CategoryD</IdLocation>
<IndexLocation>^DHCEMRM.FreqTxt.CategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.FreqTxt.CategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
