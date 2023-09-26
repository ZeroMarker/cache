/// 应用表
Class CSM.Application Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 应用介绍
Property AppDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 应用名称
Property AppName As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 应用Url地址
Property AppURL As %String(MAXLEN = 100, TRUNCATE = 1);

///  应用ID
///  Property AppID As %Integer [ Required ];
///  Index MainIdx On AppID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ApplicationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppDescription</Value>
</Value>
<Value name="3">
<Value>AppName</Value>
</Value>
<Value name="4">
<Value>AppURL</Value>
</Value>
<Value name="5">
<Value>ApplicationID</Value>
</Value>
<Value name="6">
<Value>AppDesc</Value>
</Value>
<Value name="7">
<Value>AppID</Value>
</Value>
</Data>
<DataLocation>^CSM.ApplicationD</DataLocation>
<DefaultData>ApplicationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ApplicationD</IdLocation>
<IndexLocation>^CSM.ApplicationI</IndexLocation>
<StreamLocation>^CSM.ApplicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
