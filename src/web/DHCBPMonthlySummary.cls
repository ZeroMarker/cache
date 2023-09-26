Import SQLUser

Class web.DHCBPMonthlySummary Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPMonthlySummary","FindMonthlySummary","2019-03-21","2019-03-26","C879608","N","C879608","菲奥娜","","416")
Query FindMonthlySummary(fromDate As %String, toDate As %String, regNo As %String = "", needStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", ctLoc As %String = "", registerId As %String = "", monthlySummaryId As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,patSex,patAge,RegisterId,BPMSDateYear,BPMSDateMonth,BPMSSchemeWeekTimes,BPMSSchemeNumHour,BPMSNumber,BPMSHDNumber,BPMSHFNumber,BPMSHDFNumber,BPMSK,BPMSCA,BPMSBF,BPMSConductivity,BPMSSelfHelp,BPMSSleep,BPMSFood,BPMSNutrition,BPMSDose,BPMSVascularAccessDr,BPMSVascularAccess,BPMSBodySiteDr,BPMSBodySite,BPMSVASituation,BPMSVAASituation,BPMSVAASituationOther,BPMSAnticoagulantModeDr,BPMSAnticoagulantMode,BPMSDryWeight,BPMSUrineVolume,BPMSTheraDependence,BPMSOverweight,BPMSEmergencyTimes,BPMSEmergencyReason,BPMSEReasonOther,BPMSPeriodBloodPressure,BPMSInBloodPressure,BPMSComplication,BPMSMedicationSituation,BPMSFrontCreatinine,BPMSFrontUrea,BPMSFrontUricAcid,BPMSFrontK,BPMSFrontNa,BPMSFrontCa,BPMSFrontCl,BPMSFrontP,BPMSFrontHCO3,BPMSAfterCreatinine,BPMSAfterUrea,BPMSAfterUricAcid,BPMSAfterK,BPMSAfterNa,BPMSAfterCa,BPMSAfterCl,BPMSAfterP,BPMSAfterHCO3,BPMSIDD,BPMSHBM,BPMSCreateCtcpDr,BPMSCreateCtcpDesc,BPMSCreateDate,BPMSCreateTime,BPMSCOther,BPMSEvaluationSuggestion,BPMSStatus,BPMSUpdateCtcpDr,BPMSUpdateCtcpDesc,BPMSUpdateDate,BPMSUpdateTime,BPMSHb,BPMSWBC,BPMSPLT,BPMSTS,BPMSSF,BPMSiPTH,BPMSALB,BPMSALT,BPMSAST,BPMSGGT,BPMSAL,BPMSBIL,BPMSdBIL,BPMSUreaCL")
{
}

