/// 名称: 电子病历维护程序角色
/// 描述: 角色
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.dao.DMainDictFunction Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String,ParentID:%String,Type:%String,Notes:%String")
{
	SELECT ID,FuncName,FuncDesc,ParentID,Type,Notes
	FROM EPRmeta.MainDictFunction
	ORDER BY ID
}

}
