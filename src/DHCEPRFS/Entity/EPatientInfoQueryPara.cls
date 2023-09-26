Class DHCEPRFS.Entity.EPatientInfoQueryPara Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 归档病案号
Property MRMedRecordNo As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 手机号
Property PhoneNo As %String(TRUNCATE = 1);

/// 民族
Property Nationality As %String(TRUNCATE = 1);

/// 身份证号
Property IDCard As %String(TRUNCATE = 1);

/// 出生日期
Property Birthday As %String(TRUNCATE = 1);

/// 户口地址省
Property HouseProvince As %String(TRUNCATE = 1);

/// 户口地址市
Property HouseCity As %String(TRUNCATE = 1);

/// 婚姻状况
Property Marriage As %String(TRUNCATE = 1);

/// 就诊类型
Property AdmType As %String(TRUNCATE = 1);

/// 入院科室
Property AdmInLoc As %String(TRUNCATE = 1);

/// 出院科室
Property DischgrgeLoc As %String(TRUNCATE = 1);

/// 主管医生
Property MainDoctor As %String(TRUNCATE = 1);

/// 入院开始日期
Property AdmStratDate As %String(TRUNCATE = 1);

/// 入院结束日期
Property AdmEndDate As %String(TRUNCATE = 1);

/// 出院开始日期
Property DisStratDate As %String(TRUNCATE = 1);

/// 出院结束日期
Property DisEndDate As %String(TRUNCATE = 1);

/// 查询用户
Property QueryUserID As %String(TRUNCATE = 1);

/// 留观号
Property ObservedNo As %String(TRUNCATE = 1);

/// 性别
Property Gender As %String(TRUNCATE = 1);

}
