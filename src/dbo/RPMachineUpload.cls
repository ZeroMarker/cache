///     
Class dbo.RPMachineUpload Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineUpload, StorageStrategy = Default ]
{

Index IndexVisitNumber On (VisitNumber, MachineParameterDR) [ SqlName = Index_VisitNumber, Type = index ];

Index IndexMaster On (MachineParameterDR, VisitNumber) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSendStatus On (MachineParameterDR, SendStatus, AddDate, AddTime) [ SqlName = Index_SendStatus, Type = index ];

/// DDL Primary Key Specification
Index PKRPMachineUpload On RowID [ PrimaryKey, SqlName = PK_RP_MachineUpload, Type = index, Unique ];

/// Foreign Key FKMachineUploadLink created via DDL
ForeignKey FKMachineUploadLink(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineUploadLink ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property SendStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property TCList As %Library.String(COLLATION = "Exact", MAXLEN = 1500) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPMachineUploadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>VisitNumber</Value>
</Value>
<Value name="4">
<Value>SendStatus</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>TCList</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineUploadD</DataLocation>
<DefaultData>RPMachineUploadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineUploadD</IdLocation>
<IndexLocation>^dbo.RPMachineUploadI</IndexLocation>
<StreamLocation>^dbo.RPMachineUploadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
