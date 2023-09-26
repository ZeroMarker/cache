/// 名称：		EMRservice.entity.ETitles
/// 描述：		标题Entity
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRservice.entity.ETitles Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 别名（拼音简写)
Property Alias As %String(TRUNCATE = 1);

}
