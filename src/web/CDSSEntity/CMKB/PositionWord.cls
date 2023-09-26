/// 名称:方位字典
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-11-16
Class web.CDSSEntity.CMKB.PositionWord Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.PositionWord";

/// rowid
Property ID As %String;

/// 方位词代码（自动生成）
Property PositionCode As %String;

/// 方位词描述
Property PositionDesc As %String(MAXLEN = "");

/// 分类（单纯方位词/特殊方位词/合成方位词）
Property PositionType As %String;

/// 状态0-编辑中，1-已弃用，2-已审核
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property PositionAlias As %String;

}
