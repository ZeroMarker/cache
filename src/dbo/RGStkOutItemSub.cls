///     
Class dbo.RGStkOutItemSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkOutItemSub, StorageStrategy = Default ]
{

/// Foreign Key FKRGStkOutItemSubRGLotBox created via DDL
ForeignKey FKRGStkOutItemSubRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_StkOutItemSub_RG_LotBox ];

/// Foreign Key FKRGStkOutItemSubRGStkOutItems created via DDL
ForeignKey FKRGStkOutItemSubRGStkOutItems(StkOutItemDR) References dbo.RGStkOutItems(PKRGSTKOUTITEMS) [ SqlName = FK_RG_StkOutItemSub_RG_StkOutItems ];

Index IndexMaster On (StkOutItemDR, LotBoxDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexLotBox On LotBoxDR [ SqlName = Index_LotBox, Type = index ];

/// DDL Primary Key Specification
Index PKRGStkOutItemSub On RowID [ PrimaryKey, SqlName = PK_RG_StkOutItemSub, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StkOutItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Removed As %Library.Boolean [ SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RGStkOutItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>StkOutItemDR</Value>
</Value>
<Value name="4">
<Value>LotBoxDR</Value>
</Value>
<Value name="5">
<Value>Removed</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkOutItemSubD</DataLocation>
<DefaultData>RGStkOutItemSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkOutItemSubD</IdLocation>
<IndexLocation>^dbo.RGStkOutItemSubI</IndexLocation>
<StreamLocation>^dbo.RGStkOutItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
