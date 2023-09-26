/// 名称:		EMR.DOC.DTO.Glossary
/// 描述:		术语集管理--术语集传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.Glossary Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 术语名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 全局唯一标识符
Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 术语范畴父类
Property GlossaryCategory As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 术语类型(TG：界面模板单元术语; KG:知识库单元术语)
Property GlossaryType As %String(TRUNCATE = 1);

/// 父术语节点RowID(如果没有，则为空。这里主要用于存储知识库术语的上下文术语RowID)
Property ParentID As %String(TRUNCATE = 1);

/// 内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 数据元标识符
Property MetaID As %String(TRUNCATE = 1);

}
