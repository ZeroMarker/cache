/// 名称: DHCHAI.STAS.WelcomeSrv
/// 描述: 院感首页统计相关服务
/// 编写者：zhufei
/// 编写日期: 2017-10-11
Class DHCHAI.STAS.WelcomeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-12-07
/// Description:  查询新报告（医院感染报告）审核数量
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QrySpanInfRepCnt","2")
Query QrySpanInfRepCnt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QrySpanInfRepCntExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
		Set LocData = $g(^DHCHAI.BT.LocationD(aLocID))
	Quit:LocData="" $$$OK
	Set HospID=$lg(LocData,8)
	Quit:HospID="" $$$OK
	Set HospData=$g(^DHCHAI.BT.HospitalD(HospID))
	Set HospGrpID=$lg(HospData,5)
	
	// 默认查询历史30天内的未审核报告
 	Set InfRepDate=##class(DHCHAI.BT.Config).GetValByCode("NewInfRepIntervalDate")
 	Set:InfRepDate="" InfRepDate=30
	Set DateFrom=+$h-(+InfRepDate)

	Kill arrInfReport
	Set Count=0
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexRepDate",xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1)&(xRepType'=2)
		
		For xRepDate=DateFrom:1:(+$h) { 
			Set xRepID = ""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate",xRepType,xRepDate,xRepID))
				Quit:xRepID=""
				
				Set ReportData = $g(^DHCHAI.IR.INFReportD(xRepID))
				Continue:ReportData=""
				
				Set RepStatusDr=$lg(ReportData,8)
				Continue:RepStatusDr=""
				Set StatusData=$g(^DHCHAI.BT.DictionaryD(RepStatusDr))
				Continue:StatusData=""
				Set RepStatus=$lg(StatusData,2)
				Continue:(RepStatus'="1")&(RepStatus'="2")
				
				Set EpisodeDr=$lg(ReportData,2)
				Continue:EpisodeDr=""
				Set AdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeDr))
				Set AdmLocDr = $lg(AdmData,22)
				Continue:AdmLocDr=""
				Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
				Continue:LocData=""
				Set HospDr=$lg(LocData,8)
				Continue:HospDr=""
				Set HospData=$g(^DHCHAI.BT.HospitalD(HospDr))
				Continue:HospGrpID'=$lg(HospData,5)
				
				Set arrInfReport(xRepID)=""
				Set Count=Count+1
			}
		}
	}

	Kill arrInfReport
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QrySpanInfRepCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpanInfRepCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpanInfRepCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpanInfRepCntExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-12-07
/// Description:  查询疑似筛查待处理记录数量
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QrySpanInfScreenCnt","2")
Query QrySpanInfScreenCnt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QrySpanInfScreenCntExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id()
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	
	Set Count=0  //疑似感染待处理数量
	
	//在院病人+急诊留观
	Set xDays=-1
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&(xAdmType'="EP")
		
		Set xDate=0
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
			Quit:xDate=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
				Quit:xID=""
				
				Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
				Continue:'$IsObject(objEpisode)
				Set EpisodeDr=objEpisode.%Id()
				Set EpisodeIDx=objEpisode.PAEpisodeIDx
				Set SCode = $p(EpisodeIDx,"||",1)
				Set VisitStatus=objEpisode.PAVisitStatus
				Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
				If VisitStatusInfo'="" {
					Set VisitStatus=$p(VisitStatusInfo,"^",2)
				}
				Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
				
				Set objAdmLoc=objEpisode.PAAdmLocDr
				Continue:'$IsObject(objAdmLoc)
				Continue:'$IsObject(objAdmLoc.BTHospDr)
				Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
				Set tHospGrpID=objAdmLoc.BTHospDr.BTGroupDr.%Id()
				Continue:HospGrpID'=tHospGrpID
				
				
				Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(EpisodeDr)
				Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
				Set IsSusInf=+$p(ScreenAttInfo,"^",2)
				Set IsSuspend=+$p(ScreenAttInfo,"^",3)
				Continue:IsSusInf'=1  //疑似标志
				Continue:IsSuspend=1  //1疑似已处理、0疑似未处理
				//Continue:IsNeedAtt=1  //持续关注病例
				
				If IsSusInf=1 {
					If IsSuspend=0 {  //疑似待处理病例
						Set Count=Count+1
					}
				}
			}
		}
	}
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QrySpanInfScreenCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpanInfScreenCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpanInfScreenCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpanInfScreenCntExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2018-04-18
/// Description:  按照报告日期查询近三天耐药菌监控结果,过滤已经处置过的耐药菌信息（下隔离医嘱）
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryMRBResult","","2","","","","","","")
Query QryMRBResult(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String) As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,SpeID:%String,SpeCode:%String,SpeDesc:%String,Bacteria:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ResultID:%String,LabRepID:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDes:%String,INFMBRID:%String") [ SqlProc ]
{
}

ClassMethod QryMRBResultExecute(ByRef qHandlex As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String) As %Status
{
	
	Set trepidx=$I(^CacheTemp)
	Set ind=1
	Set qHandlex=$lb(0,trepidx,0)
	Quit:aDateType="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	// 默认查询过去近三天-参数配置
 	Set HomeInfMrbDate=##class(DHCHAI.BT.Config).GetValByCode("Home-InfMrbDate")
 	
 	Set:aDateFrom="" aDateFrom=+$h-(+HomeInfMrbDate)
 	Set:aDateTo="" aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
		Quit:xItemID=""

		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")

		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
			Quit:xDate=""
			Quit:(xDate>aDateTo)
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
				Quit:xID=""
				Do BuildMRBData
			}
		}
	}
	Quit $$$OK
BuildMRBData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	Quit:IsAbFlag'=1 //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	Quit:MRBDesc="" //过滤出多重耐药菌
	Quit:(aMRBID'="")&&(aMRBID'=MRBID)
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	//是否开隔离医嘱
	Set (ISOOrdDesc,ISOSttDate,IsISOFlag)=""
	Set RSet=##Class(%ResultSet).%New("DHCHAI.DPS.OEOrdItemSrv:QryOEOrdItemISO")
  	Set sc=RSet.Execute(AdmID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit
  	}
	While (RSet.Next()){
		Set ISOOrdDesc = RSet.Data("OrdDesc")  // 隔离医嘱名称
		Set ISOSttDate = RSet.Data("SttDate")  // 医嘱开始日期
		Continue:ISOSttDate=""
		Set ISOSttDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ISOSttDate)
		// xDate 报告日期
		If (ISOSttDate>=xDate){  // 隔离医嘱大于等于报告日期就算，不考虑时间
			Set IsISOFlag=1
			Quit
		}
	}
	Quit:IsISOFlag=1 // 已经处理过的不显示
	
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Quit:(aLocID'="")&&((aLocID'=AdmWardID)&(aLocID'=AdmLocID))  //允许增加科室入参查询
   
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	Quit:(aBactID'="")&&(BacID'=aBactID)
	
	Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set LabRepID=""
	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
	If $IsObject(objLabRes) {
		Set LabRepID=objLabRes.LabReportDr.%Id()
	}	
				
	Set InfTypeID="",InfTypeCode="",InfTypeDesc=""
	Set INFMBRID=""
	Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)		     
	If $IsObject(objInf){
		Set INFMBRID =objInf.%Id()
		If $IsObject(objInf.IRInfTypeDr) {
			Set InfTypeID 	= objInf.IRInfTypeDr.%Id()
			Set InfTypeCode	= objInf.IRInfTypeDr.BTCode
			Set InfTypeDesc	= objInf.IRInfTypeDr.BTDesc
		}
		
	}
	Quit:(aInfID'="")&&(InfTypeID'=aInfID)

	Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDes,INFMBRID)
	Set ^CacheTemp(trepidx,ind)=Data
	Set ind=ind+1
	Quit 1
}

