Class web.DHCPE.Query.RunQianQuery Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","DocWork","2013-01-01","2014-10-01")
Query DocWork(BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLocID As %String = "") As %Query(ROWSPEC = "RecLoc:%String,DocId:%String,DocName:%String,ARCIMDesc:%String,AccountAmount:%Float,FactAmount:%Float") [ SqlProc ]
{
}

ClassMethod DocWorkExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLocID As %String = "") As %Status
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
 	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
 	//s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
 	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
 	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","GetItem","2017-12-13","2017-12-13","13338||1","","","")
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","ArrNoPay","2020-01-01","2020-1-27")
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

/// 弃检数量及具体科室查询
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","PERefuseCheckInfo","2018-09-20","2019-05-31")
Query PERefuseCheckInfo(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "GDesc:%String,RegNo:%String,Name:%String,ARCIMDesc:%String,RecLocDesc:%String") [ SqlProc ]
{
}

ClassMethod PERefuseCheckInfoExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	
 	i BeginDate="" s BeginDate=+$h
	e  s BeginDate=$zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
	
 	
	s AdmDate=0
	s:(""'=BeginDate) AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",BeginDate), -1)
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)||((""'=EndDate)&&(AdmDate>EndDate))  d
	.s AdmTime=0
	.f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime)) q:AdmTime=""  d
	..s IADM=""
	..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADM)) q:IADM=""  d
	...d GetIADMInfo
	
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
	e  d
	.s GDesc="个人"
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

// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","Income","2016-12-1","2016-12-10")

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

// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","Arrearage","2016-11-14","2016-11-14")

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

