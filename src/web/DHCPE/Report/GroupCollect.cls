Class web.DHCPE.Report.GroupCollect Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter Split1 = "#";

Parameter Split2 = "^";

/// 团体预约记录
Query GADMList(GBIDesc As %String = "", ContractID As %String = "") As %Query(ROWSPEC = "TGRowId:%String, TGDesc:%String,TAdmDate:%String")
{
}

ClassMethod GADMListExecute(ByRef qHandle As %Binary, GBIDesc As %String = "", ContractID As %String = "") As %Status
{
	
	s STatusList="ARRIVED"
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s GADMRowId="ALLI"
 	s Desc="全部个人"
 	s GAdmDate=""
 	d GADMListBuild
 	
 	s GADMRowId="ALLG"
 	s Desc="全部团体"
 	s GAdmDate=""
 	d GADMListBuild
 	
 	s Gid=""	
	f  s Gid=$o(^DHCPEGADM(Gid),-1) q:(Gid=0)||(Gid="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",Gid)
    .q:LocFlag=1
	.s GADMRowId=Gid
	.s CurData=$g(^DHCPEGADM(Gid))			
	.s GBIDR=$p(CurData,"^",1)
	.q:GBIDR=""
	.s Desc=$p($g(^DHCPEGBI(GBIDR)),"^",2)		
	.q:((""'=GBIDesc)&(Desc'[GBIDesc))	
	.s GAdmDate=$p(CurData,"^",4)
	.i (""'=GAdmDate) s GAdmDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
	.s CRMGADM=$p(CurData,"^",2)
	.s ContractRowId=$p(^DHCPEPreGADM(CRMGADM),"^",25)
	.q:(ContractID'="")&&(ContractID'=ContractRowId)
    .d GADMListBuild
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GADMListBuild
	set Data=$lb(GADMRowId, Desc, GAdmDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GADMListExecute ]
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

ClassMethod GADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GADMListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCPE.Report.GroupCollect).GetIllness()
ClassMethod GetIllness(GADMList, StartDate, EndDate, GTeam, Department, VIP, SexFlag, AgeStart, AgeEnd, Type, ReportType)
{
	k ^DHCPETMPGroupCollect
	
	if (GADMList="")
	{
		i StartDate="" s StartDate=+$h
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s CurDate=StartDate-1
		
		f  s CurDate=$o(^DHCPEIADM(0,"AdmDateTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
		.s CurTime=0
		.f  s CurTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime)) q:CurTime=""  d
		..s IADM=0
		..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime,IADM)) q:IADM=""  d
		...
		...d GetIllInfo
		
	}
	elseif($p(GADMList,"^",1)="ALLI")
	{
		i StartDate="" s StartDate=+$h
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s CurDate=StartDate-1
		f  s CurDate=$o(^DHCPEIADM(0,"AdmDateTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
		.s CurTime=0
		.f  s CurTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime)) q:CurTime=""  d
		..s IADM=0
		..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime,IADM)) q:IADM=""  d
		...s GDR=$p(^DHCPEIADM(IADM),"^",2)
		...q:GDR'=""
		...d GetIllInfo
		
	}
	elseif($p(GADMList,"^",1)="ALLG")
	{
		i StartDate="" s StartDate=0
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s GroupID=0
		f  s GroupID=$o(^DHCPEGADM(GroupID)) q:GroupID=""  d
		.s CurTeamID=""
		.f  s CurTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID)) q:CurTeamID=""  d
		..s TeamDesc=$p(^DHCPEGADM(+CurTeamID,"Team",$p(CurTeamID,"||",2)),"^",1)
		..q:(GTeam'="")&&((GTeam'["%"))&&(TeamDesc'=GTeam)
		..q:(GTeam'="")&&((GTeam["%"))&&(TeamDesc'[$p(GTeam,"%",2))
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID,IADM)) q:IADM=""  d
		...d GetIllInfo
		
		}
	else 
	{
		i StartDate="" s StartDate=0
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		f iLoop=1:1:$l(GADMList,"^") d
		.s GroupID=$p(GADMList,"^",iLoop)
		.q:GroupID=""
		.s GTeamDR=0
		.f  s GTeamDR=$o(^DHCPEIADM(0,"GADM",GroupID,GTeamDR)) q:GTeamDR=""  d
		..s TeamDesc=$p(^DHCPEGADM(+GTeamDR,"Team",$p(GTeamDR,"||",2)),"^",1)
		..q:(GTeam'="")&&((GTeam'["%"))&&(TeamDesc'=GTeam)
		..q:(GTeam'="")&&((GTeam["%"))&&(TeamDesc'[$p(GTeam,"%",2))
		..s IADM=0
		..f  s IADM=$o(^DHCPEIADM(0,"GADM",GroupID,GTeamDR,IADM)) q:IADM=""  d
		...d GetIllInfo
	}
	
	s IllID=0,EDSum=0
	f  s IllID=$o(^DHCPETMPGroupCollect("Illness",IllID)) q:IllID=""  d
	.s EDDesc="",EDNum=0
	.f  s EDDesc=$o(^DHCPETMPGroupCollect("IllnessED",IllID,EDDesc)) q:EDDesc=""  d
	..s EDNum=EDNum+1
	..s ^DHCPETMPGroupCollect("Diagnosis",IllID,EDNum)=EDDesc
	.i EDSum<EDNum s EDSum=EDNum
	
	q EDSum
	
	
GetIllInfo
	s IADMStatus=$p(^DHCPEIADM(IADM),"^",8)
	q:IADMStatus'="ARRIVED"
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
    q:LocFlag=1
	s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	q:CRMADM=""
 	
 	s IType=$p(^DHCPEPreIADM(CRMADM),"^",25)
 	q:(Type'="")&&(Type'["%")&&(Type'=IType)
 	q:(Type'="")&&(Type["%")&&(IType'[Type)
 	
 	s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	q:PreIBase=""
 	s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
 	q:(SexFlag'="")&&(SexFlag'=SexDr)
	
	
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s AgeSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
	s Age=$P(AgeSexStr,"^",1)
	q:(AgeStart'="")&&(Age<AgeStart)
	q:(AgeEnd'="")&&(Age>AgeEnd)
	
	s Postion=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
	s Postion=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CRMADM)
	
	q:(Department'="")&&(Department'["%")&&(Postion'=Department)
	q:(Department'="")&&(Department["%")&&(Postion'[$p(Department,"^",2))
	s IADMVIP=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IADM)
	s TVIPlevel=$P(IADMVIP,"^",1)
	q:(VIP'="")&&(VIP'=TVIPlevel)
	s ArrDate=$p(^DHCPEIADM(IADM),"^",5)
	q:ArrDate<StartDate
	q:ArrDate>EndDate
	s GSRowId=$O(^DHCPEGS(0,"IADM",IADM,0))
	q:GSRowId=""
	s AuditUser=$p($g(^DHCPEGS(GSRowId,1)),"^",5)
	q:AuditUser=""
	s GSDChildSub=0
	f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d 
	.s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	.s Status=$p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",11)
	.q:Status'=0
	.s DiagnosisDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRowId_"||"_GSDChildSub))
	.s EDDesc=..GetDiagnosisDesc(DiagnosisDesc)
	.
	.s IDRRowID=0,EDStr=""
	.f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",Diagnosis,IDRRowID)) q:IDRRowID=""  d
	..
	..s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	..s ILLnessType=$p($g(^DHCPEILLS(ILLnessID)),"^",11)
	..q:ILLnessType'=ReportType
	..;q:ILLnessID=37
	..s ^DHCPETMPGroupCollect("Illness",ILLnessID)=1
	..q:EDDesc=""
	..f j=1:1:$l(EDDesc,"^") d
	...s EDStr=$p(EDDesc,"^",j)
	...q:1=..IsMaxLength(EDStr)
	...
	...s ^DHCPETMPGroupCollect("IllnessED",ILLnessID,EDStr)=1
	...s ^DHCPETMPGroupCollect("Diagnosis",EDStr)=1
	.q:$d(^DHCPEIDR(0,"EDDR",Diagnosis))
	.
	.s ^DHCPETMPGroupCollect("Illness","Other")=1
	.q:ReportType'="1"
	.q:EDDesc=""
	.f j=1:1:$l(EDDesc,"^") d
	..s EDStr=$p(EDDesc,"^",j)
	..q:1=..IsMaxLength(EDStr)
	..q:$d(^DHCPETMPGroupCollect("Diagnosis",EDStr))
	..s ^DHCPETMPGroupCollect("IllnessED","Other",EDStr)=1
}

ClassMethod IsMaxLength(EDStr)
{
	s $ZT="MaxLengthErr"
	s ret=0
	q:$d(^DHCPETMPGroupCollect("Diagnosis",EDStr)) ret
	q ret
MaxLengthErr
	q 1
}

/// w ##class(web.DHCPE.Report.GroupCollect).GetDiagnosisDesc("Ⅰ度房室传导阻滞")
ClassMethod GetDiagnosisDesc(Desc)
{
	q:Desc="" ""
	q:$L(Desc,"]")=1 Desc
	s Str=""
	f i=1:1:$l(Desc,"]") d
	.s BeforeStr=$p(Desc,"]",i)
	.q:BeforeStr=""
	.s AfterStr=$p(BeforeStr,"[",2)
	.q:AfterStr=""
	.i Str="" s Str=AfterStr
	.e  s Str=Str_"^"_AfterStr
	
	q Str
}

ClassMethod OutMain(GADMList, StartDate, EndDate, GTeam, Department, VIP, Sex, AgeStart, AgeEnd, Type, ReportType)
{
	
	s ^tempdhcpe("Repot")=GADMList_"^"_StartDate_"^"_EndDate_"^"_GTeam_"^"_Department_"^"_VIP_"^"_Sex_"^"_AgeStart_"^"_AgeEnd_"^"_Type_"^"_ReportType
	s EDSum=..GetIllness(GADMList, StartDate, EndDate, GTeam, Department, VIP, Sex, AgeStart, AgeEnd, Type,ReportType)
	w "<b>团体疾病与诊断"
	w "<TABLE border=0 cellspacing='0' cellpadding='0' style='width:100%;height:100%;white-space:normal; word-break:break-all;'>"
	f inum=0:1:EDSum d
		. 
		.w "<TR>"
		.s IllID=0
		.f  s IllID=$o(^DHCPETMPGroupCollect("Illness",IllID)) q:IllID=""  d
		..i IllID'="Other" d
		...s IllDesc=$p(^DHCPEILLS(IllID),"^",2)
		...i inum=0 d
		....w "<TD style='white-space:normal; word-break:break-all;'>"
		....w "<div style='width:100%;height:100%'>"
		....w "<input id="_IllID_" name='ILL'  type='checkbox' onchange=SetSelectED(this)>"_IllDesc
		..i IllID="Other" d
		...i inum=0 d
		....w "<TD style='white-space:normal; word-break:break-all;'>"
		....w "<div style='width:100%;height:100%'>"
		....w "<input id="_IllID_" name='ILL'  type='checkbox' onchange=SetSelectED(this)>"_"其他疾病"
		..q:inum=0
		..s DiagDesc=$g(^DHCPETMPGroupCollect("Diagnosis",IllID,inum))
		..w "<TD style='white-space:normal; word-break:break-all;'>"
		..w "<div style='width:100%;height:100%'>"
		..i DiagDesc'="" w "<input id="_DiagDesc_" name='"_IllID_"'  type='checkbox'>"_DiagDesc
		..w "</TD>"
		.w "</TR>"
	w "</TABLE>"
}

ClassMethod GetAgeRangeNum(Age)
{
	s Age=+$G(Age)
    q:(Age<=20) 1
	q:(Age>=21)&(Age<31) 2
	q:(Age>=31)&(Age<41) 3
	q:(Age>=41)&(Age<51) 4
	q:(Age>=51)&(Age<61) 5
	q:(Age>=61)&(Age<71) 6
	q:(Age>=71)&(Age<81) 7
	q:(Age>80) 8
	q
}

ClassMethod GetSexNum(Sex)
{
	s Num=1
	s:Sex="F" Num=2
	q Num
}

/// w ##class(web.DHCPE.Report.GroupCollect).GetGroupInfo()
ClassMethod GetGroupInfo(GADMList As %String = "", GTeam As %String = "", Department As %String = "", StartDate As %String = "", EndDate As %String = "", VIPLevel As %String = "", Sort As %String = "1", IllString As %String = "", SexFlag As %String = "", AgeStart As %String = "", AgeEnd As %String = "", Type As %String = "")
{
	s UserID=%session.Get("LOGON.USERID")
	;k ^TempDHCPEGroupReport
	if Sort="" s Sort=1
	if Sort=1 d
	.k ^TempDHCPEGroupReport(UserID)
	s ^TempDHCPEGroupReport(UserID)=IllString
	if (GADMList="")
	{
		i StartDate="" s StartDate=+$h
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)="全部客户"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)="全部客户"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","PreDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(StartDate)_"--"_##class(websys.Conversions).DateLogicalToHtml(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverPrintDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(+$H)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDescHello",Sort)="全部客户"
		s CurDate=StartDate-1
		f  s CurDate=$o(^DHCPEIADM(0,"AdmDateTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
		.s CurTime=0
		.f  s CurTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime)) q:CurTime=""  d
		..s IADM=0
		..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime,IADM)) q:IADM=""  d
		...d GetOneIAdmInfo
		
	}
	elseif($p(GADMList,"^",1)="ALLI")
	{
		i StartDate="" s StartDate=+$h
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)="全部个人"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)="全部个人"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","PreDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(StartDate)_"--"_##class(websys.Conversions).DateLogicalToHtml(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverPrintDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(+$H)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDescHello",Sort)="全部个人"
		s CurDate=StartDate-1
		f  s CurDate=$o(^DHCPEIADM(0,"AdmDateTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
		.s CurTime=0
		.f  s CurTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime)) q:CurTime=""  d
		..s IADM=0
		..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,CurTime,IADM)) q:IADM=""  d
		...s GDR=$p(^DHCPEIADM(IADM),"^",2)
		...q:GDR'=""
		...d GetOneIAdmInfo
		
	}
	elseif($p(GADMList,"^",1)="ALLG")
	{
		i StartDate="" s StartDate=0
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)="全部团体"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)="全部团体"
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","PreDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(StartDate)_"--"_##class(websys.Conversions).DateLogicalToHtml(EndDate)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverPrintDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(+$H)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDescHello",Sort)="全部团体"
		s GroupID=0
		f  s GroupID=$o(^DHCPEGADM(GroupID)) q:GroupID=""  d
		.s GroupBaseID=$P($g(^DHCPEGADM(GroupID)),"^",1)
		.q:GroupBaseID=""
		.s CrmGADM=$P($g(^DHCPEGADM(GroupID)),"^",2)
		.s GStartDate=$P($g(^DHCPEPreGADM(CrmGADM)),"^",2)
		.s GStartDate=##class(websys.Conversions).DateLogicalToHtml(GStartDate)
		.s GEndDate=$P($g(^DHCPEPreGADM(CrmGADM)),"^",3)
		.s GEndDate=##class(websys.Conversions).DateLogicalToHtml(GEndDate)
		.s GroupDesc=$P($g(^DHCPEGBI(GroupBaseID)),"^",2)
		.s CurTeamID=""
		.f  s CurTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID)) q:CurTeamID=""  d
		..s TeamDesc=$p(^DHCPEGADM(+CurTeamID,"Team",$p(CurTeamID,"||",2)),"^",1)
		..q:(GTeam'="")&&((GTeam'["%"))&&(TeamDesc'=GTeam)
		..q:(GTeam'="")&&((GTeam["%"))&&(TeamDesc'[$p(GTeam,"%",2))
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID,IADM)) q:IADM=""  d
		...d GetOneIAdmInfo
		
	}
	else
	{
		i StartDate="" s StartDate=0
		e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate="" s EndDate=+$h
		e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
		f iLoop=1:1:$l(GADMList,"^")
		{	
		s GroupID=$p(GADMList,"^",iLoop)
		q:GroupID=""
		s CheckDate=..GetGroupStartEndDate(GroupID)
		
		s PreGADM=$P(^DHCPEGADM(GroupID),"^",2)
		s GroupBaseID=$P(^DHCPEGADM(GroupID),"^",1)
		s CrmGADM=$P(^DHCPEGADM(GroupID),"^",2)
		s GStartDate=$p(CheckDate,"^",1) //$P(^DHCPEPreGADM(CrmGADM),"^",2)
		s GStartDate=##class(websys.Conversions).DateLogicalToHtml(GStartDate)
		s GEndDate=$p(CheckDate,"^",2) //$P(^DHCPEPreGADM(CrmGADM),"^",3)
		s GEndDate=##class(websys.Conversions).DateLogicalToHtml(GEndDate)
		s GroupDesc=$P(^DHCPEGBI(GroupBaseID),"^",2)
		s GroupDesc=..GetGName(GroupID)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=GroupDesc
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=GroupDesc
		s:Department'="" ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)_"["_Department_"]"
		
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","PreDate",Sort)=GStartDate_"--"_GEndDate
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","StartDate",Sort)=GStartDate
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","EndDate",Sort)=GEndDate
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverPrintDate",Sort)=##class(websys.Conversions).DateLogicalToHtml(+$H)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDescHello",Sort)=GroupDesc_"领导"
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","YingJianLv",Sort)=..GetTotalPersonByGroup(PreGADM)
		s CurTeamID=""
		f  s CurTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID)) q:CurTeamID=""  d
		.s TeamDesc=$p(^DHCPEGADM(+CurTeamID,"Team",$p(CurTeamID,"||",2)),"^",1)
		.q:(GTeam'="")&&((GTeam'["%"))&&(TeamDesc'=GTeam)
		.q:(GTeam'="")&&((GTeam["%"))&&(TeamDesc'[$p(GTeam,"%",2))
		.s IADM=0
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID,IADM)) q:IADM=""  d
		..d GetOneIAdmInfo
		/***
		q:Sort'=1
		s StartDate=$zd(StartDate,4)
		s EndDate=$zd(EndDate,4)
		f  s GroupID=$O(^DHCPEGADM(0,"GBI",GroupBaseID,GroupID),-1) q:(+GroupID=0)||(Sort>2)  d
		.s Sort=Sort+1
		.d ..GetGroupInfo(GroupID,GTeam,Department,StartDate,EndDate,VIPLevel,Sort,IllString,SexFlag,AgeStart,AgeEnd,Type)
		***/
		}
	}
	q "OK"
