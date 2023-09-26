Class DHCEPRFS.INST.MREpisodeRelate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档就诊
Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 关联类型
/// NewBorn - 新生儿  OutPatient - 门诊就诊
Property RelatedType As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 关联归档就诊
Property RelatedMREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index IdxRelatedType On (MREpisodeID, RelatedType);

Index IdxRelatedMREpisodeID On (MREpisodeID, RelatedMREpisodeID);

Index IdxTypeMREpisodeID On (MREpisodeID, RelatedType, RelatedMREpisodeID As Exact);

Storage Default
{
<Data name="MREpisodeRelateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>RelatedType</Value>
</Value>
<Value name="4">
<Value>RelatedMREpisodeID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeRelateD</DataLocation>
<DefaultData>MREpisodeRelateDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MREpisodeRelateD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeRelateI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeRelateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
