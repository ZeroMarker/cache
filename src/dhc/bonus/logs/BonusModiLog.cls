/// 奖金修改日志
Class dhc.bonus.logs.BonusModiLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusUnitID ]
{

Property ModiDate As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//登录人员姓名

Property ModiPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//后台操作表名称

Property TableName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//后台表ID

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//业务名称，如：

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property OldValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property NewValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

//操作的菜单

Property ReMark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

//年月：YYYY-MM

Property YearMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

//奖金科室

Property BonusUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

//数据类型 1=字典数据、2=业务数据

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BonusModiLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModiDate</Value>
</Value>
<Value name="3">
<Value>ModiPerson</Value>
</Value>
<Value name="4">
<Value>TableName</Value>
</Value>
<Value name="5">
<Value>ItemCode</Value>
</Value>
<Value name="6">
<Value>ItemName</Value>
</Value>
<Value name="7">
<Value>OldValue</Value>
</Value>
<Value name="8">
<Value>NewValue</Value>
</Value>
<Value name="9">
<Value>ReMark</Value>
</Value>
<Value name="10">
<Value>YearMonth</Value>
</Value>
<Value name="11">
<Value>BonusUnit</Value>
</Value>
<Value name="12">
<Value>DataType</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusModiLogD</DataLocation>
<DefaultData>BonusModiLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusModiLogD</IdLocation>
<IndexLocation>^dhcbsBonusModiLogI</IndexLocation>
<StreamLocation>^dhcbsBonusModiLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
