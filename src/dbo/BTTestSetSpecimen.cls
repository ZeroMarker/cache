///     
Class dbo.BTTestSetSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetSpecimen, StorageStrategy = Default ]
{

Index IndexContainer On (ContainerDR, TestSetDR) [ SqlName = Index_Container, Type = index ];

Index IndexMaster On (TestSetDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSpecimen On (SpecimenDR, TestSetDR) [ SqlName = Index_Specimen, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTSETSPECIMEN On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETSPECIMEN, Type = index, Unique ];

/// Foreign Key FKTestSetSpecimen created via DDL
ForeignKey FKTestSetSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestSetSpecimen ];

/// Foreign Key FKTestSetSpecimenContainer created via DDL
ForeignKey FKTestSetSpecimenContainer(ContainerDR) References dbo.BTContainer(PKBTCONTAINER) [ SqlName = FK_TestSetSpecimenContainer ];

/// Foreign Key FKTestSetSpecimenTS created via DDL
ForeignKey FKTestSetSpecimenTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetSpecimenTS ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ContainerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property MergeType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTestSetSpecimenDefaultData">
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
<Value>ContainerDR</Value>
</Value>
<Value name="5">
<Value>MergeType</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetSpecimenD</DataLocation>
<DefaultData>BTTestSetSpecimenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetSpecimenD</IdLocation>
<IndexLocation>^dbo.BTTestSetSpecimenI</IndexLocation>
<StreamLocation>^dbo.BTTestSetSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
