/// 名称:		EMR.DOC.DTO.DataElementCategory
/// 描述:		术语集 数据元目录传入对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-15
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.DataElementCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 数据元目录名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 数据元范畴描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 数据元目录范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

}
