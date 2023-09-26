/// 试剂批号
Class dbo.RGLot Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Lot, StorageStrategy = Default ]
{

Index IndexExpireDate On ExpireDate [ SqlName = Index_ExpireDate, Type = index ];

Index IndexLotBarcode On LotBarcode [ SqlName = Index_LotBarcode, Type = index, Unique ];

Index IndexLotNo On LotNo [ SqlName = Index_LotNo, Type = index ];

Index IndexManufacturer On ManufacturerDR [ SqlName = Index_Manufacturer, Type = index ];

Index IndexMaster On (StkInDR, ReagentDR, LotCount) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReagent On ReagentDR [ SqlName = Index_Reagent, Type = index ];

Index IndexStkIn On StkInDR [ SqlName = Index_StkIn, Type = index ];

/// DDL Primary Key Specification
Index PKRGLOT On RowID [ PrimaryKey, SqlName = PK_RG_LOT, Type = index, Unique ];

/// Foreign Key FKRGLotManufacturer created via DDL
ForeignKey FKRGLotManufacturer(ManufacturerDR) References dbo.BTRGManufacturer(PKBTRGMANUFACTURER) [ SqlName = FK_RG_Lot_Manufacturer ];

/// Foreign Key FKRGLotPosition created via DDL
ForeignKey FKRGLotPosition(PositionDR) References dbo.BTRGPosition(PKBTRGPOSITION) [ SqlName = FK_RG_Lot_Position ];

/// Foreign Key FKRGLotReagent created via DDL
ForeignKey FKRGLotReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_Lot_Reagent ];

/// Foreign Key FKRGLotStkIn created via DDL
ForeignKey FKRGLotStkIn(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_Lot_StkIn ];

/// ID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 入库单  
Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 试剂  
Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 次批号  
Property LotCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 批号  
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 批次条码号  
Property LotBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 生产厂商  
Property ManufacturerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

///       
Property ManuLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 生产日期  
Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 失效日期  
Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 入库单价  
Property Price As %Library.Float [ Required, SqlColumnNumber = 12 ];

/// 存储位置  
Property PositionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

///       
Property IsVerified As %Library.Boolean [ SqlColumnNumber = 15 ];

///       
Property ConCentration As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="RGLotDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>LotNo</Value>
</Value>
<Value name="5">
<Value>LotCount</Value>
</Value>
<Value name="6">
<Value>LotBarcode</Value>
</Value>
<Value name="7">
<Value>ManufacturerDR</Value>
</Value>
<Value name="8">
<Value>ManuLotNo</Value>
</Value>
<Value name="9">
<Value>ProductDate</Value>
</Value>
<Value name="10">
<Value>ExpireDate</Value>
</Value>
<Value name="11">
<Value>Price</Value>
</Value>
<Value name="12">
<Value>PositionDR</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>IsVerified</Value>
</Value>
<Value name="15">
<Value>ConCentration</Value>
</Value>
</Data>
<DataLocation>^dbo.RGLotD</DataLocation>
<DefaultData>RGLotDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGLotD</IdLocation>
<IndexLocation>^dbo.RGLotI</IndexLocation>
<StreamLocation>^dbo.RGLotS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
