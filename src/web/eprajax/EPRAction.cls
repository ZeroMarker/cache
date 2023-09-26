/// 名称:web.eprajax.EPRAction
/// 描述:病历权限操作,包括提交申请、提交授权和取得待授权列表
/// 编写者:loo
/// 编写日期:2010-09-19
Class web.eprajax.EPRAction Extends %CSP.Page [ ProcedureBlock ]
{

/// Creator:loo
/// CreatDate:2010-09-19
/// Description:
/// Table:EPRinstance.EPRActionAppoint
/// Input:Action-动作类型：request/appoint/getdis/getappoint/getall/updatefs,
/// 	  patientID-病人号,episodeID-就诊号,requestCateCharpter-申请范围,
/// 	  requestUserID-申请人,requestDept-申请部门,EPRAction-权限类型,
/// 	  ID-权限表RowID,appointSpan-授权时长,appointUserID-授权人,appointType-授权类型:0-个人1-科室
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
	//add by niucaicai 2016-3-15  start -----------------------------
	//增加“是否已打印”、“是否发送至病案室”
	s IsPrinted = $g(%request.Data("IsPrinted",1),"")
	s IsCommited = $g(%request.Data("IsCommited",1),"")
	//add by niucaicai 2016-3-15  end   -----------------------------
	
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
	
	s start = $g(%request.Data("start",1),0) + 1
	s limit = $g(%request.Data("limit",1),20)
	
	s defaultAppointSpan = $g(%request.Data("DefaultAppointSpan",1),"24")
	s defaultAppointType = $g(%request.Data("DefaultAppointType",1),"0")
	s appointRequestSpan = $g(%request.Data("AppointRequestSpan",1),"0")
	
	//add by niucaicai 2013-03-14 按登记号查询
	s PapmiNo = $g(%request.Data("PapmiNo",1),"")
	
	//add by niucaicai 2015-10-08 按病案号查询
	s MedicareNo = $g(%request.Data("MedicareNo",1),"")
	if (PapmiNo = "")&&(MedicareNo '= "")
	{
		s patientID = $o(^PAPERi("Medicare1",MedicareNo,""))
		s PapmiNo = $P($g(^PAPER(patientID,"PAT",1)),"^",1)
	}
	
	s RequestRange = $g(%request.Data("RequestRange",1),"")
	
	s parameters = locID_"^"_userID_"^"_requestDateStart_"||"_requestTimeStart_"||"_requestDateEnd_"||"_requestTimeEnd_"||"_appointDateStart_"||"_appointTimeStart_"||"_appointDateEnd_"||"_appointTimeEnd_"^"_canAppointSelect_"^"_treatmentLoc_"^"_requestLoc_"^"_requestUserName_"^"_defaultAppointSpan_"^"_defaultAppointType_"^"_pAAdmType_"^"_pAStatus_"^"_isActive_"^"_appointRequestSpan_"^"_ssgroupID_"^"_RequestRange
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parameters") = PapmiNo_"#"_parameters_"#"_start_"#"_limit_"#"_eprIntegratedAuthorization
	//---------------------------------------------------------------
	
	if (patientID = "")
	{
		s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID) //201868
	}
	
	If (action="request")
	{
		//w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent)
		w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,locID,ssgroupID,IsPrinted,IsCommited)
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
		w ..RefuseAppoint(ID)
	}
	ElseIf (action="withdraw")
	{
		w ..WithdrawAppoint(ID)
	}
	ElseIf (action="getunappointed")
	{
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"UnAppointed",authLevelType)
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				d ..GetLocAppointList("UnAppointed",PapmiNo,parameters,start,limit,"loc",authLevelType)
			}
			else{
				d ..GetLocAppointList("UnAppointed",PapmiNo,parameters,start,limit,"all",authLevelType)
			}
		}
	}
	ElseIf (action="getappointed")
	{
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"Appointed",authLevelType)
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				d ..GetLocAppointList("Appointed",PapmiNo,parameters,start,limit,"loc",authLevelType)
			}
			else{
				d ..GetLocAppointList("Appointed",PapmiNo,parameters,start,limit,"all",authLevelType)
			}
		}
	}
	ElseIf (action="getrefuse")
	{
		if (eprIntegratedAuthorization '= "1")
		{
			d ..GetAppointList(patientID,"Refuse",authLevelType)
		}
		else
		{
			//modified by yang 2012-04-13
			if (onlyCurrentDept = "1")
			{
				d ..GetLocAppointList("Refuse",PapmiNo,parameters,start,limit,"loc",authLevelType)
			}
			else{
				d ..GetLocAppointList("Refuse",PapmiNo,parameters,start,limit,"all",authLevelType)
			}
		}			
	}
	
	Quit $$$OK
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
ClassMethod GetAppointList(APatientID As %String, AType As %String, AAuthLevelType As %String) As %String
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
			
			s tmpJson = ..GetAppointListByEID(APatientID,episodeID,AType,AAuthLevelType)
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
ClassMethod GetAppointListByEID(APatientID As %String, AEpisodeID As %String, AType As %String, AAuthLevelType As %String) As %String
{
	s returnJson=""
	
	//<2010-9-29><loo><待授权列表中增加患者相关信息>
	
	//患者姓名
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(APatientID)
	//就诊日期、就诊时间
	s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	s admTime = $P($G(^PAADM(AEpisodeID)),"^",7)
	//主治医生
	s mainDoc =  ##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
	s mainDoc = $P(mainDoc,"^",3)
	//就诊科室
	s curDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
	s curDept = $P(curDept,"^",3)
	
	s RowID=""
	for {
		s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""
		
		s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(RowID)
		continue:(appoint="")
		
		//校验授权级别
		continue:(AAuthLevelType '= "")&&(AAuthLevelType '= appoint.AuthLevel)
		
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
		//modify by niucaicai 2016-5-11 增加获取AppointedCCDes,并输出;
		s RequestCCDes=""
		s RequestCCDes = ..GetCateCharpterDescByIDs(appoint.RequestCateCharpter)
		s AppointedCCDes=""
		s AppointedCCDes = ..GetCateCharpterDescByIDs(appoint.AppointCateCharpter)
		
		
		//取用户名
		s:(appoint.RequestUserID'="") currAuthor = ##class(EPRmeta.Privilege.PowerUser).GetUserName(appoint.RequestUserID)
		s:(appoint.AppointUserID'="") appointUser = ##class(EPRmeta.Privilege.PowerUser).GetUserName(appoint.AppointUserID)
		
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
		s returnJson = returnJson_",RequestDate:'"_$ZD(appoint.RequestDate,3)_"'"
		s returnJson = returnJson_",RequestTime:'"_$ZT(appoint.RequestTime)_"'"
		s returnJson = returnJson_",EPRAction:'"_appoint.EPRAction_"'"
		s returnJson = returnJson_",AppointDate:'"_$ZD(appoint.AppointDate,3)_"'"
		s returnJson = returnJson_",AppointTime:'"_$ZT(appoint.AppointTime)_"'"
		s returnJson = returnJson_",AppointUser:'"_appointUser_"'"
		s returnJson = returnJson_",AppointType:'"_appoint.AppointType_"'"
		s returnJson = returnJson_",AppointSpan:'"_appointSpan_"'"
		s returnJson = returnJson_",AppointCateCharpter:'"_appoint.AppointCateCharpter_"'"
		s returnJson = returnJson_",AppointedCCDes:'"_AppointedCCDes_"'"
		s returnJson = returnJson_",Name:'"_name_"'"
		s returnJson = returnJson_",AdmDate:'"_$ZD(admDate,3)_"'"
		s returnJson = returnJson_",AdmTime:'"_$ZT(admTime)_"'"
		s returnJson = returnJson_",MainDoc:'"_mainDoc_"'"
		s returnJson = returnJson_",RequestReason:'"_..TrimEnterAndWrite(appoint.RequestReason)_"'"
		s returnJson = returnJson_",BeforeRequestContent:'"_appoint.BeforeRequestContent_"'"
		s returnJson = returnJson_",AfterRequestContent:'"_appoint.AfterRequestContent_"'"
		s returnJson = returnJson_",CurDept:'"_curDept_"'"	
		s returnJson = returnJson_",AuthLevel:'"_appoint.AuthLevel_"'"	
		s returnJson = returnJson_",AuthLevelDesc:'"_..GetAuthLevelDesc(appoint.AuthLevel)_"'"
		s returnJson = returnJson_",IsPrinted:'"_appoint.IsPrinted_"'"
		s returnJson = returnJson_",IsCommited:'"_appoint.IsCommited_"'}"
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
/// Debug:	d ##Class(web.eprajax.EPRAction).GetLocAppointList("UnAppointed","","6^105^||||||||||||||^2^^^^24^0^^^^0^100^",0,20,"all")
ClassMethod GetLocAppointList(AType As %String, APapmiNo As %String, AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, AIsAll, AAuthLevelType) As %String
{
	s RequestDateStart = $p($p(AParameters,"^",3),"||",1)
	if (RequestDateStart'="") s RequestDateStart = $zdh(RequestDateStart,3)
	s RequestDateEnd = $p($p(AParameters,"^",3),"||",3)
	if (RequestDateEnd'="") s RequestDateEnd = $zdh(RequestDateEnd,3)
	s AppointDateStart = $p($p(AParameters,"^",3),"||",5)
	if (AppointDateStart'="") s AppointDateStart = $zdh(AppointDateStart,3)
	s AppointDateEnd = $p($p(AParameters,"^",3),"||",7)
	if (AppointDateEnd'="") s AppointDateEnd = $zdh(AppointDateEnd,3)
		
	s totalCount = 0
	w "{success:true,Data:["
	
	/*
	//此区间代码按照正序查询
	s AppointDate = "" 
	if (AppointDateStart'="") s AppointDate = AppointDateStart - 1
	s RequestDate = ""
	if (RequestDateStart'="") s RequestDate = RequestDateStart - 1
	
	//N:未授权; R:拒绝; F:已授权
	if (AType = "Appointed")
	{	
		//对有要求的医院，已授权的按照申请时间排序
		s HospitalName = ##Class(EPRservice.BOSysOption).GetValueByName("HospitalName")
		
		if (HospitalName = "WLSRMYY")
		{
			for {
				s RequestDate = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," F", RequestDate))
				q:(RequestDate="")
				q:((RequestDateEnd'="")&&(RequestDate>RequestDateEnd))
				s RowID = ""
				for {
					s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," F", RequestDate, RowID))
					q:(RowID = "")
					s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(RowID)
					q:(appoint.AppointDate="")  d appoint.%Close()
					q:((AppointDateEnd'="")&&(appoint.AppointDate>AppointDateEnd))  d appoint.%Close()
					q:((AppointDateStart'="")&&(appoint.AppointDate<AppointDateStart))  d appoint.%Close()
					d appoint.%Close()
					s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
				}
			}
		}
		else
		{
			for {
				s AppointDate = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," F", AppointDate))
				q:(AppointDate="")
				q:((AppointDateEnd'="")&&(AppointDate>AppointDateEnd))
				s RowID = ""
				for {
					s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," F", AppointDate, RowID))
					q:(RowID = "")
					s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
				}
			}
		}
	}
	elseif (AType = "UnAppointed")
	{	
		for {
			s RequestDate = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," N", RequestDate))
			q:(RequestDate="")
			q:((RequestDateEnd'="")&&(RequestDate>RequestDateEnd))
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," N", RequestDate, RowID))
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
			}
		}
	}
	elseif (AType = "Refuse")
	{	
		for {
			s AppointDate = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," R", AppointDate))
			q:(AppointDate="")
			q:((AppointDateEnd'="")&&(AppointDate>AppointDateEnd))
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," R", AppointDate, RowID))
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
			}
		}
	}
	*/
	
	//此区间代码按照倒序查询
	//s AppointDate = "" 
	//if (AppointDateEnd'="") s AppointDate = AppointDateEnd + 1
	//s RequestDate = ""
	//if (RequestDateEnd'="") s RequestDate = RequestDateEnd + 1
	
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
		//对有要求的医院，已授权的按照申请时间排序
		s HospitalName = ##Class(EPRservice.BOSysOption).GetValueByName("HospitalName")
		
		if (HospitalName = "WLSRMYY")
		{
			s RequestDate = ""
			s RequestDateStart = ""
			if (RequestDateEnd'="") s RequestDate = RequestDateEnd + 1
			for {
				s RequestDate = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," F", RequestDate),-1)
				q:(RequestDate="")
				q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
				s RowID = ""
				for {
					s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," F", RequestDate, RowID),-1)
					q:(RowID = "")
					s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(RowID)
					q:(appoint.AppointDate="")  d appoint.%Close()
					q:((AppointDateEnd'="")&&(appoint.AppointDate>AppointDateEnd))  d appoint.%Close()
					q:((AppointDateStart'="")&&(appoint.AppointDate<AppointDateStart))  d appoint.%Close()
					d appoint.%Close()
					s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
				}
			}
		}
		else
		{
			for i=AppointDateEnd:-1:AppointDateStart
			{
				s RowID = ""
				for {
					s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," F", i, RowID),-1)
					q:(RowID = "")
					s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
				}
			}
			/*
			for {
				s AppointDate = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," F", AppointDate),-1)
				q:(AppointDate="")
				q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
				s RowID = ""
				for {
					s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," F", AppointDate, RowID),-1)
					q:(RowID = "")
					s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
				}
			}
			*/
		}
	}
	elseif (AType = "UnAppointed")
	{	
		for i=RequestDateEnd:-1:RequestDateStart
		{
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," N", i, RowID),-1)
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
			}
		}
		/*
		for {
			s RequestDate = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," N", RequestDate),-1)
			q:(RequestDate="")
			q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxRequestDt"," N", RequestDate, RowID),-1)
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
			}
		}
		*/
	}
	elseif (AType = "Refuse")
	{	
		for i=AppointDateEnd:-1:AppointDateStart
		{
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," R", i, RowID),-1)
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount)
			}
		}
		/*
		for {
			s AppointDate = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," R", AppointDate),-1)
			q:(AppointDate="")
			q:((RequestDateStart'="")&&(RequestDate<RequestDateStart))
			s RowID = ""
			for {
				s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," R", AppointDate, RowID),-1)
				q:(RowID = "")
				s totalCount = totalCount + ..GetLocAppointListByEID(RowID,APapmiNo,AParameters,AStartRowIndex, ARowCount,AIsAll,totalCount,AAuthLevelType)
			}
		}
		*/
	}
	
		
	w "],TotalCount:'"_totalCount_"'}"	
	q "1"
}

