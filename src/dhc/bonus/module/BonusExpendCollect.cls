/// 科室支出采集
Class dhc.bonus.module.BonusExpendCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusExpendCollectID ]
{

//科室编码

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//科室名称

Property DeptName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//科目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

//科目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//项目金额

Property ItemValue As %Library.Float [ SqlColumnNumber = 8 ];

//调整金额

Property AdjustMoney As %Library.Float [ SqlColumnNumber = 9 ];

//采集时间

Property CollectDate As %Library.String [ SqlColumnNumber = 10 ];

//操作员

Property Operator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

//审核时间

Property CheckDate As %Library.String [ SqlColumnNumber = 12 ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

//数据状态

Property state As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

//接口方法，1代表物资请领取 2代表卫生 3 代表HR 

Property Methord As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

//是否有效，1=有效，0=无效，默认=1

Property IsValue As %String [ SqlColumnNumber = 17, SqlFieldName = IsValue ];

Storage Default
{
<Data name="BonusExpendCollectDefaultData">
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
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>ItemCode</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
<Value name="8">
<Value>ItemValue</Value>
</Value>
<Value name="9">
<Value>CollectDate</Value>
</Value>
<Value name="10">
<Value>Operator</Value>
</Value>
<Value name="11">
<Value>CheckDate</Value>
</Value>
<Value name="12">
<Value>CheckMan</Value>
</Value>
<Value name="13">
<Value>state</Value>
</Value>
<Value name="14">
<Value>Methord</Value>
</Value>
<Value name="15">
<Value>FileName</Value>
</Value>
<Value name="16">
<Value>IsValue</Value>
</Value>
<Value name="17">
<Value>AdjustMoney</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdBonusExpendCollectD</DataLocation>
<DefaultData>BonusExpendCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdBonusExpendCollectD</IdLocation>
<IndexLocation>^dhcbsmdBonusExpendCollectI</IndexLocation>
<StreamLocation>^dhcbsmdBonusExpendCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
