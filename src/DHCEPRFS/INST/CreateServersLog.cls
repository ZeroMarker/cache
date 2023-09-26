Class DHCEPRFS.INST.CreateServersLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 服务器IP
Property IP As %String(MAXLEN = 20, TRUNCATE = 1);

/// 服务器活动日期
Property TaskDate As %Date;

/// 服务器活动时间
Property TaskTime As %Time;

/// ERROR--错误重生成   OLD--老病历生成   GREEN--绿色通道生成   SPECIAL--特殊生成   NORMAL--正常生成
/// 生成类型
Property TaskType As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 服务器类型
/// CREATE--生成服务器
Property ServerType As %String(TRUNCATE = 1);

/// 活动类型
/// START--开始   FALSE--错误   FINISH--完成
Property ServerStatus As %String(TRUNCATE = 1);

Index IdxIP On IP;

Index IdxServerType On ServerType;

Index IdxMain On (IP, TaskDate, TaskTime);

Storage Default
{
<Data name="CreateServersLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IP</Value>
</Value>
<Value name="3">
<Value>TaskDate</Value>
</Value>
<Value name="4">
<Value>TaskTime</Value>
</Value>
<Value name="5">
<Value>TaskType</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>ServerType</Value>
</Value>
<Value name="8">
<Value>ServerStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CreateServersLogD</DataLocation>
<DefaultData>CreateServersLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CreateServersLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CreateServersLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CreateServersLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
