/// 名称：会诊医嘱字典表 
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-27
Class web.CDSSEntity.CMKB.ConsultationDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ConsultationDict";

Property ID As %String;

/// 会诊代码
Property ConsultCode As %String;

/// 会诊名称
Property ConsultDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ConsultAlias As %String;

}
