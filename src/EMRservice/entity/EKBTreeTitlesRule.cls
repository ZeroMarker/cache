/// 名称：		EMRservice.entity.EKBTreeTitlesRule
/// 描述：		标题知识库树节点关联Entity
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRservice.entity.EKBTreeTitlesRule Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 知识库KBTree表Rowid
Property KBTreeID As %String(TRUNCATE = 1);

/// 标题Titles表的Code
Property TitlesCode As %String(TRUNCATE = 1);

}
