Class EMRservice.Ajax.auth.authorize Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s patientID = $g(%request.Data("PatientID",1),"")
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s requestCateCharpter = $g(%request.Data("RequestCateCharpter",1),"")
	s requestUserID = $g(%request.Data("RequestUserID",1),"")
	s requestDept = $g(%request.Data("RequestDept",1),"")	
	s EPRAction = $g(%request.Data("EPRAction",1),"")
	s ID = $g(%request.Data("ID",1),"")
	s appointSpan = $g(%request.Data("AppointSpan",1),"")
	s appointCateCharpter = $g(%request.Data("AppointCateCharpter",1),"")
	s appointUserID = $g(%request.Data("AppointUserID",1),"")
	s appointType = $g(%request.Data("AppointType",1),"")
	s authLevelType = $g(%request.Data("AuthLevelType",1),"")
	if (authLevelType = "ALL") {s authLevelType = ""}
	
	//add by yang 2013-08-19 ----------------------------------------
	//申请原因
	s requestReason = $g(%request.Data("RequestReason",1),"")
	s beforeRequestContent = $g(%request.Data("BeforeRequestContent",1),"")
	s afterRequestContent = $g(%request.Data("AfterRequestContent",1),"")
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parametersreason") = requestReason_"^"_beforeRequestContent_"^"_afterRequestContent
	//add by yang 2012-04-13 ----------------------------------------
	s requestDateStart = $g(%request.Data("RequestDateStart",1),"")
	s requestTimeStart = $g(%request.Data("RequestTimeStart",1),"")
	s requestDateEnd = $g(%request.Data("RequestDateEnd",1),"")
	s requestTimeEnd = $g(%request.Data("RequestTimeEnd",1),"")
	
	s appointDateStart = $g(%request.Data("AppointDateStart",1),"")
	s appointTimeStart = $g(%request.Data("AppointTimeStart",1),"")
	s appointDateEnd = $g(%request.Data("AppointDateEnd",1),"")
	s appointTimeEnd = $g(%request.Data("AppointTimeEnd",1),"")
	
	s authLevelTop =$g(%request.Data("AuthLevelTop",1),"")
	s canAppointSelect = $g(%request.Data("CanAppointSelect",1),"")
	s isActive = $g(%request.Data("IsActive",1),"")
	s treatmentLoc = $g(%request.Data("TreatmentLoc",1),"")
	s requestLoc = $g(%request.Data("RequestLoc",1),"")
	s requestUserName = $g(%request.Data("RequestUserName",1),"")
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	s ssgroupID =$g(%session.Data("LOGON.GROUPID"))
	s LOGONHOSPID =$g(%session.Data("LOGON.HOSPID"))

	s onlyCurrentDept = $g(%request.Data("OnlyCurrentDept",1),"")
	s eprIntegratedAuthorization = $g(%request.Data("EPRIntegratedAuthorization",1),"")
	
	s pAAdmType = $g(%request.Data("PAAdmType",1),"")
	s pAStatus = $g(%request.Data("PAStatus",1),"")
	s emrTemplateDocId = $g(%request.Data("EmrTemplateDocId",1),"")
	s frameType = $Get(%request.Data("frameType",1),"")
	if (frameType = "HISUI")
	{
		s page = $g(%request.Data("page",1),"1")
		s rows = $g(%request.Data("rows",1),"10")
		s start = (page - 1) * rows
		s limit = rows
	}
	else
	{
		s start = $g(%request.Data("start",1),0)
		s limit = $g(%request.Data("limit",1),10)
	}
	
	s defaultAppointSpan = $g(%request.Data("DefaultAppointSpan",1),"24")
	s defaultAppointType = $g(%request.Data("DefaultAppointType",1),"0")
	s appointRequestSpan = $g(%request.Data("AppointRequestSpan",1),"0")

	//flag代表集中授权查询页面上的“登记号、病案号、患者姓名”输入框是否有查询内容的标识
	s flag = ""
	//add by niucaicai 2013-03-14 按登记号查询
	s PapmiNo = $g(%request.Data("PapmiNo",1),"")
	if (PapmiNo '= "")
	{
		s flag = "1"
		s patientID = $o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	}
	
	//add by niucaicai 2015-10-08 按病案号查询
	s MedicareNo = $g(%request.Data("MedicareNo",1),"")
	if (PapmiNo = "")&&(MedicareNo '= "")
	{
		s flag = "1"
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(MedicareNo)

	}
	
	//add by niucaicai 2016-11-07 按姓名查询
	s PatName = $g(%request.Data("PatName",1),"")
	if ((PapmiNo = "")&&(MedicareNo = ""))&&(PatName '= "")
	{
		s flag = "1"
		s patientIDByName = ""
		for
		{
			s patientIDByName = $o(^PAPERi("PAPER_PatName",$zcvt($zstrip(PatName,"*p"),"U"),patientIDByName))
			q:(patientIDByName = "")
			
			if (patientID = "")
			{
				s patientID = patientIDByName
			}
			else
			{
				s patientID = patientID_"^"_patientIDByName
			}
		}
		
	}
	
	s RequestRange = $g(%request.Data("RequestRange",1),"")
	
	s parameters = locID_"^"_userID_"^"_requestDateStart_"||"_requestTimeStart_"||"_requestDateEnd_"||"_requestTimeEnd_"||"_appointDateStart_"||"_appointTimeStart_"||"_appointDateEnd_"||"_appointTimeEnd_"^"_canAppointSelect_"^"_treatmentLoc_"^"_requestLoc_"^"_requestUserName_"^"_defaultAppointSpan_"^"_defaultAppointType_"^"_pAAdmType_"^"_pAStatus_"^"_isActive_"^"_appointRequestSpan_"^"_ssgroupID_"^"_RequestRange_"^"_LOGONHOSPID_"^"_authLevelTop_"^"_emrTemplateDocId
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parameters") = PapmiNo_"#"_parameters_"#"_start_"#"_limit_"#"_eprIntegratedAuthorization
	//---------------------------------------------------------------
	
	if (patientID = "")
	{
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID) //201868
	}
	
	If (action="request")
	{
		//w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent)
		w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,locID,ssgroupID)
	}
	//add by yang 2012-04-13
	ElseIf (action="updatefs"){
		s appointActions = $g(%request.Data("AppointActions",1),"")
		w ..UpdateFS(appointActions)
	}
	ElseIf (action="appoint")
	{
		s appointID = $g(%request.Data("AppointID",1),"")
		s appointSpan = $g(%request.Data("AppointSpan",1),"")
		s appointUserID = $g(%request.Data("AppointUserID",1),"")
		s appointUserLocID = $g(%request.Data("AppointUserLocID",1),"")
		s appointType = $g(%request.Data("AppointType",1),"")
		s appointDesc = $g(%request.Data("AppointDesc",1),"")
		s AppointTempCate = $g(%request.Data("AppointTempCate",1),"")
		s Atype = $g(%request.Data("Atype",1),"")
		w ..AddAppoint(appointID,+appointSpan,appointUserID,appointType,appointDesc,ssgroupID,AppointTempCate,Atype,appointUserLocID)
	}
	ElseIf (action="refuse")
	{
		s appointID = $g(%request.Data("AppointID",1),"")
		s appointUserID = $g(%request.Data("AppointUserID",1),"")
		s appointUserLocID = $g(%request.Data("AppointUserLocID",1),"")
		s refuseReason = $g(%request.Data("RefuseReason",1),"")
		w ..RefuseAppoint(appointID,appointUserID,refuseReason,ssgroupID,appointUserLocID)
	}
	ElseIf (action="withdraw")
	{
		s appointID = $g(%request.Data("AppointID",1),"")
		w ..WithdrawAppoint(appointID,ssgroupID)
	}
	ElseIf (action="getunappointed")
	{
		//按登记号、病案号、姓名查询,若patientID为空,数据返回空
		if ((flag '= "")&&(patientID = "")) {
			w "{""total"":0,""rows"":[]}"
			q $$$OK
		}
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"UnAppointed")
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				s ResultStream = ..GetLocAppointList("UnAppointed",patientID,parameters,start,limit,"loc",authLevelType)
			}
			else{
				s ResultStream = ..GetLocAppointList("UnAppointed",patientID,parameters,start,limit,"all",authLevelType)
			}
			//输出流数据
			while (ResultStream.AtEnd = 0)
			{
				w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
			}
		}
	}
	ElseIf (action="getappointed")
	{
		//按登记号、病案号、姓名查询,若patientID为空,数据返回空
		if ((flag '= "")&&(patientID = "")) {
			w "{""total"":0,""rows"":[]}"
			q $$$OK
		}
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"Appointed")
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				s ResultStream = ..GetLocAppointList("Appointed",patientID,parameters,start,limit,"loc",authLevelType)
			}
			else{
				s ResultStream = ..GetLocAppointList("Appointed",patientID,parameters,start,limit,"all",authLevelType)
			}
			//输出流数据
			while (ResultStream.AtEnd = 0)
			{
				w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
			}
		}
	}
	ElseIf (action="getrefuse")
	{
		//按登记号、病案号、姓名查询,若patientID为空,数据返回空
		if ((flag '= "")&&(patientID = "")) {
			w "{""total"":0,""rows"":[]}"
			q $$$OK
		}
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"Refuse")
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				s ResultStream = ..GetLocAppointList("Refuse",patientID,parameters,start,limit,"loc",authLevelType)
			}
			else{
				s ResultStream = ..GetLocAppointList("Refuse",patientID,parameters,start,limit,"all",authLevelType)
			}
			//输出流数据
			while (ResultStream.AtEnd = 0)
			{
				w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
			}
		}			
	}
	ElseIf (action="getJson")
	{
		q:(episodeID="")||(patientID="")
		s parentID = $Get(%request.Data("node",1),"-1")
		//liuzhongwan 16/07/11更改为Stream形式传出
		s jsonStream = ..GetJsonStream(episodeID, userID, locID, ssgroupID)
		while (jsonStream.AtEnd = 0)
		{
			w $ZSTRIP(jsonStream.Read(32000),"*C")
		}
	}
	ElseIf (action="autorequest")
	{
		s appointSpan = ##Class(EMRservice.SystemParameter).SetAutoApplyTime()
		w ..AddAutoRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,locID,ssgroupID,appointSpan,"0")
	}
	ElseIf (action="getHistory"){
		s HistoryStream = ..GetHistoryList(episodeID,requestUserID,start,limit,frameType)
		
		//输出流数据
		while (HistoryStream.AtEnd = 0)
		{
			w $ZSTRIP(HistoryStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	ElseIf (action = "getEMRTempTree")
	{
		s emrTreeStream = ##Class(%GlobalCharacterStream).%New()
		d emrTreeStream.Write("[{")
		d emrTreeStream.Write("""id"":""0"",")
		d emrTreeStream.Write("""text"":"""_##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName","未选择病历")_"""")
		d emrTreeStream.Write("},")
		d emrTreeStream.CopyFrom(..GetTemplateTreeJson("0"))
		d emrTreeStream.Write("]")
		while (emrTreeStream.AtEnd = 0)
		{
			w $ZSTRIP(emrTreeStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	
	Quit $$$OK
}

/// Description:新增申请
/// Table:EMRinstance.AuthRequest、EMRinstance.AuthAppoint、EMRinstance.AuthAppointDetail
/// Input:AEpisodeID-病人就诊号,ARequestCateCharpter-申请范围,ARequestUserID-申请人,
/// 	  ARequestDept-申请人科室,AEPRAction-申请权限类型,ARequestReason-申请原因,
///       ABeforeRequestContent-申请前计划修改的内容,AAfterRequestContent-申请后想要改成的内容,
/// Output:
/// Return:  AppointID:新增操作成功;  0:有的参数为空;  -1:新增未成功
/// Others:
/// Debug: w ##class(EMRservice.Ajax.AuthAppoint).AddRequest("220","877||13^935||2^935||3^68^1297||1^1301||1^1296||1","359","6","save,delete,print,view,new","123","aaa","bbb","240","6","134")
/// liuzhongwan 入参改名
ClassMethod AddRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRActions As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID) As %String
{
	//s ^Tempncc("0") = AEpisodeID_"^"_ARequestCateCharpter_"^"_ARequestUserID_"^"_ARequestDept_"^"_AEPRActions_"^"_ARequestReason_"^"_ABeforeRequestContent_"^"_AAfterRequestContent_"^"_APatientID_"^"_AUserLocID_"^"_ASSGroupID
	s result = "0"
	q:(AEpisodeID = "")||(ARequestUserID = "")||(ARequestDept = "")||(ARequestCateCharpter = "")||(AEPRActions = "") result
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	s flag = "0"
	TStart
	//对申请表插入数据
	s RequestObj = ##class(EMRinstance.AuthRequest).%New()
	if (RequestObj = "")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	s RequestObj.EpisodeID = AEpisodeID
	s RequestObj.RequestUserID = ARequestUserID
	s RequestObj.RequestDept = ARequestDept
	s RequestObj.RequestDate = date
	s RequestObj.RequestTime = time
	s RequestObj.RequestReason = ARequestReason
	s RequestObj.BeforeRequestContent = ABeforeRequestContent
	s RequestObj.AfterRequestContent = AAfterRequestContent
	s RequestObj.RequestCateCharpter = ARequestCateCharpter
	s RequestObj.RequestAction = AEPRActions
	
	s RequestSC = RequestObj.%Save()

	if ('$$$ISOK(RequestSC))
	{
		TRollback
		s flag = "-2"
		q flag
	}
	else
	{
		s RequestID = RequestObj.%Id()
	}
	
	s PAAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
	//"Y#1^2^3&4^5^6&7^8^9"
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	//门急诊患者、并且开启了三级授权
	if (PAAdmType '= "I")&&(IsMultilevelAppoint = "Y")
	{
		s LevelGroups1 = $p($p(multilevelAppoint,"#",2),"&",1)
		s LevelGroups2 = $p($p(multilevelAppoint,"#",2),"&",2)
		s LevelGroups3 = $p($p(multilevelAppoint,"#",2),"&",3)
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%New()
		if (AppointObj = "")
		{
			s flag = "-3"
			q 
		}
		s AppointObj.RequestID = RequestID
		s AppointObj.EpisodeID = AEpisodeID
		s AppointObj.RequestUserID = ARequestUserID
		s AppointObj.RequestDept = ARequestDept
		s AppointObj.RequestDate = date
		s AppointObj.RequestTime = time
		s AppointObj.RequestCateCharpter = ARequestCateCharpter
		s AppointObj.RequestAction = AEPRActions
		s AppointObj.AppointStatus = "N"
		s AppointObj.AppointStatus1 = "N"
		s AppointObj.AppointStatus2 = "N"
		s AppointObj.AppointStatus3 = "N"
		//s AppointObj.AuthLevel = level

		s AppointSC = AppointObj.%Save()
		if ('$$$ISOK(AppointSC))
		{
			s flag = "-4"
			q 
		}
		else
		{
			s AppointID = AppointObj.%Id()
			s result = AppointID
		}
		//对授权明细表插入数据
		s CharpterCount = $l(ARequestCateCharpter, "^")
		for j = 1:1:CharpterCount{
			s newflag = 0
			s Charpter = $p(ARequestCateCharpter,"^",j)
			//对模板的处理
			if '(Charpter [ "||")
			{
				continue:('(AEPRActions [ "new"))
				if ('(AEPRActions [ "save"))
				{
					s AEPRActions = AEPRActions_",save"
				}
				s newflag = 1
			}
			
			s ActionCount = $l(AEPRActions, ",")
			for k = 1:1:ActionCount{
				s action = $p(AEPRActions,",",k)
				continue:(newflag = 0)&&(action = "new") //过滤掉对实例病历的“创建”权限的申请
				
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%New()
				if (DetailObj = "")
				{
					s flag = "-5"
					q 
				}
				
				s DetailObj.AppointID = AppointID
				s DetailObj.EpisodeID = AEpisodeID
				s DetailObj.CateCharpter = Charpter
				s DetailObj.Action = action
				s DetailObj.DetailStatus = "0"
				s DetailObj.Modify = "0"
				
				s DetailSC = DetailObj.%Save()
				if ('$$$ISOK(DetailSC))
				{
					s flag = "-6"
					q 
				}
			}
		}
	}
	
	else
	{
		//对授权表插入数据 -- 未开启三级授权
	s splitChapter = ..SplitRequestChapter(APatientID, AEpisodeID, ARequestCateCharpter, ARequestUserID, AUserLocID, ASSGroupID)
	for i = 1:1:4
	{
		s chapter = $P(splitChapter, "#", i)
		s level = (i * 100)
		continue:(chapter = "")
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%New()
		if (AppointObj = "")
		{
			s flag = "-3"
			q 
		}
		s AppointObj.RequestID = RequestID
		s AppointObj.EpisodeID = AEpisodeID
		s AppointObj.RequestUserID = ARequestUserID
		s AppointObj.RequestDept = ARequestDept
		s AppointObj.RequestDate = date
		s AppointObj.RequestTime = time
		s AppointObj.RequestCateCharpter = chapter
		s AppointObj.RequestAction = AEPRActions
		s AppointObj.AppointStatus = "N"
		s AppointObj.AuthLevel = level

		s AppointSC = AppointObj.%Save()
		if ('$$$ISOK(AppointSC))
		{
			s flag = "-4"
			q 
		}
		else
		{
			s AppointID = AppointObj.%Id()
			s result = AppointID
		}
		//对授权明细表插入数据
			s currLevelCharpterCount = $l(chapter, "^")
			for j = 1:1:currLevelCharpterCount{
				s newflag = 0
				s currLevelCharpter = $p(chapter,"^",j)
				//对模板的处理
				if '(currLevelCharpter [ "||")
			{
				continue:('(AEPRActions [ "new"))
				if ('(AEPRActions [ "save"))
				{
					s AEPRActions = AEPRActions_",save"
				}
				s newflag = 1
			}
			
			s ActionCount = $l(AEPRActions, ",")
			for k = 1:1:ActionCount{
				s action = $p(AEPRActions,",",k)
				continue:(newflag = 0)&&(action = "new") //过滤掉对实例病历的“创建”权限的申请
				
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%New()
				if (DetailObj = "")
				{
					s flag = "-5"
					q 
				}
				
				s DetailObj.AppointID = AppointID
				s DetailObj.EpisodeID = AEpisodeID
				s DetailObj.CateCharpter = currLevelCharpter
				s DetailObj.Action = action
				s DetailObj.DetailStatus = "0"
				s DetailObj.Modify = "0"
				
				s DetailSC = DetailObj.%Save()
				if ('$$$ISOK(DetailSC))
				{
					s flag = "-6"
					q 
					}
				}
			}
		}
	}
	if (flag < 0)
	{
		TRollback
		s result = "-1"
		q result
	}
	
	TCommit
	q result
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:更新授权范围
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-ID
/// 	  AppointCateCharpter-授权范围
/// Output:
/// Return:1-操作成功,-1-操作失败
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).UpdateFS("26^1#27^1#28^0#29^0")
ClassMethod UpdateFS(AppointActions As %String) As %String
{
	q:(AppointActions = "") "-1"
	s flag = "1"
	TStart
	s count = $L(AppointActions,"#")
	for i = 1:1:count{
		s DetailID = $p($p(AppointActions,"#",i),"^",1)
		s DetailStatus = $p($p(AppointActions,"#",i),"^",2)
		if (DetailID '= "")
		{
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			continue:(DetailObj = "")
			
			s DetailObj.DetailStatus = DetailStatus
			s DetailObj.Modify = "1"
			
			s sc = DetailObj.%Save()
			d DetailObj.%Close()
			
			if ('$$$ISOK(sc))
			{
				s flag = "-1"
				q
			}
		}
	}
	if (flag = "-1")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	TCommit
	q flag
}

/// Creator:loo
/// CreatDate:2010-09-20
/// Description:更新记录,进行授权
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-授权表RowID,AppointSpan-授权时长,AppointCateCharpter-授权范围,
/// 	  AppointUserID-授权人,AEPRAciton-授权权限类型(可为空,空的话不进行更新，保持原有记录),
/// 	  AppointType-授权类型(0-个人,1-科室)
/// Output:
/// Return:1-更新操作成功,-1-更新操作失败
/// Others:
/// Debug: w ##class(EMRservice.Ajax.auth.authorize).AddAppoint("157",604800,"10209","0","","29","52#58","authorize","")
ClassMethod AddAppoint(AappointID As %String, AppointSpan As %Integer, AppointUserID As %String, AppointType As %String, AppointDesc As %String = "", AppointUserGroupID As %String = "", AppointTempCate As %String = "", AType As %String = "", AppointUserLocID As %String = "") As %String
{
	//s ^temoncc("0") = AappointID_"^"_AppointSpan_"^"_AppointUserID_"^"_AppointType
	q:(AappointID = "")||(AppointSpan = "")||(AppointUserID = "")||(AppointType = "") "-1"
	s flag = "1"
	TStart
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	if (AppointDesc = "")
	{
		s AppointDesc = "未填"
	}
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AappointID)
	
	s currMultilevel = "0"
	s PAAdmType = $p($g(^PAADM(appoint.EpisodeID)),"^",2)
	//"Y#1^2^3&4^5^6&7^8^9"
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	//开启了三级授权
	if (IsMultilevelAppoint = "Y")
	{
		s LevelGroups1 = $p($p(multilevelAppoint,"#",2),"&",1)
		s LevelGroups2 = $p($p(multilevelAppoint,"#",2),"&",2)
		s LevelGroups3 = $p($p(multilevelAppoint,"#",2),"&",3)
		
		if (("^"_LevelGroups1_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "1"
			s appoint.AppointUserID = AppointUserID
			s appoint.AppointDept = AppointUserLocID
			s appoint.AppointStatus1 = "F"
			s appoint.OperDate1 = date
			s appoint.OperTime1 = time
			if (LevelGroups3 '= "") //三级授权
			{
				if (appoint.AppointStatus2 = "F")&&(appoint.AppointStatus3 = "F")
				{
					s appoint.AppointStatus = "F"
				}
			}
			else //二级授权
			{
				if (appoint.AppointStatus2 = "F")
				{
					s appoint.AppointStatus = "F"
				}
			}
			if (appoint.AppointStatus = "F")
			{
			    s appoint.AppointDate = date
	            s appoint.AppointTime = time
	
	            s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
	            s appoint.AppointEndDate = $p(EndDateTime,",",1)
	            s appoint.AppointEndTime = $p(EndDateTime,",",2)
			}	
			
		}
		elseif (("^"_LevelGroups2_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "2"
			s appoint.AppointUserID2 = AppointUserID
			s appoint.AppointDept2 = AppointUserLocID
			s appoint.AppointStatus2 = "F"
			s appoint.OperDate2 = date
			s appoint.OperTime2 = time
			if (LevelGroups3 '= "") //三级授权
			{
				if (appoint.AppointStatus1 = "F")&&(appoint.AppointStatus3 = "F")
				{
					s appoint.AppointStatus = "F"
				}
			}
			else //二级授权
			{
				if (appoint.AppointStatus1 = "F")
				{
					s appoint.AppointStatus = "F"
				}
			}
			if (appoint.AppointStatus = "F")
			{
			    s appoint.AppointDate = date
	            s appoint.AppointTime = time
	
	            s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
	            s appoint.AppointEndDate = $p(EndDateTime,",",1)
	            s appoint.AppointEndTime = $p(EndDateTime,",",2)
			}	
		}
		elseif (("^"_LevelGroups3_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "3"
			s appoint.AppointUserID3 = AppointUserID
			s appoint.AppointDept3 = AppointUserLocID
			s appoint.AppointStatus3 = "F"
			s appoint.OperDate3 = date
			s appoint.OperTime3 = time
			if (appoint.AppointStatus1 = "F")&&(appoint.AppointStatus2 = "F")
			{
				s appoint.AppointStatus = "F"
				s appoint.AppointDate = date
	            s appoint.AppointTime = time
	
	            s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
	            s appoint.AppointEndDate = $p(EndDateTime,",",1)
	            s appoint.AppointEndTime = $p(EndDateTime,",",2)
			}
		}
		 
	}
	else
	{
		s appoint.AppointUserID = AppointUserID
		s appoint.AppointDept = AppointUserLocID
		s appoint.AppointStatus = "F"
	    s appoint.AppointDate = date
	    s appoint.AppointTime = time
	
	    s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
	    s appoint.AppointEndDate = $p(EndDateTime,",",1)
	    s appoint.AppointEndTime = $p(EndDateTime,",",2)	
	}
	
	s appoint.AppointType = AppointType
	s appoint.AppointDesc = AppointDesc
	
	s sc = appoint.%Save()
	if (AType'=""){
    	s AppointTempCatelen = $l(AppointTempCate,"#")
		s AppointTempCateObj = ##Class(%ArrayOfDataTypes).%New()
		for i=1:1:AppointTempCatelen{
			s item = $p(AppointTempCate,"#",i)
			d AppointTempCateObj.SetAt(""_i,item)
			}
		}
	if ($$$ISOK(sc))
	{
		if (currMultilevel = "0")||(currMultilevel = "1")
		{
		s hasSaveAction = "0"
		s DetailID = ""
		for
		{
			s DetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppoint", " "_AappointID, DetailID))
			q:(DetailID = "")
			
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			s surCateCharpter = DetailObj.CateCharpter
			if (AType'=""){
				if (AppointTempCate'=""&&(AppointTempCate'="noclick"))
				{
					continue:AppointTempCateObj.GetAt(surCateCharpter)=""
				}
			}
			continue:(DetailObj.Modify = "1")
			
			//已封存的病历不能进行授权，这里配合前端提示，进行过滤
			s IsSealed = "N"
			if (surCateCharpter [ "||")
			{
				s episodeID = DetailObj.EpisodeID
				if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
				{
					s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(episodeID,surCateCharpter)
					s:(Sealed = 1) IsSealed = "Y"
				}
			}
			continue:(IsSealed = "Y")
			
			s DetailObj.Modify = "1"
			s DetailObj.DetailStatus = "1"
			
			if (DetailObj.Action = "save")&&(DetailObj.DetailStatus = "1")
			{
				s hasSaveAction = "1"
			}
			
			s Detailsc = DetailObj.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = "-1"
			}
			d DetailObj.%Close()
		}
		if (flag = "1")
		{
			s EpisodeID = appoint.EpisodeID
			s RequestUserID = appoint.RequestUserID
			
			//授权成功后发送消息给申请医生 add by niucaicai 2016-11-10
			s SetAppointMsgToDoc = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetAppointMsgToDoc")
			if (SetAppointMsgToDoc = "Y")
			{
				s MessageBody = "已同意病历操作权限的申请！"
				d ##class(websys.DHCMessageInterface).Send(MessageBody,"1068",AppointUserID,EpisodeID,"",RequestUserID,"")
			}
			
			//如果病历已经提交,需要在授权时间结束后自动提交病历
			/*if (hasSaveAction = "1")
			{
				s MedRecordStatus = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(appoint.EpisodeID)
				//s MedRecordStatus = "0^1^0"
				s Cmmited = $p(MedRecordStatus,"^",2)
				if (Cmmited = 1)
				{
					d ##Class(DHCEPRFS.BI.BIToEMR).ApplyAuthorization(appoint.EpisodeID,appoint.RequestUserID,appoint.AppointUserID,appoint.AppointDate,appoint.AppointTime,appoint.AppointEndDate,appoint.AppointEndTime)
				}
			}*/
			}
		}
	}
	else
	{
		s flag = "-1"
	}
	d appoint.%Close()
	
	if (flag = "-1")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	TCommit
	q flag
}

ClassMethod RefuseAppoint(AappointID As %String, AAppointUserID As %String, ARefuseReason As %String = "", AppointUserGroupID As %String = "", AppointUserLocID As %String = "") As %String
{
	//s ^temoncc("0") = AappointID_"^"_AAppointUserID_"^"_ARefuseReason
	q:(AappointID = "") "-1"
	
	s flag = "1"
	TStart	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AappointID)
	q:(appoint="") "-1"	
	
	s currMultilevel = "0"
	s PAAdmType = $p($g(^PAADM(appoint.EpisodeID)),"^",2)
	//"Y#1^2^3&4^5^6&7^8^9"
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	//写入拒绝时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	//门急诊患者、并且开启了三级授权
	if (IsMultilevelAppoint = "Y")
	{
		s LevelGroups1 = $p($p(multilevelAppoint,"#",2),"&",1)
		s LevelGroups2 = $p($p(multilevelAppoint,"#",2),"&",2)
		s LevelGroups3 = $p($p(multilevelAppoint,"#",2),"&",3)
		
		if (("^"_LevelGroups1_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "1"
			s appoint.AppointUserID = AAppointUserID
			s appoint.AppointDept = AppointUserLocID
			s appoint.AppointStatus1 = "R"
			s appoint.OperDate1 = date
			s appoint.OperTime1 = time
		}
		elseif (("^"_LevelGroups2_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "2"
			s appoint.AppointUserID2 = AAppointUserID
			s appoint.AppointDept2 = AppointUserLocID
			s appoint.AppointStatus2 = "R"
			s appoint.OperDate2 = date
			s appoint.OperTime2 = time
		}
		elseif (("^"_LevelGroups3_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "3"
			s appoint.AppointUserID3 = AAppointUserID
			s appoint.AppointDept3 = AppointUserLocID
			s appoint.AppointStatus3 = "R"
			s appoint.OperDate3 = date
			s appoint.OperTime3 = time
		}
		s appoint.AppointEndDate = ""
		s appoint.AppointEndTime = ""
	}
	else
	{
		s appoint.AppointUserID = AAppointUserID
		s appoint.AppointDept = AppointUserLocID
	}
	//设定状态为拒绝
	s appoint.AppointStatus = "R"
	s appoint.AppointDate = date
	s appoint.AppointTime = time
	s appoint.RefuseReason = ARefuseReason	
	
	s sc = appoint.%Save()
	//拒绝成功后发送消息给申请医生 add by niucaicai 2016-11-10
	s SetAppointMsgToDoc = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetAppointMsgToDoc")
	if ($$$ISOK(sc))
	{
		s DetailID = ""
		for
		{
			s DetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppoint", " "_AappointID, DetailID))
			q:(DetailID = "")
			
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			
			s DetailObj.Modify = "1"
			s DetailObj.DetailStatus = "0"
			
			s Detailsc = DetailObj.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = "-1"
			}
			d DetailObj.%Close()
		}
		
		if (flag = "1")
		{
			s EpisodeID = appoint.EpisodeID
			s RequestUserID = appoint.RequestUserID
			
			if (SetAppointMsgToDoc = "Y")
			{
				if (ARefuseReason = "")
				{
					s RefuseReason = "未填！"
				}
				else
				{
					s RefuseReason = ARefuseReason
				}
				s MessageBody = "已拒绝病历操作权限的申请！ 原因："_RefuseReason
				d ##class(websys.DHCMessageInterface).Send(MessageBody,"1069",AAppointUserID,EpisodeID,"",RequestUserID,"")
			}
		}
	}
	else
	{
		s flag = "-1"
	}
	d appoint.%Close()
	
	if (flag = "-1")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	TCommit
	q flag
}

ClassMethod WithdrawAppoint(AappointID As %String, AppointUserGroupID As %String = "") As %String
{
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AappointID)
	q:(appoint="") "-1"	
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointEndDate = date
	s appoint.AppointEndTime = time-1
	s currMultilevel = "0"
	s PAAdmType = $p($g(^PAADM(appoint.EpisodeID)),"^",2)
	//"Y#1^2^3&4^5^6&7^8^9"
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	//门急诊患者、并且开启了三级授权
	if (IsMultilevelAppoint = "Y")
	{
		s LevelGroups1 = $p($p(multilevelAppoint,"#",2),"&",1)
		s LevelGroups2 = $p($p(multilevelAppoint,"#",2),"&",2)
		s LevelGroups3 = $p($p(multilevelAppoint,"#",2),"&",3)
		
		if (("^"_LevelGroups1_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "1"
			s appoint.OperDate1 = date
			s appoint.OperTime1 = time
		}
		elseif (("^"_LevelGroups2_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "2"
			s appoint.OperDate2 = date
			s appoint.OperTime2 = time
		}
		elseif (("^"_LevelGroups3_"^") [ ("^"_AppointUserGroupID_"^"))
		{
			s currMultilevel = "3"
			s appoint.OperDate3 = date
			s appoint.OperTime3 = time
		}
	}
	
	// Zhangxy 收回授权的同时收回实例授权
	s flag = "1"
	TStart
	s sc = appoint.%Save()
	d appoint.%Close()
	if ('$$$ISOK(sc)) {
		s flag = "-1"
	}else {
		s RowID = ""
		for {
			s RowID = $o(^DHCEMRI.AuthAppointI("IdxRelatedAppoint"," "_AappointID, RowID))
			q:(RowID = "")
			s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(RowID)
			s appoint.AppointEndDate = date
			s appoint.AppointEndTime = time	- 1
			s sc = appoint.%Save()
			d appoint.%Close()
			if ('$$$ISOK(sc)) {
				s flag = "-1"
			}
		}
	}
	if (flag = "-1") {
		TRollback
	} else {
		TCommit	
	}
	q flag
}

/// Creator:loo
/// CreatDate:2010-09-29
/// Description:根据PatientID取出病人的所有episodeID,再取得所有已经进行授权的列表
/// Table:EPRinstance.EPRActionAppoint
/// Input:APatientID-病人号
/// Output:
/// Return:返回一个json格式的字符串
/// Others:
/// Debug w ##class(web.eprajax.EPRAction).GetAppointList("11","UnAppointed")
ClassMethod GetAppointList(APatientID As %String, AType As %String) As %String
{
	q:(APatientID="")||(AType="") "0"
	
	s episodeID=""
	s paAdmType=""
	s count=0
	w "["
	for {
		s paAdmType =  $o(^PAPERdr(APatientID, "ADM", paAdmType))
		q:(paAdmType = "")
		
		for {
			s episodeID = $o( ^PAPERdr(APatientID, "ADM", paAdmType, episodeID))
			q:(episodeID="")
			
			s tmpJson = ..GetAppointListByEID(APatientID,episodeID,AType)
			continue:(tmpJson="")
			
			s count = count + 1
			if (count > 1) w ","
			w tmpJson
		}
	}
	w "]"
	
	q "1"
}

/// Creator:loo
/// CreatDate:2010-09-29
/// Description:根据EpisodeID取得所有已进行授权的列表，返回一个json
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,APatientID
/// Output:
/// Return:Json格式字符串
/// Others:
/// Debug w ##class(web.eprajax.EPRAction).GetAppointListByEID("1","201868","Refuse")
ClassMethod GetAppointListByEID(APatientID As %String, AEpisodeID As %String, AType As %String) As %String
{
	s returnJson=""
	
	//<2010-9-29><loo><待授权列表中增加患者相关信息>
	
	//患者姓名
	s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(APatientID)
	//就诊日期、就诊时间
	s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	s admTime = $P($G(^PAADM(AEpisodeID)),"^",7)
	//主治医生
	s mainDoc =  ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
	s mainDoc = $P(mainDoc,"^",3)
	//就诊科室
	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
	s curDept = $P(curDept,"^",3)
	
	s RowID=""
	for {
		s RowID = $o(^DHCEMRI.AuthAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""
		
		s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(RowID)
		continue:(appoint="")
		//判断是否已经授权
		//授权日期或时间为空,即未进行授权
		if (AType = "Appointed")
		{	
			continue:(appoint.AppointDate = "")
			continue:(appoint.AppointTime = "")
			continue:(appoint.AppointStatus = "R")
			continue:(appoint.AppointStatus = "N")
		}
		elseif (AType = "UnAppointed")
		{	
			continue:(appoint.AppointDate '= "")
			continue:(appoint.AppointTime '= "")
		}
		elseif (AType = "Refuse")
		{	
			continue:(appoint.AppointDate '= "")
			continue:(appoint.AppointTime '= "")
			continue:(appoint.AppointStatus = "F")
			continue:(appoint.AppointStatus = "N")
			continue:(appoint.AppointStatus = "")
		}
		
		if (appoint.AppointDate '= "")
		{
			s day = appoint.AppointEndDate - appoint.AppointDate
			s second = appoint.AppointEndTime - appoint.AppointTime
			s appointSpan = (day * 24) + (second / 3600)
			if (+appointSpan < 0) {	s appointSpan = "0"}
		}
		
		//<2010-9-30><loo><新增一个返回值,RequestCCDes授权范围描述>
		s RequestCCDes=""
		s length = $l(appoint.RequestCateCharpter,"^")
		for i=1:1:length
		{
			s ccName = ""
			s ccID = $P(appoint.RequestCateCharpter,"^",i)
			s ccInfo = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ccID)
			if ccInfo = ""
			{	s ccName = "申请病历不存在"}
			else
			{
				s ccName = ccInfo.CategoryName
				s cgInfo = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ccInfo.ParentCategoryID)
				if cgInfo '= ""
				{	s ccName = cgInfo.CategoryName_"."_ccName}	
			}
			
			if RequestCCDes = ""
			{	s RequestCCDes = ccName}
			else
			{	s RequestCCDes = RequestCCDes_"^"_ccName}
		}
		
		
		//取用户名
		s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
		s appointUser = ""
		s:(appoint.AppointUserID'="") appointUser = appoint.AppointUserID
		
		//取用户所在科室描述
		s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)
		s appointDeptDesc = ""
		s:(appoint.AppointDept'="") appointDeptDesc=appoint.AppointDept
			
		s multilevelAppoint = "N#"
		s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
		s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
		if (IsMultilevelAppoint = "Y")
		{
			s:(appoint.AppointUserID '= "") appointUser = appoint.AppointUserID
			s:(appoint.AppointUserID2 '= "") appointUser = appoint.AppointUserID2
			s:(appoint.AppointUserID3 '= "") appointUser = appoint.AppointUserID3
			
			s:(appoint.AppointDept '= "") appointDeptDesc = appoint.AppointDept
			s:(appoint.AppointDept2 '= "") appointDeptDesc = appoint.AppointDept2
			s:(appoint.AppointDept3 '= "") appointDeptDesc = appoint.AppointDept3  
		}
		
		s appointUser = ##class(EMRmeta.PowerUser).GetUserName(appointUser)
		s appointDeptDesc = $p($g(^CTLOC(appointDeptDesc)),"^",2)
		
		
		//指定返回值
		if (returnJson '= "")
		{
			s returnJson = returnJson_","
		}
		s returnJson = returnJson_"{""ID"":"""_RowID_""""
		s returnJson = returnJson_",""EpisodeID"":"""_appoint.EpisodeID_""""
		s returnJson = returnJson_",""RequestCateCharpter"":"""_appoint.RequestCateCharpter_""""
		s returnJson = returnJson_",""RequestCCDesc"":"""_RequestCCDes_""""
		s returnJson = returnJson_",""RequestUser"":"""_currAuthor_""""
		s returnJson = returnJson_",""RequestDept"":"""_requestDeptDesc_""""
		s tmpRequestDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(appoint.RequestDate,"date") 
		s tmpRequestTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(appoint.RequestTime,"time")
		s returnJson = returnJson_",""RequestDate"":"""_tmpRequestDate_""""
		s returnJson = returnJson_",""RequestTime"":"""_tmpRequestDate_""""
		s returnJson = returnJson_",""EPRAction"":"""_appoint.EPRAction_""""
		s tmpAppointDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(appoint.AppointDate,"date") 
		s tmpAppointTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(appoint.AppointTime,"time")		
		s returnJson = returnJson_",""AppointDate"":"""_tmpAppointDate_""""
		s returnJson = returnJson_",""AppointTime"":"""_tmpAppointTime_""""
		s returnJson = returnJson_",""AppointUser"":"""_appointDeptDesc_""""
		s returnJson = returnJson_",""AppointDeptDesc"":"""_appointDeptDesc_""""
		s returnJson = returnJson_",""AppointType"":"""_appoint.AppointType_""""
		s returnJson = returnJson_",""AppointSpan"":"""_appointSpan_""""
		s returnJson = returnJson_",""AppointCateCharpter"":"""_appoint.AppointCateCharpter_""""
		s returnJson = returnJson_",""Name"":"""_name_""""
		s tmpadmDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(admDate,"date") 
		s tmpadmTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(admTime,"time")		
		s returnJson = returnJson_",""AdmDate"":"""_tmpadmDate_""""
		s returnJson = returnJson_",""AdmTime"":"""_tmpadmTime_""""
		s returnJson = returnJson_",""MainDoc"":"""_mainDoc_""""
		s returnJson = returnJson_",""RequestReason"":"""_..TrimEnterAndWrite(appoint.RequestReason)_""""
		s returnJson = returnJson_",""BeforeRequestContent"":"""_appoint.BeforeRequestContent_""""
		s returnJson = returnJson_",""AfterRequestContent"":"""_appoint.AfterRequestContent_""""
		s returnJson = returnJson_",""CurDept"":"""_curDept_""""	
		s returnJson = returnJson_",""AuthLevel"":"""_appoint.AuthLevel_""""	
		s returnJson = returnJson_",""AuthLevel"":"""_..GetAuthLevelDesc(appoint.AuthLevel)_"""}"
	}
	
	s returnJson = $TR(returnJson,$C(13),"")
	s returnJson = $TR(returnJson,$C(10),"")
		
	q returnJson
}

/// Creator:yang
/// Modify: yang
/// CreatDate:2012-04-13
/// ModifyDate:2013-06-27
/// Description:根据LocID取出科室的所有PatientID（若按登记号查询，先根据PatientID找到PapmiNo，判断此条是否满足要求）,再取出所有episodeID，再取得所有已经进行授权的列表
/// Table:EPRinstance.EPRActionAppoint
/// Input:AType-授权状态：Appointed-已授权|UnAppointed-未授权|Refuse-拒绝
/// 	  AParameters:LocID_"^"_UserID_"^"_RequestDateStart_"||"_RequestTimeStart_"||"_RequestDateEnd_"||"_RequestTimeEnd_"||"_AppointDateStart_"||"_AppointTimeStart_"||"_AppointDateEnd_"||"_AppointTimeEnd_"^"_CurLoc_"^"_CanAppointSelect_"^"_TreatmentLoc_"^"_RequestLoc_"^"_RequestUserName
/// 	  		LocID			-	当前登录医生科室ID
/// 	  		UserID			-	当前登录医生ID
/// 	  		RequestDateStart-	申请起始日期
/// 	  		RequestTimeStart-	申请起始时间
/// 	  		RequestDateEnd	-	申请终止日期
/// 	  		RequestTimeEnd	-	申请终止时间
/// 	  		AppointDateStart-	授权起始日期
/// 	  		AppointTimeStart-	授权起始时间
/// 	  		AppointDateEnd	-	授权终止日期
/// 	  		AppointTimeEnd	-	授权终止时间
/// 	  		CanAppointSelect-	能否授权
/// 	  		TreatmentLoc	-	病人就诊科室
/// 	  		RequestLoc		-	申请医生科室
/// 	  		RequestUserName	-	申请医生名字 					
/// Return:返回一个json格式的字符串
/// Debug:	d ##Class(EMRservice.Ajax.auth.authorize).GetLocAppointList("UnAppointed","","10^359^||||||||||||||^2^^^^24^0^^^^0^29^^2",0,20,"all","")
/// Debug:	d ##Class(EMRservice.Ajax.auth.authorize).GetLocAppointList("UnAppointed","","95^10209^||||||||||||||^^^^^168^0^^^^0^29^^2^100^54",0,"10","loc","")
ClassMethod GetLocAppointList(AType As %String, APatientID As %String, AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AIsAll As %String, AAuthLevelType As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	s key = $i(^CacheTemp)
	s count = 0
	k ^TempEMRAppointList(key)
	k ^TempEMRAppointData(key)
	s flag =..queryData(key,AType,APatientID,AParameters,AStartRowIndex,ARowCount,AIsAll,AAuthLevelType)
	
	//数据输出
	s authLevelTop=$p(AParameters,"^",17)
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("{""rows"":[")
	s AppointIDCount = 0
	s AppointID = ""
	for
	{
		s AppointID = $O(^TempEMRAppointList(key,AppointID))
		q:(AppointID = "")
		
		if (($zcvt(authLevelTop,"U") = "A")||($zcvt(authLevelTop,"U") = "B")||($zcvt(authLevelTop,"U") = "C"))
		{
			s AppointStream = ..GetAppointDataByIDMulti(AppointID,AParameters)
		}
		else
		{
			s AppointStream = ..GetAppointDataByID(AppointID,AParameters)
		}
		continue:(AppointStream.Size = 0)
		s json = AppointStream.Read()
		s arr = ##Class(EMRservice.Util.Json).FromJson(json)
		s tempDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",arr.GetAt("RequestDate"))
		s tempTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",arr.GetAt("RequestTime"))
		s ^TempEMRAppointData(key,tempDate,tempTime,count) = json
		s count = count + 1
		
		s AppointIDCount = AppointIDCount + 1
		
		continue:(AppointIDCount < (AStartRowIndex + 1))
		continue:(AppointIDCount > (AStartRowIndex + ARowCount))
	}
	s RequestDate = "",j=0,i=1
	for
	{
		s RequestDate = $o(^TempEMRAppointData(key,RequestDate),-1)
		q:(RequestDate="")
		s RequestTime = ""
		for
		{
			s RequestTime = $o(^TempEMRAppointData(key,RequestDate,RequestTime),-1)
			q:(RequestTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRAppointData(key,RequestDate,RequestTime,order))
				q:(order = "")
				if ((AStartRowIndex <= i)&(i <= ARowCount))
				{
					d:(j'=0) ResultStream.Write(",")				
					d ResultStream.Write(^TempEMRAppointData(key,RequestDate,RequestTime,order))
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
		
	d ResultStream.Write("],""total"":"""_AppointIDCount_"""}")
	k ^TempEMRAppointList(key)
	k ^TempEMRAppointData(key)	
	q ResultStream
}

ClassMethod GetAppointDataByIDMulti(ARowID As %String, AParameters As %String) As %GlobalCharacterStream
{
	s AppointDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") AppointDataStream
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(ARowID)
	s EpisodeID = appoint.EpisodeID
	
	//获取患者就诊信息  start
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//患者登记号
	s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	//患者姓名
	s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	//患者病案号
	s MedicareNo = $P($g(^PAPER(PatientID,"PAT",1)),"^",22)
	//就诊号
	s PaadmNO = $P($G(^PAADM(EpisodeID)),"^",81)
	//就诊日期、就诊时间
	s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
	//主治医生
	s MainDoc =  ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(EpisodeID)
	s MainDoc = $P(MainDoc,"^",3)
	//就诊科室
	s CurDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	s CurDept = $P(CurDept,"^",3)
	s CurDeptNum = $P(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID),"^",1)

	//病人就诊类型 I-住院,O-门诊,E-急诊
	s PAAdmType = $p($g(^PAADM(EpisodeID)),"^",2)   

	//病人出院信息
	s PADischgeDate=$P($g(^PAADM(EpisodeID)),"^",17)	//出院日期
	s PADischgeTime=$P($g(^PAADM(EpisodeID)),"^",18)	//出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	//获取患者就诊信息  end

	s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = "", appointUser2 = "", appointUser3 = ""	
	//取用户名
	s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
	s:(appoint.AppointUserID'="") appointUser = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID)
	s:(appoint.AppointUserID2'="") appointUser2 = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID2)
	s:(appoint.AppointUserID3'="") appointUser3 = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID3)
	
	//取用户所在科室描述
	s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)

	if (appoint.AppointDate '= "")
	{
		s day = appoint.AppointEndDate - appoint.AppointDate
		s second = appoint.AppointEndTime - appoint.AppointTime
		s appointSpan = (day * 24) + (second / 3600)
		if (+appointSpan < 0) {	s appointSpan = "0"}
		
		s appointType = appoint.AppointType
	}
	else
	{
		s appointSpan = defaultAppointSpan
		s appointType = defaultAppointType
	}

	//增加是否授权 
	s IsAppointed = "unappointed"
	s canAppoint = "0"
	if (appoint.AppointStatus = "F")
	{
		s IsAppointed = "appointed"	
		s canAppoint = "2"
	}
	elseif (appoint.AppointStatus = "R")
	{
		s IsAppointed = "refuse"	
		s canAppoint = "3"	
	}
	else
	{
		s userID =$p(AParameters,"^",2)
  		s ssgroupID = $p(AParameters,"^",14)
  		s userLocID = $p(AParameters,"^",1)
		s canAppoint = ..CanAppoint(userID, userLocID, ssgroupID, EpisodeID, PatientID)
	}
	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	//获取申请表信息 start
	s requestReason = ""
	s beforeRequestContent = ""
	s afterRequestContent = ""
	s requestNumber = ""
	s RequestID = appoint.RequestID
	if (RequestID '= "")&&(RequestID > 0)
	{
		s RequestObj = ##class(EMRinstance.AuthRequest).%OpenId(RequestID)
		s requestReason = RequestObj.RequestReason
		s beforeRequestContent = RequestObj.BeforeRequestContent
		s afterRequestContent = RequestObj.AfterRequestContent
		s requestNumber = RequestObj.RequestNumber
	}
	//获取申请表信息 end
	
	//获取病案接口信息 start
	//病案室是否已复印病历，否输出空，是输出具体病历名称
	s copyedRecords = ""
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.SSService.CommonSrv||GetCopyByEpisodeID") = 1)
	{
		s copyedRecords = ##Class(DHCWMR.SSService.CommonSrv).GetCopyByEpisodeID(EpisodeID)
	}
	//获取病案接口信息 end
	
	//输出患者信息 start
	d AppointDataStream.Write("{")
	s EpisodeID = ..TrimEnterAndWrite(EpisodeID)
	d AppointDataStream.Write("""EpisodeID"":"""_EpisodeID_"""")
	s PaadmNO = ..TrimEnterAndWrite(PaadmNO)
	d AppointDataStream.Write(",""PaadmNO"":"""_PaadmNO_"""")
	s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
	d AppointDataStream.Write(",""PapmiNo"":"""_PapmiNo_"""")
	s PatName = ..TrimEnterAndWrite(PatName)
	d AppointDataStream.Write(",""Name"":"""_PatName_"""")
	s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
	d AppointDataStream.Write(",""MedicareNo"":"""_MedicareNo_"""")
	s AdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)
	d AppointDataStream.Write(",""AdmDate"":"""_AdmDate_"""")
	s AdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)
	d AppointDataStream.Write(",""AdmTime"":"""_AdmTime_"""")
	s MainDoc = ..TrimEnterAndWrite(MainDoc)
	d AppointDataStream.Write(",""MainDoc"":"""_MainDoc_"""")
	s CurDept = ..TrimEnterAndWrite(CurDept)
	d AppointDataStream.Write(",""CurDept"":"""_CurDept_"""")
	s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
	d AppointDataStream.Write(",""PAAdmType"":"""_PAAdmType_"""")
	s PAStatus = ..TrimEnterAndWrite(PAStatus)
	d AppointDataStream.Write(",""PAStatus"":"""_PAStatus_"""")
	s PADischgeDateTime = $case(PADischgeDateTime,"":"",:##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(PADischgeDate,3)_" "_$zt(PADischgeTime)))
	
	d AppointDataStream.Write(",""PADischgeDateTime"":"""_PADischgeDateTime_"""")
	//输出患者信息 end
	
	//输出病案接口信息 start
	s copyedRecords = ..TrimEnterAndWrite(copyedRecords)
	d AppointDataStream.Write(",""CopyedRecords"":"""_copyedRecords_"""")
	//输出病案接口信息 end
	
	//输出授权表信息  start
	s ID = ..TrimEnterAndWrite(ARowID)
	d AppointDataStream.Write(",""AppointID"":"""_ID_"""")
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	d AppointDataStream.Write(",""RequestUser"":"""_currAuthor_"""")
	s requestDeptDesc = ..TrimEnterAndWrite(requestDeptDesc)
	d AppointDataStream.Write(",""RequestDept"":"""_requestDeptDesc_"""")
	s requestDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appoint.RequestDate)
	d AppointDataStream.Write(",""RequestDate"":"""_requestDate_"""")
	s requestTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appoint.RequestTime)
	d AppointDataStream.Write(",""RequestTime"":"""_requestTime_"""")
	s requestDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(appoint.RequestDate,3)_" "_$zt(appoint.RequestTime))
	d AppointDataStream.Write(",""RequestDateTime"":"""_requestDateTime_"""")
	s appointDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appoint.AppointDate)
	d AppointDataStream.Write(",""AppointDate"":"""_appointDate_"""")
	s appointTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appoint.AppointTime)
	d AppointDataStream.Write(",""AppointTime"":"""_appointTime_"""")
	if (appoint.AppointDate'="")&&(appoint.AppointTime'="")
	{
		s appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
		s:($replace(appointDateTime," ","")'="") appointDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointDateTime)
	
	}
	else{
		s appointDateTime = ""
	}
	d AppointDataStream.Write(",""AppointDateTime"":"""_appointDateTime_"""")
	
	
	
	s appointUser = ..TrimEnterAndWrite(appointUser)
	d AppointDataStream.Write(",""AppointUser"":"""_appointUser_"""")
	
	s AppointStatus1 = ..TrimEnterAndWrite(appoint.AppointStatus1)
	d AppointDataStream.Write(",""AppointStatus1"":"""_AppointStatus1_"""")
	s OperDate1 = ..TrimEnterAndWrite($ZD(appoint.OperDate1,3))
	d AppointDataStream.Write(",""OperDate1"":"""_OperDate1_"""")
	s OperTime1 = ..TrimEnterAndWrite($ZT(appoint.OperTime1))
	d AppointDataStream.Write(",""OperTime1"":"""_OperTime1_"""")
	s OperDateTime1 = ..TrimEnterAndWrite($ZD(appoint.OperDate1,3)_" "_$ZT(appoint.OperTime1))
	d AppointDataStream.Write(",""OperDateTime1"":"""_OperDateTime1_"""")
	s appointUser2 = ..TrimEnterAndWrite(appointUser2)
	d AppointDataStream.Write(",""AppointUser2"":"""_appointUser2_"""")
	s AppointStatus2 = ..TrimEnterAndWrite(appoint.AppointStatus2)
	d AppointDataStream.Write(",""AppointStatus2"":"""_AppointStatus2_"""")
	s OperDate2 = ..TrimEnterAndWrite($ZD(appoint.OperDate2,3))
	d AppointDataStream.Write(",""OperDate2"":"""_OperDate2_"""")
	s OperTime2 = ..TrimEnterAndWrite($ZT(appoint.OperTime2))
	d AppointDataStream.Write(",""OperTime2"":"""_OperTime2_"""")
	s OperDateTime2 = ..TrimEnterAndWrite($ZD(appoint.OperDate2,3)_" "_$ZT(appoint.OperTime2))
	d AppointDataStream.Write(",""OperDateTime2"":"""_OperDateTime2_"""")
	
	s appointUser3 = ..TrimEnterAndWrite(appointUser3)
	d AppointDataStream.Write(",""AppointUser3"":"""_appointUser3_"""")
	s AppointStatus3 = ..TrimEnterAndWrite(appoint.AppointStatus3)
	d AppointDataStream.Write(",""AppointStatus3"":"""_AppointStatus3_"""")
	s OperDate3 = ..TrimEnterAndWrite($ZD(appoint.OperDate3,3))
	d AppointDataStream.Write(",""OperDate3"":"""_OperDate3_"""")
	s OperTime3 = ..TrimEnterAndWrite($ZT(appoint.OperTime3))
	d AppointDataStream.Write(",""OperTime3"":"""_OperTime3_"""")
	s OperDateTime3 = ..TrimEnterAndWrite($ZD(appoint.OperDate3,3)_" "_$ZT(appoint.OperTime3))
	d AppointDataStream.Write(",""OperDateTime3"":"""_OperDateTime3_"""")
	
	
	
	s appointType = ..TrimEnterAndWrite(appointType)
	d AppointDataStream.Write(",""AppointType"":"""_appointType_"""")
	s isActive = ..TrimEnterAndWrite(isActive)
	d AppointDataStream.Write(",""IsActive"":"""_isActive_"""")
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	d AppointDataStream.Write(",""AppointSpan"":"""_appointSpan_"""")
	if (appoint.AppointEndDate'="")&&(appoint.AppointEndTime'="")
	{
		s appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
		s:($replace(appointEndDateTime," ","")'="") appointEndDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointEndDateTime)
	
	}
	else{
		s appointEndDateTime = ""
	}
	d AppointDataStream.Write(",""AppointEndDateTime"":"""_appointEndDateTime_"""")
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	d AppointDataStream.Write(",""IsAppointed"":"""_IsAppointed_"""")
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	d AppointDataStream.Write(",""CanAppoint"":"""_canAppoint_"""")
	s AuthLevel = ..TrimEnterAndWrite(appoint.AuthLevel)
	d AppointDataStream.Write(",""AuthLevel"":"""_AuthLevel_"""")
	s AuthLevelDesc = ..TrimEnterAndWrite(..GetAuthLevelDesc(appoint.AuthLevel))
	d AppointDataStream.Write(",""AuthLevelDesc"":"""_AuthLevelDesc_"""")
	s RefuseReason = ..TrimEnterAndWrite(appoint.RefuseReason)
	d AppointDataStream.Write(",""RefuseReason"":"""_RefuseReason_"""")
	
	//输出申请表信息 start
	s requestReason = ..TrimEnterAndWrite(requestReason)
	d AppointDataStream.Write(",""RequestReason"":"""_requestReason_"""")
	s beforeRequestContent = ..TrimEnterAndWrite(beforeRequestContent)
	d AppointDataStream.Write(",""BeforeRequestContent"":"""_beforeRequestContent_"""")
	s afterRequestContent = ..TrimEnterAndWrite(afterRequestContent)
	d AppointDataStream.Write(",""AfterRequestContent"":"""_afterRequestContent_"""")
	s requestNumber = ..TrimEnterAndWrite(requestNumber)
	d AppointDataStream.Write(",""RequestNumber"":"""_requestNumber_"""")
	//输出申请表信息 end
	//输出申请明细表信息 start
	d AppointDataStream.Write(",""AppointDetailData"":[")
	s DetailDataStream = ..GetDetailDataStreamByID(ARowID,IsAppointed,canAppoint,$p(AParameters,"^",18))
	d AppointDataStream.CopyFrom(DetailDataStream)
	d AppointDataStream.Write("]")
	//输出申请明细表信息 end
	
	d AppointDataStream.Write("}")
	
	d:(DetailDataStream.Size = 0) AppointDataStream.Clear()
	
	q AppointDataStream
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:根据EpisodeID,PatientID取得所有已进行授权的列表，根据条件判断，符合返回一个json，不符合返回空
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AID-RowID，AParameters-条件
/// Return:符合条件-Json格式字符串，不符合条件-空串
/// d ##Class(web.eprajax.EPRAction).GetLocAppointListByEID(57,"","","","","","")
ClassMethod GetLocAppointListByEID(key As %String, ARowID As %String, APatientID As %String, AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, ANeedDisplay As %String, ACount As %Integer, AAuthLevelType As %String) As %Integer
{
	s LocID = $p(AParameters,"^",1)
	s UserID = $p(AParameters,"^",2)
	s RequestDateStart = $p($p(AParameters,"^",3),"||",1)
	s RequestTimeStart = $p($p(AParameters,"^",3),"||",2)
	s RequestDateEnd = $p($p(AParameters,"^",3),"||",3)
	s RequestTimeEnd = $p($p(AParameters,"^",3),"||",4)
	s AppointDateStart = $p($p(AParameters,"^",3),"||",5)
	s AppointTimeStart = $p($p(AParameters,"^",3),"||",6)
	s AppointDateEnd = $p($p(AParameters,"^",3),"||",7)
	s AppointTimeEnd = $p($p(AParameters,"^",3),"||",8)
	
	s CanAppointSelect = $p(AParameters,"^",4)
	s TreatmentLoc = $p(AParameters,"^",5)
	s RequestLoc = $p(AParameters,"^",6)
	s RequestUserName = $p(AParameters,"^",7)
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s APAAdmType = $p(AParameters,"^",10)
	s APAStatus = $p(AParameters,"^",11)
	s AIsActive = $p(AParameters,"^",12)
	s AppointRequestSpan = $p(AParameters,"^",13)
	s SSGroupID = $p(AParameters,"^",14)
	s RequestRange = $p(AParameters,"^",15)
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(ARowID)
	
	//通过docId过滤没有该病历的申请
	if ($p(AParameters,"^",18) '= "0")
	{
		q:(("^"_..GetEmrDocId(appoint.RequestCateCharpter)_"^") '[ ("^"_$p(AParameters,"^",18)_"^")) 0
	}
	
	s episodeID = appoint.EpisodeID
	s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
	//共库的医院，读取系统参数，判断是否显示非本院数据，默认为N-不显示；
	s ALOGONHOSPID = $p(AParameters,"^",16)
	s ShowShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
	if ((ShowShareHospital = "N")&&(ALOGONHOSPID'=""))
	{
		s currHOSPID = $p($g(^CTLOC($P($g(^PAADM(episodeID)),"^",4))),"^",22)
		q:(currHOSPID '= "")&&(ALOGONHOSPID '= currHOSPID) 0
	}
	
	s patientIDOK = "0"
	if (APatientID '= "")
	{
		s PatIDLength = $l(APatientID,"^")
		for i=1:1:PatIDLength
		{
			s CurPatientID = $P(APatientID,"^",i)
			if (patientID = CurPatientID)
			{
				s patientIDOK = "1"
			}
		}
	}
	q:((APatientID'="")&&(patientIDOK="0")) 0
	
	if (ANeedDisplay '= "all")
	{
		//若不是全部科室
		//则取患者的当前科室若为登录的科室，则显示
		q:($P($g(^PAADM(episodeID)),"^",4)'=LocID) 0
	}
	
	q:(AAuthLevelType '= "")&&(AAuthLevelType '= appoint.AuthLevel) 0
	
	//多级授权时，采用流程授权
	s Multilevel = $p(AParameters,"^",17)
	if ((Multilevel = "A")||(Multilevel = "B")||(Multilevel = "C"))
	{
		if (Multilevel = "B")
		{
			//B级授权者，在A级授权者没有授权的情况下，不能看到申请内容
			q:(appoint.AppointStatus1 '= "F") 0
		}
		elseif (Multilevel = "C")
		{
			//C级授权者，在B级授权者没有授权的情况下，不能看到申请内容
			q:(appoint.AppointStatus2 '= "F") 0
		}
	}
	
	//增加是否授权 
	s IsAppointed = "unappointed"
	s canAppoint = "0"
	if (appoint.AppointStatus = "F")
	{
		s IsAppointed = "appointed"	
		s canAppoint = "2"
	}
	elseif (appoint.AppointStatus = "R")
	{
		s IsAppointed = "refuse"	
		s canAppoint = "3"	
	}
	else
	{
		s userID =$p(AParameters,"^",2)
  		s ssgroupID = $p(AParameters,"^",14)
  		s userLocID = $p(AParameters,"^",1)
		s canAppoint = ..CanAppoint(userID, userLocID, ssgroupID, episodeID, patientID)
	}
		
	//根据参数返回能否授权
	s showCanAppoint = "false"
	if (CanAppointSelect = ""){
		s showCanAppoint = "true"		
	}
	elseif (CanAppointSelect = canAppoint){
		s showCanAppoint = "true"
	}
	elseif (CanAppointSelect = "2"){
		s showCanAppoint = "true" 
	}
	else{
		s showCanAppoint = "false"
	}
		
	//只显示指定就诊科室
	s curDeptNum = $P(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID),"^",1)
	s showTreatmentLoc = ..CheckPara(TreatmentLoc, curDeptNum)	
		
	//只显示指定申请科室
	s showRequestLoc = ..CheckPara(RequestLoc, appoint.RequestDept)
		
	//只显示指定申请医生
	s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
	s showRequestUserName = ..CheckPara(RequestUserName, currAuthor)
	
	//只显示指定就诊类型
	s PAAdmType = $p($g(^PAADM(episodeID)),"^",2)   
	s showPAAdmType = ..CheckPara(APAAdmType, PAAdmType)
	
	//只显示指定在院状态	
	s PADischgeDT =##class(web.DHCDischargeHistory).GetDischargeDateTime(episodeID)
	s PADischgeDate= $P($G(PADischgeDT),"^",1) //出院日期
	s PADischgeTime = $P($G(PADischgeDT),"^",2) //出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	s showPAStatus = ..CheckPara(APAStatus, PAStatus)
	
	//只显示指定申请范围的
	s showRequestRange = ..CheckRequestRange(RequestRange,appoint.RequestCateCharpter)

	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	
	//只显示申请时间内的
	if ((RequestDateStart = "") && (RequestDateEnd = "") && (AppointRequestSpan '= "0"))
	{
		s RequestDateEnd = $p($h,",",1)
		s RequestTimeEnd = $p($h,",",2)
		s secondEnd = (RequestDateEnd * 3600 *24) + RequestTimeEnd
		s AppointRequestSpanSecond = AppointRequestSpan * 3600
		s secondStart = secondEnd - AppointRequestSpanSecond
		s appointSecond = (appoint.RequestDate * 24 * 3600) + appoint.RequestTime	
		if ((appointSecond <= secondEnd) && (appointSecond>= secondStart)){
			s RequestDateChk = "true"
		}
		else
		{
			s RequestDateChk = "false"
		}
	}
	else
	{
		s RequestDateChk = ..CheckDateTime(RequestDateStart, RequestTimeStart, RequestDateEnd, RequestTimeEnd, appoint.RequestDate, appoint.RequestTime)
	}

	//只显示授权时间内的
	s AppointDateChk = ..CheckDateTime(AppointDateStart, AppointTimeStart, AppointDateEnd, AppointTimeEnd, appoint.AppointDate, appoint.AppointTime)

	s json = ""
	q:(RequestDateChk '= "true") 0
	q:(AppointDateChk '= "true") 0
	q:(showCanAppoint '= "true") 0
	q:(showTreatmentLoc '= "true") 0 
	q:(showRequestLoc '= "true") 0
	q:(showRequestUserName '= "true") 0
	q:(showPAAdmType '= "true") 0
	q:(showPAStatus '= "true") 0
	q:(showIsActive '= "true") 0
	q:(showRequestRange '= "true") 0

	s ^TempEMRAppointList(key,ARowID) = ARowID
	d appoint.%Close()	
	q 1
}

ClassMethod GetAppointDataByID(ARowID As %String, AParameters As %String) As %GlobalCharacterStream
{
	s AppointDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") AppointDataStream
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(ARowID)
	s EpisodeID = appoint.EpisodeID
	
	//获取患者就诊信息  start
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//患者登记号
	s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	//患者姓名
	s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	//患者病案号
	s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
	//就诊号
	s PaadmNO = $P($G(^PAADM(EpisodeID)),"^",81)
	//就诊日期、就诊时间
	s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
	//主治医生
	s MainDoc =  ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(EpisodeID)
	s MainDoc = $P(MainDoc,"^",3)
	//就诊科室
	s CurDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	s CurDept = $P(CurDept,"^",3)
	s CurDeptNum = $P(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID),"^",1)

	//病人就诊类型 I-住院,O-门诊,E-急诊
	s PAAdmType = $p($g(^PAADM(EpisodeID)),"^",2)   

	//病人出院信息
	s PADischgeDT =##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	s PADischgeDate= $P($G(PADischgeDT),"^",1) //出院日期
	s PADischgeTime = $P($G(PADischgeDT),"^",2) //出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	//获取患者就诊信息  end

	s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = "", appointDeptDesc = ""	
	//取用户名
	s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
	s:(appoint.AppointUserID'="") appointUser = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID)
	
	//取用户所在科室描述
	s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)
	s:(appoint.AppointDept'="") appointDeptDesc=$p($g(^CTLOC(appoint.AppointDept)),"^",2)
	
	if (appoint.AppointDate '= "")
	{
		s day = appoint.AppointEndDate - appoint.AppointDate
		s second = appoint.AppointEndTime - appoint.AppointTime
		s appointSpan = (day * 24) + (second / 3600)
		if (+appointSpan < 0) {	s appointSpan = "0"}
		
		s appointType = appoint.AppointType
	}
	else
	{
		s appointSpan = defaultAppointSpan
		s appointType = defaultAppointType
	}

	//增加是否授权 
	s IsAppointed = "unappointed"
	s canAppoint = "0"
	if (appoint.AppointStatus = "F")
	{
		s IsAppointed = "appointed"	
		s canAppoint = "2"
	}
	elseif (appoint.AppointStatus = "R")
	{
		s IsAppointed = "refuse"	
		s canAppoint = "3"	
	}
	else
	{
		s userID =$p(AParameters,"^",2)
  		s ssgroupID = $p(AParameters,"^",14)
  		s userLocID = $p(AParameters,"^",1)
  		s authLevelTop=$p(AParameters,"^",17)
		s canAppoint = ..CanAppoint(userID, userLocID, ssgroupID, EpisodeID, PatientID)
		//判断当前登录用户是否有授权权限
		if (authLevelTop<appoint.AuthLevel){
		s canAppoint="0"
		}
	}

	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	//获取申请表信息 start
	s requestReason = ""
	s beforeRequestContent = ""
	s afterRequestContent = ""
	s RequestID = appoint.RequestID
	s requestNumber = ""
	if (RequestID '= "")
	{
		s RequestObj = ##class(EMRinstance.AuthRequest).%OpenId(RequestID)
		s requestReason = RequestObj.RequestReason
		s beforeRequestContent = RequestObj.BeforeRequestContent
		s afterRequestContent = RequestObj.AfterRequestContent
		s requestNumber = RequestObj.RequestNumber
	}
	//获取申请表信息 end
	
	//获取病案接口信息 start
	//病案室是否已复印病历，否输出空，是输出具体病历名称
	s copyedRecords = ""
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.SSService.CommonSrv||GetCopyByEpisodeID") = 1)
	{
		s copyedRecords = ##Class(DHCWMR.SSService.CommonSrv).GetCopyByEpisodeID(EpisodeID)
	}
	//获取病案接口信息 end
	
	//输出患者信息 start
	d AppointDataStream.Write("{")
	s EpisodeID = ..TrimEnterAndWrite(EpisodeID)
	d AppointDataStream.Write("""EpisodeID"":"""_EpisodeID_"""")
	s PaadmNO = ..TrimEnterAndWrite(PaadmNO)
	d AppointDataStream.Write(",""PaadmNO"":"""_PaadmNO_"""")
	s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
	d AppointDataStream.Write(",""PapmiNo"":"""_PapmiNo_"""")
	s PatName = ..TrimEnterAndWrite(PatName)
	d AppointDataStream.Write(",""Name"":"""_PatName_"""")
	s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
	d AppointDataStream.Write(",""MedicareNo"":"""_MedicareNo_"""")
	s AdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)
	d AppointDataStream.Write(",""AdmDate"":"""_AdmDate_"""")
	s AdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)
	d AppointDataStream.Write(",""AdmTime"":"""_AdmTime_"""")
	s MainDoc = ..TrimEnterAndWrite(MainDoc)
	d AppointDataStream.Write(",""MainDoc"":"""_MainDoc_"""")
	s CurDept = ..TrimEnterAndWrite(CurDept)
	d AppointDataStream.Write(",""CurDept"":"""_CurDept_"""")
	s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
	d AppointDataStream.Write(",""PAAdmType"":"""_PAAdmType_"""")
	s PAStatus = ..TrimEnterAndWrite(PAStatus)
	d AppointDataStream.Write(",""PAStatus"":"""_PAStatus_"""")
	s PADischgeDateTime = $case(PADischgeDateTime,"":"",:##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(PADischgeDate,3)_" "_$zt(PADischgeTime)))
	
	d AppointDataStream.Write(",""PADischgeDateTime"":"""_PADischgeDateTime_"""")
	//输出患者信息 end
	
	//输出病案接口信息 start
	s copyedRecords = ..TrimEnterAndWrite(copyedRecords)
	d AppointDataStream.Write(",""CopyedRecords"":"""_copyedRecords_"""")
	//输出病案接口信息 end
	
	//输出授权表信息  start
	s ID = ..TrimEnterAndWrite(ARowID)
	d AppointDataStream.Write(",""AppointID"":"""_ID_"""")
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	d AppointDataStream.Write(",""RequestUser"":"""_currAuthor_"""")
	s requestDeptDesc = ..TrimEnterAndWrite(requestDeptDesc)
	d AppointDataStream.Write(",""RequestDept"":"""_requestDeptDesc_"""")
	s requestDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appoint.RequestDate)
	d AppointDataStream.Write(",""RequestDate"":"""_requestDate_"""")
	s requestTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appoint.RequestTime)
	d AppointDataStream.Write(",""RequestTime"":"""_requestTime_"""")
	s requestDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(appoint.RequestDate,3)_" "_$zt(appoint.RequestTime))
	d AppointDataStream.Write(",""RequestDateTime"":"""_requestDateTime_"""")
	s appointDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appoint.AppointDate)
	d AppointDataStream.Write(",""AppointDate"":"""_appointDate_"""")
	s appointTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appoint.AppointTime)
	d AppointDataStream.Write(",""AppointTime"":"""_appointTime_"""")
	if (appoint.AppointDate'="")&&(appoint.AppointTime'="")
	{
		s appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
		s:($replace(appointDateTime," ","")'="") appointDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointDateTime)
	
	}
	else{
		s appointDateTime = ""
	}
	d AppointDataStream.Write(",""AppointDateTime"":"""_appointDateTime_"""")
	s appointUser = ..TrimEnterAndWrite(appointUser)
	d AppointDataStream.Write(",""AppointUser"":"""_appointUser_"""")
	s appointDeptDesc = ..TrimEnterAndWrite(appointDeptDesc)
	d AppointDataStream.Write(",""AppointDeptDesc"":"""_appointDeptDesc_"""")
	s appointType = ..TrimEnterAndWrite(appointType)
	d AppointDataStream.Write(",""AppointType"":"""_appointType_"""")
	s isActive = ..TrimEnterAndWrite(isActive)
	d AppointDataStream.Write(",""IsActive"":"""_isActive_"""")
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	d AppointDataStream.Write(",""AppointSpan"":"""_appointSpan_"""")
	if (appoint.AppointEndDate'="")&&(appoint.AppointEndTime'="")
	{
		s appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
		s:($replace(appointEndDateTime," ","")'="") appointEndDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointEndDateTime)
	
	}
	else{
		s appointEndDateTime = ""
	}
	d AppointDataStream.Write(",""AppointEndDateTime"":"""_appointEndDateTime_"""")
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	d AppointDataStream.Write(",""IsAppointed"":"""_IsAppointed_"""")
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	d AppointDataStream.Write(",""CanAppoint"":"""_canAppoint_"""")
	s AuthLevel = ..TrimEnterAndWrite(appoint.AuthLevel)
	d AppointDataStream.Write(",""AuthLevel"":"""_AuthLevel_"""")
	s AuthLevelDesc = ..TrimEnterAndWrite(..GetAuthLevelDesc(appoint.AuthLevel))
	d AppointDataStream.Write(",""AuthLevelDesc"":"""_AuthLevelDesc_"""")
	s RefuseReason = ..TrimEnterAndWrite(appoint.RefuseReason)
	d AppointDataStream.Write(",""RefuseReason"":"""_RefuseReason_"""")
	
	//输出申请表信息 start
	s requestReason = ..TrimEnterAndWrite(requestReason)
	d AppointDataStream.Write(",""RequestReason"":"""_requestReason_"""")
	s beforeRequestContent = ..TrimEnterAndWrite(beforeRequestContent)
	d AppointDataStream.Write(",""BeforeRequestContent"":"""_beforeRequestContent_"""")
	s afterRequestContent = ..TrimEnterAndWrite(afterRequestContent)
	d AppointDataStream.Write(",""AfterRequestContent"":"""_afterRequestContent_"""")
	s requestNumber = ..TrimEnterAndWrite(requestNumber)
	d AppointDataStream.Write(",""RequestNumber"":"""_requestNumber_"""")
	//输出申请表信息 end
	//输出申请明细表信息 start
	d AppointDataStream.Write(",""AppointDetailData"":[")
	s DetailDataStream = ..GetDetailDataStreamByID(ARowID,IsAppointed,canAppoint,$p(AParameters,"^",18))
	d AppointDataStream.CopyFrom(DetailDataStream)
	d AppointDataStream.Write("]")
	//输出申请明细表信息 end
	
	d AppointDataStream.Write("}")
	
	d:(DetailDataStream.Size = 0) AppointDataStream.Clear()
	
	q AppointDataStream
}

/// Degub: d ##Class(EMRservice.Ajax.auth.authorize).GetDetailDataStreamByID("156","unappointed","1","54")
ClassMethod GetDetailDataStreamByID(ARowID As %String, IsAppointed As %String, CanAppoint As %String, AEmrDocId As %String = "") As %GlobalCharacterStream
{
	s DetailDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "")||(IsAppointed = "")||(CanAppoint = "") DetailDataStream
	
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s count = 0
	s flag = ""
	s oldDetailID = ""
	s surDetailID = ""
	s oldCateCharpter = ""
	s surCateCharpter = ""
	s oldDetailStr = ""
	s surDetailStr = ""
	for
	{
		s surDetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppoint", " "_ARowID,surDetailID))
		if (surDetailID '= "")
		{
			if '((AEmrDocId = "")||(AEmrDocId = "0"))		//筛选：选择的病历目录模板
			{
				s tmpDetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s tmpDocId = ..GetEmrDocId(tmpDetailObj.CateCharpter)
				continue:(AEmrDocId '= tmpDocId)
			}
			//遍历到第一个DetailID
			if (oldDetailID = "")
			{
				s oldDetailID = surDetailID
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s surCateCharpter = DetailObj.CateCharpter
				s oldCateCharpter = surCateCharpter
				
				s CCDesc = ""
				s CCDateTime = ""
				s CCCreator = ""
				s CCDescStr = ""
				s CCDescStr = ..GetCateCharpterDescByID(surCateCharpter)
				if (CCDescStr '= "")
				{
					s CCDesc = $p(CCDescStr,"^",1)
					s CCDateTime = $p(CCDescStr,"^",2)
					s CCCreator = $p(CCDescStr,"^",3)
				}
				
				s IsSealed = "N"
				if (surCateCharpter [ "||")
				{
					s episodeID = DetailObj.EpisodeID
					if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
					{
						s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(episodeID,surCateCharpter)
						s:(Sealed = 1) IsSealed = "Y"
					}
				}
				else
				{
					s IsSealed = ""
				}
				
				if (count > 0)
				{
					d DetailDataStream.Write(",")
				}
				d DetailDataStream.Write("{")
				s CateCharpter = ..TrimEnterAndWrite(surCateCharpter)
				d DetailDataStream.Write("""CateCharpter"":"""_surCateCharpter_"""")
				d DetailDataStream.Write(",""IsSealed"":"""_IsSealed_"""")
				s CCDesc = ..TrimEnterAndWrite(CCDesc)
				d DetailDataStream.Write(",""CCDesc"":"""_CCDesc_"""")
				s CCDateTime = ..TrimEnterAndWrite(CCDateTime)
				s:($replace(CCDateTime," ","")'="") CCDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",CCDateTime)

				d DetailDataStream.Write(",""CCDateTime"":"""_CCDateTime_"""")
				s CCCreator = ..TrimEnterAndWrite(CCCreator)
				d DetailDataStream.Write(",""CCCreator"":"""_CCCreator_"""")
				d DetailDataStream.Write(",""IsAppointed"":"""_IsAppointed_"""")
				d DetailDataStream.Write(",""CanAppoint"":"""_CanAppoint_"""")
				d DetailDataStream.Write(",""Modify"":"""_DetailObj.Modify_"""")
				
				s count = count + 1
				s surDetailStr = ""
				s outputDetailStr = "true"
				
			}
			//既不是第一个DetailID也不是最后一个DetailID
			else
			{
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s surCateCharpter = DetailObj.CateCharpter
				if (surCateCharpter '= oldCateCharpter)
				{
					s CCDesc = ""
					s CCDateTime = ""
					s CCCreator = ""
					s CCDescStr = ""
					s CCDescStr = ..GetCateCharpterDescByID(surCateCharpter)
					if (CCDescStr '= "")
					{
						s CCDesc = $p(CCDescStr,"^",1)
						s CCDateTime = $p(CCDescStr,"^",2)
						s CCCreator = $p(CCDescStr,"^",3)
					}
					
					d DetailDataStream.Write(",""DetailStr"":"""_oldDetailStr_"""")
					d DetailDataStream.Write(",""DetailStr1"":"""_oldDetailStr_"""")
					d DetailDataStream.Write("}")
					
					s IsSealed = "N"
					if (surCateCharpter [ "||")
					{
						s episodeID = DetailObj.EpisodeID
						if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
						{
							s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(episodeID,surCateCharpter)
							s:(Sealed = 1) IsSealed = "Y"
						}
					}
					else
					{
						s IsSealed = ""
					}
					
					if (count > 0)
					{
						d DetailDataStream.Write(",")
					}
					d DetailDataStream.Write("{")
					s CateCharpter = ..TrimEnterAndWrite(surCateCharpter)
					d DetailDataStream.Write("""CateCharpter"":"""_surCateCharpter_"""")
					d DetailDataStream.Write(",""IsSealed"":"""_IsSealed_"""")
					s CCDesc = ..TrimEnterAndWrite(CCDesc)
					d DetailDataStream.Write(",""CCDesc"":"""_CCDesc_"""")
					s CCDateTime = ..TrimEnterAndWrite(CCDateTime)
					s CCDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",CCDateTime)
									
					d DetailDataStream.Write(",""CCDateTime"":"""_CCDateTime_"""")
					s CCCreator = ..TrimEnterAndWrite(CCCreator)
					d DetailDataStream.Write(",""CCCreator"":"""_CCCreator_"""")
					d DetailDataStream.Write(",""IsAppointed"":"""_IsAppointed_"""")
					d DetailDataStream.Write(",""CanAppoint"":"""_CanAppoint_"""")
					d DetailDataStream.Write(",""Modify"":"""_DetailObj.Modify_"""")
					
					s oldCateCharpter = surCateCharpter
					s count = count + 1
					s surDetailStr = ""
					s outputDetailStr = "false"
				}
			}
		}
		else
		{
			if (oldDetailStr '= "")
			{
				d DetailDataStream.Write(",""DetailStr"":"""_oldDetailStr_"""")
				d DetailDataStream.Write(",""DetailStr1"":"""_oldDetailStr_"""")
				d DetailDataStream.Write("}")
			}
			q
		}
			
		s Action = DetailObj.Action
        s ActionCode = $o(^DHCEMRM.AuthPrivRuleKeyI("IdKeyCode"," "_$zcvt(Action,"U"),""))
        s:(ActionCode '= "") ActionCode = $tr(ActionCode," ","")
        s ActionCode = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Auth.AuthPrivRuleKey","KeyName",ActionCode,langid)
		s DetailStatus = DetailObj.DetailStatus
		s DetailModify = DetailObj.Modify
		
		s Detail = surDetailID_"^"_ActionCode_"^"_DetailStatus_"^"_DetailModify
		if (surDetailStr = "")
		{
			s surDetailStr = Detail
		}
		else
		{
			s surDetailStr = surDetailStr_"#"_Detail
		}
		
		s oldDetailStr = surDetailStr
	}
	q DetailDataStream
}

/// Debug:	w ##Class(web.eprajax.EPRAction).SplitRequestChapter("5","42","104","105","6","100")
ClassMethod SplitRequestChapter(APatientID, AEpisodeID, ARequestChapterList, AUserID, AUserLocID, ASSGroupID) As %String
{
	q:(ARequestChapterList = "") "###"
	
	//100 患者主管医师审核级别，200 科主任审核级别，300 医务科审核级别 400病案室审核级别
	s level100 = "", level200 = "", level300 = "", level400 = ""
	
	s count = $L(ARequestChapterList,"^")
	for i = 1:1:count
	{
		s Chapter = $P(ARequestChapterList,"^",i)
		continue:(Chapter = "")
		
		//使用权限判断申请级别
		//二版
  		//s privPara = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLocID_"!templateid^0!ssgroupid^"_ASSGroupID_"!categoryid^0!docid^"_eprDocID_"!isnewframework^1!eprnum^0"
   		//三版
   		s InstanceID = ""
   		s DocID = ""
   		if (Chapter [ "||")
   		{
	   		s InstanceID = Chapter
	   	}
	   	else
	   	{
		   	s DocID = Chapter
		}
   		s privPara = "userid^"_AUserID_"!userloc^"_AUserLocID_"!ssgroupid^"_ASSGroupID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!instanceid^"_InstanceID_"!docid^"_DocID
   		//s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
   		
   		s privArr = ##Class(EMRservice.BOPrivRule).GetAuthLevelPriv(privPara)
 		s authLevel = privArr.GetAt("authlevel")
 		
 		if (authLevel < 101)
 		{	
 			//患者主管医师审核级别
 			//s authLevel = "100"
 			if (level100 = "")
 			{	s level100 = Chapter}
 			else
 			{	s level100 = level100_"^"_Chapter}
 		}	
 		elseif (authLevel < 201)	
 		{	
 			//患者所在科室科主任审核级别
 			//s authLevel = "200"
 			if (level200 = "")
 			{	s level200 = Chapter}
 			else
 			{	s level200 = level200_"^"_Chapter}
 		}	
 		elseif (authLevel < 301)
 		{	
 			//医务科审核级别
 			//s authLevel = "300"
 			if (level300 = "")
 			{	s level300 = Chapter}
 			else
 			{	s level300 = level300_"^"_Chapter}
 		}
 		else
 		{	
 			//病案室审核级别
 			//s authLevel = "400"
 			if (level400 = "")
 			{	s level400 = Chapter}
 			else
 			{	s level400 = level400_"^"_Chapter}
 		}
	}
	
	q level100_"#"_level200_"#"_level300_"#"_level400
}

ClassMethod TrimEnterAndWrite(input As %String)
{
	s input = $TR(input,$C(13),"")
	s input = $TR(input,$C(10),"")
	s input = $TR(input,$C(0),"")
    //替换双引号
    for {
        s count = $f(input,"""")
        if (count > 0)
        {
            s input = $e(input,1,count-2)_"shuangyinhao"_$e(input,count,$l(input))   
        }
        else
        {
            q
        }   
    }	
	q input
}

/// w ##class(EMRservice.Ajax.auth.authorize).GetAuthLevelDesc("100")
ClassMethod GetAuthLevelDesc(AAuthLevel As %String) As %String
{
	s result = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","未设置")
	q:(AAuthLevel = "") result
	s AuthLevelDesc = ""
	s authorizationSSGroupID = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("AuthorizationSSGroupID")
	if (AAuthLevel = "100")
	{
		s AuthLevelDesc = ..getGroupDescByID($p(authorizationSSGroupID,"#",2))
		q:(AuthLevelDesc = "") ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","主管医师级(默认)")
	}
	elseif (AAuthLevel = "200")
	{
		s AuthLevelDesc = ..getGroupDescByID($p(authorizationSSGroupID,"#",3))
		q:(AuthLevelDesc = "") ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","科主任级(默认)")
	}
	elseif (AAuthLevel = "300")
	{
		s AuthLevelDesc = ..getGroupDescByID($p(authorizationSSGroupID,"#",4))
		q:(AuthLevelDesc = "") ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","医务科级(默认)")
	}
	elseif (AAuthLevel = "400")
	{
		s AuthLevelDesc = ..getGroupDescByID($p(authorizationSSGroupID,"#",5))
		q:(AuthLevelDesc = "") ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","病案室级(默认)")
	}
	q AuthLevelDesc
}

ClassMethod getGroupDescByID(ASSGroupIDs As %String) As %String
{
	s AuthLevelDesc = ""
	s ASSGroupIDsCount = $l(ASSGroupIDs,"^")
	for i=1:1:ASSGroupIDsCount
	{
		s GroupID = $p(ASSGroupIDs,"^",i)
		if (GroupID '= ""){	
			s curAuthLevelDesc = $p(^SSU("SSGRP",GroupID),"^",1)
			if (AuthLevelDesc = "")
			{
				s AuthLevelDesc = curAuthLevelDesc
			}
			else
			{
				s AuthLevelDesc = AuthLevelDesc_"^"_curAuthLevelDesc
			}
		}
	}
	q AuthLevelDesc
}

/// Creator:loo
/// CreatDate:2010-09-20
/// Description:根据起始日期、起始时间、时间间隔(以秒为单位)计算截止日期、截止时间
/// Table:EPRinstance.EPRActionAppoint
/// Input:startDate-起始日期,startTime-起始时间,timeSpan-时间间隔
/// Output:
/// Return:截止日期和截止时间,格式为:截止日期,截止时间
/// Others:
/// Debug: w ##class(EPRservice.BOEPRActionAppoint).GetEndDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetEndDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	//b "s"
	s curDate = (startTime+timeSpan)\86400
	if (curDate=0)
	{
		q startDate_","_(startTime+timeSpan)
	}
	else
	{
		s curTime = startTime+timeSpan-(curDate*86400)
		q startDate+curDate_","_curTime
	}
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:是否有授权的权限
/// Table:EPRinstance.EPRActionAppoint
/// Input:AUserID	-当前用户ID
/// 	  AUserLocID-当前用户科室ID
/// 	  ASSGroupID-当前用户安全组ID
/// 	  AEpisodeID-就诊号
/// 	  APatientID-病人ID
/// Output:
/// Return:0-无授权权限,1-有授权权限
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).CanAppoint("105","6","29","220","240")
ClassMethod CanAppoint(AUserID As %String, AUserLocID As %String, ASSGroupID As %String, AEpisodeID As %String, APatientID As %String) As %Boolean
{
	//s ^tempncc("a") = AUserID_"^"_AUserLocID_"^"_ASSGroupID_"^"_AEpisodeID_"^"_APatientID
	//授权权限
  	//s privPara = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLocID_"!templateid^0!ssgroupid^"_ASSGroupID_"!categoryid^0!docid^0!isnewframework^1!eprnum^0"
   	//三版
   	s privPara = "userid^"_AUserID_"!userloc^"_AUserLocID_"!ssgroupid^"_ASSGroupID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!instanceid^0"
   	s privArr = ##Class(EMRservice.BOPrivRule).GetAppointPriv(privPara)
 	if privArr = ""
 	{	s isAppointActive = "0"}
 	else
 	{	s isAppointActive = privArr.GetAt("appoint")}
 	
 	q isAppointActive
}

ClassMethod CheckPara(ParaSelect As %String, Original As %String) As %String
{
	s isShow = "false"	
	if (ParaSelect = ""){
		s isShow = "true"	
	}
	elseif (ParaSelect = Original){
		s isShow = "true"	
	}
	else{
		s isShow = "false"	
	}
	q isShow
}

ClassMethod CheckRequestRange(ARequestRange As %String, RequestCateCharpter As %String) As %String
{
	q:((ARequestRange = "")||(RequestCateCharpter = "")) "true"
	s flag = "false"
	for i=1:1:$l(ARequestRange,"#")
	{
		for j=1:1:$l(RequestCateCharpter,"^")
		{
			s cgid = $p(ARequestRange,"#",i)
			s id = $E(cgid,3,$l(cgid))
			if (id = $p(RequestCateCharpter,"^",j))
			{
				s flag = "true"
				q	
			}	
		}
		q:(flag = "true")	
	}
	q flag
}

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:根据EpisodeID取出所有有效的授权(查看是否已授权,及授权是否有效)
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).CheckAppointIsActive("1")
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AID)
	q:(appoint = "") "0"
	
	///授权日期或者授权时间为空,即没有授权
	q:(appoint.AppointDate = "" || appoint.AppointTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(appoint.AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(appoint.AppointEndDate=date)&&(appoint.AppointEndTime<time) "0"
	
	q "1"
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:条目的日期是否在范围内
/// Table:EPRinstance.EPRActionAppoint
/// Input:DateStart-起始日期
/// 	  TimeStart-起始时间
/// 	  DateEnd  -终止日期
/// 	  TimeEnd  -终止时间
/// 	  ADate	   -条目的日期
/// 	  ATime	   -条目的时间
/// Return:"true"-在范围内,"false"-不在范围内
ClassMethod CheckDateTime(DateStart As %Date, TimeStart As %String, DateEnd As %Date, TimeEnd As %String, ADate As %Date, ATime As %String) As %String
{
		s DateChk = "false"
		//日期时间为空
		if ((DateStart = "") && (DateEnd = "") && (TimeStart = "") && (TimeEnd = "")){
			s DateChk = "true"
		} 
		//时间为空，日期不为空，输出所有符合日期段的
		elseif ((DateStart '="") && (DateEnd '="") && (TimeStart = "") && (TimeEnd = "")){
			if (($ZDATEH(DateStart,3) <= ADate) && (ADate <= $ZDATEH(DateEnd,3))){
				s DateChk = "true"
			}
		}
		//日期为空，时间不为空
		elseif ((DateStart ="") && (DateEnd ="") && (TimeStart '= "") && (TimeEnd '= "")){
				s DateChk = "true"
		}
		//日期时间不为空
		elseif ((DateStart '="") && (DateEnd '="") && (TimeStart '= "") && (TimeEnd '= "")){
			//日期不等于起始终止日期，输出日期段中的
			if (($ZDATEH(DateStart,3) '= ADate) && ($ZDATEH(DateEnd,3) '= ADate)){
				if (($ZDATEH(DateStart,3) < ADate) && (ADate < $ZDATEH(DateEnd,3))){
					s DateChk = "true"	
				}
			}
			//日期等于起始日期，时间大于起始时间
			elseif (($ZDATEH(DateStart,3) = ADate) && ($ZDATEH(DateEnd,3) '= ADate)){
				if ($ZTIMEH(TimeStart,4) <= ATime){
					s DateChk = "true"	
				}
			}
			//日期等于终止日期，时间小于终止时间
			elseif (($ZDATEH(DateStart,3) '= ADate) && ($ZDATEH(DateEnd,3) = ADate)){
				if ($ZTIMEH(TimeEnd,4) >= ATime){
					s DateChk = "true"
				}
			}
			//日期等于起始日期并且等于终止日期，时间大于起始时间小于终止时间
			else{
				if (($ZTIMEH(TimeStart,4) <= ATime) && ($ZTIMEH(TimeEnd,4) >= ATime)){
					s DateChk = "true"	
				}
			}
		}
		//开始日期不为空，其他为空
		elseif ((DateStart '="") && (DateEnd ="") && (TimeStart = "") && (TimeEnd = "")){
			if ($ZDATEH(DateStart,3) <= ADate){
				s DateChk = "true"
			}
		}
		//开始时间不为空，其他为空
		elseif ((DateStart ="") && (DateEnd ="") && (TimeStart '= "") && (TimeEnd = "")){
			s DateChk = "true"

		}
		//终止日期不为空，其他为空
		elseif ((DateStart ="") && (DateEnd '="") && (TimeStart = "") && (TimeEnd = "")){
			if ($ZDATEH(DateEnd,3) >= ADate){
				s DateChk = "true"
			}
		}
		//终止时间不为空，其他为空
		elseif ((DateStart ="") && (DateEnd ="") && (TimeStart = "") && (TimeEnd '= "")){
			s DateChk = "true"

		}
		//开始日期时间不为空，其他为空
		elseif ((DateStart '="") && (DateEnd ="") && (TimeStart '= "") && (TimeEnd = "")){
			//日期不等于起始日期
			if ($ZDATEH(DateStart,3) '= ADate){
				if ($ZDATEH(DateStart,3) < ADate){
					s DateChk = "true"	
				}
			}
			//日期等于起始日期，时间大于起始时间
			else{
				if ($ZTIMEH(TimeStart,4) <= ATime){
					s DateChk = "true"	
				}
			}
		}
		//终止日期时间不为空，其他为空
		elseif ((DateStart ="") && (DateEnd '="") && (TimeStart = "") && (TimeEnd '= "")){
			//日期不等于终止日期
			if ($ZDATEH(DateEnd,3) '= ADate){
				if ($ZDATEH(DateEnd,3) > ADate){
					s DateChk = "true"	
				}
			}
			//日期等于终止日期，时间小于终止时间
			else{
				if ($ZTIMEH(TimeEnd,4) >= ATime){
					s DateChk = "true"	
				}
			}
		}
		else {
			s DateChk = "false"
		}
		q DateChk
}

/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLocID-用户所在科室,
/// 	  ArgDocID-PrintDocID,打印模板ID
/// Output:
/// Return:返回一个字符串,格式如:set save=1,print=1
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).GetAllActiveAppoint("343","359","6","933||6","")
ClassMethod GetAllActiveAppoint(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AInstanceID As %String, ADocID As %String) As %String
{
	s returnStr=""
	if (AInstanceID = "")
	{
		s docID = ADocID
	}
	else
	{
		s docID = AInstanceID
	}
	
	s DetailID=""
	for {
		
		s DetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxEpisodeCharpter"," "_AEpisodeID," "_docID,DetailID))
		q:(DetailID = "")
		
		s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
		s AppointID = DetailObj.AppointID
		
		s flag = ..CheckAppointIsActive(AppointID)
		continue:(flag="0")
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%OpenId(AppointID)
		if (AppointObj.AppointType="0")
		{	
			continue:(AppointObj.RequestUserID'=AUserID)
		}
		elseif (AppointObj.AppointType="1")
		{	
			continue:(AppointObj.RequestDept'=AUserLocID)
		}
		else
		{	
			continue
		}
		
		//取符合条件的明细中记录的操作权限
		if (DetailObj.DetailStatus = "1")
		{
			if (returnStr="")
			{
				s returnStr = "s "_DetailObj.Action_"=1"
			}
			else
			{
				s returnStr = returnStr_","_DetailObj.Action_"=1"
			}
		}
	}
	
	q returnStr
}

/// s jj= ##class(EMRservice.Ajax.AuthAppoint).GetJsonStream("598","359","6","29")
/// Liuzhongwan 16/07/11重写GetJson方法，将整个树状病历结构以Stream形式一次性传出
ClassMethod GetJsonStream(AEpisodeID, AUserID, AUserLoc, ASSGroupID) As %GlobalCharacterStream
{
	s jsonStream = ##class(%GlobalCharacterStream).%New()
	d jsonStream.Write("[")
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLoc,ASSGroupID,AEpisodeID)
	while result.%Next()
	{
		continue:(result.Data("ItemCategoryID")="")
		d:(jsonStream.Size '= 1) jsonStream.Write(",")
		d jsonStream.Write("{")
		d jsonStream.Write("'id':'CG"_result.Data("ItemCategoryID")_"'")
		d jsonStream.Write(",'text':'"_result.Data("ItemTitle")_"'")
		d jsonStream.Write(",cls:'folder'")
		d jsonStream.Write(",checked:false")
		d jsonStream.Write(",expanded:true")
		d jsonStream.Write(",children:[")
		s docIds = ..GetDocIdsByParent(result.Data("ItemCategoryID"))
		s jsonList = ##Class(%ListOfDataTypes).%New()
		s MutexFlg = 0
		s length = $l(docIds,",")
		s count=0
		for i=1:1:length{
			s docId = $p(docIds,",",i)
			s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
			s checkpriv = ##Class(EMRservice.DocRestLogic.TempActLogic).CanTempAct(docId, "READ", curPatInfo)
			s checkInstance = ##Class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, "", docId)
			continue:(checkpriv = 0)&&(checkInstance = 0)
			s docObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			s parentId = docObj.ParentCategoryID
			s parentObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
			s parentMutex = parentObj.IsMutex
			continue:(MutexFlg = 1)&&(parentMutex = 1)
			//s checkInstance = ##Class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, "", docId)
			s:(parentMutex=1)&&(checkInstance'=0) MutexFlg = 1
			s docJson = ..GetDocJsonsById(docId,AEpisodeID)
			continue:(docJson = "")
			d jsonList.Insert(parentMutex_"^"_checkInstance_"^"_docJson)
		}
		s key = ""
		for{
			s value = jsonList.GetNext(.key)
			q:(key="")
			continue:($p(value,"^",1)=1)&&($p(value,"^",2)=0)&&(MutexFlg=1)
			s docJson = $p(value,"^",3)
			d:(count '= 0) jsonStream.Write(",")
			d jsonStream.Write(docJson)
			s count = count+1
		}
		d jsonStream.Write("]}")
	}
	//liuzhongwan如果没有query到，就提示“您不能申请该就诊的操作权限”
	//modify by niucaicai 2016-10-14 jsonStream变量名书写错误
	d:(jsonStream.Size = 1) jsonStream.Write("您不能申请该就诊的操作权限，请确认当前科室有病历展现结构！可联系高级用户进行设置！")
	d jsonStream.Write("]")
	q jsonStream
}

ClassMethod GetJson(parentID, episodeID, userID, userLoc, workGroupID)
{
	//s ^CaheTempDHCEPRDebug("actionappointchapter","input") = parentID_"^"_episodeID_"^"_userID_"^"_userLoc_"^"_workGroupID
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	
	w "["
	if type = "RT"
	{	d ..GetCategoryJason(episodeID, userID, userLoc, workGroupID)}
	elseif type = "CG"
	{	d ..GetCateChapterJason(id,episodeID, userID, userLoc, workGroupID)}
	
	w "]"
}

/// w ##class(EMRservice.Ajax.AuthAppoint).GetCategoryJason("9","743","9","29")
ClassMethod GetCategoryJason(episodeID, userID, userLoc, workGroupID)
{
	//s parentId = "RT0"
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))	
	//s parentId = " "_parentId
	
	s json = "",count = 0
	q:(userLoc = "") json
	//由于EMRservice.BL.BLClientCategory.cls中改变了GetCategory这个Query，所以跟随改变，获取病历树
	/*
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	q:(schemType = "") json
	*/
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(userLoc,workGroupID,episodeID)
	while result.%Next()
	{
		continue:(result.Data("ItemCategoryID")="")
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""id"":""CG"_result.Data("ItemCategoryID")_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_""""
		s json = json_",cls:'folder'"
		s json = json_",checked:false"
		/*
		s json = json_ ",""attributes"":{" 
		s json = json_ """image"":"""_result.Data("ItemImagePath")_"""" 
		s json = json_ ",""categoryId"":"""_result.Data("ItemCategoryID")_""""
		s json = json_ ",""type"":"""_result.Data("ItemType")_"""" 		
		s json = json_ ",""itemUrl"":"""_result.Data("ItemURL")_"?"_result.Data("ItemParas")_""""
		s json = json_ "}"
		*/
		s json = json_ "}"
		s count = count + 1
	}
	//liuzhongwan如果没有query到，就提示“您不能申请该就诊的操作权限”
	s:(json = "") json = "您不能申请该就诊的操作权限"
	s json = $ZSTRIP(json,"*C")
	w json
}

/// d ##class(EMRservice.Ajax.AuthAppoint).GetCateChapterJason("CG3","9","743","9","29")
ClassMethod GetCateChapterJason(parentId, episodeID, userID, userLoc, workGroupID)
{
	
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))
	
	s result = ..GetInstanceJsonByCategoryID(parentId,episodeID)
	w result
}

ClassMethod IsHasImage(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	q:(docIdList = "") "0"
	
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
	q:(logIdList = "") "0"

	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	q:(imageCount = 0) "0"

	q "1"
}

/// CreateTime:2010-11-09
/// Creator:houj
/// Description:判断目录是否已经启用，即至少指定了一个安全组可以使用该目录
/// Input：	eprCategoryId：病历结构树第一层的id
/// Output: 无
/// Return: 1:已启用，0：未启用
/// Others:
ClassMethod IsEPRCateogryActived(eprCategoryId As %String) As %String
{
	s ssGroupID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_eprCategoryId,0))
	q:(ssGroupID="") "0"
	q "1"
}

/// Desc: 		按CategoryID取实例数据
/// Input: 		AParentId CategoryID
///       		AEpisodeId 就诊号
/// Output:     Json
/// Debug:  	w ##Class(EMRservice.Ajax.AuthAppoint).GetInstanceJsonByCategoryID(3,598,359)
/// liuzhongwan 增加一个入参，加入了互斥模板的判定
ClassMethod GetInstanceJsonByCategoryID(AParentId As %String, AEpisodeId As %String, AUserId As %String, AResultType As %String = "") As %String
{
	s json = ""
	s jsonList = ##Class(%ListOfDataTypes).%New()
	s MutexFlg = 0
	q:(AEpisodeId = "")||(AParentId = "") json
	s docIds = ..GetDocIdsByParent(AParentId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		//s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save")
		//liuzhongwan 获取打印模板的id后判断权限决定是否获取信息串
		s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeId,AUserId)
		s checkpriv = ##Class(EMRservice.DocRestLogic.TempActLogic).CanTempAct(docId, "READ", curPatInfo)
		continue:(checkpriv = 0)
		//
		s docObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		s parentId = docObj.ParentCategoryID
		s parentObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
		s parentMutex = parentObj.IsMutex
		continue:(MutexFlg=1)&&(parentMutex=1)
		s checkInstance = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeId, "",docId)
		s:(parentMutex=1)&&(checkInstance'=0) MutexFlg = 1
		s docJson = ..GetDocJsonsById(docId,AEpisodeId,AResultType)
		continue:(docJson = "")
		d jsonList.Insert(parentMutex_"^"_checkInstance_"^"_docJson)
	}
	s key = ""
	for{
		s value = jsonList.GetNext(.key)
		q:(key = "")
		continue:($p(value,"^",1)=1)&&($p(value,"^",2)=0)&&(MutexFlg=1)
		s docJson = $p(value,"^",3)
		s:(json '= "") json = json_","
		s json = json_docJson
	}
	q json
}

/// Desc:		根据docID是否有实例以及是否Single判断是获取实例的json还是模板的json
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-02-22
/// Input:		DocId和就诊Id
/// Output:		这一DocId下的所有json串
/// Debug	w ##Class(EMRservice.Ajax.AuthAppoint).GetDocJsonsById(51,1)
ClassMethod GetDocJsonsById(ADocId As %String, AEpisodeId As %String, AResultType As %String = "") As %String
{
	s json = ""
	q:(ADocId = "")||(AEpisodeId = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
	q:(objTemplate = "") json
	s Sflag = ""
	s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeId,"",ADocId)
	//第一层判断：是否有实例
	q:(result = "0") ..GetTempJsonByID(ADocId)
	s tempjson = ..DoInstanceJsonByDocID(ADocId,AEpisodeId,"SAVE",AResultType)
	q:(tempjson = "") json
	s json = json_tempjson
	s:(objTemplate.ChartItemType = "Single") Sflag = 1
	//第二层判断：是否SINGLE
	if ('Sflag = 1)
	{
		s tempjson = ..GetTempJsonByID(ADocId)
		q:(tempjson = "") json
		q:(Sflag = 1) //tempJson = $p(tempJson,",",1,5)_","_$p(tempJson,",",7)
		s json = json_","_tempjson
	}
	q json
}

/// Desc:       根据目录展现结构取DocID
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug       d ##Class(EMRservice.Ajax.AuthAppoint).GetDocIdsByParent(3)
ClassMethod GetDocIdsByParent(AParentId As %String) As %String
{
	s docIds = ""
	q:(AParentId = "") docIds
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId	= ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objCatergory = "")
			s result = curCategoryId
			if (objCatergory.CategoryType '= "TempCate")
			{
				s result = ..GetDocIdsByParent(curCategoryId)
				q:(result = "")
			}
			s:(docIds '= "") docIds = docIds_","
            s docIds = docIds_result
		}
	}
	q docIds
}

/// Desc:		根据DocId取实例
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.Ajax.AuthAppoint).DoInstanceJsonByDocID(58,51,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, AResultType As %String = "") As %String
{
	s $zt = "Error"
	s json = ""
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID", AEpisodeId,docId,""))
	q:(ecrecordId = "") json
	
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") json
	s docId = objEcrecod.RealChartItemID
	s chartItemType = objEcrecod.ChartItemType
	s documentType = objEcrecod.DocumentType
	s objEmrTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTemplateCategoryDoc = "") json
	s isLeadframe = objEmrTemplateCategoryDoc.IsLeadframe
	s objEmrTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemplateCategoryDoc.ParentCategoryID)
	q:(objEmrTemplateCategoryChapter = "") json
	s isMutex = objEmrTemplateCategoryChapter.IsMutex
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,AResultType)
 				continue:(tempJson = "")
 				s:(count '= 0) json = json_","
				s json = json_tempJson
				s count = count + 1			
			}
		}
	}
	s json = $ZSTRIP(json,"*C")
	q json
Error
	q ""
}

/// Desc: 取模板数据JSon
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-02-22
/// Input:     ADocID 空模板的DocID，TempCate类型的
/// Output:    模板的信息JSon串
/// Debug:     w ##Class(EMRservice.Ajax.AuthAppoint).GetTempJsonByID(51)
ClassMethod GetTempJsonByID(ADocID As %String) As %String
{
	s json = ""
	q:(ADocID = "") json
	s objTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objTemplate = "") json
	s rowId = ADocID
	s parentId = objTemplate.ParentCategoryID
	s objparentTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
	s text = objparentTemplate.CategoryName
	
	s json = json_"{"
	s json = json_"id:'CT"_rowId_"'"
	s json = json_",text:'"_text_"'"
	s json = json_",leaf:'ture'"
	s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
	s json = json_",cls:'folder'"
	s json = json_",checked:false"
	s json = json_",hasImage:true"
	s json = json_"}"
	q json
}

/// Desc: 取实例数据JSon
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.Ajax.AuthAppoint).GetInstanceJsonByID(1,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, AResultType As %String = "") As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
	q:(objRecord = "") json
	s epsiodeId = objRecord.RealEpisodeID
	s docId = objRecord.RealChartItemID
	s num = objInstance.ListNo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	s chartItemType = objTemplate.ChartItemType
	s documentType = objTemplate.DocumentType
	s categoryId = objChapter.ParentCategoryID
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s title = objInstance.Title
	s tmeplateId = objInstance.RealTemplateID
	s createdate = $zd(objInstance.CreateDate,3)
	s createtime = $zt(objInstance.CreateTime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createdate)_" "_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createtime)_" "_createuserName
	/*
	//重构可重复模板的显示text
	if (objRecord.ChartItemType = "Multiple")
	{
		s text = title_" "_createdate_" "_createtime_" "_createuserName
	}
	else
	{
		s text = title
	}
	
	
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s status = $p(log,"^",2)
	s creator = $tr($p($p($p($p(log,"^",1),"|",2),":",2)," ",1)," ","")
	s notes =  objInstance.Memo //..GetInstanceSummery(rowId,epsiodeId)	
	*/
	
	
	/*
	s json = json_"{"
	s json = json_"""id"":""CC"_rowId_""""
	s json = json_",""text"":"""_text_""""
	s json = json_",leaf:'ture'"
	s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
	s json = json_",cls:'folder'"
	s json = json_",checked:false"
	s json = json_",hasImage:true"
	s json = json_",""attributes"":{" 
	s json = json_"""chartItemType"":"""_chartItemType_"""" 
	s json = json_",""documentType"":"""_documentType_"""" 
	s json = json_",""categoryId"":"""_categoryId_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""templateId"":"""_tmeplateId_""""
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_"""" 
	s json = json_",""happendate"":"""_happendate_""""
	s json = json_",""happentime"":"""_happentime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""summary"":"""_notes_""""
	s json = json_"}"
	s json = json_"}"
	*/
	
	s json = json_"{"
	s json = json_"id:'CC"_rowId_"'"
	s json = json_",text:'"_text_"'"
	s json = json_",leaf:'ture'"
	s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/file.gif'"
	s json = json_",cls:'folder'"
	s json = json_",checked:true"
	s json = json_",hasImage:true"
	s json = json_"}"	
	
	q json
}

ClassMethod GetCateCharpterDescByIDs(ACateCharpterIDs As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	q:(ACateCharpterIDs = "") ResultStream
	
	s CateCharpterDescStr = ""
	s length = $l(ACateCharpterIDs,"^")
	for i=1:1:length
	{
		s InstanceId = $P(ACateCharpterIDs,"^",i)
		// liuzhongwan 这里需要取空模板的名字
		if ($find(InstanceId,"||") = 0)
		{
			s docId = InstanceId
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = "申请模板不存在"
			}
			else{
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				s ccName = objChapter.CategoryName
			}
		}
		else
		{			
		// end liuzhongwan
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
			q:(objInstance = "")
		
			s AEcrecordID = $P(InstanceId,"||",1)
			s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
			q:(objRecord = "")
			s epsiodeId = objRecord.RealEpisodeID
			s docId = objRecord.RealChartItemID
			s num = objInstance.ListNo
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = "申请病历不存在"
			}
			else
			{
				s ccName = objCategoryDoc.CategoryName
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				if (objChapter '= "")
				{	
					//s ccName = objChapter.CategoryName_"."_ccName_"."_objInstance.Title
					s createdate = $zd(objInstance.CreateDate,3)
					s createtime = $zt(objInstance.CreateTime)
					s createuserID = objInstance.CreateUser
					continue:(createuserID="")
					s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
					s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
					//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
					s ccName = objChapter.CategoryName_"."_objInstance.Title_" "_createdate_" "_createtime_" "_createuserName
					/*
					//重构可重复模板的显示text
					if (objRecord.ChartItemType = "Multiple")
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title_" "_createdate_" "_createtime_" "_createuserName
					}
					else
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title
					}
					*/
				}
			}
		}
		/*
		if CateCharpterDescStr = ""
		{	
			s CateCharpterDescStr = ccName
		}
		else
		{
			s CateCharpterDescStr = CateCharpterDescStr_"^"_ccName
		}
		*/
		if (i = 1)
		{
			d ResultStream.Write(..TrimEnterAndWrite(ccName))
		}
		else
		{
			d ResultStream.Write("^")
			d ResultStream.Write(..TrimEnterAndWrite(ccName))
		}
	}
	q ResultStream
}

ClassMethod GetCateCharpterDescByID(ACateCharpterIDs As %String) As %String
{
	s CateCharpterDescStr = ""
	q:(ACateCharpterIDs = "") CateCharpterDescStr
	
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	
	s length = $l(ACateCharpterIDs,"^")
	for i=1:1:length
	{
		s InstanceId = $P(ACateCharpterIDs,"^",i)
		// liuzhongwan 这里需要取空模板的名字
		if ($find(InstanceId,"||") = 0)
		{
			s docId = InstanceId
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","申请模板不存在")
			}
			else{
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				s ccName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objChapter.CategoryName,langid)
			}
		}
		else
		{			
		// end liuzhongwan
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
			q:(objInstance = "")
		
			s AEcrecordID = $P(InstanceId,"||",1)
			s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
			q:(objRecord = "")
			s epsiodeId = objRecord.RealEpisodeID
			s docId = objRecord.RealChartItemID
			s num = objInstance.ListNo
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","申请病历不存在")
			}
			else
			{
				s ccName = objCategoryDoc.CategoryName
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				if (objChapter '= "")
				{	
					//s ccName = objChapter.CategoryName_"."_ccName_"."_objInstance.Title
					s createdate = $zd(objInstance.CreateDate,3)
					s createtime = $zt(objInstance.CreateTime)
					s createuserID = objInstance.CreateUser
					continue:(createuserID="")
					s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
					s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
					s createuserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",createuserName,langid)
					//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
					s tmpCategoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objChapter.CategoryName,langid)
					s tmpTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",objInstance.Title,langid)
					s ccName = tmpCategoryName_"."_tmpTitle_"^"_createdate_" "_createtime_"^"_createuserName
					/*
					//重构可重复模板的显示text
					if (objRecord.ChartItemType = "Multiple")
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title_" "_createdate_" "_createtime_" "_createuserName
					}
					else
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title
					}
					*/
				}
			}
		}
		
		if CateCharpterDescStr = ""
		{	
			s CateCharpterDescStr = ccName
		}
		else
		{
			s CateCharpterDescStr = CateCharpterDescStr_"^"_ccName
		}
	}
	q CateCharpterDescStr
}

ClassMethod GetActionDesc(AEPRAction As %String)
{
	s EPRActionDesc = ""
	s length = $l(AEPRAction,"^")
	for i=1:1:length
	{
		s EPRAction = $P(AEPRAction,"^",i)
        if (EPRAction = "save")
        {
            s retStr = "保存"
        }
        elseif (EPRAction = "print")
        {
            s retStr = "打印"
        }
        elseif (EPRAction = "reference")
        {
            s retStr = "文档对照"
        }
        elseif (EPRAction = "export")
        {
            s retStr = "导出文档"
        }
        elseif (EPRAction = "residentcheck")
        {
            s retStr = "住院医师审核"
        }
        elseif (EPRAction = "chiefcheck")
        {
            s retStr = "主任医师审核"
        }
        elseif (EPRAction = "attendingcheck")
        {
            s retStr = "主治医师审核"
        }
        elseif (EPRAction = "view")
        {
            s retStr = "查看病历"
        }
        elseif (EPRAction = "new")
        {
            s retStr = "创建病历"
        }
        elseif (EPRAction = "copypaste")
        {
            s retStr = "复制粘贴"
        }
        else
        {
	        s retStr = EPRAction
        }
        
        if EPRActionDesc = ""
		{	
			s EPRActionDesc = retStr
		}
		else
		{
			s EPRActionDesc = EPRActionDesc_"^"_retStr
		}
	}
	q EPRActionDesc
}

/// Description:自动审批
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,ARequestCateCharpter-申请范围,ARequestUserID-申请人,
/// 	  ARequestDept-申请人部门,AEPRAction-申请权限类型
/// Input:AppointSpan-授权时长,AppointCateCharpter-授权范围,
/// 	  AppointUserID-授权人,AEPRAciton-授权权限类型(可为空,空的话不进行更新，保持原有记录),
/// 	  AppointType-授权类型(0-个人,1-科室)
/// Output:
/// Return:1-新增操作成功,-1-新增操作失败
/// Others:
/// Debug: w ##class(EMRservice.Ajax.AuthAppoint).AddAutoRequest("230","279||980","359","6","save,print","","","","170","6","29","14400","0")
/// liuzhongwan 入参改名
ClassMethod AddAutoRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRActions As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID, AppointSpan As %Integer, AppointType As %String) As %String
{
	s result = "-1"
	q:(ARequestCateCharpter = "") result
	//当前已经有自动审批得来的权限，不继续申请，返回-1
	s active = ##Class(EMRservice.BL.BLApplyEdit).GetApplyStatus(ARequestCateCharpter,ARequestUserID)
	q:($p(active,"^",1) = "1") result
	
	s appointID = ..AddRequest(AEpisodeID,ARequestCateCharpter,ARequestUserID,ARequestDept,AEPRActions,ARequestReason,ABeforeRequestContent,AAfterRequestContent,APatientID,AUserLocID,ASSGroupID)
	q:((appointID = "0")||(appointID = "-1")) result
	s result = ..AddAppoint(appointID,AppointSpan,ARequestUserID,AppointType)
	s:(result = 1) applyEdit = ##class(EMRservice.BL.BLApplyEdit).AddApplyData(AEpisodeID,ARequestCateCharpter,ARequestUserID,appointID)
	q result
}

/// w ##Class(EMRservice.Ajax.auth.authorize).GetHistoryList("5","10209",1,20,"HISUI")
ClassMethod GetHistoryList(AEpisodeID As %String, ARequestUserID As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AframeType As %String = "")
{
	//数据输出
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	if (AframeType = "HISUI")
	{
		d ResultStream.Write("{""rows"":[")
	}
	else
	{
		d ResultStream.Write("{success:true,Data:[")
	}
	s AppointIDCount = 0
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s startDate = date-60
	s endDate = date
	for RequestDate=endDate:-1:startDate
	{
		s RequestID = ""
		for
		{
			s RequestID = $O(^DHCEMRI.AuthRequestI("IdxReqDtUser",RequestDate," "_ARequestUserID,RequestID),-1)
			q:(RequestID = "")
			
			s AppointID = ""
			for
			{
				s AppointID = $O(^DHCEMRI.AuthAppointI("IdxRequest"," "_RequestID,AppointID))
				q:(AppointID = "")
				
				if (AEpisodeID '= "")
				{
					s AppointObj = ##class(EMRinstance.AuthAppoint).%OpenId(AppointID)
					s EpisodeID = AppointObj.EpisodeID
					continue:(AEpisodeID '= EpisodeID)
				}
				
				s AppointIDCount = AppointIDCount + 1
				
				continue:(AppointIDCount < (AStartRowIndex + 1))
				continue:(AppointIDCount > (AStartRowIndex + ARowCount))
				
				if (AppointIDCount > (AStartRowIndex + 1))
				{
					d ResultStream.Write(",")
				}
				//s parameters = locID_"^"_userID_"^"_requestDateStart_"||"_requestTimeStart_"||"_requestDateEnd_"||"_requestTimeEnd_"||"_appointDateStart_"||"_appointTimeStart_"||"_appointDateEnd_"||"_appointTimeEnd_"^"_canAppointSelect_"^"_treatmentLoc_"^"_requestLoc_"^"_requestUserName_"^"_defaultAppointSpan_"^"_defaultAppointType_"^"_pAAdmType_"^"_pAStatus_"^"_isActive_"^"_appointRequestSpan_"^"_ssgroupID_"^"_RequestRange
				s AppointStream = ..GetHistoryDataByID(AppointID,"^^^^^^^^^^^2^^^")
				d ResultStream.CopyFrom(AppointStream)
			}
		}
	}
	if (AframeType = "HISUI")
	{
        d ResultStream.Write("],""total"":"_AppointIDCount_"}")
	}
	else
	{
		d ResultStream.Write("],TotalCount:'"_AppointIDCount_"'}")
	}
	q ResultStream
}

ClassMethod GetHistoryDataByID(ARowID As %String, AParameters As %String) As %GlobalCharacterStream
{
	s AppointDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") AppointDataStream
	
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(ARowID)
	s EpisodeID = appoint.EpisodeID
	
	//获取患者就诊信息  start
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//患者登记号
	s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	//患者姓名
	s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	//患者病案号
	s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
	//就诊号
	s PaadmNO = $P($G(^PAADM(EpisodeID)),"^",81)
	//就诊日期、就诊时间
	s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
	//主治医生
	s MainDoc =  ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(EpisodeID)
	s MainDoc = $P(MainDoc,"^",3)
	//就诊科室
	s CurDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	s CurDept = $P(CurDept,"^",3)
	s CurDeptNum = $P(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID),"^",1)

	//病人就诊类型 I-住院,O-门诊,E-急诊
	s PAAdmType = $p($g(^PAADM(EpisodeID)),"^",2)   

	//病人出院信息
	s PADischgeDT =##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	s PADischgeDate= $P($G(PADischgeDT),"^",1) //出院日期
	s PADischgeTime = $P($G(PADischgeDT),"^",2) //出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	//获取患者就诊信息  end

	s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""	
	//取用户名
	s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
	s appointUser = ""
	s:(appoint.AppointUserID'="") appointUser = appoint.AppointUserID
	
	//取用户所在科室描述
	s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)
	s appointDeptDesc = ""
	s:(appoint.AppointDept'="") appointDeptDesc=appoint.AppointDept
		
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	if (IsMultilevelAppoint = "Y")
	{
		s:(appoint.AppointUserID '= "") appointUser = appoint.AppointUserID
		s:(appoint.AppointUserID2 '= "") appointUser = appoint.AppointUserID2
		s:(appoint.AppointUserID3 '= "") appointUser = appoint.AppointUserID3
		
		s:(appoint.AppointDept '= "") appointDeptDesc = appoint.AppointDept
		s:(appoint.AppointDept2 '= "") appointDeptDesc = appoint.AppointDept2
		s:(appoint.AppointDept3 '= "") appointDeptDesc = appoint.AppointDept3  
	}
	
	s:(appointUser '="") appointUser = ##class(EMRmeta.PowerUser).GetUserName(appointUser)
	s:(appointDeptDesc '="") appointDeptDesc = $p($g(^CTLOC(appointDeptDesc)),"^",2)	
	

	if (appoint.AppointDate '= "")
	{
		s day = appoint.AppointEndDate - appoint.AppointDate
		s second = appoint.AppointEndTime - appoint.AppointTime
		s appointSpan = (day * 24) + (second / 3600)
		if (+appointSpan < 0) {	s appointSpan = "0"}
		
		s appointType = appoint.AppointType
	}
	else
	{
		s appointSpan = defaultAppointSpan
		s appointType = defaultAppointType
	}

	//增加是否授权 
	s IsAppointed = "unappointed"
	s canAppoint = "0"
	if (appoint.AppointStatus = "F")
	{
		s IsAppointed = "appointed"	
		s canAppoint = "2"
	}
	elseif (appoint.AppointStatus = "R")
	{
		s IsAppointed = "refuse"	
		s canAppoint = "3"	
	}
	else
	{
		s canAppoint = "1"
	}

	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	//获取申请表信息 start
	s requestReason = ""
	s beforeRequestContent = ""
	s afterRequestContent = ""
	s RequestID = appoint.RequestID
	s requestNumber = ""
	if (RequestID '= "")
	{
		s RequestObj = ##class(EMRinstance.AuthRequest).%OpenId(RequestID)
		s requestReason = RequestObj.RequestReason
		s beforeRequestContent = RequestObj.BeforeRequestContent
		s afterRequestContent = RequestObj.AfterRequestContent
		s requestNumber = RequestObj.RequestNumber
	}
	//获取申请表信息 end
	
	
	
	//输出患者信息 start
	d AppointDataStream.Write("{")
	s EpisodeID = ..TrimEnterAndWrite(EpisodeID)
	d AppointDataStream.Write("""EpisodeID"":"""_EpisodeID_"""")
	s PaadmNO = ..TrimEnterAndWrite(PaadmNO)
	d AppointDataStream.Write(",""PaadmNO"":"""_PaadmNO_"""")
	s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
	d AppointDataStream.Write(",""PapmiNo"":"""_PapmiNo_"""")
	s PatName = ..TrimEnterAndWrite(PatName)
	d AppointDataStream.Write(",""Name"":"""_PatName_"""")
	s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
	d AppointDataStream.Write(",""MedicareNo"":"""_MedicareNo_"""")
	s AdmDate = ..TrimEnterAndWrite($ZD(AdmDate,3))
	s:(AdmDate'="") AdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)
	d AppointDataStream.Write(",""AdmDate"":"""_AdmDate_"""")
	s:(AdmTime'="") AdmTime = ..TrimEnterAndWrite($ZT(AdmTime))
	s AdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)
	d AppointDataStream.Write(",""AdmTime"":"""_AdmTime_"""")
	s MainDoc = ..TrimEnterAndWrite(MainDoc)
	d AppointDataStream.Write(",""MainDoc"":"""_MainDoc_"""")
	s CurDept = ..TrimEnterAndWrite(CurDept)
	d AppointDataStream.Write(",""CurDept"":"""_CurDept_"""")
	s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
	d AppointDataStream.Write(",""PAAdmType"":"""_PAAdmType_"""")
	s PAStatus = ..TrimEnterAndWrite(PAStatus)
	d AppointDataStream.Write(",""PAStatus"":"""_PAStatus_"""")
	
	if (PADischgeDate'="")&&(PADischgeTime'="")
	{
		s PADischgeDateTime = ..TrimEnterAndWrite($ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime))
		s PADischgeDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",PADischgeDateTime)
	}
	else {
			s PADischgeDateTime =""
	}
	d AppointDataStream.Write(",""PADischgeDateTime"":"""_PADischgeDateTime_"""")
	//输出患者信息 end
	
	//输出授权表信息  start
	s ID = ..TrimEnterAndWrite(ARowID)
	d AppointDataStream.Write(",""AppointID"":"""_ID_"""")
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	d AppointDataStream.Write(",""RequestUser"":"""_currAuthor_"""")
	//s requestDeptDesc = ..TrimEnterAndWrite($P(requestDeptDesc,"-",2))
	d AppointDataStream.Write(",""RequestDept"":"""_requestDeptDesc_"""")
	s requestDate = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3))
	s:(requestDate'="") requestDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",requestDate)
	d AppointDataStream.Write(",""RequestDate"":"""_requestDate_"""")
	s requestTime = ..TrimEnterAndWrite($ZT(appoint.RequestTime))
	s:(requestTime'="") requestTime =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",requestTime)
	d AppointDataStream.Write(",""RequestTime"":"""_requestTime_"""")
	s requestDateTime = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3)_" "_$ZT(appoint.RequestTime))
	s:($replace(requestDateTime," ","")'="") requestDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",requestDateTime)
	d AppointDataStream.Write(",""RequestDateTime"":"""_requestDateTime_"""")
	s appointDate = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3))
	s:(appointDate'="") appointDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appointDate)
	d AppointDataStream.Write(",""AppointDate"":"""_appointDate_"""")
	s appointTime = ..TrimEnterAndWrite($ZT(appoint.AppointTime))
	s:(appointTime'="") appointTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appointTime)
	d AppointDataStream.Write(",""AppointTime"":"""_appointTime_"""")
	if (appoint.AppointDate'="")&&(appoint.AppointTime'="")
	{
		s appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
		s:($replace(appointDateTime," ","")'="") appointDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointDateTime)
	
	}
	else{
		s appointDateTime = ""
	}
	d AppointDataStream.Write(",""AppointDateTime"":"""_appointDateTime_"""")
	s appointUser = ..TrimEnterAndWrite(appointUser)
	d AppointDataStream.Write(",""AppointUser"":"""_appointUser_"""")
	s appointDeptDesc = ..TrimEnterAndWrite(appointDeptDesc)
	d AppointDataStream.Write(",""AppointDeptDesc"":"""_appointDeptDesc_"""")	
	
	s appointType = ..TrimEnterAndWrite(appointType)
	d AppointDataStream.Write(",""AppointType"":"""_appointType_"""")
	s isActive = ..TrimEnterAndWrite(isActive)
	d AppointDataStream.Write(",""IsActive"":"""_isActive_"""")
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	d AppointDataStream.Write(",""AppointSpan"":"""_appointSpan_"""")
	if (appoint.AppointEndDate'="")&&(appoint.AppointEndTime'="")
	{
		s appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
		s appointEndDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointEndDateTime)
	
	}
	else
	{
		s appointEndDateTime = ""
	}
	d AppointDataStream.Write(",""AppointEndDateTime"":"""_appointEndDateTime_"""")
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	d AppointDataStream.Write(",""IsAppointed"":"""_IsAppointed_"""")
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	d AppointDataStream.Write(",""CanAppoint"":"""_canAppoint_"""")
	s AuthLevel = ..TrimEnterAndWrite(appoint.AuthLevel)
	d AppointDataStream.Write(",""AuthLevel"":"""_AuthLevel_"""")
	s AuthLevelDesc = ..TrimEnterAndWrite(..GetAuthLevelDesc(appoint.AuthLevel))
	d AppointDataStream.Write(",""AuthLevelDesc"":"""_AuthLevelDesc_"""")
	s RefuseReason = ..TrimEnterAndWrite(appoint.RefuseReason)
	d AppointDataStream.Write(",""RefuseReason"":"""_RefuseReason_"""")
	
	//输出申请表信息 start
	s requestReason = ..TrimEnterAndWrite(requestReason)
	d AppointDataStream.Write(",""RequestReason"":"""_requestReason_"""")
	s beforeRequestContent = ..TrimEnterAndWrite(beforeRequestContent)
	d AppointDataStream.Write(",""BeforeRequestContent"":"""_beforeRequestContent_"""")
	s afterRequestContent = ..TrimEnterAndWrite(afterRequestContent)
	d AppointDataStream.Write(",""AfterRequestContent"":"""_afterRequestContent_"""")
	s requestNumber = ..TrimEnterAndWrite(requestNumber)
    d AppointDataStream.Write(",""RequestNumber"":"""_requestNumber_"""")
	//输出申请表信息 end
	//输出申请明细表信息 start
	d AppointDataStream.Write(",""AppointDetailData"":[")
	s DetailDataStream = ..GetDetailDataStreamByID(ARowID,IsAppointed,canAppoint,$p(AParameters,"^",18))
	d AppointDataStream.CopyFrom(DetailDataStream)
	d AppointDataStream.Write("]")
	//输出申请明细表信息 end
	
	d AppointDataStream.Write("}")
	
	d:(DetailDataStream.Size = 0) AppointDataStream.Clear()
	
	q AppointDataStream
}

/// desc:病历授权导出EXCEL 取数据并对数据做处理
/// debug zw ##class(EMRservice.Ajax.auth.authorize).getExcelData("UnAppointed","","95^10209^||||||||||||||^2^^^^168^0^^^^0^29^^2","current",0,10,"loc","","CanAppoint:能否审核#AuthLevelDesc:授权级别#IsActive:是否过期#AppointDetailData:已封存病历#CopyedRecords:病案室已复印病历#Name:姓名#CurDept:就诊科室#MainDoc:主治医师#RequestUser:申请医师#RequestDateTime:申请时间#RequestReason:申请原因#RequestNumber:申请人电话#PAStatus:在院状态#PADischgeDateTime:出院日期#PapmiNo:登记号#MedicareNo:病案号#AdmDate:就诊日期#AdmTime:就诊时间#PAAdmType:就诊类型#PaadmNO:就诊号#RequestDept:申请科室#IsAppointed:授权状态#AppointUser:授权医师#AppointDeptDesc:授权科室#AppointType:授权类型#AppointDateTime:授权/拒绝时间#AppointEndDateTime:授权结束时间#BeforeRequestContent:修改前内容#AfterRequestContent:修改后内容#RefuseReason:拒绝原因#CCDesc:病历名称#CCCreator:病历创建者#DetailStr:申请的操作#DetailStr1:将要授权的操作","","","")
ClassMethod getExcelData(AType As %String, APatientID As %String, AParameters As %String, AExportType As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AIsAll As %String, AAuthLevelType As %String, ACol As %String, APapmiNo As %String, AMedicareNo As %String, APatName As %String)
{
	//s ^tempce("duan","GetExcelData")=AType_","_APatientID_","_AParameters_","_AExportType_","_AStartRowIndex_","_ARowCount_","_AIsAll_","_AAuthLevelType_","_ACol_","_APapmiNo_","_AMedicareNo_","_APatName
	
	if (APatientID = "")
	{
		if (APapmiNo '= "")
		{
			s flag = "1"
			s APatientID = $o(^PAPERi("PAPMI_PatNo",APapmiNo,""))
		}
		
		//add by niucaicai 2015-10-08 按病案号查询
		if (APapmiNo = "")&&(AMedicareNo '= "")
		{
			s flag = "1"
			s APatientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(AMedicareNo)

		}
		
		//add by niucaicai 2016-11-07 按姓名查询
		if ((APapmiNo = "")&&(AMedicareNo = ""))&&(APatName '= "")
		{
			s flag = "1"
			s patientIDByName = ""
			for
			{
				s patientIDByName = $o(^PAPERi("PAPER_PatName",$zcvt($zstrip(APatName,"*p"),"U"),patientIDByName))
				q:(patientIDByName = "")
				
				if (APatientID = "")
				{
					s APatientID = patientIDByName
				}
				else
				{
					s APatientID = APatientID_"^"_patientIDByName
				}
			}
			
		}
	}
	
	s result="0"
	//数据输出
	s key = $i(^CacheTemp)
	k ^TempEMRAppointList(key)
	s flag =..queryData(key,AType,APatientID,AParameters,AStartRowIndex,ARowCount,AIsAll,AAuthLevelType)
	q:flag'=1 result
	
	s dataList=##class(%ListOfDataTypes).%New()
	s titleList=##class(%ListOfDataTypes).%New()
	s colLen=$L(ACol,"#")
	for i=1:1:colLen{
		//列名
		d titleList.Insert($P($P(ACol,"#",i),":",2))
	}
	d dataList.Insert(titleList)
	s AppointID = ""
	s AppointIDCount=0
	for
	{
		s AppointID = $O(^TempEMRAppointList(key,AppointID))
		q:(AppointID = "")
		
		s AppointIDCount = AppointIDCount + 1
		
		continue:((AExportType="current")&(AppointIDCount < (AStartRowIndex + 1)))
		continue:((AExportType="current")&(AppointIDCount > (AStartRowIndex + ARowCount)))
		
		//数据
		s detailList = ..GetAppointExcelDataByID(AppointID,AParameters,AExportType)
		s count = detailList.Count()
		q:count<0 
		//根据列对数据重新排序
		for m=1:1:count{
			s item=detailList.GetAt(m)
			s itemList=##class(%ListOfDataTypes).%New()
			for i=1:1:colLen{
				s data=item.GetAt($P($P(ACol,"#",i),":",1))
				d itemList.Insert(data)
			}
			d dataList.Insert(itemList)
		}
	}
	q dataList
}

/// w ##class(EMRservice.Ajax.auth.authorize).GetAppointExcelDataByID(160,"95^10209^||||||||||||||^2^^^^168^0^^^^0^29^^2^100^52","current")
ClassMethod GetAppointExcelDataByID(ARowID As %String, AParameters As %String, AExportType As %String)
{
	s AppointDataList=##class(%ListOfDataTypes).%New()
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(ARowID)
	s EpisodeID = appoint.EpisodeID
	
	//获取患者就诊信息  start
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//患者登记号
	s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	//患者姓名
	s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	//患者病案号
	s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
	//就诊号
	s PaadmNO = $P($G(^PAADM(EpisodeID)),"^",81)
	//就诊日期、就诊时间
	s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
	s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
	//主治医生
	s MainDoc =  ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(EpisodeID)
	s MainDoc = $P(MainDoc,"^",3)
	//就诊科室
	s CurDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	s CurDept = $P(CurDept,"^",3)
	s CurDeptNum = $P(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID),"^",1)

	//病人就诊类型 I-住院,O-门诊,E-急诊
	s PAAdmType = $p($g(^PAADM(EpisodeID)),"^",2)   

	//病人出院信息
	s PADischgeDT =##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	s PADischgeDate= $P($G(PADischgeDT),"^",1) //出院日期
	s PADischgeTime = $P($G(PADischgeDT),"^",2) //出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	//获取患者就诊信息  end

	s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""	
	//取用户名
	s:(appoint.RequestUserID'="") currAuthor = ##class(EMRmeta.PowerUser).GetUserName(appoint.RequestUserID)
	s:(appoint.AppointUserID'="") appointUser = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID)
	
	//取用户所在科室描述
	s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)

	if (appoint.AppointDate '= "")
	{
		s day = appoint.AppointEndDate - appoint.AppointDate
		s second = appoint.AppointEndTime - appoint.AppointTime
		s appointSpan = (day * 24) + (second / 3600)
		if (+appointSpan < 0) {	s appointSpan = "0"}
		
		s appointType = appoint.AppointType
	}
	else
	{
		s appointSpan = defaultAppointSpan
		s appointType = defaultAppointType
	}
	if (appointType ="0")
	{
		s appointType = "个人"
	}elseif(appointType = "1")
	{
		s appointType = "科室"
	}
	//增加是否授权 
	s IsAppointed = "unappointed"
	s canAppoint = "0"
	if (appoint.AppointStatus = "F")
	{
		s IsAppointed = "appointed"	
		s canAppoint = "2"
	}
	elseif (appoint.AppointStatus = "R")
	{
		s IsAppointed = "refuse"	
		s canAppoint = "3"	
	}
	else
	{
		s userID =$p(AParameters,"^",2)
  		s ssgroupID = $p(AParameters,"^",14)
  		s userLocID = $p(AParameters,"^",1)
		s canAppoint = ..CanAppoint(userID, userLocID, ssgroupID, EpisodeID, PatientID)
	}

	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	//获取申请表信息 start
	s requestReason = ""
	s beforeRequestContent = ""
	s afterRequestContent = ""
	s RequestID = appoint.RequestID
	s requestNumber = ""
	if (RequestID '= "")
	{
		s RequestObj = ##class(EMRinstance.AuthRequest).%OpenId(RequestID)
		s requestReason = RequestObj.RequestReason
		s beforeRequestContent = RequestObj.BeforeRequestContent
		s afterRequestContent = RequestObj.AfterRequestContent
		s requestNumber = RequestObj.RequestNumber
	}
	//获取申请表信息 end
	s mainDataList =##class(%ArrayOfDataTypes).%New()
	d mainDataList.SetAt(PaadmNO,"PaadmNO")
	d mainDataList.SetAt(PapmiNo,"PapmiNo")
	d mainDataList.SetAt(PatName,"Name")
	d mainDataList.SetAt(MedicareNo,"MedicareNo")
	d mainDataList.SetAt($ZD(AdmDate,3),"AdmDate")
	d mainDataList.SetAt($ZT(AdmTime),"AdmTime")
	d mainDataList.SetAt(MainDoc,"MainDoc")
	d mainDataList.SetAt(CurDept,"CurDept")
	d mainDataList.SetAt(PAAdmType,"PAAdmType")
	s PAStatus=$case(PAStatus,"in":"在院",:"出院")
	d mainDataList.SetAt(PAStatus,"PAStatus")
	s PADischgeDateTime = ""
	s:(PADischgeDate'="") PADischgeDateTime = $ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime)
	d mainDataList.SetAt(PADischgeDateTime,"PADischgeDateTime")
	d mainDataList.SetAt(ARowID,"AppointID")
	d mainDataList.SetAt(currAuthor,"RequestUser")
	d mainDataList.SetAt(requestDeptDesc,"RequestDept")
	d mainDataList.SetAt($ZD(appoint.RequestDate,3),"RequestDate")
	d mainDataList.SetAt($ZT(appoint.RequestTime),"RequestTime")
	s requestDateTime = $ZD(appoint.RequestDate,3)_" "_$ZT(appoint.RequestTime)
	d mainDataList.SetAt(requestDateTime,"RequestDateTime")
	s AppointDate=appoint.AppointDate
	s:AppointDate'="" AppointDate=$ZD(AppointDate,3)
	s AppointTime=appoint.AppointTime
	s:AppointTime'="" AppointTime=$ZT(AppointTime)
	d mainDataList.SetAt(AppointDate,"AppointDate")
	d mainDataList.SetAt(AppointTime,"AppointTime")
	s appointDateTime = AppointDate_" "_AppointTime
	d mainDataList.SetAt(appointDateTime,"AppointDateTime")
	d mainDataList.SetAt(appointUser,"AppointUser")
	d mainDataList.SetAt(appointType,"AppointType")
	s isActive=$case(isActive,"0":"过期","1":"授权中","none":"",:isActive)
	d mainDataList.SetAt(isActive,"IsActive")
	d mainDataList.SetAt(appointSpan,"AppointSpan")
	s AppointEndDate=appoint.AppointEndDate
	s AppointEndTime=appoint.AppointEndTime
	s:AppointEndDate'="" AppointEndDate=$ZD(AppointEndDate,3)
	s:AppointEndTime'="" AppointEndTime=$ZT(AppointEndTime)
	s appointEndDateTime = AppointEndDate_" "_AppointEndTime
	d mainDataList.SetAt(appointEndDateTime,"AppointEndDateTime")
	s IsAppointed=$case(IsAppointed,"unappointed":"未授权","appointed":"已授权","refuse":"拒绝",:IsAppointed)
	d mainDataList.SetAt(IsAppointed,"IsAppointed")
	s canAppoint=$case(canAppoint,"0":"无权限","1":"可授权","2":"已授权","3":"拒绝",:canAppoint)
	d mainDataList.SetAt(canAppoint,"CanAppoint")
	d mainDataList.SetAt(appoint.AuthLevel,"AuthLevel")
	d mainDataList.SetAt(..GetAuthLevelDesc(appoint.AuthLevel),"AuthLevelDesc")
	d mainDataList.SetAt(appoint.RefuseReason,"RefuseReason")
	d mainDataList.SetAt(requestReason,"RequestReason")
	d mainDataList.SetAt(beforeRequestContent,"BeforeRequestContent")
	d mainDataList.SetAt(afterRequestContent,"AfterRequestContent")
	d mainDataList.SetAt(requestNumber,"RequestNumber")
	if (AExportType = "current")||(AExportType = "all")
	{
		s DetailList = ..GetDetailExcelDataByID(ARowID,IsAppointed,canAppoint,$p(AParameters,"^",18))
		s count=DetailList.Count()
		for i=1:1:count
		{
			s item = DetailList.GetAt(i)
			//处理DetailStr、DetailStr1
			s tempDetailStr = ..CheckDetailExcelDetailStrData(item.GetAt("DetailStr"),"DetailStr")
			d item.SetAt(tempDetailStr,"DetailStr")

			s tempDetailStr1 = ..CheckDetailExcelDetailStrData(item.GetAt("DetailStr1"),"DetailStr1")
			d item.SetAt(tempDetailStr1,"DetailStr1")
			s key=""
			for{
				s data = mainDataList.GetNext(.key)
				q:key=""
				d item.SetAt(data,key)
			}
			d AppointDataList.Insert(item)
		}
	}
	else
	{
		d AppointDataList.Insert(mainDataList)
	}
	q AppointDataList
}

/// Degub: d ##Class(EMRservice.Ajax.auth.authorize).GetDetailExcelDataByID(174,"unappointed","1")
ClassMethod GetDetailExcelDataByID(ARowID As %String, IsAppointed As %String, CanAppoint As %String, AEmrDocId As %String = "") As %GlobalCharacterStream
{
	s DetailDataStream = ##class(%ListOfDataTypes).%New()
	q:(ARowID = "")||(IsAppointed = "")||(CanAppoint = "") DetailDataStream
	
	s count = 0
	s flag = ""
	s oldDetailID = ""
	s surDetailID = ""
	s oldCateCharpter = ""
	s surCateCharpter = ""
	s oldDetailStr = ""
	s surDetailStr = ""
	s DetailListItem=##class(%ArrayOfDataTypes).%New()
	for
	{
		s surDetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppoint", " "_ARowID,surDetailID))
		
		if (surDetailID '= "")
		{
			if '((AEmrDocId = "")||(AEmrDocId = "0"))		//筛选：选择的病历目录模板
			{
				s tmpDetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s tmpDocId = ..GetEmrDocId(tmpDetailObj.CateCharpter)
				continue:(AEmrDocId '= tmpDocId)
			}
			//遍历到第一个DetailID
			if (oldDetailID = "")
			{
				s oldDetailID = surDetailID
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s surCateCharpter = DetailObj.CateCharpter
				s oldCateCharpter = surCateCharpter
				
				s CCDesc = ""
				s CCDateTime = ""
				s CCCreator = ""
				s CCDescStr = ""
				s CCDescStr = ..GetCateCharpterDescByID(surCateCharpter)
				if (CCDescStr '= "")
				{
					s CCDesc = $p(CCDescStr,"^",1)
					s CCDateTime = $p(CCDescStr,"^",2)
					s CCCreator = $p(CCDescStr,"^",3)
				}
				
				if (count > 0)
				{
					s DetailListItem=##class(%ArrayOfDataTypes).%New()
				}
				
				d DetailListItem.SetAt(surCateCharpter,"CateCharpter")
				d DetailListItem.SetAt(CCDesc,"CCDesc")
				d DetailListItem.SetAt(CCDateTime,"CCDateTime")
				d DetailListItem.SetAt(CCCreator,"CCCreator")
				d DetailListItem.SetAt(IsAppointed,"IsAppointed")
				d DetailListItem.SetAt(CanAppoint,"CanAppoint")
				s count = count + 1
				s surDetailStr = ""
				s outputDetailStr = "true"
				
			}
			//既不是第一个DetailID也不是最后一个DetailID
			else
			{
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(surDetailID)
				s surCateCharpter = DetailObj.CateCharpter
				if (surCateCharpter '= oldCateCharpter)
				{
					s CCDesc = ""
					s CCDateTime = ""
					s CCCreator = ""
					s CCDescStr = ""
					s CCDescStr = ..GetCateCharpterDescByID(surCateCharpter)
					if (CCDescStr '= "")
					{
						s CCDesc = $p(CCDescStr,"^",1)
						s CCDateTime = $p(CCDescStr,"^",2)
						s CCCreator = $p(CCDescStr,"^",3)
					}
					d DetailListItem.SetAt(oldDetailStr,"DetailStr")
					d DetailListItem.SetAt(oldDetailStr,"DetailStr1")
					s ces = DetailListItem.GetAt("CCDesc")
					d DetailDataStream.Insert(DetailListItem)
					if (count > 0)
					{
						s DetailListItem=##class(%ArrayOfDataTypes).%New()
					}
					
					d DetailListItem.SetAt(surCateCharpter,"CateCharpter")
					d DetailListItem.SetAt(CCDesc,"CCDesc")
					d DetailListItem.SetAt(CCDateTime,"CCDateTime")
					d DetailListItem.SetAt(CCCreator,"CCCreator")
					d DetailListItem.SetAt(IsAppointed,"IsAppointed")
					d DetailListItem.SetAt(CanAppoint,"CanAppoint")
					s oldCateCharpter = surCateCharpter
					s count = count + 1
					s surDetailStr = ""
					s outputDetailStr = "false"
				}
			}
		}
		else
		{
			if (oldDetailStr '= "")
			{
				d DetailListItem.SetAt(oldDetailStr,"DetailStr")
				d DetailListItem.SetAt(oldDetailStr,"DetailStr1")
				d DetailDataStream.Insert(DetailListItem)
			}			
			q
		}
			
		s Action = DetailObj.Action
		if (Action = "save")
		{
			s ActionCode = "保存"
		}
		elseif (Action = "print")
		{
			s ActionCode = "打印"
		}
		elseif (Action = "delete")
		{
			s ActionCode = "删除"
		}
		elseif (Action = "view")
		{
			s ActionCode = "浏览"
		}
		elseif (Action = "new")
		{
			s ActionCode = "新建"
		}elseif (Action = "check")
		{
			s ActionCode = "签名"
		}
		s DetailStatus = DetailObj.DetailStatus
		s DetailModify = DetailObj.Modify
		
		s Detail = surDetailID_"^"_ActionCode_"^"_DetailStatus_"^"_DetailModify
		if (surDetailStr = "")
		{
			s surDetailStr = Detail
		}
		else
		{
			s surDetailStr = surDetailStr_"#"_Detail
		}
		
		s oldDetailStr = surDetailStr
	}
	q DetailDataStream
}

/// desc: 导出表格时，申请的操作、授权的操作，对两列数据进行处理
/// creator: 牛才才  2021/4/15
ClassMethod CheckDetailExcelDetailStrData(ADetailStr As %String, Atype As %String) As %String
{
	q:(ADetailStr = "") ADetailStr
	s tempData = ADetailStr
	s tempDataCount = $l(tempData,"#")
 	s hasModify = "false"
 	for j=1:1:tempDataCount
 	{
	 	if ($p($p(tempData,"#",j),"^",4) = 1)
	 	{
		 	s hasModify = "true"
		}
	}
	
	if (hasModify = "true")&&(Atype = "DetailStr1")
	{
		s tempDetailStr1 = ""
		for k=1:1:tempDataCount
	 	{	
		 	if ($p($p(tempData,"#",k),"^",3) = 1)
		 	{
			 	
			 	if (tempDetailStr1 = "")
			 	{
				 	s tempDetailStr1 = $p($p(tempData,"#",k),"^",2)
				}
				else
				{
					s tempDetailStr1 = tempDetailStr1_","_$p($p(tempData,"#",k),"^",2)
				}
			}
		}
	}
	else
	{
		s tempDetailStr1 = ""
		for k=1:1:tempDataCount
	 	{	
		 	if (tempDetailStr1 = "")
		 	{
			 	s tempDetailStr1 = $p($p(tempData,"#",k),"^",2)
			}
			else
			{
				s tempDetailStr1 = tempDetailStr1_","_$p($p(tempData,"#",k),"^",2)
			}
		}
	}
	q tempDetailStr1
}

/// desc: 授权查询数据的代码单独封装成一个方法
/// creator: duan  2020/2/12
/// debug w ##class(EMRservice.Ajax.auth.authorize).queryData(1,"UnAppointed","","95^10209^||||||||||||||^2^^^^168^0^^^^0^29^^2","0","10","loc","")
ClassMethod queryData(key As %String, AType As %String, APatientID As %String = "", AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AIsAll As %String, AAuthLevelType As %String)
{
	//s ^Temp("duan","query")=key_","_AType_","_APatientID_","_AParameters_","_AStartRowIndex_","_ARowCount_","_AIsAll_","_AAuthLevelType
	s RequestDateStart = $p($p(AParameters,"^",3),"||",1)
	if (RequestDateStart'="") s RequestDateStart = $zdh(RequestDateStart,3)
	s RequestDateEnd = $p($p(AParameters,"^",3),"||",3)
	if (RequestDateEnd'="") s RequestDateEnd = $zdh(RequestDateEnd,3)
	s AppointDateStart = $p($p(AParameters,"^",3),"||",5)
	if (AppointDateStart'="") s AppointDateStart = $zdh(AppointDateStart,3)
	s AppointDateEnd = $p($p(AParameters,"^",3),"||",7)
	if (AppointDateEnd'="") s AppointDateEnd = $zdh(AppointDateEnd,3)
	s authLevelTop=$p(AParameters,"^",17)
	//判断日期查询条件是否有成对出现的
	if ((RequestDateStart'="")&&(RequestDateEnd'=""))||((AppointDateStart'="")&&(AppointDateEnd'=""))
	{
		s hasDateConditions = "1"
	}
	else
	{
		s hasDateConditions = "0"
	}
	
	s totalCount = 0
	
	//取当前系统日期时间
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	if (AppointDateStart = "")&&(AppointDateEnd = "")
	{
		s AppointDateEnd = date
		s AppointDateStart = date-6
	}
	
	if (RequestDateStart = "")&&(RequestDateEnd = "")
	{
		s RequestDateEnd = date
		s RequestDateStart = date-6
	}
	
	//N:未授权; R:拒绝; F:已授权
	if (AType = "Appointed")
	{	
		if (APatientID '= "")&&(hasDateConditions = "0")
		{
			s PatIDLength = $l(APatientID,"^")
			for i=1:1:PatIDLength
			{
				s CurPatientID = $P(APatientID,"^",i)
				s CurPaAdmType = ""
				for
				{
					s CurPaAdmType = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType))
					q:(CurPaAdmType = "")
				
					s CurEpisodeID = ""
					for {
						s CurEpisodeID = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType, CurEpisodeID))
						q:(CurEpisodeID="")
					
						s RowID = ""
						if ($zcvt(authLevelTop,"U") = "A")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode1"," F"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "B")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode2"," F"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "C")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode3"," F"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						else
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode"," F"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
							}
						}
					}
				}
			}
		}
		else
		{
		//对有要求的医院，已授权的按照申请时间排序
		s HospitalName = ##Class(EMRservice.BOSysOption).GetValueByName("HospitalName")
		
		if (HospitalName = "WLSRMYY")
		{
			s RequestDate = ""
			s RequestDateStart = ""
			if (RequestDateEnd'="") s RequestDate = RequestDateEnd + 1
			for {
				s RequestDate = $o(^DHCEMRI.AuthAppointI("IdxRequestDt"," F", RequestDate),-1)
				q:(RequestDate="")
				q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
				s RowID = ""
				for {
					s RowID = $o(^DHCEMRI.AuthAppointI("IdxRequestDt"," F", RequestDate, RowID),-1)
					q:(RowID = "")
					s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(RowID)
					q:(appoint.AppointDate="")  d appoint.%Close()
					q:((AppointDateEnd'="")&&(appoint.AppointDate>AppointDateEnd))  d appoint.%Close()
					q:((AppointDateStart'="")&&(appoint.AppointDate<AppointDateStart))  d appoint.%Close()
					d appoint.%Close()
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
				}
			}
		}
		else
		{
			for i=AppointDateEnd:-1:AppointDateStart
			{
				s RowID = ""
				if ($zcvt(authLevelTop,"U") = "A")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt1"," F", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "B")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt2"," F", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "C")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt3"," F", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				else
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt"," F", i, RowID),-1)
						q:(RowID = "")
							s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
						}
					}
				}
			}
		}
	}
	elseif (AType = "UnAppointed")
	{
		if (APatientID '= "")&&(hasDateConditions = "0")
		{
			s PatIDLength = $l(APatientID,"^")
			for i=1:1:PatIDLength
			{
				s CurPatientID = $P(APatientID,"^",i)
				s CurPaAdmType = ""
				for
				{
					s CurPaAdmType = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType))
					q:(CurPaAdmType = "")
				
					s CurEpisodeID = ""
					for {
						s CurEpisodeID = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType, CurEpisodeID))
						q:(CurEpisodeID="")
					
						s RowID = ""
						if ($zcvt(authLevelTop,"U") = "A")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode1"," N"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "B")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode2"," N"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "C")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode3"," N"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						else
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode"," N"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
							}
						}
					}
				}
			}
		}
		else
		{
			for i=RequestDateEnd:-1:RequestDateStart
			{
				s RowID = ""
				if ($zcvt(authLevelTop,"U") = "A")
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxRequestDt1"," N", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "B")
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxRequestDt2"," N", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "C")
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxRequestDt3"," N", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				else
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxRequestDt"," N", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
					}
				}
			}
		}
	}
	elseif (AType = "Refuse")
	{	
		if (APatientID '= "")&&(hasDateConditions = "0")
		{
			s PatIDLength = $l(APatientID,"^")
			for i=1:1:PatIDLength
			{
				s CurPatientID = $P(APatientID,"^",i)
				s CurPaAdmType = ""
				for
				{
					s CurPaAdmType = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType))
					q:(CurPaAdmType = "")
				
					s CurEpisodeID = ""
					for {
						s CurEpisodeID = $o(^PAPERdr(CurPatientID, "ADM", CurPaAdmType, CurEpisodeID))
						q:(CurEpisodeID="")
					
						s RowID = ""
						if ($zcvt(authLevelTop,"U") = "A")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode1"," R"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "B")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode2"," R"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						elseif ($zcvt(authLevelTop,"U") = "C")
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode3"," R"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
							}
						}
						else
						{
							for {
								s RowID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode"," R"," "_CurEpisodeID, RowID),-1)
								q:(RowID = "")
								s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
							}
						}
					}
				}
			}
		}
		else
		{
			for i=AppointDateEnd:-1:AppointDateStart
			{
				s RowID = ""
				if ($zcvt(authLevelTop,"U") = "A")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt1"," R", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "B")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt2"," R", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				elseif ($zcvt(authLevelTop,"U") = "C")
				{
					for 
					{
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt3"," R", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,"")
					}
				}
				else
				{
					for {
						s RowID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt"," R", i, RowID),-1)
						q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
					}
				}
			}
		}
	}
	
	q "1"
}

/// 入参：  AEpisodeID：就诊ID, AInstanceID:实例病历ID(传空则回收该患者所有病历权限)
/// 入参：  AAction：回收操作类型代码，以^分隔，关键字左右都有上尖号。(例：^save^)
/// 返回值：-1:收回权限失败; 0:入参不能为空; 1:收回权限成功;
/// w ##class(EMRservice.Ajax.auth.authorize).withdrawByAction("4","","^save^delete^new^check^") 
ClassMethod withdrawByAction(AEpisodeID As %String, AInstanceID As %String, AAction As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AAction = "") ret
	TStart
	s AppointID = ""
	for 
	{
		s AppointID = $O(^DHCEMRI.AuthAppointI("IdxEpisode"," "_AEpisodeID,AppointID))
		q:(AppointID = "")
		//检索出当前生效授权
		s flag = ..CheckAppointIsActive(AppointID)
		continue:(flag="0")

		s DetailID = ""
		for
		{
			s DetailID = $O(^DHCEMRI.AuthAppointDetailI("IdxAppoint"," "_AppointID,DetailID))
			q:(DetailID = "")
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			continue:(DetailObj.DetailStatus '= "1")
			s tmpAction = "^"_DetailObj.Action_"^"
			continue:(AAction '[ tmpAction)
			s DetailObj.DetailStatus = "-1"
			s Detailsc = DetailObj.%Save()
			if ('$$$ISOK(Detailsc))
			{
				s ret = "-1"
			}
			d DetailObj.%Close()
		}
	}
	if (ret = "-1")
	{
		TRollback
		s ret = "-1"
		q ret
	}
	TCommit
	s ret = "1"
	q ret
}

/// Creator： 		liuyunfei
/// CreatDate： 	2023-02-02
/// Description:： 	获取模板目录
/// Input： 		
/// Output： 		json Stream
/// Return： 		json类型的流数据,按照UI-Tree的格式拼成的json流
/// Others： 		
/// debug:			w ##Class(EMRservice.Ajax.auth.authorize).GetTemplateTreeJson(1)
ClassMethod GetTemplateTreeJson(AParentId As %String) As %GlobalCharacterStream
{
	s ret = ##Class(%GlobalCharacterStream).%New()
	q:(AParentId = "") ret
	s treeState = "closed"
	s rowId = "",conut = 0
	for
	{
		s rowId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_AParentId,rowId))
		q:(rowId = "")
		s obj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
		if (obj.CategoryType = "CategoryChapter")
		{
			s json = ..GetTemplateTreeJson(rowId)
			d:(conut > 0)&&(json.Size > 0) ret.Write(",") 
			d ret.CopyFrom(json)
		}
		else
		{
			s json = ..GetTemplateTreeJson(rowId)
			continue:(obj.CategoryType = "Category")&&(json.Size = 0)
			d:(ret.Size > 0) ret.Write(",")
			d ret.Write("{")
			d ret.Write("""id"":"""_rowId_"""")
			d ret.Write(",""text"":"""_##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",obj.CategoryName)_"""")
			d:(AParentId = "0") ret.Write(",""state"":"""_treeState_"""")
			d ret.Write(",""children"":[")
			d ret.CopyFrom(json)
			d ret.Write("]")
			d ret.Write("}")
		}
		s conut = conut + 1
	}
	q ret
}

/// Creator： 		liuyunfei
/// CreatDate： 	2023-02-02
/// Description:： 	获取DocID
/// Input： 		ATmpId: docId/instanceID
/// Output： 		docId
/// Return： 		
/// Others： 		
/// debug:			w ##Class(EMRservice.Ajax.auth.authorize).GetEmrDocId("2||1^58")
ClassMethod GetEmrDocId(ATmpId As %String) As %String
{
	s ret = ""
	for i=1:1:$l(ATmpId,"^")
	{
		s tmpId = $p(ATmpId,"^",i)
		if ($find(tmpId,"||") = 0)
		{
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(tmpId)
			if (objCategoryDoc '= "")
			{
				s:(ret '= "") ret = ret_"^"
				s ret = ret_tmpId
			}
		}
		else
		{
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpId)
			q:(objInstance = "")
		
			s AEcrecordID = $P(tmpId,"||",1)
			s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
			q:(objRecord = "")
			s:(ret '= "") ret = ret_"^"
			s ret = ret_objRecord.ChartItemID.%Id()
		}
	}
	q ret
}

}
