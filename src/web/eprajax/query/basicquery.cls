Class web.eprajax.query.basicquery Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s patientName = $g(%request.Data("txtPatientName",1),"")
	s regNo = $g(%request.Data("txtRegNo",1),"")
	s episodeNo = $g(%request.Data("txtEpisodeNo",1),"")
	s Type=$g(%request.Data("cbxRegType",1),"")
	s locID = $g(%request.Data("locID",1),"")
	s wardID = $g(%request.Data("wardID",1),"")
	s admBeginDate = $g(%request.Data("dtAdmBeginDate",1),"")
	s admEndDate = $g(%request.Data("dtAdmEndDate",1),"")
	s disBeginDate = $g(%request.Data("dtDisBeginDate",1),"")
	s disEndDate = $g(%request.Data("dtDisEndDate",1),"")
	s MedicareNo = $g(%request.Data("MedicareNo",1),"")
	s diagnose = $g(%request.Data("txtDiagnose",1),"")
	s diagnote = $g(%request.Data("txtDiagnote",1),"")
	
	s columns = $g(%request.Data("hiddenCols",1),"")
	
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
	
	
	s action = $g(%request.Data("action",1),"fetchdata")
	s canViewAllLoc = $g(%request.Data("canViewAllLoc",1),"")
	if (canViewAllLoc = "N")
	{
		s logonLocID = $g(%session.Data("LOGON.CTLOCID"))
	}
	else
	{
		s logonLocID = ""
	}	
	s conditions = ..ConvertConditions(diagnose,diagnote,MedicareNo,patientName, regNo, episodeNo, admBeginDate, admEndDate, disBeginDate, disEndDate, locID, wardID, Type)
	d ..GetResult(guid, start, limit, conditions, columns, action,frameType)
	
	q $$$OK
}

