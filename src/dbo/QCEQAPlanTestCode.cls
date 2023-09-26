///     
Class dbo.QCEQAPlanTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQAPlanTestCode, StorageStrategy = Default ]
{

/// Foreign Key FKPlanTestCodeEQAPlan created via DDL
ForeignKey FKPlanTestCodeEQAPlan(EQAPlanDR) References dbo.QCEQAPlan(PKQCEQAPlan) [ SqlName = FKPlanTestCodeEQAPlan ];

/// Foreign Key FKPlanTestCodeRegUser created via DDL
ForeignKey FKPlanTestCodeRegUser(RegUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKPlanTestCodeRegUser ];

/// Foreign Key FKPlanTestCodeRegUser created via DDL
ForeignKey FKPlanTestCodeAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKPlanTestCodeAddUser ];

/// Foreign Key FKPlanTestCodeTestCode created via DDL
ForeignKey FKPlanTestCodeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FKPlanTestCodeTestCode ];

/// Foreign Key FKPlanTestCodeTestUser created via DDL
ForeignKey FKPlanTestCodeTestUser(TestUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKPlanTestCodeTestUser ];

Index IndexMaster On (EQAPlanDR, TestCodeDR, BatchNum) [ SqlName = IndexMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCEQAPlanTestCode On RowID [ PrimaryKey, SqlName = PK_QC_EQAPlanTestCode, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property EQAPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property TestUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ResScore As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Property ResStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 10 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Property RegDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property RegTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property RegUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property BatchNum As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="QCEQAPlanTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQAPlanDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>TestResult</Value>
</Value>
<Value name="5">
<Value>TestDate</Value>
</Value>
<Value name="6">
<Value>TestTime</Value>
</Value>
<Value name="7">
<Value>TestUserDR</Value>
</Value>
<Value name="8">
<Value>ResScore</Value>
</Value>
<Value name="9">
<Value>ResStatus</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>RegDate</Value>
</Value>
<Value name="12">
<Value>RegTime</Value>
</Value>
<Value name="13">
<Value>RegUserDR</Value>
</Value>
<Value name="14">
<Value>BatchNum</Value>
</Value>
<Value name="15">
<Value>AddDate</Value>
</Value>
<Value name="16">
<Value>AddTime</Value>
</Value>
<Value name="17">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQAPlanTestCodeD</DataLocation>
<DefaultData>QCEQAPlanTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.QCEQAPlanTestCodeD</IdLocation>
<IndexLocation>^dbo.QCEQAPlanTestCodeI</IndexLocation>
<StreamLocation>^dbo.QCEQAPlanTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
