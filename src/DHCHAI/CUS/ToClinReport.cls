/// 名称: DHCHAI.CUS.ToClinReport
/// 描述: HIS临床报告个性化服务
/// 编写者：zhufei
/// 编写日期: 2018-01-11
Class DHCHAI.CUS.ToClinReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 通过HIS就诊号取HAI就诊
/// w ##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(79)
ClassMethod GetEpisodeDr(aEpisodeID As %String, aSyncFlag As %String = 1) As %String
{
	New (aEpisodeID,aSyncFlag)
	Set return=""
	Quit:aEpisodeID="" return
	
	//根据医院对照取HIS系统代码(HISCode)
	Set HISCode=""
	Set XLocID=$p($g(^PAADM(aEpisodeID)),"^",4) //就诊科室
	Quit:XLocID="" return
	Set XHospID=$p($g(^CTLOC(+XLocID)),"^",22)
	Set:XHospID="" XHospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set objHospMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",XHospID)
	If $IsObject(objHospMap){
		Set objHosp=objHospMap.BTMapHospDr
		Set:$IsObject(objHosp) HISCode=$p(objHosp.BTXCode,"||",1)
	}
	Quit:HISCode="" return
	
	Set EpisodeIDX=HISCode_"||"_aEpisodeID
	Set objEpisodeDr=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	If $IsObject(objEpisodeDr){
		Set return=objEpisodeDr.%Id()
	} Else {
		If aSyncFlag>0 {
			Set flg=##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID(HISCode,aEpisodeID)
			Set:(+flg)>0 return=+flg
		}
	}
	Quit return
}

/// 通过HIS科室取HAI科室
/// w ##class(DHCHAI.CUS.ToClinReport).GetLocDr(10)
ClassMethod GetLocDr(aLocID As %String) As %String
{
	New (aLocID)
	Set return=""
	Quit:(aLocID="") return
	
	//根据医院对照取HIS系统代码(HISCode)
	Set HISCode=""
	Set XLocID=aLocID //登录科室
	Quit:XLocID="" return
	Set XHospID=$p($g(^CTLOC(+XLocID)),"^",22)
	Set:XHospID="" XHospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set objHospMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",XHospID)
	If $IsObject(objHospMap){
		Set objHosp=objHospMap.BTMapHospDr
		Set:$IsObject(objHosp) HISCode=$p(objHosp.BTXCode,"||",1)
	}
	Quit:HISCode="" return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(HISCode,aLocID)
	If $IsObject(objLoc) {
		Set return=objLoc.%Id()
	} Else {
		Set flg=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncLocationByID(HISCode,aLocID)
		Set:(+flg)>0 return=+flg
	}
	Quit return
}

