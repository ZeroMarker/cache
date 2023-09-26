Class EPRservice.Quality.BOLockPatient Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:   根据用户ID获取用户复制、粘贴权限
/// Input:  argUserId用户ID
/// Output: IsAllowCopyPaste用户有无复制粘贴权限，有则返回1;无则返回0
/// Debug:  w ##Class(EPRservice.Quality.BOUserCopyPastePower).GetUserCopyPastePower(105)
ClassMethod GetPatientLock(argEpisodeID As %String, argUserId As %String) As %String
{
	s IsLock="1"
	
	s id = $o(^DHCEPRM.LockPatientI("EpisodeIDIndex"," "_argEpisodeID,""))
	q:(id="") IsLock
	
	s aLockList=##class(EPRmeta.Quality.UserCopyPastePower).%OpenId(id)
	q:(aLockList="") IsLock
	
	//用户永久禁止拥有复制、粘贴权限，即不在有复制、粘贴权限
	if (aLockList.AllLock = "1")
	{
		s IsLock="0"
	}
	elseif (aLockList.AllLock = "0")
	{
		if (argUserId=aLockList.IsUnLockUserID)
		{
			s IsLock="1"
		}
		else
		{
			s IsLock="0"
		}	
	 }
	q IsLock
}

/// yhy
/// 2018-09-03
/// Desc: 输入JSON格式的数据
/// Input:AUserID封锁操作者ID，
/// AEpisodeID:就诊号
/// AStartDate封锁日期
/// AAllLock是否全部用户封锁
/// AIsUnLockUserID解除封锁医生
ClassMethod SetData(AUserID As %String, AEpisodeID As %String, AStartDate As %String, AAllLock As %String, AIsUnLockUserID As %String) As %String
{
	s result = "0"
	s rowId = ""
	s rowId = $o(^DHCEPRM.LockPatientI("EpisodeIDIndex"," "_AEpisodeID,rowId))
	if (rowId = "")
	{
		s obj = ##Class(EPRmeta.Quality.LockPatient).%New()
	}
	else
	{
		s obj = ##Class(EPRmeta.Quality.LockPatient).%OpenId(rowId)
	}
	s obj.UserID=AUserID
	s obj.EpisodeID = AEpisodeID
	s obj.StartDate=AStartDate
	s obj.AllLock = AAllLock
	s obj.IsUnLockUserID = AIsUnLockUserID
	s obj.IsLock = "0"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
	q result
}

/// Desc:获取JSON格式的数据
ClassMethod GetDataList() As %String
{
	s EpisodeID = ""
	s IsUnLockUserID = ""
	s AllLock = ""
	s IsLock = ""
	s json = ""
	s count = 0
	for
	{
		s EpisodeID = $o(^DHCEPRM.LockPatientI("EpisodeIDIndex",EpisodeID))
		q:(EpisodeID = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEPRM.LockPatientI("EpisodeIDIndex",EpisodeID,rowId))
			q:(rowId = "")
			s obj = ##Class(EPRmeta.Quality.LockPatient).%OpenId(rowId)
			continue:(obj = "")
			s UserName = ..GetUserName(obj.UserID)
			s Episodeid = obj.EpisodeID
	        //日期、时间格式转换
	       
			s StartDate = obj.StartDate
			s AllLock = obj.AllLock
			s:AllLock=1 AllLock = "是"
			s:AllLock=0 AllLock = "否"
			b
			s IsUnLockUserID = obj.IsUnLockUserID
			s IsUnLockUserName = ..GetUserName(IsUnLockUserID)
			s IsLock = "无"
	
			s mCurrRow = $g(^PAADM(Episodeid))
			s PAPMIDR = $p($g(mCurrRow),"^",1)
			s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""rowID"":"""_rowId_""","
		    s json = json_"""EpisodeID"":"""_Episodeid_""","
		    s json = json_"""Name"":"""_Name_""","
		    s json = json_"""UserID"":"""_obj.UserID_""","
		    s json = json_"""UserName"":"""_UserName_""","
		    s json = json_"""StartDate"":"""_StartDate_""","
	        s json = json_"""IsUnLockUserID"":"""_IsUnLockUserID_""","
	        s json = json_"""IsUnLockUserName"":"""_IsUnLockUserName_""","
			s json = json_"""AllLock"":"""_AllLock_""","
			s json = json_"""IsLock"":"""_IsLock_""""
    		s json = json_"}"
			s count = count + 1
		}
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Desc:从SSUser中取出用户名字
/// used by ##class(EPRinstance.EPRLogs).GetCurrStatus
ClassMethod GetUserName(argUserID As %String) As %String
{
	s ssuser=""
	Set ssuser=##class(User.SSUser).%OpenId(argUserID)
	q:(ssuser="") ""
	q ssuser.SSUSRName
}

/// Desc:根据ArowID删除数据
ClassMethod DeletData(ArowID As %String) As %String
{
	s result = "0"
	s sc = ##Class(EPRmeta.Quality.LockPatient).%DeleteId(ArowID)
	s:($$$ISOK(sc)) result = "1"
	q result
}

}
