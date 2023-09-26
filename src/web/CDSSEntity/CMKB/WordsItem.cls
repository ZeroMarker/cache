/// 名称：识别词项目字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-12
Class web.CDSSEntity.CMKB.WordsItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.WordsItem";

Property ID As %String;

/// 识别词项目代码
Property WordsItemCode As %String;

/// 识别词项目描述
Property WordsItemDesc As %String;

/// 父节点
Property ParentDR As %String;

/// 项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
Property ItemType As %String;

/// 关联表名
Property TableName As %String;

/// 关联字段名
Property FiledName As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 项目类别（中医、西医）
Property ItemCategory As %String;

}
