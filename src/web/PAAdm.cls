Include webimport

IncludeGenerator webimport

Class web.PAAdm Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6604;

Parameter SQLCODE = "PAADM_ADMNo";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "PAADM_ADMNo";

Parameter SQLROWID = "PAADM_RowID";

Property dummy As %String(TRUNCATE = 1);

/// Used to select adm discharge date if exists, else adm date.  for new adm, set date = today
ClassMethod SetCodetableValidDate(EpisodeID As %String = "") As %Library.Date
{
	n obj
	s valdate=..%SysDate()
	s obj=##class(User.PAAdm).%OpenId(EpisodeID)
	if $IsObject(obj){
		s valdate=obj.PAADMDischgDate
		if valdate="" s valdate=obj.PAADMAdmDate
		d obj.%Close()
	}
	Quit valdate
}

/// log63014 TedT
ClassMethod GetAdmDoctor(EpisodeID As %String = "") As %String
{
}

ClassMethod GetIPAdm(PatientID As %String, OTflag As %String = "") As %Library.String
{
}

ClassMethod GetEpisodeIDOnGNandPatient(PatientID As %String, GroupNumber As %String = "") As %Library.String
{
}

/// Creator:	  周志强
/// CreatDate:	2009.07.30
/// Description:  判断病人是否在本院就诊过
/// Table:		PA_Adm
/// Input:		PatientID:病人指针
/// Return:	   1:是  0:否
/// Others:	   此方法会被web.DHCOPAdmReg调用 
ClassMethod GetReAdmFlag(PatientID As %String) As %String
{
	;w ##class(web.DHCOPAdmReg).GetAdmRecord("00000013")
	s flag=0
	If $g(PatientID)'="" do
	.s Adm="" f  Set Adm=$o(^PAPERdr(PatientID,"ADM","O",Adm)) quit:(Adm="")!(flag=1)  d
	..s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	..i VisitStatus'="A" d  q 
	..s admdate=$p($g(^PAADM(Adm)),"^",6)
	..s flag=1
	q flag
}

ClassMethod GetDefaultBillType(PatCatDr As %String)
{
	s AdmReason=""
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
}

/// Computed Value for field number PAADMN_No
ClassMethod CompADMNo(TYPE As %String) As %String
{
	 S TYPE=$P($G(TYPE),$C(1))
	 ;if they pass something wrong instead of type
	 i " I E O H "'[(" "_TYPE_" ") s TYPE="O"
	 f j=1:1:9 s patcf(j)=$g(^CF("PATCF",1,j))
	 i TYPE="I" D
	 .s pref=$p(patcf(1),"^",17),suf=$p(patcf(1),"^",18),len=$p(patcf(3),"^",3)
	 i TYPE="E" D
	 .s pref=$p(patcf(1),"^",13),suf=$p(patcf(1),"^",14),len=$p(patcf(3),"^",1)
	 i " O "[TYPE D
	 .s pref=$p(patcf(1),"^",23),suf=$p(patcf(1),"^",24),len=$p(patcf(3),"^",4)
	 i " H "[TYPE D
	 .;s pref=$p(patcf(8),"^",12),suf=$p(patcf(8),"^",13),len=$p(patcf(8),"^",14)
	 .s pref=$p(patcf(9),"^",3),suf=$p(patcf(9),"^",4),len=$p(patcf(9),"^",15)
	 s:'len len=10
nx 
	 s cnt=$zincr(^PAADM(0,"CNT",TYPE))
	 i $length(cnt)>len s len=$length(cnt)
	 s num=pref_..LPAD(cnt,"0",len)_suf
	 i num'="",$d(^PAADMi("No",$ZCVT(num,"U"))) s err=$$znum(num) g nx
	 q num
znum(num) ;set trap
	 ;n i
	 s i=$zincr(^znum(0)),^znum(i)=$g(num)_"^"_$h
	 q 0
}

ClassMethod LPAD(STRING, SUB, LENGTH) As %String
{
	 ;N RES
	 q:'$g(LENGTH) ""
	 i '$g(LENGTH) s LENGTH=6
	 S $P(RES,SUB,LENGTH)=SUB
	 Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,1,LENGTH)
}

ClassMethod ProcessInsert(pat, proc) As %String
{
	 ;insert patient process
	 q:proc proc
	 ;check configuration
	 i $p($g(^CF("PATCF",1,5)),"^",6)'["Y" q ""
	 k PLIST
	 s PLIST(2)=pat,PLIST(7)=..%SysDate(),PLIST(5)="N",PLIST(4)="O"
	 s PLIST(6)=$$Counter()
	 &SQL(Insert into SQLUser.PA_Process Values :PLIST())
	 ;s err=$$insert^MVBPAPRC()
	 q $g(%ROWID)
Counter()  ; Next sequence number
	 ;n No,Prefix,Suffix,Length 
	 ; 
	 s Suffix=$p($g(^CF("PATCF",1,5)),"^",9)
	 s Prefix=$p($g(^CF("PATCF",1,5)),"^",8)
	 s Length=$p($g(^CF("PATCF",1,5)),"^",10)
	 s:'Length Length=8
	 ;s No=+$$NEXT("^PAPER(0,""CNT"",""PROC"")")
	 s No=+$i(^PAPER(0,"CNT","PROC"))
	 q Prefix_..LPAD(No,"0",Length)_Suffix
}

ClassMethod ADMInsert(PatientID As %Library.String = "_zz", AdmDate As %Library.String = "_zz", AdmTime As %Library.String = "_zz", AdmDoc As %Library.String = "_zz", AdmDep As %Library.String = "_zz", RefDoc As %Library.String = "_zz", RefDate As %Library.String = "_zz", Payor As %Library.String = "_zz", Plan As %Library.String = "_zz", PayorOffice As %Library.String = "_zz", InsDateFrom As %Library.String = "_zz", InsDateTo As %Library.String = "_zz", EpisodeID As %Library.String = "_zz", AdmType As %Library.String = "_zz", Bed As %Library.String = "_zz", P0 As %Library.String = "", P1 As %Library.String = "", P2 As %Library.String = "", P3 As %Library.String = "", P4 As %Library.String = "", P5 As %Library.String = "") As %Library.String
{
	;wanghc 加new,住院登记，不加admdate被重写
	n (PatientID,AdmDate,AdmTime,AdmDoc,AdmDep,RefDoc,RefDate,Payor,Plan,PayorOffice,InsDateFrom,InsDateTo,EpisodeID,AdmType,Bed,P0,P1,P2,P3,P4,P5)
	/*
	PatientID,AdmDate,AdmTime,AdmDoc,AdmDep,RefDoc,RefDate,Payor,Plan,PayorOffice,
	InsDateFrom,InsDateTo,EpisodeID,AdmType,Bed,P0,P1,P2,P3,P4,P5
	*/
	set FirstOrReadmis = ""
	if FirstOrReadmis = ""{
		set FirstOrReadmis="F"
		set ReAdmFlag=..GetReAdmFlag(PatientID)
		if ReAdmFlag=1 set FirstOrReadmis="R"
	}
	set AdmReason = ""
	if (AdmReason = ""){
		set PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		set AdmReason=..GetDefaultBillType(PatCatDr)
	}
	if AdmType '= "I"{
		;set Epissubtype=##class(web.DHCBillInterface).IGetEpisodeSubType(AdmDep,AdmReason)
	}
	set PatientName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
	set ADMNo=..CompADMNo(AdmType)
	set VisitStatus="A"
	set object=##class(User.PAAdm).%New()
	d object.PAADMPAPMIDRSetObjectId(PatientID)
	d object.PAADMDepCodeDRSetObjectId(AdmDep)
	d object.PAADMAdmDocCodeDRSetObjectId(AdmDoc)
	set object.PAADMAdmDate=AdmDate
	set object.PAADMAdmTime=AdmTime
	set object.PAADMType=AdmType
	set object.PAADMVisitStatus=VisitStatus
	set object.PAADMCreateDate=..%SysDate()
	set object.PAADMCreateTime=..%SysTime()
	;d object.PAADMCreateUserSetObjectId(CreateUser)
	set object.PAADMShowInFutureEpisode="Y"
	set object.PAADMConfidential="N"
	set object.PAADMPreAdmitted="N"
	set object.PAADMIsolate="N"
	set object.PAADMCurrent="Y"
	set object.PAADMVerified="N"
	d object.PAADMAdmReasonDRSetObjectId(AdmReason)
	set object.PAADMADMNo=ADMNo
	;d object.PAADMCurrentWardDRSetObjectId(AdmWard)
	;d object.PAADMCurrentRoomDRSetObjectId(AdmRoom)
	d object.PAADMCurrentBedDRSetObjectId(Bed) //AdmBed
	;d object.PAADMEpissubtypeDRSetObjectId(Epissubtype)
	d object.PAADMRefDocListDRSetObjectId(RefDoc) //AdmRefDocListDR
	;d object.PAADMAdmCategDRSetObjectId(AdmCate)
	;set object.PAADMUpdateDate=..%SysDate()
	;set object.PAADMUpdateTime=..%SysTime()
	set object.PAADMPreAdmitDate=AdmDate
	set object.PAADMPreAdmitTime=AdmTime
	set object.PAADMBillFlag="N"
	set object.PAADMSpecialDocument="N"
	set object.PAADMCompleted="N"
	set object.PAADMRequestMR="N"
	set object.PAADMFrequentAdmissions="N"
	set object.PAADMEstDischConfirmed="N"
	set object.PAADMRelated="N"
	set object.PAADMViewablebyEpCareProv="N"
	;set object.PAADMInPatNo=AdmInPatNo
	;d object.PAADMAdmSrcDRSetObjectId(AdmSrcDr)
	;set object.PAADMFirstOrReadmis=FirstOrReadmis
	;set object.PAADMChaplainPhone=BLFlag
	if AdmType="E" set object.PAADMEmergencyStatus="Q"
	if VisitStatus="P" set object.PAADMPreAdmitted="Y"
	;Insert PA_Process
	if " A "[(" "_$p($g(VisitStatus),$c(1))_" ") {
		set ProcessDR = ..ProcessInsert($g(PatientID),"")
		d object.PAADMCurrentProcessDRSetObjectId(ProcessDR)
	}
	
	;set object.PAADMTypeofPatientCalc=""
	set sc = object.%Save()
	if $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	set PAADMRowId=object.%Id()
	/*
	;特病类别
	if AdmDiagnosCatRowId'="" {
		set $P(^PAADM(PAADMRowId,"DHC"),"^",3)=AdmDiagnosCatRowId
	}
	*/
	//update PA_ADM2
	set object1=##class(User.PAAdm2).%OpenId(PAADMRowId)
	set object1.PAADM2Name=PatientName
	set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	;insert MR_ADM
	set object1=##class(User.MRAdm).%New()
	d object1.MRADMADMDRSetObjectId(PAADMRowId)
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	//update PA_ADM.PAADM-MainMRADMDR
	set MRADMRowId=object1.%Id()
	d object.PAADMMainMRADMDRSetObjectId(MRADMRowId)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Tro
		Do $System.Status.DisplayError()
		Q ""
	}
	q PAADMRowId
}

