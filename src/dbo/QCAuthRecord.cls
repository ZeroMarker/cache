Class dbo.QCAuthRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_AuthRecord ]
{

Index IndexMaster On (MachineParameterDR, TestCodeDR, AuthDate) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKTestResultAuthUser created via DDL
ForeignKey FKTestResultAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultAuthUser ];

/// Foreign Key FKTestResultMachine created via DDL
ForeignKey FKTestResultMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_TestResultMachine ];

/// Foreign Key FKTestResultTestCode created via DDL
ForeignKey FKTestResultTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestResultTestCode ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="QCAuthRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>AuthDate</Value>
</Value>
<Value name="5">
<Value>AuthUserDR</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCAuthRecordD</DataLocation>
<DefaultData>QCAuthRecordDefaultData</DefaultData>
<IdLocation>^dbo.QCAuthRecordD</IdLocation>
<IndexLocation>^dbo.QCAuthRecordI</IndexLocation>
<StreamLocation>^dbo.QCAuthRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
