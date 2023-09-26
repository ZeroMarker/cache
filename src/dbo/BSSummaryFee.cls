/// 输血科收入汇总
Class dbo.BSSummaryFee Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_SummaryFee ]
{

Index IndexMaster On (WorkGroupDR, TypeDate, TypeTime, TypeClassId, CostItemDR) [ SqlName = Index_Master, Type = index ];

Index IndexType On (WorkGroupDR, TypeDate, TypeTime, TypeClassId, CostItemDR) [ SqlName = Index_Type, Type = index, Unique ];

/// DDL Primary Key Specification
Index BSSummaryFeeDR On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期
Property TypeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 时间
Property TypeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 0:开单日期；2:执行日期
Property TypeClassId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 费用类型；6申请单血型复检医嘱，10交叉配血XMatch，15血费Blood，20血袋其他费用Other
/// ，25手工计费Manual,30自体血费用Self 35自体血采集医嘱 40 血标本加收  50治疗单费用 
Property CostType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

Property CostItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 8 ];

/// 项目单价
Property Price As %Library.Float(MAXVAL = 2147483647) [ SqlColumnNumber = 9 ];

/// 项目总数
Property Number As %Library.Float(MAXVAL = 2147483647) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BSSummaryFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>TypeDate</Value>
</Value>
<Value name="4">
<Value>TypeTime</Value>
</Value>
<Value name="5">
<Value>TypeClassId</Value>
</Value>
<Value name="6">
<Value>CostType</Value>
</Value>
<Value name="7">
<Value>CostItemDR</Value>
</Value>
<Value name="8">
<Value>Price</Value>
</Value>
<Value name="9">
<Value>Number</Value>
</Value>
</Data>
<DataLocation>^dbo.BSSummaryFeeD</DataLocation>
<DefaultData>BSSummaryFeeDefaultData</DefaultData>
<IdLocation>^dbo.BSSummaryFeeD</IdLocation>
<IndexLocation>^dbo.BSSummaryFeeI</IndexLocation>
<StreamLocation>^dbo.BSSummaryFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
