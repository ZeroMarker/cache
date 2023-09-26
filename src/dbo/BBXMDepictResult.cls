///     
Class dbo.BBXMDepictResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_XMDepictResult, StorageStrategy = Default ]
{

/// Foreign Key FKBBXMDRDepict created via DDL
ForeignKey FKBBXMDRDepict(XMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BB_XMDR_Depict ];

/// Foreign Key FKBBXMDRResult created via DDL
ForeignKey FKBBXMDRResult(XMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BB_XMDR_Result ];

Index IndexMaster On (XMDepictDR, XMResultDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBXMDEPICTRESULT On RowID [ PrimaryKey, SqlName = PK_BB_XMDEPICTRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property XMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property XMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBXMDepictResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMDepictDR</Value>
</Value>
<Value name="3">
<Value>XMResultDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BBXMDepictResultD</DataLocation>
<DefaultData>BBXMDepictResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBXMDepictResultD</IdLocation>
<IndexLocation>^dbo.BBXMDepictResultI</IndexLocation>
<StreamLocation>^dbo.BBXMDepictResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
