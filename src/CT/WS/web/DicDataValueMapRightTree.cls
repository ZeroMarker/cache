Class CT.WS.web.DicDataValueMapRightTree Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s strcondition = $Get(%request.Data("findData",1),"")

	//首次加载数据时传“findDataright”
	if ("findDataright" = strcondition)
	{
		s strcondition = ""
	}
	d ..GetTreeJsonDate(strcondition)
	
    Quit $$$OK
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueMapRightTree).GetTreeJsonDate("1^^家庭关系代码")
ClassMethod GetTreeJsonDate(condition As %String)
{
	//获取最新字典维护数据
	s Result = ##Class(%ResultSet).%New("CT.WS.DataElementValuesCategory:QueryByConfig")
	d Result.Execute(condition)
 	//构造json数据
 	s json = ""
    s strv = ""
 	while(Result.Next())
 	{
	 	s strtext = ""
	 	s strtext = $g(Result.Data("DECVMID")) _" "_$g(Result.Data("Name"))
	 	s json = json_"{text:'"_strtext_"',"
	 	s json = json_"id:'"_$g(Result.Data("ID"))_"^"_$g(Result.Data("DECVMID"))_"',"
	 	s json = json_" leaf:true},"
	 	s strv = $g(Result.Data("DicAliasCol"))
	 	if ((strv = $char(0))||(strv = ""))
	 	{
		 	s strv = ""
	 	}
	}
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s set1 ="["_json_"]"
	w set1
}

}
