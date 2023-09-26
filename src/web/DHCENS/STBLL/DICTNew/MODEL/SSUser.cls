Class web.DHCENS.STBLL.DICTNew.MODEL.SSUser Extends (%RegisteredObject, %XML.Adaptor)
{

/// 登录ID
Property SSUSRId As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_Id");

/// 姓名
Property SSUSRName As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_Name");

/// 密码
Property SSUSRPassword As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_Password");

/// 默认语言
Property SSUSRCTLANCode As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_CTLANCode");

/// 默认角色
Property SSUSRRoleCode As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_RoleCode");

/// 用户激活(Y/N)
Property SSUSRActive As %Library.String(MAXLEN = 1, XMLNAME = "SSUSR_Active");

/// 最后更新人
Property SSUSRLastUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_LastUpdateUserCode");

/// 最后更新日期
Property SSUSRLastUpdateDate As %Library.Date(XMLNAME = "SSUSR_LastUpdateDate");

/// 最后更新时间
Property SSUSRLastUpdateTime As %Library.Time(XMLNAME = "SSUSR_LastUpdateTime");

/// 备注
Property SSUSRRemark As %Library.String(MAXLEN = 50, XMLNAME = "SSUSR_Remark");

/// 密码(密文)
Property SSUSRPwd As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "SSUSR_Pwd");

/// 盐
Property SSUSRSalt As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "SSUSR_Salt");

/// 所属医院
Property HospitalCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "HospitalCode");

/// 用户电话号码
Property SSUSRPhoneNum As %Library.String(COLLATION = "EXACT", MAXLEN = 20, XMLNAME = "SSUSR_PhoneNum");

/// 用户电子邮箱
Property SSUSREmail As %Library.String(COLLATION = "EXACT", MAXLEN = 100, XMLNAME = "SSUSR_Email");

/// 用户默认登录科室
Property SSUSRDeptCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "SSUSR_DeptCode");

/// 用户默认登录安全组
Property SSUSRSecuGroupCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "SSUSR_SecuGroupCode");

Parameter XMLNAME = "SS_User";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

}
