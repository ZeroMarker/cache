/// 名称:		EMR.DOC.DTO.GlossaryCategory
/// 描述:		术语集管理--术语集目录传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.GlossaryCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 术语范畴名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

}
