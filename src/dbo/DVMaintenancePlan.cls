///     
Class dbo.DVMaintenancePlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = DV_MaintenancePlan, StorageStrategy = Default ]
{

/// Foreign Key FKMaintenancePlanAddUser created via DDL
ForeignKey FKMaintenancePlanAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MaintenancePlanAddUser ];

/// Foreign Key FKMaintenancePlanCancelUser created via DDL
ForeignKey FKMaintenancePlanCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MaintenancePlanCancelUser ];

/// Foreign Key FKMaintenancePlanDevice created via DDL
ForeignKey FKMaintenancePlanDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_MaintenancePlanDevice ];

/// Foreign Key FKMaintenancePlanExecUser created via DDL
ForeignKey FKMaintenancePlanExecUser(ExecuteUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MaintenancePlanExecUser ];

/// Foreign Key FKMaintenancePlanMainType created via DDL
ForeignKey FKMaintenancePlanMainType(MaintenceTypeDR) References dbo.BTDVMaintenceType(PKBTDVMAINTENCETYPE) [ SqlName = FK_MaintenancePlanMainType ];

/// Foreign Key FKMaintenancePlanServiceCompany created via DDL
ForeignKey FKMaintenancePlanServiceCompany(ServiceCompanyDR) References dbo.BTDVServiceCompany(PKBTDVSERVICECOMPANY) [ SqlName = FK_MaintenancePlanServiceCompany ];

/// Foreign Key FKMaintenancePlanUser created via DDL
ForeignKey FKMaintenancePlanUser(PlanUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MaintenancePlanUser ];

/// Foreign Key FKMaintenancePlanWorkGroup created via DDL
ForeignKey FKMaintenancePlanWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_MaintenancePlanWorkGroup ];

Index IndexAddTime On (DeviceDR, AddDate) [ SqlName = Index_AddTime, Type = index ];

Index IndexExecuteTime On (WorkGroupDR, ExecuteDate) [ SqlName = Index_ExecuteTime, Type = index ];

Index IndexPlanNo On PlanNo [ SqlName = Index_PlanNo, Type = index, Unique ];

Index IndexPlanTime On (DeviceDR, Status, PlanDate) [ SqlName = Index_PlanTime, Type = index ];

Index IndexStatus On (WorkGroupDR, Status) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroup On (DeviceDR, WorkGroupDR) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKDVMAINTENANCEPLAN On RowID [ PrimaryKey, SqlName = PK_DV_MAINTENANCEPLAN, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property PlanDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property PlanTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ServiceCompanyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property MaintenceTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property PlanContent As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property PlanUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property ExecuteDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property ExecuteTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property ExecuteUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property ExecuteRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 22 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="DVMaintenancePlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanNo</Value>
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
<Value>PlanDate</Value>
</Value>
<Value name="9">
<Value>PlanTime</Value>
</Value>
<Value name="10">
<Value>ServiceCompanyDR</Value>
</Value>
<Value name="11">
<Value>MaintenceTypeDR</Value>
</Value>
<Value name="12">
<Value>PlanContent</Value>
</Value>
<Value name="13">
<Value>PlanUserDR</Value>
</Value>
<Value name="14">
<Value>ExecuteDate</Value>
</Value>
<Value name="15">
<Value>ExecuteTime</Value>
</Value>
<Value name="16">
<Value>ExecuteUserDR</Value>
</Value>
<Value name="17">
<Value>ExecuteRemark</Value>
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
<DataLocation>^dbo.DVMaintenancePlanD</DataLocation>
<DefaultData>DVMaintenancePlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.DVMaintenancePlanD</IdLocation>
<IndexLocation>^dbo.DVMaintenancePlanI</IndexLocation>
<StreamLocation>^dbo.DVMaintenancePlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
