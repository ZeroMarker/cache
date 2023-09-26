/// 名称:组织部门表-HCP同步数据 实体类
/// 编写者:基础平台组-likefan
/// 编写日期: 2020-07-25
Class web.Entity.CT.CTDepartment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTDepartment";

/// RowId
Property ID As %String;

/// HR里（MDM平台）的组织部门代码
Property DEPRowId As %String;

/// 编码
Property DEPCode As %String;

/// 描述
Property DEPDesc As %String;

/// 简称
Property DEPAlias As %String;

/// 联系电话
Property DEPOfficePhone As %String;

/// HR科室分类
Property DEPCategory As %String;

/// 上级组织部门ID
Property DEPParentDR As %String;

/// HIS医疗机构
Property DEPRefClinDR As %String;

/// 组织属性
Property DEPAtrribute As %String;

/// 修改人ID
Property DEPUpdateUserID As %String;

/// 修改人名称
Property DEPUpdateUserName As %String;

/// 部门性质
Property DEPCharacter As %String;

/// 支出属性
Property DEPPayAtrribute As %String;

/// 是否采购部门 
Property DEPPurchaseFlag As %String;

/// 分摊性质
Property DEPShareCharacter As %String;

/// 开始日期
Property DEPDateFrom As %String;

/// 结束日期
Property DEPDateTo As %String;

/// 国家编码
Property DEPNationalCode As %String;

/// 地址
Property DEPOfficeAddress As %String;

}
