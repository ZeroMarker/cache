///     
Class dbo.BDQCTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BDQC_TestResult ]
{

/// Foreign Key FKBDQCTestResultMaterialItemDR created via DDL
ForeignKey FKBDQCTestResultMaterialItemDR(MaterialItemDR) References dbo.BBQCMaterialItem(PKBBQCMATERIALITEM) [ SqlName = FK_BDQCTestResultMaterialItemDR ];

/// Foreign Key FKBDQCTestResultTestResultDR created via DDL
ForeignKey FKBDQCTestResultTestResultDR(TestResultDR) References dbo.BDQCTestResult(PKBDQCTESTRESULT) [ SqlName = FK_BDQCTestResultTestResultDR ];

/// Foreign Key FKBDQCTestResultMachineParameterDR created via DDL
ForeignKey FKBDQCTestResultMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BDQCTestResultMachineParameterDR ];

/// Foreign Key FKBDQCTestResultAddUserDR created via DDL
ForeignKey FKBDQCTestResultAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDQCTestResultAddUserDR ];

/// Foreign Key FKBDQCTestResultCheckUserDR created via DDL
ForeignKey FKBDQCTestResultCheckUserDR(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDQCTestResultCheckUserDR ];

/// Foreign Key FKBDQCTestResultTestCheckDR created via DDL
ForeignKey FKBDQCTestResultTestCheckDR(TestCheckDR) References dbo.BDQCTestCheck(PKBDQCTESTCHECK) [ SqlName = FK_BDQCTestResultTestCheckDR ];

/// DDL Primary Key Specification
Index PKBDQCTESTRESULT On RowID [ PrimaryKey, SqlName = PK_BDQC_TESTRESULT, Type = index, Unique ];

Index IndexMaster On (MaterialItemDR, TestReagentID, TestDate, TestTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On (MaterialItemDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexMachine On (MachineParameterDR, TestDate) [ SqlName = Index_Machine, Type = index ];

Index IndexCheckDate On (MaterialItemDR, CheckDate) [ SqlName = Index_CheckDate, Type = index ];

Index IndexTestDate On (TestDate, MaterialItemDR, TestReagentID) [ SqlName = Index_TestDate, Type = index ];

Index IndexTestResult On (MaterialItemDR, TestResultDR) [ SqlName = Index_TestResult, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestReagentID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property TestResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property ResValue As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

Property QCStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CKStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 19 ];

Property TestCheckDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDQCTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemDR</Value>
</Value>
<Value name="3">
<Value>TestReagentID</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestTime</Value>
</Value>
<Value name="6">
<Value>TestResultDR</Value>
</Value>
<Value name="7">
<Value>MachineParameterDR</Value>
</Value>
<Value name="8">
<Value>SampleID</Value>
</Value>
<Value name="9">
<Value>Result</Value>
</Value>
<Value name="10">
<Value>ResValue</Value>
</Value>
<Value name="11">
<Value>QCStatus</Value>
</Value>
<Value name="12">
<Value>AddDate</Value>
</Value>
<Value name="13">
<Value>AddTime</Value>
</Value>
<Value name="14">
<Value>AddUserDR</Value>
</Value>
<Value name="15">
<Value>CheckDate</Value>
</Value>
<Value name="16">
<Value>CheckTime</Value>
</Value>
<Value name="17">
<Value>CheckUserDR</Value>
</Value>
<Value name="18">
<Value>CKStatus</Value>
</Value>
<Value name="19">
<Value>TestCheckDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDQCTestResultD</DataLocation>
<DefaultData>BDQCTestResultDefaultData</DefaultData>
<IdLocation>^dbo.BDQCTestResultD</IdLocation>
<IndexLocation>^dbo.BDQCTestResultI</IndexLocation>
<StreamLocation>^dbo.BDQCTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
