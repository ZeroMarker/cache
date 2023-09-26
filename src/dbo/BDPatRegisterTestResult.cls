Class dbo.BDPatRegisterTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PatRegisterTestResult, StorageStrategy = Default ]
{

/// Foreign Key FKBBBGCMGroup created via DDL
ForeignKey FKBDPatRegTestResult(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BD_PatRegisterTestResult ];

/// Foreign Key FKBDAgreeFAddUser created via DDL
ForeignKey FKBDPATREGAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PATREGAddUser ];

Index IndexTestCode On (RegNo, TestCodeDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexRegNo On (RegNo, AddDate) [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPATREGTESTRESULT On RowID [ PrimaryKey, SqlName = PK_BD_PATREGTESTRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property RegPositionDesc As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPatRegisterTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>TestResult</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>RegPositionDesc</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPatRegisterTestResultD</DataLocation>
<DefaultData>BDPatRegisterTestResultDefaultData</DefaultData>
<IdLocation>^dbo.BDPatRegisterTestResultD</IdLocation>
<IndexLocation>^dbo.BDPatRegisterTestResultI</IndexLocation>
<StreamLocation>^dbo.BDPatRegisterTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
