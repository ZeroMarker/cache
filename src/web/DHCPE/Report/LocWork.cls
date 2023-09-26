Class web.DHCPE.Report.LocWork
{

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.LocWork","LocWork","61758","")

Query LocWork(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TAmount:%String,TTotal:%String,TPerson:%String")
{
}

ClassMethod LocWorkExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	s ind=1
 	s id=0	
 	Set repid=$I(^CacheTemp)
 	s curUser=%session.Get("LOGON.USERID")
 	k ^TEMPDHCPELocWork
 	s GAmount=0
 	s IAmount=0
 	s YAmount=0
 	if (BeginDate="")&&(EndDate="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	
 	
 	i BeginDate="" s BeginDate=1
 	i EndDate="" s EndDate=+$H
 	/*
 	//计算收款
 	s Date=BeginDate-1
 	f  s Date=$o(^DHCPEUSERREPORT(0,"DATE",Date)) q:(Date="")||(Date>EndDate)  d
 	.s rid=0
 	.f  s rid=$o(^DHCPEUSERREPORT(0,"DATE",Date,rid)) q:(rid="")  d
 	..s invid=0
 	..f  s invid=$o(^DHCPEINVPRT(0,"REPORT",rid,invid)) q:invid=""  d
 	...s PRTINVNO=$p(^DHCPEINVPRT(invid),"^",1)  //add by zl
 	...//预缴金结算的退出
 	...s paadm=$p(^DHCPEINVPRT(invid),"^",2)
 	...s Amount=$p(^DHCPEINVPRT(invid),"^",7)
 	...s pbid=$p(^DHCPEINVPRT(invid),"^",3)
 	...s papbid=$o(^DHCPEPAPBR(0,"PBDR",pbid,0))
 	...q:papbid=""
 	...s auditid=$p(^DHCPEPAPBR(papbid),"^",1)
 	...s type=$p(^DHCPEPreA(auditid),"^",1)
 	...i type="G" d
 	....s GAmount=GAmount+Amount
 	....s ^TEMPDHCPELocWork("GAList",invid)=PRTINVNO_"^"_Amount
 	....s ^TEMPDHCPELocWork("GlobalAList",invid)=PRTINVNO_"^"_Amount
 	...e  d
 	....s IAmount=IAmount+Amount
 	....s ^TEMPDHCPELocWork("IAList",invid)=PRTINVNO_"^"_Amount
 	....s ^TEMPDHCPELocWork("GlobalAList",invid)=PRTINVNO_"^"_Amount
 	..s apid=0
 	..f  s apid=$o(^DHCPEAP(0,"Report",rid,apid)) q:apid=""  d
 	...s sub=0
 	...f  s sub=$o(^DHCPEAP(0,"Report",rid,apid,sub)) q:sub=""  d
 	....s type=$p(^DHCPEAP(apid,"AC",sub),"^",1)
 	....q:(type'="B")&&(type'="R")&&(type'="RF")
 	....i type'="RF" s DHCPEAPInvNo=$p(^DHCPEAP(apid,"AC",sub),"^",4) 
 	....else  s DHCPEAPInvNo=""
 	....s Amount=$p(^DHCPEAP(apid,"AC",sub),"^",2)
 	....s ^TEMPDHCPELocWork("APAList",apid_"||"_sub)=DHCPEAPInvNo_"^"_Amount
 	....s ^TEMPDHCPELocWork("GlobalAList",apid_"||"_sub)=PRTINVNO_"^"_Amount
 	....s YAmount=YAmount+Amount
 	*/
 	s Date=BeginDate-1 
 	f  s Date=$o(^DHCPEINVPRT(0,"RPDATE",Date)) q:(Date="")||(Date>EndDate)  d
 	.s userid=0
 	.f  s userid=$o(^DHCPEINVPRT(0,"RPDATE",Date,userid)) q:(userid="")  d
 	..s invid=0
 	..f  s invid=$o(^DHCPEINVPRT(0,"RPDATE",Date,userid,invid)) q:invid=""  d
 	...s PRTINVNO=$p(^DHCPEINVPRT(invid),"^",1) //add by zl
 	...s rid=$p(^DHCPEINVPRT(invid),"^",13) 
 	...//预缴金结算的退出
 	...s paadm=$p(^DHCPEINVPRT(invid),"^",2)
 	...s Amount=$p(^DHCPEINVPRT(invid),"^",7)
 	...s pbid=$p(^DHCPEINVPRT(invid),"^",3)
 	...s papbid=$o(^DHCPEPAPBR(0,"PBDR",pbid,0))
 	...q:papbid=""
 	...s auditid=$p(^DHCPEPAPBR(papbid),"^",1)
 	...s type=$p(^DHCPEPreA(auditid),"^",1)
 	...i type="G" d
 	....s GAmount=GAmount+Amount
 	....s ^TEMPDHCPELocWork("GAList",invid)=PRTINVNO_"^"_Amount
 	....s ^TEMPDHCPELocWork("GlobalAList",invid)=PRTINVNO_"^"_Amount
 	...e  d
 	....s IAmount=IAmount+Amount
 	....s ^TEMPDHCPELocWork("IAList",invid)=PRTINVNO_"^"_Amount
 	....s ^TEMPDHCPELocWork("GlobalAList",invid)=PRTINVNO_"^"_Amount
 	...s apid=0
 	...f  s apid=$o(^DHCPEAP(0,"Report",rid,apid)) q:apid=""  d
 	....s sub=0
 	....f  s sub=$o(^DHCPEAP(0,"Report",rid,apid,sub)) q:sub=""  d
 	.....s type=$p(^DHCPEAP(apid,"AC",sub),"^",1)
 	.....q:(type'="B")&&(type'="R")&&(type'="RF")
 	.....i type'="RF" s DHCPEAPInvNo=$p(^DHCPEAP(apid,"AC",sub),"^",4) 
 	.....else  s DHCPEAPInvNo=""
 	.....s Amount=$p(^DHCPEAP(apid,"AC",sub),"^",2)
 	.....s ^TEMPDHCPELocWork("APAList",apid_"||"_sub)=DHCPEAPInvNo_"^"_Amount
 	.....s ^TEMPDHCPELocWork("GlobalAList",apid_"||"_sub)=PRTINVNO_"^"_Amount
 	.....s YAmount=YAmount+Amount

 	s TAmount=GAmount+IAmount+YAmount
 	//计算体检人数
 	s GTotal=0,GPerson=""
 	s ITotal=0,IPerson=""
 	s Date=BeginDate-1
 	f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
 	.s time=0
 	.f  s time=$o(^DHCPEIADM(0,"AdmDateTime",Date,time)) q:(time="")  d
 	..s iadm=0
 	..f  s iadm=$o(^DHCPEIADM(0,"AdmDateTime",Date,time,iadm)) q:(iadm="")  d
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",iadm)  
    ...q:LocFlag=1
 	...s status=$p(^DHCPEIADM(iadm),"^",8)
 	...q:status'="ARRIVED"
 	...s gadm=$p(^DHCPEIADM(iadm),"^",2)
 	...i gadm'="" d
 	....s GTotal=GTotal+1
 	....s GPerson=GPerson_"^"_iadm
 	....S ^TEMPDHCPELocWork("GPerson",curUser,iadm)=iadm
 	...e  d
 	....s ITotal=ITotal+1
 	....s IPerson=IPerson_"^"_iadm
 	....S ^TEMPDHCPELocWork("IPerson",curUser,iadm)=iadm
 	s TTotal=GTotal+ITotal
 	s TPerson=GPerson_"^"_IPerson
 	//输出查询结果
 	s Name="集体"
 	s Amount=GAmount
 	s Total=GTotal
 	s Person=GPerson
 	d LocWorkOut
 	
 	s Name="个人"
 	s Amount=IAmount
 	s Total=ITotal
 	s Person=IPerson
 	d LocWorkOut
 	
 	s Name="预缴金"
 	s Amount=YAmount
 	s Total=""
 	d LocWorkOut
 	
 	s Name="合计"
 	s Amount=TAmount
 	s Total=TTotal
 	s Person=TPerson
 	d LocWorkOut
 	 
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
LocWorkOut
    s Data=$LB(Name,Amount,Total,Person)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LocWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocWorkExecute ]
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

ClassMethod LocWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocWorkExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LocWorkPerson(IADMList As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TGroupName:%String")
{
}

/*
ClassMethod LocWorkPersonExecute(ByRef qHandle As %Binary, IADMList As %Library.String = "") As %Status
{
	s ind=1
 	Set repid=$I(^CacheTemp)
 	
 	f iLLoop=1:1:$Length(IADMList,"^") d
	.s IAdmRowId=$P(IADMList,"^",iLLoop)
	.Q:(""=IAdmRowId)
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.s GTeamRowid=$P($g(^DHCPEIADM(IAdmRowId)),"^",3)
	.i GTeamRowid'="" d
	..s GTChildSub=$p(GTeamRowid,"||",2)
	..s GADMRowid=$p(GTeamRowid,"||",1)
	..s GGroup=""
	..i GTeamRowid'="" s GGroup=$P($g(^DHCPEGADM(GADMRowid,"Team",GTChildSub)),"^",1)
	.
	.s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	.s AdmDate2=AdmDate
	.s AdmDate=$ZD(AdmDate,3)
	.
	.s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""=PIAdmRowId) 
	.s GDesc=""
	.s PGADMDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",2)
	.i ""'=PGADMDR d
	..s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1)
	..s GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	.s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	.Q:(""=PIBIDR) 
	.s PAPMINo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	.s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	.s Married=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	.s:(Married'="") Married=$p(^CT("MAR",Married),"^",2)
	.s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	.s:(PIBISex'="") PIBISex=$p(^CT("SEX",PIBISex),"^",2)
	.s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,AdmDate2)
 	.s Age=+$P(Age,"Y",1)
	.s:(""'=PIBIDOB) PIBIDOB=$ZD(PIBIDOB,3)
	.;s PIBISex="("_Age_")"_PIBISex
 	.d LocWorkPersonOut
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
LocWorkPersonOut
    s Data=$LB(PAPMINo,Name,PIBISex,Age,GDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
ClassMethod LocWorkPersonExecute(ByRef qHandle As %Binary, IADMList As %Library.String = "") As %Status
{
	s ind=1
 	Set repid=$I(^CacheTemp)
 	
 	s curUser=%session.Get("LOGON.USERID")
 	
 	I IADMList="集体" d
 	.s IAdmRowId=""
 	.f  s IAdmRowId=$o(^TEMPDHCPELocWork("GPerson",curUser,IAdmRowId))  q:IAdmRowId=""  d
 	..d GetPersonInfo
	
	
	I IADMList="个人" d
 	.s IAdmRowId=""
 	.f  s IAdmRowId=$o(^TEMPDHCPELocWork("IPerson",curUser,IAdmRowId))  q:IAdmRowId=""  d
 	..d GetPersonInfo
	
	
	I IADMList="合计" d
	.s type=""
	.f  s type=$o(^TEMPDHCPELocWork(type)) q:type=""  d 
 	..s IAdmRowId=""
 	..f  s IAdmRowId=$o(^TEMPDHCPELocWork(type,curUser,IAdmRowId))  q:IAdmRowId=""  d
 	...d GetPersonInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
 
GetPersonInfo
	Q:(""=IAdmRowId)
	s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	s GTeamRowid=$P($g(^DHCPEIADM(IAdmRowId)),"^",3)
	i GTeamRowid'="" d
	.s GTChildSub=$p(GTeamRowid,"||",2)
	.s GADMRowid=$p(GTeamRowid,"||",1)
	.s GGroup=""
	.i ((GTeamRowid'="")&&(GTeamRowid["||"))  s GGroup=$P($g(^DHCPEGADM(GADMRowid,"Team",GTChildSub)),"^",1)
	
	s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	s AdmDate2=AdmDate
	s AdmDate=$ZD(AdmDate,3)
    
	s PIAdmRowId=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	Q:(""=PIAdmRowId) 
	s GDesc=""
	s PGADMDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",2)
	i ""'=PGADMDR d
	.s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1)
	.s GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	Q:(""=PIBIDR) 
	s PAPMINo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	s Married=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	s:(Married'="") Married=$p(^CT("MAR",Married),"^",2)
	s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	s:(PIBISex'="") PIBISex=$p(^CT("SEX",PIBISex),"^",2)
	s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	s NewPatID=$O(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	s Age=""
    i PIBIDOB'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(NewPatID)
	s:(""'=PIBIDOB) PIBIDOB=$ZD(PIBIDOB,3)
	;s PIBISex="("_Age_")"_PIBISex
 	d LocWorkPersonOut
 	Q
   
LocWorkPersonOut
    s Data=$LB(PAPMINo,Name,PIBISex,Age,GDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LocWorkPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocWorkPersonExecute ]
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

ClassMethod LocWorkPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocWorkPersonExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryInvList(Name As %String = "") As %Query(ROWSPEC = "InvPrt:%String,Amount:%String,Status:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.LocWork","QueryInvList","61758","")

ClassMethod QueryInvListExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
  
	Set repid=$I(^CacheTemp)
 	s ind=1
    i (""=Name) {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	     if Name="集体"  d
	     .s invid=0
	     .f  s invid=$o(^TEMPDHCPELocWork("GAList",invid))  q:invid=""  d
	     ..s GStr=^TEMPDHCPELocWork("GAList",invid)
	     ..s PRTINVNO=$P(GStr,"^",1)
	     ..s PRTAcount=$P(GStr,"^",2)
	     ..i PRTINVNO=""  s PRTStstus="冲红"
	     ..else  s PRTStstus="正常"
	     ..d OutInvPrt
	     if Name="个人"  d
	     .s invid=0
	     .f  s invid=$o(^TEMPDHCPELocWork("IAList",invid))  q:invid=""  d
	     ..s GStr=^TEMPDHCPELocWork("IAList",invid)
	     ..s PRTINVNO=$P(GStr,"^",1)
	     ..s PRTAcount=$P(GStr,"^",2)
	     ..i PRTINVNO=""  s PRTStstus="冲红"
	     ..else  s PRTStstus="正常"
	     ..d OutInvPrt
	     if Name="预缴金"  d
	     .s APRoWID=0
	     .f  s APRoWID=$o(^TEMPDHCPELocWork("APAList",APRoWID))  q:APRoWID=""  d
	     ..s APStr=$g(^TEMPDHCPELocWork("APAList",APRoWID))
	     ..s PRTINVNO=$P(APStr,"^",1)
	     ..s PRTAcount=$P(APStr,"^",2)
 	     ..i PRTINVNO=""  s PRTStstus="冲红"
	     ..else  s PRTStstus="正常"
         ..d OutInvPrt
         if Name="合计"  d
	     .s invid=0
	     .f  s invid=$o(^TEMPDHCPELocWork("GlobalAList",invid)) q:invid=""  d
	     ..s APStr=$g(^TEMPDHCPELocWork("GlobalAList",invid))
	     ..s PRTINVNO=$P(APStr,"^",1)
	     ..s PRTAcount=$P(APStr,"^",2)
 	     ..i PRTINVNO=""  s PRTStstus="冲红"
	     ..else  s PRTStstus="正常"
         ..d OutInvPrt

   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInvPrt
 	set Data=$lb(PRTINVNO,PRTAcount,PRTStstus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryInvListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInvListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryInvListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInvListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
