/// 申请单
Class dbo.RQRequest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_Request, StorageStrategy = Default ]
{

/// Foreign Key FKRequestABO created via DDL
ForeignKey FKRequestABO(AboDR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_RequestABO ];

/// Foreign Key FKRequestAge created via DDL
ForeignKey FKRequestAge(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_RequestAge ];

/// Foreign Key FKRequestCard created via DDL
ForeignKey FKRequestCard(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FK_RequestCard ];

/// Foreign Key FKRequestCli created via DDL
ForeignKey FKRequestCli(ClinicalConditionsDR) References dbo.BTClinicalConditions(PKBTCLINICALCONDITIONS) [ SqlName = FK_RequestCli ];

/// Foreign Key FKRequestDoc created via DDL
ForeignKey FKRequestDoc(DoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_RequestDoc ];

/// Foreign Key FKRequestHospital created via DDL
ForeignKey FKRequestHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RequestHospital ];

/// Foreign Key FKRequestLoc created via DDL
ForeignKey FKRequestLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_RequestLoc ];

/// Foreign Key FKRequestNat created via DDL
ForeignKey FKRequestNat(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_RequestNat ];

/// Foreign Key FKRequestPay created via DDL
ForeignKey FKRequestPay(PaymentTypeDR) References dbo.BTPaymentType(PKBTPAYMENTTYPE) [ SqlName = FK_RequestPay ];

/// Foreign Key FKRequestRH created via DDL
ForeignKey FKRequestRH(RhDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_RequestRH ];

/// Foreign Key FKRequestSex created via DDL
ForeignKey FKRequestSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_RequestSex ];

/// Foreign Key FKRequestType created via DDL
ForeignKey FKRequestType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_RequestType ];

/// Foreign Key FKRequestUser created via DDL
ForeignKey FKRequestUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RequestUser ];

/// Foreign Key FKRequestWard created via DDL
ForeignKey FKRequestWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_RequestWard ];

Index IndexAddTime On (HospitalDR, AddDate) [ SqlName = Index_AddTime, Type = index ];

Index IndexAdmNo On (AdmNo, Status) [ SqlName = Index_AdmNo, Type = index ];

Index IndexAdmissionType On (HospitalDR, AdmissionTypeDR, RequestTime) [ SqlName = Index_AdmissionType, Type = index ];

Index IndexDoctor On (DoctorDR, RequestTime) [ SqlName = Index_Doctor, Type = index ];

Index IndexLocation On (LocationDR, RequestTime) [ SqlName = Index_Location, Type = index ];

Index IndexPatient On (RegNo, AdmissionTypeDR, Status) [ SqlName = Index_Patient, Type = index ];

Index IndexRequestNo On RequestNo [ SqlName = Index_RequestNo, Type = index, Unique ];

Index IndexRequestTime On (HospitalDR, RequestTime) [ SqlName = Index_RequestTime, Type = index ];

Index IndexWard On (WardDR, RequestTime) [ SqlName = Index_Ward, Type = index ];

/// DDL Primary Key Specification
Index PKRQREQUEST On RowID [ PrimaryKey, SqlName = PK_RQ_REQUEST, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单号  
Property RequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 4 ];

/// 就诊类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 就诊病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

/// 就诊日期  
Property AdmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 就诊时间  
Property AdmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 证件类型  
Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 证件号  
Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 支付类型  
Property PaymentTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 14 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 出生日期  
Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 出生时间  
Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 年龄  
Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 民族  
Property EthnicityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 申请医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 申请医生  
Property DoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 申请日期  
Property RequestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 申请时间  
Property RequestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 28 ];

/// 临床症状  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 29 ];

/// 手机号  
Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 30 ];

/// 座机号  
Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 31 ];

/// email  
Property EMail As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 32 ];

/// 身高  
Property Height As %Library.Float [ SqlColumnNumber = 33 ];

/// 体重  
Property Weight As %Library.Float [ SqlColumnNumber = 34 ];

/// 血压  
Property BloodPressure As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 35 ];

/// 生理条件  
Property ClinicalConditionsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 末次月经日期  
Property LMPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 是否怀孕  {1:true,0:false}
Property Pregnant As %Library.Boolean [ SqlColumnNumber = 38 ];

/// 怀孕周数  
Property PregnantWeeks As %Library.Float [ SqlColumnNumber = 39 ];

