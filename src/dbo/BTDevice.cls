///     
Class dbo.BTDevice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Device, StorageStrategy = Default ]
{

/// Foreign Key FKDeviceServiceCompany created via DDL
ForeignKey FKDeviceServiceCompany(ServiceCompanyDR) References dbo.BTDVServiceCompany(PKBTDVSERVICECOMPANY) [ SqlName = FK_DeviceServiceCompany ];

/// Foreign Key FKTempDevice created via DDL
ForeignKey FKTempDevice(RegisterDeviceDR) References dbo.BTRegisterDevice(PKBTREGISTERDEVICE) [ SqlName = FK_TempDevice ];

/// Foreign Key FKTempDeviceHospital created via DDL
ForeignKey FKTempDeviceHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TempDeviceHospital ];

/// Foreign Key FKTempDeviceWorkGroup created via DDL
ForeignKey FKTempDeviceWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TempDeviceWorkGroup ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTDEVICE On RowID [ PrimaryKey, SqlName = PK_BT_DEVICE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property RegisterDeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ServiceCompanyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property IsRecordTemp As %Library.Boolean [ SqlColumnNumber = 12 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property IsMain As %Library.Boolean [ SqlColumnNumber = 14 ];

Property IsCali As %Library.Boolean [ SqlColumnNumber = 15 ];

Property CaliPeriod As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CaliLastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CaliWarnDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property MainWarnDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BTDeviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>LName</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>RegisterDeviceDR</Value>
</Value>
<Value name="8">
<Value>ServiceCompanyDR</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>IsRecordTemp</Value>
</Value>
<Value name="12">
<Value>StartDate</Value>
</Value>
<Value name="13">
<Value>IsMain</Value>
</Value>
<Value name="14">
<Value>IsCali</Value>
</Value>
<Value name="15">
<Value>CaliPeriod</Value>
</Value>
<Value name="16">
<Value>CaliLastDate</Value>
</Value>
<Value name="17">
<Value>CaliWarnDays</Value>
</Value>
<Value name="18">
<Value>MainWarnDays</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDeviceD</DataLocation>
<DefaultData>BTDeviceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDeviceD</IdLocation>
<IndexLocation>^dbo.BTDeviceI</IndexLocation>
<StreamLocation>^dbo.BTDeviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
