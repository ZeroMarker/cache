/// 石萧伟
/// 2018-03-29
/// 术语文献管理
Class web.Entity.MKB.MKBDocManage Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBDocManage";

Property MKBDMRowId As %String;

/// 文献代码
Property MKBDMCode As %String;

/// 文献名称
Property MKBDMDesc As %String;

/// 路径
Property MKBDMPath As %String;

/// 文献出处
Property MKBDMSource As %String;

/// 文献类型
Property MKBDMType As %String;

/// 文献上传人
Property MKBDMUpdateUser As %String;

/// 文献上传时间
Property MKBDMUpdateDate As %String;

/// 审核状态
Property MKBDMFlag As %String;

/// 备注
Property MKBDMNote As %String;

/// 关键词
Property MKBDMKeyWord As %String;

/// 文献分类
Property MKBDMClassify As %String;

}
