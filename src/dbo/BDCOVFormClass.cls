///     
Class dbo.BDCOVFormClass Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_COVFormClass, StorageStrategy = Default ]
{

/// Foreign Key FKCOVFormClass1 created via DDL
ForeignKey FKCOVFormClass1(COVFormDR) References dbo.BDCOVForm(PKBDCOVFORM) [ SqlName = FK_COVFormClass1 ];

/// Foreign Key FKCOVFormClass2 created via DDL
ForeignKey FKCOVFormClass2(COVClassDR) References dbo.BBCOVClass(PKBBCOVCLASS) [ SqlName = FK_COVFormClass2 ];

Index IndexMaster On (COVFormDR, COVClassDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (COVFormDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDCOVFORMCLASS On RowID [ PrimaryKey, SqlName = PK_BD_COVFORMCLASS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property COVFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property COVClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsSelect As %Library.Boolean [ Required, SqlColumnNumber = 5 ];

Property OthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDCOVFormClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>COVFormDR</Value>
</Value>
<Value name="3">
<Value>COVClassDR</Value>
</Value>
<Value name="4">
<Value>IsSelect</Value>
</Value>
<Value name="5">
<Value>OthRemark</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDCOVFormClassD</DataLocation>
<DefaultData>BDCOVFormClassDefaultData</DefaultData>
<IdLocation>^dbo.BDCOVFormClassD</IdLocation>
<IndexLocation>^dbo.BDCOVFormClassI</IndexLocation>
<StreamLocation>^dbo.BDCOVFormClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
