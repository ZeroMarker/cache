/// Description： 知识提交实体类
/// Creator：程和贵
/// Date：2018-03-29
Class web.Entity.MKB.MKBKnoManage Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBKnoManage";

Property MKBKMRowId As %String;

/// 代码
Property MKBKMCode As %String;

/// 名称
Property MKBKMDesc As %String;

/// 路径
Property MKBKMPath As %String;

/// 出处
Property MKBKMSource As %String;

/// 类型
Property MKBKMType As %String;

/// 上传人
Property MKBKMUpdateUser As %String;

/// 上传时间
Property MKBKMUpdateDate As %String;

/// 审核状态
Property MKBKMFlag As %String;

/// 备注
Property MKBKMNote As %String;

/// 科室
Property MKBKMUpdateLoc As %String;

/// 术语ID
Property MKBKMTermDr As %String;

/// 属性ID
Property MKBKMProDr As %String;

/// 扩展属性ID串
Property MKBKMDetail As %String;

/// 微信小程序(mini)和电脑端(computer)的区分标志
Property MKBKMMiniFlag As %String;

/// 审核不通过的原因
Property MKBKMFailureReason As %String;

}
