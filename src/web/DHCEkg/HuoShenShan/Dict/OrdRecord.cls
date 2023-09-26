Class web.DHCEkg.HuoShenShan.Dict.OrdRecord Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "record";

/// 流水号
Property SerialNO As %String;

/// 病人号
Property PatientID As %String;

/// 病人姓名
Property PatientName As %String;

/// 病人性别
Property PatientSex As %String;

/// 病人年龄
Property PatientAge As %String;

/// 年龄单位
Property PatientAgeUnit As %String;

/// 病人出生日期
Property PatientBirthDate As %String;

/// 身高
Property Height As %String;

/// 身高单位
Property HeightUnit As %String;

/// 体重
Property Weight As %String;

/// 体重单位
Property WeightUnit As %String;

/// 舒张压
Property DiastolicBP As %String;

/// 收缩压
Property SystolicBP As %String;

/// 血压单位
Property BPUnit As %String;

/// 检查科室
Property ExamDepartment As %String;

/// 申请科室
Property RequestDepartment As %String;

/// 预约日期
Property RequestDate As %String;

/// 申请号
Property RequestID As %String;

/// 检查优先级
Property Priority As %String;

/// 检查项目
Property ExamItem As %String;

/// 医嘱
Property DoctorAdvice As %String;

/// 病区
Property WardNo As %String;

/// 病床号
Property SickBedNo As %String;

/// 种族
Property Race As %String;

/// 起搏器
Property Pacemaker As %String;

/// 用药
Property DrugsTaken As %String;

/// 自定义项1名称
Property CustomName1 As %String;

/// 自定义项1内容
Property CustomContent1 As %String;

/// 自定义项2名称
Property CustomName2 As %String;

/// 自定义项2内容
Property CustomContent2 As %String;

}
