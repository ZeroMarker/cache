/// Desc:		消息体
/// Creator:	yejian
/// CreateDate:	2019-1-15
Class EMRservice.entity.EventMessage.EEvent Extends (%RegisteredObject, %XML.Adaptor)
{

/// 消息ID
Property EventID As %String(TRUNCATE = 1);

/// 消息体
Property MessageBoby As %String(TRUNCATE = 1);

/// 模板ID
Property TempalteID As %String(TRUNCATE = 1);

/// 科室ID
Property CTlocID As %String(TRUNCATE = 1);

}
