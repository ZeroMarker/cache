///     
Class dbo.BTSpecimenGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SpecimenGroupLinks, StorageStrategy = Default ]
{

/// Foreign Key FKSpecimenGroupLinksGroup created via DDL
ForeignKey FKSpecimenGroupLinksGroup(SpecimenGroupDR) References dbo.BTSpecimenGroup(PKBTSPECIMENGROUP) [ SqlName = FK_SpecimenGroupLinksGroup ];

/// Foreign Key FKSpecimenGroupLinksSpec created via DDL
ForeignKey FKSpecimenGroupLinksSpec(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_SpecimenGroupLinksSpec ];

Index IndexMaster On (SpecimenGroupDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSPECIMENGROUPLINKS On RowID [ PrimaryKey, SqlName = PK_BT_SPECIMENGROUPLINKS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SpecimenGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSpecimenGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecimenGroupDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpecimenGroupLinksD</DataLocation>
<DefaultData>BTSpecimenGroupLinksDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSpecimenGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTSpecimenGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTSpecimenGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
