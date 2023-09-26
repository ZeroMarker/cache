/// CLassName：DHCMed.EPDService.RunQianPrint
/// description：润乾打印Query：肺结核转诊单、HIV个案随访表、流感样病例
/// Author：liuzhenhe
/// CreateDate：2020-03-23
Class DHCMed.EPDService.RunQianPrint Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2020-03-25
/// Description:  肺结核病人转诊单润乾打印query
/// Table：       DHCMed.EPD.ReferralRep
/// Input：                 
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.RunQianPrint","QryReferralRep","1")
Query QryReferralRep(aReportID As %String) As %Query(ROWSPEC = "aReportID:%String,PatName:%String,PatSex:%String,PatAge:%String,PatMrNo:%String,PatAddress:%String,PatPhoneNo:%String,FamilyName:%String,WorkAddress:%String,ReferralHosp:%String,ReferralDoc:%String,ReferralDate:%String,ReferralAdd:%String,ReferralPhone:%String,ReferralReason:%String") [ SqlProc ]
{
}

ClassMethod QryReferralRepExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objRep
	Set objRep=##class(DHCMed.EPD.ReferralRep).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	
	Set PatName = objRep.PatName
	Set PatSex = objRep.PatSex
	Set PatAge = objRep.PatAge
	Set PatMrNo = objRep.PatMrNo
	Set PatAddress = objRep.PatAddress
	Set PatPhoneNo = objRep.PatPhoneNo
	Set FamilyName = objRep.FamilyName
	Set WorkAddress = objRep.WorkAddress
	Set ReferralHosp = objRep.ReferralHosp
	Set ReferralDoc = objRep.ReferralDoc
	Set ReferralDate = objRep.ReferralDate
	Set ReferralAdd = objRep.ReferralAdd
	Set ReferralPhone = objRep.ReferralPhone
	Set ReferralReason = objRep.ReferralReason
	if ReferralReason'=""{
		Set objReferralReason = ##class(DHCMed.SS.Dictionary).GetObjById(ReferralReason)
		Set:$IsObject(objReferralReason) ReferralReason = objReferralReason.Description
	}
	
	Set Data=$lb(aReportID,PatName,PatSex,PatAge,PatMrNo,PatAddress,PatPhoneNo,FamilyName,WorkAddress,ReferralHosp,ReferralDoc,ReferralDate,ReferralAdd,ReferralPhone,ReferralReason)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryReferralRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReferralRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReferralRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReferralRepExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2020-03-25
/// Description:  HIV个案随访表润乾打印query
/// Table：       DHCMed.EPD.CaseFollow
/// Input：                
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.RunQianPrint","QryHIVFollow","2")
Query QryHIVFollow(aReportID As %String) As %Query(ROWSPEC = "aReportID:%String,FollowNo:%String,FollowStatus:%String,FollowTimes:%String,IsCustody:%String,Reasons:%String,PatName:%String,PatSex:%String,FamilyName:%String,PatCardID:%String,PhoneNo:%String,Address:%String,IsHIVTest:%String,fLastHIVTestDate:%String,NeverHIVTest:%String,fFirstHIVTestDate:%String,HIVTestTimes:%String,IsDead:%String,fDeathDate:%String,DeathStage:%String,DeathPlace:%String,DeathOtherPlace:%String,DeathReasonSource:%String,DeathOtherSource:%String,DeathReason:%String,DeathReasonHIV:%String,DeathReasonOthers:%String,HIVManifestation:%String,CourseStage:%String,fHIVDate:%String,SpouseSituation:%String,SpouseHIV:%String,SpouseCaseNo:%String,fSpouseHIVDate:%String,Children:%String,Children1:%String,Children2:%String,Children3:%String,Children4:%String,HIVSurvey1:%String,HIVSurvey2:%String,HIVSurvey2No:%String,HIVSurvey3:%String,HIVSurvey4:%String,HIVSurvey4No:%String,HIVSurvey5:%String,HIVSurvey5No:%String,HIVSurvey5No1:%String,HIVSurvey6:%String,HIVSurvey6No:%String,HIVSurvey7:%String,IsHIVSurvey7:%String,HIVSurvey8a:%String,HIVSurvey8aNo1:%String,HIVSurvey8aNo2:%String,HIVSurvey8b:%String,HIVSurvey8c:%String,HIVSurvey9:%String,IsHIVSurvey10:%String,HIVSurvey10:%String,IsHIVSurvey11:%String,IsHIVSurvey11No:%String,CD4TestTimes:%String,CD4TestResult:%String,fCD4TestDate:%String,CD4TestUnit:%String,SurveyOrgan:%String,SurveyName:%String,fSurveyDate:%String,Comments:%String,HIVPatBelong:%String,HIVTreatment:%String,ViralloadTestResult:%String,ViralloadTestDate:%String,posmonCaseNo:%String,posmonTestUnit:%String") [ SqlProc ]
{
}

