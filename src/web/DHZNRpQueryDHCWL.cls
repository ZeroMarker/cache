Import SQLUser

Class web.DHZNRpQueryDHCWL Extends %RegisteredObject [ Not ProcedureBlock ]
{

//门诊患者费用核对,结算对账(DHC_PatientBill和DHC_workload)---2012-08-28lxc 协和对账用

//d ##class(%ResultSet).RunQuery("web.DHZNRpQueryDHCWL","CheckAdmPatFLAGMZ","2012-11-28","2012-11-28")

ClassMethod CheckAdmPatFLAGMZExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j),^TEMPDHCWL1($j)
    s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f date=SDate:1:EDate d
    .s wlId=0,fee=0,sumwl=0
    .f  s wlId=$o(^DHCWorkLoad(0,"FlagDate",date,wlId)) q:wlId=""  d
    ..s PAADMType=$p(^DHCWorkLoad(wlId),"^",4) 
    ..q:PAADMType="I"
    ..s pbl=$p(^DHCWorkLoad(wlId),"^",20)   
    ..s fee=$p(^DHCWorkLoad(wlId),"^",16)
    ..s admId=$p(^DHCWorkLoad(wlId),"^",12)  ;q:admId'=294525
    ..s ^TEMPDHCWL($j,date,admId,pbl,"wl")=$g(^TEMPDHCWL($j,date,admId,pbl,"wl"))+fee
       
    f date1=SDate:1:EDate d
    .s hisDr="",fee1=0,sump=0
 	.f  s hisDr=$o(^DHCOPInsFootI(0,"Date",date1,hisDr)) q:hisDr=""  d //结算表
 	..q:'$d(^DHCOPInsFoot(hisDr))
 	..s InvRowid=""
 	..f  s InvRowid=$o(^DHCINVPRT(0,"Report",hisDr,InvRowid)) q:InvRowid=""  d
 	...q:'$d(^DHCINVPRT(InvRowid))
 	...s myPrtUser=$p(^DHCINVPRT(InvRowid),"^",21)
 	...Quit:+myPrtUser=3881
    ...s BCIRowid=0
    ...f  s BCIRowid=$o(^DHCBCI(0,"INV",InvRowid,BCIRowid)) q:BCIRowid=""  d         ;门诊帐单与发票的对应表
    ....s PBRowid=$p(^DHCBCI(BCIRowid),"^",2) 
    ....s PAADMDR=$P($G(^DHCPB(PBRowid)),"^",1)   ;q:PAADMDR'=294525  
    ....s PaidFlag=$p(^DHCPB(PBRowid),"^",16)
    ....q:PaidFlag'="P"
    ....s fee1=$P($G(^DHCPB(PBRowid)),"^",8)
    ....s ^TEMPDHCWL1($j,date1,PAADMDR,PBRowid,"pb")=$g(^TEMPDHCWL1($j,date1,PAADMDR,PBRowid,"pb"))+fee1

    s adm="",sum=0,sumwl=0,sumpb=0,diff=0
    s dat=0 f  s dat=$o(^TEMPDHCWL($j,dat)) q:dat=""  d
    .f  s adm=$o(^TEMPDHCWL($j,dat,adm)) q:adm=""  d
    ..s pbid=0 f  s pbid=$o(^TEMPDHCWL($j,dat,adm,pbid)) q:pbid=""  d
    ...s sumwl=$g(^TEMPDHCWL($j,dat,adm,pbid,"wl"))
    ...q:$d(^TEMPDHCWL1($j,dat,adm,pbid))
    ...s sumpb=$g(^TEMPDHCWL1($j,dat,adm,pbid,"pb")) 
    ...s diff=sumwl-sumpb
    ...i diff'=0 d
    ....d OutputRow3
   
    k ^TEMPDHCWL($j),^TEMPDHCWL1($j)
  
 	q $$$OK	
