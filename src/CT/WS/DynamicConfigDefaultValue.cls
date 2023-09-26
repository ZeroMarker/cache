Class CT.WS.DynamicConfigDefaultValue Extends %Persistent
{

Index IdxTableNameRow On (TableName, DefaultRow);

Index IdxTableName On TableName;

/// tableName
Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 默认列
Property DefaultRow As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

///   默认列所对应的值

Storage Default
{
<Data name="DynamicConfigDefaultValueDefaultData">
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
<Value>DefaultRow</Value>
</Value>
</Data>
<DataLocation>^CT.WS.DynamicConfE129D</DataLocation>
<DefaultData>DynamicConfigDefaultValueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CT.WS.DynamicConfE129D</IdLocation>
<IndexLocation>^CT.WS.DynamicConfE129I</IndexLocation>
<StreamLocation>^CT.WS.DynamicConfE129S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
