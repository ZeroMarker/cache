/// 支出项目字典
Class dhc.bonus.module.BonusExpendItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusExpendItemID ]
{

//项目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ItemCode ];

//项目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ItemName ];

//是否核算

Property IsCalc As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = IsCalc ];

//分摊月份

Property Months As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = Months ];

//计提系数

Property ItemRate As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ItemRate ];

//上级项目ID

Property SuperItemID As dhc.bonus.module.BonusExpendItem [ SqlColumnNumber = 7, SqlFieldName = SuperItemID ];

//审核日期

Property CheckDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CheckDate ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CheckMan ];

//是否末级

Property IsLast As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = IsLast ];

Property State As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = State ];

//更新时间

Property UpdateDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = UpdateDate ];

//ExpendType,1=人员工资；2=卫生材料 3=办公用品、4=折旧费，5=维修费用，6=公摊费用，9=其他成本

Property ExpendType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property ItemLevel As %Library.Integer [ SqlColumnNumber = 14 ];

Index BonusItemCode On ItemCode As Exact;

Index BonusItemName On ItemName As Exact;

Index Parent On SuperItemID As Exact;

Storage Default
{
<Data name="BonusExpendItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>IsCalc</Value>
</Value>
<Value name="5">
<Value>Months</Value>
</Value>
<Value name="6">
<Value>ItemRate</Value>
</Value>
<Value name="7">
<Value>SuperItemID</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckMan</Value>
</Value>
<Value name="10">
<Value>IsLast</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>State</Value>
</Value>
<Value name="13">
<Value>ExpendType</Value>
</Value>
<Value name="14">
<Value>ItemLevel</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdBonusExpendItemD</DataLocation>
<DefaultData>BonusExpendItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdBonusExpendItemD</IdLocation>
<IndexLocation>^dhcbsmdBonusExpendItemI</IndexLocation>
<StreamLocation>^dhcbsmdBonusExpendItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
