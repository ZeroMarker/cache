/// 名称：扩展码字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-11
Class web.CDSSEntity.CMKB.ExtendCodeDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ExtendCodeDict";

Property ID As %String;

/// 扩展码代码
Property ExtendCode As %String;

/// 扩展码名称
Property ExtendDesc As %String;

/// 扩展码ICD编码
Property ExtendICD As %String;

/// 版本
Property ExtendVersion As %String;

/// 状态(编辑中、已审核、已删除)
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ExtendAlias As %String;

}
