Class DHCEPRFS.INST.AdmMRStatusQueue Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 生成标识
/// "0"--没有生成，"1"--生成过
Property CreateFlag As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String;

/// 生成方案类型
Property SchemeType As %String;

Index IdxMain On (CreateFlag, ActDate);

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="AdmMRStatusQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ActDate</Value>
</Value>
<Value name="4">
<Value>ActTime</Value>
</Value>
<Value name="5">
<Value>CreateFlag</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>SchemeType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmMRQueueD</DataLocation>
<DefaultData>AdmMRStatusQueueDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AdmMRQueueD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmMRQueueI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmMRQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
