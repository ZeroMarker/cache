/// 描述：生成任务类型
Class DHCEPRFS.META.CTTaskType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 类型代码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 类型名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 项目类型描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 颜色标示
Property Color As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxCode On Code [ Unique ];

Storage Default
{
<Data name="CTTaskTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskTypeCode</Value>
</Value>
<Value name="3">
<Value>TaskTypeName</Value>
</Value>
<Value name="4">
<Value>TaskTypeDesc</Value>
</Value>
<Value name="5">
<Value>Color</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
<Value name="7">
<Value>Name</Value>
</Value>
<Value name="8">
<Value>Desciption</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.CTTaskTypeD</DataLocation>
<DefaultData>CTTaskTypeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.CTTaskTypeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.CTTaskTypeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.CTTaskTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
