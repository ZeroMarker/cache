Import SQLUser

Class web.DHCDocOutPatientList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 判断是否可以接诊
/// w ##class(web.DHCDocOutPatientList).CheckIsAdmissions(438,13648)
ClassMethod CheckIsAdmissions(EpisodeID As %String, UserID As %String, CurLogonHosp As %String = "") As %String
{
	s myRtnStr=""
	;1.报到状态不能接诊
	Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Set QueRowId=..GetQueRowidByMore(EpisodeID,DocId)
	s PersName=""
	q:QueRowId="" ""
	Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)	
	Set PersName=QueObj.QueStateDr.PersName
	Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	Set DeptDr=QueObj.QueDepDr.%Id()
	Set QueEverCalled=QueObj.QueEverCalled
	Set QueNo=QueObj.QueNo
	Do QueObj.%Close()
	i (PersName["报到")&&(##class(web.DHCDocTransfer).GetExaNoCheckinDocCanRecAdm(EpisodeID)'="Y") {
		s myRtnStr="未报到的患者不允许接诊,请提醒患者到诊区分诊台报到."
	}
	
	Set PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	if ((PAAdmPriority'="优先")&&(myRtnStr="")&&(PAAdmType="O")&&(QueNo'=""))&&((PersName="等候")&&(QueEverCalled'="Y")){
		;医生站设置-常规设置-不呼叫允许医生正常接诊【该配置西南医大附属项目用，标板未加该配置】
		s AllowAdmissionsNoCall=..%GetConfig("AllowAdmissionsNoCall",CurLogonHosp)
		if (AllowAdmissionsNoCall=0){
			;医生站配置-科室功能设置-科室扩展设置不呼叫禁止医生正常接诊(1表示配置勾选)
			s LocNotAllowAdmissionsIFNoCall=+($P($G(^CTLOC(DeptDr,"DHC")),"^",22))
			if LocNotAllowAdmissionsIFNoCall=1{
				s myRtnStr="未呼叫过的患者不允许接诊,请按顺序呼叫病人并接诊."	
			}
		}
	}
	Q myRtnStr
}

/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date) As %Status
{
	Set AdmDate=$P($g(^PAADM(Adm)),"^",6)
	If (AdmDate<DateFrom)!(AdmDate>DateTo) Quit 1 
	Quit 0
}

ClassMethod CheckDocTime(DocId) As %Status
{
	Set LocID=%session.Get("LOGON.CTLOCID")
	If LocID="" Quit 100	
 If $g(DocId)="" Quit 100
 //
 Set ResRowId=$o(^RB("RES",0,"CTPCP",DocId,LocID,""))
 Quit:ResRowId="" 101 
 Set DateRowId=""
 If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
 Quit:DateRowId="" 101
 //
 Set CurDate=..%SysDate(),CurTime=..%SysTime(),CurWeek=$ZD(+$H,10)
 If CurWeek="0" Set CurWeek="7"
 Set Sess=""
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
 .Set StartTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
 .Set EndTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
 .Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
 .Quit:DoWeek'=CurWeek
 .If CurTime<StartTime Set Sess=102 Quit
 .If CurTime'<EndTime Set Sess=102 Quit
 .Set Sess=0 	
	If Sess="" Set Sess=101
	Quit Sess
}

/// , LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String
ClassMethod FindLocDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	set ^DHCA=qHandle
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","FindLocDocCurrentAdm","194","12175","","","","","","","","")
ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String = "", MarkID As %String = "", CheckName As %String = "", PatSeqNo As %String = "", ExpSessionStr As %String = "") As %Status
{
	s ^guo("OutPatList")=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation
	s $zt="error"
	;Set qHandle=$lb(0,repid,0)
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	If $g(DocId)="" Quit $$$OK
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
    s (LgHospID,LgGroupID)=""
	Set langid=..%LanguageID()
	if $d(%session){
		Set LgHospID=%session.Get("LOGON.HOSPID")
		Set LgGroupID=%session.Get("LOGON.GROUPID")
	}else{
		Set LgHospID=$p(ExpSessionStr,"^",2)
		Set LgGroupID=$p(ExpSessionStr,"^",1)	
	}
	;改进通过传入的CheckName来验证传入的是什么组件  
	;加入以下判断初始化参数兼容已经存在的别的产品组调用不会报错
	s Report="",CompleteQue=""
	s:("^"_CheckName_"^")["^RegQue^" RegQue="on"
	s:("^"_CheckName_"^")["^AllPatient^" AllPatient="on"
	s:("^"_CheckName_"^")["^ArrivedQue^" ArrivedQue="on"
	s:("^"_CheckName_"^")["^Consultation^" Consultation="on"
	s:("^"_CheckName_"^")["^Report^" Report="on"
	s:("^"_CheckName_"^")["^Complete^" CompleteQue="on"
	if (MarkID="null") s MarkID=""
	if (RegQue="")&&(AllPatient="")&&(ArrivedQue="")&&(Consultation="")&&(CheckName="") s RegQue="on"
	
	if SurName'="" s SurName=$$ALPHAUP^SSUTIL4(SurName)
	//判断当前可以列诊的号?只能有一个?//此处对应多个号别并且不是专家则会只取到最后一个对照的号别.有问题
	set CurTime=..%SysTime()
	set CurrMark=""
	set TimeRangeDr=##class(web.DHCDocOutPatientList).GetTimeRangeByTime(CurTime)
	set DocLinkMarkDr=0
	FOR  Set DocLinkMarkDr=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,DocLinkMarkDr)) Quit:DocLinkMarkDr=""  Do
	.s MarkDocID=0,FindMarkDocFlag=0
	.f  s MarkDocID=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,DocLinkMarkDr,MarkDocID)) Q:(MarkDocID="")||(FindMarkDocFlag=1)  d
	..s MarkddepDr=$lg(^User.DHCMarkDocD(MarkDocID),4)
	..Q:MarkddepDr'=LocID
	..s FindMarkDocFlag=1
	.Q:FindMarkDocFlag=0
	.set ResDr=##class(web.DHCOPAdmReg).GetResRowIdStr(LocID,DocLinkMarkDr)
	.Q:ResDr=""
	.set SechDr=##class(web.DHCRBApptSchedule).GetAvailRA(ResDr,+$h,0,TimeRangeDr)
	.set SpecFlag=$p($g(^CTPCP(DocLinkMarkDr,1)),"^",16)
	.if (SechDr'="")&(CurrMark="") set CurrMark=DocLinkMarkDr
	.if (SechDr'="")&(SpecFlag="Y") set CurrMark=DocLinkMarkDr
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//20180627 新门诊患者列表,不单独进行姓名或者登记号的查询
	/*Set Singleflag=0
	If ($g(PatientNo)'="") Do
		.Set Singleflag=1
		.Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
		.Quit:$g(PAPMI)=""
		.Do OutOPPAAdm
	If ($g(SurName)'="")&($g(PatientNo)="") Do
		.Set Singleflag=1
		.Set name=SurName
		.Set name0=name
		.Set PAPMI=0
		.For  Set PAPMI=$O(^PAPERi("PAPER_PatName",SurName,PAPMI)) Quit:PAPMI=""  Do
		..Do OutOPPAAdm
		.Set Qflag="N"
		.For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		..If $l(name),$e(name0,1,$l(name))'[name Set Qflag="Y" Quit
		..Set PAPMI=0
		..For  Set PAPMI=$O(^PAPERi("PAPER_PatName",name0,PAPMI)) Quit:PAPMI=""  Do
		...Do OutOPPAAdm
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Singleflag=1 $$$OK*/

	If (RegQue="on1") Do
	.Do OutOPPAPMI
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:(RegQue="on1") $$$OK
	
	If (RegQue="on") Do 
	.Do OutOPPAPMINewCon
	.;Do OutOPPAPMINewConfig
	.;Do OutOPPAPMINew
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	.//d SetArrivePatList
	.//Set qHandle=$lb(0,repid,0)
	Quit:(RegQue="on") $$$OK
	
	If (ArrivedQue="on")	Do 
	.Do OutOPArrived
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1),-1) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2),-1) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:ArrivedQue="on" $$$OK
	
	//OutOPConsultation
	If (Consultation="on")	Do 
	.Do OutOPConsultation
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Consultation="on" $$$OK
	
	;报到
	If (Report="on") Do 
	.Do OutOPReport
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Report="on" $$$OK
	
	;已完成
	If (CompleteQue="on") Do 
	.Do OutOPComplate
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1),-1) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2),-1) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:CompleteQue="on" $$$OK
	
	//对无分诊的诊区如何处理!!
	//不做医生号别对照的专家号做如下判断
	//Set QutFlag="Y"
	
	//&SQL(select ID into :QutFlag from DHCDepMark where DepmDepDr=:LocID and DepmMarkDr= :DocId)
	//
	//Quit:QutFlag="" $$$OK

	//
	/*Set RoomDr="",DocConsultArea=""
	Set RoomDr=..GetDocConsultRoom()

	If RoomDr="" Set qHandle=$lb(0,repid,0) Kill ^TMP("DHCDocWorkBench",$j) Quit $$$OK
	&SQL(select BorDr INTO :DocConsultArea FROM DHCBorExaRoom WHERE BorExaRoomDr=:RoomDr)
	If DocConsultArea="" Set qHandle=$lb(0,repid,0) Kill ^TMP("DHCDocWorkBench",$j) Quit $$$OK
	//---------------------------------------------------------------------
	//---------------------------------------------------------------------
	*/
	;Set ^SMLPara=LocID_"^"_UserID_"^"_DocId_"^"_RoomDr_"^"_DocConsultArea
	Set QueDr=0
	For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.Set QuitFlag=0
	.Set QueConsultArea=QueObj.QueExabDrGetObjectId()
	.//If QueConsultArea'=DocConsultArea Set QuitFlag=1
	.Set QueMark=QueObj.QueMarkDrGetObjectId()
	.Q:(MarkID'="")&&(MarkID'=QueMark)
	.;Set:((QueMark'=CurrMark)&(QueMark'=DocId)) QuitFlag=1     2009-02-15
	.Set QueStatus=QueObj.QueStateDr.PersName
	.If (QueStatus="到达")&(AllPatient'="on") Set QuitFlag=1
	.If QueStatus="退号" Set QuitFlag=1
	.If QueStatus="报到" Set QuitFlag=1
	.//If QueStatus="过号" Set QuitFlag=1
	.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	.Set QueConsultFlag=QueObj.QueConsultFlag
	.//set ^DHCAA(QueDr)=QueMark_"^"_QueStatus
	.If (PAAdm="")!('$D(^PAADM(PAAdm))) Set QuitFlag=1
	.Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	.//;判断是否医生号别对照,会诊病人
	.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	.quit:(DocAdmInclude="N")
	.If (PAAdm'="") do
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do 
	...//如果该号的出诊时段不在当前时段?该号不显示
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...if (HospitalCode="ZHSRMYY")&&(RegRangeTimeDr'=TimeRangeDr) Set QuitFlag=1
	.If (DocId'=QueObj.QueDocDrGetObjectId())&(QueObj.QueDocDrGetObjectId()'="") Set QuitFlag=1
	.Do QueObj.%Close()
	.Quit:QuitFlag=1
	.Do OutputRow(QueDr,"")
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,MZRecordStatus)=""
	Quit
 ;("UnSort")
 ;SortFlag: 
 ;	UnSort 		不在OutputRow内部排序
 ;	Sort||""	在OutputRow内部排序(默认是这种方式)
OutputRow(ParaQueDr,SortFlag)
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	q:(PatientNo'="")&&($$ALPHAUP^SSUTIL4(PAPMINO)'[PatientNo)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	q:(SurName'="")&&($$ALPHAUP^SSUTIL4(PAPMIName)'[SurName)
	s PAPMIName=##class(web.DHCDocUtil).EvalJSON(PAPMIName)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.//Set PAPMIAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PAPMIDOB,+$h)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm,LgHospID)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	s PAPMISex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	s PAAdmTimeGet=$P($g(^PAADM(PAAdm)),"^",7)
	Set PAAdmTime=..%ZT(PAAdmTimeGet,3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	If Loc'="" d
	.Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	.s PAAdmDepCodeDR=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmDepCodeDR,langid)
	.if ($f(PAAdmDepCodeDR,"-")'=0) set PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	Else  Set PAAdmDepCodeDR=""
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmDocCodeDR= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDocCodeDR,langid)
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'=""  d
	.Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	.s Hospital=##class(User.CTHospital).GetTranByDesc("HOSPDesc",Hospital,langid)
	Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
	if (Ward'="") {
		Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
		s PAAdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
	}else{  Set PAAdmWard=""}
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	s PAAdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",PAAdmReason,langid)
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	s ArrivedDate="",ArrivedTime=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	i ParaQueDr'="" Set QueRowId=ParaQueDr
	e  Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set LocSeqNo=QueObj.QueNo
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	.Set Doc=QueObj.QueDocDrGetObjectId()
	.If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.Else  Set PAAdmDocCodeDR=""
	.Set PAAdmDocCodeDR= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDocCodeDR,langid)
	.Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	.Set PAAdmPriority= ##class(User.DHCFirstCode).GetTranByDesc("FirstcName",PAAdmPriority,langid)
	.Set PriorityCode=QueObj.QueFirstDr.FirstcCode
	.If PriorityCode="" Set PriorityCode="XX"
	.Set RegDocCode=""
	.Set RegDocDr=QueObj.QueMarkDrGetObjectId()
	.If RegDocDr'="" d
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..Set RegDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",RegDoctor,langid)
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...set RegfeeNo=$List(^User.DHCRegistrationFeeD(RegfeeDr),8)
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...if RegRangeTimeDr="" do
	....s RBASRowid=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),18)
	....if RBASRowid'="" s RegRangeTimeDr=$P($G(^RBAS(+RBASRowid,$P(RBASRowid,"||",2),"DHC")),"^",17)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	...Set RegRangeTime= ##class(User.DHCTimeRange).GetTranByDesc("TRDesc",RegRangeTime,langid)
	...i RegfeeNo'="" set RegDoctor=RegDoctor_"("_$g(RegRangeTime)_")"
	..set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Set Called=QueObj.QueCompDr
	.set SortCalled=Called
	.IF Called="" SET SortCalled="X"
	.Set WalkStatus=QueObj.QueStateDr.PersShowName
	.Set StatusCode=QueObj.QueStateDr.PersCode
	.If StatusCode="" Set StatusCode="XX"
	.set WalkStatus= ##class(User.DHCPerState).GetTranByDesc("PersShowName",WalkStatus,langid)
	.//到达日期，到达时间
	.i WalkStatus="到达" d
	..s ArrivedDate=QueObj.QueStateDate,ArrivedTime=QueObj.QueStateTime
	..i ArrivedDate'="" s ArrivedDate=..%ZD(ArrivedDate) //$zd(ArrivedDate,3)
	..i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	.Set ConsultRoom=QueObj.QueRoomDr.CTLOCDesc
	.s ConsultRoom=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ConsultRoom,langid)
	.//set ConsultRoom=QueObj.QueExabDr
	.Set ConsultArea=QueObj.QueExabDr.ExabName
	.s ConsultArea=##class(User.DHCExaBorough).GetTranByDesc("ExabName",ConsultArea,langid)
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set SortCalled="X"
	.Set RegDocDr=""
	s RegAdmSource=##class(web.DHCDocMainOut).GetRegAdmSource(EpisodeID)
	s RegAdmSource=##class(websys.Translation).Get("opdoc.patient.list.csp",RegAdmSource)
	s NewSeqNoStr=..GetNewQueueNo(PAAdm)
	if NewSeqNoStr'="" {
		s SeqNo=$P(NewSeqNoStr,"^",1)
		s LocSeqNo=$P(NewSeqNoStr,"^",2)
		if ($P(NewSeqNoStr,"^",3)'="正常"){
			s NewSeqNoStatu=$P(NewSeqNoStr,"^",3)
			s NewSeqNoStatu=##class(websys.Translation).Get("opdoc.patient.list.csp",NewSeqNoStatu)
			s LocSeqNo=LocSeqNo_"("_NewSeqNoStatu_")"
		}
	}
	q:(PatSeqNo'="")&&(PatSeqNo'=$P(LocSeqNo,"(",1))
	Set Count=Count+1
	
	set SeqNo=$tr(SeqNo,"+","Z")
	Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	If (ArrivedQue="on")  d
	.;s Arrtime=$$GetLastArriveTime(EpisodeID) ;按照到达时间排
	.s ArriveFalg=..%GetConfig1("OutPatListArrive",LgGroupID,LgHospID)
	.s Arrtime=PAAdmTimeGet ;按照就诊时间排
	.if ArriveFalg=1 s Seq=$G(RegDocCode)_$G(SortCalled)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo) ;$G(PriorityCode)
	.e  Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(StatusCode)_..%ZDH($G(PAAdmDate))_$G(RegRangeTimeDr)_$G(Arrtime) ;$G(PriorityCode)
	s ComPlateflag=""
	Set Complateflag=$P($g(^PAADM(PAAdm,1)),"^",23)
	s:Complateflag="Y" ComPlateflag="是"
	s ComPlateflag=##class(websys.Translation).Get("opdoc.patient.list.csp",ComPlateflag)
	s Remark=""
	s APPRBASDR=$O(^RBAS("ADM",EpisodeID,""))
	if (APPRBASDR'=""){
		s APPRBASSubDR=$O(^RBAS("ADM",EpisodeID,APPRBASDR,""))
		if (APPRBASSubDR'=""){
			s RBSub=$O(^RBAS("ADM",EpisodeID,APPRBASDR,APPRBASSubDR,""))
			if (RBSub'="") s Remark=$g(^RBAS(APPRBASDR,APPRBASSubDR,"APPT",RBSub,"REM",1))
		}
	}
	s PAAdmReMark=##class(web.DHCDocInPatientListNew).GetDocReMark(EpisodeID)
	s PAAdmReMark=##class(web.DHCDocUtil).EvalJSON(PAAdmReMark)
	s MZRecordStatus=##class(DHCDoc.Interface.Inside.InvokeOPAdm).GetMZRecordStatus(EpisodeID)
	s MZRecordStatus=##class(websys.Translation).Get("opdoc.patient.list.csp",MZRecordStatus)
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,RegAdmSource,QueRowId,ComPlateflag,Remark,PAAdmReMark,MZRecordStatus)
 	if SortFlag="UnSort" {
	 	set SortLable=SortFlag
 	}else{
 		set SortLable=Seq
 	}
 	
	Set ^TMP("DHCDocWorkBench",$j,SortLable,Count)=Data
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	Quit
OutOPPAPMI
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...//医生号别对照作用语句 下两句
	...;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...Quit:QueRowId=""
	...Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	...Set QueDoc=QueObj.QueDocDrGetObjectId()
	...Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	...Set StatusName=QueObj.QueStateDr.PersName
	...//--------add gsb 复诊可以查询
	...s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	...quit:(DocAdmInclude="N")
	...//-----------------------------------------
	...Do QueObj.%Close()
	...Q:(MarkID'="")&&(MarkID'=MarkDoc)
	...Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")) 
	...Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	...;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId)) //有对照和没有对照都考虑在内  2009-03-25 gry
	...Do OutputRow("","")
	Quit
	
