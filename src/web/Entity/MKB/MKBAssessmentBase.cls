/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库评分表注册实体类
/// Table：User.MKBAssessmentBase
Class web.Entity.MKB.MKBAssessmentBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBAssessmentBase";

Property MKBABRowId As %String;

/// 代码	
Property MKBABCode As %String;

/// 标题
Property MKBABDesc As %String;

/// 备注
Property MKBABNote As %String;

}
