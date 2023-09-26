/// 仪器关联药敏
Class dbo.BTMIMachineMicroSens Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineMicroSens, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, SensitivityDR, MachineSensitivity) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChannel On (MachineParameterDR, MachineSensitivity) [ SqlName = Index_Channel, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEMICROSENS On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEMICROSENS, Type = index, Unique ];

/// Foreign Key FKMachineSen created via DDL
ForeignKey FKMachineSen(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineSen ];

/// Foreign Key FKMachineSensi created via DDL
ForeignKey FKMachineSensi(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_MachineSensi ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 药敏代码  
Property MachineSensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

/// 药敏  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineMicroSensDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>MachineSensitivity</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineMicroSensD</DataLocation>
<DefaultData>BTMIMachineMicroSensDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineMicroSensD</IdLocation>
<IndexLocation>^dbo.BTMIMachineMicroSensI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineMicroSensS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