ClassMethod QryMRBResultClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	set trepidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(trepidx)
	Quit $$$OK
}

ClassMethod QryMRBResultFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	set AtEnd=$LIST(qHandlex,1)
 	set trepidx=$LIST(qHandlex,2)
 	set ind=$LIST(qHandlex,3)
 	set ind=$o(^CacheTemp(trepidx,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(trepidx,ind)
 	}
 	// Save QHandle
 	s qHandlex=$lb(AtEnd,trepidx,ind)
	Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   2021-02-08
/// Description:  查询职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：		  aHospIDs  : 多个医院用"|"连接
/// 			  aRepType  : 报告类型
/// 			  aDateType : 日期类型
/// 			  aDateFrom : 开始日期
/// 			  aDateTo   : 结束日期       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryOccExpReg","1|2","2020-02-08","2021-02-08")
Query QryOccExpReg(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ResultDesc:%String,ResultCount:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpRegExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
    Set NIndex="QryOccExpReg"
	Kill ^TMP($zn,$j,NIndex)
 	
 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
			Quit:xType=""
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))  //暴露日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
			
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
					Quit:xID=""	
					Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(xID)
					Continue:'$IsObject(objReg) 
				    Set objStatus = objReg.OEStatusDr
				    Set StatusID="", StatusCode="",StatusDesc=""
					If $IsObject(objStatus) {
						Set StatusID   = objStatus.%Id()
						Set StatusCode = objStatus.BTCode
						Set StatusDesc = objStatus.BTDesc
					}
					Continue:StatusCode=3   // 过滤删除的报告
				    Set objLoc = objReg.OEExpLocDr	
				    Set LocID="",LocDesc=""
				    Continue:'$IsObject(objLoc) 
					Set LocID   = objLoc.%Id()
					Set LocDesc = objLoc.BTDesc
					If $IsObject(objLoc.BTHospDr){
						Set HospID = objLoc.BTHospDr.%Id()			
						Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
					}
					Set xSubID = ""
					For {
						Set xSubID =$o(^DHCHAI.IR.OccExpRegD(xID,"EXT",xSubID))
						Quit:xSubID=""
						
						Set ExtID=xID_"||"_xSubID
						Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
					    Continue:'$IsObject(objExt) 
						Set objItemDr  = objExt.OEItemDr
					    Continue:'$IsObject(objItemDr)
					    Set Code = objItemDr.BTCode	   
					    Set Desc = objItemDr.BTDesc
					    
					    Continue:'$IsObject(objItemDr.BTDicType)	    
					    Set TypeCode = objItemDr.BTDicType.BTCode	   
					    Set TypeDesc = objItemDr.BTDicType.BTDesc
					  	Continue:TypeCode'="OEDuty" 
					  	
						Set objResult = objExt.OEResultDr
						Set ResultID="", ResultCode="",ResultDesc=""
						If $IsObject(objResult) {
							Set ResultID = objResult.%Id()
							Set ResultCode = objResult.BTCode
							Set ResultDesc = objResult.BTDesc
						}
						Continue:ResultDesc=""
						Set ^TMP($zn,$j,NIndex,"OccLoc",ResultDesc)=xID
						Set num=+$i(^TMP($zn,$j,NIndex,"RasCount",ResultDesc))
					}
				}	
			}
		}
	 	// 输出Data
		Set ResultDesc = ""
		For{
			Set ResultDesc = $o(^TMP($zn,$j,NIndex,"OccLoc",ResultDesc))
			Quit:ResultDesc=""
			Set ResultCount=+$g(^TMP($zn,$j,NIndex,"RasCount",ResultDesc)) // 数量
			Set Data=$lb(ResultDesc,ResultCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Kill ^TMP($zn,$j,NIndex)
		Quit $$$OK
}

ClassMethod QryOccExpRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpRegExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpRegExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2020-01-14
/// Description:  查询确诊未上报病例数（当前在院及出院30天内的确诊未报告患者数）
/// Input:        aLocID：登录科室ID
/// w ##class(DHCHAI.STAS.WelcomeSrv).GetSpanInfNoRepCnt("193")
ClassMethod GetSpanInfNoRepCnt(aLocID As %String) As %String
{
	New (aLocID)
	Set return=0
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set HospID=objLoc.BTHospDr.%Id()
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	
	// 默认查询出院30天内的确诊未报告的患者
 	Set QryDate=##class(DHCHAI.BT.Config).GetValByCode("UnRepIntervalDate")
 	Set:QryDate="" QryDate=30
	Set DateFrom=+$h-(+QryDate)
	
	Kill ^TMP($zn,$j,"InfNoRep")
	
	Set Count=0	
	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID))
		Quit:xDiagID=""
		
		Set xScreenID=""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID))
			Quit:xScreenID=""
			
			Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSItmScreenDr)
			Continue:'$IsObject(objScreen.CSEpisodeDr)

			Set IsConfirm =0	
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID,xSubID))
				Quit:xSubID=""
			    Quit:IsConfirm=1
			    Set DtlID = xScreenID_"||"_xSubID
			    
		   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(DtlID)
				Continue:'$IsObject(objScreenDtl)
				Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
				Continue:(objScreen.CSStatus'=1)	   //只筛查确诊条目	
				Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
				Continue:IsActive'=1
				Set IsConfirm =1
			}
		    Continue:IsConfirm=0  //未确诊
		   
		    Set IsRep=0
		    Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xDiagID,xRepID))
				Quit:xRepID=""
				Quit:IsRep=1
				
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:(objReport.IRRepType'=1)&&(objReport.IRRepType'=2)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4
				Set IsRep=1
			} 
			Continue:IsRep=1    //已报
		
			Set EpisodeID =objScreen.CSEpisodeDr.%Id()		
			Continue:$d(^TMP($zn,$j,"InfNoRep",EpisodeID))  
			Set ^TMP($zn,$j,"InfNoRep",EpisodeID)=""
		    
			Set EpisodeIDx=objScreen.CSEpisodeDr.PAEpisodeIDx
			Set DischDate=objScreen.CSEpisodeDr.PADischDate
			Continue:(DischDate'="")&&(DischDate<DateFrom)   //查询日期限制
			Set SCode = $p(EpisodeIDx,"||",1)
			Set VisitStatus=objScreen.CSEpisodeDr.PAVisitStatus
			Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
			If VisitStatusInfo'="" {
				Set VisitStatus=$p(VisitStatusInfo,"^",2)
			}
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
            
            Set objAdmLoc=objScreen.CSEpisodeDr.PAAdmLocDr
			Continue:'$IsObject(objAdmLoc)
			Continue:'$IsObject(objAdmLoc.BTHospDr)
			Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
			Set tHospGrpID=objAdmLoc.BTHospDr.BTGroupDr.%Id()
			Continue:HospGrpID'=tHospGrpID
	
			Set Count=Count+1
			
		}
	}
	Kill ^TMP($zn,$j,"InfNoRep")
	Set return = Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-12-07
