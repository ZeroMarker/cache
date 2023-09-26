Class dbo.BTTestSetQueryGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetQueryGroup ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = IndexCode, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = IndexSeqNum, Type = index ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, Code) [ SqlName = Index_WorkGroupMachine, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTestSetQueryGroup On RowID [ PrimaryKey, SqlName = PK_BT_TestSetQueryGroup, Type = index, Unique ];

/// Foreign Key FKTestSetGroupHosp created via DDL
ForeignKey FKTestSetGroupHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestSetGroupHosp ];

/// Foreign Key FKVisitNumberReportWorkGroup created via DDL
ForeignKey FKTestSetQueryGroupWGM(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestSetQueryGroupWGM ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTestSetQueryGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>WorkGroupMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetQueryGroupD</DataLocation>
<DefaultData>BTTestSetQueryGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetQueryGroupD</IdLocation>
<IndexLocation>^dbo.BTTestSetQueryGroupI</IndexLocation>
<StreamLocation>^dbo.BTTestSetQueryGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
