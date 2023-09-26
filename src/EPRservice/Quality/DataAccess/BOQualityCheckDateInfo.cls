/// 检查该时间段的数据是否已经被抽取过
Class EPRservice.Quality.DataAccess.BOQualityCheckDateInfo Extends %RegisteredObject
{

/// Desc:	该方法用于判断日期是否重复
/// Input:  StartDate:开始日期   EndDate：结束日期   checkGrade:质控级别
/// output: 返回触犯的日期范围，所有flag为 0 说明日期不重复
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).checkDateIsOn("2019-02-02","2019-03-03","secondGrade")
ClassMethod checkDateIsOn(StartDate As %String, EndDate As %String, checkGrade As %String) As %String
{
	s result = ""
	
	//s StartDate = $Get(%request.Data("StartDate",1),"")
	//s EndDate = $Get(%request.Data("EndDate",1),"")
	s flag1 = 0     // 用于判断选取日期范围是否在已抽取范围内
	s flag2 = 0     //用于判断选取日期范围是否包含已抽取范围
	s flag3 = 0     //用于判断开始时间重复，结束时间不重复（-1）
	s flag4 = 0     //用于判断开始时间不重复，结束时间重复（-1）
	
	s startNum = $zdh(StartDate,3)
	s endNum = $zdh(EndDate,3)
	//1.首先判断是否抽取过该时间段的患者
	s dateRowId = ""
	for {
		s dateRowId = $o(^DHCEPRQ.QualityDateD(dateRowId))
		q:dateRowId=""
		s alrStartDate = $List(^DHCEPRQ.QualityDateD(dateRowId),2)
		s alrStartNum = $zdh(alrStartDate,3)
		s alrEndDate = $List(^DHCEPRQ.QualityDateD(dateRowId),3)
		s alrEndNum = $zdh(alrEndDate,3)
		s alrCheckGrade = $List(^DHCEPRQ.QualityDateD(dateRowId),4)
		
		s:(alrCheckGrade=checkGrade)&&(startNum+1>alrStartNum)&&(endNum-1<alrEndNum) flag1=-1
		s:(alrCheckGrade=checkGrade)&&(startNum-1<alrStartNum)&&(endNum+1>alrEndNum) flag2=-1
		s:(alrCheckGrade=checkGrade)&&(startNum+1>alrStartNum)&&(startNum-1<alrEndNum)&&(endNum+1>alrEndNum) flag3=-1
		s:(alrCheckGrade=checkGrade)&&(startNum-1<alrStartNum)&&(endNum+1>alrStartNum)&&(endNum-1<alrEndNum) flag4=-1
		q:(flag1=-1)||(flag2=-1)||(flag3=-1)||(flag4=-1)
		
	}
	
	if ((flag1=-1)||(flag2=-1)||(flag3=-1)||(flag4=-1))
	{
		// 时间冲突后，直接返回到前台json
	 	s result = flag1_","_flag2_","_flag3_","_flag4_","_alrStartDate_","_alrEndDate_","_StartDate_","_EndDate
	}
	else     
	{
		//说明不重复，开始向数据库添加数据
	 	s result = flag1_","_flag2_","_flag3_","_flag4
	
	}
	q result
}

/// Desc:	向数据库中添加已经抽取过的时间段信息
/// Input:  StartDate:开始时间   EndDate：结束时间   checkGrade：质控级别
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).addDateInfo("2018-11-14","2019-11-12","secondGrade")
ClassMethod addDateInfo(StartDate As %String, EndDate As %String, CheckGrade As %String) As %String
{
	s result = ""
	s qualityCheckDate = ##class(EPRinstance.Quality.QualityCheckDate).%New()
	if (qualityCheckDate)
	{
		s qualityCheckDate.StartDate = StartDate
		s qualityCheckDate.EndDate = EndDate
		s qualityCheckDate.CheckGrade = CheckGrade
		
		TSTART
		s sc = qualityCheckDate.%Save()
		if ($$$ISERR(sc))
		{
			TROLLBACK
			s Error = $system.OBJ.DisplayError(sc)
			s result = "失败^"_Error
		}
		else
		{
			TCOMMIT
			s StRowId = qualityCheckDate.%Id()
			s result = "添加成功"
		}
	}
	q result
}

