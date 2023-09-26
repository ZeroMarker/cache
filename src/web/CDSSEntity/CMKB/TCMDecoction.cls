/// 名称:中药煎法字典
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-08-19
Class web.CDSSEntity.CMKB.TCMDecoction Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMDecoction";

/// rowid
Property ID As %String;

/// 煎法编码
Property DecoctionCode As %String;

/// 煎法名称
Property DecoctionName As %String;

/// 适用中药
Property DecoctionApplication As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property DecoctionAlias As %String;

}
