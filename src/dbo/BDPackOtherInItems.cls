///     
Class dbo.BDPackOtherInItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackOtherInItems, StorageStrategy = Default ]
{

/// Foreign Key FKPackOtherInItems created via DDL
ForeignKey FKPackOtherInItems(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_Pack_OtherInItems ];

/// Foreign Key FKPackOtherInOtherInItems created via DDL
ForeignKey FKPackOtherInOtherInItems(PackOtherInDR) References dbo.BDPackOtherIn(PKPackOtherIn) [ SqlName = FK_PackOtherIn_OtherInItems ];

/// DDL Primary Key Specification
Index IndexMaster On (PackOtherInDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackOtherInItems On RowID [ PrimaryKey, SqlName = PK_BD_PackOtherInItems, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackOtherInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDPackOtherInItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackOtherInDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackOtherInItemsD</DataLocation>
<DefaultData>BDPackOtherInItemsDefaultData</DefaultData>
<IdLocation>^dbo.BDPackOtherInItemsD</IdLocation>
<IndexLocation>^dbo.BDPackOtherInItemsI</IndexLocation>
<StreamLocation>^dbo.BDPackOtherInItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