/// Desc:	向数据库中添加该时间段的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   CheckDoctorID：分配人ID   CheckAssignedID：分给谁(质控员)  CheckGrade:质控级别   CheckDate:分配日期(获取当前日期)
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).addSecondSelectInfo(1,"secondGrade")
ClassMethod addSecondSelectInfo(CheckDoctorID As %String, CheckGrade As %String) As %String
{
	s result = ""
	s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
	// 如果没有数据就直接返回
	q:PAADMRowIDList="" result
	//由于linshiglobal拼接原因，需要先截取第一个字符
	s PAADMRowIDList = $e(PAADMRowIDList,2,$l(PAADMRowIDList))
	s CheckDate = $zd(($p($h,",",1)),3)
	// 取科室的字符串接口,并计算长度
	s AssignedIDList = ##class(EPRservice.Quality.DataGather.Location).getUserIdbyGroupId(63)
	s AssignedIDLength = $l(AssignedIDList,"*")
	// 就诊号的长度
	s PAADMLength = $l(PAADMRowIDList,"^")
	for i=1:1:PAADMLength
	{
		//就诊号
		s PAADMRowID = $p(PAADMRowIDList,"^",i)
		
		s qualityCheckPat = ##class(EPRinstance.Quality.QualityCheckPatInfo).%New()
		if (qualityCheckPat)
		{
			s qualityCheckPat.PAADMRowID = PAADMRowID
			s qualityCheckPat.CheckDoctorID = CheckDoctorID
			// 用取余法平分给质控员
			s currentLocation = (i#AssignedIDLength)+1
			s CheckAssignedID = $p(AssignedIDList,"*",currentLocation)
			s qualityCheckPat.CheckAssignedID = CheckAssignedID
			s qualityCheckPat.CheckGrade = CheckGrade
			s qualityCheckPat.CheckDate = CheckDate
			s qualityCheckPat.OutDate = $p(^PAADM(PAADMRowID),"^",17)
			
			TSTART
			s sc = qualityCheckPat.%Save()
			if ($$$ISERR(sc))
			{
				TROLLBACK
				s Error = $system.OBJ.DisplayError(sc)
				s result = "失败^"_Error
			}
			else
			{
				TCOMMIT
				s StRowId = qualityCheckPat.%Id()
				s result = "添加成功"
			}
		}
	}

    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")

	q result
}

/// Desc通过UserID查询就诊号
/// WZL2020-09-28
/// Input UserID(质控医师ID)
/// Output EpisodeID(就诊号) 1\2\3
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).GetEpisodeIDByUserID()
ClassMethod GetEpisodeIDByUserID(UserID As %String)
{
	s ret=""
	s rowID=""
	for
	{
		s str=""
		s rowID=$o(^DHCEPRQ.QualityCheckI("IndexCheckAssignedID"," "_UserID,rowID))
		s:(rowID'="")&&(ret'="") str="\"
		s ret=ret_str
		q:rowID=""
		s list=$g(^DHCEPRQ.QualityCheckD(rowID))
		s EpisodeID=$list(list,8)
		s ret=ret_EpisodeID
	}
	q ret
}

/// 获取门诊病历检查时间表的最后一次检查时间
/// WZL2020-09-28
/// Output StartDate^EndDate
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).GetLastCheckDate()
ClassMethod GetLastCheckDate() As %String
{
	s DateInfo=""
	
	s DateId=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxLastSpotCheck"," 1",""))
	s OBJDate=##class(EPRinstance.Quality.OutPatSpotCheckDate).%OpenId(DateId)
	s startDate=OBJDate.StartDate
	s endDate=OBJDate.EndDate
	
	s:(startDate'=""&&endDate'="") DateInfo=startDate_"^"_endDate
	
	q DateInfo
}

/// Desc 将最后一次抽查时间更新，如果该没有数据，则成功退出。
/// WZL2020-09-28
/// Output StartDate^EndDate
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).UpdateLastCheckDate()
ClassMethod UpdateLastCheckDate() As %String
{
	s DateInfo=""
	
	s DateId=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxLastSpotCheck"," 1",""))
	q:(DateId="") "该表还没有数据，请继续写入操作。"
	
	
	s OBJDate=##class(EPRinstance.Quality.OutPatSpotCheckDate).%OpenId(DateId)
	s OBJDate.LastSpotCheck=0
	
	
	s sc=OBJDate.%Save()
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s DateInfo = "设置失败^"_Error
	}
	else
	{
		s StRowId = OBJDate.%Id()
		s DateInfo = "设置成功"
	}
	q DateInfo
}

