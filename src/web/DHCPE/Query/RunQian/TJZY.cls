/// 天津中医
Class web.DHCPE.Query.RunQian.TJZY Extends %RegisteredObject
{

/// ##class(web.DHCPE.Query.RunQian.TJZY).tt()
ClassMethod tt()
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","DocWork","2013-01-01","2014-10-01")
Query DocWork(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "RecLoc:%String,DocId:%String,DocName:%String,ARCIMDesc:%String,AccountAmount:%Float,FactAmount:%Float") [ SqlProc ]
{
}

ClassMethod DocWorkExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
 	
 	s PreAudits=""
 	f date=BeginDate:1:EndDate d
 	.s rprowid=0
 	.f  s rprowid=$o(^DHCPEUSERREPORT(0,"DATE",date,rprowid)) q:rprowid=""  d
 	..s invrowid=0
 	..f  s invrowid=$o(^DHCPEINVPRT(0,"REPORT",rprowid,invrowid)) q:invrowid=""  d
 	...s billId=$p($g(^DHCPEINVPRT(invrowid)),"^",3)
 	...q:billId=""
 	...s relateid=""
 	...f  s relateid=$o(^DHCPEPAPBR(0,"PBDR",billId,relateid)) q:relateid=""  d
 	....i PreAudits'=""  s PreAudits=PreAudits_","
 	....s PreAudits=PreAudits_$p($g(^DHCPEPAPBR(relateid)),"^",1)
 	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
 	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
 	s i=1
	while(i<=$l(PreAudits,",")){
		s preAuditId=$p(PreAudits,",",i)
		q:preAuditId=""
		s preAdmId=""
		s preAdmIds=""
		s i=i+1
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:preAdmId=""  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:childsub=""  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s CRMO=$o(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_childsub,0))
		..q:CRMO=""
		..s OEORIRowId=$p(^DHCPECRMO(CRMO),"^",1)
		..q:OEORIRowId=""
		..s OEORIItemStatDR=+$P($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",13)
		..Q:(6'=OEORIItemStatDR)
		..s RecDepDR=$P($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",6)
		..s RecLoc=$P($G(^CTLOC(RecDepDR)),"^",2)
		..s ItmMastDR=$P($G(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
		..s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
		..q:STRowId=""
		..s RLTId="",DocId="",DocName=""
		..f  s RLTId=$o(^DHCPERLT(0,"OEORI",OEORIRowId,RLTId)) q:RLTId=""  d
		...s DocId=$p(^DHCPERLT(RLTId),"^",5)
		...q:DocId=""
		...s DocName=$p($g(^SSU("SSUSR",DocId)),"^",2)
		...i STRowId=LabStation s DocName=$p($g(^[namespaceLab]SSU("SSUSR",1,DocId)),"^",2)
		..q:DocId=""
		..s ARCIMDesc=$P($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",2)
		..s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(preAdmId_"||"_childsub,"","")
 		..s AccountAmount=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",14)
 		..d DocWork

	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DocWork
	set Data=$lb(RecLoc,DocId,DocName,ARCIMDesc,AccountAmount,FactAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DocWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DocWorkExecute ]
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

ClassMethod DocWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DocWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 医嘱数量查询
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","GetItem","2017-12-13","2017-12-13","13338||1","","","")
Query GetItem(BeginDate As %Library.String = "", EndDate As %Library.String = "", ArcItemID As %String = "", ToDay As %String = "", CheckFlag As %String = "", UserID As %String = "") As %Query(ROWSPEC = "yyyymmddDate:%String,ItemDesc:%String,Flag:%String,Name:%String,RegNo:%String,HPNo:%String,CheckDate:%String,ItemNum:%Float,ItemPrice:%Float") [ SqlProc ]
{
}

ClassMethod GetItemExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", ArcItemID As %String = "", ToDay As %String = "", CheckFlag As %String = "", UserID As %String = "") As %Status
{
	s ind=1
 	s id=0
 	Set repid=$I(^CacheTemp)
 	
 	i (ArcItemID="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$J
 	s:UserID="" UserID=Job
 	k ^TempDHCPE("RegNum",UserID)
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i ToDay'="" s ToDay=##class(websys.Conversions).DateHtmlToLogical(ToDay) 
	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
	s AdmDate=0
	s:(""'=BeginDate) AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",BeginDate), -1)
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)||((""'=EndDate)&&(AdmDate>EndDate))  d
	.q:(ToDay'="")&&(ToDay'=AdmDate)
	.s AdmTime=0
	.f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime)) q:AdmTime=""  d
	..s IADM=""
	..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADM)) q:IADM=""  d
	...s Status=$p(^DHCPEIADM(IADM),"^",8)
	...q:Status="CANCELPE"
	...s preIADM=$p(^DHCPEIADM(IADM),"^",4)
	...s PIBI=$p(^DHCPEPreIADM(preIADM),"^",1)
	...s RegNo=$p($G(^DHCPEPreIBI(PIBI)),"^",1)
	...s Name=$p($G(^DHCPEPreIBI(PIBI)),"^",2)
	...s HPNo=$p(^DHCPEPreIADM(preIADM),"^",27)
	...s sub=0
	...f  s sub=$o(^DHCPEPreIADM(preIADM,"ORDITEM",sub)) q:sub=""  d
	....s arcItemID=$P(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",1)
	....q:ArcItemID'=arcItemID
	....s ItemStatus=$p(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",16)
	....q:ItemStatus'="1"
	....s ItemPrice=$p(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",14)
	....s PIOIRowID=preIADM_"||"_sub
	....s Flag=0
	....s CheckDate=""
	....s CRMOID=""
	....f  s CRMOID=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,CRMOID)) q:CRMOID=""  d
	.....s OEORDRowId=$p(^DHCPECRMO(CRMOID),"^",1)
	.....i $D(^DHCPERLT(0,"OEORI",OEORDRowId)) d
	......s Flag=1
	......s RLTRowID=$o(^DHCPERLT(0,"OEORI",OEORDRowId,0))
	......s CheckDate=$p(^DHCPERLT(RLTRowID),"^",6)
	......s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
	....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,1,preIADM,"Num")=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,1,preIADM,"Num"))+1
	....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,1,preIADM,"Info")=RegNo_"^"_Name_"^"_HPNo_"^"_ItemPrice_"^"_CheckDate
	....i Flag=1 d
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,2,preIADM,"Num")=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,2,preIADM,"Num"))+1
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",AdmDate,arcItemID,2,preIADM,"Info")=RegNo_"^"_Name_"^"_HPNo_"^"_ItemPrice_"^"_CheckDate
	
	s date=0
	f  s date=$O(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date)) q:date=""  d
	.s arc=ArcItemID
	.s ARCIMDesc=$P($G(^ARCIM(+ArcItemID,$p(ArcItemID,"||",2),1)),"^",2)
	.s flag=0
	.f  s flag=$o(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc,flag)) q:flag=""  d
	..q:(CheckFlag'="")&&(CheckFlag'=flag)
	..s preIADM=0
	..f  s preIADM=$o(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc,flag,preIADM)) q:preIADM=""  d
	...s ItemNum=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc,flag,preIADM,"Num"))
    ...s Info=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc,flag,preIADM,"Info"))
	...s RegNo=$p(Info,"^",1)
	...s Name=$p(Info,"^",2)
	...s HPNo=$p(Info,"^",3)
	...s ItemPrice=$p(Info,"^",4)
	...s CheckDate=$p(Info,"^",5)
	...s yyyymmddDate=##class(websys.Conversions).DateLogicalToHtml(date)
	...d GetItemOut
 	 	 
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
GetItemOut
    s Data=$LB(yyyymmddDate,ARCIMDesc,flag,Name,RegNo,HPNo,CheckDate,ItemNum,ItemPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemExecute ]
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

ClassMethod GetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 统计自费没交钱做了体检的人员信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","ArrNoPay","2013-01-01","2018-1-27")
Query ArrNoPay(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "RegNo:%String,Name:%String,TeamName:%String,NoPayCount:%Float") [ SqlProc ]
{
}

ClassMethod ArrNoPayExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
    
    f teamDate=BeginDate:1:EndDate d
	.s teamTime=""
 	.f  s teamTime=$o(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime)) q:teamTime=""  d
 	..;b ;d
 	..s IADMId=""
    ..f  s IADMId=$O(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime,IADMId)) q:IADMId=""  d
    ...s TeamId=""
    ...s TeamId=$P($G(^DHCPEIADM(IADMId)),"^",2)
    ...q:TeamId=""
    ...s Status=$P($G(^DHCPEIADM(IADMId)),"^",8) ;ARRIVED
    ...q:Status'="ARRIVED"
    ...s StatusBill=$P($G(^DHCPEIADM(IADMId)),"^",16) ;GD  RegNo,Name,TeamName,NoPayCount
    ...q:StatusBill="ID"
 	...s RegNo="",Name="",TeamName="",NoPayCount=""
 	...s PreteamId=$P($G(^DHCPEGADM(TeamId)),"^",1)
 	...b ;1
 	...s TeamName=$P($G(^DHCPEGBI(PreteamId)),"^",2)
 	...s IADMCRMADM=$P($G(^DHCPEIADM(IADMId)),"^",4)
 	...s PIADMPIBIDR=$P($G(^DHCPEPreIADM(IADMCRMADM)),"^",1)
 	...s Name=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
 	...s RegNo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
 	...;// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
 	...s NoPayCount=0
 	...s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	...Q:(""=retvalue)
	...s NoPayCount=+$P(retvalue,"^",8)
	...q:NoPayCount=0
	...//公费已付金额
	...d ArrNoPay
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ArrNoPay
	set Data=$lb(RegNo,Name,TeamName,NoPayCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArrNoPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArrNoPayExecute ]
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

ClassMethod ArrNoPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArrNoPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 筛选个人及团体的弃检数量及具体科室
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","PERefuseCheckInfo","2017-09-20","2017-12-31","")
Query PERefuseCheckInfo(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupID As %Library.String = "") As %Query(ROWSPEC = "GDesc:%String,RegNo:%String,Name:%String,ARCIMDesc:%String,RecLocDesc:%String") [ SqlProc ]
{
}

ClassMethod PERefuseCheckInfoExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupID As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
	
 	i GroupID'="" d
	.s GADM=$o(^DHCPEGADM(0,"CRMGADM",GroupID,0))
	.q:GADM=""
	.s Team=0
	.f  s Team=$o(^DHCPEIADM(0,"GADM",GADM,Team)) q:Team=""  d
	..s IADM=0
	..f  s IADM=$o(^DHCPEIADM(0,"GADM",GADM,Team,IADM)) q:IADM=""  d
	...d GetIADMInfo
	e  d
	.s AdmDate=0
	.s:(""'=BeginDate) AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",BeginDate), -1)
	.f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)||((""'=EndDate)&&(AdmDate>EndDate))  d
	..s AdmTime=0
	..f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime)) q:AdmTime=""  d
	...s IADM=""
	...f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADM)) q:IADM=""  d
	....d GetIADMInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetIADMInfo
	s Status=$p(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED"
	s PIADM=$p(^DHCPEIADM(IADM),"^",4)
	s GDesc=""
	s PGADM=$p(^DHCPEPreIADM(PIADM),"^",2)
	i PGADM'="" d
	.s PGBI=$p($g(^DHCPEPreGADM(PGADM)),"^",1)
	.i PGBI'="" d
	..s GDesc=$p($g(^DHCPEPreGBI(PGBI)),"^",2)
	s PIBI=$p(^DHCPEPreIADM(PIADM),"^",1)
	q:PIBI=""
	s RegNo=$p($g(^DHCPEPreIBI(PIBI)),"^",1)
	s Name=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
	s CRMOID=""
	f  s CRMOID=$o(^DHCPECRMO(0,"IADM",IADM,CRMOID)) q:CRMOID=""  d
	.s OEORIDR=$p(^DHCPECRMO(CRMOID),"^",1)
	.q:'$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIDR))
	.s CRMORI=$p(^DHCPECRMO(CRMOID),"^",2)
	.s RecLoc=$p(^DHCPEPreIADM(+CRMORI,"ORDITEM",$p(CRMORI,"||",2)),"^",17)
	.s RecLocDesc=$p(^CTLOC(RecLoc),"^",2)
	.s ItmMastDR=$P($G(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",2)
	.s ARCIMSubscript=$P(ItmMastDR,"||",1)
	.s ARCIMVersion=$P(ItmMastDR,"||",2)
	.s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.d OutRow

	q
OutRow
	set Data=$lb(GDesc,RegNo,Name,ARCIMDesc,RecLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PERefuseCheckInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PERefuseCheckInfoExecute ]
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

ClassMethod PERefuseCheckInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PERefuseCheckInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 体检收入报表

// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","Income","2016-12-1","2016-12-10")

Query Income(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "Type:%String,Desc:%String,Num2:%String,Num:%String,CountAmount:%Float,BillAmount:%Float,NotBillAmount:%Float") [ SqlProc ]
{
}

ClassMethod IncomeExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	k ^DHCPERUNQIANMark
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
 
 	f date=BeginDate:1:EndDate d
 	.s Invrowid=0
 	.f  s Invrowid=$o(^DHCPEINVPRT(0,"DATE",date,Invrowid)) q:Invrowid=""  d
 	..s Num2="",Type="",Desc="",Num="",CountAmount="",BillAmount="",NotBillAmount=""
 	..s UserId=$P($G(^DHCPEINVPRT(Invrowid)),"^",10)
 	..s Type="门诊收费"
 	..s paadm=$p($G(^DHCPEINVPRT(Invrowid)),"^",2)
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)
  	..;q:(LocFlag=1)	
	..s patid=$p($g(^PAADM(paadm)),"^",1)
	..if patid="" q
	..s giadmid=$o(^DHCPEIADM(0,"PAADM",paadm,""))
	..q:giadmid=""
 	..s personMark=""
 	..s personMark=$P($G(^DHCPEINVPRT(Invrowid)),"^",1)
 	..s Desc=$P($G(^SSU("SSUSR",UserId)),"^",2)
 	..s Num2=1
 	..i $d(^DHCPERUNQIANMark(paadm)) d
 	...s Num2=0
 	..s ^DHCPERUNQIANMark(paadm)=paadm
 	..i personMark="" d
 	...s Num=0
 	..e  d
 	...s Num=1
 	..s CountAmount=$P($G(^DHCPEINVPRT(Invrowid)),"^",7)
 	..s BillAmount=$P($G(^DHCPEINVPRT(Invrowid)),"^",7)
 	..s NotBillAmount=CountAmount-BillAmount
 	..d IncomeOutput
    
    f teamDate=BeginDate:1:EndDate d
	.s teamTime=""
 	.f  s teamTime=$o(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime)) q:teamTime=""  d
 	..s IADMId=""
    ..f  s IADMId=$O(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime,IADMId)) q:IADMId=""  d
    ...s TeamId=""
    ...s TeamId=$P($G(^DHCPEIADM(IADMId)),"^",2)
    ...q:TeamId=""
    ...s Status=$P($G(^DHCPEIADM(IADMId)),"^",8) ;ARRIVED
    ...q:'((Status="ARRIVED")||(Status="COMPLETED"))
    ...s Type="",Desc="",Num="",CountAmount="",BillAmount="",NotBillAmount=""
 	...s Num=1
 	...s Num2=1
    ...s StatusBill=""
    ...s StatusBill=$P($G(^DHCPEIADM(IADMId)),"^",3) ;GD
    ...q:StatusBill'["||"
    ...;q:'(StatusBill="GD")
 	...s Type="团体收费"
 	...
 	...;s PreteamId=""
 	...;s PreteamId=$P( $G(^DHCPEGADM(TeamId)),"^",1)
 	...s Desc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(TeamId) ;;$P($G(^DHCPEPreGBI(PreteamId)),"^",2)_"^"_IADMId
 	...;s CashAmount=""   ;  按照个人预约查询界面的费用取费用
 	...s IADMCRMADM=$P($G(^DHCPEIADM(IADMId)),"^",4)
 	...;// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
 	...s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	...;Q:(""=retvalue)
	...// 实际金额
	...s CountAmount=+$P(retvalue,"^",3)
	...s NotBillAmount=+$P(retvalue,"^",5)
	...s BillAmount=+$P(retvalue,"^",4)
 	...d IncomeOutput
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IncomeOutput
	set Data=$lb(Type,Desc,Num2,Num,CountAmount,BillAmount,NotBillAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod IncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IncomeExecute ]
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

