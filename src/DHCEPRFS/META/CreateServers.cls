Class DHCEPRFS.META.CreateServers Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 服务器IP
Property IP As %String(MAXLEN = 20, TRUNCATE = 1);

/// 服务器活动日期
Property TaskDate As %Date;

/// 服务器活动时间
Property TaskTime As %Time;

/// 生成类型
/// ERROR--错误重生成   OLD--老病历生成   GREEN--绿色通道生成   SPECIAL--特殊生成   NORMAL--正常生成
Property TaskType As %String(TRUNCATE = 1);

/// 服务器类型
/// CREATE--生成服务器
Property ServerType As %String(TRUNCATE = 1);

/// 工作类型
/// SLEEP--休眠   WORKING--正在工作
Property Type As %String(TRUNCATE = 1);

Index IdxIP On IP;

Index IdxServerType On ServerType;

Storage Default
{
<Data name="CreateServersDefaultData">
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
<Value>ServerType</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CreateServersD</DataLocation>
<DefaultData>CreateServersDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.CreateServersD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CreateServersI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CreateServersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
