/// ClassName:    DHCHAI.IO.ToDtPortal02
///               替换类DtPortal.MD.MD10InfectionAlert
/// Description:  Portal感染爆发预警及疑似病例方法接口
/// Creator：     zhufei
/// CreatDate:    2018-03-19
Class DHCHAI.IO.ToDtPortal02 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询最近一段时间内爆发预警人数分布（接口MD10.01.01、MD01.05.01）
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCItmWarn
/// Input：       aFromDate : 开始日期
///               aToDate   : 结束日期
///               aWardID   ：病区ID
/// 	      aHospID   ：医院ID
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","QryLocWarning","2020-01-20","2020-01-20")
Query QryLocWarning(aFromDate As %String, aToDate As %String, aWardID As %String = "", aHospID As %String = "") As DtPortal.Query(ROWSPEC = "WardID:%String,ActWard:%String,WarnTypes:%String,AllSum:%String,AllWarnSum:%String,Outbreak:%String")
{
}

ClassMethod QryLocWarningExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aWardID As %String = "", aHospID As %String = "") As %Status
{
	new (qHandle,aFromDate,aToDate,aWardID,aHospID)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//暴发预警：开始日期=结束日期
 	Set:aFromDate["-" aFromDate=$zdh(aFromDate, 3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate, 4)
	Set:aToDate["-" aToDate=$zdh(aToDate, 3)
	Set:aToDate["/" aToDate=$zdh(aToDate, 4)
	Quit:((aFromDate="")||(aToDate="")) $$$OK
	
 	Kill ^||TMP("WARDWARN")
 	Kill ^||TMP("WARDWARNPaadm")
 	
 	Set WarnDate=aFromDate
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetWarningPatInfo(WarnDate,aWardID)
 	Quit:arr.Count()<1 $$$OK
 
 	For indEpis=1:1:arr.Count() {
	 	Set WarningInfo=arr.GetAt(indEpis)
	 	Continue:WarningInfo=""
	 	Set EpisodeDr=$p(WarningInfo,"^",1)
	 	Set EpisodeID=$p(WarningInfo,"^",2)
	 	Set WarnDate=$p(WarningInfo,"^",3)
	 	Set SummaryStr=$p(WarningInfo,"^",4)
	 	Set WarnLocID=$p(WarningInfo,"^",5)
		
	 	Set hospID=$p($g(^CTLOC(WarnLocID)),"^",22)
	 	Continue:(aHospID'="")&&(aHospID'=hospID)
	 	Continue:EpisodeID=""
	 	Continue:SummaryStr=""
	 	
	 	//SummaryStr包含项目：实时现患||3^发热|7|3^检出同种同源菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3
	 	For indSS=1:1:$l(SummaryStr,",") {
		 	Set tSummary=$p(SummaryStr,",",indSS)
		 	Continue:tSummary=""
		 		 	
		 	If '$d(^||TMP("WARDWARN",WarnLocID,tSummary,EpisodeID)) {
				Set ^||TMP("WARDWARN",WarnLocID,tSummary,EpisodeID)=EpisodeID
				Set num=$i(^||TMP("WARDWARN",WarnLocID,tSummary))
			}
	
			If '$d(^||TMP("WARDWARNPaadm",WarnLocID,EpisodeID)) {
				Set ^||TMP("WARDWARNPaadm",WarnLocID,EpisodeID)=EpisodeID
				Set num=$i(^||TMP("WARDWARNPaadm",WarnLocID))
			}
		}
	}
 
 	Set xWardID=""
 	For {
	 	Set xWardID=$o(^||TMP("WARDWARN",xWardID))
	 	Quit:xWardID=""
	 	
	 	Set WarnTypes=""
	 	Set SumNum=0
	 	Set xSummary=""
 		For {
	 		Set xSummary=$o(^||TMP("WARDWARN",xWardID,xSummary))
	 		Quit:xSummary=""
	 		
	 		Set SumNum=+$g(^||TMP("WARDWARN",xWardID,xSummary))
	 	    Continue:SumNum<3
	 	    Set WarnTypes=WarnTypes_","_xSummary
	 	 	
	 	 	Set xEpisodeID=""
	 		For {
		 		Set xEpisodeID=$o(^||TMP("WARDWARN",xWardID,xSummary,xEpisodeID))
		 		Quit:xEpisodeID=""
		 		
		 		If '$d(^||TMP("WARDWARN",xWardID,xEpisodeID)) {
					Set ^||TMP("WARDWARN",xWardID,xEpisodeID)=xEpisodeID
					Set num=$i(^||TMP("WARDWARN",xWardID))
				}
	 		}
 		}
 		Continue:WarnTypes=""
	    Set WarnTypes=$e(WarnTypes,2,$l(WarnTypes))
	   
	    //预警总人数
        Set AllWarnSum = +$g(^||TMP("WARDWARNPaadm",xWardID)) 	//此字段获取的为全部类型的患者数，明细数据中过滤其他类型的数据，该数据不能直接做科室预警人数值
        Set AllSum = +$g(^||TMP("WARDWARN",xWardID)) //预警类型例数超过3预警的总人数
        
 		Set ActWard=$p($g(^CTLOC(+xWardID)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		//add 20220302 判断病区是否处置为疑似聚集，据此判断是否感染暴发病区
		Set Outbreak=0		
		Set xActID=""
		For {
			Set xActID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDate",xWardID,WarnDate,xActID))
			Quit:xActID=""
			
			Set objAct =##class(DHCHAI.IR.CCWarningAct).GetObjById(xActID)
			Continue:'$IsObject(objAct)
			Set ActStatus=objAct.IRActStatus
			Continue:ActStatus'=1
			Set Outbreak=1
			Quit
		}
		 
 		Set Data=$lb(xWardID,ActWard,WarnTypes,AllSum,AllWarnSum,Outbreak)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
			
	}
	Kill ^||TMP("WARDWARN")
	Kill ^||TMP("WARDWARNPaadm")
	
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询各病区院感暴发预警病人详细信息（接口MD10.01.02、MD01.05.02）
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCItmWarn
/// Input：       aFromDate : 开始日期
///               aToDate   : 结束日期
///               aWardID   ：病区ID
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","QryLocWarningDtl","2020-04-02","2020-04-02","151","实时现患")
Query QryLocWarningDtl(aFromDate As %String, aToDate As %String, aWardID As %String, aWarnType As %String = "") As DtPortal.Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PAPMINo:%String,BedNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,MedicareNo:%String,WarnDate:%String,WarnSummary:%String,PatientDoctor:%String,ICDDesc:%String,WarnLocID:%String,Ward:%String,AdmitDateTime:%String,DisDateTime:%String,WarnTypes:%String")
{
}

ClassMethod QryLocWarningDtlExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aWardID As %String, aWarnType As %String = "") As %Status
{
	new (qHandle,aFromDate,aToDate,aWardID,aWarnType)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//暴发预警：开始日期=结束日期
 	Set:aFromDate["-" aFromDate=$zdh(aFromDate, 3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate, 4)
	Set:aToDate["-" aToDate=$zdh(aToDate, 3)
	Set:aToDate["/" aToDate=$zdh(aToDate, 4)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Kill ^||TMP("WARDWARNDtl")
	
 	Set WarnDate=aFromDate
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetWarningPatInfo(WarnDate,aWardID)
 	Quit:arr.Count()<1 $$$OK
 	For indEpis=1:1:arr.Count() {
	 	Set WarningInfo=arr.GetAt(indEpis)
	 	Continue:WarningInfo=""
	 	Set EpisodeDr=$p(WarningInfo,"^",1)
	 	Set EpisodeID=$p(WarningInfo,"^",2)
	 	Set WarnDate=$p(WarningInfo,"^",3)
	 	Set SummaryStr=$p(WarningInfo,"^",4)
	 	Set WarnLocID=$p(WarningInfo,"^",5)
	 	Continue:EpisodeID=""
	 	Continue:SummaryStr="" 	
	 	
	 	Set WarnTypes=""
	 	For indSS=1:1:$l(SummaryStr,",") {
		 	Set tSummary=$p(SummaryStr,",",indSS)
		 	Continue:tSummary=""
		 	Continue:(aWarnType'="")&&(tSummary'=aWarnType)
		 		 	
		 	If '$d(^||TMP("WARDWARNDtl",WarnLocID,tSummary,EpisodeID)) {
				Set ^||TMP("WARDWARNDtl",WarnLocID,tSummary,EpisodeID)=""
				Set num=$i(^||TMP("WARDWARNDtl",WarnLocID,tSummary))
			}
		}
		If '$d(^||TMP("WARDWARNDtl","WarnTypes",EpisodeID)) {
			Set ^||TMP("WARDWARNDtl","WarnTypes",EpisodeID)=SummaryStr
		}
	}
 
 	Set xWardID=""
 	For {
	 	Set xWardID=$o(^||TMP("WARDWARNDtl",xWardID))
	 	Quit:xWardID=""
	 	
	 	Set SumNum=0
	 	Set xSummary=""
 		For {
	 		Set xSummary=$o(^||TMP("WARDWARNDtl",xWardID,xSummary))
	 		Quit:xSummary=""
	 		
	 		Set SumNum=+$g(^||TMP("WARDWARNDtl",xWardID,xSummary))
	 	    Continue:SumNum<3    //只显示异常预警类型
	 	    	
	 	    Set xEpisodeID=""
 			For {
	 			Set xEpisodeID=$o(^||TMP("WARDWARNDtl",xWardID,xSummary,xEpisodeID))
	 			Quit:xEpisodeID=""
	 		
	 	       	If '$d(^||TMP("WARDWARNDtl",xWardID,"Paadm",xEpisodeID)) {
					Set ^||TMP("WARDWARNDtl",xWardID,"Paadm",xEpisodeID)=""
			  	}
			  
			  	Set ^||TMP("WARDWARNDtl",xWardID,"Summary",xEpisodeID)=$g(^||TMP("WARDWARNDtl",xWardID,"Summary",xEpisodeID))_","_xSummary
 			}
 			
 		}
 		
 		Set Ward=$p($g(^CTLOC(+xWardID)),"^",2)
		Set:$p(Ward,"-",2)'="" Ward=$p(Ward,"-",2)
		
 		Set xPaadm = ""
 		For {
	 		Set xPaadm=$o(^||TMP("WARDWARNDtl",xWardID,"Paadm",xPaadm))
	 		Quit:xPaadm=""
	 		
	 		Set SummaryStr=$g(^||TMP("WARDWARNDtl",xWardID,"Summary",xPaadm))
	 		Set:SummaryStr'="" SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
	      
		 	Set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(xPaadm)
			Quit:PatInfo=""
			Set BedNo=$p(PatInfo,"^",1)                                         //床号
			Set Name=$p(PatInfo,"^",2)											//姓名
			Set Sex=$p(PatInfo,"^",3)											//性别
			Set Age=$p(PatInfo,"^",4)                                           //年龄
			Set MedicareNo=$p(PatInfo,"^",5)									//病案号
			Set AdmReason=$p(PatInfo,"^",6)										//费用类别
			
			Set AdmDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(xPaadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set AdmDateTime = AdmDate_" "_AdmTime
			
			Set DischDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(xPaadm)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
			Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:DischTime'="" DischTime=$zt(DischTime,1)
			Set DischDateTime = DischDate_" "_DischTime
			
			Set ICDDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(xPaadm) //诊断
			Set PatientID=$P($g(^PAADM(xPaadm)),"^",1)
			Set PAPMINo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1) 					//登记号	
		
			Set DocData=$g(^CTPCP(+$p(^PAADM(+xPaadm),"^",9)))
		    Set DoctorCode=$p(DocData,"^",1)
		    Set DoctorName=$p(DocData,"^",2)      //主管医生 
            Set WarnTypes =$g(^||TMP("WARDWARNDtl","WarnTypes",xPaadm))

			Set Data=$lb(xPaadm,PatientID,PAPMINo,BedNo,Name,Sex,Age,InPatientMrNo,WarnDate,SummaryStr,DoctorName,ICDDesc,xWardID,Ward,AdmitDateTime,DisDateTime,WarnTypes)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		} 
	 
	}
	
	Kill ^||TMP("WARDWARNDtl")
	
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询最近一段时间内院感爆发病区数量和疑似病例总人数(不再使用)
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCScreenAtt
/// Input：       aFromDate : 疑似病例开始日期
///               aToDate   : 疑似病例结束日期
/// 				  aWarningDate :暴发预警日期
/// 	      aHospID   : 医院ID
/// w ##class(DHCHAI.IO.ToDtPortal02).GetAllWarning(+$h-3,+$h)
ClassMethod GetAllWarning(aFromDate As %String = "", aToDate As %String = "", aWarningDate As %String = "", aHospID As %String = "") As DtPortal.OutPut
{
	New (aFromDate,aToDate,aWarningDate,aHospID)
	Quit:(aFromDate="")||(aToDate="")||(aWarningDate="")
	#Dim return As DtPortal.OutPut
	Set return=##class(DtPortal.OutPut).%New()
	
	Set $zt="GetAllWarning"
	Set:aFromDate["-" aFromDate=$zdh(aFromDate, 3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate, 4)
	Set:aToDate["-" aToDate=$zdh(aToDate, 3)
	Set:aToDate["/" aToDate=$zdh(aToDate, 4)
	Set:aWarningDate["-" aWarningDate=$zdh(aWarningDate, 3)
	Set:aWarningDate["/" aWarningDate=$zdh(aWarningDate, 4)
	
	Set (WardNum,WardPatNum)=0
	
	Set rset = ##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarning")
	Do rset.Execute(aWarningDate,aWarningDate,"",aHospID)
	
	While (rset.Next()) {
		Set WardNum=WardNum+1
	}
	
	//按日期筛查预警信息
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningPatInfo(aFromDate,aToDate)
	Quit:arr.Count()<1 $$$OK
 	For indEpis=1:1:arr.Count() {
	 	Set ScreeningInfo=arr.GetAt(indEpis)
	 	Continue:ScreeningInfo=""
	 	Set EpisodeDr=$p(ScreeningInfo,"^",1)
	 	Set EpisodeID=$p(ScreeningInfo,"^",2)
	 	Set IsSusInf=$p(ScreeningInfo,"^",3)
	 	Set IsSuspend=$p(ScreeningInfo,"^",4)
	 	Set ScreenLocID=$p(ScreeningInfo,"^",5)
	 	Set hospID=$p($g(^CTLOC(ScreenLocID)),"^",22)
		Continue:(aHospID'="")&&(aHospID'=hospID)
		
	 	Continue:EpisodeID=""
	 	Continue:IsSusInf'=1  //疑似病例
	 	Continue:(IsSuspend'=0)&&(IsSuspend'=1) //0疑似未确诊、1确诊未上报
	 	Set WardPatNum=WardPatNum+1
 	}
 	
	Set return.status=1
	Set return.errMSG=""
	Set return.data=WardNum_"^"_WardPatNum
	Quit return
	
GetAllWarning
	Set return.status=-1
	Set return.errMSG=$ZE
	Set return.data=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询病区当前疑似病例信息（接口MD12.01.01）
/// Table：       DHCHAI.IR.CCScreenAtt、DHCHAI.IR.INFDiagnos、DHCHAI.IR.INFReport
/// Input：       aFromDate : 开始日期
///               aToDate   : 结束日期
/// 	          aHospID   : 医院ID
/// 	          aDateType   : 日期类型
/// return：      病区ID WardId（HIS中的WardID）、病区描述WardDesc、疑似未处置人数SuspectedUnprocessed、确诊未报人数ConfirmedUnreported、感染人数InfectionPatients、感染例数InfectionCases
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","QryLocCases","2020-04-27","2020-04-27","","A")   
Query QryLocCases(aFromDate As %String, aToDate As %String, aHospID As %String = "", aDateType As %String = "A") As DtPortal.Query(ROWSPEC = "WardID:%String,WardDesc:%String,SuspectedUnprocessed:%String,ConfirmedUnreported:%String,InfectionPatients:%String,InfectionCases:%String")
{
}

ClassMethod QryLocCasesExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String = "", aDateType As %String = "A") As %Status
{
	New (qHandle,aFromDate,aToDate,aHospID,aDateType)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aFromDate["-" aFromDate=$zdh(aFromDate, 3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate, 4)
	Set:aToDate["-" aToDate=$zdh(aToDate, 3)
	Set:aToDate["/" aToDate=$zdh(aToDate, 4)
	
	Quit:(aDateType'="A")&&((aFromDate="")||(aToDate="")) $$$OK
	
	Kill ^||InfectionWardNub
	
	//查询疑似待处置和确诊未报患者数量
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningPatInfo(aFromDate,aToDate,aDateType)
	For indEpis=1:1:arr.Count() {
	 	Set ScreeningInfo=arr.GetAt(indEpis)
	 	Continue:ScreeningInfo=""
	 	Set EpisodeDr=$p(ScreeningInfo,"^",1)	//DHCHAI.DP.PAAdm表的ID
	 	Set EpisodeID=$p(ScreeningInfo,"^",2)	//HIS的就诊号
	 	Continue:EpisodeDr=""
	 	
	 	Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objPaadm)
		Set WardID=objPaadm.WardID
		
	 	//查询时段内的感染人数和感染病例
		Set InfInfo = ##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnosByAdm(EpisodeDr)		
		Continue:InfInfo=""
		Set IsInf = $p(InfInfo,"^",1)
		Set InfCnt = $p(InfInfo,"^",2)
		
		If (IsInf=1) {
			If '$d(^||InfectionWardNub($j,"QryLocCases",WardID,"INPE",EpisodeID)) {
				Set num=$i(^||InfectionWardNub($j,"QryLocCases",WardID,"INPE"))
				Set ^||InfectionWardNub($j,"QryLocCases",WardID,"INPE",EpisodeID)=""
			}
		}
		If (InfCnt'=0) {
			If '$d(^||InfectionWardNub($j,"QryLocCases",WardID,"INCA",EpisodeID)) {			
				Set num=+$g(^||InfectionWardNub($j,"QryLocCases",WardID,"INCA"))
				Set ^||InfectionWardNub($j,"QryLocCases",WardID,"INCA")=num+InfCnt
				Set ^||InfectionWardNub($j,"QryLocCases",WardID,"INCA",EpisodeID)=""
			}
		}
		//查询疑似待处置和确诊未报患者数量		
		Set StatusByAdmInfo=##class(DHCHAI.IO.ToDtPortalSrv).GetScreenStatusByAdm(EpisodeDr)
		Continue:StatusByAdmInfo=""
		Set IsSuspend=$p(StatusByAdmInfo,"^",3)
	 	Set IsConfirmed=$p(StatusByAdmInfo,"^",4)
	 	
	 	Continue:(IsSuspend'=0)&&(IsConfirmed'=1) //IsSuspend=0疑似待处理、IsConfirmed=1确诊未上报	
		
		If IsSuspend=0 {
			Set num=$i(^||InfectionWardNub($j,"QryLocCases",WardID,"SUSP"))
		}
		If IsConfirmed=1 {
			Set num=$i(^||InfectionWardNub($j,"QryLocCases",WardID,"DIAG"))
		}
 	}
	
	Set FWardID=0
	For {
		set FWardID=$o(^||InfectionWardNub($j,"QryLocCases",FWardID))
		Quit:FWardID=""
		
		//过滤院区 可能要修改
		s wardLocId=$p(^PAWARD(FWardID),"^",5)
		s hospID=$p($g(^CTLOC(wardLocId)),"^",22)
		Continue:(aHospID'="")&&(aHospID'=hospID)
		
		Set (Num1,Num2,Num3,Num4)=0
		set Num1=+$g(^||InfectionWardNub($j,"QryLocCases",FWardID,"SUSP"))
		set Num2=+$g(^||InfectionWardNub($j,"QryLocCases",FWardID,"DIAG"))
		set Num3=+$g(^||InfectionWardNub($j,"QryLocCases",FWardID,"INPE"))
		set Num4=+$g(^||InfectionWardNub($j,"QryLocCases",FWardID,"INCA"))
		Continue:(Num1=0)&&(Num2=0)&&(Num3=0)&&(Num4=0)
		Set ActWard=$p($g(^PAWARD(+FWardID)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		Set Data=$lb(FWardID,ActWard,Num1,Num2,Num3,Num4)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^||InfectionWardNub
	
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  根据类型查询当前病区疑似未处置、确诊未报病人、感染人数、感染例数信息（接口MD12.01.02）
/// Table：       DHCHAI.IR.CCScreenAtt、DHCHAI.IR.INFDiagnos、DHCHAI.IR.INFReport
/// Input：       aFromDate : 开始日期
///               aToDate   : 结束日期
///               aInfType  : 1-疑似未处置人数；2-确诊未上报人数；3-感染人数；4-感染例数
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","QryLocCasesXDtl","2020-04-27","2020-04-27","","1")
Query QryLocCasesXDtl(aFromDate As %String, aToDate As %String, aWardID As %String = "", aInfType As %String = "", aDateType As %String = "A") As DtPortal.Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PAPMINo:%String,BedNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,MedicareNo:%String,InpatientDiagnosis:%String,InPatientDate:%String,PatientDoctor:%String,InfectionDiagnosis:%String,InfectionKPI:%String,InfectionFactors:%String,WardID:%String,WardDesc:%String")
{
}

ClassMethod QryLocCasesXDtlExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aWardID As %String = "", aInfType As %String = "", aDateType As %String = "A") As %Status
{
	new (qHandle,aFromDate,aToDate,aWardID,aInfType,aDateType)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aFromDate["-" aFromDate=$zdh(aFromDate, 3)
	Set:aFromDate["/" aFromDate=$zdh(aFromDate, 4)
	Set:aToDate["-" aToDate=$zdh(aToDate, 3)
	Set:aToDate["/" aToDate=$zdh(aToDate, 4)

	Set:aFromDate="" aFromDate=0
	Set:aToDate="" aToDate=$p($h,",",1)
       	
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningPatInfo(aFromDate,aToDate,aDateType)
	For indEpis=1:1:arr.Count() {
	 	Set ScreeningInfo=arr.GetAt(indEpis)
	 	Continue:ScreeningInfo=""
	 	Set EpisodeDr=$p(ScreeningInfo,"^",1)
	 	Set EpisodeID=$p(ScreeningInfo,"^",2)
	 	Continue:EpisodeID=""
	 	
	 	Set StatusByAdmInfo=##class(DHCHAI.IO.ToDtPortalSrv).GetScreenStatusByAdm(EpisodeDr)
		//Continue:StatusByAdmInfo=""
		if (StatusByAdmInfo'=""){
			Set IsSuspend=$p(StatusByAdmInfo,"^",3)
	 		Set IsConfirmed=$p(StatusByAdmInfo,"^",4)
		}else{
			Set IsSuspend=""
	 		Set IsConfirmed=""
		}
	 	Continue:(aInfType=1)&&(IsSuspend'=0)  //IsSuspend=0疑似待处理
	 	Continue:(aInfType=2)&&(IsConfirmed'=1)  //IsConfirmed=1确诊未上报
	 		
	    //查询时段内的感染人数和感染病例
		Set InfInfo = ##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnosByAdm(EpisodeDr)
		Continue:((aInfType=3)||(aInfType=4))&&(InfInfo="")
		Set IsInf = $p(InfInfo,"^",1)
		Set InfCnt = $p(InfInfo,"^",2)
		
		Continue:(aInfType=3)&&(IsInf'=1)  //感染人数
		Continue:(aInfType=4)&&(IsInf'=1)  //感染人数
		
		Do LocCasesXDtlList(EpisodeID,EpisodeDr)
	
	}
	Quit $$$OK	
	
LocCasesXDtlList(EpisodeID,EpisodeDr)
	Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm)
	Set WardID=objPaadm.WardID      //病区ID
	Quit:(aWardID'="")&&(WardID'=aWardID)
	Set WardDesc=""
	Set:WardID'="" WardDesc=$p($g(^PAWARD(WardID)),"^",2)	
	Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)						//病区描述
	
	Set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(EpisodeID)
	Quit:PatInfo=""
	Set BedNo=$p(PatInfo,"^",1)                                         //床号
	Set Name=$p(PatInfo,"^",2)											//姓名
	Set Sex=$p(PatInfo,"^",3)											//性别
	Set Age=$p(PatInfo,"^",4)                                           //年龄
	Set MedicareNo=$p(PatInfo,"^",5)									//病案号
	Set AdmReason=$p(PatInfo,"^",6)										//费用类别
	
	Set AdmDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set AdmDateTime = AdmDate_" "_AdmTime
	
	Set ICDDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID) //诊断
	Set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
	Set PAPMINo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1) 					//登记号	
	
	Set DocData=$g(^CTPCP(+$p(^PAADM(+EpisodeID),"^",9)))
    Set DoctorCode=$p(DocData,"^",1)
    Set DoctorName=$p(DocData,"^",2)      //主管医生
    //感染诊断、感染指标、感染因素
    Set ScreenInfo = ##class(DHCHAI.IO.ToDtPortalSrv).GetScreenItemByAdm(EpisodeDr)
    Set InfDiags=$p(ScreenInfo,"^",1)
    Set SrceenItems=$p(ScreenInfo,"^",2)
    Set InfFactors=$p(ScreenInfo,"^",3)  
	Set Data=$lb(EpisodeID,PatientID,PAPMINo,BedNo,Name,Sex,Age,MedicareNo,ICDDesc,AdmDateTime,DoctorName,InfDiags,SrceenItems,InfFactors,WardID,WardDesc)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
 
	Quit
}

/// Creator：     chengpeng
/// CreatDate：   2014-11-13
/// Description:  查询更多院感暴发信息
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       aStartDate		开始时间
/// Input：       aEndDate			结束时间
/// Input：       aWardID			病区ID
/// Input：       aLocID			科室ID
/// Input：       aHospID			医院ID
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","FindMoreWarningPat","2018-03-01","2018-03-30","","")
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","FindMoreWarningPat","","","","")
Query FindMoreWarningPat(aStartDate As %String, aEndDate As %String, aWardID As %String = "", aLocID As %String = "", aHospID As %String = "") As DtPortal.Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,BedNo:%String,ActDept:%String,LocDesc:%String,WardID:%String,WardDesc:%String,InDate:%String,ICDDesc:%String,DoctorName:%String,ActDate:%String,ActTime:%String,ItemDesc:%String,DataValue:%String,DataSummary:%String,KeyDesc:%String,EpisodeID:%String")
{
}

ClassMethod FindMoreWarningPatExecute(ByRef qHandle As %Binary, aStartDate As %String, aEndDate As %String, aWardID As %String = "", aLocID As %String = "", aHospID As %String = "") As %Status
{
	new (qHandle,aStartDate,aEndDate,aLocID,aWardID,aHospID)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set:aStartDate["-" aStartDate=$zdh(aStartDate, 3)
	Set:aStartDate["/" aStartDate=$zdh(aStartDate, 4)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate, 3)
	Set:aEndDate["/" aEndDate=$zdh(aEndDate, 4)
	Quit:(aStartDate="")||(aEndDate="") $$$OK
	
	Set WarnDate=aStartDate
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetWarningPatInfo(WarnDate,"")
 	Quit:arr.Count()<1 $$$OK
 	For indEpis=1:1:arr.Count() {
	 	Set WarningInfo=arr.GetAt(indEpis)
	 	Continue:WarningInfo=""
	 	Set EpisodeDr=$p(WarningInfo,"^",1)
	 	Set EpisodeID=$p(WarningInfo,"^",2)
	 	Set WarnDate=$p(WarningInfo,"^",3)
	 	Set SummaryStr=$p(WarningInfo,"^",4)
	 	Set WarnLocID=$p(WarningInfo,"^",5)
	 	Continue:EpisodeID=""
	 	Continue:SummaryStr=""
	 	
		Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objPaadm)
		Set WardID=objPaadm.WardID      //病区ID
		Set LocID=objPaadm.DepartmentID //科室ID
		
		Set hospID=$p($g(^CTLOC(LocID)),"^",22)
		Continue:(aHospID'="")&&(aHospID'=hospID)	// 过滤院区
		Set LocDesc=objPaadm.Department	//科室名称
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2) //科室描述
		set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(EpisodeID)
		Continue:PatInfo=""
		set Name=$p(PatInfo,"^",2)											//姓名
		set Sex=$p(PatInfo,"^",3)											//性别
		set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
		set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) //统一调用计费组的年龄接口
		set MedicareNo=$p(PatInfo,"^",5)									//病案号
		set AdmReason=$p(PatInfo,"^",6)										//费用类别
		set BedNo=$p(PatInfo,"^",1)											//床号
		set WardDesc=objPaadm.Ward										
		set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)						//病区描述
		set LocDesc=objPaadm.Department			
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)							//科室描述
		// 修复bug：623181：Portal-医务部-医院感染-暴发预警-病区明细数据与主页面数据不一致
		// 预警日期患者所在的科室病区
		Set PatLocWard=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,WarnDate,"")
		Continue:PatLocWard=""
		Set WarnLocDr  = $p(PatLocWard,"^",1) // 科室
		Set WarnWardDr = $p(PatLocWard,"^",2) // 病区
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(WarnLocDr)
		If $IsObject(objLoc) {
			Set LocXCode=objLoc.BTXCode
			Set LocID=$p(LocXCode,"||",2)
			Set LocDesc=objLoc.BTDesc2
			Set:LocDesc="" LocDesc=objLoc.BTDesc
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		}
		Set objWard=##class(DHCHAI.BT.Location).GetObjById(WarnWardDr)
		If $IsObject(objWard) {
			Set LocXCode=objWard.BTXCode
			Set WardID=$p(LocXCode,"||",2)
			Set WardDesc=objWard.BTDesc2
			Set:WardDesc="" WardDesc=objWard.BTDesc
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		}	
		Continue:(aWardID'="")&&(WardID'=aWardID)
		Continue:(aLocID'="")&&(aLocID'=LocID)
		
		//调用统一取入院时间的接口   by cfyc 20170120
		set InDate=""
		set inDateTimeStr=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
		set InDate=$p(inDateTimeStr,"^",1)
		Set:InDate'="" InDate=$zd(InDate,3)
		
		Set ICDDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID) //诊断
		Set DoctorName=objPaadm.DoctorName									//主管医生
		
		Set ActDate=$zd(WarnDate,3)								//预警日期
		Set ActTime=""           								//预警时间
		Set DataSummary=SummaryStr                              //预警摘要
		For indSS=1:1:$l(SummaryStr,",") {
			Set tSummary=$p(SummaryStr,",",indSS)
			Continue:tSummary=""
			Set ItemDesc=$p(tSummary,":",1)                      //预警类型
			Set DataValue=$p(tSummary,":",2)                     //预警信息值
			Set KeyDesc=ItemDesc
			Set Data=$lb(Name,Sex,Age,MedicareNo,AdmReason,BedNo,ActDept,LocDesc,WardID,WardDesc,InDate,ICDDesc,DoctorName,ActDate,ActTime,ItemDesc,DataValue,DataSummary,KeyDesc,EpisodeID)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2014-03-05
/// Description:  查询监控明细列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal02","QryCtlResultDtl","","","2018-03-01","2018-03-25")
Query QryCtlResultDtl(aEpisodeID As %String, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String) As DtPortal.Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActUser:%String,OccurDate:%String,OccurTime:%String,ObjEndDate:%String,ObjEndTime:%String,DataValue:%String,ObjectID:%String")
{
}

ClassMethod QryCtlResultDtlExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	new (qHandle,aEpisodeID,aSubjectCode,aDateFrom,aDateTo)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aEpisodeID="") $$$OK
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID)
	Quit:EpisodeDr="" $$$OK
	Set arrResult=##class(DHCHAI.IO.ToDtPortalSrv).GetCCResults(EpisodeDr,aDateFrom,aDateTo)
	For indRst=1:1:arrResult.Count() {
		Set objResult=arrResult.GetAt(indRst)
		Continue:'$IsObject(objResult)
		Continue:'$IsObject(objResult.CCItemDr)
		Set ResultID=objResult.%Id()
		Set ItemID=objResult.CCItemDr.%Id()
		Set ItemDesc=objResult.CCItemDr.CCDesc
		Set ItemGroup=""
		Set ItemCatID=""
		Set ItemCatDesc=""
		Set Summary=objResult.CCTextRes
		Set ActDate=objResult.CCActDate
		Set ActTime=objResult.CCActTime
		Set ActUser=objResult.CCActUser
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set OccurDate=objResult.CCRepDate
		Set OccurTime=objResult.CCRepTime
		Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		Set ObjEndDate=OccurDate
		Set ObjEndTime=OccurTime
		Set DataValue=objResult.CCResult
		Set ObjectID=objResult.CCObjectID
		
		Set Data=$lb(xResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActUser,OccurDate,OccurTime,ObjEndDate,ObjEndTime,DataValue,ObjectID)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

}
