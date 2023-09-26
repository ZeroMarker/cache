///     
Class dbo.QCITCPlanTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_ITCPlanTestCode, StorageStrategy = Default ]
{

/// Foreign Key FKITCPlanTestCodePlan created via DDL
ForeignKey FKITCPlanTestCodePlan(ITCPlanDR) References dbo.QCITCPlan(PKQCITCPlan) [ SqlName = FKITCPlanTestCodePlan ];

/// Foreign Key FKITCPlanTestCodeSYSUser created via DDL
ForeignKey FKITCPlanTestCodeSYSUser(TestUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKITCPlanTestCodeSYSUser ];

/// Foreign Key FKITCPlanTestCodeTestCode created via DDL
ForeignKey FKITCPlanTestCodeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FKITCPlanTestCodeTestCode ];

/// DDL Primary Key Specification
Index PKQCITCPlanTestCode On RowID [ PrimaryKey, SqlName = PK_QC_ITCPlanTestCode, Type = index, Unique ];

Index IndexMaster On (ITCPlanDR, TestCodeDR, TestDate, TestTime) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ITCPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property TestUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property TestResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="QCITCPlanTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITCPlanDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestTime</Value>
</Value>
<Value name="6">
<Value>TestUserDR</Value>
</Value>
<Value name="7">
<Value>TestResult</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCITCPlanTestCodeD</DataLocation>
<DefaultData>QCITCPlanTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.QCITCPlanTestCodeD</IdLocation>
<IndexLocation>^dbo.QCITCPlanTestCodeI</IndexLocation>
<StreamLocation>^dbo.QCITCPlanTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
