/// CT.WS.web.DicCustomMaintainQuery
/// 描述:取得自定义字典维护数据
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.web.DicCustomMaintainQuery Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s datavalue = $g(%request.Data("dataName",1),"")
	s actionbtn = $g(%request.Data("actionbtn",1),"")
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"0")
	s idxLast = start + limit - 1	
	d ..GetJsonDate(start,idxLast,actionbtn,datavalue)
    Quit $$$OK
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.BO.BOCustomMaintainQuery).GetJsonDate(0,12,"","")
ClassMethod GetJsonDate(start As %String, idxLast As %String, actionbtn As %String, datavalue As %String)
{
   	//生成字典查询结果集，并存储在临时global中
   	s ^test2=start_"^"_idxLast_"^"_actionbtn_"^"_datavalue
   	//对维护字典进行更新处理
   	
   	if ((actionbtn '= "")&&(datavalue'= ""))
   	{
	   	if (actionbtn = "btnInsertData")
	   	{
		   	s res = ##Class(CT.WS.BO.BOCustomMaintainQuery).CreateStdDictionary(datavalue)
	   	}
	   	elseif (actionbtn = "updateidbtn")
	   	{
		   	s res = ##Class(CT.WS.BO.BOCustomMaintainQuery).UpdateStdDictionary(datavalue)
	   	}
	   	elseif (actionbtn = "deleteidbtn")
	   	{
		   	s res = ##Class(CT.WS.BO.BOCustomMaintainQuery).DeleteStdDictionary(datavalue)
	   	}
   	}
   	s inCount = 0
   	//获取最新字典维护数据
	s Result = ##Class(%ResultSet).%New("CT.WS.StdDictionary:SELECTALL")
	d Result.Execute()
 	//构造json数据
 	s json = ""
    s strv = ""
 	while(Result.Next())
 	{
	 	if ((inCount<=idxLast)&(inCount>=start))
		{
	 	//ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,IsRuleType,RuleTypeTag,Condition,ConditionCode,IsDiagnosRuleType
	 	s json = json_"{Code:'"_$g(Result.Data("Code"))_"',"
	 	s json = json_"Name:'"_$g(Result.Data("Name"))_"',"
	 	s json = json_"Description:'"_$g(Result.Data("Description"))_"',"
	 	s json = json_"TableName:'"_$g(Result.Data("TableName"))_"',"
	 	s strv = $g(Result.Data("DicAliasCol"))
	 	if ((strv = $char(0))||(strv = ""))
	 	{
		 	s strv = ""
	 	}
	 	s json = json_"DicAliasCol:'"_strv_"',"
	 	s json = json_"DicCodeCol:'"_$g(Result.Data("DicCodeCol"))_"',"
	 	s json = json_"DicDescCol:'"_$g(Result.Data("DicDescCol"))_"',"
	 	s strv = $g(Result.Data("ConditionCode"))
	 	if ((strv = $char(0))||(strv = ""))
	 	{
		 	s strv = ""
	 	}
	 	s json = json_"ConditionCode:'"_strv_"',"
	 	s strv = $g(Result.Data("Condition"))
	 	if ((strv = $char(0))||(strv = ""))
	 	{
		 	s strv = ""
	 	}
	 	s inCounts=inCount+1
	 	s json = json_"Condition:'"_strv_"',"
		s json = json_"ID:'"_$g(Result.Data("ID"))_"',"
		s json = json_"IDs:'"_inCounts_"',"
		s json = json_"SystemCode:'"_$g(Result.Data("SystemCode"))_"'},"
		}
		s inCount = inCount+1
	}
    s json = $e(json, 1, $l(json)-1)

	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s set1 ="{results:"_inCount_",rows:["_json_"]}"
	w set1
}

}
