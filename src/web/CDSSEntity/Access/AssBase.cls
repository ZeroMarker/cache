/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库评分表注册实体类
/// Table：CT.WDT.CDSS.AssBase
Class web.CDSSEntity.Access.AssBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssBase";

Property MKBABRowId As %String;

/// 代码	
Property MKBABCode As %String;

/// 标题
Property MKBABDesc As %String;

/// 备注
Property MKBABNote As %String;

/// 版本
Property MKBABVersion As %String;

/// 状态
Property MKBABState As %String;

/// 编辑人
Property MKBABUpdateUser As %String;

/// 编辑时间
Property MKBABUpdateDate As %String;

/// 审核人
Property MKBABAuditUser As %String;

/// 审核时间
Property MKBABAuditDate As %String;

/// 类型（评估量表、医学计算器
Property MKBABType As %String;

/// 别名
Property MKBABAliasName As %String;

/// 结论名
Property MKBABConclusionName As %String;

}