/// Desc 获取输入抽查时间段包括的已抽查时间段
/// WZL2020-09-28
/// 无参
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).GetCheckedDate("2019-01-01","2019-02-01")
ClassMethod GetCheckedDate(StartDate As %String, EndDate As %String) As %String
{
	s maxList="",minList="",ErrorDateList=""
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	s date=""
	for
	{
		s date=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date))
		q:(date="")
		s rowId=""
		for
		{
			s rowId=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date,rowId))
			
			q:(rowId="")
			s OBJDate=##class(EPRinstance.Quality.OutPatSpotCheckDate).%OpenId(rowId)
			s st=OBJDate.StartDate
			s et=OBJDate.EndDate
			s st=$zdh(st,3)
			s et=$zdh(et,3)
			continue:(StartDate>et)||(EndDate<st)
			
			if (EndDate<=et)&&(StartDate<st)
			{
				s maxList=$zd(st,3)	
			}
			if (StartDate>=st)&&(EndDate>et)
			{
				s minList=$zd(et,3)
			}
			s:(StartDate>st)&&(EndDate<et) ErrorDateList=ErrorDateList_$zd(StartDate,3)_"to"_$zd(EndDate,3)_"^"
			s:(StartDate<=st)&&(EndDate>=et) ErrorDateList=ErrorDateList_$zd(st,3)_"to"_$zd(et,3)_"^"
			
		}
	}
	
	s ErrorDateList=$e(ErrorDateList,1,*-1)
	
	q maxList_"||"_minList_"||"_ErrorDateList
}

/// Desc 获取所有已分配时间段
/// WZL2020-09-28
/// 无参
/// w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).GetAllCheckedDate()
ClassMethod GetAllCheckedDate() As %String
{
	s dateList="",date=""
	for
	{
		s date=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date))
		q:(date="")
		s rowId=""
		for
		{
			s rowId=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date,rowId))
			
			q:(rowId="")
			s OBJDate=##class(EPRinstance.Quality.OutPatSpotCheckDate).%OpenId(rowId)
			s st=OBJDate.StartDate
			s et=OBJDate.EndDate
			s dateList=dateList_st_","_et_"/"
		}
	}
	s dateList=$e(dateList,1,*-1)
	
	q dateList
}

/// Desc 获取可分配时间段
/// WZL2020-09-28
/// 无参
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).GetAllRightDate()
ClassMethod GetAllRightDate() As %String
{
	s dateList="",date="",maxList="",minList="",lastDate=""
	for
	{
		s date=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date))
		q:(date="")
		s rowId=""
		for
		{
			s rowId=$o(^DHCEPRQ.OutPatSpotCheckDateI("IdxSpotCheckDate",date,rowId))
			
			q:(rowId="")
			s OBJDate=##class(EPRinstance.Quality.OutPatSpotCheckDate).%OpenId(rowId)
			s st=$zdh(OBJDate.StartDate,3)
			s et=$zdh(OBJDate.EndDate,3)
			s:(maxList="")||(maxList>st) maxList=st
			s:(minList="")||(minList<et) minList=et
			
			if ((st-lastDate)>0)&&(lastDate'="")
			{
				s dateList=dateList_$zd(lastDate,3)_","_$zd((st-1),3)_"/"
			}
			s lastDate=et+1
			
			
		}
	}
	s dateList=$e(dateList,1,*-1)
	
	q dateList_"and:"_$zd(maxList,3)_"and:"_$zd(minList,3)
}

/// Desc 新增分配日期
/// WZL2020-09-28
/// input StartDate 开始分配日期  EndDate 结束分配日期
/// output 添加成功或者失败
/// w ##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).InsertSpotCheckDateInfo()
ClassMethod InsertSpotCheckDateInfo(StartDate As %String, EndDate As %String) As %String
{
	s result="操作失败"
	q:(StartDate="")||(EndDate="") result
	
	s updateFlag=##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).UpdateLastCheckDate() //更新表里最后一次抽查时间
	q:(updateFlag["更新失败") result
	
	s OutPatSpotCheckDate = ##class(EPRinstance.Quality.OutPatSpotCheckDate).%New()
	if (OutPatSpotCheckDate)
	{
		s OutPatSpotCheckDate.StartDate = StartDate
		s OutPatSpotCheckDate.EndDate = EndDate
		s OutPatSpotCheckDate.LastSpotCheck=1
		s OutPatSpotCheckDate.SpotCheckDate=$zd($h,3)
		TSTART
		s sc = OutPatSpotCheckDate.%Save()
		if ($$$ISERR(sc))
		{
			TROLLBACK
			s Error = $system.OBJ.DisplayError(sc)
			s result = result_"^"_Error
		}
		else
		{
			TCOMMIT
			s StRowId = OutPatSpotCheckDate.%Id()
			s result = "添加成功"
		}
	}
	q result
}

/// 清除临时抽查数据
ClassMethod ClearQueryData()
{
	k ^temp("duplicateRemoval")
	
	q "清除成功!"
}

}