/// Creator:yang
/// CreatDate:2012-04-13
/// Description:根据EpisodeID,PatientID取得所有已进行授权的列表，根据条件判断，符合返回一个json，不符合返回空
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AID-RowID，AParameters-条件
/// Return:符合条件-Json格式字符串，不符合条件-空串
ClassMethod GetLocAppointListByEID(ARowID As %String, APapmiNo As %String, AParameters As %String, AStartRowIndex As %Integer, ARowCount As %Integer, ANeedDisplay As %String, ACount As %Integer, AAuthLevelType As %String) As %Integer
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
	
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(ARowID)
	s episodeID = appoint.EpisodeID
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
	if (ANeedDisplay '= "all")
	{
		//若不是全部科室
		//则取患者的当前科室若为登录的科室，则显示
		q:($P($g(^PAADM(episodeID)),"^",4)'=LocID) 0
	}
	
	//登记号判断
	s PapmiNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
	q:((APapmiNo'="")&&(PapmiNo'=APapmiNo)) 0
			
	
	//患者姓名
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(patientID)
	//患者病案号
	s MedicareNo = $P($g(^PAPER(patientID,"PAT",1)),"^",22)
	
	//就诊日期、就诊时间
	s admDate = $P($G(^PAADM(episodeID)),"^",6)
	s admTime = $P($G(^PAADM(episodeID)),"^",7)
	//主治医生
	s mainDoc =  ##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(episodeID)
	s mainDoc = $P(mainDoc,"^",3)
	//就诊科室
	s curDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
	s curDept = $P(curDept,"^",3)
	s curDeptNum = $P(##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID),"^",1)
	
	//病人就诊类型 I-住院,O-门诊,E-急诊
	s PAAdmType = $p($g(^PAADM(episodeID)),"^",2)   
	
	//病人出院信息
	s PADischgeDate=$P($g(^PAADM(episodeID)),"^",17)	//出院日期
	s PADischgeTime=$P($g(^PAADM(episodeID)),"^",18)	//出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	s PAStatus = "in"
	if (PADischgeDateTime '= "") s PAStatus = "out"
	
	s currAuthor="",requestDeptDesc="",appointUser="", appointSpan = ""

	q:(AAuthLevelType '= "")&&(AAuthLevelType '= appoint.AuthLevel) 0
	
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
		
	s RequestCCDes=""
	s RequestCCDes = ..GetCateCharpterDescByIDs(appoint.RequestCateCharpter)
	s AppointedCCDes=""
	s AppointedCCDes = ..GetCateCharpterDescByIDs(appoint.AppointCateCharpter)
		
	//取用户名
	s:(appoint.RequestUserID'="") currAuthor = ##class(EPRmeta.Privilege.PowerUser).GetUserName(appoint.RequestUserID)
	s:(appoint.AppointUserID'="") appointUser = ##class(EPRmeta.Privilege.PowerUser).GetUserName(appoint.AppointUserID)
		
	//取用户所在科室描述
	s:(appoint.RequestDept'="") requestDeptDesc=$p($g(^CTLOC(appoint.RequestDept)),"^",2)
		
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
	s showTreatmentLoc = ..CheckPara(TreatmentLoc, curDeptNum)	
		
	//只显示指定申请科室
	s showRequestLoc = ..CheckPara(RequestLoc, appoint.RequestDept)
		
	//只显示指定申请医生
	s showRequestUserName = ..CheckPara(RequestUserName, currAuthor)
	
	//只显示指定就诊类型
	s showPAAdmType = ..CheckPara(APAAdmType, PAAdmType)
	
	//只显示指定在院状态
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

	q:(ACount < (AStartRowIndex - 1)) 1
	q:(ACount > (AStartRowIndex + ARowCount - 2)) 1
			
	s PatientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(appoint.EpisodeID)
	s PapmiNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
			
	if (ACount > (AStartRowIndex - 1)) w ","
	
	s ARowID = ..TrimEnterAndWrite(ARowID)
	w "{ID:'"_ARowID_"'"
	s episodeID = ..TrimEnterAndWrite(appoint.EpisodeID)
	w ",EpisodeID:'"_episodeID_"'"
	s PapmiNo = ..TrimEnterAndWrite(PapmiNo)
	w ",PapmiNo:'"_PapmiNo_"'"
	s requestCateCharpter = ..TrimEnterAndWrite(appoint.RequestCateCharpter)
	w ",RequestCateCharpter:'"_requestCateCharpter_"'"
	s RequestCCDes = ..TrimEnterAndWrite(RequestCCDes)
	w ",RequestCCDesc:'"_RequestCCDes_"'"
	s currAuthor = ..TrimEnterAndWrite(currAuthor)
	w ",RequestUser:'"_currAuthor_"'"
	s requestDeptDesc = ..TrimEnterAndWrite($P(requestDeptDesc,"-",2))
	w ",RequestDept:'"_requestDeptDesc_"'"
	s requestDate = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3))
	w ",RequestDate:'"_requestDate_"'"
	s requestTime = ..TrimEnterAndWrite($ZT(appoint.RequestTime))
	w ",RequestTime:'"_requestTime_"'"
	s eprAction = ..TrimEnterAndWrite(appoint.EPRAction)
	w ",EPRAction:'"_eprAction_"'"
	s appointDate = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3))
	w ",AppointDate:'"_appointDate_"'"
	s appointTime = ..TrimEnterAndWrite($ZT(appoint.AppointTime))
	w ",AppointTime:'"_appointTime_"'"
	s appointUser = ..TrimEnterAndWrite(appointUser)
	w ",AppointUser:'"_appointUser_"'"
	s appointType = ..TrimEnterAndWrite(appointType)
	w ",AppointType:'"_appointType_"'"
	s appointSpan = ..TrimEnterAndWrite(appointSpan)
	w ",AppointSpan:'"_appointSpan_"'"
	s appointCateCharpter = ..TrimEnterAndWrite(appoint.AppointCateCharpter)
	w ",AppointCateCharpter:'"_appointCateCharpter_"'"
	s AppointedCCDes = ..TrimEnterAndWrite(AppointedCCDes)
	w ",AppointedCCDes:'"_AppointedCCDes_"'"
	s name = ..TrimEnterAndWrite(name)
	w ",Name:'"_name_"'"
	s MedicareNo = ..TrimEnterAndWrite(MedicareNo)
	w ",MedicareNo:'"_MedicareNo_"'"
	s admDate = ..TrimEnterAndWrite($ZD(admDate,3))
	w ",AdmDate:'"_admDate_"'"
	s admTime = ..TrimEnterAndWrite($ZT(admTime))
	w ",AdmTime:'"_admTime_"'"
	s mainDoc = ..TrimEnterAndWrite(mainDoc)
	w ",MainDoc:'"_mainDoc_"'"
	s eprAction = ..TrimEnterAndWrite(appoint.EPRAction)
	w ",ActionType:'"_eprAction_"'"
	s isActive = ..TrimEnterAndWrite(isActive)
	w ",IsActive:'"_isActive_"'"
	s appointDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointDate,3)_" "_$ZT(appoint.AppointTime))
	w ",AppointDateTime:'"_appointDateTime_"'"
	s appointEndDateTime = ..TrimEnterAndWrite($ZD(appoint.AppointEndDate,3)_" "_$ZT(appoint.AppointEndTime))
	w ",AppointEndDateTime:'"_appointEndDateTime_"'"
	s requestDateTime = ..TrimEnterAndWrite($ZD(appoint.RequestDate,3)_" "_$ZT(appoint.RequestTime))
	w ",RequestDateTime:'"_requestDateTime_"'"
	s IsAppointed = ..TrimEnterAndWrite(IsAppointed)
	w ",IsAppointed:'"_IsAppointed_"'"
	s canAppoint = ..TrimEnterAndWrite(canAppoint)
	w ",CanAppoint:'"_canAppoint_"'"
	s PAAdmType = ..TrimEnterAndWrite(PAAdmType)
	w ",PAAdmType:'"_PAAdmType_"'"
	s PAStatus = ..TrimEnterAndWrite(PAStatus)
	w ",PAStatus:'"_PAStatus_"'"
	s PADischgeDateTime = ..TrimEnterAndWrite($ZD(PADischgeDate,3)_" "_$ZT(PADischgeTime))
	w ",PADischgeDateTime:'"_PADischgeDateTime_"'"
	s requestReason = ..TrimEnterAndWrite(appoint.RequestReason)
	w ",RequestReason:'"_requestReason_"'"
	s beforeRequestContent = ..TrimEnterAndWrite(appoint.BeforeRequestContent)
	w ",BeforeRequestContent:'"_beforeRequestContent_"'"
	s afterRequestContent = ..TrimEnterAndWrite(appoint.AfterRequestContent)
	w ",AfterRequestContent:'"_afterRequestContent_"'"
	s curDept = ..TrimEnterAndWrite(curDept)
	//w ",CurDept:'"_curDept_"'}"
	w ",CurDept:'"_curDept_"'"
	w ",AuthLevel:'"_appoint.AuthLevel_"'"	
	//w ",AuthLevelDesc:'"_..GetAuthLevelDesc(appoint.AuthLevel)_"'}"
	//modify by niucaicai 2016-3-15
	w ",AuthLevelDesc:'"_..GetAuthLevelDesc(appoint.AuthLevel)_"'"
	w ",IsPrinted:'"_appoint.IsPrinted_"'"
	w ",IsCommited:'"_appoint.IsCommited_"'}"

	d appoint.%Close()	
	q 1
}

