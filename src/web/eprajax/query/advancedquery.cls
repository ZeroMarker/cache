Class web.eprajax.query.advancedquery Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//Unique ID
	s guid = $g(%request.Data("hiddenGUID",1),"")
	
	s frameType = $g(%request.Data("frameType",1),"")
	if (frameType = "HISUI")
	{
		s page = $g(%request.Data("page",1),"1")
		s rows = $g(%request.Data("rows",1),"12")
		s start = (page - 1) * rows
		s limit = rows
	}
	else
	{
		s start = $g(%request.Data("start",1),"0")
		s limit = $g(%request.Data("limit",1),"25")
	}
	
	//查询条件
	s conditions = $g(%request.Data("conditions",1),"")
	
	//结果列
	s columns = $g(%request.Data("hiddenCols",1),"")
	
	//按  入院日期/出院日期  进行查询   add by niucaicai 2012-10-18
	s queryType = $g(%request.Data("queryType",1),"AdmDate")
	
	//Action：querydata 生成满足查询条件的就诊列表
	//		  fetchdata 获取满足查询条件的就诊数据
	s action = 	$g(%request.Data("action",1),"fetchdata")

	s canViewAllLoc = $g(%request.Data("canViewAllLoc",1),"")
	if (canViewAllLoc = "N")
	{
		s logonLocID = $g(%session.Data("LOGON.CTLOCID"))
	}
	else
	{
		s logonLocID = ""
	}
	//edit by Candyxu
	if (action = "getGUID"){d ..GetQueryGUID(guid)}else{d ..GetResult(guid, start, limit, conditions, columns, action, queryType, frameType,logonLocID)}

	q $$$OK
}

/// Desc:	获取查询结果
ClassMethod GetResult(AGUID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AConditions As %String, AColumns As %String, AAction As %String, AqueryType As %String, AframeType As %String = "", ALogonLocID As %String = "")
{
	//Debug
	
	//if (AAction = "querydata")
	//{	s ^CacheTempDHCEPRDebug("web.eprajax.query.advancedquery","input","query") = AGUID_"!"_AStartRowIndex_"!"_ARowCount_"!"_AConditions_"!"_AColumns_"!"_AAction}
	//if (AAction = "fetchdata")
	//{	s ^CacheTempDHCEPRDebug("web.eprajax.query.advancedquery","input","fetch") = AGUID_"!"_AStartRowIndex_"!"_ARowCount_"!"_AConditions_"!"_AColumns_"!"_AAction}
	
    if (AAction = "querydata")
    {
       //生成符合查询条件的就诊列表
       d ..QueryData(AGUID, AConditions,AqueryType,ALogonLocID)

       	//上面方法执行完成后，写出字符串表示操作完成
		w "WriteTempGlobalOver"
    }
    else
    {
      //获取查询结果
      d ..FetchData(AGUID, AStartRowIndex, ARowCount, AColumns,AAction,AframeType)
    }
}

