/// 输血科收入汇总明细
Class dbo.BSSummaryFeeItem Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlTableName = BS_SummaryFeeItem ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSSummaryFeeItemDR) References dbo.BSSummaryFee(BSSummaryFeeDR) [ SqlName = FK_BS_SummaryFeeItemDR ];

Index IndexMaster On (BSSummaryFeeItemDR, SummReordDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSSummaryFeeItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  操作类型业务Id
Property SummReordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BSSummaryFeeItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSSummaryFeeItemDR</Value>
</Value>
<Value name="3">
<Value>SummReordDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSSummaryFeeItemD</DataLocation>
<DefaultData>BSSummaryFeeItemDefaultData</DefaultData>
<IdLocation>^dbo.BSSummaryFeeItemD</IdLocation>
<IndexLocation>^dbo.BSSummaryFeeItemI</IndexLocation>
<StreamLocation>^dbo.BSSummaryFeeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
