/// 名称: DHCMed.EPDService.PatInfoSrv
/// 描述: 传染病查询患者信息
/// 编写者: chenrui
/// 编写日期: 2022-07-08
Class DHCMed.EPDService.PatInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2022-07-08
/// Description:  MED下查询某段时间类的所有患者
/// Table：       
/// Input:        HIS就诊号
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.PatInfoSrv","QryPatByDate","2,3","","1","2019-01-01","2019-03-01","","","")
Query QryPatByDate(aHospID As %String, aLocID As %String = "", aDateType As %String, aDateFrom As %String, aDateTo As %String, aPatName As %String = "", aMrNo As %String = "", aPampiNo As %String = "", aRepPlace As %String = "") As %Query(ROWSPEC = "RowID:%String,PatientID:%String,AdmType:%String,PapmiNo:%String,LocDesc:%String,PatName:%String,PatSex:%String,PatAge:%String,DiagDesc:%String,IsReAdmDesc:%String,AdmDoc:%String,Bed:%String,AdmDate:%String,DischDate:%String,Address:%String,IDNumber:%String,Telephone:%String,IsWoBorn:%String,IsReportEPD:%String,EPDRepInfo:%String,MrNo") [ SqlProc ]
{
}

ClassMethod QryPatByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String = "", aDateType As %String, aDateFrom As %String, aDateTo As %String, aPatName As %String = "", aMrNo As %String = "", aPampiNo As %String = "", aRepPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	// 就诊日期
 	if (aDateType="1"){
	 	For xDate=aDateFrom:1:aDateTo{
	 		Set RowID =""
	 		For{
			 	Set RowID = $o(^PAADMi("AdmDateCurr",xDate,RowID))
			 	Quit:RowID=""
			 	Do BuildDate(RowID)
		 	}
		}
	}
	// 出院日期
	elseif(aDateType="2"){
	 	For xDate=aDateFrom:1:aDateTo{
		 	Set RowID =""
		 	For{
			 	Set RowID = $o(^PAADMi("DischDate",xDate,RowID))
			 	Quit:RowID=""
			 	Do BuildDate(RowID)
			}
		}
	}
 	
	Quit $$$OK

