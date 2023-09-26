///     
Class dbo.RGStkOutItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkOutItems, StorageStrategy = Default ]
{

/// Foreign Key FKRGStkOutItemsMachine created via DDL
ForeignKey FKRGStkOutItemsMachine(MachineDR) References dbo.BTRGMachine(PKBTRGMACHINE) [ SqlName = FK_RG_StkOutItems_Machine ];

/// Foreign Key FKRGStkOutItemsStkOut created via DDL
ForeignKey FKRGStkOutItemsStkOut(StkOutDR) References dbo.RGStkOut(PKRGSTKOUT) [ SqlName = FK_RG_StkOutItems_StkOut ];

/// Foreign Key FKRGTransferItemsLot created via DDL
ForeignKey FKRGTransferItemsLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_TransferItems_Lot ];

Index IndexMaster On (StkOutDR, LotDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMachineDR On MachineDR [ SqlName = Index_MachineDR, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKOUTITEMS On RowID [ PrimaryKey, SqlName = PK_RG_STKOUTITEMS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Cdkey As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 7 ];

Property InQty As %Library.Float [ SqlColumnNumber = 8 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property StartEnd As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="RGStkOutItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutDR</Value>
</Value>
<Value name="3">
<Value>MachineDR</Value>
</Value>
<Value name="4">
<Value>LotDR</Value>
</Value>
<Value name="5">
<Value>Cdkey</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>InQty</Value>
</Value>
<Value name="8">
<Value>StartDate</Value>
</Value>
<Value name="9">
<Value>StartEnd</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkOutItemsD</DataLocation>
<DefaultData>RGStkOutItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkOutItemsD</IdLocation>
<IndexLocation>^dbo.RGStkOutItemsI</IndexLocation>
<StreamLocation>^dbo.RGStkOutItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
