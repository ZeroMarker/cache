///     
Class dbo.BTEpidemicCheckFormulaTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpidemicCheckFormulaTC, StorageStrategy = Default ]
{

/// Foreign Key FKEpidemicCheckFormulaTC created via DDL
ForeignKey FKEpidemicCheckFormulaTC(EpidemicCheckFormulaDR) References dbo.BTEpidemicCheckFormula(PKBTEPIDEMICCHECKFORMULA) [ SqlName = FK_EpidemicCheckFormulaTC ];

/// Foreign Key FKEpidemicCheckFormulaTCTestCode created via DDL
ForeignKey FKEpidemicCheckFormulaTCTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_EpidemicCheckFormulaTCTestCode ];

Index IndexDataMaster On (EpidemicCheckFormulaDR, TestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTEPIDEMICCHECKFORMULATC On RowID [ PrimaryKey, SqlName = PK_BT_EPIDEMICCHECKFORMULATC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property EpidemicCheckFormulaDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTEpidemicCheckFormulaTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpidemicCheckFormulaDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpidemicCheckFormulaTCD</DataLocation>
<DefaultData>BTEpidemicCheckFormulaTCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTEpidemicCheckFormulaTCD</IdLocation>
<IndexLocation>^dbo.BTEpidemicCheckFormulaTCI</IndexLocation>
<StreamLocation>^dbo.BTEpidemicCheckFormulaTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
