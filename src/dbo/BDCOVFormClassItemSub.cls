///     
Class dbo.BDCOVFormClassItemSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_COVFormClassItemSub, StorageStrategy = Default ]
{

/// Foreign Key FKCOVFormClassItemSub1 created via DDL
ForeignKey FKCOVFormClassItemSub1(COVFormClassItemDR) References dbo.BDCOVFormClassItem(PKBDCOVFORMCLASSITEM) [ SqlName = FK_COVFormClassItemSub1 ];

/// Foreign Key FKCOVFormClassItemSub2 created via DDL
ForeignKey FKCOVFormClassItemSub2(COVClassItemDR) References dbo.BBCOVClassItem(PKBBCOVCLASSITEM) [ SqlName = FK_COVFormClassItemSub2 ];

Index IndexMaster On (COVFormClassItemDR, COVClassItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (COVFormClassItemDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDCOVFORMCLASSITEMSUB On RowID [ PrimaryKey, SqlName = PK_BD_COVFORMCLASSITEMSUB, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property COVFormClassItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property COVClassItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsSelect As %Library.Boolean [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDCOVFormClassItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>COVFormClassItemDR</Value>
</Value>
<Value name="3">
<Value>COVClassItemDR</Value>
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
<DataLocation>^dbo.BDCOVFormClassItemSubD</DataLocation>
<DefaultData>BDCOVFormClassItemSubDefaultData</DefaultData>
<IdLocation>^dbo.BDCOVFormClassItemSubD</IdLocation>
<IndexLocation>^dbo.BDCOVFormClassItemSubI</IndexLocation>
<StreamLocation>^dbo.BDCOVFormClassItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
