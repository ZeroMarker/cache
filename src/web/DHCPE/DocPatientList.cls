Class web.DHCPE.DocPatientList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date) As %Status
{
	Set AdmDate=$P($g(^PAADM(Adm)),"^",6)
	If (AdmDate<DateFrom)!(AdmDate>DateTo) Quit 1 
	Quit 0
}

ClassMethod FindDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocCurrentAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DocPatientList","FindDocCurrentAdm","","","2022-02-01","2022-02-17","","","","","","on","","","","",17283,105)
Query FindDocCurrentAdm(PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, IncludeCompleted As %String, IsCanSumResult As %String, GroupID As %String, TeamID As %String, TeamName As %String, LocAudited As %String = "", DepName As %String, DocName As %String, HPLocID As %String, MainDoctor As %String = "", UserID, LocID, CSPName As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String, PAAdmReasonCode:%String, Group:%String, Team:%String,TReason:%String,TTotal:%String,TPosition:%String,TType:%String,TReCheck:%String,TIDCard:%String,TCheckingDoc:%String,TDepName:%String,TAge:%String")
{
}

ClassMethod FindDocCurrentAdmExecute(ByRef qHandle As %Binary, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, IncludeCompleted As %String, IsCanSumResult As %String, GroupID As %String = "", TeamID As %String = "", TeamName As %String, LocAudited As %String = "", DepName As %String, DocName As %String, HPLocID As %String = "", MainDoctor As %String = "", UserID, LocID, CSPName As %String = "") As %Status
{
	s ^tempdhcpe("FindDocCurrentAdm")=$lb(PatientNo,SurName,StartDate,EndDate,IncludeCompleted,IsCanSumResult,GroupID,TeamID,TeamName, LocAudited,DepName,DocName,HPLocID,MainDoctor,UserID,LocID,CSPName)
	s:$d(%session) UserID=%session.Get("LOGON.USERID")
	
	Set CurDate=+$H
	k ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID)
	I StartDate'="" S StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	I EndDate'=""    S EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	s SurName=##class(web.DHCPE.DHCPECommon).UnEscape(SurName)
	d ..DeleteTempQuery()
    
    
	if (PatientNo="")&&(SurName="")&&(StartDate="")&&(EndDate="")&&(IncludeCompleted="")&&(IsCanSumResult="")&&(IsCanSumResult="")&&(GroupID="")&&(TeamID="")&&(LocAudited="")
	{
		s PatientNo=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"PatientNo"))
		s SurName=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"SurName"))
		s StartDate=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"StartDate"))
		s EndDate=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"EndDate"))
		s IncludeCompleted=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"IncludeCompleted"))
		s IsCanSumResult=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"IsCanSumResult"))
		s GroupID=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"GroupID"))
		s TeamID=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"TeamID"))
		s DocName=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"DocName"))
		s LocAudited=$g(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"LocAudited"))
	    s MainDoctor=$G(^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"MainDoctor"))
	}
	else
	{
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"PatientNo")=PatientNo
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"SurName")=SurName
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"StartDate")=StartDate
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"EndDate")=EndDate
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"IncludeCompleted")=IncludeCompleted
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"IsCanSumResult")=IsCanSumResult
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"GroupID")=GroupID
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"TeamID")=TeamID
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"LocAudited")=LocAudited
		s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"DocName")=DocName
	    s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"MainDoctor")=MainDoctor
	}
	s SurName=$ZCVT(SurName,"U")
	
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	i HPLocID'="" s LocID=HPLocID
	
	
	//如果是已完成，日期条件为空，默认为一周内的
	i (IncludeCompleted'="")&&(StartDate="")&&(EndDate="")&&($g(PatientNo)="") d 
	.s EndDate=+$h
	.s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"StartDate")=StartDate
	.s ^DHCPETempQuery("DHCPEDocPatientList",CurDate,UserID,"EndDate")=EndDate

	If LocID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	If UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	If (PatientNo="")&&(SurName="")&&(StartDate="")&&(EndDate="")&&(IncludeCompleted="")&&(IsCanSumResult="")&&(GroupID="")&&(LocAudited="") d
	.Set StartDate=+$h
	
	Set CurrentAdmType="H"
	Set CurrentDept=LocID
	
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	Set Singleflag=0
	set StatusList=",ARRIVED,CHARGED,"
	if IncludeCompleted'="" set StatusList=StatusList_"COMPLETED,"
	
	i PatientNo'="" s PatientNo=##class(web.DHCPE.DHCPECommon).RegNoMask(PatientNo,LocID)
	
	Set PatientNo=$tr(PatientNo," ","")
	
	///ReWrite by wrz 080314
	If ($g(PatientNo)'="") Do
	.s PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	.q:$g(PAPMI)=""
	.d OutPAPMI
	else  if ($g(GroupID)'="")&&(GroupID'="ALLG")&&(GroupID'="ALLI") d
	.s TeamDR=0
	.f  s TeamDR=$o(^DHCPEIADM(0,"GADM",GroupID,TeamDR)) q:TeamDR=""  d
	..q:(TeamID'="")&&(TeamID'=TeamDR)
	..s PEIADM=0
	..f  s PEIADM=$o(^DHCPEIADM(0,"GADM",GroupID,TeamDR,PEIADM)) q:PEIADM=""  d
	...s PAAdm=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	...q:PAAdm=""
	...d CheckPAADM
	else  if ($g(SurName)'="") d
	.s desc=$o(^DHCPEPreIBI(0,"Name",SurName),-1)
	.f  s desc=$o(^DHCPEPreIBI(0,"Name",desc)) q:(desc="")||(desc'[SurName)  d
	..s IBI=0
	..f  s IBI=$o(^DHCPEPreIBI(0,"Name",desc,IBI)) q:IBI=""  d
	...s PreIADM=0
	...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
	....s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	....q:PEIADM=""
	....s PAAdm=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	....q:PAAdm=""
	....d CheckPAADM
	else  d
	.d SetDefaultDate
	.d DeptPatList
	//w (ind-1)_"人",!
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPAPMI
	If CurrentAdmType'="" Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm),-1) Quit:(PAAdm="")||(PAAdm=0)  Do             // modify by zhouli
	..d CheckPAADM
	Else  Do
	.Set AdmType=""
	.For  Set AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:AdmType=""  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:PAAdm=""  Do
	...d CheckPAADM
	q

CheckPAADM
	Set DeptId=$P($g(^PAADM(PAAdm)),"^",4)
	Quit:LocID'=DeptId
	d SetDefaultDate
	Quit:(..CheckAdmDate(PAAdm,StartDate,EndDate))&&(PatientNo="")&&(GroupID="")
	Set EIIsLoc=..EpisodeIdLoc(UserID,PAAdm,LocID)
	Quit:EIIsLoc=0
	d OutputRow
	q
	
DeptPatList
	s DeptItem=CurrentDept
	Quit:DeptItem=""
	if EndDate'="" set Date=EndDate+1
	else  set Date=""
	i StartDate="" s StartDate=0
	For  Set Date=$O(^PAADMi("CurrLoc",DeptItem,Date),-1) Quit:(Date="")!(Date<StartDate)  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("CurrLoc",DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("CurrLoc",DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...d CheckPAADM
	Quit

SetDefaultDate
	if StartDate="" Set StartDate=+$h-40  //StartDate=$ZDH("2005-11-28",3)
	If EndDate="" Set EndDate=+$H
	Quit
	
	
OutputRow
	Do ResetVariables
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	///医生根据登记号查询时登记状态自动到达
	Set PEAdm=$O(^DHCPEIADM(0,"PAADM",PAAdm,""))
	q:PEAdm=""
	s PreIADM=$P($g(^DHCPEIADM(PEAdm)),"^",4)
	q:PreIADM=""
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM,LocID)       //Add by 090702
   	q:LocFlag=1
   	
   	i PatientNo'="" d
	.//第一个为医生界面自动到达\第二个为打印条码自动到达
	.s AutoArrived=$G(^DHCPESetting("DHCPE","AutoArrived",LocID))
	.s AutoArrived=$p(AutoArrived,"^",1)
	.i AutoArrived="Y" d
	..d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(PreIADM)
		
	q:##class(web.DHCPE.ResultEdit).IsArrivedStatu(PAAdm)="0"
	Set EpisodeID=PAAdm
	Set mradm=$P($g(^PAADM(PAAdm)),"^",61)
	Set PAPMINO=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	q:$g(^PAPER(PatientID,"ALL"))=""
	Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	q:(($ZCVT(PAPMIName,"U"))'[SurName)
	
	Set PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml($P($g(^PAPER(PatientID,"ALL")),"^",6))
	Set Sex=$P($g(^PAPER(PatientID,"ALL")),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Set PAAdmDate=##class(websys.Conversions).DateLogicalToHtml($P($g(^PAADM(PAAdm)),"^",6))
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm)
	;s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PatientID,"ALL")),"^",6),$P($g(^PAADM(PAAdm)),"^",6))
	;s Age=$P(Age,"Y",1)
	
	//过滤2007-07-12前的数据           2007-07-25
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	q:$P($g(^PAADM(PAAdm)),"^",6)<PESystemStartDate
	/*/过滤2007-07-12前的数据           2007-07-25
	q:$P($g(^PAADM(PAAdm)),"^",6)<60823
	*/
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	
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
	
	//打开医生界面自动回传结果
	d ##class(web.DHCPE.TransResult).TransMain(PAAdm)
	s Reason=""
	s AppFlag=##class(web.DHCPE.ResultEdit).ItemHadApp("",PAAdm)
	q:(+AppFlag'=1)&&(IsCanSumResult'="")&&(IncludeCompleted="")
	i +AppFlag=2 {
		i CSPName'="" s ReasonEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"有未检查的项目")
		s Reason=$p(AppFlag,"^",2)_ReasonEng
	}
	s NoSub=""
	s Flag=##class(web.DHCPE.ResultDiagnosis).StationSHadSubmit(PAAdm)
	q:(Flag'=0)&&(IsCanSumResult'="")
	i Flag'=0
	{
		s NoReason=$p(Flag,"^",2)
		s i=$L(NoReason,",")
		s AppReason=","_$p(AppFlag,"^",2)_","
		for j=1:1:i
		{
			s NoItem=$p(NoReason,",",j)
			i AppReason'[(","_NoItem_",")
			{
				i NoSub=""
				{
					s NoSub=NoItem
				}
				else
				{
					s NoSub=NoSub_","_NoItem
				}
			}
		}
	}
	
	i NoSub'="" {
		i CSPName'="" s ReasonEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"未提交")
		s Reason=Reason_";"_NoSub_ReasonEng
	}
	
	s RefuseReturn=##class(web.DHCPE.ResultDiagnosis).RefuseStations(PAAdm)
	i RefuseReturn'="" {
		i CSPName'="" s ReasonEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"谢绝检查")
		s Reason=Reason_";"_RefuseReturn_ReasonEng
	}
	i IncludeCompleted=""
	{   i MainDoctor=""
          {
			q:1=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,"")
	
          }
     }
	elseif((MainDoctor="")&&(IncludeCompleted'=""))
	{
		q:0=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,"")
	    q:$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAAdm))'=""
	}
	I (MainDoctor'="")&&(IncludeCompleted="")
	{   
		q:(0=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,""))
		q:$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAAdm))=""
	}elseif(MainDoctor'="")&&(IncludeCompleted'="")
	{   
		q:(0=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,""))
		
	}

	//q:(IncludeCompleted="")&&(1=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,""))
	//q:(IncludeCompleted'="")&&(0=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(PEAdm,""))
	Quit:PEAdm=""
	Set PEAdmStatus=$p(^DHCPEIADM(PEAdm),"^",8)
	Quit:(PatientNo)&&(StatusList'[PEAdmStatus)
	s AdmLocAudit=""
	//s AdmLocAudit=..ADMLocIsAudit(PEAdm)
	//q:AdmLocAudit=2
	Quit:(LocAudited="")&&(1=AdmLocAudit)  //Add by MLH 2008-03-07
	
	Quit:(LocAudited'="")&&(0=AdmLocAudit)
	
	Set GAdmDr=$P($g(^DHCPEIADM(PEAdm)),"^",2)
	q:(GroupID="ALLI")&&(GAdmDr'="")
	q:(GroupID="ALLG")&&(GAdmDr="")
	q:((GroupID'="")&&(GroupID'="ALLI")&&(GroupID'="ALLG")&&(GroupID'=GAdmDr))
	//q:(GroupID'="")&&(GroupID'=GAdmDr)
	Set TAdmDr=$P($g(^DHCPEIADM(PEAdm)),"^",3)
	q:(TeamID'="")&&(TeamID'=TAdmDr)
	;s PreIADM=$P($g(^DHCPEIADM(PEAdm)),"^",4)
	
	
	
	s PreIBaseInfo=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
	q:PreIBaseInfo=""
	s TPosition=$P($g(^DHCPEPreIBI(PreIBaseInfo)),"^",12)
	s TIDCard=$P($g(^DHCPEPreIBI(PreIBaseInfo)),"^",9)
	s TPart=""                               //add by zhouli
	s TPart=$G(^DHCPEDataEx("DHCPEPreIADM","Department",PreIADM)) 
	q:(DepName'="")&&(DepName'=TPart)         //add by zhouli
	s TType=$P($g(^DHCPEPreIADM(PreIADM)),"^",25)
	s TType=##class(web.DHCPE.PreCommon).GetPreTypeDesc(TType)
	s TReCheck=##class(web.DHCPE.PreCommon).GetReCheckFlag(PreIADM,"PreADM")
	s TReCheck=TReCheck+1
	
	if (CSPName'=""){
		s TReChecDkEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"第")
    	s TReChecCkEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,"次")
    	s TReCheck=TReChecDkEng_TReCheck_TReChecCkEng
	}else{
		s TReCheck="第"_TReCheck_"次"
	}
	
	Set Group=""
	Set GroupDr=""
	Set Team=""
	If GAdmDr'="" Do
	.Set GroupDr=$P($g(^DHCPEGADM(GAdmDr)),"^",1)
	.If $g(GroupDr)'="" Set Group=$P($g(^DHCPEGBI(GroupDr)),"^",2)
	.If $G(TAdmDr)'="" Set Team=$P($g(^DHCPEGADM(+TAdmDr,"Team",$P(TAdmDr,"||",2))),"^",1)
	
	Set RegDoctor=""
	Set ArrivedDate=PAAdmDate
	set ArrivedTime=PAAdmTime
	Set LeavedDate=""
	Set LeavedTime=""
	Set LocSeqNo=""
	Set PAAdmPriority=""
	Set ConsultRoom=""
	Set ConsultArea=""
	Set WalkStatus=""
	Set StatusCode="XX"
	Set PriorityCode="XX"
	Set SeqNo="999"
	
	s PAAdmDocCodeDR=..GetGeneralDoctorName(PAAdm)
	q:(PAAdmDocCodeDR'="")&&(PAAdmDocCodeDR'=DocName)&&(DocName'="")
	
	Set Count=Count+1
	
	s TCheckingDoc=$G(^TempDHCPEDocPatientChecking(EpisodeID))
	s:TCheckingDoc'="" TCheckingDoc=$P($G(^SSU("SSUSR",TCheckingDoc)),"^",1)
	
	Set Seq=PAAdmBed
	If Seq="" Set Seq="ZZZZZ"
	
	/***翻译 start***/
    s PAPMISex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PAPMISex,"CTSEXDesc","cls")
    s PAAdmReason=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.PACAdmReason",PAAdmReason,"READesc","cls")
    /***翻译 end***/
    
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,Group,Team,Reason,Count,$G(TPosition),TType,TReCheck,TIDCard,TCheckingDoc,TPart,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ResetVariables
	///Set (repid)=0
	//Set ($g(PatientID),$g(EpisodeID),$g(mradm),$g(PAPMINO),$g(PAPMIName),$g(PAPMIDOB),$g(PAPMISex),$g(PAAdmDate),$g(PAAdmTime),$g(PAAdmNo),$g(PAAdmDepCodeDR),$g(PAAdmDocCodeDR),$g(PAAdmType),$g(Hospital),$g(PAAdmWard),PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,Group,Team,Reason,Count,TPosition,TType,TReCheck)=""
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,Group,Team,Reason,Count,TPosition,TType,TReCheck,TIDCard,TCheckingDoc,Age)=""
	Quit
}