ClassMethod GetCateCharpterDescByIDs(ACateCharpterIDs As %String)
{
	s CateCharpterDescStr = ""
	q:(ACateCharpterIDs = "") CateCharpterDescStr
	
	s length = $l(ACateCharpterIDs,"^")
	for i=1:1:length
	{
		s ccName = ""
		s ccID = $P(ACateCharpterIDs,"^",i)
		s ccInfo = ##class(EPRmeta.EPRTemplateCategory).%OpenId(ccID)
		if ccInfo = ""
		{	s ccName = "申请病历不存在"}
		else
		{
			s ccName = ccInfo.CategoryName
			s cgInfo = ##class(EPRmeta.EPRTemplateCategory).%OpenId(ccInfo.ParentCategoryID)
			if cgInfo '= ""
			{	s ccName = cgInfo.CategoryName_"."_ccName}	
			}
			
		if CateCharpterDescStr = ""
		{	s CateCharpterDescStr = ccName}
		else
		{	s CateCharpterDescStr = CateCharpterDescStr_"^"_ccName}
	}
	
	q CateCharpterDescStr
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
	//s input = $TR(input,"'","@@@")
	q input
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
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"
	
	s appoint.AppointCateCharpter = AppointCateCharpter
	
	s sc = appoint.%Save()
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
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
  	s privPara = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLocID_"!templateid^0!ssgroupid^"_ASSGroupID_"!categoryid^0!docid^0!isnewframework^1!eprnum^0"
   	s privArr = ##Class(EPRservice.Privilege.BOPrivRule).GetAppointPriv(privPara)
 	if privArr = ""
 	{	s isAppointActive = "0"}
 	else
 	{	s isAppointActive = privArr.GetAt("appoint")}
 	
 	q isAppointActive
}

