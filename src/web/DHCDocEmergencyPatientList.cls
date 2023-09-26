Class web.DHCDocEmergencyPatientList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CheckAdm24Hour(Adm As %String, DateFrom As %Date, DateTo As %Date) As %Status
{
	Set AdmFlag=0
	Set AdmDate=$P($g(^PAADM(Adm)),"^",6)
	Set AdmTime=$P($g(^PAADM(Adm)),"^",7)
	If DateFrom="" Do
	.Set DiffDate=..%SysDate()-AdmDate
	.Set DiffTime=AdmTime-..%SysTime()
	.If DiffDate>1 Set AdmFlag=1
	.If DiffDate<0 Set AdmFlag=1
	.If DiffDate=0 Set AdmFlag=0
	.If (DiffDate=1)&(DiffTime'<0) Set AdmFlag=0
	Else  DO
	.If DateTo="" Set DateTo=..%SysDate()
	.If DateFrom>DateTo Set AdmFlag=1 Quit
	.If (AdmDate<DateFrom)!(AdmDate>DateTo) Set AdmFlag=1
	Quit AdmFlag
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

ClassMethod FindLocDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String) As %Status
{
	//PatientNo,SurName,CurrentDept,CurrentBed,CurrentWard,CurrentDoctor,StartDate,EndDate,CurrentAdmType
	//Set ^SMLPara=PatientNo_"^"_SurName_"^"_CurrentDept_"^"_CurrentBed_"^"_CurrentWard_"^"_CurrentDoctor_"^"_StartDate_"^"_EndDate_"^"_CurrentAdmType
	//;
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	i StartDate'="" s StartDate=..%ZDH(StartDate)
	i EndDate'="" s EndDate=..%ZDH(EndDate)
	
	s (LgHospID,LgGroupID)=""
	if $d(%session){
		Set LgHospID=%session.Get("LOGON.HOSPID")
		Set LgGroupID=%session.Get("LOGON.GROUPID")
	}
	
	//
 Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 If $g(DocId)="" Quit $$$OK
 //Set DocId=$p($g(^CTPCP(DocId,1)),"^",1)
	// 	
	Set CurrentAdmType="E"
	//
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Set Singleflag=0
	//
	If ($g(PatientNo)'="") Do
		.Set Singleflag=1
		.Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
		.Quit:$g(PAPMI)=""
		.Do OutPAPMI
	If ($g(SurName)'="")&($g(PatientNo)="") Do
		.Set Singleflag=1
		.Set name=$$ALPHAUP^SSUTIL4(SurName)
		.Set name0=name
		.Set PAPMI=$O(^PAPERi("PAPER_PatName",name,""))
		.If PAPMI'="" Do OutPAPMI
		.Set Qflag="N"
		.For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		..If $l(name),$e(name0,1,$l(name))'[name Set Qflag="Y" Quit
		..Set PAPMI=$O(^PAPERi("PAPER_PatName",name0,""))
		..If PAPMI="" Set Qflag="Y" Quit
		..Else  Do OutPAPMI
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Singleflag=1 $$$OK
	//
	//非留观本科病人
	if (AllPatient="")&&(ArrivedQue="")&&(RegQue="") s RegQue="on"
	Set AllPatientFlag=1
	If RegQue="on"	Do 
	.Do NotStayInWard
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	.d SetArrivePatList
	.Set qHandle=$lb(0,repid,0)
	Quit:RegQue="on" $$$OK
	//
	//留观室病人
	If AllPatient="on"	Do
	.Do StayInWard
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:AllPatient="on" $$$OK
	//
	//留观室本科病人
	If ArrivedQue="on"	Do 
	.Do StayInWardLoc
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:ArrivedQue="on" $$$OK
	//
	//;----------------------------------------------------------------------;
	//
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	//Set CurrentDoctor=$g(CurrentDoctor),CurrentWard=$g(CurrentWard),CurrentDept=$g(CurrentDept)
	//if Singleflag=0 Do SetDefaultPara,SetDefaultDate
	//
	//Set CurrentDept=LocID 
	//if ($g(CurrentWard)="")&($g(CurrentDept)'="") Do
	//	.Set DeptLst=$L(CurrentDept,$C(1))
	//	.For I=1:1:DeptLst Do
	//	..Set DeptItem=$P(CurrentDept,$C(1),I)
	//	..Do DeptPatList
	//
	//Do StayInWardLoc
	Set AllPatientFlag=0
	Do NotStayInWard
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
	//
OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm)
	Set PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	q:(StartDate'="")&&(PAAdmDate<StartDate)
	q:(EndDate'="")&&(PAAdmDate>EndDate)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	Set PAAdmDate=..%ZD(PAAdmDate)
	//
	//Add Date Check
	//	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If mradm'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//----zhaolj update 2006-10-19
	set RegId=0
	set RegId=$o(^User.DHCRegistrationFeeI("ADM",PAAdm,RegId))
	if RegId'="" d
	.set LocSeqNo=$list(^User.DHCRegistrationFeeD(RegId),8)
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	.set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegId),21)
	.i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	//----
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	Q:(WalkStatus="离院")&&((AllPatient="on")||(ArrivedQue="on"))
	s AVSRowId=0
	f  s AVSRowId=$o(^DHCADMVisitStatus(0,"PAADM",PAAdm,AVSRowId)) q:AVSRowId=""  d
	.s AVSVisitStatus=$p(^DHCADMVisitStatus(AVSRowId),"^",2)
	.q:AVSVisitStatus'=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4("Arrival"),""))
	.s ArrivedDate=$p(^DHCADMVisitStatus(AVSRowId),"^",8)
	.s ArrivedTime=$p(^DHCADMVisitStatus(AVSRowId),"^",9)
	i ArrivedDate'="" s ArrivedDate=..%ZD(ArrivedDate) //$zd(ArrivedDate,3)
	i ArrivedTime'="" s ArrivedTime=..%ZT(ArrivedTime,3)
	Set Priority=$P($g(^PAADM(PAAdm)),"^",33)
	s PriorityColor=""
	If Priority'="" Set PAAdmPriority=$P($G(^CT("ACU",Priority)),"^",2),PriorityCode=+$P($G(^CT("ACU",Priority)),"^",1),PriorityColor=$P($G(^CT("ACU",Priority)),"^",11)
	Else  Set PAAdmPriority="",PriorityCode="999"
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Doc=QueObj.QueDocDr
	.;s ^AAQ=QueObj
	.;If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.;Else  Set PAAdmDocCodeDR=""
	.Set RegDocCode=""
	.Set RegDocDr=QueObj.QueMarkDr.%Id()
	.Set Called=QueObj.QueCompDr
	.set SortCalled=Called
	.IF Called="" SET SortCalled="X"
	.Set StatusCode=QueObj.QueStateDr.PersCode
	.If StatusCode="" Set StatusCode="XX"
	.If RegDocDr'="" Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2),RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set Called=""
	.Set RegDocDr=""
	.Set SortCalled="X"
	s EMPatLev=""
	Set:((LgHospID'="")&&(LgGroupID'="")) EMPatLev=##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(PAAdm,PatientID,LgHospID,LocID,UserID,LgGroupID)
	// 022级(危重)H12X0220003
	Set Count=Count+1
	;Set Seq=EpisodeID
	;Set Seq=$g(EMPatLev)_$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	Set Seq=$G(PriorityCode)_$g(EMPatLev)_$G(RegDocCode)_$G(SortCalled)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	//02$2级(危重)$H12$X$02$20$003
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,EMPatLev,PriorityColor)
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
 	s ^Tempscl("DHCDocWorkBenchEm",$j,Seq,Count)=Data
	Quit
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,TPoliticalLevel,TSecretLevel,RegRangeTime,EMPatLev)=""
	Quit
NotStayInWard
	///List patients who doesn't stay in ward last 24hour
	//KILL DeptAdmArry
	//
	If StartDate="" Set FromDate=..%SysDate()-1,Time=..%SysTime()
	Else  Set FromDate=StartDate,Time=0
	If EndDate="" Set ToDate=..%SysDate()
	Else  Set ToDate=EndDate
	If FromDate>ToDate Quit
	//	
	For Date=FromDate:1:ToDate Do
	.For  Set Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("CurrLoc",LocID,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	...q:QueRowId=""
	...if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	...s StateDesc=""
	...if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	...Q:StateDesc="报到"
	
	...//医生号别对照
	...Set QueMarkId=$List(^User.DHCQueueD(QueRowId),8)
	...Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	...Quit:Include=""
	
	...Set PatPMI=$P($g(^PAADM(PAAdm)),"^",1)
	...Set PatAdmWard=$P($g(^PAADM(PAAdm)),"^",70)
	...Quit:PatPMI=""
	...Quit:(PatAdmWard'="")
	...Set CurStat=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If CurStat'="" Set CurStat=$P(CurStat,"^",1)
	...Quit:($G(CurStat)'="")&(AllPatientFlag=0)
	...//Set DeptAdmArry(PatPMI)=PAAdm
	...;到达病人不显示
	...Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...Quit:WalkStatus="到达"
	...Do OutputRow
	.Set Time=0 
	
	Quit
StayInWard
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="EM"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.//Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WardPatList
	Quit
StayInWardLoc
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="EM"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WLDPatList
	Quit
OutPAPMI
	//
	If StartDate="" Set FromDate=..%SysDate()-6
	Else  Set FromDate=StartDate
	If EndDate="" Set ToDate=..%SysDate()
	Else  Set ToDate=EndDate
	If FromDate>ToDate Quit
	//
	Set AdmStr=..GetEmergencyEpisode(PAPMI,FromDate,ToDate)
	Set LstCnt=$L(AdmStr,"^")
	For I=1:1:LstCnt Do
	.Set PAAdm=$P(AdmStr,"^",I)
	.Quit:PAAdm=""
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.Do OutputRow
	Quit
DeptPatList
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	
	For  Set Date=$O(^PAADMi("CurrLoc",DeptItem,Date)) Quit:(Date="")!(Date>EndDate)  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("CurrLoc",DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("CurrLoc",DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set PatPMI=$P($g(^PAADM(PAAdm)),"^",1)
	...Set PatAdmWard=$P($g(^PAADM(PAAdm)),"^",70)
	...Quit:PatPMI=""
	...Quit:(PatAdmWard="")&(ArrivedQue="on")
	...Quit:(PatAdmWard'="")&(RegQue="on")
	...Do OutputRow
	
	Quit
WLDPatList
	Quit:WardItem=""
	Set RoomDr=0
	For  Set RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set PAAdmVisitSta=$P($g(^PAADM(PAAdm)),"^",20)
	..q:PAAdmVisitSta'="A"
	..Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	..if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	..s StateDesc=""
	..if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	..Q:StateDesc="报到"
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..Quit:(PatLoc'=LocID)
	..//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set PAAdmVisitSta=$P($g(^PAADM(PAAdm)),"^",20)
	.q:PAAdmVisitSta'="A"
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)
	.//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	.Do OutputRow
	Quit
	//
WardPatList
	Set RoomDr=0
	For  s RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set PAAdmVisitSta=$P($g(^PAADM(PAAdm)),"^",20)
	..q:PAAdmVisitSta'="A"
	..Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	..if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	..s StateDesc=""
	..if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	..Q:StateDesc="报到"
	..//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set PAAdmVisitSta=$P($g(^PAADM(PAAdm)),"^",20)
	.q:PAAdmVisitSta'="A"
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	.Do OutputRow
	Quit
SetDefaultPara
	If (StartDate="")&(%request.Get("WIPDateFromToday")="on") Set StartDate=..%SysDate()
	If (StartDate="")&(%request.Get("WIPDtFromOffset")'="") Set StartDate=$ZDH(%request.Get("WIPDtFromOffset"),5)
	//
	If (EndDate="")&(%request.Get("WIPDateToToday")="on") Set EndDate=..%SysDate()
	If (EndDate="")&(%request.Get("WIPDtToOffset")'="") Set EndDate=$ZDH(%request.Get("WIPDtToOffset"),5)
	//
	If $g(CurrentDept)="" Do
	.Set LocStr=%request.Get("WIPLocList")
	.Set Loclen=$L(LocStr,$C(1))
	.For I=1:1:Loclen Do
	..If CurrentDept="" Set CurrentDept=$P($P(LocStr,$C(1),I),$C(2),3)
	..Else  Set CurrentDept=CurrentDept_$C(1)_$P($P(LocStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentDoctor)="" Do
	.Set DocStr=%request.Get("WIPCPList")
	.Set Doclen=$L(DocStr,$C(1))
	.For I=1:1:Doclen Do
	..Set DoctCode=$P($P(DocStr,$C(1),I),$C(2),1)
	..Quit:DoctCode=""
	..Set DocRowId=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DoctCode),""))
	..Quit:DocRowId=""
	..If CurrentDoctor="" Set CurrentDoctor=DocRowId
	..Else  Set CurrentDoctor=CurrentDoctor_$C(1)_DocRowId
	//
	If $g(CurrentWard)="" Do
	.Set WardStr=%request.Get("WIPWardList")
	.Set Wardlen=$L(WardStr,$C(1))
	.For I=1:1:Wardlen Do
	..If CurrentWard="" Set CurrentWard=$P($P(WardStr,$C(1),I),$C(2),3)
	..Else  Set CurrentWard=CurrentWard_$C(1)_$P($P(WardStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentAdmType)="" Do
	.Set AdmStr=%request.Get("WIPEpisodeTypeList")
	.If $L(AdmStr)>0 Set CurrentAdmType=$E(AdmStr,1)
	Quit
SetDefaultDate
	if StartDate="" Set StartDate=..%SysDate()-6
	If EndDate="" Set EndDate=..%SysDate()
	Quit
OutOPArrived
	s ArriveCount=0
	If StartDate="" Set StartDate=..%SysDate()
	If EndDate="" Set EndDate=..%SysDate()
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm),1),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm),1),"^",11)
	...Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...Set PatQueState=""
	...Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	....Set StatusName=QueObj.QueStateDr.PersName
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	....Quit:Include=""
	....Quit:(QueDocId'=DocId)
	....If WalkStatus["到达" Set PatQueState="A"
	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...;w "aaa,"_PatQueState,!
	...Do OutputRow
	...Set ArriveCount=ArriveCount+1
	Quit
SetArrivePatList
    s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)=""
	s PAPMINO="已看病人:"
	s ArriveFlagRowInd=ind
	Set ^CacheTemp(repid,ind)=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime)
 	set ind=ind+1
	Do OutOPArrived
	
	;赋值已看病人数
	Set $List(^CacheTemp(repid,ArriveFlagRowInd),4)=$ListGet(^CacheTemp(repid,ArriveFlagRowInd),4)_$g(ArriveCount)_"人"
	
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1
	
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

ClassMethod GetDocConsultRoom() As %String
{
	Set IPAddress=$ZUTIL(67,15,$JOB)
	Set RoomDr=$O(^User.DHCRoomCompI("RoomcIpIndex"," "_IPAddress,""))
	Quit:RoomDr="" ""
	Set Room=$LIST(^User.DHCRoomCompD(RoomDr),5)
	Quit:Room="" ""
	//Set RoomName=$LIST(^User.DHCExaRoomD(Room),5)
	Quit Room
}

ClassMethod GetDocConsultRoomCode() As %String
{
	Quit ""
	;Set RoomDr=..GetDocConsultRoom()
	;If RoomDr="" Quit ""
	;Set RoomCode=$LIST(^User.DHCExaRoomD(RoomDr),3)
	;Quit RoomCode
}

ClassMethod GetDocConsultRoomName() As %String
{
	Quit ""
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	Set RoomName=$LIST(^User.DHCExaRoomD(RoomDr),5)
	Quit RoomName
}

ClassMethod GetDocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	Set val=$$ALPHAUP^SSUTIL4(val)
 Set DocRowId=$O(^CTPCP(0,"Decs",val,""))
 If DocRowId'="" Set DocCode=$P($g(^CTLOC(DocRowId)),"^",1)
 Quit DocRowId_"^"_$g(DocCode)_"^"_val
}

ClassMethod GetEmergencyEpisode(PAPMI As %String, StartDate As %String, EndDate As %String) As %String
{
	Set CurrentAdmType="E"
	Kill PAAdmStr
	Set PAAdm=""
	If $G(EndDate)="" Set EndDate=..%SysDate()
	If $G(StartDate)="" Set StartDate=..%SysDate()-6
	Set CurWardAdm=""
	For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm),-1) Quit:PAAdm=""  Do
	.Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	.Set PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:PAAdmStatus'="A"
	.Quit:PAAdmStatus="C"
	.Quit:PAAdmStatus="P"
	.Set PAAdmWard=$P($g(^PAADM(PAAdm)),"^",70)
	.If PAAdmWard'="" Set CurWardAdm=PAAdm
	.Quit:..CheckAdmDate(PAAdm,StartDate,EndDate)
	.IF $G(PAAdmStr(PAAdmDate))="" Set PAAdmStr(PAAdmDate)=PAAdm
	.Else  Set PAAdmStr(PAAdmDate)=PAAdmStr(PAAdmDate)_"^"_PAAdm
	//
	Quit:CurWardAdm'="" CurWardAdm
	//
	s AdmStr="",AdmStrDate=""
	f  Set AdmStrDate=$O(PAAdmStr(AdmStrDate),-1) q:AdmStrDate=""  d
	.;Quit:AdmStrDate="" ""
	.i AdmStr="" d
	..s AdmStr=$G(PAAdmStr(AdmStrDate))
	.e  d
	..Set AdmStr=AdmStr_"^"_$G(PAAdmStr(AdmStrDate))
	Quit AdmStr
}