ClassMethod QryHIVFollowExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill obj
	Set obj=##class(DHCMed.EPD.CaseFollow).GetObjById(aReportID)
	Quit:'$IsObject(obj) $$$OK

	Set FollowNo = obj.FollowNo
	Set FollowStatus = ""
	Set:$IsObject(obj.FollowStatus) FollowStatus=obj.FollowStatus.Description
	Set FollowTimes = obj.FollowTimes
	Set IsCustody = ""
	Set:$IsObject(obj.IsCustody) IsCustody=obj.IsCustody.Description
	Set Reasons = ""
	Set:$IsObject(obj.Reasons) Reasons=obj.Reasons.Description
	
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(obj.PatientID)
	Set (PatName,PatSex) = ""
	If ($IsObject(objPat)){
		Set PatName=objPat.PatientName
		//Set PatCardID=objPat.PersonalID
		Set PatSex=objPat.Sex
	}
	Set FamilyName = obj.EPDSuper.MEPDFamName
	Set PatCardID = obj.FollowText1
	Set PhoneNo = obj.EPDSuper.MEPDTelPhone
	Set Address = obj.EPDSuper.MEPDAddress
	Set:Address'="" Address=Address_"号"
	
	//HIV检测
	Set IsHIVTest = ""
	Set:$IsObject(obj.IsHIVTest) IsHIVTest=obj.IsHIVTest.Description
	Set fLastHIVTestDate = ""
	If (obj.LastHIVTestDate'="") {
		Set fLastHIVTestDate=$zd(obj.LastHIVTestDate,3)
		Set fLastHIVTestDate=$p(fLastHIVTestDate,"-",1)_"年"_$p(fLastHIVTestDate,"-",2)_"月"
	}
	Set NeverHIVTest = obj.NeverHIVTest
	Set fFirstHIVTestDate = ""
	If (obj.FirstHIVTestDate'=""){
		Set fFirstHIVTestDate=$zd(obj.FirstHIVTestDate,3)
		Set fFirstHIVTestDate=$p(fFirstHIVTestDate,"-",1)_"年"_$p(fFirstHIVTestDate,"-",2)_"月"
	} 
	Set HIVTestTimes = obj.HIVTestTimes
	Set IsDead = ""
	Set:$IsObject(obj.IsDead) IsDead=obj.IsDead.Description
	Set fDeathDate = ""
	If (obj.DeathDate'=""){
		Set fDeathDate=$zd(obj.DeathDate,3)
		Set fDeathDate=$p(fDeathDate,"-",1)_"年"_$p(fDeathDate,"-",2)_"月"_$p(fDeathDate,"-",3)_"日"
	}
	Set DeathStage = ""
	Set:$IsObject(obj.DeathStage) DeathStage=obj.DeathStage.Description
	Set DeathPlace=""
	Set:$IsObject(obj.DeathPlace) DeathPlace=obj.DeathPlace.Description
	Set DeathOtherPlace = obj.DeathOtherPlace
	Set DeathReasonSource = ""
	For index=1:1:obj.DeathReasonSource.Count() {
		Set objDic=obj.DeathReasonSource.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set DeathReasonSource=DeathReasonSource_"^"_xDesc
	}
	Set DeathOtherSource = obj.DeathOtherSource	
	Set DeathReason = ""
	Set:$IsObject(obj.DeathReason) DeathReason = obj.DeathReason.Description
	Set (DeathReasonHIV,DeathReasonOthers)=""
	If (DeathReason="艾滋病相关疾病死亡"){
		For index=1:1:obj.DeathReasonHIV.Count() {
			Set objDic=obj.DeathReasonHIV.GetAt(index)
			Continue:'$IsObject(objDic)
			Set xDesc=objDic.Description
			Set DeathReasonHIV=DeathReasonHIV_"^"_xDesc
		}
	}ElseIf(DeathReason="艾滋病无关死亡"){
		For index=1:1:obj.DeathReasonOthers.Count() {
			Set objDic=obj.DeathReasonOthers.GetAt(index)
			Continue:'$IsObject(objDic)
			Set xDesc=objDic.Description
			Set DeathReasonOthers=DeathReasonOthers_"^"_xDesc
		}	
	}
	
	//HIV临床表现
	Set HIVManifestation = ""
	For index=1:1:obj.HIVManifestation.Count() {
		Set objDic=obj.HIVManifestation.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set HIVManifestation=HIVManifestation_"^"_xDesc
	}
	//随访调查
	Set CourseStage = ""
	Set:$IsObject(obj.CourseStage) CourseStage=obj.CourseStage.Description
	Set fHIVDate = ""
	If (obj.HIVDate'="")&&(CourseStage="艾滋病病人") {
		Set fHIVDate=$zd(obj.HIVDate,3)
		Set fHIVDate=$p(fHIVDate,"-",1)_"年"_$p(fHIVDate,"-",2)_"月"_$p(fHIVDate,"-",3)_"日"
	}
	Set SpouseSituation = ""
	Set:$IsObject(obj.SpouseSituation) SpouseSituation=obj.SpouseSituation.Description
	Set SpouseHIV = ""
	Set:$IsObject(obj.SpouseHIV) SpouseHIV=obj.SpouseHIV.Description
	Set SpouseCaseNo = obj.SpouseCaseNo
	Set fSpouseHIVDate = ""
	If (obj.SpouseHIVDate'=""){
		Set fSpouseHIVDate=$zd(obj.SpouseHIVDate,3)
		Set fSpouseHIVDate=$p(fSpouseHIVDate,"-",1)_"年"_$p(fSpouseHIVDate,"-",2)_"月"_$p(fSpouseHIVDate,"-",3)_"日"
	}
	Set Children = obj.Children
	Set Children1= obj.Children1
	Set Children2= obj.Children2
	Set Children3= obj.Children3
	Set Children4= obj.Children4
	Set HIVSurvey1 = ""
	Set:$IsObject(obj.HIVSurvey1) HIVSurvey1=obj.HIVSurvey1.Description
	Set HIVSurvey2 = ""
	Set:$IsObject(obj.HIVSurvey2) HIVSurvey2=obj.HIVSurvey2.Description
	Set HIVSurvey2No=obj.HIVSurvey2No
	Set HIVSurvey3 = ""
	Set:$IsObject(obj.HIVSurvey3) HIVSurvey3=obj.HIVSurvey3.Description
	Set HIVSurvey4 = ""
	Set:$IsObject(obj.HIVSurvey4) HIVSurvey4=obj.HIVSurvey4.Description
	Set HIVSurvey4No = obj.HIVSurvey4No
	Set HIVSurvey5 = ""
	Set:$IsObject(obj.HIVSurvey5) HIVSurvey5=obj.HIVSurvey5.Description
	Set HIVSurvey5No = obj.HIVSurvey5No
	Set HIVSurvey5No1= obj.HIVSurvey5No1
	Set HIVSurvey6 = ""
	Set:$IsObject(obj.HIVSurvey6) HIVSurvey6=obj.HIVSurvey6.Description
	Set HIVSurvey6No = obj.HIVSurvey6No
	Set HIVSurvey7 = ""
	Set:$IsObject(obj.HIVSurvey7) HIVSurvey7=obj.HIVSurvey7.Description
	Set IsHIVSurvey7 = ""
	Set:$IsObject(obj.IsHIVSurvey7) IsHIVSurvey7=obj.IsHIVSurvey7.Description
	Set HIVSurvey8a = ""
	Set:$IsObject(obj.HIVSurvey8a) HIVSurvey8a=obj.HIVSurvey8a.Description
	Set HIVSurvey8aNo1 = obj.HIVSurvey8aNo1
	Set HIVSurvey8aNo2 = obj.HIVSurvey8aNo2
	Set HIVSurvey8b = ""
	Set:$IsObject(obj.HIVSurvey8b) HIVSurvey8b=obj.HIVSurvey8b.Description
	Set HIVSurvey8c = ""
	Set:$IsObject(obj.HIVSurvey8c) HIVSurvey8c=obj.HIVSurvey8c.Description
	Set HIVSurvey9 = ""
	For index=1:1:obj.HIVSurvey9.Count() {
		Set objDic=obj.HIVSurvey9.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set HIVSurvey9=HIVSurvey9_"^"_xDesc
	}
	Set IsHIVSurvey10 = ""
	Set:$IsObject(obj.IsHIVSurvey10) IsHIVSurvey10=obj.IsHIVSurvey10.Description
	Set HIVSurvey10 = ""
	Set:$IsObject(obj.HIVSurvey10) HIVSurvey10 = obj.HIVSurvey10.Description
	Set IsHIVSurvey11 = ""
	Set:$ISObject(obj.IsHIVSurvey11) IsHIVSurvey11=obj.IsHIVSurvey11.Description
	Set IsHIVSurvey11No = obj.IsHIVSurvey11No
	//CD4检测
	Set CD4TestTimes = obj.CD4TestTimes
	Set CD4TestResult= obj.CD4TestResult
	Set fCD4TestDate = ""
	If (obj.CD4TestDate'="") {
		Set fCD4TestDate=$zd(obj.CD4TestDate,3)
		Set fCD4TestDate=$p(fCD4TestDate,"-",1)_"年"_$p(fCD4TestDate,"-",2)_"月"_$p(fCD4TestDate,"-",3)_"日"
	}
	Set CD4TestUnit = obj.CD4TestUnit
	Set SurveyOrgan = obj.SurveyOrgan
	Set SurveyName  = obj.SurveyName
	Set fSurveyDate = ""
	If (obj.SurveyDate'="") {
		Set fSurveyDate=$zd(obj.SurveyDate,3)
		Set fSurveyDate=$p(fSurveyDate,"-",1)_"年"_$p(fSurveyDate,"-",2)_"月"_$p(fSurveyDate,"-",3)_"日"
	}
	Set Comments=obj.Comments
	
	Set HIVPatBelong = ""
	Set:$IsObject(obj.HIVPatBelong) HIVPatBelong=obj.HIVPatBelong.Description
	Set HIVTreatment = ""
	Set:$IsObject(obj.HIVTreatment) HIVTreatment=obj.HIVTreatment.Description
	Set ViralloadTestResult  = obj.ViralloadTestResult
	Set ViralloadTestDate = ""
	Set:ViralloadTestDate'="" ViralloadTestDate=$zd(obj.ViralloadTestDate,3)
	
	Set posmonCaseNo  = obj.posmonCaseNo
	Set posmonTestUnit  = obj.posmonTestUnit
	
	
	
	Set Data=$lb(aReportID,FollowNo,FollowStatus,FollowTimes,IsCustody,Reasons,PatName,PatSex,FamilyName,PatCardID,PhoneNo,Address,IsHIVTest,fLastHIVTestDate,NeverHIVTest,fFirstHIVTestDate,HIVTestTimes)
	Set Data=Data_$lb(IsDead,fDeathDate,DeathStage,DeathPlace,DeathOtherPlace,DeathReasonSource,DeathOtherSource,DeathReason,DeathReasonHIV,DeathReasonOthers, HIVManifestation,CourseStage,fHIVDate,SpouseSituation,SpouseHIV,SpouseCaseNo,fSpouseHIVDate,Children,Children1,Children2,Children3,Children4,HIVSurvey1)
	Set Data=Data_$lb(HIVSurvey2,HIVSurvey2No,HIVSurvey3,HIVSurvey4,HIVSurvey4No,HIVSurvey5,HIVSurvey5No,HIVSurvey5No1,HIVSurvey6,HIVSurvey6No,HIVSurvey7,IsHIVSurvey7,HIVSurvey8a,HIVSurvey8aNo1,HIVSurvey8aNo2,HIVSurvey8b,HIVSurvey8c,HIVSurvey9,IsHIVSurvey10,HIVSurvey10,IsHIVSurvey11,IsHIVSurvey11No,CD4TestTimes,CD4TestResult,fCD4TestDate,CD4TestUnit,SurveyOrgan,SurveyName,fSurveyDate,Comments,HIVPatBelong,HIVTreatment,ViralloadTestResult,ViralloadTestDate,posmonCaseNo,posmonTestUnit)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryHIVFollowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHIVFollowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHIVFollowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHIVFollowExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2020-03-27