GetOneIAdmInfo
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED"
	
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
    q:LocFlag=1
	s IADMVIP=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IADM)
	s TVIPlevel=$P(IADMVIP,"^",1)
	q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
	s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	q:CRMADM=""
 	s IType=$p(^DHCPEPreIADM(CRMADM),"^",25)
 	q:(Type'="")&&(Type'["%")&&(Type'=IType)
 	q:(Type'="")&&(Type["%")&&(IType'[Type)
 	s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	q:PreIBase=""
 	s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
 	q:(SexFlag'="")&&(SexFlag'=SexDr)
 	s Sex=$p(^CT("SEX",SexDr),"^",2)
 	s Dob=$p(^DHCPEPreIBI(PreIBase),"^",4)
 	s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	s Age=##class(web.DHCPE.DHCPECommon).GetCurAge(Dob)
	s ArrDate=$p(^DHCPEIADM(IADM),"^",5)
	q:ArrDate<StartDate
	q:ArrDate>EndDate
	s CheckDate=##class(websys.Conversions).DateLogicalToHtml(ArrDate)
	
	;s Postion=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
	s Postion=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CRMADM)
	
	q:((Department'="")&&(Department'[("%")))&&(Postion'=Department)
	q:((Department'="")&&(Department[("%")))&&(Postion'[$p(Department,"%",1))
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s AgeSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
	s Age=$P(AgeSexStr,"^",1)
	q:(AgeStart'="")&&(Age<AgeStart)
	q:(AgeEnd'="")&&(Age>AgeEnd)
	s Sex=$P(AgeSexStr,"^",2)
	s AgeNum=..GetAgeRangeNum(Age)
	s SexNum=..GetSexNum(Sex)
	s Sub=""
	s Sub=$o(^DHCPEPreIADM(0,"ItmMast","23444||1",CRMADM,0))
	i Sub'="" s ^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount",Sort,AgeNum,3)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount",Sort,AgeNum,3))+1,^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount3",Sort)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount3",Sort))+1 
	s ^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount"_SexNum,Sort)=+$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount"_SexNum,Sort))+1
	s ^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort)=+$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))+1
	s ^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,SexNum)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,SexNum))+1
	s ^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3))+1
	
	s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
	
	q:GSID=""
	s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
	q:AuditUser=""
	s GSDChildSub=0,ResultDesc=""
	f  s GSDChildSub=$O(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d
	.s GSDStatus=$P($G(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)),"^",11)
	.q:GSDStatus'="0"
	.s DiagnosisDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSID_"||"_GSDChildSub))
	.s EDDesc=..GetDiagnosisDesc(DiagnosisDesc)
	.q:EDDesc=""
	.s ResultDesc=$p(DiagnosisDesc,"]",2)
	.s EDID=$P($G(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)),"^",1)
	.s Advice=$P($G(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)),"^",9)
	.s IllNessFlag=0
	.s IDRRowID=0
	.f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRRowID)) q:IDRRowID=""  d
	..s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	..s IllNessFlag=1
	..s IncludeFlag=..IsInclude(IllString,ILLnessID,EDDesc)
	..q:IncludeFlag=0
	..i '$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM)) d
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM)=ResultDesc_"^"_Advice
	..f j=1:1:$l(EDDesc,"^") d
	...s EDStr=$p(EDDesc,"^",j)
	...i '$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",EDStr,Sort,IADM)) d
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,SexNum))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,3))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,SexNum))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,3))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",EDStr,Sort,IADM)=ResultDesc_"^"_Advice
	.i IllNessFlag=0 d
	..s ILLnessID="Other"
	..s IncludeFlag=..IsInclude(IllString,ILLnessID,EDDesc)
	..q:IncludeFlag=0
	..i '$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM)) d
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM)=ResultDesc_"^"_Advice
	..f j=1:1:$l(EDDesc,"^") d
	...s EDStr=$p(EDDesc,"^",j)
	...i '$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",EDStr,Sort,IADM)) d
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,SexNum))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDStr,Sort,3))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,SexNum))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDStr,Sort,AgeNum,3))+1
	....s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",EDStr,Sort,IADM)=ResultDesc_"^"_Advice
	
	q
}

