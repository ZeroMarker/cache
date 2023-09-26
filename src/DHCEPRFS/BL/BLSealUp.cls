Class DHCEPRFS.BL.BLSealUp Extends %RegisteredObject [ ProcedureBlock ]
{

/// 注册封存信息，封存序号由归档系统管理
/// w ##Class(DHCEPRFS.BL.BLSealUp).RegSealUpByAdm("583","131","医疗纠纷","张三","夫妻","133","112112","张二","110001")
ClassMethod RegSealUpByAdm(AEpisodeID As %String, ASealUpDocID As %String, ASealReason As %String, ASealUpName As %String, ASealUpRelation As %String, ASealUpDeptID As %String = "", ASealUpPhone As %String = "", ASealUpPatientName As %String = "", ASealUpPatientPhone As %String = "", AVersionNum As %Integer = 0) As %String
{
	//b "s"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "-1"
	
	s curNo = ..GetMaxSealNo(mrEpisodeID)
	s maxNo = curNo + 1
	
	s $zt = "OnRegSealUpByAdmError"
	
	tstart
	
	s id = ..RegSealUp(mrEpisodeID, ASealUpDocID, ASealReason, ASealUpName, ASealUpRelation,ASealUpDeptID,ASealUpPhone,ASealUpPatientName,ASealUpPatientPhone, maxNo,AVersionNum)
	if (id = "") 
	{
		trollback
		q "-2"
	}
	
	s taskid = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateSealUpTask(id)
	if (taskid = "")
	{
		trollback
		q "-3"
	}
	
	tcommit
	
	q id
	
OnRegSealUpByAdmError
	trollback
	q "-9"
}

/// 注册封存信息，封存序号由第三方系统管理，需要校验传入的封存序号是否已经做过封存
/// w ##Class(DHCEPRFS.BL.BLSealUp).RegSealUpByNo("17","3","医疗纠纷","张三","夫妻","2")
ClassMethod RegSealUpByNo(AEpisodeID, ASealUserID, ASealReason, ASealName, ASealRelation, ASealNo) As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "-1"
	
	s id = ..GetIDBySealNo(mrEpisodeID, ASealNo)
	q:(id '= "") "-2"
	
	s $zt = "OnRegSealUpByNoError"
	
	tstart
	
	s id = ..RegSealUp(mrEpisodeID, ASealUserID, ASealReason, ASealName, ASealRelation, ASealNo)
	if (id = "") 
	{
		trollback
		q "-3"
	}
	
	
	s taskid = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateSealUpTask(id)
	if (taskid = "")
	{
		trollback
		q "-4"
	}
	
	tcommit
	
	q id
	
OnRegSealUpByNoError
	trollback
	q "-9"
}

/// 解封指定就诊的所有封存记录
/// w ##Class(DHCEPRFS.BL.BLSealUp).UnSealByAdm("59","4")
ClassMethod UnSealByAdm(AEpisodeID, AUnSealUserID) As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "0"
	
	s idList = ..GetIDList(mrEpisodeID)
	q:(idList = "") "0"
	
	s count = $L(idList,"^")
	for i = 1:1:count
	{
		do ..UnSeal($p(idList,"^",i), AUnSealUserID)
	}
	
	d ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).RemoveSpcl("DHC",AEpisodeID,AUnSealUserID,"SEALUP")
	q "1"
}

/// 解封指定就诊指定封存序号的封存记录
/// w ##Class(DHCEPRFS.BL.BLSealUp).UnSealByNo("17","4","2")
ClassMethod UnSealByNo(AEpisodeID, AUnSealUserID, ASealNo) As %String
{
	//b "s"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "0"
	
	s id = ..GetIDBySealNo(mrEpisodeID,ASealNo)
	q:(id = "") "0"
	
	s obj = ##Class(DHCEPRFS.INST.MRSealUp).%OpenId(id)
	q:(obj.SealStatus = "UNSEALED") "0"
	
	s sc = ..UnSeal(id, AUnSealUserID)
	
	q sc
}

