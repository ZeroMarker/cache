///     
Class dbo.BTRegisterDevice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_RegisterDevice, StorageStrategy = Default ]
{

/// Foreign Key FKRegisteDeviceCostSupplyType created via DDL
ForeignKey FKRegisteDeviceType(DeviceTypeDR) References dbo.BTDeviceType(PKBTDeviceType) [ SqlName = FK_RegisteDeviceType ];

/// Foreign Key FKRegisteDeviceCostSupplyType created via DDL
ForeignKey FKRegisteDeviceCostSupplyType(FundSourceDR) References dbo.BTDeviceCostSupplyType(PKBTDeviceCostSupplyType) [ SqlName = FK_RegisteDeviceCostSupplyType ];

/// Foreign Key FKRegisteDeviceAgent created via DDL
ForeignKey FKRegisteDeviceAgent(DeviceAgentDR) References dbo.BTDVSupplier(PKBTDVSUPPLIER) [ SqlName = FK_RegisteDeviceAgent ];

/// Foreign Key FKRegisteDeviceHospital created via DDL
ForeignKey FKRegisteDeviceHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RegisteDeviceHospital ];

/// Foreign Key FKRegisteDeviceManufacturer created via DDL
ForeignKey FKRegisteDeviceManufacturer(DeviceManufacturerDR) References dbo.BTDVManufacturer(PKBTDVMANUFACTURER) [ SqlName = FK_RegisteDeviceManufacturer ];

/// Foreign Key FKRegisterDeviceAddUser created via DDL
ForeignKey FKRegisterDeviceAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RegisterDeviceAddUser ];

/// Foreign Key FKRegisterDeviceCheckUser created via DDL
ForeignKey FKRegisterDeviceCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RegisterDeviceCheckUser ];

/// Foreign Key FKRegisterDeviceScrapUser created via DDL
ForeignKey FKRegisterDeviceScrapUser(ScrapUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RegisterDeviceScrapUser ];

/// Foreign Key FKRegisterDeviceService created via DDL
ForeignKey FKRegisterDeviceService(DeviceServiceCoDR) References dbo.BTDVServiceCompany(PKBTDVSERVICECOMPANY) [ SqlName = FK_RegisterDeviceService ];

Index IndexBarcode On Barcode [ SqlName = Index_Barcode, Type = index ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexDeviceID On DeviceID [ SqlName = Index_DeviceID, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSerialNo On SerialNo [ SqlName = Index_SerialNo, Type = index ];

/// DDL Primary Key Specification
Index PKBTREGISTERDEVICE On RowID [ PrimaryKey, SqlName = PK_BT_REGISTERDEVICE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ModelNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property DeviceManufacturerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property DeviceID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property SerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property DeviceNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property BuyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property InStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

Property DeviceAgentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property DeviceServiceCoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property Barcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

Property ScrapDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property ScrapUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property ScrapRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 23 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property InStorageCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Property LifeSpan As %Library.Float [ SqlColumnNumber = 29 ];

Property FundSourceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property OriginCost As %Library.Float [ SqlColumnNumber = 31 ];

Property DeviceTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 33 ];

Storage Default
{
<Data name="BTRegisterDeviceDefaultData">
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
<Value>ModelNo</Value>
</Value>
<Value name="7">
<Value>DeviceManufacturerDR</Value>
</Value>
<Value name="8">
<Value>ProductDate</Value>
</Value>
<Value name="9">
<Value>DeviceID</Value>
</Value>
<Value name="10">
<Value>SerialNo</Value>
</Value>
<Value name="11">
<Value>DeviceNo</Value>
</Value>
<Value name="12">
<Value>BuyDate</Value>
</Value>
<Value name="13">
<Value>CheckDate</Value>
</Value>
<Value name="14">
<Value>CheckUserDR</Value>
</Value>
<Value name="15">
<Value>InStatus</Value>
</Value>
<Value name="16">
<Value>DeviceAgentDR</Value>
</Value>
<Value name="17">
<Value>DeviceServiceCoDR</Value>
</Value>
<Value name="18">
<Value>Barcode</Value>
</Value>
<Value name="19">
<Value>Status</Value>
</Value>
<Value name="20">
<Value>ScrapDate</Value>
</Value>
<Value name="21">
<Value>ScrapUserDR</Value>
</Value>
<Value name="22">
<Value>ScrapRemark</Value>
</Value>
<Value name="23">
<Value>AddDate</Value>
</Value>
<Value name="24">
<Value>AddTime</Value>
</Value>
<Value name="25">
<Value>AddUserDR</Value>
</Value>
<Value name="26">
<Value>Sequence</Value>
</Value>
<Value name="27">
<Value>InStorageCheckDate</Value>
</Value>
<Value name="28">
<Value>LifeSpan</Value>
</Value>
<Value name="29">
<Value>FundSourceDR</Value>
</Value>
<Value name="30">
<Value>OriginCost</Value>
</Value>
<Value name="31">
<Value>DeviceTypeDR</Value>
</Value>
<Value name="32">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRegisterDeviceD</DataLocation>
<DefaultData>BTRegisterDeviceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRegisterDeviceD</IdLocation>
<IndexLocation>^dbo.BTRegisterDeviceI</IndexLocation>
<StreamLocation>^dbo.BTRegisterDeviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
