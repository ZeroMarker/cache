///     
Class dbo.BTMIMachineOpenTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineOpenTC, StorageStrategy = Default ]
{

/// Foreign Key FKMachineQCMach created via DDL
ForeignKey FKMachineOpenTCMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineOpenTCMach ];

/// Foreign Key FKMachineQCMat created via DDL
ForeignKey FKMachineOpenTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineOpenTC ];

Index IndexMaster On (MachineParameterDR, OpenDate, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMachineOpenTC On RowID [ PrimaryKey, SqlName = PK_BTMI_MachineOpenTC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OpenDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property IsQC As %Library.Boolean [ SqlColumnNumber = 6 ];

Property IsEQA As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTMIMachineOpenTCDefaultData">
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
</Data>
<DataLocation>^dbo.BTMIMachineOpenTCD</DataLocation>
<DefaultData>BTMIMachineOpenTCDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineOpenTCD</IdLocation>
<IndexLocation>^dbo.BTMIMachineOpenTCI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineOpenTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