// 

ClassMethod IsInclude(IllString, IllID, EDDesc)
{
	s InCludeFlag=0
	s Length=$L(IllString,"^")
	f i=1:1:Length
	{
		s OneIllInfo=$P(IllString,"^",i)
		s OneLength=$L(OneIllInfo,"$")
		s CurIllID=$P(OneIllInfo,"$",1)
		continue:CurIllID'=IllID
		s CurEDDesc="$"_$P(OneIllInfo,"$",2,OneLength)_"$"
		continue:CurEDDesc'[("$"_EDDesc_"$")
		s InCludeFlag=1
		q
	}
	q InCludeFlag
}

ClassMethod GetSexDesc(Num)
{
	q:Num=1 "男性"
	q:Num=2 "女性"
	q:Num=3 "合计"
	q ""
}

ClassMethod GetAgeRangeDesc(Num)
{
	q:Num=1 "<=20"
	q:Num=2 "21-30"
	q:Num=3 "31-40"
	q:Num=4 "41-50"
	q:Num=5 "51-60"
	q:Num=6 "61-70"
	q:Num=7 "71-80"
	q:Num=8 ">80"
	q ""
}

ClassMethod GetPercent(Dividend, Divisor)
{
	i +Divisor=0 q ""
	i +Dividend=0 q ""
	s Result=(100*Dividend)/Divisor
	q $j(Result,"",2)_"%"
}

