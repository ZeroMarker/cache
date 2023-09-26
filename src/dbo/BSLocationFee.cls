/// 统计临床科室费用统计
Class dbo.BSLocationFee Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_LocationFee ]
{

Index IndexMaster On (WorkGroupDR, TypeDate, TypeClassId, TypeClass, CostType, CostItemDR) [ SqlName = Index_Master, Type = index ];

Index IndexType On (WorkGroupDR, CostType, TypeDate, TypeClassId, TypeClass, CostItemDR) [ SqlName = Index_Type, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 计费日期
Property TypeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 1:申请科室 LOC,2:病房 WARD 3:医生 DOC 
Property TypeClassId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 1:申请科室 LOC,2:病房 WARD 3:医生 DOC 
Property TypeClass As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 费用类型；1:血费 BLD,2:检查费用 COMP
Property CostType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

/// 项目Id
Property CostItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 8 ];

/// 项目单价
Property Price As %Library.Float(MAXVAL = 2147483647) [ SqlColumnNumber = 9 ];

/// 项目总数
Property Number As %Library.Float(MAXVAL = 2147483647) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BSLocationFeeDefaultData">
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
<Value>TypeClassId</Value>
</Value>
<Value name="5">
<Value>TypeClass</Value>
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
<DataLocation>^dbo.BSLocationFeeD</DataLocation>
<DefaultData>BSLocationFeeDefaultData</DefaultData>
<IdLocation>^dbo.BSLocationFeeD</IdLocation>
<IndexLocation>^dbo.BSLocationFeeI</IndexLocation>
<StreamLocation>^dbo.BSLocationFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
