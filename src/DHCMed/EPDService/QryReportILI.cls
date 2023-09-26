/// 名称：DHCMed.EPDService.QryServiceILI
/// 描述：查询流感样病例标本登记表信息
/// 编写者：yk
/// 编写日期：2016-3-20
Class DHCMed.EPDService.QryReportILI Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-12-04
/// Description:  根据就诊号查询流感样病例标本登记信息(ZLK) EpisodeID
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.QryReportILI","QryILIRepByEpisodeID",12)
Query QryILIRepByEpisodeID(aEpisodeID) As %Query(ROWSPEC = "ReportID:%String,RepStatusDesc:%String,ERAdmitDate:%String,ERAdmLoc:%String,ReportDate:%String,ReportTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReportNum:%String,RegNo:%String,PatName:%String,PatSex:%String,PatAge:%String,SickDate:%String,AdmitDate:%String,MrNo:%String,DoctorName:%String,AdmLocDesc:%String,SpecType:%String,SpecSource:%String,SpecClnArea:%String,Incident:%String,EpisodeID:%String")
{
}

ClassMethod QryILIRepByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.EPD.ERReportILII("EREpisodeIDIndex"," "_$zcvt(aEpisodeID,"U"),xRepID))
		
		Quit:xRepID=""
				
		Set objRep=##class(DHCMed.EPD.ERReportILI).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
				
		Set (RepStatusDesc,ReportDate,ReportTime,CheckUser,CheckDate)=""
		Set (ReportNum,RegNo,PatName,PatSex,PatAge,SickDate,AdmitDate)=""
		Set (MrNo,DoctorName,AdmLocDesc,SpecType,SpecSource,SpecClnArea,Incident)=""
			
		;Set RepStatusID=objRep.ERReportStatus.%Id()
		Set RepStatusDesc=objRep.ERReportStatus.Description
		
		Set AdmLoc=objRep.ERAdmLoc
		Set objAdmLoc=##class(DHCMed.Base.Ctloc).GetObjById(AdmLoc)
		If $IsObject(objAdmLoc){
			Set AdmLoc=objAdmLoc.Descs
		}
		Set ReportDate=objRep.ERReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		
		Set ReportTime=objRep.ERReportTime
		Set:ReportTime'="" ReportTime=$zt(ReportTime,1)	
		
		Set CheckUserDr=objRep.ERCheckUser
		If (CheckUserDr'=""){
			set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
			If ($IsObject(objUser)){
				set CheckUser=objUser.Name
			}
		}
		Set CheckDate=objRep.ERCheckDate
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set CheckTime=objRep.ERCheckTime
		Set:CheckTime'="" CheckTime=$zt(CheckTime,1)					
		Set ReportNum=objRep.ERReportNum
		Set RegNo=objRep.ERRegNo
		Set PatName=objRep.ERPatName
		Set PatSex=objRep.ERPatSex
		Set:objRep.ERAge'="" PatAge=objRep.ERAge_"岁"
		Set:objRep.ERAgeMonth'="" PatAge=objRep.ERAgeMonth_"月"
		Set:objRep.ERAgeDay'="" PatAge=objRep.ERAgeDay_"天"
		Set SickDate=objRep.ERSickDate
		Set:SickDate'="" SickDate=$zd(SickDate,3)
		Set AdmitDate=objRep.ERAdmitDate
		Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
			
		Set EpisodeID=objRep.EREpisodeID
		Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
		Set DoctorName=objRep.ERDoctorName
		set AdmLocDesc=$p($g(^CTLOC(+$p(objRep.ERAdmLoc," ",2))),"^",2)
		set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)				
		Set SpecType=objRep.ERSpecimenType.Description
		Set SpecSource=objRep.ERSpecimenSource.Description
		Set SpecClnArea=objRep.ERSpecimenClnArea
		Set Incident=objRep.ERIncident
				
		Set Data=$lb(xRepID,RepStatusDesc,AdmitDate,AdmLoc,ReportDate,ReportTime,CheckUser,CheckDate,CheckTime)
		Set Data=Data_$lb(ReportNum,RegNo,PatName,PatSex,PatAge,SickDate,AdmitDate)
		Set Data=Data_$lb(MrNo,DoctorName,AdmLocDesc,SpecType,SpecSource,SpecClnArea,Incident,EpisodeID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryILIRepByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryILIRepByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryILIRepByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryILIRepByEpisodeIDExecute ]
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

