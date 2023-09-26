/// 名称：检查结果字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-08
Class web.CDSSEntity.CMKB.ExamResultDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ExamResultDict";

Property ID As %String;

/// 检查结果代码
Property ERCode As %String;

/// 检查结果名称
Property ERDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ExamResultAlias As %String;

}
