/// 名称：		CT.WS.web.getdicConfigTableList
/// 描述：		获取公用字典数据维护列表
/// 编写者：	yejian
/// 编写时间：	2013-4-17
Class CT.WS.web.DicStdmaintainList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"12")
	s idxLast=(start+limit)-1
	w ##class(CT.WS.BO.BODynamicConfigTable).GetAllConfigJson(start,idxLast)	
	 	
    Quit $$$OK
}

}
