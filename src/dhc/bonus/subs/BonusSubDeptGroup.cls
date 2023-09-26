/// SH科室组字典BonusSubDeptGroup
Class dhc.bonus.subs.BonusSubDeptGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubDeptGroupID ]
{

Property DeptGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property DeptGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

// 科室类别 0:通用科室、 1：开单科室、2：执行科室、3：病人科室

Property DeptGroupType As %Library.Integer [ SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BonusSubDeptGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptGroupCode</Value>
</Value>
<Value name="3">
<Value>DeptGroupName</Value>
</Value>
<Value name="4">
<Value>DeptGroupType</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubDeptGroupD</DataLocation>
<DefaultData>BonusSubDeptGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubDeptGroupD</IdLocation>
<IndexLocation>^dhcbsSubDeptGroupI</IndexLocation>
<StreamLocation>^dhcbsSubDeptGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
