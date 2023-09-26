Class DHCMed.NINFService.Rep.InfUncount Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfUncount","QueryInfUncountInfo")
Query QueryInfUncountInfo() As %Query(ROWSPEC = "RepID:%String,EpisodeID:%String,AdmitDate:%String,DisDate:%String,PatientName:%String,ReportLoc:%String,DescStr:%String,ReportUser:%String,UserName:%String,ResumeText:%String,Active:%String,PapmiNo:%String,AdmInfo:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QueryInfUncountInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set RepID=""
	
	For {
		Set RepID=$o(^DHCMed.NINF.Rep.InfUncountD(RepID),-1)
		Quit:RepID=""
		
		Set obj=##class(DHCMed.NINF.Rep.InfUncount).GetObjById(RepID)
		Continue:'$IsObject(obj)
		
		Set EpisodeID=obj.EpisodeID
		Continue:EpisodeID=""
		Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(AdmObj)
		Set AdmitDate=AdmObj.AdmitDate
		Set DisDate=AdmObj.DisDate
		Set PatientID=AdmObj.PatientID
		Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	
		Set ReportLoc=obj.ReportLoc
		Set DescStr=""
		set:ReportLoc'="" DescStr=$p($g(^CTLOC(+ReportLoc)),"^",2)
		set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	
		Set ReportUser=obj.ReportUser
		Set UserName=""
		Set:ReportUser'="" UserName=$p($g(^SSU("SSUSR",ReportUser)),"^",2)
		
		Set ResumeText=obj.ResumeText
		Set Active=obj.Active
        Set ActiveDesc = $s(Active=1:"是",1:"否")  //add vy pylian 2015-06-19 111098 感染漏报录入-是否有效显示0或者1，应显示为是或者否
		Set Department=AdmObj.Department
			
		Set AdmInfo="入院日期："_AdmitDate_" 就诊科室："_Department_" 出院日期："_DisDate
		Set (EncryptLevel,PatLevel)=""
		Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
		Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
		Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
		
		Set Data=$lb(RepID,EpisodeID,AdmitDate,DisDate,PatientName,ReportLoc,DescStr,ReportUser,UserName,ResumeText,ActiveDesc,PapmiNo,AdmInfo,EncryptLevel,PatLevel)

		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryInfUncountInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfUncountInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryInfUncountInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfUncountInfoExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfUncount","QueryAdmInfoByPatNo",1)
Query QueryAdmInfoByPatNo(PatNo As %String) As %Query(ROWSPEC = "ind:%String,paadm:%String,AdmInfo:%String")
{
}

ClassMethod QueryAdmInfoByPatNoExecute(ByRef qHandle As %Binary, PatNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:PatNo="" $$$OK
	
	//^PAPERi("PAPMI_PatNo",
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set PatNo=$$RegNoCon(PatNo)
	
	Set papmi=""
	For {
		Set papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,papmi))
		Quit:papmi=""
		
		Continue:'$d(^PAPERdr(papmi))
		Continue:'$d(^PAPERdr(papmi,"ADM","I"))
		
		Set paadm=""
		For {
			Set paadm=$o(^PAPERdr(papmi,"ADM","I",paadm),-1)
			Quit:paadm=""
			
			Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
			Continue:'$IsObject(AdmObj)
			
			Set AdmInfo=$g(^PAADM(paadm))
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			
			Set AdmDate=AdmObj.AdmitDate
			Set Department=AdmObj.Department
			Set DisDate=AdmObj.DisDate
			
			Set Data=$lb(ind,paadm,"入院日期："_AdmDate_" 就诊科室："_Department_" 出院日期："_DisDate)

			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
			}
	}
	
	Quit $$$OK
	
RegNoCon(PAPMINo)
	n (PAPMINo)
	q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

ClassMethod QueryAdmInfoByPatNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmInfoByPatNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAdmInfoByPatNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmInfoByPatNoExecute ]
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