ClassMethod FindMonthlySummaryExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", ctLoc As %String = "", registerId As %String = "", monthlySummaryId As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i monthlySummaryId'="" d
		.s bpmsId=monthlySummaryId
		.q:$$GetMonthlySummary()<0
		.d OutputRow
	i monthlySummaryId'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCANOPCom).GetPatientEpisodeID(regNo,"")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	s wardIdStr=##Class(web.DHCBPCom).GetLinkLocByLocId(ctLoc) //科室关联
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..q:'$d(^PAPER(papmiId,"PAT",1))
			..//s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,"")) //患者登记多次
			..//q:bpprId=""
			..s bpprId=""
			..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d			
				...q:(registerId'="")&&(bpprId'=registerId)
				...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
				...q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
				...s bpmsId=""
				...f  s bpmsId=$o(^DHCBPMonthlySummary(0,"Register",bpprId,bpmsId)) q:bpmsId=""  d
					....q:$$GetMonthlySummary()<0
					....d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMonthlySummary()
	q:bpmsId="" -1
	s RegisterId=$lg(^DHCBPMonthlySummary(bpmsId),1)	
	s papmiId=$lg(^DHCBPPatRegister(RegisterId),1)	
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	s EpisodeID=$lg($g(^DHCBPPatRegister(RegisterId)),26)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	;w bpmsId,!    
	s BPMSDateYear=$lg(^DHCBPMonthlySummary(bpmsId),2)
	s BPMSDateMonth=$lg(^DHCBPMonthlySummary(bpmsId),3)
	s BPMSSchemeWeekTimes=$lg(^DHCBPMonthlySummary(bpmsId),4)
	s BPMSSchemeNumHour=$lg(^DHCBPMonthlySummary(bpmsId),5)
	s BPMSNumber=$lg(^DHCBPMonthlySummary(bpmsId),6)
	s BPMSHDNumber=$lg(^DHCBPMonthlySummary(bpmsId),7)
	s BPMSHFNumber=$lg(^DHCBPMonthlySummary(bpmsId),8)
	s BPMSHDFNumber=$lg(^DHCBPMonthlySummary(bpmsId),9)
	s BPMSK=$lg(^DHCBPMonthlySummary(bpmsId),10)
	s BPMSCA=$lg(^DHCBPMonthlySummary(bpmsId),11)
	s BPMSBF=$lg(^DHCBPMonthlySummary(bpmsId),12)
	s BPMSConductivity=$lg(^DHCBPMonthlySummary(bpmsId),13)
	s BPMSSelfHelp=$lg(^DHCBPMonthlySummary(bpmsId),14)
	s BPMSSleep=$lg(^DHCBPMonthlySummary(bpmsId),15)
	s BPMSFood=$lg(^DHCBPMonthlySummary(bpmsId),16)
	s BPMSNutrition=$lg(^DHCBPMonthlySummary(bpmsId),17)
	s BPMSDose=$lg(^DHCBPMonthlySummary(bpmsId),18) 
	s BPMSVascularAccessDr=$lg(^DHCBPMonthlySummary(bpmsId),19)
	s BPMSVascularAccess=""
	i BPMSVascularAccessDr'="" s BPMSVascularAccess=$lg($g(^DHCBPC("VascularAccess",BPMSVascularAccessDr)),2)
	s BPMSBodySiteDr=$lg(^DHCBPMonthlySummary(bpmsId),20)
	s BPMSBodySite=""
	i BPMSBodySiteDr'="" s BPMSBodySite=$lg(^DHCCLC("BodySite",BPMSBodySiteDr),2)
	s BPMSVASituation=$lg(^DHCBPMonthlySummary(bpmsId),21)
	s BPMSVAASituation=$lg(^DHCBPMonthlySummary(bpmsId),22)
	s BPMSVAASituationOther=$lg(^DHCBPMonthlySummary(bpmsId),23)
	s BPMSAnticoagulantModeDr=$lg(^DHCBPMonthlySummary(bpmsId),24)
	s BPMSAnticoagulantMode=""
	i BPMSAnticoagulantModeDr'="" s BPMSAnticoagulantMode=$lg($g(^DHCBPC("BloodPurificationMode",BPMSAnticoagulantModeDr)),2)
	s BPMSDryWeight=$lg(^DHCBPMonthlySummary(bpmsId),25)
	s BPMSUrineVolume=$lg(^DHCBPMonthlySummary(bpmsId),26)
	s BPMSTheraDependence=$lg(^DHCBPMonthlySummary(bpmsId),27)
	s BPMSOverweight=$lg(^DHCBPMonthlySummary(bpmsId),28)		
	s BPMSEmergencyTimes=$lg(^DHCBPMonthlySummary(bpmsId),29)
	s BPMSEmergencyReason=$lg(^DHCBPMonthlySummary(bpmsId),30)
	s BPMSEReasonOther=$lg(^DHCBPMonthlySummary(bpmsId),31)
	s BPMSPeriodBloodPressure=$lg(^DHCBPMonthlySummary(bpmsId),32)		
	s BPMSInBloodPressure=$lg(^DHCBPMonthlySummary(bpmsId),33)
	s BPMSComplication=$lg(^DHCBPMonthlySummary(bpmsId),34)
	s BPMSMedicationSituation=$lg(^DHCBPMonthlySummary(bpmsId),35)
	s BPMSFrontCreatinine=$lg(^DHCBPMonthlySummary(bpmsId),36)	    
	s BPMSFrontUrea=$lg(^DHCBPMonthlySummary(bpmsId),37)
	s BPMSFrontUricAcid=$lg(^DHCBPMonthlySummary(bpmsId),38)
	s BPMSFrontK=$lg(^DHCBPMonthlySummary(bpmsId),39)
	s BPMSFrontNa=$lg(^DHCBPMonthlySummary(bpmsId),40)	    
	s BPMSFrontCa=$lg(^DHCBPMonthlySummary(bpmsId),41)
	s BPMSFrontCl=$lg(^DHCBPMonthlySummary(bpmsId),42)
	s BPMSFrontP=$lg(^DHCBPMonthlySummary(bpmsId),43)
	s BPMSFrontHCO3=$lg(^DHCBPMonthlySummary(bpmsId),44)	    
	s BPMSAfterCreatinine=$lg(^DHCBPMonthlySummary(bpmsId),45)
	s BPMSAfterUrea=$lg(^DHCBPMonthlySummary(bpmsId),46)
	s BPMSAfterUricAcid=$lg(^DHCBPMonthlySummary(bpmsId),47)
	s BPMSAfterK=$lg(^DHCBPMonthlySummary(bpmsId),48)
	s BPMSAfterNa=$lg(^DHCBPMonthlySummary(bpmsId),49)
	s BPMSAfterCa=$lg(^DHCBPMonthlySummary(bpmsId),50)
	s BPMSAfterCl=$lg(^DHCBPMonthlySummary(bpmsId),51)
	s BPMSAfterP=$lg(^DHCBPMonthlySummary(bpmsId),52)		
	s BPMSAfterHCO3=$lg(^DHCBPMonthlySummary(bpmsId),53)		
	s BPMSIDD=$lg(^DHCBPMonthlySummary(bpmsId),54)
	s BPMSHBM=$lg(^DHCBPMonthlySummary(bpmsId),55)
	s BPMSCreateCtcpDr=$lg(^DHCBPMonthlySummary(bpmsId),56)
	s BPMSCreateCtcpDesc=##class(web.DHCBPCom).GetNameById(BPMSCreateCtcpDr)
	s BPMSCreateDate=$lg(^DHCBPMonthlySummary(bpmsId),57)
	q:((fromDate'="")&&(fromDate>BPMSCreateDate))||((toDate'="")&&(toDate<BPMSCreateDate)) -2
	i BPMSCreateDate'="" d
	.s BPMSCreateDate=##class(web.DHCClinicCom).ConvertToDate(BPMSCreateDate)
	s BPMSCreateTime=$lg(^DHCBPMonthlySummary(bpmsId),58)
	i BPMSCreateTime'="" d
	.s BPMSCreateTime=##class(web.DHCClinicCom).ConvertToTime(BPMSCreateTime)
	s BPMSCOther=$lg(^DHCBPMonthlySummary(bpmsId),59)
	s BPMSEvaluationSuggestion=$lg(^DHCBPMonthlySummary(bpmsId),60)
	s BPMSStatus=$lg(^DHCBPMonthlySummary(bpmsId),61)
	;w "BPMSStatus:"_BPMSStatus,!
	q:(needStatus'="")&&(needStatus'[BPMSStatus) -3
	s BPMSUpdateCtcpDr=$lg(^DHCBPMonthlySummary(bpmsId),62)
	s BPMSUpdateCtcpDesc=##class(web.DHCBPCom).GetNameById(BPMSUpdateCtcpDr)
	s BPMSUpdateDate=$lg(^DHCBPMonthlySummary(bpmsId),63)
	i BPMSUpdateDate'="" d
	.s BPMSUpdateDate=##class(web.DHCClinicCom).ConvertToDate(BPMSUpdateDate)
	s BPMSUpdateTime=$lg(^DHCBPMonthlySummary(bpmsId),64)
	i BPMSUpdateTime'="" d
	.s BPMSUpdateTime=##class(web.DHCClinicCom).ConvertToTime(BPMSUpdateTime)	
	;w "BPMSStatus1:"_BPMSStatus,!
	s BPMSHb=$lg(^DHCBPMonthlySummary(bpmsId),65)
	s BPMSWBC=$lg(^DHCBPMonthlySummary(bpmsId),66)
	s BPMSPLT=$lg(^DHCBPMonthlySummary(bpmsId),67)
	s BPMSTS=$lg(^DHCBPMonthlySummary(bpmsId),68)
	s BPMSSF=$lg(^DHCBPMonthlySummary(bpmsId),69)
	s BPMSiPTH=$lg(^DHCBPMonthlySummary(bpmsId),70)
	s BPMSALB=$lg(^DHCBPMonthlySummary(bpmsId),71)
	s BPMSALT=$lg(^DHCBPMonthlySummary(bpmsId),72)
	s BPMSAST=$lg(^DHCBPMonthlySummary(bpmsId),73)
	s BPMSGGT=$lg(^DHCBPMonthlySummary(bpmsId),74)
	s BPMSAL=$lg(^DHCBPMonthlySummary(bpmsId),75)
	s BPMSBIL=$lg(^DHCBPMonthlySummary(bpmsId),76)
	s BPMSdBIL=$lg(^DHCBPMonthlySummary(bpmsId),77)
	s BPMSUreaCL=$lg(^DHCBPMonthlySummary(bpmsId),78)
	;w bpmsId,!
	q 0
OutputRow
	set Data=$lb(bpmsId,regNo,patName,papmiMedicare,patSex,patAge,RegisterId,BPMSDateYear,BPMSDateMonth,BPMSSchemeWeekTimes,BPMSSchemeNumHour,BPMSNumber,BPMSHDNumber,BPMSHFNumber,BPMSHDFNumber,BPMSK,BPMSCA,BPMSBF,BPMSConductivity,BPMSSelfHelp,BPMSSleep,BPMSFood,BPMSNutrition,BPMSDose,BPMSVascularAccessDr,BPMSVascularAccess,BPMSBodySiteDr,BPMSBodySite,BPMSVASituation,BPMSVAASituation,BPMSVAASituationOther,BPMSAnticoagulantModeDr,BPMSAnticoagulantMode,BPMSDryWeight,BPMSUrineVolume,BPMSTheraDependence,BPMSOverweight,BPMSEmergencyTimes,BPMSEmergencyReason,BPMSEReasonOther,BPMSPeriodBloodPressure,BPMSInBloodPressure,BPMSComplication,BPMSMedicationSituation,BPMSFrontCreatinine,BPMSFrontUrea,BPMSFrontUricAcid,BPMSFrontK,BPMSFrontNa,BPMSFrontCa,BPMSFrontCl,BPMSFrontP,BPMSFrontHCO3,BPMSAfterCreatinine,BPMSAfterUrea,BPMSAfterUricAcid,BPMSAfterK,BPMSAfterNa,BPMSAfterCa,BPMSAfterCl,BPMSAfterP,BPMSAfterHCO3,BPMSIDD,BPMSHBM,BPMSCreateCtcpDr,BPMSCreateCtcpDesc,BPMSCreateDate,BPMSCreateTime,BPMSCOther,BPMSEvaluationSuggestion,BPMSStatus,BPMSUpdateCtcpDr,BPMSUpdateCtcpDesc,BPMSUpdateDate,BPMSUpdateTime,BPMSHb,BPMSWBC,BPMSPLT,BPMSTS,BPMSSF,BPMSiPTH,BPMSALB,BPMSALT,BPMSAST,BPMSGGT,BPMSAL,BPMSBIL,BPMSdBIL,BPMSUreaCL)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMonthlySummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMonthlySummaryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMonthlySummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMonthlySummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCBPMonthlySummary).AddMonthlySummary("416$c(3)2019$c(3)3$c(3)1$c(3)2$c(3)3$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)正常$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)52$c(3)$c(3)$c(3)N$c(3)")