ClassMethod IncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 体检应收款报表

// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","Arrearage","2016-11-14","2016-11-14")

Query Arrearage(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "Desc:%String,CountAmount:%Float,CashAmount1:%Float,CashAmount2:%Float,CashAmount3:%Float") [ SqlProc ]
{
}

ClassMethod ArrearageExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
    
    f teamDate=BeginDate:1:EndDate d
	.s teamTime=""
 	.f  s teamTime=$o(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime)) q:teamTime=""  d
 	..s IADMId=""
    ..f  s IADMId=$O(^DHCPEIADM(0,"AdmDateTime",teamDate,teamTime,IADMId)) q:IADMId=""  d
    ...s TeamId=""
    ...s TeamId=$P($G(^DHCPEIADM(IADMId)),"^",2)
    ...q:TeamId=""
    ...s Status=$P($G(^DHCPEIADM(IADMId)),"^",8) ;ARRIVED
    ...q:Status'="ARRIVED"
    ...i TeamId="" d
    ....s Desc="",CountAmount="",CashAmount1="",CashAmount2="",CashAmount3=""
    ....s PreIADMId=$P($G(^DHCPEIADM(IADMId)),"^",4)
    ....s PIADMPIBIDR=$P($G(^DHCPEPreIADM(PreIADMId)),"^",1)
    ....s markid=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(PreIADMId)
    ....q:markid="2"
 	....s Desc=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
 	....s CashAmount=""   ;  按照个人预约查询界面的费用取费用
 	....s IADMCRMADM=$P($G(^DHCPEIADM(IADMId)),"^",4)
 	....;// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
 	....s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	....Q:(""=retvalue)
	....// 作废金额^个人终止金额^公费金额金额
	....s AbortFees="0^0^0^" //##Class(web.DHCPE.InvPrt).GetAdmAbortFee(IADMCRMADM)
	....// 实际金额
	....s CountAmount=+$P(retvalue,"^",2)-$P(AbortFees,"^",1)
	....//自费已付金额
	....s CashAmountMark=""
	....s CashAmountMark=+$P(retvalue,"^",7)
	....i CashAmountMark'="" d
	.....s paadm=$P($G(^DHCPEIADM(IADMId)),"^",1)
	.....s Invrowid=""
	.....f  s Invrowid=$O(^DHCPEINVPRT(0,"ADM",paadm,Invrowid)) q:Invrowid=""  d
 	......s arrcp=$P($G(^DHCPEINVPRT(Invrowid)),"^",4)
 	......s paym="0"
    ......f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
    .......s ss=^ARRCP(arrcp,"PAYM",paym)
    .......s mode=$p(ss,"^",1)
    .......Q:'$D(^CT("CTPM",mode))
    .......s chequeno=$p(ss,"^",4) 
    .......q:mode=""  
    .......i mode'="" s CashAmountDesc=$p(^CT("CTPM",mode),"^",2)
    .......e  s pmdesc="现金"
    .......s pdamt=+$p(ss,"^",3)
    .......i CashAmountDesc["支付" d 
    ........s CashAmount3=pdamt
    .......e  d
    ........s CashAmount2=CashAmount2+pdamt
    ....d ArrearageOutput
    ...e  d
    ....
    ....s StatusBill=$P($G(^DHCPEIADM(IADMId)),"^",3) ;GD
    ....q:StatusBill'["||"
    ....;q:StatusBill'="GD"
 	....s Desc="",CountAmount="",CashAmount1="",CashAmount2="",CashAmount3=""
 	....;.s PreteamId=$P($G(^DHCPEGADM(TeamId)),"^",1)
 	....s Desc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(TeamId)  ;$P($G(^DHCPEPreGBI(PreteamId)),"^",2)
 	....s CashAmount=""   ;  按照个人预约查询界面的费用取费用
 	....s IADMCRMADM=$P($G(^DHCPEIADM(IADMId)),"^",4)
 	....s PIADMPIBIDR2=$P($G(^DHCPEPreIADM(IADMCRMADM)),"^",1)
    ....s markid2=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(PIADMPIBIDR2)
    ....;q:markid2="2"
    ....s markamount1=""
 	....;// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
 	....s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
 	....s markamount1=+$P(retvalue,"^",5)
 	....q:markamount1=""
 	....q:markamount1=0
	....Q:(""=retvalue)
	....// 作废金额^个人终止金额^公费金额金额
	....s AbortFees="0^0^0^" //##Class(web.DHCPE.InvPrt).GetAdmAbortFee(IADMCRMADM)
	....// 实际金额;
	....s CountAmount=+$P(retvalue,"^",2) ;-$P(AbortFees,"^",1)
	....//公费已付金额
	....s CashAmount1=+$P(retvalue,"^",4)
	....d ArrearageOutput
	
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ArrearageOutput
	set Data=$lb(Desc,CountAmount,CashAmount1,CashAmount2,CashAmount3)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArrearageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArrearageExecute ]
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

ClassMethod ArrearageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArrearageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 采血标本统计报表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","LabEpisodeStatistic","2020-05-19","2020-05-20","","","","480")
Query LabEpisodeStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", ReturnFlag As %Library.String = "", RecLoc As %Library.String = "", ItemDesc As %Library.String = "", CTLOCID As %Library.String = "", SpecNoDesc As %Library.String = "") As %Query(ROWSPEC = "RecLocDR:%String,RecLocDesc:%String,ARCIMDesc:%String,TotalNum:%Float,SpecNo:%String,RegNo:%String,Name:%String,Sex:%String,Age:%String,GDesc:%String,TReceiver:%String,TRecDate:%String,TransFlag:%String,RLTUser:%String") [ SqlProc ]
{
}

ClassMethod LabEpisodeStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", ReturnFlag As %Library.String = "", RecLoc As %Library.String = "", ItemDesc As %Library.String = "", CTLOCID As %Library.String = "", SpecNoDesc As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=$j
 	k ^TempDHCPELabEpisode(Job)
 	//s ^DHCPETempLab("20200522",1)=BeginDate_"^"_EndDate_"^"_ReturnFlag_"^"_RecLoc_"^"_ItemDesc_"^"_CTLOCID
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
	s Type="TotalNum"
	i RecLoc'="" s Type="Detail"
 	
 	s PreAudits=""
 	f Date=BeginDate:1:EndDate d
 	.s Time=""    
	.f  s Time=$O(^DHCPETempLabEpisodeScan("Date",Date,Time)) q:Time=""  d
	..s SpecNo=""
	..f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo)) q:SpecNo=""  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo,CTLOCID)         //Add by 090702
    ...q:LocFlag=1  
    ...s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
    ...q:OEORDID=""
    ...s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,0))
    ...s RecLocDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,3)),"^",6)
    ...s OrdItemID=OEORDID_"||"_OEpisNoid
    ...s SpecName=##class(web.DHCPE.BarPrint).GetSpecName(OrdItemID)
    ...s:SpecNoDesc=0 SpecNoDesc="血"
    ...s:SpecNoDesc=1 SpecNoDesc="尿"
    ...s:SpecNoDesc=2 SpecNoDesc="便"
    ...q:(SpecName'[SpecNoDesc)&(SpecNoDesc'="")
    ...q:(RecLoc'="")&&(RecLoc'=RecLocDR)
    ...s ARCIMDesc=##class(web.DHCPE.BarPrint).GetARCIMDesc(SpecNo,OEORDID)
    ...q:(ItemDesc'="")&&(ItemDesc'=ARCIMDesc)
    ...s Flag=##class(web.DHCPE.BarPrintFind).IsReturnResult(SpecNo)
	...q:(ReturnFlag'="")&&(ReturnFlag'=Flag)
	...s RLTUser=""
	...i Flag=1 d
	....s RLTRowID=$O(^DHCPERLT(0,"OEORI",OEORDID_"||"_OEpisNoid,""))
	....q:RLTRowID=""
	....s RLTUser=$p(^DHCPERLT(RLTRowID),"^",5)
	....s:RLTUser'="" RLTUser=$p(^SSU("SSUSR",RLTUser),"^",2)
    ...s ^TempDHCPELabEpisode(Job,"TotalNum",RecLocDR,ARCIMDesc)=$G(^TempDHCPELabEpisode(Job,"TotalNum",RecLocDR,ARCIMDesc))+1
    ...s ^TempDHCPELabEpisode(Job,"Detail",Flag,SpecNo)=RLTUser
    
    i Type="TotalNum" d
    .s RecLocDR=""
    .f  s RecLocDR=$o(^TempDHCPELabEpisode(Job,"TotalNum",RecLocDR)) q:RecLocDR=""  d
    ..d SetEpisodeVariable
    ..s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
    ..s ARCIMDesc=""
    ..f  s ARCIMDesc=$o(^TempDHCPELabEpisode(Job,"TotalNum",RecLocDR,ARCIMDesc)) q:ARCIMDesc=""  d
    ...s TotalNum=$G(^TempDHCPELabEpisode(Job,"TotalNum",RecLocDR,ARCIMDesc))
    ...d OutLabEpisodeInfo
    e  d
    .s Flag=""
    .f  s Flag=$o(^TempDHCPELabEpisode(Job,"Detail",Flag)) q:Flag=""  d
    ..d SetEpisodeVariable
    ..s SpecNo=""
    ..f  s SpecNo=$o(^TempDHCPELabEpisode(Job,"Detail",Flag,SpecNo)) q:SpecNo=""  d
    ...s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
    ...s PAADM=$p(^OEORD(OEORDID),"^",1)
    ...s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    ...q:IADM=""
    ...s PIADM=$p(^DHCPEIADM(IADM),"^",4)
    ...s PIBI=$p(^DHCPEPreIADM(PIADM),"^",1)
    ...s RegNo=$p(^DHCPEPreIBI(PIBI),"^",1)
    ...s Name=$p(^DHCPEPreIBI(PIBI),"^",2)
    ...s Sex=$p(^DHCPEPreIBI(PIBI),"^",3)
    ...s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
    ...s Dob=$p(^DHCPEPreIBI(PIBI),"^",4)
    ...s:Dob'="" Age=##class(web.DHCDocCommon).GetAgeDescNew($zd(Dob,3),"")
    ...s PGADM=$p(^DHCPEPreIADM(PIADM),"^",2)
    ...s GDesc=""
    ...i PGADM'="" d
    ....s PGBI=$p(^DHCPEPreGADM(PGADM),"^",1)
    ....s GDesc=$p(^DHCPEPreGBI(PGBI),"^",2)
    ...s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	...s TReceiver=$P(Info,"^",3)
	...q:TReceiver=""
	...s RLTUser=$G(^TempDHCPELabEpisode(Job,"Detail",Flag,SpecNo))
	...s RecTime=$P(Info,"^",2)
	...s RecDate=$P(Info,"^",1)
	...s:TReceiver'="" TReceiver=$P(^SSU("SSUSR",TReceiver),"^",2)
	...s TRecDate=$ZD(RecDate,3)_" "_$ZT(RecTime)
	...i Flag=0 s TransFlag="未回传"
	...i Flag=1 s TransFlag="已回传"
    ...d OutLabEpisodeInfo
    
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetEpisodeVariable
    s (RecLocDesc,ARCIMDesc)=""  
    s TotalNum=0
    s (SpecNo,RegNo,Name,Sex,Age,GDesc,TReceiver,TRecDate,TransFlag,RLTUser)=""
    
 	q
OutLabEpisodeInfo
	set Data=$lb(RecLocDR,RecLocDesc,ARCIMDesc,TotalNum,SpecNo,RegNo,Name,Sex,Age,GDesc,TReceiver,TRecDate,TransFlag,RLTUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LabEpisodeStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LabEpisodeStatisticExecute ]
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

