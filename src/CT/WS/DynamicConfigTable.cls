Class CT.WS.DynamicConfigTable Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On (TableName, ConfigName) [ Unique ];

Index IdxValue On TableName;

/// tableName
Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 配置名称
Property ConfigName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 字段
Property Fields As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 字段默认值
Property IniValue As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="DynamicConfigTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>ConfigName</Value>
</Value>
<Value name="4">
<Value>Fields</Value>
</Value>
<Value name="5">
<Value>IniValue</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.DynamicConfigTableD</DataLocation>
<DefaultData>DynamicConfigTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.DynamicConfigTableD</IdLocation>
<IndexLocation>^DHCCTWS.DynamicConfigTableI</IndexLocation>
<StreamLocation>^DHCCTWS.DynamicConfigTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