ClassMethod GetFilePath() As %String
{
	Quit ""
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	Set ConsultArea=$LIST(^User.DHCExaRoomD(RoomDr),2)
	Quit:ConsultArea="" ""
	Set FilePath=$LIST(^User.DHCExaBoroughD(ConsultArea),4)
	Quit FilePath
}

ClassMethod GetIPAndName() As %String
{
	Set IPAddress=$ZUTIL(67,15,$JOB)
	Quit IPAddress
}

ClassMethod GetLocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Code",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
  Quit:$g(MRAdm)="" ""
 Set DiagStr=""
 Set Diag=0
 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:(Diag="")  Do //!(DiagStr'="")
 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
 .//Quit:$g(DiagID)=""
 .i DiagID'="" d 
 ..Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 ..If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 .e  d
 ..Set DiagDesc=$g(^MR(MRAdm,"DIA",Diag,"DES",1))
 .If DiagStr="" Set DiagStr=DiagDesc
 .Else  Set DiagStr=DiagStr_","_DiagDesc
 Quit DiagStr
}

ClassMethod GetQueDoc(PAAdm As %String) As %String
{
	Set Doc=""
	Quit:$g(PAAdm)="" ""
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	Quit:QueRowId="" Doc
	Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	Set Doc=QueObj.QueDocDr
	Do QueObj.%Close()
	Quit Doc
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

ClassMethod SetAdmDocId(Adm As %String, LocId As %String, DocId As %String, UserId As %String) As %Status
{
	KILL PLIST
	Set PLIST(0)=Adm
	Set PLIST(3)=..%SysDate()
	Set PLIST(4)=..%SysTime()
	Set PLIST(7)=DocId
	Set PLIST(8)=LocId
	Set PLIST(16)=..%SysDate()
	Set PLIST(17)=..%SysTime()
	Set PLIST(18)=UserId
	//&SQL(INSERT INTO SQLUSER.PA_AdmTransaction VALUES PLIST() )
	&SQL(UPDATE SQLUSER.PA_Adm Set PAADM_AdmDocCodeDR=:DocId Where PAADM_RowId = :Adm)
	
	Quit SQLCODE
}

ClassMethod SetArrivedStatus(Adm As %String, DocDr As %String, LocId As %String, UserId As %String) As %Status
{
	Set sc=0
	Quit:$g(Adm)="" sc
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set QueDoc=oref.QueDocDrGetObjectId()
	.Quit:(QueDoc'="")&(QueDoc'=DocDr)
	.If QueDoc="" do oref.QueDocDrSetObjectId(DocDr)
	.s PatWardId = $p(^PAADM(Adm),"^",70)
	.&sql(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='到达')
	.if PatWardId="" Do oref.QueStateDrSetObjectId(PerStateDr)
	.s oref.QueCompDr=""
	.Set sc = oref.%Save()
	.Do oref.%Close()
	.If sc=1 Set sc=..SetAdmDocId(Adm,LocId,DocDr,UserId)
	Set VisitCode="Arrival"
	Set ArriveDate=..%SysDate()
	Set ArriveTime=..%SysTime()
	Set CurStat=##Class(web.DHCADMVisitStat).GetPatCurStat(Adm)
	if CurStat="" Do
	.;Set sc1=..SetAdmDocId(Adm,LocId,DocDr,UserId)
	.Set sc2=##Class(web.DHCADMVisitStat).InsertVisitStat(Adm,VisitCode,ArriveDate,ArriveTime,UserId)
	s rtn=##Class(web.DHCEMInterfaceCom).UpdEmVisitPosition(Adm,UserId)
	;If 'sc1 Set sc1=1
	;Quit:QueRowId="" sc1
	Quit 1
}

ClassMethod SetCallStatus(Adm As %String, DocDr As %String) As %Status
{
	//RetCode=100	Adm blank
	//RetCode=101	Pat has called by other Doctor
	//
	Set sc=0
	Quit:$g(Adm)="" 100
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Status=oref.QueStateDr.PersCode
	.If (Status="01")!(Status="02")!(Status="03") Do
	..Set QueDoc=oref.QueDocDr
	..Set Qutflag=0
	..If (QueDoc'="")&(QueDoc'=DocDr) Do
	...Set sc="101"
	...Set Qutflag=1
	..Quit:Qutflag=1
	..;
	..Set Room=..GetDocConsultRoom()
	..Do oref.QueRoomDrSetObjectId(Room)
	..Set oref.QueDocDr=DocDr
	..//Mask Called
	..Set oref.QueCompDr="1"
	..Set sc = oref.%Save()
	.else  Set sc="102"
 .Do oref.%Close()
 Quit sc
}

ClassMethod SetSkipStatus(Adm As %String, DocDr As %String) As %Status
{
	Set sc=0
	Quit:$g(Adm)="" sc
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set Status=oref.QueStateDr.PersCode
	.If (Status="01")!(Status="02")!(Status="03") Do
	..Set QueDoc=oref.QueDocDr
	..Quit:QueDoc=""
	..Quit:(QueDoc'="")&(QueDoc'=DocDr)
	..;
	..Do oref.QueRoomDrSetObjectId("")
	..Do oref.QueStateDrSetObjectId(3)
	..Set oref.QueDocDr=""
	..Set oref.QueCompDr=""
	..Set sc = oref.%Save()
 .Do oref.%Close()
 Quit sc
}

Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String,TSecretLevel:%String,RegRangeTime:%String,EMPatLev:%String,PriorityColor:%String")
{
}

}
