///     
Class dbo.DVCapability Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = DV_Capability, StorageStrategy = Default ]
{

/// Foreign Key FKCapabilityAddUser created via DDL
ForeignKey FKCapabilityAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CapabilityAddUser ];

/// Foreign Key FKCapabilityAuthUser created via DDL
ForeignKey FKCapabilityAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CapabilityAuthUser ];

/// Foreign Key FKCapabilityCancelUser created via DDL
ForeignKey FKCapabilityCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CapabilityCancelUser ];

/// Foreign Key FKCapabilityDevice created via DDL
ForeignKey FKCapabilityDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_CapabilityDevice ];

/// Foreign Key FKCapabilityWorkGroup created via DDL
ForeignKey FKCapabilityWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_CapabilityWorkGroup ];

Index IndexAddTime On (DeviceDR, AddDate) [ SqlName = Index_AddTime, Type = index ];

Index IndexAuthTime On (WorkGroupDR, AuthDate) [ SqlName = Index_AuthTime, Type = index ];

Index IndexCapabilityNo On CapabilityNo [ SqlName = Index_CapabilityNo, Type = index, Unique ];

Index IndexStatus On (WorkGroupDR, Status) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroup On (DeviceDR, WorkGroupDR) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKDVCAPABILITY On RowID [ PrimaryKey, SqlName = PK_DV_CAPABILITY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property CapabilityNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AbnormalContent As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property StopDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property StopTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property HandleRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property AuthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 22 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="DVCapabilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CapabilityNo</Value>
</Value>
<Value name="3">
<Value>DeviceDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>AbnormalContent</Value>
</Value>
<Value name="9">
<Value>StopDate</Value>
</Value>
<Value name="10">
<Value>StopTime</Value>
</Value>
<Value name="11">
<Value>StartDate</Value>
</Value>
<Value name="12">
<Value>StartTime</Value>
</Value>
<Value name="13">
<Value>HandleRemark</Value>
</Value>
<Value name="14">
<Value>AuthDate</Value>
</Value>
<Value name="15">
<Value>AuthTime</Value>
</Value>
<Value name="16">
<Value>AuthUserDR</Value>
</Value>
<Value name="17">
<Value>AuthRemark</Value>
</Value>
<Value name="18">
<Value>CancelDate</Value>
</Value>
<Value name="19">
<Value>CancelTime</Value>
</Value>
<Value name="20">
<Value>CancelUserDR</Value>
</Value>
<Value name="21">
<Value>CancelRemark</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.DVCapabilityD</DataLocation>
<DefaultData>DVCapabilityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.DVCapabilityD</IdLocation>
<IndexLocation>^dbo.DVCapabilityI</IndexLocation>
<StreamLocation>^dbo.DVCapabilityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
