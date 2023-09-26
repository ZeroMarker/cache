/// RBRVS数据临时表                                                                                                                
Class dhc.bonus.rbrvs.RbrvsDataTemp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = RbrvsDataTempID ]
{

/// 年份
Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 月份
Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 项目编码
Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 项目名称
Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 开单科室编码
Property MakeUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 开单科室名称
Property MakeUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 执行科室编码
Property ExecuteDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// 执行科室名称
Property ExecuteDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// 项目数量
Property ItemNumber As %Library.Float [ SqlColumnNumber = 10 ];

/// 项目单价
Property ItemPrice As %Library.Float [ SqlColumnNumber = 11 ];

/// 开单分值
Property MakeRate As %Library.Float [ SqlColumnNumber = 12 ];

/// 执行分值
Property ExecuteRate As %Library.Float [ SqlColumnNumber = 13 ];

/// 数据标识
Property DataFlag As %Library.String [ SqlColumnNumber = 14 ];

/// 更新日期
Property DataUpDate As %Library.String [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RbrvsDataTempDefaultData">
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
<Value>MakeUnitCode</Value>
</Value>
<Value name="7">
<Value>MakeUnitName</Value>
</Value>
<Value name="8">
<Value>ExecuteDeptCode</Value>
</Value>
<Value name="9">
<Value>ExecuteDeptName</Value>
</Value>
<Value name="10">
<Value>ItemNumber</Value>
</Value>
<Value name="11">
<Value>ItemPrice</Value>
</Value>
<Value name="12">
<Value>MakeRate</Value>
</Value>
<Value name="13">
<Value>ExecuteRate</Value>
</Value>
<Value name="14">
<Value>DataFlag</Value>
</Value>
<Value name="15">
<Value>DataUpDate</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.rbrvs.RbrvsDataTempD</DataLocation>
<DefaultData>RbrvsDataTempDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus.rbrvs.RbrvsDataTempD</IdLocation>
<IndexLocation>^dhc.bonus.rbrvs.RbrvsDataTempI</IndexLocation>
<StreamLocation>^dhc.bonus.rbrvs.RbrvsDataTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
