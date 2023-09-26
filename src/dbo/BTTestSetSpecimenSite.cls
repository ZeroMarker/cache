Class dbo.BTTestSetSpecimenSite Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetSpecimenSite ]
{

Index IndexMaster On (TestSetSpecimenDR, AnatomicalSiteDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (TestSetSpecimenDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKTestSetSpecimen created via DDL
ForeignKey FKTestSetSpecimen(TestSetSpecimenDR) References dbo.BTTestSetSpecimen(PKBTTESTSETSPECIMEN) [ SqlName = FK_TestSetSpecimen ];

/// Foreign Key FKAnatomicalSite created via DDL
ForeignKey FKAnatomicalSite(AnatomicalSiteDR) References dbo.BTAnatomicalSite(PKBTANATOMICALSITE) [ SqlName = FK_AnatomicalSite ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetSpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AnatomicalSiteDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestSetSpecimenSiteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetSpecimenDR</Value>
</Value>
<Value name="3">
<Value>AnatomicalSiteDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetSpecimenSiteD</DataLocation>
<DefaultData>BTTestSetSpecimenSiteDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetSpecimenSiteD</IdLocation>
<IndexLocation>^dbo.BTTestSetSpecimenSiteI</IndexLocation>
<StreamLocation>^dbo.BTTestSetSpecimenSiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
