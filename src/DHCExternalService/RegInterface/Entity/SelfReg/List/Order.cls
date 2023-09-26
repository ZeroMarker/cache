Class DHCExternalService.RegInterface.Entity.SelfReg.List.Order Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 挂号id
Property AdmNo As %String(TRUNCATE = 1);

/// 挂号日期(YYYY-MM-DD)
Property RegDate As %String(TRUNCATE = 1);

/// 状态
Property Status As %String(TRUNCATE = 1);

/// 患者姓名
Property PatName As %String(TRUNCATE = 1);

/// 病人id
Property PatientID As %String(TRUNCATE = 1);

/// 就诊日期(YYYY-MM-DD)
Property AdmitDate As %String(TRUNCATE = 1);

/// 医院
Property HospitalName As %String(TRUNCATE = 1);

/// 就诊科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生
Property Doctor As %String(TRUNCATE = 1);

/// 医生职称
Property DoctorTitle As %String(TRUNCATE = 1);

/// 总费用
Property RegFee As %String(TRUNCATE = 1);

/// 就诊序号
Property SeqCode As %String(TRUNCATE = 1);

/// 候诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 就诊时段
Property SessionName As %String(TRUNCATE = 1);

/// 候诊时间
Property AdmitRange As %String(TRUNCATE = 1);

/// 专业名称
Property ServiceName As %String(TRUNCATE = 1);

/// 医保退号适用串(以&分割的N个入参)，有值时退号需调用医保注销接口
Property InsuRegInfo As %String(TRUNCATE = 1);

/// 可退号标志(Y/N)
Property ReturnFlag As %String(TRUNCATE = 1);

/// 不可退号原因
Property ReturnMsg As %String(TRUNCATE = 1);

}
