Class dbo.RGTransport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Transport, StorageStrategy = Default ]
{

Index IndexMaster On (StkInDR, FilePathDR) [ SqlName = Index_Master, Type = index, Unique ];

Index PKRGTRANSPORT On RowID [ PrimaryKey, SqlName = PK_RG_TRANSPORT, Type = index, Unique ];

ForeignKey FKRGTransportStkIn(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_Transport_StkIn ];

ForeignKey FKRGTransportFilePath(FilePathDR) References dbo.RGFilePath(PKRGFILEPATH) [ SqlName = FK_RG_Transport_FilePath ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property FilePathDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RGTransportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>FilePathDR</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RGTransportD</DataLocation>
<DefaultData>RGTransportDefaultData</DefaultData>
<IdLocation>^dbo.RGTransportD</IdLocation>
<IndexLocation>^dbo.RGTransportI</IndexLocation>
<StreamLocation>^dbo.RGTransportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
