Class EMRservice.Obj.Template Extends (%RegisteredObject, %XML.Adaptor)
{

/// 模板类型ID
Property ID As %String;

/// 模板Code,此属性的值固定，不能改变，用来区分模板是“病案首页”、“转出记录”、“手术记录”、“术前讨论记录”、“术后首程”
Property Code As %String;

/// 模板名称
Property Desc As %String;

/// 若病历没有单独的模板，是某个模板中的标题，则维护该属性值为TitleCode；否则为空；
Property TitleCode As %String;

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
