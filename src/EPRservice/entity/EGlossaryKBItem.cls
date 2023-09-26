Class EPRservice.entity.EGlossaryKBItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %Integer;

/// 所属术语
Property GlossaryID As %Integer;

/// 上下文术语(如主诉、现病史等)
Property ContextGlossaryID As %Integer;

/// 所属知识库
Property KBNodeID As %Integer;

/// 所属知识库部分
Property KBPartNo As %Integer;

/// 知识库单元名称
Property ItemName As %String(TRUNCATE = 1);

/// 知识库单元代码
Property ItemCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 知识库单元取值类型(V:值;C:代码;VC:值^代码;CV:代码^值)
Property ValueType As %String(TRUNCATE = 1);

Property KBType As %String(TRUNCATE = 1);

}