ClassMethod LabEpisodeStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LabEpisodeStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 患病人数、年龄分段、
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisReport","608")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
/// 体检团体报告润乾 Start  yd
/// -------------------------------------------------------------------------------------------
/// 患病人数、年龄分段、
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisReport","42")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisReport","611")
/// IllID 疾病ID
Query TeamDiagnosisReport(GADMDR As %Library.String = "", Depart As %Library.String = "", Contract As %String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Sex:%String,SexValue:%String,Bob:%String,DeptNo:%String,DiagnosisDesc:%String,One:%String,Two:%String,Three:%String,Four:%String,Five:%String,Six:%String,Seven:%String,FactPerson:%String,ManPerson:%String,WoManPerson:%String,GSDRowId:%String,IllID:%String,Age:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "", Contract As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	k ^TMPGREPORTNew
	k ^DHCPETEMPAdviceNew
 	s ind=1
 	s AgeFrom= 0, AgeTo= 100, AgeStep = 10
 	
 	
 	if (Contract=""){
 	s FactPerson=..GetPerson(GADMDR,"N","",Depart)
 	s ManPerson=..GetManPerson(GADMDR,"N","",Depart)
 	s WoManPerson=..GetWoManPerson(GADMDR,"N","",Depart)
 	
	s DiagnosisSex=""
 	
 	
 	s Name="",RegNo="",Sex="",Bob="",DeptNo="",DiagnosisDesc="",One="",Two="",Three="",Four="",Five="",Six="",Seven="",SexValue=1
 	s SexValue=1
 	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
 	s LocID=$P(^DHCPEPreGADM(PreGADM),"^",23)
 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",LocID)),"^",1)
	
	s PreIADM=0

	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.//b // 1
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s DeptNo=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
	.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
 	.i PAPERDob'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=0
	.i Age<20 s One= 1
	.i ((Age>=20)&(Age<=29)) s Two=1
	.i ((Age>=30)&(Age<=39)) s Three=1
	.i ((Age>=40)&(Age<=49)) s Four=1
	.i ((Age>=50)&(Age<=59)) s Five=1
	.i ((Age>=60)&(Age<=69)) s Six=1
	.i ((Age>=70)) s Seven =1
	.s IsDiagnosis=0
	.s GSRowId=0
	.s Conclus=""  
	.
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
	..q:AuditUser=""  
	../// ^User.DHCPEGSIllnessI("IndexParrefStaIll",31976," 0",42
	.. //  用到的变量 set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,ManPerson,ManPerson,WoManPerson,$g(GSDRowId),OutIllID,Age)
 	.. // DiagnosisSex
 	..s ILLnessID=""
 	..f  s ILLnessID=$o(^User.DHCPEGSIllnessI("IndexParrefStaIll",GSRowId," 0",ILLnessID)) q:(ILLnessID="")  d
 	...//b ///aaa
 	...s GSDRowId="",OutIllID=ILLnessID
	...s DiagnosisSex=$P($G(^DHCPEILLS(ILLnessID)),"^",9)
	...s DiagnosisDesc=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
	...d TeamDiagnosisReportOutput
	...
	..
	..q
	..///////////////////////// 下面的是原来的方式不用了////////////////////////////
	..s MainUser=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR))
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
	...// 当前客户患有疾病
	...q:($p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",11)'=0)
	...S HaveConclusFlag=""    
	...s IsDiagnosis=1    
	...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...s IsActiveDiag=1  /// 存在不规范操作问题，例如选择高血压改成了冠心病，先尝试过滤互相不包含的看看
	...s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRowId_"||"_GSDChildSub))
	...s DiagnoseConclusion=$replace(DiagnoseConclusion,"[","")
	...s DiagnoseConclusion=$replace(DiagnoseConclusion,"]","")
	...i DiagnoseConclusion'="" d
	....s SysDiagnoseConclusion=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	....s:(SysDiagnoseConclusion'[DiagnoseConclusion)||(DiagnoseConclusion'[SysDiagnoseConclusion) IsActiveDiag=0
	...//Q:HaveConclusFlag=1     
    ...///按照疾病统计
    ...s OutIllID=""
	...i DiagnosisType="Y" d
	....
	....s IDRRowID=0
	....f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",Diagnosis,IDRRowID)) q:IDRRowID=""  d
	.....//q:(IsActiveDiag=0)
	.....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	.....///判断某人是否已经在此种疾病列表里面
	.....s Flag=$G(^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID))
	.....q:Flag=1
	.....//b // 1
	.....s ^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID)="1"
	.....s DiagnosisDesc=""
	.....Q:$G(^DHCPEILLS(ILLnessID))=""
	.....//b // 2
	.....s DiagnosisDesc=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
	.....s DiagnosisSex=$P($G(^DHCPEILLS(ILLnessID)),"^",9)
	.....//Q:$g(^DHCPEDataEx("GReport","Conclusion",GADMDR,DiagnosisDesc))'="Y"
	.....s ^DHCPETEMPAdviceNew(GADMDR,"Count",ILLnessID)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",ILLnessID))+1
	.....s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",ILLnessID)=DiagnosisDesc
	.....//b // 3
	.....b:(DiagnosisDesc="单项高血压")
	.....q:$d(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name))  
	.....s ^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name)=ILLnessID_"^"_Sex
	.....;q:DiagnosisDesc'["超重"
	.....//b //
	.....s OutIllID=ILLnessID
	.....d TeamDiagnosisReportOutput
	..../// 原来的 结束
	..../// 增加按照结果和关键字的判断
	....s ILLID=0
	....f  s ILLID=$O(^DHCPEILLS(ILLID)) q:ILLID=""  d
	.....s ILLType=$P(^DHCPEILLS(ILLID),"^",11)
	.....s Advice=$P(^DHCPEILLS(ILLID),"^",3)
	.....s DiagnosisDesc=$p(^DHCPEILLS(ILLID),"^",2)
	.....//q:ILLType'="1"
	.....s GSIllnessID=ILLID
	.....Q:$G(^DHCPEILLS(GSIllnessID))=""
	.....///判断某人是否已经在此种疾病列表里面
	.....s Flag=$G(^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID))
	.....q:Flag=1
	.....b:(Name="于海涛")&&(ILLID=16) ;; 11
	.....s HadCurIll=..JudgeExpress(IADMPAADMDR,ILLID,GSRowId)
	.....//b:(IADMPAADMDR=20007475)
	.....i HadCurIll=1 d
	......b:(Name="于海涛")&&(ILLID=16) ;; 112
	......s ^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID)="1"
	......s ^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID))+1
	......s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",GSIllnessID)=DiagnosisDesc
	......s OutIllID=ILLID
	......d TeamDiagnosisReportOutput
	....// 增加按照结果和关键字的判断  结束
	...e  d   /////按照诊断统计
	....s Status=""
	....s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
	....q:Status'="0"
	....s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	....Set GSDRowId=GSRowId_"||"_GSDChildSub   
	....If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   
	.....Set EDDiagnoseConclus=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
	.....;i EDDiagnoseConclus["]" s EDDiagnoseConclus=$P(EDDiagnoseConclus,"]",1)_"]"  
	....Q:$g(^DHCPEDataEx("GReport","Conclusion",GADMDR,EDDiagnoseConclus))'="Y"
	....s DiagnosisDesc=EDDiagnoseConclus
	....s:DiagnosisDesc["[" DiagnosisDesc=$replace(DiagnosisDesc,"[","")
	....s:DiagnosisDesc["]" DiagnosisDesc=$replace(DiagnosisDesc,"]"," ")
	....s ^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis))+1
	....s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",Diagnosis)=EDDiagnoseConclus
	....q:$d(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name))  // yx  去掉同一个人的相同诊断
    ....s ^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name)=Sex
    ....s OutIllID=Diagnosis
	....d TeamDiagnosisReportOutput
 	}else{
	 	s PreGADM=""
	 	s FactPerson=0
	 	s ManPerson=.0
	 	s WoManPerson=0
	 	for{
		 	
			s PreGADM=$O(^DHCPEPreGADM(0,"Contract",Contract,PreGADM))
			q:(PreGADM="")
			s GADMDR=$o(^DHCPEGADM(0,"CRMGADM",PreGADM,0))
			continue:(GADMDR="")
			s FactPerson=FactPerson+..GetPerson(GADMDR,"N","",Depart)
		 	s ManPerson=ManPerson+..GetManPerson(GADMDR,"N","",Depart)
		 	s WoManPerson=WoManPerson+..GetWoManPerson(GADMDR,"N","",Depart)
		}
		
		
		
		s PreGADM=""
	 	
	 	for{
		 	
			s PreGADM=$O(^DHCPEPreGADM(0,"Contract",Contract,PreGADM))
			q:(PreGADM="")
			s GADMDR=$o(^DHCPEGADM(0,"CRMGADM",PreGADM,0))
			continue:(GADMDR="")
			s DiagnosisSex=""
 	
 	
		 	s Name="",RegNo="",Sex="",Bob="",DeptNo="",DiagnosisDesc="",One="",Two="",Three="",Four="",Five="",Six="",Seven="",SexValue=1
		 	s SexValue=1
		 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
			s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
			s PreIADM=0

			f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
			.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
			.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
			.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
			.q:Status="CANCELPREREG"
			.q:Status="CANCELPE"
			.//b // 1
			.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
			.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
			.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
			.q:IADMRowId=""
			.s DeptNo=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
			.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
			.Q:(""=IADMPAADMDR)
			.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
			.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
			.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
			.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
			.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
			.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
			.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
		 	.i PAPERDob'="" d
		 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
		 	..s Age=+$P(Age,"Y",1)
		 	..s PAPERDob=$ZD(PAPERDob,3)
			.e  d
			..s Age=0
			.i Age<20 s One= 1
			.i ((Age>=20)&(Age<=29)) s Two=1
			.i ((Age>=30)&(Age<=39)) s Three=1
			.i ((Age>=40)&(Age<=49)) s Four=1
			.i ((Age>=50)&(Age<=59)) s Five=1
			.i ((Age>=60)&(Age<=69)) s Six=1
			.i ((Age>=70)) s Seven =1
			.s IsDiagnosis=0
			.s GSRowId=0
			.s Conclus=""  
			.
			.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
			..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
			..q:AuditUser=""  
			../// ^User.DHCPEGSIllnessI("IndexParrefStaIll",31976," 0",42
			.. //  用到的变量 set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,ManPerson,ManPerson,WoManPerson,$g(GSDRowId),OutIllID,Age)
		 	.. // DiagnosisSex
		 	..s ILLnessID=""
		 	..f  s ILLnessID=$o(^User.DHCPEGSIllnessI("IndexParrefStaIll",GSRowId," 0",ILLnessID)) q:(ILLnessID="")  d
		 	...s GSDRowId="",OutIllID=ILLnessID
			...s DiagnosisSex=$P($G(^DHCPEILLS(ILLnessID)),"^",9)
			...s DiagnosisDesc=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
			...//b:(DiagnosisDesc="")
			...d TeamDiagnosisReportOutput
			...
			..
			..q
			..
			..s MainUser=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR))
			..s GSDChildSub=0
			..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
			...// 当前客户患有疾病
			...q:($p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",11)'=0)
			...S HaveConclusFlag=""    
			...s IsDiagnosis=1    
			...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
			...s IsActiveDiag=1  /// 存在不规范操作问题，例如选择高血压改成了冠心病，先尝试过滤互相不包含的看看
			...s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRowId_"||"_GSDChildSub))
			...s DiagnoseConclusion=$replace(DiagnoseConclusion,"[","")
			...s DiagnoseConclusion=$replace(DiagnoseConclusion,"]","")
			...i DiagnoseConclusion'="" d
			....s SysDiagnoseConclusion=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
			....s:(SysDiagnoseConclusion'[DiagnoseConclusion)||(DiagnoseConclusion'[SysDiagnoseConclusion) IsActiveDiag=0
			...//Q:HaveConclusFlag=1     
		    ...///按照疾病统计
		    ...s OutIllID=""
			...i DiagnosisType="Y" d
			....
			....s IDRRowID=0
			....f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",Diagnosis,IDRRowID)) q:IDRRowID=""  d
			.....//q:(IsActiveDiag=0)
			.....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
			.....///判断某人是否已经在此种疾病列表里面
			.....s Flag=$G(^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID))
			.....q:Flag=1
			.....//b // 1
			.....s ^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID)="1"
			.....s DiagnosisDesc=""
			.....Q:$G(^DHCPEILLS(ILLnessID))=""
			.....//b // 2
			.....s DiagnosisDesc=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
			.....s DiagnosisSex=$P($G(^DHCPEILLS(ILLnessID)),"^",9)
			.....//Q:$g(^DHCPEDataEx("GReport","Conclusion",GADMDR,DiagnosisDesc))'="Y"
			.....s ^DHCPETEMPAdviceNew(GADMDR,"Count",ILLnessID)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",ILLnessID))+1
			.....s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",ILLnessID)=DiagnosisDesc
			.....//b // 3
			.....b:(DiagnosisDesc="单项高血压")
			.....q:$d(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name))  
			.....s ^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name)=ILLnessID_"^"_Sex
			.....;q:DiagnosisDesc'["超重"
			.....//b //
			.....s OutIllID=ILLnessID
			.....d TeamDiagnosisReportOutput
			..../// 原来的 结束
			..../// 增加按照结果和关键字的判断
			....s ILLID=0
			....f  s ILLID=$O(^DHCPEILLS(ILLID)) q:ILLID=""  d
			.....s ILLType=$P(^DHCPEILLS(ILLID),"^",11)
			.....s Advice=$P(^DHCPEILLS(ILLID),"^",3)
			.....s DiagnosisDesc=$p(^DHCPEILLS(ILLID),"^",2)
			.....//q:ILLType'="1"
			.....s GSIllnessID=ILLID
			.....Q:$G(^DHCPEILLS(GSIllnessID))=""
			.....///判断某人是否已经在此种疾病列表里面
			.....s Flag=$G(^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID))
			.....q:Flag=1
			.....b:(Name="于海涛")&&(ILLID=16) ;; 11
			.....s HadCurIll=..JudgeExpress(IADMPAADMDR,ILLID,GSRowId)
			.....//b:(IADMPAADMDR=20007475)
			.....i HadCurIll=1 d
			......b:(Name="于海涛")&&(ILLID=16) ;; 112
			......s ^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID)="1"
			......s ^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID))+1
			......s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",GSIllnessID)=DiagnosisDesc
			......s OutIllID=ILLID
			......d TeamDiagnosisReportOutput
			....// 增加按照结果和关键字的判断  结束
			...e  d   /////按照诊断统计
			....s Status=""
			....s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
			....q:Status'="0"
			....s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
			....Set GSDRowId=GSRowId_"||"_GSDChildSub   
			....If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   
			.....Set EDDiagnoseConclus=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
			.....;i EDDiagnoseConclus["]" s EDDiagnoseConclus=$P(EDDiagnoseConclus,"]",1)_"]"  
			....Q:$g(^DHCPEDataEx("GReport","Conclusion",GADMDR,EDDiagnoseConclus))'="Y"
			....s DiagnosisDesc=EDDiagnoseConclus
			....s:DiagnosisDesc["[" DiagnosisDesc=$replace(DiagnosisDesc,"[","")
			....s:DiagnosisDesc["]" DiagnosisDesc=$replace(DiagnosisDesc,"]"," ")
			....s ^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis))+1
			....s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",Diagnosis)=EDDiagnoseConclus
			....q:$d(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name))  // yx  去掉同一个人的相同诊断
		    ....s ^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",DiagnosisDesc,Name)=Sex
		    ....s OutIllID=Diagnosis
			....d TeamDiagnosisReportOutput
	
		}
 	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisReportOutput
	q:(DiagnosisDesc="")
	/// 按照性别输出 ,只有总人数不同
	if DiagnosisSex="M"{
		d RealOut3
	}elseif (DiagnosisSex="F"){
		d RealOut3
	}else{
		d RealOut3
	}
	q
RealOut1
	set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,ManPerson,ManPerson,WoManPerson,$g(GSDRowId),OutIllID,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
RealOut2
	set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,WoManPerson,ManPerson,WoManPerson,$g(GSDRowId),OutIllID,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
RealOut3
	set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,FactPerson,ManPerson,WoManPerson,$g(GSDRowId),OutIllID,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisName","19","")
