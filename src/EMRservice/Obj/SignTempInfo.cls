Class EMRservice.Obj.SignTempInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 模板ID
Property ID As %String;

/// 可重复模板则维护该属性值为TitleCode；唯一模板则为空；
Property TitleCode As %String;

}
