Class CIS.AN.DTO.HIS.Patient Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Patient";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 患者卡号
Property CardID As %String(TRUNCATE = 1);

/// 患者身份证号
Property CertID As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 姓名拼音码
Property Alias As %String(TRUNCATE = 1);

/// 出生日期
Property Birthday As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 住院登记号
Property InpatientNo As %String(TRUNCATE = 1);

/// 门诊登记号
Property OutpatientNo As %String(TRUNCATE = 1);

/// 激活标志
Property Active As %String(TRUNCATE = 1);

/// Deceased Flag
Property Deceased As %String(TRUNCATE = 1);

/// Deceased Date
Property DeceasedDate As %String(TRUNCATE = 1);

/// Deceased Time
Property DeceasedTime As %String(TRUNCATE = 1);

/// 患者民族
Property Nation As %String(TRUNCATE = 1);

/// 社保状态
Property SocialStatus As %String(TRUNCATE = 1);

/// 家庭住址
Property Address As %String(TRUNCATE = 1);

/// 手机号码
Property TelephoneNo As %String(TRUNCATE = 1);

/// 患者保密级别
Property SecretLevel As %String(TRUNCATE = 1);

/// 患者保密代码
Property SecretCode As %String(TRUNCATE = 1);

}