OutOPConsultation
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set QueRowId1=0
	.For  Set QueRowId1=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId1)) Quit:QueRowId1=""  Do
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId1)
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag'="Y"
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..quit:VisitStatus'="A"
	..;如果会诊和报到同时勾选，则默认取报到的会诊记录
	..Quit:(Report="on")&&(StatusName'="报到")
	..;会诊病人控制队列状态和未就诊一致
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号"))&&(Report'="on")
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..Do OutputRow(QueRowId1,"")
	Quit
	;
OutOPPAPMINewCon
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	k ^TempOutDoc(UserJob)
	For Date=StartDate:1:EndDate {
		s QueRowId=0
		For  {
			Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId))
			Quit:QueRowId=""
			Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
			continue:'$IsObject(QueObj)
			Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			Set QueDoc=QueObj.QueDocDrGetObjectId()
			Set MarkDoc=QueObj.QueMarkDrGetObjectId()
			continue:(MarkID'="")&&(MarkID'=MarkDoc)
			continue:(QueObj.QueStateDr.PersName="到达")
			Set StatusName=##class(DHCDoc.OPDoc.PatientListConfig).GetQueueStatus(QueRowId,PAAdm,LocID)
			Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
			Set CalledFlag=QueObj.QueCompDr
			Set QueWaitCallTime=QueObj.QueWaitCallTime
			if QueObj.QueStateDr.PersName="过号" s StatusName="过号"
			i CalledFlag="1" s StatusName="正在呼叫"
			i CalledFlag="2" s StatusName="等候呼叫"
			Set SeqNo=""
			s NewSeqNoStr=..GetNewQueueNo(PAAdm)
			if NewSeqNoStr'="" s SeqNo=$P(NewSeqNoStr,"^",1)
			Set RegRangeTime=""
			set RegfeeDr=""
			Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
			if (RegfeeDr'=""){
				set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
				i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
			}
			s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			continue:(DocAdmInclude="N")
			Do QueObj.%Close()
			s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
			continue:VisitStatus'="A"
			continue:(StatusName="")
			continue:(((QueDoc'="")&(QueDoc'=DocId)))
			i $d(^TempOutDoc(UserJob,"Ind",StatusName))=0 s TempIndex=1
			e  s TempIndex=+$o(^TempOutDoc(UserJob,"Ind",StatusName,""),-1)+1
			s ^TempOutDoc(UserJob,"Ind",StatusName,TempIndex)=PAAdm
			if (StatusName="正在呼叫"){
				s ^TempOutDoc(UserJob,StatusName,SeqNo,TempIndex)=PAAdm
			}elseif (StatusName="等候呼叫"){
				Set SeqNo=QueWaitCallTime_SeqNo
				s ^TempOutDoc(UserJob,StatusName,SeqNo,TempIndex)=PAAdm
			}elseif (StatusName="过号"){
				s StatusTime=QueObj.QueStateTime
				s ^DHCDocSkip(+$H,QueRowId)=StatusTime
				s ^TempOutDoc(UserJob,StatusName,$G(^DHCDocSkip(+$H,QueRowId)),TempIndex)=PAAdm
			}else{
				i SeqNo["+" s SeqNo="A"_SeqNo
				Set SeqNo=RegRangeTime_SeqNo
				if (StatusName="复诊"){
					s StatusTime=QueObj.QueStateTime
					s ^DHCDocAgain(+$H,QueRowId)=StatusTime
					Set SeqNo=^DHCDocAgain(+$H,QueRowId)
				}
				s ^TempOutDoc(UserJob,StatusName,SeqNo,TempIndex)=PAAdm
			}
		}
	}
	set TempQty=0
	set CallFlag=0
	s SeqNo=""
	f  {
		s SeqNo=$O(^TempOutDoc(UserJob,"正在呼叫",SeqNo)) 
		q:SeqNo=""  
		s TempIndex=""
		for {
			s TempIndex=$O(^TempOutDoc(UserJob,"正在呼叫",SeqNo,TempIndex))
			q:TempIndex="" 
			s TempQty=TempQty+1
			s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正在呼叫",SeqNo,TempIndex)
		}
	}
	s SeqNo=""
	f  {
		s SeqNo=$O(^TempOutDoc(UserJob,"等候呼叫",SeqNo)) 
		q:SeqNo=""  
		s TempIndex=""
		for {
			s TempIndex=$O(^TempOutDoc(UserJob,"等候呼叫",SeqNo,TempIndex))
			q:TempIndex="" 
			s TempQty=TempQty+1
			s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"等候呼叫",SeqNo,TempIndex)
		}
	}
	if (TempQty'=0) s CallFlag=1
	;---自定义排序
	s StatusInfo=##class(DHCDoc.OPDoc.PatientListConfig).GetOutPatientConfigStr(LocID)
	s LoopLen=$L(StatusInfo,"^")
	for i=1:1:LoopLen {
		s Status=$P(StatusInfo,"^",i)
		s NewTempIndex=0
		s SeqNo=""
		f  {
			s SeqNo=$O(^TempOutDoc(UserJob,Status,SeqNo)) 
			q:SeqNo=""  
			s TempIndex=""
			for {
				s TempIndex=$O(^TempOutDoc(UserJob,Status,SeqNo,TempIndex))
				q:TempIndex="" 
				s NewTempIndex=NewTempIndex+1
				s ^TempOutDoc(UserJob,"LoopLenStatus",Status,NewTempIndex)=$G(^TempOutDoc(UserJob,Status,SeqNo,TempIndex))
			}
		}
	}
	s StatusDisplayNum=0
	s TotalStatusNum=0
	for i=1:1:LoopLen {
		s Status=$P(StatusInfo,"^",i)
		continue:$D(StatusNum(Status,"Index"))
		s StatusNum(Status,"Index")=1												//当前状态对应的需输入下标
		s StatusNum(Status,"Total")=+$o(^TempOutDoc(UserJob,"LoopLenStatus",Status,""),-1)	//当前状态总人数
		if (StatusNum(Status,"Total")>0){
			s StatusDisplayNum=StatusDisplayNum+1
		}
		s TotalStatusNum=TotalStatusNum+StatusNum(Status,"Total")
	}
	///记录上次看完或者等候呼叫的最后一个是第几位
	if ((CallFlag=1)||($g(^DHCDocSetArrive(UserID,+$H,"Call"))'="")){
		s TestQty=$g(^DHCDocSetArrive(UserID,+$H,"Call"))
	}else{
		s TestQty=$g(^DHCDocSetArrive(UserID,+$H,"Arrive"))
		}
	if TestQty="" s TestQty=0
	s AddTempQty=0
	f MinRowID=1:1:(TotalStatusNum) {
		//计算当前需要输出的状态
		s SqueueInd=((TestQty+LoopLen+AddTempQty)#LoopLen+1)
		s AddTempQty=AddTempQty+1
		s OnceStatus=$P(StatusInfo,"^",SqueueInd)
		b //当前需要输入的状态如果已经全部遍历完毕，则使用下一个状态填充
		if (StatusNum(OnceStatus,"Index")>StatusNum(OnceStatus,"Total")){
			s MinRowID=MinRowID-1
			continue
		}
		continue:$g(^TempOutDoc(UserJob,"LoopLenStatus",OnceStatus,StatusNum(OnceStatus,"Index")))=""
		s TempQty=TempQty+1
		s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"LoopLenStatus",OnceStatus,StatusNum(OnceStatus,"Index"))
		s Paadm=^TempOutDoc(UserJob,"OutPut",TempQty)
		s ^DHCDocOutPatientList("WartInd",Paadm)=SqueueInd
		s StatusNum(OnceStatus,"Index")=StatusNum(OnceStatus,"Index")+1
	}
	;---结束
	s SeqNo=""
	f  {
		s SeqNo=$O(^TempOutDoc(UserJob,"过号",SeqNo)) 
		q:SeqNo=""  
		s TempIndex=""
		for {
			s TempIndex=$O(^TempOutDoc(UserJob,"过号",SeqNo,TempIndex))
			q:TempIndex="" 
			s TempQty=TempQty+1
			s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"过号",SeqNo,TempIndex)
		}
	}
	f PXRowId=1:1:TempQty   d
	.q:$G(^TempOutDoc(UserJob,"OutPut",PXRowId))=""
	.s PAAdm=^TempOutDoc(UserJob,"OutPut",PXRowId)
	.i PXRowId=1 s ^DHCDocCall(+$h,UserID,"Frist")=PAAdm
	.d OutputRow("","UnSort")
	k ^TempOutDoc(UserJob)
	Quit
OutOPPAPMINewD
    ;b ;new
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	;s UserJob="61765"_$J_"6"
	k ^TempOutDoc(UserJob)
	/*
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	*/
	For Date=StartDate:1:EndDate Do
	.s QueRowId=0
	.For  Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId)) Quit:QueRowId=""  Do
	..;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	..;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	..;Quit:QueRowId=""
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	..Quit:'$IsObject(QueObj)
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Q:(MarkID'="")&&(MarkID'=MarkDoc)
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	..Set CalledFlag=QueObj.QueCompDr
	..Set QueWaitCallTime=QueObj.QueWaitCallTime
	..i CalledFlag="1" s StatusName="正在呼叫"
	..i CalledFlag="2" s StatusName="等候呼叫"
	..Set SeqNo=""
	..Set LocSeqNo=QueObj.QueNo
	..If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	..If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	..If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	..If $L(LocSeqNo)=0 Set SeqNo="999"
	..s NewSeqNoStr=..GetNewQueueNo(PAAdm)
	..if NewSeqNoStr'="" s SeqNo=$P(NewSeqNoStr,"^",1)
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	..e  Set RegRangeTime=""
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..quit:VisitStatus'="A"
	..;此处增加过号未登记患者不显示
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="等候呼叫")) 
	..;b ;QueDoc  DocId
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..//有对照和没有对照都考虑在内  2009-03-25 gry
    ..;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId))
	..i $d(^TempOutDoc(UserJob,PAAdmPriority,StatusName))=0 s TempIndex=1
	..e  s TempIndex=+$o(^TempOutDoc(UserJob,PAAdmPriority,StatusName,""),-1)+1
	..s ^TempOutDoc(UserJob,PAAdmPriority,StatusName,TempIndex)=PAAdm
	..;等候呼叫排序，防止大号先报到进入待诊且为等候呼叫，小号后报到进入待诊等候呼叫一直插在大号之前的问题
	..i (StatusName="等候呼叫") d
	...Set SeqNo=QueWaitCallTime_SeqNo
	...s ^TempOutDoc(UserJob,PAAdmPriority,"等候呼叫排序",SeqNo,TempIndex)=PAAdm
	..i (StatusName="等候") d
	...i SeqNo["+" s SeqNo="A"_SeqNo
	...Set SeqNo=RegRangeTime_SeqNo
	...s ^TempOutDoc(UserJob,PAAdmPriority,"等候排序",SeqNo,TempIndex)=PAAdm
	..i (StatusName="复诊") d
	...s StatusTime=QueObj.QueStateTime
	...s ^DHCDocAgain(+$H,QueRowId)=StatusTime
	...s ^TempOutDoc(UserJob,PAAdmPriority,"复诊排序",$G(^DHCDocAgain(+$H,QueRowId)),TempIndex)=PAAdm
	..;由于过号患者需要报到 此处也需要增加时间排序
	..i (StatusName="过号") d
	...s StatusTime=QueObj.QueStateTime
	...s ^DHCDocSkip(+$H,QueRowId)=StatusTime
	...s ^TempOutDoc(UserJob,PAAdmPriority,"过号排序",$G(^DHCDocSkip(+$H,QueRowId)),TempIndex)=PAAdm
	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"优先","等候呼叫排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","等候呼叫排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"优先","等候呼叫排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"优先","等候呼叫",NewTempIndex)=$G(^TempOutDoc(UserJob,"优先","等候呼叫排序",SeqNo,TempIndex))
	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"正常","等候呼叫排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候呼叫排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","等候呼叫排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","等候呼叫",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","等候呼叫排序",SeqNo,TempIndex))
	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","等候",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))
	s NewTempIndex=0
	s AgainTime=""
	f  s AgainTime=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime)) q:AgainTime=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","复诊",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))
	s NewTempIndex=0
	s AgainTime=""
	f  s AgainTime=$O(^TempOutDoc(UserJob,"正常","过号排序",AgainTime)) q:AgainTime=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","过号排序",AgainTime,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","过号排序",AgainTime,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","过号",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","过号排序",AgainTime,TempIndex))
	set TempQty=0
	s ifCalled=0,WartCalled=0
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)
	
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)
	.s ifCalled=1
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","等候呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","等候呼叫",TempIndex)
	.s WartCalled=WartCalled+1
	.;s ifCalled=1 ;这里需要修改ifCalled的值?--nikang
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候呼叫",TempIndex)
	.s WartCalled=WartCalled+1
	.;s ifCalled=1 ;这里需要修改ifCalled的值?--nikang
	
	s StatusId=0
	f  s StatusId=$o(^TempOutDoc(UserJob,"优先",StatusId)) q:StatusId=""  d
	.q:StatusId="正在呼叫"
	.q:StatusId="等候呼叫"
	.s TempIndex=""
	.f  s TempIndex=$o(^TempOutDoc(UserJob,"优先",StatusId,TempIndex)) q:TempIndex=""  d
	..s TempQty=TempQty+1
	..Q:$G(^TempOutDoc(UserJob,"优先",StatusId,TempIndex))=""
	..s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先",StatusId,TempIndex)
	b ;-------------------------------------------自定义排序区
	s StatusInfo="等候^等候^复诊"
	s LoopLen=$L(StatusInfo,"^")
	s StatusDisplayNum=0
	s TotalStatusNum=0
	for i=1:1:LoopLen {
		s Status=$P(StatusInfo,"^",i)
		continue:$D(StatusNum(Status,"Index"))
		s StatusNum(Status,"Index")=1												//当前状态对应的需输入下标
		s StatusNum(Status,"Total")=+$o(^TempOutDoc(UserJob,"正常",Status,""),-1)	//当前状态总人数
		if (StatusNum(Status,"Total")>0){
			s StatusDisplayNum=StatusDisplayNum+1
		}
		s TotalStatusNum=TotalStatusNum+StatusNum(Status,"Total")
	}
	;如果需要输入的状态小于等于1，对整个队列进行重新排序
	i (StatusDisplayNum<=1) k ^DHCDocCall(+$h,UserID)
	;
	i ('$D(^DHCDocCall(+$h,UserID))||($G(^DHCDocCall(+$h,UserID))="")) s TestQty=0
	e  s TestQty=+$g(^DHCDocCall(+$h,UserID))+ifCalled+WartCalled
	s TestQty=TestQty#LoopLen
	f MinRowID=1:1:(TotalStatusNum) {
		s TempQty=TempQty+1
		//计算当前需要输出的状态
		s OnceStatus=$P(StatusInfo,"^",((TempQty+TestQty+(LoopLen-1))#LoopLen+1))
		b //当前需要输入的状态如果已经全部遍历完毕，则使用下一个状态填充
		if (StatusNum(OnceStatus,"Index")>StatusNum(OnceStatus,"Total")){
			s MinRowID=MinRowID-1
			continue
		}
		continue:$g(^TempOutDoc(UserJob,"正常",OnceStatus,StatusNum(OnceStatus,"Index")))=""
		s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常",OnceStatus,StatusNum(OnceStatus,"Index"))
		s StatusNum(OnceStatus,"Index")=StatusNum(OnceStatus,"Index")+1
	}
	b ;--------------------------------------------------其他状态排序区
	s OtherStatusInfo="过号"
	for i=1:1:$L(OtherStatusInfo,"^") {
		s OtherStatus=$P(OtherStatusInfo,"^",i)
		if (StatusInfo[OtherStatus){
			continue
		}
		s Index=0
		for  {
			s Index=$o(^TempOutDoc(UserJob,"正常",OtherStatus,Index)) 
			q:Index=""  
			s TempQty=TempQty+1
			s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常",OtherStatus,Index)
		}
	}
	
	f PXRowId=1:1:TempQty   d
	.q:$G(^TempOutDoc(UserJob,"OutPut",PXRowId))=""
	.s PAAdm=^TempOutDoc(UserJob,"OutPut",PXRowId)
	.i PXRowId=1 s ^DHCDocCall(+$h,UserID,"Frist")=PAAdm
	.d OutputRow("","UnSort")
	k ^TempOutDoc(UserJob)
	Quit
OutOPPAPMINewConfig
 	b ;new
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	;s UserJob="61765"_$J_"6"
	//k ^TempOutDoc(UserJob)
	/*
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	*/
	
	s config="优先-9999:正在呼叫-9999:等候呼叫-9999:等候-2:复诊-1"
	s ListNum=0,OtherNum=0
	k TempList($j)
	k ^tempP("TempList")
	
	For Date=StartDate:1:EndDate Do
	.s QueRowId=0
	.For  Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId)) Quit:QueRowId=""  Do
	..;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	..;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	..;Quit:QueRowId=""
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	..Quit:'$IsObject(QueObj)
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag="Y"
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Q:(MarkID'="")&&(MarkID'=MarkDoc)
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	..;if PAAdmPriority="优先" s StatusName="优先"
	..Set CalledFlag=QueObj.QueCompDr
	..i CalledFlag'="" s StatusName="正在呼叫"
	..i CalledFlag="1" s StatusName="正在呼叫"
	..i CalledFlag="2" s StatusName="等候呼叫"
	..if (((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="等候呼叫"))&&(PAAdmPriority="优先")) s StatusName="优先"
	..Set SeqNo=""
	..Set LocSeqNo=QueObj.QueNo
	..If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	..If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	..If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	..If $L(LocSeqNo)=0 Set SeqNo="999"
	..if SeqNo["+" d
	...s SeqNo=$tr(SeqNo,"+","")
	...s SeqNo="Z"_SeqNo
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	..e  Set RegRangeTime=""
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..quit:VisitStatus'="A"
	..;b ;StatusName
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="等候呼叫")!(StatusName="优先")) 
	..;b ;QueDoc  DocId
	..;b ;QueDoc  DocId
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..//有对照和没有对照都考虑在内  2009-03-25 gry
    ..;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId))
	..//设置取数规则数据 s ListNum=0,OtherNum=0
	..if StatusName="复诊" s SeqNo=$g(^DHCDocAgain(+$H,QueRowId))
	..Set SeqNo=RegRangeTime_SeqNo
	..b ;093344
	..i ((config[(StatusName_"-"))) d  ;&&($L(LocSeqNo)'=0)) d
	...s ListNum=ListNum+1  ;有规则
	...s SeqNo=SeqNo_ListNum
	...s ^TempList($j,"正常",StatusName,SeqNo)=PAAdm
	..e  d
	...s OtherNum=OtherNum+1 ;无规则
	...s SeqNo=SeqNo_OtherNum
	...s ^TempList($j,"其他",StatusName,SeqNo)=PAAdm
	..s ^tempP("TempList",$j,QueRowId)=RegRangeTime_":"_SeqNo_":"_PAAdm
	
	/*新写排队规则 
	1.记录当前查询到 ^TempList($j,按优先级,状态,序号)
	2.最后组织输出数据 按配置取出再设置排队序号
	*/
	//1.取有排队规则数据
	b ; ListNum  OtherNum
	
	while(ListNum>0){	
		s con=$l(config,":")
		for ti=1:1:con{
			s constr=$p(config,":",ti)
			s type=$p(constr,"-",1)
			s num=$p(constr,"-",2)
			s c1=$$T3($j,"正常",type,num)
			;w type_":"_c1,!
			s ListNum=ListNum-c1	
		}
		b ;ListNum
	}
	
	s li=0
	f  s li=$o(^TempList($j,"List",li)) q:li=""  d
	.s PAAdm=^TempList($j,"List",li)
	.;w "PAAdm:"_PAAdm,!
	.Do OutputRow("","UnSort")
	
	b ; OtherNum
	//2.取无排队规则数据
	i OtherNum>0{
		s nuei=0
		i $d(^TempList($j,"List")){//新序号
			s nuei=$o(^TempList($j,"List",""),-1)
		}
		s st=""
		f  s st=$o(^TempList($j,"其他",st)) q:st=""  d
		.s ot=""
		.f  s ot=$o(^TempList($j,"其他",st,ot)) q:ot=""  d
		..;s ^TempList($j,"List",nuei)=^TempList($j,"其他",st,ot)
		..s PAAdm=^TempList($j,"其他",st,ot)
		..Do OutputRow("","UnSort")
	}
	
	k ^TempList($j)

	Quit
	;
T3(t,tt,type,num)
	s pkey=0,cnt=1,i=0
	i $d(^TempList(t,"pkey",tt,type)){//上一次取数key 
		s pkey=$g(^TempList(t,"pkey",tt,type))
	}
	i $d(^TempList(t,"List")){//新序号
		s i=$o(^TempList(t,"List",""),-1)
	}
	f  s pkey=$o(^TempList(t,tt,type,pkey)) q:((pkey="")!(cnt>num))  d
	.s ^TempList(t,"pkey",tt,type)=pkey
	.s i=i+1
	.s value=$G(^TempList(t,tt,type,pkey))
	.;w "key:"_pkey_",value:"_value,!
	.s ^TempList(t,"List",i)=value
	.s cnt=cnt+1
	q (cnt-1)	
	
OutOPPAPMINew
    b ;new
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	;s UserJob="61765"_$J_"6"
	k ^TempOutDoc(UserJob)
	/*
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	*/
	For Date=StartDate:1:EndDate Do
	.s QueRowId=0
	.For  Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId)) Quit:QueRowId=""  Do
	..;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	..;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	..;Quit:QueRowId=""
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	..Quit:'$IsObject(QueObj)
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag="Y"
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Q:(MarkID'="")&&(MarkID'=MarkDoc)
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	..Set CalledFlag=QueObj.QueCompDr
	..i CalledFlag'="" s StatusName="正在呼叫"
	..i CalledFlag="1" s StatusName="正在呼叫"
	..i CalledFlag="2" s StatusName="等候呼叫"
	..Set SeqNo=""
	..Set LocSeqNo=QueObj.QueNo
	..If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	..If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	..If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	..If $L(LocSeqNo)=0 Set SeqNo="999"
	..if SeqNo["+" d
	...s SeqNo=$tr(SeqNo,"+","")
	...s SeqNo="Z"_SeqNo
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	..e  Set RegRangeTime=""
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..quit:VisitStatus'="A"
	..b ;StatusName
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="等候呼叫")) 
	..b ;QueDoc  DocId
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..//有对照和没有对照都考虑在内  2009-03-25 gry
    ..;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId))
	..i $d(^TempOutDoc(UserJob,PAAdmPriority,StatusName))=0 s TempIndex=1
	..e  s TempIndex=+$o(^TempOutDoc(UserJob,PAAdmPriority,StatusName,""),-1)+1
	..s ^TempOutDoc(UserJob,PAAdmPriority,StatusName,TempIndex)=PAAdm
	..i (StatusName="等候") d
	...Set SeqNo=RegRangeTime_SeqNo
	...s ^TempOutDoc(UserJob,PAAdmPriority,"等候排序",SeqNo,TempIndex)=PAAdm
	..i (StatusName="复诊") d
	...i $G(^DHCDocAgain(+$H,QueRowId))="" s ^DHCDocAgain(+$H,QueRowId)=..%SysTime()
	...s ^TempOutDoc(UserJob,PAAdmPriority,"复诊排序",$G(^DHCDocAgain(+$H,QueRowId)),TempIndex)=PAAdm

	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","等候",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))

	s NewTempIndex=0
	s AgainTime=""
	f  s AgainTime=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime)) q:AgainTime=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","复诊",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))
	
	set TempQty=0
	s ifCalled=0
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)
	.s ifCalled=1
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","等候呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","等候呼叫",TempIndex)
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候呼叫",TempIndex)
	.s ifCalled=1
	s StatusId=0
	f  s StatusId=$o(^TempOutDoc(UserJob,"优先",StatusId)) q:StatusId=""  d
	.q:StatusId="正在呼叫"
	.q:StatusId="等候呼叫"
	.s TempIndex=""
	.f  s TempIndex=$o(^TempOutDoc(UserJob,"优先",StatusId,TempIndex)) q:TempIndex=""  d
	..s TempQty=TempQty+1
	..Q:$G(^TempOutDoc(UserJob,"优先",StatusId,TempIndex))=""
	..s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先",StatusId,TempIndex)
	
	s DHQty=+$o(^TempOutDoc(UserJob,"正常","等候",""),-1)
	s FZQty=+$o(^TempOutDoc(UserJob,"正常","复诊",""),-1)
	
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	i '$D(^DHCDocCall(+$h,UserID)) s TestQty=1
	e  s TestQty=+$g(^DHCDocCall(+$h,UserID))+ifCalled
	s TestQty=TestQty#2
	i DHQty="" d
	.i FZQty="" d
	..
	.e  d
	..f FZRowId=1:1:FZQty q:FZRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	e  d
	.i FZQty="" d
	..f DHRowId=1:1:DHQty q:DHRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.e  d
	..i FZQty>DHQty d
	...f DHRowId=1:1:DHQty q:DHRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	...f DHRowId=DHQty+1:1:FZQty q:DHRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	..e  d
	...f FZRowId=1:1:FZQty q:FZRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	...f FZRowId=FZQty+1:1:DHQty q:FZRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	s GHRowId=0
	f  s GHRowId=$o(^TempOutDoc(UserJob,"正常","过号",GHRowId)) q:GHRowId=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","过号",GHRowId)
	
	f PXRowId=1:1:TempQty q:PXRowId=""  d
	.q:$G(^TempOutDoc(UserJob,"OutPut",PXRowId))=""
	.s PAAdm=^TempOutDoc(UserJob,"OutPut",PXRowId)
	.Do OutputRow("","UnSort")
	k ^TempOutDoc(UserJob)
	Quit
	;
