/// 名称：药物类字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-03-04
Class web.CDSSEntity.CMKB.DrugTypeDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ExamResultDict";

Property ID As %String;

/// 药物分类代码
Property DrugTypeCode As %String;

/// 药物分类名称
Property DrugTypeDesc As %String;

/// 状态（0已审核，1编辑中，2已删除）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property AliasName As %String;

}
