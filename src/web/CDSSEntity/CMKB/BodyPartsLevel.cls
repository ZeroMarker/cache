/// 名称：部位分层表 
/// 描述：实体类
/// 编写者：赵文伟
/// 编写日期：2021-11-15
Class web.CDSSEntity.CMKB.BodyPartsLevel Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.BodyPartsLevel";

/// ID
Property ID As %String;

/// 部位指针
Property BodyPartDR As %String;

/// 部位名称
Property BodyPartName As %String;

/// 父节点/上层分类
Property BodyLastLevel As %String;

/// 父节点/上层分类指针
Property BodyLastLevelDR As %String;

/// 父节点名称/上层分类名称
Property BodyLastLevelName As %String;

/// 层级类型（系统/解剖）
Property LevelType As %String;

/// 状态（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property Alias As %String;

}
