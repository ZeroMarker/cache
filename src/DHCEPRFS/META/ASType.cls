Class DHCEPRFS.META.ASType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 类型代码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 类型名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 项目类型描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index IdxCode On Code [ Unique ];

Storage Default
{
<Data name="ASTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ASTypeD</DataLocation>
<DefaultData>ASTypeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ASTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ASTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ASTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
