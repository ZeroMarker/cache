Class web.DHCPE.GGSDiagnosis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

Query GetGDiagnosis(GID As %String = "") As %Query(ROWSPEC = "TRowID:%String, TILLSDR:%String, User:%String, TDiagnosis:%String, Date:%String, TDiagnoseConclusion:%String,TAdvice:%String,TSort:%String,TReportPrint:%String,TGenType:%String")
{
}

ClassMethod GetGDiagnosisExecute(ByRef qHandle As %Binary, GID) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
 	s id="0"
 	i GID=""
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	quit $$$OK
 	}
 	s SSID=..GetGGSD(GID)
 	s Sub=0
 	s Sort=0
 	i SSID'=""  Do
 	.f  s Sort=$o(^DHCPEGGS(0,"GSSDSort",SSID,Sort)) q:Sort=""  d
 	..s Sub=0
 	..f  s Sub=$o(^DHCPEGGS(0,"GSSDSort",SSID,Sort,Sub)) q:Sub=""  d
 	...s SSRId=SSID_"||"_Sub
 	...s RLID=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",1)
 	...q:RLID=""
 	...s RIDDesc=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",8)
 	...//$p($g(^DHCPEED(RLID,"Detail")),"^",1)
 	...s ItemDesc=$p($g(^DHCPEILLS(RLID)),"^",2)
 	...s User=$p($g(^DHCPEGGS(SSID,"Diagnosis",Sub)),"^",4)
 	...i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
 	...s (Date)=""
 	...s Remark=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",2)
 	...s ReportFlag=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",3)
 	...s GenType=$p(^DHCPEGGS(SSID,"Diagnosis",Sub),"^",7)
 	...d Build	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	//			PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
	set Data=$lb(SSRId, RLID, User, ItemDesc, Date, Remark,RIDDesc,Sort,ReportFlag,GenType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetGDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGDiagnosisExecute ]
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

ClassMethod GetGDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGGSD(GID)
{
	new GGSD
	s GGSD=$o(^DHCPEGGS(0,"GADM",GID,0))
	q GGSD
}

/// ##class(web.DHCPE.IllnessStandard).UpdateGGSD(GID)
ClassMethod UpdateGGSD(GID)
{
	new GGSD,PLIST,User,Date,Time
	i GID="" q ""
	s GGSD=..GetGGSD(GID)
	i GGSD="" d
	.s User=%request.Get("LOGON.USERID")
	.s Date=+$H
	.s Time=$P($H,",",2)
	.s PLIST(2)=GID
	.s PLIST(4)=Date
	.s PLIST(5)=User
	.s PLIST(6)=Time
	.&SQL(insert into sqluser.DHC_PE_GGeneralSummarize values :PLIST())
	.s GGSD=%ROWID
	q GGSD
}

ClassMethod UpdateSSDiagnosis(SSID, SDID, isDel)
{
	s Status=$p($g(^DHCPEGGS(SSID)),"^",6)
	q:Status'="" "HadAudit"
	i isDel=1
	{
		s i=$L(SDID,"^")
		s j=1
		TSTART
		for j=1:1:i d
		.s ID=$p(SDID,"^",j)
		.&SQL(delete from sqluser.DHC_PE_GGSDiagnosis where GGSD_RowId=:ID)
		.break:SQLCODE'=0
		i SQLCODE TROLLBACK
		i SQLCODE=0 TCOMMIT
		q SQLCODE
	}
	&SQL(select GGSD_ILLS_DR from sqluser.DHC_PE_GGSDiagnosis where GGSD_ParRef=:SSID and GGSD_ILLS_DR=:SDID)
	
	q:SQLCODE=0 "HadDiagnosis"
	s Sort=$o(^DHCPEGGS(0,"GSSDSort",SSID,""),-1)
	i Sort="" s Sort=0
	s Sort=Sort+1
	s Advice=$P($G(^DHCPEILLS(SDID)),"^",3)
	s Date=+$H
	s Time=$P($H,",",2)
	s User=%session.Get("LOGON.USERID")
	//,SSD_ReportPrint,"N"
	&SQL(insert into sqluser.DHC_PE_GGSDiagnosis (GGSD_ParRef,GGSD_ILLS_DR,GGSD_UpdateUser_DR,GGSD_UpdateDate,GGSD_UpdateTime,GGSD_ReportPrint,GGSD_GenType,GGSD_Advice,GGSD_Sort) values (:SSID,:SDID,:User,:Date,:Time,'Y','D',:Advice,:Sort))
	q SQLCODE
}

