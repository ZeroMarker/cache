Class dhc.bonus.data.DeptManager Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DeptManagerID ]
{

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property DeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property SuperDeptID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 4 ];

//预算系统

Property IsBudg As %Library.Integer [ Required, SqlColumnNumber = 5 ];

//会计系统

Property IsAcct As %Library.Integer [ Required, SqlColumnNumber = 6 ];

//成本系统

Property IsCost As %Library.Integer [ Required, SqlColumnNumber = 7 ];

//物资系统

Property IsDura As %Library.Integer [ Required, SqlColumnNumber = 8 ];

//绩效系统

Property IsPa As %Library.Integer [ Required, SqlColumnNumber = 9 ];

//奖金系统

Property IsBonus As %Library.Integer [ Required, SqlColumnNumber = 10 ];

//人力资源

Property IsHuman As %Library.Integer [ Required, SqlColumnNumber = 11 ];

//考勤系统

Property IsAttend As %Library.Integer [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="DeptManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptCode</Value>
</Value>
<Value name="3">
<Value>DeptName</Value>
</Value>
<Value name="4">
<Value>SuperDeptID</Value>
</Value>
<Value name="5">
<Value>IsBudg</Value>
</Value>
<Value name="6">
<Value>IsAcct</Value>
</Value>
<Value name="7">
<Value>IsCost</Value>
</Value>
<Value name="8">
<Value>IsDura</Value>
</Value>
<Value name="9">
<Value>IsPa</Value>
</Value>
<Value name="10">
<Value>IsBonus</Value>
</Value>
<Value name="11">
<Value>IsHuman</Value>
</Value>
<Value name="12">
<Value>IsAttend</Value>
</Value>
</Data>
<DataLocation>^herpDeptManagerD</DataLocation>
<DefaultData>DeptManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^herpDeptManagerD</IdLocation>
<IndexLocation>^herpDeptManagerI</IndexLocation>
<StreamLocation>^herpDeptManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
