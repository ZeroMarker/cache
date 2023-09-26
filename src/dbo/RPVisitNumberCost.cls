/// 标本收费项目
Class dbo.RPVisitNumberCost Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberCost, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberCharge created via DDL
ForeignKey FKVisitNumberCharge(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberCharge ];

/// Foreign Key FKVisitNumberChargeItem created via DDL
ForeignKey FKVisitNumberChargeItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_VisitNumberChargeItem ];

/// Foreign Key FKVisitNumberChargeTS created via DDL
ForeignKey FKVisitNumberChargeTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_VisitNumberChargeTS ];

Index IndexCostItem On (VisitNumberDR, CostItemDR) [ SqlName = Index_CostItem, Type = index ];

Index IndexMaster On (VisitNumberDR, ItemType, ItemCode, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (VisitNumberDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexTestSet On (VisitNumberDR, TestSetDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERCOST On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERCOST, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目类型  
Property ItemType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 项目代码  
Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 数量  
Property Quantity As %Library.Float [ SqlColumnNumber = 7 ];

/// 单价  
Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 8 ];

/// 实收金额  
Property ItemFee As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 9 ];

/// 折扣率  
Property Discount As %Library.Float [ SqlColumnNumber = 10 ];

/// 状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

/// 发票号  
Property InvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RPVisitNumberCostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>ItemType</Value>
</Value>
<Value name="4">
<Value>ItemCode</Value>
</Value>
<Value name="5">
<Value>CostItemDR</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>Price</Value>
</Value>
<Value name="8">
<Value>ItemFee</Value>
</Value>
<Value name="9">
<Value>Discount</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>InvoiceNo</Value>
</Value>
<Value name="12">
<Value>TestSetDR</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberCostD</DataLocation>
<DefaultData>RPVisitNumberCostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberCostD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberCostI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberCostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
