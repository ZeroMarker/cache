Class EMRservice.entity.ECommonEleCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 模板模板标识符Code 遵循电子病历基本架构中业务活动记录EMRxxx
Property TemCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板描述 DisplayName
Property TemDisplayName As %String(MAXLEN = 200, TRUNCATE = 1);

}
