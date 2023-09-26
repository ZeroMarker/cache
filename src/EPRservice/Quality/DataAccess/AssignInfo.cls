/// 访问病历分配数据表
Class EPRservice.Quality.DataAccess.AssignInfo Extends %RegisteredObject
{

/// Desc:	向数据库中添加该时间段抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   AdmType 病历类型 门诊O 环节IA 终末ID
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.AssignInfo).AddAssignInfo("CQC",1291,"1")
ClassMethod AddAssignInfo(AdmType As %String, AdmList As %String, IsCrossFlag As %String = "0") As %String
{
	
	s result = ""

	s PAADMRowIDList=AdmList
	
	q:PAADMRowIDList="" result
	
	s CheckDate = $zd(($p($h,",",1)),3)
	
	s UserIDS=##class(EPRservice.Quality.Ajax.MedDoctor).GetEffectiveUserByRange($p($h,",",1),AdmType)
	
	q:(UserIDS="") "未设置质控医师，分配失败!"
	s ^tempUserID("UserID")="",UserCount=0  //UserCount=用户总数
	for u=1:1:$l(UserIDS,"^")
	{
		s userId=$p(UserIDS,"^",u)
		
		s ^tempUserID("UserID",userId)=""
		
		s UserCount=UserCount+1
	}
	
	
	s userId="",index=1,userNums=0  //userNums=用户总数
	for
	{
		s userId=$o(^tempUserID("UserID",userId))
		continue:(userId="")
		
		//增加交叉分配判断，IsCrossFlag=0,本科室病历只分配给本科室医师，=1，则不分配给本科室的医师，即交叉分配
		s UserInfo=$g(^SSU("SSUSR",userId))
		s UserLocId=##class(EPRservice.Quality.DataAccess.MedDoctor).GetUserConfigLocID(userId)
		
		s EpisodeID=$p(PAADMRowIDList,"^",index)
		q:(EpisodeID="")
		s AdmLocId=$p(^PAADM(EpisodeID),"^",4)  //患者科室
		
		///由于分配时只会是IsCrossFlag=1||0 所以只使用一个用户计数userNums
		//当分配规则为交叉分配且医师科室和患者科室相同时，跳过此次分配，寻找下一位医师
		//当分配规则为：本科室病历只分配给本科室医师且医师科室和患者科室不相同时，跳过此次分配，寻找下一位医师
		if ((IsCrossFlag=1)&&(AdmLocId=UserLocId))||((IsCrossFlag=0)&&(AdmLocId'=UserLocId))  
		{
			if userNums<UserCount
			{
				s userNums=userNums+1   //从用户总数计数，当查找用户数小于用户总数时，用户计数递增
				
			}else  //当用户数量计数>=用户总数时,表示该患者未找到适合的分配医师，开始分配下一位患者
			{
				s userNums=0
				s index=index+1
			}
			
			continue
			
		}
		
		
		
		s index=index+1
		
		s ^tempUserID("UserID",userId,EpisodeID)=""
	}
	
	if ..IsAssignFinish()="0"
	{
		q "本科室病历不允许分配本科医生!"
		
	}
	
	s result= ..InserAssignInfo(AdmType)
	
	k ^tempUserID("UserID")
    // 删除存放就诊号的临时Global。
	k ^tempSelect("PAADMRowID")
	q result
}

/// Desc:	向数据库中添加该时间段抽查的数据   s ^tempSelect("PAADMRowID")="^1^2^3"
/// Input:  PAADMRowID:就诊号(不用传递)   AdmType 病历类型 门诊O 环节IA 终末ID
/// Note:   就诊号在抽取的时候存放到了临时Global(^tempSelect("PAADMRowID"))
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.AssignInfo).AddAppointAssignInfo("8066")
ClassMethod AddAppointAssignInfo(AdmList As %String, UserList As %String, AdmType) As %String
{
	s result=""
	q:(AdmList="")||(UserList="")
	
	s ^tempUserID("UserID")=""
	
	for i=1:1:$l(AdmList,"^")
	{
		s EpisodeID=$p(AdmList,"^",i)
		s ^tempUserID("UserID",UserList,EpisodeID)=""
	}
	
	s result= ..InserAssignInfo(AdmType)
	
	k ^tempUserID("UserID")
	
	q result
}

/// Desc 将临时global中的数据存入表(EPRinstance.Quality.AssignInfo)里
/// 2020-09-28
/// 分配者ID 分配时间段
/// 这个方法不能单独使用...和头顶的这个方法配合使用
/// debug:w ##Class(EPRservice.Quality.DataAccess.AssignInfo).InserAssignInfo("ID")
ClassMethod InserAssignInfo(AdmType As %String)
{
	///数据存表(EPRinstance.Quality.AssignInfo)
	s result=""
	
	s userId=""
	
	s ExtractInfo=$g(^tempSelect("ExtractInfo"))
	
	s lastAssignDate=$p(ExtractInfo,"^",3)
	q:(lastAssignDate="")||(lastAssignDate="1840-12-31") "意外错误"
	
	for
	{
		s userId=$o(^tempUserID("UserID",userId))
		q:(userId="")
		s EpisodeID="",LastEpisodeID=""
		for
		{
			s EpisodeID=$o(^tempUserID("UserID",userId,EpisodeID))
			q:(EpisodeID="")
			//判断该就诊号是否存在分配表中,如果存在修改isActive字段为Y
			//如果不存在,存入分配表，并设置为Y
			s assignState=..GetAssignState(EpisodeID)
			
			s OBJAssignInfo=""
			
			if (assignState="NA")
			{
				s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%New()
			}
			
			if (assignState="N")
			{
				s rowId=$o(^DHCEPRQ.AssignInfoI("IdxEpisodeID"," "_EpisodeID,""))
				s OBJAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
			}
			s OBJAssignInfo.UserID=userId
			s OBJAssignInfo.EpisodeID=EpisodeID
			s OBJAssignInfo.AdmType=AdmType
			s OBJAssignInfo.IsActive="Y"
			s OBJAssignInfo.LastAssignDate=$p(ExtractInfo,"^",3)
			s sc = OBJAssignInfo.%Save()
			if ($$$ISERR(sc))
			{
				s Error = $system.OBJ.DisplayError(sc)
				s result = "失败^"_Error

			}
			else
			{
				s result = "添加成功"
				s LastEpisodeID=EpisodeID
			}
		}
		
		if (LastEpisodeID'=""){
			s SignUserID=%session.Get("LOGON.USERID")
			s linkParam = "EpisodeId="_LastEpisodeID
			
			s medId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_userId,""))
			
			s locId=""
			
			s:(medId'="") locId=$list(^DHCEPRQ.MedDoctorD(medId),8)
			
			//ASender , AReceiver , AMessageTitle , AMessage , AMessageSource , AEpisodeID , AInstanceId , AEmrDocId , AEntryScore , AExamCount , AEntryID , AResumeText , AResultDetailID , ASendNo  = "1", APath  = "", CtLocDR , AMessageType  = "SEND", AMessagePriority  = "N", AEffectiveType  = "L"
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(SignUserID,userId,"分配消息","已分配病历，请及时质控","QUALITY",LastEpisodeID,"","","","","","","","1","",locId)
			s OtherInfoJson="{""link"":""dhc.emr.messagetab.csp"",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"
			d ##class(websys.DHCMessageInterface).Send("已分配病历请及时质控","1009",SignUserID,LastEpisodeID,"",userId,OtherInfoJson,"","","")
		}
	}
	
	q result
}

