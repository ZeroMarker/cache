/// 名称：		EPRservice.entity.EGlossaryItemMap
/// 描述：		模版数据允许值持久化类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.entity.EGlossaryItemMap Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 关联EPRmeta.GlossaryItem的ID
Property GlossaryItemID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模版数据ID
Property TempID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模版描述
Property TempDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元允许值ID
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据元允许值描述
Property DEVDes As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元允许值标示符关联ID
Property DECVMID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字典单元：编码，其他为空
Property CodeSystem As %String(MAXLEN = 50, TRUNCATE = 1);

}