/// Description:  查询确诊未上报记录数量
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QrySpanInfNoRepCnt","206")
Query QrySpanInfNoRepCnt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QrySpanInfNoRepCntExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id()
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set Count=0
	
	//在院病人+急诊留观
	//Set xDays=-1
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&(xAdmType'="EP")
		Set xDays = ""
		For {
			Set xDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays))
			Quit:xDays=""
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
					Continue:'$IsObject(objEpisode)
					Set EpisodeDr=objEpisode.%Id()
					Set EpisodeIDx=objEpisode.PAEpisodeIDx
					Set SCode = $p(EpisodeIDx,"||",1)
					Set VisitStatus=objEpisode.PAVisitStatus
					Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
					If VisitStatusInfo'="" {
						Set VisitStatus=$p(VisitStatusInfo,"^",2)
					}
					Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
					
					Set objAdmLoc=objEpisode.PAAdmLocDr
					Continue:'$IsObject(objAdmLoc)
					Continue:'$IsObject(objAdmLoc.BTHospDr)
					Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
					Set tHospGrpID=objAdmLoc.BTHospDr.BTGroupDr.%Id()
					Continue:HospGrpID'=tHospGrpID
					//Continue:(HospID'="")&(HospID'=objAdmLoc.BTHospDr.%Id())
					Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(EpisodeDr)
					
					Set ConfCnt = $p(ConfRepCnt,"^",1)	//患者确诊数量
					Set RepCnt = $p(ConfRepCnt,"^",2)	//确诊已报数量
					If (ConfCnt-RepCnt)>0 {  //确诊未报	
						Set Count=Count+1
					} 
				}
			}
		}
		
	}
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QrySpanInfNoRepCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpanInfNoRepCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpanInfNoRepCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpanInfNoRepCntExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询当月科室感染发病率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryLocInfRatio","2")
Query QryLocInfRatio(aLocID As %String) As %Query(ROWSPEC = "LocDesc:%String,InfRatio:%String") [ SqlProc ]
{
}

