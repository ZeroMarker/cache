///     
Class dbo.RGDayStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_DayStock, StorageStrategy = Default ]
{

/// Foreign Key FKRGDayStockCreator created via DDL
ForeignKey FKRGDayStockCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_DayStock_Creator ];

/// Foreign Key FKRGDayStockGroup created via DDL
ForeignKey FKRGDayStockGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_DayStock_Group ];

/// Foreign Key FKRGDayStockLot created via DDL
ForeignKey FKRGDayStockLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_DayStock_Lot ];

Index IndexMaster On (CreateDate, CreateTime, ReagentGroupDR, LotDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGDAYSTOCK On RowID [ PrimaryKey, SqlName = PK_RG_DAYSTOCK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 8 ];

Property StockType As %Library.SmallInt [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RGDayStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>CreatorDR</Value>
</Value>
<Value name="5">
<Value>LotDR</Value>
</Value>
<Value name="6">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="7">
<Value>Quantity</Value>
</Value>
<Value name="8">
<Value>StockType</Value>
</Value>
</Data>
<DataLocation>^dbo.RGDayStockD</DataLocation>
<DefaultData>RGDayStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGDayStockD</IdLocation>
<IndexLocation>^dbo.RGDayStockI</IndexLocation>
<StreamLocation>^dbo.RGDayStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
