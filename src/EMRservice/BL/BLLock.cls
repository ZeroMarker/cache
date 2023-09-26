/// Desc:         病历锁逻辑类
/// Creator:       Candy
/// CreateDate: 2015-2-12
Class EMRservice.BL.BLLock Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加锁信息
/// Creator:    Candy	
/// CreateDate: 2015-2-13
/// Input:      AUserID 用户ID
///             AComputerName 计算机名
///             AUserLocID 用户科室ID
///             AUserCode 用户代码
///             AComputer 计算机
///             AAction 操作动作
///             ADocID  DocID
///             AInstanceID 实例ID 
///             ATempalteID 模板ID  
/// OutPut:     result 0:错误 、1 成功 、 "锁定信息"  
/// Debug:      w ##Class(EMRservice.BL.BLLock).Lock(105,"admin",6,337,"127.0.0.1","LOAD",76,616,"2||1",50,"114")
ClassMethod Lock(AUserID As %String, AComputerName As %String, AUserCode As %String, AComputer As %String, AAction As %String, AEpisodeID As %String, ADocID As %String, AInstanceID As %String, ATempalteID As %String, ASessionID As %String, AUserLocID As %String) As %String
{
	s result = "0"
	q:((AUserID = "")||(AEpisodeID = "")||(ADocID = "")) result
	
	s isEnableEditMultiRecord = ##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord()
	if (isEnableEditMultiRecord = "false")
	{
		q:(AInstanceID = "GuideDocument") ""
		s rowId = $o(^DHCEMRI.LockSpecialI("IdxDocInstance"," "_AEpisodeID," "_ADocID," "_AInstanceID,""))
	}
	else
	{
		s rowId = $o(^DHCEMRI.LockI("IdxMain"," "_ADocID," "_AEpisodeID,""))
	}
	
	s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objDoc = "") result
	s chapterId = objDoc.ParentCategoryID
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapterId)
	q:(objChapter = "") result
	s categoryId = objChapter.ParentCategoryID
	s objCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryId)
	
	if ((rowId '= ""))
	{
		if (isEnableEditMultiRecord = "false")
		{
			s objLock = ##Class(EMRinstance.LockSpecial).%OpenId(rowId)
			q:(objLock = "") result
			q:((objLock.UserID = AUserID)&&(objLock.Computer = AComputer)) "lock^"_rowId
		}
		s result = ..GetPrompt(rowId)
		q "locked^"_result
	}
	else
	{
		if (isEnableEditMultiRecord = "false")
		{
			s rowId = $o(^DHCEMRI.LockSpecialI("IdxCategory"," "_categoryId," "_AEpisodeID,""))
		}
		else
		{
			s rowId = $o(^DHCEMRI.LockI("IdxCategory"," "_categoryId," "_AEpisodeID,""))
		}
		if ((objChapter.IsMutex = "1")&&(rowId '= ""))
		{
			s result = ..GetPrompt(rowId)
			q "locked^"_result
		}
	}
	if (isEnableEditMultiRecord = "false")
	{
		s obj = ##Class(EMRinstance.LockSpecial).%New()
	}
	else
	{
		s obj = ##Class(EMRinstance.Lock).%New()
	}
	s obj.UserID =  AUserID
	s obj.UserLocID = AUserLocID
	s obj.EpisodeID = AEpisodeID
	s obj.Action = AAction
	s obj.CategoryID = categoryId
	s obj.ChapterID = chapterId
	s obj.ComputerName = AComputerName
	s obj.Computer = AComputer
	s obj.DocID = ADocID
	s obj.InstanceID = AInstanceID
	s obj.UserCode = AUserCode
	s obj.TemplateID = ATempalteID
	s obj.SessionID = ASessionID
	s obj.LockDate = $p($h,",",1)
	s obj.LockTime = $p($h,",",2)
	s:($$$ISOK(obj.%Save())) result = obj.%Id()
	k obj,objChapter,objDoc,objCategory
	q "lock^"_result
}

/// Desc:       取病历提示锁信息
/// Creator:    Candy
/// CreateDate: 2015-2-13
/// Input:      AId 就诊ID
/// Output      提示信息
ClassMethod GetPrompt(AId As %String) As %String
{
	s result = ""
	q:(AId = "") result
	if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
	{
		s obj = ##Class(EMRinstance.LockSpecial).%OpenId(AId)
	}
	else
	{
		s obj = ##Class(EMRinstance.Lock).%OpenId(AId)
	}
	q:(obj = "") result
	s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(obj.UserID)
	s userDeptDesc = $Case(obj.UserLocID,"":"",:$p(^CTLOC(obj.UserLocID),"^",2))
	s:($f(userDeptDesc,"-") '= 0) userDeptDesc = $p(userDeptDesc,"-",2)
	s result = obj.UserCode_"|"_userName_"|"_$zd(obj.LockDate,3)_" "_$zt(obj.LockTime)_"|"_obj.Computer_"|"_AId_"|"_obj.ComputerName_"|"_userDeptDesc
	q result
}

/// Desc:       解锁
/// Creator:    Candy
/// CreateDate: 2015-2-14
/// Input:      ALockID  锁ID
/// Output:     0 解锁失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLLock).UnLock(10)
ClassMethod UnLock(ALockID As %String) As %String
{
	s result = "0"
	q:(ALockID = "") result
	if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
	{
		if ($d(^DHCEMRI.LockSpecialD(ALockID))<=0) 
		{
			s result = "1"
			q result
		}
		s sc = ##Class(EMRinstance.LockSpecial).%DeleteId(ALockID)
	}
	else
	{
		if ($d(^DHCEMRI.LockD(ALockID))<=0) 
		{
			s result = "1"
			q result
		}
		s sc = ##Class(EMRinstance.Lock).%DeleteId(ALockID)
	}
	
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       Session解锁
/// Creator:    Candy
/// CreateDate: 2015-5-5
/// Input:      ASessionID  锁ID
/// Output:     0 解锁失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLLock).UnLockBySessionID("135fY5zy00")
ClassMethod UnLockBySessionID(ASessionID As %String) As %String
{
	s result = "0"
	q:(ASessionID = "") result
	s sessionId = $zcvt(ASessionID,"U")
	if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
	{
		s rowId = $o(^DHCEMRI.LockSpecialI("IdxSessionID"," "_sessionId,""))
	}
	else
	{
		s rowId = $o(^DHCEMRI.LockI("IdxSessionID"," "_sessionId,""))
	}
	
	if (rowId = "") 
	{
		//门诊病历锁
		s rowId = $o(^DHCEMRI.LockOpI("IdxSessionID"," "_sessionId,""))
		if (rowId = "") 
		{
			s result = "1"
			q result
		}
		else
		{
			s sc = ##Class(EMRinstance.LockOp).%DeleteId(rowId)
			s:($$$ISOK(sc)) result = "1"
			q result
		}
	}
	if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
	{
		s sc = ##Class(EMRinstance.LockSpecial).%DeleteId(rowId)
	}
	else
	{
		s sc = ##Class(EMRinstance.Lock).%DeleteId(rowId)
	}
	
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       显示病历锁信息
/// CreateDate: 2015-6-12
/// Input:      
/// Output:     锁信息
/// Debug:      w ##Class(EMRservice.BL.BLLock).GetLockList(1,10)
ClassMethod GetLockList(AIdxStart As %Integer, AIdxLast As %Integer, AUserName As %String = "", AIPAddress As %String = "", ADocName As %String = "", AType As %String = "IP") As %String
{
	s json = ""
	s result = ""
	s count = 0
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s rowId = ""
	for
	{
		//OP则查询门诊页面锁信息
		if (AType = "OP")
		{
			s rowId = $o(^DHCEMRI.LockOpD(rowId))
			q:(rowId = "")
			s obj = ##Class(EMRinstance.LockOp).%OpenId(rowId)
		}
		else
		{
			if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
			{
				s rowId = $o(^DHCEMRI.LockSpecialD(rowId))
				q:(rowId = "")
				s obj = ##Class(EMRinstance.LockSpecial).%OpenId(rowId)
			}
			else
			{
				s rowId = $o(^DHCEMRI.LockD(rowId))
				q:(rowId = "")
				s obj = ##Class(EMRinstance.Lock).%OpenId(rowId)
			}
		}
		
		continue:(obj = "")
		s DocName = ""
		s objEMRTemplateCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(obj.DocID)
		s:(objEMRTemplateCategory '= "") DocName = objEMRTemplateCategory.CategoryName
		s:(objEMRTemplateCategory '= "") DocName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",DocName,langid)
		
		continue:((AUserName '= "")&&(AUserName '= ##class(EMRservice.BL.BLPowerUser).GetUserName(obj.UserID)))
		continue:((AIPAddress '= "")&&(AIPAddress '= obj.Computer))
		continue:((ADocName '= "")&&(DocName '[ ADocName))
		
		s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(obj.UserID)
		s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",userName,langid)
		s newDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","创建")
		s editDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","编辑")
		
		if (AType = "OP")
		{
			s action = "MODIFY"
			s userObj = ##class(User.SSUser).%OpenId(obj.UserID,0)
			s userCode = userObj.SSUSRInitials
		}
		else
		{
			s action = obj.Action
			s userCode = obj.UserCode
		}
		
		if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
			s result = result_"{"
			s result = result_"""ID"":"""_rowId_""""
			s result = result_",""UserID"":"""_obj.UserID_""""
			s result = result_",""UserCode"":"""_userCode_""""
			s result = result_",""UserName"":"""_userName_""""
			s result = result_",""Computer"":"""_obj.Computer_""""
			s HISFormatLockDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.LockDate)
			s HISFOrmatLockTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.LockTime)
			s result = result_",""LockDateTime"":"""_HISFormatLockDate_" "_HISFOrmatLockTime_""""
			s result = result_",""Action"":"""_$Case(action,"LOAD":editDesc,:newDesc)_""""
			s result = result_",""EpisodeID"":"""_obj.EpisodeID_""""
			s result = result_",""DocID"":"""_obj.DocID_""""
			s result = result_",""DocName"":"""_DocName_""""
			s result = result_",""CategoryID"":"""_obj.CategoryID_""""
			s result = result_",""TemplateID"":"""_obj.TemplateID_""""
			s result = result_"}"
			s result = result_","
		}
		s count = count + 1	
	}
	
	s result = $e(result,1,$l(result)-1)
	s json = "{""total"":"_count_",""rows"":["_result_"]}"
	s json = $ZSTRIP(json,"*C")
 	q json
}

/// Desc:       显示用户病历锁信息
/// Creator:    Candy
/// CreateDate: 2015-2-14
/// Input:      AUserID 用户名称
///             AComputer 计算机Ip 
/// Output:     锁表列表
/// Debug:      w ##Class(EMRservice.BL.BLLock).GetUserLockList(105)
ClassMethod GetUserLockList(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s count = 0
	s episodeId = ""
	for
	{
		if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
		{
			s episodeId = $o(^DHCEMRI.LockSpecialI("IdxUserLock"," "_AUserID,episodeId))
		}
		else
		{
			s episodeId = $o(^DHCEMRI.LockI("IdxUserLock"," "_AUserID,episodeId))
		}
		q:(episodeId = "")
		s docId = ""
		s instanceId = ""
		for
		{
			if (##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord() = "false")
			{
				s instanceId = $o(^DHCEMRI.LockSpecialI("IdxUserInstanceLock"," "_AUserID,episodeId,instanceId))
				q:(instanceId = "")
				s rowId = $o(^DHCEMRI.LockSpecialI("IdxUserInstanceLock"," "_AUserID,episodeId,instanceId,""))
				continue:(rowId = "")
				s obj = ##Class(EMRinstance.LockSpecial).%OpenId(rowId)
			}
			else
			{
				s docId = $o(^DHCEMRI.LockI("IdxUserLock"," "_AUserID,episodeId,docId))
				q:(docId = "")
				s rowId = $o(^DHCEMRI.LockI("IdxUserLock"," "_AUserID,episodeId,docId,""))
				continue:(rowId = "")
				s obj = ##Class(EMRinstance.Lock).%OpenId(rowId)
			}
			
			continue:(obj = "")
			s DocName = ""
			s objEMRTemplateCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(obj.DocID)
			s:(objEMRTemplateCategory '= "") DocName = objEMRTemplateCategory.CategoryName
			s:(count '= 0) result = result_","
			s result = result_"{"
			s result = result_"""ID"":"""_rowId_""""
			s result = result_",""UserID"":"""_AUserID_""""
			s result = result_",""UserCode"":"""_obj.UserCode_""""
			s result = result_",""UserName"":"""_##class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)_""""
			s result = result_",""Computer"":"""_obj.Computer_""""
			s result = result_",""LockDateTime"":"""_$zd(obj.LockDate,3)_" "_$zt(obj.LockTime)_""""
			s result = result_",""Action"":"""_obj.Action_""""
			s result = result_",""EpisodeID"":"""_obj.EpisodeID_""""
			s result = result_",""DocID"":"""_obj.DocID_""""
			s result = result_",""DocName"":"""_DocName_""""
			s result = result_",""CategoryID"":"""_obj.CategoryID_""""
			s result = result_",""TemplateID"":"""_obj.TemplateID_""""
			s result = result_"}"
			s count = count + 1
		}
	}
	q "{""total"":"_count_",""rows"":["_result_"]}"
}

/// Desc:       解锁，将残留的病程记录的锁释放(只锁部分病程)
/// Creator:    Donglulu
/// CreateDate: 2018-7-26
/// Input:      
/// Output:     0 解锁失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLLock).UnLockAllInstance(10)
ClassMethod UnLockAllInstance(AUserID As %String, AEpisodeID As %String, ADocID As %String, AComputer As %String) As %String
{
	s result = ""
	q:((AUserID = "")||(AEpisodeID = "")||(ADocID = "")) result
	s rowId = ""
	s count = 0
	for
	{
		s rowId = $o(^DHCEMRI.LockSpecialI("IdxUserLock"," "_AUserID," "_AEpisodeID," "_ADocID,rowId))
		q:(rowId = "")
		s objLock = ##Class(EMRinstance.LockSpecial).%OpenId(rowId)
		continue:(objLock = "") 
		continue:(objLock.Computer '= AComputer)
		s sc = ##Class(EMRinstance.LockSpecial).%DeleteId(rowId)
		s:(rowId = "") result = result_"^"
		s result = result_rowId
		s count = count + 1
	}
	q result
}

}