/// Desc: 获取GUID
/// Add by Candyxu
ClassMethod GetQueryGUID(AGUID As %String)
{
 if (AGUID = "")
 { 
  s guid = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).GetGUID()
 }
 else
 {
  s guid = AGUID
  s status =  ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).ClearGlobalByGUID(guid) 
 }
 w "{"
    w """GUID"":"""_guid_""""
 w "}"
}

/// Desc:	获取满足查询条件的就诊列表Json串
ClassMethod QueryData(AGUID As %String, AConditions As %String, AqueryType As %String, ALogonLocID As %String = "")
{
	if (AGUID '= "") {s totCount = ..GenerateAdmList(AGUID, AConditions, AqueryType,ALogonLocID)}
}

/// 	Desc:	获取满足查询条件的就诊数据Json串
ClassMethod FetchData(AGUID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AColumns As %String, Flag As %String, AframeType As %String = "")
{
	s guid = AGUID
	s totCount = ##Class(EPRservice.BLL.Query.BLQueryBasic).GetEpisodeCount(guid)

	//输出查询结果Json串
	w "{"
	w """success"":""true"""
	w ",""GUID"":"""_guid_""""
	if (AframeType = "HISUI")
	{
		w ",""total"":"""_totCount_""""
		w ",""rows"":["			
	}
	else
	{
		w ",""TotalCount"":"""_totCount_""""
		w ",""data"":["
	}
	if (guid '= "")&&(Flag = "fetchdata")
	{
		d ..OutputPagedResultJson(guid, AStartRowIndex, ARowCount, AColumns)
	}
	elseif (guid '= "")&&(Flag = "ForExcell")
	{
		d ..OutputPagedResultJson(guid, 0, totCount, AColumns)
	}
	w "]"
	w "}"
}

/// Desc:	获取符合查询条件的就诊列表
ClassMethod GenerateAdmList(AGUID As %String, AConditions As %String, AqueryType As %String, ALogonLocID As %String = "") As %Integer
{
	s blBasicQuery = ##Class(EPRservice.BLL.Query.BLQueryAdvanced).CreateInstanceByConText(AGUID, AConditions, AqueryType, ALogonLocID)
	s count = blBasicQuery.SetAdmListIntoGlobal()
	q count
}

/// Desc:	获取分页的查询结果Json串
ClassMethod OutputPagedResultJson(AGUID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AColumns As %String)
{
	q:((AGUID = "")||(AStartRowIndex < 0)||(ARowCount < 1)) 

	s startKey = AStartRowIndex + 1		   //分页起始行Key
	s endKey = 	AStartRowIndex + ARowCount //分页结束行Key
	
	d ##Class(EPRservice.BLL.Query.BLFormattedResult).OutputJsonResult(AGUID, startKey, endKey, AColumns)
}

/// Desc:	测试方法
/// Debug：	d ##Class(web.eprajax.query.advancedquery).Test()
ClassMethod Test()
{
	s AConditionStr = "HIS^AdmDate^AdmDate$>=$2010-10-9"
	s AConditionStr = AConditionStr_"&HIS^AdmDate^AdmDate$<=$2010-10-9"
	s AConditionStr = AConditionStr_"&HIS^Name^Name$like$永"
	//s AConditionStr = AConditionStr_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V$=$Male"
	//s AConditionStr = AConditionStr_"|EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V$=$b"
	
	s AColumnsStr = "HIS^Name^Name"
	s AColumnsStr = AColumnsStr_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V"
	s AColumnsStr = AColumnsStr_"&EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V"
	
	//s guid = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).GetGUID()
	s guid = ""

	s startRowIndex = 0, rowCount = 10
	
	d ..GetResult(guid, startRowIndex, rowCount, AConditionStr, AColumnsStr)
}

/// Debug: 	w ##Class(web.eprajax.query.advancedquery).TestDynamic()
ClassMethod TestDynamic()
{
	s inputquery = $g(^CacheTempDHCEPRDebug("web.eprajax.query.advancedquery","input","query"))
	s inputfetch = $g(^CacheTempDHCEPRDebug("web.eprajax.query.advancedquery","input","fetch"))
	q:(inputquery = "")||(inputfetch = "") "no input"
	 
	s AGUID = "1"
	
	s AConditions= $P(inputquery, "!", 4)
	
	s AStartRowIndex= $P(inputfetch, "!", 2)
	s ARowCount= $P(inputfetch, "!", 3)
	s AColumns = $P(inputfetch, "!", 5)
	
	
	s AAction = "querydata"
	b
	w !, "++++++++++ querydata ++++++++++",!
	w "Conditions :"_AConditions
	w !, "++++++++++",!
	d ..GetResult(AGUID, AStartRowIndex, ARowCount, AConditions, AColumns, AAction)
	w !, "++++++++++ end of querydata +++"
	
	
	s AAction = "fetchdata"
	b
	w !, "++++++++++ fetchdata ++++++++++",!
	d ..GetResult(AGUID, AStartRowIndex, ARowCount, AConditions, AColumns, AAction)
	w !, "++++++++++ end of fetchdata +++"
}

}
