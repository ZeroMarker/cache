/// BTCheckValidFormulaTC
Class dbo.BTCheckValidFormulaTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidFormulaTC, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidFormulaTC created via DDL
ForeignKey FKCheckValidFormulaTC(CheckValidFormulaDR) References dbo.BTCheckValidFormula(PKBTCHECKVALIDFORMULA) [ SqlName = FK_CheckValidFormulaTC ];

/// Foreign Key FKCheckValidFormulaTCTestCode created via DDL
ForeignKey FKCheckValidFormulaTCTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidFormulaTCTestCode ];

Index IndexDataMaster On (CheckValidFormulaDR, TestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, CheckValidFormulaDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDFORMULATC On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDFORMULATC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 自动审核项目  
Property CheckValidFormulaDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCheckValidFormulaTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidFormulaDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidFormulaTCD</DataLocation>
<DefaultData>BTCheckValidFormulaTCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidFormulaTCD</IdLocation>
<IndexLocation>^dbo.BTCheckValidFormulaTCI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidFormulaTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
