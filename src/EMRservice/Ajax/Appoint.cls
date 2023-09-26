/// creat by niucaicai 2015-8-7
Class EMRservice.Ajax.Appoint Extends %CSP.Page
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
	//申请号码
	s requestNumber = $g(%request.Data("RequestNumber",1),"")
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
	
	s canAppointSelect = $g(%request.Data("CanAppointSelect",1),"")
	s isActive = $g(%request.Data("IsActive",1),"")
	s treatmentLoc = $g(%request.Data("TreatmentLoc",1),"")
	s requestLoc = $g(%request.Data("RequestLoc",1),"")
	s requestUserName = $g(%request.Data("RequestUserName",1),"")
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	s ssgroupID =$g(%session.Data("LOGON.GROUPID"))

	s onlyCurrentDept = $g(%request.Data("OnlyCurrentDept",1),"")
	s eprIntegratedAuthorization = $g(%request.Data("EPRIntegratedAuthorization",1),"")
	
	s pAAdmType = $g(%request.Data("PAAdmType",1),"")
	s pAStatus = $g(%request.Data("PAStatus",1),"")
	
	s start = $g(%request.Data("start",1),0)
	s limit = $g(%request.Data("limit",1),20)
	
	s defaultAppointSpan = $g(%request.Data("DefaultAppointSpan",1),"24")
	s defaultAppointType = $g(%request.Data("DefaultAppointType",1),"0")
	s appointRequestSpan = $g(%request.Data("AppointRequestSpan",1),"0")
	
	//add by niucaicai 2013-03-14 按登记号查询
	s PapmiNo = $g(%request.Data("PapmiNo",1),"")
	if (PapmiNo '= "")
	{
		s patientID = $o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	}
	
	//add by niucaicai 2015-10-08 按病案号查询
	s MedicareNo = $g(%request.Data("MedicareNo",1),"")
	if (PapmiNo = "")&&(MedicareNo '= "")
	{
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(MedicareNo)
	}
	
	//add by niucaicai 2016-11-07 按姓名查询
	s PatName = $g(%request.Data("PatName",1),"")
	if ((PapmiNo = "")&&(MedicareNo = ""))&&(PatName '= "")
	{
		s patientIDByName = ""
		for
		{
			s patientIDByName = $o(^PAPERi("PAPER_PatName",$zcvt(PatName,"U"),patientIDByName))
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
	
	s parameters = locID_"^"_userID_"^"_requestDateStart_"||"_requestTimeStart_"||"_requestDateEnd_"||"_requestTimeEnd_"||"_appointDateStart_"||"_appointTimeStart_"||"_appointDateEnd_"||"_appointTimeEnd_"^"_canAppointSelect_"^"_treatmentLoc_"^"_requestLoc_"^"_requestUserName_"^"_defaultAppointSpan_"^"_defaultAppointType_"^"_pAAdmType_"^"_pAStatus_"^"_isActive_"^"_appointRequestSpan_"^"_ssgroupID_"^"_RequestRange
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parameters") = PapmiNo_"#"_parameters_"#"_start_"#"_limit_"#"_eprIntegratedAuthorization
	//---------------------------------------------------------------
	
	if (patientID = "")
	{
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID) //201868
	}
	
	If (action="request")
	{
		//w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent)
		w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,locID,ssgroupID,requestNumber)
	}
	//add by yang 2012-04-13
	ElseIf (action="updatefs"){
		w ..UpdateFS(ID,appointCateCharpter)
	}
	ElseIf (action="appoint")
	{
		w ..AddAppoint(ID,+appointSpan,appointCateCharpter,appointUserID,EPRAction,appointType)
	}
	ElseIf (action="refuse")
	{
		s RefuseReason = $g(%request.Data("RefuseReason",1),"")
		w ..RefuseAppoint(ID,appointUserID,RefuseReason)
	}
	ElseIf (action="withdraw")
	{
		w ..WithdrawAppoint(ID)
	}
	ElseIf (action="getunappointed")
	{
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
		w ..AddAutoRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,locID,ssgroupID,"60","0")
	}
	ElseIf (action="getHistory")
	{
		s HistoryStream = ..GetHistoryList(episodeID,requestUserID,start,limit)
		//输出流数据
		while (HistoryStream.AtEnd = 0)
		{
			w $ZSTRIP(HistoryStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	
	Quit $$$OK
}

/// Description:新增申请
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,ARequestCateCharpter-申请范围,ARequestUserID-申请人,
/// 	  ARequestDept-申请人部门,AEPRAction-申请权限类型
/// Output:
/// Return:1-新增操作成功,-1-新增操作失败
/// Others:
/// Debug: w ##class(EMRservice.Ajax.Appoint).AddRequest("9","2||4","743","9","save","test2","","","41","9","29")
/// liuzhongwan 入参改名
ClassMethod AddRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRActions As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID, ARequestNumber As %String = "") As %String
{
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parametersreason1") = ARequestReason_"^"_ABeforeRequestContent_"^"_AAfterRequestContent
	q:(ARequestCateCharpter="") "-1"
	
	s flag = 1
	s splitChapter = ..SplitRequestChapter(APatientID, AEpisodeID, ARequestCateCharpter, ARequestUserID, AUserLocID, ASSGroupID)
	s newflag = 0
	if ((AEPRActions["new")&&'(AEPRActions["save")){
		s newflag = 1
		s AEPRActions = AEPRActions_",save"
	}
	for i = 1:1:4
	{
		s chapter = $P(splitChapter, "#", i)
		s level = (i * 100)
		continue:(chapter = "")
		s tempchapter = ""
		for j=1:1:$l(chapter,"^"){
			if '($p(chapter,"^",j)["||"){
				s:(tempchapter '= "") tempchapter = tempchapter_"^"
				s:'(tempchapter["||") tempchapter = tempchapter_$p(chapter,"^",j)
			}
		}
		//liuzhongwan 拆分AEPRActions
		s ActionCount = $l(AEPRActions, ",")
		for j = 1:1:ActionCount{
			s action = $p(AEPRActions,",",j)
			continue:(action="new")&&(tempchapter="")
			continue:(action="save")&&(newflag=1)&&(tempchapter="")
			s appoint = ##class(EMRinstance.EMRActionAppoint).%New()
			if (appoint="")
			{
				s flag = "-1"
				q
			}
		
			s appoint.EpisodeID = AEpisodeID
			s appoint.RequestCateCharpter = chapter
			s:(action="new")||((action="save")&&(newflag = 1)) appoint.RequestCateCharpter = tempchapter
			s appoint.RequestUserID = ARequestUserID
			s appoint.RequestDept = ARequestDept
			s appoint.AppointStatus="N"
			s appoint.RequestReason=ARequestReason
			s appoint.BeforeRequestContent=ABeforeRequestContent
			s appoint.AfterRequestContent=AAfterRequestContent
			s appoint.AuthLevel = level
			s appoint.RequestNumber = ARequestNumber
		
			//取当前系统时间
			s date = $p($H,",",1)
			s time = $p($H,",",2)
			s appoint.RequestDate = date
			s appoint.RequestTime = time
			s appoint.EPRAction = action
		
			s sc = appoint.%Save()
			d appoint.%Close()
		
			if ('$$$ISOK(sc))
			{
				s flag = "-1"
				q
			}
		}
		//end liuzhongwan
	}
	q flag
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:更新授权范围
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-ID
/// 	  AppointCateCharpter-授权范围
/// Output:
/// Return:1-操作成功,-1-操作失败
/// Others:
ClassMethod UpdateFS(AID As %String, AppointCateCharpter As %String) As %String
{
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"
	
	s appoint.AppointCateCharpter = AppointCateCharpter
	
	s sc = appoint.%Save()
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
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
/// Debug: w ##class(EMRservice.Ajax.Appoint).AddAppoint("2",86400,"12||1","601","save","0")
ClassMethod AddAppoint(AID As %String, AppointSpan As %Integer, AppointCateCharpter As %String, AppointUserID As %String, AEPRAciton As %String, AppointType As %String) As %String
{
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointDate = date
	s appoint.AppointTime = time
	
	s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
	s appoint.AppointEndDate = $p(EndDateTime,",",1)
	s appoint.AppointEndTime = $p(EndDateTime,",",2)
	s appoint.AppointCateCharpter = AppointCateCharpter
	s appoint.AppointUserID = AppointUserID
	s appoint.AppointStatus = "F"
	if (AEPRAciton'="")
	{
		s appoint.EPRAction = AEPRAciton
	}
	s appoint.AppointType = AppointType
	
	s sc = appoint.%Save()
	if ($$$ISOK(sc))
	{
		s EpisodeID = appoint.EpisodeID
		s RequestUserID = appoint.RequestUserID
		s EPRAction = appoint.EPRAction
		
		//授权成功后发送消息给申请医生 add by niucaicai 2016-11-10
		s SetAppointMsgToDoc = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetAppointMsgToDoc")
		if (SetAppointMsgToDoc = "Y")
		{
			s EPRActionDesc = ..GetActionDesc(appoint.EPRAction)
			s EPRActionDesc = $tr(EPRActionDesc,"^","、")
		
			//s AppointCCDesc = ..GetCateCharpterDescByIDs(appoint.AppointCateCharpter)
			//s AppointCCDesc = $tr(AppointCCDesc,"^","和")
		
			s MessageBody = "已同意 "_EPRActionDesc_" 操作的申请！"
			//d ##class(websys.DHCMessageInterface).Send(MessageBody,"1044",AppointUserID,EpisodeID,"",RequestUserID,"")
			s linkParam = "EpisodeId="_EpisodeID
			s OtherInfoJson="{""link"":"""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_AID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1068",AppointUserID,EpisodeID,"",RequestUserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
		}
		
		//如果病历已经提交,需要在授权时间结束后自动提交病历
		if (EPRAction = "save")
		{
			s MedRecordStatus = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(appoint.EpisodeID)
			//s MedRecordStatus = "0^1^0"
			s Cmmited = $p(MedRecordStatus,"^",2)
			if (Cmmited = 1)
			{
				d ##Class(DHCEPRFS.BI.BIToEMR).ApplyAuthorization(appoint.EpisodeID,appoint.RequestUserID,appoint.AppointUserID,appoint.AppointDate,appoint.AppointTime,appoint.AppointEndDate,appoint.AppointEndTime)
			}
		}
	}
	
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod RefuseAppoint(AID As %String, AAppointUserID As %String, ARefuseReason As %String = "") As %String
{
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"	
	
	//设定状态为拒绝
	s appoint.AppointStatus = "R"
	//写入拒绝时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointDate = date
	s appoint.AppointTime = time
	s appoint.AppointUserID = AAppointUserID
	s appoint.RefuseReason = ARefuseReason	
	
	s sc = appoint.%Save()
	//拒绝成功后发送消息给申请医生 add by niucaicai 2016-11-10
	s SetAppointMsgToDoc = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetAppointMsgToDoc")
	if ($$$ISOK(sc))&&(SetAppointMsgToDoc = "Y")
	{
		s EpisodeID = appoint.EpisodeID
		s RequestUserID = appoint.RequestUserID
		s RequestCateCharpter = appoint.RequestCateCharpter
		s EPRAction = appoint.EPRAction
		
		s EPRActionDesc = ..GetActionDesc(EPRAction)
		s EPRActionDesc = $tr(EPRActionDesc,"^","、")
		
		//s RequestCCDesc = ..GetCateCharpterDescByIDs(RequestCateCharpter)
		//s RequestCCDesc = $tr(RequestCCDesc,"^","和")
		
		if (ARefuseReason = "")
		{
			s RefuseReason = "未填！"
		}
		else
		{
			s RefuseReason = ARefuseReason
		}
		s MessageBody = "已拒绝 "_EPRActionDesc_" 操作的申请！ 原因："_RefuseReason
		//d ##class(websys.DHCMessageInterface).Send(MessageBody,"1045",AAppointUserID,EpisodeID,"",RequestUserID,"")
		s linkParam = "EpisodeId="_EpisodeID
		s OtherInfoJson="{""link"":"""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_AID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
		d ##class(websys.DHCMessageInterface).Send(MessageBody,"1069",AAppointUserID,EpisodeID,"",RequestUserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
	}
	
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod WithdrawAppoint(AID As %String) As %String
{
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"	
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointEndDate = date
	s appoint.AppointEndTime = time	
	
	s sc = appoint.%Save()
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
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
		s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""
		
		s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
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
		s:(appoint.AppointUserID'="") appointUser = ##class(EMRmeta.PowerUser).GetUserName(appoint.AppointUserID)
		
		//取用户所在科室描述
		s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)
			
		//指定返回值
		if (returnJson '= "")
		{
			s returnJson = returnJson_","
		}
		s returnJson = returnJson_"{ID:'"_RowID_"'"
		s returnJson = returnJson_",EpisodeID:'"_appoint.EpisodeID_"'"
		s returnJson = returnJson_",RequestCateCharpter:'"_appoint.RequestCateCharpter_"'"
		s returnJson = returnJson_",RequestCCDesc:'"_RequestCCDes_"'"
		s returnJson = returnJson_",RequestUser:'"_currAuthor_"'"
		s returnJson = returnJson_",RequestDept:'"_requestDeptDesc_"'"
		s HISFormatRequestDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$ZD(appoint.RequestDate,3))
		s returnJson = returnJson_",RequestDate:'"_HISFormatRequestDate_"'"
		s HISFormatRequestTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$ZT(appoint.RequestTime))
		s returnJson = returnJson_",RequestTime:'"_HISFormatRequestTime_"'"
		s returnJson = returnJson_",EPRAction:'"_appoint.EPRAction_"'"
		s HISFormatAppointDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$ZD(appoint.AppointDate,3))
		s returnJson = returnJson_",AppointDate:'"_HISFormatAppointDate_"'"
		s HISFormatAppointTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$ZD(appoint.AppointTime,3))
		s returnJson = returnJson_",AppointTime:'"_HISFormatAppointTime_"'"
		s returnJson = returnJson_",AppointUser:'"_appointUser_"'"
		s returnJson = returnJson_",AppointType:'"_appoint.AppointType_"'"
		s returnJson = returnJson_",AppointSpan:'"_appointSpan_"'"
		s returnJson = returnJson_",AppointCateCharpter:'"_appoint.AppointCateCharpter_"'"
		s returnJson = returnJson_",Name:'"_name_"'"
		s HISFormatAdmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$ZD(admDate,3))
		s returnJson = returnJson_",AdmDate:'"_HISFormatAdmDate_"'"
		s HISFormatAdmTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$ZT(admTime))
		s returnJson = returnJson_",AdmTime:'"_HISFormatAdmTime_"'"
		s returnJson = returnJson_",MainDoc:'"_mainDoc_"'"
		s returnJson = returnJson_",RequestReason:'"_..TrimEnterAndWrite(appoint.RequestReason)_"'"
		s returnJson = returnJson_",BeforeRequestContent:'"_appoint.BeforeRequestContent_"'"
		s returnJson = returnJson_",AfterRequestContent:'"_appoint.AfterRequestContent_"'"
		s returnJson = returnJson_",CurDept:'"_curDept_"'"	
		s returnJson = returnJson_",AuthLevel:'"_appoint.AuthLevel_"'"	
		s returnJson = returnJson_",AuthLevel:'"_..GetAuthLevelDesc(appoint.AuthLevel)_"'}"
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
/// Debug:	d ##Class(EMRservice.Ajax.Appoint).GetLocAppointList("UnAppointed","","10^359^||||||||||||||^2^^^^24^0^^^^0^29^",0,20,"all","")
/// Debug:	d ##Class(EMRservice.Ajax.Appoint).GetLocAppointList("Refuse","","10^359^||||||||2016-11-01||||2016-11-24||^2^^^^24^0^^^^0^29^",0,20,"all","")
ClassMethod GetLocAppointList(AType As %String, APatientID As %String, AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AIsAll As %String, AAuthLevelType As %String) As %GlobalCharacterStream
{
	//s ^ncctemp("0") = AType_"^"_APatientID_"^"_AParameters_"^"_AStartRowIndex_"^"_ARowCount_"^"_AIsAll_"^"_AAuthLevelType
	s key = $i(^CacheTemp)
	k ^TempEMRAppointList(key)
	
	s RequestDateStart = $p($p(AParameters,"^",3),"||",1)
	if (RequestDateStart'="") s RequestDateStart = $zdh(RequestDateStart,3)
	s RequestDateEnd = $p($p(AParameters,"^",3),"||",3)
	if (RequestDateEnd'="") s RequestDateEnd = $zdh(RequestDateEnd,3)
	s AppointDateStart = $p($p(AParameters,"^",3),"||",5)
	if (AppointDateStart'="") s AppointDateStart = $zdh(AppointDateStart,3)
	s AppointDateEnd = $p($p(AParameters,"^",3),"||",7)
	if (AppointDateEnd'="") s AppointDateEnd = $zdh(AppointDateEnd,3)
	//判断日期查询条件是否有成对出现的
	if ((RequestDateStart'="")&&(RequestDateEnd'=""))
	{
		s hasRequestDateConditions = "1"
	}
	else
	{
		s hasRequestDateConditions = "0"
	}
	
	if ((AppointDateStart'="")&&(AppointDateEnd'=""))
	{
		s hasAppointDateConditions = "1"
	}
	else
	{
		s hasAppointDateConditions = "0"
	}
	
	if (hasRequestDateConditions||hasAppointDateConditions)
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
						for {
							s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxStatusEpisode"," F"," "_CurEpisodeID, RowID),-1)
							q:(RowID = "")
							s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
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
				s RequestDate = $o(^DHCEMRI.EMRActionAppointI("IdxRequestDt"," F", RequestDate),-1)
				q:(RequestDate="")
				q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
				s RowID = ""
				for {
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxRequestDt"," F", RequestDate, RowID),-1)
					q:(RowID = "")
					s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
					q:(appoint.AppointDate="")  d appoint.%Close()
					q:((AppointDateEnd'="")&&(appoint.AppointDate>AppointDateEnd))  d appoint.%Close()
					q:((AppointDateStart'="")&&(appoint.AppointDate<AppointDateStart))  d appoint.%Close()
					d appoint.%Close()
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
				}
			}
		}
		elseif (hasRequestDateConditions = "1")
		{
			for x=RequestDateEnd:-1:RequestDateStart
			{
				s RowID = ""
				for
				{
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxRequestDt"," F", RequestDate, RowID),-1)
					q:(RowID = "")
					s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
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
				for {
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxAppointDt"," F", i, RowID),-1)
					q:(RowID = "")
						s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
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
						for {
							s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxStatusEpisode"," N"," "_CurEpisodeID, RowID),-1)
							q:(RowID = "")
							s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
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
				for {
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxRequestDt"," N", i, RowID),-1)
					q:(RowID = "")
					s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
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
						for {
							s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxStatusEpisode"," R"," "_CurEpisodeID, RowID),-1)
							q:(RowID = "")
							s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,CurPatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
						}
					}
				}
			}
		}
		elseif (hasRequestDateConditions = "1")
		{
			for x=RequestDateEnd:-1:RequestDateStart
			{
				s RowID = ""
				for
				{
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxRequestDt"," R", RequestDate, RowID),-1)
					q:(RowID = "")
					s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
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
				for {
					s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxAppointDt"," R", i, RowID),-1)
					q:(RowID = "")
					s totalCount = totalCount + ..GetLocAppointListByEID(key,RowID,APatientID,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
				}
			}
		}
	}
	//数据输出
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("{success:true,Data:[")
	s EpisodeIDCount = 0
	s EpisodeID = ""
	for
	{
		s EpisodeID = $O(^TempEMRAppointList(key,EpisodeID))
		q:(EpisodeID = "")
		
		s EpisodeIDCount = EpisodeIDCount + 1
		
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
		//s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
		//s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
		s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
		s AdmDate = $P(AdmDateTime,"^",1)
		s AdmTime = $P(AdmDateTime,"^",2)
		
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
		//输出患者信息 start
		continue:(EpisodeIDCount < (AStartRowIndex + 1))
		continue:(EpisodeIDCount > (AStartRowIndex + ARowCount))
			
		if (EpisodeIDCount > (AStartRowIndex + 1))
		{
			d ResultStream.Write(",")
		}
		d ResultStream.Write("{")
		s EpisodeID = ..TrimEnterAndWrite(EpisodeID)
		d ResultStream.Write("EpisodeID:'"_EpisodeID_"'")
		s PaadmNO = ..TrimEnterAndWrite(PaadmNO)
		d ResultStream.Write(",PaadmNO:'"_PaadmNO_"'")
		s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
		d ResultStream.Write(",PapmiNo:'"_PapmiNo_"'")
		s PatName = ..TrimEnterAndWrite(PatName)
		d ResultStream.Write(",Name:'"_PatName_"'")
		s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
		d ResultStream.Write(",MedicareNo:'"_MedicareNo_"'")
		s AdmDate = ..TrimEnterAndWrite($ZD(AdmDate,3))
		s HISDateFormate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)	
		d ResultStream.Write(",AdmDate:'"_HISDateFormate_"'")
		s AdmTime = ..TrimEnterAndWrite($ZT(AdmTime))
		s HISTimeFormate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)
		d ResultStream.Write(",AdmTime:'"_HISTimeFormate_"'")
		s MainDoc = ..TrimEnterAndWrite(MainDoc)
		d ResultStream.Write(",MainDoc:'"_MainDoc_"'")
		s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
		d ResultStream.Write(",PAAdmType:'"_PAAdmType_"'")
		s PAStatus = ..TrimEnterAndWrite(PAStatus)
		d ResultStream.Write(",PAStatus:'"_PAStatus_"'")
		s:(PADischgeDate'="")&&(PADischgeTime'="") PADischgeDateTime = ..TrimEnterAndWrite($ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime))
		s HISDateTimeFormate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",PADischgeDateTime)
		d ResultStream.Write(",PADischgeDateTime:'"_HISDateTimeFormate_"'")
		s CurDept = ..TrimEnterAndWrite(CurDept)
		d ResultStream.Write(",CurDept:'"_CurDept_"',")
		//输出患者信息 end
		s AppointRowIDStr = ""
		d ResultStream.Write("AppointData:[")
		s AppointRowIDCount = 0
		s RequestUserID = ""
		for
		{
			s RequestUserID = $O(^TempEMRAppointList(key,EpisodeID,RequestUserID))
			q:(RequestUserID = "")
			
			s AppointRowID = ""
			for
			{
				s AppointRowID = $O(^TempEMRAppointList(key,EpisodeID,RequestUserID,AppointRowID))
				q:(AppointRowID = "")
				
				//取权限申请信息
				if (AppointRowIDCount > 0)
				{
					s AppointRowIDStr = AppointRowIDStr_"^"_AppointRowID
					d ResultStream.Write(",")
				}
				elseif(AppointRowIDCount = 0)
				{
					s AppointRowIDStr = AppointRowID
				}
				//w ^TempEMRAppointList(key,EpisodeID,RequestUserID,AppointRowID)
				s AppointRowStream = ..GetAppointDataByID(AppointRowID,AParameters)
				d ResultStream.CopyFrom(AppointRowStream)
				s AppointRowIDCount = AppointRowIDCount + 1
			}
		}
		d ResultStream.Write("]")
		d ResultStream.Write(",AppointRowIDStr:'"_AppointRowIDStr_"'")
		d ResultStream.Write("}")
	}
		
	d ResultStream.Write("],TotalCount:'"_EpisodeIDCount_"'}")
	k ^TempEMRAppointList(key)	
	q ResultStream
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
	
	//locID_"^"_userID_"^"_requestDateStart_"||"_requestTimeStart_"||"_requestDateEnd_"||"_requestTimeEnd_"||"_appointDateStart_"||"_appointTimeStart_"||"_appointDateEnd_"||"_appointTimeEnd_"^"_canAppointSelect_"^"_treatmentLoc_"^"_requestLoc_"^"_requestUserID
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
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(ARowID)
	s episodeID = appoint.EpisodeID
	s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
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
	s PADischgeDate=$P($g(^PAADM(episodeID)),"^",17)	//出院日期
	s PADischgeTime=$P($g(^PAADM(episodeID)),"^",18)	//出院时间
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

	s ^TempEMRAppointList(key,appoint.EpisodeID,appoint.RequestUserID,ARowID) = ARowID
	d appoint.%Close()	
	q 1
}

ClassMethod GetAppointDataByID(ARowID As %String, AParameters As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") json
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(ARowID)
	s episodeID = appoint.EpisodeID
	s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)

	//病人出院信息
	s PADischgeDate=$P($g(^PAADM(episodeID)),"^",17)	//出院日期
	s PADischgeTime=$P($g(^PAADM(episodeID)),"^",18)	//出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	
	s RequestCCDes=""
	s RequestCCDes = ..GetCateCharpterDescByIDs(appoint.RequestCateCharpter)
	s AppointedCCDes=""
	s AppointedCCDes = ..GetCateCharpterDescByIDs(appoint.AppointCateCharpter)

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

	s isActive = "none"
	s showIsActive = "true"
	if (IsAppointed = "appointed"){
		s isActive = ..CheckAppointIsActive(ARowID)
		s showIsActive = ..CheckPara(AIsActive, isActive)
		if (AIsActive = "2"){
			s showIsActive = "true"
		}
	}
	s (requestDate,requestTime,appointDate,appointTime,requestDateTime,appointEndDateTime,appointDateTime,requestNumber)=""
	d json.Write("{")
	s ID = ..TrimEnterAndWrite(ARowID)
	d json.Write("ID:'"_ID_"'")
	s requestCateCharpter = ..TrimEnterAndWrite(appoint.RequestCateCharpter)
	d json.Write(",RequestCateCharpter:'"_requestCateCharpter_"'")
	//s RequestCCDes = ..TrimEnterAndWrite(RequestCCDes)
	d json.Write(",RequestCCDesc:'")
	d json.CopyFrom(RequestCCDes)
	d json.Write("'")
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	d json.Write(",RequestUser:'"_currAuthor_"'")
	//liuzhongwan 新的基础数据中科室描述不再带有简拼
	//s requestDeptDesc = ..TrimEnterAndWrite($P(requestDeptDesc,"-",2))
	d json.Write(",RequestDept:'"_requestDeptDesc_"'")
	s:(appoint.RequestDate'="") requestDate = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3))
	s HISFormatrequestDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",requestDate)
	d json.Write(",RequestDate:'"_HISFormatrequestDate_"'")
	s:(appoint.RequestTime="") requestTime = ..TrimEnterAndWrite($ZT(appoint.RequestTime))
	s HISFormatrequestTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",requestTime)
	d json.Write(",RequestTime:'"_HISFormatrequestTime_"'")
	s eprAction = ..TrimEnterAndWrite(appoint.EPRAction)
	d json.Write(",EPRAction:'"_eprAction_"'")
	s:(appoint.AppointDate'="") appointDate = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3))
	s HISFormatappointDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",appointDate)
	d json.Write(",AppointDate:'"_HISFormatappointDate_"'")
	s:(appoint.AppointTime'="") appointTime = ..TrimEnterAndWrite($ZT(appoint.AppointTime))
	s HISFormatappointTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",appointTime)
	d json.Write(",AppointTime:'"_HISFormatappointTime_"'")
	s appointUser = ..TrimEnterAndWrite(appointUser)
	d json.Write(",AppointUser:'"_appointUser_"'")
	s appointType = ..TrimEnterAndWrite(appointType)
	d json.Write(",AppointType:'"_appointType_"'")
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	d json.Write(",AppointSpan:'"_appointSpan_"'")
	s appointCateCharpter = ..TrimEnterAndWrite(appoint.AppointCateCharpter)
	d json.Write(",AppointCateCharpter:'"_appointCateCharpter_"'")
	//s AppointedCCDes = ..TrimEnterAndWrite(AppointedCCDes)
	d json.Write(",AppointedCCDes:'")
	d json.CopyFrom(AppointedCCDes)
	d json.Write("'")
	s eprAction = ..TrimEnterAndWrite(appoint.EPRAction)
	d json.Write(",ActionType:'"_eprAction_"'")
	s isActive = ..TrimEnterAndWrite(isActive)
	d json.Write(",IsActive:'"_isActive_"'")
	s:(appoint.AppointDate'="") appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
	s HISFormatappointDateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointDateTime)
	d json.Write(",AppointDateTime:'"_HISFormatappointDateTime_"'")
	s:(appoint.AppointEndDate'="") appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
	s HISFormatappointEndDateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",appointEndDateTime)
	d json.Write(",AppointEndDateTime:'"_HISFormatappointEndDateTime_"'")
	s:(appoint.RequestDate'="") requestDateTime = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3)_" "_$ZT(appoint.RequestTime))
	s HISFormatrequestDateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",requestDateTime)
	d json.Write(",RequestDateTime:'"_HISFormatrequestDateTime_"'")
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	d json.Write(",IsAppointed:'"_IsAppointed_"'")
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	d json.Write(",CanAppoint:'"_canAppoint_"'")
	s:(PADischgeDate'="")&&(PADischgeTime'="") PADischgeDateTime = ..TrimEnterAndWrite($ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime))
	s HISFormatPADischgeDateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",PADischgeDateTime)
	d json.Write(",PADischgeDateTime:'"_HISFormatPADischgeDateTime_"'")
	s requestReason = ..TrimEnterAndWrite(appoint.RequestReason)
	d json.Write(",RequestReason:'"_requestReason_"'")
	s beforeRequestContent = ..TrimEnterAndWrite(appoint.BeforeRequestContent)
	d json.Write(",BeforeRequestContent:'"_beforeRequestContent_"'")
	s afterRequestContent = ..TrimEnterAndWrite(appoint.AfterRequestContent)
	d json.Write(",AfterRequestContent:'"_afterRequestContent_"'")
	s:(appoint.RequestNumber'="") requestNumber = ..TrimEnterAndWrite(appoint.RequestNumber)
	d json.Write(",RequestNumber:'"_requestNumber_"'")
	d json.Write(",AuthLevel:'"_..TrimEnterAndWrite(appoint.AuthLevel)_"'")
	d json.Write(",AuthLevelDesc:'"_..TrimEnterAndWrite(..GetAuthLevelDesc(appoint.AuthLevel))_"'")
	d json.Write(",RefuseReason:'"_..TrimEnterAndWrite(appoint.RefuseReason)_"'}")
	
	q json
}

/// Debug:	w ##Class(web.eprajax.EPRAction).SplitRequestChapter("5","42","104","105","6","100")
ClassMethod SplitRequestChapter(APatientID, AEpisodeID, ARequestChapterList, AUserID, AUserLocID, ASSGroupID) As %String
{
	q:(ARequestChapterList = "") "##"
	
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
	//替换单引号
	for {
		s count = $f(input,"'")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"@@@"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换斜杠
	for {
		s count = $f(input,"\")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"xiegangxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换反斜杠
	for {
		s count = $f(input,"/")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"fanxiegangfanxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文逗号
	for {
		s count = $f(input,",")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文逗号
	for {
		s count = $f(input,"，")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文叹号
	for {
		s count = $f(input,"!")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文叹号
	for {
		s count = $f(input,"！")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文句号
	for {
		s count = $f(input,"。")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"juhaojuhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文左单引号
	for {
		s count = $f(input,"‘")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"zuodanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文右单引号
	for {
		s count = $f(input,"’")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"youdanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//s input = $TR(input,"'","@@@")
	q input
}

ClassMethod GetAuthLevelDesc(AAuthLevel As %String) As %String
{
	q:(AAuthLevel = "100") "主管医师"
	q:(AAuthLevel = "200") "科主任"
	q:(AAuthLevel = "300") "医务科"
	q:(AAuthLevel = "400") "病案室"
	q "未设置"
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
/// Others:
ClassMethod CanAppoint(AUserID As %String, AUserLocID As %String, ASSGroupID As %String, AEpisodeID As %String, APatientID As %String) As %Boolean
{
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
/// Others: w ##Class(EMRservice.Ajax.Appoint).CheckAppointIsActive("1")
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
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
/// Return:返回一个字符串,格式如:set browse=1,print=1
/// Others:
/// liuzhongwan 最后增加一个入参Docid
ClassMethod GetAllActiveAppoint(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AInstanceID As %String, ADocID As %String) As %String
{
	s returnStr=""
	s RowID=""
	//liuzhongwan
	if (AInstanceID = ""){s docID = ADocID}
	else{s docID = AInstanceID}
	//liuzhongwan end
	for {
		s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s flag = ..CheckAppointIsActive(RowID)
		continue:(flag="0")
		
		s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
		if (appoint.AppointType="0")
		{	continue:(appoint.RequestUserID'=AUserID)}
		elseif (appoint.AppointType="1")
		{	continue:(appoint.RequestDept'=AUserLocID)}
		else
		{	continue}
		
		//liuzhongwan
		continue:($find("^"_appoint.AppointCateCharpter_"^","^"_docID_"^")=0)
		//liuzhongwan end
		
		if (returnStr="")
		{
			s returnStr = "s "_appoint.EPRAction_"=1"
		}
		else
		{
			s returnStr = returnStr_","_appoint.EPRAction_"=1"
		}
	}
	
	q returnStr
}

/// s jj= ##class(EMRservice.Ajax.Appoint).GetJsonStream("598","359","6","29")
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

/// w ##class(EMRservice.Ajax.Appoint).GetCategoryJason("9","743","9","29")
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

/// d ##class(EMRservice.Ajax.Appoint).GetCateChapterJason("CG3","9","743","9","29")
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
/// Debug:  	w ##Class(EMRservice.Ajax.Appoint).GetInstanceJsonByCategoryID(3,598,359)
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
/// Debug	w ##Class(EMRservice.Ajax.Appoint).GetDocJsonsById(51,1)
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
/// Debug       d ##Class(EMRservice.Ajax.Appoint).GetDocIdsByParent(3)
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
/// Debug：     w ##Class(EMRservice.Ajax.Appoint).DoInstanceJsonByDocID(58,51,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, AResultType As %String = "") As %String
{
	s $zt = "Error"
	s json = ""
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
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
/// Debug:     w ##Class(EMRservice.Ajax.Appoint).GetTempJsonByID(51)
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
/// Debug:     w ##Class(EMRservice.Ajax.Appoint).GetInstanceJsonByID(1,1)
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
	s createdate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createdate)			
	s createtime = $zt(objInstance.CreateTime)
	s createtime =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createtime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
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
					s createdate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(objInstance.CreateDate,3))
					s createtime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(objInstance.CreateTime))
					s createuserID = objInstance.CreateUser
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
/// Debug: w ##class(EMRservice.Ajax.Appoint).AddAutoRequest("230","279||980","359","6","save,print","","","","170","6","29","14400","0")
/// liuzhongwan 入参改名
ClassMethod AddAutoRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRActions As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID, AppointSpan As %Integer, AppointType As %String) As %String
{
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parametersreason1") = ARequestReason_"^"_ABeforeRequestContent_"^"_AAfterRequestContent
	q:(ARequestCateCharpter="") "-1"
	
	s flag = 1
	
	//liuzhongwan 拆分AEPRActions
	s ActionCount = $l(AEPRActions, ",")
	for j = 1:1:ActionCount
	{
		s action = $p(AEPRActions,",",j)
		s appoint = ##class(EMRinstance.EMRActionAppoint).%New()
		if (appoint="")
		{
			s flag = "-1"
			q
		}
	
		s appoint.EpisodeID = AEpisodeID
		s appoint.RequestCateCharpter = ARequestCateCharpter
		s appoint.RequestUserID = ARequestUserID
		s appoint.RequestDept = ARequestDept
		s appoint.AppointStatus="N"
		s appoint.RequestReason=ARequestReason
		s appoint.BeforeRequestContent=ABeforeRequestContent
		s appoint.AfterRequestContent=AAfterRequestContent
		s appoint.AuthLevel = "100"
	
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		s appoint.RequestDate = date
		s appoint.RequestTime = time
		s appoint.EPRAction = action
		s appoint.AppointDate = date
		s appoint.AppointTime = time
		
		s EndDateTime = ..GetEndDateTime(date,time,AppointSpan)
		s appoint.AppointEndDate = $p(EndDateTime,",",1)
		s appoint.AppointEndTime = $p(EndDateTime,",",2)
		s appoint.AppointCateCharpter = ARequestCateCharpter
		s appoint.AppointUserID = ARequestUserID
		s appoint.AppointStatus = "F"
		s appoint.EPRAction = action
		s appoint.AppointType = AppointType
		
		s sc = appoint.%Save()
		d appoint.%Close()
	
		if ('$$$ISOK(sc))
		{
			s flag = "-1"
			q
		}
	}
	//end liuzhongwan
		
	q flag
}

/// d ##Class(EMRservice.Ajax.Appoint).GetHistoryList("4125408","5671",1,10)
ClassMethod GetHistoryList(AEpisodeID As %String, ARequestUserID As %String, AStartRowIndex As %Integer, ARowCount As %Integer) As %GlobalCharacterStream
{
	//数据输出
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("{success:true,Data:[")
	s AppointIDCount = 0
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s startDate = date-60
	s endDate = date
	
	s RowID = ""
	for 
	{
		s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeID,RowID))
		q:(RowID = "")
		if (AEpisodeID '= "")
		{
			s AppointObj = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
			s requestUserID = AppointObj.RequestUserID
			continue:(requestUserID '= ARequestUserID)
		}
		s AppointIDCount = AppointIDCount + 1
		
		continue:(AppointIDCount < (AStartRowIndex + 1))
		continue:(AppointIDCount > (AStartRowIndex + ARowCount))
		
		if (AppointIDCount > (AStartRowIndex + 1))
		{
			d ResultStream.Write(",")
		}
		s AppointStream = ..GetHistoryDataByID(RowID,"")
		d ResultStream.CopyFrom(AppointStream)
	}

	d ResultStream.Write("],TotalCount:'"_AppointIDCount_"'}")
	q ResultStream
}

ClassMethod GetHistoryDataByID(ARowID As %String, AParameters As %String) As %GlobalCharacterStream
{
	s AppointDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") AppointDataStream
	
	s defaultAppointSpan = $p(AParameters,"^",8)
	s defaultAppointType = $p(AParameters,"^",9)
	s AIsActive = $p(AParameters,"^",12)
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(ARowID)
	s EpisodeID = appoint.EpisodeID
	
	//获取患者就诊信息  start
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//患者登记号
	s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	//患者姓名
	s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	//患者病案号
	s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
	//病案号
	s IPRecordNoNew = ##Class(EPRinstance.CaseRecordNo).GetIPRecordNoNew(EpisodeID)
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
	//s RequestID = appoint.RequestID
	if (ARowID '= "")&&(ARowID > 0)
	{
		s RequestObj = ##class(EMRinstance.EMRActionAppoint).%OpenId(ARowID)
		s requestReason = RequestObj.RequestReason
		s beforeRequestContent = RequestObj.BeforeRequestContent
		s afterRequestContent = RequestObj.AfterRequestContent
	}
	//获取申请表信息 end
	
	//输出患者信息 start
	d AppointDataStream.Write("{")
	s EpisodeID = ..TrimEnterAndWrite(EpisodeID)
	d AppointDataStream.Write("EpisodeID:'"_EpisodeID_"'")
	s PaadmNO = ..TrimEnterAndWrite(PaadmNO)
	d AppointDataStream.Write(",PaadmNO:'"_PaadmNO_"'")
	//IPRecordNoNew
	s IPRecordNoNew = ..TrimEnterAndWrite(IPRecordNoNew)
	d AppointDataStream.Write(",IPRecordNoNew:'"_IPRecordNoNew_"'")
	
	s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
	d AppointDataStream.Write(",PapmiNo:'"_PapmiNo_"'")
	s PatName = ..TrimEnterAndWrite(PatName)
	d AppointDataStream.Write(",Name:'"_PatName_"'")
	s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
	d AppointDataStream.Write(",MedicareNo:'"_MedicareNo_"'")
	s AdmDate = ..TrimEnterAndWrite($ZD(AdmDate,3))
	d AppointDataStream.Write(",AdmDate:'"_AdmDate_"'")
	s AdmTime = ..TrimEnterAndWrite($ZT(AdmTime))
	d AppointDataStream.Write(",AdmTime:'"_AdmTime_"'")
	s MainDoc = ..TrimEnterAndWrite(MainDoc)
	d AppointDataStream.Write(",MainDoc:'"_MainDoc_"'")
	s CurDept = ..TrimEnterAndWrite(CurDept)
	d AppointDataStream.Write(",CurDept:'"_CurDept_"'")
	s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
	d AppointDataStream.Write(",PAAdmType:'"_PAAdmType_"'")
	s PAStatus = ..TrimEnterAndWrite(PAStatus)
	d AppointDataStream.Write(",PAStatus:'"_PAStatus_"'")
	s PADischgeDateTime = ..TrimEnterAndWrite($ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime))
	d AppointDataStream.Write(",PADischgeDateTime:'"_PADischgeDateTime_"'")
	//输出患者信息 end
	
	//输出授权表信息  start
	s ID = ..TrimEnterAndWrite(ARowID)
	d AppointDataStream.Write(",AppointID:'"_ID_"'")
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	d AppointDataStream.Write(",RequestUser:'"_currAuthor_"'")
	s requestDeptDesc = ..TrimEnterAndWrite($P(requestDeptDesc,"-",2))
	d AppointDataStream.Write(",RequestDept:'"_requestDeptDesc_"'")
	s requestDate = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3))
	d AppointDataStream.Write(",RequestDate:'"_requestDate_"'")
	s requestTime = ..TrimEnterAndWrite($ZT(appoint.RequestTime))
	d AppointDataStream.Write(",RequestTime:'"_requestTime_"'")
	s requestDateTime = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3)_" "_$ZT(appoint.RequestTime))
	d AppointDataStream.Write(",RequestDateTime:'"_requestDateTime_"'")
	s appointDate = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3))
	d AppointDataStream.Write(",AppointDate:'"_appointDate_"'")
	s appointTime = ..TrimEnterAndWrite($ZT(appoint.AppointTime))
	d AppointDataStream.Write(",AppointTime:'"_appointTime_"'")
	s appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
	d AppointDataStream.Write(",AppointDateTime:'"_appointDateTime_"'")
	s appointUser = ..TrimEnterAndWrite(appointUser)
	d AppointDataStream.Write(",AppointUser:'"_appointUser_"'")
	s appointType = ..TrimEnterAndWrite(appointType)
	d AppointDataStream.Write(",AppointType:'"_appointType_"'")
	s isActive = ..TrimEnterAndWrite(isActive)
	d AppointDataStream.Write(",IsActive:'"_isActive_"'")
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	d AppointDataStream.Write(",AppointSpan:'"_appointSpan_"'")
	s appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
	d AppointDataStream.Write(",AppointEndDateTime:'"_appointEndDateTime_"'")
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	d AppointDataStream.Write(",IsAppointed:'"_IsAppointed_"'")
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	d AppointDataStream.Write(",CanAppoint:'"_canAppoint_"'")
	s AuthLevel = ..TrimEnterAndWrite(appoint.AuthLevel)
	d AppointDataStream.Write(",AuthLevel:'"_AuthLevel_"'")
	s AuthLevelDesc = ..TrimEnterAndWrite(..GetAuthLevelDesc(appoint.AuthLevel))
	d AppointDataStream.Write(",AuthLevelDesc:'"_AuthLevelDesc_"'")
	s RefuseReason = ..TrimEnterAndWrite(appoint.RefuseReason)
	d AppointDataStream.Write(",RefuseReason:'"_RefuseReason_"'")
	
	//输出申请表信息 start
	s requestReason = ..TrimEnterAndWrite(requestReason)
	d AppointDataStream.Write(",RequestReason:'"_requestReason_"'")
	s beforeRequestContent = ..TrimEnterAndWrite(beforeRequestContent)
	d AppointDataStream.Write(",BeforeRequestContent:'"_beforeRequestContent_"'")
	s afterRequestContent = ..TrimEnterAndWrite(afterRequestContent)
	d AppointDataStream.Write(",AfterRequestContent:'"_afterRequestContent_"'")
	//输出申请表信息 end
	//输出申请明细表信息 start
	
	d AppointDataStream.Write(",AppointDetailData:[")
	s DetailDataStream = ..GetDetailDataStrByID(ARowID,IsAppointed,canAppoint)
	//s DetailDataStream = ..GetDetailDataStreamByID(ARowID,IsAppointed,canAppoint)
	d AppointDataStream.CopyFrom(DetailDataStream)
	d AppointDataStream.Write("]")
	
	//输出申请明细表信息 end
	
	d AppointDataStream.Write("}")
	
	q AppointDataStream
}

/// d ##class(EMRservice.Ajax.AuthAppoint).GetDetailDataStreamByID("2099")
ClassMethod GetDetailDataStrByID(ARowID As %String, IsAppointed As %String, CanAppoint As %String) As %GlobalCharacterStream
{
	s DetailDataStream = ##Class(%GlobalCharacterStream).%New()
	s AppiontAction = ""
	s count = 0

	q:(ARowID = "") DetailDataStream
		s DetailObj = ##class(EMRinstance.EMRActionAppoint).%OpenId(ARowID)
		s DRequestCateCharpterStr = DetailObj.RequestCateCharpter
		s DAppointCateCharpterStr = DetailObj.AppointCateCharpter
		s DAction = DetailObj.EPRAction

		if (DAppointCateCharpterStr = DRequestCateCharpterStr)
		{
			s AppiontAction = DAction
		} 
		for i=1:1:$l(DRequestCateCharpterStr,"^")
		{
			
			s DRequestCateCharpter = $p(DRequestCateCharpterStr,"^",i)
			
			
			for j=1:1:$l(DAppointCateCharpterStr,"^")
			{
				
				s DAppointCateCharpter = $p(DAppointCateCharpterStr,"^",j)
				
				if (DRequestCateCharpter = DAppointCateCharpter)
				{
					
					s AppiontAction = DAction
					
				}
				
			}
			s CCDescStr = ..GetCateCharpterDescByID(DRequestCateCharpter)
				if (CCDescStr '= "")
				{
					s CCDesc = $p(CCDescStr,"^",1)
					s CCDateTime = $p(CCDescStr,"^",2)
					s CCCreator = $p(CCDescStr,"^",3)
				}
				if (count > 0)
				{
					d DetailDataStream.Write(",")
				}
				d DetailDataStream.Write("{")
				s CateCharpter = ..TrimEnterAndWrite(DRequestCateCharpter)
				d DetailDataStream.Write("CateCharpter:'"_DRequestCateCharpter_"'")
				s CCDesc = ..TrimEnterAndWrite(CCDesc)
				d DetailDataStream.Write(",CCDesc:'"_CCDesc_"'")
				s CCDateTime = ..TrimEnterAndWrite(CCDateTime)
				d DetailDataStream.Write(",CCDateTime:'"_CCDateTime_"'")
				s CCCreator = ..TrimEnterAndWrite(CCCreator)
				d DetailDataStream.Write(",CCCreator:'"_CCCreator_"'")
				
				d DetailDataStream.Write(",DAction:'"_DAction_"'")	
				d DetailDataStream.Write(",AppiontAction:'"_AppiontAction_"'")
				d DetailDataStream.Write("}")
				s count = count + 1	
		}
				
	q DetailDataStream
}

/// w ##Class(EMRservice.Ajax.AuthAppoint).GetCateCharpterDescByID(643)
ClassMethod GetCateCharpterDescByID(ACateCharpterIDs As %String) As %String
{
	s CateCharpterDescStr = ""
	q:(ACateCharpterIDs = "") CateCharpterDescStr
	b ;1
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
					if (createuserID = "")
					{
						s createuserCode =  ""
						s createuserName = ""
					}else
					{
						s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
						s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
					}
					
					//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
					s ccName = objChapter.CategoryName_"."_objInstance.Title_"^"_createdate_" "_createtime_"^"_createuserName
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

}
