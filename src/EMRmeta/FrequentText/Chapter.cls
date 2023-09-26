Class EMRmeta.FrequentText.Chapter Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String;

Property Sequence As %Integer;

Property CTLocID As %String;

Index IdxCTLocIDSeq On (CTLocID, Sequence);

Index IdxCTLocIDName On (CTLocID, Name);

//d ##class(EMRmeta.FrequentText.Chapter).%BuildIndices()

Storage Default
{
<Data name="ChapterDefaultData">
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
<DataLocation>^DHCEMRM.FreqTxt.ChapterD</DataLocation>
<DefaultData>ChapterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.FreqTxt.ChapterD</IdLocation>
<IndexLocation>^DHCEMRM.FreqTxt.ChapterI</IndexLocation>
<StreamLocation>^DHCEMRM.FreqTxt.ChapterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
