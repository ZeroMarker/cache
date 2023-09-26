Class DHCEPRFS.Entity.EMREpisode Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 02 归档系统病人ID
Property MRPatientID As %String(TRUNCATE = 1);

/// 03 系统标示
Property SysCode As %String(TRUNCATE = 1);

/// 04 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 05 创建日期
Property CreateDate As %Date;

/// 06 创建时间
Property CreateTime As %Time;

/// 07 最后修改日期
Property LastModifyDate As %Date;

/// 08 最后修改时间
Property LastModifyTime As %Time;

/// 09 就诊总次数
Property AdmNum As %Integer;

/// 10 入院总次数
Property InNum As %Integer;

/// 11 补充病案号 满足与病案就诊相关的情况
Property MedRecordNo As %String(TRUNCATE = 1);

/// 12 入院就诊号
Property IPRecordNo As %String(TRUNCATE = 1);

/// 13 门诊就诊号
Property OPRecordNo As %String(TRUNCATE = 1);

/// 14 急诊就诊号
Property EPRecordNo As %String(TRUNCATE = 1);

/// 15 就诊日期
Property AdmDate As %Date;

/// 16 就诊时间
Property AdmTime As %Time;

/// 17 出院日期
Property DisDate As %Date;

/// 18 出院时间
Property DisTime As %Time;

/// 19 死亡日期
Property DeathDate As %Date;

/// 20 死亡时间
Property DeathTime As %Date;

/// 21 入院科室
Property AdmLoc As %String(TRUNCATE = 1);

/// 22 入院病区
Property AdmWard As %String(TRUNCATE = 1);

/// 23 出院科室
Property DisLoc As %String(TRUNCATE = 1);

/// 24 出院病区
Property DisWard As %String(TRUNCATE = 1);

/// 25 主管医生
Property MainDoctor As %String(TRUNCATE = 1);

/// 26 就诊类型
Property AdmType As %String(TRUNCATE = 1);

/// 27 入院科室
Property AdmLocID As %String(TRUNCATE = 1);

/// 28 入院病区
Property AdmWardID As %String(TRUNCATE = 1);

/// 29 出院科室
Property DisLocID As %String(TRUNCATE = 1);

/// 30 出院病区
Property DisWardID As %String(TRUNCATE = 1);

/// 31 主管医生
Property MainDoctorID As %String(TRUNCATE = 1);

/// 32 就诊类型
Property AdmTypeID As %String(TRUNCATE = 1);

/// 33 转科科别
Property TransDept As %String(TRUNCATE = 1);

/// 34 转科科别ID
Property TransDeptID As %String(TRUNCATE = 1);

/// 35 住院天数
Property HospitalDays As %Integer;

/// 36 付费方式
Property PayMode As %String(TRUNCATE = 1);

/// 37 费用
Property AllPay As %String(TRUNCATE = 1);

/// 38 病案质量
Property MedQuality As %String(TRUNCATE = 1);

/// 39 危重病人
Property IsCritiCal As %String(TRUNCATE = 1);

/// 40 主任（副）医师
Property SeniorDocID As %String(TRUNCATE = 1);

/// 41 主任（副）医师
Property SeniorDoc As %String(TRUNCATE = 1);

/// 42 住院医师
Property InHospitlDocID As %String(TRUNCATE = 1);

/// 43 住院医师
Property InHospitlDoc As %String(TRUNCATE = 1);

/// 44 科主任
Property LocManagerID As %String(TRUNCATE = 1);

/// 45 科主任
Property LocManager As %String(TRUNCATE = 1);

/// 46 质控医师ID
Property QualityDocID As %String(TRUNCATE = 1);

/// 47 质控医师
Property QualityDoc As %String(TRUNCATE = 1);

/// 48 母亲就诊RowID
Property MotherEpisodeID As %String(TRUNCATE = 1);

/// 49 主治医生ID
Property AttendingDocID As %String(TRUNCATE = 1);

/// 50 主治医生
Property AttendingDoc As %String(TRUNCATE = 1);

/// 51 归档病案ID
Property MRMedRecordID As %String(TRUNCATE = 1);

/// 52 非计划再次手术
Property NoPlanAgainOp As %String(TRUNCATE = 1);

/// 53 医保细分类
Property InsuranceType As %String(TRUNCATE = 1);

/// 54 医保细分类代码
Property InsuranceTypeCode As %String(TRUNCATE = 1);

/// 55 付费方式代码
Property PayModeCode As %String(TRUNCATE = 1);

/// 56 出院日期 - 医生
Property DisDateDoc As %Date;

/// 57 出院时间 - 医生
Property DisTimeDoc As %Time;

/// 58 护士标志，现用来表示是否欠费，N-不欠费，Y-欠费，空值-未使用
Property FlagFinalAccountRemark As %String(TRUNCATE = 1);

/// 59 入院途径代码，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
Property InPatientWayCode As %String(TRUNCATE = 1);

/// 60 入院途径描述，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
Property InPatientWayDesc As %String(TRUNCATE = 1);

}
