/// 名称:EMRservice.entity.ETemplateUserAccess
/// 描述:模板用户模板权限控制对象
/// 编写者：yejian
/// 编写日期: 2018-12-13
Class EMRservice.entity.ETemplateUserAccess Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 用户编号（关联EMRmeta.SuperUser表的SupUserID）
Property SupUserID As %String(TRUNCATE = 1);

/// 用户名
Property SupUserName As %String(TRUNCATE = 1);

/// 模板ID或模板目录ID（temType区分）
Property TemCID As %String(TRUNCATE = 1);

/// 模板名称
Property TempCName As %String(TRUNCATE = 1);

/// 模板类型：CATEGORY:模板目录,TEMPLATE:模板
Property TemType As %String(TRUNCATE = 1);

}
