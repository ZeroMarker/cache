Class DHCEPRFS.web.eprajax.AdmMRStatusMgr Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"")
	s actionType = $Get(%request.Data("ActionType",1),"")
	s remarks = $Get(%request.Data("Remarks",1),"")
	s remarksDesc = $Get(%request.Data("RemarksDesc",1),"")
	s remarksID = $Get(%request.Data("RemarksID",1),"")
	
	if (actionType = "getdetail")
	{
		do ..GetDetail(episodeID)
	}
	elseif (actionType = "loadremarks")
	{
		d ..LoadSubmitRemarksJSON(userID)
	}
	elseif (actionType = "addremarks")
	{
		d ..AddSubmitRemarks(userID,remarksDesc,remarks)
	}
	elseif (actionType = "saveremarks")
	{
		d ..SaveSubmitRemarks(remarksID,remarks)
	}
	elseif (actionType = "removeremarks")
	{
		d ..RemoveSubmitRemarks(remarksID)
	}
	elseif (actionType = "lastremarks")
	{
		d ..GetLastSubmitRemarks(episodeID)
	}
	elseif (actionType = "getpaperitems")
	{
		d ..GetPaperItemsJSON(episodeID)
	}
	elseif (actionType = "nurse")
	{
		s ret = ..UpdateNurseAdmMRStatus(episodeID, userID)
		w ret
	}
	elseif (actionType="nurSubmitBatch")
	{
		s ret = ..UpdateNurseAdmBatchMRStatus(episodeID,userID)
		w ret
	}
	else
	{
		s ret = ..UpdateAdmMRStatus(episodeID, userID, remarks)
		w ret
	}
	Quit $$$OK
}

/// Creator:houj
/// CreateDate:2013-05-07
/// Desc:	更新最终结算状态
/// Debug：	w ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).UpdateNurseAdmMRStatus()
ClassMethod UpdateNurseAdmMRStatus(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(AEpisodeID,AUserID)
	if (ret = "1")
	{
		q "1"
	}
	else
	{
		q "-1"
	}
}

/// Creator:houj
/// CreateDate:2013-05-07
/// Desc:	更新病历状态
/// Debug：	w ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).UpdateAdmMRStatus()
ClassMethod UpdateAdmMRStatus(AEpisodeID As %String, AUserID As %String, ARemarks As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,"Y","Y",ARemarks)
	if (ret = "1")
	{
		q "1"
	}
	else
	{
		q "-1"
	}
}

/// Desc:	更新病历状态
/// Debug：	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).GetDetail("10274902")
ClassMethod GetDetail(AEpisodeID As %String) As %String
{
	s rowId = ""
	s count = 0
	s startJson = "["
	w startJson
	
	s json = ""
	for{
		s rowId = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxEpisodeID"," DHC"," "_AEpisodeID,rowId))
		q:(rowId="") 
		
		s obj = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(rowId)
		s changeAct = obj.ChangeAct
		s changeType = obj.Type
		s changeTypeDesc = ""
		if (changeType = "DOCTOR")
		{
			s changeTypeDesc = "医生"	
		}
		elseif (changeType = "NURSE")
		{
			s changeTypeDesc = "护士"	
		}

		if (changeAct = "COMPLETE")
		{
			s changeTypeDesc = changeTypeDesc_"确认"	
		}
		elseif (changeAct = "QCBACK")
		{
			s changeTypeDesc = changeTypeDesc_"退回"	
		}
		
		s json = ..GetJson(changeTypeDesc,obj.ChangeDate,obj.ChangeTime,obj.ChangeUserID)
			
		if (count>0) w ","
		w json
		s count = count +1
		
	}
	
	s endJson = "]"
	w endJson
}

