/// Description：HIS-Location与HR-组织关联关系表 导入Entity类
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-27
Class web.BDPExt.CTDepartmentLocationEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.CTDepartmentLocationEntity";

/// RowId
Property ID As %String;

/// 医疗机构代码
Property OrgCode As %String;

/// 医疗机构名称
Property OrgName As %String;

/// 组织部门表ID
Property DEPLDeptDR As %String;

/// 组织部门表代码
Property DEPRowId As %String;

/// 组织部门表编码
Property DEPCode As %String;

/// 组织部门表名称
Property DEPDesc As %String;

/// Location来源
Property DEPLLocSource As %String;

/// Location rowid
Property DEPLLocID As %String;

/// Location代码
Property DEPLLocCode As %String;

/// Location名称
Property DEPLLocDesc As %String;

/// 上级Location来源
Property DEPLParentLocSource As %String;

/// 上级Location rowid
Property DEPLParentLocID As %String;

/// 上级Location代码
Property DEPLParentLocCode As %String;

/// 上级Location名称
Property DEPLParentLocDesc As %String;

/// 开始日期
Property DEPLDateFrom As %String;

/// 结束日期
Property DEPLDateTo As %String;

}
