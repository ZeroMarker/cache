Class EMRservice.entity.EViewEMRTemplate Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//模板ID

Property TemplateID As %String(TRUNCATE = 1);

//模板版本ID

Property TemplateVersionID As %String(TRUNCATE = 1);

//模板名称

Property TemplateName As %String(TRUNCATE = 1);

//模板中包含的数据项集合，把所有数据项封装成一个XML数据项；数据项中包含的属性有名称， ID, 和值类型，如注释例

Property ItemsSet As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

//Property ItemsSet As %String(MAXLEN = 20000, TRUNCATE = 1);

//模板最后更新日期时间

Property LastUpdateDateTime As %String;

}
