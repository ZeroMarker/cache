///     
Class dbo.BTTestCodeJudgeRanges Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeJudgeRanges, StorageStrategy = Default ]
{

Index IndexMachineParameter On (TestCodeDR, MachineParameterDR) [ SqlName = Index_MachineParameter, Type = index ];

Index IndexMasterTC On (TestCodeDR, OrderNo) [ SqlName = Index_MasterTC, Type = index, Unique ];

Index IndexSeqNo On (TestCodeDR, SeqNo) [ SqlName = Index_SeqNo, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestCodeJudgeRanges On RowID [ PrimaryKey, SqlName = PK_BT_TestCodeJudgeRanges, Type = index, Unique ];

/// Foreign Key FKTestCodeJudgeRanges created via DDL
ForeignKey FKTestCodJudgeeRanges(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeJudgeRanges ];

/// Foreign Key FKTestCodeJudgeRangesMach created via DDL
ForeignKey FKTestCodeRangesJudgeMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_TestCodeJudgeRangesMach ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property SeqNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTTestCodeJudgeRangesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>MachineParameterDR</Value>
</Value>
<Value name="5">
<Value>ValueLow</Value>
</Value>
<Value name="6">
<Value>ValueHigh</Value>
</Value>
<Value name="7">
<Value>Result</Value>
</Value>
<Value name="8">
<Value>SeqNo</Value>
</Value>
<Value name="9">
<Value>AbFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeJudgeRangesD</DataLocation>
<DefaultData>BTTestCodeJudgeRangesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeJudgeRangesD</IdLocation>
<IndexLocation>^dbo.BTTestCodeJudgeRangesI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeJudgeRangesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