Query TeamDiagnosisName(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "DiagnosisDesc:%String,NameStr:%String,num:%String,CNumberName:%String,ILLnessDc:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisNameExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s FactPerson=..GetPerson(GADMDR)
 	s ManPerson=..GetManPerson(GADMDR)
 	s WoManPerson=..GetWoManPerson(GADMDR)
 	
 	
 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
 	s Diagnosis=0,Number=0,TempILLnessDetailed=""
 	f  s Diagnosis=$o(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",Diagnosis)) q:Diagnosis=""  d
 	.s Name=0,i=0,Sexlimit="",Rate=0,DiagnosisMan=0,DiagnosisWoMan=0
 	.s NameStr="",ILLnessDetailed="",ILLnessDescDetailed="",CNumberName=""
 	.f  s Name=$o(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",Diagnosis,Name)) q:Name=""  d
 	..i NameStr="" s NameStr=Name
 	..e  s NameStr=NameStr_"，"_Name
 	..i $p($g(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",Diagnosis,Name)),"^",2)["男" s DiagnosisMan=DiagnosisMan+1
 	..i $p($g(^DHCPETEMPAdviceNew(GADMDR,"Diagnosis_Name",Diagnosis,Name)),"^",2)["女" s DiagnosisMan=DiagnosisWoMan+1
 	..s i=i+1
 	.i DiagnosisType="Y"  d 
 	..s DiagnosisId=$o(^DHCPEILLS(0,"Desc",Diagnosis,0)) //只有疾病才有疾病描述,诊断需要加载诊断意见(未加)
 	..b:(DiagnosisId="")
 	..s Sexlimit=$p($g(^DHCPEILLS(DiagnosisId)),"^",9)
 	..i $d(^DHCPEDataEx("BaseData","IllnessStandard","IllExplain",DiagnosisId)) s ILLnessDetailed=$p($g(^DHCPEDataEx("BaseData","IllnessStandard","IllExplain",DiagnosisId)),"@@",1)
 	.i ILLnessDetailed'=""  d
 	..i Sexlimit="" d
 	...s Rate=$FN((i/FactPerson)*100,"",2)_"%"
 	...s ILLnessDescDetailed="  本次体检共检出"_Diagnosis_i_"人（男"_DiagnosisMan_"人，女"_DiagnosisWoMan_"人），检出率"_Rate_"。"_$c(10)_ILLnessDetailed
 	..e  d
 	...s Rate=$FN((i/WoManPerson)*100,"",2)_"%"
 	...s ILLnessDescDetailed="  本次体检有"_i_"名女性员工查出"_Diagnosis_"，占女性总数的"_Rate_"。"_$c(10)_ILLnessDetailed 
 	..s Number=Number+1
 	.s TempILLnessDetailed($j,"ILLness","Detailed",i,Diagnosis)=$LB(NameStr,ILLnessDescDetailed)
 	b 
 	s num="",NameStr="",count=1
 	f  s num=$o(TempILLnessDetailed($j,"ILLness","Detailed",num),-1) q:num=""  d
 	.s DiagnosisDesc=""
 	.f  s DiagnosisDesc=$o(TempILLnessDetailed($j,"ILLness","Detailed",num,DiagnosisDesc)) q:DiagnosisDesc=""  d
 	..s ILLnessDc="",CNumberName=""
 	..s NameStr=$list(TempILLnessDetailed($j,"ILLness","Detailed",num,DiagnosisDesc),1)
 	..s ILLnessDc=$list(TempILLnessDetailed($j,"ILLness","Detailed",num,DiagnosisDesc),2)
 	..i ILLnessDc'=""  d
 	...s CNumberName=count //##class(web.DHCPE.Public.Tools).ChinaSerialNumber(count)
 	...s ^TempILLnessDetailed("ILLness","Detailed",count,CNumberName)=ILLnessDc_"^"_DiagnosisDesc
 	...s count=count+1
	..d TeamDiagnosisNametOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisNametOutput

	set Data=$lb(DiagnosisDesc,NameStr,num,CNumberName,ILLnessDc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamDiagnosisNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamDiagnosisNameExecute ]
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

ClassMethod TeamDiagnosisNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamDiagnosisNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(web.DHCPE.Query.RunQian.TJZY).GetPerson("609","Y","4")

/// 得到团体受检人数
/// Input: isAll 是否全部
/// 			N 只取已检人数 Y 全部人数
ClassMethod GetPerson(GADMDR, isAll As %String = "N", Contract As %String = "", Depart As %String = "")
{
	if (Contract'="")
	{
		s GADMDR=""
		s FactPerson=0
		s id=0
		for{  
			s id=$O(^DHCPEPreGADM(0,"Contract",Contract,id)) 
			q:id=""
			s PreGADM=id //$P(^DHCPEGADM(id),"^",2)
			
			s PreIADM=0
			f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
			.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
			.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
			.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
			.q:Status="CANCELPREREG"
			.q:Status="CANCELPE"
			.//b:(Status'="ARRIVED")&&(isAll="N")
			.//b:(Status'="ARRIVED")
			.q:(Status'="ARRIVED")&&(isAll="N")
			.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
			.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
			.s FactPerson=FactPerson+1
		}
		
	}else{
	
		s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
		s FactPerson=0
		s PreIADM=0
		f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
		.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
		.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
		.q:Status="CANCELPREREG"
		.q:Status="CANCELPE"
		.q:(Status'="ARRIVED")&&(isAll="N")
		.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
		.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
		.s FactPerson=FactPerson+1
	
	}
	
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQian.TJZY).GetManPerson("15")

/// 得到团体受检男性人数
ClassMethod GetManPerson(GADMDR, isAll As %String = "N", Contract As %String = "", Depart As %String = "")
{
	
	if (Contract'="")
	{
		s GADMDR=""
		s FactPerson=0
		s id=0
		for{  
			s id=$O(^DHCPEPreGADM(0,"Contract",Contract,id)) 
			q:id=""
			s PreGADM=id //$P(^DHCPEGADM(id),"^",2)
			
			s PreIADM=0
			f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
			.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
			.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
			.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
			.q:Status="CANCELPREREG"
			.q:Status="CANCELPE"
			.q:(Status'="ARRIVED")&&(isAll="N")
			.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
			.q:IADMRowId=""
			.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
			.Q:(""=IADMPAADMDR)
			.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
			.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
			.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
			.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
			.q:Sex'="男"
			.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
			.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
			.s FactPerson=FactPerson+1
		}
		
	}else{
	
		s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
		s FactPerson=0
		s PreIADM=0
		f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
		.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
		.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
		.q:Status="CANCELPREREG"
		.q:Status="CANCELPE"
		.q:Status'="ARRIVED"&&(isAll="N")
		.
		.
		.
		.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
		.q:IADMRowId=""
		.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
		.Q:(""=IADMPAADMDR)
		.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
		.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
		.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
		.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
		.q:Sex'="男"
		.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
		.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
		.s FactPerson=FactPerson+1
	}
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQian.TJZY).GetWoManPerson("15")

/// 得到团体受检女性人数
ClassMethod GetWoManPerson(GADMDR, isAll As %String = "N", Contract As %String = "", Depart As %String = "")
{
	
	if (Contract'="")
	{
		s GADMDR=""
		s FactPerson=0
		s id=0
		for{  
			s id=$O(^DHCPEPreGADM(0,"Contract",Contract,id)) 
			q:id=""
			s PreGADM=id //$P(^DHCPEGADM(id),"^",2)
			
			s PreIADM=0
			f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
			.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
			.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
			.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
			.q:Status="CANCELPREREG"
			.q:Status="CANCELPE"
			.q:(Status'="ARRIVED")&&(isAll="N")
			.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
			.q:IADMRowId=""
			.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
			.Q:(""=IADMPAADMDR)
			.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
			.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
			.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
			.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
			.q:Sex'="女"
			.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
			.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
			.s FactPerson=FactPerson+1
		}
		
	}else{
	
		s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
		s FactPerson=0
		s PreIADM=0
		f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
		.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
		.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
		.q:Status="CANCELPREREG"
		.q:Status="CANCELPE"
		.q:Status'="ARRIVED"&&(isAll="N")
		.
		.
		.
		.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
		.q:IADMRowId=""
		.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
		.Q:(""=IADMPAADMDR)
		.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
		.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
		.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
		.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
		.q:Sex'="女"
		.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
		.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
		.s FactPerson=FactPerson+1
	}
	q FactPerson
}

ClassMethod TeamDiagnosisReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamDiagnosisReportExecute ]
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

ClassMethod TeamDiagnosisReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamDiagnosisReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 体检人员年龄分布图
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamReport","19")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
Query TeamReport(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "Agegroup:%String,NNumber:%String,WNumber:%String,Number:%String") [ SqlProc ]
{
}

ClassMethod TeamReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	s AgeFrom= 0, AgeTo= 100, AgeStep = 10
 	s Sex="",SexValue=1,NOne=0,NTwo=0,NThree=0,NFour=0,NFive=0,NSix=0,NSeven=0
  	s WOne=0,WTwo=0,WThree=0,WFour=0,WFive=0,WSix=0,WSeven=0
  	s Number=0,NNumber=0,WNumber=0
 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"        
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$")))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
 	.i PAPERDob'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=0
	.i Sex="男"  d
	..i Age<20 s NOne=NOne+ 1
	..i ((Age>=20)&(Age<=29)) s NTwo=NTwo+1
	..i ((Age>=30)&(Age<=39)) s NThree=NThree+1
	..i ((Age>=40)&(Age<=49)) s NFour=NFour+1
	..i ((Age>=50)&(Age<=59)) s NFive=NFive+1
	..i ((Age>=60)&(Age<=69)) s NSix=NSix+1
	..i ((Age>=70)) s NSeven =NSeven+1
  	.e  d
  	..i Age<20 s WOne=WOne+ 1
	..i ((Age>=20)&(Age<=29)) s WTwo=WTwo+1
	..i ((Age>=30)&(Age<=39)) s WThree=WThree+1
	..i ((Age>=40)&(Age<=49)) s WFour=WFour+1
	..i ((Age>=50)&(Age<=59)) s WFive=WFive+1
	..i ((Age>=60)&(Age<=69)) s WSix=WSix+1
	..i ((Age>=70)) s WSeven =WSeven+1
	

	i (WOne'=0)||(NOne'=0)   d
	.s Agegroup="0-20岁",Number=WOne+NOne,NNumber=NOne,WNumber=WOne
	.d TeamReportOutput
	i (WTwo'=0)||(NTwo'=0)   d
	.s Agegroup="20-29岁",Number=NTwo+WTwo,NNumber=NTwo,WNumber=WTwo
	.d TeamReportOutput
	i (WThree'=0)||(NThree'=0)   d
	.s Agegroup="30-39岁",Number=WThree+NThree,NNumber=NThree,WNumber=WThree
	.d TeamReportOutput
	i (WFour'=0)||(NFour'=0)   d
	.s Agegroup="40-49岁",Number=WFour+NFour,NNumber=NFour,WNumber=WFour
	.d TeamReportOutput
	i (WFive'=0)||(NFive'=0)   d
	.s Agegroup="50-59岁",Number=WFive+NFive,NNumber=NFive,WNumber=WFive
	.d TeamReportOutput
	i (WSix'=0)||(NSix'=0)   d
	.s Agegroup="60-69岁",Number=WSix+NSix,NNumber=NSix,WNumber=WSix
	.d TeamReportOutput
	i (WSeven'=0)||(NSeven'=0)   d
	.s Agegroup="70岁以上",Number=WSeven+NSeven,NNumber=NSeven,WNumber=WSeven
	.d TeamReportOutput

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamReportOutput

	set Data=$lb(Agegroup,NNumber,WNumber,Number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamReportExecute ]
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

ClassMethod TeamReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 体检单位基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamBaseInfo","19")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamBaseInfo(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "GroupNameYear:%String,GroupName:%String,PreDate:%String,PrintDate:%String,FactPerson:%String,ManPerson:%String,WoManPerson:%String") [ SqlProc ]
{
}

ClassMethod TeamBaseInfoExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s TeamType=""
	
	
 	s ind=1
	//  DHC_PE_GADM.{ GADM_GBI_DR}
	s GBIDR=$P($G(^DHCPEGADM(GADMDR)),"^",1)
	s CRMID=$P($G(^DHCPEGADM(GADMDR)),"^",2)
	s StartDate=$P($G(^DHCPEPreGADM(CRMID)),"^",2)
	i StartDate'="" s StartDate=$ZD(StartDate,3)
	s EndDate=$P($G(^DHCPEPreGADM(CRMID)),"^",3)
	i EndDate'="" s EndDate=$ZD(EndDate,3)
	s Year=$p(EndDate,"-",1)
	s PreDate=$p(StartDate,"-",1)_"年"_$p(StartDate,"-",2)_"月"_$p(StartDate,"-",3)_"日-"_$p(EndDate,"-",1)_"年"_$p(EndDate,"-",2)_"月"_$p(EndDate,"-",3)_"日"
	s GroupName=$P($G(^DHCPEGBI(GBIDR)),"^",2)
	s GroupNameYear=GroupName_Year
	s PrintDate=$p($ZD($H,3),"-",1)_"年 "_$p($ZD($H,3),"-",2)_"月 "_$p($ZD($H,3),"-",3)_"日 "
	s FactPerson=##class(web.DHCPE.Query.RunQian.TJZY).GetPerson(GADMDR)
	s ManPerson=##class(web.DHCPE.Query.RunQian.TJZY).GetManPerson(GADMDR)
	s WoManPerson=##class(web.DHCPE.Query.RunQian.TJZY).GetWoManPerson(GADMDR)
	d TeamBaseInfoOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamBaseInfoOutput

	set Data=$lb(GroupNameYear,GroupName,PreDate,PrintDate,FactPerson,ManPerson,WoManPerson)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamBaseInfoExecute ]
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

ClassMethod TeamBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 体检单位医嘱信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamOrdItem","19")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamOrdItem(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "OrderName:%String") [ SqlProc ]
{
}

ClassMethod TeamOrdItemExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s TeamType=""
	k ^DHCPETempARCIMOrdItem
	
 	s ind=1
	//  DHC_PE_GADM.{ GADM_GBI_DR}
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
    s ChildSub=0
    f  s ChildSub=$O(^DHCPEPreGADM(PreGADM,"Team",ChildSub)) q:ChildSub=""  d
    .s TeamId=PreGADM_"||"_ChildSub
    .s ItemSubId=0
    .f  s ItemSubId=$O(^DHCPEPreGADM(PreGADM,"Team",ChildSub,"ORDITEM",ItemSubId)) q:ItemSubId=""  d
    ..s ArcItemId=$p($G(^DHCPEPreGADM(PreGADM,"Team",ChildSub,"ORDITEM",ItemSubId)),"^",1)
    ..s StationID=$O(^DHCPEST(0,"STORD_ARCIM",ArcItemId,0))
    ..q:StationID=""
    ..s ^DHCPETempARCIMOrdItem(TeamId,"ArcItemId",StationID,ArcItemId)=""
	
	s TeamId=0
	f  s TeamId=$O(^DHCPETempARCIMOrdItem(TeamId))  q:TeamId=""  d 
	.s PreGADM=$p(TeamId,"||",1),ChildSub=$p(TeamId,"||",2)
	.s TeamDesc=$p(^DHCPEPreGADM(PreGADM,"Team",ChildSub),"^",1)
	.s StationID="",OrderName=""
	.f  s StationID=$O(^DHCPETempARCIMOrdItem(TeamId,"ArcItemId",StationID)) q:StationID=""  d
	..s ordMastId=""
	..q:StationID=34
	..f  s ordMastId=$O(^DHCPETempARCIMOrdItem(TeamId,"ArcItemId",StationID,ordMastId)) q:ordMastId=""  d
	...s ARCIMDesc=$P($G(^ARCIM($P(ordMastId,"||",1),$P(ordMastId,"||",2),1)),"^",2)
	...s:ARCIMDesc["(体检)" ARCIMDesc=$p(ARCIMDesc,"(体检)",2)
	...i OrderName="" d
	....s OrderName=TeamDesc_"组:  "_ARCIMDesc
	...e  d
	....s OrderName=OrderName_"、"_ARCIMDesc
	.d TeamOrdItemOutput
	

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamOrdItemOutput

	set Data=$lb(OrderName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamOrdItemExecute ]
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

ClassMethod TeamOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 体检单位疾病、疾病建议信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamAdvice","15")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamAdvice(GADMDR As %Library.String = "") As %Query(ROWSPEC = "Advice:%String") [ SqlProc ]
{
}

ClassMethod TeamAdviceExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s Advice=""
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	;^DHCPETEMPAdviceNew("ILLnessID",36)	=	"超重"
 	s ind=1
 	s num=0,Count=0,SumCount=0
 	s SumCount=..GetPersonNew(GADMDR)
	s illId=0
	f  s illId=$O(^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",illId)) q:illId=""  d
	.s Desc=$G(^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",illId))
	.i DiagnosisType="Y" d
	..s Detail=$P(^DHCPEILLS(illId),"^",3)
	.e  d
	..s Detail=$G(^DHCPEED(illId,"Detail"))
	.i Detail="默认" s Detail=""
	.s Count=$G(^DHCPETEMPAdviceNew(GADMDR,"Count",illId))
	.s point=($FN((Count/SumCount),"",4))*100_"%"
	.;检出人数为112例，占体检总人数的
	.s num=num+1
	.s Advice=num_"、"_Desc_$C(10,13)_"    检出人数为 "_Count_"例，占体检总人数的"_point_"。"_$C(10,13)_"    建议："_Detail_$C(10,13)
	.d TeamAdviceOutput	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamAdviceOutput

	set Data=$lb(Advice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamAdviceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamAdviceExecute ]
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

ClassMethod TeamAdviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamAdviceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 团体体检结果综述
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisReportNew","608") 
Query TeamDiagnosisReportNew(GADMDR As %Library.String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Sex:%String,Tel:%String,Age:%String,DiagnosisDesc:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisReportNewExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Name="",RegNo="",Sex="",Tel="",Age="",DiagnosisDesc="",DiagnoseConclusion=""
	.k ^DHCPETEMPTeamDiagnosisReportNew
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s PIADMPIBIDR=""
	.s PIADMPIBIDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	.i ""'=PIADMPIBIDR  d       //身份证号     //Add
    ..s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6)       //联系电话       //Add
	..i Tel="" s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7)
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
	.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
 	.i PAPERDob'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=""
	.
	.s GSRowId=0
	.s Conclus=""  
	.
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
	..q:AuditUser=""  
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
	...s EDID=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...q:EDID=""
	...s StationDR=$p(^DHCPEED(EDID,1),"^",7)      //add 20161013
	...;s Station=$p(^DHCPEST(StationDR),"^",2)
	...s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
	...Set GSDRowId=GSRowId_"||"_GSDChildSub   //Add 20080728
	...If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   //Add 20080728
	....Set DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))   //Add 20080728
	...i '$D(^DHCPETEMPTeamDiagnosisReportNew(StationDR)) d
	....s ^DHCPETEMPTeamDiagnosisReportNew(StationDR)=DiagnoseConclusion
	...e  d
	....s ^DHCPETEMPTeamDiagnosisReportNew(StationDR)=$G(^DHCPETEMPTeamDiagnosisReportNew(StationDR))_"  "_DiagnoseConclusion
	.s StationID=""
	.f  s StationID=$O(^DHCPETEMPTeamDiagnosisReportNew(StationID)) q:StationID=""  d
	..s Station=$p(^DHCPEST(StationID),"^",2)
	..
	..i DiagnosisDesc="" d
	...s DiagnosisDesc=Station_":"_$G(^DHCPETEMPTeamDiagnosisReportNew(StationID))
	..e  d
	...s DiagnosisDesc=DiagnosisDesc_"   "_Station_":"_$G(^DHCPETEMPTeamDiagnosisReportNew(StationID))
	.d TeamDiagnosisReportNewOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisReportNewOutput

	set Data=$lb(Name,RegNo,Sex,Tel,Age,DiagnosisDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

// w d ##class(web.DHCPE.Query.RunQian.TJZY).GetPerson("15")

/// 得到团体受检人数
ClassMethod GetPersonNew(GADMDR)
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.s FactPerson=FactPerson+1
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQian.TJZY).GetManPerson("15")

/// 得到团体受检男性人数
ClassMethod GetManPersonNew(GADMDR)
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.
	.
	.
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.q:Sex'="男"
	.s FactPerson=FactPerson+1
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQian.TJZY).GetWoManPerson("15")

/// 得到团体受检女性人数
ClassMethod GetWoManPersonNew(GADMDR)
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.q:Sex'="女"
	.s FactPerson=FactPerson+1
	q FactPerson
}

ClassMethod TeamDiagnosisReportNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamDiagnosisReportNewExecute ]
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

ClassMethod TeamDiagnosisReportNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamDiagnosisReportNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 体检单位基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamBaseInfoNew","15")
Query TeamBaseInfoNew(GADMDR As %Library.String = "") As %Query(ROWSPEC = "GroupName:%String,FactPerson:%String,ManPerson:%String,WoManPerson:%String") [ SqlProc ]
{
}

ClassMethod TeamBaseInfoNewExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s TeamType=""
	s FactPerson=..GetPersonNew(GADMDR)
 	s ManPerson=..GetManPersonNew(GADMDR)
 	s WoManPerson=..GetWoManPersonNew(GADMDR)
	
 	s ind=1
	//  DHC_PE_GADM.{ GADM_GBI_DR}
	s GBIDR=$P($G(^DHCPEGADM(GADMDR)),"^",1)
	s CRMID=$P($G(^DHCPEGADM(GADMDR)),"^",2)
	
	s GroupName=$P($G(^DHCPEGBI(GBIDR)),"^",2)
	d TeamBaseInfoOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamBaseInfoOutput

	set Data=$lb(GroupName,FactPerson,ManPerson,WoManPerson)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamBaseInfoNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamBaseInfoNewExecute ]
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

ClassMethod TeamBaseInfoNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamBaseInfoNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 团体人员信息以及诊断
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamDiagnosisPersonReport","2") 
Query TeamDiagnosisPersonReport(GADMDR As %Library.String = "", Depart As %Library.String = "", Contract As %Library.String = "", LocID As %String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Sex:%String,Tel:%String,Age:%String,DiagnosisDesc:%String,Contentgather:%String,DeptNo:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisPersonReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "", Contract As %Library.String = "", LocID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s:(GADMDR="") GADMDR=Contract_"-"_Depart
 	k ^TempDHCPEGDiagnoseConclusion(GADMDR)
 	if (Contract=""){
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Name="",RegNo="",Sex="",Tel="",Age="",DiagnosisDesc="",DiagnoseConclusion=""      
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE" 
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
	.s PIADMPIBIDR=""
	.s PIADMPIBIDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	.i ""'=PIADMPIBIDR  d       //身份证号     //Add
    ..s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6)       //联系电话       //Add
	..i Tel="" s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7)
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
	.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
 	.i PAPERDob'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..s PAPERDob=$ZD(PAPERDob,3)
	.e  d
	..s Age=""
	.s Contentgather=""
	.s GSRowId=0
	.s Conclus=""  
	.s conclutionindex=1
	.k ^DHCPETMP("TeamDiagnosisPersonReport")
	.//q:(IADMPAADMDR'=152914)
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
	..q:AuditUser=""  
	..s GSDChildSub=0
	..s Contentgather=##Class(web.DHCPE.ReportGetInfor).GetStationSummarizegather(GSRowId)
	..//b:(IADMPAADMDR=152914)  //1
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
	...s EDID=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...q:EDID=""
	...s Status=""
	...s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
	...q:Status'=0
	...//i DiagnosisType'="Y"  d
	...i 1  d
	....
	....;w !,
	....Set GSDRowId=GSRowId_"||"_GSDChildSub   //Add 20080728
	....If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   //Add 20080728
	.....Set DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))   //Add 20080728
	.....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion,$C(10),"")
	.....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion," ","")
	.....s:DiagnoseConclusion["[" DiagnoseConclusion=$replace(DiagnoseConclusion,"[","")
	.....s:DiagnoseConclusion["]" DiagnoseConclusion=$replace(DiagnoseConclusion,"]"," ")
	....s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
	....s STID=$p($g(^DHCPEED(EDID,"1")),"^",7)
	....s STIndex=9999
	....//b:(IADMPAADMDR=152914)  // 2
	....i STID'="" d
	.....s STIndex=$p(^DHCPEST(STID),"^",9),StName=$p(^DHCPEST(STID),"^",2)
	.....s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STID,""))
    .....q:StatSetID=""
    .....s STIndex=$lg($g(^CF.PE.StationSetD(StatSetID)),5)
	....s ^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId)=DiagnoseConclusion
	....
	...e  d
	....s IDRRowID=0,DiagnoseConclusion=""
	....f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRRowID)) q:IDRRowID=""  d
	.....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	.....s ^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID)="1"
	.....Q:$G(^DHCPEILLS(ILLnessID))=""
	.....s IILConclusion=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
	.....q:$d(^TempDHCPEGDiagnoseConclusion(GADMDR,"IADM",IILConclusion,IADMRowId))
	.....s ^TempDHCPEGDiagnoseConclusion(GADMDR,"IADM",IILConclusion,IADMRowId)=""
	.....s DiagnoseConclusion=IILConclusion
	...;b ;DiagnoseConclusion
	...;i DiagnosisDesc="" s DiagnosisDesc=conclutionindex_"、"_DiagnoseConclusion
	...;e  i DiagnoseConclusion'="" s DiagnosisDesc=DiagnosisDesc_"<br>"_conclutionindex_"、"_DiagnoseConclusion
	...;s conclutionindex=conclutionindex+1
	.s STIndex=0
	.//b 
	.for  s STIndex=$o(^DHCPETMP("TeamDiagnosisPersonReport",STIndex)) q:(STIndex="")  d
	..s GSDRowId=""
	..for  s GSDRowId=$o(^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId)) q:(GSDRowId="")  d
	...s DiagnoseConclusion=$g(^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId))
	...s:(DiagnosisDesc'="") DiagnosisDesc=DiagnosisDesc_"<br>"_conclutionindex_"、"_DiagnoseConclusion
	...s:(DiagnosisDesc="") DiagnosisDesc=conclutionindex_"、"_DiagnoseConclusion
	...s conclutionindex=conclutionindex+1
	.//b:(IADMPAADMDR=152914)
	.i DiagnosisDesc="" s DiagnosisDesc="本次体检未见异常"
	.//s Contentgather=$G(^DHCPENetReport("Result",IADMPAADMDR,"Contentgather"))
	.s DeptNo=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
	.d TeamDiagnosisPersonReportOutput
 	}else{
	 	
	 	s id=""	
		for{
			s id=$O(^DHCPEPreGADM(0,"Contract",Contract,id))
			q:(id="")
	 	
			s PreGADM=id //$P(^DHCPEGADM(GADMDR),"^",2)
			s PreIADM=0
			s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
			f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
			.s Name="",RegNo="",Sex="",Tel="",Age="",DiagnosisDesc="",DiagnoseConclusion=""      
			.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
			.q:Status="CANCELPREREG"
			.q:Status="CANCELPE" 
			.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
			.q:(Depart'="")&&(("$"_Depart_"$")'[("$"_TPosition_"$"))
			.s PIADMPIBIDR=""
			.s PIADMPIBIDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
			.i ""'=PIADMPIBIDR  d       //身份证号     //Add
		    ..s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6)       //联系电话       //Add
			..i Tel="" s Tel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7)
			.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
			.q:IADMRowId=""
			.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
			.Q:(""=IADMPAADMDR)
			.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
			.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
			.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
			.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
			.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
			.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
			.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
		 	.i PAPERDob'="" d
		 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
		 	..s Age=+$P(Age,"Y",1)
		 	..s PAPERDob=$ZD(PAPERDob,3)
			.e  d
			..s Age=""
			.s Contentgather=""
			.s GSRowId=0
			.s Conclus=""  
			.s conclutionindex=1
			.k ^DHCPETMP("TeamDiagnosisPersonReport")
			.
			.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
			..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
			..q:AuditUser=""  
			..s GSDChildSub=0
			..s Contentgather=##Class(web.DHCPE.ReportGetInfor).GetStationSummarizegather(GSRowId)
			..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
			...s EDID=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
			...q:EDID=""
			...s Status=""
			...s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
			...q:Status'=0
			...//i DiagnosisType'="Y"  d
			...i 1  d
			
			...;w !,
			....Set GSDRowId=GSRowId_"||"_GSDChildSub   //Add 20080728
			....If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   //Add 20080728
			.....Set DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))   //Add 20080728
			.....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion,$C(10),"")
			.....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion," ","")
			.....s:DiagnoseConclusion["[" DiagnoseConclusion=$replace(DiagnoseConclusion,"[","")
			.....s:DiagnoseConclusion["]" DiagnoseConclusion=$replace(DiagnoseConclusion,"]"," ")
			....s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
			....s STID=$p($g(^DHCPEED(EDID,"1")),"^",7)
			....s STIndex=9999
			....i STID'="" d
			.....s STIndex=$p(^DHCPEST(STID),"^",9),StName=$p(^DHCPEST(STID),"^",2)
			.....s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STID,""))
		    .....q:StatSetID=""
		    .....s STIndex=$lg($g(^CF.PE.StationSetD(StatSetID)),5)
		    ....s ^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId)=DiagnoseConclusion
			...e  d
			....s IDRRowID=0,DiagnoseConclusion=""
			....f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRRowID)) q:IDRRowID=""  d
			.....s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
			.....s ^TMPGREPORTNew("GReport","Temp",PreIADM,ILLnessID)="1"
			.....Q:$G(^DHCPEILLS(ILLnessID))=""
			.....s IILConclusion=$P($G(^DHCPEILLS(ILLnessID)),"^",2)
			.....q:$d(^TempDHCPEGDiagnoseConclusion(GADMDR,"IADM",IILConclusion,IADMRowId))
			.....s ^TempDHCPEGDiagnoseConclusion(GADMDR,"IADM",IILConclusion,IADMRowId)=""
			.....s DiagnoseConclusion=IILConclusion
			...;b ;DiagnoseConclusion
			...;i DiagnosisDesc="" s DiagnosisDesc=conclutionindex_"、"_DiagnoseConclusion
			...;e  i DiagnoseConclusion'="" s DiagnosisDesc=DiagnosisDesc_"<br>"_conclutionindex_"、"_DiagnoseConclusion
			...;s conclutionindex=conclutionindex+1
			.s STIndex=0
			.//b 
			.for  s STIndex=$o(^DHCPETMP("TeamDiagnosisPersonReport",STIndex)) q:(STIndex="")  d
			..s GSDRowId=""
			..for  s GSDRowId=$o(^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId)) q:(GSDRowId="")  d
			...s DiagnoseConclusion=$g(^DHCPETMP("TeamDiagnosisPersonReport",STIndex,GSDRowId))
			...s:(DiagnosisDesc'="") DiagnosisDesc=DiagnosisDesc_"<br>"_conclutionindex_"、"_DiagnoseConclusion
			...s:(DiagnosisDesc="") DiagnosisDesc=conclutionindex_"、"_DiagnoseConclusion
			...s conclutionindex=conclutionindex+1
			.i DiagnosisDesc="" s DiagnosisDesc="本次体检未见异常"
			.//s Contentgather=$G(^DHCPENetReport("Result",IADMPAADMDR,"Contentgather"))
			.s DeptNo=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
			.d TeamDiagnosisPersonReportOutput
		}
	 	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisPersonReportOutput

	set Data=$lb(Name,RegNo,Sex,Tel,Age,DiagnosisDesc,Contentgather,DeptNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamDiagnosisPersonReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamDiagnosisPersonReportExecute ]
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

ClassMethod TeamDiagnosisPersonReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamDiagnosisPersonReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 团体参建人员名单
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","PersonName","97") 
Query PersonName(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "Name1:%String,Name2:%String,Name3:%String,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String") [ SqlProc ]
{
}

ClassMethod PersonNameExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s Str=""
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Name1="",Name2="",Name3="",Name4="",Name5="",Name6="",Name7="",Name8=""      
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.i Str="" d
	..s Str=Name
	.e  d
	..s Str=Str_"^"_Name
	.i $L(Str,"^")=8 d
	..s Name1=$P(Str,"^",1)
	..s Name2=$P(Str,"^",2)
	..s Name3=$P(Str,"^",3)
	..s Name4=$P(Str,"^",4)
	..s Name5=$P(Str,"^",5)
	..s Name6=$P(Str,"^",6)
	..s Name7=$P(Str,"^",7)
	..s Name8=$P(Str,"^",8)
	..s Str=""
	..d PersonName
	i Str'="" d
	.s Name1=$P(Str,"^",1)
	.s Name2=$P(Str,"^",2)
	.s Name3=$P(Str,"^",3)
	.s Name4=$P(Str,"^",4)
	.s Name5=$P(Str,"^",5)
	.s Name6=$P(Str,"^",6)
	.s Name7=$P(Str,"^",7)
	.s Name8=$P(Str,"^",8)
	.d PersonName
	;;.d PersonName
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PersonName

	set Data=$lb(Name1,Name2,Name3,Name4,Name5,Name6,Name7,Name8)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PersonNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PersonNameExecute ]
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