ClassMethod FindDocCurrentAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocCurrentAdmExecute ]
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
 // , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 // Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
 Quit:$g(MRAdm)="" ""
 Set DiagStr=""
 Set Diag=0
 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:Diag=""  Do
 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
 .Quit:$g(DiagID)=""
 .Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 .If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 .If DiagStr="" Set DiagStr=DiagDesc
 .Else  Set DiagStr=DiagStr_","_DiagDesc
 Quit DiagStr
}

ClassMethod GetDocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set DocRowId=$O(^CTPCP(0,"Decs",val,""))
 If DocRowId'="" Set DocCode=$P($g(^CTLOC(DocRowId)),"^",1)
 Quit DocRowId_"^"_$g(DocCode)_"^"_val
}

// w ##class(web.DHCPE.DocPatientList).GetIPAndName()

ClassMethod GetIPAndName() As %String
{
	Set IPAddress=$ZUTIL(67,15,$JOB)
	Set CompName=$ZUTIL(67,12,$JOB)
	Quit IPAddress_"  "_CompName
}

ClassMethod GetLocRowIdByCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Code",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
}

ClassMethod GetLocRowIdByDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set val=$$ALPHAUP^SSUTIL4(val)
 Set LocRowId=$O(^CTLOC(0,"Desc",val,""))
 If LocRowId'="" Set LocDesc=$P($g(^CTLOC(LocRowId)),"^",2)
 Quit LocRowId_"^"_val_"^"_$g(LocDesc)
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

