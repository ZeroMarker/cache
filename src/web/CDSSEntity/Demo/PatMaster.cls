/// Description：住院Demo-患者基础信息表
/// Table：User.DHCDSSDEMOPatMaster
Class web.CDSSEntity.Demo.PatMaster Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.PatMaster";

/// RowId
Property RowId As %String;

/// 患者主索引
Property IDNO As %String;

/// 病人标识（就诊医院id）
Property PatientDR As %String;

/// 病案号
Property CaseNum As %String;

/// 住院次
Property AdmissionCount As %String;

/// 床号
Property BedNumber As %String;

/// 身份证号
Property IDCardNumber As %String;

/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 出生日期
Property Birthday As %String;

/// 年龄
Property Age As %String;

/// 年龄单位
Property AgeUnit As %String;

/// 电话
Property PhoneNumber As %String;

/// 科室
Property Department As %String;

/// 主诊断
Property MainDiag As %String;

/// 职业
Property Profession As %String;

/// 住址
Property Address As %String;

/// 紧急联系人
Property ContactsName As %String;

/// 联系人电话
Property ContractsPhone As %String;

/// 类型(I/O)
Property Type As %String;

/// 出生地
Property BirthPlace As %String;

/// 工作单位
Property WorkUnitName As %String;

/// 婚姻
Property Marriage As %String;

/// 入院日期
Property AdmisTime As %String;

/// 出院日期
Property DischargeTime As %String;

/// 住院天数
Property HospDays As %String;

/// 死亡时间
Property DeathTime As %String;

/// 陈述人
Property Representor As %String;

/// 记录日期
Property RecordTime As %String;

/// 医院
Property Hospital As %String;

/// 主诊断分类[中医/西医]
Property MainDiagType As %String;

}
