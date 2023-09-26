///     
Class dbo.BDCOVFormClassItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_COVFormClassItem, StorageStrategy = Default ]
{

/// Foreign Key FKCOVFormClassItem2 created via DDL
ForeignKey FKCOVFormClassItem(COVClassItemDR) References dbo.BBCOVClassItem(PKBBCOVCLASSITEM) [ SqlName = FK_COVFormClassItem2 ];

ForeignKey FKCOVFormClass1(COVFormDR) References dbo.BDCOVForm(PKBDCOVFORM) [ SqlName = FK_COVFormClass1 ];

Index IndexMaster On (COVFormDR, COVClassItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCOVForm On (COVClassItemDR, COVFormDR) [ SqlName = Index_COVForm, Type = index ];

/// DDL Primary Key Specification
Index PKBDCOVFORMCLASSITEM On RowID [ PrimaryKey, SqlName = PK_BD_COVFORMCLASSITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property COVClassItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property COVFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property IsSelect As %Library.Boolean [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDCOVFormClassItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>COVClassItemDR</Value>
</Value>
<Value name="3">
<Value>COVFormDR</Value>
</Value>
<Value name="4">
<Value>IsSelect</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDCOVFormClassItemD</DataLocation>
<DefaultData>BDCOVFormClassItemDefaultData</DefaultData>
<IdLocation>^dbo.BDCOVFormClassItemD</IdLocation>
<IndexLocation>^dbo.BDCOVFormClassItemI</IndexLocation>
<StreamLocation>^dbo.BDCOVFormClassItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
