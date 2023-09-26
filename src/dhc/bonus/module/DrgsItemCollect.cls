Class dhc.bonus.module.DrgsItemCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DrgsItemCollectID ]
{

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//核算单元编码

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//核算单元名称

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//收费项目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

//收费项目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//项目数值

Property ItemNum As %Library.Float [ SqlColumnNumber = 8 ];

//项目系数

Property ItemRate As %Library.Float [ SqlColumnNumber = 9 ];

//项目系数

Property CostRate As %Library.Float [ SqlColumnNumber = 10 ];

//采集时间

Property CollectDate As %Library.String [ SqlColumnNumber = 11 ];

//数据状态

Property State As %Library.Integer [ SqlColumnNumber = 12 ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

//审核日期

Property CheckDate As %Library.String [ SqlColumnNumber = 14 ];

//数据类别

Property DataType As %Library.Integer [ SqlColumnNumber = 15 ];

// 导入文件名称

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="DrgsItemCollectDefaultData">
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
<Value>BonusUnitCode</Value>
</Value>
<Value name="5">
<Value>BonusUnitName</Value>
</Value>
<Value name="6">
<Value>ItemCode</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
<Value name="8">
<Value>ItemNum</Value>
</Value>
<Value name="9">
<Value>ItemRate</Value>
</Value>
<Value name="10">
<Value>CostRate</Value>
</Value>
<Value name="11">
<Value>CollectDate</Value>
</Value>
<Value name="12">
<Value>State</Value>
</Value>
<Value name="13">
<Value>CheckMan</Value>
</Value>
<Value name="14">
<Value>CheckDate</Value>
</Value>
<Value name="15">
<Value>DataType</Value>
</Value>
<Value name="16">
<Value>FileName</Value>
</Value>
</Data>
<DataLocation>^dhcbsDrgsItemCollectD</DataLocation>
<DefaultData>DrgsItemCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsDrgsItemCollectD</IdLocation>
<IndexLocation>^dhcbsDrgsItemCollectI</IndexLocation>
<StreamLocation>^dhcbsDrgsItemCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