OutOPArrived
	Set ArriveCount=0
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set ComplateFlag=$P($g(^PAADM(PAAdm,1)),"^",23)
	...Quit:ComplateFlag="Y"	;已就诊不包含已经完成
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm,1)),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm,1)),"^",11)
	...Set PatQueState=""
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....Q:(MarkID'="")&&(QueMarkId'=MarkID)
	....Quit:(QueDocId'=DocId)
	....;对于到达来说,只要到达医生是登陆医生即需要显示
	....;Q:(MarkID'="")&&(MarkID'=QueMarkId)
	....If StatusName="到达" Set PatQueState="A"
	....Do QueObj.%Close()
	...e  d
	....s CESAdmStatusInfo=##Class(DHCDoc.Interface.StandAlone.Service).GetCESAdmQueStatInfo(PAAdm) //判断是否是应急系统导回患者
	....s:$p(CESAdmStatusInfo,"^",3)="到达" PatQueState="A"
	...Quit:(PatQueState="")
	...Do OutputRow(QueRowId,"")
	...s ArriveCount=ArriveCount+1
	Quit
	;
OutOPPAAdm
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	Set PAAdm=0
	For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM","O",PAAdm)) Quit:PAAdm=""  Do
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:PatLoc'=LocID
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(AdmDate<StartDate)!(AdmDate>EndDate)
	.s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	.Quit:AdmVisitStatus="C"
	.s QueStateDr="",StateCode=""
	.;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,0))
	.Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.if QueStateDr'="" Set StateCode=$List(^User.DHCPerStateD(QueStateDr),2)
	.Q:(StateCode="07")&&(Report'="on")
	.Do OutputRow(QueRowId,"")
	Quit
OutOPReport
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm,1)),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm,1)),"^",11)
	...Set PatQueState=""
	...;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	....quit:(DocAdmInclude="N")
	....Quit:(QueDocId'=DocId)&&(QueDocId'="")
	....Q:(MarkID'="")&&(MarkID'=QueMarkId)
	....If StatusName="报到" Set PatQueState="B"
	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...Do OutputRow(QueRowId,"")
	Quit
OutOPComplate
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set ComplateFlag=$P($g(^PAADM(PAAdm,1)),"^",23)
	...Quit:ComplateFlag'="Y"
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm,1)),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm,1)),"^",11)
	...Set PatQueState=""
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....Q:(MarkID'="")&&(QueMarkId'=MarkID)
	....Quit:(QueDocId'=DocId)
	....;对于到达来说,只要到达医生是登陆医生即需要显示
	....;Q:(MarkID'="")&&(MarkID'=QueMarkId)
	....If StatusName="到达" Set PatQueState="A"
	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...Do OutputRow(QueRowId,"")
	Quit
error
     set ^Temp("FindLoccurrentAdm","error")=$ze
	 Quit $$$OK
GetLastArriveTime(EpisodeID)
	;获取最后一次到达时间
	s QueLastArriveTime=""
	s QueIDPAADM=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,0))
	s QueCahngeSub=""
	f  s QueCahngeSub=$O(^DHCQueueStatus(QueIDPAADM,QueCahngeSub),-1) Q:(QueCahngeSub="")||(QueLastArriveTime'="")  d
	.s LastStatuDr=$P($G(^DHCQueueStatus(QueIDPAADM,QueCahngeSub)),"^",4)
	.Q:LastStatuDr=""
	.s LastStateDesc=$list(^User.DHCPerStateD(LastStatuDr),4)
	.if LastStateDesc="到达"
	.s QueLastArriveTime=$P($G(^DHCQueueStatus(QueIDPAADM,QueCahngeSub)),"^",2)
	q QueLastArriveTime
SetArrivePatList
    s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)=""
	s PAPMINO="已看病人:"
	s ArriveFlagRowInd=ind
	Set ^CacheTemp(repid,ind)=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)
 	set ind=ind+1
	Do OutOPArrived
	
	;赋值已看病人数
	Set $List(^CacheTemp(repid,ArriveFlagRowInd),4)=$ListGet(^CacheTemp(repid,ArriveFlagRowInd),4)_$g(ArriveCount)_"人"
	/*
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1
	..Set ^gry("xh",ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	*/
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	quit
}

ClassMethod FindLocDocCurrentAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetCareProvByUserID(UserID As %String) As %String
{
	Q:UserID="" ""
	
 s CareID="" 
	s UserObj=##class(User.SSUser).%OpenId(UserID)
	if '$IsObject(UserObj) Quit ""
	s CareObj=UserObj.SSUSRCareProvDR
	if $IsObject(CareObj) {
		s CareID=CareObj.%Id()
	}
	
	Q CareID
}

ClassMethod GetDocConsultRoom(IPAddress As %String = "", HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	i IPAddress="" Set IPAddress=..GetIPAndName()
	Set RoomDr=0,ConsultRoom=""
	for {
		Set RoomDr=$O(^User.DHCRoomCompI("RoomcIpIndex"," "_IPAddress,RoomDr)) Quit:(RoomDr="")||(ConsultRoom'="")
		continue:$d(^User.DHCRoomCompD(RoomDr))=0
		Set RoomRowId=$LIST(^User.DHCRoomCompD(RoomDr),5)
		continue:RoomRowId=""
		Set RoomHospDr=$p($g(^CTLOC(RoomRowId)),"^",22)
		continue:RoomHospDr'=HospId
		set RoomName=$p($g(^CTLOC(RoomRowId)),"^",2)
		Set ConsultRoom=RoomRowId
	}
	Quit ConsultRoom
}

ClassMethod GetDocConsultRoomCode() As %String
{
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	Set RoomCode=$p($g(^CTLOC(RoomDr)),"^",1)

	Quit RoomCode
}

ClassMethod GetDocConsultRoomName() As %String
{
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	Set RoomName=$p($g(^CTLOC(RoomDr)),"^",2)
	Quit RoomName
}

ClassMethod GetDocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	Set val=$$ALPHAUP^SSUTIL4(val)
 Set DocRowId=$O(^CTPCP(0,"Decs",val,""))
 If DocRowId'="" Set DocCode=$P($g(^CTLOC(DocRowId)),"^",1)
 Quit DocRowId_"^"_$g(DocCode)_"^"_val
}

ClassMethod GetFilePath() As %String
{
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	//Set ConsultArea=$LIST(^User.DHCExaRoomD(RoomDr),2)
	s ConsultAreaDr=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RoomDr,0))
 s ConsultArea=$LIST(^User.DHCBorExaRoomD(ConsultAreaDr),5)
	Quit:ConsultArea="" ""
	set FilePath=$o(^User.DHCExaBoroughFilePathI("BordBorDrIndex",ConsultArea,0))
	Quit:FilePath="" ""
	Set FilePath=$LIST(^User.DHCExaBoroughFilePathD(FilePath),7)
	Quit FilePath
}

ClassMethod GetIPAndName() As %String
{
	//Set IPAddress=$ZUTIL(67,15,$JOB)
	Set IPAddress=%session.Data("REMOTE_ADDR")
	
	Quit IPAddress
}

ClassMethod GetLocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Code",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String, DelimStr As %String = ",") As %String
{
	Quit:$g(MRAdm)="" ""
	s AdmID=$p($G(^MR(MRAdm,"PRO",1)),"^",9)
 	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(AdmID)
}

ClassMethod GetCardNoByPatientID(PatientID As %String) As %String
{
 Quit:$g(PatientID)="" ""
 Set CardNo="",find=0
 Set CFRowId=0
 Set PapmiRowId=PatientID
 for {
	 set CFRowId=$O(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,CFRowId)) q:(CFRowId="")||(find=1)
	 set CFTypeDr=$P(^DHCCARD("CF",CFRowId),"^",16)
	 set DefaultFlag=""
	 if CFTypeDr'="" set DefaultFlag=$P($g(^DHCCARDTYPEDef(CFTypeDr)),"^",8)
	 if DefaultFlag="Y" {
		 set find=1
		 set CardNo=$P(^DHCCARD("CF",CFRowId),"^",2)
	 }
 }

 Quit CardNo
}

ClassMethod GetQueDoc(PAAdm As %String) As %String
{
	Set Doc=""
	Quit:$g(PAAdm)="" ""
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	Set QueRowId=..GetQueRowidByMore(PAAdm,"")
	Quit:QueRowId="" Doc
	Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	Set Doc=QueObj.QueDocDrGetObjectId()
	Do QueObj.%Close()
	Quit Doc
}

ClassMethod GetTimeRangeByTime(SessTime As %String) As %String
{
	s find=0,ret=""
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")!(find=1)  d
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.i (SessTime'<StartTime)&&(SessTime'>EndTime) d
	..s find=1
	..s ret=TRRowId
	.Q:find=1
	if ret="" {
		s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")!(ret'="")  d
		.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
		.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
		.i (SessTime<StartTime) s ret=TRRowId
	}
	Q ret
}

ClassMethod GetWaitFilePath() As %String
{
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	//Set ConsultArea=$LIST(^User.DHCExaRoomD(RoomDr),2)
	s ConsultAreaDr=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RoomDr,0))
 s ConsultArea=$LIST(^User.DHCBorExaRoomD(ConsultAreaDr),5)
	Quit:ConsultArea="" ""
	set FilePath=$o(^User.DHCExaBoroughFilePathI("BordBorDrIndex",ConsultArea,0))
	Quit:FilePath="" ""
	Set FilePath=$LIST(^User.DHCExaBoroughFilePathD(FilePath),10)
	Quit FilePath
}

ClassMethod GetWardRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	Set val=$$ALPHAUP^SSUTIL4(val)
 Set WardRowId=$O(^PAWARD(0,"WARD_Desc",val,""))
 If WardRowId'="" Do
 .Set WardCode=$P($g(^PAWARD(WardRowId)),"^",1)
 .Set WardDesc=$P($g(^PAWARD(WardRowId)),"^",2) 	
 Quit WardRowId_"^"_$g(WardCode)_"^"_$g(WardDesc)
}

ClassMethod GetWorkflowID(Workflow As %String) As %String
{
 Quit ##Class(websys.WorkFlow).GetIdFromCodeOrDescription(Workflow)
}

ClassMethod SendPatient(PatientStr As %String) As %String
{
	Set Count=$I(^DHCCalledPatient(+$H))
	Set Date=$ZD(+$H,3)
	Set Time=..%ZT(..%SysTime(),3)
	Set ^DHCCalledPatient(+$H,Count)=PatientStr_"^"_Date_" "_Time
	Quit
}

ClassMethod SetAdmDocId(Adm As %String, DocId As %String, LocId As %String, UserId As %String, CurLogonHosp As %String = "") As %Status
{
 	 s CFArriveUpdate=..%GetConfig("ArriveUpdate",CurLogonHosp)
	 KILL PLIST
	 Set PLIST(0)=Adm
	 Set PLIST(95)=..%SysDate()
	 Set PLIST(96)=..%SysTime()
	 Set PLIST(12)=DocId
	 Set PLIST(5)=LocId
	 Set PLIST(79)=..%SysDate()
	 Set PLIST(80)=..%SysTime()
	 Set PLIST(97)=UserId
	 s OperSQLFlag=0
	 s CuDate=..%SysDate()
	 s CuTime=..%SysTime()
	 
	 ;就诊日期是当日，需更新就诊时间
	 set admDate=$p(^PAADM(Adm),"^",6)
	 i admDate=CuDate set admTime=CuTime
	 e  s admTime=$p(^PAADM(Adm),"^",7)
	 
	 ;判断就诊医生记录表是否有数据
	 s AdmDocFlag=$d(^PAADM(Adm,"DOCDEATIL"))
	 if AdmDocFlag=0{
		 //&SQL(INSERT INTO SQLUSER.PA_AdmTransaction VALUES PLIST() )
		 if CFArriveUpdate=1 {
		     &SQL(UPDATE SQLUSER.PA_Adm Set PAADM_AdmDocCodeDR=:DocId,PAADM_AdmTime=:admTime Where PAADM_RowId = :Adm)
		 }else{
		 	&SQL(UPDATE SQLUSER.PA_Adm Set PAADM_DepCode_DR=:LocId,PAADM_AdmDocCodeDR=:DocId,PAADM_AdmTime=:admTime Where PAADM_RowId = :Adm)
		 }
		 	;插入就诊医生记录表
		&sql(insert into SQLUser.PAAdm_DocDetails (AdmDoc_ParRef,AdmDoc_UserDR,AdmDoc_DocDR,AdmDoc_LocDR,AdmDoc_Date,AdmDoc_Time)
		values(:Adm,:UserId,:DocId,:LocId,:CuDate,:CuTime))
		s OperSQLFlag=1
	 }else{
		;判断和上一次记录是否一致
		s SQLReturn=0
		s PreAdmRowId=$o(^PAADM(Adm,"DOCDEATIL",""),-1)
		s PreAdmDocId=$p($g(^PAADM(Adm,"DOCDEATIL",PreAdmRowId)),"^",3)
		i PreAdmDocId'=DocId {
	 		;插入就诊医生记录表
			&sql(insert into SQLUser.PAAdm_DocDetails (AdmDoc_ParRef,AdmDoc_UserDR,AdmDoc_DocDR,AdmDoc_LocDR,AdmDoc_Date,AdmDoc_Time)
			values(:Adm,:UserId,:DocId,:LocId,:CuDate,:CuTime))
			s OperSQLFlag=1
		}
	 }
	 ;设置就诊到达科室
	 s $p(^PAADM(Adm,"DHC"),"^",10)=LocId
	 Q:OperSQLFlag=1 SQLCODE
	 Q 0
}

ClassMethod SetArrivedStatus(Adm As %String, DocDr As %String, LocId As %String, UserId As %String) As %Status
{
	s ^tmpgry("SetArrivedStatus")=Adm_","_DocDr_","_LocId_","_UserId
	Set HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
	Set sc=0,sc1=1
	Quit:$g(Adm)="" sc
	Set QueConsultFlag="N"
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Status=oref.QueStateDr.PersName
	.If (Status="复诊")!(Status="等候")!(Status="过号") Do
	..Set QueDoc=oref.QueDocDrGetObjectId()
	..Set PAAdmPriority=oref.QueFirstDr.FirstcName
	..Quit:(QueDoc'="")&(QueDoc'=DocDr)
	..If QueDoc="" Do oref.QueDocDrSetObjectId(DocDr)
	..&sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='到达')
	..Do oref.QueStateDrSetObjectId(PerStateDr)
	..Set oref.QueCompDr=""
	..Set oref.QueStateDate=..%SysDate()
	..Set oref.QueStateTime=..%SysTime()
	..Do oref.OperuseridSetObjectId(UserId)
	..Set sc = oref.%Save()
	..Set QueConsultFlag=oref.QueConsultFlag
 .Do oref.%Close()
 Quit:(QueRowId'="")&(sc'=1) sc
 if QueConsultFlag'="Y" {
	 Set sc1=..SetAdmDocId(Adm,DocDr,LocId,UserId)
	 If 'sc1 Set sc1=1
 }
 Quit:QueRowId="" sc1
 
 i $G(UserId)="" s UserId=%session.Get("LOGON.USERID")
 i (UserId'="") d
 .if ^DHCDocCall(+$h,UserId,"Frist")=Adm d
 ..s ^DHCDocSetArrive(UserId,+$H,"Arrive")=^DHCDocOutPatientList("WartInd",Adm)
 Quit sc
}

ClassMethod SetCallStatus(Adm As %String, DocDr As %String, CompDrFlag = "", IPAddress As %String = "", index = "") As %Status
{
	//RetCode=100	Adm blank
	//RetCode=101	Pat has called by other Doctor
	;w ##Class(web.DHCDocOutPatientList).SetCallStatus("152761","5476",2,"192.168.43.24",2)
	s ^tmpnk("SetCallStatus")=$lb(Adm,DocDr,CompDrFlag,IPAddress,index)
	s CompDr=CompDrFlag
	i CompDr=""  s CompDr=1
	if index="" s index=0
	if +index>0 s index=+index-1
	Set sc=0
	Quit:$g(Adm)="" 100
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
	If QueRowId=""{
		Quit sc
	}
	Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	Set Status=oref.QueStateDr.PersCode
	Set QueDoc=oref.QueDocDrGetObjectId()
	If (QueDoc'="")&(QueDoc'=DocDr) {
		Set sc="101"
		Do oref.%Close()
		Quit sc
	}
	If (Status="01")!(Status="02")!(Status="03") {
		Set Room=..GetDocConsultRoom(IPAddress)
		Do oref.QueRoomDrSetObjectId(Room)
		Do oref.QueDocDrSetObjectId(DocDr)
		//呼叫
		if CompDr=1 {
			Set oref.QueEverCalled="Y"
			Set oref.QueCallDate=..%SysDate()
			Set oref.QueCallTime=..%SysTime()
		}elseif (CompDr=2) {
			//等候呼叫
			;叫号时呼一等二,将连续两人置等候呼叫状态置时间差,方便排序
			set CurrTime=..%SysTime()+(index*5)
			Set oref.QueWaitCallDate=..%SysDate()
			Set oref.QueWaitCallTime=CurrTime
		}
		Set oref.QueCompDr=CompDr
		i Status="03" Do oref.QueStateDrSetObjectId(2)
		Set sc = oref.%Save()
	}else  {
		Set sc="102"
	}
	Do oref.%Close()
	Quit sc
}

// w ##class(web.DHCDocOutPatientList).SetSkipStatus(77074,1102)

ClassMethod SetSkipStatus(Adm As %String, DocDr As %String) As %Status
{
	Set sc=0
	Quit:$g(Adm)="" sc
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Status=oref.QueStateDr.PersName
	.Set PAAdmPriority=oref.QueFirstDr.FirstcName
	.;Quit:PAAdmPriority="优先"
	.Set called=oref.QueCompDr
	.Quit:called=""
	.If (Status="复诊")!(Status="等候")!(Status="过号") Do
	..Set QueDoc=oref.QueDocDrGetObjectId()
	..Quit:QueDoc=""
	..Quit:(QueDoc'="")&(QueDoc'=DocDr)
	..;
	..s RoomDr=""
	..s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",Adm,""))
	..if Regfeeid'="" d
	...s RBASDR=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	...s RoomDr=$P($G(^RBAS(+RBASDR,$P(RBASDR,"||",2),"DHC")),"^",5)
	..Do oref.QueRoomDrSetObjectId(RoomDr)
	..&sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='过号')
	..Do oref.QueStateDrSetObjectId(PerStateDr)
	..Do oref.QueDocDrSetObjectId("")
	..Set oref.QueCompDr=""
	..Set oref.QueEverCalled=""
	..Set oref.QueStateDate=..%SysDate()
	..Set oref.QueStateTime=..%SysTime()
	..if PAAdmPriority="优先" Do oref.QueFirstDrSetObjectId("2")
	..Set oref.QueFirstReason=""
	..Set sc = oref.%Save()
 	.Do oref.%Close()
 	i $G(UserId)="" s UserId=%session.Get("LOGON.USERID")
	i (UserId'="")&&($G(PAAdmPriority)'="优先") d
	.i $G(^DHCDocCall(+$h,UserId))="" s ^DHCDocCall(+$h,UserId)=0
	.if $g(^DHCDocCall(+$h,UserId,"Frist"))=Adm d
	..s ^DHCDocCall(+$h,UserId)=$I(^DHCDocCall(+$h,UserId))
 	Quit sc
}

