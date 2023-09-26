///     
Class dbo.QCTestResultTransaction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_TestResultTransaction, StorageStrategy = Default ]
{

/// Foreign Key FKTestResultTransactionQc created via DDL
ForeignKey FKTestResultTransactionQc(TestResultDR) References dbo.QCTestResult(PKQCTESTRESULT) [ SqlName = FK_TestResultTransactionQc ];

/// Foreign Key FKTestResultTransactionUser created via DDL
ForeignKey FKTestResultTransactionUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultTransactionUser ];

/// Foreign Key FKTestResultTransactionInnerUserDR created via DDL
ForeignKey FKTestResultTransactionInnerUserDR(InnerUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultTransactionInnerUserDR ];

/// Foreign Key FKTestResultTransactionProfessionUserDR created via DDL
ForeignKey FKTestResultTransactionProfessionUserDR(ProfessionUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultTransactionProfessionUserDR ];

/// Foreign Key FKTestResultTransactionUser created via DDL
ForeignKey FKTestResultTransactionType(TransactionTypeDR) References dbo.BTQCTransactionType(PKBTQCTransactionType) [ SqlName = FK_TestResultTransactionType ];

Index IndexMaster On (TestResultDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUser On (AddDate, AddUserDR) [ SqlName = Index_User, Type = index ];

Index IndexTransactionType On (TransactionTypeDR, AddDate, AddTime) [ SqlName = Index_TransactionType, Type = index ];

/// DDL Primary Key Specification
Index PKQCTESTRESULTTRANSACTION On RowID [ PrimaryKey, SqlName = PK_QC_TESTRESULTTRANSACTION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 7 ];

Property Reported As %Library.Boolean [ SqlColumnNumber = 8 ];

Property TransactionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property TransactionMethod As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

Property TransactionRes As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 11 ];

Property ClinicaImpact As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 12 ];

Property Precaution As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 13 ];

Property InnerUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property ProfessionUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="QCTestResultTransactionDefaultData">
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
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Reported</Value>
</Value>
<Value name="8">
<Value>TransactionTypeDR</Value>
</Value>
<Value name="9">
<Value>TransactionMethod</Value>
</Value>
<Value name="10">
<Value>TransactionRes</Value>
</Value>
<Value name="11">
<Value>ClinicaImpact</Value>
</Value>
<Value name="12">
<Value>Precaution</Value>
</Value>
<Value name="13">
<Value>InnerUserDR</Value>
</Value>
<Value name="14">
<Value>ProfessionUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCTestResultTransactionD</DataLocation>
<DefaultData>QCTestResultTransactionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCTestResultTransactionD</IdLocation>
<IndexLocation>^dbo.QCTestResultTransactionI</IndexLocation>
<StreamLocation>^dbo.QCTestResultTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
