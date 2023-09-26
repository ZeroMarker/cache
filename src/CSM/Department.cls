Class CSM.Department Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 所属医疗机构ID
Property InstitutionID As %Integer [ Required ];

Storage Default
{
<Data name="DepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstitutionID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^CSM.DepartmentD</DataLocation>
<DefaultData>DepartmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.DepartmentD</IdLocation>
<IndexLocation>^CSM.DepartmentI</IndexLocation>
<StreamLocation>^CSM.DepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