Query StationWorkStatisticNew(DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Query(ROWSPEC = "Loc:%String:科室, ArcDesc:%String:检查项目, INum:%String:个检人次, IAmount:%String:个检金额, GNum:%String:团检人次,GAmount:%String:团检金额,Num:%String:人次合计,Amount:%String:金额合计") [ SqlProc ]
{
}

ClassMethod StationWorkStatisticNewExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateBegin)&&(""=DateEnd){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DateBegin'=""  s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
 	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
 	
 	k ^DHCPETMPSTA
 	
 	i (""'=DateBegin)  s SSAduitDate=DateBegin-1
    i (""=DateBegin)   s SSAduitDate=0
    i (""=DateEnd)     s DateEnd=+$h 
    
    ///按到达统计
    i (""'=DateBegin)  s AdmDate=DateBegin-1
    i (""=DateBegin)   s AdmDate=0
    i (""=DateEnd)     s DateEnd=+$h  
	f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||((0'=+DateEnd)&(AdmDate>DateEnd))  d
	.s AdmTime=0
	.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...s PAADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...Q:(""=PAADM)
	...s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))	;已到达没任何结果退出
	...q:RLTDR=""
	...s GADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
	...s PIADM=$p(^DHCPEIADM(IAdmRowId),"^",4)
	...s PIBI=$p(^DHCPEPreIADM(PIADM),"^",1)
	...s Reg=$p(^DHCPEPreIBI(PIBI),"^",1)
	...//用于具体人员信息
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....// 过滤非医嘱站点
	.....s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	.....s OEORIStat=$p(^OEORD($p(OEORDRowId,"||",1),"I",OEORIChildsub,1),"^",13)
	.....q:(OEORIStat=4)
	.....s ARCID=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
	.....q:(ARCID="")
	.....s RecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
	.....s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,0))
	.....q:(STDR=7)
	.....s STDR=RecDepDR
	.....q:(STDR="")
	.....//q:(STIDS'[("^"_STDR_"^"))
	.....s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,0))
	.....q:(crmodr="")
	.....s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	.....s:(GADM'="") FactAmount=1 //##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,AdmDate,"","","","")
	.....s:(GADM="") FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
 	.....s ^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))+1
 	.....s ^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))+FactAmount
 	.....s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))+1
 	.....s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))+FactAmount
 	.....s:(GADM="") ^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))+1
 	.....s:(GADM="") ^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))+FactAmount
 	
    ///检验的按照状态记录检索
    i (""'=DateBegin)  s AdmDate=DateBegin-1
    i (""=DateBegin)   s AdmDate=0
    i (""=DateEnd)     s DateEnd=+$h  
    f  s AdmDate=$o(^OEORDi(0,"StatDate",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)  d
    .s Ord=0
    .f  s Ord=$o(^OEORDi(0,"StatDate",AdmDate,Ord)) q:(Ord="")  d
    ..s PAADM=$p($g(^OEORD(Ord)),"^",1)
    ..q:(PAADM="")
    ..s IADM=($o(^DHCPEIADM(0,"PAADM",PAADM,0)))
    ..q:(IADM="")
    ..s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
    ..s ori=0
    ..f  s ori=$o(^OEORDi(0,"StatDate",AdmDate,Ord,ori)) q:(ori="")  d
    ...s ARCID=$p(^OEORD(Ord,"I",ori,1),"^",2)
    ...s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,0))
	...q:(STDR'=7)
    ...s OEORIStat=$p(^OEORD(Ord,"I",ori,1),"^",13)
	...q:(OEORIStat'=6)
	...s ssub=$o(^OEORDi(0,"StatDate",AdmDate,Ord,ori,""),-1)
	...q:(ssub="")
	...s curstat=$p(^OEORD(Ord,"I",ori,"ST",ssub),"^",3)
	...q:(curstat'=6)
    ...s RecDepDR=$p(^OEORD(Ord,"I",ori,3),"^",6)
    ...s STDR=RecDepDR
    ...;s STDR="R"_RecDepDR
    ...s crmodr=$O(^DHCPECRMO(0,"OEORI",Ord_"||"_ori,0))
	...q:(crmodr="")
	...s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	...s:(GADM'="") FactAmount=1 //##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,AdmDate,"","","","")
	...s:(GADM="") FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
    ...s ^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))+1
 	...s ^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))+FactAmount
 	...s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))+1
 	...s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))+FactAmount
 	...s:(GADM="") ^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))+1
 	...s:(GADM="") ^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))+FactAmount
    
     
    
 	 	
 	s STDR=0
 	f  s STDR=$o(^DHCPETMPSTA("NewStatistic","allNum",STDR)) q:(STDR="")  d
 	.;s:($l(STDR,"R")>1) STDesc=$p($P($G(^CTLOC($p(STDR,"R",2))),"^",2),"-",2)
 	.;s:($l(STDR,"R")=1) STDesc=$p(^DHCPEST(STDR),"^",2)
 	.s STDesc=$P($G(^CTLOC(STDR)),"^",2)
 	.s ARCID=0
 	.f  s ARCID=$o(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)) q:(ARCID="")  d
 	..s ARCDesc=$p(^ARCIM(+ARCID,1,1),"^",2)
 	..//DateBegin
 	..s CurGAmt=##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,DateBegin,"","","","")
 	..s INum=+$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))
 	..s IAmount=+$G(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))
 	..s GNum=+$G(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))
 	..s GAmount=CurGAmt*GNum  //+$G(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))
 	..s AllNum=+$G(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))
 	..s AllAmount=IAmount+GAmount  //+$G(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))
 	..s Data=$LB(STDesc, ARCDesc, INum, IAmount, GNum,GAmount,AllNum,AllAmount)
 	..d StationWorkStatisticOutNew2

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkStatisticOutNew2
 	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
 	q
}

ClassMethod StationWorkStatisticNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationWorkStatisticNewExecute ]
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

