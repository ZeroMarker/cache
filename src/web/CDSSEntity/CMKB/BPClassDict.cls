/// Description：输血品分类字典表 
/// Table：CT.WDT.CDSS.BPClassDict
Class web.CDSSEntity.CMKB.BPClassDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.BPClassDict";

/// BPClassRowId
Property BPClassRowId As %String;

/// 输血品分类编码
Property BPClassCode As %String;

/// 输血品分类名称
Property BPClassName As %String;

/// 输血品分类拼音
Property BPClassPinyin As %String;

/// 汉语首拼
Property BPClassFirstPinyin As %String;

/// 输血品分类说明
Property BPClassDesc As %String;

/// 操作时间
Property UpdateDate As %String;

/// 操作人
Property UpdateUser As %String;

/// 使用标志
Property UseFlag As %String;

/// 别名
Property BPClassAlias As %String;

}
