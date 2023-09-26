///     
Class dbo.RGStkInStkOut Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkInStkOut, StorageStrategy = Default ]
{

Index IndexMaster On (StkInDR, StkOutDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStkIn On StkInDR [ SqlName = Index_StkIn, Type = index ];

Index IndexStkOut On StkOutDR [ SqlName = Index_StkOut, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKINSTKOUT On RowID [ PrimaryKey, SqlName = PK_RG_STKINSTKOUT, Type = index, Unique ];

/// Foreign Key FKRGStkInOutStkInt created via DDL
ForeignKey FKRGStkInOutStkInt(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_StkInOut_StkInt ];

/// Foreign Key FKRGStkInOutStkOut created via DDL
ForeignKey FKRGStkInOutStkOut(StkOutDR) References dbo.RGStkOut(PKRGSTKOUT) [ SqlName = FK_RG_StkInOut_StkOutDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGStkInStkOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>StkOutDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkInStkOutD</DataLocation>
<DefaultData>RGStkInStkOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkInStkOutD</IdLocation>
<IndexLocation>^dbo.RGStkInStkOutI</IndexLocation>
<StreamLocation>^dbo.RGStkInStkOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
