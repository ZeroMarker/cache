/// 描述: HIS-Location与HR-组织关联关系表(HCP) Entity
/// 编写者：基础数据平台 likefan
/// 编写日期: 2020-07-25
Class web.Entity.CT.CTDepartmentLocation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTDepartmentLocation";

/// RowId
Property ID As %String;

/// 组织部门表ID
Property DEPLDeptDR As %String;

/// Location 来源
Property DEPLLocSource As %String;

/// Location rowid
Property DEPLLocID As %String;

/// Location代码
Property DEPLLocCode As %String;

/// Location名称
Property DEPLLocDesc As %String;

/// 上次Location 来源
Property DEPLParentLocSource As %String;

/// 上级 Location rowid
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