ClassMethod StationWorkStatisticNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationWorkStatisticNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 患病人数、年龄分段、
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamDiagnosisReport","15")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
/// 体检团体报告润乾 Start  yd
/// -------------------------------------------------------------------------------------------
/// 患病人数、年龄分段、
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamDiagnosisReport","87")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
Query TeamDiagnosisReport(GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Sex:%String,SexValue:%String,Bob:%String,DeptNo:%String,DiagnosisDesc:%String,One:%String,Two:%String,Three:%String,Four:%String,Five:%String,Six:%String,Seven:%String,FactPerson:%String,ManPerson:%String,WoManPerson:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	k ^TMPGREPORTNew
	k ^DHCPETEMPAdviceNew
 	s ind=1
 	s AgeFrom= 0, AgeTo= 100, AgeStep = 10
 	s FactPerson=..GetPerson(GADMDR,Depart)
 	s ManPerson=..GetManPerson(GADMDR,Depart)
 	s WoManPerson=..GetWoManPerson(GADMDR,Depart)
 	
 	s Name="",RegNo="",Sex="",Bob="",DeptNo="",DiagnosisDesc="",One="",Two="",Three="",Four="",Five="",Six="",Seven="",SexValue=1
 	s SexValue=1
 	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLOCID)),"^",1)
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
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
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADMRowId,GSRowId)) Q:(""=GSRowId)  d
	..s AuditUser=$p(^DHCPEGS(GSRowId,1),"^",5)
	..q:AuditUser=""  
	..s MainUser=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR))
	..s GSDChildSub=0
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d // 
	...// 当前客户患有疾病
	...S HaveConclusFlag=""    
	...s IsDiagnosis=1
	...s Diagnosis=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...//Q:HaveConclusFlag=1     
    ...///按照疾病统计
	..i DiagnosisType="Y" d
	...
	...s GSIll=0
	...f  s GSIll=$o(^User.DHCPEGSIllnessI("IndexParref",GSRowId,GSIll)) q:GSIll=""  d
	....s GSIllnessID=$lg(^User.DHCPEGSIllnessD(GSIll),3)
	....s GSIStatus=$lg(^User.DHCPEGSIllnessD(GSIll),8)
	....q:GSIStatus'=0
	....s Type=$p($g(^DHCPEILLS(GSIllnessID)),"^",11)
	....q:Type'=1  //疾病类型：团体报告
	....s DiagnosisDesc=""
	....s DiagnosisDesc=$p($g(^DHCPEILLS(GSIllnessID)),"^",2)
	....///判断某人是否已经在此种疾病列表里面
	....s Flag=$G(^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID))
	....q:Flag=1
	....s ^TMPGREPORTNew("GReport","Temp",PreIADM,GSIllnessID)="1"
	....Q:$G(^DHCPEILLS(GSIllnessID))=""
	....s ^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",GSIllnessID))+1
	....s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",GSIllnessID)=DiagnosisDesc
	....d TeamDiagnosisReportOutput
	..e  d   /////按照诊断统计
	...s Status=""
	...s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
	...q:Status'="0"
	...s EDDiagnoseConclus=$P($G(^DHCPEED(Diagnosis,1)),"^",1)
	...Set GSDRowId=GSRowId_"||"_GSDChildSub   
	...If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   
	....Set EDDiagnoseConclus=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
	....i EDDiagnoseConclus["]" s EDDiagnoseConclus=$P(EDDiagnoseConclus,"]",1)_"]"  
	...s DiagnosisDesc=EDDiagnoseConclus
	...s ^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis)=+$G(^DHCPETEMPAdviceNew(GADMDR,"Count",Diagnosis))+1
	...s ^DHCPETEMPAdviceNew(GADMDR,"ILLnessID",Diagnosis)=EDDiagnoseConclus
    ...
	...d TeamDiagnosisReportOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisReportOutput

	set Data=$lb(Name,RegNo,Sex,SexValue,Bob,DeptNo,DiagnosisDesc,One,Two,Three,Four,Five,Six,Seven,FactPerson,ManPerson,WoManPerson)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 得到团体受检人数:存在已执行项目即算是已检
/// w d ##class(web.DHCPE.Query.RunQianQuery).GetPerson("15")
ClassMethod GetPerson(GADMDR, Depart As %String = "")
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"       
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:PEIADM=""
	.s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	.q:PAADM=""
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(PAADM)=0
	.s FactPerson=FactPerson+1
	q FactPerson
}

/// 得到团体受检男性人数
/// w d ##class(web.DHCPE.Query.RunQianQuery).GetManPerson("15")
ClassMethod GetManPerson(GADMDR, Depart As %String = "")
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"        
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.q:Sex'="男"
	.s FactPerson=FactPerson+1
	q FactPerson
}