ClassMethod GetCheckDate()
{
	
	
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s ret=""
	s StartDate=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","StartDate",Sort))
	
	s EndDate=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","EndDate",Sort))
	
	
	q $p(StartDate,"-",1)_"年"_$p(StartDate,"-",2)_"月-"_$p(EndDate,"-",2)_"月"
}

// 得到年龄段人数

/// w ##class(web.DHCPE.Report.GroupCollect).GetSexAgeCount()
ClassMethod GetSexAgeCount()
{
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s ret=""
	s Total=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum)) q:AgeNum=""  d
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s MCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	.s MPercent=..GetPercent(MCount,MTotal)
	.s FCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	.s FPercent=..GetPercent(FCount,FTotal)
	.s Count=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3))
	.i +MCount=0 s Total=Total-MTotal
	.i +FCount=0 s Total=Total-FTotal
	.s Percent=..GetPercent(Count,Total)
	.s OneInfo=AgeDesc_..#Split1_MCount_..#Split1_MPercent_..#Split1_FCount_..#Split1_FPercent_..#Split1_Count_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

ClassMethod GetTotalPersonByGroup(id)
{
  
	new j,l,k,Str
	s j=0
	s l=0
	s k=0
	s n=0
	s Str="",CancelPEStr=""
	s Sub=0
	f  s Sub=$o(^DHCPEPreGADM(id,"Team",Sub)) q:Sub=""  d
	.s Person=##class(web.DHCPE.PreGTeam).GetTotalPersonByItem(id_"||"_Sub)
	.s j=j+(+Person)
	.s l=l+($p(Person,"^",2))
	.s k=k+($p(Person,"^",3))
	.s n=n+($p(Person,"^",4))
	i k'=0 s Str=",取消"_k_"人"
	i n'=0  s CancelPEStr=",取消体检"_n_"人"
	q $j((l/j)*100,3,2)_"%"
}