/// 批量更新分配医师
ClassMethod UpdateMedDoc(userId, EpisodeIDS) As %String
{
	s result="更新失败!",errorFlag=0
	q:(userId="")||(EpisodeIDS="") result
	
	s admNums=$l(EpisodeIDS,"^")
	
	TSTART
	
	for i=1:1:admNums
	{
		s episodeId=$p(EpisodeIDS,"^",i)
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

/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.AssignInfo","GetAssignInfoByLastDate"," 2019-02-27")
Query GetAssignInfoByLastDate(LastDate, AdmType) As %Query(ROWSPEC = "RegNo,PAPMIName,PAPMISex,MainDiagnos,DischDate,ResidentDays,MedName,PAADMRowID,IsActive,crossCheckFlag")
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
	
	s LastDate=$p((##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(LastDate))," ",1)
	s rowId=""
	for
	{
		s rowId=$o(^DHCEPRQ.AssignInfoI("IdxLastAssignDate"," "_$zd(LastDate,3),rowId))
		
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
			s DischDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
		}
		//住院天数
		s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
		
		s DisDept=##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(PAADMRowID,"")
		
		//诊断
		s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
		
		s checkType=AdmType
		s:(AdmType="O") checkType="AO"
		//是否做交叉质控
		s crossCheckFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(PAADMRowID,checkType)
		
		s:crossCheckFlag>0 crossCheckFlag="Y"
		
		s Data=$lb(RegNo,PAPMIName,PAPMISex,$p(MainDiagnos,"^",3),DischDate,ResidentDays,MedName,PAADMRowID,IsActive,crossCheckFlag)
		
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
/// debug:d ##class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.AssignInfo","GetAssignInfoByUserId","11095","Y","ID") 
Query GetAssignInfoByUserId(UserID, IsChecked, Range) As %Query(ROWSPEC = "ChargeDoc,RegNo,PAPMIName,EpisodeID,CheckedFlag,Grade,Score,ResidentDays,checked,ProblemFlag,MedicareNo,Age,PAPMISex,Illness,TransLocFlag,AdmDateTime,CreateOutUser,MainDiagnos,PAAdmDocName,BedNo")
{
}

ClassMethod GetAssignInfoByUserIdExecute(ByRef qHandle As %Binary, UserID, IsChecked = "N", Range = "") As %Status
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
		//continue:(OBJAssignInfo.IsActive="N")
		
		s EpisodeID=OBJAssignInfo.EpisodeID
		s MedDoc=OBJAssignInfo.UserID
		continue:(Range'="")&&(Range'=OBJAssignInfo.AdmType)
		
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
		
		s SGInfo=##Class(EPRservice.Quality.BOQualityReport).GetMRScoreAndGrade(EpisodeID,"A^G",Range)
		
		s:(SGInfo'="") Score=$p(SGInfo,"^",2),Grade=$p(SGInfo,"^",1)
		
		//是否质控
		s checked="否",checkFlag="N"
		s checkFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(EpisodeID,Range)
		s:checkFlag>0 checkFlag="Y"
		continue:(IsChecked'=checkFlag)&&(IsChecked'="")
		
		s:(checkFlag="Y") checked="是"
		
		s PAADMDepCode=$p($g(mCurrRow),"^",4)
		
		s structId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(PAADMDepCode,2)
		
		s ProblemFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(structId,2,EpisodeID,100,"GetProblemList","")
		
		//s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
		s Papmi = $p(mCurrRow,"^",1)

	    s MedicareNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
		
		s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,EpisodeID,"","")
		
		s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
		
		s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
		
		s Illness = "一般"
		
		s TerminallyIll = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("TerminallyIll")
		
		s DiseaseSeve = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("DiseaseSeve")
		
		s BWYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,TerminallyIll,"")
		
		s BZYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,DiseaseSeve,"")
		
		s:((BWYZ'="")&&(BZYZ="")) Illness = "病危"
		
		s:((BWYZ="")&&(BZYZ'="")) Illness = "病重"
		
		s TransLocFlag = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTransLocCount(EpisodeID)
		
		s AdmDate=$P($g(^PAADM(EpisodeID)),"^",6)
		
		s AdmTime=$P($g(^PAADM(EpisodeID)),"^",7)
		
		s AdmDateTime=$zd(AdmDate,3)
		
		s AdmDateTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDateTime)
  		
  		s CreateOutUser = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateOutUserByEpisodeID(EpisodeID)
		
		//主要诊断
		s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(EpisodeID)
		if (MainDiagnos = "")
	    {
	        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(EpisodeID)
	        //s MainDiagnos = $P(MainDiagnos,"^",3)
	    }
		if (MainDiagnos '= "")
		{	
			s MainDiagnos =$p($p(MainDiagnos,"$",1),"^",3)
			s MainDiagnos = $tr(MainDiagnos,"'","\'")
		}
		s MainDiagnos=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MainDiagnos)
		
		
		s PAAdmDocName="无"
		
		s PAADMDocCode=$p($g(mCurrRow),"^",9)
		
		if (PAADMDocCode '= "")
		{
			s PAAdmDocName = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
		}
		
		s BedNo = ##Class(EPRservice.Quality.DataGather.AdmInfo).DisBed(EpisodeID)
				
		s Data=$lb(ChargeDoc,RegNo,PAPMIName,EpisodeID,CheckedFlag,Grade,Score,ResidentDays,checked,ProblemFlag,MedicareNo,Age,PAPMISex,Illness,TransLocFlag,AdmDateTime,CreateOutUser,MainDiagnos,PAAdmDocName,BedNo)
		
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

/// 检查病历是否分配过
/// 1 已分配，0 未分配
/// debug:w ##class(EPRservice.Quality.DataAccess.AssignInfo).CheckAdmIsAssigned(59\329)
ClassMethod CheckAdmIsAssigned(admList)
{
	s ret=0
	//IdxEpisodeID
	for i=1:1:$l(admList,",")
	{
		s adm=$p(admList,",",i)
		s episodeId=""
		for
		{
			s episodeId=$o(^DHCEPRQ.AssignInfoI("IdxEpisodeID",episodeId))
			q:(episodeId="")
			s rowId=$tr(episodeId," ","")
			
			s:(adm=rowId) ret=1
			q:(ret=1)	
		}	
	}
	
	q ret
}

/// 检测是否分配成功
/// Input:
/// Output:ret=1 成功 ret=0 失败
/// Creator:wzl 2022年11月29日
/// Debug:w ##class(EPRservice.Quality.DataAccess.AssignInfo).IsAssignFinish()
ClassMethod IsAssignFinish()
{
	s ret=0
	s userId=""
	for
	{
		s userId=$o(^tempUserID("UserID",userId))
		q:(userId="")
		
		s admId=""
		for
		{
			s admId=$o(^tempUserID("UserID",userId,admId))
			q:(admId="")
			s ret=1
			q
		}	
	}
	
	q ret
}

/// 检查患者分配状态
/// Y 有效 N 无效 NA 未分配
/// debug:w ##class(EPRservice.Quality.DataAccess.AssignInfo).GetAssignState(59\329)
ClassMethod GetAssignState(adm)
{
	s ret="NA"
	
	s rowId=$o(^DHCEPRQ.AssignInfoI("IdxEpisodeID"," "_adm,""))
	
	q:(rowId="") ret
	
	s objAssignInfo=##class(EPRinstance.Quality.AssignInfo).%OpenId(rowId)
	
	s ret=objAssignInfo.IsActive
	
	q ret
}

}
