Class dbo.BTQCUpTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_UpTestCode ]
{

Index IndexMaster On (MachineParameterDR, SampleID, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCUPTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTQC_UPTESTCODE, Type = index, Unique ];

/// Foreign Key FKQCUpTestCodeMachineParameter created via DDL
ForeignKey FKQCUpTestCodeMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCUpTestCodeMachineParameter ];

/// Foreign Key FKQCUpTestCode created via DDL
ForeignKey FKQCUpTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCUpTestCode ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTQCUpTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>SampleID</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCUpTestCodeD</DataLocation>
<DefaultData>BTQCUpTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTQCUpTestCodeD</IdLocation>
<IndexLocation>^dbo.BTQCUpTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTQCUpTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
