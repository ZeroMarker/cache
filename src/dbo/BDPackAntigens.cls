///     
Class dbo.BDPackAntigens Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackAntigens, StorageStrategy = Default ]
{

/// Foreign Key FKBDPAntigensGenoType created via DDL
ForeignKey FKBDPAntigensGenoType(GenotypeDR) References dbo.BBGenotype(PKBBGENOTYPE) [ SqlName = FK_BD_PAntigens_GenoType ];

/// Foreign Key FKBDPAntigensPack created via DDL
ForeignKey FKBDPAntigensPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PAntigens_Pack ];

/// Foreign Key FKBDPAntigensTestSet created via DDL
ForeignKey FKBDPAntigensTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BD_PAntigens_TestSet ];

Index IndexMaster On (PackDR, GenotypeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDPACKANTIGENS On RowID [ PrimaryKey, SqlName = PK_BD_PACKANTIGENS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property GenotypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDPackAntigensDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>GenotypeDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>TestSetDR</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackAntigensD</DataLocation>
<DefaultData>BDPackAntigensDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackAntigensD</IdLocation>
<IndexLocation>^dbo.BDPackAntigensI</IndexLocation>
<StreamLocation>^dbo.BDPackAntigensS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