/// 得到团体受检女性人数
/// w d ##class(web.DHCPE.Query.RunQianQuery).GetWoManPerson("15")
ClassMethod GetWoManPerson(GADMDR, Depart As %String = "")
{
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"        
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.q:Sex'="女"
	.s FactPerson=FactPerson+1
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamReport","15")  ;ReceivingDepartment,ActualAmount,DiscountAmount2
Query TeamReport(GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Query(ROWSPEC = "Sex:%String,SexValue:%String,One:%String,Two:%String,Three:%String,Four:%String,Five:%String,Six:%String,Seven:%String") [ SqlProc ]
{
}

ClassMethod TeamReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	
 	s ind=1
 	s AgeFrom= 0, AgeTo= 100, AgeStep = 10
 	s Sex="",SexValue=1,One="",Two="",Three="",Four="",Five="",Six="",Seven=""
 	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
 	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLOCID)),"^",1)
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
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
	.i Age<20 s One= 1
	.i ((Age>=20)&(Age<=29)) s Two=1
	.i ((Age>=30)&(Age<=39)) s Three=1
	.i ((Age>=40)&(Age<=49)) s Four=1
	.i ((Age>=50)&(Age<=59)) s Five=1
	.i ((Age>=60)&(Age<=69)) s Six=1
	.i ((Age>=70)) s Seven =1
	.d TeamReportOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamReportOutput

	set Data=$lb(Sex,SexValue,One,Two,Three,Four,Five,Six,Seven)
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamBaseInfo","69","测试")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamBaseInfo(GADMDR As %Library.String = "", Depart As %String = "") As %Query(ROWSPEC = "GroupName:%String,TeamType:%String,StartDate:%String,EndDate:%String,SumPerson:%String,FactPerson:%String") [ SqlProc ]
{
}

ClassMethod TeamBaseInfoExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "") As %Status
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
	s GroupName=$P($G(^DHCPEGBI(GBIDR)),"^",2)
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s SumPerson=0
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s SumPerson=SumPerson+1
	.q:Status'="ARRIVED"
	.
	.s IADMRowId=""
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
	.s FactPerson=FactPerson+1
	.s CTLocdr=$p($G(^PAADM(IADMPAADMDR)),"^",4)
	.s TeamType="健康体检"
	.;i CTLocdr="143" s TeamType="VIP体检"
	d TeamBaseInfoOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamBaseInfoOutput

	set Data=$lb(GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson)
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamOrdItem","87")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamOrdItem(GADMDR As %Library.String = "", Depart As %String = "") As %Query(ROWSPEC = "OrderName:%String") [ SqlProc ]
{
}

ClassMethod TeamOrdItemExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s TeamType=""
	k ^DHCPETempARCIMOrdItem
	
 	s ind=1
	//  DHC_PE_GADM.{ GADM_GBI_DR}
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
    s ChildSub=0
    f  s ChildSub=$O(^DHCPEPreGADM(PreGADM,"Team",ChildSub)) q:ChildSub=""  d
    .s ItemSubId=0
    .f  s ItemSubId=$O(^DHCPEPreGADM(PreGADM,"Team",ChildSub,"ORDITEM",ItemSubId)) q:ItemSubId=""  d
    ..s ArcItemId=$p($G(^DHCPEPreGADM(PreGADM,"Team",ChildSub,"ORDITEM",ItemSubId)),"^",1)
    ..;b ;1
    ..s StationID=$O(^DHCPEST(0,"STORD_ARCIM",ArcItemId,0))
    ..q:StationID=""
    ..s ^DHCPETempARCIMOrdItem("ArcItemId",StationID,ArcItemId)=""
    ..
    b ;1
	s OrderName=""
	s StationID=""
	f  s StationID=$O(^DHCPETempARCIMOrdItem("ArcItemId",StationID)) q:StationID=""  d
	.
	.s ordMastId=""
	.f  s ordMastId=$O(^DHCPETempARCIMOrdItem("ArcItemId",StationID,ordMastId)) q:ordMastId=""  d
	..s ARCIMDesc=$P($G(^ARCIM($P(ordMastId,"||",1),$P(ordMastId,"||",2),1)),"^",2)
	..i OrderName="" d
	...s OrderName="    "_ARCIMDesc
	..e  d
	...s OrderName=OrderName_","_ARCIMDesc
	
	d TeamOrdItemOutput
	

	
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamAdvice","15")  GroupName,TeamType,StartDate,EndDate,SumPerson,FactPerson
Query TeamAdvice(GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Query(ROWSPEC = "Advice:%String") [ SqlProc ]
{
}

ClassMethod TeamAdviceExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "", CTLOCID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s Advice=""
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLOCID)),"^",1)
	;^DHCPETEMPAdviceNew("ILLnessID",36)	=	"超重"
 	s ind=1
 	s num=0,Count=0,SumCount=0
 	s SumCount=..GetPersonNew(GADMDR,Depart)
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamDiagnosisReportNew","15") 
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
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
    .
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.s Name=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)
	.s PAPERDob=$p($g(^PAPER(PAPMIdr,"ALL")),"^",6)
	.i PAPERDob'="" s Bob=$zd(PAPERDob,3)
 	.i PAPERDob'="" d
 	..;s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..;s Age=+$P(Age,"Y",1)
 	..i PAPMIdr'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIdr)
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