OutputRow3
    i $d(^PAADM(adm)) s date=$p($g(^PAADM(adm)),"^",6) 
    ;s AdmIddate=$zd(date,3)
   	s ybtype=$$GetReason^DHCWLCommon(adm)   //通过PA_Adm.PAADM_RowID获得病人的人员类别
    s flagd=$zd(dat,3)
    s Data=$lb(adm,ybtype,flagd,pbid,diff,sumwl,sumpb)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod CheckAdmPatFLAGMZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckAdmPatFLAGMZExecute ]
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

ClassMethod CheckAdmPatFLAGMZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckAdmPatFLAGMZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckAdmPatFLAGMZ(sDate As %String, eDate As %String) As %Query(ROWSPEC = "admId:%String,ybtype:%String,flagd:%String,pbid:%String,diff:%Float,sumwl:%Float,sumpb:%Float") [ SqlProc ]
{
}

//查询未进或未结算workload门诊患者费用核对,

//结算对账(DHC_PatientBill和DHC_workload)---2012-08-28lxc 协和对账用

//d ##class(%ResultSet).RunQuery("web.DHZNRpQueryDHCWL","CheckAdmNW","2012-11-28","2012-11-28")

ClassMethod CheckAdmNWExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j)
    s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f date=SDate:1:EDate d

    .s hisDr="",fee1=0
 	.f  s hisDr=$o(^DHCOPInsFootI(0,"Date",date,hisDr)) q:hisDr=""  d //结算表
 	..q:'$d(^DHCOPInsFoot(hisDr))
 	..s InvRowid=""
 	..f  s InvRowid=$o(^DHCINVPRT(0,"Report",hisDr,InvRowid)) q:InvRowid=""  d
 	...q:'$d(^DHCINVPRT(InvRowid))
 	...s myPrtUser=$p(^DHCINVPRT(InvRowid),"^",21)
 	...Quit:+myPrtUser=3881
    ...s BCIRowid=0
    ...f  s BCIRowid=$o(^DHCBCI(0,"INV",InvRowid,BCIRowid)) q:BCIRowid=""  d         ;门诊帐单与发票的对应表
    ....s PBRowid=$p(^DHCBCI(BCIRowid),"^",2) 
    ....s PAADMDR=$P($G(^DHCPB(PBRowid)),"^",1)   q:PAADMDR'=519875
    ....q:$d(^DHCWorkLoad(0,"ARPBL",PBRowid))
    ....s fee1=+$P($G(^DHCPB(PBRowid)),"^",8)
    ....q:$p(^PAADM(PAADMDR),"^",2)="I"
    ....s ^TEMPDHCWL($j,date,PAADMDR,PBRowid,"pb")=$g(^TEMPDHCWL($j,date,PAADMDR,PBRowid,"pb"))+fee1
    
    s adm="",sum=0,sumwl=0,sumpb=0
    s dat=0 f  s dat=$o(^TEMPDHCWL($j,dat)) q:dat=""  d
    .f  s adm=$o(^TEMPDHCWL($j,dat,adm)) q:adm=""  d
    ..s pbid=0 f  s pbid=$o(^TEMPDHCWL($j,dat,adm,pbid)) q:pbid=""  d
    ...s sumpb=$g(^TEMPDHCWL($j,dat,adm,pbid,"pb")) d
    ...d OutputRow5
   
    k ^TEMPDHCWL($j)
 
 	q $$$OK	
OutputRow5
    i $d(^PAADM(adm)) s date=$p($g(^PAADM(adm)),"^",6),type=$p(^PAADM(adm),"^",2)
   	s ybtype=$$GetReason^DHCWLCommon(adm)   //通过PA_Adm.PAADM_RowID获得病人的人员类别
    ;s AdmIddate=$zd(date,3)
    s flagd=$zd(dat,3)
    s Data=$lb(adm,type,ybtype,flagd,pbid,sumpb)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod CheckAdmNWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckAdmNWExecute ]
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