ClassMethod PersonNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PersonNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// //yd 体检团体报告end----------------------------------------
/// DHCPE-科室人员项目工作量报表.raq
/// BeginDate    EndDate    GContract 团体合同   PreGADM 团体   VIPLevel VIP等级   Percentage 工作量百分比   Type 类型（Aud 按总检时间  Exe 按医嘱执行日期（结果表日期） Arr 按到达日期）
/// 工号  医师  科室  体检项目  工作量（人）  项目价格  应收金额  优惠金额  实际金额  工作量金额
/// CALL web_DHCPE_Query.RunQianQuery_GetLocOrderReport("2020-05-05","2020-07-20")
///  d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","GetLocOrderReport","2020-07-01","2020-07-31") 
/// d ##class(web.DHCPE.Query.RunQian.TJZY).GetLocOrderReport("2020-07-01","2020-07-31")
Query GetLocOrderReport(BeginDate As %String = "", EndDate As %String = "", GContract As %String = "", PreGADM As %String = "", VIPLevel As %String = "", Percentage As %String = "", Type As %String = "") As websys.Query(ROWSPEC = "UserCode:%String,UserName:%String,stId:%String,STDsec:%String,itemId:%String,ItemDesc:%String,PENum:%String,Price:%String,TotalAmt:%String,DisAmt:%String,FactAmt:%String,WorkAmt:%String,arcId:%String") [ SqlProc ]
{
}

ClassMethod GetLocOrderReportExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", GContract As %String = "", PreGADM As %String = "", VIPLevel As %String = "", Percentage As %String = "", Type As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("MKLCYX.LCYXInterface","LocList","")
    
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    if ((BeginDate="")||(EndDate="")) {
	    Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
    }
    
    k tempDHCPELOR
    k ^zrc
    
    s:BeginDate'="" BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:Type="" Type="Exe"
    
    s Date=BeginDate-1
    if (Type="Aud") {  // 总检日期
    
	    f  s Date=$o(^DHCPEGS(0,"AuditDateTime",Date)) q:((""=Date)||(Date>EndDate))  d
		.s Time=""
		.f  s Time=$o(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:Time=""  d
	    ..s GSID=""
	    ..f  s GSID=$o(^DHCPEGS(0,"AuditDateTime",Date,Time,GSID)) q:GSID=""  d
	    ...s GSData=$g(^DHCPEGS(GSID,1))
	    ...;q:$p(GSData,"^",5)=""
	    ...s IADM=$p(GSData,"^",1)
	    ...q:IADM=""
	    ...s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	    ...q:PAADM=""
		...;s MainDoctorGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup",ADMLoc))  //复检标志
	   	...;q:((MainDoctorGroup="Y")&&('$d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))))  // 复检判断
	   	...s OEOrder=$o(^OEORD(0,"Adm",PAADM,0))
	   	...q:OEOrder=""
	   	...s Ordsub=0
	   	...f  s Ordsub=$o(^OEORD(OEOrder,"I",Ordsub)) q:Ordsub=""  d
	   	....s OEOrdItem=OEOrder_"||"_Ordsub
		....d GetOrderInfo
		
    } elseif (Type="Arr") {  // 到达日期
       
	    s Date=BeginDate-1
	    f  s Date=$O(^DHCPEIADM(0, "AdmDateTime", Date)) Q:((""=Date)||(Date>EndDate))  d
	    .;d KillQueryTargetGlobal
		.s AdmTime=0
		.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", Date, AdmTime)) Q:(""=AdmTime)  d
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0, "AdmDateTime", Date, AdmTime, IADM))  Q:(""=IADM)  d
		...q:$p($g(^DHCPEIADM(IADM)),"^",8)'="ARRIVED"
	    ...s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	    ...q:PAADM=""
	   	...s OEOrder=$o(^OEORD(0,"Adm",PAADM,0))
	   	...q:OEOrder=""
	   	...s Ordsub=0
	   	...f  s Ordsub=$o(^OEORD(OEOrder,"I",Ordsub)) q:Ordsub=""  d
	   	....s OEOrdItem=OEOrder_"||"_Ordsub
		....d GetOrderInfo
		
    } elseif (Type="Exe") {  // 医嘱执行日期
    	f  s Date=$o(^DHCPERLT(0,"DateOrder",Date)) q:((""=Date)||(Date>EndDate))  d
	    .s OEOrdItem=""
	    .f  s OEOrdItem=$o(^DHCPERLT(0,"DateOrder",Date,OEOrdItem)) q:OEOrdItem=""  d
	    ..s OEOrder=$p(OEOrdItem,"||",1)
	    ..s Ordsub=$p(OEOrdItem,"||",2)
	   
	    ..s PAADM=$p($g(^OEORD(OEOrder)),"^",1)
	    ..q:PAADM=""
	    ..s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	    ..q:IADM=""
	    ..d GetOrderInfo
	    
    } else {
	    
    }
    
    if ('$d(tempDHCPELOR)) {
	    Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
    }
    
    s stId=0
    f  s stId=$o(tempDHCPELOR(stId)) q:stId=""  d
    .s STDsec=$p($g(^DHCPEST(stId)),"^",2)
    .s itemId=""
    .f  s itemId=$o(tempDHCPELOR(stId,itemId)) q:itemId=""  d
    ..s itemDesc=$p($g(^ARCIM(+itemId,$p(itemId,"||",2),1)),"^",2)
    ..s user=0
    ..f  s user=$o(tempDHCPELOR(stId,itemId,user)) q:user=""  d
    ...q:user="8317"
    ...s userCode=$p($g(^SSU("SSUSR",user)),"^",1)
    ...s ^TempBaseInfo($j,"BaseInfo",userCode)=userCode
    ...s userName=$p($g(^SSU("SSUSR",user)),"^",2)
    ...s peNum=$g(tempDHCPELOR(stId,itemId,user,"Num"))
    ...
    ...s (price,totalAmt,disAmt,factAmt,workAmt)=0
    ...s iadm=0
    ...f  s iadm=$o(tempDHCPELOR(stId,itemId,user,"IADM",iadm)) q:iadm=""  d
    ....s price=$p(tempDHCPELOR(stId,itemId,user,"IADM",iadm),"^",1)
    ....s totalAmt=totalAmt+price
    ....s factAmt=factAmt+$p(tempDHCPELOR(stId,itemId,user,"IADM",iadm),"^",2)
    ....s workAmt=workAmt+$p(tempDHCPELOR(stId,itemId,user,"IADM",iadm),"^",3)
    ....s arcId=$p(tempDHCPELOR(stId,itemId,user,"IADM",iadm),"^",4)
    ...s disAmt=totalAmt-factAmt
    ...d OutLocOrderReport
    
    k tempDHCPELOR
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

GetOrderInfo
    s preIadm=$p($g(^DHCPEIADM(IADM)),"^",4)
    q:preIadm=""
    s preIBI=$p($g(^DHCPEPreIADM(preIadm)),"^",1)
    q:preIBI=""
    s RegNo=$p(^DHCPEPreIBI(preIBI),"^",1)
    q:RegNo="0004748016"
    s resultId=$o(^DHCPERLT(0,"OEORI",OEOrdItem,0))
    q:resultId=""

    s PreIADMData=$g(^DHCPEPreIADM(preIadm))
    //s PreIBIData=$g(^DHCPEPreIBI(preIBI))
    s resultData=$g(^DHCPERLT(resultId))
    
    q:((VIPLevel'="")&&(VIPLevel'=$p(PreIADMData,"^",18)))
    s PGADM=$p(PreIADMData,"^",2)
    q:((GContract'="")&&(PGADM=""))
    q:((PreGADM'="")&&(PGADM'=PreGADM))
    q:((GContract'="")&&($p($g(^DHCPEPreGADM(PGADM)),"^",25)'=GContract))
    
    s userId=$p(resultData,"^",5)
    
    s ARCITEM=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1),"^",2)   ///医嘱项目
	i ARCITEM="20161||1" d
		.s username=$p(##class(web.DHCEkg.GetEkgReportState).GetEKGArbiterUser(OEOrdItem),"^",2)
		.s userId=$o(^SSU("SSUSR",0,"SSUSR_Name",username,"") )
	
    q:userId=""
    
    s arcRowId=$p(resultData,"^",2)
    s stationId=$o(^DHCPEST(0,"STORD_ARCIM",arcRowId,0))
    q:stationId=""
    
    s crmOrder=$o(^DHCPECRMO(0,"OEORI",OEOrdItem,0))
    q:crmOrder=""
    s preIOI=$p($g(^DHCPECRMO(crmOrder)),"^",2)
    
    s iAmt=$p($g(^DHCPEPreIADM(+preIOI,"ORDITEM",$p(preIOI,"||",2))),"^",14)
    s fAmt=0,wAmt=""
    
    s preIOE=$p($g(^DHCPEPreIADM(+preIOI,"ORDITEM",$p(preIOI,"||",2))),"^",2)
    i preIOE'="" d
    .b:arcRowId="" //2
    .q:$p($g(^DHCPEPreIADM(+preIOE,"ORDENT",$p(preIOE,"||",2))),"^",9)'="1"
    .s oeAmt=$p($g(^DHCPEPreIADM(+preIOE,"ORDENT",$p(preIOE,"||",2))),"^",7)
    .q:+oeAmt=0
    .s Feesub=0
    .f  s Feesub=$o(^DHCPEPreIADM(+preIOE,"ORDENT",$p(preIOE,"||",2),"FEE",Feesub)) q:Feesub=""  d
    ..s preAudit=$p($g(^DHCPEPreIADM(+preIOE,"ORDENT",$p(preIOE,"||",2),"FEE",Feesub)),"^",5)
    ..q:preAudit=""
    ..q:$p($g(^DHCPEPreA(preAudit)),"^",21)'="U"
    ..s rate=(+$p($g(^DHCPEPreIADM(+preIOE,"ORDENT",$p(preIOE,"||",2),"FEE",Feesub)),"^",2)/oeAmt)
    ..s fAmt=fAmt+(rate*iAmt)
    e  d
    .s Feesub=0
    .f  s Feesub=$o(^DHCPEPreIADM(+preIOI,"ORDITEM",$p(preIOI,"||",2),"FEE",Feesub)) q:Feesub=""  d
    ..s preAudit=$p($g(^DHCPEPreIADM(+preIOI,"ORDITEM",$p(preIOI,"||",2),"FEE",Feesub)),"^",5)
    ..q:preAudit=""
    ..q:$p($g(^DHCPEPreA(preAudit)),"^",21)'="U"
    ..s fAmt=fAmt+$p($g(^DHCPEPreIADM(+preIOI,"ORDITEM",$p(preIOI,"||",2),"FEE",Feesub)),"^",2)
    
    
    s:Percentage'="" wAmt=fAmt*Percentage
    
    s tempDHCPELOR(stationId,arcRowId,userId,"Num")=$g(tempDHCPELOR(stationId,arcRowId,userId,"Num"))+1
    s tempDHCPELOR(stationId,arcRowId,userId,"IADM",IADM)=iAmt_"^"_fAmt_"^"_wAmt_"^"_arcRowId
    m ^zrc=tempDHCPELOR
    q
	
OutLocOrderReport
    // 工号  医师  科室  体检项目  工作量（人）  项目价格  应收金额  优惠金额  实际金额  工作量金额
    set Data=$lb(userCode,userName,stId,STDsec,itemId,itemDesc,peNum,price,totalAmt,disAmt,factAmt,workAmt,arcId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Creator：      YX
/// CreatDate：    2020-08-13
/// Description:： 科室人员项目工作量统计--明细
/// Table：     被访问的表（此项仅对于牵扯到数据库操作的程序
/// Input：     StationId  科室ID, arcRowId  医嘱ID, userId 工号  
/// Output：    RegNo, Name, Sex, Dob, Tell, IDCard, IADMDate, GADMDesc, GTeamDesc
/// Return：    登记号 姓名  性别 年龄 电话  身份证  检查日期  团体      分组 "33","20161||1","7353"
/// Debug:      d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","GetBaceInfoQuery","33","20161||1","7353") 
Query GetBaceInfoQuery(stationId As %String, arcRowId As %String, userId As %String) As %Query(ROWSPEC = "Rowid:%String,RegNo:%String,Name:%String,Sex:%String,Dob:%String,IDCard:%String,Tell:%String,IADMDate:%String,GADMDesc:%String,GTeamDesc:%String") [ SqlProc ]
{
}

ClassMethod GetBaceInfoQueryExecute(ByRef qHandle As %Binary, stationId As %String, arcRowId As %String, userId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	q:(stationId="")||(arcRowId="")||(userId="") $$$OK
	s ^TempYuxiang(0)=stationId_"$"_arcRowId_"$"_userId
	s $ZT="myError"
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userId,0))
	s IADM=0
	f  s IADM=$o(^zrc(stationId,arcRowId,userId,"IADM",IADM))  q:IADM=""  d
	.s preIADMId=$p($g(^DHCPEIADM(IADM)),"^",4)
	.s PreIBIId=$p($g(^DHCPEPreIADM(preIADMId)),"^",1)
	.s Name=$p(^DHCPEPreIBI(PreIBIId),"^",2)
	.q:Name["测试" 
	.s RegNo=$p(^DHCPEPreIBI(PreIBIId),"^",1)
	.s Sex=$p(^DHCPEPreIBI(PreIBIId),"^",3)
	.s:Sex'="" Sex=$p(^CT("SEX",Sex),"^",2)
	.s Tell=$p(^DHCPEPreIBI(PreIBIId),"^",6)
	.s:Tell="" Tell=$p(^DHCPEPreIBI(PreIBIId),"^",7)
	.s:Tell="" Tell=$p(^DHCPEPreIBI(PreIBIId),"^",8)
	.s IDCard=$p(^DHCPEPreIBI(PreIBIId),"^",9)
	.s Dob=$p(^DHCPEPreIBI(PreIBIId),"^",4)
	.s:Dob'="" Dob=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)_"岁"    //年龄
	.s IADMDate=$ZD($p(^DHCPEPreIADM(preIADMId),"^",4),3)
	.s GADMDesc="",GTeamDesc=""
	.s GADMID=$p(^DHCPEPreIADM(preIADMId),"^",2)
	.s:GADMID'="" GADMDesc=$p(^DHCPEPreGBI($p(^DHCPEPreGADM(GADMID),"^",1)),"^",2)
	.s GTeamID=$p($p(^DHCPEPreIADM(preIADMId),"^",3),"||",2)
	.s:GTeamID'="" GTeamDesc=$p(^DHCPEPreGADM(GADMID,"Team",GTeamID),"^",1)
	.d Arr1NoPay
	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK

Arr1NoPay
 	Set ^CacheTemp(repid,ind)=$LB(ind,RegNo,Name,Sex,Dob,IDCard,Tell,IADMDate,GADMDesc,GTeamDesc)
 	Set ind=ind+1
 	q
 	
myError
    s $ZT=""
    q "程序发生错误："_$ZERROR
}

ClassMethod GetBaceInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaceInfoQueryExecute ]
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

ClassMethod GetBaceInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaceInfoQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 天津中医院体检收入报表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","PEIncomeStatistic","2020-07-01","2020-07-28","","","9")
Query PEIncomeStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", Group As %Library.String = "", VIPLevel As %Library.String = "", CTLOCID As %Library.String = "") As %Query(ROWSPEC = "PIADM:%String,RegNo:%String,Name:%String,SexName:%String,TAge:%String,telno:%String,IADMAdmDate:%String,GName:%String,AccountAmount:%Float,FactAmount:%Float,FinalAmount:%Float,Payed:%Float,UnPayed:%Float,Amount:%Float") [ SqlProc ]
{
}

ClassMethod PEIncomeStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", Group As %Library.String = "", VIPLevel As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if ((""=BeginDate)&(""=EndDate)&(""=Group)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s job=$j
 	k ^TempDHCPEIncomeStatistic(job)
 	
 	i BeginDate="" s BeginDate=0
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
	
	if (Group'="")
	{
		s GPAADM=Group
	 	s PIADM=0
	 	f  s PIADM=$o(^DHCPEPreIADM(0,"PGADM",GPAADM,PIADM)) Q:PIADM=""  d
	 	.s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
	 	.q:(Status="PREREG")||(Status="CANCELPE")
	 	.;b ;Status
	 	.s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,""))
	 	.q:IADM=""
	 	.s TRowId=""
		.f  s TRowId=$o(^DHCPEINVPRT(0,"ADM",IADM,TRowId)) q:((TRowId=""))  d
		..b ;TRowId
		..d GetOneInvPrt
	}
	else
	{
		s Date=EndDate+1		
		f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date),-1) q:((Date="")||(Date<BeginDate))  d
		.s TRowId=""
		.f  s TRowId=$o(^DHCPEINVPRT(0,"DATE",Date,TRowId),-1) q:((TRowId=""))  d
		..d GetOneInvPrt
	}
	
	if ('$d(^TempDHCPEIncomeStatistic(job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s PIADM=""
	f  s PIADM=$o(^TempDHCPEIncomeStatistic(job,PIADM)) q:PIADM=""  d
	.s PIBI=$p($g(^DHCPEPreIADM(PIADM)),"^",1)
	.s RegNo=$p($g(^DHCPEPreIBI(PIBI)),"^",1)
	.s Name=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
	.s SexName=""
	.s SexID=$p($g(^DHCPEPreIBI(PIBI)),"^",3)
    .i SexID'=""   s SexName=$p(^CT("SEX",SexID),"^",2)
    .s TAge=$p($g(^DHCPEPreIBI(PIBI)),"^",4)
    .s:TAge'="" TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1)
    .s telno=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBI)
    .s IADMAdmDate=$p($g(^DHCPEPreIADM(PIADM)),"^",5)
    .s:IADMAdmDate'="" IADMAdmDate=$zd(IADMAdmDate,3)
    .s GName=""
    .s PGADM=$p($g(^DHCPEPreIADM(PIADM)),"^",2)
    .i PGADM'="" d
    ..s PGBIDR=$p(^DHCPEPreGADM(PGADM),"^",1)
    ..s GName=$p(^DHCPEPreGBI(PGBIDR),"^",2)
    .s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(PIADM)
    .s AccountAmount=+$P(retvalue,"^",1)     //应收金额
    .s FinalAmount=+$P(retvalue,"^",2)       //实际金额
    .s FactAmount=AccountAmount-FinalAmount   //优惠金额
    .s Payed=+$P(retvalue,"^",4)+$P(retvalue,"^",7)    //已收金额
    .s UnPayed=+$P(retvalue,"^",5)+$P(retvalue,"^",8)   //未收金额
    .s Amount=$G(^TempDHCPEIncomeStatistic(job,PIADM))   //查询时间段内收取金额
    .d OutIncomeStatistic
	
	k ^TempDHCPEIncomeStatistic(job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInvPrt
    q:TRowId=""
	s InvNo=$p($g(^DHCPEINVPRT(TRowId)),"^",1)
	q:InvNo["DHCPEYJS"
	s PrtDate=$p($g(^DHCPEINVPRT(TRowId)),"^",11)
	q:(PrtDate<BeginDate)||(PrtDate>EndDate)
	s FH=1
	s RealInv=$p($g(^DHCPEINVPRT(TRowId)),"^",9)
	i RealInv'="" d
	.s InvID=RealInv
	.s FH=-1
	e  d
	.s InvID=TRowId
	s PAADM=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	;q:(##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CTLOCID)=1)
	s PB=$p($g(^DHCPEINVPRT(InvID)),"^",3)
	s PAPB=0
	f  s PAPB=$o(^DHCPEPAPBR(0,"PBDR",PB,PAPB)) q:PAPB=""  d
	.s PA=$p(^DHCPEPAPBR(PAPB),"^",1)
	.s UseFlag=$p(^DHCPEPreA(PA),"^",21)
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM)) q:PIADM=""  d
	..s VIP=$p($g(^DHCPEPreIADM(PIADM)),"^",18)
	..q:(VIPLevel'="")&&(VIPLevel'=VIP)
	..s OrdSub=0
	..f  s OrdSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub))  q:OrdSub=""  d
	...s ORDFee=0
	...s ARCDR=$p($g(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub)),"^",1)
	...s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCDR,""))
	...;b:ARCDR'="18139||1" ;STDR CTLOCID
	...q:(CTLOCID'="")&(STDR'=CTLOCID)
	...f  s ORDFee=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub,ORDFee)) q:ORDFee=""  d
	....s OneFactAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub,"FEE",ORDFee),"^",2)
	....s ^TempDHCPEIncomeStatistic(job,PIADM)=$G(^TempDHCPEIncomeStatistic(job,PIADM))+(OneFactAmount*FH)
	.
	.s PIADM=0
	.f  s PIADM=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM)) q:PIADM=""  d
	..s VIP=$p($g(^DHCPEPreIADM(PIADM)),"^",18)
	..q:(VIPLevel'="")&&(VIPLevel'=VIP)
	..s EntSub=0
	..f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM,EntSub))  q:EntSub=""  d
	...s EntRid=PIADM_"||"_EntSub
	...s OrdSub=0
	...f  s OrdSub=$o(^DHCPEPreIADM(0,"OrdEnt",EntRid,PIADM,OrdSub)) q:OrdSub=""  d
	....s ORDFee=0
	....s ARCDR=$p($g(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub)),"^",1)
	....s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCDR,""))
	....;b:(ARCDR'="18139||1")&(STDR=9) ;STDR CTLOCID
	....q:(CTLOCID'="")&(STDR'=CTLOCID)
	....f  s ORDFee=$o(^DHCPEPreIADM(0,"PAORDITEM",PA,PIADM,OrdSub,ORDFee)) q:ORDFee=""  d
	.....s OneFactAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",OrdSub,"FEE",ORDFee),"^",2)
	.....s ^TempDHCPEIncomeStatistic(job,PIADM)=$G(^TempDHCPEIncomeStatistic(job,PIADM))+(OneFactAmount*FH)
	
	;...s EntFee=0
	;...f  s EntFee=$o(^DHCPEPreIADM(0,"PAORDENT",PA,PIADM,EntSub,EntFee)) q:EntFee=""  d
	;....s OneFactAmount=$p(^DHCPEPreIADM(PIADM,"ORDENT",EntSub,"FEE",EntFee),"^",2)
	;....s ^TempDHCPEIncomeStatistic(job,PIADM)=$G(^TempDHCPEIncomeStatistic(job,PIADM))+(OneFactAmount*FH)
	  
    q
OutIncomeStatistic
	set Data=$lb(PIADM,RegNo,Name,SexName,TAge,telno,IADMAdmDate,GName,AccountAmount,FactAmount,FinalAmount,Payed,UnPayed,Amount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PEIncomeStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PEIncomeStatisticExecute ]
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

ClassMethod PEIncomeStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PEIncomeStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 疾病建议与分析(团体报告)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","TeamILLnessDesc","19")
Query TeamILLnessDesc(GADMDR As %Library.String = "", Depart As %Library.String = "") As %Query(ROWSPEC = "count:%String,CNumberName:%String,ILLnessDesc:%String,ILLnessDetailed:%String") [ SqlProc ]
{
}

ClassMethod TeamILLnessDescExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	
	;测试数据
	s count=1
	s CNumberName="Name1"
	s ILLnessDesc="Desc1"
	s ILLnessDetailed="本次体检共检出视网膜动脉硬化 1 人（男 1 人、女 0 人），检出率 1.72%。<br>视网膜动脉硬化(arteriosclerosis of retina)，在一定程度上，反映了大脑或肾血管系统方面的同样情况，因为视网膜中央动脉是脑循环系统的一部分，所以视网膜动脉所显示的动脉硬化程度，也就是脑动脉及周身动脉硬化的指征。但大脑血管的硬化，却不一定意味着视网膜血管的同样变化，即正常的视网膜血管并不能除外大脑血管硬化的存在，这是根据眼底变化对全身情况估计时所必具有的认识。 视网膜动脉硬化主要是一种老年性慢性血管病变，是老年周身血管系统的衰老现象，由于血管壁局部纤维组织增厚而发生硬化。"
	d TeamILLnessOutput
	s count=1
	s CNumberName="Name2"
	s ILLnessDesc="Desc2"
	s ILLnessDetailed="本次体检共检出左心室肥厚 1 人（男 1 人、女 0 人），检出率 1.72%。<br>是心脏对高血压、瓣膜病、心梗后收缩期或舒张期负荷过重而产生的代偿性或适应性改变。可显著增加心血管意外的发生率。建议专科诊治。"
	d TeamILLnessOutput
	
	;s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",ILLnessID)=DiagnosisDesc
	s count=0,ILLnessDetailed="",ILLnessDesc="",ILLness="",CNumberName=0
	f  s count=$o(^TempILLnessDetailed("ILLness","Detailed",count)) q:count=""  d
	.s CNumberName=$o(^TempILLnessDetailed("ILLness","Detailed",count,""))
	.s ILLness=$g(^TempILLnessDetailed("ILLness","Detailed",count,CNumberName))
	.s ILLnessDetailed=$p(ILLness,"^",1)
	.s ILLnessDesc=$p(ILLness,"^",2)
	.d TeamILLnessOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamILLnessOutput

	set Data=$lb(count,CNumberName,ILLnessDesc,ILLnessDetailed)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TeamILLnessDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TeamILLnessDescExecute ]
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

