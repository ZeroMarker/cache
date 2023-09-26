///     
Class dbo.RGLotCdkey Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_LotCdkey, StorageStrategy = Default ]
{

/// Foreign Key FKRGLotBarcodeLot created via DDL
ForeignKey FKRGLotBarcodeLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_LotBarcode_Lot ];

/// Foreign Key FKRGLotCdkeyEnder created via DDL
ForeignKey FKRGLotCdkeyEnder(EnderDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_LotCdkey_Ender ];

/// Foreign Key FKRGLotCdkeySealer created via DDL
ForeignKey FKRGLotCdkeySealer(SealerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_LotCdkey_Sealer ];

/// Foreign Key FKRGLotCdkeySecUnsealer created via DDL
ForeignKey FKRGLotCdkeySecUnsealer(SecUnsealerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_LotCdkey_SecUnsealer ];

/// Foreign Key FKRGLotCdkeyStkOutItem created via DDL
ForeignKey FKRGLotCdkeyStkOutItem(StkOutItemDR) References dbo.RGStkOutItems(PKRGSTKOUTITEMS) [ SqlName = FK_RG_LotCdkey_StkOutItem ];

/// Foreign Key FKRGLotCdkeyUnsealer created via DDL
ForeignKey FKRGLotCdkeyUnsealer(UnsealerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_LotCdkey_Unsealer ];

/// Foreign Key FKRGLotCdkeyGroup created via DDL
ForeignKey FKRGLotCdkeyGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_LotCdkey_Group ];

Index IndexEndDate On EndDate [ SqlName = Index_EndDate, Type = index ];

Index IndexLot On LotDR [ SqlName = Index_Lot, Type = index ];

Index IndexMaster On (LotDR, Cdkey) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMinBarcode On MinBarcode [ SqlName = Index_MinBarcode, Type = index, Unique ];

Index IndexSealDate On SealDate [ SqlName = Index_SealDate, Type = index ];

Index IndexSecUnsealDate On SecUnsealDate [ SqlName = Index_SecUnsealDate, Type = index ];

Index IndexUnsealDate On UnsealDate [ SqlName = Index_UnsealDate, Type = index ];

Index IndexUnsealStatus On UnsealStatus [ SqlName = Index_UnsealStatus, Type = index ];

Index IndexReagentGroup On ReagentGroupDR [ SqlName = Index_ReagentGroup, Type = index ];

/// DDL Primary Key Specification
Index PKRGLOTCDKEY On RowID [ PrimaryKey, SqlName = PK_RG_LOTCDKEY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Cdkey As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsUsed As %Library.Boolean [ SqlColumnNumber = 5 ];

Property MinBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property UnsealStatus As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property UnsealerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property UnsealDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property UnsealTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SecUnsealerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property SecUnsealDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property SecUnsealTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property EnderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property SealerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property SealDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property SealTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property SealReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 21 ];

Property IsOuted As %Library.Boolean [ SqlColumnNumber = 22 ];

Property StkOutItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property Surplus As %Library.Float [ Required, SqlColumnNumber = 24 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 25 ];

Property StkInItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="RGLotCdkeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LotDR</Value>
</Value>
<Value name="3">
<Value>Cdkey</Value>
</Value>
<Value name="4">
<Value>IsUsed</Value>
</Value>
<Value name="5">
<Value>MinBarcode</Value>
</Value>
<Value name="6">
<Value>UnsealStatus</Value>
</Value>
<Value name="7">
<Value>UnsealerDR</Value>
</Value>
<Value name="8">
<Value>UnsealDate</Value>
</Value>
<Value name="9">
<Value>UnsealTime</Value>
</Value>
<Value name="10">
<Value>SecUnsealerDR</Value>
</Value>
<Value name="11">
<Value>SecUnsealDate</Value>
</Value>
<Value name="12">
<Value>SecUnsealTime</Value>
</Value>
<Value name="13">
<Value>EnderDR</Value>
</Value>
<Value name="14">
<Value>EndDate</Value>
</Value>
<Value name="15">
<Value>EndTime</Value>
</Value>
<Value name="16">
<Value>SealerDR</Value>
</Value>
<Value name="17">
<Value>SealDate</Value>
</Value>
<Value name="18">
<Value>SealTime</Value>
</Value>
<Value name="19">
<Value>SealReason</Value>
</Value>
<Value name="20">
<Value>CreateDate</Value>
</Value>
<Value name="21">
<Value>IsOuted</Value>
</Value>
<Value name="22">
<Value>StkOutItemDR</Value>
</Value>
<Value name="23">
<Value>Surplus</Value>
</Value>
<Value name="24">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="25">
<Value>StkInItemDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGLotCdkeyD</DataLocation>
<DefaultData>RGLotCdkeyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGLotCdkeyD</IdLocation>
<IndexLocation>^dbo.RGLotCdkeyI</IndexLocation>
<StreamLocation>^dbo.RGLotCdkeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
