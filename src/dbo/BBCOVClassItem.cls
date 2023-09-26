///     
Class dbo.BBCOVClassItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_COVClassItem, StorageStrategy = Default ]
{

/// Foreign Key FKCOVClassItem1 created via DDL
ForeignKey FKCOVClassItem1(COVClassDR) References dbo.BBCOVClass(PKBBCOVCLASS) [ SqlName = FK_COVClassItem1 ];

/// Foreign Key FKCOVClassItem2 created via DDL
ForeignKey FKCOVClassItem2(ParClassItemDR) References dbo.BBCOVClassItem(PKBBCOVCLASSITEM) [ SqlName = FK_COVClassItem2 ];

Index IndexCode On (COVClassDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLevelNo On (ParClassItemDR, LevelNo) [ SqlName = Index_LevelNo, Type = index ];

Index IndexParClassItem On ParClassItemDR [ SqlName = Index_ParClassItem, Type = index ];

Index IndexSequence On (COVClassDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBBCOVCLASSITEM On RowID [ PrimaryKey, SqlName = PK_BB_COVCLASSITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property COVClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ParClassItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBCOVClassItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>COVClassDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>LevelNo</Value>
</Value>
<Value name="8">
<Value>ParClassItemDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBCOVClassItemD</DataLocation>
<DefaultData>BBCOVClassItemDefaultData</DefaultData>
<IdLocation>^dbo.BBCOVClassItemD</IdLocation>
<IndexLocation>^dbo.BBCOVClassItemI</IndexLocation>
<StreamLocation>^dbo.BBCOVClassItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