ClassMethod AddMonthlySummary(MonthlySummary As %String) As %String
{
	q:($p(MonthlySummary,$c(3),1)="") "未登记的病人不能进行月小结"
	s MonthlySummaryObj=""        
    s MonthlySummaryObj=##class(User.DHCBPMonthlySummary).%New()	
    s MonthlySummaryObj.BPMSBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId($p(MonthlySummary,$c(3),1))
	s MonthlySummaryObj.BPMSDateYear=$p(MonthlySummary,$c(3),2)
	s MonthlySummaryObj.BPMSDateMonth=$p(MonthlySummary,$c(3),3)
	s MonthlySummaryObj.BPMSSchemeWeekTimes=$p(MonthlySummary,$c(3),4)
	s MonthlySummaryObj.BPMSSchemeNumHour=$p(MonthlySummary,$c(3),5)
	s MonthlySummaryObj.BPMSNumber=$p(MonthlySummary,$c(3),6)
	s MonthlySummaryObj.BPMSHDNumber=$p(MonthlySummary,$c(3),7)
	s MonthlySummaryObj.BPMSHFNumber=$p(MonthlySummary,$c(3),8)
	s MonthlySummaryObj.BPMSHDFNumber=$p(MonthlySummary,$c(3),9)
	s MonthlySummaryObj.BPMSK=$p(MonthlySummary,$c(3),10) 
	s MonthlySummaryObj.BPMSCA=$p(MonthlySummary,$c(3),11)
	s MonthlySummaryObj.BPMSBF=$p(MonthlySummary,$c(3),12)
	s MonthlySummaryObj.BPMSConductivity=$p(MonthlySummary,$c(3),13)
	s MonthlySummaryObj.BPMSSelfHelp=$p(MonthlySummary,$c(3),14)
	s MonthlySummaryObj.BPMSSleep=$p(MonthlySummary,$c(3),15)
	s MonthlySummaryObj.BPMSFood=$p(MonthlySummary,$c(3),16)
	s MonthlySummaryObj.BPMSNutrition=$p(MonthlySummary,$c(3),17)
	s MonthlySummaryObj.BPMSDose=$p(MonthlySummary,$c(3),18)
	s MonthlySummaryObj.BPMSVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId($p(MonthlySummary,$c(3),19))
	s MonthlySummaryObj.BPMSBodySiteDr=$p(MonthlySummary,$c(3),20)
	s MonthlySummaryObj.BPMSVASituation=$p(MonthlySummary,$c(3),21)
	s MonthlySummaryObj.BPMSVAASituation=$p(MonthlySummary,$c(3),22)
	s MonthlySummaryObj.BPMSVAASituationOther=$p(MonthlySummary,$c(3),23)
	s MonthlySummaryObj.BPMSAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId($p(MonthlySummary,$c(3),24))
	s MonthlySummaryObj.BPMSDryWeight=$p(MonthlySummary,$c(3),25)
	s MonthlySummaryObj.BPMSUrineVolume=$p(MonthlySummary,$c(3),26)
	s MonthlySummaryObj.BPMSTheraDependence=$p(MonthlySummary,$c(3),27)
	s MonthlySummaryObj.BPMSOverweight=$p(MonthlySummary,$c(3),28)
	s MonthlySummaryObj.BPMSEmergencyTimes=$p(MonthlySummary,$c(3),29)	
	s MonthlySummaryObj.BPMSEmergencyReason=$p(MonthlySummary,$c(3),30)
	s MonthlySummaryObj.BPMSEReasonOther=$p(MonthlySummary,$c(3),31)
	s MonthlySummaryObj.BPMSPeriodBloodPressure=$p(MonthlySummary,$c(3),32)
	s MonthlySummaryObj.BPMSInBloodPressure=$p(MonthlySummary,$c(3),33)		
	s MonthlySummaryObj.BPMSComplication=$p(MonthlySummary,$c(3),34)
	s MonthlySummaryObj.BPMSMedicationSituation=$p(MonthlySummary,$c(3),35)
	s MonthlySummaryObj.BPMSFrontCreatinine=$p(MonthlySummary,$c(3),36)
	s MonthlySummaryObj.BPMSFrontUrea=$p(MonthlySummary,$c(3),37)
	s MonthlySummaryObj.BPMSFrontUricAcid=$p(MonthlySummary,$c(3),38)
	s MonthlySummaryObj.BPMSFrontK=$p(MonthlySummary,$c(3),39)
	s MonthlySummaryObj.BPMSFrontNa=$p(MonthlySummary,$c(3),40)
	s MonthlySummaryObj.BPMSFrontCa=$p(MonthlySummary,$c(3),41)	
	s MonthlySummaryObj.BPMSFrontCl=$p(MonthlySummary,$c(3),42)
	s MonthlySummaryObj.BPMSFrontP=$p(MonthlySummary,$c(3),43)
	s MonthlySummaryObj.BPMSFrontHCO3=$p(MonthlySummary,$c(3),44)
	s MonthlySummaryObj.BPMSAfterCreatinine=$p(MonthlySummary,$c(3),45)
	s MonthlySummaryObj.BPMSAfterUrea=$p(MonthlySummary,$c(3),46)
	s MonthlySummaryObj.BPMSAfterUricAcid=$p(MonthlySummary,$c(3),47)	
	s MonthlySummaryObj.BPMSAfterK=$p(MonthlySummary,$c(3),48)
	s MonthlySummaryObj.BPMSAfterNa=$p(MonthlySummary,$c(3),49)
	s MonthlySummaryObj.BPMSAfterCa=$p(MonthlySummary,$c(3),50)
	s MonthlySummaryObj.BPMSAfterCl=$p(MonthlySummary,$c(3),51)	
	s MonthlySummaryObj.BPMSAfterP=$p(MonthlySummary,$c(3),52)
	s MonthlySummaryObj.BPMSAfterHCO3=$p(MonthlySummary,$c(3),53)
	s MonthlySummaryObj.BPMSIDD=$p(MonthlySummary,$c(3),54)
	s MonthlySummaryObj.BPMSHBM=$p(MonthlySummary,$c(3),55)	
	s MonthlySummaryObj.BPMSCreateCtcpDr=$p(MonthlySummary,$c(3),56)
	s MonthlySummaryObj.BPMSCreateDate=+$h
	s MonthlySummaryObj.BPMSCreateTime=$p($h,",",2)
	s MonthlySummaryObj.BPMSCOther=$p(MonthlySummary,$c(3),57)
	s MonthlySummaryObj.BPMSEvaluationSuggestion=$p(MonthlySummary,$c(3),58)
	s MonthlySummaryObj.BPMSStatus=$p(MonthlySummary,$c(3),59)	
	s MonthlySummaryObj.BPMSHb=$p(MonthlySummary,$c(3),60)
	s MonthlySummaryObj.BPMSWBC=$p(MonthlySummary,$c(3),61)
	s MonthlySummaryObj.BPMSPLT=$p(MonthlySummary,$c(3),62)	
	s MonthlySummaryObj.BPMSTS=$p(MonthlySummary,$c(3),63)
	s MonthlySummaryObj.BPMSSF=$p(MonthlySummary,$c(3),64)
	s MonthlySummaryObj.BPMSiPTH=$p(MonthlySummary,$c(3),65)
	s MonthlySummaryObj.BPMSALB=$p(MonthlySummary,$c(3),66)	
	s MonthlySummaryObj.BPMSALT=$p(MonthlySummary,$c(3),67)
	s MonthlySummaryObj.BPMSAST=$p(MonthlySummary,$c(3),68)
	s MonthlySummaryObj.BPMSGGT=$p(MonthlySummary,$c(3),69)
	s MonthlySummaryObj.BPMSAL=$p(MonthlySummary,$c(3),70)	
	s MonthlySummaryObj.BPMSBIL=$p(MonthlySummary,$c(3),71)
	s MonthlySummaryObj.BPMSdBIL=$p(MonthlySummary,$c(3),72)	
	s MonthlySummaryObj.BPMSUreaCL=$p(MonthlySummary,$c(3),73)	
	
	d MonthlySummaryObj.%Save()
	s result=MonthlySummaryObj.%Id()
	d MonthlySummaryObj.%Close()
	q result
}

/// w ##class(web.DHCBPMonthlySummary).StopMonthlySummary("4$c(3)D$c(3)52")
ClassMethod StopMonthlySummary(MonthlySummary As %String) As %String
{
	q:MonthlySummary="" "未选中月小结"
	s result=0
	s rowId=$p(MonthlySummary,$c(3),1)
	q:rowId="" 
	s MonthlySummaryObj=""
    s MonthlySummaryObj=##class(User.DHCBPMonthlySummary).%OpenId(rowId) 	
	s MonthlySummaryObj.BPMSStatus=$p(MonthlySummary,$c(3),2)
	s MonthlySummaryObj.BPMSUpdateCtcpDr=$p(MonthlySummary,$c(3),3)
	s MonthlySummaryObj.BPMSUpdateDate=+$h
	s MonthlySummaryObj.BPMSUpdateTime=$p($h,",",2)
	d MonthlySummaryObj.%Save()
	s result=MonthlySummaryObj.%Id()
	d MonthlySummaryObj.%Close()
	q result
}

}
