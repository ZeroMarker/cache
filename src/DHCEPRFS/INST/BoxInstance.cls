Class DHCEPRFS.INST.BoxInstance Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 扫描后装箱实例，记录哪些病案放到哪个箱子中
/// 箱子ID
Property BoxID As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 归档就诊号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 出院日期
Property DisDate As %Date;

/// 出院时间
Property DisTime As %Time;

/// 装箱用户ID
Property ActUserID As %String(TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 就诊箱中顺序号
Property Sequence As %Integer;

Index IdxBoxSequence On (BoxID, Sequence);

Index IdxMedRecordNo On (BoxID, MedRecordNo, MREpisodeID);

Index IdxMREpisode On MREpisodeID;

Index IdxBoxEpisodeID On EpisodeID;

Index IdxBoxMedRecordNo On MedRecordNo;

Storage Default
{
<Data name="BoxInstanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BoxID</Value>
</Value>
<Value name="3">
<Value>MedRecordNo</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>MREpisodeID</Value>
</Value>
<Value name="6">
<Value>DisDate</Value>
</Value>
<Value name="7">
<Value>DisTime</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
<Value name="9">
<Value>ActDate</Value>
</Value>
<Value name="10">
<Value>ActTime</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
<Value name="12">
<Value>MedRecordSequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.BoxD</DataLocation>
<DefaultData>BoxInstanceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.BoxD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.BoxI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.BoxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
