///     
Class dbo.RGStkInItemSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkInItemSub, StorageStrategy = Default ]
{

/// Foreign Key FKRGStkInItemSubRGLotBox created via DDL
ForeignKey FKRGStkInItemSubRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_StkInItemSub_RG_LotBox ];

/// Foreign Key FKRGStkInItemSubRGStkInItems created via DDL
ForeignKey FKRGStkInItemSubRGStkInItems(StkInItemDR) References dbo.RGStkInItems(PKRGSTKINITEMS) [ SqlName = FK_RG_StkInItemSub_RG_StkInItems ];

Index IndexMaster On (StkInItemDR, LotBoxDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGStkInItemSub On RowID [ PrimaryKey, SqlName = PK_RG_StkInItemSub, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StkInItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Removed As %Library.Boolean [ SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RGStkInItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>StkInItemDR</Value>
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
<DataLocation>^dbo.RGStkInItemSubD</DataLocation>
<DefaultData>RGStkInItemSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkInItemSubD</IdLocation>
<IndexLocation>^dbo.RGStkInItemSubI</IndexLocation>
<StreamLocation>^dbo.RGStkInItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
