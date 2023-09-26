Class dhcinterface.Portal.RegInfoRequest Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 用户的ID号
Property UserID As %String(TRUNCATE = 1);

/// 用户名
Property LoginName As %String(TRUNCATE = 1);

/// 密码
Property Password As %String(TRUNCATE = 1);

/// 昵称
Property NickName As %String(TRUNCATE = 1);

/// 安全邮箱
Property SafeEmal As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 出生日期
Property DateofBirth As %Date;

/// 证件类型代码
Property CredentialTypeCode As %String(TRUNCATE = 1);

/// 证件号
Property CredentialNo As %String(TRUNCATE = 1);

/// 家庭住址
Property Adress As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 工作单位
Property CompanyName As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 性别
Property Gender As %String(TRUNCATE = 1);

/// 国籍
Property Nation As %String(TRUNCATE = 1);

/// 民族
Property Nationality As %String(TRUNCATE = 1);

/// 职业
Property Occupation As %String(TRUNCATE = 1);

/// 婚姻状况
Property Marriage As %String(TRUNCATE = 1);

/// 血型
Property BloodType As %String(TRUNCATE = 1);

/// 性别描述
Property GenderName As %String(TRUNCATE = 1);

/// 国籍描述
Property NationName As %String(TRUNCATE = 1);

/// 民族描述
Property NationalityName As %String(TRUNCATE = 1);

/// 职业描述
Property OccupationName As %String(TRUNCATE = 1);

/// 婚姻状况描述
Property MarriageName As %String(TRUNCATE = 1);

/// 血型描述
Property BloodTypeName As %String(TRUNCATE = 1);

/// 医疗机构代码
Property OrganCode As %String(TRUNCATE = 1);

/// 登记号
Property PatientNo As %String(TRUNCATE = 1);

/// 卡类型
Property CardType As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 权限组(非区域协同项目使用)
Property GroupItem As %String(MAXLEN = 1000, TRUNCATE = 1);

}
