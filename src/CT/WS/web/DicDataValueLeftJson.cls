Class CT.WS.web.DicDataValueLeftJson Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	 d ..GetJsonLeftTree()
	q $$$OK
}

/// Creator:	dujinrong
/// CreatDate:	2013-4-27
/// Desc:		获取自定义字典树
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueLeftJson).GetJsonLeftTree()
ClassMethod GetJsonLeftTree()
{
	s inCount = 0
   	//获取最新字典维护数据
	s Result = ##Class(%ResultSet).%New("CT.WS.StdDictionary:SELECTALL")
	d Result.Execute()
 	//构造json数据
 	s json = ""
    s strv = ""
 	while(Result.Next())
 	{

	 	s json = json_"{text:'"_$g(Result.Data("Code"))_" "_$g(Result.Data("Name"))_"',"
	 	s json = json_"id:'"_$g(Result.Data("ID"))_"^"_$g(Result.Data("Code"))_"^"_$g(Result.Data("SystemCode"))_"',"
	 	s json = json_"leaf:true},"
	
	}
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s set1="["_json_"]"
	w set1
}

}
