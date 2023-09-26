/// save table name and fields
/// ^DHCEMRM.DynamicConfigTableD
/// ^DHCEMRM.DynamicConfigTableI
Class EMRmeta.DynamicConfigTable Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On (TableName, ConfigName) [ Unique ];

/// className
Property ClassName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// tableName
Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 配置名称
Property ConfigName As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 字段
Property Fields As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 字段默认值
Property IniValue As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="DynamicConfigTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Fields</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>ConfigName</Value>
</Value>
<Value name="5">
<Value>IniValue</Value>
</Value>
<Value name="6">
<Value>ClassName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DynamicConfigTableD</DataLocation>
<DefaultData>DynamicConfigTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.DynamicConfigTableD</IdLocation>
<IndexLocation>^DHCEMRM.DynamicConfigTableI</IndexLocation>
<StreamLocation>^DHCEMRM.DynamicConfigTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