ClassMethod QryLocInfRatioExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate
	Set DateFrom=$zd(DateFrom,3)
	Set DateFrom=$p(DateFrom,"-",1)_"-"_$p(DateFrom,"-",2)_"-"_1
	Set DateFrom=$zdh(DateFrom,3)
	Set DateTo=DateFrom+32
	Set DateTo=$zd(DateTo,3)
	Set DateTo=$p(DateTo,"-",1)_"-"_$p(DateTo,"-",2)_"-"_1
	Set DateTo=$zdh(DateTo,3)-1
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id()
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	
	Set NIndex="QryLocInfRatio"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	
	// 同期在科人数
    Set num=0
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(DateFrom,DateTo,"E","","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)
		Continue:TransInfo=""
		Set EpisodeID  = $LIST(TransInfo,1)
		Set TransLocDr = $LIST(TransInfo,2)
		Set TransID    = $LIST(TransInfo,3)
		
        Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(TransLocDr)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		//Continue:(HospID'="")&(HospID'=objLoc.BTHospDr.%Id())  // 按登录科室院区过滤
        Continue:(HospGrpID'="")&&($IsObject(objLoc.BTHospDr.BTGroupDr))&&(HospGrpID'=objLoc.BTHospDr.BTGroupDr.%Id())  // 按登录科室院区过滤
		
		Continue:$d(^TMP($zn,$j,NIndex,TransLocDr,EpisodeID,1))  //同科多次转入转出重复计算
		Set ^TMP($zn,$j,NIndex,TransLocDr,EpisodeID,1)=""
		Set num=$i(^TMP($zn,$j,NIndex,TransLocDr,"同期在科人数"))
    }
    
    // 同期感染人数,感染日期
	For xDate=DateFrom:1:DateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xID))
			Quit:xID=""
			
			Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(objDiagnos)
			
			Set EpisodeID=objDiagnos.IREpisodeDr.%Id()
			//感染科室
			if ($IsObject(objDiagnos.IRInfLocDr)){
				Set InfLocDr=objDiagnos.IRInfLocDr.%Id()
				Set objLoc=objDiagnos.IRInfLocDr
			}
			else{
				//新生儿无感染科室
				//感染日期
				Set InfDate=objDiagnos.IRInfDate
				Set TransData=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,InfDate,"")
				Set InfLocDr=$p(TransData,"^",1)
				Set objLoc=##class(DHCHAI.BT.Location).GetObjById(InfLocDr)
				Continue:'$IsObject(objLoc)
			}
			Continue:'$IsObject(objLoc.BTHospDr)
            Continue:(HospGrpID'="")&&($IsObject(objLoc.BTHospDr.BTGroupDr))&&(HospGrpID'=objLoc.BTHospDr.BTGroupDr.%Id())  // 按登录科室院区过滤
			//Continue:(HospID'="")&(HospID'=objLoc.BTHospDr.%Id())
			//Set arrRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
			//Continue:arrRep.Count()<1
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_$zcvt(xID,"U"),xRepID))
				Quit:xRepID=""
		
				Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.IRStatusDr)
				Set StatusCode=objRep.IRStatusDr.BTCode
				Continue:StatusCode'=3 
				Continue:$d(^TMP($zn,$j,NIndex,InfLocDr,EpisodeID,2))  //同科多次转入转出重复计算
				Set ^TMP($zn,$j,NIndex,InfLocDr,EpisodeID,2)=""
				Set num=$i(^TMP($zn,$j,NIndex,InfLocDr,"同期感染人数"))
				Quit
			}
		}
	}
	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLoc)
		Continue:'$isobject(objLoc)
		Set LocDesc=objLoc.BTDesc2
		Set:LocDesc="" LocDesc=objLoc.BTDesc
		Set InfRatio=0
      	Set InLocCount =+$g(^TMP($zn,$j,NIndex,xLoc,"同期在科人数"))
      	Set InfCount   =+$g(^TMP($zn,$j,NIndex,xLoc,"同期感染人数"))
		Continue:InLocCount=0
		
      	Set InfRatio = (InfCount/InLocCount)  // 科室感染率
      	Set ^TMP($zn,$j,"RatioSort",InfRatio,LocDesc)=1
	}
	set Count=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,"RatioSort",xRatio),-1)
		Quit:((xRatio="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"RatioSort",xRatio,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xRatio)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	Quit $$$OK
}

ClassMethod QryLocInfRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocInfRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocInfRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询全院最近7天现患率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryHospPrevRatio","2")
Query QryHospPrevRatio(aLocID As %String) As %Query(ROWSPEC = "PrevDate:%String,PrevRatio:%String") [ SqlProc ]
{
}

ClassMethod QryHospPrevRatioExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate-7
	Set DateTo=CurrDate
	Set NIndex="QryHospPrevRatio"
	Kill ^TMP($zn,$j,NIndex)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()
	
	//同期在科:某段时间的在科人数
	//Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(DateFrom,DateTo,"W","","I")
	Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    if (+INFCSSHPFlag=0){
        //同期在科:某段时间的零点在科人数
        Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(DateFrom,DateTo,"W","","I","A|O")
    }else{
		//同期在科:某段时间的在科人数
       Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(DateFrom,DateTo,"W","","I","A|A2|O")
    }
    For index1=1:1:ListLocArray.Count() {
	    Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
        Continue:(HospGrpID'="")&&($IsObject(objLoc.BTHospDr.BTGroupDr))&&(HospGrpID'=objLoc.BTHospDr.BTGroupDr.%Id()) 
		
        for TransDate=DateFrom:1:DateTo{
            Quit:TransDate=""
			
			Continue:$d(^TMP($zn,$j,NIndex,TransDate,"同期在科人数",Paadm))
			Set ^TMP($zn,$j,NIndex,TransDate,"同期在科人数",Paadm)=""
			
			Set num=$i(^TMP($zn,$j,NIndex,TransDate,"同期在科人数"))
			
			Set InfPosDescs =##class(DHCHAI.STATV2.S030InfPre).GetInfPosInfo(Paadm,TransDate,TransDate)
			Continue:InfPosDescs=""
			
			Set num=$i(^TMP($zn,$j,NIndex,TransDate,"同期感染人数"))
		}
    }
    
	For xDate=DateFrom:1:DateTo {
		Quit:xDate=""
		Set InLocCount  =+$g(^TMP($zn,$j,NIndex,xDate,"同期在科人数"))
		Set InfLocCount =+$g(^TMP($zn,$j,NIndex,xDate,"同期感染人数"))
		Set ViewDate=$zd(xDate,3)
		Set ViewDate=$p(ViewDate,"-",2)_"-"_$p(ViewDate,"-",3)
		Set PrevRatio=0
		Set:InLocCount>0 PrevRatio=$fn((InfLocCount/InLocCount)*100,"",2)_"%" 	//感染率
		
		Set Data=$lb(ViewDate,PrevRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospPrevRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospPrevRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询科室多耐检出率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryLocMBRRatio","2")
Query QryLocMBRRatio(aLocID As %String) As %Query(ROWSPEC = "LocDesc:%String,MBRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryLocMBRRatioExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate
	Set DateFrom=$zd(DateFrom,3)
	Set DateFrom=$p(DateFrom,"-",1)_"-"_$p(DateFrom,"-",2)_"-"_1
	Set DateFrom=$zdh(DateFrom,3)
	Set DateTo=DateFrom+32
	Set DateTo=$zd(DateTo,3)
	Set DateTo=$p(DateTo,"-",1)_"-"_$p(DateTo,"-",2)_"-"_1
	Set DateTo=$zdh(DateTo,3)-1
	Set NIndex="QryLocMBRRatio"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()		//update for 图表
	
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(DateFrom,DateTo,HospID,"","I")
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Continue:'$Isobject(objAdm)
		For xDate=DateFrom:1:DateTo {
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate,xID))
				Quit:xID=""
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				
				Set ActDate=objResult.CCActDate
				Set ActTime=objResult.CCActTime
				//Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA
				//Continue:IPHour<48
				//采集病区
			    Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,ActDate,ActTime)
			   	Set ActLocID = $p(LocIfno,"^",1)  // 科室为单位
			   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(ActLocID)
				Continue:'$IsObject(objRecLoc)
			    Set ActLocDesc=objRecLoc.BTDesc2
			    Set:ActLocDesc="" ActLocDesc=objRecLoc.BTDesc	
                Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime)
				Set SCode    = objResult.CCSCode      //子系统代码
		        Set Bacteria = objResult.CCBacteria   //原始细菌名称
		        Continue:Bacteria=""
		        // 细菌未做标准对照的过滤
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				Set num=$i(^TMP($zn,$j,NIndex,ActLocDesc,"检出耐药菌总数"))
				Set (MRBID,MRBDesc)=""
				If $IsObject(objResult.CCMRBTpDr) {
					Set MRBID   = objResult.CCMRBTpDr.%Id()
					Set MRBDesc = objResult.CCMRBTpDr.BTDesc
					Set num=$i(^TMP($zn,$j,NIndex,ActLocDesc,"检出多重耐药菌总数"))
				}
			}	
		}
	}
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,xLocDesc))
		Quit:xLocDesc=""
		Set RBCount  =+$g(^TMP($zn,$j,NIndex,xLocDesc,"检出耐药菌总数"))
		Set MRBCount =+$g(^TMP($zn,$j,NIndex,xLocDesc,"检出多重耐药菌总数"))
		Continue:MRBCount=0
		Set MRBRatio=0
		
		Set:RBCount>0 MRBRatio = MRBCount/RBCount
		Set ^TMP($zn,$j,"RatioSort",MRBRatio,xLocDesc)=1
	}
	set Count=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,"RatioSort",xRatio),-1)
		Quit:((xRatio="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"RatioSort",xRatio,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xRatio)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	Quit $$$OK
}

ClassMethod QryLocMBRRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocMBRRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocMBRRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocMBRRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询菌种多耐检出率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryBactMBRRatio","2")
Query QryBactMBRRatio(aLocID As %String) As %Query(ROWSPEC = "BactDesc:%String,MBRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryBactMBRRatioExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate
	Set DateFrom=$zd(DateFrom,3)
	Set DateFrom=$p(DateFrom,"-",1)_"-"_$p(DateFrom,"-",2)_"-"_1
	Set DateFrom=$zdh(DateFrom,3)
	Set DateTo=DateFrom+30
	Set DateTo=$zd(DateTo,3)
	Set DateTo=$p(DateTo,"-",1)_"-"_$p(DateTo,"-",2)_"-"_1
	Set DateTo=$zdh(DateTo,3)-1
	Set NIndex="QryBactMBRRatio"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()		//update for 图表
	
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(DateFrom,DateTo,HospID,"","I")
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Continue:'$Isobject(objAdm)
		For xDate=DateFrom:1:DateTo {
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate,xID))
				Quit:xID=""
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Set ActDate=objResult.CCActDate
				Set ActTime=objResult.CCActTime
				//Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA
				//Continue:IPHour<48
				//采集病区
			    Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,ActDate,ActTime)
			   	Set ActLocID = $p(LocIfno,"^",1)  // 科室为单位
			   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(ActLocID)
				Continue:'$IsObject(objRecLoc)
			    Set ActLocDesc=objRecLoc.BTDesc2
			    Set:ActLocDesc="" ActLocDesc=objRecLoc.BTDesc	
                Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime)
				Set SCode    = objResult.CCSCode      //子系统代码
		        Set Bacteria = objResult.CCBacteria   //原始细菌名称
		        Continue:Bacteria=""
		        // 细菌未做标准对照的过滤
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				Set num=$i(^TMP($zn,$j,NIndex,BacDesc,"检出耐药菌数"))
				Set (MRBID,MRBDesc)=""
				If $IsObject(objResult.CCMRBTpDr) {
					Set MRBID   = objResult.CCMRBTpDr.%Id()
					Set MRBDesc = objResult.CCMRBTpDr.BTDesc
					Set num=$i(^TMP($zn,$j,NIndex,BacDesc,"检出多重耐药菌数"))
				}
			}	
		}
	}
	Set xBacDesc=""
	For {
		Set xBacDesc=$o(^TMP($zn,$j,NIndex,xBacDesc))
		Quit:xBacDesc=""
		Set RBCount  =+$g(^TMP($zn,$j,NIndex,xBacDesc,"检出耐药菌数"))
		Set MRBCount =+$g(^TMP($zn,$j,NIndex,xBacDesc,"检出多重耐药菌数"))
		Continue:MRBCount=0
		Set MRBRatio=0
		Set:RBCount>0 MRBRatio = MRBCount/RBCount
		Set ^TMP($zn,$j,"RatioSort",MRBRatio,xBacDesc)=1
	}
	set Count=0
	Set xRatio=""
	For {
		Set xRatio=$o(^TMP($zn,$j,"RatioSort",xRatio),-1)
		Quit:((xRatio="")||(Count>9))
		Set xBacDesc=""
		For {
			Set xBacDesc=$o(^TMP($zn,$j,"RatioSort",xRatio,xBacDesc))
			Quit:((xBacDesc="")||(Count>9))
			Set BacDesc=xBacDesc
			set Count=Count+1
      		Set Data=$lb(BacDesc,xRatio)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"RatioSort")
	Quit $$$OK
}

