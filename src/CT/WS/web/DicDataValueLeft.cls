Class CT.WS.web.DicDataValueLeft Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"100")
	s idxLast=(start+limit)-1
	s nodeid = $g(%request.Data("nodeid",1),"0")
	d ..OneTreeVaule(nodeid,start,idxLast)
	
	q $$$OK
}

/// Creator:	dujinrong
/// CreatDate:	2013-4-27
/// Desc:		获取自定义字典树
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueLeft ).OneTreeVaule("3","0","99")
ClassMethod OneTreeVaule(id As %String, start As %String, idxLast As %String)
{
	s nodeidByrows = ##Class(CT.WS.StdDictionary).%OpenId(id)
	s ID =id
	s dicCodeCol=nodeidByrows.DicCodeCol
	s dicDescCol=nodeidByrows.DicDescCol
	s tableName=nodeidByrows.TableName
	/*
	s count=$l(tableName,".")
	if (count>1)
	{
		s $e(tableName,$f(tableName,".")-1,$f(tableName,".")-1)="_"
	}
	*/
	s strjson = ..GetTableByName(tableName,dicCodeCol,dicDescCol,start,idxLast)
	w strjson
}

/// Creator:	dujinrong
/// CreatDate:	2013-4-27
/// Desc:		获取自定义字典数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueLeft).GetTableByName("SQLUser.CT_Nation","CTNAT_Code","CTNAT_Desc")
ClassMethod GetTableByName(tableName As %String, dicCodeCol As %String, dicDescCol As %String, start As %String, idxLast As %String) As %String
{
	s sql="SELECT "_dicCodeCol_","_dicDescCol_" FROM "_tableName
 	s resultSet = ##class(%Library.ResultSet).%New()
 	S ^dicDa = sql
    d resultSet.Prepare(sql)
    d resultSet.Execute()
    s inCount = 0
    s json = ""
	while(resultSet.Next())
    {
 			
		if ((inCount<=idxLast)&(inCount>=start))
		{
			s json = json_"{DEVID:'"_resultSet.%GetData(1)_"',"
			s json = json_"Meaning:'"_$g(resultSet.Data(dicDescCol))_"'},"
		}
		s inCount = inCount + 1 
	 }
   	s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s jsons ="{results:"_inCount_",rows:["_json_"]}"
	q jsons
}

}
