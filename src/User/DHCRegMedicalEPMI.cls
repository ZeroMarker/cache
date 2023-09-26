/// creator:郭荣勇
/// date：2017-06-14
/// desc：患者通过外部机构建大病历的信息暂存表，用于到院后窗口建病历
/// other: 字段说明见《医院建病历接口文档.doc》的：建病案(3031) 入参
Class User.DHCRegMedicalEPMI Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_RegMedicalEPMI ]
{

Index EPMI On PatientID As Exact;

Property PatientID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property Sex As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property Birth As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property CredType As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property CredNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property PatYBCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Property PAPERMarital As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property TelHome As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property PatType As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

Property Nation As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

Property Country As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

Property HomePlace As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

Property CountryBirth As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Property ProvinceBirth As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

Property CityBirth As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

Property AreaBirth As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

Property AddressBirth As %String(TRUNCATE = 1) [ SqlColumnNumber = 19 ];

Property CountryCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 20 ];

Property ProvinceCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

Property CityCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

Property AreaCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 23 ];

Property AddressCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

Property ZipCurrent As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

Property CountryHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 26 ];

Property ProvinceHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

Property CityHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 28 ];

Property AreaHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 29 ];

Property AddressHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 30 ];

Property ZipHouse As %String(TRUNCATE = 1) [ SqlColumnNumber = 31 ];

Property Vocation As %String(TRUNCATE = 1) [ SqlColumnNumber = 32 ];

Property Company As %String(TRUNCATE = 1) [ SqlColumnNumber = 33 ];

Property TelOffice As %String(TRUNCATE = 1) [ SqlColumnNumber = 34 ];

Property CompanyZip As %String(TRUNCATE = 1) [ SqlColumnNumber = 35 ];

Property ForeignName As %String(TRUNCATE = 1) [ SqlColumnNumber = 36 ];

Property CTRelation As %String(TRUNCATE = 1) [ SqlColumnNumber = 37 ];

Property ForeignAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 38 ];

Property ForeignZip As %String(TRUNCATE = 1) [ SqlColumnNumber = 39 ];

Property ForeignPhone As %String(TRUNCATE = 1) [ SqlColumnNumber = 40 ];

Property ForeignIDCard As %String(TRUNCATE = 1) [ SqlColumnNumber = 41 ];

Property HCP As %String(TRUNCATE = 1) [ SqlColumnNumber = 42 ];

Property HCPNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 43 ];

Property EmployeeNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 44 ];

Property HealthCareRegion As %String(TRUNCATE = 1) [ SqlColumnNumber = 45 ];

Property AdmSource As %String(TRUNCATE = 1) [ SqlColumnNumber = 46 ];

Property CreateUserDR As User.SSUser [ SqlColumnNumber = 47 ];

Property CreateDate As %Date [ SqlColumnNumber = 48 ];

Property CreateTime As %Time [ SqlColumnNumber = 49 ];

Property ExtOrgCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 50 ];

Property ClientType As %String(TRUNCATE = 1) [ SqlColumnNumber = 51 ];

Property TerminalID As %String(TRUNCATE = 1) [ SqlColumnNumber = 52 ];

Property HospitalId As %String(TRUNCATE = 1) [ SqlColumnNumber = 53 ];

Storage Default
{
<Data name="DHCRegMedicalEPMIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Sex</Value>
</Value>
<Value name="5">
<Value>Birth</Value>
</Value>
<Value name="6">
<Value>CredType</Value>
</Value>
<Value name="7">
<Value>CredNo</Value>
</Value>
<Value name="8">
<Value>PatYBCode</Value>
</Value>
<Value name="9">
<Value>PAPERMarital</Value>
</Value>
<Value name="10">
<Value>TelHome</Value>
</Value>
<Value name="11">
<Value>PatType</Value>
</Value>
<Value name="12">
<Value>Nation</Value>
</Value>
<Value name="13">
<Value>Country</Value>
</Value>
<Value name="14">
<Value>HomePlace</Value>
</Value>
<Value name="15">
<Value>CountryBirth</Value>
</Value>
<Value name="16">
<Value>ProvinceBirth</Value>
</Value>
<Value name="17">
<Value>CityBirth</Value>
</Value>
<Value name="18">
<Value>AreaBirth</Value>
</Value>
<Value name="19">
<Value>AddressBirth</Value>
</Value>
<Value name="20">
<Value>CountryCurrent</Value>
</Value>
<Value name="21">
<Value>ProvinceCurrent</Value>
</Value>
<Value name="22">
<Value>CityCurrent</Value>
</Value>
<Value name="23">
<Value>AreaCurrent</Value>
</Value>
<Value name="24">
<Value>AddressCurrent</Value>
</Value>
<Value name="25">
<Value>ZipCurrent</Value>
</Value>
<Value name="26">
<Value>CountryHouse</Value>
</Value>
<Value name="27">
<Value>ProvinceHouse</Value>
</Value>
<Value name="28">
<Value>CityHouse</Value>
</Value>
<Value name="29">
<Value>AreaHouse</Value>
</Value>
<Value name="30">
<Value>AddressHouse</Value>
</Value>
<Value name="31">
<Value>ZipHouse</Value>
</Value>
<Value name="32">
<Value>Vocation</Value>
</Value>
<Value name="33">
<Value>Company</Value>
</Value>
<Value name="34">
<Value>TelOffice</Value>
</Value>
<Value name="35">
<Value>CompanyZip</Value>
</Value>
<Value name="36">
<Value>ForeignName</Value>
</Value>
<Value name="37">
<Value>CTRelation</Value>
</Value>
<Value name="38">
<Value>ForeignAddress</Value>
</Value>
<Value name="39">
<Value>ForeignZip</Value>
</Value>
<Value name="40">
<Value>ForeignPhone</Value>
</Value>
<Value name="41">
<Value>ForeignIDCard</Value>
</Value>
<Value name="42">
<Value>HCP</Value>
</Value>
<Value name="43">
<Value>HCPNo</Value>
</Value>
<Value name="44">
<Value>EmployeeNo</Value>
</Value>
<Value name="45">
<Value>HealthCareRegion</Value>
</Value>
<Value name="46">
<Value>AdmSource</Value>
</Value>
<Value name="47">
<Value>CreateUserDR</Value>
</Value>
<Value name="48">
<Value>CreateDate</Value>
</Value>
<Value name="49">
<Value>CreateTime</Value>
</Value>
<Value name="50">
<Value>ExtOrgCode</Value>
</Value>
<Value name="51">
<Value>ClientType</Value>
</Value>
<Value name="52">
<Value>TerminalID</Value>
</Value>
<Value name="53">
<Value>HospitalId</Value>
</Value>
</Data>
<DataLocation>^User.DHCRegMedicalEPMID</DataLocation>
<DefaultData>DHCRegMedicalEPMIDefaultData</DefaultData>
<IdLocation>^User.DHCRegMedicalEPMID</IdLocation>
<IndexLocation>^User.DHCRegMedicalEPMII</IndexLocation>
<StreamLocation>^User.DHCRegMedicalEPMIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
