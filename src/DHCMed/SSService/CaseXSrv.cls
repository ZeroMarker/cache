/// Creator			:刘贞贺
/// CreateDate		:2020-07-07
Class DHCMed.SSService.CaseXSrv Extends %RegisteredObject
{

/// Creator			:刘贞贺
/// CreateDate		:2020-07-07
/// Description		:标记/排除操作
/// w ##class(DHCMed.SSService.CaseXSrv).SetCXStatus(1,0,"测试","","")
ClassMethod SetCXStatus(aCasesXID As %String, aStatus As %String, aOpinion As %String = "", aLocID As %String = "", aUserID As %String = "")
{
	Quit:(aCasesXID="")||(aStatus="") ""
	Set objCase=##class(DHCMed.SS.CasesX).%OpenId(aCasesXID)
	Set objCase.CXStatus=aStatus
	Set objCase.CXOpinion=aOpinion
	Set objCase.CXEvalDate=+$H
	Set objCase.CXEvalTime=+$P($h,",",2)
	Set objCase.CXEvalLoc=aLocID
	Set objCase.CXEvalUser=aUserID
	Set sc=objCase.%Save()
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
		Set return=-1
	}else{
		Set return=objCase.%Id()
	}
	Do objCase.%Close()
	Quit return
}

/// Creator			:刘贞贺
/// CreateDate		:2020-07-07
/// Description		:诊断病例查询
/// Table			:User.PAAdm、User.PAPatMas、
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.CaseXSrv","QryPatInfo","CD","","2018-06-04","2020-07-20","","","")
Query QryPatInfo(aProductCode As %String, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aAdmType As %String, aIsRep As %String, aStatus As %String = "-1") As %Query(ROWSPEC = "ind:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,Address:%String,PersonID:%String,Tel:%String,LocalFlagDesc:%String,AdmTypeDesc:%String,DiagDesc:%String,AdmDoc:%String,AdmDate:%String,AdmLoc:%String,AdmWard:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,CasesXID:%String,ActDiagnosID:%String,ActDiagnosDesc:%String,StatusDesc:%String,RepTypeCode:%String,RepTypeDesc:%String,PatientID:%String,EpisodeID:%String,RepList:%String,Opinion:%String") [ SqlProc ]
{
}