BuildDate(aEpisodeID)
	
	Set PaadmInfo	= $g(^PAADM(+aEpisodeID))								// 就诊信息	
 	Set PatientID	= $p($g(^PAADM(+aEpisodeID)),"^",1)						// 病人ID
	Set AdmType 	= $p($g(^PAADM(+aEpisodeID)),"^",2)						// 就诊类型
	Set:aRepPlace="ALL" aRepPlace=""
	Quit:((aRepPlace'="")&&(aRepPlace'=AdmType))
 	Set AdmType		= $s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",AdmType="H":"体检",1:"其他")
	Set PapmiNo		= $p(^PAPER(PatientID,"PAT",1),"^",1)					// 登记号
	Quit:((aPampiNo'="")&&(aPampiNo'=PapmiNo))
	Set MrNo		= ##class(DHCMed.Base.PatientAdm).GetMrNoByAdm(aEpisodeID)	// 病案号
	Quit:((aMrNo'="")&&(aMrNo'=MrNo))
	Set AdmLocID	= +$p(PaadmInfo,"^",4)									// 科室ID
	Quit:((aLocID'="")&&(AdmLocID'=aLocID))						// 科室选择不为空时，过滤掉非选中科室
	set LocDesc		= $p($g(^CTLOC(+AdmLocID)),"^",2)						// 就诊科室描述
	set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
 	Set HospID=$p($g(^CTLOC(AdmLocID)),"^",22)
	Quit:(aHospID'="")&&((","_aHospID_",")'[(","_HospID_","))				// 过滤院区
	Set PatName 	= $p($g(^PAPER(PatientID,"ALL")),"^",1)					// 姓名
	Quit:((aPatName'="")&&(PatName'[aPatName))								// 过滤患者姓名
	Set PatSex		= $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)	// 性别
	Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"","","")	//返回值为“*岁*月*天”
	Set MRADMDR		= $p($g(^PAADM(+aEpisodeID)),"^",61)							// 诊断ID
	Quit:MRADMDR=""
	Set DiagSub=0
	Set DiagDesc=""
	For {
		Set DiagSub=$o(^MR(MRADMDR,"DIA",DiagSub))
		Quit:DiagSub=""
		Set tmpDignos = $g(^MR(MRADMDR,"DIA",DiagSub))
		Set ICDID	 = $p(tmpDignos,"^",1)
		Continue:ICDID=""
		Set tmpICD  = $g(^MRC("ID",ICDID))
		Continue:$p(^MRC("ID",ICDID),"^",15)="Y"  							// 过滤中医诊断
		Set ICD10   = $p(tmpICD,"^",1)
		Set ICDDesc = $p(tmpICD,"^",2)
		Set DiagDesc = DiagDesc_","_ICDDesc
	}
	Set:DiagDesc'="" DiagDesc = $e(DiagDesc,2,*)
	Set AdmReadm		= $p($g(^PAADM(aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	Set IsReAdmDesc		= $s(AdmReadm="A":"初诊",AdmReadm="R":"复诊")
	Set AdmDoc		= $p($g(^CTPCP(+$p(PaadmInfo,"^",9),1)),"^",2)			// 就诊医生
	Set Bed			= $p($g(^PAWARD(+$p(PaadmInfo,"^",73),"BED",+$p($p(PaadmInfo,"^",73),"||",2))),"^",1)		// 床号
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)	// 就诊日期
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate) 
	Set AdmitTime=$p(AdmDateTime,"^",2)
	Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	Set AdmDate	= AdmitDate_" "_AdmitTime
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)	// 出院日期
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
	Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DisDate)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
	Set DischDate	= DisDate_" "_DisTime
	Set Address		= ##class(DHCMed.Base.Patient).xGetHomeAddress(PatientID)		// 现住址
	Set IDNumber	= $p($g(^PAPER(PatientID,"PAT",3)),"^",6)						// 证件号
	Set Telephone	= $p($g(^PAPER(PatientID,"PER",1)),"^",11)						// 联系电话
	Set IsWoBorn	= ..IsWoburn(PatientID)											// 是否本市
	Set IsReportEPD = ..IsReportEPD(aEpisodeID)										// 是否上报传染病
	Set EPDRepInfo  = ..GetEPDInfo(aEpisodeID)										// 传染病信息
	Set Data = $lb(aEpisodeID,PatientID,AdmType,PapmiNo,LocDesc,PatName,PatSex,PatAge,DiagDesc,IsReAdmDesc,AdmDoc,Bed,AdmDate,DischDate,Address,IDNumber,Telephone,IsWoBorn,IsReportEPD,EPDRepInfo,MrNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryPatByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPatByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatByDateExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2022-07-11
/// Description:  判断患者是否是本地/外地
/// Table：       DHCMed.EPDService.PatInfoSrv
/// Return：      1:外地    2：本地   ""
/// w ##class(DHCMed.EPDService.PatInfoSrv).IsWoburn("")
ClassMethod IsWoburn(aPatientID As %String) As %String
{
	New (aPatientID)
	Set return = 0
	Quit:aPatientID="" return
	//本地或者外地
	Set LocalFlagDr=""
	Set LocalFlagDesc="本市"
	Set DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",aPatientID,""))
	//"&"改成"&&"，否则DHCPersonDr为空时报错
	Set:(DHCPersonDr'="")&&($d(^DHCPERSON(DHCPersonDr))) LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
	Set:LocalFlagDr=2 LocalFlagDesc="外埠"
	Set:LocalFlagDr="" LocalFlagDesc=""
	
	Set return		= LocalFlagDesc
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-11
/// Description:  是否上报传染病
/// Table：       DHCMed.EPDService.PatInfoSrv
/// Return：      
/// w ##class(DHCMed.EPDService.PatInfoSrv).IsReportEPD("")
ClassMethod IsReportEPD(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	Set return =0
	Quit:aEpisodeID="" return
	if ($d(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID))){
		Set return =1
	}
	Set return		= $s(return="1":"是",return="0":"否")	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-11
/// Description:  获取传染病报告信息（诊断，报告日期）
/// Table：       DHCMed.EPDService.PatInfoSrv
/// Return：      
/// w ##class(DHCMed.EPDService.PatInfoSrv).GetEPDInfo(184)
ClassMethod GetEPDInfo(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	Set return =""
	Quit:aEpisodeID="" return
	Set xRepID = ""
	Set (MIFDisease,RepDate) = ""
	For{
		Set xRepID = $o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID))
		Quit:xRepID=""
		Set EPDInfo 	= ^DHCMed.EPD("EPD",xRepID)
		Set MEPDICDDR 	= $p(EPDInfo,"^",5)
		Set MIFDisease 	= $p(^DHCMed.EPDC("IF",MEPDICDDR),"^",2)
		Set RepDate	  	= $p(EPDInfo,"^",17)
		Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate) 
		Set return 	  = return_","_MIFDisease_"^"_RepDate
	}
	Set:return'="" return = $e(return,2,*)
	Quit return
}

}