ClassMethod GetGroupStartEndDate(GroupID)
{
	s CurTeamID="",MinDate="",MaxDate="",ArriveFlag=0
	f  s CurTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID)) q:CurTeamID=""  d
	.s IADM=0
	.f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID,IADM)) q:IADM=""  d
	..s ArriveDate=$p(^DHCPEIADM(IADM),"^",5)
	..s Status=$P(^DHCPEIADM(IADM),"^",8)
	..i Status'="ARRIVED" s ArriveFlag=1
	..q:Status'="ARRIVED"
	..i MinDate="" s MinDate=ArriveDate
	..i MaxDate="" s MaxDate=ArriveDate
	..i MinDate>ArriveDate s MinDate=ArriveDate
	..i MaxDate<ArriveDate s MaxDate=ArriveDate
	i ArriveFlag=1 s MaxDate=+$h
	q MinDate_"^"_MaxDate
}

ClassMethod GetBaseInfo()
{
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1 
	s ret=""
	s LabDesc=""
	f  s LabDesc=$O(^TempDHCPEGroupReport(UserID,"BaseInfo",LabDesc)) q:LabDesc=""  d
	.s value=$G(^TempDHCPEGroupReport(UserID,"BaseInfo",LabDesc,Sort))
	.s OneInfo=LabDesc_..#Split1_value
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到疾病排行

/// w ##class(web.DHCPE.Report.GroupCollect).GetILLInfo()
ClassMethod GetILLInfo()
{
	
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s TotalCount=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s ILLID=""
	f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID)) q:ILLID=""  d
	.q:'$D(^DHCPEILLS(ILLID))
	.s OneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,3))
	.s ILLDesc=..GetILLDesc(ILLID)
	.s ^TempDHCPEGroupReport(UserID,"ILLSort",+OneTotal,ILLID)=ILLDesc
	s ret=""
	s Total="" 
	f  s Total=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total),-1) q:Total=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID)) q:ILLID=""  d
	..s ILLDesc=$G(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID))
	..s Count=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,3))
	..s MCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,1))
	..s FCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,2))
	..s TotalCount=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	..s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	..s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	..i +MCount=0 s TotalCount=TotalCount-MTotal
	..i +FCount=0 s TotalCount=TotalCount-FTotal
	..s Percent=..GetPercent(Count,TotalCount)
	..s OneInfo=ILLDesc_..#Split1_Count_..#Split1_MCount_..#Split1_FCount_..#Split1_Percent
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_..#Split2_OneInfo
	q ret
}

ClassMethod GetILLDesc(ILLID)
{
	i $d(^DHCPEILLS(ILLID)) d
	.s ILLDesc=$P(^DHCPEILLS(ILLID),"^",2)
	e  d
	.s ILLDesc=ILLID
	q ILLDesc
}

// 得到以往三年的疾病信息

/// w ##class(web.DHCPE.Report.GroupCollect).GetILLHistoryInfo()
ClassMethod GetILLHistoryInfo()
{
	s UserID=%session.Get("LOGON.USERID")
	
	s TotalCount2=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",2))
	s TotalCount3=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",3))
	s ret=""
	s Total="" 
	f  s Total=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total),-1) q:Total=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID)) q:ILLID=""  d
	..q:'$D(^DHCPEILLS(ILLID))
	..s ILLDesc=$G(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID))
	..s Count1=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,1,3))
	..s MCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,1,1))
	..s FCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,1,2))
	..s Count2=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,2,3))
	..s Count3=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,3,3))
	..s TotalCount=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",1))
	..s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",1))
	..s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",1))
	..i +MCount=0 s TotalCount=TotalCount-MTotal
	..i +FCount=0 s TotalCount=TotalCount-FTotal
	..s Percent1=..GetPercent(Count1,TotalCount)
	..s Percent2=..GetPercent(Count2,TotalCount2)
	..s Percent3=..GetPercent(Count1,TotalCount3)
	..s OneInfo=ILLDesc_..#Split1_Count1_..#Split1_Percent1_..#Split1_Count2_..#Split1_Percent2_..#Split1_Count3_..#Split1_Percent3
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到每个年龄段最多人数的疾病

/// w ##class(web.DHCPE.Report.GroupCollect).GetILLAgeSexMax()
ClassMethod GetILLAgeSexMax()
{
	s Sort=1
	s UserID=%session.Get("LOGON.USERID")
	s ILLID=""
	f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID)) q:ILLID=""  d
	.q:'$D(^DHCPEILLS(ILLID))
	.s AgeNum=""
	.f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum)) q:AgeNum=""  d
	..s SexNum=""
	..f  s SexNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,SexNum)) q:SexNum=""  d
	...s ILLCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,SexNum))
	...s ^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,SexNum,ILLCount,ILLID)=""
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum)) q:AgeNum=""  d
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s SexDesc=..GetSexDesc(1)
	.s ILLCount=""
	.s ILLCount=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,1,ILLCount),-1)
	.i ILLCount="" d
	..s ILLDesc=""
	..s Percent=""
	.e  d
	..s ILLID=""
	..s ILLID=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,1,ILLCount,""))
	..s ILLDesc=..GetILLDesc(ILLID)
	..s AgeCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	..s Percent=..GetPercent(ILLCount, AgeCount)
	.s OneInfo=AgeDesc_..#Split1_ILLDesc_..#Split1_ILLCount_..#Split1_Percent
	.s SexDesc=..GetSexDesc(2)
	.s ILLCount=""
	.s ILLCount=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,2,ILLCount),-1)
	.i ILLCount="" d
	..s ILLDesc=""
	..s Percent=""
	.e  d
	..s ILLID=""
	..s ILLID=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,2,ILLCount,""))
	..s ILLDesc=..GetILLDesc(ILLID)
	..s AgeCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	..s Percent=..GetPercent(ILLCount, AgeCount)
	.s OneInfo=OneInfo_..#Split1_ILLDesc_..#Split1_ILLCount_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

Query IllDescList(IllStr As %String = "") As %Query(ROWSPEC = "TIll:%String,TIllDesc:%String")
{
}

