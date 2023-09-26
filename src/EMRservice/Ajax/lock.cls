/// Desc:       病历锁逻辑类
/// Creator:    Candy
/// CreateDate: 2015-2-13
Class EMRservice.Ajax.lock Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	
	if (action = "Lock")
	{
		d ..Lock()
	}
	elseif (action = "UnLock")
	{
		d ..UnLock()
	}
	elseif (action = "GetLocks")
	{
		d ..GetLocks() 
	}
	elseif (action = "GetLockList")
	{ 
		s UserName = $Get(%request.Data("UserName",1),"")
		s IPAddress = $Get(%request.Data("IPAddress",1),"")
		s DocName = $Get(%request.Data("DocName",1),"")
		s Type = $Get(%request.Data("Type",1),"")
		w ##Class(EMRservice.BL.BLLock).GetLockList(idxStart,idxLast,UserName,IPAddress,DocName,Type)
	}
	Quit $$$OK
}

/// Desc:       编辑病历上锁
/// Creator:    Candy
/// CreateDate: 2015-2-13
ClassMethod Lock()
{
	s userId = $Get(%request.Data("UserID",1),"")
	s userCode = $Get(%request.Data("UserCode",1),"")
	s computer = $Get(%request.Data("Computer",1),"")
	s:(computer = "") computer = ##Class(EMRservice.Tools.Tool).getLoginIP(userId)
	s actionType = $Get(%request.Data("ActionType",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s catagoryId = $Get(%request.Data("CategoryID",1),"")
	s docId = $Get(%request.Data("DocID",1),"")
	s instanceId = $Get(%request.Data("InstanceID",1),"")
	s templateId = $Get(%request.Data("TemplateID",1),"")
	s result = ##Class(EMRservice.BL.BLLock).Lock(userId,userCode,computer,actionType,episodeId,catagoryId,docId,instanceId,templateId)
	w result
}

/// Desc:       编辑病历上锁
/// Creator:    Candy
/// CreateDate: 2015-2-14
ClassMethod UnLock()
{
	s lockId = $Get(%request.Data("LockID",1),"")
	s result = ##Class(EMRservice.BL.BLLock).UnLock(lockId)
	w result
}

/// Desc:       用户病历锁表
/// Creator:    Candy
/// CreateDate: 2015-2-14
ClassMethod GetLocks()
{
	s userId = $Get(%request.Data("UserID",1),"")
	s computer = $Get(%request.Data("Computer",1),"")
	s:(computer = "") computer = ##Class(EMRservice.Tools.Tool).getLoginIP(userId)
	s ^TempCandy = userId_"^"_computer
	s result = ##Class(EMRservice.BL.BLLock).GetUserLockList(userId,computer)
	w result
}

}
