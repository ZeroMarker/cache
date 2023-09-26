///     
Class dbo.RGDayStockItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_DayStockItem, StorageStrategy = Default ]
{

/// Foreign Key FKRGDayStockItemRGDayStock created via DDL
ForeignKey FKRGDayStockItemRGDayStock(DayStockDR) References dbo.RGDayStock(PKRGDAYSTOCK) [ SqlName = FK_RG_DayStockItem_RG_DayStock ];

/// Foreign Key FKRGDayStockItemRGLotBox created via DDL
ForeignKey FKRGDayStockItemRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_DayStockItem_RG_LotBox ];

/// DDL Primary Key Specification
Index PKRGDayStockItem On RowID [ PrimaryKey, SqlName = PK_RG_DayStockItem, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property DayStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGDayStockItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>DayStockDR</Value>
</Value>
<Value name="4">
<Value>LotBoxDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGDayStockItemD</DataLocation>
<DefaultData>RGDayStockItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGDayStockItemD</IdLocation>
<IndexLocation>^dbo.RGDayStockItemI</IndexLocation>
<StreamLocation>^dbo.RGDayStockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
