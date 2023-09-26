/// 名称：诱因/病因字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-07
Class web.CDSSEntity.CMKB.PathogenyDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.PathogenyDict";

Property ID As %String;

/// 病因代码
Property PathogenyCode As %String;

/// 病因名称
Property PathogenyDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property PathogenyAlias As %String;

}
