/// 名称:腧穴字典
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-08-11
Class web.CDSSEntity.CMKB.TCMAcupoints Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMAcupoints";

/// rowid
Property ID As %String;

/// 腧穴编码
Property AcupointsCode As %String;

/// 腧穴名称
Property AcupointsName As %String;

/// 别名
Property AcupointsAlias As %String;

/// 类属
Property AcupointsGenus As %String;

/// 归经
Property AcupointsChannelTropism As %String;

/// 功效
Property AcupointsEfficacy As %String;

/// 主治
Property AcupointsAttending As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String;

}
