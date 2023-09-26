/// 支出临时表，用于存放从其他数据库取出来的数据
Class dhc.bonus.subs.TempExpendData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TempExpendDataID ]
{

//年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//月

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//支出项编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//支出项名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//科室编码

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

//科室名称

Property DeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//值

Property ItemValue As %Library.Float [ SqlColumnNumber = 8 ];

//采集时间

Property DataUpDate As %Library.TimeStamp [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="TempExpendDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>ItemCode</Value>
</Value>
<Value name="5">
<Value>ItemName</Value>
</Value>
<Value name="6">
<Value>DeptCode</Value>
</Value>
<Value name="7">
<Value>DeptName</Value>
</Value>
<Value name="8">
<Value>ItemValue</Value>
</Value>
<Value name="9">
<Value>DataUpDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsTempExpendDataD</DataLocation>
<DefaultData>TempExpendDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTempExpendDataD</IdLocation>
<IndexLocation>^dhcbsempExpendDataI</IndexLocation>
<StreamLocation>^dhc.bonus.subs.TempExpendDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
