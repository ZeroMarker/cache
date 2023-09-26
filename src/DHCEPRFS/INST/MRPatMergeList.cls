Class DHCEPRFS.INST.MRPatMergeList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRPatientID As %String(TRUNCATE = 1);

Property MergeDate As %Date;

Property MergeTime As %Time;

Relationship TheMRPatMerge As DHCEPRFS.INST.MRPatMerge [ Cardinality = parent, Inverse = TheMRPatMergeList ];

Storage Default
{
<Data name="MRPatMergeListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPatientID</Value>
</Value>
<Value name="3">
<Value>MergeDate</Value>
</Value>
<Value name="4">
<Value>MergeTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheMRPatMergeList")</DataLocation>
<DefaultData>MRPatMergeListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPatMergeC("TheMRPatMergeList")</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPatMergeListI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPatMergeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