// w d ##class(web.DHCPE.Query.RunQianQuery).GetPerson("15")

/// 得到团体受检人数
ClassMethod GetPersonNew(GADMDR, Depart As %String = "")
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
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
	.s FactPerson=FactPerson+1
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQianQuery).GetManPerson("15")

/// 得到团体受检男性人数
ClassMethod GetManPersonNew(GADMDR)
{
	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s FactPerson=0
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""   d
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s One=0,Two=0,Three=0,Four=0,Five=0,Six=0,Seven=0         
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:Status'="ARRIVED"
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.Q:(""=IADMPAADMDR)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
	.s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	.s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
	.s RegNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)
	.s:(""'=PAPERSex) Sex=$p(^CT("SEX",PAPERSex),"^",2)
	.q:Sex'="男"
	.s FactPerson=FactPerson+1
	q FactPerson
}

// w d ##class(web.DHCPE.Query.RunQianQuery).GetWoManPerson("15")

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
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamBaseInfoNew","15")
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","TeamDiagnosisPersonReport","97") 
Query TeamDiagnosisPersonReport(GADMDR As %Library.String = "", Depart As %String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Sex:%String,Tel:%String,Age:%String,DiagnosisDesc:%String") [ SqlProc ]
{
}

ClassMethod TeamDiagnosisPersonReportExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	s PreGADM=$P(^DHCPEGADM(GADMDR),"^",2)
	s PreIADM=0
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PGADM",PreGADM,PreIADM)) q:PreIADM=""  d
	.s Name="",RegNo="",Sex="",Tel="",Age="",DiagnosisDesc="",DiagnoseConclusion=""      
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status="CANCELPREREG"
	.q:Status="CANCELPE"
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"     
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
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
 	..;s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	..;s Age=+$P(Age,"Y",1)
 	..i PAPMIdr'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIdr,IADMPAADMDR)
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
	...s Status=""
	...s Status=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",11)
	...q:Status'=0
	...s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
	...;w !,
	...Set GSDRowId=GSRowId_"||"_GSDChildSub   //Add 20080728
	...If $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 Do   //Add 20080728
	....Set DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))   //Add 20080728
	....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion,$C(10),"")
	....s DiagnoseConclusion=##class(web.DHCPE.Public.Setting).Replace(DiagnoseConclusion," ","")
	...i DiagnosisDesc="" d 
	....s DiagnosisDesc=DiagnoseConclusion
	...e  d
	....s DiagnosisDesc=DiagnosisDesc_" "_DiagnoseConclusion
	.q:DiagnosisDesc=""
	.d TeamDiagnosisPersonReportOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TeamDiagnosisPersonReportOutput

	set Data=$lb(Name,RegNo,Sex,Tel,Age,DiagnosisDesc)
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
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Query.RunQianQuery","PersonName","97") 
Query PersonName(GADMDR As %Library.String = "", Depart As %String = "") As %Query(ROWSPEC = "Name1:%String,Name2:%String,Name3:%String,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String") [ SqlProc ]
{
}

ClassMethod PersonNameExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "", Depart As %String = "") As %Status
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
	.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"  
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	.q:((Depart'="")&&(TPosition'[Depart))
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADMRowId=""
	.s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	.q:##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(IADMPAADMDR)=0
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

}
