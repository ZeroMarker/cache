///     
Class dbo.DVRepair Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = DV_Repair, StorageStrategy = Default ]
{

/// Foreign Key FKRepairAddUser created via DDL
ForeignKey FKRepairAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RepairAddUser ];

/// Foreign Key FKRepairAuthUser created via DDL
ForeignKey FKRepairAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RepairAuthUser ];

/// Foreign Key FKRepairCancelUser created via DDL
ForeignKey FKRepairCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RepairCancelUser ];

/// Foreign Key FKRepairDevice created via DDL
ForeignKey FKRepairDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_RepairDevice ];

/// Foreign Key FKRepairServiceCompany created via DDL
ForeignKey FKRepairServiceCompany(ServiceCompanyDR) References dbo.BTDVServiceCompany(PKBTDVSERVICECOMPANY) [ SqlName = FK_RepairServiceCompany ];

/// Foreign Key FKRepairWorkGroup created via DDL
ForeignKey FKRepairWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RepairWorkGroup ];

Index IndexAddTime On (DeviceDR, AddDate) [ SqlName = Index_AddTime, Type = index ];

Index IndexAuthTime On (WorkGroupDR, AuthDate) [ SqlName = Index_AuthTime, Type = index ];

Index IndexRepairNo On RepairNo [ SqlName = Index_RepairNo, Type = index, Unique ];

Index IndexStatus On (WorkGroupDR, Status) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroup On (DeviceDR, WorkGroupDR) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKDVREPAIR On RowID [ PrimaryKey, SqlName = PK_DV_REPAIR, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RepairNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property RepairDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property RepairTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ServiceCompanyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property RepairMan As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property RepairRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property RepairCost As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 14 ];

Property ReceiptNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 15 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property AuthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 19 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 23 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="DVRepairDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepairNo</Value>
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
<Value>RepairDate</Value>
</Value>
<Value name="9">
<Value>RepairTime</Value>
</Value>
<Value name="10">
<Value>ServiceCompanyDR</Value>
</Value>
<Value name="11">
<Value>RepairMan</Value>
</Value>
<Value name="12">
<Value>RepairRemark</Value>
</Value>
<Value name="13">
<Value>RepairCost</Value>
</Value>
<Value name="14">
<Value>ReceiptNo</Value>
</Value>
<Value name="15">
<Value>AuthDate</Value>
</Value>
<Value name="16">
<Value>AuthTime</Value>
</Value>
<Value name="17">
<Value>AuthUserDR</Value>
</Value>
<Value name="18">
<Value>AuthRemark</Value>
</Value>
<Value name="19">
<Value>CancelDate</Value>
</Value>
<Value name="20">
<Value>CancelTime</Value>
</Value>
<Value name="21">
<Value>CancelUserDR</Value>
</Value>
<Value name="22">
<Value>CancelRemark</Value>
</Value>
<Value name="23">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.DVRepairD</DataLocation>
<DefaultData>DVRepairDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.DVRepairD</IdLocation>
<IndexLocation>^dbo.DVRepairI</IndexLocation>
<StreamLocation>^dbo.DVRepairS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