ClassMethod QryBactMBRRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactMBRRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBactMBRRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactMBRRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-11-15
/// Description:  查询科室发热人数（近三天）
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryLocFeverNumber","2")
Query QryLocFeverNumber(aLocID As %String) As %Query(ROWSPEC = "LocDesc:%String,FeverNumber:%String") [ SqlProc ]
{
}

ClassMethod QryLocFeverNumberExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate-2
	Set DateTo=CurrDate
	
	Set NIndex="QryLocFeverNumber"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"FeverNumber")
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()
	Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
	
	For xDate=DateFrom:1:DateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",ItemID,xDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			
			Set EpisodeDr=obj.CCEpisodeDr.%Id()
			Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,xDate,"")
			Set LocDr=$p(TransLocInfo,"^",2)
			Continue:LocDr=""
			Continue:$d(^TMP($zn,$j,NIndex,LocDr,EpisodeDr))
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
			Continue:'$IsObject(objLoc)
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:'$IsObject(objLoc.BTHospDr.BTGroupDr)
			Set HospID=objLoc.BTHospDr.BTGroupDr.%Id()
			Continue:HospID'=HospGrpID  // 登录院区过滤
				
			Set ^TMP($zn,$j,NIndex,LocDr,EpisodeDr)=""
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"科室发热人数"))
		}
	}
	Set xLocDr=""
	For {
		Set xLocDr=$o(^TMP($zn,$j,NIndex,xLocDr))
		Quit:(xLocDr="")
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocDr)
		Continue:'$IsObject(objLoc)
	    Set LocDesc=objLoc.BTDesc2
	    Set:LocDesc="" LocDesc=objLoc.BTDesc
		Set FeverNumber =+$g(^TMP($zn,$j,NIndex,xLocDr,"科室发热人数"))
  		Set ^TMP($zn,$j,"FeverNumber",FeverNumber,LocDesc)=1
	}
	set Count=0
	Set xNum=""
	For {
		Set xNum=$o(^TMP($zn,$j,"FeverNumber",xNum),-1)
		Quit:((xNum="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"FeverNumber",xNum,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xNum)
      		
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"FeverNumber")
	Quit $$$OK
}

ClassMethod QryLocFeverNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocFeverNumberExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocFeverNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocFeverNumberExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询科室发热人数变化
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryLocFeverChange","2")
Query QryLocFeverChange(aLocID As %String) As %Query(ROWSPEC = "LocDesc:%String,FeverNumber:%String,ChainFeverNumber:%String") [ SqlProc ]
{
}

ClassMethod QryLocFeverChangeExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set Days=3
	Set DateFrom=CurrDate-Days+1
	Set DateTo=CurrDate
	
	Set NIndex="QryLocFeverChange"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"FeverNumber")
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()
	
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
    
	// 近三天发热人数
	For xDate=DateFrom:1:DateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",ItemID,xDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			
			Set EpisodeDr=obj.CCEpisodeDr.%Id()
			Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,xDate,"")
			Set LocDr=$p(TransLocInfo,"^",2)
			Continue:LocDr=""
			Continue:$d(^TMP($zn,$j,NIndex,LocDr,EpisodeDr,"近三天"))
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
			Continue:'$IsObject(objLoc)
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:'$IsObject(objLoc.BTHospDr.BTGroupDr)
			Set HospID=objLoc.BTHospDr.BTGroupDr.%Id()
			Continue:HospID'=HospGrpID  
			
			Set ^TMP($zn,$j,NIndex,LocDr,EpisodeDr,"近三天")=""
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"科室近三天发热人数"))
		}
	}
	
	// 环比三天发热人数
	For xDate=DateFrom:1:DateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",ItemID,xDate-Days,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			
			Set EpisodeDr=obj.CCEpisodeDr.%Id()
			Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,xDate,"")
			Set LocDr=$p(TransLocInfo,"^",2)
			Continue:LocDr=""
			Continue:$d(^TMP($zn,$j,NIndex,LocDr,EpisodeDr,"环比三天"))
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
			Continue:'$IsObject(objLoc)
			Continue:'$IsObject(objLoc.BTHospDr)
			Continue:'$IsObject(objLoc.BTHospDr.BTGroupDr)
			Set HospID=objLoc.BTHospDr.BTGroupDr.%Id()
			Continue:HospID'=HospGrpID  // 登录院区过滤
		
			Set ^TMP($zn,$j,NIndex,LocDr,EpisodeDr,"环比三天")=""
			Set num=$i(^TMP($zn,$j,NIndex,LocDr,"科室环比三天发热人数"))
		}
	}
	Set xLocDr=""
	For {
		Set xLocDr=$o(^TMP($zn,$j,NIndex,xLocDr))
		Quit:(xLocDr="")
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocDr)
		Continue:'$IsObject(objLoc)
	    Set LocDesc=objLoc.BTDesc2
	    Set:LocDesc="" LocDesc=objLoc.BTDesc
	    Set FeverNumber=+$g(^TMP($zn,$j,NIndex,xLocDr,"科室近三天发热人数"))
		Set ChainFeverNumber=+$g(^TMP($zn,$j,NIndex,xLocDr,"科室环比三天发热人数"))
  		Set ^TMP($zn,$j,"FeverNumber",FeverNumber,LocDesc,ChainFeverNumber)=1
	}
	set Count=0
	Set xNum=""
	For {
		Set xNum=$o(^TMP($zn,$j,"FeverNumber",xNum),-1)
		Quit:((xNum="")||(Count>9))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"FeverNumber",xNum,xLocDesc))
			Quit:((xLocDesc="")||(Count>9))
			Set LocDesc=xLocDesc
			set Count=Count+1
			Set ChainFeverNumber = +$o(^TMP($zn,$j,"FeverNumber",xNum,xLocDesc,""))
      		Set Data=$lb(LocDesc,xNum,ChainFeverNumber)
      		
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"FeverNumber")
	Quit $$$OK
}

