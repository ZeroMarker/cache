Class EPRservice.entity.EGlossaryCategory Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 术语名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 所属界面模板
Property TemplateCategroyID As %String(TRUNCATE = 1);

}
