/// 向抽查表中增删改查数据
Class EPRservice.Quality.DataAccess.BOQualityCheckPatInfo Extends %RegisteredObject
{

/// Desc:	向数据库中添加该时间段二级抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   CheckDoctorID：分配人ID   CheckAssignedID：分给谁(质控员)  CheckGrade:质控级别   CheckDate:分配日期(获取当前日期)
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).addSecondSelectInfo(8066,"secondGrade")
ClassMethod addSecondSelectInfo(CheckDoctorID As %String, CheckGrade As %String) As %String
{
	s result = ""
	s NKloc = "28,30,33,35,38,40,43,47,50,55,59,62,65,67,113,118"
	s WKloc = "71,75,81,73,83,85,226,88,93,77,102,105,108,79"
	// 内外科就诊号
	s NKList = "",WKList = ""
	//获取临时global中的就诊号
	s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
	s:(PAADMRowIDList'="") PAADMRowIDList = $e(PAADMRowIDList,1,$l(PAADMRowIDList)-1)
	s PAADMLength = $l(PAADMRowIDList,"^")
	// 如果没有数据就直接返回
	q:PAADMRowIDList="" result
	for i=1:1:PAADMLength
	{
		//就诊号
		s PAADMRowID = $p(PAADMRowIDList,"^",i)
		//科室ID
		s mCurrRow = $g(^PAADM(PAADMRowID))
		s LocID=$p($g(mCurrRow),"^",4)
		s:(NKloc[LocID) NKList=NKList_"^"_PAADMRowID
		s:(WKloc[LocID) WKList=WKList_"^"_PAADMRowID
	}
	//由于临时global拼接原因，需要先截取第一个字符
	s NKList = $e(NKList,2,$l(NKList))
	s WKList = $e(WKList,2,$l(WKList))
	
	s CheckDate = $zd(($p($h,",",1)),3)

	//  内科NKDocList,质控员
	s NKDocList = ##class(EPRservice.Quality.DataGather.Location).getUserIdbyGroupId(312)
	//  外科WKDocList，质控员
	s WKDocList = ##class(EPRservice.Quality.DataGather.Location).getUserIdbyGroupId(315)

	//*****内科数据分配*****
	// 内科人数
	s NKDocListLength = $l(NKDocList,"^")
	// 当前所分配人的位置
	s NKDocLoc = 1
	// 就诊号的长度
	s NKListLength = $l(NKList,"^")
	
	for i=1:1:NKListLength
	{
		//就诊号
		s PAADMRowID = $p(NKList,"^",i)
		// 当前该分配到的质控员位置
		s CheckAssignedID = $p(NKDocList,"^",NKDocLoc)
		// 查询质控员所在科室、病历所属科室，抽取一致时跳过该质控员
		s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
		s paadmInfo = $g(^PAADM(PAADMRowID))
		s PAADMLocID=$p($g(paadmInfo),"^",4)
		
		// 质控员科室 和 病历所在科室 一致的时候
		s locNUm = 0    // 防止极限事件，造成死循环
		while(PAADMLocID '= CheckAssignedLocID) 
		{
			s locNUm = locNUm + 1
			s NKDocLoc = NKDocLoc + 1
			s:(NKDocLoc > NKDocListLength) NKDocLoc = 1
			s CheckAssignedID = $p(NKDocList,"^",NKDocLoc)
			// 查询质控员所在科室、病历所属科室，抽取一致时应该跳过该质控员
			s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
			s paadmInfo = $g(^PAADM(PAADMRowID))
			s PAADMLocID=$p($g(paadmInfo),"^",4)
			q:locNUm>NKDocListLength
		}

		s qualityCheckPat = ##class(EPRinstance.Quality.QualityCheckPatInfo).%New()
		if (qualityCheckPat)
		{
			s qualityCheckPat.PAADMRowID = PAADMRowID
			s qualityCheckPat.CheckDoctorID = CheckDoctorID
			s qualityCheckPat.CheckAssignedID = CheckAssignedID
			s qualityCheckPat.CheckGrade = CheckGrade
			s qualityCheckPat.CheckDate = CheckDate
			s qualityCheckPat.OutDate = $p(^PAADM(PAADMRowID),"^",17)
			// 存一下病案号，要不越用越慢
			s qualityCheckPat.MedicareNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(PAADMRowID)
			
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
		s NKDocLoc = NKDocLoc + 1
		s:(NKDocLoc > NKDocListLength) NKDocLoc = 1
		
	}

	
	//*****外科数据分配*****
	// 外科人数
	s WKDocListLength = $l(WKDocList,"^")
	// 当前所分配人的位置
	s WKDocLoc = 1
	// 就诊号的长度
	s WKListLength = $l(WKList,"^")
	for i=1:1:WKListLength
	{
		
		//就诊号
		s PAADMRowID = $p(WKList,"^",i)
		// 当前该分配到的质控员位置
		s CheckAssignedID = $p(WKDocList,"^",WKDocLoc)
		// 查询质控员所在科室、病历所属科室，抽取一致时跳过该质控员
		s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
		s paadmInfo = $g(^PAADM(PAADMRowID))
		s PAADMLocID=$p($g(paadmInfo),"^",4)
		
		// 质控员科室 和 病历所在科室 一致的时候
		s locNUm = 0    // 防止极限事件，造成死循环
		while(PAADMLocID '= CheckAssignedLocID) 
		{
			s locNUm = locNUm + 1
			s WKDocLoc = WKDocLoc + 1
			s:(WKDocLoc > WKDocListLength) WKDocLoc = 1
			s CheckAssignedID = $p(WKDocList,"^",WKDocLoc)
			// 查询质控员所在科室、病历所属科室，抽取一致时应该跳过该质控员
			s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
			s paadmInfo = $g(^PAADM(PAADMRowID))
			s PAADMLocID=$p($g(paadmInfo),"^",4)
			q:locNUm>WKDocListLength
		}
			
		s qualityCheckPat = ##class(EPRinstance.Quality.QualityCheckPatInfo).%New()
		if (qualityCheckPat)
		{
			s qualityCheckPat.PAADMRowID = PAADMRowID
			s qualityCheckPat.CheckDoctorID = CheckDoctorID
			s qualityCheckPat.CheckAssignedID = CheckAssignedID
			s qualityCheckPat.CheckGrade = CheckGrade
			s qualityCheckPat.CheckDate = CheckDate
			s qualityCheckPat.OutDate = $p(^PAADM(PAADMRowID),"^",17)
			s qualityCheckPat.MedicareNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(PAADMRowID)
			
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
		s WKDocLoc = WKDocLoc + 1
		s:(WKDocLoc > WKDocListLength) WKDocLoc = 1
	}

    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")

	q result
}

/// Desc:	向数据库中添加该时间段三级抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   CheckDoctorID：分配人ID   CheckAssignedID：分给谁(质控员)  CheckGrade:质控级别   CheckDate:分配日期(获取当前日期)
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).addThirdSelectInfo("8066",CheckGrade)
ClassMethod addThirdSelectInfo(CheckDoctorID As %String, CheckGrade As %String) As %String
{
	s result = ""
	s NKloc = "28,30,33,35,38,40,43,47,50,55,59,62,65,67,113,118"
	s WKloc = "71,75,81,73,83,85,226,88,93,77,102,105,108,79"
	// 内外科就诊号
	s NKList = "",WKList = ""
	//获取临时global中的就诊号
	s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
	s:(PAADMRowIDList'="") PAADMRowIDList = $e(PAADMRowIDList,1,$l(PAADMRowIDList)-1)
	s PAADMLength = $l(PAADMRowIDList,"^")
	// 如果没有数据就直接返回
	q:PAADMRowIDList="" result
	for i=1:1:PAADMLength
	{
		//就诊号
		s PAADMRowID = $p(PAADMRowIDList,"^",i)
		//科室ID
		s mCurrRow = $g(^PAADM(PAADMRowID))
		s LocID=$p($g(mCurrRow),"^",4)
		s:(NKloc[LocID) NKList=NKList_"^"_PAADMRowID
		s:(WKloc[LocID) WKList=WKList_"^"_PAADMRowID
	}
	//由于临时global拼接原因，需要先截取第一个字符
	s NKList = $e(NKList,2,$l(NKList))
	s WKList = $e(WKList,2,$l(WKList))
	
	s CheckDate = $zd(($p($h,",",1)),3)

	//  内科NKDocList
	s NKDocList = ##class(EPRservice.Quality.DataGather.Location).getUserIdbyGroupId(313)
	//  外科WKDocList
	s WKDocList = ##class(EPRservice.Quality.DataGather.Location).getUserIdbyGroupId(316)


	//*****内科数据分配*****
	// 内科人数
	s NKDocListLength = $l(NKDocList,"^")
	// 当前所分配人的位置
	s NKDocLoc = 1
	// 就诊号的长度
	s NKListLength = $l(NKList,"^")
	
	for i=1:1:NKListLength
	{
		//就诊号
		s PAADMRowID = $p(NKList,"^",i)
		// 通过位置，找到质控员的 ID
		s CheckAssignedID = $p(NKDocList,"^",NKDocLoc)
		// 查询质控员所在科室、病历所属科室，抽取一致时跳过该质控员
		s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
		s paadmInfo = $g(^PAADM(PAADMRowID))
		s PAADMLocID=$p($g(paadmInfo),"^",4)
		
		// 质控员科室 和 病历所在科室 一致的时候
		s locNUm = 0    // 防止极限事件，造成死循环
		while(PAADMLocID '= CheckAssignedLocID) 
		{
			s locNUm = locNUm + 1
			s NKDocLoc = NKDocLoc + 1
			s:(NKDocLoc > NKDocListLength) NKDocLoc = 1
			s CheckAssignedID = $p(NKDocList,"^",NKDocLoc)
			// 查询质控员所在科室、病历所属科室，抽取一致时应该跳过该质控员
			s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
			s paadmInfo = $g(^PAADM(PAADMRowID))
			s PAADMLocID=$p($g(paadmInfo),"^",4)
			q:locNUm>NKDocListLength
		}

		s qualityCheckPat = ##class(EPRinstance.Quality.QualityCheckPatInfo).%New()
		if (qualityCheckPat)
		{
			s qualityCheckPat.PAADMRowID = PAADMRowID
			s qualityCheckPat.CheckDoctorID = CheckDoctorID
			s qualityCheckPat.CheckAssignedID = CheckAssignedID
			s qualityCheckPat.CheckGrade = CheckGrade
			s qualityCheckPat.CheckDate = CheckDate
			s qualityCheckPat.OutDate = $p(^PAADM(PAADMRowID),"^",17)
			// 存一下病案号，要不越用越慢
			s qualityCheckPat.MedicareNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(PAADMRowID)
			
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
		s NKDocLoc = NKDocLoc + 1
		s:(NKDocLoc > NKDocListLength) NKDocLoc = 1
		
	}

	
	//*****外科数据分配*****
	// 外科人数
	s WKDocListLength = $l(WKDocList,"^")
	// 当前所分配人的位置
	s WKDocLoc = 1
	// 就诊号的长度
	s WKListLength = $l(WKList,"^")
	for i=1:1:WKListLength
	{
		
		//就诊号
		s PAADMRowID = $p(WKList,"^",i)
		// 当前该分配到的质控员位置
		s CheckAssignedID = $p(WKDocList,"^",WKDocLoc)
		// 查询质控员所在科室、病历所属科室，抽取一致时跳过该质控员
		s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
		s paadmInfo = $g(^PAADM(PAADMRowID))
		s PAADMLocID=$p($g(paadmInfo),"^",4)
		
		// 质控员科室 和 病历所在科室 一致的时候
		s locNUm = 0    // 防止极限事件，造成死循环
		while(PAADMLocID '= CheckAssignedLocID) 
		{
			s locNUm = locNUm + 1
			s WKDocLoc = WKDocLoc + 1
			s:(WKDocLoc > WKDocListLength) WKDocLoc = 1
			s CheckAssignedID = $p(WKDocList,"^",WKDocLoc)
			// 查询质控员所在科室、病历所属科室，抽取一致时应该跳过该质控员
			s CheckAssignedLocID= $p(^SSU("SSUSR",CheckAssignedID),"^",4)
			s paadmInfo = $g(^PAADM(PAADMRowID))
			s PAADMLocID=$p($g(paadmInfo),"^",4)
			q:locNUm>WKDocListLength
		}
			
		s qualityCheckPat = ##class(EPRinstance.Quality.QualityCheckPatInfo).%New()
		if (qualityCheckPat)
		{
			s qualityCheckPat.PAADMRowID = PAADMRowID
			s qualityCheckPat.CheckDoctorID = CheckDoctorID
			s qualityCheckPat.CheckAssignedID = CheckAssignedID
			s qualityCheckPat.CheckGrade = CheckGrade
			s qualityCheckPat.CheckDate = CheckDate
			s qualityCheckPat.OutDate = $p(^PAADM(PAADMRowID),"^",17)
			// 存一下病案号，要不越用越慢
			s qualityCheckPat.MedicareNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(PAADMRowID)
			
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
		s WKDocLoc = WKDocLoc + 1
		s:(WKDocLoc > WKDocListLength) WKDocLoc = 1
	}

    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")

	q result
}

/// Desc:	向数据库中添加该时间段抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   CheckDoctorID：分配人ID   CheckAssignedID：分给谁(质控员) CheckDate:分配日期(获取当前日期)
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).addOutPatInfo("8066")
ClassMethod addOutPatInfo(CheckDoctorID As %String, DateGap As %String) As %String
{
	
	s result = ""
	
	
	
	//获取临时global中的就诊号
	s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
	s:(PAADMRowIDList'="") PAADMRowIDList = $e(PAADMRowIDList,1,*-1)
	s PAADMLength = $l(PAADMRowIDList,"^")
	// 如果没有数据就直接返回
	q:PAADMRowIDList="" result
	
	
	s CheckDate = $zd(($p($h,",",1)),3)


	
	///获取配置在质控维护程序---公共函数模块中的医务科安全组
	/*s ParamID=$o(^DHCEPRM.QualityParamsI("IdxCode","MZSSGroup",""))
	q:(ParamID="") "未设置质控医师，分配失败!"
	s OBJQualityParams=##class(EPRmeta.Quality.QualityParams).%OpenId(ParamID)
	s KSGroupID=OBJQualityParams.BindValue
	
	
	///将医生id存入临时global中()
	s UserIDS=##Class(EPRservice.Quality.DataGather.SSUser).GetUserIdByGroupID(KSGroupID)*/
	
	s UserIDS=##class(EPRservice.Quality.Ajax.MedDoctor).GetEffectiveUserByRange($p($h,",",1),"O")
	
	q:(UserIDS="") "未设置质控医师，分配失败!"
	s ^tempUserID("UserID")=""
	for u=1:1:$l(UserIDS,"^")
	{
		s userId=$p(UserIDS,"^",u)
		
		s ^tempUserID("UserID",userId)=""
		
	}
	
	s userId="",index=1
	for
	{
		s userId=$o(^tempUserID("UserID",userId))
		continue:(userId="")
		s EpisodeID=$p(PAADMRowIDList,"^",index)
		s index=index+1
		q:(EpisodeID="")
		s ^tempUserID("UserID",userId,EpisodeID)=""
	}
	
	s result= ..InserAssignInfo(CheckDoctorID,DateGap)
	
	k ^tempUserID("UserID")
    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")
	q result
}

/// Desc 将临时global中的数据存入表(EPRinstance.Quality.OutPatAssignInfo)里
/// 2020-09-28
/// 分配者ID 分配时间段
/// 这个方法不能单独使用...和头顶的这个方法配合使用
ClassMethod InserAssignInfo(CheckDoctorID As %String, DateGap As %String)
{
	///数据存表(EPRinstance.Quality.OutPatAssignInfo)
	s userId=""
	
	for
	{
		s userId=$o(^tempUserID("UserID",userId))
		q:(userId="")
		s EpisodeID=""
		for
		{
			s EpisodeID=$o(^tempUserID("UserID",userId,EpisodeID))
			q:(EpisodeID="")
			TSTART
			s OBJOutPatAssignInfo=##class(EPRinstance.Quality.OutPatAssignInfo).%New()
			
			q:(OBJOutPatAssignInfo="")
			s OBJOutPatAssignInfo.AssignUserID=CheckDoctorID
			s OBJOutPatAssignInfo.MedDoctorID=userId
			s OBJOutPatAssignInfo.EpisodeID=EpisodeID
			s OBJOutPatAssignInfo.DateGap=DateGap
			s sc = OBJOutPatAssignInfo.%Save()
			if ($$$ISERR(sc))
			{
				TROLLBACK
				s Error = $system.OBJ.DisplayError(sc)
				s result = "失败^"_Error

			}
			else
			{
				TCOMMIT
				s result = "添加成功"
			}
		}
	}
	
	q result
}

/// 批量更新分配医师
ClassMethod UpdateMedDoc(userId, EpisodeIDS) As %String
{
	s result="操作失败!",errorFlag=0
	q:(userId="")||(EpisodeIDS="") result
	
	s admNums=$l(EpisodeIDS,"/")
	
	TSTART
	
	for i=1:1:admNums
	{
		s episodeId=$p(EpisodeIDS,"/",i)
		q:(episodeId="")
		s RowId=$o(^DHCEPRQ.OutPatAssignInfoI("IdxEpisodeID"," "_episodeId,""))
		q:(RowId="")
		s OBJOutPatAssignInfo=##class(EPRinstance.Quality.OutPatAssignInfo).%OpenId(RowId)
		q:(OBJOutPatAssignInfo="")
		
		s OBJOutPatAssignInfo.MedDoctorID=userId
		s sc = OBJOutPatAssignInfo.%Save()
		if ($$$ISERR(sc))
		{
			s Error = $system.OBJ.DisplayError(sc)
			s result = "更新失败^"_Error
			s errorFlag=1
			q

		}
		else
		{
			s result = "更新成功"
		}
	}
	
	if errorFlag=1
	{
		TROLLBACK
	}else
	{
		TCOMMIT
	}
	
	q result
}

}
