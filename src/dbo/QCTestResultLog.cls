///     
Class dbo.QCTestResultLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_TestResultLog, StorageStrategy = Default ]
{

/// Foreign Key FKTestResultLogOldUser created via DDL
ForeignKey FKTestResultLogOldUser(OldUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultLogOldUser ];

/// Foreign Key FKTestResultLogUser created via DDL
ForeignKey FKTestResultLogUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultLogUser ];

Index IndexMaster On (TestResultDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexMach On (MachineParameterDR, TestDate, TestCodeDR, LevelNo, TestTime) [ SqlName = Index_Mach, Type = index ];

/// DDL Primary Key Specification
Index PKQCTESTRESULTLOG On RowID [ PrimaryKey, SqlName = PK_QC_TESTRESULTLOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OldResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

Property OldUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="QCTestResultLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestResultDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>OldResult</Value>
</Value>
<Value name="6">
<Value>OldUserDR</Value>
</Value>
<Value name="7">
<Value>NewResult</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>IPAddress</Value>
</Value>
<Value name="11">
<Value>TestCodeDR</Value>
</Value>
<Value name="12">
<Value>LevelNo</Value>
</Value>
<Value name="13">
<Value>TestDate</Value>
</Value>
<Value name="14">
<Value>TestTime</Value>
</Value>
<Value name="15">
<Value>MachineParameterDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCTestResultLogD</DataLocation>
<DefaultData>QCTestResultLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCTestResultLogD</IdLocation>
<IndexLocation>^dbo.QCTestResultLogI</IndexLocation>
<StreamLocation>^dbo.QCTestResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
