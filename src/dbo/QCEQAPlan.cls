Class dbo.QCEQAPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQAPlan ]
{

Index IndexMaster On (MachineParameterDR, PlanDate) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQAPlan On RowID [ PrimaryKey, SqlName = PK_QC_EQAPlan, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PlanDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property PlanType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="QCEQAPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>OpenDate</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>IsQC</Value>
</Value>
<Value name="6">
<Value>IsEQA</Value>
</Value>
<Value name="7">
<Value>CName</Value>
</Value>
<Value name="8">
<Value>PlanDate</Value>
</Value>
<Value name="9">
<Value>PlanType</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQAPlanD</DataLocation>
<DefaultData>QCEQAPlanDefaultData</DefaultData>
<IdLocation>^dbo.QCEQAPlanD</IdLocation>
<IndexLocation>^dbo.QCEQAPlanI</IndexLocation>
<StreamLocation>^dbo.QCEQAPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
