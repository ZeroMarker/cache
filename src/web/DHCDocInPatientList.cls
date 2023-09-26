Class web.DHCDocInPatientList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date) As %Status
{
	Set AdmDate=$P($g(^PAADM(Adm)),"^",6)
	if (DateFrom'="")&(AdmDate<DateFrom) Quit 1 
	If (DateTo'="")&(AdmDate>DateTo) Quit 1 
	Quit 0
}

ClassMethod RemoveAlias(Desc As %String) As %String
{
	s Desc1=$P(Desc,"-",2)
	if Desc1'="" Q Desc1
	Q Desc
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
 Set CurDate=..%SysDate(),CurTime=..%SysTime(),CurWeek=$ZD(..%SysDate(),10)
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

// d ##class(%ResultSet).RunQuery("web.DHCDocInPatientList","FindLocDocCurrentAdm",6,359,"127.0.0.1","","","","","","","","",10,"10||8")

ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "") As %Status
{
	//PatientNo,SurName,CurrentDept,CurrentBed,CurrentWard,CurrentDoctor,StartDate,EndDate,CurrentAdmType
	Set ^SMLPara=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue _","_RegQue_","_MedUnit_","_PACWard_","_BedId
	//;
	//n (qHandle, LocID , UserID , IPAddress , AllPatient , PatientNo , SurName , StartDate , EndDate , ArrivedQue, RegQue, MedUnit, PACWard, BedId)
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	s LogonHospId=%session.Get("LOGON.HOSPID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	//
	//
	Set repid=$I(^CacheTemp)
 	Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 	If $g(DocId)="" s qHandle=$lb(0,repid,0) Quit $$$OK
 	Set DocGrp=$P($g(^CTPCP(DocId,3)),"^",1)
	//Set DocId=$p($g(^CTPCP(DocId,1)),"^",1)
	//	
	Set CurrentAdmType="I"
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
		.Set name=SurName
		.Set name0=name
		.Set SurName=$$ALPHAUP^SSUTIL4(SurName)
		.Set PAPMI=$O(^PAPERi("PAPER_PatName",SurName,""))
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
	//全病区病人
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
	//本科病人
	If ArrivedQue="on"	Do 
	.Do DeptPatList
	.Do TempDeptPatList
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
	//本病区病人
	if PACWard'="" Do
	.s WardItem=PACWard
	.Do WardPatList
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:PACWard'="" $$$OK
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
	Do DocPatList
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
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	;全部条件下都需要退出的写此处
	;预住院状态的退出
	quit:PAAdmStatus="P"
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
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm)
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(PAAdm)),"^",7),2)
	//
	//Add Date Check
	//	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=..RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	q:(LogonHospId'="")&&(Hosp'=LogonHospId)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=..RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	//Q:(BedId'="")&&(BedId'=AdmBedId)
	if AdmBedId'="" Set PAAdmBed=$P($g(^PAWARD(+AdmBedId,"BED",$P(AdmBedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If mradm'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//
	Set Count=Count+1
	Set Seq=EpisodeID
	set MotherID=$P(^PAADM(PAAdm),"^",75)
	if MotherID'="" s Seq=MotherID

	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr)
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit
	;PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//
	If Seq="" Set Seq="ZZZZZ"
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,OEOrdItemID)
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode)=""
	Quit
StayInWard
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="W"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
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
		.;Quit:LocEmerType'="W"
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
	//
DocPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set QuitFlag=0
	...if MedUnit="" d
	....Set PatDoc=$P($g(^PAADM(PAAdm)),"^",9)
	....if PatDoc="" Set QuitFlag=1
	....if PatDoc'=DocId Set QuitFlag=1
	...else  d
	....s AllowFlag=..CheckCTLocMedUnit(PAAdm,DocId,DeptItem,MedUnit)
	....if AllowFlag'="1" Set QuitFlag=1
	...Q:QuitFlag=1
	...Do OutputRow
	Quit
	//