/// Desc:	转换查询条件
ClassMethod ConvertConditions(diagnose, diagnote, MedicareNo, patientName, regNo, episodeNo, admBeginDate, admEndDate, disBeginDate, disEndDate, locID, wardID, Type) As %String
{
	if (admBeginDate '= "") s admBeginDate= $ZDH(admBeginDate, 3)
	if (admEndDate '= "") s admEndDate= $ZDH(admEndDate, 3)
	
	s:(disBeginDate '= "") disBeginDate = $zdh(disBeginDate,3)
	s:(disEndDate '= "") disEndDate = $zdh(disEndDate,3)
	if (Type'=""){
	  s:(Type="住院") Type="I"
	  s:(Type="门诊") Type="O"
	  s:(Type="急诊") Type="E"
		}
	//前端传来的wardID是CTLocID，需要转换
	//if (wardID '= "") s wardID = $o(^PAWARD(0,"WARD_LocationDR",wardID,""))	
	//按病案号查询，当病案号和登记号输入不一致时按病案号查询
	if (MedicareNo '= "")
	{
		s regNoStr = ""
		for i = 1:1:$L(MedicareNo,"#")
		{
			s MedicareNoSub = $p(MedicareNo,"#",i)
			//s PatientID = $o(^PAPERi("Medicare1",MedicareNoSub,""),-1)
			s PatientID = ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(MedicareNoSub,"",.ErrMsg)
			continue:(PatientID = "")
			s regNosub = $P($g(^PAPER(PatientID,"PAT",1)),"^",1)
			
			s regNoStr = regNoStr_"#"_regNosub
		}
		s regNo = regNoStr
	}
	
	s conditions = patientName_"^"_regNo_"^"_episodeNo_"^"_admBeginDate_"^"_admEndDate_"^"_locID_"^"_wardID_"^"_disBeginDate_"^"_disEndDate_"^"_Type_"^"_diagnose_"^"_diagnote
	q conditions
}

/// Desc:	获取查询结果
ClassMethod GetResult(AGUID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AConditions As %String, AColumns As %String, AAction As %String, AFrameType As %String = "")
{
	
	if (AAction = "querydata")
	{
		//生成符合查询条件的就诊列表
		d ..QueryData(AGUID, AConditions,AFrameType)
	}
	else
	{
		//获取查询结果
		d ..FetchData(AGUID, AStartRowIndex, ARowCount, AColumns,AAction,AFrameType)
	}
}

/// Desc:	获取满足查询条件的就诊列表Json串
ClassMethod QueryData(AGUID As %String, AConditions As %String, AFrameType As %String = "")
{
	if (AGUID = "")
	{	
		s guid = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).GetGUID()
	}
	else
	{
		s guid = AGUID
		s status = 	##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).ClearGlobalByGUID(guid)	
	}
	
	s totCount = ..GenerateAdmList(guid, AConditions)
	
	//输出查询结果Json串
	w "{"
		w """success"":""true"""
		w ",""GUID"":"""_guid_""""
		if (AFrameType = "HISUI")
		{
			w ",""total"":"""_totCount_""""
			w ",""rows"":[]"			
		}
		else
		{
			w ",""TotalCount"":"""_totCount_""""
			w ",""data"":[]"
		}
	w "}"
}

/// Desc:	获取满足查询条件的就诊数据Json串
ClassMethod FetchData(AGUID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AColumns As %String, AAction As %String, AFrameType As %String = "")
{
	s guid = AGUID
	s totCount = ##Class(EPRservice.BLL.Query.BLQueryBasic).GetEpisodeCount(guid)
	
	//输出查询结果Json串
	w "{"
		w """success"":""true"""
		w ",""GUID"":"""_guid_""""
		if (AFrameType = "HISUI")
		{
			w ",""total"":"""_totCount_""""
			w ",""rows"":["						
		}
		else
		{
			w ",""TotalCount"":"""_totCount_""""
			w ",""data"":["
		}
			if (guid '= "")&&(AAction = "fetchdata")
			{d ..OutputPagedResultJson(guid, AStartRowIndex, ARowCount, AColumns)}
			elseif (guid '= "")&&(AAction = "ForExcell")
			{d ..OutputPagedResultJson(guid, 0, totCount, AColumns)}
		w "]"
	w "}"
}

/// Desc:	生成满足查询条件的就诊列表
ClassMethod GenerateAdmList(AGUID As %String, AConditions As %String) As %Integer
{
	s AName = $P(AConditions, "^", 1)
	s APatNo = $P(AConditions, "^", 2)
	s AAdmNo = $P(AConditions, "^", 3)
	s AStartAdmDate = $P(AConditions, "^", 4)
	s AEndAdmDate = $P(AConditions, "^", 5)
	s ACurrentDept = $P(AConditions, "^", 6)
	s ACurrentWard = $P(AConditions, "^", 7)
	s AStartDisDate = $P(AConditions, "^", 8)
	s AEndDisDate = $P(AConditions, "^", 9)
	s AType=$P(AConditions, "^", 10)
	s ADiagnose=$P(AConditions, "^", 11)
	s ADiagnote=$P(AConditions, "^", 13)
	s blBasicQuery = ##Class(EPRservice.BLL.Query.BLQueryBasic).CreateInstance(AGUID)
	s count = blBasicQuery.SetAdmListIntoGlobal(AName, APatNo, AAdmNo, AType,AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate, ACurrentDept, ACurrentWard, ADiagnose,ADiagnote)
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
/// Debug:	w ##Class(web.eprajax.query.basicquery).Test()
ClassMethod Test()
{
	s guid = "1"

	s start = "0"
	s limit = "20"
		
	s patientName = ""
	s regNo = ""
	s Type="o"
	s episodeNo = ""
	s admBeginDate = "2008-10-09"	
	s admEndDate = "2008-10-11"
	s disBeginDate = "2010-9-3"
	s disEndDate = "2010-9-30"
	s locID = "" 
	s wardID = ""
	s:(admBeginDate '= "") admBeginDate= $ZDH(admBeginDate, 3)
	s:(admEndDate '= "") admEndDate= $ZDH(admEndDate, 3)
	s:(disBeginDate '= "") disBeginDate = $ZDH(disBeginDate, 3)
	s:(disEndDate '= "") disEndDate = $ZDH(disEndDate, 3)
	s conditions = patientName_"^"_regNo_"^"_episodeNo_"^"_admBeginDate_"^"_admEndDate_"^"_locID_"^"_wardID_"^"_disBeginDate_"^"_disEndDate_"^"_Type
	
	w !,"+++++++++++++++conditions+++++++++++++++++++",!
	w conditions
	
	s columns = "HIS^Name^Name"
	s columns = columns_"&HIS^Gender^Gender"
	s columns = columns_"&HIS^BirthDate^BirthDate"
	//s columns = columns_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V"
	//s columns = columns_"&EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V"
	
	s action = "querydata"
	w !, "++++++++++ querydata ++++++++++",!
	d ..GetResult(guid, start, limit, conditions, columns, action)
	w !, "++++++++++ end of querydata +++"
	
	s action = "fetchdata"
	w !, "++++++++++ fetchdata ++++++++++",!
	d ..GetResult(guid, start, limit, conditions, columns, action)
	w !, "++++++++++ end of fetchdata +++"
	
	q
}

/// Debug: 	w ##Class(web.eprajax.query.basicquery).TestDynamic()
ClassMethod TestDynamic()
{
	s inputquery = $g(^CacheTempDHCEPRDebug("web.eprajax.query.basicquery","input","query"))
	s inputfetch = $g(^CacheTempDHCEPRDebug("web.eprajax.query.basicquery","input","fetch"))
	q:(inputquery = "")||(inputfetch = "") "no input"
	 
	s AGUID = "1"
	
	s AConditions= $P(inputquery, "!", 4)
	
	s AStartRowIndex= $P(inputfetch, "!", 2)
	s ARowCount= $P(inputfetch, "!", 3)
	s AColumns = $P(inputfetch, "!", 5)
	
	
	s AAction = "querydata"
	b
	w !, "++++++++++ querydata ++++++++++",!
	d ..GetResult(AGUID, AStartRowIndex, ARowCount, AConditions, AColumns, AAction)
	w !, "++++++++++ end of querydata +++"
	
	
	s AAction = "fetchdata"
	b
	w !, "++++++++++ fetchdata ++++++++++",!
	d ..GetResult(AGUID, AStartRowIndex, ARowCount, AConditions, AColumns, AAction)
	w !, "++++++++++ end of fetchdata +++"
}

ClassMethod getExcelData(AGuid As %String, AColumns As %String, APage As %String = "", ASize As %String = "")
{
	s dataList=##class(%ListOfDataTypes).%New()
	q:AGuid=""||AColumns dataList
	s titleList=##class(%ListOfDataTypes).%New()
	s count=0
	for i=1:1:$L(AColumns,"&")
	{
		s column=$P(AColumns,"&",i)
		s headTitle=$P(column,"^",4)
		s count=count+1
		d titleList.Insert(headTitle)
	}
	d dataList.Insert(titleList)
	s start=""
 	s limit=""
 	if (APage'=""){
	 	s start = (APage-1) * ASize
	 	s limit =  start+ASize	
	}
	s blItemResult = ##Class(EPRservice.BLL.Query.BLQueryResult).CreateInstanceByColText(AGuid,AColumns)
	s len=blItemResult.BLTempGlobalMgr.GetEpisodeCount()
	for i=1:1:len
	{
		continue:(((start'="")&&(i<=start))||((start'="")&&(i>limit)))
		s itemList=##class(%ListOfDataTypes).%New()
		s dataItem = blItemResult.GetResultByKey(i)	
		continue:(dataItem = "")
		s count = blItemResult.ColumnList.Count()
		for j = 1:1:count
		{
			s column = blItemResult.ColumnList.GetAt(j)
			s colName = $P(column, "^", 2)
			s result = $ListGet(dataItem,j)
			d itemList.Insert(result)
		}
		d dataList.Insert(itemList)
	}
	q dataList
}

}
