/// 	血液盘库汇总
Class dbo.BDStockCheckSummary Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_StockCheckSummary ]
{

/// Foreign Key FKBDStockCheckSummaryStockCheckDR created via DDL
ForeignKey FKBDStockCheckSummaryStockCheckDR(StockCheckDR) References dbo.BDStockCheck(PKBDSTOCKCHECK) [ SqlName = FK_BDStockCheckSummaryStockCheckDR ];

/// Foreign Key FKBDStockCheckSummaryBloodProductDR created via DDL
ForeignKey FKBDStockCheckSummaryBloodProductDR(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BDStockCheckSummaryBloodProductDR ];

/// Foreign Key FKBDStockCheckSummaryBloodGroupDR created via DDL
ForeignKey FKBDStockCheckSummaryBloodGroupDR(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BDStockCheckSummaryBloodGroupDR ];

/// DDL Primary Key Specification
Index PKBDSTOCKCHECKSUMMARY On RowID [ PrimaryKey, SqlName = PK_BD_STOCKCHECKSUMMARY, Type = index, Unique ];

Index IndexMaster On (StockCheckDR, BloodProductDR, BloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 盘库单
Property StockCheckDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血液产品
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 血型
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 账盘血袋
Property StcokBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 账盘血量
Property StcokVolume As %Library.Float [ SqlColumnNumber = 7 ];

/// 实盘血袋
Property RealBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 实盘血量
Property RealVolume As %Library.Float [ SqlColumnNumber = 9 ];

/// 差异血袋
Property DiffBags As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 差异血量
Property DiffVolume As %Library.Float [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BDStockCheckSummaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckDR</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
<Value name="4">
<Value>BloodGroupDR</Value>
</Value>
<Value name="5">
<Value>StcokBags</Value>
</Value>
<Value name="6">
<Value>StcokVolume</Value>
</Value>
<Value name="7">
<Value>RealBags</Value>
</Value>
<Value name="8">
<Value>RealVolume</Value>
</Value>
<Value name="9">
<Value>DiffBags</Value>
</Value>
<Value name="10">
<Value>DiffVolume</Value>
</Value>
</Data>
<DataLocation>^dbo.BDStockCheckSummaryD</DataLocation>
<DefaultData>BDStockCheckSummaryDefaultData</DefaultData>
<IdLocation>^dbo.BDStockCheckSummaryD</IdLocation>
<IndexLocation>^dbo.BDStockCheckSummaryI</IndexLocation>
<StreamLocation>^dbo.BDStockCheckSummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