ClassMethod GetChart(x As %String) As %String
{
 &sql(select chartsettings into :a from epr.chart where ID=:x)
 Quit a
}

// w ##class(web.DHCPE.DocPatientList).EpisodeIdLoc(17283,818,105)

ClassMethod EpisodeIdLoc(UserID As %String, EpisodeID As %String, LocID As %String = "", Group As %String = "") As %String
{
	Set EpIsLoc=0   //0-没有 1-有
	s:$d(%session) Group=%session.Get("LOGON.GROUPID")
	i '$d(%session){
		i Group="" s Group=164
	}
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	If Group="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	/*
	s chartID=""
	f  s chartID=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID,Group,"Write",chartID)) q:(chartID="")||(EpIsLoc=1)  d
	.s StationDr=chartID
	.s:StationDr="NULL" EpIsLoc=1
	.q:EpIsLoc=1
	..Set OEOrder=0
	..For  Set OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  Quit:(OEOrder=""||EpIsLoc=1)  Do
	...s OEOrdItem=0
	...For  Set OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  Quit:OEOrdItem=""  Do
	....Set OEORIRowId=OEOrder_"||"_OEOrdItem
	....Set CEID=..CheckEpisodeID(EpisodeID,OEORIRowId,StationDr)
	....If CEID=1 Set EpIsLoc=1
	*/
	//多院区
	s chartID=""
	f  s chartID=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_LocID," "_UserID," "_Group,chartID)) q:(chartID="")||(EpIsLoc=1)  d
	.s DtlSub=""
	.f  s DtlSub=$o(^CF.PE.ChartAssignD(chartID,"DTL",DtlSub))  q:DtlSub=""  d
	..s WriteWay=$lg(^CF.PE.ChartAssignD(chartID,"DTL",DtlSub),4) //可写
	..q:WriteWay'="Y"
	..s StationDr=$lg(^CF.PE.ChartAssignD(chartID,"DTL",DtlSub),2) //站点
	..S OEOrder=0
	..f  s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,OEOrder))  Quit:(OEOrder=""||EpIsLoc=1)  Do
	...s OEOrdItem=0
	...f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  Quit:OEOrdItem=""  Do
	....s OEORIRowId=OEOrder_"||"_OEOrdItem
	....s CEID=..CheckEpisodeID(EpisodeID,OEORIRowId,StationDr)
	....i CEID=1 s EpIsLoc=1
	Quit EpIsLoc
}

