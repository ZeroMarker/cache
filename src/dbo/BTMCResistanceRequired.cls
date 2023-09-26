///     
Class dbo.BTMCResistanceRequired Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_ResistanceRequired ]
{

/// Foreign Key FKBTMCResistanceRequiredTestSetDR created via DDL
ForeignKey FKBTMCResistanceRequiredTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTMCResistanceRequiredTestSetDR ];

/// Foreign Key FKBTMCResistanceRequiredSpecimenDR created via DDL
ForeignKey FKBTMCResistanceRequiredSpecimenDR(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTMCResistanceRequiredSpecimenDR ];

/// Foreign Key FKBTMCResistanceRequiredResistanceItemDR created via DDL
ForeignKey FKBTMCResistanceRequiredResistanceItemDR(ResistanceItemDR) References dbo.BTMCResistanceItem(PKBTMCRESISTANCEITEM) [ SqlName = FK_BTMCResistanceRequiredResistanceItemDR ];

Index IndexMaster On (TestSetDR, ResistanceItemDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCRESISTANCEREQUIRED On RowID [ PrimaryKey, SqlName = PK_BTMC_RESISTANCEREQUIRED, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ResistanceItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMCResistanceRequiredDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
<Value name="4">
<Value>ResistanceItemDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCResistanceRequiredD</DataLocation>
<DefaultData>BTMCResistanceRequiredDefaultData</DefaultData>
<IdLocation>^dbo.BTMCResistanceRequiredD</IdLocation>
<IndexLocation>^dbo.BTMCResistanceRequiredI</IndexLocation>
<StreamLocation>^dbo.BTMCResistanceRequiredS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
