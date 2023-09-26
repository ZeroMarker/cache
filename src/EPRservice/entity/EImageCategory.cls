Class EPRservice.entity.EImageCategory Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 图库目录名称
Property Name As %String(TRUNCATE = 1);

/// 图库目录描述	
Property Description As %String(TRUNCATE = 1);

/// 目录父节点ID
Property ParentID As %String(TRUNCATE = 1);

}