/*
/// Desc:	更新病历状态
/// Debug：	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).GetDetail("16217743")
ClassMethod GetDetail(AEpisodeID As %String) As %String
{
	s rowId = ""
	s count = 0
	s startJson = "["
	w startJson
	
	s json = ""
	for{
		s rowId = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxEpisodeID"," DHC"," "_AEpisodeID,rowId))
		q:(rowId="") 
		s obj = ##Class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(rowId)
		if ((obj.Type = "NURSE")&&(obj.ChangeAct = "COMPLETE"))
		{
			s json = ..GetJson("护士确认",obj.ChangeDate,obj.ChangeTime,obj.ChangeUserID)
			
			if (count>0) w ","
			w json
			s count = count +1
		}
	}
	if (json = "")
	{
		s entity = ##Class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusEntity(AEpisodeID,"DHC")
		q:(entity="") ""
		q:(entity.FlagFinalAccount '= "1")&&(entity.FlagMRCompletion '= "1") ""
	
		if (entity.FlagFinalAccount = "1")
		{
			s json = ..GetJson("护士确认",entity.FlagFinalAccountDate,entity.FlagFinalAccountTime,entity.FlagFinalAccountUserID)
			
			if (count>0) w ","
			w json
			s count = count +1
		}
	}
		
	s json = ""
	for{
		s rowId = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxEpisodeID"," DHC"," "_AEpisodeID,rowId))
		q:(rowId="") 
		s obj = ##Class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(rowId)
		if ((obj.Type = "DOCTOR")&&(obj.ChangeAct = "COMPLETE"))
		{
			s json = ..GetJson("医生确认",obj.ChangeDate,obj.ChangeTime,obj.ChangeUserID)
			
			if (count>0) w ","
			w json
			s count = count +1
		}
	}	
	if (json = "")
	{
		s entity = ##Class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusEntity(AEpisodeID,"DHC")
		q:(entity="") ""
		q:(entity.FlagFinalAccount '= "1")&&(entity.FlagMRCompletion '= "1") ""
		if (entity.FlagMRCompletion = "1")
		{
			b "s"
			s json = ..GetJson("医生确认",entity.FlagMRCompletionDate,entity.FlagMRCompletionTime,entity.FlagMRCompletionUserID)
			
			if (count>0) w ","
			w json
			s count = count +1
		}
	}
	
	s endJson = "]"
	w endJson
}
*/
ClassMethod GetJson(actDesc, actDate, actTime, actUser)
{
	if (actDate '= "") {s actDate =$zd(actDate,3) }
	if (actTime '= "") {s actTime =$zt(actTime,1) }
	if (actUser '= "") {s actUser = $p($g(^SSU("SSUSR",actUser)),"^",2)}

	s json = "{ActionDesc:'"_actDesc_"',"
	s json = json_"ActionUser:'"_actUser_"',"
	s json = json_"ActionDate:'"_actDate_"',"
	s json = json_"ActionTime:'"_actTime_"'}"
	
	q json
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).AddSubmitRemarks("159","test1","测试备注")
ClassMethod AddSubmitRemarks(AUserID As %String, ARemarksDesc As %String, ARemarks As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).AddSubmitRemarks(AUserID,ARemarksDesc,ARemarks)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).SaveSubmitRemarks("1","测试修改")
ClassMethod SaveSubmitRemarks(ARemarksID As %String, ARemarks As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveSubmitRemarks(ARemarksID,ARemarks)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).RemoveSubmitRemarks("1")
ClassMethod RemoveSubmitRemarks(ARemarksID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).RemoveSubmitRemarks(ARemarksID)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).LoadSubmitRemarksJSON("159")
ClassMethod LoadSubmitRemarksJSON(AUserID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLAdmMRStatus:LoadSubmitRemarks")
	s sc = result.Execute(AUserID)
	
 	s count = 0
 	s first = 1
 	w "["
 	
	While (result.Next())
 	{
	 	s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""RemarksID"":"""_$g(result.Data("RemarksID"))_""",")
		w ..TrimEnter("""RemarksCode"":"""_$g(result.Data("RemarksCode"))_""",")
		w ..TrimEnter("""RemarksDesc"":"""_$g(result.Data("RemarksDesc"))_""",")
		w ..TrimEnter("""Remarks"":"""_$g(result.Data("Remarks"))_"""")
		w "}"
		s first = 0
	}
	w "]"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).GetLastSubmitRemarks("601")
ClassMethod GetLastSubmitRemarks(AEpisodeID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetLastSubmitRemarks(AEpisodeID)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).GetPaperItemsJSON("601")
ClassMethod GetPaperItemsJSON(AEpisodeID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLAdmMRStatus:GetPaperItems")
	s sc = result.Execute(AEpisodeID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""ItemID"":"""_$g(result.Data("ItemID"))_""",")
		w ..TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
		w ..TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
		w ..TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
		w ..TrimEnter("""IsChecked"":"""_$g(result.Data("IsChecked"))_""",")
		w ..TrimEnter("""ItemPages"":"""_$g(result.Data("ItemPages"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// Desc: yangshun 2022-7-8 护士批量提交
ClassMethod UpdateNurseAdmBatchMRStatus(AEpisodeIDs As %String, AUserID As %String) As %String
{
	q:((AEpisodeIDs="")||(AUserID="")) "-1"
	s total = $L(AEpisodeIDs,"^")
	s success = 0
	ts
	for i=1:1:total
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC($P(AEpisodeIDs,"^",i),AUserID)
		if (ret = "1")
		{
			s success = success+1
		}
		else
		{
			q
		}
	}
	if (total=success)
	{
		tc
		q "1"
	}
	else
	{
		tro
		q "-1"
	}
}

}
