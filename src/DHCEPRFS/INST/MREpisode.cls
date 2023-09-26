Class DHCEPRFS.INST.MREpisode Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 02 归档系统病人ID
Property MRPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 系统标示
Property SysCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 就诊号
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 06 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 07 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 7 ];

/// 08 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 8 ];

/// 09 就诊总次数
Property AdmNum As %Integer [ SqlColumnNumber = 9 ];

/// 10 入院总次数
Property InNum As %Integer [ SqlColumnNumber = 10 ];

/// 11 补充病案号 满足与病案就诊相关的情况
Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 12 入院就诊号
Property IPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 13 门诊就诊号
Property OPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 14 急诊就诊号
Property EPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 15 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 15 ];

/// 16 就诊时间
Property AdmTime As %Time [ SqlColumnNumber = 16 ];

/// 17 出院日期
Property DisDate As %Date [ SqlColumnNumber = 17 ];

/// 18 出院时间
Property DisTime As %Time [ SqlColumnNumber = 18 ];

/// 19 死亡日期
Property DeathDate As %Date [ SqlColumnNumber = 19 ];

/// 20 死亡时间
Property DeathTime As %Time [ SqlColumnNumber = 20 ];

/// 21 入院科室
Property AdmLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

/// 22 入院病区
Property AdmWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

/// 23 出院科室
Property DisLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 23 ];

/// 24 出院病区
Property DisWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

/// 25 主管医生
Property MainDoctor As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

/// 26 就诊类型
Property AdmType As %String(TRUNCATE = 1) [ SqlColumnNumber = 26 ];

/// 27 入院科室
Property AdmLocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

/// 28 入院病区
Property AdmWardID As %String(TRUNCATE = 1) [ SqlColumnNumber = 28 ];

/// 29 出院科室
Property DisLocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 29 ];

/// 30 出院病区
Property DisWardID As %String(TRUNCATE = 1) [ SqlColumnNumber = 30 ];

/// 31 主管医生
Property MainDoctorID As %String(TRUNCATE = 1) [ SqlColumnNumber = 31 ];

/// 32 就诊类型
Property AdmTypeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 32 ];

/// 33 转科科别
Property TransDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 33 ];

/// 34 转科科别ID
Property TransDeptID As %String(TRUNCATE = 1) [ SqlColumnNumber = 34 ];

/// 35 住院天数
Property HospitalDays As %Integer [ SqlColumnNumber = 35 ];

/// 36 付费方式
Property PayMode As %String(TRUNCATE = 1) [ SqlColumnNumber = 36 ];

/// 37 费用
Property AllPay As %String(TRUNCATE = 1) [ SqlColumnNumber = 37 ];

/// 38 病案质量
Property MedQuality As %String(TRUNCATE = 1) [ SqlColumnNumber = 38 ];

/// 39 危重病人
Property IsCritiCal As %String(TRUNCATE = 1) [ SqlColumnNumber = 39 ];

/// 40 主任（副）医师
Property SeniorDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 40 ];

/// 41 主任（副）医师
Property SeniorDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 41 ];

/// 42 住院医师
Property InHospitlDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 42 ];

/// 43 住院医师
Property InHospitlDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 43 ];

/// 44 科主任
Property LocManagerID As %String(TRUNCATE = 1) [ SqlColumnNumber = 44 ];

/// 45 科主任
Property LocManager As %String(TRUNCATE = 1) [ SqlColumnNumber = 45 ];

/// 46 质控医师ID
Property QualityDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 46 ];

/// 47 质控医师
Property QualityDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 47 ];

/// 48 母亲就诊RowID
Property MotherEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 48 ];

/// 49 主治医生ID
Property AttendingDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 49 ];

/// 50 主治医生
Property AttendingDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 50 ];

/// 51 归档病案ID
Property MRMedRecordID As %String(TRUNCATE = 1) [ SqlColumnNumber = 51 ];

/// 52 非计划再次手术
Property NoPlanAgainOp As %String(TRUNCATE = 1) [ SqlColumnNumber = 52 ];

/// 53 医保细分类
Property InsuranceType As %String(TRUNCATE = 1) [ SqlColumnNumber = 53 ];

/// 54 医保细分类代码
Property InsuranceTypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 54 ];

/// 55 付费方式代码
Property PayModeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 55 ];

/// 56 出院日期 - 医生
Property DisDateDoc As %Date [ SqlColumnNumber = 56 ];

/// 57 出院时间 - 医生
Property DisTimeDoc As %Time [ SqlColumnNumber = 57 ];

/// 58 护士标志，现用来表示是否欠费，N-不欠费，Y-欠费，空值-未使用
Property FlagFinalAccountRemark As %String(TRUNCATE = 1) [ SqlColumnNumber = 58 ];

/// 59 入院途径代码，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
Property InPatientWayCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 59 ];

/// 60 入院途径描述，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
Property InPatientWayDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 60 ];

/// 61 入监信息ID
Property ImprisonID As %String(TRUNCATE = 1) [ SqlColumnNumber = 61 ];

/// 62 关联就诊号
Property OriginEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 62 ];

/// 63 关联归档就诊号
Property OriginMREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 63 ];

/// 64 被关联就诊号
Property ExtendEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 64 ];

/// 65 被关联归档就诊号
Property ExtendMREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 65 ];

