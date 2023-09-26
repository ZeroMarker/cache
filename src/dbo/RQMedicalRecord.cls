/// 申请病案号
Class dbo.RQMedicalRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_MedicalRecord, StorageStrategy = Default ]
{

/// Foreign Key FKMedicalRecordHospital created via DDL
ForeignKey FKMedicalRecordHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_MedicalRecordHospital ];

/// Foreign Key FKMedicalRecordPat created via DDL
ForeignKey FKMedicalRecordPat(PatientDR) References dbo.RQPatient(PKRQPATIENT) [ SqlName = FK_MedicalRecordPat ];

/// Foreign Key FKMedicalRecordType created via DDL
ForeignKey FKMedicalRecordType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_MedicalRecordType ];

Index IndexMaster On (HospitalDR, AdmissionTypeDR, RecordNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPerson On (PatientDR, HospitalDR, AdmissionTypeDR, RecordNo) [ SqlName = Index_Person, Type = index ];

Index IndexRecordNo On (RecordNo, HospitalDR, AdmissionTypeDR) [ SqlName = Index_RecordNo, Type = index ];

/// DDL Primary Key Specification
Index PKRQMEDICALRECORD On RowID [ PrimaryKey, SqlName = PK_RQ_MEDICALRECORD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 就诊类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 病案号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

/// 关联病人  
Property PatientDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 是否在用  {1:true,0:false}
Property Used As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RQMedicalRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="4">
<Value>RecordNo</Value>
</Value>
<Value name="5">
<Value>PatientDR</Value>
</Value>
<Value name="6">
<Value>Used</Value>
</Value>
</Data>
<DataLocation>^dbo.RQMedicalRecordD</DataLocation>
<DefaultData>RQMedicalRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQMedicalRecordD</IdLocation>
<IndexLocation>^dbo.RQMedicalRecordI</IndexLocation>
<StreamLocation>^dbo.RQMedicalRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