ClassMethod QryPatInfoExecute(ByRef qHandle As %Binary, aProductCode As %String, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLoc As %String, aAdmType As %String, aIsRep As %String, aStatus As %String = "-1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^TMPLH=$lb(aProductCode ,aHospIDs , aDateFrom , aDateTo , aLoc, aAdmType , aIsRep)
	Quit:aProductCode=""
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK 
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set lstStatus=$LISTFROMSTRING(aStatus,",")
 	Set xStatus=""
 	for {
		Set xStatus=$o(^MA.SS.CasesXI("IndexStatusDate",aProductCode,xStatus))
		Quit:xStatus=""
		//w xStatus
		Continue:(aStatus'="")&&($lf(lstStatus,xStatus)<1)
		Set StatusDesc=$s(xStatus="-1":"未处置",xStatus="1":"标记上报",xStatus="0":"排除",1:"")
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^MA.SS.CasesXI("IndexStatusDate",aProductCode,xStatus,xDate))
			Quit:xDate=""
			Quit:(xDate>aDateTo)||(xDate<aDateFrom)
			Set xCaseID=""
			For {
				Set xCaseID=$o(^MA.SS.CasesXI("IndexStatusDate",aProductCode,xStatus,xDate,xCaseID))
				Quit:xCaseID=""
				Set CaseInfo=$g(^MA.SS.CasesXD(xCaseID))
				Continue:CaseInfo=""
				Set IsActive=$lg(CaseInfo,16)           //有效性应默认为1
				Continue:IsActive'=1
				Set ActDiagnosID=$lg(CaseInfo,7)       //疾病ID
				Set objDisease=##class(DHCMed.SS.Disease).GetObjById(ActDiagnosID)
				Continue:'$IsObject(objDisease)
				Continue:objDisease.IDIsActive'=1
				Set ActDiagnosDesc=objDisease.IDDesc
				Set ActDiagnosCode=objDisease.IDCode
				Set RepTypeCode="",RepTypeDesc=""
				if $IsObject(objDisease.IDCateDr) {
					Set RepTypeCode=objDisease.IDCateDr.Code
					Set RepTypeDesc=objDisease.IDCateDr.Description
				}
				
				Set EpisodeID=$lg(CaseInfo,3) 
				Continue:EpisodeID=""
				Set AdmInfo=$g(^PAADM(EpisodeID))
				Continue:AdmInfo=""
				
				Set Status=$p(AdmInfo,"^",20)
				Continue:Status="C"
				Set AdmLocID=$p(AdmInfo,"^",4)
				Set AdmWardID=$p($g(^PAWARD(+$p(AdmInfo,"^",70))),"^",5) 
				Continue:(aLoc'="")&&((aLoc'=AdmLocID)&&(aLoc'=AdmWardID))
				Set HospID=$p(^CTLOC(AdmLocID),"^",22)
				Continue:(aHospIDs'="")&(aHospIDs'[HospID)
				Set AdmType=$p(AdmInfo,"^",2)
				Continue:(aAdmType'="")&&(aAdmType'[AdmType)
				
				Set MRAdm=+$p(AdmInfo,"^",61)
				Set AdmTypeDesc=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"其他")
				
				Do BuildData
				}
		}
	}
	Quit $$$OK
BuildData

	//就诊信息
	Set AdmDocDr=$p(AdmInfo,"^",9)
	Set AdmDoc=""
	If (AdmDocDr'=""){
		Set AdmDocID=$o(^SSU("SSUSR",0,"CTPCP",AdmDocDr,""))
		Set:AdmDocID'="" AdmDoc=$p(^SSU("SSUSR",AdmDocID),"^",2)
	}
	
	Set AdmDate=$p(AdmInfo,"^",6)
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	
	Set AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
    Set AdmWard=$p($g(^PAWARD(+$p(AdmInfo,"^",70))),"^",2)
    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	//患者基本信息
	Set PatientID=$p(AdmInfo,"^",1)
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Set PatName=objPat.PatientName
	Set PapmiNo=objPat.PapmiNo
	Set Sex=objPat.Sex
	
	Set AgeYear=objPat.Age
	Set:+AgeYear>0 AgeYear=AgeYear_"岁"
	Set AgeMonth=objPat.AgeMonth
	Set:+AgeMonth>0 AgeMonth=AgeMonth_"月"
	Set AgeDay=objPat.AgeDay
	Set:+AgeDay>0 AgeDay=AgeDay_"天"
	If (AgeYear>0)&(AgeMonth'=0){
		Set Age=AgeYear_AgeMonth
	}elseIf (AgeMonth>0)&(AgeDay'=0){
		Set Age=AgeMonth_AgeDay
	}else{
		Set Age=AgeYear
	}
	Set Tel=objPat.Telephone
	Set Address=objPat.Address
	Set PersonID=objPat.PersonalID
	
	//本地或者外地
	Set LocalFlagDr=""
	Set LocalFlagDesc="本市"
	Set DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PatientID,""))
	//"&"改成"&&"，否则DHCPersonDr为空时报错
	Set:(DHCPersonDr'="")&&($d(^DHCPERSON(DHCPersonDr))) LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
	Set:LocalFlagDr=2 LocalFlagDesc="外埠"
	
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)        //住院时间
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set:AdmitDate'="" AdmitDate=$ZD(AdmitDate,3) 
	Set AdmitTime=$p(AdmDateTime,"^",2)
	Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)   //出院时间
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
	Set:DisDate'="" DisDate=$ZD(DisDate,3)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If (aProductCode="CD"){
	    Set RepList=..GetAllAdmInfo(MRAdm,RepTypeCode)
    }elseif(aProductCode="FBD"){
	    Set RepList=..GetFBDRepInfo(MRAdm)
    
    }
	Set Opinion=$lg(CaseInfo,11)  
	Set Data=$lb(ind,PapmiNo,PatName,Sex,Age,Address,PersonID,Tel,LocalFlagDesc)
	Set Data=Data_$lb(AdmTypeDesc,DiagDesc,AdmDoc,AdmDate,AdmLoc,AdmWard,AdmitDate,AdmitTime,DisDate,DisTime)
	Set Data=Data_$lb(xCaseID,ActDiagnosID,ActDiagnosDesc,StatusDesc,RepTypeCode,RepTypeDesc,PatientID,MRAdm,RepList,Opinion)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatInfoExecute ]
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

/// w ##class(DHCMed.SSService.CaseXSrv).GetAllAdmInfo(358,"FZYCO")
ClassMethod GetAllAdmInfo(aEpisodeID As %String, aRepType As %String) As %String
{
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" 
	Set AdmType="",return=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Set CDAdmType=##class(DHCMed.SS.Config).GetValueByKeyHosp("CDAdmType")
		Quit:AdmType=""
		Continue:(CDAdmType'="")&&(CDAdmType'[AdmType)
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C"  
			Set RepList=..GetRepInfo(Paadm,aRepType)
			Set:RepList'="" return=return_"^"_RepList
			
		}
	}
	Set:return'="" return=$e(return,2,*)
	Quit return
}

/// 跟据就诊号获取所有慢病相关报卡(历史报卡记录)
/// w ##class(DHCMed.SSService.CaseXSrv).GetRepInfo(353,"ZLK")
ClassMethod GetRepInfo(aEpisodeID As %String, aRepType As %String) As %String
{
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_aEpisodeID,xRepID))
		Quit:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Set ReportDate=objRep.CRReportDate
		Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set RepTypeCode=objRep.CRReportType.CRFCode
		Set RepTypeDesc=objRep.CRReportType.CRFDesc
		Set ReportLocID=objRep.CRReportLoc
		set LocDescStr=$p($g(^CTLOC(+ReportLocID)),"^",2)
		set:$p(LocDescStr,"-",2)'="" LocDescStr=$p(LocDescStr,"-",2)
		Continue:(aRepType'="")&&(aRepType'=RepTypeCode)
		Set ReportStatus=objRep.CRReportStatus.Description
		continue:(ReportStatus="删除")||(ReportStatus="作废")
		Set return=return_"^"_objRep.%Id()_"||"_RepTypeDesc_"||"_ReportDate_"||"_objRep.CRReportUser_"||"_LocDescStr_"||"_ReportStatus
	}
	
	Set:return'="" return=$e(return,2,*)
	Quit return
}

