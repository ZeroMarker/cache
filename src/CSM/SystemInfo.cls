/// 系统信息表
Class CSM.SystemInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 序列号
Property SerialNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 系统名称
Property Name As %String(MAXLEN = 50, TRUNCATE = 1);

/// 系统配置信息
/// Property SysConfigData As %Stream [ Collection = binarystream ];
/// ID
/// Property SystemID As %Integer [ Required ];
/// 版本号
Property Version As %String(MAXLEN = 50, TRUNCATE = 1);

///   Index MainIdx On SystemID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="SystemInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>SystemID</Value>
</Value>
<Value name="4">
<Value>Licensed</Value>
</Value>
<Value name="5">
<Value>SysConfigData</Value>
</Value>
<Value name="6">
<Value>Version</Value>
</Value>
<Value name="7">
<Value>SerialNo</Value>
</Value>
</Data>
<DataLocation>^CSM.SystemInfoD</DataLocation>
<DefaultData>SystemInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.SystemInfoD</IdLocation>
<IndexLocation>^CSM.SystemInfoI</IndexLocation>
<StreamLocation>^CSM.SystemInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