ClassMethod CheckEpisodeID(EpisodeID As %String, OEORIRowId As %String, StationDr As %String) As %Status
{
	Quit:$g(EpisodeID)="" 1
	Quit:$g(OEORIRowId)="" 1
	s Ord=$p(OEORIRowId,"||",1)
	s OrdItem=$p(OEORIRowId,"||",2)
	s LocID=$p($g(^PAADM(EpisodeID)),"^",4)
	s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:PEIAdmId="" 1
	s ItemStat=$P($g(^OEORD(Ord,"I",OrdItem,1)),"^",13)
	q:((ItemStat'=1)&(ItemStat'=6)) 0
	s ArcimID=$P($g(^OEORD(Ord,"I",OrdItem,1)),"^",2)
	Set STORDChd=0, flag=0
	/*
	For  Set STORDChd=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,StationDr,STORDChd))  Quit:(STORDChd=""||flag=1)  Do
	.If STORDChd'="" Set flag=1
	*/
	//多院区
	S StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
	If StatOrderID'="" Set flag=1

	q flag
}

/// w ##class(web.DHCPE.DocPatientList).GetGeneralDoctorName(3665727)
/// rewrite by MLH 20080313
ClassMethod GetGeneralDoctorName(PAADM)
{
	q "demo"
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	If HospitalCode="YY"
	{
		s DoctorName=""
		i PAADM="" q DoctorName
		s PEADM=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
		i PEADM="" q DoctorName
		s PreADM=$p(^DHCPEIADM(PEADM),"^",4)
		i PreADM="" q DoctorName
		s ARCIMDRs="2832||1"
		//s ARCIMDR=""	
		s k=1
		s j=$l(ARCIMDRs,"^")
		for k=1:1:j
		{
			s ARCIMDR=$p(ARCIMDRs,"^",k)
			s IItemSub=0
			s i=0
			f  s IItemSub=$O(^DHCPEPreIADM(0,"ItmMast",ARCIMDR,PreADM,IItemSub)) q:IItemSub=""  d
			.s Status=$p(^DHCPEPreIADM(PreADM,"ORDITEM",IItemSub),"^",16)
			.q:Status'="1"
			.s IItemID=PreADM_"||"_IItemSub
			
			.s CRMID=$o(^DHCPECRMO(0,"CRMORI",IItemID,0))
			.q:CRMID=""
			.s OEORIDR=$p(^DHCPECRMO(CRMID),"^",1)
			.q:OEORIDR=""
			.
			.s RLID=$o(^DHCPERLT(0,"ADMOD",PAADM,OEORIDR,0))
			.q:RLID=""
			.s RLID=$o(^DHCPERLT(0,"ADMOD",PAADM,OEORIDR,RLID,0))
			.q:RLID=""
			.s DocID=$p($G(^DHCPERLT(RLID)),"^",5)
			.q:DocID=""
			.i DoctorName="" d
			..s DoctorName=$p(^SSU("SSUSR",DocID),"^",1)
			.e  d
			..s DoctorName=DoctorName_","_$p(^SSU("SSUSR",DocID),"^",1)
		}
	}
	else 
	{
		Set IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
		Quit:$g(IADM)=""
		Set DoctorName=""
		Set GSRowId=$o(^DHCPEGS(0,"IADM",IADM,""))
		If GSRowId'="" Do
		.Set AuditUserDR=$P($g(^DHCPEGS(GSRowId,1)),"^",5)
		.Quit:$g(AuditUserDR)=""
		.Set DoctorName=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	}
	Quit $g(DoctorName)
}

