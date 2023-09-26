/// ClassName:    DtPortal.Doctor.D01PatList.D0106CpWayPat
/// Description:  临床路径服务
/// Creator：     程鹏
/// CreatDate:    2018-11-03
/// 修改日期：2017-04-13  修改者：hulei
Class DtPortal.Doctor.D01PatList.D0106CpWayPat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     程鹏
/// CreatDate：   2018-11-03
/// Description:  查询医生/主诊组在径患者
/// Table：       User.DHCMRClinicalPathWayInPathLog
/// Input：       queryType:查询范围（P：本人  PG:就诊组）
/// 			  aUserCode     ：医生工号(SS_User.SSUSR_Initials)
/// Return：      admID			就诊号
/// 				  BedNo			床号
/// 				  MedicareNo	病案号
/// 				  Name			姓名
/// 				  Sex			性别
/// 				  Age			年龄
///   			  AdmReason		就诊类型
/// 				  DiagnoseDesc	诊断
/// 				  InDay			在院天数
/// 				  StepDesc		路径步骤
/// 服务号:		  D01.06.01
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0106CpWayPat","D010601AtWaysPat","PG","ys01")
Query D010601AtWaysPat(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "ind,AdmBed,MedicareNo,PatName,PatSex,PatAge,AdmReason,InDept,InTime,MainDiagnosis,InDay,CPWDesc,StepDesc,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010601AtWaysPatExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	new (qHandle,QueryType,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	Quit:UserID="" $$$OK
	Set CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Quit:CareProvID="" $$$OK
	

	//获取就诊患者集合
	set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserID,"")
	
	for admindex=1:1:$l(admPatList,"^")
	{
		set admID=$p(admPatList,"^",admindex)
		set stepDescStr=..IsInPathWay(admID)
		continue:stepDescStr=0
		
		//获取路径当前步骤
		set CPWDesc=$p(stepDescStr,"^",1)
		set StepDesc=$p(stepDescStr,"^",2)
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admID)
		s AdmBed=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s PatName=$p(patInfoStr,"^",2)
		s PatSex=$p(patInfoStr,"^",3)
		s PatAge=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		Set PatientID=$P($g(^PAADM(admID)),"^",1)
		s AdmNo=$p(^PAADM(admID),"^",81)
		s PAPMINo=$p(patInfoStr,"^",7)
		Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
		Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
		
		//取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		s MainDiagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admID)
		
		s InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(admID)  //bmz20170810 在院患者在院天数取公共方法
		
		Set tmpDateTime=##Class(DtPortal.Common.PaadmService).GetAdminDateTime(admID)
		Continue:tmpDateTime=""
		Set InTime=$p(tmpDateTime,"^",1)
		Set:InTime'="" InTime=$zd(InTime,3)
		
		s DeptDr=$p(^PAADM(admID),"^",4)
		s InDept=$p(^CTLOC(DeptDr),"^",2)
		i InDept["-" s InDept=$p(InDept,"-",2)
		
		s InTime="",InDate=""
		Set InDate=$p(tmpDateTime,"^",1)
		Set InTime=$p(tmpDateTime,"^",2)
		i InDate'="" s InDate=$zd(InDate,3)
		i InTime'="" s InTime=$zt(InTime,2)
		if InDate'="" s InDate=$p(InDate,"-",1)_"-"_$p(InDate,"-",2)_"-"_$p(InDate,"-",3)
		s InTime=InDate_"&nbsp;"_InTime
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(admID)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)

		Set Data=$lb(ind,AdmBed,MedicareNo,PatName,PatSex,PatAge,AdmReason,InDept,InTime,MainDiagnosis,InDay,CPWDesc,StepDesc,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  查询指定医的生未入径(在院)患者列表
/// Table：       User.DHCMRClinicalPathWayInPathLog
/// Input：       queryType:查询范围（P：本人  PG:就诊组）
/// 				  aUserCode     ：医生工号(SS_User.SSUSR_Initials)
/// Return：      未入径患者列表
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0106CpWayPat","D010602NotInWaysPat","P","ys01")
Query D010602NotInWaysPat(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "PapmiNo,PatName,PatSex,PatAge,AdmDate,AdmBed,AdmDiagnos,CPWVerDesc,NotInReason,aUserCode,MedicareNo,AdmReason,MainDiagnosis,InDept,DocName,InTime,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId,NoticeDate,NoticeTime,NoticeDocName")
{
}

ClassMethod D010602NotInWaysPatExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	new (qHandle,QueryType,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	Quit:UserID="" $$$OK
	Set CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Quit:CareProvID="" $$$OK
	
	//获取临床路径版本
	set CPWType=##Class(DtPortal.Common.PublicService).getValueByCode("CPWEDITION")
	
	if CPWType="V4"
	{
			
		//获取就诊患者集合
		set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserID,"")
		
		for admindex=1:1:$l(admPatList,"^")
		{
			set EpisodeID=$p(admPatList,"^",admindex)
			set stepDescStr=##class(DHCMA.CPW.IO.ToPortal).CheckIsApply(EpisodeID)
			continue:stepDescStr=""
			
			//已经入经退出
			set isInWay=##class(DHCMA.CPW.IO.ToPortal).CheckCPWStatus(EpisodeID,"I",1) 
			continue:isInWay'=""
					
			//获取路径当前步骤
			set CPWVerDesc=$p(stepDescStr,"^",1)				//路径名称
			set NotInReason=$p(stepDescStr,"^",2)				//未入经理由
			set NoticeDate=$p(stepDescStr,"^",3)				//未入经日期
			set NoticeTime=$p(stepDescStr,"^",4)				//未入经时间
			set:NoticeDate'="" NoticeDate=$zd(NoticeDate,3)
			set:NoticeTime'="" NoticeTime=$zt(NoticeTime,2)
			set NoticeDocName=$p(stepDescStr,"^",5)				//未入经医生
			d NoInway
		}
	}else
	{
		//hulei
		if QueryType="P" {//个人
			set MUDocIDs=CareProvID
		}elseif QueryType="PG" {//主诊组
			//获取医生ID集合
			set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(CareProvID)  
		}else{
			set MUDocIDs=CareProvID
		}
		//hulei
		
		Set AdmType="I"
		Set xLocID=0
		For {
			Set xLocID=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID))
			Quit:xLocID=""
			Set xDate=0
			For {
				Set xDate=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate))
				Quit:xDate=""
				Set xTime=""
				For {
					Set xTime=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime))
					Quit:xTime=""
					
					Set xPaadm=""
					For {
						Set xPaadm=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime,xPaadm))
						Quit:xPaadm=""
						
						Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
						Continue:$p($g(^PAADM(+xPaadm)),"^",20)="C"   //就诊状态过滤
						Set AdmDocID=$p($g(^PAADM(xPaadm)),"^",9)     //主管医生
						Continue:MUDocIDs'[AdmDocID
						
						Set EpisodeID=xPaadm
						Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
						Continue:MRAdm=""
						
						Set IsInPathWay=0
						Set xPathWayID=0
						For {
							Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
							Quit:xPathWayID=""
							Quit:IsInPathWay=1
							
							Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
							Continue:'$IsObject(objPathWay)
							Set IsInPathWay=1
						}
						Continue:IsInPathWay=1
						Set LogInfo=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetLogByPaadm(EpisodeID,"^")
						Continue:LogInfo=""
						Set CPWVerID=$p(LogInfo,"^",8)
						Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWVerID)
						Continue:'$IsObject(objCPW)
						Continue:objCPW.CPWActive'="Y"
						Set CPWVerDesc=objCPW.CPWDesc
						Set LogReasons=$p(LogInfo,"^",9)
						Set LogResume=$p(LogInfo,"^",10)
						Set NotInReason="",NoticeDate="",NoticeTime="",NoticeDocName=""
						For indRea=1:1:$length(LogReasons,",") {
							Set ReasonID=$p(LogReasons,",",indRea)
							Continue:ReasonID=""
							Set objReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
							Continue:'$IsObject(objReason)
							Set NotInReason=NotInReason_objReason.VRDesc_";"
						}
						Set:LogResume'="" NotInReason=NotInReason_LogResume_";"
						d NoInway
					}
				}
			}
		}
	}
	
	Quit $$$OK
					