/// 66 就诊信息来源
Property Source As %String(TRUNCATE = 1) [ SqlColumnNumber = 66 ];

Index IdxAdmDate On (AdmDate, MRPatientID);

Index IdxDisDate On (DisDate, MRPatientID);

Index IdxDisDateDoc On (DisDateDoc, MRPatientID);

Index IdxMRPatientID On MRPatientID;

Index IdxMedRecordNo On MedRecordNo;

Index IdxMRMedRecordID On MRMedRecordID;

Index IdxDisLocDisDate On (DisLocID, DisDate);

Index IdxEpisodeID On (MRPatientID, SysCode, EpisodeID) [ Unique ];

Index IdxMotherEpisodeID On (SysCode, MotherEpisodeID);

Index IdxSysCodeAndEpisodeID On (SysCode, EpisodeID) [ Unique ];

Index idxMedRecordNoDisDate On (MedRecordNo, AdmDate, AdmTime);

Index IdxCreateDate On CreateDate;

Index IdxImprisonID On ImprisonID;

Storage Default
{
<Data name="MREpisodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPatientID</Value>
</Value>
<Value name="3">
<Value>SysCode</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>AdmNum</Value>
</Value>
<Value name="10">
<Value>InNum</Value>
</Value>
<Value name="11">
<Value>MedRecordNo</Value>
</Value>
<Value name="12">
<Value>IPRecordNo</Value>
</Value>
<Value name="13">
<Value>OPRecordNo</Value>
</Value>
<Value name="14">
<Value>EPRecordNo</Value>
</Value>
<Value name="15">
<Value>AdmDate</Value>
</Value>
<Value name="16">
<Value>AdmTime</Value>
</Value>
<Value name="17">
<Value>DisDate</Value>
</Value>
<Value name="18">
<Value>DisTime</Value>
</Value>
<Value name="19">
<Value>DeathDate</Value>
</Value>
<Value name="20">
<Value>DeathTime</Value>
</Value>
<Value name="21">
<Value>AdmLoc</Value>
</Value>
<Value name="22">
<Value>AdmWard</Value>
</Value>
<Value name="23">
<Value>DisLoc</Value>
</Value>
<Value name="24">
<Value>DisWard</Value>
</Value>
<Value name="25">
<Value>MainDoctor</Value>
</Value>
<Value name="26">
<Value>AdmType</Value>
</Value>
<Value name="27">
<Value>AdmLocID</Value>
</Value>
<Value name="28">
<Value>AdmWardID</Value>
</Value>
<Value name="29">
<Value>DisLocID</Value>
</Value>
<Value name="30">
<Value>DisWardID</Value>
</Value>
<Value name="31">
<Value>MainDoctorID</Value>
</Value>
<Value name="32">
<Value>AdmTypeID</Value>
</Value>
<Value name="33">
<Value>TransDept</Value>
</Value>
<Value name="34">
<Value>TransDeptID</Value>
</Value>
<Value name="35">
<Value>HospitalDays</Value>
</Value>
<Value name="36">
<Value>PayMode</Value>
</Value>
<Value name="37">
<Value>AllPay</Value>
</Value>
<Value name="38">
<Value>MedQuality</Value>
</Value>
<Value name="39">
<Value>IsCritiCal</Value>
</Value>
<Value name="40">
<Value>SeniorDocID</Value>
</Value>
<Value name="41">
<Value>SeniorDoc</Value>
</Value>
<Value name="42">
<Value>InHospitlDocID</Value>
</Value>
<Value name="43">
<Value>InHospitlDoc</Value>
</Value>
<Value name="44">
<Value>LocManagerID</Value>
</Value>
<Value name="45">
<Value>LocManager</Value>
</Value>
<Value name="46">
<Value>QualityDocID</Value>
</Value>
<Value name="47">
<Value>QualityDoc</Value>
</Value>
<Value name="48">
<Value>MotherEpisodeID</Value>
</Value>
<Value name="49">
<Value>AttendingDocID</Value>
</Value>
<Value name="50">
<Value>AttendingDoc</Value>
</Value>
<Value name="51">
<Value>MRMedRecordID</Value>
</Value>
<Value name="52">
<Value>NoPlanAgainOp</Value>
</Value>
<Value name="53">
<Value>InsuranceType</Value>
</Value>
<Value name="54">
<Value>InsuranceTypeCode</Value>
</Value>
<Value name="55">
<Value>PayModeCode</Value>
</Value>
<Value name="56">
<Value>DisDateDoc</Value>
</Value>
<Value name="57">
<Value>DisTimeDoc</Value>
</Value>
<Value name="58">
<Value>AdmTypeDesc</Value>
</Value>
<Value name="59">
<Value>FlagFinalAccountRemark</Value>
</Value>
<Value name="60">
<Value>InPatientWayCode</Value>
</Value>
<Value name="61">
<Value>InPatientWayDesc</Value>
</Value>
<Value name="62">
<Value>ImprisonID</Value>
</Value>
<Value name="63">
<Value>OriginEpisodeID</Value>
</Value>
<Value name="64">
<Value>OriginMREpisodeID</Value>
</Value>
<Value name="65">
<Value>ExtendEpisodeID</Value>
</Value>
<Value name="66">
<Value>ExtendMREpisodeID</Value>
</Value>
<Value name="67">
<Value>Source</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeD</DataLocation>
<DefaultData>MREpisodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