ClassMethod ADMLocIsAudit(IADMDR As %String) As %String
{
	Set LocIsAudit=0   //0-没有 1-有 2-没有操作此人的权限
	Set Count=0
	Set STNoSubmitStr=$g(^DHCPESetting("DHCPE","StationId_NoSubmit"))
	Set Group=%session.Get("LOGON.GROUPID")
	Set GroupDesc=%session.Get("LOGON.GROUPDESC")
	If GroupDesc="体检总检医生" q LocIsAudit
	If GroupDesc="体检复检医生" q LocIsAudit
	s PIADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",4)
	i Group="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s curUser=%session.Get("LOGON.USERID")
	s curLoc=%session.Get("LOGON.CTLOCID")
	s EpisodeID=$p($g(^DHCPEIADM(IADMDR)),"^",1)
	/*	
	s ChartId=0
	f  s ChartId=$O(^DHCPECFDataEx("ChartAssign",curUser,curLoc,Group,"Detail",ChartId)) q:ChartId=""  d
	.q:$G(^DHCPECFDataEx("ChartAssign",curUser,curLoc,Group,"Detail",ChartId))=0
	.q:##class(web.DHCPE.Public.Setting).ShowChartPage(EpisodeID,ChartId)="0" 
	.s RefuseFlag=..GetLocRefuseFlag(EpisodeID,ChartId)
	.q:RefuseFlag="0" 
	.s Count=Count+1
	.s StationDr=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartId))
	.q:StationDr=""
	.s STNoSubmit=0
	.s SSRowId=$o(^DHCPESS(0,"IADM",IADMDR,StationDr,0))
	.q:SSRowId=""
	.s SSStatus=$p($g(^DHCPESS(SSRowId,1)),"^",7)
	.If ((SSStatus="SA")||(SSStatus="GA")) s LocIsAudit=LocIsAudit+1
	*/
	//多院区
	s ChartId=0
	f  s ChartId=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_curUser," "_UserID," "_Group,ChartId)) q:(ChartId="")||(EpIsLoc=1)  d
	.s DtlSub=""
	.f  s DtlSub=$o(^CF.PE.ChartAssignD(ChartId,"DTL",DtlSub))  q:DtlSub=""  d
	..s DetailWay=$lg(^CF.PE.ChartAssignD(ChartId,"DTL",DtlSub),3) //可读
	..q:DetailWay'="Y"
	..s StationDr=$lg(^CF.PE.ChartAssignD(ChartId,"DTL",DtlSub),2) //站点
	..q:##class(web.DHCPE.Public.Setting).ShowChartPage(EpisodeID,ChartId)="0"
	..s RefuseFlag=..GetLocRefuseFlag(EpisodeID,ChartId)
	..q:RefuseFlag="0" 
	..s Count=Count+1
	..s StationDr=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartId))
	..q:StationDr=""
	..s STNoSubmit=0
	..s SSRowId=$o(^DHCPESS(0,"IADM",IADMDR,StationDr,0))
	..q:SSRowId=""
	..s SSStatus=$p($g(^DHCPESS(SSRowId,1)),"^",7)
	..If ((SSStatus="SA")||(SSStatus="GA")) s LocIsAudit=LocIsAudit+1
	
	q:Count=0 2 //没有操作权限
	i (Count>LocIsAudit) s LocIsAudit=0
	i (Count=LocIsAudit)&&(LocIsAudit>0) s LocIsAudit=1
	i (Count=LocIsAudit)&&(LocIsAudit=0) s LocIsAudit=1
	q LocIsAudit
}

