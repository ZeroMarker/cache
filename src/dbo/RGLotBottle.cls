///     
Class dbo.RGLotBottle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_LotBottle, StorageStrategy = Default ]
{

/// Foreign Key FKRGLotBottleRGLotBox created via DDL
ForeignKey FKRGLotBottleRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_LotBottle_RG_LotBox ];

Index IndexMaster On (LotBoxDR, BottleNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IXRGLotBottle On BottleBarcode [ SqlName = IX_RG_LotBottle, Type = index ];

/// DDL Primary Key Specification
Index PKRGLotBottle On RowID [ PrimaryKey, SqlName = PK_RG_LotBottle, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BottleNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BottleBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

Property IsOuted As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Property IsUsed As %Library.Boolean [ Required, SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

Property Surplus As %Library.Float [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RGLotBottleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>LotBoxDR</Value>
</Value>
<Value name="4">
<Value>BottleNo</Value>
</Value>
<Value name="5">
<Value>BottleBarcode</Value>
</Value>
<Value name="6">
<Value>IsOuted</Value>
</Value>
<Value name="7">
<Value>IsUsed</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>SurPlus</Value>
</Value>
<Value name="10">
<Value>Surplus</Value>
</Value>
<Value name="11">
<Value>PositionDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGLotBottleD</DataLocation>
<DefaultData>RGLotBottleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGLotBottleD</IdLocation>
<IndexLocation>^dbo.RGLotBottleI</IndexLocation>
<StreamLocation>^dbo.RGLotBottleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
