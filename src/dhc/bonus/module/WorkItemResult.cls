Class dhc.bonus.module.WorkItemResult Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = WorkItemResultID ]
{

//接口方法ID

Property InterLocMethodRowid As %Library.Integer [ SqlColumnNumber = 2 ];

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//核算单元ID

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 5 ];

//工作量项目ID

Property BonusWorkItemID As dhc.bonus.module.BonusWorkItem [ SqlColumnNumber = 6 ];

//项目数值

Property ItemNum As %Library.Float [ SqlColumnNumber = 7 ];

//项目单价

Property ItemPrice As %Library.Float [ SqlColumnNumber = 8 ];

//计算时间

Property CalDate As %Library.String [ SqlColumnNumber = 9 ];

//数据状态

Property State As %Library.Integer [ SqlColumnNumber = 10 ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

//审核日期

Property CheckDate As %Library.String [ SqlColumnNumber = 12 ];

//数据类别

Property DataTypeID As dhc.bonus.module.WorkItemType [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="WorkItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterLocMethodRowid</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>BonusUnitID</Value>
</Value>
<Value name="6">
<Value>BonusWorkItemID</Value>
</Value>
<Value name="7">
<Value>ItemNum</Value>
</Value>
<Value name="8">
<Value>ItemPrice</Value>
</Value>
<Value name="9">
<Value>CalDate</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>CheckMan</Value>
</Value>
<Value name="12">
<Value>CheckDate</Value>
</Value>
<Value name="13">
<Value>DataTypeID</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdWorkItemResultD</DataLocation>
<DefaultData>WorkItemResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdWorkItemResultD</IdLocation>
<IndexLocation>^dhcbsmdWorkItemResultI</IndexLocation>
<StreamLocation>^dhcbsmdWorkItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
