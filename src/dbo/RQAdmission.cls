/// 申请就诊信息
Class dbo.RQAdmission Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_Admission, StorageStrategy = Default ]
{

/// Foreign Key FKAdmissionAddUser created via DDL
ForeignKey FKAdmissionAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AdmissionAddUser ];

/// Foreign Key FKAdmissionBed created via DDL
ForeignKey FKAdmissionBed(BedDR) References dbo.BTBed(PKBTBED) [ SqlName = FK_AdmissionBed ];

/// Foreign Key FKAdmissionCancelUser created via DDL
ForeignKey FKAdmissionCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AdmissionCancelUser ];

/// Foreign Key FKAdmissionDiag created via DDL
ForeignKey FKAdmissionDiag(DiseaseDR) References dbo.BTDisease(PKBTDISEASE) [ SqlName = FK_AdmissionDiag ];

/// Foreign Key FKAdmissionDisUser created via DDL
ForeignKey FKAdmissionDisUser(OutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AdmissionDisUser ];

/// Foreign Key FKAdmissionDoc created via DDL
ForeignKey FKAdmissionDoc(DoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_AdmissionDoc ];

/// Foreign Key FKAdmissionLoc created via DDL
ForeignKey FKAdmissionLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_AdmissionLoc ];

/// Foreign Key FKAdmissionPat created via DDL
ForeignKey FKAdmissionPat(PatientDR) References dbo.RQPatient(PKRQPATIENT) [ SqlName = FK_AdmissionPat ];

/// Foreign Key FKAdmissionType created via DDL
ForeignKey FKAdmissionType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_AdmissionType ];

/// Foreign Key FKAdmissionWard created via DDL
ForeignKey FKAdmissionWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_AdmissionWard ];

Index IndexAddDate On (AddDate, AdmissionTypeDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexAdmStatus On (AdmissionTypeDR, AdmStatus) [ SqlName = Index_AdmStatus, Type = index ];

Index IndexLocTime On (LocationDR, AdmDate) [ SqlName = Index_LocTime, Type = index ];

Index IndexMaster On (PatientDR, AdmissionTypeDR, AdmDate, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOutDate On OutDate [ SqlName = Index_OutDate, Type = index ];

Index IndexWard On (WardDR, CheckOut) [ SqlName = Index_Ward, Type = index ];

/// DDL Primary Key Specification
Index PKRQADMISSION On RowID [ PrimaryKey, SqlName = PK_RQ_ADMISSION, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 病人  
Property PatientDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 日期  
Property AdmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 时间  
Property AdmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 床位  
Property BedDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 主管医生  
Property DoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 是否怀孕  {1:true,0:false}
Property Pregnant As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 怀孕周数  
Property PregnantWeeks As %Library.Float [ SqlColumnNumber = 12 ];

/// 是否出院  {1:true,0:false}
Property CheckOut As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 出院日期  
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 出院时间  
Property OutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 登记日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 登记时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 登记人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 就诊诊断  
Property DiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 取消日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 取消时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 取消人  
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 状态  {1:就诊中,2:出院,3:取消}
Property AdmStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

/// 出院用户  
Property OutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 临床症状  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="RQAdmissionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientDR</Value>
</Value>
<Value name="3">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="4">
<Value>AdmDate</Value>
</Value>
<Value name="5">
<Value>AdmTime</Value>
</Value>
<Value name="6">
<Value>LocationDR</Value>
</Value>
<Value name="7">
<Value>WardDR</Value>
</Value>
<Value name="8">
<Value>BedDR</Value>
</Value>
<Value name="9">
<Value>DoctorDR</Value>
</Value>
<Value name="10">
<Value>Pregnant</Value>
</Value>
<Value name="11">
<Value>PregnantWeeks</Value>
</Value>
<Value name="12">
<Value>CheckOut</Value>
</Value>
<Value name="13">
<Value>OutDate</Value>
</Value>
<Value name="14">
<Value>OutTime</Value>
</Value>
<Value name="15">
<Value>AddDate</Value>
</Value>
<Value name="16">
<Value>AddTime</Value>
</Value>
<Value name="17">
<Value>AddUserDR</Value>
</Value>
<Value name="18">
<Value>DiseaseDR</Value>
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
<Value>AdmStatus</Value>
</Value>
<Value name="23">
<Value>OutUserDR</Value>
</Value>
<Value name="24">
<Value>Symptom</Value>
</Value>
</Data>
<DataLocation>^dbo.RQAdmissionD</DataLocation>
<DefaultData>RQAdmissionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQAdmissionD</IdLocation>
<IndexLocation>^dbo.RQAdmissionI</IndexLocation>
<StreamLocation>^dbo.RQAdmissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
