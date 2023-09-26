Class web.DHCPE.Query.ExportData Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.ExportData","querypersoninfo",892)
Query querypersoninfo(GAdmId As %String) As %Query(ROWSPEC = "HPNo:%String,PAPMINo:%String,Name:%String,NamePY:%String,Sex:%String,DobDate:%String,Marry:%String,Tel:%String,EMail:%String,ZhiWu:%String,GName:%String,IDCard:%String")
{
}

ClassMethod querypersoninfoExecute(ByRef qHandle As %Binary, GAdmId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	s GTeamId=0
	f  s GTeamId=$o(^DHCPEIADM(0,"GADM",GAdmId,GTeamId)) q:GTeamId=""   d
	.s IADMId=0
	.s PreGADM=$p(^DHCPEGADM(GAdmId),"^",2)
	.q:PreGADM=""
	.s PreGBaseId=$p(^DHCPEPreGADM(PreGADM),"^",1)
	.q:PreGBaseId=""
	.s GName=$p(^DHCPEPreGBI(PreGBaseId),"^",2)
	.f  s IADMId=$o(^DHCPEIADM(0,"GADM",GAdmId,GTeamId,IADMId)) q:IADMId=""  d
	..s PreIADMId=$p(^DHCPEIADM(IADMId),"^",4)
	..q:PreIADMId=""
	..s PreIBaseId=$p(^DHCPEPreIADM(PreIADMId),"^",1)
	..q:PreIBaseId=""
	..s Status=$p(^DHCPEIADM(IADMId),"^",8)
	..q:Status'="ARRIVED"
	..s HPNo=$p(^DHCPEPreIADM(PreIADMId),"^",27)
	..s PAPMINo=$p(^DHCPEPreIBI(PreIBaseId),"^",1)
	..s Name=$p(^DHCPEPreIBI(PreIBaseId),"^",2)
	..s NamePY=##class(web.DHCINSUPort).GetCNCODE(Name,4,"")
	..s SexDr=$p(^DHCPEPreIBI(PreIBaseId),"^",3)
	..q:SexDr=""
	..s Sex=$p(^CT("SEX",SexDr),"^",2)
	..s Dob=$p(^DHCPEPreIBI(PreIBaseId),"^",4)
	..q:Dob=""
	..s DobDate=$zd(Dob,3)
	..s Marry=""
	..s Married=$p(^DHCPEPreIBI(PreIBaseId),"^",17)
	..i Married'="" s Marry=$p(^CT("MAR",Married),"^",2)
	..s Tel=$p(^DHCPEPreIBI(PreIBaseId),"^",6)
	..s EMail=$p(^DHCPEPreIBI(PreIBaseId),"^",16)
	..s IDCard=$p(^DHCPEPreIBI(PreIBaseId),"^",9)
	..s ZhiWu=$p(^DHCPEPreIBI(PreIBaseId),"^",25)
	..do OutputRow1	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(HPNo,PAPMINo,Name,NamePY,Sex,DobDate,Marry,Tel,EMail,ZhiWu,GName,IDCard)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod querypersoninfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = querypersoninfoExecute ]
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

ClassMethod querypersoninfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = querypersoninfoFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.ExportData","queryDiagnosis",892)
Query queryDiagnosis(GAdmId As %String) As %Query(ROWSPEC = "PAPMINo:%String,EDCode:%String,EDDesc:%String")
{
}

ClassMethod queryDiagnosisExecute(ByRef qHandle As %Binary, GAdmId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	s GTeamId=0
	f  s GTeamId=$o(^DHCPEIADM(0,"GADM",GAdmId,GTeamId)) q:GTeamId=""   d
	.s IADMId=0
	.f  s IADMId=$o(^DHCPEIADM(0,"GADM",GAdmId,GTeamId,IADMId)) q:IADMId=""  d
	..s PreIADMId=$p(^DHCPEIADM(IADMId),"^",4)
	..q:PreIADMId=""
	..s PreIBaseId=$p(^DHCPEPreIADM(PreIADMId),"^",1)
	..q:PreIBaseId=""
	..s Status=$p(^DHCPEIADM(IADMId),"^",8)
	..q:Status'="ARRIVED"
	..s HPNo=$p(^DHCPEPreIADM(PreIADMId),"^",27)
	..s PAPMINo=$p(^DHCPEPreIBI(PreIBaseId),"^",1)
    ..s GSRowId=$O(^DHCPEGS(0,"IADM",IADMId,0))
	..q:GSRowId=""
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d 
	...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...s Status=$p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",11)
	...q:Status'=0
	...s EDCode=$p(^DHCPEED(Diagnosis,1),"^",6)
	...s DiagnosisDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRowId_"||"_GSDChildSub))
	...s EDDesc=..GetDiagnosisDesc(DiagnosisDesc)
	..do OutputRow1	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(PAPMINo,EDCode,EDDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod queryDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queryDiagnosisExecute ]
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

ClassMethod queryDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queryDiagnosisFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDiagnosisDesc(Desc)
{
	q:Desc="" ""
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

//平均每日客户量153人，平均日营业额625163元，最高日营业额 1318763元，平均人均消费4086元，最高单人消费60480元，最高团体消费1769780元、人均1492元。

/// w ##class(web.DHCPE.Query.ExportData).A() 人数24326 天数159 结算总金额 99400969.45
ClassMethod A()
{
	s IADM=0,Num=0,MaxPay=0
	f  s IADM=$o(^DHCPEIADM(IADM)) q:IADM=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)
	.q:LocFlag="1"
	.s CurData=$g(^DHCPEIADM(IADM)) 
	.s IADMCRMADM=$p(CurData,"^",4)
	.Q:(""=IADMCRMADM)
	.s IADMStatus=$p(CurData,"^",8)
	.Q:(IADMStatus'="ARRIVED")
	.s Num=Num+1
	.s IADMAdmDate=$p(CurData,"^",5)
	.s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	.s AbortFees="0^0^0^"
	.s Payed=+$P(retvalue,"^",4)-$P(AbortFees,"^",3)+$P(retvalue,"^",7)-$P(AbortFees,"^",2)
	.
	q 0
}

}