ClassMethod RegSealUp(AMREpisodeID As %String, ASealUserID As %String, ASealReason As %String, ASealName As %String, ASealRelation As %String, ASealUpDeptID As %String, ASealUpPhone As %String, ASealUpPatientName As %String, ASealUpPatientPhone As %String, ASealNo As %Integer, AVersionNum As %Integer = 0) As %String
{
	s obj = ##Class(DHCEPRFS.INST.MRSealUp).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.SealUpReason = ASealReason
	s obj.SealUpName = ASealName
	s obj.SealUpPhone = ASealUpPhone
	s obj.SealUpRelation = ASealRelation
	s obj.SealUpDocID = ASealUserID
	s obj.SealUpDeptID = ASealUpDeptID
	s obj.SealUpPatientName = ASealUpPatientName
	s obj.SealUpPatientPhone = ASealUpPatientPhone
	s obj.SealUpDate = $p($h,",",1)
	s obj.SealUpTime = $p($h,",",2)
	s obj.SealNo = ASealNo
	s obj.SealStatus = "SEALED"
	s obj.VersionNum = AVersionNum
	s sc =  obj.%Save()
	
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UnSeal(AMRSealUpID, AUnSealUserID) As %String
{
	s obj = ##Class(DHCEPRFS.INST.MRSealUp).%OpenId(AMRSealUpID)
	q:(obj = "") "0"
	
	q:(obj.SealStatus = "UNSEALED") "1"
	
	s obj.UnSealUserID = AUnSealUserID
	s obj.UnSealDate = $p($h,",",1)
	s obj.UnSealTime = $p($h,",",2)
	s obj.SealStatus = "UNSEALED"
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod GetMaxSealNo(AMREpisodeID) As %String
{
	s maxNo = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo", " "_AMREpisodeID, ""),-1)
	q maxNo
}

ClassMethod GetIDBySealNo(AMREpisodeID, ASealNo) As %String
{
	s id = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo", " "_AMREpisodeID, ASealNo,""))
	q id
}

ClassMethod GetIDList(AMREpisodeID) As %String
{
	s idList = ""
	
	s no = ""
	for {
		s no = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo", " "_AMREpisodeID, no))
		q:(no = "")
		
		s id = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo", " "_AMREpisodeID, no,""))
		if (idList = "")
		{	s idList = id}
		else
		{	s idList = idList_"^"_id}
	}
	
	q idList
}

/// Desc：通过归档就诊号获取封存记录
/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLSealUp","GetSealListByAdm","21")
Query GetSealListByAdm(AMREpisodeID As %String) As %Query(ROWSPEC = "sealStatus:%String,sealUpDoc:%String,sealUpDept:%String,sealUpPatientName:%String,sealUpPatientPhone:%String,sealUpName:%String,sealUpPhone:%String,sealUpRelation:%String,sealUpDate:%String,sealUpTime:%String,sealVersionNum:%Integer,unSealDate:%String,unSealTime:%String")
{
}

ClassMethod GetSealListByAdmExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID="") $$$OK
	
	//b "s"
	s sealNo=""
	for {
		//b "s"
		s sealNo=$o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo"," "_AMREpisodeID,sealNo))
		q:(sealNo="")
		s rowID = ""
		for{
			//b "s"
			s rowID =$o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo"," "_AMREpisodeID,sealNo,rowID))
			q:(rowID="")
			
			s obj = ##Class(DHCEPRFS.INST.MRSealUp).%OpenId(rowID)
			s sealStatus = obj.SealStatus
			if (sealStatus = "SEALED")
			{
				s sealStatus = "封存"
			}elseif (sealStatus = "UNSEALED")
			{
				s sealStatus = "解封"
			}else
			{
				s sealStatus = ""
			}
			s sealUpDocID = obj.SealUpDocID
			s sealUpDoc =""
			s rowIDDoc = ""
			&sql(select CTPCP_Desc into :sealUpDoc from SQLUser.CT_CareProv where CTPCP_RowId1 =:sealUpDocID)
			s sealUpDeptID = obj.SealUpDeptID
			s sealUpDept = ""
			&sql(select CTPCP_Desc into :sealUpDept from SQLUser.CT_CareProv where CTPCP_RowId1 =:sealUpDeptID)
			//b "s"
			s sealUpPatientName = obj.SealUpPatientName
			s sealUpPatientPhone = obj.SealUpPatientPhone
			s sealUpName = obj.SealUpName
			s sealUpPhone = obj.SealUpPhone
			s sealUpRelation = obj.SealUpRelation
			s sealUpDate = obj.SealUpDate
			If (sealUpDate '= "")
			{
				s sealUpDate = $ZD(sealUpDate,3)
			}
			s sealUpTime = obj.SealUpTime
			If (sealUpTime '= "")
			{
				s sealUpTime = $Zt(sealUpTime,3)
			}
			
			s unSealDate = obj.UnSealDate
			If (unSealDate '= "")
			{
				s unSealDate = $ZD(unSealDate,3)
			}
			
			s unSealTime = obj.UnSealTime
			If (unSealTime '= "")
			{
				s unSealTime = $Zt(unSealTime,3)
			}
			s sealVersionNum = obj.VersionNum
			
			s ^CacheTemp(repid,ind) = $lb(sealStatus,sealUpDoc,sealUpDept,sealUpPatientName,sealUpPatientPhone,sealUpName,sealUpPhone,sealUpRelation,sealUpDate,sealUpTime,sealVersionNum,unSealDate,unSealTime)
			s ind=ind+1			
		}
	}		
   	
   Quit $$$OK
}

ClassMethod GetSealListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSealListByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSealListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSealListByAdmExecute ]
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

/// Desc: 通过就诊号得到封存的最后一次版本号（入参EpisodeID）
/// Debug:	w ##Class(DHCEPRFS.BL.BLSealUp).GetVersionNum("21")
ClassMethod GetVersionNum(AEpisodeID As %String) As %Integer
{
	s versionNum = 0
	s flag = "0"
	s sealUpDate = ""
	for{
		s sealUpDate = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnVersionNum", " "_AEpisodeID, sealUpDate),-1)
		q:(sealUpDate="")
		q:(flag = "1")
		s sealUpTime = ""
		for{
			s sealUpTime = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnVersionNum", " "_AEpisodeID, sealUpDate,sealUpTime),-1)
			q:(sealUpTime = "")
			q:(flag = "1")
			s rowID = ""
			for{
				s rowID = $o(^DHCEPRFS.INST.MRSealUpI("IdxOnVersionNum", " "_AEpisodeID, sealUpDate,sealUpTime,rowID))			
				q:(rowID = "")
				q:(flag = "1")
				s obj = ##class(DHCEPRFS.INST.MRSealUp).%OpenId(rowID)
				s versionNum = obj.VersionNum
				if (versionNum = "")||(versionNum =$c(0))
				{
					s versionNum = 0
				}
				s flag = "1"
			}
		}
	}
	q versionNum
}

/// Desc: 通过就诊号得到是否有孩子（入参EpisodeID）
/// Debug:	w ##Class(DHCEPRFS.BL.BLSealUp).GetVersionNum("21")
ClassMethod CheckchildEpisodeID(AEpisodeID As %String) As %String
{
	s episodeID = ""
	s childEpisodeID = 	""
	for {
		s childEpisodeID = $o(^PAADMi("Mother",AEpisodeID,childEpisodeID)) 	
		q:(childEpisodeID = "")
		if (episodeID = "")
		{
			s episodeID = childEpisodeID
		}
		else
		{
			s episodeID = episodeID_"_"_childEpisodeID
		}
	}
	q episodeID
}

}
