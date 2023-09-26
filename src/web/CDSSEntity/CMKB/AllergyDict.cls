/// 名称:过敏史字典表
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-15
Class web.CDSSEntity.CMKB.AllergyDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.AllergyDict";

/// rowid
Property ID As %String;

/// 过敏史代码
Property AllergyCode As %String;

/// 过敏史名称
Property AllergyDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property AllergyAlias As %String;

}
