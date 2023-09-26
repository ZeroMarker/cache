Class EMRservice.entity.ETitleCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 目录名称
Property TitleCategoryName As %String(TRUNCATE = 1);

/// 目录类型 	
Property TitleCategoryType As %String(TRUNCATE = 1);

/// 目录属性扩展参数
Property PropertyParams As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 标题目录顺序
Property Sequence As %Integer;

}
