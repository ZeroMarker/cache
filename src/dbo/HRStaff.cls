Class dbo.HRStaff Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_Staff, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexUser On UserDR [ SqlName = Index_User, Type = index, Unique ];

Index IndexContractExpirty On ContractExpirtyDate [ SqlName = Index_ContractExpirty, Type = index ];

Index IndexContractDate On ContractDate [ SqlName = Index_ContractDate, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexDOB On BirthDate [ SqlName = Index_DOB, Type = index ];

Index IndexEntryDate On EntryDate [ SqlName = Index_EntryDate, Type = index ];

Index IndexHospital On (HospitalDR, WorkStatus) [ SqlName = Index_Hospital, Type = index ];

Index IndexDepartment On DepartmentDR [ SqlName = Index_Department, Type = index ];

/// DDL Primary Key Specification
Index PKHRSTAFF On RowID [ PrimaryKey, SqlName = PK_HR_STAFF, Type = index, Unique ];

/// Foreign Key FKStaffUser created via DDL
ForeignKey FKStaffUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_StaffUser ];

/// Foreign Key FKStaffHospital created via DDL
ForeignKey FKStaffHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_StaffHospital ];

/// Foreign Key FKStaffWorkGroup created via DDL
ForeignKey FKStaffWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_StaffWorkGroup ];

/// Foreign Key FKStaffSex created via DDL
ForeignKey FKStaffSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_StaffSex ];

/// Foreign Key FKStaffNation created via DDL
ForeignKey FKStaffNation(NationDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_StaffNation ];

/// Foreign Key FKStaffABO created via DDL
ForeignKey FKStaffABO(AboDR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_StaffABO ];

/// Foreign Key FKStaffRH created via DDL
ForeignKey FKStaffRH(RhDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_StaffRH ];

/// Foreign Key FKStaffEmployeeType created via DDL
ForeignKey FKStaffEmployeeType(EmployTypeDR) References dbo.BTHREmployType(PKBTHREMPLOYTYPE) [ SqlName = FK_StaffEmployeeType ];

/// Foreign Key FKStaffAddUser created via DDL
ForeignKey FKStaffAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_StaffAddUser ];

/// Foreign Key FKStaffEmployeeType created via DDL
ForeignKey FKStaffTechnicalTitle(TechnicalTitleDR) References dbo.BTHRTechnicalTitle(PKBTHRTECHNICALTITLE) [ SqlName = FK_StaffTechnicalTitle ];

/// Foreign Key FKStaffEmployeeType created via DDL
ForeignKey FKStaffPositionTitle(PositionTitleDR) References dbo.BTHRPositionTitle(PKBTHRPOSITIONTITLE) [ SqlName = FK_StaffPositionTitle ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Photo As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 10 ];

Property Sign As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 11 ];

Property NationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Mobile As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 13 ];

Property Phone As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 14 ];

Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 15 ];

Property PostNo As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 16 ];

Property EMail As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 17 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

Property AboDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property RhDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property Height As %Library.Float [ SqlColumnNumber = 21 ];

Property Weight As %Library.Float [ SqlColumnNumber = 22 ];

Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 23 ];

Property PoliticalStatus As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

Property Faith As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

Property Married As %Library.Boolean [ SqlColumnNumber = 26 ];

Property GraduateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property GraduateSchool As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 28 ];

Property Specialty As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 29 ];

Property HighestDegree As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 30 ];

Property Speciality As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 31 ];

Property EntryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Property Duty As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 33 ];

Property Rank As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 34 ];

Property EmployTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

Property BasicSalary As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 36 ];

Property ContractDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

Property ContractExpirtyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

Property WorkStatus As %Library.Boolean [ SqlColumnNumber = 39 ];

Property DimissionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

Property DimissionReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 41 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 42 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 43 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 44 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 45 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

Property TechnicalTitleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

Property PositionTitleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

Property ContractFilePath As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 49 ];

Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

Property ContractFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 51 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

/// 0:保存  1:提交  2:审核
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 55 ];

Property InitialDegree As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 56 ];

Storage Default
{
<Data name="HRStaffDefaultData">
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
<Value>UserDR</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>SpeciesDR</Value>
</Value>
<Value name="8">
<Value>BirthDate</Value>
</Value>
<Value name="9">
<Value>Photo</Value>
</Value>
<Value name="10">
<Value>Sign</Value>
</Value>
<Value name="11">
<Value>NationDR</Value>
</Value>
<Value name="12">
<Value>Mobile</Value>
</Value>
<Value name="13">
<Value>Phone</Value>
</Value>
<Value name="14">
<Value>Address</Value>
</Value>
<Value name="15">
<Value>PostNo</Value>
</Value>
<Value name="16">
<Value>EMail</Value>
</Value>
<Value name="17">
<Value>IDNumber</Value>
</Value>
<Value name="18">
<Value>AboDR</Value>
</Value>
<Value name="19">
<Value>RhDR</Value>
</Value>
<Value name="20">
<Value>Height</Value>
</Value>
<Value name="21">
<Value>Weight</Value>
</Value>
<Value name="22">
<Value>NativePlace</Value>
</Value>
<Value name="23">
<Value>PoliticalStatus</Value>
</Value>
<Value name="24">
<Value>Faith</Value>
</Value>
<Value name="25">
<Value>Married</Value>
</Value>
<Value name="26">
<Value>GraduateDate</Value>
</Value>
<Value name="27">
<Value>GraduateSchool</Value>
</Value>
<Value name="28">
<Value>Specialty</Value>
</Value>
<Value name="29">
<Value>HighestDegree</Value>
</Value>
<Value name="30">
<Value>Speciality</Value>
</Value>
<Value name="31">
<Value>EntryDate</Value>
</Value>
<Value name="32">
<Value>Duty</Value>
</Value>
<Value name="33">
<Value>Rank</Value>
</Value>
<Value name="34">
<Value>EmployTypeDR</Value>
</Value>
<Value name="35">
<Value>BasicSalary</Value>
</Value>
<Value name="36">
<Value>ContractDate</Value>
</Value>
<Value name="37">
<Value>ContractExpirtyDate</Value>
</Value>
<Value name="38">
<Value>WorkStatus</Value>
</Value>
<Value name="39">
<Value>DimissionDate</Value>
</Value>
<Value name="40">
<Value>DimissionReason</Value>
</Value>
<Value name="41">
<Value>AddDate</Value>
</Value>
<Value name="42">
<Value>AddTime</Value>
</Value>
<Value name="43">
<Value>AddUserDR</Value>
</Value>
<Value name="44">
<Value>Remark</Value>
</Value>
<Value name="45">
<Value>Sequence</Value>
</Value>
<Value name="46">
<Value>TechnicalTitleDR</Value>
</Value>
<Value name="47">
<Value>PositionTitleDR</Value>
</Value>
<Value name="48">
<Value>ContractFilePath</Value>
</Value>
<Value name="49">
<Value>DepartmentDR</Value>
</Value>
<Value name="50">
<Value>ContractFileName</Value>
</Value>
<Value name="51">
<Value>AuthUserDR</Value>
</Value>
<Value name="52">
<Value>AuthDate</Value>
</Value>
<Value name="53">
<Value>AuthTime</Value>
</Value>
<Value name="54">
<Value>Status</Value>
</Value>
<Value name="55">
<Value>InitialDegree</Value>
</Value>
</Data>
<DataLocation>^dbo.HRStaffD</DataLocation>
<DefaultData>HRStaffDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRStaffD</IdLocation>
<IndexLocation>^dbo.HRStaffI</IndexLocation>
<StreamLocation>^dbo.HRStaffS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