NoInway
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	quit:(EpisodeID="")||(PatientID="")	
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	s AdmBed=$p(patInfoStr,"^",1)
	s MedicareNo=$p(patInfoStr,"^",5)
	s PatName=$p(patInfoStr,"^",2)
	s PatSex=$p(patInfoStr,"^",3)
	s PatAge=$p(patInfoStr,"^",4)
	s AdmReason=$p(patInfoStr,"^",6)
	
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)

	Set tmpDateTime=##Class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
	quit:tmpDateTime=""
	Set AdmDate=$p(tmpDateTime,"^",1)
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set AdmBedID=$p($g(^PAADM(EpisodeID)),"^",73)


	//取诊断---bmz
	Set MainDiagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	Set AdmDiagnos=MainDiagnosis
	s DeptDr=$p(^PAADM(EpisodeID),"^",4)
	s InDept=$p(^CTLOC(DeptDr),"^",2)
	i InDept["-" s InDept=$p(InDept,"-",2)
	
	s InTime="",InDate=""
	Set InDate=$p(tmpDateTime,"^",1)
	Set InTime=$p(tmpDateTime,"^",2)
	i InDate'="" s InDate=$zd(InDate,3)
	i InTime'="" s InTime=$zt(InTime,2)
	if InDate'="" s InDate=$p(InDate,"-",1)_"-"_$p(InDate,"-",2)_"-"_$p(InDate,"-",3)
	s InTime=InDate_"&nbsp;"_InTime
	

	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EpisodeID=$p(EMRinfo,"^",5)
	
	Set Data=$lb(PapmiNo,PatName,PatSex,PatAge,AdmDate,AdmBed,AdmDiagnos,CPWVerDesc,NotInReason,aUserCode,MedicareNo,AdmReason,MainDiagnosis,InDept,DocName,InTime,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId,NoticeDate,NoticeTime,NoticeDocName)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  查询指定医的临床路径变异(在院)患者列表
/// Table：       User.DHCMRClinicalPathWay
/// Input：       queryType:查询范围（P：本人  PG:就诊组）
/// 				  aUserCode :医生工号(SS_User.SSUSR_Initials)
/// Return：      变异患者
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0106CpWayPat","D010603VarWays","PG","ys01")
Query D010603VarWays(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "PapmiNo,PatName,PatSex,PatAge,InTime,AdmBed,AdmDiagnos,CPWDesc,CurrStep,VarInforStrList,InTime,InDay,MedicareNo,AdmReason,MainDiagnosis,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010603VarWaysExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	new (qHandle,QueryType,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	Quit:UserID="" $$$OK
	Set CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Quit:CareProvID="" $$$OK
	
	//获取临床路径版本
	set CPWType=##Class(DtPortal.Common.PublicService).getValueByCode("CPWEDITION")
	
	if CPWType="V4"
	{
		//获取就诊患者集合
		set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserID,"")
		
		for admindex=1:1:$l(admPatList,"^")
		{
			set EpisodeID=$p(admPatList,"^",admindex)
			set stepDescStr=##class(DHCMA.CPW.IO.ToPortal).CheckCPWStatus(EpisodeID,"","1")
			continue:stepDescStr=""
				
			//获取路径当前步骤
			set CPWDesc=$p(stepDescStr,"^",1)					//路径名称
			set CurrStep=$p(stepDescStr,"^",2)					//当前步骤
			set VarInforStrList=$p(stepDescStr,"^",3)					//变异原因
			
			d TOVarWays
		}
	}else
	{
		//hulei
		if QueryType="P" {//个人
			set MUDocIDs=CareProvID
		}elseif QueryType="PG" {//主诊组
			//获取医生ID集合
			set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(CareProvID)  
		}else{
			set MUDocIDs=CareProvID
		}
		//hulei
		
		Set AdmType="I"
		Set xLocID=0
		For {
			Set xLocID=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID))
			Quit:xLocID=""
			Set xDate=0
			For {
				Set xDate=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate))
				Quit:xDate=""
				Set xTime=""
				For {
					Set xTime=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime))
					Quit:xTime=""
					
					Set xPaadm=""
					For {
						Set xPaadm=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime,xPaadm))
						Quit:xPaadm=""
						
						Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
						Continue:$p($g(^PAADM(+xPaadm)),"^",20)="C"   //就诊状态过滤
						Set AdmDocID=$p($g(^PAADM(xPaadm)),"^",9)     //主管医生
						Continue:MUDocIDs'[AdmDocID
						
						Set EpisodeID=xPaadm
						Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
						Continue:MRAdm=""
						
						Set IsVarPathWay=0
						Set CPWDesc="",CurrStep="",VarReason=""
						Set xPathWayID=0
						For {
							Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
							Quit:xPathWayID=""
							Quit:IsVarPathWay=1
							
							Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
							Continue:'$IsObject(objPathWay)
							Set CPWStatus=objPathWay.CPWStatus
							Continue:CPWStatus'="I"
							Continue:'$IsObject(objPathWay.CPWPathwayDR)
							Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
							Set CurrStepInfo=##class(web.DHCCPW.MR.ClinicalPathWays).GetCurrentStepInfo(EpisodeID)
							Set CurrStep=$p(CurrStepInfo,"^",4)
							Continue:CurrStep=""
							
							Set VarianceList=""
							
							set VarInforStrList=""
							
							Set xSubID=""
							For {
								Set xSubID=$o(^DHCMR("CPW",xPathWayID,"VAR",xSubID),-1)
								Quit:xSubID=""
								
								Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(xPathWayID_"||"_xSubID)
								Continue:'$IsObject(objVar)
								Continue:objVar.CPWVUpdoFlag="Y"
								Continue:'$IsObject(objVar.CPWVReasonDR)
								Set VarReason=objVar.CPWVReasonDR.VRDesc
								Continue:VarReason=""
								Set VarNote=objVar.CPWVNote
								set CPWVReasonDR=""
								set CPWVDate=$zd(objVar.CPWVDate,3)
								set CPWVTime=$zt(objVar.CPWVTime,2)
								set CPWVUserDR=objVar.CPWVUserDR
								set CPWVUserName=$p(^SSU("SSUSR",CPWVUserDR),"^",2)
								
								If $listfind(VarianceList,VarReason)<1 {
									Set CPWVReasonDR=VarReason
									set VarianceList=VarianceList_$lb(VarReason)
								}
								If VarNote'="" {
									If $listfind(VarianceList,VarNote)<1 {
										Set CPWVReasonDR=CPWVReasonDR_";"_VarNote
										set VarianceList=VarianceList_$lb(VarNote)
									}
								}
								set VarInforStr=CPWVReasonDR_"("_CPWVDate_"&nbsp;"_CPWVTime_"--"_CPWVUserName_")"
								set VarInforStrList=VarInforStrList_"||"_VarInforStr
							}
							Continue:VarianceList=""
							
							Set IsVarPathWay=1
							
							
						}
						Continue:IsVarPathWay'=1
						d TOVarWays
					}
				}
			}
		}
	}
	 
	Quit $$$OK

