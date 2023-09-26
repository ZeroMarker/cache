Class EMRservice.Obj.TemplateInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TemplateInfo";

Parameter XMLTYPE = "TemplateInfo";

Parameter XMLIGNORENULL = 1;

/// 模板类型Code
/// OutPat:出院患者
/// TransPat:转出患者
/// OperationPat:手术患者
Property TypeCode As %String;

/// 模板类型描述
Property TypeDesc As %String;

/// 模板信息
Property Template As EMRservice.Obj.Template;

}
