Class web.Entity.CT.SSUser Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSUser";

// rowid

Property SSUSRRowId As %String;

// 工号

Property SSUSRInitials As %String;

// 姓名

Property SSUSRName As %String;

// 密码

Property SSUSRPassword As %String;

// 默认登录科室

Property SSUSRDefaultDeptDR As %String;

// 安全组

Property SSUSRGroup As %String;

// 医院

Property SSUSRHospitalDR As %String;

// 默认语言

Property SSUSRCTLANDR As %String;

// 医护人员

Property SSUSRCareProvDR As %String;

// 允许用户更改登录科室

Property SSUSRChangeLocation As %String;

// 医嘱签名密码

Property SSUSRPin As %String;

// 激活

Property SSUSRActive As %String;

Property SSUSRLastUpdateUserDR As %String;

Property SSUSRLastUpdateDate As %String;

Property SSUSRLastUpdateTime As %String;

// 开始日期

Property SSUSRDateFrom As %String;

// 结束日期

Property SSUSRDateTo As %String;

// 下次登录时强制用户改变密码

Property SSUSRPasswordChanged As %String;

// 管理员用户

Property SSUSRAdmitted As %String;

// 忽略CA登录控制

Property SSUSRIgnoreCALogon As %String;

Property SSUSRUseDeptAsDefault As %String;

// 身份证号 2019-05-25

Property SSUSRFreeText1 As %String;

// 性别

Property SSUSRFreeText2 As %String;

// 备注

Property SSUSRFreeText3 As %String;

// 手机号

Property SSUSRMobile As %String;

// 邮箱

Property SSUSREmail As %String;

// 办公电话

Property SSUSRPager As %String;

// 行政科室

Property SSUSRDefRBDepartmentDR As %String;

// 人员唯一标识码

Property SSUSRHOSPersonDR As %String;

// 系统排序号

Property SSUSRSeqNo As %String;

// 拼音码

Property SSUSRPYCode As %String;

// 五笔码

Property SSUSRWBCode As %String;

// 备注

Property SSUSRMark As %String;

// 系统创建人

Property SSUSRCreatedByDR As %String;

// 系统创建日期

Property SSUSRCreatedDate As %String;

// 系统创建时间

Property SSUSRCreatedTime As %String;

// 启用岗位登录

Property EnablePostLogon As %String;

}