ClassMethod CheckAdmNWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckAdmNWExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckAdmNW(sDate As %String, eDate As %String) As %Query(ROWSPEC = "admId:%String,type:%String,ybtype:%String,flagd:%String,pbid:%String,sumpb:%Float") [ SqlProc ]
{
}

//门诊患者费用核对,结算对账(DHC_PatientBill和DHC_workload)---2012-08-28lxc 协和对账用

//找出结算日不一致的账单

//d ##class(%ResultSet).RunQuery("web.DHZNRpQueryDHCWL","CheckAdmTest","2012-11-28","2012-11-28")

ClassMethod CheckAdmTestExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j),^TEMPDHCWL1($j)
    s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)

    f date=SDate:1:EDate d
    .s hisDr="",sum=0
 	.;f  s hisDr=$o(^DHCOPInsFootI(0,"Date",date,hisDr)) q:hisDr=""  d //结算表
 	.;.q:'$d(^DHCOPInsFoot(hisDr))
 	.;.s InvRowid=""
 	.;.f  s InvRowid=$o(^DHCINVPRT(0,"Report",hisDr,InvRowid)) q:InvRowid=""  d
 	.;..q:'$d(^DHCINVPRT(InvRowid))
 	.i (1) d
    ..s InvRowid=0
 	..f  s InvRowid=$o(^DHCINVPRT(0,"HandDate",date,InvRowid)) q:InvRowid=""  d
    ...q:'$d(^DHCINVPRT(InvRowid))
    ...s BCIRowid=0
    ...f  s BCIRowid=$o(^DHCBCI(0,"INV",InvRowid,BCIRowid)) q:BCIRowid=""  d         ;门诊帐单与发票的对应表
    ....s PBRowid=$p(^DHCBCI(BCIRowid),"^",2) 
    ....s PAADMDR=$P($G(^DHCPB(PBRowid)),"^",1)   ;q:PAADMDR'=331210    
    ....s PaidFlag=$p(^DHCPB(PBRowid),"^",16)
    ....q:PaidFlag'="P"
    ....q:'$d(^DHCWorkLoad(0,"ARPBL",PBRowid))
    ....s wlId=0  f  s wlId=$o(^DHCWorkLoad(0,"ARPBL",PBRowid,wlId)) q:wlId=""  d
    .....s flagdate=$p(^DHCWorkLoad(wlId),"^",27) 
    .....i flagdate="" s flagdate="999999"
    .....q:flagdate=date
    .....s fee=$p(^DHCWorkLoad(wlId),"^",16) 
    .....s ^TEMPDHCWL($j,flagdate,PBRowid,"wl")=$g(^TEMPDHCWL($j,flagdate,PBRowid,"wl"))+fee
    
    s adm="",sum=0,sumwl=0,sumpb=0,total=0
    s dat=0 f  s dat=$o(^TEMPDHCWL($j,dat)) q:dat=""  d
    .s pbid=0 f  s pbid=$o(^TEMPDHCWL($j,dat,pbid)) q:pbid=""  d
    ..s sumwl=$g(^TEMPDHCWL($j,dat,pbid,"wl")) 
    ..d OutputRow6
    
    k ^TEMPDHCWL($j),^TEMPDHCWL1($j)
 
 	q $$$OK	
OutputRow6
    ;i $d(^PAADM(adm)) s date=$p($g(^PAADM(adm)),"^",6) 
    s total=total+sumwl
    s flagd=$zd(dat,3)
    s Data=$lb(flagd,pbid,sumwl)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod CheckAdmTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckAdmTestExecute ]
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

ClassMethod CheckAdmTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckAdmTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckAdmTest(sDate As %String, eDate As %String) As %Query(ROWSPEC = "flagd:%String,pbid:%String,sumwl:%Float") [ SqlProc ]
{
}

}