/// 跟据就诊号获取所有食源性疾病相关报卡(历史报卡记录)
/// w ##class(DHCMed.SSService.CaseXSrv).GetFBDRepInfo("19")
ClassMethod GetFBDRepInfo(aEpisodeID As %String) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set DiagnosList=""
	Set xID=""
	For {
		Set xID=$o(^DHCMed.FBD.ReportI("IndexEpisodeID"," "_$ZCVT(aEpisodeID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.FBD.Report).GetObjById(xID)
		Continue:'$IsObject(objReport)
		
		Set (StatusID,StatusCode,StatusDesc)=""
		Set StatusDr=objReport.FRStatusDr
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
		}
		Continue:StatusCode="4" //草稿状态报告无效
		Continue:StatusCode="5" //删除状态报告无效
		Set (DiseaseID,DiseaseDesc)=""
		Set DiseaseDr=objReport.FRDiseaseDr
		If $IsObject(DiseaseDr) {
			Set DiseaseID=DiseaseDr.%Id()
			Set DiseaseDesc=DiseaseDr.IDDesc
		}
		Set FRReportDate=objReport.FRReportDate
		Set:FRReportDate'="" FRReportDate=$zd(FRReportDate,3)
		Set ReportLocID=objReport.FRReportLoc
		Set ReportLocDesc=$p($g(^CTLOC(+ReportLocID)),"^",2)
		Set:$p(ReportLocDesc,"-",2)'="" ReportLocDesc=$p(ReportLocDesc,"-",2)
		Continue:$listfind(DiagnosList,DiseaseID)>0   //重复报卡过滤
		Set return=return_"^"_objReport.%Id()_"||食源性疾病||"_FRReportDate_"||"_objReport.FRReportUser_"||"_ReportLocDesc_"||"_StatusDesc
		
	}
	Set:return'="" return=$e(return,2,*)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-09-06
/// Description:  根据筛查日志查询筛查明细
/// Table：       DHCMed.SS.CasesX、DHCMed.SS.CasesXDtl
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.CaseXSrv","QryCasesXDtl","1")
Query QryCasesXDtl(aCasesXID As %String) As %Query(ROWSPEC = "CasesXID:%String,SubID:%String,CasesXDtlID:%String,ScreenID:%String,Type:%String,TypeDesc:%String,DContent:%String,DHappenDate:%String,DHappenTime:%String,DActUser:%String,ContDesc:%String")
{
}

ClassMethod QryCasesXDtlExecute(ByRef qHandle As %Binary, aCasesXID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aCasesXID="") $$$OK
  
     Set xSubID=""
 	 For {
		Set xSubID=$o(^MA.SS.CasesXD(aCasesXID,"Dtl",xSubID))
		Quit:xSubID=""
 		Set DtlID = aCasesXID_"||"_xSubID
		Set objDtl=##class(DHCMed.SS.CasesXDtl).GetObjById(DtlID)
		Continue:'$IsObject(objDtl)
		
		Set IsActive=objDtl.CXDIsActive
		Continue:IsActive'=1

	    Set Type = objDtl.CXDScreenType
	    Set TypeDesc=$s(Type="K":"Key诊断关键词",1:"其它")   
	 	
		Set DContent=objDtl.CXDContent
        Set ContDesc = $p(DContent,":",1)
        Set Description = $replace(DContent,(ContDesc_":")," ")
        Set Desc1 = $p(Description,"#",1)
	    Set Desc2 = $p(Description,"#",2)
	    Set Desc3 = $p(Description,"#",3)
	    Set Desc4 = $p(Description,"#",4)
	    Set Desc5 = $p(Description,"#",5)
	    If (ContDesc="MRICD") {
		    Set ContDesc=" 诊断ID:"_" "_Desc1_" ICD编码:"_" "_Desc2_" 诊断名称:"_" "_Desc3 
	    }
		Set DHappenDate=objDtl.CXDHappenDate
		Set:DHappenDate'="" DHappenDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DHappenDate)
		Set DHappenTime=objDtl.CXDHappenTime
		Set:DHappenTime'="" DHappenTime=$zt(DHappenTime,1)
		Set DActUser=objDtl.CXDActUser
		
		Set Data=$lb(aCasesXID,xSubID,DtlID,ScreenID,Type,TypeDesc,DContent,DHappenDate,DHappenTime,DActUser,ContDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCasesXDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
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
