/// 名称：药物剂型分类表 
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-08-27
Class web.CDSSEntity.CMKB.DosageForm Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DosageForm";

Property ID As %String;

/// 剂型编码
Property DosageFormCode As %String;

/// 剂型描述
Property DosageFormDesc As %String;

/// 父节点
Property ParentDR As %String;

/// 父节点名称
Property ParentDRName As %String;

/// 状态（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property DosageAlias As %String;

}
