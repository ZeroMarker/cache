Class CIS.AN.DTO.HIS.Person Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Person";

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

/// 血型
Property BloodType As %String(TRUNCATE = 1);

/// RH血型
Property RHBloodType As %String(TRUNCATE = 1);

}