ClassMethod UpdateStationDRemark(Strings)
{
	s SSID=+Strings
	s Status=$p($g(^DHCPEGGS(SSID)),"^",6)
	q:Status'="" "HadAudit"
	s j=$l(Strings,"^")
	s SQLCODE=0
	TSTART
	f i=1:1:j
	{
		s String=$p(Strings,"^",i)
		s ID=$p(String,"&&",1)
		s Remark=$p(String,"&&",2)
		s Advice=$p(String,"&&",3)
		s Sort=$p(String,"&&",4)
		&SQL(update sqluser.DHC_PE_GGSDiagnosis set GGSD_DiagnoseConclusion=:Remark,GGSD_Advice=:Advice,GGSD_Sort=:Sort where GGSD_RowId=:ID)
		q:SQLCODE
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod AuditGGS(GADM, Type)
{
	i (GADM="") q ""
	s GGSD=..GetGGSD(GADM)
	s User=""
	i Type="Submit" s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$p($H,",",2)
	TSTART
	i GGSD'=""
	{
		s Sort=$o(^DHCPEGGS(0,"GSSDSort",GGSD,""))
		//i Sort="" q "NoData"
		s PLIST(7)=User
		s PLIST(8)=Date
		s PLIST(9)=Time
		&SQL(update sqluser.DHC_PE_GGeneralSummarize values :PLIST() where GGS_GADM_DR=:GADM)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	k PLIST
	s Status="NA"
	i Type="Submit" s Status="A"
	s PLIST(3)=Status
	s PLIST(5)=User
	s PLIST(6)=Date
	&SQL(update sqluser.DHC_PE_Report values :PLIST() where RPT_GADM_DR=:GADM)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod GetIllness(GADMDR)
{
	s SSID=..GetGGSD(GADMDR)
	s Status=$p($g(^DHCPEGGS(SSID)),"^",6)
	q:Status'="" "HadAudit"
	k ^DHCPETemp("GDiagnosis","Temp")
	s SQLCODE=0
	s Date=+$H
	s Time=$P($H,",",2)
	s User=%session.Get("LOGON.USERID")
	s GenType="S"
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	TSTART
	&SQL(delete from sqluser.DHC_PE_GGSDiagnosis where GGSD_ParRef=:SSID and GGSD_GenType='S')
	s:SQLCODE=100 SQLCODE=0
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:(PreIADM="")||(SQLCODE'=0)  d
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize 总检结论
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..//DHC_PE_GSDiagnosis
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",7)
	..q:AuditUser=""
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)||(SQLCODE'=0)  d // 
	...// 当前客户患有疾病
	...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...s IDRRowID=0
	...f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",Diagnosis,IDRRowID)) q:IDRRowID=""  d
	....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	....s Flag=$o(^DHCPEGGS(0,"ILLSDR",ILLnessID,SSID,0))
	....q:Flag'=""
	....///判断某人是否已经在此种疾病列表里面
	....s Flag=$G(^DHCPETemp("GDiagnosis","Temp",GADMDR,ILLnessID))
	....q:Flag=1
	....s ^DHCPETemp("GDiagnosis","Temp",GADMDR,ILLnessID)="1"
	....s Sort=$o(^DHCPEGGS(0,"GSSDSort",SSID,""),-1)
	....i Sort="" s Sort=0
	....s Sort=Sort+1
	....s Advice=$P($G(^DHCPEILLS(ILLnessID)),"^",3)
	....&SQL(insert into sqluser.DHC_PE_GGSDiagnosis (GGSD_ParRef,GGSD_ILLS_DR,GGSD_UpdateUser_DR,GGSD_UpdateDate,GGSD_UpdateTime,GGSD_ReportPrint,GGSD_Advice,GGSD_Sort,GGSD_GenType) values (:SSID,:ILLnessID,:User,:Date,:Time,'Y',:Advice,:Sort,:GenType))
	i SQLCODE'=0
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

}
