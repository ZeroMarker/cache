/// 名称：		EPRservice.entity.EDataElementCategory
/// 描述：		数据元范畴持久化类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.entity.EDataElementCategory Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 数据元名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

}