ClassMethod SetSubCallStatus(Adm As %String, DocDr As %String) As %Status
{
 //RetCode=100 Adm blank
 //RetCode=101 Pat has called by other Doctor
 //
 Set sc=0
 Quit:$g(Adm)="" 100
 ;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
 Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
 If QueRowId'="" Do
 .Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
 .Set Status=oref.QueStateDr.PersName
 .If (Status="复诊")!(Status="等候")!(Status="过号") Do
 ..Set QueDoc=oref.QueDocDrGetObjectId()
 ..Set Qutflag=0
 ..If (QueDoc'="")&(QueDoc'=DocDr) Do
 ...Set sc="101"
 ...Set Qutflag=1
 ..Quit:Qutflag=1
 ..;
 ..Set Qutflag=0
 ..Set Called=oref.QueCompDr
 ..If (Called="1") do
 ...set sc="103"
 ...Set Qutflag=1
 ..Quit:Qutflag=1
 ..;
 ..Set Room=..GetDocConsultRoom()
 ..//Do oref.QueRoomDrSetObjectId(Room) //dj090409
 ..//Do oref.QueDocDrSetObjectId(DocDr) //gry 09-04-01
 ..//Mask Called
 ..Set oref.QueCompDr="2"
 ..Set sc = oref.%Save()
 .else  Set sc="102"
 .Do oref.%Close()
 Quit sc
}

/// LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String
Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "", PatSeqNo As %String = "", ExpSessionStr As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String:登记号$120,PAPMIName:%String:姓名$70,PAPMIDOB:%String:出生日期$100,PAPMISex:%String:性别$50,PAAdmDate:%String:就诊日期$95,PAAdmTime:%String:就诊时间$100,PAAdmNo:%String:就诊号$100,PAAdmDepCodeDR:%String:科室$100,PAAdmDocCodeDR:%String:医生$100,PAAdmType:%String:就诊类型$100,Hospital:%String:医院$100,PAAdmWard:%String:病区$100,PAAdmBed:%String:床号$100,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String:费别$70,DischargeDate:%String,RegDoctor:%String:号别$150,Diagnosis:%String:诊断$200,ArrivedDate:%String:到达日期$95,ArrivedTime:%String:到达时间$100,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String:序号$50,PAAdmPriority:%String:优先级$90,WalkStatus:%String:状态$70,ConsultRoom:%String:诊室$100,ConsultArea:%String:诊区$100,PAAdmReasonCode:%String,StatusCode:%String:就诊状态$100,Age:%String:年龄$55,PriorityCode:%String,Called:%String:呼叫标志$90,RegDocDr:%String,TPoliticalLevel:%String:级别$90,TSecretLevel:%String:密级$90,RegRangeTime:%String:时段$90,RegAdmSource:%String:来源$90,QueRowId:%String,ComPlateflag:%String:完成就诊$90,Remark:%String:预约备注$90,PAAdmReMark:%String:便签$90,MZRecordStatus:%String:病历状态$90")
{
}

/// 检查转诊
ClassMethod CheckReferral(loc As %String) As %Status
{
	Q:loc="" "1"
	s NoReferral=""
	s NoReferral=$P($g(^CTLOC(loc,"DHC")),"^",2)
	Q:NoReferral="1" "NoReferral"
	Q "1"
}

/// Creator:guorongyong
/// CreateDate:2010-08-11
/// desc:根据医生和EpisodeID得到DHCQueue队列表的Rowid
ClassMethod GetQueRowidByMore(EpisodeID As %String, DocRowid As %String) As %String
{
	;n (EpisodeID,DocRowid)
	s findQueRowid=""
	Set QueRowid=""
	for {
		Set QueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,QueRowid),-1)
		Q:QueRowid=""
		s QueDocDr=$List(^User.DHCQueueD(QueRowid),5)
		s QueLocDr=$List(^User.DHCQueueD(QueRowid),4)
		s PAADMDepCodeDR=$p(^PAADM(EpisodeID),"^",4)
		s QueConsultFlag=$List(^User.DHCQueueD(QueRowid),18)
		//continue:(LocRowid'="")&&(QueLocDr'=LocRowid)
		//处理存在会诊的情况
		//continue:(QueLocDr'=PAADMDepCodeDR)&&(LocRowid="")
		//continue:QueConsultFlag="Y"
		;到达医生有值
		if (QueDocDr'="") {
			if (QueDocDr=DocRowid) s findQueRowid=QueRowid
		}else{
		;到达医生没有值
			s findQueRowid=QueRowid
		}
		if findQueRowid'="" quit
	}
	if findQueRowid="" s findQueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""),-1)
	
	Q findQueRowid
}

/// Creator:guorongyong
/// CreateDate:2014-08-11
/// Desc:取消接诊
ClassMethod CancelAdmiss(Adm As %String, DocDr As %String) As %String
{
	;1.只能取消当日就诊的接诊,避免影响工作量统计
	;2.只能取消本人接诊的就诊记录
	;3.需要更新就诊表的就诊科室和就诊医生字段,队列表字段
	s ^tmpgry("CancelAdmiss")=Adm_","_DocDr
	Set myrtn=0
	Quit:$g(Adm)="" myrtn
	s AdmDate=$p(^PAADM(Adm),"^",6)
	q:AdmDate<+$H "NoToday"
	//医生加号取号之后已经确定该患者诊疗医生,不能进行操作取消接诊操作
	s TRegTypeCode=""
    i $D(^RBAS("PAADM_DR",Adm)) d
    .s resID=$O(^RBAS("PAADM_DR",Adm,""))
    .s resSub=$O(^RBAS("PAADM_DR",Adm,resID,""))
    .s apptSub=$O(^RBAS("PAADM_DR",Adm,resID,resSub,""))
    .s methodDR=$P(^RBAS(resID,resSub,"APPT",apptSub),"^",12)
    .q:methodDR=""
    .s TRegTypeCode=$P($G(^RBC("APTM",methodDR)),"^",1)
	Q:TRegTypeCode="DOCADD" "AddMark"
	
	s Rtn=##class(web.DHCOPAdmReg).CheckAdmDiagnos(Adm)
	Q:(Rtn=1) "diagnos"
	s Rtn=##class(web.DHCOPAdmReg).CheckAdmOrdItem(Adm)
	Q:(Rtn=1) "diagnos"
	
	Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
	if QueRowId'="" {
		TS	;WQY增加事务
		s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
		Set QueDoc=QueObj.QueDocDrGetObjectId()
		if QueDoc=""{
			TRO
			Q "NoAdmiss"
		}
		if QueDoc'=DocDr{
			TRO
			Q "NoSelf"
		}
		Set Status=QueObj.QueStateDr.PersName
	    if (Status'="到达"){
		    TRO
		    Q "NoAdmiss"
	    }
		/*;还原到DHCQueueStatus表的第一条记录的状态
		s QSRowId=$O(^DHCQueueStatus(QueRowId,""))
		if QSRowId="" {
			TRO
			Q "NoInitData"
		}else{
			s PreStatusDR=$p($g(^DHCQueueStatus(QueRowId,QSRowId)),"^",4)
		}*/
		//取消接诊一定是等候-》到达状态的就诊记录，还原为等候状态
		&sql(SELECT ID into :PreStatusDR FROM sqluser.dhcPerstate where persname='等候')
		
		d QueObj.QueStateDrSetObjectId(PreStatusDR)
		s QueObj.QueDocDr=""
		s QueObj.QueCompDr=""
		s QueObj.QueStateDate=..%SysDate()
		s QueObj.QueStateTime=..%SysTime()
		s sc = QueObj.%Save()
		if $$$ERROR(sc) {
			s myrtn="InsertFail"
		}else{
			s myrtn=0
		}
		d QueObj.%Close()
		
		s QueDepDr=QueObj.QueDepDrGetObjectId()
		if myrtn=0 {
			s myrtn=..SetAdmDocId(Adm,DocDr,QueDepDr,"")
			i myrtn'=0 s myrtn="UpdateAdmDocFail"
		}
		;wangqingyong 去掉PA_Adm完成接诊标志
		if myrtn=0{
			&SQL(UPDATE SQLUSER.PA_Adm Set PAADM_Completed=NULL Where PAADM_RowId = :Adm)
			s myrtn=SQLCODE
		}
		if myrtn=0{
			TC
		}else{
			TRO
		}
	}
	
 	Quit myrtn
}

ClassMethod CancelOPRegist(EpisodeID As %String, UseId As %String, GroupId As %String, LocRowd As %String)
{
	//s checkRegStr=##class(web.DHCOPAdmReg).CheckAdmDiagnos(EpisodeID)
	//if $p(checkRegStr,"^",1)=1 Quit checkRegStr
	
	Set RegFeeRowid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,0))
	if RegFeeRowid'=""{
		s ret=##class(web.DHCOPAdmReg).CancelOPRegist(RegFeeRowid,UseId,GroupId,LocRowd,"")
		if ret=0 Quit 0
		else  Quit "1^退号失败"_ret	
	}
	Quit 0
}

