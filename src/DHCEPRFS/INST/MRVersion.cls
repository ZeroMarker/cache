Class DHCEPRFS.INST.MRVersion Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1);

Property Version As %Integer;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property MRMedRecordID As %String;

/// 版本类型
/// SEALUP--封存
Property Type As %String;

Index IdxUnique On (Version, MREpisodeID, MRMedRecordID) [ Unique ];

Index IdxMain On (MREpisodeID, Version);

Index IdxMRMedRecord On (MRMedRecordID, Version);

Index IdxType On (MREpisodeID, Version, Type);

Storage Default
{
<Data name="MRVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>Version</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>ModifyDate</Value>
</Value>
<Value name="7">
<Value>ModifyTime</Value>
</Value>
<Value name="8">
<Value>MRMedRecordID</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRVersionD</DataLocation>
<DefaultData>MRVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRVersionD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRVersionI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
