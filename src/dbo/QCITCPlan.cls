///     
Class dbo.QCITCPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_ITCPlan, StorageStrategy = Default ]
{

/// Foreign Key FKITCPlanMachineDR created via DDL
ForeignKey FKITCPlanMachineDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FKITCPlanMachineDR ];

/// DDL Primary Key Specification
Index PKQCITCPlan On RowID [ PrimaryKey, SqlName = PK_QC_ITCPlan, Type = index, Unique ];

Index IndexMaster On (MachineParameterDR, PlanDate) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PlanDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CPDepart As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Property CPMachine As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="QCITCPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>PlanDate</Value>
</Value>
<Value name="5">
<Value>CPDepart</Value>
</Value>
<Value name="6">
<Value>CPMachine</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCITCPlanD</DataLocation>
<DefaultData>QCITCPlanDefaultData</DefaultData>
<IdLocation>^dbo.QCITCPlanD</IdLocation>
<IndexLocation>^dbo.QCITCPlanI</IndexLocation>
<StreamLocation>^dbo.QCITCPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
