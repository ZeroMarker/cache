/// Desc:       门诊病历加锁逻辑类
/// Creator:    yb
/// CreateDate: 2022-08-11
Class EMRservice.BL.BLLockOp Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加锁信息
/// Input:      AUserID 用户ID
///             AComputerName 计算机名
///             AUserLocID 用户科室ID
///             AComputer 计算机IP
///             AInstanceID 实例ID 
/// 				AUserLocID 当前科室ID
/// 				ASessionID  会话sessionID
/// OutPut:     result 0:错误  成功:lcok^锁ID   locked^"锁定信息"  
/// Debug:      w ##Class(EMRservice.BL.BLLockOp).Lock(105,"admin","127.0.0.1",76,"2||1",50,"114","CREATE")
ClassMethod Lock(AUserID As %String, AComputerName As %String, AComputer As %String, AEpisodeID As %String, AInstanceID As %String, ASessionID As %String, AUserLocID As %String) As %String
{
	s result = "0"
	q:((AUserID = "")||(AEpisodeID = "")||(AInstanceID = "")) result
	
	s rowId = $o(^DHCEMRI.LockOpI("IdxMain"," "_AEpisodeID," "_AInstanceID,""))
	if ((rowId '= ""))
	{
		
		s objLock = ##Class(EMRinstance.LockOp).%OpenId(rowId,0)
		q:(objLock = "") result

		s result = ..GetPrompt(rowId)
		q "locked^"_result_"^"_rowId
	}
	
	s insObj = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID,0)
	q:(insObj = "") result
	s templateID = insObj.RealTemplateID
	s recordID = $p(AInstanceID,"||",1)
	q:(recordID = "") result
	s recordObj = ##Class(EMRinstance.ECRecord).%OpenId(recordID,0)
	q:(recordObj = "") result
	s docID = recordObj.RealChartItemID
	
	s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID,0)
	q:(objDoc = "") result
	s chapterId = objDoc.ParentCategoryID
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapterId,0)
	q:(objChapter = "") result
	s categoryId = objChapter.ParentCategoryID

	s obj = ##Class(EMRinstance.LockOp).%New()
	s obj.UserID =  AUserID
	s obj.UserLocID = AUserLocID
	s obj.EpisodeID = AEpisodeID
	s obj.ComputerName = AComputerName
	s obj.Computer = AComputer
	s obj.DocID = docID
	s obj.InstanceID = AInstanceID
	s obj.TemplateID = templateID
	s obj.SessionID = ASessionID
	s obj.CategoryID = categoryId
	s obj.LockDate = $p($h,",",1)
	s obj.LockTime = $p($h,",",2)
	
	q:($$$ISERR(obj.%Save())) result
	s result = obj.%Id()
	k obj
	q "lock^"_result
}

/// Desc:       获取病历是否加锁信息，前端页面提示用
/// Input:      ALockID  锁ID
/// Output      空 锁信息
/// Debug:      w ##Class(EMRservice.BL.BLLockOp).GetPrompt(10)
ClassMethod GetPrompt(ALockID As %String) As %String
{
	s result = ""
	q:(ALockID = "") result
	s obj = ##Class(EMRinstance.LockOp).%OpenId(ALockID,0)
	q:(obj = "") result
	
	s userObj = ##class(User.SSUser).%OpenId(obj.UserID,0)
	q:(userObj = "") result
	s userName = userObj.SSUSRName
	s userCode = userObj.SSUSRInitials
	s userDeptDesc = $Case(obj.UserLocID,"":"",:$p(^CTLOC(obj.UserLocID),"^",2))
	s:($f(userDeptDesc,"-") '= 0) userDeptDesc = $p(userDeptDesc,"-",2)
	
	s result = userCode_"|"_userName_"|"_$zd(obj.LockDate,3)_" "_$zt(obj.LockTime)_"|"_obj.Computer_"|"_ALockID_"|"_obj.ComputerName_"|"_userDeptDesc_"|"_$replace(obj.InstanceID,"||","-")
	q result
}

/// Desc:       解锁  解锁指定记录的锁
/// Input:      ALockID  锁ID
/// Output:     0 解锁失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLLockOp).UnLock(21)
ClassMethod UnLock(ALockID As %String) As %String
{
	s result = "0"
	q:(ALockID = "") result
	
	if ($d(^DHCEMRI.LockOpD(ALockID))<=0) 
	{
		s result = "1"
		q result
	}
	s sc = ##Class(EMRinstance.LockOp).%DeleteId(ALockID)
	s:($$$ISOK(sc)) result = "1"
	q result
}

}
