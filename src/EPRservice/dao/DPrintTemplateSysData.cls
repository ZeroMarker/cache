/// 名称: 电子病历维护程序打印模板系统常用参数
/// 编写者：LingChen
Class EPRservice.dao.DPrintTemplateSysData Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Query SelectAll() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Type:%String,Code:%String,Image:%Integer")
{
	SELECT Name,Type,Code,Image
	FROM EPRmeta.PrintTemplateSysData
}

}
