/// 描述：生成服务器定义
Class DHCEPRFS.META.CreateServer Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 服务器IP
Property IP As %String(TRUNCATE = 1);

/// 生成类型
/// 源自 CTTaskType E--错误重生成   O--老病历生成   G--绿色通道生成   S--特殊生成   N--正常生成 
Property TaskType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CreateServerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IP</Value>
</Value>
<Value name="3">
<Value>TaskType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CreateServerD</DataLocation>
<DefaultData>CreateServerDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.CreateServerD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CreateServerI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CreateServerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