ClassMethod IllDescListExecute(ByRef qHandle As %Binary, IllStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s UserID=%session.Get("LOGON.USERID")
	
	s IllStr=$G(^TempDHCPEGroupReport(UserID))
 	if IllStr=""
	{Set qHandle=$lb(0,repid,0)
	Quit $$$OK}
 	
 	f i=1:1:$l(IllStr,"^") d
 	.s illid=$p(IllStr,"^",i)
 	.q:illid=""
 	.f j=1:1:$l(illid,"$") d
 	..s Oneillid=$p(illid,"$",j)
 	..i $d(^DHCPEILLS(Oneillid)) s IllDesc=$p(^DHCPEILLS(Oneillid),"^",2)
 	..e  s IllDesc=Oneillid
    ..d IllListBuild
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IllListBuild
	s:Oneillid="Other" IllDesc="其它疾病"
	i (Oneillid=IllDesc) s IllDesc="----"_IllDesc
	set Data=$lb(Oneillid,IllDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod IllDescListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IllDescListExecute ]
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

ClassMethod IllDescListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IllDescListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query ADMList(IllString As %String = "") As %Query(ROWSPEC = "PatNo:%String,Name:%String,Sex:%String,Result:%String,Age:%String,CheckDate:%String,TDepart:%String")
{
}

ClassMethod ADMListExecute(ByRef qHandle As %Binary, IllString As %String = "") As %Status
{
	
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if IllString=""
	{Set qHandle=$lb(0,repid,0)
	Quit $$$OK}
 	s UserID=%session.Get("LOGON.USERID")
 	s IADM=0
 	f  s IADM=$o(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",IllString,1,IADM)) q:IADM=""  d
 	.s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	.q:CRMADM=""
 	.s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	.q:PreIBase=""
 	.s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	.s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	.s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
 	.s Sex=$p(^CT("SEX",SexDr),"^",2)
 	.s Dob=$p(^DHCPEPreIBI(PreIBase),"^",4)
 	.s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	.;s Age=##class(web.DHCPE.DHCPECommon).GetCurAge(Dob)
	.S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PatNo,0))
	.i PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	.s CheckDate=$p(^DHCPEIADM(IADM),"^",5)
	.s CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
	.s TDepart=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
	.s TDepart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CRMADM)
 	.s Result=$g(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",IllString,1,IADM))
    .d AdmListBuild
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AdmListBuild
	set Data=$lb(PatNo,Name,Sex,Result,Age,CheckDate,TDepart)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ADMListExecute ]
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

ClassMethod ADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ADMListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutReport(IllList, ReportType, ShowDetailFlag As %String = "0")
{
	s UserID=%session.Get("LOGON.USERID")
	
	s IllList=$G(^TempDHCPEGroupReport(UserID))
	q:IllList=""
	w "<TABLE border=1 cellspacing='0' cellpadding='0' style='width:80%;white-space:normal; word-break:break-all;'>"
	w "<TR>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "年龄段"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "男性患病人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "男性总人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "男性患病率"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "女性患病人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "女性总人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "女性患病率"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "总患病人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "总人数"
	w "</TD>"
	w "<TD style='white-space:normal; word-break:break-all;'>"
	w "<div style='width:100%;height:100%'>"
	w "患病率"
	w "</TD>"
	w "</TR>"
	f i=1:1:$l(IllList,"^")
	{
 	s OneILLID=$p(IllList,"^",i)
 	continue:OneILLID=""
 	s OneIllLength=$L(OneILLID,"$")
 	f j=1:1:OneIllLength
 	{
 	s ILLID=$p(OneILLID,"$",j)
 	continue:(ShowDetailFlag=0)&&(j>1)
 	continue:'$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLID))
 	i $d(^DHCPEILLS(ILLID)) s IllDesc=$p(^DHCPEILLS(ILLID),"^",2)
 	e  s IllDesc=ILLID
 	s:IllDesc="Other" IllDesc="其它疾病"
 	s:IllDesc=ILLID IllDesc="----"_IllDesc
	w "<TR><TD colspan=10><b>"_IllDesc_"</TD></TR>"
	s Sort=1
	
	s IADM=0
	f  s IADM=$o(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLID,Sort,IADM)) q:IADM=""  d
	.s ^TempDHCPEGroupReport(UserID,"IADMInfo",IADM)=1
	s MOne=0
	s FOne=0
	s TOne=0
	s OneNum=0
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum)) q:AgeNum=""  d
	.s MTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	.s FTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	.s AgeTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3))
	.i ReportType=2 s FTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount",Sort,AgeNum,3)),AgeTotal=FTotal
	.s OneNum=OneNum+1
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s MOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,1))
	.s MOne=MOne+MOneTotal
	.s MPercent=..GetPercent(MOneTotal, MTotal)
	.s FOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,2))
	.s FOne=FOne+FOneTotal
	.s FPercent=..GetPercent(FOneTotal, FTotal)
	.s OneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,3))
	.s TOne=TOne+OneTotal
	.;i +MOneTotal=0 s AgeTotal=AgeTotal-MTotal
	.;i +FOneTotal=0 s AgeTotal=AgeTotal-FTotal
	.s AgeTotal=MTotal+FTotal
	.s Percent=..GetPercent(OneTotal, AgeTotal)
	.w "<TR>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w AgeDesc
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MOneTotal
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MTotal
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MPercent
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FOneTotal
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FTotal
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FPercent
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w OneTotal
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w AgeTotal
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w Percent
	.w "</TD>"
	.w "</TR>"
 	
	s Total=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	i OneNum>1 d
	.s AgeDesc="总计"
	.s MPercent=..GetPercent(MOne, MTotal)
	.s FPercent=..GetPercent(FOne, FTotal)
	.i +MOne=0 s Total=Total-MTotal
	.i +FOne=0 s Total=Total-FTotal
	.s Percent=..GetPercent(TOne, Total)
	.w "<TR>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w AgeDesc
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MOne
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MTotal
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w MPercent
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FOne
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FTotal
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w FPercent
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w TOne
	.w "</TD>"
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w Total
	.w "</TD>"
	
	.w "<TD style='white-space:normal; word-break:break-all;'>"
	.w "<div style='width:100%;height:100%'>"
	.w Percent
	.w "</TD>"
	.w "</TR>"
 	}
	}
	w "</TABLE>"
	s IADM=0,IADMNum=0,FIADMNum=0,MIADMNum=0
	f  s IADM=$o(^TempDHCPEGroupReport(UserID,"IADMInfo",IADM)) q:IADM=""  d
	.s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	.q:CRMADM=""
 	.s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	.q:PreIBase=""
 	.s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	.s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	.s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
	.s IADMNum=IADMNum+1
	.s:SexDr=1 FIADMNum=FIADMNum+1
	.s:SexDr=2 MIADMNum=MIADMNum+1
	
	
	i ReportType=2 w "总人数："_FTotal_"，"_"妇科人数："_$g(^TempDHCPEGroupReport(UserID,"ListInfo","FKAgeSexPersonCount3",Sort))_"，"_"患病人数："_IADMNum
}

