Class dbo.QCMachineMonthData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineMonthData ]
{

/// Foreign Key FKMachineResultMachine created via DDL
ForeignKey FKMachineResultMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineResultMachine ];

Index IndexMaster On (MachineParameterDR, Year, Month) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCMACHINEMONTHDATA On RowID [ PrimaryKey, SqlName = PK_QC_MACHINERESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Year As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Month As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property AuthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="QCMachineMonthDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>Year</Value>
</Value>
<Value name="4">
<Value>Month</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>AuthDate</Value>
</Value>
<Value name="10">
<Value>AuthTime</Value>
</Value>
<Value name="11">
<Value>AuthUserDR</Value>
</Value>
<Value name="12">
<Value>AuthRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineMonthDataD</DataLocation>
<DefaultData>QCMachineMonthDataDefaultData</DefaultData>
<IdLocation>^dbo.QCMachineMonthDataD</IdLocation>
<IndexLocation>^dbo.QCMachineMonthDataI</IndexLocation>
<StreamLocation>^dbo.QCMachineMonthDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
