Class DHCEPRFS.INST.MRPatMerge Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MRPatientID As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Relationship TheMRPatMergeList As DHCEPRFS.INST.MRPatMergeList [ Cardinality = children, Inverse = TheMRPatMerge ];

Storage Default
{
<Data name="MRPatMergeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>MRPatientID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPatMergeD</DataLocation>
<DefaultData>MRPatMergeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPatMergeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPatMergeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPatMergeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
