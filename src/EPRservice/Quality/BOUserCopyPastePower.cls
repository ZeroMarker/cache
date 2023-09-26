Class EPRservice.Quality.BOUserCopyPastePower Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:   根据用户ID获取用户复制、粘贴权限
/// Input:  argUserId用户ID
/// Output: IsAllowCopyPaste用户有无复制粘贴权限，有则返回1;无则返回0
/// Debug:  w ##Class(EPRservice.Quality.BOUserCopyPastePower).GetUserCopyPastePower(105)
ClassMethod GetUserCopyPastePower(argUserId As %String) As %String
{
	s IsAllowCopyPaste="1"
	
	s id = $o(^DHCEPRM.UserCopyPastePowerI("UserIDIndex"," "_argUserId,""))
	q:(id="") IsAllowCopyPaste
	
	s aPowerUser=##class(EPRmeta.Quality.UserCopyPastePower).%OpenId(id)
	q:(aPowerUser="") IsAllowCopyPaste
	
	//用户永久禁止拥有复制、粘贴权限，即不在有复制、粘贴权限
	if (aPowerUser.Foreverban = "1")
	{
		s IsAllowCopyPaste="0"
	}
	elseif (aPowerUser.Foreverban = "0")
	{
		s nowDate=$p($h,",",1),nowTime=$p($h,",",2)
		if ((nowDate>aPowerUser.StartDate)&&(nowDate<aPowerUser.EndDate))
		{
			s IsAllowCopyPaste="0"
		}elseif ((nowDate=aPowerUser.StartDate)&&(nowDate'=aPowerUser.EndDate))
		{
			if (nowTime>=aPowerUser.StartTime)
			{
				s IsAllowCopyPaste="0"
			}else
			{
				s IsAllowCopyPaste="1"
			}			
		}elseif ((nowDate'=aPowerUser.StartDate)&&(nowDate=aPowerUser.EndDate))
		{
			if (nowTime<=aPowerUser.EndTime)
			{
				s IsAllowCopyPaste="0"
			}else
			{
				s IsAllowCopyPaste="1"
			}			
		}elseif((nowDate=aPowerUser.StartDate)&&(nowDate=aPowerUser.EndDate))
		{
			if (nowTime>=aPowerUser.StartTime)
			{
				if (nowTime<=aPowerUser.EndTime)
				{
					s IsAllowCopyPaste="0"
				}else
				{
					s IsAllowCopyPaste="1"
				}
			}elseif(nowTime<aPowerUser.StartTime)
			{
				s IsAllowCopyPaste="1"
			}
		}else
		{
			s IsAllowCopyPaste="1"
		}	
	 }
	q IsAllowCopyPaste
}

/// Desc: 输入JSON格式的数据
/// Input:AUserID用户ID，
///      ASSGroupID科室ID，
///      AStartDate禁止开始日期，
///      AStartTime禁止开始时间，
///      AEndDate禁止结束日期，
///      AEndTime禁止结束时间，
///      AForeverban是否永久禁止
ClassMethod SetData(AUserID As %String, ASSGroupID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AForeverban As %String) As %String
{
	s result = "0"
	s rowId = $o(^DHCEPRM.UserCopyPastePowerI("UserIDIndex"," "_AUserID,""))
	if (rowId = "")
	{
		s obj = ##Class(EPRmeta.Quality.UserCopyPastePower).%New()
	}
	else
	{
		s obj = ##Class(EPRmeta.Quality.UserCopyPastePower).%OpenId(rowId)
	}
	s obj.UserID=AUserID
	s obj.SSGroupID=ASSGroupID
	s obj.StartDate=AStartDate
	s obj.StartTime=AStartTime
	s obj.EndDate=AEndDate
	s obj.EndTime=AEndTime
	s obj.Foreverban=AForeverban
	
	//用户永久禁止拥有复制、粘贴权限，即不再有复制、粘贴权限
	if (obj.Foreverban = "1")
	{
		s obj.IsAllowCopyPaste="0"
	}
	elseif (obj.Foreverban = "0")
	{
		s nowDate=$p($h,",",1),nowTime=$p($h,",",2)
		if ((nowDate>obj.StartDate)&&(nowDate<obj.EndDate))
		{
			s obj.IsAllowCopyPaste="0"
		}elseif ((nowDate=obj.StartDate)&&(nowDate'=obj.EndDate))
		{
			if (nowTime>=obj.StartTime)
			{
				s obj.IsAllowCopyPaste="0"
			}else
			{
				s obj.IsAllowCopyPaste="1"
			}			
		}elseif ((nowDate'=obj.StartDate)&&(nowDate=obj.EndDate))
		{
			if (nowTime<=obj.EndTime)
			{
				s obj.IsAllowCopyPaste="0"
			}else
			{
				s obj.IsAllowCopyPaste="1"
			}			
		}elseif((nowDate=obj.StartDate)&&(nowDate=obj.EndDate))
		{
			if (nowTime>=obj.StartTime)
			{
				if (nowTime<=obj.EndTime)
				{
					s obj.IsAllowCopyPaste="0"
				}else
				{
					s obj.IsAllowCopyPaste="1"
				}
			}elseif(nowTime<obj.StartTime)
			{
				s obj.IsAllowCopyPaste="1"
			}
		}else
		{
			s obj.IsAllowCopyPaste="1"
		}	
	 }
	s:($$$ISOK(obj.%Save())) result = "1"
	q result
}

/// Desc:获取JSON格式的数据
ClassMethod GetDataList() As %String
{
	s userId = ""
	s json = ""
	s count = 0
	for
	{
		s userId = $o(^DHCEPRM.UserCopyPastePowerI("UserIDIndex",userId))
		q:(userId = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEPRM.UserCopyPastePowerI("UserIDIndex",userId,rowId))
			q:(rowId = "")
			s obj = ##Class(EPRmeta.Quality.UserCopyPastePower).%OpenId(rowId)
			continue:(obj = "")
			s UserName = ..GetUserName(obj.UserID)
			s SSGroupID = obj.SSGroupID
			continue:SSGroupID=""
	        s SSGroup = $p($g(^CTLOC(obj.SSGroupID)),"^",2)
	        //日期、时间格式转换
	        if (obj.StartDate'=""){
		        s StartDate=$zd(obj.StartDate,3)
				s StartDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",StartDate)
			}else{
				s StartDate=""
			}
			if (obj.StartTime'=""){
				s StartTime=$zt(obj.StartTime,1)
				s StartTime=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",StartTime)
			}else{
				s StartTime=""
			}
			if (obj.EndDate'=""){
		        s EndDate=$zd(obj.EndDate,3)
				s EndDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",EndDate)
			}else{
				s EndDate=""
			}
			if (obj.EndTime'=""){
		        s EndTime=$zt(obj.EndTime,1)
				s EndTime=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",EndTime)
			}else{
				s EndTime=""
			}
			//Foreverban是否永久禁止、IsAllowCopyPaste有无粘贴复制权限
			if (obj.Foreverban = "1"){
				s Foreverban = "是"
				s IsAllowCopyPaste = "无"
			}elseif (obj.Foreverban = "0"){
				s Foreverban = "否"
				s nowDate=$p($h,",",1),nowTime=$p($h,",",2)
				if ((nowDate>obj.StartDate)&&(nowDate<obj.EndDate))
				{
					s obj.IsAllowCopyPaste="0"
					s IsAllowCopyPaste = "无"
				}elseif ((nowDate=obj.StartDate)&&(nowDate'=obj.EndDate))
				{
					if (nowTime>=obj.StartTime)
					{
						s obj.IsAllowCopyPaste="0"
						s IsAllowCopyPaste = "无"
					}else
					{
						s obj.IsAllowCopyPaste="1"
						s IsAllowCopyPaste = "有"
					}
				}elseif ((nowDate'=obj.StartDate)&&(nowDate=obj.EndDate))
				{
					if (nowTime<=obj.EndTime)
					{
						s obj.IsAllowCopyPaste="0"
						s IsAllowCopyPaste = "无"
					}else
					{
						s obj.IsAllowCopyPaste="1"
						s IsAllowCopyPaste = "有"
					}
				}elseif((nowDate=obj.StartDate)&&(nowDate=obj.EndDate))
				{
					if (nowTime>=obj.StartTime)
					{
						if (nowTime<=obj.EndTime)
						{
							s obj.IsAllowCopyPaste="0"
							s IsAllowCopyPaste = "无"
						}else
						{
							s obj.IsAllowCopyPaste="1"
							s IsAllowCopyPaste = "有"
						}
					}elseif(nowTime<obj.StartTime)
					{
						s obj.IsAllowCopyPaste="1"
						s IsAllowCopyPaste = "有"
					}
				}else
				{
					s obj.IsAllowCopyPaste = "1"
					s IsAllowCopyPaste = "有"
				}
			}
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""rowID"":"""_rowId_""","
		    s json = json_"""SSGroupID"":"""_obj.SSGroupID_""","
		    s json = json_"""SSGroup"":"""_SSGroup_""","
		    s json = json_"""UserID"":"""_obj.UserID_""","
		    s json = json_"""UserName"":"""_UserName_""","
		    s json = json_"""StartDate"":"""_StartDate_""","
	        s json = json_"""StartTime"":"""_StartTime_""","
	        s json = json_"""EndDate"":"""_EndDate_""","
	        s json = json_"""EndTime"":"""_EndTime_""","
			s json = json_"""Foreverban"":"""_Foreverban_""","
			s json = json_"""IsAllowCopyPaste"":"""_IsAllowCopyPaste_""""
    		s json = json_"}"
			s count = count + 1
		}
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Desc:根据ArowID删除数据
ClassMethod DeletData(ArowID As %String) As %String
{
	s result = "0"
	s sc = ##Class(EPRmeta.Quality.UserCopyPastePower).%DeleteId(ArowID)
	s:($$$ISOK(sc)) result = "1"
	q result
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

}
