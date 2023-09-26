Class EMRservice.entity.ETitleLinkEvent Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 标题代码
Property TitleCode As %String(TRUNCATE = 1);

/// 事件类型Code(EMRmeta.Events.EventType表的TypeCode)
Property EventCode As %String;

}
