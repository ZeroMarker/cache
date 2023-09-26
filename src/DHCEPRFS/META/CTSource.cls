/// 描述：归档病历数据源代码表
Class DHCEPRFS.META.CTSource Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档病历数据源名称
Property SourceName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历数据源编码
Property SourceCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 归档病历数据源描述
Property SourceDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="CTSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceName</Value>
</Value>
<Value name="3">
<Value>SourceCode</Value>
</Value>
<Value name="4">
<Value>SourceDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTSourceD</DataLocation>
<DefaultData>CTSourceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.CTSourceD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTSourceI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTSourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
