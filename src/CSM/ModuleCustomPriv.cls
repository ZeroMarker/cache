///  模块扩展权限表
Class CSM.ModuleCustomPriv Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 扩展权限ID
/// Property ModuleCustomPrivID As %Integer [ Required ];
/// 模块ID
Property ModuleID As %Integer [ Required ];

/// 权限名称
Property PrivName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 权限值
Property PrivValue As %String(MAXLEN = 4, TRUNCATE = 1) [ Required ];

///  Index MainIdx On ModuleCustomPrivID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ModuleCustomPrivDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleCustomPrivID</Value>
</Value>
<Value name="3">
<Value>ModuleID</Value>
</Value>
<Value name="4">
<Value>PrivName</Value>
</Value>
<Value name="5">
<Value>PrivValue</Value>
</Value>
</Data>
<DataLocation>^CSM.ModuleCustomPrivD</DataLocation>
<DefaultData>ModuleCustomPrivDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ModuleCustomPrivD</IdLocation>
<IndexLocation>^CSM.ModuleCustomPrivI</IndexLocation>
<StreamLocation>^CSM.ModuleCustomPrivS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
