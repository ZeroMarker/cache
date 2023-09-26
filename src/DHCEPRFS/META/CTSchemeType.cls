Class DHCEPRFS.META.CTSchemeType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 方案类型名称
Property TypeName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 方案类型编码	
Property TypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 方案类型描述 
Property TypeDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="CTSchemeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeName</Value>
</Value>
<Value name="3">
<Value>TypeCode</Value>
</Value>
<Value name="4">
<Value>TypeDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTSchemeTypeD</DataLocation>
<DefaultData>CTSchemeTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.CTSchemeTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTSchemeTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTSchemeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
