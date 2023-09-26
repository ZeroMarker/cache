Class web.eprajax.GivePower Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s patientID = $Get(%request.Data("PatientID",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s patientLocID = $Get(%request.Data("PatientLocID",1),"")
    s patientWardID = $Get(%request.Data("PatientWardID",1),"")
    s MedicareNo = $g(%request.Data("MedicareNo",1),"")
    
    s userID = $Get(%request.Data("UserID",1),"")
    s userName = $Get(%request.Data("DocUserName",1),"")
    s userCode = $Get(%request.Data("DocUserCode",1),"")
    s groupID = $Get(%request.Data("DocSSGroupID",1),"")
    s ctLocID = $Get(%request.Data("DocLocID",1),"")
    
    s appointSpan = $Get(%request.Data("AppointSpan",1),"")
    s appointCateCharpter = $Get(%request.Data("AppointCateCharpter",1),"")
    s appointUserID = $Get(%request.Data("AppointUserID",1),"")
    s eprActions = $Get(%request.Data("EPRAcitons",1),"")
    
    s appointIDs = $Get(%request.Data("AppointIDs",1),"")
    
    s isValid = $Get(%request.Data("IsValid",1),"")
		
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s param = patientID_"^"_patientName_"^"_patientLocID_"^"_patientWardID_"^"_episodeID_"^"_regNo_"^"_MedicareNo
	s paramDoc = userName_"^"_userCode_"^"_groupID_"^"_ctLocID
	//s ^CacheTemp("debug","web.eprajax.GivePower","input") = param_"|"_startRow_"|"_endRow
	//s ^CacheTemp("debug","web.eprajax.GivePower","tree") = action_"|"_episodeID_"|"_patientID_"|"_userID_"|"_groupID_"|"_ctLocID

	if (action = "tree")
	{
		//s ^CacheTemp("debug","web.eprajax.GivePower","tree") = episodeID_"|"_patientID_"|"_userID_"|"_groupID_"|"_ctLocID
		d ..GetEPRTreeJSON(episodeID)
	}
	elseif (action = "doclist")
	{
		//
		d ..GetDocListJSON(paramDoc,startRow,endRow)
	}
	elseif (action = "givepower")
	{
		w ..GivePower(appointSpan,appointCateCharpter,appointUserID,eprActions,userID,ctLocID,episodeID)	
	}
	elseif (action = "history")
	{
		d ..GetHistoryJSON(isValid,startRow, endRow)	
	}
	elseif (action = "withdraw")
	{
		w ..Withdraw(appointIDs)	
	}
	else
	{
		d ..GetEPREpisodeListJSON(param, startRow, endRow)
	}
	
	Quit $$$OK
}

/// Debug:	d ##Class(web.eprajax.GivePower).Withdraw("")
ClassMethod Withdraw(AApointIDS As %String)
{
	s count = $l(AApointIDS,"^")
	s flag = 0
	for index=1:1:count
	{
		s appointID = $p(AApointIDS,"^",index)
		s appoint = ##class(EPRinstance.EPRActionAppoint).%OpenId(appointID)
		if (appoint = "")
		{
			s flag = 1
			q	
		}
	
		//b "s"
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)

		s endDate = appoint.AppointEndDate
		s endTime = appoint.AppointEndTime
		
		//已过期则不操作
		continue:(endDate < date)
		continue:((endDate = date) && (endTime < time))

		//未过期设过期时间为当前时间
		s appoint.AppointEndDate = date
		s appoint.AppointEndTime = time
	
		s sc = appoint.%Save()
		d appoint.%Close()
	
		s:('$$$ISOK(sc)) flag = 1
	}
	q:(flag = 1) "-1"
	q "1"
}

/// Debug:	d ##Class(web.eprajax.GivePower).GivePower("24","","","","","","")
ClassMethod GivePower(AAppointSpan, AAppointCateCharpter, AAppointUserID, AEprActions, AUserID, ACTLocID, AEpisodeID)
{
	s count = $l(AEprActions,"^")
	s flag = 0
	for index=1:1:count
	{
		s appoint = ##class(EPRinstance.EPRActionAppoint).%New()
		if (appoint = "")
		{
			s flag = 1
			q	
		}
	
		b "s"
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		s appoint.RequestDate = date
		s appoint.RequestTime = time
		s appoint.AppointDate = date
		s appoint.AppointTime = time
		
		s timeSpan = +(+AAppointSpan * 3600)
	
		s EndDateTime = ..GetEndDateTime(date,time,timeSpan)
		s appoint.AppointEndDate = $p(EndDateTime,",",1)
		s appoint.AppointEndTime = $p(EndDateTime,",",2)
		s appoint.AppointCateCharpter = AAppointCateCharpter
		s appoint.RequestCateCharpter = AAppointCateCharpter
		s appoint.AppointUserID = AAppointUserID
		s appoint.AppointStatus = "G"
		s appoint.EpisodeID = AEpisodeID
		s appoint.RequestUserID = AUserID
		s appoint.RequestDept = ACTLocID

		s appoint.EPRAction = $p(AEprActions,"^",index)

		s appoint.AppointType = "0"
	
		s sc = appoint.%Save()
		d appoint.%Close()
	
		s:('$$$ISOK(sc)) flag = 1
	}
	q:(flag = 1) "-1"
	q "1"
}

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

/// Debug:	d ##Class(web.eprajax.GivePower).GetHistoryJSON("1","20")
ClassMethod GetHistoryJSON(AIsValid As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	

 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
 	s rowID = ""
 	
	for {
		s rowID = $o(^DHCEPRI.EPRActionAppointI("IdxAstatus", " G", rowID), -1)
		q:(rowID = "")
		
		//b "s"
		s obj = ##class(EPRinstance.EPRActionAppoint).%OpenId(rowID)
		
		s isValidText = "生效中"
		s isValid = "active"
		if (obj.AppointEndDate< $p($h,",",1))
		{ 
			s isValid = "past"
			s isValidText = "过期"
		}
		if ((obj.AppointEndDate = $p($h,",",1)) && (obj.AppointEndTime < $p($h,",",2)))
		{ 
			s isValid = "past"
			s isValidText = "过期"
		}
		
		continue:((AIsValid '= "all") && (AIsValid '= isValid) )
		
	 	s count = count + 1		
	 	if ( count >= AIdxStart) && (count <= AIdxLast)
		{
			s desc = ""
			s length = $l(obj.AppointCateCharpter,"^")
			for index=1:1:length
			{
				if (desc = "") {
					s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD($p(obj.AppointCateCharpter,"^",index))),8)
				}
				else {
					s desc = desc_" "_$list($g(^DHCEPRM.EPRTemplateCategoryD($p(obj.AppointCateCharpter,"^",index))),8)
				}
			}
			
			
			s PatientID = $p($g(^PAADM(obj.EpisodeID)),"^",1)
			s PAAdmType = $p($g(^PAADM(obj.EpisodeID)),"^",2)   
			//就诊类型
			if PAAdmType = "I"
			{
				s PAAdmType = "住院"
			}elseif PAAdmType = "O"
			{
				s PAAdmType = "门诊"
			}elseif PAAdmType = "E"
			{
				s PAAdmType = "急诊"
			}
			//病人姓名
			s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
			//登记号
			s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

			s RequestUser = ""
			if (obj.RequestUserID '= "")
			{
				s requestUserID = obj.RequestUserID
				&sql(select TOP 1 SSUSR_Name into :RequestUser from SQLUser.SS_User where SSUSR_RowId = :requestUserID)
			}
			s AppointUser = ""
			if (obj.AppointUserID '= "")
			{
				s appointUserID = obj.AppointUserID
				&sql(select TOP 1 SSUSR_Name into :AppointUser from SQLUser.SS_User where SSUSR_RowId = :appointUserID)

			}

			s RequestUserCTLocID = obj.RequestDept
			s RequestUserCTLocName = $P($g(^CTLOC(RequestUserCTLocID)),"^",1)
			
			s eprAction = obj.EPRAction
			s eprActionText = ""
			if (eprAction = "view")
			{
                s eprActionText = "界面模板浏览"

            }
            elseif (eprAction = "save")
            {
	            s eprActionText = "保存"
            }
    		elseif (eprAction = "print")
            {
	            s eprActionText = "打印"
            }
			elseif (eprAction = "commit")
            {
	            s eprActionText = "提交"
            }
			elseif (eprAction = "switch")
            {
	            s eprActionText = "选择模板"
            }    
			elseif (eprAction = "switchtemplate")
            {
	            s eprActionText = "更新模板"
            }   
			elseif (eprAction = "chiefcheck")
            {
	            s eprActionText = "主任医师签名"
            } 
			elseif (eprAction = "attendingcheck")
            {
	            s eprActionText = "主治医生签名"
            } 
 			elseif (eprAction = "browse")
            {
	            s eprActionText = "病历浏览"
            } 
			
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""AppointID"":"""_rowID_""",")
			w ..TrimEnter("""EpisodeID"":"""_obj.EpisodeID_""",")
			w ..TrimEnter("""EpisodeID"":"""_obj.EpisodeID_""",")
			w ..TrimEnter("""PatientID"":"""_PatientID_""",")
			w ..TrimEnter("""PAAdmType"":"""_PAAdmType_""",")
			w ..TrimEnter("""PAPMIName"":"""_PAPMIName_""",")
			w ..TrimEnter("""PAPMINO"":"""_PAPMINO_""",")
			w ..TrimEnter("""AppointDateTime"":"""_$zd(obj.AppointDate,3)_" "_$zt(obj.AppointTime,3)_""",")
			w ..TrimEnter("""AppointEndDateTime"":"""_$zd(obj.AppointEndDate,3)_" "_$zt(obj.AppointEndTime,3)_""",")
			w ..TrimEnter("""AppointUserID"":"""_obj.AppointUserID_""",")	
			w ..TrimEnter("""AppointUserName"":"""_AppointUser_""",")			
			w ..TrimEnter("""AppointCateCharpter"":"""_obj.AppointCateCharpter_""",")
			w ..TrimEnter("""AppointCateCharpterText"":"""_desc_""",")
			w ..TrimEnter("""EPRAction"":"""_obj.EPRAction_""",")
			w ..TrimEnter("""EPRActionText"":"""_eprActionText_""",")
			w ..TrimEnter("""IsValid"":"""_isValidText_""",")
			w ..TrimEnter("""RequestUserName"":"""_RequestUser_""",")
			w ..TrimEnter("""RequestUserCTLocID"":"""_RequestUserCTLocID_""",")
			w ..TrimEnter("""RequestUserCTLocName"":"""_RequestUserCTLocName_""",")
			w ..TrimEnter("""RequestUserID"":"""_obj.RequestUserID_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(web.eprajax.GivePower).GetEPRTreeJSON("919352")
ClassMethod GetEPRTreeJSON(AEpisodeID)
{
	//insert into EPRmeta.SysOption (Description,IsVisible,Name,OptionValue) Values ("授权|直接授权时默认不勾选的模板CategoryChapterID集合，以^分隔","Y","DirectCategoryChapterIDS","101^102")
	w "[{"
	w """id"":""RT00"","
	w """type"":""RT"","
	w """text"":""授权范围"","
	w """children"":"
	s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID)
	
	//遍历根节点的第一层目录(Category类型)
	s parentId = " 0"
	s curCategoryId = ""
	s count = 0
	w "["
	for {
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
		q:(curCategoryId="")
			
		s isEPRCateActive = ..IsEPRCateogryActived(curCategoryId)
		continue:(isEPRCateActive = "0")
		
		s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryId)),8)
		s count = count + 1
		
		if count>1 w ","
		w "{"
		w ..TrimEnter("""id"":"""_curCategoryId_""",")
		w ..TrimEnter("""type"":""cg"",")
		w ..TrimEnter("""text"":"""_desc_""",")
		w """children"":"
		w "["
		
		//遍历第二层节点(CategoryChapter)
		s curCategoryChapterId = ""
		s countSec = 0
		for {
			s curCategoryChapterId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryId, curCategoryChapterId))
			q:(curCategoryChapterId="")
			
			//b "s"
			//是否有可用的界面模板
			s validDocID = ##class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(AEpisodeID, "", curCategoryChapterId, isTplPrivActive, curPatInfo)
			continue:(validDocID = "")
			
			s hasImage = ..IsHasImage(AEpisodeID, curCategoryId, curCategoryChapterId)
			
			//是否写过
			s prtID =""
			s flag = "false"
			for {
				//b "s"
				s prtID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryChapterId, prtID))
				q:(prtID = "")
				s isSaved = ..IsSaved(AEpisodeID, prtID)
				if (isSaved = "1"){
					s flag = "true"
					q	
				}
			}
			continue:(flag="false")
			
			s DirectCategoryChapterIDS = ##class(EPRmeta.SysOption).GetOptionValueByName("DirectCategoryChapterIDS")
			s idsLength = $l(DirectCategoryChapterIDS,"^")
			s finded = 0
			for index=1:1:idsLength
			{
				s id = $p(DirectCategoryChapterIDS,"^",index)
				if (curCategoryChapterId = id)
				{
					s finded = 1
					q
				}
			}
			
			s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryChapterId)),8)
			
			s countSec = countSec + 1
			
			if countSec > 1 {w ","}
			w "{"
			w ..TrimEnter("""id"":"""_curCategoryChapterId_""",")
			w ..TrimEnter("""type"":""cc"",")
			if (finded = 0)
			{
				w ..TrimEnter("""checked"":""true"",")
			}
			w ..TrimEnter("""text"":"""_desc_"""")
			w "}"	
		}
			
			
		w "]"
		w "}"
	}	
	w "]"
	w "}]" //root
}

/// Debug:	d ##Class(web.eprajax.GivePower).GetDocListJSON("田^^^110",1,20)
/// Debug:	d ##Class(web.eprajax.GivePower).GetDocListJSON("^^^108",1,20",1,20)
ClassMethod GetDocListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	
 	s AUserName = $p(AParam,"^",1)
	s AUserCode = $p(AParam,"^",2)
	s AGroupID = $p(AParam,"^",3)
    s ACTLocID = $p(AParam,"^",4)
	
	s result = ##Class(%ResultSet).%New("web.eprajax.GivePower:GetUser")
	s sc = result.Execute(AUserName, AUserCode, AGroupID, ACTLocID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
	 	if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""SSUserID"":"""_$g(result.Data("SSUserID"))_""",")
			w ..TrimEnter("""UserName"":"""_$g(result.Data("UserName"))_""",")
			w ..TrimEnter("""UserCode"":"""_$g(result.Data("UserCode"))_""",")
			w ..TrimEnter("""CTLocID"":"""_$g(result.Data("CTLocID"))_""",")			
			w ..TrimEnter("""SSGroupID"":"""_$g(result.Data("SSGroupID"))_""",")
			w ..TrimEnter("""CTLoc"":"""_$g(result.Data("CTLoc"))_""",")
			w ..TrimEnter("""SSGroup"":"""_$g(result.Data("SSGroup"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(web.eprajax.GivePower).GetEPREpisodeListJSON("^^7^^","1","20")
ClassMethod GetEPREpisodeListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	//b "s"
	s result = ##Class(%ResultSet).%New("web.eprajax.GivePower:GetPatientList")
	s sc = result.Execute(AParam)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
	 	if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")			
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
			w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
			w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
			w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")			
			w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")
			w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
			w ..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// do ##class(%ResultSet).RunQuery("web.eprajax.GivePower","GetPatientList","193^^^^")
Query GetPatientList(AParam As %String) As %Query(ROWSPEC = "PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String,MedicareNo:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s ALocID = $p(AParam,"^",3)
    s AWard = $p(AParam,"^",4)
	s AAdmNo = $p(AParam,"^",5)
	s ARegNo = $p(AParam,"^",6)
	s AMedicareNo = $p(AParam,"^",7)
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= ""){
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
			d OutPutRow 		
		}

	}
	elseif (APatientID '= ""){
		s PAPMI = APatientID
		d OutPutPAMI
	}
 	elseif (ARegNo '= ""){
	 	s ARegNo = ..AddZero(ARegNo)
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}
	//add by niucaicai 2015-10-08 按病案号查询
	elseif (AMedicareNo '= "")
	{
		s patientID = $o(^PAPERi("Medicare1",AMedicareNo,""))
		if (patientID = "")
		{
			s patientID = ##Class(web.DHCWMRService).IGetPatientIDByMrNo(AMedicareNo)
		}
		s PAPMI = patientID
		q:(PAPMI = "") $$$OK
	 	d OutPutPAMI
	}
	elseif (APatientName '= ""){ 
		s PAPMI = ""
		for {
		   s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
		   q:(PAPMI = "")
		   d OutPutPAMI
	    }	 
	}
	elseif(AWard '= ""){
		s RowID = ""
		for {
			 s RowID = $o(^PAADMi("CurrWard",AWard,RowID))
			 q:(RowID = "")
			 s PAAdm = ""
			 for {
				 s PAAdm = $o(^PAADMi("CurrWard",AWard,RowID,PAAdm))
				 q:(PAAdm = "")
		         d OutPutRow 
			 }
		}		
	}
	else{
		//科室
		s TempDate = ""
		for {
			s TempDate = $o(^PAADMi("DepDateTime",ALocID,TempDate))
			q:(TempDate = "")
			s TempTime = ""
			for {
				s TempTime = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime))
				q:(TempTime = "")
				s PAAdm = ""
				for {
					s PAAdm = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime,PAAdm))
					q:(PAAdm = "")
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
		     d OutPutRow
		}
	}
	q
	
OutPutRow
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
	//就诊类型
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	//病案号  add by niucaicai 2016-3-31
	s MedicareNo = $P($g(^PAPER(PatientID,"PAT",1)),"^",22)
	if (MedicareNo = "")
	{
		s MedicareNo = ##Class(web.DHCWMRService).IGetMrNoByPatientID(PatientID)
	} 

	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
 	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	//职业
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",1)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",1)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	s ^CacheTemp("PAStatusType") = PADischgeDateTime_"||"_PAStatusType
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
 	s data = $lb(PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID,MedicareNo)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter    
    if AWard = $c(0) s AWard = ""
    if AWard '= ""
    {
       s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
       if TempWard '= "" s AWard = TempWard
    }
    if APatientID = $c(0) s APatientID = ""
    if ARegNo = $c(0) s ARegNo = ""
    if APatientName = $c(0) s APatientName = ""
    if ALocID = $c(0) s ALocID = ""
    if AAdmNo = $c(0) s AAdmNo = ""
    if AMedicareNo = $c(0) s AMedicareNo = ""

    q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
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

/// do ##class(%ResultSet).RunQuery("web.eprajax.GivePower","GetUser","","","","")
Query GetUser(AUserName As %String, AUserCode As %String, AGroupID As %String, ACTLocID As %String) As %Query(ROWSPEC = "SSUserID:%String,UserName:%String,UserCode:%String,CTLocID:%String,SSGroupID:%String,CTLoc:%String,SSGroup:%String")
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary, AUserName As %String, AUserCode As %String = "", AGroupID As %String, ACTLocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AUserName = $c(0)) AUserName = ""
	s:(AUserCode = $c(0)) AUserCode = ""
	s:(AGroupID = $c(0)) AGroupID = ""
	s:(ACTLocID = $c(0)) ACTLocID = ""
    s HospitalID=$g(%session.Data("LOGON.HOSPID"))
	if (AUserCode '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByUserCode")
		s sc = rset.Execute(AUserCode)
	}
	
	elseif (ACTLocID '= "")&&(AGroupID '= "")&&(AUserName '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByCTLocIDSSGroupIDName")
		s sc = rset.Execute(ACTLocID,AGroupID,"%"_AUserName_"%")	
	}
	
	elseif (AUserName '= "")&&(AGroupID '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByUserNameAndGroupID")
		s sc = rset.Execute("%"_AUserName_"%",AGroupID)		
	}
	elseif (AUserName '= "")&&(ACTLocID '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByCTLocIDAndUserName")
		s sc = rset.Execute(ACTLocID,"%"_AUserName_"%")		
	}
	
	elseif (ACTLocID '= "")&&(AGroupID '= "")
	{

		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByCTLocIDAndSSGroupID")
		s sc = rset.Execute(ACTLocID,AGroupID)	
	}
	elseif (AUserName '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByUserName")
		s sc = rset.Execute("%"_AUserName_"%",HospitalID)		
	}
	elseif (AGroupID '= "")
	{
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectBySSGroupID")
		s sc = rset.Execute(AGroupID)	
	}
	elseif (ACTLocID '= "")
	{
		
		s rset = ##Class(%ResultSet).%New("web.eprajax.GivePower:SelectByCTLocID")
		s sc = rset.Execute(ACTLocID)
	}
	else
	{
		q $$$OK
	}
	
	while (rset.Next())
	{
		s SSUserID = rset.Data("ID")
		s UserName = rset.Data("Name")
		s UserCode = rset.Data("Code")
		s CTLocID = rset.Data("CTLocID")
		continue:((ACTLocID '= "") && (ACTLocID '= CTLocID))
		s SSGroupID = rset.Data("SSGroupID")
		continue:((AGroupID '= "") && (AGroupID '= SSGroupID))
		s CTLoc = rset.Data("CTLOC") 
		s SSGroup = rset.Data("SSGroup")	

		s ^CacheTemp(repid,ind) = $lb(SSUserID,UserName,UserCode,CTLocID,SSGroupID,CTLoc,SSGroup)
	    s ind=ind+1	
   }	
   Quit $$$OK
}

ClassMethod GetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

Query SelectByCTLocID(ACTLocID As %String) As %SQLQuery
{
	
	/*
		//将默认科室修改为所有关联此科室的医生
	  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
		from SQLUser.SS_User  
		where SSUSR_DefaultDept_DR = :ACTLocID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
		order by SSUSR_name
	*/
	
	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, :ACTLocID as CTLocID, SSUSR_Group as SSGroupID,  (select CTLOC_Desc from SQLUser.CT_Loc where CTLOC_RowID=:ACTLocID) as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	WHERE SSUSR_Initials IN (SELECT Res_Code FROM SQLUser.RB_Resource WHERE RES_CTLOC_DR=:ACTLocID) and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByCTLocIDAndUserName(ACTLocID As %String, AUserName As %String) As %SQLQuery
{

	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, :ACTLocID as CTLocID, SSUSR_Group as SSGroupID,  (select CTLOC_Desc from SQLUser.CT_Loc where CTLOC_RowID=:ACTLocID) as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	WHERE SSUSR_Initials IN (SELECT Res_Code FROM SQLUser.RB_Resource WHERE RES_CTLOC_DR=:ACTLocID) and SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

/// d ##class(%ResultSet).RunQuery("web.eprajax.GivePower","SelectByCTLocIDAndSSGroupID",108,29)
Query SelectByCTLocIDAndSSGroupID(ACTLocID As %String, ASSGroupID As %String) As %SQLQuery
{
	
	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, :ACTLocID as CTLocID, SSUSR_Group as SSGroupID,  (select CTLOC_Desc from SQLUser.CT_Loc where CTLOC_RowID=:ACTLocID) as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	WHERE SSUSR_Initials IN (SELECT Res_Code FROM SQLUser.RB_Resource WHERE RES_CTLOC_DR=:ACTLocID) and SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByCTLocIDSSGroupIDName(ACTLocID As %String, ASSGroupID As %String, AUserName As %String) As %SQLQuery
{
	
	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, :ACTLocID as CTLocID, SSUSR_Group as SSGroupID,  (select CTLOC_Desc from SQLUser.CT_Loc where CTLOC_RowID=:ACTLocID) as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	WHERE SSUSR_Initials IN (SELECT Res_Code FROM SQLUser.RB_Resource WHERE RES_CTLOC_DR=:ACTLocID) and SSUSR_Group = :ASSGroupID and SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserName(AUserName As %String, AHospitalID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') and SSUSR_Hospital_DR =:AHospitalID
	order by SSUSR_name
}

Query SelectByUserNameAndGroupID(AUserName As %String, ASSGroupID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Name like :AUserName and SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserCode(AUserCode As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Initials = :AUserCode and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectBySSGroupID(ASSGroupID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
  	from SQLUser.SS_User
	where SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes')
	
	order by SSUSR_name
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

/// debug: w ##class(web.eprajax.GivePower).IsSaved(2616503,103)
ClassMethod IsSaved(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	/*
	s eprLogsID = ""
	&sql(select top 1 ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :APrintTemplateDocID)
	
	q:(eprLogsID = "")||(eprLogsID = $c(0)) "0"
	q "1"
	*/
	s ret = ##class(EPRservice.Privilege.BOPrivAssist).IsRecordFinishedNew(AEpisodeID,APrintTemplateDocID,"1")
	q ret
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

}