/// 通过HIS用户取HAI用户
/// w ##class(DHCHAI.CUS.ToClinReport).GetUserDr(105,10)
ClassMethod GetUserDr(aUserID As %String, aLocID As %String) As %String
{
	New (aUserID,aLocID)
	Set return=""
	Quit:(aUserID="")||(aLocID="") return
	
	//根据医院对照取HIS系统代码(HISCode)
	Set HISCode=""
	Set XLocID=aLocID //登录科室
	Quit:XLocID="" return
	Set XHospID=$p($g(^CTLOC(+XLocID)),"^",22)
	Set:XHospID="" XHospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set objHospMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",XHospID)
	If $IsObject(objHospMap){
		Set objHosp=objHospMap.BTMapHospDr
		Set:$IsObject(objHosp) HISCode=$p(objHosp.BTXCode,"||",1)
	}
	Quit:HISCode="" return
	
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjByXCode(HISCode,aUserID)
	If $IsObject(objUser) {
		Set return=objUser.%Id()
	} Else {
		Set flg=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncSSUserByID(HISCode,aUserID)
		Set:(+flg)>0 return=+flg
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询医院感染报告信息
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCHAI.CUS.ToClinReport","QryReportByAdm",340545)
Query QryReportByAdm(aEpisodeDr As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeDr:%String,ReportTypeCode:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusDesc:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,InfPos:%String,InfDate:%String,InfDiag:%String,Specimen:%String,TestResults:%String,BackOpinion:%String")
{
}

ClassMethod QryReportByAdmExecute(ByRef qHandle As %Binary, aEpisodeDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeDr="" $$$OK
	
	Set ClinRepTypeList=##class(DHCHAI.BT.Config).GetValByCode("IRClinRepTypeList")
	Set:ClinRepTypeList="" ClinRepTypeList="1"
	Set ClinRepTypeList="|"_ClinRepTypeList_"|"
	
	Set xRepType=0
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		
		//检查临床报告类型，通过设置处理
		Set tRepType="|"_xRepType_"|"
		Continue:ClinRepTypeList'[tRepType
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
			Quit:xRepID=""
			
			Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.IREpisodeDr)
			
			Set (EpisodeDr,ReportTypeCode,ReportTypeDesc)=""
			Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
			Set (ReportDate,ReportTime,ReportStatusID,ReportStatusDesc)=""
			Set (PapmiNo,PatientName,PatientSex,PatientAge)=""
			Set (InfPosDesc,InfDateDesc,InfDiagDesc,SpecimenDesc,TestResults)=""
			
			Set EpisodeDr=aEpisodeDr
			Set RepType=objReport.IRRepType
			Set ReportTypeCode=RepType
			Set ReportTypeDesc=""
			If RepType=1 {
				Set ReportTypeDesc="医院感染报告"
			} ElseIf RepType=2 {
				Set ReportTypeDesc="新生儿感染报告"
			} ElseIf RepType=3 {
				Set ReportTypeDesc="ICU调查表"
			} ElseIf RepType=4 {
				Set ReportTypeDesc="手术切口调查表"
			} ElseIf RepType=5 {
				Set ReportTypeDesc="多重耐药调查表"
			} Else {
				//6抗菌药物调查表
				//7横断面调查
				Continue
			}
			If $IsObject(objReport.IRRepLocDr){
				Set ReportLocID=objReport.IRRepLocDr.%Id()
				Set ReportLocDesc=objReport.IRRepLocDr.BTDesc
				Set ReportLocDesc2=objReport.IRRepLocDr.BTDesc2
				Set:ReportLocDesc2'="" ReportLocDesc=ReportLocDesc2
			}
			If $IsObject(objReport.IRRepUser){
				Set ReportUserID=objReport.IRRepUser.%Id()
				Set ReportUserDesc=objReport.IRRepUser.BTDesc
			}
			Set ReportDate=objReport.IRRepDate
			Set:ReportDate'="" ReportDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReportDate)
			//Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
			Set ReportTime=objReport.IRRepTime
			Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
			If $IsObject(objReport.IRStatusDr){
				Set ReportStatusID=objReport.IRStatusDr.%Id()
				Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
			}
			Set PapmiNo=objReport.IREpisodeDr.PAPapmiNo
			Set PatientName=objReport.IREpisodeDr.PAPatName
			Set PatientSex=objReport.IREpisodeDr.PASex
			Set PatientSex=$s(PatientSex="M":"男",PatientSex="F":"女",PatientSex="O":"其他",1:"")
			Set PatientAge=objReport.IREpisodeDr.PAAge
			
			Set InfPosList="",InfSubList="",InfDateList=""
			Set InfDiagList=objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indInfD=1:1:$l(InfDiagList,","){
				Set xInfDiagnosID=$p(InfDiagList,",",indInfD)
				Continue:xInfDiagnosID=""
				Set objInfDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagnosID)
				Continue:'$IsObject(objInfDiagnos)
				Continue:'$IsObject(objInfDiagnos.IRInfPosDr)
				Set tInfPos=objInfDiagnos.IRInfPosDr.BTDesc
				Set tInfSub=objInfDiagnos.IRInfSubDr.BTDesc
				Set tInfDate=objInfDiagnos.IRInfDate
				//Set:tInfDate="" tInfDate=$zd(tInfDate,3)
				Set:tInfDate'="" tInfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(tInfDate)
				Set InfPosList=InfPosList_$lb(tInfPos)
				Set InfSubList=InfSubList_$lb(tInfSub)
				Set InfDateList=InfDateList_$lb(tInfDate)
			}
			Set InfPosDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfPosList,";")
			Set InfDiagDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSubList,";")
			Set InfDateDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfDateList,";")
			Set:RepType=2 InfDateDesc=$p(InfDateDesc,";",1)   //新生儿感染报告只有一个感染日期
			Set:RepType=2 InfPosDesc=$p(InfPosDesc,";",1)
			
			Set SpecimenList="",LabBactList=""
			Set InfLabList=objReport.GetRepLinkIDs("DHCHAI.IR.INFLab")
			For indInfL=1:1:$l(InfLabList,","){
				Set xInfLabID=$p(InfLabList,",",indInfL)
				Continue:xInfLabID=""
				Set objInfLab=##class(DHCHAI.IR.INFLab).GetObjById(xInfLabID)
				Continue:'$IsObject(objInfLab)
				Continue:'$IsObject(objInfLab.IRSpecimenDr)
				
				Set tSpecimen=objInfLab.IRSpecimenDr.BTSpecDesc
				Set SpecimenList=SpecimenList_$lb(tSpecimen)
				
				Set xLabBactSub=0
				For {
					Set xLabBactSub=$o(^DHCHAI.IR.INFLabD(xInfLabID,"BACT",xLabBactSub))
					Quit:xLabBactSub=""
					Set objLabBact=##class(DHCHAI.IR.INFLabBact).GetObjById(xInfLabID_"||"_xLabBactSub)
					Continue:'$IsObject(objLabBact)
					Set tLabBact=objLabBact.IRBactDesc
					Set LabBactList=LabBactList_$lb(tLabBact)
				}
			}
			Set SpecimenDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(SpecimenList,";")
			Set TestResults=##class(DHCHAI.Utils.CommonSrv).ListToString(LabBactList,";")
			// 取退回原因
			Set BackOpinion=""
			Set xLogDr=""
			For {
				Set xLogDr=$o(^DHCHAI.IR.INFReportD(xRepID,"LOG",xLogDr),-1)
				Quit:((xLogDr="")||(BackOpinion'=""))
				
				Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(xRepID_"||"_xLogDr)
				Continue:'$IsObject(objLog)
				Continue:'$IsObject(objLog.IRStatusDr)
				Set StatusCode=objLog.IRStatusDr.BTCode
				Continue:(StatusCode'=5)    // 5:退回
				Set BackOpinion = objLog.IROpinion
			}
			
			//多语言翻译
			Set ReportTypeDesc= ##class(websys.Translation).Get("dhcma.ss.clinreptoadm.csp",ReportTypeDesc)
			Set ReportLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",ReportLocDesc,"User.CTLoc")
			Set ReportUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",ReportUserDesc,"User.SSUser")
			Set InfPosDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfPosDesc,"DHCHAI.BT.InfPos")
			Set InfDiagDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfDiagDesc,"DHCHAI.BT.InfSub")
			Set SpecimenDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpecimenDesc,"DHCHAI.DP.LabSpecimen")
			Set ReportStatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ReportStatusDesc,"DHCHAI.BT.Dictionary")
			Set Data=$lb(xRepID,EpisodeDr,ReportTypeCode,ReportTypeDesc)
			Set Data=Data_$lb(ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)
			Set Data=Data_$lb(ReportDate,ReportTime,ReportStatusID,ReportStatusDesc)
			Set Data=Data_$lb(PapmiNo,PatientName,PatientSex,PatientAge)
			Set Data=Data_$lb(InfPosDesc,InfDateDesc,InfDiagDesc,SpecimenDesc,TestResults,BackOpinion)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryReportByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByAdmExecute ]
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