/// w ##class(web.DHCDocOutPatientList).SendCallInfo(2828)
ClassMethod SendCallInfo(UserId As %String)
{
	///调用叫号公司提供的webservice
	Set DocRowid=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Quit:DocRowid="" "-1^医生不存在"
	Set DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	Set CallServiceObj=##class(DHCDocCallService.HtOutpIndexManagerPort).%New()
	Set ret=CallServiceObj.callNext(DocCode)   //ret 为json串的格式
	///只需要 flag   visitNo
	//b ;434
	Set retFlag=$p($p(ret,"""flag"":",2),",",1)
	if retFlag="false"{
		Quit "-1^呼叫病人失败"	
	}
	Set AdmRowid=$p($p(ret,"""visitNo"":",2),",",1)
	if AdmRowid=""{
		//Quit "-1^没有需要呼叫的病人信息"_ret
		Quit "-1^没有需要呼叫的病人信息"
	}
	Set retStr=""
	s updateStatusFlag = ##Class(web.DHCDocOutPatientList).SetCallStatus(AdmRowid,DocRowid)
	if AdmRowid'=""	s ^tempupdateStatusFlag(AdmRowid)=updateStatusFlag
	//q:updateStatusFlag'=1 "-1^更新队列状态失败!"_ret
	Set PatientId=$p(^PAADM(AdmRowid),"^",1)
	Set PatietnNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
	Set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
	Set QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	Set SeqNo="",QueStatDesc=""
	if QueRowId'=""{
		Set SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
		Set QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
		Set QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	}
	if QueStatDesc="复诊"{
		 s retStr="正在呼叫复诊"_" "_SeqNo_"号"_" "_PatName
	}else{
		s retStr="正在呼叫"_" "_SeqNo_"号"_" "_PatName	
	}
	Quit 0_"^"_retStr
}

ClassMethod SendReCallInfo(UserId As %String)
{
	///调用叫号公司提供的webservice
	Set DocRowid=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Quit:DocRowid="" "-1^医生不存在"
	Set DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	Set CallServiceObj=##class(DHCDocCallService.HtOutpIndexManagerPort).%New()
	Set ret=CallServiceObj.recall(DocCode)   //ret 为json串的格式
	Set retFlag=$p($p(ret,"""flag"":",2),",",1)
	Set AdmRowid=$p($p(ret,"""visitNo"":",2),",",1)
	if (AdmRowid="")||(AdmRowid=0){
		//Quit "-1^没有需要呼叫的病人信息"_ret
		Quit "-1^没有需要呼叫的病人信息"
	}
	
	if retFlag="false"{
		Quit "-1^重复呼叫病人失败"	
	}
	
	Set PatientId=$p(^PAADM(AdmRowid),"^",1)
	Set PatietnNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
	Set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
    Set QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	Set SeqNo="",QueStatDesc=""
	if QueRowId'=""{
		Set SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
		Set QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
		Set QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	}
	if QueStatDesc="复诊"{
		 s retStr="正在重复呼叫复诊"_" "_SeqNo_"号"_" "_PatName
	}else{
		s retStr="正在重复呼叫"_" "_SeqNo_"号"_" "_PatName	
	}
	Quit 0_"^"_retStr
}

/// , LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String
ClassMethod FindLocDocCurrentAdmEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmEExecute ]
{
	set ^DHCA=qHandle
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","FindLocDocCurrentAdm",21,219,"","","","","","","","on","")
ClassMethod FindLocDocCurrentAdmEExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String = "", MarkID As %String = "", CheckName As %String = "") As %Status
{
	s ^tmpguo("OutPatList")=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation_","_MarkID_","_CheckName
	//s $zt="error"
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	If $g(DocId)="" Quit $$$OK
	s (LgHospID,LgGroupID)=""
	if $d(%session){
		Set LgHospID=%session.Get("LOGON.HOSPID")
		Set LgGroupID=%session.Get("LOGON.GROUPID")
	}
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	;改进通过传入的CheckName来验证传入的是什么组件  
	;加入以下判断初始化参数兼容已经存在的别的产品组调用不会报错
	s Report=""
	s:("^"_CheckName_"^")["^RegQue^" RegQue="on"
	s:("^"_CheckName_"^")["^AllPatient^" AllPatient="on"
	s:("^"_CheckName_"^")["^ArrivedQue^" ArrivedQue="on"
	s:("^"_CheckName_"^")["^Consultation^" Consultation="on"
	s:("^"_CheckName_"^")["^Report^" Report="on"
	if (MarkID="null") s MarkID=""

	if (RegQue="")&&(AllPatient="")&&(ArrivedQue="")&&(Consultation="")&&(CheckName="") s RegQue1="on"
	s ResultFlag=0
	if SurName'="" s SurName=$$ALPHAUP^SSUTIL4(SurName)
	//判断当前可以列诊的号?只能有一个?//此处对应多个号别并且不是专家则会只取到最后一个对照的号别.有问题
	set CurTime=..%SysTime()
	set CurrMark=""
	set TimeRangeDr=##class(web.DHCDocOutPatientList).GetTimeRangeByTime(CurTime)
	set DocLinkMarkDr=0
	FOR  Set DocLinkMarkDr=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,DocLinkMarkDr)) Quit:DocLinkMarkDr=""  Do
	.set ResDr=##class(web.DHCOPAdmReg).GetResRowIdStr(LocID,DocLinkMarkDr)
	.Q:ResDr=""
	.set SechDr=##class(web.DHCRBApptSchedule).GetAvailRA(ResDr,+$h,0,TimeRangeDr)
	.set SpecFlag=$p(^CTPCP(DocLinkMarkDr,1),"^",16)
	.if (SechDr'="")&(CurrMark="") set CurrMark=DocLinkMarkDr
	.if (SechDr'="")&(SpecFlag="Y") set CurrMark=DocLinkMarkDr
	
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	Set Singleflag=0
	If ($g(PatientNo)'="") Do
		.Set Singleflag=1
		.Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
		.Quit:$g(PAPMI)=""
		.Do OutOPPAAdm
	If ($g(SurName)'="")&($g(PatientNo)="") Do
		.Set Singleflag=1
		.Set name=SurName
		.Set name0=name
		.Set PAPMI=0
		.For  Set PAPMI=$O(^PAPERi("PAPER_PatName",SurName,PAPMI)) Quit:PAPMI=""  Do
		..Do OutOPPAAdm
		.Set Qflag="N"
		.For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		..If $l(name),$e(name0,1,$l(name))'[name Set Qflag="Y" Quit
		..Set PAPMI=0
		..For  Set PAPMI=$O(^PAPERi("PAPER_PatName",name0,PAPMI)) Quit:PAPMI=""  Do
		...Do OutOPPAAdm
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Kill ^TMP("DHCDocWorkBenchArr",$j)
	Quit:Singleflag=1 $$$OK

	b ;2
	If (RegQue="on") Do
	.Do OutOPPAPMINew1
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:(RegQue="on") $$$OK
	
	If ($g(RegQue1)="on") Do 
	.Do OutOPPAPMINew
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	.d SetArrivePatList
	.Set qHandle=$lb(0,repid,0)
	Quit:($g(RegQue1)="on") $$$OK
	
	If (ArrivedQue="on")	Do 
	.Do OutOPArrived
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBenchArr",$j,L1),-1) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("DHCDocWorkBenchArr",$j,L1,L2)) Quit:L2=""  Do
	...Set L3=""
	...for  Set L3=$O(^TMP("DHCDocWorkBenchArr",$j,L1,L2,L3)) Quit:L3=""  do
	....Set L4=""
	....for  Set L4=$O(^TMP("DHCDocWorkBenchArr",$j,L1,L2,L3,L4)) Quit:L4=""  do
	.....Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBenchArr",$j,L1,L2,L3,L4)
	.....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBenchArr",$j)
	Quit:ArrivedQue="on" $$$OK
	
	//OutOPConsultation
	If (Consultation="on")	Do 
	.Do OutOPConsultation
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Consultation="on" $$$OK
	
	;报到
	If (Report="on") Do 
	.Do OutOPReport
	.Set ind=1
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Report="on" $$$OK
	
	//对无分诊的诊区如何处理!!
	//不做医生号别对照的专家号做如下判断
	//Set QutFlag="Y"
	
	//&SQL(select ID into :QutFlag from DHCDepMark where DepmDepDr=:LocID and DepmMarkDr= :DocId)
	//
	//Quit:QutFlag="" $$$OK

	//
	/*Set RoomDr="",DocConsultArea=""
	Set RoomDr=..GetDocConsultRoom()

	If RoomDr="" Set qHandle=$lb(0,repid,0) Kill ^TMP("DHCDocWorkBench",$j) Quit $$$OK
	&SQL(select BorDr INTO :DocConsultArea FROM DHCBorExaRoom WHERE BorExaRoomDr=:RoomDr)
	If DocConsultArea="" Set qHandle=$lb(0,repid,0) Kill ^TMP("DHCDocWorkBench",$j) Quit $$$OK
	//---------------------------------------------------------------------
	//---------------------------------------------------------------------
	*/
	;Set ^SMLPara=LocID_"^"_UserID_"^"_DocId_"^"_RoomDr_"^"_DocConsultArea
	Set QueDr=0
	For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.Set QuitFlag=0
	.Set QueConsultArea=QueObj.QueExabDrGetObjectId()
	.//If QueConsultArea'=DocConsultArea Set QuitFlag=1
	.Set QueMark=QueObj.QueMarkDrGetObjectId()
	.;Set:((QueMark'=CurrMark)&(QueMark'=DocId)) QuitFlag=1     2009-02-15
	.Set QueStatus=QueObj.QueStateDr.PersName
	.If (QueStatus="到达")&(AllPatient'="on") Set QuitFlag=1
	.If QueStatus="退号" Set QuitFlag=1
	.If QueStatus="报到" Set QuitFlag=1
	.//If QueStatus="过号" Set QuitFlag=1
	.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	.Set QueConsultFlag=QueObj.QueConsultFlag
	.//set ^DHCAA(QueDr)=QueMark_"^"_QueStatus
	.If (PAAdm="")!('$D(^PAADM(PAAdm))) Set QuitFlag=1
	.Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	.//;判断是否医生号别对照,会诊病人
	.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	.quit:(DocAdmInclude="N")
	.If (PAAdm'="") do
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do 
	...//如果该号的出诊时段不在当前时段?该号不显示
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...if (HospitalCode="ZHSRMYY")&&(RegRangeTimeDr'=TimeRangeDr) Set QuitFlag=1
	.If (DocId'=QueObj.QueDocDrGetObjectId())&(QueObj.QueDocDrGetObjectId()'="") Set QuitFlag=1
	.Do QueObj.%Close()
	.Quit:QuitFlag=1
	.Do OutputRow(QueDr)
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
OutputRow(ParaQueDr)
	b //1
	Do ResetVariables
	b //4
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	Quit:'$d(^PAPER(PatientID))
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	.Set PAPMIAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PAPMIDOB,+$h)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	b //456
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	s PAAdmTimeGet=$P($g(^PAADM(PAAdm)),"^",7)
	Set PAAdmTime=..%ZT(PAAdmTimeGet,3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	If Loc'="" d
	.Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	.if ($f(PAAdmDepCodeDR,"-")'=0) set PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	Else  Set PAAdmDepCodeDR=""
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	s ArrivedDate="",ArrivedTime=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	i ParaQueDr'="" Set QueRowId=ParaQueDr
	e  Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set LocSeqNo=QueObj.QueNo
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	.Set Doc=QueObj.QueDocDrGetObjectId()
	.If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.Else  Set PAAdmDocCodeDR=""
	.Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	.Set PriorityCode=QueObj.QueFirstDr.FirstcCode
	.If PriorityCode="" Set PriorityCode="XX"
	.Set RegDocCode=""
	.Set RegDocDr=QueObj.QueMarkDrGetObjectId()
	.If RegDocDr'="" d
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	...set RegDoctor=RegDoctor_"("_$g(RegRangeTime)_")"
	..set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Set Called=QueObj.QueCompDr
	.set SortCalled=Called
	.IF Called="" SET SortCalled="X"
	.Set WalkStatus=QueObj.QueStateDr.PersShowName
	.Set StatusCode=QueObj.QueStateDr.PersCode
	.If StatusCode="" Set StatusCode="XX"
	.Set WalkStatus1=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	.If WalkStatus1'="" Set WalkStatus=$P(WalkStatus1,"^",2)
	.//到达日期，到达时间
	.i WalkStatus="到达" d
	..//s ArrivedDate=QueObj.QueStateDate,ArrivedTime=QueObj.QueStateTime
	..//i ArrivedDate'="" s ArrivedDate=$zd(ArrivedDate,3)
	..//i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	.Set ConsultRoom=QueObj.QueRoomDr.CTLOCDesc
	.//set ConsultRoom=QueObj.QueExabDr
	.Set ConsultArea=QueObj.QueExabDr.ExabName
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set SortCalled="X"
	.Set RegDocDr=""
	s AVSRowId=0
	f  s AVSRowId=$o(^DHCADMVisitStatus(0,"PAADM",PAAdm,AVSRowId)) q:AVSRowId=""  d
	.s AVSVisitStatus=$p(^DHCADMVisitStatus(AVSRowId),"^",2)
	.q:AVSVisitStatus'=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4("Arrival"),""))
	.s ArrivedDate=$p(^DHCADMVisitStatus(AVSRowId),"^",8)
	.s ArrivedTime=$p(^DHCADMVisitStatus(AVSRowId),"^",9)
	i ArrivedDate'="" s ArrivedDate=..%ZD(ArrivedDate) //$zd(ArrivedDate,3)
	i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	//
	Set Count=Count+1
	Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	If (ArrivedQue="on")  d
	.;s Arrtime=$$GetLastArriveTime(EpisodeID) ;按照到达时间排
	.s Arrtime=PAAdmTimeGet ;按照就诊时间排
	.Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(PAAdmDate)_$G(Arrtime)
	s cddesc=""
	S Totalmoney=""
	s patrecdrowid="" f  s patrecdrowid=$o(^DHCDOCRELEPATCCPi(0,"PAPMIDR",PatientID,patrecdrowid)) q:patrecdrowid=""  d
	 .S inuseflag=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",3)
	 .q:inuseflag="N" 
	 .s cdrowid=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",1)
	 .S cddesc=$p($g(^DHCCD(cdrowid)),"^",2)
	 .s Money=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",7)
	 .s Patcdinfo=cddesc_": "_Money_"||"_Patcdinfo
	 .s Totalmoney=Money+$g(Totalmoney) 
		//电话
	s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	if PatTelNo="" s PatTelNo=PatMobil
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,Patcdinfo,Totalmoney,PatTelNo)
 	//set SortLable=$P($g(^PAADM(PAAdm)),"^",6)_$P($g(^PAADM(PAAdm)),"^",7)
	s EMPatLev=""
	Set:((LgHospID'="")&&(LgGroupID'="")) EMPatLev=##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(PAAdm,PatientID,LgHospID,LocID,UserID,LgGroupID)
 	Set Priority=$P($g(^PAADM(PAAdm)),"^",33)
 	s PriorityColor=""
	If Priority'="" Set PAAdmPriority=$P($G(^CT("ACU",Priority)),"^",2),PriorityCode=+$P($G(^CT("ACU",Priority)),"^",1),PriorityColor=$P($G(^CT("ACU",Priority)),"^",11)
	Else  Set PAAdmPriority="",PriorityCode="999"
 	Set SortLable=$G(PriorityCode)_"$"_$g(EMPatLev)_"$"_$G(RegDocCode)_"$"_$G(SortCalled)_"$"_$G(StatusCode)_"$"_$G(RegRangeTimeDr)_"$"_$G(SeqNo)
 	//set SortLable=Seq
 	//set SortLable=$tr(SortLable,"+","Z")
	Set ^TMP("DHCDocWorkBench",$j,SortLable,Count)=Data
	s ^tempscl("DHCDocWorkBench",$j,SortLable,Count)=Data
    Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	Quit
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,Patcdinfo,Totalmoey)=""
	Quit
OutputRowArrive(ParaQueDr)
	b //3
	///用于到达的排序
	Do ResetVariables
	b //5
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	Quit:'$d(^PAPER(PatientID))
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.;Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	.Set PAPMIAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PAPMIDOB,+$h)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	s PAAdmTimeGet=$P($g(^PAADM(PAAdm)),"^",7)
	Set PAAdmTime=..%ZT(PAAdmTimeGet,3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	If Loc'="" d
	.Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	.if ($f(PAAdmDepCodeDR,"-")'=0) set PAAdmDepCodeDR=$p(PAAdmDepCodeDR,"-",2)
	Else  Set PAAdmDepCodeDR=""
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	s ArrivedDate="",ArrivedTime=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	i ParaQueDr'="" Set QueRowId=ParaQueDr
	e  Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set LocSeqNo=QueObj.QueNo
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	.Set Doc=QueObj.QueDocDrGetObjectId()
	.If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.Else  Set PAAdmDocCodeDR=""
	.Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	.Set PriorityCode=QueObj.QueFirstDr.FirstcCode
	.If PriorityCode="" Set PriorityCode="XX"
	.Set RegDocCode=""
	.Set RegDocDr=QueObj.QueMarkDrGetObjectId()
	.If RegDocDr'="" d
	..Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..s RegRangeTime=""
	..if RegfeeDr'="" do
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	...set RegDoctor=RegDoctor_"("_$g(RegRangeTime)_")"
	..else  s RegRangeTime=""
	..set RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Set Called=QueObj.QueCompDr
	.set SortCalled=Called
	.IF Called="" SET SortCalled="X"
	.Set WalkStatus=QueObj.QueStateDr.PersName
	.Set StatusCode=QueObj.QueStateDr.PersCode
	.If StatusCode="" Set StatusCode="XX"
	.Set WalkStatus1=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	.If WalkStatus1'="" Set WalkStatus=$P(WalkStatus1,"^",2)
	.//到达日期，到达时间
	.i WalkStatus="到达" d
	..//s ArrivedDate=QueObj.QueStateDate,ArrivedTime=QueObj.QueStateTime
	..//i ArrivedDate'="" s ArrivedDate=$zd(ArrivedDate,3)
	..//i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	.Set ConsultRoom=QueObj.QueRoomDr.CTLOCDesc
	.//set ConsultRoom=QueObj.QueExabDr
	.Set ConsultArea=QueObj.QueExabDr.ExabName
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set SortCalled="X"
	.Set RegDocDr=""
	s AVSRowId=0
	f  s AVSRowId=$o(^DHCADMVisitStatus(0,"PAADM",PAAdm,AVSRowId)) q:AVSRowId=""  d
	.s AVSVisitStatus=$p(^DHCADMVisitStatus(AVSRowId),"^",2)
	.q:AVSVisitStatus'=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4("Arrival"),""))
	.s ArrivedDate=$p(^DHCADMVisitStatus(AVSRowId),"^",8)
	.s ArrivedTime=$p(^DHCADMVisitStatus(AVSRowId),"^",9)
	i ArrivedDate'="" s ArrivedDate=..%ZD(ArrivedDate) //$zd(ArrivedDate,3)
	i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	//
	Set Count=Count+1
	set SeqNoConfig=""
	if (LgGroupID'=""){
		s SeqNoConfig=..%GetConfig1("OutPatListArrive",LgGroupID,LgHospID)
	}
	if SeqNoConfig="2"{
		s Arrtime=PAAdmTimeGet ;按照就诊时间排
		Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(PAAdmDate)_$G(Arrtime)
	}else{
		Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	}
	/*Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	If (ArrivedQue="on")  d
	.;s Arrtime=$$GetLastArriveTime(EpisodeID) ;按照到达时间排
	.s Arrtime=PAAdmTimeGet ;按照就诊时间排
	.Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(PAAdmDate)_$G(Arrtime)
	*/
	s cddesc=""
	S Totalmoney=""
	s patrecdrowid="" f  s patrecdrowid=$o(^DHCDOCRELEPATCCPi(0,"PAPMIDR",PatientID,patrecdrowid)) q:patrecdrowid=""  d
	 .S inuseflag=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",3)
	 .q:inuseflag="N" 
	 .s cdrowid=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",1)
	 .S cddesc=$p($g(^DHCCD(cdrowid)),"^",2)
	 .s Money=$p(^DHCDOCRELEPATCCP(patrecdrowid),"^",7)
	 .s Patcdinfo=cddesc_": "_Money_"||"_Patcdinfo
	 .s Totalmoney=Money+$g(Totalmoney) 
	//电话
	s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	if PatTelNo="" s PatTelNo=PatMobil
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,Patcdinfo,Totalmoney,PatTelNo)
 	//set SortLable=$P($g(^PAADM(PAAdm)),"^",6)_$P($g(^PAADM(PAAdm)),"^",7)
 	set SortLable=Seq
 	set SortLable=$tr(SortLable,"+","Z")
 	Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
 	Set TRId=RegRangeTimeDr
 	if TRId="" s TRId=0
 	Set seqno=LocSeqNo
 	if seqno="" s seqno=0
 	
	Set ^TMP("DHCDocWorkBenchArr",$j,AdmDate,TRId,seqno,EpisodeID)=Data
 	//Set ^CacheTemp(repid,ind)=Data
	Quit	
OutOPPAPMI
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time)) Quit:Time=""  Do
	..Quit:(ResultFlag=1)&&(Date+1=(+$h))&&(Time<..%SysTime())
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...Quit:QueRowId=""
	...Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	...Set QueDoc=QueObj.QueDocDrGetObjectId()
	...Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	...Set StatusName=QueObj.QueStateDr.PersName
	...//--------add gsb 复诊可以查询
	...s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	...quit:(DocAdmInclude="N")
	
	...//-----------------------------------------
	...Do QueObj.%Close()
	...Q:(MarkID'="")&&(MarkID'=MarkDoc)
	...Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")) 
	...Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	...;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId)) //有对照和没有对照都考虑在内  2009-03-25 gry
	...Do OutputRow
	Quit
	
OutOPConsultation
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set QueRowId1=0
	.For  Set QueRowId1=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId1)) Quit:QueRowId1=""  Do
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId1)
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag'="Y"
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..quit:VisitStatus'="A"
	..;如果会诊和报到同时勾选，则默认取报到的会诊记录
	..Quit:(Report="on")&&(StatusName'="报到")
	..Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	..If WalkStatus'="" Set StatusName=$P(WalkStatus,"^",2)
	
	..;会诊病人控制队列状态和未就诊一致
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号"))&&(Report'="on")
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..Do OutputRow(QueRowId1)
	Quit
	;
OutOPPAPMINew
    b ;new
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If StartDate=..%SysDate() {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	;s UserJob="61765"_$J_"6"
	k ^TempOutDoc(UserJob)
	/*
	For Date=StartDate:1:EndDate Do
	.Set Time=0
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time)) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","O",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	*/
	For Date=StartDate:1:EndDate Do
	.s QueRowId=0
	.For  Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId)) Quit:QueRowId=""  Do
	..;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	..;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	..;Quit:QueRowId=""
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	..Quit:'$IsObject(QueObj)
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag="Y"
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Q:(MarkID'="")&&(MarkID'=MarkDoc)
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	..Set CalledFlag=QueObj.QueCompDr
	..i CalledFlag'="" s StatusName="正在呼叫"
	..Set SeqNo=""
	..Set LocSeqNo=QueObj.QueNo
	..If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	..If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	..If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	..If $L(LocSeqNo)=0 Set SeqNo="999"
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...s RegRangeTime=""
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	..e  Set RegRangeTime=""
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..s AdmTime=$p($g(^PAADM(PAAdm)),"^",7)
	..Quit:(ResultFlag=1)&&(Date+1=(+$h))&&(AdmTime<..%SysTime())
	..quit:VisitStatus'="A"
	..b ;StatusName
	..Quit:'((StatusName="等候")!(StatusName="复诊")!(StatusName="过号")!(StatusName="正在呼叫")) 
	..b ;QueDoc  DocId
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..//有对照和没有对照都考虑在内  2009-03-25 gry
    ..;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId))
	..i $d(^TempOutDoc(UserJob,PAAdmPriority,StatusName))=0 s TempIndex=1
	..e  s TempIndex=+$o(^TempOutDoc(UserJob,PAAdmPriority,StatusName,""),-1)+1
	..s ^TempOutDoc(UserJob,PAAdmPriority,StatusName,TempIndex)=PAAdm
	..i (StatusName="等候") d
	...Set SeqNo=RegRangeTime_SeqNo
	...s ^TempOutDoc(UserJob,PAAdmPriority,"等候排序",SeqNo,TempIndex)=PAAdm
	..i (StatusName="复诊") d
	...i $G(^DHCDocAgain(+$H,QueRowId))="" s ^DHCDocAgain(+$H,QueRowId)=..%SysTime()
	...s ^TempOutDoc(UserJob,PAAdmPriority,"复诊排序",$G(^DHCDocAgain(+$H,QueRowId)),TempIndex)=PAAdm

	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","等候",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))

	s NewTempIndex=0
	s AgainTime=""
	f  s AgainTime=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime)) q:AgainTime=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","复诊",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))
	
	set TempQty=0
	s ifCalled=0
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)
	.s ifCalled=1
	s StatusId=0
	f  s StatusId=$o(^TempOutDoc(UserJob,"优先",StatusId)) q:StatusId=""  d
	.q:StatusId="正在呼叫"
	.s TempIndex=""
	.f  s TempIndex=$o(^TempOutDoc(UserJob,"优先",StatusId,TempIndex)) q:TempIndex=""  d
	..s TempQty=TempQty+1
	..Q:$G(^TempOutDoc(UserJob,"优先",StatusId,TempIndex))=""
	..s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先",StatusId,TempIndex)
	
	s DHQty=+$o(^TempOutDoc(UserJob,"正常","等候",""),-1)
	s FZQty=+$o(^TempOutDoc(UserJob,"正常","复诊",""),-1)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	
	i '$D(^DHCDocCall(+$h,UserID)) s TestQty=1
	e  s TestQty=+$g(^DHCDocCall(+$h,UserID))+ifCalled
	s TestQty=TestQty#2
	i DHQty="" d
	.i FZQty="" d
	..
	.e  d
	..f FZRowId=1:1:FZQty q:FZRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	e  d
	.i FZQty="" d
	..f DHRowId=1:1:DHQty q:DHRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.e  d
	..i FZQty>DHQty d
	...f DHRowId=1:1:DHQty q:DHRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	...f DHRowId=DHQty+1:1:FZQty q:DHRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	..e  d
	...f FZRowId=1:1:FZQty q:FZRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	...f FZRowId=FZQty+1:1:DHQty q:FZRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	s GHRowId=0
	f  s GHRowId=$o(^TempOutDoc(UserJob,"正常","过号",GHRowId)) q:GHRowId=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","过号",GHRowId)
	
	f PXRowId=1:1:TempQty q:PXRowId=""  d
	.q:$G(^TempOutDoc(UserJob,"OutPut",PXRowId))=""
	.s PAAdm=^TempOutDoc(UserJob,"OutPut",PXRowId)
	.Do OutputRow("")
	k ^TempOutDoc(UserJob)
	Quit
	;
	;weijiuzhen
OutOPPAPMINew1
    b ;new
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If StartDate=..%SysDate() {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If EndDate="" Set EndDate=..%SysDate()
	s UserJob=StartDate_$J_UserID
	k ^TempOutDoc(UserJob)
	
	For Date=StartDate:1:EndDate Do
	.s QueRowId=0
	.For  Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,LocID,QueRowId)) Quit:QueRowId=""  Do
	..;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	..;Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	..;Quit:QueRowId=""
	..Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	..Quit:'$IsObject(QueObj)
	..Set QueConsultFlag=QueObj.QueConsultFlag
	..quit:QueConsultFlag="Y"
	..Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	..Set QueDoc=QueObj.QueDocDrGetObjectId()
	..Set MarkDoc=QueObj.QueMarkDrGetObjectId()
	..Q:(MarkID'="")&&(MarkID'=MarkDoc)
	..Set StatusName=QueObj.QueStateDr.PersName
	..Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	..Set CalledFlag=QueObj.QueCompDr
	..i CalledFlag'="" s StatusName="正在呼叫"
	..Set SeqNo=""
	..Set LocSeqNo=QueObj.QueNo
	..If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	..If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	..If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	..If $L(LocSeqNo)=0 Set SeqNo="999"
	..set RegfeeDr=""
	..Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	..if RegfeeDr'="" do
	...s RegRangeTime=""
	...set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
	...i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	..e  Set RegRangeTime=""
	..s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	..quit:(DocAdmInclude="N")
	..Do QueObj.%Close()
	..s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	..s AdmTime=$p($g(^PAADM(PAAdm)),"^",7)
	..Quit:(ResultFlag=1)&&(Date+1=(+$h))&&(AdmTime<..%SysTime())
	..quit:VisitStatus'="A"
	..Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	..If WalkStatus'="" Set StatusName=$P(WalkStatus,"^",2)
	..b ;StatusName
	..Quit:'((StatusName="等候")!(StatusName="过号")!(StatusName="正在呼叫")!(StatusName="复诊")!(StatusName="抢救")) 
	..b ;QueDoc  DocId
	..Quit:(((QueDoc'="")&(QueDoc'=DocId)))
	..//有对照和没有对照都考虑在内  2009-03-25 gry
    ..;Quit:((MarkDoc'=CurrMark)&(MarkDoc'=DocId))
	..i $d(^TempOutDoc(UserJob,PAAdmPriority,StatusName))=0 s TempIndex=1
	..e  s TempIndex=+$o(^TempOutDoc(UserJob,PAAdmPriority,StatusName,""),-1)+1
	..s ^TempOutDoc(UserJob,PAAdmPriority,StatusName,TempIndex)=PAAdm
	..i (StatusName="等候") d
	...Set SeqNo=RegRangeTime_SeqNo
	...s ^TempOutDoc(UserJob,PAAdmPriority,"等候排序",SeqNo,TempIndex)=PAAdm
	..i (StatusName="复诊") d
	...i $G(^DHCDocAgain(+$H,QueRowId))="" s ^DHCDocAgain(+$H,QueRowId)=..%SysTime()
	...s ^TempOutDoc(UserJob,PAAdmPriority,"复诊排序",$G(^DHCDocAgain(+$H,QueRowId)),TempIndex)=PAAdm
	b ;;;3
	s NewTempIndex=0
	s SeqNo=""
	f  s SeqNo=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo)) q:SeqNo=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","等候",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","等候排序",SeqNo,TempIndex))

	s NewTempIndex=0
	s AgainTime=""
	f  s AgainTime=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime)) q:AgainTime=""  d
	.s TempIndex=""
	.f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex)) q:TempIndex=""  d
	..q:$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))=""
	..s NewTempIndex=NewTempIndex+1
	..s ^TempOutDoc(UserJob,"正常","复诊",NewTempIndex)=$G(^TempOutDoc(UserJob,"正常","复诊排序",AgainTime,TempIndex))
	
	set TempQty=0
	s ifCalled=0
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先","正在呼叫",TempIndex)
	s TempIndex=""
	f  s TempIndex=$O(^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)) q:TempIndex=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","正在呼叫",TempIndex)
	.s ifCalled=1
	s StatusId=0
	f  s StatusId=$o(^TempOutDoc(UserJob,"优先",StatusId)) q:StatusId=""  d
	.q:StatusId="正在呼叫"
	.s TempIndex=""
	.f  s TempIndex=$o(^TempOutDoc(UserJob,"优先",StatusId,TempIndex)) q:TempIndex=""  d
	..s TempQty=TempQty+1
	..Q:$G(^TempOutDoc(UserJob,"优先",StatusId,TempIndex))=""
	..s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"优先",StatusId,TempIndex)
	
	
	s GHRowId=0
	f  s GHRowId=$o(^TempOutDoc(UserJob,"正常","抢救",GHRowId)) q:GHRowId=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","抢救",GHRowId)
	
	
	s DHQty=+$o(^TempOutDoc(UserJob,"正常","等候",""),-1)
	s FZQty=+$o(^TempOutDoc(UserJob,"正常","复诊",""),-1)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	;s UserID=6
	i '$D(^DHCDocCall(+$h,UserID)) s TestQty=1
	e  s TestQty=+$g(^DHCDocCall(+$h,UserID))+ifCalled
	s TestQty=TestQty#2
	i DHQty="" d
	.i FZQty="" d
	..
	.e  d
	..f FZRowId=1:1:FZQty q:FZRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	e  d
	.i FZQty="" d
	..f DHRowId=1:1:DHQty q:DHRowId=""  d
	...s TempQty=TempQty+1
	...s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.e  d
	..i FZQty>DHQty d
	...f DHRowId=1:1:DHQty q:DHRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",DHRowId)
	...f DHRowId=DHQty+1:1:FZQty q:DHRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",DHRowId)
	..e  d
	...f FZRowId=1:1:FZQty q:FZRowId=""  d
	....i TestQty=1 d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	....e  d
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","复诊",FZRowId)
	.....s TempQty=TempQty+1
	.....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	...f FZRowId=FZQty+1:1:DHQty q:FZRowId=""  d
	....s TempQty=TempQty+1
	....s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","等候",FZRowId)
	s GHRowId=0
	f  s GHRowId=$o(^TempOutDoc(UserJob,"正常","过号",GHRowId)) q:GHRowId=""  d
	.s TempQty=TempQty+1
	.s ^TempOutDoc(UserJob,"OutPut",TempQty)=^TempOutDoc(UserJob,"正常","过号",GHRowId)
	
	f PXRowId=1:1:TempQty q:PXRowId=""  d
	.q:$G(^TempOutDoc(UserJob,"OutPut",PXRowId))=""
	.s PAAdm=^TempOutDoc(UserJob,"OutPut",PXRowId)
	.Do OutputRow("")
	k ^TempOutDoc(UserJob)
	Quit
	;
