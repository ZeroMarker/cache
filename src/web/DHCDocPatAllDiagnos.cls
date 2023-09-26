Class web.DHCDocPatAllDiagnos Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取患者全部诊断记录
/// 入参：PatientID 患者ID，diagCat诊断分类 ，AdmTypeStr 就诊类型
Query GetPatAllDiagnose(PatientID As %String, diagCat As %String, AdmTypeStr As %String, searchType As %String, searchDesc As %String, LogonHospDr As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "LastMRDIARowId:%String,GroupICDRowIDStr:%String,Desc:%String,LastDiagStatus:%String,FirstMRDate:%String,LastMRDate:%String,LastDoctDesc:%String,ICDCodeStr:%String,LastUpdateLoc:%String,DiagPALongDate:%String,RepeatNum:%String,DiagnosCatRowId:%String,DiagType:%String,SDSInfo:%String,PrefixDesc:%String,Note:%String")
{
}

ClassMethod GetPatAllDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAllDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPatAllDiagnos","GetPatAllDiagnose","1007","0^1","ALL","ALL","","")
ClassMethod GetPatAllDiagnoseExecute(ByRef qHandle As %Binary, PatientID As %String, diagCat As %String, AdmTypeStr As %String, searchType As %String, searchDesc As %String, LogonHospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tempqujina("GetPatAllDiagnose")=$Lb(PatientID,diagCat,AdmTypeStr,searchType,searchDesc,LogonHospDr)
	s searchDesc=$ZCVT(searchDesc,"U")
	k DiaList
	s Paadmtype=0 
	Set langid=..%LanguageID()
    s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	for{
		s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype))
		q:Paadmtype=""
		if (AdmTypeStr'="")&&(AdmTypeStr'="ALL")&&(AdmTypeStr'[Paadmtype){
			continue	
		}
    	s PaadmRowid=0
    	for{
	    	s PaadmRowid=$o(^PAPERdr(PatientID,"ADM",Paadmtype,PaadmRowid)) Q:PaadmRowid=""
	    	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowid)
 			continue:LogonHospDr'=AdmHospitalId
	    	s MradmRowid=$P(^PAADM(PaadmRowid),"^",61)
			s MrICDSub=0
			for{
				s MrICDSub=$o(^MR(MradmRowid,"DIA",MrICDSub)) Q:MrICDSub=""
				s str=$g(^MR(MradmRowid,"DIA",MrICDSub))
				continue:str=""
				s ICDRowid=$p(str,"^",1)
				s MainMRDIADr=$P(str,"^",15)
				continue:(MainMRDIADr'="")
				s MRDate=$p(str,"^",7)
				s MRTime=$p(str,"^",8)
				if (ICDRowid'="") {
					s ICDInfo=##Class(web.DHCDocDiagnosEntryV8).GetICDInfoByICDDr(ICDRowid)
					s DiagnosCatRowId=$p(ICDInfo,"^",3)
				}else{
					s MRDIAQuestionnaire=$p(str,"^",22)
					s DiagnosCatRowId=$case(MRDIAQuestionnaire,1:0,2:1,3:2,"":"")
				}
				continue:(diagCat'[DiagnosCatRowId)&&(diagCat'="")
				s MRDIARowId=MradmRowid_"||"_MrICDSub
				s GroupICDRowIDStr=##Class(web.DHCDocDiagnosEntryV8).GetGroupICDRowIDStr(MRDIARowId)
				continue:(GroupICDRowIDStr="")
				if $d(DiaList(GroupICDRowIDStr,MRDate,MRTime)) {
					s MRTime=MRTime_"-"_MradmRowid_"-"_MrICDSub
				}
		    	s DiaList(GroupICDRowIDStr,MRDate,MRTime)=MRDIARowId
			}
	    }
    }
    s GroupICDRowIDStr=0
    for {
	    s GroupICDRowIDStr=$O(DiaList(GroupICDRowIDStr)) Q:GroupICDRowIDStr=""
	    //获取重复记录最早的诊断日期、时间、诊断表ID
	    s FirstMRDate=$o(DiaList(GroupICDRowIDStr,0))
	    s FirstMRTime=$o(DiaList(GroupICDRowIDStr,FirstMRDate,0))
	    s FirstMRDIARowId=$g(DiaList(GroupICDRowIDStr,FirstMRDate,FirstMRTime))
	     //获取重复记录最新的诊断日期、时间、诊断表ID
	    s LastMRDate=$o(DiaList(GroupICDRowIDStr,""),-1)
	    s LastMRTime=$o(DiaList(GroupICDRowIDStr,LastMRDate,""),-1)
	    s LastMRDIARowId=$g(DiaList(GroupICDRowIDStr,LastMRDate,LastMRTime))
	    
	    s Desc="",ICDCodeStr="",ICDDr=""
		for i=1:1:$L(GroupICDRowIDStr,"!"){
			s ICDRowID=$P(GroupICDRowIDStr,"!",i)
			if $D(^MRC("ID",ICDRowID)){
				if (ICDDr="") s ICDDr=ICDRowID
				s ICDDesc=$p(^MRC("ID",ICDRowID),"^",2)
				s ICDCode=$p(^MRC("ID",ICDRowID),"^",4)
				if (ICDCodeStr="") s ICDCodeStr=ICDCode
				else  s ICDCodeStr=ICDCodeStr_","_ICDCode
			}else{
				if (ICDRowID["Desc:") s ICDDesc=$p(ICDRowID,"Desc:",2) //$TR(ICDRowID,"Desc:","") //$TR会把描述中含有s的字符替换为空
				else  s ICDDesc=ICDRowID
			}
		}
		s Desc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(LastMRDIARowId)
		s PrefixDesc=$p($G(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2),1)),"^",26)
		s DESSub=$G(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2),"DES",0))
		s Note=$CASE(+DESSub,0:"",:$G(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2),"DES",DESSub)))
		;结构化诊断信息返回
		s EpisodeID=$p($G(^MR(+LastMRDIARowId,"PRO",1)),"^",9)
		s ADMNo=$p(^PAADM(EpisodeID),"^",81)
		s SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,LastMRDIARowId)
	    if SDSInfo'=""{
		    s SDSRowId=$P(SDSInfo,"^",1)
		    s SDSTermDR=$P(SDSInfo,"^",2)
		    s SDSDisplayIDStr=$P(SDSInfo,"^",3)
		    s SDSDisplayName=$P(SDSInfo,"^",4)
			s SDSWordID=$P(SDSInfo,"^",8)
			s Supplement=$P(SDSInfo,"^",9)
	    	s SDSInfo=SDSRowId_"^"_SDSTermDR_"^"_SDSDisplayIDStr_"^"_SDSWordID_"^"_Supplement
	    }
		s Desc=##class(ext.util.String).EvalJSON(Desc) //诊断描述
		s MRDIADiagStatDR=$p($g(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2))),"^",9) 
		s LastDiagStatus=$p($g(^MRC("DSTAT",+MRDIADiagStatDR)),"^",2) //最新诊断状态
		s LastDiagStatus=##class(websys.Translation).Get("dhcdocpatalldiagnos.csp",LastDiagStatus)
		s FirstMRDate=..%ZD(FirstMRDate)
		s LastMRDate=..%ZD(LastMRDate)
		s doctorRowid=$p($g(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2))),"^",4) 
		s LastDoctDesc=""
		i doctorRowid'="" {
			s LastDoctDesc=$P($G(^CTPCP(doctorRowid,1)),"^",2) //最新诊断医生
			s LastDoctDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",LastDoctDesc,langid)
		}
		//最新诊断科室
		s LastUpdateLoc=""
		s LastUpdateLocDr=$p($g(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2),1)),"^",25)
		if (LastUpdateLocDr'="") {
			s LastUpdateLoc=$p($g(^CTLOC(LastUpdateLocDr)),"^",2)
			s LastUpdateLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LastUpdateLoc,langid)
		}
		s TYPMRCDiagTypDr=$p(^MR(+LastMRDIARowId,"DIA",$p(LastMRDIARowId,"||",2),"TYP",1),"^",1)
		s DiagType=$p(^MRC("DTYP",TYPMRCDiagTypDr),"^",2)
		s DiagType=##class(User.MRCDiagnosType).GetTranByDesc("DTYPDesc",DiagType,langid)
		s DiagPALongDate=..GetPALongTime(PatientID,ICDDr)
		s DiagPALongDate=##class(websys.Translation).Get("dhcdocpatalldiagnos.csp",DiagPALongDate)
		if (searchDesc'="") {
			continue:(searchType="ALL")&&($ZCVT(Desc,"U")'[searchDesc)&&($ZCVT(DiagType,"U")'[searchDesc)&&($ZCVT(LastUpdateLoc,"U")'[searchDesc)
			continue:(searchType="DiagDesc")&&($ZCVT(Desc,"U")'[searchDesc)
			continue:(searchType="DiagType")&&($ZCVT(DiagType,"U")'[searchDesc)
			continue:(searchType="DiagLoc")&&($ZCVT(LastUpdateLoc,"U")'[searchDesc)
		}
		s date=0,RepeatNum=0
		for {
		   s date=$O(DiaList(GroupICDRowIDStr,date)) Q:date=""
		   s time=""
		   for {
			   s time=$O(DiaList(GroupICDRowIDStr,date,time)) Q:time=""
			   s RepeatNum=RepeatNum+1
		   }
		}
		s MRDIAQuestionnaire=$p($g(^MR(+FirstMRDIARowId,"DIA",$p(FirstMRDIARowId,"||",2))),"^",22)
		s DiagnosCatRowId=$case(MRDIAQuestionnaire,1:0,2:1,3:2,"":"")
		d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(LastMRDIARowId,GroupICDRowIDStr,Desc,LastDiagStatus,FirstMRDate,LastMRDate,LastDoctDesc,ICDCodeStr,LastUpdateLoc,DiagPALongDate,RepeatNum,DiagnosCatRowId,DiagType,SDSInfo,PrefixDesc,Note)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetPatAllDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAllDiagnoseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			
	 Set AtEnd=1
	 Set Row=""
	}Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取长效诊断的起止日期
ClassMethod GetPALongTime(PatientID As %String, ICDDr As %String) As %String
{
	Q:ICDDr="" "非长效"
	s StartDate="",EndDate=""
	s PALongRowId=$o(^User.PALongICDI("LICDPatICDDRIndex",PatientID,ICDDr,""),-1)
	if (PALongRowId'="") {
		s StartDate=$lg(^User.PALongICDD(PALongRowId),5)
		if (StartDate'="") {
			s StartDate=..%ZD(StartDate)
		}
		s EndDate=$lg(^User.PALongICDD(PALongRowId),13)
		if (EndDate'="") {
			s EndDate=..%ZD(EndDate)
		}
	}else{
		Q "非长效"
	}
	Q StartDate_" / "_EndDate
}

/// 获取重复诊断列表
/// 入参：PatientID 患者ID，diagCat诊断分类 ，AdmTypeStr 就诊类型
Query GetPatRepeatDiag(PatientID As %String, diagCat As %String, AdmTypeStr As %String, paraGroupICDRowIDStr As %String, LogonHospDr As %String = "", DiagRowids = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "MRDIARowId:%String,PAAdmRowId:%String,PAAdmType:%String,MRDIAMainDiagFlag:%String,DiagStat:%String,MRDiagDate:%String,SSUseName:%String,CTCPTType:%String,DiagLoc:%String,PAAdmDate:%String,PAAdmLoc:%String,PAAdmHosp:%String,Ord:%String,HasEMRRecord:%String")
{
}

ClassMethod GetPatRepeatDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatRepeatDiagExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPatAllDiagnos","GetPatRepeatDiag","1880","","ALL","","","5554||1")
ClassMethod GetPatRepeatDiagExecute(ByRef qHandle As %Binary, PatientID As %String, diagCat As %String, AdmTypeStr As %String, paraGroupICDRowIDStr As %String, LogonHospDr As %String = "", DiagRowids = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tempqujian("GetPatRepeatDiag")=$lb(PatientID, diagCat, AdmTypeStr, paraGroupICDRowIDStr , LogonHospDr , DiagRowids)
	Set langid=..%LanguageID()
	if DiagRowids'=""{
		for i=1:1:$L(DiagRowids,"^"){
			s MRDIARowId=$P(DiagRowids,"^",i)
			s AdmID=$P(^MR(+MRDIARowId,"PRO",1),"^",9)
			s Paadmtype=$P(^PAADM(AdmID),"^",2)
			continue:(AdmTypeStr'="")&&(AdmTypeStr'="ALL")&&(AdmTypeStr'[Paadmtype)
			d OneDiagnos
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	k DiaList
	s Paadmtype=0 
	for{
		s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype))
		q:Paadmtype=""
		if (AdmTypeStr'="")&&(AdmTypeStr'="ALL")&&(AdmTypeStr'[Paadmtype){
			continue	
		}
    	s PaadmRowid=0
    	for{
	    	s PaadmRowid=$o(^PAPERdr(PatientID,"ADM",Paadmtype,PaadmRowid)) Q:PaadmRowid=""
	    	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowid)
 			continue:LogonHospDr'=AdmHospitalId
	    	s MradmRowid=$P(^PAADM(PaadmRowid),"^",61)
			s MrICDSub=0
			for{
				s MrICDSub=$o(^MR(MradmRowid,"DIA",MrICDSub)) Q:MrICDSub=""
				s str=$g(^MR(MradmRowid,"DIA",MrICDSub))
				continue:str=""
				s ICDRowid=$p(str,"^",1)
				s MainMRDIADr=$P(str,"^",15)
				continue:(MainMRDIADr'="")
				s MRDate=$p(str,"^",7)
				s MRTime=$p(str,"^",8)
				if (ICDRowid'="") {
					s ICDInfo=##Class(web.DHCDocDiagnosEntryV8).GetICDInfoByICDDr(ICDRowid)
					s DiagnosCatRowId=$p(ICDInfo,"^",3)
				}else{
					s MRDIAQuestionnaire=$p(str,"^",22)
					s DiagnosCatRowId=$case(MRDIAQuestionnaire,1:0,2:1,3:2,"":"")
				}
				continue:(diagCat'[DiagnosCatRowId)&&(diagCat'="")
				s MRDIARowId=MradmRowid_"||"_MrICDSub
				s GroupICDRowIDStr=##Class(web.DHCDocDiagnosEntryV8).GetGroupICDRowIDStr(MRDIARowId)
				continue:(GroupICDRowIDStr="")||(GroupICDRowIDStr'=paraGroupICDRowIDStr)
		    	s DiaList(MRDate,MRTime,MRDIARowId)=GroupICDRowIDStr
			}
	    }
    }
    s MRDate=0
    for {
	    s MRDate=$o(DiaList(MRDate)) Q:MRDate=""
	    s MRTime=0
	    for {
		    s MRTime=$o(DiaList(MRDate,MRTime)) Q:MRTime=""
		    s MRDIARowId=0
		    for {
			    s MRDIARowId=$o(DiaList(MRDate,MRTime,MRDIARowId)) Q:MRDIARowId=""
			    d OneDiagnos
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneDiagnos
	s PAAdmRowId=$p(^MR(+MRDIARowId,"PRO",1),"^",9)
    s PAAdmType=$p(^PAADM(PAAdmRowId),"^",2) //就诊类型
    s PAAdmType=$case(PAAdmType,"O":"门诊","I":"住院","E":"急诊","H":"体检")
    s PAAdmType=##class(websys.Translation).Get("dhcdocpatrepeatdiag.csp",PAAdmType)
    S PAAdmDate=$p(^PAADM(PAAdmRowId),"^",6) //就诊日期
    s PAAdmDate=..%ZD(PAAdmDate)
    s PAAdmLocDr=$p(^PAADM(PAAdmRowId),"^",4) //就诊科室
    s PAAdmLoc=$p(^CTLOC(PAAdmLocDr),"^",2)
    s PAAdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmLoc,langid)
    s PAAdmHospDr=$p(^CTLOC(PAAdmLocDr),"^",22)
    s PAAdmHosp=$P(^CT("HOSP",PAAdmHospDr),"^",2)
    Set PAAdmHosp= ##class(User.CTHospital).GetTranByDesc("HOSPDesc",PAAdmHosp,langid)
    s MRDIAMainDiagFlag=$p($G(^MR(+MRDIARowId,"DIA",$p(MRDIARowId,"||",2),1)),"^",20)
    s MRDIAMainDiagFlag=$case(MRDIAMainDiagFlag,"Y":"是",:"否") //主诊断标识
    s MRDIAMainDiagFlag=##class(websys.Translation).Get("dhcdocpatrepeatdiag.csp",MRDIAMainDiagFlag)
    s DiagStat=""
    s DiagStatDr=$p($g(^MR($P(MRDIARowId,"||",1),"DIA",$P(MRDIARowId,"||",2))),"^",9)
    if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2) //诊断状态
    s DiagStat =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",DiagStat,langid)
    s MRDate1=$p($g(^MR($P(MRDIARowId,"||",1),"DIA",$P(MRDIARowId,"||",2))),"^",7)
    s MRDiagDate=..%ZD(MRDate1) //诊断日期
    s MRDidUserCreatedDR=$p($g(^MR($P(MRDIARowId,"||",1),"DIA",$P(MRDIARowId,"||",2),1)),"^",18)
    s SSUseName=$p(^SSU("SSUSR",MRDidUserCreatedDR),"^",2)
    s SSUseName= ##class(User.SSUser).GetTranByDesc("SSUSRName",SSUseName,langid)
    s MRDIADocCodeDR=$p($g(^MR($P(MRDIARowId,"||",1),"DIA",$P(MRDIARowId,"||",2))),"^",4)
    s CTCPTType="" //诊断人类型
    if (MRDIADocCodeDR'="") {
	    s CTPCPCarPrvTpDR=$p($g(^CTPCP(MRDIADocCodeDR,1)),"^",4)
	    if (CTPCPCarPrvTpDR'="") {
	    	s CTCPTType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2)
	    	//s CTCPTType=$case(CTCPTInternalType,"DOCTOR":"医师","NURSE":"护师","Pharmacist":"药师","Technician":"技师",:"")
			s CTCPTType=##class(User.CTCarPrvTp).GetTranByDesc("CTCPTDesc",CTCPTType,langid)
	    }
	}
	s DiagLoc="" //诊断科室
	s MRDIAUpdateLocDr=$p($g(^MR($P(MRDIARowId,"||",1),"DIA",$P(MRDIARowId,"||",2),1)),"^",24)
	if (MRDIAUpdateLocDr'="") {
		s DiagLoc=$p(^CTLOC(MRDIAUpdateLocDr),"^",2)
		s DiagLoc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DiagLoc,langid)
	}
	//医嘱 病历
	s Ord=$o(^OEORD(0,"Adm",PAAdmRowId,""))
	s HasEMRRecord=##Class(EMRservice.BIEMRService).HasRecord(PAAdmRowId) // 是否写病历 1 写, 0 未写, "" 出错
	s HasEMRRecord=##class(websys.Translation).Get("dhcdocpatrepeatdiag.csp",HasEMRRecord)
	d OutputRow2
	Q
OutputRow2
	set Data=$lb(MRDIARowId,PAAdmRowId,PAAdmType,MRDIAMainDiagFlag,DiagStat,MRDiagDate,SSUseName,CTCPTType,DiagLoc,PAAdmDate,PAAdmLoc,PAAdmHosp,Ord,HasEMRRecord)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetPatRepeatDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatRepeatDiagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			
	 Set AtEnd=1
	 Set Row=""
	}Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
