Import SQLUSER

Class DHCCL.Mobile.BI.BP.UserInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

ClassMethod LogOn(Param As %String = "") As %String
{
	// w ##class(DHCCL.Mobile.BI.HD.UserInfo).LogOn()
	i Param="" s Param="<Request><userName>159</userName><password>1</password></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","User.DHCCLMRequest")
    
	While reader.Next(.request,.sc)
	{
	   s userName=request.userName
	   s password=request.password
	}
	q:userName="" "用户名不能为空"
	q:password="" "密码不能为空"
	s password=$$ENCR^SSUTIL2(password)
	s rowId=""
	s userName=$$UPPER^SSUTIL4(userName)
	s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userName,rowId))
	s userObj=##class(User.SSUser).%OpenId(rowId)
	
	s res=""
	i (userObj.SSUSRPassword=password) d
	.;密码正确
	.d SetSession
	.s doctorInfo=##class(User.DHCCLMDoctorLoginInfo).%New()
	.s doctorInfo.name=userObj.SSUSRName
	.s doctorInfo.eMail=userObj.SSUSREMailName
	.s doctorInfo.userName=userName
	.s doctorInfo.department=userObj.SSUSRDefaultDeptDR.CTLOCDesc
	.s doctorInfo.jobTitle=userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc
	.S doctorInfo.userType="Doctor"
	.i userObj.SSUSRIsThisDoctor'="Y" d
	..S doctorInfo.userType="Nurse"
	.b
	.s Xml=""
	.i doctorInfo.XMLExportToString(.Xml,"LoginInfo")=1 d
	..s res=Xml
	e  d
	.;密码错误
	.s res="密码错误"
	.
	
	q res
SetSession
	i ##class(%Library.Device).GetType()'=1 d
	.s %session.Data("userName")=userName
	.s %session.Data("userRowId")=rowId
	.s ^tmpcldebug("logOn")=userName
}

ClassMethod GetBedInfo(Param As %String = "") As %String
{
	// w ##class(DHCCL.Mobile.BI.BP.UserInfo).GetBedInfo("2014-11-18")
	// Id,RegisterId,SchemeDetailId,EpisodeId,RegNo,PatName,PatGender,PatAge,PatDiagnosis,MedicareNo,BedId,BedDesc,ArrangeDate,ArrangeTime,DayPartCode,ArrangeType,Status,RegisterStatus,BPNum,StartWeight,SubtractiveWeight,EndWeight,IntakeAmount,PlanDewaterAmount,ReplenishWaterAmount,DewaterAmount,ResidualBloodAmount,TherapyDuration,FlushPipeNurseId,FlushPipeNurseDesc,PunctureNurseId,PunctureNurseDesc,CirculatingNurseId,CirculatingNurseDesc,JoinPipeNurseId,JoinPipeNurseDesc,CloseNurseId,CloseNurseDesc,VascularAccessSchemeId,EquipId,EquipDesc,DialysisMethodId,DialysisMethodDesc,SecondDialysisMethodId,SecondDialysisMethodDesc,CT,ACT,EquipRunModeId,Heparin,FirstHeparinAmount,Protamine,Na,K,Ca2,HCO3,Temperature,FilterReplaceMode,FilterReplaceAmount,EquipRunStatus,Grume,PipeGrume,AVFEffect,Dindle,JoinDirection,OutletEffect,OralHematin,InjectHematin,PatBPNo,StartDiastolicPressure,EndDiastolicPressure,StartSystolicPressure,EndSystolicPressure,StartHeartRate,EndHeartRate,StartSymptom,EndSymptom,UrineVolume,ClinicalEvaluationNote,IsolatedUltrafiltrationVolume,BFR,BFRNote,VascularAccessId,BodySiteId,AnticoagulantModeId,ReturnSalineAmount,BPSchemeAdjustment,PlanTherapyDuration,PlanFilterReplaceAmount,DFR,VascularAccessStatus,AllConsumable,Note,DiseaseTreatment,ArrangeEndDate,ArrangeEndTime,CreateUserId,CreateDate,CreateTime,DocOperateStatus,CheckDocId,CheckDocDesc,CheckDate,CheckTime,RecheckDocId,RecheckDocDesc,RecheckDate,RecheckTime,WardRoundDocId,WardRoundDocDesc,WardRoundDate,WardRoundTime,StartOperationNurseId,StartOperationNurseDesc,StartOperationDate,StartOperationTime,EndOperationNurseId,bpaEndOperationNurseDesc,EndOperationDate,EndOperationTime,CheckNurseId,CheckNurseDesc,NurseCheckDate,NurseCheckTime
	s date=Param
	s rset=##class(%ResultSet).%New("web.DHCBPArrange:FindBPArrange")
	s ret=""
	do rset.Execute(date)
	while (rset.Next()) {
	i ret="" d
	.s Id=rset.GetData("Id")
	.w Id,!
	.;s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	.;s ret="-"_arcimDesc_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
	e  s ret=ret_$c(1)_rset.GetData(1)_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
	}
	d rset.Close()
	q ret
}

/// 查询血透先项
/// eg. D ##class(%ResultSet).RunQuery("DHCCL.Mobile.BI.BP.UserInfo","FindOptions","BodySite")
Query FindOptions(type) As %Query(ROWSPEC = "id,code,desc") [ SqlProc ]
{
}

ClassMethod FindOptionsExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^tmpdebug("xxxxxxx")="FindOptions"_type
	If $g(ind)="" Set ind=1
	i type'="" d Find	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
Find
	s sub="" f  s sub=$O(^DHCCLComCode(type,sub)) q:sub=""  d
	.s id=sub
	.s item=$g(^DHCCLComCode(type,sub))
	.s code=$p(item,"^",1)
	.s desc=$p(item,"^",2)
	.d OutputRow
OutputRow           
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOptionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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

ClassMethod FindOptionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