/// ABO血型  
Property AboDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// RH血型  
Property RhDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 42 ];

/// 邮编  
Property PostCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 43 ];

/// 传染标志  {1:true,0:false}
Property InfectFlag As %Library.Boolean [ SqlColumnNumber = 44 ];

/// 院感标志  
Property InfectAlert As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 45 ];

/// 特殊标本标志  {1:true,0:false}
Property SpecialFlag As %Library.Boolean [ SqlColumnNumber = 46 ];

/// 孕次  
Property PregnantNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

/// 产次  
Property ChildbirthNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

/// 状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 49 ];

/// 登记日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

/// 登记时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

/// 登记用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

/// 总费用  
Property FeeSum As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 53 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 54 ];

Storage Default
{
<Data name="RQRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestNo</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="5">
<Value>AdmNo</Value>
</Value>
<Value name="6">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="7">
<Value>AdmDate</Value>
</Value>
<Value name="8">
<Value>AdmTime</Value>
</Value>
<Value name="9">
<Value>CertTypeDR</Value>
</Value>
<Value name="10">
<Value>CertNo</Value>
</Value>
<Value name="11">
<Value>IDNumber</Value>
</Value>
<Value name="12">
<Value>PaymentTypeDR</Value>
</Value>
<Value name="13">
<Value>SurName</Value>
</Value>
<Value name="14">
<Value>GivenName</Value>
</Value>
<Value name="15">
<Value>SpeciesDR</Value>
</Value>
<Value name="16">
<Value>BirthDate</Value>
</Value>
<Value name="17">
<Value>BirthTime</Value>
</Value>
<Value name="18">
<Value>Age</Value>
</Value>
<Value name="19">
<Value>AgeUnitDR</Value>
</Value>
<Value name="20">
<Value>EthnicityDR</Value>
</Value>
<Value name="21">
<Value>HospitalDR</Value>
</Value>
<Value name="22">
<Value>LocationDR</Value>
</Value>
<Value name="23">
<Value>DoctorDR</Value>
</Value>
<Value name="24">
<Value>RequestDate</Value>
</Value>
<Value name="25">
<Value>RequestTime</Value>
</Value>
<Value name="26">
<Value>WardDR</Value>
</Value>
<Value name="27">
<Value>BedNo</Value>
</Value>
<Value name="28">
<Value>Symptom</Value>
</Value>
<Value name="29">
<Value>MobileNo</Value>
</Value>
<Value name="30">
<Value>PhoneNo</Value>
</Value>
<Value name="31">
<Value>EMail</Value>
</Value>
<Value name="32">
<Value>Height</Value>
</Value>
<Value name="33">
<Value>Weight</Value>
</Value>
<Value name="34">
<Value>BloodPressure</Value>
</Value>
<Value name="35">
<Value>ClinicalConditionsDR</Value>
</Value>
<Value name="36">
<Value>LMPDate</Value>
</Value>
<Value name="37">
<Value>Pregnant</Value>
</Value>
<Value name="38">
<Value>PregnantWeeks</Value>
</Value>
<Value name="39">
<Value>AboDR</Value>
</Value>
<Value name="40">
<Value>RhDR</Value>
</Value>
<Value name="41">
<Value>Address</Value>
</Value>
<Value name="42">
<Value>PostCode</Value>
</Value>
<Value name="43">
<Value>InfectFlag</Value>
</Value>
<Value name="44">
<Value>InfectAlert</Value>
</Value>
<Value name="45">
<Value>SpecialFlag</Value>
</Value>
<Value name="46">
<Value>PregnantNum</Value>
</Value>
<Value name="47">
<Value>ChildbirthNum</Value>
</Value>
<Value name="48">
<Value>Status</Value>
</Value>
<Value name="49">
<Value>AddDate</Value>
</Value>
<Value name="50">
<Value>AddTime</Value>
</Value>
<Value name="51">
<Value>AddUserDR</Value>
</Value>
<Value name="52">
<Value>FeeSum</Value>
</Value>
<Value name="53">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RQRequestD</DataLocation>
<DefaultData>RQRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQRequestD</IdLocation>
<IndexLocation>^dbo.RQRequestI</IndexLocation>
<StreamLocation>^dbo.RQRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
