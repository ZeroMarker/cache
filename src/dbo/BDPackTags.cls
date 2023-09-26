///     
Class dbo.BDPackTags Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackTags, StorageStrategy = Default ]
{

/// Foreign Key FKBDPTagsPack created via DDL
ForeignKey FKBDPTagsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PTags_Pack ];

/// Foreign Key FKBDPTagsTags created via DDL
ForeignKey FKBDPTagsTags(BloodTagsDR) References dbo.BBBloodTags(PKBBBLOODTAGS) [ SqlName = FK_BD_PTags_Tags ];

Index IndexMaster On (PackDR, BloodTagsDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDPACKTAGS On RowID [ PrimaryKey, SqlName = PK_BD_PACKTAGS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodTagsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDPackTagsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>BloodTagsDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackTagsD</DataLocation>
<DefaultData>BDPackTagsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackTagsD</IdLocation>
<IndexLocation>^dbo.BDPackTagsI</IndexLocation>
<StreamLocation>^dbo.BDPackTagsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
