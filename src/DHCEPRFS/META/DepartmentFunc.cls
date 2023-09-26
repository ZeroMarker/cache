/// 科室权限表，在很多地方需要对科室的权限判断
Class DHCEPRFS.META.DepartmentFunc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 科室名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 科室代码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 科室描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 科室HIS中的rowID
Property DepartmentID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 科室是否拥有扫描功能
Property Scan As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 科室是否拥有查询功能
Property Query As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 科室是否拥有关联功能
Property Correlation As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Index IdxDepartment On DepartmentID;

Storage Default
{
<Data name="DepartmentFuncDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DepartmentID</Value>
</Value>
<Value name="6">
<Value>Scan</Value>
</Value>
<Value name="7">
<Value>Query</Value>
</Value>
<Value name="8">
<Value>Correlation</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.DepartmentFuncD</DataLocation>
<DefaultData>DepartmentFuncDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.DepartmentFuncD</IdLocation>
<IndexLocation>^DHCEPRFS.META.DepartmentFuncI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.DepartmentFuncS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