OutOPArrived
	Set ArriveCount=0
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If StartDate=..%SysDate() {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	i EndDate="" s EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time),-1) Quit:Time=""  Do
	..Quit:(ResultFlag=1)&&(Date+1=(+$h))&&(Time<..%SysTime())
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm,1)),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm,1)),"^",11)
	...Set PatQueState=""
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....Q:(MarkID'="")&&(QueMarkId'=MarkID)
	....s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	....quit:(DocAdmInclude="N")
	....Quit:(QueDocId'=DocId)
	....;对于到达来说,只要到达医生是登陆医生即需要显示
	....;Q:(MarkID'="")&&(MarkID'=QueMarkId)
	....Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	....If WalkStatus'="" Set StatusName=$P(WalkStatus,"^",2)
	....If StatusName="到达" Set PatQueState="A"
	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...Do OutputRowArrive(QueRowId)
	...s ArriveCount=ArriveCount+1
	Quit
	;
OutOPPAAdm
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If StartDate=..%SysDate() {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If EndDate="" Set EndDate=..%SysDate()
	Set PAAdm=0
	For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM","E",PAAdm)) Quit:PAAdm=""  Do
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)&&(%session.Get("LOGON.GROUPID")'=21)
	.s AdmTime=$p($g(^PAADM(PAAdm)),"^",7)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(ResultFlag=1)&&(AdmDate+1=(+$h))&&(AdmTime<..%SysTime())
	
	.Quit:(AdmDate<StartDate)!(AdmDate>EndDate)
	.s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	.Quit:AdmVisitStatus="C"
	.s QueStateDr="",StateCode=""
	.;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,0))
	.Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.if QueStateDr'="" Set StateCode=$List(^User.DHCPerStateD(QueStateDr),2)
	.Q:(StateCode="07")&&(Report'="on")
	.Do OutputRow(QueRowId)
	Quit
	;
OutOPReport
	If StartDate="" {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If StartDate=..%SysDate() {
		Set StartDate=..%SysDate()-1
		s ResultFlag=1
	}
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...s AdmTime=$p($g(^PAADM(PAAdm)),"^",7)
	...Quit:(ResultFlag=1)&&(Date+1=(+$h))&&(AdmTime<..%SysTime())
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm,1)),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm,1)),"^",11)
	...Set PatQueState=""
	...;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...Set QueRowId=..GetQueRowidByMore(PAAdm,DocId)
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
	....quit:(DocAdmInclude="N")
	....Quit:(QueDocId'=DocId)&&(QueDocId'="")
	....Q:(MarkID'="")&&(MarkID'=QueMarkId)
	....If StatusName="报到" Set PatQueState="B"
	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...Do OutputRow(QueRowId)
	Quit
error
     set ^Temp("FindLoccurrentAdm","error")=$ze
GetLastArriveTime(EpisodeID)
	;获取最后一次到达时间
	s QueLastArriveTime=""
	s QueIDPAADM=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,0))
	s QueCahngeSub=""
	f  s QueCahngeSub=$O(^DHCQueueStatus(QueIDPAADM,QueCahngeSub),-1) Q:(QueCahngeSub="")||(QueLastArriveTime'="")  d
	.s LastStatuDr=$P($G(^DHCQueueStatus(QueIDPAADM,QueCahngeSub)),"^",4)
	.Q:LastStatuDr=""
	.s LastStateDesc=$list(^User.DHCPerStateD(LastStatuDr),4)
	.if LastStateDesc="到达"
	.s QueLastArriveTime=$P($G(^DHCQueueStatus(QueIDPAADM,QueCahngeSub)),"^",2)
	q QueLastArriveTime
SetArrivePatList
    s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)=""
	s LocSeqNo="已看病人:"
	s ArriveFlagRowInd=ind
	Set ^CacheTemp(repid,ind)=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)
 	set ind=ind+1
	Do OutOPArrived
	
	;赋值已看病人数
	Set $List(^CacheTemp(repid,ArriveFlagRowInd),28)=$ListGet(^CacheTemp(repid,ArriveFlagRowInd),28)_$g(ArriveCount)_"人"
	/*
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1
	..Set ^gry("xh",ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	*/
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	quit
}

ClassMethod FindLocDocCurrentAdmEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmEExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

// ,Patcdinfo,Totalmoey,PatTelNo:%String

/// LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String
Query FindLocDocCurrentAdmE(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String,TSecretLevel:%String,RegRangeTime:%String")
{
}

/// w ##class(web.DHCDocOutPatientList).SendCallInfoTest(1320)
ClassMethod SendCallInfoTest(UserId As %String)
{
	///调用叫号公司提供的webservice
	Set DocRowid=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Quit:DocRowid="" "-1^医生不存在"
	Set DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	Set CallServiceObj=##class(DHCDocCallService.HtOutpIndexManagerPort).%New()
	Set ret=CallServiceObj.callNext(DocCode)   //ret 为json串的格式
	///只需要 flag   visitNo
	//b ;434
	Set retFlag=$p($p(ret,"""flag"":",2),",",1)
	if retFlag="false"{
		Quit "-1^呼叫病人失败"	
	}
	Set AdmRowid=$p($p(ret,"""visitNo"":",2),",",1)
	if AdmRowid=""{
		//Quit "-1^没有需要呼叫的病人信息"_ret
		Quit "-1^没有需要呼叫的病人信息"
	}
	Set retStr=""
	s updateStatusFlag = ##Class(web.DHCDocOutPatientList).SetCallStatus(AdmRowid,DocRowid)
	if AdmRowid'=""	s ^tempupdateStatusFlag(AdmRowid)=updateStatusFlag
	//q:updateStatusFlag'=1 "-1^更新队列状态失败!"_ret
	Set PatientId=$p(^PAADM(AdmRowid),"^",1)
	Set PatietnNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
	Set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
	Set QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	Set SeqNo="",QueStatDesc=""
	if QueRowId'=""{
		Set SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
		Set QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
		Set QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	}
	if QueStatDesc="复诊"{
		 s retStr="正在呼叫复诊"_" "_SeqNo_"号"_" "_PatName
	}else{
		s retStr="正在呼叫"_" "_SeqNo_"号"_" "_PatName	
	}
	Quit 0_"^"_retStr
}

/// w ##class(web.DHCDocOutPatientList).SendReCallInfoTest(1320)
ClassMethod SendReCallInfoTest(UserId As %String)
{
	///调用叫号公司提供的webservice
	Set DocRowid=$p($g(^SSU("SSUSR",UserId)),"^",14)
	Quit:DocRowid="" "-1^医生不存在"
	Set DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	Set CallServiceObj=##class(DHCDocCallService.HtOutpIndexManagerPort).%New()
	Set ret=CallServiceObj.recall(DocCode)   //ret 为json串的格式
	Set retFlag=$p($p(ret,"""flag"":",2),",",1)
	Set AdmRowid=$p($p(ret,"""visitNo"":",2),",",1)
	if AdmRowid=""{
		//Quit "-1^没有需要呼叫的病人信息"_ret
		Quit "-1^没有需要呼叫的病人信息"
	}
	
	if retFlag="false"{
		Quit "-1^重复呼叫病人失败"	
	}
	
	Set PatientId=$p(^PAADM(AdmRowid),"^",1)
	Set PatietnNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
	Set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
    Set QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	Set SeqNo="",QueStatDesc=""
	if QueRowId'=""{
		Set SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
		Set QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
		Set QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	}
	if QueStatDesc="复诊"{
		 s retStr="正在重复呼叫复诊"_" "_SeqNo_"号"_" "_PatName
	}else{
		s retStr="正在重复呼叫"_" "_SeqNo_"号"_" "_PatName	
	}
	Quit 0_"^"_retStr
}

/// //w ##Class(web.DHCDocOutPatientList).SetComplate(162,5,1259)
ClassMethod SetComplate(Adm As %String, LocId As %String, UserId As %String) As %String
{
    Set sc=0,sc1=1
    s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
    s ErrMsg=##class(web.DHCDocOutPatientList).CheckIsAdmissions(Adm,UserId,AdmHospitalId)
    Q:ErrMsg'="" "-1^"_ErrMsg
    s DocDr=$P(^SSU("SSUSR",UserId),"^",14)
    q:DocDr="" "-7^人员对照失败"
    Set QueConsultFlag="N"
    Set QueRowId=..GetQueRowidByMore(Adm,DocDr)
    if (QueRowId=""){
	s IsCESAdm=##Class(DHCDoc.Interface.StandAlone.Service).IsCESAdm(Adm)
        q:IsCESAdm'=1 "-1^无权操作此病人"
    }else{
	Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	Set Status=oref.QueStateDr.PersName
	Set StatusCode=oref.QueStateDr.PersCode
	Set QueDoc=oref.QueDocDrGetObjectId()
	Set PAAdmPriority=oref.QueFirstDr.FirstcName
	if (QueDoc'="")&(QueDoc'=DocDr){
	    q "-2^无权操作此病人"
	}
	Set QueStatus=oref.QueStateDr.PersName
	/*if (oref.QueEverCalled'="Y")&&(QueStatus="等候"){
	    Q "-1^没有呼叫过的病人,不能完成接诊"
	}*/
	//未报到是否可就诊
	Set ExabNoCheckinDocCanRecAdm=oref.QueExabDr.ExabNoCheckinDocCanRecAdm
	If (QueStatus="复诊")!(QueStatus="等候")!(QueStatus="过号")!((ExabNoCheckinDocCanRecAdm="Y")&&(StatusCode="07")) {
	    If QueDoc="" Do oref.QueDocDrSetObjectId(DocDr)
	    &sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='到达')
	    Do oref.QueStateDrSetObjectId(PerStateDr)
	    Set oref.QueCompDr=""
	    Set oref.QueStateDate=..%SysDate()
	    Set oref.QueStateTime=..%SysTime()
	    Do oref.OperuseridSetObjectId(UserId)
	    Set sc = oref.%Save()
	    ///会诊标准
	    Set QueConsultFlag=oref.QueConsultFlag
	    If $$$ISERR(sc) {
		    Do oref.%Close()
	    	q "-2^保存数据失败"
	    }
	    i $G(UserId)="" s UserId=%session.Get("LOGON.USERID")
		i (UserId'="")&&($G(PAAdmPriority)'="优先") d
		.if $g(^DHCDocCall(+$h,UserId,"Frist"))=Adm d
		..s ^DHCDocSetArrive(UserId,+$H,"Arrive")=^DHCDocOutPatientList("WartInd",Adm)
	}
	Do oref.%Close()
    }
    if QueConsultFlag'="Y" {
	  Set sc1=..SetAdmDocId(Adm,DocDr,LocId,UserId)
	  If 'sc1 Set sc1=1
    }
    
    &SQL(UPDATE SQLUSER.PA_Adm Set PAADM_Completed="Y" Where PAADM_RowId = :Adm)
    Q SQLCODE
    //q "0^成功"
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","Findadmquery","308","1357","到达","")
Query Findadmquery(LocID As %String, UserID As %String, Type As %String = "", IPAddress As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,Status:%String,SeqNum:%String,PatName:%String,PatientID:%String,RegRangeTime:%String,QueCompDr:%String")
{
}

ClassMethod FindadmqueryExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, Type As %String = "", IPAddress As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^DTempD(UserID,$h)=LocID_"*"_UserID_"*"_Type_"*"_IPAddress
 	k ^TempFindadmlistquery
 	k ^TempFindadmlistquerYX
 	k ^temdenghoulist
 	i IPAddress="" d
    s IPAddress=$$upper^SSUTIL4(IPAddress)
    s Callindex=0
	s EmercncyTyperowid=""
	 set EmercncyTyperowid=$o(^PAC("ADMLOC",0,"AdmType","E",LocID,""))  //急诊查找24小时
    if (EmercncyTyperowid=""){
	 	Set QueDr=0
	 	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
		For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
		.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
		.Set QueMark=QueObj.QueMarkDrGetObjectId()
		.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
		.Set QueStatus=QueObj.QueStateDr.PersName
		.set FisrtDr=QueObj.QueFirstDr.FirstcName
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.i FisrtDr="优先"  s ^TempFindadmlistquerYX(QueStatus,QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="过号"  s ^TempFindadmlistquery(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="等候" d
		..;当前未被指定医生且号别为当前登录医生
		..i ((QueMark'=DocId)&&(QueDocDr="")) s ^temdenghoulist(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.q:QueStatus="等候"
		.q:QueStatus="回诊"
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.q:((QueMark'=DocId)&&(QueDocDr'=DocId))
		.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
		.q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
		.q:((QueMark'=DocId)&&(QueDocDr=""))
		.Quit:(Type'="")&&(QueStatus'=Type)
		.;b
		.s EpisodeID=PAAdm
		.Set PatientID=$P(^PAADM(PAAdm),"^",1)
		.s SortSeqNoStr=..GetAdmSortSeqNo(PAAdm)
		.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
		.s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
		.s SeqNum=ShowSeqNo
		.;s SeqNum=ind
		.s QueCompDr=QueObj.QueCompDr
		.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
		.s Status=QueStatus
	    .do OutputRow56
	    if (Type="等候") {
		    s seqfist=2
		    s QueDr=0
		    s frist=2
		    s guohao=1
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.//b ;999
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先"  s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.s QuitFlag=0
			.i $g(^DHCDocLocalSysP("OPDoc.OutPatList.ShowPTDep"))[("^"_LocID_"^") d
			..i (Include="") s QuitFlag=1
			..;i (Include="") d
			...;i QueDocDr="" s QuitFlag=1
			..e  i ((QueDocDr'="")&&(QueDocDr'=DocId)) s QuitFlag=1
			.e  d
			..i (QueDocDr="") d
			...i QueMark'=DocId s QuitFlag=1
			..e  d
			...i (QueDocDr'=DocId) s QuitFlag=1
			.q:QuitFlag=1
			.;实名号在前,非实名号排在后面
			.i QueMark=DocId s seqfist=1
			.e  s seqfist=2
		    .Set PAAdm=QueObj.QuePaadmDrGetObjectId()
		    .Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.Set QueStatus=QueObj.QueStateDr.PersName
			.;b ;556
			.Quit:(Type'="")&&(QueStatus'=Type)
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.s SeqNum=QueObj.QueNo
			.s SeqNew=SeqNum
			.;i $g(^DHCAllocTimeOut(PAAdm))=1 s SeqNum=SeqNum+5
			.s QueCompDr=QueObj.QueCompDr
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.//b ;556
			.i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
			.;实名号计算违约序号,非实名号取指定医生时产生的就诊排队序号,需按8位数排序
			.s SortSeqNoStr=..GetAdmSortSeqNo(EpisodeID)
			.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
			.s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
			.s SeqNum=ShowSeqNo
		    .do OutputRow56
		    
		    ;输出过号记录
		    s seqfist=2
		    s frist=2
		    s QueID="" f  s QueID=$o(^TempFindadmlistquery(QueID))  q:QueID=""  d
		    .s QueMark=$p(^TempFindadmlistquery(QueID),"^",1)
		    .s PAAdm=$p(^TempFindadmlistquery(QueID),"^",2)
		    .s QueStatus=$p(^TempFindadmlistquery(QueID),"^",3)
		    .Set QueObj=##Class(User.DHCQueue).%OpenId(QueID)
			.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			.quit:(DocAdmInclude="N")
		    .s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.s SeqNum=QueObj.QueNo
			.s QueCompDr=QueObj.QueCompDr
			.s guohao=2
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.;实名号计算违约序号,非实名号取指定医生时产生的就诊排队序号,需按8位数排序
			.s SortSeqNoStr=..GetAdmSortSeqNo(EpisodeID)
			.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
			.s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
			.s SeqNum=ShowSeqNo
			.d OutputRow56
		    }
	     if (Type="回诊") {
		    s QueDr=""
		    s frist=2
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先" s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.q:((QueMark'=DocId)&&(QueDocDr'=DocId))
			.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
			.q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
		    .Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			.Set QueStatus=QueObj.QueStateDr.PersName
			.Quit:(Type'="")&&(QueStatus'=Type)
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.s SeqNum=QueObj.QueNo
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.s Updatetime=QueObj.QueStateTime
			.s QueCompDr=QueObj.QueCompDr
		    .i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
		    .;实名号计算违约序号,非实名号取指定医生时产生的就诊排队序号,需按8位数排序
			.s SortSeqNoStr=..GetAdmSortSeqNo(EpisodeID)
			.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
			.;s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
			.s SeqNum=ShowSeqNo
		    .do OutputRow56
		    }
    }else{
	    Set QueDr=0
	 	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
		For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H-1,LocID,QueDr)) Quit:QueDr=""  Do
		.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
		.Set QueMark=QueObj.QueMarkDrGetObjectId()
		.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
		.Set AdmTime=$P($g(^PAADM(PAAdm)),"^",7)
 		.set NowTime=..%SysTime()
 		.q:NowTime>AdmTime
		.Set QueStatus=QueObj.QueStateDr.PersName
		.set FisrtDr=QueObj.QueFirstDr.FirstcName
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.i FisrtDr="优先"  s ^TempFindadmlistquerYX(QueStatus,QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="过号"  s ^TempFindadmlistquery(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="等候" d
		..i ((QueMark'=DocId)&&(QueDocDr="")) s ^temdenghoulist(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.q:QueStatus="等候"
		.q:QueStatus="回诊"
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.q:((QueMark'=DocId)&&(QueDocDr'=DocId))
		.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
		.q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
		.q:((QueMark'=DocId)&&(QueDocDr=""))
		.Quit:(Type'="")&&(QueStatus'=Type)
		.;b
		.s EpisodeID=PAAdm
		.Set PatientID=$P(^PAADM(PAAdm),"^",1)
		.s SortSeqNoStr=..GetAdmSortSeqNo(PAAdm)
		.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
		.s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
		.s SeqNum=ShowSeqNo
		.s QueCompDr=QueObj.QueCompDr
		.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
		.s Status=QueStatus
	    .do OutputRow56
		Set QueDr=0
	 	If UserID'="" Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
		For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
		.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
		.Set QueMark=QueObj.QueMarkDrGetObjectId()
		.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
		.Set QueStatus=QueObj.QueStateDr.PersName
		.set FisrtDr=QueObj.QueFirstDr.FirstcName
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.i FisrtDr="优先"  s ^TempFindadmlistquerYX(QueStatus,QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="过号"  s ^TempFindadmlistquery(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.i QueStatus="等候" d
		..i ((QueMark'=DocId)&&(QueDocDr="")) s ^temdenghoulist(QueDr)=QueMark_"^"_PAAdm_"^"_QueStatus
		.q:QueStatus="等候"
		.q:QueStatus="回诊"
		.s QueDocDr=QueObj.QueDocDrGetObjectId()
		.q:((QueMark'=DocId)&&(QueDocDr'=DocId))
		.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
		.q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
		.q:((QueMark'=DocId)&&(QueDocDr=""))
		.Quit:(Type'="")&&(QueStatus'=Type)
		.;b
		.s EpisodeID=PAAdm
		.Set PatientID=$P(^PAADM(PAAdm),"^",1)
		.s SortSeqNoStr=..GetAdmSortSeqNo(PAAdm)
		.s ShowSeqNo=$p(SortSeqNoStr,"^",1)
		.s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
		.s SeqNum=ShowSeqNo
		.s QueCompDr=QueObj.QueCompDr
		.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
		.s Status=QueStatus
	    .do OutputRow56
	    // b ;0909
	    if (Type="等候") {
		    s seqfist=2
		    s QueDr=0
		    s frist=2
		    s guohao=1
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H-1,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.//b ;0999
 			.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			.quit:(DocAdmInclude="N")
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先"  s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.q:((QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr'=DocId))
			.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
			.;q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr=""))
			.i QueMark=DocId s seqfist=1
			.e  s seqfist=2
		    .Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.Set QueStatus=QueObj.QueStateDr.PersName
			.Quit:(Type'="")&&(QueStatus'=Type)
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.s SeqNum=QueObj.QueNo
			.i SeqNum["+" d
			..s SortSeqNoStr=..GetAdmSortSeqNo(PAAdm)
			..s ShowSeqNo=$p(SortSeqNoStr,"^",1)
			..s AdmSortSeqNo=$p(SortSeqNoStr,"^",2)
			..s SeqNum=ShowSeqNo
			.s QueCompDr=QueObj.QueCompDr
			.Set AdmTime=$P($g(^PAADM(PAAdm)),"^",7)
 			.set NowTime=..%SysTime()
 			.q:NowTime>AdmTime
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
		    .do OutputRow56
		    s seqfist=2
		    s QueDr=0
		    s frist=2
		    s guohao=1
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.//b ;0999
			.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			.quit:(DocAdmInclude="N")
			.;b ;09988
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先"  s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.q:((QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr'=DocId))
			.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
			.;q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr=""))
			.i QueMark=DocId s seqfist=1
			.e  s seqfist=2
		    .Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.Set QueStatus=QueObj.QueStateDr.PersName
			.;b ;09933
			.Quit:(Type'="")&&(QueStatus'=Type)
			.;b ;099903
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.s SeqNum=QueObj.QueNo
			.s QueCompDr=QueObj.QueCompDr
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
		    .do OutputRow56
		    s seqfist=2
		    s frist=2
		    s QueID="" f  s QueID=$o(^TempFindadmlistquery(QueID))  q:QueID=""  d
		    .s QueMark=$p(^TempFindadmlistquery(QueID),"^",1)
		    .s PAAdm=$p(^TempFindadmlistquery(QueID),"^",2)
		    .s QueStatus=$p(^TempFindadmlistquery(QueID),"^",3)
		    .Set QueObj=##Class(User.DHCQueue).%OpenId(QueID)
		    .s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.s SeqNum=QueObj.QueNo
			.s QueCompDr=QueObj.QueCompDr
			.s guohao=2
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.d OutputRow56
		    }
	     if (Type="回诊") {
		    s QueDr=""
		    s frist=2
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H-1,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			.quit:(DocAdmInclude="N")
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先" s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.q:((QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr'=DocId))
			.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
			.;q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
			.Set QueStatus=QueObj.QueStateDr.PersName
			.Quit:(Type'="")&&(QueStatus'=Type)
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.Set AdmTime=$P($g(^PAADM(PAAdm)),"^",7)
 			.set NowTime=..%SysTime()
 			.q:NowTime>AdmTime
			.s SeqNum=QueObj.QueNo
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.s Updatetime=QueObj.QueStateTime
			.s QueCompDr=QueObj.QueCompDr
		    .i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
		    .do OutputRow56
		    s QueDr=""
		    s frist=2
		    For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
			.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
			.Set QueMark=QueObj.QueMarkDrGetObjectId()
			.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
			.s DocAdmInclude=..CheckDocAdmInclude(PAAdm,DocId)
			.quit:(DocAdmInclude="N")
			.set FisrtDr=QueObj.QueFirstDr.FirstcName
			.i FisrtDr="优先" s frist=1
			.e  s frist=2
			.s QueDocDr=QueObj.QueDocDrGetObjectId()
			.Set QueExabDr=QueObj.QueExabDrGetObjectId()
			.q:((QueDocDr'="")&&(QueDocDr'=DocId))
			.;q:((QueMark'=DocId)&&(QueDocDr'=DocId))
			.s userdr=$o(^SSU("SSUSR",0,"CTPCP",QueMark,0))
			.;q:((userdr'="")&&(QueDocDr'="")&&(QueDocDr'=DocId))
			.Set QueStatus=QueObj.QueStateDr.PersName
			.Quit:(Type'="")&&(QueStatus'=Type)
			.s EpisodeID=PAAdm
			.Set PatientID=$P(^PAADM(PAAdm),"^",1)
			.s SeqNum=QueObj.QueNo
			.s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
			.s Status=QueStatus
			.s Updatetime=QueObj.QueStateTime
			.s QueCompDr=QueObj.QueCompDr
		    .i FisrtDr="优先" s Status=QueStatus_"("_FisrtDr_")"
		    .do OutputRow56
		    }
	    
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow56
	Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	if RegfeeDr'="" {
		set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
		i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	}else {  Set RegRangeTime=""}
	;q:((RegRangeTime="上午")&&(..%SysTime()>52200)&&(Type="等候"))
	if (QueCompDr="") s QueCompDr=9
	//set Data=$lb(EpisodeID,Status,SeqNum,PatName,PatientID,RegRangeTime,QueCompDr)
	
	i $g(AdmSortSeqNo)'="" {
		If $L(AdmSortSeqNo)'<8 Set SeqNo=$E(AdmSortSeqNo,1,8)
		else  i $L(AdmSortSeqNo)'=0  Set SeqNo=$e("00000000",1,8-$l(AdmSortSeqNo))_AdmSortSeqNo
		If $L(AdmSortSeqNo)=0 Set SeqNo="99999999"
		if SeqNum["+" set SeqNo=900+AdmSortSeqNo
	}else{
		If $L(SeqNum)'<8 Set SeqNo=$E(SeqNum,1,8)
		else  i $L(SeqNum)'=0  Set SeqNo=$e("00000000",1,8-$l(SeqNum))_SeqNum
		;If $L(SeqNum)=2 Set SeqNo="0"_SeqNum
		;If $L(SeqNum)=1 Set SeqNo="00"_SeqNum
		If $L(SeqNum)=0 Set SeqNo="99999999"
		if SeqNum["+" set SeqNo=900+SeqNum
	}
	s indd=SeqNo_ind
	;s ^tmpgry("SeqNo",EpisodeID)=SeqNum_","_SeqNo_","_$g(AdmSortSeqNo)
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)
	s QueCompDr=$tr(QueCompDr,$c(0),"")
	set Data=$lb(EpisodeID,Status,SeqNum,PatName,PatientID,RegRangeTime,QueCompDr)
	If $L(ind)=2 Set indii="0"_ind
	If $L(ind)=1 Set indii="00"_ind
	If $L(ind)'<3 Set indii=$E(ind,1,3) 
	s PAAdmPriority="" 
	Set Priority=$P($g(^PAADM(EpisodeID)),"^",33)
	If Priority'="" Set PAAdmPriority=$P($G(^CT("ACU",Priority)),"^",2)
	Else  Set PAAdmPriority=""
	i $g(PAAdmPriority)="一般" s sind=3
	i $g(PAAdmPriority)="危重" s sind=1
	i $g(PAAdmPriority)="重患" s sind=2
	i $g(PAAdmPriority)="" s sind=9
	i Type="等候" {
		;小儿科门诊非实名号在实名号之后,其他门诊科室按序号排列
		i $g(^DHCDocLocalSysP("OPDoc.OutPatList.ShowPTDep"))[("^"_LocID_"^") {
			s indd=QueCompDr_guohao_sind_frist_AdmDate_RegRangeTimeDr_seqfist_SeqNo_indii
		}else{
			s indd=QueCompDr_guohao_$g(sind)_frist_AdmDate_RegRangeTimeDr_SeqNo_seqfist_indii
		}
	}
	i Type="回诊" s indd=frist_RegRangeTimeDr_Updatetime_indii

	s Callindex=Callindex+1
	s CallType=""
	i Type="回诊" s CallType=1
	i Type="等候" s CallType=2 
	i Type="未报到" s CallType=3
	i ((CallType'="")&&(IPAddress'="")&&($g(SeqNum)'="")) s ^DHCVISTemp(+$h,"Findadmquery",IPAddress,UserID,CallType,indd)=EpisodeID_"^"_Status_"^"_SeqNum_"^"_PatName_"^"_PatientID_"^"_"^"_UserID_"^"_LocID
 	
 	;s ^tmpgry(UserID,Type)=
 	Set ^CacheTemp(repid,indd)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindadmqueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindadmqueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindadmqueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindadmqueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCDocOutPatientList).GetAdmSortSeqNo(73452)
ClassMethod GetAdmSortSeqNo(EpisodeID)
{
	;显示序号
	s ShowSeqNo=""
	;就诊排队序号
	s AdmSortSeqNo=""
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueMarkDR=$lg(^User.DHCQueueD(QueRowId),8)
	s QueDocDR=$lg(^User.DHCQueueD(QueRowId),5)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	
	;急诊和儿科除外
	s QueDepDR=$lg(^User.DHCQueueD(QueRowId),4)
	s QueDepDesc=$p(^CTLOC(QueDepDR),"^",2)
	Q:QueDepDesc["急诊" QueSeqNo_"^"_""
	;Q:^DHCDocLocalSysP("OPDoc.OutPatList.ShowPTDep")[("^"_QueDepDR_"^") QueSeqNo_"^"_""
	
	s SSUserId=""
	i QueMarkDR'="" {
		s SSUserId=$O(^SSU("SSUSR",0,"CTPCP",QueMarkDR,0))
	}
	i SSUserId="" {
		;非实名号
		i QueDocDR'="" {
			s SortSeqNo=$$GetLastQADSeqNo(QueRowId,QueDocDR)
			s ShowSeqNo=SortSeqNo
			s AdmSortSeqNo=SortSeqNo_"00000"
		}else{
			s AdmSortSeqNo=99999999
			s ShowSeqNo=QueSeqNo
		}
	}else{
		;实名号,分实名正号和实名加号
		i QueSeqNo["+" {
			;判断违约,报到时间是否在时段内;没有时段则按不违约处理
			i QueDocDR'="" s tempQueDocDR=QueDocDR 
			e  s tempQueDocDR=QueMarkDR
			s SortSeqNo=$$GetLastQADSeqNo(QueRowId,tempQueDocDR)
			s ShowSeqNo=SortSeqNo
			s AdmSortSeqNo=SortSeqNo_"00000"
		}else{
			;取违约顺序,不违约按原序号返回
			s AdmSortSeqNo=$$GetLateSeq(QueRowId)
			s ShowSeqNo=QueSeqNo
		}
	}
	
	quit ShowSeqNo_"^"_AdmSortSeqNo
GetLastQADSeqNo(QueRowId,QueDocDR)
	s LastQADSeqNo=""
	s QADID=""
	for {
		s QADID=$O(^DHCQueueAD(QueRowId,QADID),-1) q:QADID=""
		s QADDocDR=$p(^DHCQueueAD(QueRowId,QADID),"^",3)
		s QADSeqNo=$p(^DHCQueueAD(QueRowId,QADID),"^",4)
		i (QADDocDR=QueDocDR) s LastQADSeqNo=QADSeqNo quit
	}
	if LastQADSeqNo="" s LastQADSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	q LastQADSeqNo
GetLateSeq(QueRowId)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	s LateSeq=QueSeqNo
	s AdmId=$lg(^User.DHCQueueD(QueRowId),11)
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",AdmId,""))
	Q:Regfeeid="" 0
	s RBASDR=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASDR="" 0
	s RegCurrentTime="" //##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo1(RBASDR,QueSeqNo,"")
	/*
	i RegCurrentTime'="" {
		;有分时段
		s CheckInTime=..GetCheckInTime(QueRowId)
		i CheckInTime="" s CheckInTime=..%SysTime()
		b ;1
		i +CheckInTime>+RegCurrentTime {
			s CheckInTime=$e("00000",1,5-$l(CheckInTime))_CheckInTime
			s LateSeq=MaxRangeNum_CheckInTime
		}else{
			s LateSeq=LateSeq_"00000"
		}
	}else{
		;无分时段,按初始化的序号(LateSeq=QueSeqNo)返回
		s LateSeq=LateSeq_"00000"
	}
	q LateSeq
	*/
	
	s TRRegNumStr=$P($G(^RBAS(+RBASDR,$p(RBASDR,"||",2),"DHC")),"^",24)
	s TRRegInfoStr=$P($G(^RBAS(+RBASDR,$p(RBASDR,"||",2),"DHC")),"^",25)
	s FindSplitNum="",TRRegTimeRange=""
	for i=1:1:$l(TRRegNumStr,",") {
		s OneTRRegNumRange=$p(TRRegNumStr,",",i)
		continue:OneTRRegNumRange=""
		s MinRangeNum=$p(OneTRRegNumRange,"-",1)
		s MaxRangeNum=$p(OneTRRegNumRange,"-",2)
		i QueSeqNo>MinRangeNum,QueSeqNo<MaxRangeNum s FindSplitNum=i quit
	}
	i FindSplitNum'="" s TRRegTimeRange=$p(TRRegInfoStr,",",FindSplitNum)
	i TRRegTimeRange'="" {
		;有分时段
		s AdmStartTime=$p(TRRegTimeRange,"-",1)
		s AdmEndTime=$p(TRRegTimeRange,"-",2)
		i AdmStartTime[":" s AdmStartTime=..%ZTH(AdmStartTime,1)
		s TRRegNumRange=$p(TRRegNumStr,",",FindSplitNum)
		s MinRangeNum=$p(TRRegNumRange,"-",1)
		s MaxRangeNum=$p(TRRegNumRange,"-",2)
		
		s CheckInTime=..GetCheckInTime(QueRowId)
		i CheckInTime="" s CheckInTime=RegCurrentTime
		i +CheckInTime>+RegCurrentTime {
			s CheckInTime=$e("00000",1,5-$l(CheckInTime))_CheckInTime
			s LateSeq=MaxRangeNum_CheckInTime
		}else{
			s LateSeq=LateSeq_"00000"
		}
	}else{
		;无分时段,按初始化的序号(LateSeq=QueSeqNo)返回
		s LateSeq=LateSeq_"00000"
	}
	
	q LateSeq
}

ClassMethod GetCheckInTime(QueRowId) As %String
{
	s CheckInTime=""
	s QSChild=0
	for {
		s QSChild=$O(^DHCQueueStatus(QueRowId,QSChild)) Q:QSChild=""
		s QSStatusDR=$p(^DHCQueueStatus(QueRowId,QSChild),"^",4)
		s QSStatusCode=""
		i QSStatusDR'="" s QSStatusCode=$lg(^User.DHCPerStateD(QSStatusDR),2)
		;未报到 07,等候 02
		i QSStatusCode="02" {
			s PreStatusCode=""
			s PreQSChild=$o(^DHCQueueStatus(QueRowId,QSChild),-1)
			i PreQSChild'="" s PreStatusCode=$lg(^User.DHCPerStateD($p(^DHCQueueStatus(QueRowId,PreQSChild),"^",4)),2)
			i PreStatusCode="07" {
				s CheckInDate=$p(^DHCQueueStatus(QueRowId,QSChild),"^",1)
				s CheckInTime=$p(^DHCQueueStatus(QueRowId,QSChild),"^",2)
				quit
			}
		} 
	}
	q CheckInTime
}

/// Creator:songchunli
/// CreateDate:2016-08-15
/// Desc:获取当前病人列表第一个正在等候的患者
/// w ##Class(web.DHCDocOutPatientList).GetNextPatMethod(63,600)
ClassMethod GetNextPatMethod(LocId As %String, UserId As %String) As %String
{
	 s FirstWaitPat=""
	 s rs=##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	 i rs.QueryIsValid() {
		Set Status=rs.Execute(LocId,UserId,"","","","","","","","")
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s FirstWaitPat=rs.GetData(2)
			Quit
		}
	 }
	 Q:FirstWaitPat="" ""
	 if (FirstWaitPat'=""){
		 s EpisodeID=FirstWaitPat
		 s PatientId=$p(^PAADM(EpisodeID),"^",1)
		 s mradm=$p(^PAADM(EpisodeID),"^",61)
	 }
	 Q EpisodeID_"^"_PatientId_"^"_mradm
}

/// 是否开启报到产生队列号，开启报到迟到惩罚，开启过号惩罚
/// w ##Class(web.DHCDocOutPatientList).InsertNewQueueNo(107,"A")
ClassMethod InsertNewQueueNo(EpisodeID, Type)
{
	s rtn=""
	q:EpisodeID="" rtn
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	Q:Regfeeid="" rtn
	s RBASId=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASId="" rtn
	s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(RBASId)
	Q:ASNoLimitLoadFlag="Y" rtn
	
	s ExabCheckFlag=##class(web.DHCAlloc).GetExaBordFlag(EpisodeID)
	b //报到产生序列号
	if (($P(ExabCheckFlag,"^",5)="Y")&&(Type="A")){
		s rtn=..CreatNewQueueNo(EpisodeID)
	}
	//迟到惩罚
	if (($P(ExabCheckFlag,"^",6)="Y")&&(Type="A")){
		s rtn=..DelayNewQueueNo(EpisodeID)
	}
	//过号惩罚
	if (($P(ExabCheckFlag,"^",7)="Y")&&(Type="C")){
		s rtn=..CallDelayNewQueueNo(EpisodeID)
	}
	q rtn
}

/// 开启报到产生队列号，开启报到迟到惩罚，开启过号惩罚后产生的排队号和显示号
/// 排队号^显示号^状态
/// w ##class(web.DHCDocOutPatientList).GetNewQueueNo(2480)
ClassMethod GetNewQueueNo(EpisodeID)
{
	q:EpisodeID="" ""
	//应急系统返回患者无队列信息
	q:##Class(DHCDoc.Interface.StandAlone.Service).IsCESAdm(EpisodeID)=1 ""
	
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	s RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	s rtn=""
	if RegfeeRowId'="" {
		s object=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
		s CreatNewSeqNo=object.RegfeeCreatNewSeqNo
		s CreatDelaySeqNo=object.RegfeeCreatDelaySeqNo
		s CreatCallDelaySeqNo=object.RegfeeCreatCallDelaySeqNo
		s ExabCheckFlag=##class(web.DHCAlloc).GetExaBordFlag(EpisodeID)
		//报到产生序列号
		if ($P(ExabCheckFlag,"^",5)="Y"){
			if (CreatNewSeqNo=""){
				s SeqNo=QueSeqNo
		    	if ($L(SeqNo)'<8){
			    	s SeqNo=$e(SeqNo,1,8)
			    }elseif ((SeqNo["+")&($L(SeqNo)>2)){  
		    		s SeqNo=..GetNewAddQueueNo(SeqNo)
			    }elseif ($L(SeqNo)'=0){
					s SeqNo=$E("00000000",1,8-$L(SeqNo))_SeqNo
				}else{
					s SeqNo="99999999"
				}
				s rtn=SeqNo_"^"_QueSeqNo_"^正常"	
			}else{
				b ;feibaodao 
				s SeqNo=$P(CreatNewSeqNo,":",1)
				s ShowSeqNo=$P(CreatNewSeqNo,":",2)
				if (ShowSeqNo'["+") s ShowSeqNo =$e(SeqNo,1,$L(SeqNo)-5)+ShowSeqNo-1
				if ($L(SeqNo)'<8){
					s SeqNo=$e(SeqNo,1,8)
				}elseif ($L(SeqNo)'=0){
					s SeqNo=..GetNewAddQueueNo(SeqNo)
				}else{
					s SeqNo="99999999"
				}
				s rtn=SeqNo_"^"_ShowSeqNo_"^正常"
			}
		}
		//迟到惩罚
		if ($P(ExabCheckFlag,"^",6)="Y"){
			if (CreatDelaySeqNo=""){
				s SeqNo=QueSeqNo
		    	if ($L(SeqNo)'<8){
			    	s SeqNo=$e(SeqNo,1,8)
			    }elseif ((SeqNo["+")&($L(SeqNo)>2)){    		
				    s SeqNo=..GetNewAddQueueNo(SeqNo)
			    }elseif ($L(SeqNo)'=0){
				    s SeqNo=$E("00000000",1,8-$L(SeqNo))_SeqNo
				}else{
					s SeqNo="99999999"
				}
				s rtn=SeqNo_"^"_QueSeqNo_"^正常"	
			}else{
				s SeqNo=$P(CreatDelaySeqNo,":",1)
				s ShowSeqNo=$P(CreatDelaySeqNo,":",2)
				if ($L(SeqNo)'<8){
					s SeqNo=$e(SeqNo,1,8)
				}elseif ((SeqNo["+")&($L(SeqNo)>2)){    		
					s SeqNo=..GetNewAddQueueNo(SeqNo)
				}elseif ($L(SeqNo)'=0){
					s SeqNo=$E("00000000",1,8-$L(SeqNo))_SeqNo
				}else{
					s SeqNo="99999999"
				}
				s Status="正常"
				s:ShowSeqNo'="" Status="迟到"
				if ($P(ExabCheckFlag,"^",5)="Y"){
					s SeqNo=$P(CreatNewSeqNo,":",1)
					s ShowSeqNo=$P(CreatNewSeqNo,":",2)
					if (ShowSeqNo'["+"){
						s ShowSeqNo =$e(SeqNo,1,$L(SeqNo)-5)+ShowSeqNo-1
					}
					if (Status'="迟到"){
						s SeqNo=$P(CreatNewSeqNo,":",1)
						if ($L(SeqNo)'<8){
							s SeqNo=$e(SeqNo,1,8)
						}elseif ((SeqNo["+")&($L(SeqNo)>2)){    		
					    	s SeqNo=..GetNewAddQueueNo(SeqNo)
				    	}elseif ($L(SeqNo)'=0){
					    	s SeqNo=$E("00000000",1,8-$L(SeqNo))_SeqNo
						}else{
							s SeqNo="99999999"
						}
					}else {
						s SeqNo=$P(CreatDelaySeqNo,":",1)
						if ($L(SeqNo)'<8){
							s SeqNo=$e(SeqNo,1,8)
						}elseif ($L(SeqNo)'=0){
							s SeqNo=..GetNewAddQueueNo(SeqNo)
						}else{
							s SeqNo="99999999"
						}
					}
					s rtn=SeqNo_"^"_ShowSeqNo_"^"_Status
				}else{
					s rtn=SeqNo_"^"_QueSeqNo_"^"_Status
				}
			}
		}
		//过号惩罚
		if (($P(ExabCheckFlag,"^",7)="Y")&&(CreatCallDelaySeqNo'="")){
			s SeqNo=$P(CreatCallDelaySeqNo,":",1)
			s ShowSeqNo=$P(CreatCallDelaySeqNo,":",2)
			if ($L(SeqNo)'<8){
				s SeqNo=$e(SeqNo,1,8)
			}elseif ((SeqNo["+")&($L(SeqNo)>2)){    		
				s SeqNo=..GetNewAddQueueNo(SeqNo)
			}elseif ($L(SeqNo)'=0){
				s SeqNo=$E("00000000",1,8-$L(SeqNo))_SeqNo
			}else{
				s SeqNo="99999999"
			}
			 
			s Status="过号"
			if ($P(ExabCheckFlag,"^",6)="Y"){
				s ShowSeqNo=$P(CreatNewSeqNo,":",2)
				if (ShowSeqNo'["+") s ShowSeqNo =$e(SeqNo,1,$L(SeqNo)-5)+ShowSeqNo
				s rtn=SeqNo_"^"_ShowSeqNo_"^"_Status
			}else{
				s rtn=SeqNo_"^"_QueSeqNo_"^"_Status
			}
		}
	}
	if rtn="" {
		s SeqNo=QueSeqNo
		if ($L(SeqNo)'<8){
			s SeqNo=$e(SeqNo,1,3)_"00000"
		}elseif ((SeqNo["+")&($L(SeqNo)>2)){  	
			s SeqNo=..GetNewAddQueueNo(SeqNo)
		}elseif ($L(SeqNo)'=0){
			s SeqNo=$E("000",1,3-$L(SeqNo))_SeqNo_"00000"
		}else{
			s SeqNo="99999999"
		}
		s rtn=SeqNo_"^"_QueSeqNo_"^正常"
	}
	q rtn
}

/// 针对加号显示有误特殊处理 
ClassMethod GetNewAddQueueNo(SeqNo)
{
	s Len=8+$L(SeqNo)-2 ;此处处理可以最大处理到+999位；8为正常序号长度		
	s SeqNo=$E("0000000000",1,Len-$L(SeqNo))_SeqNo ;加号超过999时，"0000000000"后面需要补0
	q SeqNo
}

ClassMethod CreatNewQueueNo(EpisodeID)
{
	q:EpisodeID="" ""
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueMarkDR=$lg(^User.DHCQueueD(QueRowId),8)
	s QueDocDR=$lg(^User.DHCQueueD(QueRowId),5)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	Q:Regfeeid="" 0
	s RBASId=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASId="" 0
	s NowTime=..%SysTime()
	s MaxSecorndSeqNo=0
	lock +^DHCRBASQueue(RBASId):10
	lock +^RBASLOCK(+RBASId,$P(RBASId,"||",2)):10
	if (QueSeqNo'["+"){
		s TotalTRLoad=1
		s MaxRangeNum=""
		s TRQueueNoStr=""
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			if (TotalTRLoad>QueSeqNo){
				 s TRQueueNoStr=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",4) 
				 s ConResRowId=+RBASId
				 s ConChildsub=$P(RBASId,"||",2)
				 s ConASTRSub=ASTRSub
				 quit
			}
		}
		if (TRQueueNoStr=""){
			if (TotalTRLoad=1) s MaxRangeNum=TotalTRLoad 
			else  s MaxRangeNum=TotalTRLoad-1
		}
		if ((QueSeqNo="")){
			s ASQueueNo=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC"),"^",4)
		 	;正号串与加号串
		 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
			s MaxRangeNum=$l(NormalQueueNoStr,",")
		}
		if (MaxRangeNum'=""){
			s MaxSecorndSeqNo=$g(^DHCRBASQueue(RBASId,"A",MaxRangeNum))
			if (MaxSecorndSeqNo="") { s MaxSecorndSeqNo=1}
			else{s MaxSecorndSeqNo=MaxSecorndSeqNo+1}
			s ^DHCRBASQueue(RBASId,"A",MaxRangeNum)=MaxSecorndSeqNo
		}else{
			s TRQueueNum=0
			for j=1:1:$L(TRQueueNoStr,","){
				s OneTRQueueNo=$P(TRQueueNoStr,",",j)
				s OneNo=$P(OneTRQueueNo,":",1)
				s OneStatus=$P(OneTRQueueNo,":",2)
				if (OneStatus=0){
					s MaxRangeNum=OneNo
					s MaxSecorndSeqNo=1
					s TRQueueNum=j
					q 
				}
			}
			if (MaxRangeNum'=""){
				s $P(TRQueueNoStr,",",TRQueueNum)=MaxRangeNum_":1"
				s $P(^RBAS(ConResRowId,ConChildsub,"ASTR",ConASTRSub),"^",4)=TRQueueNoStr
			}
		}
		if ($L(NowTime)'<5){ set NowTime=$e(NowTime,1,5)}
		elseif ($L(NowTime)'=0){s NowTime=$E("00000",1,5-$L(NowTime))_NowTime}   ///2
		s MaxRangeNum=MaxRangeNum_NowTime
		s TypeQueueNo=MaxRangeNum_":"_MaxSecorndSeqNo
	}else{
		s MaxSecorndSeqNo=$g(^DHCRBASQueue(RBASId,"+A"))
		if (MaxSecorndSeqNo="") { s MaxSecorndSeqNo=1}
		else{s MaxSecorndSeqNo=MaxSecorndSeqNo+1}
		s ^DHCRBASQueue(RBASId,"+A")=MaxSecorndSeqNo
		if ($L(NowTime)'<5){ set NowTime=$e(NowTime,1,5)}
		elseif ($L(NowTime)'=0){s NowTime=$E("00000",1,5-$L(NowTime))_NowTime}   ///2
		s TypeQueueNo=NowTime_":+"_MaxSecorndSeqNo
		}
	&SQL(Update SQLUser.DHCRegistrationFee Set RegfeeCreatNewSeqNo=:TypeQueueNo Where %Id=:Regfeeid)
	lock -^RBASLOCK(+RBASId,$P(RBASId,"||",2)):10
	lock -^DHCRBASQueue(RBASId)
	q 0
}

/// w ##class(web.DHCDocOutPatienList).DelayNewQueueNo(1273)
ClassMethod DelayNewQueueNo(EpisodeID)
{
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueMarkDR=$lg(^User.DHCQueueD(QueRowId),8)
	s QueDocDR=$lg(^User.DHCQueueD(QueRowId),5)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	q:QueSeqNo["+" 0
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	Q:Regfeeid="" 0
	s RBASId=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASId="" 0
	s NowTime=..%SysTime()
	s MaxSecorndSeqNo=0
	s TimeRangeFlag=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",19)
	s RegCurrentTime=..GetTimeRangeRegInfo1(RBASId,QueSeqNo,"")
	lock +^DHCRBASQueue(RBASId):10
	i (TimeRangeFlag="Y")&&(+NowTime>+RegCurrentTime) {
		s TotalTRLoad=1
		s MaxRangeNum=""
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s StartRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			i NowTime>=StartRegtime,NowTime<=EndRegtime {
				s MaxRangeNum=TotalTRLoad-1 
				quit
			}
		}
		if (MaxRangeNum="") s MaxRangeNum=TotalTRLoad
		s MaxSecorndSeqNo=""
		if MaxRangeNum'=""{
			s MaxSecorndSeqNo=$g(^DHCRBASQueue(RBASId,"D",MaxRangeNum))
		}
		if (MaxSecorndSeqNo="") { s MaxSecorndSeqNo=1}
		else{s MaxSecorndSeqNo=MaxSecorndSeqNo+1}
		s ^DHCRBASQueue(RBASId,"D",MaxRangeNum)=MaxSecorndSeqNo
		if ($L(NowTime)'<5){ set NowTime=$e(NowTime,1,5)}
		elseif ($L(NowTime)'=0){s NowTime=$E("00000",1,5-$L(NowTime))_NowTime}   ///1
		s MaxRangeNum=MaxRangeNum_NowTime_":"_MaxSecorndSeqNo
	}else{
		s NowTime=QueSeqNo_"00000"
		s MaxRangeNum=NowTime
		}
	&SQL(Update SQLUser.DHCRegistrationFee Set RegfeeCreatDelaySeqNo=:MaxRangeNum Where %Id=:Regfeeid)
	lock -^DHCRBASQueue(RBASId)
	q 0
}

ClassMethod CallDelayNewQueueNo(EpisodeID)
{
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueMarkDR=$lg(^User.DHCQueueD(QueRowId),8)
	s QueDocDR=$lg(^User.DHCQueueD(QueRowId),5)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	q:QueSeqNo["+" 0
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	Q:Regfeeid="" 0
	s RBASId=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASId="" 0
	s NowTime=..%SysTime()
	s MaxSecorndSeqNo=0
	lock +^DHCRBASQueue(RBASId):10
	s fNum=$g(^DHCRBASQueue(RBASId,Regfeeid))
	s TotalTRLoad=1,MaxRangeNum=0
	if (fNum=""){s fNum=1}
	if (fNum=1){
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s StartRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			i NowTime>=StartRegtime,NowTime<=EndRegtime s MaxRangeNum=TotalTRLoad-1 quit
			s MaxRangeNum=TotalTRLoad-1
		}
	}elseif(fNum=2){
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s StartRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			i NowTime>=StartRegtime,NowTime<=EndRegtime {
				s ASTRSubNet=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub))
				if ASTRSubNet'=""{
					s TotalTRLoad=TotalTRLoad+$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSubNet),"^",3)
					}
				s MaxRangeNum=TotalTRLoad-1 
				quit
			}
			s MaxRangeNum=TotalTRLoad-1
		}
	}else{
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s StartRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
		}
		s MaxRangeNum=TotalTRLoad-1 
	}
	s MaxSecorndSeqNo=$g(^DHCRBASQueue(RBASId,"A",MaxRangeNum))
	if (MaxSecorndSeqNo="") { s MaxSecorndSeqNo=1}
	else{s MaxSecorndSeqNo=MaxSecorndSeqNo+1}
	s ^DHCRBASQueue(RBASId,"A",MaxRangeNum)=MaxSecorndSeqNo
	s ^DHCRBASQueue(RBASId,Regfeeid)=fNum+1
	if ($L(NowTime)'<5){ set NowTime=$e(NowTime,1,5)}
	elseif ($L(NowTime)'=0){s NowTime=$E("00000",1,5-$L(NowTime))_NowTime}   ///4
	s MaxRangeNum=MaxRangeNum_NowTime
	s TypeQueueNo=MaxRangeNum_":"_MaxSecorndSeqNo
	&SQL(Update SQLUser.DHCRegistrationFee Set RegfeeCreatCallDelaySeqNo=:TypeQueueNo Where %Id=:Regfeeid)
	lock -^DHCRBASQueue(RBASId)
	q 0
}

/// w ##class(web.DHCDocOutPatientList).GetTimeRangeRegInfo1("4921||3",22,"")
ClassMethod GetTimeRangeRegInfo1(RBASId, QueueNo, TimeRangeDesc)
{
	Q:RBASId="" ""
	s TimeRangeFlag=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",19)
	s RegNumStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",24)
	s RegInfoStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",25)
	s Date=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2))),"^",1)
	s Timerangeb=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",17)
	s Date=$ZD(Date,3)
	q:TimeRangeFlag'="Y" "0"	
	s RegCurrentTime=""
	s i=$L(RegNumStr,",")
	s Position=0
	s TotalTRLoad=0
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
		s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
		s TotalTRLoad=TotalTRLoad+TRLoad
		if TotalTRLoad>=QueueNo{
			s SttTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s RegCurrentTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			s Position=1
			Q
		}
	}
	q:Position>0 RegCurrentTime 
	q "99999"	;"请咨询护士台"
}

/// w ##class(web.DHCDocOutPatientList).GetAPPTimeRangeReg("4921||3",22,"")
ClassMethod GetAPPTimeRangeReg(RBASId, QueueNo)
{
	Q:RBASId="" ""
	s TimeRangeFlag=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",19)
	s RegNumStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",24)
	s RegInfoStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",25)
	s Date=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2))),"^",1)
	s Timerangeb=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",17)
	s Date=$ZD(Date,3)
	q:TimeRangeFlag'="Y" ""	
	s RegCurrentTime=""
	s i=$L(RegNumStr,",")
	s Position=0
	s TotalTRLoad=0
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
		s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
		s TotalTRLoad=TotalTRLoad+TRLoad
		if TotalTRLoad>=QueueNo{
			s SttTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s RegCurrentTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			s Position=..%ZT(SttTime)_"-"_..%ZT(RegCurrentTime)
			Q
		}
	}
	q:Position>0 RegCurrentTime 
	q ""
}

/// 获取当前就诊人的替诊号别
ClassMethod GetReplaceMarkDr(EpisodeID As %String) As %String
{
	Q:(EpisodeID="") ""
	s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",EpisodeID,0))
 	Q:(RegfeeRowId="") ""
 	s RBASId=$lg(^User.DHCRegistrationFeeD(RegfeeRowId),18)
 	Q:(RBASId="") ""
 	s ReplaceMarkDr="" 
 	s ReplaceRBASId="" 
 	While (1){ 
	 	s ResRowId=+RBASId,ASChildSub=$P(RBASId,"||",2) 
	 	s StatusDr=$P($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10) 
	 	q:StatusDr="" 
	 	s StatusCode=$P($G(^DHCRBCASStatus(StatusDr)),"^",1) 
	 	q:(StatusCode'="TR") // TR说明是被替诊的排班 
	 	s TReplaceRBASId=$P($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",12) // 替诊 的排班id（也可能是被替诊的排班id） 
	 	q:(TReplaceRBASId="") // ReplaceRBASId不为空才能继续找替诊排班 
	 	s ReplaceRBASId=TReplaceRBASId 
	 	s RBASId=ReplaceRBASId 
 	}
 	s ReplaceMarkDr= $P($G(^RB("RES",+ReplaceRBASId)),"^",2) 
 	q ReplaceMarkDr
 	
 	/*s ResRowId=+RBASId,ASChildSub=$P(RBASId,"||",2)
 	s StatusDr=$P($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
 	s StatusCode=""
	s:(StatusDr'="") StatusCode=$P($G(^DHCRBCASStatus(StatusDr)),"^",1)
	q:(StatusCode'="TR") ""
	s ReplaceRBASId=$P($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",12)
	Q:(ReplaceRBASId="") ""
	s ReplaceMarkDr= $P($G(^RB("RES",+ReplaceRBASId)),"^",2)
	q ReplaceMarkDr*/
}

/// 获取当前医生是否是就诊人的挂号医生
ClassMethod CheckDocAdmInclude(EpisodeID As %String, DoctorID As %String)
{
	s AdmLocId=$P(^PAADM(EpisodeID),"^",4)
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	if (QueRowId'=""){
		s QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
		s StatusPerName=$List(^User.DHCPerStateD(QueStateDr),4)
		s QueMarkDr=$LG(^User.DHCQueueD(QueRowId),8)
		s QueDocDr=$LG(^User.DHCQueueD(QueRowId),5)
		;2021-01-16 当复诊时有可能重新指定了另外的医生
		Q:(StatusPerName="复诊")&&(DoctorID=QueDocDr) "Y"
		Q:(DoctorID=QueMarkDr) "Y"
		Q:(QueMarkDr="") "Y"
		/*Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DoctorID,QueMarkDr,""))
		Q:(Include'="") "Y"*/
		s MarkDocID=0,FindMarkDocFlag=0
		for {
			Set MarkDocID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DoctorID,QueMarkDr,MarkDocID)) Q:(MarkDocID="")||(FindMarkDocFlag=1)
			s MarkddepDr=$lg(^User.DHCMarkDocD(MarkDocID),4)
			continue:MarkddepDr'=AdmLocId
			s FindMarkDocFlag=1
		}
		Q:FindMarkDocFlag=1 "Y"
	}
	s ReplaceMarkDr=..GetReplaceMarkDr(EpisodeID)
	Q:ReplaceMarkDr="" "N"
	Q:(DoctorID=ReplaceMarkDr) "Y"
	s MarkDocID=0,FindMarkDocFlag=0
	for {
		Set MarkDocID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DoctorID,ReplaceMarkDr,MarkDocID)) Q:(MarkDocID="")||(FindMarkDocFlag=1)
		s MarkddepDr=$lg(^User.DHCMarkDocD(MarkDocID),4)
		continue:MarkddepDr'=AdmLocId
		s FindMarkDocFlag=1
	}
	Q:FindMarkDocFlag=1 "Y"
	//q:(Include'="") "Y"
	q "N"
}

/// tanjishan 结合当前迟到惩罚规则，获取建议就诊时间
/// w ##class(web.DHCDocOutPatientList).GetPrintTimeRange(50041926)
ClassMethod GetPrintTimeRange(EpisodeID)
{
		Q:EpisodeID="" ""
		
		s RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",EpisodeID,0))
		Q:(RegfeeDr="") ""
		s RBASId=$lg(^User.DHCRegistrationFeeD(RegfeeDr),18)
		Q:(RBASId="") ""
		s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
		Q:(QueRowId="") ""
		
		Set RegRangeTime=""
		if RegfeeDr'="" {
			set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
			set:(RegRangeTimeDr'="") RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
		}
		
		s TimeRangeFlag=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",19)
		i (TimeRangeFlag'="Y") {
			//没有启用分时段信息,只返回时段
			q RegRangeTime
		}
		s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",""),-1)
		s SttTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
		s EndTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
		//最后一个时段
		s LastPosition=..%ZT(SttTime,2)_"-"_..%ZT(EndTime,2)
		s object=##class(User.DHCRegistrationFee).%OpenId(RegfeeDr)
		s QueueNo=object.RegfeeNo
		if (QueueNo["+"){
			q LastPosition
		}
		s CreatNewSeqNo=object.RegfeeCreatNewSeqNo
		s CreatDelaySeqNo=object.RegfeeCreatDelaySeqNo
		s CreatCallDelaySeqNo=object.RegfeeCreatCallDelaySeqNo
		s CreatSeqNoStr=CreatCallDelaySeqNo
		s:(CreatSeqNoStr="") CreatSeqNoStr=CreatDelaySeqNo
		s:(CreatSeqNoStr="") CreatSeqNoStr=CreatNewSeqNo
		//如果没有重算的号别信息，直接取该顺序号对应的时段信息
		if (CreatSeqNoStr=""){
			s Position="",TotalTRLoad=1
			s ASTRSub=0 for{
				s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
				s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
				s TotalTRLoad=TotalTRLoad+TRLoad
				if TotalTRLoad>=QueueNo{
					s SttTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
					s EndTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
					s Position=..%ZT(SttTime,2)_"-"_..%ZT(EndTime,2)
					Q
				}
			}
			if (Position=""){
				s Position=LastPosition
			}
			q Position
		}
		
		s TotalTRLoad=1
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s StartRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndRegtime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			
			s MaxRangeNum=TotalTRLoad-1 
			s MaxTimeRangeArr(MaxRangeNum)=..%ZT(StartRegtime,2)_"-"_..%ZT(EndRegtime,2)
		}
		//获取重排的计数文件
		s MaxRangeNumStr=$P(CreatSeqNoStr,":",1)
		s MaxRangeLen=$L(MaxRangeNumStr)
		s MaxRangeNum=$E(MaxRangeNumStr,1,MaxRangeLen-5)
		s MaxTime=$E(MaxRangeNumStr,MaxRangeLen-4,MaxRangeLen)
		
		if ('$D(MaxTimeRangeArr(MaxRangeNum))){
			q LastPosition
		}
		s Position=MaxTimeRangeArr(MaxRangeNum)
		
		q Position
}

/// 分时段报到产生的序列号，退号时需要回归
ClassMethod CancleCreatNewQueueNo(EpisodeID)
{
	q:EpisodeID="" ""
	s ExabCheckFlag=##class(web.DHCAlloc).GetExaBordFlag(EpisodeID)
	b //报到产生序列号
	q:($P(ExabCheckFlag,"^",5)'="Y") 0
	s QueRowId=..GetQueRowidByMore(EpisodeID,"")
	s QueMarkDR=$lg(^User.DHCQueueD(QueRowId),8)
	s QueDocDR=$lg(^User.DHCQueueD(QueRowId),5)
	s QueSeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	s Regfeeid=$o(^User.DHCRegistrationFeeI("ADM",EpisodeID,""))
	Q:Regfeeid="" 0
	s RBASId=$lg(^User.DHCRegistrationFeeD(Regfeeid),18)
	Q:RBASId="" 0
	s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(RBASId)
	Q:ASNoLimitLoadFlag="Y" 0
	
	s object=##class(User.DHCRegistrationFee).%OpenId(Regfeeid)
	s CreatNewSeqNo=object.RegfeeCreatNewSeqNo
	s NowTime=..%SysTime()
	s MaxSecorndSeqNo=0
	s SeqNo=$P(CreatNewSeqNo,":",1)
	s ShowSeqNo =$e(SeqNo,1,$L(SeqNo)-5)
	lock +^RBASLOCK(+RBASId,$P(RBASId,"||",2)):10
	if (QueSeqNo'["+"){
		s TotalTRLoad=1
		s MaxRangeNum=""
		s TRQueueNoStr=""
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			s TRQueueNoStr=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",4)
			if (TotalTRLoad>QueSeqNo){
				 s TRQueueNoStr=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",4) 
				 s ConResRowId=+RBASId
				 s ConChildsub=$P(RBASId,"||",2)
				 s ConASTRSub=ASTRSub
				 quit
			}
			}
		if (TRQueueNoStr'=""){
			s TRQueueNum=0
			s MaxRangeNum=""
			for j=1:1:$L(TRQueueNoStr,","){
				s OneTRQueueNo=$P(TRQueueNoStr,",",j)
				s OneNo=$P(OneTRQueueNo,":",1)
				s OneStatus=$P(OneTRQueueNo,":",2)
				if (ShowSeqNo=OneNo){
					s TRQueueNum=j
					s MaxRangeNum=OneNo
					q 
					}
				}
				if (MaxRangeNum'=""){
					s $P(TRQueueNoStr,",",TRQueueNum)=MaxRangeNum_":0"
					s $P(^RBAS(ConResRowId,ConChildsub,"ASTR",ConASTRSub),"^",4)=TRQueueNoStr
					}
			}
		
	}
	&SQL(Update SQLUser.DHCRegistrationFee Set RegfeeCreatNewSeqNo=NULL Where %Id=:Regfeeid)
	lock -^RBASLOCK(+RBASId,$P(RBASId,"||",2)):10
	q 0
}

}
