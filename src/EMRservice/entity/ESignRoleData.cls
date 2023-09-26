/// 名称：		EMRservice.entity.ESignRoleData
/// 描述：		签名对象
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRservice.entity.ESignRoleData Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

/// EMRmeta.EMRAction表的ActionCode
Property ActionCode As %String(TRUNCATE = 1);

/// 1：使用 0：停用
Property IsValid As %String(TRUNCATE = 1);

/// 级别：数值越大级别越高（验证和失效）
Property RoleLevel As %String;

/// 前缀，如果为1，则前面加斜杠
Property SignPrefix As %String(TRUNCATE = 1);

/// 是否可以在多级医师审核单元(Name为"Check")上签名 1：可以 0或空：不可以
Property CanSignOnCheck As %String(TRUNCATE = 1);

/// 是否不验证签名用户，任何人都可签 1：是 0或空：不是
Property NotValidate As %String(TRUNCATE = 1);

}
