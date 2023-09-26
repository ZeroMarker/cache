/// 名称: DHCMed.CCService.Ctrl.Important
/// 描述: 住院患者监控
/// 编写者：zhufei
/// 编写日期: 2011-03-13
Class DHCMed.CCService.Ctrl.Important Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildCtrlData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildCtrlDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmDays)=""
	Set objPaadm=##Class(User.PAAdm).%OpenId(argPaadm)
	Quit:'$IsObject(objPaadm) return
	Do objPaadm.%Close()
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    //Set PapmiNo=objPatient.PAPMINo
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
	    //update by zf 20150228 统一调用年龄计算方法
	    Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,argPaadm,"","")	//返回“*岁*月*天”
	    Set:Birthday'="" Birthday=$zd(Birthday,3)
	    Set PersonalID=objPatient.PAPMIID
	}
	
    //Set AdmitDate=objPaadm.PAADMAdmDate
    //Set AdmitTime=objPaadm.PAADMAdmTime
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    //Set DisDate=objPaadm.PAADMDischgDate
    //Set DisTime=objPaadm.PAADMDischgTime
    //Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	}
    If $IsObject(objPaadm.PAADMCurrentWardDR)
    {
	    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
	    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	}
	If $IsObject(objPaadm.PAADMCurrentRoomDR)
	{
		Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
	}
	If $IsObject(objPaadm.PAADMCurrentBedDR)
	{
		Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
	}
	If $IsObject(objPaadm.PAADMAdmDocCodeDR)
	{
		Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
	}
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(argPaadm)
	
	//就诊信息
	Set Data=$lb(argPaadm)
    Set Data=Data_$lb(PatientID)
    Set Data=Data_$lb(PapmiNo)
    Set Data=Data_$lb(PatName)
    Set Data=Data_$lb(Sex)
    Set Data=Data_$lb(Birthday)
    Set Data=Data_$lb(Age)
    Set Data=Data_$lb(PersonalID)
	Set Data=Data_$lb(AdmitDate)
	Set Data=Data_$lb(AdmitTime)
	Set Data=Data_$lb(DisDate)
	Set Data=Data_$lb(DisTime)
	Set Data=Data_$lb(AdmLoc)
	Set Data=Data_$lb(AdmWard)
	Set Data=Data_$lb(AdmRoom)
	Set Data=Data_$lb(AdmBed)
	Set Data=Data_$lb(AdmDoc)
	Set Data=Data_$lb(AdmDays)
	Set Data=Data_$lb(MRAdm)
    
    Set return=Data
	Quit return
	
BuildCtrlDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  组织监控明细数据
/// Return:       字符串
ClassMethod BuildCtrlDtl(argCtrlDtls As %String) As %List
{
	New (argCtrlDtls)
	Set return="",DtlInfo="",ScoreCount=""
	Set $ZT="BuildCtrlDtlErr"
	
	//$lb($lb("病毒性乙型肝炎",5,2,$lb("","病毒性肝炎乙型慢性重度(2008-07-28 09:14)","药物性肝炎(2008-07-28 09:16)"),$lb("")))
	Set DtlInfo=DtlInfo_"<b style=margin:20px'>触发项目：列出此次就诊触发的项目明细。</b><br>"
	For i=1:1:$listlength(argCtrlDtls)
	{
		Set ctrlDtl=$li(argCtrlDtls,i)
		Set ItemDesc=$li(ctrlDtl,1)
		Set Score=$li(ctrlDtl,2)
		Set Result=$li(ctrlDtl,3)
		Set RstDtls=$li(ctrlDtl,4)
		Set RstErrs=$li(ctrlDtl,5)
		Set ScoreCount=ScoreCount+Score
		Set DtlInfo=DtlInfo_"<b style=margin:40px'>"_"项目"_i_"："_ItemDesc_"  分值："_Score_""_"</b><br>"
		For j=1:1:$listlength(RstDtls)
		{
			Set RstDtl=$li(RstDtls,j)
			Continue:RstDtl=""
			Set DtlInfo=DtlInfo_"<a style=margin:80px'>"_"Value："_RstDtl_"</a><br>"
		}
		For j=1:1:$listlength(RstErrs)
		{
			Set RstErr=$li(RstErrs,j)
			Continue:RstErr=""
			Set DtlInfo=DtlInfo_"<a style=margin:80px'>"_"Error："_RstErr_"</a><br>"
		}
	}
	Set return=$lb(ScoreCount,DtlInfo)
	Quit return
BuildCtrlDtlErr
	Set DtlInfo="<b style=margin:20px'>Error: "_$ZERROR_"</b><br>"
	Set return=$lb(-999,DtlInfo)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  住院患者监控(包括:在院、出院)
/// Input：       Status(在院/出院),DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区),Ctrls(监控项目列表)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.Ctrl.Important","QryByPaadm","I","","","","820/821/822/",65)
Query QryByPaadm(argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,MRAdm:%String,Score:%String,CtrlDtl:%String,EvalInfo:%String")
{
}

ClassMethod QryByPaadmExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:argCtrls="" $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	;Quit:(argLocID="")&&(argWardID="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	Set flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList("",argCtrls)

	Quit:flg<1 $$$OK
	
	Set PACWardID=0
	For {
		Set PACWardID=$o(^PAADMi("CurrWard",PACWardID))
		Quit:PACWardID=""
		Set WardID=$p($g(^PAWARD(PACWardID)),"^",5)
		Continue:(argWardID'="")&&(argWardID'=WardID)
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",+WardID))
		Set aRoom=""
		For {
			Set aRoom=$o(^PAADMi("CurrWard",PACWardID,aRoom))
			Quit:aRoom=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",PACWardID,aRoom,Paadm))

				Quit:Paadm=""
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"                 //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
				//Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)
				//upadte by pylian 2016-02-18 修改入院时间取值方式
   				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Continue:(argDateFrom'="")&&(AdmDate<argDateFrom)
				Continue:(argDateTo'="")&&(AdmDate>argDateTo)
				If argCtrls'="" {
					Set ctrlDtl=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm)
					Continue:ctrlDtl=""
					Set DataDetail=..BuildCtrlDtl(ctrlDtl)
				}Else{
					Set DataDetail=$lb(0,"")
				}
				Set Data=..BuildCtrlData(Paadm)
				Continue:Data=""
				Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(argSubjectID,Paadm)
				Set Data=Data_DataDetail_$lb(EvalInfo)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	Quit $$$OK
}

ClassMethod QryByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPaadmExecute ]
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
