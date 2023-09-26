Class DHCEPRFS.INST.MREpisodeUpdateTask Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 加入日期
Property TaskDate As %Date [ SqlColumnNumber = 3 ];

/// 加入时间
Property TaskTime As %Time [ SqlColumnNumber = 4 ];

/// 优先级
Property Priority As %Integer [ SqlColumnNumber = 5 ];

Index IdxMREpisodeID On MREpisodeID;

Index IdxPriority On Priority;

Index IdxDateTime On (TaskDate, TaskTime);

Storage Default
{
<Data name="MREpisodeUpdateTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>Priority</Value>
</Value>
<Value name="4">
<Value>TaskDate</Value>
</Value>
<Value name="5">
<Value>TaskTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeUDD</DataLocation>
<DefaultData>MREpisodeUpdateTaskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodeUDD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeUDI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeUDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