/// Creator:loo
/// CreatDate:2010-09-20
/// Description:新增申请
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,ARequestCateCharpter-申请范围,ARequestUserID-申请人,
/// 	  ARequestDept-申请人部门,AEPRAction-申请权限类型
/// Output:
/// Return:1-新增操作成功,-1-新增操作失败
/// Others:
/// Debug: w ##class(web.eprajax.EPRAction).AddRequest("201764","23^25","5972","34","browse","","","","1","2","3")
ClassMethod AddRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRAction As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID, AIsPrinted As %String, AIsCommited As %String) As %String
{
	//s ^CacheTempDHCEPRDebug("web.eprajax.EPRAction", "parametersreason1") = ARequestReason_"^"_ABeforeRequestContent_"^"_AAfterRequestContent
	q:(ARequestCateCharpter="") "-1"
	
	s flag = 1
	s splitChapter = ..SplitRequestChapter(APatientID, AEpisodeID, ARequestCateCharpter, ARequestUserID, AUserLocID, ASSGroupID)
	
	for i = 1:1:3
	{
		s chapter = $P(splitChapter, "#", i)
		s level = (i * 100)
		continue:(chapter = "")
		
		s appoint = ##class(EPRinstance.EPRActionAppoint).%New()
		if (appoint="")
		{
			s flag = "-1"
			q
		}
		
		s appoint.EpisodeID = AEpisodeID
		s appoint.RequestCateCharpter = chapter
		s appoint.RequestUserID = ARequestUserID
		s appoint.RequestDept = ARequestDept
		s appoint.AppointStatus="N"
		s appoint.RequestReason=ARequestReason
		s appoint.BeforeRequestContent=ABeforeRequestContent
		s appoint.AfterRequestContent=AAfterRequestContent
		s appoint.AuthLevel = level
		s appoint.IsPrinted = AIsPrinted
		s appoint.IsCommited = AIsCommited
		
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		s appoint.RequestDate = date
		s appoint.RequestTime = time
		s appoint.EPRAction = AEPRAction
		
		s sc = appoint.%Save()
		d appoint.%Close()
		
		if ('$$$ISOK(sc))
		{
			s flag = "-1"
			q
		}
	}
	
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
/// Debug: w ##class(web.eprajax.EPRAction).AddAppoint("8",28800,"23^25^29","5972","print","0")
ClassMethod AddAppoint(AID As %String, AppointSpan As %Integer, AppointCateCharpter As %String, AppointUserID As %String, AEPRAciton As %String, AppointType As %String) As %String
{
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(AID)
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
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod RefuseAppoint(AID As %String) As %String
{
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(AID)
	q:(appoint="") "-1"	
	
	//设定状态为拒绝
	s appoint.AppointStatus = "R"
	//写入拒绝时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointDate = date
	s appoint.AppointTime = time	
	
	s sc = appoint.%Save()
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

ClassMethod WithdrawAppoint(AID As %String) As %String
{
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(AID)
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

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLocID-用户所在科室,
/// 	  ArgDocID-PrintDocID,打印模板ID
/// Output:
/// Return:返回一个字符串,格式如:set browse=1,print=1
/// Others:
ClassMethod GetAllActiveAppoint(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, ArgDocID As %String) As %String
{
	s ArgCateCharpterID=##class(EPRmeta.EPRTemplateCategory).GetParentIDByDocID(ArgDocID)
	
	s returnStr=""
	s RowID=""
	for {
		s RowID = $o(^DHCEPRI.EPRActionAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s flag = ..CheckAppointIsActive(RowID)
		continue:(flag="0")
		
		s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(RowID)
		if (appoint.AppointType="0")
		{	continue:(appoint.RequestUserID'=AUserID)}
		elseif (appoint.AppointType="1")
		{	continue:(appoint.RequestDept'=AUserLocID)}
		else
		{	continue}
		
		continue:($find("^"_appoint.AppointCateCharpter_"^","^"_ArgCateCharpterID_"^")=0)
		
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

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:根据EpisodeID取出所有有效的授权(查看是否已授权,及授权是否有效)
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others:
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(AID)
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

ClassMethod AddZero(APatientNo As %String) As %String
{
	s patientNo = ""
	s patientNo = $o(^PAPERi("PAPMI_PatNo",patientNo))
	s patientNo = $tr(patientNo, " ")
	s patientNo = $tr(patientNo,$c(10),"")
	s patientNo = $tr(patientNo,$c(13),"")
	s length = $l(patientNo)
	q:(length = $l(APatientNo)) APatientNo
	
	for index=1:1:(length - $l(APatientNo)) {
		s APatientNo = "0"_APatientNo
	}
	q APatientNo
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

/// debug:  d ##class(web.eprajax.EPRAction).UpdateData()
/// d ##class(EPRinstance.EPRActionAppoint).%BuildIndices()
ClassMethod UpdateData()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRI.EPRActionAppointD(rowID))
		q:(rowID = "")
		s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(rowID)
		if (appoint.AppointStatus = "")
		{
			//未授权
			if (appoint.AppointDate = "" || appoint.AppointTime = "")
			{
				s appoint.AppointStatus = "N"
			}
			//已授权
			else
			{
				s appoint.AppointStatus = "F"	
			} 	
		}
		s sc = appoint.%Save()
		d appoint.%Close()
		if ($$$ISOK(sc)) continue
		w !,"error"
	}	
	w !,"all finish"
}

/// Debug:	w ##Class(web.eprajax.EPRAction).SplitRequestChapter("1","2","1^2^3^4^5^6","3","4","5")
ClassMethod SplitRequestChapter(APatientID, AEpisodeID, ARequestChapterList, AUserID, AUserLocID, ASSGroupID) As %String
{
	q:(ARequestChapterList = "") "##"
	
	//100 患者主管医师审核级别，200 科主任审核级别，300 病案室审核级别
	s level100 = "", level200 = "", level300 = ""
	
	s count = $L(ARequestChapterList,"^")
	for i = 1:1:count
	{
		s eprDocID = $P(ARequestChapterList,"^",i)
		continue:(eprDocID = "")
		
		//使用权限判断申请级别
  		s privPara = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLocID_"!templateid^0!ssgroupid^"_ASSGroupID_"!categoryid^0!docid^"_eprDocID_"!isnewframework^1!eprnum^0"
   		s privArr = ##Class(EPRservice.Privilege.BOPrivRule).GetAuthLevelPriv(privPara)
 		s authLevel = privArr.GetAt("authlevel")
 		
 		//b 
 		if (authLevel < 101)
 		{	
 			//患者主管医师审核级别
 			//s authLevel = "100"
 			if (level100 = "")
 			{	s level100 = eprDocID}
 			else
 			{	s level100 = level100_"^"_eprDocID}
 		}	
 		elseif (authLevel < 201)	
 		{	
 			//患者所在科室科主任审核级别
 			//s authLevel = "200"
 			if (level200 = "")
 			{	s level200 = eprDocID}
 			else
 			{	s level200 = level200_"^"_eprDocID}
 		}	
 		else
 		{	
 			//病案室审核级别
 			//s authLevel = "300"
 			if (level300 = "")
 			{	s level300 = eprDocID}
 			else
 			{	s level300 = level300_"^"_eprDocID}
 		}
	}
	
	q level100_"#"_level200_"#"_level300
}

ClassMethod GetAuthLevelDesc(AAuthLevel As %String) As %String
{
	q:(AAuthLevel = "100") "主管医师"
	q:(AAuthLevel = "200") "科主任"
	q:(AAuthLevel = "300") "医务处"
	q "未设置"
}

/// debug:  d ##class(web.eprajax.EPRAction).Test()
ClassMethod Test() As %String
{
	//d ..GetLocAppointList("UnAppointed","","34^5972^2013-06-01||||2013-06-27||||||||||^2^^^^24^0^^^^0^576^",1,20,"all","300")
	d ..GetLocAppointList("UnAppointed","","^^||||||||||||||^^^^^^^^^^^^",1,20,"all","300")
}

}