/// s val=##class(web.DHCPE.DocPatientList).GetArgValue(String)
ClassMethod GetArgValue(String)
{
	Set UserID=%session.Get("LOGON.USERID")
	s Date=+$H
	s flag=..getIsClearFlag()
	i flag'="" d
	.s Value=%request.Get(String)
	.//s ^zl("String",String)=Value
	e  d
	.s Value=$G(^DHCPETempQuery("DHCPEDocPatientList",Date,UserID,String))
	.i (String="StartDate")&&(Value'="") s Value=##class(websys.Conversions).DateLogicalToHtml(Value)
	.i (String="EndDate")&&(Value'="") s Value=##class(websys.Conversions).DateLogicalToHtml(Value)
	.i (String="IncludeCompleted")&&(Value'="") s Value=1
	.i (String="IsCanSumResult")&&(Value'="") s Value=1
	.i (String="LocAudited")&&(Value'="") s Value=1
	.i (String="GroupName") d
	..s Value=$G(^DHCPETempQuery("DHCPEDocPatientList",Date,UserID,"GroupID"))
	..s Value=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(Value)
	.i (String="TeamName")
	..s Value=$G(^DHCPETempQuery("DHCPEDocPatientList",Date,UserID,"TeamID"))
	..s Value=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(Value)
	
	q Value
}

ClassMethod getIsClearFlag()
{
	s value=""
	s value=value_%request.Get("PatientNo")
	s value=value_%request.Get("SurName")
	s value=value_%request.Get("StartDate")
	s value=value_%request.Get("EndDate")
	s value=value_%request.Get("IncludeCompleted")
	s value=value_%request.Get("IsCanSumResult")
	s value=value_%request.Get("GroupID")
	s value=value_%request.Get("TeamID")
	s value=value_%request.Get("LocAudited") //分科室已提交
	q value
}

/// d ##class(web.DHCPE.DocPatientList).DeleteTempQuery()
ClassMethod DeleteTempQuery()
{
	s Date=+$H
	f  s Date=$o(^DHCPETempQuery("DHCPEDocPatientList",Date),-1) q:Date=""  d
	.k ^DHCPETempQuery("DHCPEDocPatientList",Date)
}

ClassMethod IsChecking(EpisodeID, Type As %String = "Y")
{
	i Type="Y"
	{
		s ^TempDHCPEDocPatientChecking(EpisodeID)=%session.Get("LOGON.USERID")
		q 0
	}
	i $D(^TempDHCPEDocPatientChecking(EpisodeID))
	{
		s UserID=$G(^TempDHCPEDocPatientChecking(EpisodeID))
		q:UserID=%session.Get("LOGON.USERID") 0
		q $P($G(^SSU("SSUSR",UserID)),"^",1)
	}
	else
	{
		s ^TempDHCPEDocPatientChecking(EpisodeID)=%session.Get("LOGON.USERID")
		q 0
	}
}

ClassMethod KillChecking(EpisodeID As %String = "")
{
	//s EpisodeID=%request.Get("EpisodeID")
	q:EpisodeID="" ""
	k ^TempDHCPEDocPatientChecking(EpisodeID)
	q EpisodeID
}

ClassMethod GetAdmInfoByReg(RegNo As %String = "")
{
  
    s PAADM=""
	s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	s PAADM=$O(^PAPERdr(PAPMIRowId,"ADM","H",""),-1 ) 
	q PAADM
}

ClassMethod GetLocRefuseFlag(PAADM, ChartID)
{
 s Flag=0
 i ChartID'=""  d
 .s PEStation=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))
 s OEORDRowId=""
 s OEORDID=$O(^OEORD(0,"Adm",PAADM,0))
 s LocID=$p($g(^PAADM(PAADM)),"^",4)
 q:OEORDID=""
 s ChildSub=0
 f  s ChildSub=$o(^OEORD(OEORDID,"I",ChildSub)) q:ChildSub=""  d
 .s ItmMastDR=$P($g(^OEORD(OEORDID,"I",ChildSub,1)),"^",2)
 .q:ItmMastDR=""
 .s STRowId="0"
 .;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STRowId))
 .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItmMastDR,LocID)
 .s STRowId=+StatOrderID
 .q:(STRowId=PEStation)&&($d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDID_"||"_ChildSub)))
 .s Flag=1
 
 q Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DocPatientList", "DiagnosisNew","64176","64266","")