ClassMethod QryLocFeverChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocFeverChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocFeverChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocFeverChangeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-10-11
/// Description:  查询院感宣教列表
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryHAIEducatList","2")
Query QryHAIEducatList(aLocID As %String) As %Query(ROWSPEC = "BactDesc:%String,MBRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryHAIEducatListExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//增加演示功能（设置测试日期）
	Set TestDate=##class(DHCHAI.BT.Config).GetValByCode("SystemTestDate")
	Set CurrDate=$s(TestDate="":+$h,1:$zdh(TestDate,3))
	Set DateFrom=CurrDate
	Set DateFrom=$zd(DateFrom,3)
	Set DateFrom=$p(DateFrom,"-",1)_"-"_$p(DateFrom,"-",2)_"-"_1
	Set DateFrom=$zdh(DateFrom,3)
	Set DateTo=DateFrom+32
	Set DateTo=$zd(DateTo,3)
	Set DateTo=$p(DateTo,"-",1)_"-"_$p(DateTo,"-",2)_"-"_1
	Set DateTo=$zdh(DateTo,3)-1
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
	Set HospID=objLoc.BTHospDr.%Id()
	//BactDesc,MBRRatio
	Set Data=$lb("金黄色葡萄球菌",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("肠球菌",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("大肠埃希菌",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("肺炎克雷伯",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("铜绿假单胞菌",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("ESBLs",$RANDOM(10)/100)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryHAIEducatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHAIEducatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHAIEducatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHAIEducatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2021-05-20
/// Description:  查询全院基本概况(默认当天前一天)
/// Table：       DHCHAI.DP.PAAdm
/// Input：       院区aHospID、选择日期aDate
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryHospSurvey","1","2021-05-20")
Query QryHospSurvey(aHospIDs As %String, aDate As %String = "") As %Query(ROWSPEC = "LocDesc:%String,NewPatCnt:%Integer,AdmPatCnt:%Integer,FeverPatCnt:%Integer,PICCPatCnt:%Integer,VAPPatCnt:%Integer,UCPatCnt:%Integer,AntPatCnt:%Integer,OperPatCnt:%Integer,DischPatCnt:%Integer,DischPatCnt:%Integer,DeathPatCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryHospSurveyExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aHospIDs="" $$$OK
	Set:aDate="" aDate=+$h-1
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Quit:aDate=""
	
    Set NIndex="QryHospSurvey"
	Kill ^TMP($zn,$j,NIndex)
    //同期在科:某天的入科/在科/当天入当天出/出科人数
    Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(aDate,aDate,"E","","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Set HospDr=$li(LocData,8)
		
		Set LocDesc=$li(LocData,3)
		Continue:LocDesc=""
		//过滤院区
		Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospDr_"|"))	
		
		Set:aHospIDs["|" HospDesc="全院"
		Set:aHospIDs'["|" HospDesc=$li(^DHCHAI.BT.HospitalD(HospDr),3)
		//过滤重复患者[科室]
		Continue:$d(^TMP($zn,$j,NIndex,"IsPatCnt",Paadm,LocDesc))
		Set ^TMP($zn,$j,NIndex,"IsPatCnt",Paadm,LocDesc)=""
		//统计新入人数
		Set AdmDate=$li(^DHCHAI.DP.PAAdmD(Paadm),20)
		Continue:AdmDate=""
		if (AdmDate=aDate){
			//去重
			If ('$d(^TMP($zn,$j,NIndex,"NewPatCnt",Paadm))){
				Set ^TMP($zn,$j,NIndex,"NewPatCnt",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"NewPatCnt"))
			}
			
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"NewPatCnt"))
		} 
		
		//统计住在人数
		//去重
		If ('$d(^TMP($zn,$j,NIndex,"AdmPatCnt",Paadm))){
			Set ^TMP($zn,$j,NIndex,"AdmPatCnt",Paadm)=""
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"AdmPatCnt"))
		}
		Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"AdmPatCnt"))
		//统计死亡/出院人数
		Set DischDate=$li(^DHCHAI.DP.PAAdmD(Paadm),26)
		Set IsDeath=$li(^DHCHAI.DP.PAAdmD(Paadm),15)
		if (DischDate=aDate){
			If ('$d(^TMP($zn,$j,NIndex,"DischPatCnt",Paadm))){
				Set ^TMP($zn,$j,NIndex,"DischPatCnt",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"DischPatCnt"))
			}
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"DischPatCnt"))
			
			if (IsDeath=1){
				If ('$d(^TMP($zn,$j,NIndex,"DeathPatCnt",Paadm))){
					Set ^TMP($zn,$j,NIndex,"DeathPatCnt",Paadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"DeathPatCnt"))
				}
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"DeathPatCnt"))
			}
		}
		//统计发热人数
		Set AbnoArr=##class(DHCHAI.STATV2.AbstractComm).GetFeverAbno(Paadm,aDate,aDate)
		if (AbnoArr.Count()>0){
			If ('$d(^TMP($zn,$j,NIndex,"FeverPatCnt",Paadm))){
				Set ^TMP($zn,$j,NIndex,"FeverPatCnt",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"FeverPatCnt"))
			}
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"FeverPatCnt"))
		} 
		
		Set ICULogID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",aDate,Paadm,0))
		if (ICULogID'=""){
			//统计中央血管导管插管人数
			Set IsPICC =$li(^DHCHAI.IR.ICULogDtlD(ICULogID),6)
			Set IsCVC  =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),10)
			Set IsCRRT =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),11)
			Set IsPORT =$lg(^DHCHAI.IR.ICULogDtlD(ICULogID),12)
			if ((IsPICC=1)||(IsCVC=1)||(IsCRRT=1)||(IsPORT=1)){
				If ('$d(^TMP($zn,$j,NIndex,"PICCPatCnt",Paadm))){
					Set ^TMP($zn,$j,NIndex,"PICCPatCnt",Paadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"PICCPatCnt"))
				}
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"PICCPatCnt"))
			} 
			//统计呼吸机插管人数
			Set IsVAP=$li(^DHCHAI.IR.ICULogDtlD(ICULogID),5)
			if (IsVAP=1){
				If ('$d(^TMP($zn,$j,NIndex,"VAPPatCnt",Paadm))){
					Set ^TMP($zn,$j,NIndex,"VAPPatCnt",Paadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"VAPPatCnt"))
				}
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"VAPPatCnt"))
			} 
			//统计泌尿道插管人数
			Set IsUC=$li(^DHCHAI.IR.ICULogDtlD(ICULogID),7)
			if (IsUC=1){
				If ('$d(^TMP($zn,$j,NIndex,"UCPatCnt",Paadm))){
					Set ^TMP($zn,$j,NIndex,"UCPatCnt",Paadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"UCPatCnt"))
				}
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"UCPatCnt"))
			}
		}
		//统计抗菌用药人数
		Set AntUseFlg=0
		Set AntUseArr =##class(DHCHAI.STATV2.AbstractComm).GetAntUseInfo(Paadm,aDate,aDate,"","")	
		Set:AntUseArr.Count()>0 AntUseFlg=1
		if (AntUseFlg=1){
			If ('$d(^TMP($zn,$j,NIndex,"AntPatCnt",Paadm))){
				Set ^TMP($zn,$j,NIndex,"AntPatCnt",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"AntPatCnt"))
			}
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"AntPatCnt"))
		}
		//统计手术人数(一天多次手术？)
		Set IsOper=0
		Set xOperID=""
		For{
			Set xOperID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",Paadm,aDate,xOperID))
			Quit:xOperID=""
			Quit:IsOper=1
				
			Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xOperID))
			Continue:AnaesData=""
			
			//过滤无效数据
			Set ORIsActive=$li(AnaesData,31)
			Continue:ORIsActive'=1
			//过滤手术状态
			Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态
			Set:ExclStatus="" ExclStatus="ADC"
			Set OperStatus = $li(AnaesData,34)         // 手术状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
			Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
			Set:tOperStatus'="" OperStatus=tOperStatus
			Continue:ExclStatus[OperStatus 
				
			Set IsOper=1
		}
		if (IsOper="1"){
			If ('$d(^TMP($zn,$j,NIndex,"OperPatCnt",Paadm))){
				Set ^TMP($zn,$j,NIndex,"OperPatCnt",Paadm)=""
				Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc","0"_HospDesc,"OperPatCnt"))
			}
			Set num=$i(^TMP($zn,$j,NIndex,"DimensDesc",LocDesc,"OperPatCnt"))
		} 
    }
	// 输出Data
	Set xDimensDesc=""
	For{
		Set xDimensDesc=$o(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc))
		Quit:xDimensDesc=""
		
		//新入人数
		Set NewPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"NewPatCnt"))
		Set:NewPatCnt="" NewPatCnt=0
		//住在人数
		Set AdmPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"AdmPatCnt"))
		Set:AdmPatCnt="" AdmPatCnt=0
		//出院-死亡人数
		Set DischPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"DischPatCnt"))
		Set:DischPatCnt="" DischPatCnt=0
		Set DeathPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"DeathPatCnt"))
		Set:DeathPatCnt="" DeathPatCnt=0
		Set DDPatCnt=DischPatCnt
		Set:DeathPatCnt'=0 DDPatCnt=DeathPatCnt_"/"_DDPatCnt
		//发热人数
		Set FeverPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"FeverPatCnt"))
		Set:FeverPatCnt="" FeverPatCnt=0
		//PICC人数
		Set PICCPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"PICCPatCnt"))
		Set:PICCPatCnt="" PICCPatCnt=0
		//VAP人数
		Set VAPPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"VAPPatCnt"))
		Set:VAPPatCnt="" VAPPatCnt=0
		//UC人数
		Set UCPatCnt= $g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"UCPatCnt"))
		Set:UCPatCnt="" UCPatCnt=0
		//抗菌用药人数
		Set AntPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"AntPatCnt"))
		Set:AntPatCnt="" AntPatCnt=0
		//手术人数
		Set OperPatCnt=$g(^TMP($zn,$j,NIndex,"DimensDesc",xDimensDesc,"OperPatCnt"))
		Set:OperPatCnt="" OperPatCnt=0
		//处理排序问题
		Set DimensDesc=xDimensDesc
		Set:DimensDesc["0" DimensDesc=$e(DimensDesc,2,$l(DimensDesc))
		
		Set Data=$lb(DimensDesc,NewPatCnt,AdmPatCnt,FeverPatCnt,PICCPatCnt,VAPPatCnt,UCPatCnt,AntPatCnt,OperPatCnt,DDPatCnt,DischPatCnt,DeathPatCnt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospSurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospSurveyExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHospSurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBReportExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		ShenC
/// CreateDate：	2022-06-16
/// Description:	多重耐药菌检出数目[首页]
/// Input:          aHospIDs： 多个医院用"|"连接
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期
///                 aStaType : 统计类型E：科室W：病区 
/// 		 	    aQryCon  : 是否仅显示有数据的科室
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.WelcomeSrv","QryMRBPos","1","2018-07-01","2019-11-08","W")
Query QryMRBPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Query(ROWSPEC = "MRSAMRBCase:%String,MRSAPatCase:%String,MRSAPatRatio:%String,VREMRBCase:%String,VREPatCase:%String,VREPatRatio:%String,CREMRBCase:%String,CREPatCase:%String,CREPatRatio:%String,CRABMRBCase:%String,CRABPatCase:%String,CRABPatRatio:%String,CEPAMRBCase:%String,CEPAPatCase:%String,CEPAPatRatio:%String") [ SqlProc ]
{
}

ClassMethod QryMRBPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//转换院区('1|2|3'->'$lb(1,2,3)')
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//转换日期
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//统计维度(病区W/科室E)
 	Set:aStaType'="W" StatType="E"
 	
 	//定义临时Global
 	Set NIndex="QryMRBPos"
	Kill ^TMP($zn,$j,NIndex)
	
	//循环监控结果表[不走住院患者表加快运行速度]
	Set xItemID=""
	For{
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
		Quit:xItemID=""
		
		Set ItemData=$g(^DHCHAI.IR.CCItmMastD(xItemID))
		Continue:ItemData=""
		Set ItemCode=$li(ItemData,2)
		//只查询'检出菌'+'常规检验异常'+'常规检验'--与报表保持一致
		Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
		
		For xDate=aDateFrom:1:aDateTo{
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
				Quit:xID=""
			
				Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
				Continue:RstData=""
				Continue:$lg(RstData,14)'=1			//过滤无效数据
				
				//就诊号
				Set EpisodeID= $lg(RstData,2)    
				Set ActDate=$lg(RstData,8)
				Set ActTime=$lg(RstData,9)
				//采集病区 
				Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,ActDate,ActTime)
			   	Set LocDr  = $p(LocWardInfo,"^",1) 	// 科室
				Set WardDr = $p(LocWardInfo,"^",2) 	// 病区
				If aStaType="E" {
                    Continue:LocDr=""
					Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				} Else {
                    Continue:WardDr=""
					Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
				}
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)			//过滤院区
				//子系统代码
				Set SCode    = $lg(RstData,17)             
				//原始细菌名称
				Set Bacteria = $lg(RstData,23)
		        Continue:Bacteria=""
		     	Set BactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
				Continue:BactMapID=""				//过滤未对照标准名细菌
				Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
				Set BacID = $lg(BactMapData,3)
				Continue:BacID=""
				Set BactData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
				Continue:BactData=""
				Set BacCode = $li(BactData,2)
				//标准细菌名称
				Set BacDesc = $li(BactData,3)
				
				Continue:'$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) 		//非多重耐药菌对应的细菌不记录
				//多耐类型
				Set xMRBTypeID="",MRBType="",MRBTypeList=""
				For {
					Set xMRBTypeID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,xMRBTypeID))
					Quit:xMRBTypeID=""
					
					Set RuleMRBInfo=$g(^DHCHAI.IR.CRuleMRBD(xMRBTypeID))
					Continue:RuleMRBInfo=""
					Set MRBType=$li(RuleMRBInfo,2)
					Set MRBTypeList=MRBTypeList_","_MRBType
				}
				Set:MRBTypeList'="" MRBTypeList=$e(MRBTypeList,2,$l(MRBTypeList))
				
				//感染类型标记(HA,CA,定值,污染,HA重复,CA重复,定制重复)
				//检验结果ID	
				Set ResultID=$p($lg(RstData,19),"=",2)  	
				Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
				Continue:RepRstData=""
				Set LabInfType       = $lg(RepRstData,13)   
				Continue:LabInfType=4				//过滤污染细菌(Add 2021-12-14)
				
				//统计具体细菌数据
				If (MRBTypeList="M1"){	    //金黄色葡萄球菌
					Set num = $i(^TMP($zn,$j,NIndex,"JHSPTQJ"))
				}elseif(MRBTypeList="M2"){  //粪肠球菌
					Set num = $i(^TMP($zn,$j,NIndex,"FCQJ"))
				}elseif(MRBTypeList="M3"){  //屎肠球菌
					Set num = $i(^TMP($zn,$j,NIndex,"SCQJ"))
				}elseif((MRBTypeList["M4")||(MRBTypeList["M6")){  //大肠埃希菌
					Set num = $i(^TMP($zn,$j,NIndex,"DCAXJ"))
				}elseif((MRBTypeList["M5")||(MRBTypeList["M7")){  //肺炎克雷伯菌
					Set num = $i(^TMP($zn,$j,NIndex,"FYKLBJ"))
				}elseif(MRBTypeList="M8"){   //鲍曼不动杆菌
					Set num = $i(^TMP($zn,$j,NIndex,"BMBDGJ"))
				}elseif(MRBTypeList="M9"){   //铜绿假单胞菌
					Set num = $i(^TMP($zn,$j,NIndex,"TLJDBJ"))
				}elseif(MRBTypeList'="")&&(MRBTypeList["P"){
					Set num = $i(^TMP($zn,$j,NIndex,MRBTypeList))
				}
				
				//多耐类型
				Set MRBTpDr=$lg(RstData,24)
				Set MRBTp2Dr=$lg(RstData,31)
				If (MRBTpDr) {
					Set MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
					Set MRBID    = MRBTpDr
					Set MRBDesc  = $lg(MRBInfo,3)
					Set MRBCode  = $lg(MRBInfo,2)
				}Else {
					Set MRBID    = ""
					Set MRBDesc  = ""
					Set MRBCode  = ""
				}
				If (MRBTp2Dr) {
					Set MRB2Info=$g(^DHCHAI.IR.CRuleMRBD(MRBTp2Dr))
					Set MRB2ID    = MRBTp2Dr
					Set MRB2Desc  = $lg(MRB2Info,3)
					Set MRB2Code  = $lg(MRB2Info,2)
				}Else {
					Set MRB2ID    = ""
					Set MRB2Desc  = ""
					Set MRB2Code  = ""
				}
				//同期检出多耐菌1的例次数
				Continue:MRBCode=""
				Set MCIndex=MRBCode_"PatCase"   
				Set num = $i(^TMP($zn,$j,NIndex,MCIndex))
				//同期检出多耐菌2的例次数
				Continue:MRB2Code=""
				Set MCIndex=MRB2Code_"PatCase"
				Set num = $i(^TMP($zn,$j,NIndex,MCIndex))
			}
		}
	}
	//输出数据
	//MRSA
	Set MRSAMRBCase  =+$g(^TMP($zn,$j,NIndex,"JHSPTQJ")) 	//同期检出金黄色葡萄球菌的例次数
	Set MRSAPatCase  =+$g(^TMP($zn,$j,NIndex,"M1PatCase")) //同期检出耐甲氧西林的金黄色葡萄球菌例次数
	Set MRSAPatRatio="0.00%"
	Set:MRSAMRBCase>0 MRSAPatRatio=$fn((MRSAPatCase/MRSAMRBCase)*100,"",2)_"%" //耐甲氧西林的金黄色葡萄球菌检出率
	
	//VRE
	Set M2MRBCase  =+$g(^TMP($zn,$j,NIndex,"FCQJ")) 		//粪肠球菌
	Set M3MRBCase  =+$g(^TMP($zn,$j,NIndex,"SCQJ")) 		//屎肠球菌
	Set P3MRBCase  =+$g(^TMP($zn,$j,NIndex,"P3"))
	Set VREMRBCase=M2MRBCase+M3MRBCase+P3MRBCase
		
	Set M2PatCase  =+$g(^TMP($zn,$j,NIndex,"M2PatCase")) //耐万古霉素的粪肠球菌
	Set M3PatCase  =+$g(^TMP($zn,$j,NIndex,"M3PatCase")) //耐万古霉素的屎肠球菌
	Set P3PatCase  =+$g(^TMP($zn,$j,NIndex,"P3PatCase")) //耐万古霉素肠球菌(除粪肠球菌、屎肠球菌)
	Set VREPatCase =M2PatCase+M3PatCase+P3PatCase
	Set VREPatRatio="0.00%"
	Set:VREMRBCase>0 VREPatRatio=$fn((VREPatCase/VREMRBCase)*100,"",2)_"%" //检出率
	
	//CRE
	Set M6MRBCase  =+$g(^TMP($zn,$j,NIndex,"DCAXJ")) 	//大肠埃希菌
	Set M7MRBCase  =+$g(^TMP($zn,$j,NIndex,"FYKLBJ")) 	//肺炎克雷伯菌
	Set P4MRBCase  =+$g(^TMP($zn,$j,NIndex,"P4")) 	    //耐碳青霉烯类的肠杆菌科细菌(除大肠埃希菌、肺炎克雷伯菌)		
	Set CREMRBCase=M6MRBCase+M7MRBCase+P4MRBCase
	Set M6PatCase  =+$g(^TMP($zn,$j,NIndex,"M6PatCase")) //大肠埃希菌
	Set M7PatCase  =+$g(^TMP($zn,$j,NIndex,"M7PatCase")) //耐碳青霉烯类的肺炎克雷伯菌
	Set P4PatCase  =+$g(^TMP($zn,$j,NIndex,"P4PatCase")) //耐碳青霉烯类的肺炎克雷伯菌
	Set CREPatCase=M6PatCase+M7PatCase+P4PatCase
	Set CREPatRatio="0.00%"
	Set:CREMRBCase>0 CREPatRatio=$fn((CREPatCase/CREMRBCase)*100,"",2)_"%" //检出率
	//CRAB
	Set CRABMRBCase  =+$g(^TMP($zn,$j,NIndex,"BMBDGJ")) 	//鲍曼不动杆菌
	Set CRABPatCase  =+$g(^TMP($zn,$j,NIndex,"M8PatCase")) //耐碳青霉烯类的鲍曼不动杆菌
	Set CRABPatRatio="0.00%"
	Set:CRABMRBCase>0 CRABPatRatio=$fn((CRABPatCase/CRABMRBCase)*100,"",2)_"%" //检出率
	//CEPA
	Set CEPAMRBCase  =+$g(^TMP($zn,$j,NIndex,"TLJDBJ")) 	//铜绿假单胞菌
	Set CEPAPatCase  =+$g(^TMP($zn,$j,NIndex,"M9PatCase")) //耐碳青霉烯类的铜绿假单胞菌
	Set CEPAPatRatio="0.00%"
	Set:CEPAMRBCase>0 CEPAPatRatio=$fn((CEPAPatCase/CEPAMRBCase)*100,"",2)_"%" //检出率
	
	Set Data=$lb(MRSAMRBCase,MRSAPatCase,MRSAPatRatio,VREMRBCase,VREPatCase,VREPatRatio,CREMRBCase,CREPatCase,CREPatRatio,CRABMRBCase,CRABPatCase,CRABPatRatio,CEPAMRBCase,CEPAPatCase,CEPAPatRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
		
	Kill ^TMP($zn,$j,NIndex)	
	Quit $$$OK
}

ClassMethod QryMRBPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBPosExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
