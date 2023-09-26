/// 名称:EMRmeta.DiagnosKBNode
/// 描述:病种知识库节点表
/// 编写者：yejian
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosKBNode Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 知识库节点表ID
Property KBNodeID As %String;

/// 目录ID
Property KBTreeID As %String;

/// 病种代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 有效标志
Property ActiveFlag As %String;

}
