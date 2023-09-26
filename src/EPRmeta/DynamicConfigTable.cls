/// save table name and fields
/// ^DHCEPRM.DynamicConfigTableD
/// ^DHCEPRM.DynamicConfigTableI
Class EPRmeta.DynamicConfigTable Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On (TableName, ConfigName) [ Unique ];

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
</Data>
<DataLocation>^DHCEPRM.DynamicConfigTableD</DataLocation>
<DefaultData>DynamicConfigTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.DynamicConfigTableD</IdLocation>
<IndexLocation>^DHCEPRM.DynamicConfigTableI</IndexLocation>
<StreamLocation>^DHCEPRM.DynamicConfigTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