/// Description:  流感样标本登记表润乾打印query
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.RunQianPrint","QryERRepILI","1")      
Query QryERRepILI(aReportID As %String) As %Query(ROWSPEC = "aReportID:%String,ERReportNum:%String,ERRegNo:%String,ERPatName:%String,ERPatSex:%String,PatAge:%String,ERTelephone:%String,ERParent:%String,ERCurrProvince:%String,ERCurrCity:%String,ERCurrCounty:%String,ERCurrTown:%String,ERCurrVillage:%String,ERCurrAddress:%String,ERSpecimenType:%String,ERSpecimenClnArea:%String,ERSpecimenSource:%String,ERIncident:%String,SickDate:%String,AdmitDate:%String,ReportDate,AdmLocID:%String,LocDescStr:%String,ERDoctorName:%String,ERHospital:%String") [ SqlProc ]
{
}

ClassMethod QryERRepILIExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objRep
	Set objRep=##class(DHCMed.EPD.ERReportILI).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	
	Set ERReportNum = objRep.ERReportNum
	Set ERRegNo = objRep.ERRegNo 
	Set ERPatName = objRep.ERPatName
	Set ERPatSex = objRep.ERPatSex
	Set PatAge=""
	If (objRep.ERAge'="") {
		Set PatAge=objRep.ERAge_"岁"
	} ElseIf (objRep.ERAgeMonth'="") {
		Set PatAge=objRep.ERAgeMonth_"月"
	} ElseIf (objRep.ERAgeDay'="") {
		Set PatAge=objRep.ERAgeDay_"天"
	}
	Set ERTelephone = objRep.ERTelephone
	Set ERParent = objRep.ERParent
	Set ERCurrProvince = objRep.ERCurrProvince.ShortDesc
	Set ERCurrCity = objRep.ERCurrCity.ShortDesc
	Set ERCurrCounty = objRep.ERCurrCounty.ShortDesc
	Set ERCurrTown = objRep.ERCurrTown.ShortDesc
	Set ERCurrVillage = objRep.ERCurrVillage
	Set ERCurrAddress = objRep.ERCurrAddress
	Set ERSpecimenType= objRep.ERSpecimenType.Description
	Set ERSpecimenClnArea = objRep.ERSpecimenClnArea
	Set ERSpecimenSource = objRep.ERSpecimenSource.Description
	Set ERIncident = objRep.ERIncident
	Set SickDate=objRep.ERSickDate
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set AdmitDate=objRep.ERAdmitDate
	Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	Set ReportDate=objRep.ERReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set AdmLocID=objRep.ERAdmLoc
	set LocDescStr=$p($g(^CTLOC(+AdmLocID)),"^",2)
	set:$p(LocDescStr,"-",2)'="" LocDescStr=$p(LocDescStr,"-",2)
	Set ERDoctorName = objRep.ERDoctorName
	Set ERHospital = objRep.ERHospital
	
	Set Data=$lb(aReportID,ERReportNum,ERRegNo,ERPatName,ERPatSex,PatAge,ERTelephone,ERParent,ERCurrProvince,ERCurrCity,ERCurrCounty,ERCurrTown)
	Set Data=Data_$lb(ERCurrVillage,ERCurrAddress,ERSpecimenType,ERSpecimenClnArea,ERSpecimenSource,ERIncident,SickDate,AdmitDate,ReportDate,AdmLocID,LocDescStr,ERDoctorName,ERHospital)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryERRepILIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryERRepILIExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryERRepILIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryERRepILIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