Query DiagnosisNew(BDate As %String = "", EDate As %String = "", OnlyNoTrans As %String = "", VIPLevel As %String = "", GroupID As %String = "", ReCheck As %String = "", GroupName As %String = "") As %Query(ROWSPEC = "TSort:%String,TName:%String,TReg:%String,PAADM:%String,N:%String,HPNo:%String,TGroup:%String")
{
}

ClassMethod DiagnosisNewExecute(ByRef qHandle As %Binary, BDate As %String = "", EDate As %String = "", OnlyNoTrans As %String = "", VIPLevel As %String = "", GroupID As %String = "", ReCheck As %String = "", GroupName As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i BDate'="" s BDate=##class(websys.Conversions).DateHtmlToLogical(BDate) 
	i EDate'=""  s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate) 
	
 	/*
 	收表的global
 	
 	s ^DHCPEDataEx("ConfirmRecPaper",PIADM)=..IAdmRecived(Time) 
	s ^DHCPEDataEx("ConfirmRecPaper","Date",+$h,PIADM)=""
	s ^DHCPEDataEx("ConfirmRecPaper","DateTime",+$h,Time,PIADM)=""
	s ^DHCPEDataEx("ConfirmRecPaper","ReportDate",PIADM)=ReportDate
	q:ReportDate="" 0
	s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIADM)=ReportDate_"^"_Time
	s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",ReportDate,Time,PIADM)=""
	*/
	i ReCheck="on" d
	.s ReCheck="Y"
	e  d
	.s ReCheck=""
	k ^DHCPETMP("DiagnosisOrder")
 	s Date=BDate-1
 	f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EDate)  d
 	.s time=0
 	.f  s time=$o(^DHCPEIADM(0,"AdmDateTime",Date,time)) q:(time="")  d
 	..s IADM=0
 	..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,time,IADM)) q:(IADM="")  d
 	...s PIADM=$p(^DHCPEIADM(IADM),"^",4)
 	...s Status=$p(^DHCPEIADM(IADM),"^",8)
 	...q:Status'="ARRIVED"
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)
 	...q:LocFlag="1"
 	...s PBID=$p(^DHCPEPreIADM(PIADM),"^",1)
 	...s PGADM=$p(^DHCPEPreIADM(PIADM),"^",2)
 	...s G=$p(^DHCPEIADM(IADM),"^",2)
 	...q:(GroupID="ALLI")&&(G'="")
	...q:(GroupID="ALLG")&&(G="")
	...q:((GroupID'="")&&(GroupID'="ALLI")&&(GroupID'="ALLG")&&(GroupID'=G))
 	...;q:(GroupID'="")&&(GroupID'=G)
 	...s CurGroupName=""
 	...i PGADM'="" d
 	....s GBI=$P(^DHCPEPreGADM(PGADM),"^",1)
 	....s CurGroupName=$P(^DHCPEPreGBI(GBI),"^",2)
 	...;q:(GroupName'="")&&(CurGroupName'[GroupName)
 	...s CurReCheck=$p(^DHCPEPreIADM(PIADM),"^",28)
 	...q:(ReCheck="Y")&&(ReCheck'=CurReCheck)
 	...s CurVip=+##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
 	...q:(VIPLevel'="")&&(VIPLevel'=CurVip)
 	...s HPNo=$p(^DHCPEPreIADM(PIADM),"^",27)
 	...s Reg=$p(^DHCPEPreIBI(PBID),"^",1)
 	...s Name=$p(^DHCPEPreIBI(PBID),"^",2)
 	...s PAADM=##class(web.DHCPE.DHCPEIAdm).GetPAADMByPADM(PIADM) 
 
 	...;q:(##class(web.DHCPE.ResultDiagnosisNew).GetStatus(PAADM)'=0)
 	...s GenStatus=##class(web.DHCPE.ResultDiagnosisNew).GetStatus(PAADM)
 	...s sta=##class(web.DHCPE.TransResult).GetStatus(PAADM)
 	...s O=$g(^DHCPEDataEx("TransResult",PAADM,"S"))
 	...s ind=ind+1
 	...s:(G="") TGroup=""
 	...s:(G'="") TGroup="Y"
 	...s:GenStatus="1" O=4
 	...s:GenStatus="2" O=5
 	...s ^DHCPETMP("DiagnosisOrder",O,HPNo,ind)=Name_"^"_Reg_"^"_PAADM_"^"_O_"^"_HPNo_"^"_TGroup
 	
 	s o=0,ind=1
 	f  s o=$o(^DHCPETMP("DiagnosisOrder",o)) q:(o="")  d
 	.s HPNo=""
 	.f  s HPNo=$o(^DHCPETMP("DiagnosisOrder",o,HPNo)) q:(HPNo="")  d
 	..s ind2=0
 	..f  s ind2=$o(^DHCPETMP("DiagnosisOrder",o,HPNo,ind2)) q:(ind2="")  d
 	...s dd=$g(^DHCPETMP("DiagnosisOrder",o,HPNo,ind2))
 	...s Data=$lb(ind,$p(dd,"^",1),$p(dd,"^",2),$p(dd,"^",3),$p(dd,"^",4),$p(dd,"^",5),$p(dd,"^",6))
 	...d Autotrans11
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Autotrans11      
	//set Data=$lb(Name,Reg,PAADM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

 	q
}

ClassMethod DiagnosisNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosisNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DiagnosisNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosisNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