OutPAPMI
	If CurrentAdmType'="" Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
	..Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	..Quit:PAAdmStatus'="A"
	..;Quit:PAAdmStatus="P"
	..Quit:..CheckAdmDate(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Quit
DeptPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""

	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Do OutputRow
	Quit
TempDeptPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	;对于产房这种特殊病房,需要判断某些特殊医嘱就需要显示病人的走统一的自定义方法
	;这种一般都需要按登陆科室去接收科室,否则就诊科室还没有改变的情况下,录医嘱的接收科室位置可能不正确
	
	;这种特殊科室应当增加配置
	s SpecLocIDStr=""
	s CustomARCIMStr=""
	if (SpecLocIDStr[("^"_LocID_"^")) {
		s DeptItem=LocID
		For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
		.Set Time=""
		.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
		..Set PAAdm=""
		..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
		...//得到是否包含参数中的医嘱,并且未执行
		...s NotExecFlag=..GetCustomARCIMNotExecFlag(CustomARCIMStr,PAAdm)
		...Q:NotExecFlag'=1
		....Do OutputRow
	}else{
		//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
		For  Set Date=$O(^PAADMi("TempLoc",DeptItem,Date)) Quit:(Date="")  Do
		.Set Time=""
		.For  Set Time=$O(^PAADMi("TempLoc",DeptItem,Date,Time)) Quit:(Time="")  Do
		..Set PAAdm=""
		..For  Set PAAdm=$O(^PAADMi("TempLoc",DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
		...s CurrDepDR=$P($g(^PAADM(PAAdm)),"^",4)
		...q:CurrDepDR=DeptItem
		...Do OutputRow
	}
	Quit
WLDPatList
	Quit:WardItem=""
	Set RoomDr=0
	For RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..Quit:(PatLoc'=LocID)
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
	.Do OutputRow
	Quit
	//
WardPatList
	Set RoomDr=0
	For  s RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=0
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	..q:PAADMVisitStatus="D"
	..Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	..Q:(BedId'="")&&(BedId'=AdmBedId)
	..Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	..Q:(BedId'="")&&(BedId'=AdmBedId)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	.Q:(BedId'="")&&(BedId'=AdmBedId)
	.s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	.q:PAADMVisitStatus="D"
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
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

/// 得到是否包含参数中的医嘱,并且未执行
ClassMethod GetCustomARCIMNotExecFlag(CustomARCIMStr, PAAdm) As %String
{
	n (CustomARCIMStr,PAAdm)
	s NotExecFlag=0
	s OrderRowId=$O(^OEORD(0,"Adm",PAAdm,""))
	Q:OrderRowId="" NotExecFlag
	s OEItemRowId=0 f  s OEItemRowId=$O(^OEORD(OrderRowId,"I",OEItemRowId)) q:(OEItemRowId="")||(NotExecFlag=1)  d
	.s ItmRowId=$p($g(^OEORD(OrderRowId,"I",OEItemRowId,1)),"^",2)
	.Q:CustomARCIMStr'[("^"_ItmRowId_"^")
	.s OrderStatusDR=$p(^OEORD(OrderRowId,"I",OEItemRowId,1),"^",13)
	.s OrderStatus=""
	.if OrderStatusDR'="" s OrderStatus=$p(^OEC("OSTAT",OrderStatusDR),"^",1)
	.Q:OrderStatus'="V"
	.s OEExcID="",str=""
	.f  s OEExcID=$O(^OEORD(OrderRowId,"I",OEItemRowId,"X",OEExcID)) q:(OEExcID="")||(str'="")  d
	..s ctpcpDr=$P(^OEORD(OrderRowId,"I",OEItemRowId,"X",OEExcID),"^",15)
	..s str=str_ctpcpDr
	.Q:str'=""
	.s NotExecFlag=1
	
	Q NotExecFlag
}

ClassMethod GetDocConsultRoom() As %String
{
	Set IPAddress=$ZUTIL(67,15,$JOB)
	Set RoomDr=$O(^User.DHCRoomCompI("RoomcIpIndex"," "_IPAddress,""))
	Quit:RoomDr="" ""
	Set Room=$LIST(^User.DHCRoomCompD(RoomDr),5)
	Quit:Room="" ""
	//Set RoomName=$LIST(^User.DHCExaRoomD(Room),5)
	//INPATIENT return null
	set Room=""
	Quit Room
}

ClassMethod GetDocConsultRoomCode() As %String
{
	Set RoomDr=..GetDocConsultRoom()
	If RoomDr="" Quit ""
	Set RoomCode=$LIST(^User.DHCExaRoomD(RoomDr),3)
	Quit RoomCode
}

ClassMethod GetDocConsultRoomName() As %String
{
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
	For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm),-1) Quit:PAAdm=""  Do
	.Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	.Set PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.;Quit:PAAdmStatus'="A"
	.Quit:..CheckAdmDate(PAAdm,StartDate,EndDate)
	.IF $G(PAAdmStr(PAAdmDate))="" Set PAAdmStr(PAAdmDate)=PAAdm
	.Else  Set PAAdmStr(PAAdmDate)=PAAdmStr(PAAdmDate)_"^"_PAAdm
	Set AdmStrDate=$O(PAAdmStr(""),-1)
	Quit:AdmStrDate="" ""
	Set AdmStr=$G(PAAdmStr(AdmStrDate))
	Quit AdmStr
}

ClassMethod GetFilePath() As %String
{
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

ClassMethod GetMRAdmDiagnosis(MRAdm As %String, DelimStr As %String = ",") As %String
{
	Quit:$g(MRAdm)="" ""
	s AdmID=$p($G(^MR(MRAdm,"PRO",1)),"^",9)
 	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(AdmID)
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
	.Set QueDoc=oref.QueDocDr
	.Quit:(QueDoc'="")&(QueDoc'=DocDr)
	.If QueDoc="" Set oref.QueDocDr=DocDr
	.Set sc = oref.%Save()
 .Do oref.%Close()
 ;Quit:(QueRowId'="")&(sc'=1) sc
 ;Set sc1=..SetAdmDocId(Adm,LocId,DocDr,UserId)
 Set VisitCode="Arrival"
	Set ArriveDate=..%SysDate()
 Set ArriveTime=..%SysTime()
 Set CurStat=##Class(web.DHCADMVisitStat).GetPatCurStat(Adm)
 if CurStat="" Do
 .Set sc1=..SetAdmDocId(Adm,LocId,DocDr,UserId)
 .Set sc2=##Class(web.DHCADMVisitStat).InsertVisitStat(Adm,VisitCode,ArriveDate,ArriveTime,UserId)
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

ClassMethod CheckCTLocMedUnit(Adm As %String, DocId As %String, Loc As %String, MedUnit As %String) As %Status
{
	s PatDoc=$P($g(^PAADM(Adm)),"^",9)
	s Allow=0
	s MedUnitDocStr=""
	s CurMedUnitRowid=""
	s ret=##class(web.DHCCTLocMedUnit).getMedUnit(Loc,DocId)
	if ret'="" s CurMedUnitRowid=$p(ret,"^",1)
	Q:CurMedUnitRowid="" Allow
	
	s CTLOCID=$p(CurMedUnitRowid,"||",1)
	s MUChildID=$p(CurMedUnitRowid,"||",2)
	s MUCPChildsub=""
	for {
		s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub))
		Q:MUCPChildsub=""
		s DoctorId=$p(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub),"^",1)
		s MUCDateFrom=$P($G(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub)),"^",5)
		s MUCDateTo=$P($G(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub)),"^",6)
		if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
		if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
		
		i MedUnitDocStr="" {
			s MedUnitDocStr="^"_DoctorId_"^"
		}else{
			s MedUnitDocStr=MedUnitDocStr_"!"_"^"_DoctorId_"^"
		}
	}
	/*
	s CTMUChildsub=""
	for {
		s CTMUChildsub=$O(^CTLOC(Loc,"MU",CTMUChildsub))
		Q:CTMUChildsub=""
		s MUCPChildsub=""
		for {
			s MUCPChildsub=$O(^CTLOC(Loc,"MU",CTMUChildsub,"CP",MUCPChildsub))
			Q:MUCPChildsub=""
			s DoctorId=$p(^CTLOC(Loc,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1)
			i MedUnitDocStr="" {
				s MedUnitDocStr="^"_DoctorId_"^"
			}else{
				s MedUnitDocStr=MedUnitDocStr_"!"_"^"_DoctorId_"^"
			}

		}
	}*/
	i MedUnit="on" {
		;s DocId="^"_DocId_"^"
		s PatDoc="^"_PatDoc_"^"
		i MedUnitDocStr[PatDoc s Allow=1
	}else{
		i ((PatDoc'="")&&(PatDoc=DocId)) s Allow=1
	}
	Q Allow
}

// ,LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String

// LocID As %String, UserID As %String, IPAddress As %String, AllPatient As String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String

Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String")
{
}

/// creator:李相宗
/// date:2011-11-30
/// desc:得到病人就诊医生的所在组的组长
/// input:CTLOCRowId就诊科室ID	DoctorID就诊医生ID
/// outPut:DocMessage 就诊医生所在组的组长和DocID
/// debug:w ##class(web.DHCDocInPatientList).GetHadeUniteDoc("810","1595")
ClassMethod GetHadeUniteDoc(DoctorID As %String, CTLOCID As %String) As %Status
{
	
    s date=+$P($H,",",1)
 	s Str=""
	s SSUSRCareProvDR=DoctorID
    s CTMUChildsub=0  f  s CTMUChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub)) q:(CTMUChildsub="")||(Str'="")  d
    .s CTMUActiveFlag=$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",3)
    .q:CTMUActiveFlag'="Y"  //单元是激活状态
    .s DateFrom1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",4) //单元没有过期，有效状态
    .q:((date<DateFrom1)&&(DateFrom1'=0))
    .s DateTo1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",5)
    .q:(date>DateTo1)&&(DateTo1'=0)
    .s IsExist=0,LeaderDoctorDR=""
 	.s MUCPChildsub=0 f  s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  d
 	..s MUCPDoctorDR=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1) 
	..if (MUCPDoctorDR=SSUSRCareProvDR) s IsExist=1
	..s MUCPLeaderFlag=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",2) //取组长标志
	..s DateFrom2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",5)
	..q:((date<DateFrom2)&&(DateFrom2'=0)) //单元中的用户没有超出有效期
	..s DateTo2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",6)
	..q:((date>DateTo2)&&(DateTo2'=0))
	..if (MUCPLeaderFlag="Y") s LeaderDoctorDR=MUCPDoctorDR
	.i (IsExist=1)&&(LeaderDoctorDR'="") s Str=CTLOCID_"||"_CTMUChildsub_"^"_LeaderDoctorDR //_"^"_MUCPDoctorDR_"^"_SSUSRCareProvDR
	if (Str="") s Docdesc=$P($g(^CTPCP(DoctorID,1)),"^",2)
	else  s Docdesc=$P($g(^CTPCP($P(Str,"^",2),1)),"^",2)
	q Docdesc
}

/// 取得住院病人体重
/// w ##class(web.DHCDocInPatientList).GetWeight(219)
ClassMethod GetWeight(AdmRowid As %String)
{
	s Weight=""
	s MRAdm=$p($g(^PAADM(AdmRowid)),"^",61)
	q:MRAdm="" ""
	
	s ChildSub=0
	f  s ChildSub=$o(^MR(MRAdm,"OBS",ChildSub)) q:ChildSub=""  d
	.s TypeDR=$p(^MR(MRAdm,"OBS",ChildSub),"^",1)
	.s TypeDesc=$p(^MRC("OBITM",TypeDR),"^",2)
	.q:TypeDesc'["体重"
	.s Weight=$p(^MR(MRAdm,"OBS",ChildSub),"^",2)
	i Weight'="" s Weight=Weight_" kg"
	q Weight
}

/// creator:李相宗
/// date:2011-11-30
/// desc:得到科室所对应的病房
/// input:CTLOCRowId	科室ID
/// debug:d ##class(web.DHCDocInPatientList).GetPACWard("","31")
ClassMethod GetPACWard(JSFunName As %String, CTLOCID As %String) As %Status
{
	//s ^Tempzong=CTLOCID
    s Desc="",value=""
    //s retval=JSFunName_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
    //&javascript<#(retval)#>
    q:CTLOCID=""
    s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
   .s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
   .s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
   ..s value=WardID
   ..s Desc=$P(^PAWARD(WardID),"^",2)
   ..if $P(Desc,"-",2)'="" s Desc=$P(Desc,"-",2)
   ..s retval=JSFunName_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
   .. &javascript<#(retval)#>
    q 0
}

/// 根据病区的id来取到病区的描述
ClassMethod GetPACWardDescById(PACWardId)
{
	q:PACWardId="" ""
	s ret=""
	s ret=$p($g(^PAWARD(PACWardId)),"^",2)
	q ret
}

}