/// Creator：     yk
/// CreatDate：   2016-03-20
/// Description:  根据日期查询流感样病例标本登记信息(ZLK)
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.QryReportILI","QryILIRepByDate","2019-03-20","2019-05-20","","")
Query QryILIRepByDate(aFromDate As %String, aToDate As %String, aRepLoc As %String, aRepStatus As %String, aHosp As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,ReportNum:%String,RegNo:%String,PatName:%String,PatSex:%String,PatAge:%String,SickDate:%String,AdmitDate:%String,MrNo:%String,DoctorName:%String,AdmLocDesc:%String,SpecType:%String,SpecSource:%String,SpecClnArea:%String,Incident:%String,EpisodeID:%String,Hospital:%String")
{
}

ClassMethod QryILIRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aRepLoc As %String, aRepStatus As %String, aHosp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.EPD.ERReportILII("ERReportDateIndex",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.EPD.ERReportILII("ERDateLocIndex",xDate,xLoc))
			Quit:xLoc=""
			Continue:(aRepLoc'="")&&(aRepLoc'=$p(xLoc," ",2))
			Set aLoc=$p(xLoc," ",2)
			if (aHosp'=""){
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(aLoc,aHosp)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.EPD.ERReportILII("ERDateLocIndex",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.EPD.ERReportILI).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				
				Set (RepStatusDesc,ReportDate,CheckUser,CheckDate)=""
				Set (ReportNum,RegNo,PatName,PatSex,PatAge,SickDate,AdmitDate)=""
				Set (MrNo,DoctorName,AdmLocDesc,SpecType,SpecSource,SpecClnArea,Incident)=""
				
				Set RepStatusID=objRep.ERReportStatus.%Id()
				Continue:((aRepStatus'="")&&(aRepStatus'[RepStatusID))
				Set RepStatusDesc=objRep.ERReportStatus.Description
				Set ReportDate=objRep.ERReportDate
				Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set CheckUserDr=objRep.ERCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.ERCheckDate
				Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:RepStatusDesc'="审核" CheckUser="",CheckDate=""	
				Set ReportNum=objRep.ERReportNum
				Set RegNo=objRep.ERRegNo
				Set PatName=objRep.ERPatName
				Set PatSex=objRep.ERPatSex
				Set:PatSex'="" PatSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
				Set:objRep.ERAge'="" PatAge=objRep.ERAge_"岁"
				Set:objRep.ERAgeMonth'="" PatAge=objRep.ERAgeMonth_"月"
				Set:objRep.ERAgeDay'="" PatAge=objRep.ERAgeDay_"天"
				Set SickDate=objRep.ERSickDate
				Set:SickDate'="" SickDate=$zd(SickDate,3)
				Set AdmitDate=objRep.ERAdmitDate
				Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
				
				Set EpisodeID=objRep.EREpisodeID
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				Set DoctorName=objRep.ERDoctorName
				set AdmLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)				
				Set SpecType=objRep.ERSpecimenType.Description
				Set SpecSource=objRep.ERSpecimenSource.Description
				Set SpecClnArea=objRep.ERSpecimenClnArea
				Set Incident=objRep.ERIncident
				Set Hospital=objRep.ERHospital
		
				Set Data=$lb(ind,xRepID,RepStatusDesc,ReportDate,CheckUser,CheckDate)
				Set Data=Data_$lb(ReportNum,RegNo,PatName,PatSex,PatAge,SickDate,AdmitDate)
				Set Data=Data_$lb(MrNo,DoctorName,AdmLocDesc,SpecType,SpecSource,SpecClnArea,Incident,EpisodeID,Hospital)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryILIRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryILIRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryILIRepByDateExecute ]
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

/// Creator：    yukai
/// CreatDate：   2020-03-11
/// Description:  查询全院现患率
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.QryReportILI","QryHospILIRatio","2")
Query QryHospILIRatio(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "admDate:%String,PrevRatio:%String") [ SqlProc ]
{
}

ClassMethod QryHospILIRatioExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"EPD")
	Set:aDateFrom="" aDateFrom=+$h-30
	Set:aDateTo="" aDateTo=+$h
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	Set NIndex="QryHospPrevRatio"
	Kill ^TMP($zn,$j,NIndex)
	
	
	//同期在科:某段时间的在科人数
	Set xDate=aDateFrom-1
	For {
	    set xDate=$o(^PAADMi("PAADM_AdmDate",xDate))
	    Quit:(xDate="")||(xDate>aDateTo)
	    Set EpisodeID=""
	    For {
		    Set EpisodeID=$o(^PAADMi("PAADM_AdmDate",xDate,EpisodeID))
		    Quit:EpisodeID=""
		    If (aHospCode'=""){
		    	Set flg=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,EpisodeID,"EPD")
		    	continue:flg<1
		    }
		    Set num=$i(^TMP($zn,$j,NIndex,xDate,"同期就诊人数"))
		    
		    }
		}
   Set xDate=""
   for{
	   set xDate=$o(^TMP($zn,$j,NIndex,xDate))
	   Quit:xDate=""
	   Set xReportID=""
	   for{
		   Set xReportID=$o(^DHCMed.EPD.ERReportILII("ERReportDateIndex",xDate,xReportID))
		   Quit:xReportID=""
		    If (aHospCode'=""){
			    Set obj=##class(DHCMed.EPD.ERReportILI).GetObjById(xReportID)
		   		Continue:'$IsObject(obj) 
		   		Set EpisodeID=obj.EREpisodeID
		    	Set flg=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,EpisodeID,"EPD")
		    	continue:flg<1
		    }
		   Set num=$i(^TMP($zn,$j,NIndex,xDate,"同期流感人数"))
		   }
	   }
		//b ;1
	For xDate=aDateFrom:1:aDateTo {
		Quit:xDate=""
		Set AdmCount  =+$g(^TMP($zn,$j,NIndex,xDate,"同期就诊人数"))
		Set ILICount =+$g(^TMP($zn,$j,NIndex,xDate,"同期流感人数"))
		Set PrevRatio=0
		Set:ILICount>0 PrevRatio = ILICount/AdmCount
		Set admDate=$e($zd(xDate,3),6,10)
		Set Data=$lb(admDate,PrevRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospILIRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospILIRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
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
