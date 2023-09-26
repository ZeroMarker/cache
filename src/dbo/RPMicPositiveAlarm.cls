Class dbo.RPMicPositiveAlarm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MicPositiveAlarm ]
{

Index IndexMaster On (WorkGroupMachineDR, AssayNo, AlarmDate) [ SqlName = Index_Master, Type = index ];

Index IndexDate On (WorkGroupMachineDR, AlarmDate, AssayNo) [ SqlName = Index_Date, Type = index ];

/// DDL Primary Key MicPositiveAlarm
Index PKRPMICPOSITIVEALARM On RowID [ PrimaryKey, SqlName = PK_RP_MICPOSITIVEALARM, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachine ];

/// Foreign Key FKMachineParameter created via DDL
ForeignKey FKMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineParameter ];

/// Foreign Key FKConfirmUser created via DDL
ForeignKey FKConfirmUser(ConfirmUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ConfirmUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

Property AlarmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AlarmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

Property IsConfirm As %Library.Boolean [ SqlColumnNumber = 9 ];

Property ConfirmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ConfirmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ConfirmUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RPMicPositiveAlarmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>AssayNo</Value>
</Value>
<Value name="5">
<Value>AlarmDate</Value>
</Value>
<Value name="6">
<Value>AlarmTime</Value>
</Value>
<Value name="7">
<Value>Result</Value>
</Value>
<Value name="8">
<Value>IsConfirm</Value>
</Value>
<Value name="9">
<Value>ConfirmDate</Value>
</Value>
<Value name="10">
<Value>ConfirmTime</Value>
</Value>
<Value name="11">
<Value>ConfirmUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMicPositiveAlarmD</DataLocation>
<DefaultData>RPMicPositiveAlarmDefaultData</DefaultData>
<IdLocation>^dbo.RPMicPositiveAlarmD</IdLocation>
<IndexLocation>^dbo.RPMicPositiveAlarmI</IndexLocation>
<StreamLocation>^dbo.RPMicPositiveAlarmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