ClassMethod AdmInsertParam1(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod AdmInsertParam2(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod AdmInsertParam3(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod AdmInsertParam4(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod AdmInsertParam5(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod AdmInsertParam6(compref As %Library.String, cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod CheckInjuryPoisoning(EpisodeID As %Library.String) As %Library.Boolean
{
}

ClassMethod CheckForOTBookingsOnEDBedR(eadm As %Library.String = "", patid As %Library.String = "", bconf As %Library.String, startdate As %Library.String = "", inpunit As %Library.String = "") As %Library.Boolean
{
}

ClassMethod CheckPalliativeCare(EpisodeID As %Library.String) As %Library.String
{
}

/// This routine checks to see if the referral date falls within the number of days before the given date.
/// 
/// This is being used for checking appointments against the Admission (LOG 25281). 
ClassMethod CheckReferralDate(EpisodeID As %Library.String, Date As %Library.String = "", days As %Library.String) As %Library.Boolean
{
}

/// cjb 17/06/2003 - 35023
ClassMethod CheckTextAreaLength(compref As %String, id As %String)
{
}

ClassMethod ConvertToInpatient(EpisodeID As %Library.String, compid As %Library.String = "")
{
}

/// ab 1.05.02 - creates statistical admission for discharged inpat admission, if seperation code entered (austin)
ClassMethod CreateStatisticalAdm() As %Library.String
{
}

/// ab 1.08.02 cross validates fields for PAAdm.Edit and PAAdmDischarge.Edit from the code table validations
ClassMethod CrossVal(itmjs As %Library.String, itmjsex As %Library.String, EpisodeID As %Library.String = "", PARAMS As %Library.String = "") As %Library.Boolean
{
	//'CrossVal_lookupsel','ReturnFromCrossVal'
	//q 0 ;失败
	q 1
}

ClassMethod DischargeAll(compref As %Library.String, WardID As %Library.String = "")
{
}

ClassMethod DoNotArrivePatient(ID As %String)
{
}

ClassMethod FindByEpisodeVPClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByEpisodeVPFetch ]
{
}

ClassMethod FindByEpisodeVPExecute(ByRef QHandle As %Library.Binary, status As %Library.String = "") As %Library.Status
{
}

ClassMethod FindByEpisodeVPFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByEpisodeVPExecute ]
{
}

ClassMethod FindByLocDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByLocDateFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindByLocDateExecute(ByRef QHandle As %Library.Binary, location As %Library.String = "", dateFrom As %Library.Date = "", dateTo As %Library.Date = "", PAADMType As %Library.String = "O", VisitStatus As %Library.String = "P", WARDDesc As %Library.String = "", CTPCPDesc As %Library.String = "", HOSPDesc As %Library.String = "", PayorDesc As %Library.String = "", InUK As %Library.String = "", PAPMIName As %Library.String = "", PAPMINo As %Library.String = "", PAPERName4 As %Library.String = "", PAPERName2 As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=""
	s ind=ind+1
	q $$$OK
}

/// SA 13.11.01: Although this query accepts VisitStatus, it has only been written to handle the case where VisitStatus="P-PREADMITTED" (because of conditional indexing).
/// This fetch will need to be re-written to use the indexes for "A-ADMITTED" if it is to be used for admitted episodes.
/// nb. default expression for visit ="P"
/// nb. ^PAADMi("TypeLocDocDateTime",,,,) can only be used for Admitted episodes
ClassMethod FindByLocDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByLocDateExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCurrentPatientsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCurrentPatientsFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindCurrentPatientsExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PARAMS As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	set EpisodeID = ""
	set PatientID = ""
	set mradm = ""
	set BookedBed = ""
	set UR = ""
	set Surname = ""
	set GivenName = ""
	set Name3 = ""
	set age = ""
	set sex = ""
	set sexCode = ""
	set admdate = ""
	set admtime = ""
	set admType = ""
	set DaysIn = ""
	set admdoc = ""
	set DaysOut = ""
	set FirstDayOfLeave = ""
	set Color = ""
	set dob = ""
	set EpisodeDept = ""
	set EpisodeSubType = ""
	set RoomDesc = ""
	set MedicallyFit = ""
	set ExpAdmDate = ""
	set EstDisDate = ""
	set EstDisTime = ""
	set LikelihoodAdmit = ""
	set PriorityDesc = ""
	set PriorityColor = ""
	set PresentComplaint = ""
	set warddesc = ""
	set beddesc = ""
	set NotifDoc = ""
	set NotifLoc = ""
	set DisDate = ""
	set DisTime = ""
	set EstDisConfirmed = ""
	set OESubCatDesc = ""
	set VisitorStatus = ""
	set ReturnDayOfLeave = ""
	set boarder = ""
	set PayorType = ""
	set DischClass = ""
	set waitingTime = ""
	set BookedWard = ""
	set PAADMPayor = ""
	set hospital = ""
	set MRCIDDesc = ""
	set BedExtNo = ""
	set PAADMTriageTime = ""
	set AdmitUnit = ""
	set AdmitDoc = ""
	set CSU = ""
	set edob = ""
	set dimgList = ""
	set ddescList = ""
	set OrderName1 = ""
	set Modifiers1 = ""
	set MainMeal11 = ""
	set MainMeal21 = ""
	set MainMeal31 = ""
	set TriageDate = ""
	set PriorityCode = ""
	set PAADMPayorCode = ""
	set CondAtDisch = ""
	set DOSA = ""
	set PAADMDepType = ""
	set PrivatePayor = ""
	set PrivatePlan = ""
	set AdmitWard = ""
	set AdmitBed = ""
	set CTDSPDesc = ""
	set DISCONDesc = ""
	set OrderName = ""
	set Modifiers = ""
	set MainMeal1 = ""
	set MainMeal2 = ""
	set MainMeal3 = ""
	set PAADMType = ""
	set updatelast12 = ""
	set updatelast24 = ""
	set PAADMSeenDate = ""
	set PAADMSeenTime = ""
	set AdmissionPoint = ""
	set PAADMCurrentWardSigFac = ""
	set DOB = ""
	set PAADMAppointBookingSystemDesc = ""
	set PAADMAdmReasonDesc = ""
	set PAADMPatientContacted = ""
	set PAADMInterviewRec = ""
	set PAADMRemark = ""
	set WLProcedureFreeText = ""
	set WLIntendedWardSigFac = ""
	set BookedWardSigFac = ""
	set PAADM2AdmPointLocDR = ""
	set PAADMADMNo = ""
	set PAPERName4 = ""
	set PAPERName5 = ""
	set PAPERName6 = ""
	set PAPERName7 = ""
	set PAPERName8 = ""
	set VIPStatus = ""
	
	s ^CacheTemp(repid,ind)=$lb(EpisodeID,PatientID,mradm,BookedBed,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,RoomDesc,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,VisitorStatus,ReturnDayOfLeave,boarder,PayorType,DischClass,waitingTime,BookedWard,PAADMPayor,hospital,MRCIDDesc,BedExtNo,PAADMTriageTime,AdmitUnit,AdmitDoc,CSU,edob,dimgList,ddescList,OrderName1,Modifiers1,MainMeal11,MainMeal21,MainMeal31,TriageDate,PriorityCode,PAADMPayorCode,CondAtDisch,DOSA,PAADMDepType,PrivatePayor,PrivatePlan,AdmitWard,AdmitBed,CTDSPDesc,DISCONDesc,OrderName,Modifiers,MainMeal1,MainMeal2,MainMeal3,PAADMType,updatelast12,updatelast24,PAADMSeenDate,PAADMSeenTime,AdmissionPoint,PAADMCurrentWardSigFac,DOB,PAADMAppointBookingSystemDesc,PAADMAdmReasonDesc,PAADMPatientContacted,PAADMInterviewRec,PAADMRemark,WLProcedureFreeText,WLIntendedWardSigFac,BookedWardSigFac,PAADM2AdmPointLocDR,PAADMADMNo,PAPERName4,PAPERName5,PAPERName6,PAPERName7,PAPERName8,VIPStatus)
	s ind=ind+1
	q $$$OK
}

ClassMethod FindCurrentPatientsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCurrentPatientsExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEpisodeWithPayorClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeWithPayorFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Log 28886 BC 6-11-2002 Speeding up the PAAdm.Tree.  The original query has been retained in PAAdmMedFit
/// by wuqk 2011-06-25* 输出不明确
ClassMethod FindEpisodeWithPayorExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String = "", admType As %Library.String = "", VISITSTATUS As %Library.String = "", ADMINTTYPE As %Library.String = "", VERIFIED As %Library.String = "", CodeEpisode As %Library.String = "", EpisodeIDs As %String = "", SameHospital As %String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	n EpisodeID,PAADMADMNo,PAADMAdmDate,PAADMAdmTime,CTLOCDesc,CTPCPDesc,PAADMVisitStatus
	n DEPDesc,PAADMRemark,SERDesc,PAADMType,payor,mradm,PAADMDischgDate,PAADMDischgTime
	n REFPRIDesc,RSTDesc,REFTDesc,WARDDesc,WLType,WLRowId,GPConsent,CodingStatus,CARETYPDesc
	n IPATDesc,AdmSrc,Hosp,CTDSPDesc,Plan,Outstanding,RESDesc,MRADMGPConsent,ACUDesc,ADMCATDesc
	n RegNo,Surname,FirstName,DischSource,SIGNFDesc,RUDesc,RefSource,OPDaysWaiting,LengthOfStay
	n DiagPC,VisitRefStatus,OtherName,Sex,DOB,Bed,CTPCPCode,DDESTDesc,REFDDesc,SUBTDesc
	n VisitDischStatus,WLRemarks,SPPPCode,SPPPDesc,WLProcedureFreeText,RBCServ,WLAdmComment
	n IntendedWard,PAADMFinDischDate,PAADMMedDischDate,PAADMSpecialCategory,PAADMFlaggedPatient
	n PAADM2ReferredToHospitalDR,PAADMVerified,payorCategory,IsCoded,VIPStatus,CMCTPCPDesc
	n HidPAADMVisitStatus,GroupNumber,OrigAdmNo,HidFAUpdateUser,HidFAUpdateDate,HidComents,HidFAConcern,PatientType
	/*
	set ^Temp("Upgrade","FindEpisodeWithPayor","TSRTITM")=TSRTITM
	set ^Temp("Upgrade","FindEpisodeWithPayor","TSRTORD")=TSRTORD
	set ^Temp("Upgrade","FindEpisodeWithPayor","PatientID")=PatientID
	set ^Temp("Upgrade","FindEpisodeWithPayor","admType")=admType
	set ^Temp("Upgrade","FindEpisodeWithPayor","VISITSTATUS")=VISITSTATUS
	set ^Temp("Upgrade","FindEpisodeWithPayor","ADMINTTYPE")=ADMINTTYPE
	set ^Temp("Upgrade","FindEpisodeWithPayor","VERIFIED")=VERIFIED
	set ^Temp("Upgrade","FindEpisodeWithPayor","CodeEpisode")=CodeEpisode
	set ^Temp("Upgrade","FindEpisodeWithPayor","EpisodeIDs")=EpisodeIDs
	set ^Temp("Upgrade","FindEpisodeWithPayor","SameHospital")=SameHospital*/
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	//quit:'$d(^PAPERdr(PatientID,"ADM")) $$$OK
	&sql(select PAPMI_No,PAPER_Dob,PAPER_SurName,PAPER_Sex_DR->CTSEX_Desc,
			PAPMI_VIPFlag
	     into :RegNo,:Dob,:SurName,:Sex,
	          :VIPStatus
	from PA_PatMas,PA_Person where PAPMI_RowId=PAPER_RowId and PAPMI_RowId=:PatientID)
	 
	&sql(declare cfewp cursor for 
		select PAADM_RowID,PAADM_AdmNo,PAADM_AdmDate,PAADM_AdmTime,
		PAADM_DepCode_DR->CTLOC_Desc,PAADM_AdmDocCodeDR->CTPCP_Desc,
		PAADM_VisitStatus,PAADM_Remark,PAADM_Type,PAADM_MainMRADM_DR,
		PAADM_DischgDate,PAADM_DischgTime,PAADM_RefPeriod_DR->REFPER_Desc,
		PAADM_CurrentWard_DR->WARD_Desc,PAADM_Hospital_DR->HOSP_Desc,
		PAADM_CurrentBed_DR->BED_Code,PAADM_AdmDocCodeDR->CTPCP_Desc,
		PAADM_FinDischDate,PAADM_MedDischDate,PAADM_SpecialCategory,PAADM_FlaggedPatient,
		PAADM_Verified
		into :EpisodeID,:PAADMADMNo,:PAADMAdmDate,:PAADMAdmTime,
		:CTLOCDesc,:CTPCPDesc,
		:PAADMVisitStatus,:PAADMRemark,:PAADMType,:mradm,
		:PAADMDischgDate,:PAADMDischgTime,:REFPRIDesc,
		:WARDDesc,:Hosp,
		:Bed,:CTPCPCode,
		:PAADMFinDischDate,:PAADMMedDischDate,:PAADMSpecialCategory,:PAADMFlaggedPatient,
		:PAADMVerified
		from PA_Adm where PAADM_PAPMI_DR=:PatientID order by PAADM_AdmDate desc,PAADM_AdmTime desc)
	
	&sql(open cfewp)
	for {
		&sql(fetch cfewp)
        quit:SQLCODE  
        do BuildEpisodeWithPayor
	}
	&sql(close cfewp)
	quit $$$OK
	
BuildEpisodeWithPayor
	set data=$lb()
	set $li(data,1)=$g(EpisodeID) 
	set $li(data,2)=$g(PAADMADMNo)
	set $li(data,3)=$g(PAADMAdmDate)
	set $li(data,4)=$g(PAADMAdmTime)
	set $li(data,5)=$g(CTLOCDesc)
	set $li(data,6)=$g(CTPCPDesc)
	set $li(data,7)=$g(PAADMVisitStatus)
	//set $li(data,8)=$g(//DEPDesc)
	set $li(data,9)=$g(PAADMRemark)
	//set $li(data,10)=$g(//SERDesc)
	set $li(data,11)=$g(PAADMType)
	//set $li(data,12)=$g(//payor)
	set $li(data,13)=$g(mradm)
	set $li(data,14)=$g(PAADMDischgDate)
	set $li(data,15)=$g(PAADMDischgTime)
	set $li(data,16)=$g(REFPRIDesc)
	//set $li(data,17)=$g(RSTDesc)  //PAADM_RefStat_DR????
	//set $li(data,18)=$g(REFTDesc)
	set $li(data,19)=$g(WARDDesc)
	//set $li(data,20)=$g(WLType)
	//set $li(data,21)=$g(WLRowId)
	//set $li(data,22)=$g(GPConsent)
	//set $li(data,23)=$g(CodingStatus)
	//set $li(data,24)=$g(CARETYPDesc)
	//set $li(data,25)=$g(IPATDesc)
	//set $li(data,26)=$g(AdmSrc)
	set $li(data,27)=$g(Hosp)
	//set $li(data,28)=$g(CTDSPDesc)
	//set $li(data,29)=$g(Plan)
	//set $li(data,30)=$g(Outstanding)
	
	//set $li(data,31)=$g(RESDesc)
	//set $li(data,32)=$g(MRADMGPConsent)
	//set $li(data,33)=$g(ACUDesc)
	//set $li(data,34)=$g(ADMCATDesc)
	set $li(data,35)=$g(PatientID)
	set $li(data,36)=$g(RegNo)
	set $li(data,37)=$g(Surname)
	//set $li(data,38)=$g(FirstName)
	set $li(data,39)=$g(DischSource)
	set $li(data,40)=$g(SIGNFDesc)
	set $li(data,41)=$g(RUDesc)
	set $li(data,42)=$g(RefSource)
	set $li(data,43)=$g(OPDaysWaiting)
	set $li(data,44)=$g(LengthOfStay)
	set $li(data,45)=$g(DiagPC)
	set $li(data,46)=$g(VisitRefStatus)
	//set $li(data,47)=$g(OtherName)
	set $li(data,48)=$g(Sex)
	set $li(data,49)=$g(DOB)
	set $li(data,50)=$g(Bed)
	set $li(data,51)=$g(CTPCPCode)
	/*
	set $li(data,52)=$g(DDESTDesc)
	set $li(data,53)=$g(REFDDesc)
	set $li(data,54)=$g(SUBTDesc)
	set $li(data,55)=$g(VisitDischStatus)
	set $li(data,56)=$g(WLRemarks)
	set $li(data,57)=$g(SPPPCode)
	set $li(data,58)=$g(SPPPDesc)
	set $li(data,59)=$g(WLProcedureFreeText)
	set $li(data,60)=$g(RBCServ)
	set $li(data,61)=$g(WLAdmComment)
	set $li(data,62)=$g(IntendedWard)*/
	set $li(data,63)=$g(PAADMFinDischDate)   //PAADM_FinDischDate
	set $li(data,64)=$g(PAADMMedDischDate)    //PAADM_MedDischDate
	set $li(data,65)=$g(PAADMSpecialCategory)  //PAADM_SpecialCategory
	set $li(data,66)=$g(PAADMFlaggedPatient)   //PAADM_FlaggedPatient
	//set $li(data,67)=$g(PAADM2ReferredToHospitalDR)
	set $li(data,68)=$g(PAADMVerified)         //PAADM_Verified
	/*
	set $li(data,69)=$g(payorCategory)
	set $li(data,70)=$g(IsCoded)
	set $li(data,72)=$g(CMCTPCPDesc)
	*/
	set $li(data,73)=$g(PAADMVisitStatus) ;HidPAADMVisitStatus
	/*set $li(data,74)=$g(GroupNumber)
	set $li(data,75)=$g(OrigAdmNo)
	set $li(data,76)=$g(HidFAUpdateUser)
	set $li(data,77)=$g(HidFAUpdateDate)
	set $li(data,78)=$g(HidComents)
	set $li(data,79)=$g(HidFAConcern)*/
	set $li(data,71)=$g(VIPStatus)     //PAPMI_VIPFlag
	set $li(data,80)=$g(PatientType)   //PAPER_PatType_DR->PTYPE_Desc
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q $$$OK
}

ClassMethod FindEpisodeWithPayorFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeWithPayorExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFAFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindFAExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String = "", StartDate As %Library.Date = "", EndDate As %Library.Date = "", AdmType As %Library.String = "", Flags As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

ClassMethod FindFAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindFAExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Purpose - To return a string of 0 and 1 respresenting if there is information behind the four links.  The pieces 
/// are as follows - 
/// 1 -medicallyFit
/// est discharge history
/// scanning doc
/// viewable by
/// by wuqk 2011-06-21 从原环境测试，暂定输出，尚未确定逻辑
ClassMethod FindIfLinksDataPAAdmEdit(EpisodeID As %Library.String)
{
	quit "0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0"
}

ClassMethod FindIncompleteClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindIncompleteFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindIncompleteExecute(ByRef QHandle As %Library.Binary, loc As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

ClassMethod FindIncompleteFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindIncompleteExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod FindMultiviewClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMultiviewFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindMultiviewExecute(ByRef QHandle As %Library.Binary, LocType As %Library.String = "", Location As %Library.String = "", CareProv As %Library.String = "", DateFrom As %Library.Date = "", DateTo As %Library.Date = "", TimeFrom As %Library.Time = "", TimeTo As %Library.Time = "", OrderCategory As %Library.String = "", LocationOfInPat As %Library.String = "", PAADMLikelihoodAdmit As %Library.String = "", DEPDesc As %Library.String = "", EpisodeNo As %Library.String = "", TRDDesc As %Library.String = "", PAPMIName As %Library.String = "", DISCONDesc As %Library.String = "", ExtraParams As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

/// AB 08.03.02 - log 23267
/// Query for PACBed.CustomFind
ClassMethod FindMultiviewFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMultiviewExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindReferralDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReferralDetailsFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindReferralDetailsExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", ToDate As %Library.Date = "", FromDate As %Library.Date = "", Status As %Library.String = "", CTPCPDesc As %Library.String = "", HOSPDesc As %Library.String = "", HCADesc As %Library.String = "", weeksWaiting As %Library.String = "", REFPRICode As %Library.String = "", CTACUDesc As %Library.String = "", HCPPDesc As %Library.String = "", PAPMIName As %Library.String = "", noAppt As %Library.String, HiddenFindParameters As %Library.String = "^^") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

ClassMethod FindReferralDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReferralDetailsExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRestrIncomplClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRestrIncomplFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindRestrIncomplExecute(ByRef QHandle As %Library.Binary, loc As %Library.String, AdmType As %Library.String = "", WaitList As %Library.String = "", CurrentPat As %Library.String = "", Discharged As %Library.String = "", datefrom As %Library.String = "", dateto As %Library.String = "", CarPrvLastTreated As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	//EpisodeID,PatientID,mradm,BookedBed,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,RoomDesc,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,VisitorStatus,ReturnDayOfLeave,boarder,PayorType,DischClass,waitingTime,BookedWard,PAADMPayor,hospital,MRCIDDesc,BedExtNo,PAADMTriageTime,AdmitUnit,AdmitDoc,CSU,edob,dimgList,ddescList,OrderName1,Modifiers1,MainMeal11,MainMeal21,MainMeal31,TriageDate,PriorityCode,PAADMPayorCode,CondAtDisch,DOSA,PAADMDepType,PrivatePayor,PrivatePlan,AdmitWard,AdmitBed,CTDSPDesc,DISCONDesc,OrderName,Modifiers,MainMeal1,MainMeal2,MainMeal3,PAADMType,updatelast12,updatelast24,PAADMSeenDate,PAADMSeenTime,AdmissionPoint,PAADMCurrentWardSigFac,DOB,PAADMAppointBookingSystemDesc,PAADMAdmReasonDesc,PAADMPatientContacted,PAADMInterviewRec,PAADMRemark,WLProcedureFreeText,WLIntendedWardSigFac,BookedWardSigFac,PAADM2AdmPointLocDR,PAADMADMNo,PAPERName4,PAPERName5,PAPERName6,PAPERName7,PAPERName8,VIPStatus"
	
	s ^CacheTemp(repid,ind)=$lb("")
	s ind=ind+1
	q $$$OK
}

ClassMethod FindRestrIncomplFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRestrIncomplExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindUnverifiedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindUnverifiedFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindUnverifiedExecute(ByRef QHandle As %Library.Binary, loc As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

ClassMethod FindUnverifiedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindUnverifiedExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// by wuqk 2011-06-02
ClassMethod GetAdmDateByID(ID As %Library.String) As %Library.Date
{
	if ID="" quit ""
	quit +$p($g(^PAADM(ID)),"^",6)
}

ClassMethod GetAdmTimeByID(ID As %Library.String) As %Library.Time
{
}

ClassMethod GetArrayDetailsFP(EpisodeID As %Library.String, ByRef ARY As %Library.String)
{
}

ClassMethod GetClinicAddress(EpisodeID As %Library.String = "") As %Library.String
{
}

/// SA 29.11.01: This method is called via Hidden Field "ConflictMessage" on component PAAdm.Edit
/// Conflict search implementation for log 20904, Admission screen requirement 4:
/// ab 13.10.03 - rewrote this to use indexes, speeded up quite a bit
/// by wuqk 2011-06-21 used in PAAdm.Edit Component
ClassMethod GetConflictMessage(PatientID As %Library.String, EpisodeID As %Library.String, WaitingListID As %Library.String, date As %Library.String = "") As %Library.String
{
	quit ""
}

/// SA 29.11.01: This method is called via Hidden Field "ConflictMessage" on component PAAdm.Edit
/// 
/// Conflict search implementation for log 20904, Admission screen requirement 4:
/// 
/// 4.	The system will automatically perform a "conflict search" and notify the user via a message based on the following rules: (logged as 20904)
/// If any type of future booking has been made:
/// Outpatient  	Future appointments for the next 5 days.
/// Inpatient		Future TCIs or Pre-admissions within the next 5 days.
/// Current Waiting List entry:  If patient has a current waiting list entry for this specialty then summary details of the entry should be displayed.  This should include:
/// ¨	Date on List;
/// ¨	HCP;
/// ¨	Intended Procedure;
/// ¨	Diagnosis (free text).
ClassMethod GetConflictMessageForAppt(PatientID As %Library.String, EpisodeID As %Library.String, WaitingListID As %Library.String, date As %Library.String, TransApptID As %Library.String = "") As %Library.String
{
}

/// A method to return the previously stored values of PAADMRefDrConsent, PAADMConsentPatSatisfSurve 
/// PAADMConsentRecFundInfo and MRADMGPConsent.  The values are returned in a "^" delimated string in
/// following order 
/// PAADMRefDrConsent^PAADMConsentPatSatisfSurve^PAADMConsentRecFundInfo^MRADMGPConsent.
/// 
/// For an existing episode it returns the values stored in that episode.  For new episodes, it returns the values 
/// from the most recent episode.  When it is a new episode and there no existing previous episodes the values 
/// are defaulted as "Yes".  Default values are always "Yes" (translatable). 
ClassMethod GetConsents(PatientID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.String
{
	q "^^^^"
}

/// ab 18.04.02 - 23625
/// called from Workflow Trak.Discharge
/// sets all the carried over fields for the new episode from the previous episode
/// when a patient is discharged on leave
ClassMethod GetDetailsFromPrevLeave(id As %Library.String) As %Library.String
{
}

ClassMethod GetEDWdesc(DepCode As %Library.String, WardCode As %Library.String) As %Library.String
{
}

/// SA: Method implemented to call all methods used by component PAAdm.EditEmergency
ClassMethod GetEmergencyDetails(EpisodeID As %Library.String)
{
}

ClassMethod GetEpisodeComments(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetEpisodeService(EpisodeID As %String) As %String
{
}

ClassMethod GetGuarAdmDate(AdmDept As %Library.String, Adm As %Library.String = "") As %Library.Date
{
}

ClassMethod GetInPatientAdmType(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetLatestInpatFromRegNo(regnum As %Library.String) As %Library.String
{
}

/// GR 06/02/02 for log 22683.  gets the length of stay for procdures based on code table
/// ab 18.04.02 - took out WL operation/procedure stuff
ClassMethod GetLengthOfStay(id As %Library.String) As %Library.String
{
	quit ""
}

/// by wuqk 2011-06-01
ClassMethod GetMRAdm(EpisodeID As %String = "") As %String
{
	Quit $p($g(^PAADM(+EpisodeID)),"^",61)
}

/// changes to add orders and  Modifiers
/// by wuqk 2011-06-21 未实现
ClassMethod GetOriginalAdmissionDischarge(adm As %Library.String) As %Library.String
{
	quit "^^^^"
}

/// KM 4-Mar-2002: For general Use
/// by xuqy 2011-7-26
/// w ##Class(web.PAAdm).GetPAADMField(77128,"PAADMLikelyTransICUDR","LTICUDesc")
ClassMethod GetPAADMField(EpisodeID As %Library.String = "", Field As %Library.String = "", DRField As %Library.String = "") As %Library.Status
{
	n obj,exp,val
	if Field="" Q ""
	q:EpisodeID="" ""
	s obj=##class(User.PAAdm).%OpenId(EpisodeID)
	if '$ISObject(obj) Q ""
	s exp="s val=obj."_Field
	if DRField'="" {
		s exp=exp_"."_DRField
	}
	x exp
	Q val
}

/// called from:
/// ID item on PAAdm.Edit
/// ID item on PAADMDischarge.Edit
/// GetEmergencyDetails method
ClassMethod GetPAADM2Details(EpisodeID As %String = "")
{
}

/// KM 4-Mar-2002: For general Use
/// by xuqy 2011-7-26 
ClassMethod GetPAADMPriorityDR(EpisodeID As %Library.String) As %Library.String
{
	q:EpisodeID="" ""
	s PriorityDR=$p($g(^PAADM(EpisodeID)),"^",33)
	s PriorityDR=+PriorityDR
	q:PriorityDR=0 ""
	s CTACUDesc=$p($g(^CT("ACU",PriorityDR)),"^",2)
	q CTACUDesc
}

/// Get the patient id given the episode/admission id
ClassMethod GetPatientId(episodeid As %String = "") As %String
{
	
	n PatientId
	if episodeid = "" quit ""
	if $g(^PAADM(episodeid)) = "" quit ""
	set PatientId = $P(^PAADM(episodeid),"^",1)
	quit PatientId
}

ClassMethod GetPalliativeCarePatDays(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetPatientPrevAdm(PatientID As %String = "", type As %String = "", vstat As %String = "") As %Library.Boolean
{
}

ClassMethod GetPrevAdmiss(pat As %Library.String, episodeID As %Library.String)
{
}

/// ab 17.04.02
/// returns length of stay for previously discharged inpatient episode
/// md.30/01/2003
/// returns length of stay for previously discharged inpatient episodes
/// (all ip episode within seven days diffence betwen previus episode discharge and curent episode admission)
ClassMethod GetPrevLOS(pat As %Library.String, curr As %Library.String = "") As %Library.String
{
	;结转天数
	q:curr="" 0
	s str=""
	s:$d(^PAADM(curr,2)) str = $p(^PAADM(curr,2),"^",95) ;PAADMDaysCarriedForward
	q str
}

/// Called from component web.PAAdm.DRGCoding (field EpisodeID) to determine 
/// the next and previous episodes.
/// 
/// SA 13.3.03 - log 33873: ARMC currently only code Inpatient Admissions. 
/// Have changed query to only return Inpatient Admissions. Clause added to query:
/// AND (PAADM_Type = ("I"))
/// If at a later stage another site wishes to code outpatient and emergency, will need to 
/// change this query to accept parameter for valid admission types and filter by those.
ClassMethod GetPreviousEpisodeDetails(PatientID As %Library.String, EpisodeID As %Library.String)
{
}

/// Author - John Hart
/// Purpose - To return the Patient's Temporary Location
/// Used By - PAAdmTransaction.Edit
ClassMethod GetTemporaryLocation(EpisodeID As %Library.String = "") As %Library.String
{
}

/// ab 14.03.03 - returns total num of bed days for QH
/// Counting Rules:
/// 1. A bed day is counted for the day of admission.
/// 2. A bed day is not counted for the day of discharge. 
/// 3. For patients admitted and discharged on the sameday, count one bed day (no leave days).
/// 4. For any given date, either a bed day or a leave day may be counted, but not both.
/// 5. A bed day is counted for the day the patient returns from leave,
/// unless the return from leave date is equal to the discharge date, then a bed day is not counted.
/// 6. An occupied bed day is not counted for the day the patient is sent on leave or any subsequent days on leave,
/// even if  the  on leave date is equal to the admission date.
ClassMethod GetTotalBedDays(EpisodeID As %Library.String = "", DischOnly As %Library.String = 0) As %Library.String
{
}

ClassMethod GetUrgentCancerMessage(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetWaitingListRemarks(PatientID As %Library.String = "") As %Library.String
{
}

/// This insert/update is only valid for emergency admissions. 
ClassMethod HtmlEmergSave(compref As %Library.String, id As %String)
{
}

ClassMethod InsertEpisodeWithAppt(PatientID As %Library.String, ApptID As %Library.String, RefD As %Library.String = "") As %Library.String
{
}

ClassMethod IsAlreadyTriaged(PAPMIName As %Library.String = "", PAPMIName2 As %Library.String = "", PAPMIDob As %Library.Date = "", PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IsCurrentInpatient(PatientID As %Library.String) As %Library.String
{
}

/// ab 22.05.03
/// returns if an patient is an outlier
ClassMethod IsOutlier(EpisodeID As %Library.String = "", WardID As %Library.String = "") As %Library.String
{
}

/// used in icon definition 'Patient Type - Recently Discharged'
ClassMethod IsRecentlyDischarged(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

/// Used by PAAdmTransaction websys.Save to check that careprovider/unit is a valid combination
ClassMethod IsValidCareProvider(careprov As %Library.String, location As %Library.String) As %Library.Boolean
{
}

/// This method sets the LayoutID to the Main Chart
ClassMethod PatientEpisodeList(PatientID As %String)
{
}

ClassMethod PatientLatestEpisode(PatientID As %String)
{
}

/// ab 18.03.02 - finds if patient has been refused consent on any of their episodes
/// ie. gpconsent = "n"
ClassMethod PatientRefusedConsent(PatientID As %Library.String) As %Library.String
{
}

/// BC 6-Feb-2002: This routine has been introduced to do the following - 
/// 
/// (1) Is the admission has been discharged the discharge date is returned
/// (2) If the admission is not discharge but on leave the start date of the leave is returned
/// (3) if the admission is not discharged and not on leave a blank is returned
/// (4) if no admission ID is given then "Error" is returned 
ClassMethod ReturnDischargeDate(ID As %Library.String) As %Library.Date
{
}

/// cjb 01/02/2005 49390 - rewritten, don't need to open the object, esp if it's not closed
/// by wuqk 2011-06-02
ClassMethod ReturnDischargeDateOnly(ID As %Library.String) As %Library.Date
{
	q +$h
}

/// cjb 01/02/2005 49390 - rewritten, don't need to open the object, esp if it's not closed
/// BC 6-Feb-2002: This routine has been introduced to do the following - 
/// 
/// (1) Is the admission has been discharged the discharge time is returned
/// (2) If the admission is not discharge but on leave the start time of the leave is returned
/// (3) if the admission is not discharged and not on leave a blank is returned
/// (4) if no admission ID is given then "Error" is returned 
ClassMethod ReturnDischargeTime(ID As %Library.String) As %Library.Time
{
}

ClassMethod ReverseFinalDischarge(EpisodeID As %Library.String, compid As %Library.String = "")
{
}

ClassMethod ReverseCancellation(EpisodeID As %Library.String, compid As %Library.String = "")
{
}

ClassMethod SetContacted(EpisodeID As %Library.String)
{
}

ClassMethod SetEstDischConfirmed(EpisodeID As %Library.String, flag As %Library.String = "off")
{
}

/// AB - 11.03.02  log 20756
/// Link needed to change 'In UK' status in preadmission list
ClassMethod SetINUK(EpisodeID As %Library.String)
{
}

/// wanghc PAADMDischarge.Edit->StringNatCode
ClassMethod SetNCString(EpisodeID As %Library.String) As %Library.String
{
	
	q ""
}

ClassMethod SetPaliative(EpisodeID As %Library.String, PrevInPatAdmPalliativeCare As %Library.String, PrevNonInPatPalliativeCare As %Library.String, flag As %Library.String) As %Library.String
{
}

ClassMethod SetVerified(EpisodeID As %Library.String)
{
}

/// KM 14-Jan-2002
ClassMethod TAfterUpd()
{
}

/// ab 11.12.03 40017 - used to run brokers on update, for checking start/end dates on existing data
ClassMethod ValidateCodeTableDates(compid As %String, id As %String = "") As %String
{
}

/// KM: 11May2001: Called From FindDocCurrentAdmFetch
/// ab 26.11.04 - 47653 - rewrote this to be sensible
ClassMethod getAllEpisodes(PatientID As %String = "", VisitStatus As %String = "") As %Library.String
{
}

/// by wuqk 2011-06-01
ClassMethod getPatEpisLoc(EpisodeID As %Library.String) As %Library.String
{
	Set langid=..%LanguageID()
	s tmp=$g(^PAADM(+EpisodeID))
    s objLoc=##class(User.CTLoc).%OpenId(+$p(tmp,"^",4))
	s CTLOCDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",objLoc.CTLOCDesc,langid)
	quit:$IsObject(objLoc) CTLOCDesc
	quit ""
}

/// cjb 23/12/2003
/// yl 13/02/2012
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
   
    s $zt="saveerror"
    Q:id="" $$$OK
	Q:new'=1 $$$OK
	Set compid=$e($p(compref,"i",1),2,999)
	Set PatientID=%request.Get("PatientID")
	Set PatientID = $p(^PAADM(id),"^",1)
	;写转移表,增加错误提示 2018-3-26 by wanghc
	s StDate=..%SysDate(), StTime=..%SysTime()
	s curDate = StDate, curTime = StTime
	s userId = $p(^PAADM(id,1),"^",44)		  
	s (wardId, roomId, bedId,bedTypeId,TRANSMain,bedSub,LocationID,CTPCPID)= ""
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))	;PAC_TransfRequestStatus,"Transfer"
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M","")) ;PAC_TransType
	s wardId = $p(^PAADM(id),"^",70)
	s bedId =  $p(^PAADM(id),"^",73)
	s bedSub = $p(bedId,"||",2)
	s roomId =  $p(^PAADM(id),"^",69)
	s:bedSub'="" bedTypeId=$p(^PAWARD(wardId,"BED",bedSub),"^",2)
	s LocationID = $p(^PAADM(id),"^",4)
	s AdmDocCodeDR = $p(^PAADM(id),"^",9)
	;----
	Set BabyAdmWKFL=##class(websys.WorkFlow).GetIdFromCodeOrDescription("Trak.Maternity.Baby")
	Set WKFL=%request.Get("TWKFL")
	Set isBabyAdmWKFL=$s(WKFL=BabyAdmWKFL:1,1:0)
	s ^Wanghc("is baby")=isBabyAdmWKFL
    //如果是分娩工作流
	if (isBabyAdmWKFL){
		Set MotherID=$P($G(^PAPER(PatientID,"PER",4)),"^",13)
		if MotherID>0 {
			Set MotherAdm=""
			Set MoAdm=0
			For  Set MoAdm=$O(^PAPERdr(MotherID,"ADM","I",MoAdm)) Quit:(MoAdm="")!(MotherAdm'="")  Do
			.Set VisitStatus=$P($G(^PAADM(MoAdm)),"^",20)
			.Quit:VisitStatus'="A"
			.Set MotherAdm=MoAdm
			if MotherAdm>0 {
				//母亲的主管医生
				set AdmDocCodeDR = $p(^PAADM(MotherAdm),"^",9)
				//更新主管医生与母亲指向
				&SQL(Update PA_Adm 
					Set PAADM_AdmDocCodeDR = :AdmDocCodeDR,
					PAADM_MotherAdm_Dr = :MotherAdm
				 Where PAADM_RowId= :id)
				 
				 i SQLCODE {
					d msg.AddItem("E","Error","更新新生儿与母亲关联出错",compid,"PAADMAdmDate")
					q 0
				 }
				 S V7EpisodeFlag = $G(^PAADM(MotherAdm,"VER"))
				 i V7EpisodeFlag=7 s ^PAADM(id,"VER")=7
				 e  s ^PAADM(id,"VER")=6
			}
		}
	}
	&SQL(insert into SQLUser.PA_AdmTransaction 
		  (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		  TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		  TRANS_TransType_DR,TRANS_Ward_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
	Values (:id,:StDate,:StTime,
		  :reqstId,:curDate,:curTime,:userId,
		  :transtypId,:wardId,:roomId,:bedId,:bedTypeId,:TRANSMain))		  
	i SQLCODE {
		d msg.AddItem("E","Error","写转移记录出错",compid,"PAADMAdmDate")
		Q 0
	}
	b ;pa_admtransaction
	s transId=$g(%ROWID)
	if (bedId'=""){
		;写床位就诊表
		//&sql(delete from SQLUser.PAC_BedAdm where ADM_ParRef=:bedId)
		&sql(insert into SQLUser.PAC_BedAdm 
					(ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			 Values (:bedId,:id,'O',:transId))			
		i SQLCODE d msg.AddItem("E","Error","写床位就诊信息出错",compid,"PAADMAdmDate") q 0	
	}elseif wardId'="" {
		;写病区就诊表	 
		&sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
		&sql(insert into SQLUser.PAC_WardAdm 
					(WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR,WADM_Room_DR)
			 Values (:wardId,:id,'O',:transId,:roomId))
		i SQLCODE d msg.AddItem("E","Error","写病区就诊信息出错",compid,"WARDDesc") Q 0
	}
	i LocationID'=""{			
		&sql(insert into SQLUser.PA_AdmTransaction 
				(TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
				 TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
				TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,TRANS_Main)  
		Values (:id,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,
				:transtypId,:LocationID,:AdmDocCodeDR,:TRANSMain))	
		i SQLCODE d msg.AddItem("E","Error","写转科转医生出错",compid,"CTLOCDesc") q 0
				
	}
	
	//update PA_ADM2
	SET PAPMIRowId = $p(^PAADM(id),"^",1)
	set PAADM2Name=$P(^PAPER(PAPMIRowId,"ALL"),"^",1)
	&SQL(Update SQLUser.PA_Adm2(PAADM2_Name) values (:PAADM2Name) where PAAdm2_RowId=:id)
	i SQLCODE d msg.AddItem("E","Error","更新新生儿姓名出错",compid,"CTLOCDesc") Q 0
	
	;insert MR_ADM
	&sql(insert into SQLUser.MR_Adm(MRADM_ADM_DR) Values (:id))
	i SQLCODE d msg.AddItem("E","Error","写病案信息出错",compid,"CTLOCDesc") Q 0	
	set MRADMRowId = $G(%ROWID)
	
	//update PA_ADM -> PAADM_MainMRADM_DR	
	&SQL(update SQLUser.PA_Adm(PAADM_MainMRADM_DR) Values (:MRADMRowId) Where PAADM_RowId=:id)
	i SQLCODE d msg.AddItem("E","Error","就诊与病案信息关联出错",compid,"CTLOCDesc") Q 0

	//如果是分娩流程
	i 'isBabyAdmWKFL q 0
	/*
	逻辑提前 ,写入主管医生，再写转移表就可以插入主管医生 by wanghc 2018-3-26 
	Set EpisodeID=id
	Quit:PatientID="" 0
	Quit:EpisodeID="" 0
	Set MotherID=$P($G(^PAPER(PatientID,"PER",4)),"^",13)
	Quit:MotherID="" 0
	Set MotherAdm=""
	Set MoAdm=0
	For  Set MoAdm=$O(^PAPERdr(MotherID,"ADM","I",MoAdm)) Quit:(MoAdm="")!(MotherAdm'="")  Do
	.Set VisitStatus=$P($G(^PAADM(MoAdm)),"^",20)
	.Quit:VisitStatus'="A"
	.Set MotherAdm=MoAdm
	Quit:MotherAdm="" 0
	&SQL(Update PA_Adm Set PAADM_MotherAdm_Dr = :MotherAdm Where PAADM_RowId= :EpisodeID)
	i SQLCODE Q 0
	S V7EpisodeFlag = $G(^PAADM(MotherAdm,"VER"))
	i V7EpisodeFlag=7 s ^PAADM(EpisodeID,"VER")=7
	e  s ^PAADM(EpisodeID,"VER")=6
	*/
	//插入出生日期出生时间
	s pregnancyId=$o(^PAPRGi("BABY_Person_DR",PatientID,""))
	q:pregnancyId="" 0
	s pregDeliverySub=$o(^PAPRGi("BABY_Person_DR",PatientID,pregnancyId,"DEL",""))
	q:pregDeliverySub="" 0
	s babySub=$o(^PAPRGi("BABY_Person_DR",PatientID,pregnancyId,"DEL",pregDeliverySub,"BABY",""))
	q:babySub="" 0
	s birthDate=$P($g(^PAPRG(pregnancyId,"DEL",pregDeliverySub,"BABY",babySub)),"^",13)
	s birthTime=$P($g(^PAPRG(pregnancyId,"DEL",pregDeliverySub,"BABY",babySub)),"^",49)
	if ..%IsValidMethod("web.UDHCJFCOMMON","saveNewBabyDob") {
		d ##class(web.UDHCJFCOMMON).saveNewBabyDob(PatientID, birthDate, birthTime)
	}
	If (..%IsValidMethod("web.DHCDischargeHistory","SaveAdminDateTime")) {
		Set rtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,StDate,StTime,1,LocationID,wardId)	
	}
	Q $$$OK

	/*
    S PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s AdmObject=##class(User.PAAdm).%OpenId(id)
	S ADMNo=##class(web.DHCPAADM).CompADMNo("I") 
	//费别 s AdmReason=table PAC_AdmReason
	s AdmReason=$o(^PAC("ADMREA",0,"Desc","自费",""))
	s CreateUser=$g(%session.Data("LOGON.USERID"))
	d:CreateUser'="" AdmObject.PAADMCreateUserSetObjectId(CreateUser)
	s AdmObject.PAADMADMNo=ADMNo
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s AdmReason=##class(web.DHCPAADM).GetDefaultBillType(PatCatDr)
	
	d:AdmReason'="" AdmObject.PAADMAdmReasonDRSetObjectId(AdmReason)
	//绿色通道 d AdmObject.PAADMAdmCategDRSetObjectId(AdmCate)
	//d object.PAADMRefDocListDRSetObjectId(AdmRefDocListDR) User.PACRefDoctor
	//d object.PAADMEpissubtypeDRSetObjectId(Epissubtype) PAC_EpisodeSubType 普通病人 绿色通道病人
	//婴儿无医护人员关联 s:BabyAdmWKFL=WKFL AdmObject.PAADMAdmDocCodeDR=""
	s:BabyAdmWKFL=WKFL AdmObject.PAADMType="I"
	s AdmObject.PAADMVisitStatus="A"
	s AdmObject.PAADMShowInFutureEpisode="Y"
	s AdmObject.PAADMConfidential="N"
	s AdmObject.PAADMPreAdmitted="N"
	s AdmObject.PAADMIsolate="N"
	s AdmObject.PAADMCurrent="Y"
	s AdmObject.PAADMVerified="N"
	s AdmObject.PAADMBillFlag="N"
	s AdmObject.PAADMSpecialDocument="N"
	s AdmObject.PAADMCompleted="N"
	s AdmObject.PAADMRequestMR="N"
	s AdmObject.PAADMFrequentAdmissions="N"
	s AdmObject.PAADMEstDischConfirmed="N"
	s AdmObject.PAADMRelated="N"
	s AdmObject.PAADMViewablebyEpCareProv="N"
	Set sc = AdmObject.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	s PAADMRowId=AdmObject.%Id()
	//update PA_ADM2
	s object1=##class(User.PAAdm2).%OpenId(PAADMRowId)
	s object1.PAADM2Name=PatientName
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	;insert MR_ADM
	s object1=##class(User.MRAdm).%New()
	d object1.MRADMADMDRSetObjectId(PAADMRowId)
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	//update PA_ADM.PAADM-MainMRADMDR
	s MRADMRowId=object1.%Id()
	d AdmObject.PAADMMainMRADMDRSetObjectId(MRADMRowId)
	Set sc = AdmObject.%Save()
	If $$$ISERR(sc) {
		Tro
		Do $System.Status.DisplayError()
		Q ""
	}
	Quit:BabyAdmWKFL'=WKFL 0
	
	//更新 PAADM_MotherAdm_Dr 
	Set EpisodeID=id
	Quit:PatientID="" 0
	Quit:EpisodeID="" 0
	Set MotherID=$P($G(^PAPER(PatientID,"PER",4)),"^",13)
	Quit:MotherID="" 0
	Set MotherAdm=""
	Set MoAdm=0
	For  Set MoAdm=$O(^PAPERdr(MotherID,"ADM","I",MoAdm)) Quit:(MoAdm="")!(MotherAdm'="")  Do
	.Set VisitStatus=$P($G(^PAADM(MoAdm)),"^",20)
	.Quit:VisitStatus'="A"
	.Set MotherAdm=MoAdm
	Quit:MotherAdm="" 0
	&SQL(Update PA_Adm Set PAADM_MotherAdm_Dr = :MotherAdm Where PAADM_RowId= :EpisodeID)
	q $$$OK
	*/
saveerror 
   s ^Temp("Upgrade","web.PAAdm","websysAfterSave",$h)=$ZE
   q 0
}

/// Invoked before websysSave - can be used to cancel the save
ClassMethod websysBeforeSave(compref As %String = "", ByRef id As %String = "") As %Boolean
{
	q $$$OK
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDeleteAdm(id As %Library.String, compref As %Library.String) As %Library.Boolean
{
}

ClassMethod SetFAActions(compref As %String, EpisodeID As %String)
{
}

/// Thecompref is the  component reference which is the string from which we can deduce the instance of
/// websysComponent
/// websysComponentItem
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
	 s $ZT="saveerr"
	 n compid,status,new,j,oktosave,save,value,parref,oldval
	 s compid=251,oktosave=1,save=0
	 i id'="",'##Class(websys.Lock).Lock($lb(id,"User.PAAdm"),%session.SessionId,%session.Get("LOGON.USERID"),.status) d  q 0
	 . ;d msg.AddItem("E","LOCKED",status,compid) s oktosave=0
	 i '##Class(web.PAAdm).websysBeforeSave(compref,.id) q 0
	 s new=id=""
	 s:id'="" obj=##Class(User.PAAdm).%OpenId(id)
	 if id="" d
	 . s parref=$g(%request.Data("PARREF",1))
	 . i parref="" s obj=##Class(User.PAAdm).%New()
	 . i parref'="" s obj=##Class(User.PAAdm).%New(parref)
	 s PatientID = $G(%request.Data("PatientID",1))
	 s VisitStatus = "A" 
	 set AdmType = $g(%request.Data("PAADMType",1))
	 if (new ){
		 
		 d obj.PAADMPAPMIDRSetObjectId(PatientID)
		 s obj.PAADMVisitStatus=VisitStatus	 
		 if " A "[(" "_$p($g(VisitStatus),$c(1))_" ") {
			set ProcessDR = ..ProcessInsert($g(PatientID),"")
			d obj.PAADMCurrentProcessDRSetObjectId(ProcessDR)
		 }
		set obj.PAADMShowInFutureEpisode="Y"
		set obj.PAADMConfidential="N"
		set obj.PAADMPreAdmitted="N"
		set obj.PAADMIsolate="N"
		set obj.PAADMCurrent="Y"
		set obj.PAADMVerified="N"
		set AdmReason = ""
		if (AdmReason = ""){
			set PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
			i PatCatDr="" s AdmReason= $o(^PAC("ADMREA",0)) ;$o(^PAC("ADMREA",0,"Desc","自费",""))
			e  set AdmReason=..GetDefaultBillType(PatCatDr)
		}
		d obj.PAADMAdmReasonDRSetObjectId(AdmReason)
		set ADMNo=..CompADMNo(AdmType)
		Set %request.Data("PAADMADMNo",1)=ADMNo
		s CreateUser=$g(%session.Data("LOGON.USERID"))
		d:CreateUser'="" obj.PAADMCreateUserSetObjectId(CreateUser)
		set obj.PAADMBillFlag="N"
		set obj.PAADMSpecialDocument="N"
		set obj.PAADMCompleted="N"
		set obj.PAADMRequestMR="N"
		set obj.PAADMFrequentAdmissions="N"
		set obj.PAADMEstDischConfirmed="N"
		set obj.PAADMRelated="N"
		set obj.PAADMViewablebyEpCareProv="N"
	}
	set PatientName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
	if AdmType="E" set object.PAADMEmergencyStatus="Q"
	set obj.PAADMType = AdmType
	;set obj.PAADMPreAdmitDate=..%SysDate()
	;set obj.PAADMPreAdmitTime=..%SysTime()	
	d obj.PAADMUpdateUserDRSetObjectId(%session.Get("LOGON.USERID"))
	set WardID = ""
	i $d(%request.Data("WARDDesc",1)) d
	.s val = $G(%request.Data("WARDDesc",1)) s:$l($g(val)) val=##class(web.PACWard).GetIdFromCodeOrDescription(val) d obj.PAADMCurrentWardDRSetObjectId(val)
	.s WardID = val 
	i $d(%request.Data("BEDCode",1)) d
	.s val = %request.Data("BEDCode",1) s:$l($g(val)) val=##class(web.PACBed).GetIdFromBedAndWard(val,WardID,"") ;.GetIdFromCodeOrDescription(val)
	.i val'="" d obj.PAADMCurrentBedDRSetObjectId(val)
	.i val'="" s roomId=$p(^PAWARD(+val,"BED",$p(val,"||",2)),"^",3) d obj.PAADMCurrentRoomDRSetObjectId(roomId)

	 i $d(%request.Data("HOSPDesc",1)) d
	 .s val = $G(%request.Data("HOSPDesc",1)) s:$l($g(val)) val=##class(web.CTHospital).GetIdFromCodeOrDescription(val) d obj.PAADMHospitalDRSetObjectId(val)
	 
	 ;d ##class(web.PAPregDelBaby).SetBabyAdmitDefaults
	 i $d(%request.Data("PAADMMotherAdmDR",1)) d
	 .s val = $G(%request.Data("PAADMMotherAdmDR",1)) d:$l($g(val)) obj.PAADMMotherAdmDRSetObjectId(val)
	
	 ;----
	 i $d(%request.Data("ACUDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ACUDesc",1)) s:$l($g(val)) val=##Class(web.PACPatAcuity).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPatAcuityDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ACUDesc"),"病人剧烈程度"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ACUDesc") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADM2EDIOverride",1)) s:$l($g(val)) val=##Class(web.PAAdm2).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPAAdm2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADM2EDIOverride"),"EDI Override"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADM2EDIOverride") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADM2EstimateDateInjury",1)) s:$l($g(val)) val=##Class(web.PAAdm2).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPAAdm2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADM2EstimateDateInjury"),"EstimateDateInjury"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADM2EstimateDateInjury") s oktosave=0
	 i $d(%request.Data("PAADM2OnHoldReason",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADM2OnHoldReason",1)) s:$l($g(val)) val=##Class(web.PAAdm2).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPAAdm2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADM2OnHoldReason"),"OnHold Reason"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADM2OnHoldReason") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADM2OnHold",1)) s:$l($g(val)) val=##Class(web.PAAdm2).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPAAdm2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADM2OnHold"),"OnHold"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADM2OnHold") s oktosave=0
	 i $d(%request.Data("PAADMCreateUser",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMCreateUser",1)) s:$l($g(val)) val=##Class(web.SSUser).GetIdFromCodeOrDescription($g(val)) d obj.PAADMCreateUserSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMCreateUser"),"被创建"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMCreateUser") s oktosave=0
	 i $d(%request.Data("PAADMInjuryIncidentDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMInjuryIncidentDate",1)) s obj.PAADMInjuryIncidentDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMInjuryIncidentDate"),"受伤日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMInjuryIncidentDate") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMAuditLetterResponse",1)) s obj.PAADMAuditLetterResponse=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMAuditLetterResponse"),"审计反馈"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMAuditLetterResponse") s oktosave=0
	 i $d(%request.Data("PrevEpsDischDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PrevEpsDischDate",1)) // needed to pass through Trak.Discharge Maternity workflow
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PrevEpsDischDate"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PrevEpsDischDate") s oktosave=0
	 i $d(%request.Data("DischBabyEps",1)) d
	 . s (val,oldval)=$g(%request.Data("DischBabyEps",1)) // needed to pass through Trak.Discharge Maternity workflow
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("DischBabyEps"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"DischBabyEps") s oktosave=0
	 i $d(%request.Data("PAADMConsentWorkCompens",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentWorkCompens",1)) s obj.PAADMConsentWorkCompens=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentWorkCompens"),"许可工作报酬"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentWorkCompens") s oktosave=0
	 i $d(%request.Data("PAADMConsentMotorVehicle",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentMotorVehicle",1)) s obj.PAADMConsentMotorVehicle=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentMotorVehicle"),"许可管理机动车"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentMotorVehicle") s oktosave=0
	 i $d(%request.Data("PAADMConsentFeedback",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentFeedback",1)) s obj.PAADMConsentFeedback=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentFeedback"),"许可反馈"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentFeedback") s oktosave=0
	 i $d(%request.Data("PAADMConsentDepOfDefence",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentDepOfDefence",1)) s obj.PAADMConsentDepOfDefence=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentDepOfDefence"),"许可防卫部门"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentDepOfDefence") s oktosave=0
	 i $d(%request.Data("PAADMConsentDVA",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentDVA",1)) s obj.PAADMConsentDVA=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentDVA"),"许可DVA"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentDVA") s oktosave=0
	 i $d(%request.Data("PAADMUpdateUserHospitalDR",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMUpdateUserHospitalDR",1)) s:$l($g(val)) val=##Class(web.CTHospital).GetIdFromCodeOrDescription($g(val)) d obj.PAADMUpdateUserHospitalDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMUpdateUserHospitalDR"),"用户上一个医院"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMUpdateUserHospitalDR") s oktosave=0
	 i $d(%request.Data("TRD2Desc",1)) d
	 . s (val,oldval)=$g(%request.Data("TRD2Desc",1)) s:$l($g(val)) val=##Class(web.PACTransferDestination).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMTransDest2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("TRD2Desc"),"转移发出科室"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"TRD2Desc") s oktosave=0
	 i $d(%request.Data("HCRDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("HCRDesc",1)) s:$l($g(val)) val=##Class(web.CTHealthCareRegion).GetIdFromCodeOrDescription($g(val)) d obj.PAADMHCRDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("HCRDesc"),"护理地域"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"HCRDesc") s oktosave=0
	 i $d(%request.Data("WLDateOnList",1)) d
	 . s (val,oldval)=$g(%request.Data("WLDateOnList",1)) s:$l($g(val)) val=##Class(web.PAWaitingList).GetIdFromCodeOrDescription($g(val)) d obj.PAADMWaitListDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("WLDateOnList"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"WLDateOnList") s oktosave=0
	 i $d(%request.Data("PAADMLabClinicalCondition",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMLabClinicalCondition",1)) s obj.PAADMLabClinicalCondition=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMLabClinicalCondition"),"临床条件"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMLabClinicalCondition") s oktosave=0
	 i $d(%request.Data("PAADMMaternityVisTypeDR",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMMaternityVisTypeDR",1)) s:$l($g(val)) val=##Class(web.PACMaternityVisitType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMMaternityVisTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMMaternityVisTypeDR"),"妇科访问类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMMaternityVisTypeDR") s oktosave=0
	 i $d(%request.Data("PAADMRefOrgAddress",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRefOrgAddress",1)) s obj.PAADMRefOrgAddress=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRefOrgAddress"),"机构参考地址"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRefOrgAddress") s oktosave=0
	 i $d(%request.Data("MRADMDischDestinDR",1)) d
	 . s (val,oldval)=$g(%request.Data("MRADMDischDestinDR",1)) s:$l($g(val)) val=##Class(web.PACDischargeDestination).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMDischDestinDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRADMDischDestinDR"),"结算前往地"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"MRADMDischDestinDR") s oktosave=0
	 i $d(%request.Data("QUALDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("QUALDesc",1)) s:$l($g(val)) val=##Class(web.PACQualificationStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAADMQualifStatusDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("QUALDesc"),"资格"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"QUALDesc") s oktosave=0
	i $d(%request.Data("CANCDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CANCDesc",1)) s:$l($g(val)) val=##Class(web.PACSuspectCancerType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMSuspectCancerTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CANCDesc"),"癌症类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CANCDesc") s oktosave=0
	 i $d(%request.Data("NGODesc",1)) d
	 . s (val,oldval)=$g(%request.Data("NGODesc",1)) s:$l($g(val)) val=##Class(web.PACNonGovOrg).GetIdFromCodeOrDescription($g(val)) d obj.PAADMNonGovOrgDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("NGODesc"),"无政府组织"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"NGODesc") s oktosave=0
	 i $d(%request.Data("PAADMDaySurgeryType",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDaySurgeryType",1)) s obj.PAADMDaySurgeryType=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDaySurgeryType"),"类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDaySurgeryType") s oktosave=0
	 i $d(%request.Data("ROOMTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ROOMTDesc",1)) s:$l($g(val)) val=##Class(web.PACRoomType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRoomTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ROOMTDesc"),"优先居住类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ROOMTDesc") s oktosave=0
	 i $d(%request.Data("CMCTPCPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CMCTPCPDesc",1)) s:$l($g(val)) val=##Class(web.CTCareProv).GetIdFromCodeOrDescription($g(val)) d obj.PAADMCaseManagerDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CMCTPCPDesc"),"案例管理名称"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CMCTPCPDesc") s oktosave=0
	 i $d(%request.Data("REA2Desc",1)) d
	 . s (val,oldval)=$g(%request.Data("REA2Desc",1)) s:$l($g(val)) val=##Class(web.PACAdmReason).GetIdFromCodeOrDescription($g(val)) d obj.PAADMSecondaryReasonDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REA2Desc"),"第二原因"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REA2Desc") s oktosave=0
	 i $d(%request.Data("PAADMRejectionReason",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRejectionReason",1)) s obj.PAADMRejectionReason=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRejectionReason"),"拒绝原因"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRejectionReason") s oktosave=0
	 i $d(%request.Data("PAADMLastContactFamily",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMLastContactFamily",1)) s obj.PAADMLastContactFamily=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMLastContactFamily"),"最后一个联系家庭"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMLastContactFamily") s oktosave=0
	 i $d(%request.Data("PAADMDateFirstAppt",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateFirstAppt",1)) s obj.PAADMDateFirstAppt=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateFirstAppt"),"第一次预约日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateFirstAppt") s oktosave=0
	 i $d(%request.Data("PAADMDateDischHosp",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateDischHosp",1)) s obj.PAADMDateDischHosp=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateDischHosp"),"医院结算日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateDischHosp") s oktosave=0
	 i $d(%request.Data("RESDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("RESDesc",1)) s:$l($g(val)) val=##Class(web.RBResource).GetIdFromCodeOrDescription($g(val)) d obj.PAADMCurrentResourceDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("RESDesc"),"资源"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"RESDesc") s oktosave=0
	 i $d(%request.Data("APPTBSDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("APPTBSDesc",1)) s:$l($g(val)) val=##Class(web.PACApptBookingSystem).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAppointBookingSystemDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("APPTBSDesc"),"预约类别"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"APPTBSDesc") s oktosave=0
	 i $d(%request.Data("RSTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("RSTDesc",1)) s:$l($g(val)) val=##Class(web.PACReferralStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefStatDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("RSTDesc"),"推荐状态"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"RSTDesc") s oktosave=0
	 i $d(%request.Data("CLNPhone",1)) d
	 . s (val,oldval)=$g(%request.Data("CLNPhone",1)) s:$l($g(val)) val=##Class(web.PACRefDoctorClinic).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefDocClinicDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CLNPhone"),"电话"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CLNPhone") s oktosave=0
	 i $d(%request.Data("SPPPCode",1)) d
	 . s (val,oldval)=$g(%request.Data("SPPPCode",1)) s:$l($g(val)) val=##Class(web.PACStatePPP).GetIdFromCodeOrDescription($g(val)) d obj.PAADMStatePPPDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("SPPPCode"),"省PPP代码"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"SPPPCode") s oktosave=0
	 i $d(%request.Data("SPPPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("SPPPDesc",1)) s:$l($g(val)) val=##Class(web.PACStatePPP).GetIdFromCodeOrDescription($g(val)) d obj.PAADMStatePPPDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("SPPPDesc"),"省PPP描述"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"SPPPDesc") s oktosave=0
	 i $d(%request.Data("PAADMTransfer",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMTransfer",1)) s:$l($g(val)) val=##Class(web.TRANSFDesc).GetIdFromCodeOrDescription($g(val)) d obj.PAADMTransferDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMTransfer"),"转移转诊/转科)"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMTransfer") s oktosave=0
	 i $d(%request.Data("PAADMDischargeFIM",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDischargeFIM",1)) s obj.PAADMDischargeFIM=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDischargeFIM"),"结算FIM"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDischargeFIM") s oktosave=0
	 i $d(%request.Data("IPATDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("IPATDesc",1)) s:$l($g(val)) val=##Class(web.PACInPatAdmissionType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMInPatAdmTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("IPATDesc"),"住院病人类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"IPATDesc") s oktosave=0
	 i $d(%request.Data("CONTROLDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CONTROLDesc",1)) s:$l($g(val)) val=##Class(web.PACContractRole).GetIdFromCodeOrDescription($g(val)) d obj.PAADMContractRoleDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CONTROLDesc"),"合约角色"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CONTROLDesc") s oktosave=0
	 i $d(%request.Data("CONTRTYPEDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CONTRTYPEDesc",1)) s:$l($g(val)) val=##Class(web.PACContractType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMContractTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CONTRTYPEDesc"),"合约类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CONTRTYPEDesc") s oktosave=0
	 i $d(%request.Data("CSIDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CSIDesc",1)) s:$l($g(val)) val=##Class(web.PACContractSpokIdentifier).GetIdFromCodeOrDescription($g(val)) d obj.PAADMContractSpokeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CSIDesc"),"合约/标识"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CSIDesc") s oktosave=0
	 i $d(%request.Data("PAADMAdmissionFIM",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMAdmissionFIM",1)) s obj.PAADMAdmissionFIM=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMAdmissionFIM"),"入院就诊FIM"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMAdmissionFIM") s oktosave=0
	 i $d(%request.Data("PAADMTreatingDr",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMTreatingDr",1)) s:$l($g(val)) val=##Class(web.CTCareProv).GetIdFromCodeOrDescription($g(val)) d obj.PAADMTreatingDrDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMTreatingDr"),"处置医生"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMTreatingDr") s oktosave=0
	 i $d(%request.Data("PFSDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("PFSDesc",1)) s:$l($g(val)) val=##Class(web.PACProgramFundingSource).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMProgrFundSourceDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PFSDesc"),"基金程序"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PFSDesc") s oktosave=0
	 i $d(%request.Data("FUNDARDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("FUNDARDesc",1)) s:$l($g(val)) val=##Class(web.PACFundingArrangement).GetIdFromCodeOrDescription($g(val)) d obj.PAADMFundingArrangementDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("FUNDARDesc"),"基金计划"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"FUNDARDesc") s oktosave=0
	 i $d(%request.Data("PatNewBorn",1)) d
	 . s (val,oldval)=$g(%request.Data("PatNewBorn",1)) // RETURNS THE NUMBER OF DAYS FOR NEW BORNS
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PatNewBorn"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PatNewBorn") s oktosave=0
	 i $d(%request.Data("PCLASSDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("PCLASSDesc",1)) s:$l($g(val)) val=##Class(web.PACPatientClassification).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPatClassifDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PCLASSDesc"),"分类"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PCLASSDesc") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMPatientContacted",1)) s obj.PAADMPatientContacted=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMPatientContacted"),"联系病人"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMPatientContacted") s oktosave=0
	 
	 ;i $d(%request.Data("PAADMTypeDisplayOnly",1)) d
	 ;. s (val,oldval)=$g(%request.Data("PAADMTypeDisplayOnly",1)) s obj.PAADMType=$g(val)
	 ;. i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMTypeDisplayOnly"),"入院种类"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMTypeDisplayOnly") s oktosave=0
	 

	 ;i $d(%request.Data("PAADMADMNoDisplayOnly",1)) d
	 ;. s (val,oldval)=$g(%request.Data("PAADMADMNoDisplayOnly",1)) s obj.PAADMADMNo=$g(val)
	 ;. i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMADMNoDisplayOnly"),"就诊号"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMADMNoDisplayOnly") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMFrequentAdmissions",1)) s obj.PAADMFrequentAdmissions=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMFrequentAdmissions"),"频繁登记入院"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMFrequentAdmissions") s oktosave=0
	 i $d(%request.Data("PAADMConsentRecFundInfo",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentRecFundInfo",1)) s obj.PAADMConsentRecFundInfo=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentRecFundInfo"),"同意接收筹款信息"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentRecFundInfo") s oktosave=0
	 i $d(%request.Data("PAADMConsentPatSatisfSurve",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMConsentPatSatisfSurve",1)) s obj.PAADMConsentPatSatisfSurve=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConsentPatSatisfSurve"),"同意进行病人满意度调查"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConsentPatSatisfSurve") s oktosave=0
	 i $d(%request.Data("RCCTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("RCCTDesc",1)) s:$l($g(val)) val=##Class(web.PACReasonCritCareTransfer).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMReasonCritCareTransDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("RCCTDesc"),"重要的护理转送原因"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"RCCTDesc") s oktosave=0
	 i $d(%request.Data("TRDDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("TRDDesc",1)) s:$l($g(val)) val=##Class(web.PACTransferDestination).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMTransDest2DRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("TRDDesc"),"转诊目的地"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"TRDDesc") s oktosave=0
	 i $d(%request.Data("CARETYPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CARETYPDesc",1)) s:$l($g(val)) val=##Class(web.PACCareType).GetIdFromCodeOrDescription($g(val)) d:$IsObject(obj.PAADMMainMRADMDR) obj.PAADMMainMRADMDR.MRADMCareTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CARETYPDesc"),"护理类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CARETYPDesc") s oktosave=0
	 i $d(%request.Data("PAADMOtherHospital",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMOtherHospital",1)) s obj.PAADMOtherHospital=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMOtherHospital"),"其他医院"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMOtherHospital") s oktosave=0
	 i $d(%request.Data("CTRLGDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CTRLGDesc",1)) s:$l($g(val)) val=##Class(web.CTReligion).GetIdFromCodeOrDescription($g(val)) d obj.PAADMPAPMIDR.PAPMIPAPERDR.PAPERReligionDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTRLGDesc"),"宗教"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CTRLGDesc") s oktosave=0
	 i $d(%request.Data("ADMETHDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ADMETHDesc",1)) s:$l($g(val)) val=##Class(web.PACAdmissionMethod).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAdmMethodDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ADMETHDesc"),"接收方法"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ADMETHDesc") s oktosave=0
	 i $d(%request.Data("MRADMVisitorStatusDR",1)) d
	 . s (val,oldval)=$g(%request.Data("MRADMVisitorStatusDR",1)) s:$l($g(val)) val=##Class(web.MRAdm).GetIdFromCodeOrDescription($g(val)) d obj.PAADMMainMRADMDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRADMVisitorStatusDR"),"访客状态"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"MRADMVisitorStatusDR") s oktosave=0
	 i $d(%request.Data("ARCICDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ARCICDesc",1)) s:$l($g(val)) val=##Class(web.ARCItemCat).GetIdFromCodeOrDescription($g(val)) d obj.PAADMOESubCatDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ARCICDesc"),"病人食物"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ARCICDesc") s oktosave=0
	 i $d(%request.Data("PAADMDateRefDecision",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateRefDecision",1)) s obj.PAADMDateRefDecision=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateRefDecision"),"咨询病人决定日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateRefDecision") s oktosave=0
	 i $d(%request.Data("ATTENDDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ATTENDDesc",1)) s:$l($g(val)) val=##Class(web.PACSourceOfAttendance).GetIdFromCodeOrDescription($g(val)) d obj.PAADMSourceOfAttendDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ATTENDDesc"),"出席者来源"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ATTENDDesc") s oktosave=0
	 i $d(%request.Data("PAADMDateReceived",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateReceived",1)) s obj.PAADMDateReceived=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateReceived"),"GP信件日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateReceived") s oktosave=0
	 i $d(%request.Data("CTCOUDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CTCOUDesc",1)) s:$l($g(val)) val=##Class(web.CTCountry).GetIdFromCodeOrDescription($g(val)) d obj.PAADMOSVCountryFromDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTCOUDesc"),"国家"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CTCOUDesc") s oktosave=0
	 i $d(%request.Data("PAADMInterviewedBy",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMInterviewedBy",1)) s obj.PAADMInterviewedBy=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMInterviewedBy"),"被面试"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMInterviewedBy") s oktosave=0
	 i $d(%request.Data("PAADMDateOfInterview",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateOfInterview",1)) s obj.PAADMDateOfInterview=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateOfInterview"),"面试日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateOfInterview") s oktosave=0
	 i $d(%request.Data("PAADMDateOfEntry",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateOfEntry",1)) s obj.PAADMDateOfEntry=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateOfEntry"),"进入日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateOfEntry") s oktosave=0
	 i $d(%request.Data("OPERDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("OPERDesc",1)) s:$l($g(val)) val=##Class(web.MRAdm).GetIdFromCodeOrDescription($g(val)) d obj.PAADMMainMRADMDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("OPERDesc"),"已经订婚的手续"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"OPERDesc") s oktosave=0
	 i $d(%request.Data("WLREFDDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("WLREFDDesc",1)) s:$l($g(val)) val=##Class(web.PACRefDoctor).GetIdFromCodeOrDescription($g(val)) d obj.PAADMWaitListDR.WLRefDocDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("WLREFDDesc"),"等候列表推荐医生"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"WLREFDDesc") s oktosave=0
	 i $d(%request.Data("MRADMPresentComplaint",1)) d
	 . s (val,oldval)=$g(%request.Data("MRADMPresentComplaint",1)) s:$l($g(val)) val=##Class(web.MRAdm).GetIdFromCodeOrDescription($g(val)) d obj.PAADMMainMRADMDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("MRADMPresentComplaint"),"当前主诉"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"MRADMPresentComplaint") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMOwnMinisterIndicator",1)) s obj.PAADMOwnMinisterIndicator=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMOwnMinisterIndicator"),"自有管理指示"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMOwnMinisterIndicator") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMHospChaplainVisitReq",1)) s obj.PAADMHospChaplainVisitReq=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMHospChaplainVisitReq"),"需要牧师到访医院"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMHospChaplainVisitReq") s oktosave=0
	 i $d(%request.Data("PAADMChaplainPhone",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMChaplainPhone",1)) s obj.PAADMChaplainPhone=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMChaplainPhone"),"社区牧师电话"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMChaplainPhone") s oktosave=0
	 i $d(%request.Data("PAADMChaplainName",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMChaplainName",1)) s obj.PAADMChaplainName=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMChaplainName"),"社区牧师姓名"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMChaplainName") s oktosave=0
	 i $d(%request.Data("PAADMChaplainChurchAddress",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMChaplainChurchAddress",1)) s obj.PAADMChaplainChurchAddress=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMChaplainChurchAddress"),"社区教堂地址"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMChaplainChurchAddress") s oktosave=0
	 i $d(%request.Data("WLDate",1)) d
	 . s (val,oldval)=$g(%request.Data("WLDate",1)) s:$l($g(val)) val=##Class(web.PAWaitingList).GetIdFromCodeOrDescription($g(val)) d obj.PAADMWaitListDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("WLDate"),"日期列表"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"WLDate") s oktosave=0
	 i $d(%request.Data("WLTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("WLTDesc",1)) s:$l($g(val)) val=##Class(web.PACWaitingListType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMWaitListDR.WLWaitListTypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("WLTDesc"),"等待列表类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"WLTDesc") s oktosave=0
	 i $d(%request.Data("PAADMEstimDischargeDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMEstimDischargeDate",1)) s obj.PAADMEstimDischargeDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMEstimDischargeDate"),"期望出院结算日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMEstimDischargeDate") s oktosave=0
	 i $d(%request.Data("ADSOUDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ADSOUDesc",1)) s:$l($g(val)) val=##Class(web.PACAdmSource).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAdmSrcDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ADSOUDesc"),"参考入院来源"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ADSOUDesc") s oktosave=0
	 i $d(%request.Data("PAADMDateHCPreceived",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateHCPreceived",1)) s obj.PAADMDateHCPreceived=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateHCPreceived"),"HCP接收日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateHCPreceived") s oktosave=0
	 i $d(%request.Data("PAADMDateHCPRequestSent",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDateHCPRequestSent",1)) s obj.PAADMDateHCPRequestSent=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDateHCPRequestSent"),"需要派HCP的日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDateHCPRequestSent") s oktosave=0
	 i $d(%request.Data("HCPPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("HCPPDesc",1)) s:$l($g(val)) val=##Class(web.PACHCPPriority).GetIdFromCodeOrDescription($g(val)) d obj.PAADMHCPPriorityDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("HCPPDesc"),"被HCP分配的优先级"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"HCPPDesc") s oktosave=0
	 i $d(%request.Data("APTRDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("APTRDesc",1)) s:$l($g(val)) val=##Class(web.RBCAppointTransport).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAppointDR.APPTTransportDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("APTRDesc"),"需要传输"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"APTRDesc") s oktosave=0
	 i $d(%request.Data("OVSDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("OVSDesc",1)) s:$l($g(val)) val=##Class(web.PACOSVisitorStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAADMOSVisitStatusDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("OVSDesc"),"OVS状态"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"OVSDesc") s oktosave=0
	 i $d(%request.Data("REFPRIDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("REFPRIDesc",1)) s:$l($g(val)) val=##Class(web.PACReferralPriority).GetIdFromCodeOrDescription($g(val)) d obj.PAADMReferralPriorityDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFPRIDesc"),"推荐优先级"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFPRIDesc") s oktosave=0
	 i $d(%request.Data("PAADMRefDocCodeDR",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRefDocCodeDR",1)) s obj.PAADMRefDocCodeDR=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRefDocCodeDR"),"推荐人"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRefDocCodeDR") s oktosave=0
	 i $d(%request.Data("REFMETHDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("REFMETHDesc",1)) s:$l($g(val)) val=##Class(web.PACRefReceiptMethod).GetIdFromCodeOrDescription($g(val)) d obj.PAADMMethodRefDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFMETHDesc"),"推荐方法"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFMETHDesc") s oktosave=0
	 i $d(%request.Data("PAADMUserUpdate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMUserUpdate",1)) s:$l($g(val)) val=##Class(web.SSUser).GetIdFromCodeOrDescription($g(val)) d obj.PAADMUpdateUserDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMUserUpdate"),"用户最近更新"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMUserUpdate") s oktosave=0
	 i $d(%request.Data("PAADMUpdateTime",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMUpdateTime",1)) s obj.PAADMUpdateTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMUpdateTime"),"更新时间"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMUpdateTime") s oktosave=0
	 i $d(%request.Data("PAADMUpdateDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMUpdateDate",1)) s obj.PAADMUpdateDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMUpdateDate"),"更新日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMUpdateDate") s oktosave=0
	 i $d(%request.Data("PAADMGuaranteeAdmDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMGuaranteeAdmDate",1)) s obj.PAADMGuaranteeAdmDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMGuaranteeAdmDate"),"担保就诊日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMGuaranteeAdmDate") s oktosave=0
	 
	 i $d(%request.Data("PAADMADMNo",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMADMNo",1)) s obj.PAADMADMNo=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMADMNo"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMADMNo") s oktosave=0
	 
	 i $d(%request.Data("REFDCode",1)) d
	 . s (val,oldval)=$g(%request.Data("REFDCode",1)) s:$l($g(val)) val=##Class(web.PACRefDoctor).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefDocListDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFDCode"),""),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFDCode") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMConfirmReferral",1)) s obj.PAADMConfirmReferral=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMConfirmReferral"),"确认推荐"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMConfirmReferral") s oktosave=0
	 i $d(%request.Data("REFPERDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("REFPERDesc",1)) s:$l($g(val)) val=##Class(web.PACReferralPeriod).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefPeriodDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFPERDesc"),"转诊过程"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFPERDesc") s oktosave=0
	 i $d(%request.Data("CLNProviderNo",1)) d
	 . s (val,oldval)=$g(%request.Data("CLNProviderNo",1)) s:$l($g(val)) val=##Class(web.PACRefDoctorClinic).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefDocClinicDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CLNProviderNo"),"提供者号"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CLNProviderNo") s oktosave=0
	 i $d(%request.Data("PAADMSeenTime",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMSeenTime",1)) s obj.PAADMSeenTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMSeenTime"),"看到日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMSeenTime") s oktosave=0
	 i $d(%request.Data("PAADMSeenDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMSeenDate",1)) s obj.PAADMSeenDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMSeenDate"),"看到时间"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMSeenDate") s oktosave=0
	 i $d(%request.Data("PAADMDischgTime",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDischgTime",1)) s obj.PAADMDischgTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDischgTime"),"结算时间"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDischgTime") s oktosave=0
	 i $d(%request.Data("PAADMDischgDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMDischgDate",1)) s obj.PAADMDischgDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMDischgDate"),"结算日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMDischgDate") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMVerified",1)) s obj.PAADMVerified=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMVerified"),"确认"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMVerified") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMSpecialDocument",1)) s obj.PAADMSpecialDocument=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMSpecialDocument"),"就诊/混合案例账单"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMSpecialDocument") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMSpecialCategory",1)) s obj.PAADMSpecialCategory=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMSpecialCategory"),"DRG账单"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMSpecialCategory") s oktosave=0
	 i $d(%request.Data("PAADMFlaggedPatient",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMFlaggedPatient",1)) s obj.PAADMFlaggedPatient=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMFlaggedPatient"),"同一天"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMFlaggedPatient") s oktosave=0
	 d
	 . s (val,oldval)=$g(%request.Data("PAADMCompleted",1)) s obj.PAADMCompleted=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMCompleted"),"完成"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMCompleted") s oktosave=0
	 i $d(%request.Data("HCPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("HCPDesc",1)) s:$l($g(val)) val=##Class(web.CTHealthCareProvider).GetIdFromCodeOrDescription($g(val)) d obj.PAADMHCPDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("HCPDesc"),"医护人员"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"HCPDesc") s oktosave=0
	 i $d(%request.Data("HCADesc",1)) d
	 . s (val,oldval)=$g(%request.Data("HCADesc",1)) s:$l($g(val)) val=##Class(web.CTHealthCareArea).GetIdFromCodeOrDescription($g(val)) d obj.PAADMHCADRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("HCADesc"),"医疗区域"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"HCADesc") s oktosave=0
	 i $d(%request.Data("INJUDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("INJUDesc",1)) s:$l($g(val)) val=##Class(web.PACCauseOfInjury).GetIdFromCodeOrDescription($g(val)) d obj.PAADMCauseInjDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("INJUDesc"),"受伤原因"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"INJUDesc") s oktosave=0
	 i $d(%request.Data("REFTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("REFTDesc",1)) s:$l($g(val)) val=##Class(web.PACReferralType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMReferralTypeSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFTDesc"),"推荐类型"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFTDesc") s oktosave=0
	 i $d(%request.Data("ADMCATDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("ADMCATDesc",1)) s:$l($g(val)) val=##Class(web.PACAdmCategory).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAdmCategDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("ADMCATDesc"),"入院类别"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"ADMCATDesc") s oktosave=0
	 i $d(%request.Data("READesc",1)) d
	 . s (val,oldval)=$g(%request.Data("READesc",1)) s:$l($g(val)) val=##Class(web.PACAdmReason).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAdmReasonDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("READesc"),"入院原因"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"READesc") s oktosave=0
	 i $d(%request.Data("SUBTDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("SUBTDesc",1)) s:$l($g(val)) val=##Class(web.PACEpisodeSubType).GetIdFromCodeOrDescription($g(val)) d obj.PAADMEpissubtypeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("SUBTDesc"),"就诊子类别"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"SUBTDesc") s oktosave=0
	 i $d(%request.Data("PAADMRemark",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRemark",1)) s obj.PAADMRemark=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRemark"),"注释"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRemark") s oktosave=0
	 i $d(%request.Data("PAADMRefDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRefDate",1)) s obj.PAADMRefDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRefDate"),"推荐时间"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRefDate") s oktosave=0
	 i $d(%request.Data("CTRFCDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CTRFCDesc",1)) s:$l($g(val)) val=##Class(web.CTRefClin).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefClinicDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTRFCDesc"),"转诊诊所"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CTRFCDesc") s oktosave=0
	 i $d(%request.Data("PAADMRefApprovNo",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMRefApprovNo",1)) s obj.PAADMRefApprovNo=$g(val)
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMRefApprovNo"),"推荐号"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMRefApprovNo") s oktosave=0
	 i $d(%request.Data("CTPCPDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CTPCPDesc",1)) s:$l($g(val)) val=##Class(web.CTCareProv).GetIdFromCodeOrDescription($g(val)) d obj.PAADMAdmDocCodeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTPCPDesc"),"医护人员"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CTPCPDesc") s oktosave=0
	 i $d(%request.Data("CTLOCDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("CTLOCDesc",1)) s:$l($g(val)) val=##Class(web.CTLoc).GetIdFromCodeOrDescription($g(val)) d obj.PAADMDepCodeDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTLOCDesc"),"科室"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"CTLOCDesc") s oktosave=0
	 i $d(%request.Data("REFDDesc",1)) d
	 . s (val,oldval)=$g(%request.Data("REFDDesc",1)) s:$l($g(val)) val=##Class(web.PACRefDoctor).GetIdFromCodeOrDescription($g(val)) d obj.PAADMRefDocListDRSetObjectId($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFDDesc"),"外部推荐医生"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"REFDDesc") s oktosave=0
	 i $d(%request.Data("PAADMAdmTime",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMAdmTime",1)) s obj.PAADMAdmTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMAdmTime"),"就诊时间"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMAdmTime") s oktosave=0
	 i $d(%request.Data("PAADMAdmDate",1)) d
	 . s (val,oldval)=$g(%request.Data("PAADMAdmDate",1)) s obj.PAADMAdmDate=..%ZDH($g(val))
	 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAADMAdmDate"),"就诊日期"),oldval_" "_$g(t("XINVALID")," is invalid"),251,"PAADMAdmDate") s oktosave=0
	 i 'oktosave,'$g(msg.Count("E")),$g(%request.Data("TOVERRIDE",1)) s oktosave=1
	 i oktosave d
	 . s save=obj.%Save(0)
	 . i $d(msg) d msg.Status(save,251)
	 s:save id=obj.%Id()
	 d obj.%Close()  s obj=""
	 s idnew=id
	 d:save ##Class(web.PAAdm).websysAfterSave(compref,id,new)
	 i 'new d ##Class(websys.Lock).LockClear($lb(id,"User.PAAdm"),%session.SessionId)
	 q save

saveerr
 d ##Class(websys.Lock).LockClear($lb(id,"User.PAAdm"),%session.SessionId)
 s ^Temp("Upgrade","web.PAAdm","websysSave",$h)=$ZE
 q 1
}

/// SB 30/04/02: Copied the default websysSave.
ClassMethod websysSaveBarthelScore(compref As %String, id As %String)
{
}

/// KM 25-Sep-2002: Called from component PAAdmTransaction.EditBookingEM (use to be called PAAdm.EditBedAdmission).  Most of this program does 
/// virtually the same save as the PAAdmTransaction.websysSaveBooking() so all neccessary %request.Get() variables have been set and then this method is called.
ClassMethod websysSaveBedAdmission(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveChangeStatus(compref As %Library.String, id As %Library.String)
{
	///wanghc 改变状态 20121212
	s Status=%request.Get("Status")
	q:Status="" $$$OK
	s Status=$s(Status="Did Not Attend":"N",Status="Current":"A",1:$e(Status,1,1))
	s EpisodeID = %request.Get("EpisodeID")
	q:EpisodeID="" $$$OK
	s UserID = %request.Get("UserID")	
	s visitStatus = $p(^PAADM(EpisodeID),"^",20)
	if visitStatus="D",Status="A"{	
		S reverseReasonId = ##class(web.PACReasonForReverseFinDisch).GetIdFromCodeOrDescription("病情变化")
		q ##class(web.DHCADTDischarge).PAAdmReverseFinalDischarge(EpisodeID, UserID, reverseReasonId)
	}
	s curDate = +$h
	s curTime = ..%SysTime()
	&sql(update SQLUser.PA_Adm  
	set PAADM_VisitStatus=:Status ,
	PAADM_UpdateUser_DR=:UserID,
	PAADM_UpdateDate = :curDate,
	PAADM_UpdateTime = :curTime
	where PAAdm_Rowid=:EpisodeID)
	q $$$OK
}

ClassMethod websysSaveDischarge(compref As %Library.String, id As %Library.String)
{
	s $zt="SaveDischageError"
	//s ^Temp("websysSaveDischarge")=compref_","_id_","_%request.Get("EpisodeID")

	s compid=$e($p(compref,"i",1),2,999)
	if '##class(web.SSUser).ValidatePIN(%request.Get("UserCode"),"",compid,"",0) Q 0
	if '##class(web.SSUser).ValidatePIN(%request.Get("UserCode"),%request.Get("PIN"),compid,"",0) Q 0

	n EpisodeID
	s EpisodeID=%request.Get("EpisodeID")
	s userId=%session.Data("LOGON.USERID")
	s medDischDate=%request.Get("PAADMEstimDischargeDate")
	s medDischTime=%request.Get("PAADMEstimDischargeTime")
	s dischDate=%request.Get("PAADMDischgDate")
	s dischTime=%request.Get("PAADMDischgTime")
	s deceasedDate=%request.Get("PAPERDeceasedDate")
	s deceasedTime=%request.Get("PAPERDeceasedTime")
	s disConDesc = %request.Get("DISCONDesc")
	q:EpisodeID="" ;"没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)="D" ;"不能对出院病人操作!"
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" ;"请用医护人员的身份操作!"
	
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" ;"未定义医护人员类型!"
	
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="DOCTOR")&(ctcptInternalType'="NURSE") ;"医护人员类型错!"

	
	if ctcptInternalType="DOCTOR"{
		s PAADMEstDischConfirmed=$p(^PAADM(EpisodeID,2),"^",25)
		;wanghc add if 
		;如果已经医疗结算过,再医疗结算并且时间与出院状态都是空的则为-撤消医疗结算
		if ((PAADMEstDischConfirmed="Y")&&(medDischDate="")&&(medDischTime="")&&(disConDesc="")){
			Q ##class(web.DHCADTDischarge).ReverseEstimDischarge(EpisodeID)
		}else{
			//医疗结算日期不能为空，为空不能办理医疗结算
			q:((medDischDate="")!(medDischTime="")) 0	 ///医疗结算日期不能为空，为空不能办理医疗结算
		}
	}
		
    i $l(medDischDate,"/")=3 s medDischDate=$zdh(medDischDate,4)
    i $l(medDischTime,":")>1 s medDischTime=..%ZTH(medDischTime)
    i $l(dischDate,"/")=3 s dischDate=$zdh(dischDate,4)
    i $l(dischTime,":")>1 s dischTime=..%ZTH(dischTime)
    i $l(deceasedDate,"/")=3 s deceasedDate=$zdh(deceasedDate,4)
    i $l(deceasedTime,":")>1 s deceasedTime=..%ZTH(deceasedTime)
	s curDate=..%SysDate(),curTime=..%SysTime()
    i (medDischDate>curDate)!((medDischDate=curDate)&(medDischTime>curTime)) {
    	s medDischDate=curDate,medDischTime=curTime
    }
    
	;医疗结算也要 写MR_Adm,医生死亡病人时要写pa_person  ;add by wanghc
    s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
	s disconId=$s(disConDesc="":"",1:$o(^PAC("DISCON",0,"Desc",disConDesc,"")))
	&SQL(Update MR_Adm set MRADM_ConditAtDisch_DR=:disconId	where MRADM_RowId=:mrAdmId)		
	s paperId=$p(^PAADM(EpisodeID),"^",1)
	i ((disconId'="")&&($p(^PAC("DISCON",disconId),"^",3)="D")){
        ;i (deceasedDate>medDischDate)!((deceasedDate=medDischDate)&(deceasedTime>medDischTime)) s deceasedDate=medDischDate,deceasedTime=medDischTime
		s paperDeceased="Y"
	}else {	//删除死亡状态就相当于反向死亡
		s deceasedDate="",deceasedTime="",paperDeceased=""
	}
	&sql(update PA_Person set PAPER_Deceased=:paperDeceased,
	    	PAPER_Deceased_Date=:deceasedDate,
	    	PAPER_DeceasedTime=:deceasedTime 
	    	where Paper_RowId=:paperId)
    
    i ctcptInternalType="DOCTOR" {
	   	&sql(update SQLUser.PA_ADM set 
	   		PAADM_EstDischConfirmed='Y',
			PAADM_EstimDischargeDate=:medDischDate,
			PAADM_EstimDischargeTime=:medDischTime,
			PAADM_MedDischDoc_DR=:ctcpId,
			PAADM_UpdateDate=:curDate,
			PAADM_UpdateTime=:curTime,
			PAADM_UpdateUser_DR=:userId 
		Where PAADM_RowId=:EpisodeID)
		Q SQLCODE
    }
        
    //以下是护士的最终结算
    q:(dischDate="")!(dischTime="") 0    ///最终结算日期不能为空，为空不能办理出院
    i dischDate="" s dischDate=curDate,dischTime=curTime
    i dischTime="" s dischTime=curTime
    i (dischDate>curDate)!((dischDate=curDate)&(dischTime>curTime)) s dischDate=curDate,dischTime=curTime
    
    s paadmEstDischDate=$p(^PAADM(EpisodeID),"^",59)
    s paadmEstDischTime=$p(^PAADM(EpisodeID),"^",60)
    q:(paadmEstDischDate>dischDate)!((paadmEstDischDate=dischDate)&(paadmEstDischTime>dischTime)) "最终结算时间不能早于医疗结算时间!"
	
    s retStr=##class(web.DHCADTDischarge).DischargeBaby(EpisodeID, userId)
    q:retStr'=0 retStr
    
    s disConDesc=%request.Get("DISCONDesc")
    s disConDesc=$$ALPHAUP^SSUTIL4(disConDesc)
  
    Q ##class(web.DHCADTDischarge).PAAdmFinalDischarge(EpisodeID, userId, dischDate, dischTime, disConDesc, deceasedDate, deceasedTime)
    
SaveDischageError
	s ^Temp("web.PAAdm","websysSaveDischarge","error",$j)=$ze
	q "操作错误! "_$ze
}

ClassMethod websysSaveEpisodeComments(compref As %Library.String, EpisodeID As %Library.String, PAADMRemark As %Library.String)
{
}

ClassMethod websysSaveLetterNotes(compref As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod websysSaveMedicallyFit(compref As %Library.String, EpisodeID As %Library.String, MedicallyFit As %Library.String)
{
}

ClassMethod websysSaveRUGADL(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveSeenByDoc(compref As %Library.String, id As %Library.String, mhpractflag As %String = "")
{
}

/// wanghc 20121203
ClassMethod GetUpdateDetailsAdm(Adm As %String) As %Library.String
{
	n tmpObj
	s username = "",usercode="" ,updatedate="",updatetime="",updateHospotal=""
	s tmpObj = ##class(User.PAAdm).%OpenId(Adm,0)
	s tmpUserObj =  tmpObj.PAADMUpdateUserDR
	if $IsObject(tmpUserObj){
		s username = tmpUserObj.SSUSRName
		s usercode = tmpUserObj.SSUSRInitials
		s updatedate = ..%ZD(tmpObj.PAADMUpdateDate)
		s updatetime = ##class(websys.Conversions).TimeLogicalToHtml(tmpObj.PAADMUpdateTime)
		if ($IsObject(tmpObj.PAADMUpdateUserHospitalDR)){
			s updateHospotal = tmpObj.PAADMUpdateUserHospitalDR.HOSPDesc
		}
	}
	
	s %request.Data("PAADMUserUpdate",1)=username
	s %request.Data("PAADMUserUpdateInitials",1)=usercode
	s %request.Data("PAADMUpdateDate",1)=updatedate
	s %request.Data("PAADMUpdateTime",1)=updatetime
	s %request.Data("PAADMUpdateUserHospitalDR",1)=updateHospotal
	q updateHospotal_"^"_username_"^"_usercode_"^"_updatedate_"^"_updatetime
}

ClassMethod ValidateEpisode(EpisodeID As %String = "", ControlDate1 As %String = "", ControlDate2 As %String = "") As %Boolean
{
}

Query FindByEpisodeVP(Status As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeID,RegNum,PAADMADMNo,PatientID,PAADMAdmDate,PAADMAdmTime,CTLOCDesc,CTPCPDesc,Name,Name2,Dob,Sex,OriginalAdm,disdate,distime,Diagnosis,DSCLDesc")
{
}

/// 7/11/06 EZ log #56199 added three fields InpAdmType,PrefAccType,EstimDischargeDate
Query FindByLocDate(location, dateFrom, dateTo, PAADMType, VisitStatus, WARDDesc, CTPCPDesc, HOSPDesc, PayorDesc, InUK, PAPMIName, PAPMINo, PAPERName4, PAPERName2) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PAADMPAPMIDR,PAPMINo:%String,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,CTSEXDesc:%String,PAADMAdmDate:%Date,PAADMAdmTime:%Time,PAADMMainMRADMDR,CTACUDesc:%String,MRADMPresentComplaint:%String,MRCIDDesc:%String,PAADMDischgDate:%Date,PAADMDischgTime:%Time,WARDDesc:%String,PAADMPayor,PAPERPayor,DSCLDesc,PAADMLikelihoodAdmit:%String,BEDCode:%String,unitCTLOCDesc:%String,unitCTPCPDesc:%String,PAPMIDOB:%String,PAPERAge:%String,CTLOCDesc:%String,CTPCPDesc:%String,OPERDesc:%String,WLMRCIDDesc:%String,PAADMPatientContacted:%String,PAADMOverseasVisitor:%String,WLProvisionalDiagnosis:%String,SPPPDesc:%String,WLRemarks:%String,SUBTDesc:%String,WLProcedureFreeText:%String,READesc:%String,APPTBSDesc:%String,PAADMType:%String,Campus:%String,Comments:%String,ShareCare:%String,AdmissionPoint:%String,PAADMPlan:%String,Hospital:%String,BedType:%String,PAADM2ExpAdmTime:%Time,PAPMIName4:%String,PAPMIName5:%String,PAPMIName6:%String,PAPMIName7:%String,PAPMIName8:%String,VIPStatus,InpAdmType,PrefAccType,EstimDischargeDate")
{
}

Query FindCurrentPatients(TSRTITM, TSRTORD, PARAMS) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeID,PatientID,mradm,BookedBed,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,RoomDesc,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,VisitorStatus,ReturnDayOfLeave,boarder,PayorType,DischClass,waitingTime,BookedWard,PAADMPayor,hospital,MRCIDDesc,BedExtNo,PAADMTriageTime,AdmitUnit,AdmitDoc,CSU,edob,dimgList,ddescList,OrderName1,Modifiers1,MainMeal11,MainMeal21,MainMeal31,TriageDate,PriorityCode,PAADMPayorCode,CondAtDisch,DOSA,PAADMDepType,PrivatePayor,PrivatePlan,AdmitWard,AdmitBed,CTDSPDesc,DISCONDesc,OrderName,Modifiers,MainMeal1,MainMeal2,MainMeal3,PAADMType,updatelast12,updatelast24,PAADMSeenDate,PAADMSeenTime,AdmissionPoint,PAADMCurrentWardSigFac,DOB,PAADMAppointBookingSystemDesc,PAADMAdmReasonDesc,PAADMPatientContacted,PAADMInterviewRec,PAADMRemark,WLProcedureFreeText,WLIntendedWardSigFac,BookedWardSigFac,PAADM2AdmPointLocDR,PAADMADMNo,PAPERName4,PAPERName5,PAPERName6,PAPERName7,PAPERName8,VIPStatus")
{
}

/// cjb 31/01/2005 49390 - this is only being used by web.PAMergePatient.CheckIPADMOverLap so stripped out all the unused columns
Query FindEpisodeDetails(PatientID, admType, VISITSTATUS) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PAADMAdmDate:%Date,PAADMDischgDate")
{
SELECT PAADM_AdmDate, PAADM_DischgDate
FROM SQLUser.PA_Adm
WHERE   (PAADM_PAPMI_DR = :PatientID)
AND ((:admType IS NULL) OR (:admType [ PAADM_Type))
AND ((:VISITSTATUS IS NULL) OR (:VISITSTATUS [ PAADM_VisitStatus))
ORDER BY PAADM_AdmDate DESC, PAADM_AdmTime DESC
}

Query FindEpisodeWithPayor(TSRTITM As %String, TSRTORD As %String, PatientID, admType, VISITSTATUS, ADMINTTYPE, VERIFIED, CodeEpisode, EpisodeIDs, SameHospital) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeID,PAADMADMNo:%String,PAADMAdmDate:%Date,PAADMAdmTime:%Time,CTLOCDesc:%String,CTPCPDesc:%String,PAADMVisitStatus:%String,DEPDesc:%String,PAADMRemark:%String,SERDesc:%String,PAADMType:%String,payor:%String,mradm:%String,PAADMDischgDate:%Date,PAADMDischgTime:%Time,REFPRIDesc:%String,RSTDesc:%String,REFTDesc:%String,WARDDesc:%String,WLType:%String,WLRowId:%String,GPConsent:%String,CodingStatus:%String,CARETYPDesc:%String,IPATDesc:%String,AdmSrc:%String,Hosp:%String,CTDSPDesc:%String,Plan:%String,Outstanding:%String,RESDesc:%String,MRADMGPConsent:%String,ACUDesc:%String,ADMCATDesc:%String,PatientID:%String,RegNo:%String,Surname:%String,FirstName:%String,DischSource:%String,SIGNFDesc:%String,RUDesc:%String,RefSource:%String,OPDaysWaiting:%String,LengthOfStay:%String,DiagPC:%String,VisitRefStatus:%String,OtherName:%String,Sex:%String,DOB:%String,Bed:%String,CTPCPCode:%String,DDESTDesc:%String,REFDDesc:%String,SUBTDesc:%String,VisitDischStatus:%String,WLRemarks:%String,SPPPCode:%String,SPPPDesc:%String,WLProcedureFreeText:%String,RBCServ:%String,WLAdmComment:%String,IntendedWard:%String,PAADMFinDischDate:%Date,PAADMMedDischDate:%Date,PAADMSpecialCategory:%String,PAADMFlaggedPatient:%String,PAADM2ReferredToHospitalDR:%String,PAADMVerified:%String,payorCategory:%String,IsCoded:%String,VIPStatus,CMCTPCPDesc,HidPAADMVisitStatus,GroupNumber,OrigAdmNo,HidFAUpdateUser,HidFAUpdateDate,HidComents,HidFAConcern,PatientType")
{
}

Query FindIncomplete(loc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,PAADMAdmDate:%Date,PAADMAdmTime:%Time,CTPCPDesc:%String,PAADMPAPMIDR,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,mradm,CarPrvLastTreated:%String")
{
}

/// $lb(outWardName,outBedNo,outRoomNo,outBedStatus,
/// outSex,outEpiDept,outEstDis,outFirstName,outLastName)
Query FindMultiview(LocType As %Library.String, Location As %Library.String, CareProv As %Library.String, DateFrom As %Library.Date, DateTo As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time, OrderCategory As %Library.String, LocationOfInPat As %Library.String, PAADMLikelihoodAdmit As %Library.String, DEPDesc As %Library.String, EpisodeNo As %Library.String, TRDDesc As %Library.String, PAPMIName As %Library.String, DISCONDesc As %Library.String, ExtraParams As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeID,AdmNo,AdmDate,AdmTime,PatientID,RegNo,Name,Name2,DOB,Age,Sex,Loc,Doc,mradm,PresentingComplaint,InPatEpisodeID,InPatEpisodeNo,InPatEpisodeLocation,ArrMode,ReqForBed,DepGroup,DisChrDest,ordercat,DischDesc,OtherHosp,RefOnDep,HospWard,PAADMVisitStatus,DSCLDesc,edob,Injury,discond,TLoc,DDate,DTime,Hosp,AdmMeth,AdmSourc,AdmCateg,MedicFit,OnLeav,edDate,edTime,NoBedAssed,EExpDisch,GovCategory,TempLocDate:%Library.Date,TempLocTime:%Library.Time,DischWard,AdmPayor,ReqForBedTime,Name3,Name4,Name5,Name6,Name7,Name8,VIPStatus,Priority,SubjectiveFindings,WaitingTime,SeenDate")
{
}

/// used in PAAdm.FindMultiReferral & PAAdm.ListMultiReferral
/// please make sure:
/// weekswaiting is the last piece in the Row specification
Query FindReferralDetails(TSRTITM As %Library.String, TSRTORD As %Library.String, ToDate As %Library.String, FromDate As %Library.String, Status As %Library.String, CTPCPDesc As %Library.String, HOSPDesc As %Library.String, HCADesc As %Library.String, weeksWaiting As %Library.String, REFPRICode As %Library.String, CTACUDesc As %Library.String, HCPPDesc As %Library.String, PAPMIName As %Library.String, noAppt As %Library.String, HiddenFindParameters As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,refNo,Surname,gname,status,date,speciality,cprov,source,chi,patientID,admpro,hcppro,PAPMINo,weekswaiting,AdmStatus,psex,poname,AdmReferralDoc,AdmReferralType,patcont,MedRecNo,dayswaiting,admtype,refsrc,RefPriority,AuditLetterResponse,DateAuditLetterSent:%Date,CreateDate:%Date,ResponceDate:%Date,PACRefStatCode,RSTVisitStatus,oname2,oname3,oname4,oname5,oname6,VIPStatus,CMCTPCPDesc")
{
}

Query FindRestrIncompl(loc As %String, AdmType As %String, WaitList As %String, CurrentPat As %String, Discharged As %String, datefrom As %String, dateto As %String, CarPrvLastTreated As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,PAADMAdmDate:%Date,PAADMAdmTime:%Time,CTPCPDesc:%String,PAADMPAPMIDR,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,mradm,CarPrvLastTreated:%String,EpType,VisStat,admNo:%String,DischgDate:%Date,VIPStatus")
{
}

/// KM: 12Jun2001: Modified by adding Diagnosis; for user with PAAdm.ListUnverified
Query FindUnverified(loc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PAADMAdmDate:%Date,PAADMAdmTime:%Time,PAADMDischgDate:%Date,PAADMDischgTime:%Time,DSCLDesc:%String,PAADMPAPMIDR,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,WARDDesc:%String,BEDCode:%String,unitCTLOCDesc:%String,unitCTPCPDesc:%String,Diagnosis:%String,TRDDesc:%String,VIPStatus")
{
}

Query FindFA(TSRTITM As %Library.String, TSRTORD As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, AdmType As %Library.String, Flags As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,EpisodeNo:%String,PAADMPAPMIDR,PAPMINo:%String,PAPMIName:%String,PAPMIName2:%String,DOB,Sex:%String,PostCode:%String,PAADMAdmDate,PAADMAdmTime")
{
}

/// cjb 10/02/2005 49390 - dummy methods as the brokers aren't being used (not actually used, but they are on some hidden fields, DR's to PAAdm...)
/// the dummy methods ensure that websys.abstract doesn't generate nasty sql
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetIdFromCodeOrDescription(number As %Library.String) As %Library.String
{
	Quit:number="" 0
	Set tmpid = $O(^PAADMi("No",number,0))
	Quit tmpid
}

ClassMethod GetIdFromDateCodeOrDesc(number As %Library.String, date As %Library.Date = "") As %Library.String
{
}

ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod GetCurrWLID(EpisodeID As %Library.String) As %Library.String
{
}

// log58996 TedT get Inpatient ward for discharged emergency episode

ClassMethod GetIPWard(PatientID As %String, EpisodeID As %String) As %String
{
}

ClassMethod GetPatDep(epID As %Library.String) As %Library.String
{
}

/// Log 66213 - to return the episode hospital id
ClassMethod GetDefaultEpHosp(EpisodeId As %Library.String) As %Library.String
{
}

ClassMethod checkRegEpisode(admtype As %Library.String, totD As %Library.String)
{
}

/// New method added, log 49183 to check if this security group is allowed to view active episode alerts 
ClassMethod CheckEpisodeAlerts(EpisodeID As %String) As %Library.String
{
	quit ""
}

/// Log 64089 - 25.10.2007
ClassMethod GetAgrRefWarning(PatientID As %Library.String, Payor As %Library.String, Plan As %Library.String, EpDate As %Library.String = "", EpSubType As %Library.String = "", CareProvider As %Library.String = "") As %Library.String
{
}

ClassMethod CheckSecGrRest(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

/* from PAAdm.Edit.js
//md 10/03/2005 structure for HiddenCodes string
//1 = Location ID, 2 = Ward ID, 3 = CareProv Code, 4 = PAAdmRefDocListDR, 
//5 = PAADMFundingArrangementDR code, 6 = AllowEditLogLoc (sec grp)
//7 = PAADMTreatingDr Code, 8 = pat DVA number, 9 = use discharge date (system param), 
//10 = Ward Code, 11 = wardmessage (ward ct), 12 = closedwarddesc (ward ct)
//13 = iswardclosed (ward ct), 14 = HOSPMandatoryRefHospital, 
//15 = CTLOC mental health flag, 16 = ADSOUCode, 17 = Indigenous status, 18 = Patient DOB
//19 = Pat HealthFundNo, 20 = refstat reason id, 21 = snap ward flag,
//22 = PAADMRefPeriodDR factor, 23 = Bed ID, 24 = ATTENDMandatoryRefDoctor, 25 = ATTENDMandatoryRefHospital
//26 = PAADMAdmCategDR Code, 27=PAADMAdmReasonDR Code, 28=PAADMEpissubtypeDR Code, 29 = snap bed flag
//PAPersonPatMasID=$p(ret,"^",32) --->PAADMDischarge.Edit component PAPersonPatMas
//PRS2Status=$p(ret,"^",33)	--->PAADMDischarge.Edit component PAPersonPatMas

*/
/// 
/// add by wuqk 2011-06-21 for PAAdm.Edit.HiddenCodes
/// replace $$getHiddenCodes^CPAAdm1A
/// PAADMDischarge.Edit component HiddenCodes
///   update websys.ComponentItems set ValueGet='i obj s val=##class(web.PAAdm).getHiddenCodes(obj.%Id())'
///   where ParRef=251 and Name='HiddenCodes'
/// modify by wuqk 2011-07-12
/// --update websys.ComponentItems set ValueGet='i obj s val=##class(web.PAAdm).getHiddenCodes(obj.%Id())' 
/// 	  where parref->name='PAADMDischarge.Edit' and name='HiddenCodes'
/// --update websys.ComponentItems set ValueGet='i $g(%request.Data("PARREF",1))\'="" s val=##class(web.PAAdm).getHiddenCodes($g(%request.Data("PARREF",1)))'
///   where parref->name='PAAdmTransaction.EditNew' and name='HiddenCodes'    --出入院管理-转移-转科(注意转科时一定要选择科室和病房!都需要)(T) 
/// 
ClassMethod getHiddenCodes(EpisodeID As %Library.String)
{
	n objEpisode,objPatient,objPerson	
	q:$g(EpisodeID)="" ""
	s objEpisode=##class(User.PAAdm).%OpenId(EpisodeID)
	s objPatient=##class(User.PAPatMas).%OpenId(objEpisode.PAADMPAPMIDR.%Id()) //objEpisode.PAADMPAPMIDR
	s objPerson=##class(User.PAPerson).%OpenId(objEpisode.PAADMPAPMIDR.%Id())
	//s tmpPAAdm=$g(^PAADM(EpisodeID))
	//s PatientID=$p(tmpPAAdm,"^",1)
	s ret=""
	s $p(ret,"^",1)=$s(objEpisode.PAADMDepCodeDR:objEpisode.PAADMDepCodeDR.%Id(),1:"")   //PAADM_DepCode_DR
	s $p(ret,"^",2)=$s(objEpisode.PAADMCurrentWardDR:objEpisode.PAADMCurrentWardDR.%Id(),1:"")   //PAADM_CurrentWard_DR
	s $p(ret,"^",3)=$s(objEpisode.PAADMAdmDocCodeDR:objEpisode.PAADMAdmDocCodeDR.CTPCPCode,1:"")   //PAADM_AdmDocCodeDR->Code
	s $p(ret,"^",4)=$s(objEpisode.PAADMRefDocListDR:objEpisode.PAADMRefDocListDR.%Id(),1:"")   //PAADM_RefDocList_DR
	s $p(ret,"^",5)=$s(objEpisode.PAADMFundingArrangementDR:objEpisode.PAADMFundingArrangementDR.FUNDARCode(),1:"")   //PAADM_FundingArrangement_DR->Code
	//s $p(ret,"^",6)=$p(tmpPAAdm,"^",4)   //AllowEditLogLoc
	s $p(ret,"^",7)=$s(objEpisode.PAADMTreatingDrDR:objEpisode.PAADMTreatingDrDR.CTPCPCode,1:"")   //PAADMTreatingDr Code
	s $p(ret,"^",8)=objPatient.PAPMIDVAnumber   //pat DVA number
	s $p(ret,"^",9)=objEpisode.PAADMDischgDate   //discharge date
	s $p(ret,"^",10)=$s(objEpisode.PAADMCurrentWardDR:objEpisode.PAADMCurrentWardDR.WARDCode,1:"")   //Ward Code
	//s $p(ret,"^",11)=$p(tmpPAAdm,"^",4)   //wardmessage
	//s $p(ret,"^",12)=$p(tmpPAAdm,"^",4)   //closedwarddesc
	//s $p(ret,"^",13)=$p(tmpPAAdm,"^",4)   //iswardclosed
	//s $p(ret,"^",14)=$p(tmpPAAdm,"^",4)   //HOSPMandatoryRefHospital
	//s $p(ret,"^",15)=$p(tmpPAAdm,"^",4)   //CTLOC mental health flag
	//s $p(ret,"^",16)=$p(tmpPAAdm,"^",4)   //ADSOUCode, 
	//s $p(ret,"^",17)=$p(tmpPAAdm,"^",4)   //Indigenous status
	s $p(ret,"^",18)=$zd(objPerson.PAPERDob)   //Patient DOB
	//s $p(ret,"^",19)=$p(tmpPAAdm,"^",4)   //Pat HealthFundNo
	//s $p(ret,"^",20)=$p(tmpPAAdm,"^",4)   //refstat reason id
	//s $p(ret,"^",21)=$p(tmpPAAdm,"^",4)   //snap ward flag
	s $p(ret,"^",22)=$s(objEpisode.PAADMRefPeriodDR:objEpisode.PAADMRefPeriodDR.REFPERFactor,1:"")   //PAADMRefPeriodDR factor
	s $p(ret,"^",23)=$s(objEpisode.PAADMCurrentBedDR:objEpisode.PAADMCurrentBedDR.%Id(),1:"")   //Bed ID
	//s $p(ret,"^",24)=$p(tmpPAAdm,"^",4)   //ATTENDMandatoryRefDoctor
	//s $p(ret,"^",25)=$p(tmpPAAdm,"^",4)   //ATTENDMandatoryRefHospital
	s $p(ret,"^",26)=$s(objEpisode.PAADMAdmCategDR:objEpisode.PAADMAdmCategDR.ADMCATCode,1:"")   //PAADMAdmCategDR Code
	s $p(ret,"^",27)=$s(objEpisode.PAADMAdmReasonDR:objEpisode.PAADMAdmReasonDR.REACode,1:"")    //27=PAADMAdmReasonDR Code
	s $p(ret,"^",28)=$s(objEpisode.PAADMEpissubtypeDR:objEpisode.PAADMEpissubtypeDR.SUBTCode,1:"")    //28=PAADMEpissubtypeDR Code
	//s $p(ret,"^",29)=$p(tmpPAAdm,"^",4)   //snap bed flag
	
	//quit "63^^396^^^^^^^^^^^^N^^^01/01/1973^^^^^^^^^01^^^38^^^"
	//quit "8^12^120^^^N^^ ^^内四科护理单元^^^^^N^^^11/01/1974^^^N^^12||1^^^^07^^N^37^^^"  --->PAADMDischarge.Edit component HiddenCodes

	quit ret
}

ClassMethod GetPatientBaseInfo(papmi, adm)
{
	n (papmi,adm,%request,%session)
	s name="",bedno="",age="",sex="",weight="",ipno="",insu="",ipdate=""
	Set langid=..%LanguageID()
	q:(papmi="")&&(adm="") "{}"
	s:papmi="" papmi = +^PAADM(adm)
	q:'$d(^PAPER(papmi)) "{}"
	S CONTEXT = $g(%session.Data("CONTEXT"))	
	s:$d(^PAPER(papmi,"ALL")) name = $p(^PAPER(papmi,"ALL"),"^",1)
	/// 护士站 -转移记录中增加床位号字段---用于取值 2018-8-1
	if ..%IsValidMethod("Nur.Interface.OutSide.Patient","getPatientLastBedCode"),##class(%Dictionary.CompiledProperty).%ExistsId("User.PAAdmTransaction||TRANSBedCode"){
		Set bedno = ##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(adm)
	}else{
		s:$d(^PAADM(adm)) beddr = $p(^PAADM(adm),"^",73)
		s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
	}
	s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	s sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",sex,langid)
	s weight=##class(web.DHCDocInPatientList).GetWeight(adm)
	s age = ##class(web.DHCDocMainOrderInterface).GetPatientAge(papmi,adm)

	s regno = ##class(web.PAPatMas).GetRegistration(papmi)
	;s ipno=""
	;s:$d(^PAPER(papmi,"PAT",1)) ipno = $p(^PAPER(papmi,"PAT",1),"^",22)
	s ipno = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(adm)
	s insu = $p(^PAADM(adm,1),"^",7) ;PAADMAdmReasonDR
	s:insu'="" insu=$p(^PAC("ADMREA",insu),"^",2)
	s insu=##class(User.PACAdmReason).GetTranByDesc("READesc",insu,langid)
	s ipdate = $p(^PAADM(adm),"^",6)
	if ipdate'="" {
		Set ipDays = +$h-ipdate
		set ipdate=$zd(ipdate,3)
		set baseInfoAdmDays=ipDays
		if (baseInfoAdmDays=0) set baseInfoAdmDays=1
	}
	s admInfo=##Class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(adm) 
	s ipDays=$p(admInfo,"^",12)
	s charge=##class(web.DHCDocOrderCommon).GetCurrentDeposit(adm)
	Set mradm=$P(^PAADM(adm),"^",61)
	Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)
	/*if ($l(Diagnosis)>10){
		Set Diagnosis=$e(Diagnosis,1,10)_"..."
	}*/
	s isEstDisch = ##class(web.DHCDocMain).isEstDisch(adm)
	set IconProfile=$ZCVT(##class(epr.CTIconProfile).ShowIcon("MAP",adm_"^^^"_papmi,CONTEXT),"O","HTML")	//加图表菜单
	s TdeptDesc=""
	s admDept = $p(^PAADM(adm),"^",4)
	s:+admDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(admDept)
	s Tel=$p($g(^PAPER(papmi,"PER",1)),"^",11)
	
	s jsonObj = ##class(ext.util.JsonObject).%New()
	d jsonObj.Put("baseInfoName",name).Put("baseInfoBedno",bedno).Put("baseInfoAge",age).Put("baseInfoSex",sex)
	d jsonObj.Put("baseInfoBodyWeight",weight).Put("baseInfoIPNo",ipno).Put("baseInfoInsu",insu).Put("baseInfoIPDate",ipdate)
	d jsonObj.Put("baseIsEstDisch",isEstDisch).Put("baseIconProfile",IconProfile).Put("baseInfoRegNo",regno).Put("baseInfoIPDays",ipDays)
	d jsonObj.Put("baseInfoCharge",charge).Put("baseInfoDiag",Diagnosis).Put("baseInfoAdmDays",baseInfoAdmDays)
	d jsonObj.Put("baseInfoAdmDept",TdeptDesc).Put("baseInfoTel",Tel)
	
	;"{baseInfoName:"""_name_""",baseInfoBedno:"""_bedno_""",baseInfoAge:"""_age_""",baseInfoSex:"""_sex_""",baseInfoBodyWeight:"""_weight_""",baseInfoIPNo:"""_ipno_""",baseInfoInsu:"""_insu_""",baseInfoIPDate:"""_ipdate_"""}"
	q jsonObj.Json()
}

}
