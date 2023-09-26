Class EPRservice.entity.EGlossaryItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String;

/// 所属术语集
Property GlossaryID As %String;

/// 所属界面模板
Property TemplateID As %String;

/// 界面模板单元名称(冗余字段用于显示单元名称)
Property ItemName As %String(TRUNCATE = 1);

/// 界面模板单元代码
Property ItemCode As %String(MAXLEN = 300, TRUNCATE = 1);

/// 界面模板单元取值类型(V:值;C:代码;VC:值^代码;CV:代码^值)
Property ValueType As %String(TRUNCATE = 1);

/// 界面模板标示(NEW：新版，OLD:旧版(空))
Property TemType As %String(TRUNCATE = 1);

/// 术语内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 模板编码
Property TemplateCode As %String(MAXLEN = 200, TRUNCATE = 1);

}