TOVarWays
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	q:(EpisodeID="")||(PatientID="")
	
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	s AdmBed=$p(patInfoStr,"^",1)
	s MedicareNo=$p(patInfoStr,"^",5)
	s PatName=$p(patInfoStr,"^",2)
	s PatSex=$p(patInfoStr,"^",3)
	s PatAge=$p(patInfoStr,"^",4)
	s AdmReason=$p(patInfoStr,"^",6)
	
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	Set tmpDateTime=##Class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
	q:tmpDateTime=""
	Set InTime=$p(tmpDateTime,"^",1)
	
	Set InTime=$zd(InTime,3)
	Set AdmBedID=$p($g(^PAADM(EpisodeID)),"^",73)
	Set AdmBed=$p($g(^PAWARD(+AdmBedID,"BED",+$p(AdmBedID,"||",2))),"^",1)

	s InTime="",InDate=""
	s TRANSId=$o(^PAADM(EpisodeID,"TRANS",0)) 
	i TRANSId'="" s InTime=$p($g(^PAADM(EpisodeID,"TRANS",TRANSId)),"^",2)
	i TRANSId'="" s InDate=$p($g(^PAADM(EpisodeID,"TRANS",TRANSId)),"^",1)
	i InDate'="" s InDate=$zd(InDate,3)
	i InTime'="" s InTime=$zt(InTime,2)

	//用于传向前台格式---bmz  加空格
	if InDate'="" s InDate=$p(InDate,"-",1)_"-"_$p(InDate,"-",2)_"-"_$p(InDate,"-",3)
	s InTime=InDate_"&nbsp;"_InTime
	//取诊断---bmz
	Set MainDiagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	Set AdmDiagnos=MainDiagnosis
	//入院天数
	s InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)  //bmz20170814 在院患者在院天数取公共方法

	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EpisodeID=$p(EMRinfo,"^",5)
	
	Set Data=$lb(PapmiNo,PatName,PatSex,PatAge,InTime,AdmBed,AdmDiagnos,CPWDesc,CurrStep,VarInforStrList,InTime,InDay,MedicareNo,AdmReason,MainDiagnosis,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

/// Creator：     chengppeng
/// CreatDate：   2014-08-19
/// Description:  判断在院患者是否在路径中
/// Input：       就诊号 aEpisodeID
/// Return：      返回0：不在路径    返回1  ：在路径
/// w ##class(DtPortal.Doctor.D01PatList.D0106CpWayPat).IsInPathWay(266)
/// w ##class(DtPortal.Doctor.D01PatList.D0106CpWayPat).IsInPathWay(578)
ClassMethod IsInPathWay(aEpisodeID As %String)
{
	new (aEpisodeID)
	set return=0
	
	//获取临床路径版本
	set CPWType=##Class(DtPortal.Common.PublicService).getValueByCode("CPWEDITION")
	
	if CPWType="V4"
	{
		set ret=##class(DHCMA.CPW.IO.ToPortal).CheckCPWStatus(aEpisodeID,"I",0) 
		set:ret'="" return=ret
	}else
	{
		Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
		Set xPathWayID=0
		For {
			Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,xPathWayID))
			Quit:xPathWayID=""			
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
			Continue:'$IsObject(objPathWay)
			set CPWPathwayDR=objPathWay.CPWPathwayDR.CPWDesc
			Set return=CPWPathwayDR
			}
		//获取路径当前步骤
		set stepDescStr=##class(web.DHCCPW.MR.ClinicalPathWays).GetCurrentStepInfo(aEpisodeID)
		set StepDesc=$p(stepDescStr,"^",4)
		set:StepDesc'="" return=return_"^"_StepDesc
	}
	quit return
}

}