ClassMethod TeamILLnessDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TeamILLnessDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// yuxiang 异常结果汇总报表（一）
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","AbnormalResultSummary","","13/07/2020","31/07/2020","","30","","")   
Query AbnormalResultSummary(ARCIMRid As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", VIP As %Library.String = "", Group As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "") As %Query(ROWSPEC = "PIBIRegNo:%String,PIBIName:%String,Sex:%String, Age:%String, GroupDesc:%String, VIPDesc:%String, Tell:%String, AbnormalResult:%String") [ SqlProc ]
{
}

ClassMethod AbnormalResultSummaryExecute(ByRef qHandle As %Binary, ARCIMRid As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", VIP As %Library.String = "", Group As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s $ZT="MyErrorInfo"
	
	if (((""=BeginDate)||(""=EndDate))&(""=Group)&(""=RegNo)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:BeginDate'="" BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	if (RegNo '="") {	
		s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
		s PIBIRid=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
		q:PIBIRid="" $$$OK
		s PIADMRid=""
		f  s PIADMRid=$o(^DHCPEPreIADM(0,"PIBI",PIBIRid,PIADMRid),-1) q:PIADMRid=""  d
		.s AbnormalResult=""
		.s Status=$p(^DHCPEPreIADM(PIADMRid),"^",8)
		.q:Status'="ARRIVED"
		.s flag=0
		.d GetAbnormaPersonInfo
		.q:flag=0
		.s IADMRid=$o(^DHCPEIADM(0,"CRMADM",PIADMRid,""))
		.s PAADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",1)
		.s RLTRid=0
		.s STORDRid=0
		.s i=0
		.s ARCIMid=""
		.f  s RLTRid=$o(^DHCPERLT(0,"ADM",PAADMRid,RLTRid)) q:RLTRid=""  d
		..s UpdateDate=$p($g(^DHCPERLT(RLTRid)),"^",6)
		..q:(BeginDate'="")&(UpdateDate<BeginDate)
		..q:(EndDate'="")&(UpdateDate>EndDate)
		..d GetAbnormalResult
		.q:AbnormalResult=""
		.d AbnormalResultOutput
	} elseif (Group '=""){
		s PreGADM=Group
		s PIADMRid=0
		f  s PIADMRid=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PIADMRid)) q:PIADMRid=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PIADMRid,"Person")="0"     
		.s Status=$p(^DHCPEPreIADM(PIADMRid),"^",8)
		.q:Status'="ARRIVED"
		.s AbnormalResult=""
		.s flag=0
		.d GetAbnormaPersonInfo
		.q:flag=0
		.s IADMRid=$o(^DHCPEIADM(0,"CRMADM",PIADMRid,""))
		.s PAADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",1)
		.s RLTRid=0
		.s STORDRid=0
		.s i=0
		.s ARCIMid=""
		.f  s RLTRid=$o(^DHCPERLT(0,"ADM",PAADMRid,RLTRid)) q:RLTRid=""  d
		..s UpdateDate=$p($g(^DHCPERLT(RLTRid)),"^",6)
		..q:(BeginDate'="")&(UpdateDate<BeginDate)
		..q:(EndDate'="")&(UpdateDate>EndDate)
		..d GetAbnormalResult
		.q:AbnormalResult=""
		.d AbnormalResultOutput
	} else {
		s UpdateDate=BeginDate-1
		f  s UpdateDate=$o(^DHCPERLT(0,"DateADM",UpdateDate))  q:(UpdateDate>EndDate)||(UpdateDate>+$h)||(UpdateDate="")  d
		.;b ;UpdateDate 
		.s PAADMRid=0
		.f  s PAADMRid=$o(^DHCPERLT(0,"DateADM",UpdateDate,PAADMRid)) q:PAADMRid=""  d
		..;b ;PAADMRid
		..s IADMRid=$o(^DHCPEIADM(0,"PAADM",PAADMRid,""))
		..s AbnormalResult=""
		..s PIADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",4)
		..s flag=0
		..d GetAbnormaPersonInfo
		..q:flag=0
		..s RLTRid=0,STORDRid=0,i=0
		..s ARCIMid=""
		..f  s RLTRid=$o(^DHCPERLT(0,"DateADM",UpdateDate,PAADMRid,RLTRid)) q:RLTRid=""  d
		...d GetAbnormalResult
		..q:AbnormalResult=""
		..d AbnormalResultOutput	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetAbnormaPersonInfo
	q:PIADMRid=""
	s PIBIRid=$p($g(^DHCPEPreIADM(PIADMRid)),"^",1)
	s PIBIRegNo=$p($g(^DHCPEPreIBI(PIBIRid)),"^",1)
	s PIBIName=$p($g(^DHCPEPreIBI(PIBIRid)),"^",2)
	q:(Name'="")&(Name'=PIBIName)
	s Sex=$p($g(^DHCPEPreIBI(PIBIRid)),"^",3)
	s:Sex'="" Sex=$p(^CT("SEX",Sex),"^",2)
	s Age=$p($g(^DHCPEPreIBI(PIBIRid)),"^",4)
	s:Age'="" Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,$h)
	s Tell=$p($g(^DHCPEPreIBI(PIBIRid)),"^",6)
	s:Tell="" Tell=$p($g(^DHCPEPreIBI(PIBIRid)),"^",8)
	s VIPLevel=$p($g(^DHCPEPreIADM(PIADMRid)),"^",18)
	q:(VIP'="")&(VIP'=VIPLevel)
	s VIPDesc=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	s GroupDR=$p($g(^DHCPEPreIADM(PIADMRid)),"^",2) //yuxiang 可能要修改 ，根据传入的Group的值
	q:(Group'="")&(Group'=GroupDR)
	s GroupDesc=""
	i GroupDR'="" d 
	.s PGBIDR=$p($g(^DHCPEPreGADM(GroupDR)),"^",1)
	.s GroupDesc=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
	s flag=1
	q
	
GetAbnormalResult
	;b ;GetAbnormalResult
	s ARCIMDR=$p($g(^DHCPERLT(RLTRid)),"^",2)
	q:(ARCIMRid'="")&(ARCIMRid'=ARCIMDR)
	s RLTNormal=$p($g(^DHCPERLT(RLTRid)),"^",7)
	q:RLTNormal'=0
	s ODDR=$p($g(^DHCPERLT(RLTRid)),"^",3)
	i STORDRid'=$p(ODDR,"||",1)  d 
	.s STORDRid=$p(ODDR,"||",1)
	.s STDesc=$p($g(^DHCPEST(STORDRid)),"^",2)
	.s i=1
	.i AbnormalResult="" s AbnormalResult="【"_STDesc_"】："
	.e  s AbnormalResult=AbnormalResult_$c(10)_"【"_STDesc_"】："
	s ARCIMSubscript=$p(ARCIMDR,"||",1)
	s ARCIMVersion=$p(ARCIMDR,"||",2)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	s:ARCIMDesc["（体检）" ARCIMDesc=$Replace(ARCIMDesc,"（体检）","")
	s:ARCIMDesc["(体检)" ARCIMDesc=$Replace(ARCIMDesc,"(体检)","")
	s ARCSort=i //##class(web.DHCPE.Public.Tools).ChinaSerialNumber(i)
	s ARCSort=$Replace(ARCSort,"（","")
	s ARCSort=$Replace(ARCSort,"）","、 ") 
	i ARCIMid'=ARCIMDR  d
	.s AbnormalResult=AbnormalResult_$c(10)_ARCSort_ARCIMDesc_"："
	.s ARCIMid=ARCIMDR
	.s i=i+1
	s ODSub=$p(ODDR,"||",2)
	s ODDetil=$p($g(^DHCPERLT(RLTRid)),"^",4)
	s ODDesc=$p(^DHCPEST(STORDRid,"OD",ODSub),"^",1)
	s ODUnit=$p(^DHCPEST(STORDRid,"OD",ODSub),"^",4)
	s AbnormalResult=AbnormalResult_$c(1)_ODDesc_":"_ODDetil_" "_ODUnit_"; "
	i AbnormalResult="" s AbnormalResult=ODDesc_":"_ODDetil_" "_ODUnit
	s AbnormalResult=ODDesc_":"_ODDetil_" "_ODUnit
	q
	
MyErrorInfo
	s $ZT=""
	q "程序发生异常："_$ZERROR
		
AbnormalResultOutput
    ;b ;AbnormalResultOutput
	set Data=$lb(PIBIRegNo, PIBIName, Sex, Age, GroupDesc, VIPDesc, Tell, AbnormalResult)
	;set Data=$lb(RegNo, PIBIName, AbnormalResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod AbnormalResultSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AbnormalResultSummaryExecute ]
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

ClassMethod AbnormalResultSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AbnormalResultSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// yuxiang 异常结果汇总报表（二）
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQian.TJZY","AbnormalResultSummaryTwo","","01/07/2020","01/09/2020","","","0004748016","")   
Query AbnormalResultSummaryTwo(ARCIMRid As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", VIP As %Library.String = "", Group As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "") As %Query(ROWSPEC = "IADMRid:%String, PIBIRegNo:%String,PIBIName:%String,Sex:%String, Age:%String, GroupDesc:%String, VIPDesc:%String, Tell:%String, StationInfo:%String, Details:%String, Value:%String") [ SqlProc ]
{
}

ClassMethod AbnormalResultSummaryTwoExecute(ByRef qHandle As %Binary, ARCIMRid As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "", VIP As %Library.String = "", Group As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s $ZT="TwoMyErrorInfo"
	if (((""=BeginDate)||(""=EndDate))&(""=Group)&(""=RegNo)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:BeginDate'="" BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	if (RegNo '="") {	
		
		s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
		s PIBIRid=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
		q:PIBIRid="" $$$OK
		s PIADMRid=""
		f  s PIADMRid=$o(^DHCPEPreIADM(0,"PIBI",PIBIRid,PIADMRid),-1) q:PIADMRid=""  d
		.s AbnormalResult=""
		.s Status=$p(^DHCPEPreIADM(PIADMRid),"^",8)
		.q:Status'="ARRIVED"
		.s flag=0
		.d TwoGetAbnormaPersonInfo
		.q:flag=0
		.s IADMRid=$o(^DHCPEIADM(0,"CRMADM",PIADMRid,""))
		.s PAADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",1)
		.s RLTRid=0
		.s STORDRid=0
		.s i=0
		.s ARCIMid=""
		.f  s RLTRid=$o(^DHCPERLT(0,"ADM",PAADMRid,RLTRid)) q:RLTRid=""  d
		..s StationInfo="",Details="",Value=""
		..s UpdateDate=$p($g(^DHCPERLT(RLTRid)),"^",6)
		..q:(BeginDate'="")&(UpdateDate<BeginDate)
		..q:(EndDate'="")&(UpdateDate>EndDate)
		..d TwoGetAbnormalResult 
		..
		..q:StationInfo=""
		..
		..d TwoAbnormalResultOutput
	} elseif (Group '=""){
		s PreGADM=Group
		s PIADMRid=0
		f  s PIADMRid=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PIADMRid)) q:PIADMRid=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PIADMRid,"Person")="0"     
		.s Status=$p(^DHCPEPreIADM(PIADMRid),"^",8)
		.q:Status'="ARRIVED"
		.s AbnormalResult=""
		.s flag=0
		.d TwoGetAbnormaPersonInfo
		.q:flag=0
		.s IADMRid=$o(^DHCPEIADM(0,"CRMADM",PIADMRid,""))
		.s PAADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",1)
		.s RLTRid=0
		.s STORDRid=0
		.s i=0
		.s ARCIMid=""
		.f  s RLTRid=$o(^DHCPERLT(0,"ADM",PAADMRid,RLTRid)) q:RLTRid=""  d
		..s StationInfo="",Details="",Value=""
		..s UpdateDate=$p($g(^DHCPERLT(RLTRid)),"^",6)
		..q:(BeginDate'="")&(UpdateDate<BeginDate)
		..q:(EndDate'="")&(UpdateDate>EndDate)
		..d TwoGetAbnormalResult
		..q:StationInfo=""
		..d TwoAbnormalResultOutput
	} else {
		s UpdateDate=BeginDate-1
		f  s UpdateDate=$o(^DHCPERLT(0,"DateADM",UpdateDate))  q:(UpdateDate>EndDate)||(UpdateDate>+$h)||(UpdateDate="")  d
		.;b ;UpdateDate 
		.s PAADMRid=0
		.f  s PAADMRid=$o(^DHCPERLT(0,"DateADM",UpdateDate,PAADMRid)) q:PAADMRid=""  d
		..;b ;PAADMRid
		..s IADMRid=$o(^DHCPEIADM(0,"PAADM",PAADMRid,""))
		..s AbnormalResult=""
		..s PIADMRid=$p($g(^DHCPEIADM(IADMRid)),"^",4)
		..s flag=0
		..d TwoGetAbnormaPersonInfo
		..q:flag=0
		..s RLTRid=0,STORDRid=0,i=0
		..s ARCIMid=""
		..f  s RLTRid=$o(^DHCPERLT(0,"DateADM",UpdateDate,PAADMRid,RLTRid)) q:RLTRid=""  d
		...s StationInfo="",Details="",Value=""
		...d TwoGetAbnormalResult
		...q:StationInfo=""
		...d TwoAbnormalResultOutput	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
TwoGetAbnormaPersonInfo
	q:PIADMRid=""
	s PIBIRid=$p($g(^DHCPEPreIADM(PIADMRid)),"^",1)
	s PIBIRegNo=$p($g(^DHCPEPreIBI(PIBIRid)),"^",1)
	s PIBIName=$p($g(^DHCPEPreIBI(PIBIRid)),"^",2)
	q:(Name'="")&(Name'=PIBIName)
	s Sex=$p($g(^DHCPEPreIBI(PIBIRid)),"^",3)
	s:Sex'="" Sex=$p(^CT("SEX",Sex),"^",2)
	s Age=$p($g(^DHCPEPreIBI(PIBIRid)),"^",4)
	s:Age'="" Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,$h)
	s Tell=$p($g(^DHCPEPreIBI(PIBIRid)),"^",6)
	s:Tell="" Tell=$p($g(^DHCPEPreIBI(PIBIRid)),"^",8)
	s VIPLevel=$p($g(^DHCPEPreIADM(PIADMRid)),"^",18)
	q:(VIP'="")&(VIP'=VIPLevel)
	s VIPDesc=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	s GroupDR=$p($g(^DHCPEPreIADM(PIADMRid)),"^",2) //yuxiang 可能要修改 ，根据传入的Group的值
	q:(Group'="")&(Group'=GroupDR)
	s GroupDesc=""
	i GroupDR'="" d 
	.s PGBIDR=$p($g(^DHCPEPreGADM(GroupDR)),"^",1)
	.s GroupDesc=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
	s flag=1
	q
	
TwoGetAbnormalResult
	
	s ARCIMDR=$p($g(^DHCPERLT(RLTRid)),"^",2)
	q:(ARCIMRid'="")&(ARCIMRid'=ARCIMDR)
	s RLTNormal=$p($g(^DHCPERLT(RLTRid)),"^",7)
	q:RLTNormal'=0
	
	s ODDR=$p($g(^DHCPERLT(RLTRid)),"^",3)
	s STORDRid=$p(ODDR,"||",1)
	s STDesc=$p($g(^DHCPEST(STORDRid)),"^",2)  //站点
	s STLayoutType=$p($g(^DHCPEST(STORDRid)),"^",7)
	q:STLayoutType=""
	
	s ARCIMSubscript=$p(ARCIMDR,"||",1)
	s ARCIMVersion=$p(ARCIMDR,"||",2)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	s:ARCIMDesc["（体检）" ARCIMDesc=$Replace(ARCIMDesc,"（体检）","")
	s:ARCIMDesc["(体检)" ARCIMDesc=$Replace(ARCIMDesc,"(体检)","")
	s ODSub=$p(ODDR,"||",2)
	s ODDetil=$p($g(^DHCPERLT(RLTRid)),"^",4)
	s ODDesc=$p(^DHCPEST(STORDRid,"OD",ODSub),"^",1)
	s ODUnit=$p(^DHCPEST(STORDRid,"OD",ODSub),"^",4)

	i STLayoutType=4  d
	.s StationInfo=ARCIMDesc 
	.s Details=ODDesc
	.s Value=ODDetil_" "_ODUnit
	e  i (STLayoutType=5)||(STLayoutType=6) d
	.s StationInfo=STDesc
	.s Details=ARCIMDesc
	.s Value=$p(ODDetil,"诊断意见:",2)
	e  i (STLayoutType=1)||(STLayoutType=2) d
	.s StationInfo=STDesc
	.s Details=ODDesc
	.s Value=ODDetil_" "_ODUnit
	;b ;q
	q
	
TwoMyErrorInfo
	s $ZT=""
	q "程序发生异常："_$ZERROR
		
TwoAbnormalResultOutput
    ;b ;TwoAbnormalResultOutput
	set Data=$lb(IADMRid, PIBIRegNo, PIBIName, Sex, Age, GroupDesc, VIPDesc, Tell, StationInfo, Details, Value)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod AbnormalResultSummaryTwoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AbnormalResultSummaryTwoExecute ]
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

ClassMethod AbnormalResultSummaryTwoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AbnormalResultSummaryTwoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据就诊和疾病ID判断这个人是否有这个疾病
/// / w ##Class(web.DHCPE.Query.RunQian.TJZY).JudgeExpress(149212,63,"33497")
/// / w ##Class(web.DHCPE.Query.RunQian.TJZY).JudgeExpress(149188,63,"33499")
ClassMethod JudgeExpress(EpisodeID, ILLID, GSID)
{
	
	
	
	s AgeSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s Age=$P(AgeSexStr,"^",1)
	s Sex=$P(AgeSexStr,"^",2)
	
	s ILLType=$P(^DHCPEILLS(ILLID),"^",11)
	s Advice=$P(^DHCPEILLS(ILLID),"^",3)
	s ILLnessID=ILLID
	s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ILLGREPORT",ILLID,0))
	q:ExpressID="" 0
	s Express="",ResultDesc=""
	s QuitFlag=0
	s ExpressID=0
	f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","ILLGREPORT",ILLID,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
	.s obj=##class(User.DHCPEExpress).%OpenId(ExpressID)
	.s Express=Express_obj.EPreBracket
	.s ItemID=obj.EItemDRGetObjectId()
	.i ItemID="" s ItemID="a||b"
	.
	.i $D(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID)) d  ;;逐个判断此细项是否满足
	..s ItemType=obj.EItemDR.ODType
	..s Reference=obj.EReference
	..i Reference="" s Reference=obj.EODStandardDR.ODSTextVal
	..s Operator=obj.EOperator
	..s IsResult=0
	..s RLTID=0
	..f  s RLTID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,ItemID,RLTID)) q:(RLTID="")||(IsResult=1)  d
 	...s Result=$P(^DHCPERLT(RLTID),"^",4)
 	...s ResultDesc=Result
 	...s EDID=$P(^DHCPERLT(RLTID),"^",9)
 	...i (ItemType="S")||(ItemType="T") d
 	....s Result=""""_Result_""""
 	....s Reference=""""_Reference_""""
 	...s OneExpress=Result_Operator_Reference
 	...s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
 	...//b //11
	.e  d  ;;没有结果设置为0
	..s ODDesc=$p(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2)),"^",1)
	..i ODDesc'="疾病关键字" d
	...s IsResult=0
	..e  d
	...s IsResult=0
	...s Reference=obj.EReference
	...s Sort=0,HadIllQuitFlag=0
    ...f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:(Sort="")||(HadIllQuitFlag=1)  d
    ....s gSub=0
    ....f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:(gSub="")||(HadIllQuitFlag=1)  d
    .....s Status=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",11)
    .....q:Status'="0"
    .....s EDID=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",1)
    .....q:EDID=""
    .....// 增加乙肝标志 add
    .....s YGFlag=$p(^DHCPEGS(GSID,"Diagnosis",gSub),"^",12)
    .....// 增加乙肝标志 end
    .....s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    .....s GSDRowId=GSID_"||"_gSub
    .....i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ......s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    .....//b:(gSub=25)
    .....i (DiagnoseConclusion[Reference) d
    ......//b ;  55
    ......s HadIllQuitFlag=1
    ......s IsResult=1
	.s ExpressSex=obj.ESex
	.;;性别不符设置为0
	.//b /// ExpressSex
	.s:(ExpressSex'="N")&&(ExpressSex'="")&&(ExpressSex'=Sex) IsResult=0
	.s Express=Express_IsResult_obj.EAfterBracket_obj.ERelation
	.s:obj.ERelation="" QuitFlag=1
	;i ILLID=100 s ^ypp(EpisodeID)=Express
	//"(0)||(1)||(0)||(1)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0)||(0&&0)||(1&&1)||(0&&0)||(0&&0)||(0&&0)||(0)||(0)||(0)||(0)"
	s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	/// 直接返回首是否有这个疾病
	//b  /// Express
	q:(rStr) 1
	q 0
}

}
