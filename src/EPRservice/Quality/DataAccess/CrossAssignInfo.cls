/// 访问病历分配数据表
Class EPRservice.Quality.DataAccess.CrossAssignInfo Extends %RegisteredObject
{

/// Desc:	向数据库中添加该时间段抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   AdmType 病历类型 门诊O 环节IA 终末ID
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.AssignInfo).addOutPatInfo("8066")
ClassMethod AddAssignInfo(AdmType As %String) As %String
{
	
	s result = ""

	//获取临时global中的就诊号
	s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
	s:(PAADMRowIDList'="") PAADMRowIDList = $e(PAADMRowIDList,2,$l(PAADMRowIDList))
	s PAADMLength = $l(PAADMRowIDList,"^")
	// 如果没有数据就直接返回
	q:PAADMRowIDList="" result
	
	s CheckDate = $zd(($p($h,",",1)),3)
	
	s UserIDS=##class(EPRservice.Quality.Ajax.MedDoctor).GetEffectiveUserByRange($p($h,",",1),AdmType)
	
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
	
	s result= ..InserAssignInfo(AdmType)
	
	k ^tempUserID("UserID")
    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")
	q result
}

/// Desc 将临时global中的数据存入表(EPRinstance.Quality.AssignInfo)里
/// 2020-09-28
/// 分配者ID 分配时间段
/// 这个方法不能单独使用...和头顶的这个方法配合使用
ClassMethod InserAssignInfo(AdmType As %String)
{
	///数据存表(EPRinstance.Quality.AssignInfo)
	
	s userId=""
	
	s ExtractInfo=$g(^tempSelect("ExtractInfo"))
	
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
			s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%New()
			
			q:(OBJAssignInfo="")
			s OBJAssignInfo.UserID=userId
			s OBJAssignInfo.EpisodeID=EpisodeID
			s OBJAssignInfo.AdmType=AdmType
			s OBJAssignInfo.IsActive="N"
			s OBJAssignInfo.LastAssignDate=$p(ExtractInfo,"^",3)
			s sc = OBJAssignInfo.%Save()
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

/*ClassMethod UpdateActiveStatus(){
	s result=""
	q:(dateGap="") result
	
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.QualityCrossAssignInfoI("IdxDateGap",dateGap,rowId))
		q:(rowId="")
		s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
		s OBJAssignInfo.IsActive="Y"
		s sc=OBJAssignInfo.%Save()
		if ($$$ISERR(sc))
		{
			s Error = $system.OBJ.DisplayError(sc)
			s result = "更新失败^"_Error

		}
		else
		{
			s StRowId = OBJAssignInfo.%Id()
			s result = "更新成功"
		}	
	}
	
	q result	
}*/
/// 批量更新分配医师
ClassMethod UpdateMedDoc(userId, EpisodeIDS) As %String
{
	s result="操作失败!",errorFlag=0
	q:(userId="")||(EpisodeIDS="") ret
	
	s admNums=$l(EpisodeIDS,"/")
	
	TSTART
	
	for i=1:1:admNums
	{
		s episodeId=$p(EpisodeIDS,"/",i)
		q:(episodeId="")
		s RowId=$o(^DHCEPRQ.AssignInfoI("IdxEpisodeID"," "_episodeId,""))
		q:(RowId="")
		s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(RowId)
		q:(OBJAssignInfo="")
		
		s OBJAssignInfo.UserID=userId
		s sc = OBJAssignInfo.%Save()
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

/// 更新状态,有效或者无效  status = Y 有效  N 无效
/// debug:W ##class(EPRservice.Quality.DataAccess.CrossAssignInfo).ChangeAssignStatus("17","Y")
ClassMethod ChangeAssignStatus(EpisodeID, status) As %String
{
	s result="操作失败"
	
	q:(EpisodeID="") result
	
	s rowId=$o(^DHCEPRQ.AssignInfoI("IdxEpisodeID"," "_EpisodeID,""))
	
	q:rowId="" result
	
	s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
	
	s OBJAssignInfo.IsActive=status
	s sc = OBJAssignInfo.%Save()
	if ($$$ISERR(sc))
	{
		
		s Error = $system.OBJ.DisplayError(sc)
		s result = "操作失败^"_Error
		s errorFlag=1
		q

	}
	else
	{
		s result = "操作成功"
	}
	
	
	q result
}

/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.AssignInfo","GetAssignInfoByLastDate"," 2021-03-30","ID")
Query GetAssignInfoByLastDate(LastDate, AdmType) As %Query(ROWSPEC = "RegNo,PAPMIName,PAPMISex,MainDiagnos,DischDate,ResidentDays,MedName,PAADMRowID,IsActive")
{
}

ClassMethod GetAssignInfoByLastDateExecute(ByRef qHandle As %Binary, LastDate, AdmType) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","AssignInfo")
	
	/*s extractId="",DateGap=""
	for
	{
		s extractId=$o(^DHCEPRQ.ExtractInfoI("IdxAdmType"," "_AdmType,extractId))
		q:(extractId="")
		s OBJExtract=##class(EPRinstance.Quality.ExtractInfo).%OpenId(extractId)
		
		continue:(OBJExtract.EndDate'=LastDate)
		
		s DateGap=OBJExtract.StartDate_"至"_LastDate 	
	}*/
	
	
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.AssignInfoI("IdxLastAssignDate",LastDate,rowId))
		
		q:(rowId="")
		
		s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
		s PAADMRowID=OBJAssignInfo.EpisodeID
		q:(PAADMRowID="")
		
		continue:(OBJAssignInfo.AdmType'=AdmType)
		
		s mCurrRow = $g(^PAADM(PAADMRowID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
		
		s OBJPatMas=##class(User.PAPatMas).%OpenId(PAPMIDR)
		//登记号
		s RegNo=OBJPatMas.PAPMIIPNo
		s:(AdmType="O") RegNo=OBJPatMas.PAPMIOPNo
		
		//有效状态
		s IsActive=OBJAssignInfo.IsActive
		
		//姓名
		s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		
		//质控医师
		s MedDoc=OBJAssignInfo.UserID
		s MedUser = $g(^SSU("SSUSR",MedDoc))
		s MedName = $p(MedUser,"^",2)
		
		//性别
		s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
		s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
		
		
		//出院时间
		s DischDate = $p($g(mCurrRow),"^",17)
		if (DischDate '= "")
		{
			s DischDate = $zd(DischDate,3)
		}
		//住院天数
		s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
		
		s DisDept=##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(PAADMRowID,"")
		
		//诊断
		s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
		
		
		
		
		
		
		//s Data=$lb(AssignName,MedName,PAPMIName,PAPMISex,$p(MainDiagnos,"^",3),DateGap,$p(CheckedFlag,"^",1),PAADMRowID,signName,mucpDoctor,DischDate,ResidentDays,RegNo,$p(DisDept,"^",3))
		s Data=$lb(RegNo,PAPMIName,PAPMISex,$p(MainDiagnos,"^",3),DischDate,ResidentDays,MedName,PAADMRowID,IsActive)
		
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetAssignInfoByLastDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssignInfoByLastDateExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAssignInfoByLastDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssignInfoByLastDateExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取指定医师的分配病历
/// UserId 医师Id, IsChecked 是否质控
/// 测试数据:UserID 
/// debug:d ##class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.AssignInfo","GetAssignInfoByUserId","11738") 
Query GetAssignInfoByUserId(UserID, IsChecked) As %Query(ROWSPEC = "ChargeDoc,RegNo,PAPMIName,EpisodeID,CheckedFlag,Grade,Score,ResidentDays")
{
}

ClassMethod GetAssignInfoByUserIdExecute(ByRef qHandle As %Binary, UserID, IsChecked = "N") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(UserID="") $$$OK
	
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.AssignInfoI("IdxUserID"," "_UserID,rowId))
		q:(rowId="")
		s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
		q:(OBJAssignInfo="")
		continue:(OBJAssignInfo.IsActive="N")
		
		s EpisodeID=OBJAssignInfo.EpisodeID
		s MedDoc=OBJAssignInfo.UserID
		
		s mCurrRow = $g(^PAADM(EpisodeID))
		
		s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
		s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		
		s RegNo=$g(^PAPER(PAPMIDR,"PAT",1))  //登记号
		s RegNo=$p(RegNo,"^",2)
		
		//continue:(regNo'="")&&(RegNo'=regNo) 
		s ChargeDoc=""
		s ChargeDocId=$p($g(mCurrRow),"^",*-4) 
		if (ChargeDocId'=""){
			s ChargeDoc=$g(^SSU("SSUSR",ChargeDocId))  //主管医生
			s ChargeDoc=$p(ChargeDoc,"^",2)
		}
		
		//住院天数
		s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(EpisodeID,"")
		
		s CheckedFlag=""
		s Grade="甲级"
		s Score="100"
		//是否质控
		s checked="否"
		s checkFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(EpisodeID,"ID")
		continue:(IsChecked'=checkFlag)
		s:(checkFlag="Y") checked="是"
		
		s Data=$lb(ChargeDoc,RegNo,PAPMIName,EpisodeID,CheckedFlag,Grade,Score,ResidentDays,checked)
		
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
		
	}
	
	Quit $$$OK
}

ClassMethod GetAssignInfoByUserIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssignInfoByUserIdExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAssignInfoByUserIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssignInfoByUserIdExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
