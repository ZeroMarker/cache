/// 患者的就诊信息表
Class DHCEPRFS.INST.OldMedRecordInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 姓名,身份证号,患者ID，老系统就诊号 ,就诊日期 出院日期 入院科室 出院科室 病案号 就诊次数
/// 02 病人姓名
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 身份证号
Property IDCard As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 老系统病人ID
Property OldPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 老系统就诊号
Property OldEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 6 登记号
Property OldRegNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 07 就诊日期
Property AdmDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 08 出院日期
Property DisDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 9 入院科室ID
Property AdmLocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 10 入院科室
Property AdmLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 11 出院科室ID
Property DisLocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 12 出院科室
Property DisLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 13 入院病区
Property AdmWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 14 出院病区
Property DisWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 15 主管医生
Property MainDoctor As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

/// 16 入院病区
Property AdmWardID As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

/// 17 出院病区
Property DisWardID As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 18 病案号
Property OldMedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 19 就诊类型
Property AdmType As %String(TRUNCATE = 1) [ SqlColumnNumber = 19 ];

/// 20 病人ID
Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 20 ];

/// 21 性别
Property Gender As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

/// 22 出生日期
Property Birthday As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

/// 23 现住址省
Property ResidentProvince As %String(TRUNCATE = 1) [ SqlColumnNumber = 23 ];

/// 24 现住址市
Property ResidentCity As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

/// 25 现住址县区
Property ResidentArea As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

/// 26 现住址地址
Property ResidentAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 26 ];

/// 27 现住址邮编
Property ResidentZipCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

Index IdxIDCard On IDCard;

Index IdxAdmDate On AdmDate;

Index IdxDisDate On DisDate;

Index IdxPatientID On PatientID;

Index IdxOldPatientID On OldPatientID;

Index IdxOldEpisodeID On OldEpisodeID [ Unique ];

Storage Default
{
<Data name="OldMedRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>IDCard</Value>
</Value>
<Value name="4">
<Value>OldPatientID</Value>
</Value>
<Value name="5">
<Value>OldEpisodeID</Value>
</Value>
<Value name="6">
<Value>OldRegNo</Value>
</Value>
<Value name="7">
<Value>AdmDate</Value>
</Value>
<Value name="8">
<Value>DisDate</Value>
</Value>
<Value name="9">
<Value>AdmLocID</Value>
</Value>
<Value name="10">
<Value>AdmLoc</Value>
</Value>
<Value name="11">
<Value>DisLocID</Value>
</Value>
<Value name="12">
<Value>DisLoc</Value>
</Value>
<Value name="13">
<Value>AdmWard</Value>
</Value>
<Value name="14">
<Value>DisWard</Value>
</Value>
<Value name="15">
<Value>MainDoctor</Value>
</Value>
<Value name="16">
<Value>AdmWardID</Value>
</Value>
<Value name="17">
<Value>DisWardID</Value>
</Value>
<Value name="18">
<Value>OldMedRecordNo</Value>
</Value>
<Value name="19">
<Value>AdmType</Value>
</Value>
<Value name="20">
<Value>PatientID</Value>
</Value>
<Value name="21">
<Value>Gender</Value>
</Value>
<Value name="22">
<Value>Birthday</Value>
</Value>
<Value name="23">
<Value>ResidentProvince</Value>
</Value>
<Value name="24">
<Value>ResidentCity</Value>
</Value>
<Value name="25">
<Value>ResidentArea</Value>
</Value>
<Value name="26">
<Value>ResidentAddress</Value>
</Value>
<Value name="27">
<Value>ResidentZipCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.OldMedRecD</DataLocation>
<DefaultData>OldMedRecordInfoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.OldMedRecD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.OldMedRecI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.OldMedRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
