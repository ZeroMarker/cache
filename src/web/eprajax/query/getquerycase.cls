/// Desc:    用于与前台JS进行ajax交互的应用,实现“查询方案”有关信息的读取操作
/// Creator: 牛才才
Class web.eprajax.query.getquerycase Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	s frameType = $g(%request.Data("frameType",1),"")
	
	if (action = "getCaseName")
	{
		s CaseNameDesc = $Get(%request.Data("desc",1),"")
		s QueryAreaStr = $Get(%request.Data("QueryAreaStr",1),"")
		s QueryAreaName = $p(QueryAreaStr,"^",1)
		s QueryAreaID = $p(QueryAreaStr,"^",2)
		
		d ..GetCaseName(CaseNameDesc,QueryAreaName,QueryAreaID)
	}
	elseif (action = "DeleteCase")
	{
		s CaseID = $Get(%request.Data("DeleteCaseID",1),"")
		s ret = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).DeleteCaseById(CaseID)
		w ret
	}
	elseif (action = "getCaseConditionInfo")
	{
		s CaseID = $Get(%request.Data("CaseID",1),"")
		d ..GetCaseConditionInfo(CaseID)
	}
	elseif (action = "getCaseResultColsInfo")
	{
		s CaseID = $Get(%request.Data("CaseID",1),"")
		d ..GetCaseResultColsInfo(CaseID)
	}
	elseif (action = "getAllSSGroup")
	{
		d ..GetAllSSGroup(frameType)
	}
	elseif (action = "getCTLocByCaseID")
	{
		s CaseID = $Get(%request.Data("CaseID",1),"")
		d ..GetCTLocByCaseID(CaseID)
	}
	elseif (action = "getGroupByCaseID")
	{
		s CaseID = $Get(%request.Data("CaseID",1),"")
		d ..GetGroupByCaseID(CaseID)
	}
	elseif (action = "checkCaseID")
	{
		s CaseID = $Get(%request.Data("CaseID",1),"")
		s ret = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).CheckCaseID(CaseID)
		w ret
	}
	q $$$OK
}

/// Desc：   查询得到方案名称
/// Creator: 牛才才
/// Input：  CaseNameDesc： 读取查询方案是，需要检索的方案名称，此值为空则查询全部方案
/// 		 QueryAreaName: 可见范围的名称，包括 “userID”、“ctLocID”、“groupID”
/// 		 QueryAreaID：  QueryAreaName 对应的具体ID
/// Debug：  d ##Class(web.eprajax.query.getquerycase).GetCaseName("","ctLocID",34)
ClassMethod GetCaseName(CaseNameDesc As %String, QueryAreaName As %String, QueryAreaID As %String)
{
	s count = 0
	s json = "["
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetCaseName(CaseNameDesc, QueryAreaName, QueryAreaID)
	
	While (result.Next())
	{
		s count = count + 1	
		if (count > 1) { s json = json_"," }
		
		s json = json_"{""ID"":"""_$g(result.Data("Rowid"))_""","
		s json = json_"""Desc"":"""_$g(result.Data("desc"))_""","
		s json = json_"""SaveUserID"":"""_$g(result.Data("SaveUserID"))_""","
		s json = json_"""SaveUserName"":"""_$g(result.Data("SaveUserName"))_"""}"
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

/// Desc：   查询得到 方案--查询条件 详细信息
/// Creator: 牛才才
/// Input：  CaseID：查询得到该CaseID下的查询条件
/// Debug：  d ##Class(web.eprajax.query.getquerycase).getCaseConditionInfo("1")
ClassMethod GetCaseConditionInfo(CaseID As %String)
{
	s i=1,j=2,k=3,m=4,n=5
	s num = 0
	s conditionNum = 0
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetCaseConditionInfo(CaseID)
	
	While (result.Next())
	{
		s ORCode = $g(result.Data("ORCode"))
		s ItemCode = $g(result.Data("ItemCode"))
		s ItemName = $g(result.Data("ItemName"))
		s OPCode = $g(result.Data("OPCode"))
		s textValue = $g(result.Data("textValue"))
		s conditionNum = conditionNum+5
		
		if (num = 0)
		{
			s RET = ORCode_","_ItemCode_","_ItemName_","_OPCode_","_textValue
			s num = 1
		}
		elseif (num = 1)
		{
			s RET = RET_","_ORCode_","_ItemCode_","_ItemName_","_OPCode_","_textValue
		}
	}
	w conditionNum_","_RET
}

/// Desc：   查询得到 方案--结果列 详细信息
/// Creator: 牛才才
/// Input：  CaseID：查询得到该CaseID下的结果列
/// Debug：  d ##Class(web.eprajax.query.getquerycase).getCaseResultColsInfo("1")
ClassMethod GetCaseResultColsInfo(CaseID As %String)
{
	s num = 0
	s ResultColsNum = 0
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetCaseResultColsInfo(CaseID)
	
	While (result.Next())
	{
		s IsDisabled = $g(result.Data("IsDisabled"))
		s ColsName = $g(result.Data("ColsName"))
		s ColsCode = $g(result.Data("ColsCode"))
		s ResultColsNum = ResultColsNum+3
		
		if (num = 0)
		{
			s RET = IsDisabled_","_ColsName_","_ColsCode
			s num = 1
		}
		elseif (num = 1)
		{
			s RET = RET_","_IsDisabled_","_ColsName_","_ColsCode
		}
	}
	w ResultColsNum_","_RET
}

/// Desc：   查询得到 全部安全组 详细信息
/// Creator: 牛才才
/// Debug：  d ##Class(web.eprajax.query.getquerycase).getAllSSGroup()
ClassMethod GetAllSSGroup(AframeType As %String = "")
{
	s count = 0
	s json = "["
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetAllSSGroup()
	
	While (result.Next())
	{
		s count = count + 1	
		if (count > 1) { s json = json_"," }
		
		s json = json_"{""ID"":"""_$g(result.Data("RowId"))_""","
		s json = json_"""Desc"":"""_$g(result.Data("Desc"))_"""}"
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	if (AframeType = "HISUI")
	{
		s ret = "{""total"":"_count_",""rows"":"_json_"}"
	}
	else
	{
		s ret = json
	}
	
	w ret
}

/// Desc：   查询得到 当前方案可见科室 信息
/// Creator: 牛才才
/// Input：  CaseID：查询得到该CaseID下的可见科室
/// Debug：  d ##Class(web.eprajax.query.getquerycase).getCTLocByCaseID()
ClassMethod GetCTLocByCaseID(CaseID As %String)
{
	s count = 0
	s json = "["
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetCTLocByCaseID(CaseID)
	
	While (result.Next())
	{
		s count = count + 1	
		if (count > 1) { s json = json_"," }
		
		s json = json_"{""ID"":"""_$g(result.Data("CTLocID"))_""","
		s json = json_"""Name"":"""_$g(result.Data("CTLocDesc"))_"""}"	
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

/// Desc：   查询得到 当前方案可见安全组 信息
/// Creator: 牛才才
/// Input：  CaseID：查询得到该CaseID下的可见安全组
/// Debug：  d ##Class(web.eprajax.query.getquerycase).getGroupByCaseID()
ClassMethod GetGroupByCaseID(CaseID As %String)
{
	s count = 0
	s json = "["
	
	s result = ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).GetGroupByCaseID(CaseID)
	
	While (result.Next())
	{
		s count = count + 1	
		if (count > 1) { s json = json_"," }
		
		s json = json_"{""ID"":"""_$g(result.Data("GroupID"))_""","
		s json = json_"""Desc"":"""_$g(result.Data("GroupDesc"))_"""}"	
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

}