/// w ##class(web.DHCPE.Report.GroupCollect).GetHighRisk()
ClassMethod GetHighRisk(GroupID)
{
}

ClassMethod GetDetailString(IllStr)
{
	q:IllStr=""
	s ret=""
	s UserID=%session.Get("LOGON.USERID")
	f i=1:1:$l(IllStr,"^") d
 	.s illid=$p(IllStr,"^",i)
 	.q:illid=""
 	.i $d(^DHCPEILLS(illid)) s IllDesc=$p(^DHCPEILLS(illid),"^",2)
 	.e  s IllDesc=illid
 	.
 	.s IADM=0
 	.f  s IADM=$o(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",illid,1,IADM)) q:IADM=""  d
 	..s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	..q:CRMADM=""
 	..s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	..q:PreIBase=""
 	..s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	..s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	..s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
 	..s Sex=$p(^CT("SEX",SexDr),"^",2)
 	..s Dob=$p(^DHCPEPreIBI(PreIBase),"^",4)
 	..s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	..s Age=##class(web.DHCPE.DHCPECommon).GetCurAge(Dob)
	..s CheckDate=$p(^DHCPEIADM(IADM),"^",5)
	..s CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
 	..s Result=$g(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",illid,1,IADM))
 	..s Advice=$P(Result,"^",2)
 	..s Result=$P(Result,"^",1)
 	..i Result["[" s Result=""
 	..s TDepart=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
 	..s TDepart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CRMADM)
 	..;s IllDesc2=IllDesc_":"_Advice
 	..i ret="" s ret=IllDesc_"^"_PatNo_"^"_Name_"^"_Sex_"^"_Age_"^"_TDepart_"^"_CheckDate_"^"_Result_"^"_Advice
 	..e  s ret=ret_"#"_IllDesc_"^"_PatNo_"^"_Name_"^"_Sex_"^"_Age_"^"_TDepart_"^"_CheckDate_"^"_Result_"^"_Advice
 	
 	q ret
}

/// 得到某一疾病所有adm的串
ClassMethod GetIllAdmStr(IllID)
{
	;s $ZT="GetIllAdmStrErr"
	s IllAdmStr=""
	s UserID=%session.Get("LOGON.USERID")
	;s IllStr=$G(^TempDHCPEGroupReport(UserID))
	s IADM=0
 	f  s IADM=$o(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",IllID,1,IADM)) q:IADM=""  d
 	.i IllAdmStr="" d
 	..s IllAdmStr=IADM
 	.e  d
 	..s IllAdmStr=IllAdmStr_"^"_IADM
 	q IllAdmStr
GetIllAdmStrErr
 	q ""
}

/// 得到某人某个疾病的信息
ClassMethod GetOneAdmDetail(illid, IADM)
{
	s ret=""
	s UserID=%session.Get("LOGON.USERID")
	i $d(^DHCPEILLS(illid)) s IllDesc=$p(^DHCPEILLS(illid),"^",2)
 	e  s IllDesc=illid
 	s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
 	q:CRMADM="" ret
 	s PreIBase=$p(^DHCPEPreIADM(CRMADM),"^",1)
 	q:PreIBase="" ret
 	s PatNo=$p(^DHCPEPreIBI(PreIBase),"^",1)
 	s Name=$p(^DHCPEPreIBI(PreIBase),"^",2)
 	s SexDr=$p(^DHCPEPreIBI(PreIBase),"^",3)
 	s Sex=$p(^CT("SEX",SexDr),"^",2)
 	s Dob=$p(^DHCPEPreIBI(PreIBase),"^",4)
 	s Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
	s Age=##class(web.DHCPE.DHCPECommon).GetCurAge(Dob)
	s CheckDate=$p(^DHCPEIADM(IADM),"^",5)
	s CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
 	s Result=$g(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",illid,1,IADM))
 	s Advice=$P(Result,"^",2)
 	s Result=$P(Result,"^",1)
 	i Result["[" s Result=""
 	s TDepart=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
 	s TDepart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CRMADM)
 	;s IllDesc2=IllDesc_":"_Advice
 	s ret=IllDesc_"^"_PatNo_"^"_Name_"^"_Sex_"^"_Age_"^"_TDepart_"^"_CheckDate_"^"_Result_"^"_Advice
 	
 	;i ret="" s ret=IllDesc_"^"_PatNo_"^"_Name_"^"_Sex_"^"_Age_"^"_TDepart_"^"_CheckDate_"^"_Result_"^"_Advice
 	;e  s ret=ret_"#"_IllDesc_"^"_PatNo_"^"_Name_"^"_Sex_"^"_Age_"^"_TDepart_"^"_CheckDate_"^"_Result_"^"_Advice
 	q ret
}

ClassMethod GetGName(GADM)
{
	i GADM="" s GroupDesc="全部客户"
	i $p(GADM,"^",1)="ALLI" s GroupDesc="全部个人"
	i $p(GADM,"^",1)="ALLG" s GroupDesc="全部团体"
	f i=1:1:$l(GADM,"^") d
	.s GroupID=$p(GADM,"^",i)
	.q:GroupID=""
	.q:GroupID="ALLI"
	.q:GroupID="ALLG"
	.s GroupBaseID=$P(^DHCPEGADM(GroupID),"^",1)
	.s GroupDesc=$P(^DHCPEGBI(GroupBaseID),"^",2)
	.s CRMGADM=$P(^DHCPEGADM(GroupID),"^",2)
	.s ContractRowId=$p(^DHCPEPreGADM(CRMGADM),"^",25)
	.i +ContractRowId'="0" d
	..s Contract=$LG(^User.DHCPEContractD(ContractRowId),3)
	..s GroupDesc=Contract
	q GroupDesc
}

Query DHCPEGItemList(GIDList As %String = "") As %Query(ROWSPEC = "GT_Desc:%String, GT_RowId:%String")
{
}

ClassMethod DHCPEGItemListExecute(ByRef qHandle As %Binary, GIDList As %String = "") As %Status
{
	
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if GIDList=""
	{Set qHandle=$lb(0,repid,0)
	Quit $$$OK}
 	f iLoop=1:1:$l(GIDList,"^")
	{	
		s GroupID=$p(GIDList,"^",iLoop)
		q:GroupID=""
		s TeamSub=0
		f  s TeamSub=$O(^DHCPEGADM(GroupID,"Team",TeamSub)) q:TeamSub=""  d
		.s GTDesc=$p(^DHCPEGADM(GroupID,"Team",TeamSub),"^",1)
		.s GTRowId=GroupID_"||"_TeamSub
    	.d DHCPEGItemList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCPEGItemList
	set Data=$lb(GTDesc,GTRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DHCPEGItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPEGItemListExecute ]
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

ClassMethod DHCPEGItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPEGItemListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.GroupCollect","SearchGDepart","921^","")
Query SearchGDepart(GIDList As %String = "", Depart) As %Query(ROWSPEC = "DepartName:%String")
{
}

ClassMethod SearchGDepartExecute(ByRef qHandle As %Binary, GIDList As %String = "", vDepart) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^wrz("GDepart")=GIDList
	i (GIDList="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s ind=1
 	s Job=$J
 	f iLoop=1:1:$l(GIDList,"^")
 	{
	 	s GroupID=$p(GIDList,"^",iLoop)
		q:GroupID=""
 		s teamID=""
 		f  s teamID=$O(^DHCPEIADM(0,"GADM",GroupID,teamID)) q:teamID=""  d
 		.s id=""
 		.f  s id=$O(^DHCPEIADM(0,"GADM",GroupID,teamID,id)) q:id=""  d
 		..s crmID=$P(^DHCPEIADM(id),"^",4)
 		..s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",crmID))
 		..q:Depart=""
 		..q:(vDepart'="")&&(Depart'[vDepart)
		..s ^TempDHCPE(Job,Depart)=""
 	}
	s Depart=""
	f  s Depart=$O(^TempDHCPE(Job,Depart)) q:Depart=""  d
	.d SearchGDepartBuild
	k ^TempDHCPE(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchGDepartBuild
	set Data=$lb(Depart)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGDepartExecute ]
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

ClassMethod SearchGDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.GroupCollect", "SearchGType","1377^","")

Query SearchGType(GIDList As %String = "", Type) As %Query(ROWSPEC = "TypeName:%String")
{
}

ClassMethod SearchGTypeExecute(ByRef qHandle As %Binary, GIDList As %String = "", Type) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^wrz("GType")=GIDList
	i (GIDList="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s ind=1
 	s Job=$J
 	f iLoop=1:1:$l(GIDList,"^")
 	{
	 	s GroupID=$p(GIDList,"^",iLoop)
		q:GroupID=""
 		s teamID=""
 		f  s teamID=$O(^DHCPEIADM(0,"GADM",GroupID,teamID)) q:teamID=""  d
 		.s id=""
 		.f  s id=$O(^DHCPEIADM(0,"GADM",GroupID,teamID,id)) q:id=""  d
 		..s crmID=$P(^DHCPEIADM(id),"^",4)
 		..s IType=$p(^DHCPEPreIADM(crmID),"^",25)
 		..q:IType=""
 		..q:(Type'="")&&(Type'[IType)
		..s ^TempDHCPE(Job,IType)=""
 	}
	s Type=""
	f  s Type=$O(^TempDHCPE(Job,Type)) q:Type=""  d
	.d SearchGTypeBuild
	k ^TempDHCPE(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchGTypeBuild
	set Data=$lb(Type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGTypeExecute ]
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

ClassMethod SearchGTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 按照顺序得到所有的疾病

ClassMethod GetAllILL(CTLocID As %String = "")
{
	;w ##class(web.DHCPE.GroupReportNew).GetAllILL()
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	s Job=$J
	k ^TempDHCPE(Job,"TempILL")
	i DiagnosisType="N" d
	.;s ILLDesc=$P(^DHCPEED(ILLID,1),"^",1)
	e  d
	.s ILLID=0
	.f  s ILLID=$O(^DHCPEILLS(ILLID)) q:ILLID=""  d
	..s ILLType=$P(^DHCPEILLS(ILLID),"^",11)
	..q:ILLType'="1"
	..s Sort=$P(^DHCPEILLS(ILLID),"^",1)
	..s ^TempDHCPE(Job,"TempILL",Sort,ILLID)=""
	s ret=""
	s Sort=0
	f  s Sort=$O(^TempDHCPE(Job,"TempILL",Sort)) q:Sort=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPE(Job,"TempILL",Sort,ILLID)) q:ILLID=""  d
	..i ret="" d
	...s ret=ILLID
	..e  d
	...s ret=ret_"^"_ILLID
	k ^TempDHCPE(Job,"TempILL")
	q ret
}

// 获取每种疾病的信息

ClassMethod GetOneILLInfo(ILLID, CTLocID As %String = "")
{
	;^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)
	q:ILLID="" ""
	s Sort=1
	s UserID=%session.Get("LOGON.USERID")
	s Total=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	s ILLSex="N"

	s ILLSex="N"
	i DiagnosisType="N" d
	.s ILLSex=$P(^DHCPEED(ILLID,1),"^",1)
	e  d
	.s ILLSex=$P(^DHCPEILLS(ILLID),"^",9)
	s:ILLSex="" ILLSex="N"
	;i (ILLSex="F")||(ILLSex="M") s TotalFlag="Y"
	
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum)) q:AgeNum=""  d
	.s MTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	.s FTotal=$g(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s MOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,1))
	.s MPercent=..GetPercent(MOneTotal, MTotal)
	.s FOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,2))
	.s FPercent=..GetPercent(FOneTotal, FTotal)
	.s OneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,3))
	
	.s Percent=..GetPercent(OneTotal, Total)
	.i +MOneTotal=0 s Percent=FPercent
	.i +FOneTotal=0 s Percent=MPercent
	.i ILLSex="F" d
	..s OneInfo=AgeDesc_..#Split1_FOneTotal_..#Split1_FPercent
	.e  i ILLSex="M" d
	..s OneInfo=AgeDesc_..#Split1_MOneTotal_..#Split1_MPercent
	.e  d
	..s OneInfo=AgeDesc_..#Split1_MOneTotal_..#Split1_MPercent_..#Split1_FOneTotal_..#Split1_FPercent_..#Split1_OneTotal_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ILLSex_..#Split2_ret
}

}
