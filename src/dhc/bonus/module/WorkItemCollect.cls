Class dhc.bonus.module.WorkItemCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = WorkItemCollectID ]
{

//接口方法ID

Property InterLocMethodRowid As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = InterLocMethod_rowid ];

//核算单元编码

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BonusUnitCode ];

//核算单元名称

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BonusUnitName ];

//收费项目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ItemCode ];

//收费项目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ItemName ];

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BonusYear ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BonusPeriod ];

//项目数值

Property ItemNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ItemNum ];

//采集时间

Property CollectDate As %Library.String [ SqlColumnNumber = 10, SqlFieldName = CollectDate ];

//数据状态

Property State As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = State ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CheckMan ];

//审核日期

Property CheckDate As %Library.String [ SqlColumnNumber = 13 ];

//数据类别

Property DataType As %Library.Integer [ SqlColumnNumber = 14, SqlFieldName = DataType ];

//SH辅助项目字典ID

Property BonusSubItemID As dhc.bonus.module.BonusWorkItem [ SqlColumnNumber = 15, SqlFieldName = BonusSubItemID ];

// 导入文件名称

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="WorkItemCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterLocMethodRowid</Value>
</Value>
<Value name="3">
<Value>BonusUnitCode</Value>
</Value>
<Value name="4">
<Value>BonusUnitName</Value>
</Value>
<Value name="5">
<Value>ItemCode</Value>
</Value>
<Value name="6">
<Value>ItemName</Value>
</Value>
<Value name="7">
<Value>BonusYear</Value>
</Value>
<Value name="8">
<Value>BonusPeriod</Value>
</Value>
<Value name="9">
<Value>ItemNum</Value>
</Value>
<Value name="10">
<Value>CollectDate</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>CheckMan</Value>
</Value>
<Value name="13">
<Value>CheckDate</Value>
</Value>
<Value name="14">
<Value>DataType</Value>
</Value>
<Value name="15">
<Value>BonusSubItemID</Value>
</Value>
<Value name="16">
<Value>FileName</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdWorkItemCollectD</DataLocation>
<DefaultData>WorkItemCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdWorkItemCollectD</IdLocation>
<IndexLocation>^dhcbsmdWorkItemCollectI</IndexLocation>
<StreamLocation>^dhcbsmdWorkItemCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
