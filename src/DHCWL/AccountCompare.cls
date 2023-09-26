Class DHCWL.AccountCompare Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//比较在院病人费用是否一致  DHCWL_Account.Period DHCWL_Account.DayDetail DHCWLAccount

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAccPatDetails","2016-06-10","1","","")

//CheckFlag:是否全部显示，0－全部，1－有问题的病人 

Query GetAccPatDetails(DateName As %String, CheckFlag As %Integer, admId As %String, status1 As %String) As %Query(ROWSPEC = "adm:%String,PatNo:%String,PatMedNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatReason:%String,admdate:%String,admdisdate:%String,billflagdate:%String,PATLast:%Float,PATH:%Float,PATI:%Float,PATC:%Float,PATCOLD:%Float,TomorrowOrd:%String,flag:%Integer,tomorrowFee:%Float,status:%String,Deposit:%Float") [ SqlProc ]
{
}

ClassMethod GetAccPatDetailsExecute(ByRef qHandle As %Binary, DateName As %String, CheckFlag As %Integer, admId As %String, status1 As %String) As %Status
{
 k ^TEMPDHCWL($j),^TEMPDHCWLData($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:DateName="" $$$OK
 
 ;d SplitMulitData(admId,,.admIdData)
 d SplitMulitData(status1,,.status1Data)
 i CheckFlag="" s CheckFlag=0
 s date=$zdh(DateName,3)
 s AccOldID=0 f  s AccOldID=$o(^DHCWLACCOUNT(0,"AccName",DateName,AccOldID)) q:AccOldID=""  d
 .d ..QueryDetailOld(AccOldID)
 
 s lastAccId=$o(^DHCWL.Account.PeriodI("AccDate",date-1,""))
 d ..GetLastFee(lastAccId)
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",date,AccPeriodID))  q:AccPeriodID=""  d
 .d ..QueryDetail(AccPeriodID) 
 s adm="" f  s adm=$o(^TEMPDHCWL($j,adm)) q:adm=""  d
 .//s status=##class(web.UDHCJFBaseCommon).GetAdmVistbyDate(adm,DateName)
 .//s Deposit=##class(web.DHCIPBillFinReports).GetAdmDeposit(adm,DateName)  //2014-08-13 add 预交金
 .//判断科室是否为所选状态
 .//q:(status1'="")&&(status="") 
 .//q:(status1'="")&&('$d(status1Data(status)))
 .//q:adm'=14184
 .//i admId'="" q:$F(","_admId_",",","_adm_",")=0 
 .s papmi=$p($g(^PAADM(adm)),"^",1)
 .s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 .s PatMedNo=$$GetPapmiMedtare^DHCWLCommon(papmi)
 .s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 .s PatAge=$$GetAge^DHCWLCommon(papmi)
 .s PatSex=$$GetSex^DHCWLCommon(papmi)
 .s PatReason=$$GetReason^DHCWLCommon(adm)
 .s admdate=$zd($p($g(^PAADM(adm)),"^",6),3)
 .s disdate=$p($g(^PAADM(adm)),"^",17)
 .i disdate'="" s admdisdate=$zd(disdate,3)
 .e  s admdisdate=""
 .s mbillflagdate=+$$GetBillFlagDate^DHCWLCommon(adm)
 .i mbillflagdate'=0 s billflagdate=$zd(mbillflagdate,3)
 .e  s billflagdate=""
 .i billflagdate'="" s TomorrowOrd=$$GetTomorrowOrd^DHCWLCommon(adm,mbillflagdate)
 .e  s TomorrowOrd="N"
 .;s tomorrowFee=..GetTomorrowFee(adm,mbillflagdate)
 .s tomorrowFee=..GetTomorrowFee(adm,$zdh(DateName,3))  ;2014-08-05
 .i tomorrowFee=0 s tomorrowFee=""
 .s PATH=+$g(^TEMPDHCWL($j,adm," H","PatDetails"))
 .s PATI=+$g(^TEMPDHCWL($j,adm," I","PatDetails"))
 .s PATC=+$g(^TEMPDHCWL($j,adm," C","PatDetails"))
 .s PATLast=+$g(^TEMPDHCWL($j,adm,"Last","PatDetails"))
 .s PATCOld=+$g(^TEMPDHCWL($j,adm,"C","PatDetailsOld"))
 .i (PATLast=0)&(PATI=0)&(PATH=0)&(PATC=0)&(PATCOld=0)  q
 .s flag=9999
 .//i PATC=PATCOld s flag=1
 .i (PATC'=PATCOld)&((PATC+$g(tomorrowFee))'=PATCOld) s flag=1    //余额加明日医嘱不等his余额
 .i (PATC=PATCOld)&(billflagdate'="")&(mbillflagdate<=date)&(PATC'=0) s flag=2   //病人已最终财物结算还有账单费用
 .i (PATC'=PATCOld)&((PATC+$g(tomorrowFee))=PATCOld) s flag=3     //期末余额与his余额不等但余额加明日医嘱相等，这种不是有问题的病人
 .//i (PATC'=0)&(PATCOld=0)&($zabs(PATC)=$g(tomorrowFee)) s flag=1
 .i CheckFlag'=0 q:flag=1
 .i CheckFlag'=0 s ^TEMPDHCWLData($j)=$g(^TEMPDHCWLData($j))+1
 .;i (PATCOld'=PATC)&((PATC+tomorrowFee)'=0) s ^TEMPDHCWLERR("ERR",adm)=adm
 .d OutputRow
 k ^TEMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow
	set Data=$lb(adm,PatNo,PatMedNo,PatName,PatAge,PatSex,PatReason,admdate,admdisdate,billflagdate,PATLast,PATH,PATI,PATC,PATCOld,TomorrowOrd,flag,tomorrowFee,status,Deposit)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SplitMulitData(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetAccPatDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccPatDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccPatDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccPatDetailsExecute ]
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

ClassMethod QueryDetail(wlaccDr) As %Status
{
     s typeIndex=""  f  s typeIndex=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex)) q:typeIndex=""  d
     .//q:typeIndex=" C"
     .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex,accDataDr)) q:accDataDr=""  d
     ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
     ..i admId'="" q:$F(","_admId_",",","_adm_",")=0
     ..s papmi=$p($g(^PAADM(adm)),"^",1)
     ..s free=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
     ..s ^TEMPDHCWL($j,adm,typeIndex,"PatDetails")=$g(^TEMPDHCWL($j,adm,typeIndex,"PatDetails"))+free
     q
}

//取DHCWLACCDETAIL表中的在院费用

ClassMethod QueryDetailOld(wlaccOldDr) As %Status
{
 s typeoldIndex=0 f  s typeoldIndex=$o(^DHCWLACCDETAIL(0,"ACCType",wlaccOldDr,typeoldIndex)) q:typeoldIndex=""  d
 .q:typeoldIndex'="C"
 .s accDetId=0 f  s accDetId=$o(^DHCWLACCDETAIL(0,"ACCType",wlaccOldDr,typeoldIndex,accDetId)) q:accDetId=""  d
 ..s accAdmDr=$p(^DHCWLACCDETAIL(accDetId),"^",6)
 ..i admId'="" q:$F(","_admId_",",","_accAdmDr_",")=0
 ..s admReasonDr=$p($g(^PAADM(accAdmDr,1)),"^",7)
 ..s patFee=0
 ..s patFee=$fn($p(^DHCWLACCDETAIL(accDetId),"^",2),"",2)
 ..s ^TEMPDHCWL($j,accAdmDr,typeoldIndex,"PatDetailsOld")=$g(^TEMPDHCWL($j,accAdmDr,typeoldIndex,"PatDetailsOld"))+$g(patFee)
}

ClassMethod GetLastFeeold(AccOldID) As %Status
{
 q:AccOldID=""
 s lastAccId=$o(^DHCWLACCOUNT(AccOldID),-1)
 s accDetId=0 f  s accDetId=$o(^DHCWLACCDETAIL(0,"ACCType",lastAccId,"C",accDetId)) q:accDetId=""  d
 .s accAdmDr=$p(^DHCWLACCDETAIL(accDetId),"^",6)
 .s admReasonDr=$p($g(^PAADM(accAdmDr,1)),"^",7)
 .s lastPatFee=$p(^DHCWLACCDETAIL(accDetId),"^",2)
 .s ^TEMPDHCWL($j,accAdmDr,"Last","PatDetailsOld")=$g(^TEMPDHCWL($j,accAdmDr,"Last","PatDetailsOld"))+$g(lastPatFee)
 q
}

ClassMethod GetLastFee(lastAccId) As %Status
{
 Q:lastAccId=""
 //s lastAccId=$o(^DHCWL.Account.PeriodD(AccID),-1)
 i lastAccId="" d     //DHCWL_Account.Period表中上期为空时取DHCWLACCDetail表中的在院数据
 .s accDetId=0 f  s accDetId=$o(^DHCWLACCDETAIL(0,"ACCType",1,"C",accDetId)) q:accDetId=""  d   //941为DHCWLAccount表中ID
 ..s accAdmDr=$p(^DHCWLACCDETAIL(accDetId),"^",6)
 ..i admId'="" q:$F(","_admId_",",","_accAdmDr_",")=0 
 ..s admReasonDr=$p($g(^PAADM(accAdmDr,1)),"^",7)
 ..s lastPatFee=$fn($p(^DHCWLACCDETAIL(accDetId),"^",2),"",2)
 ..s ^TEMPDHCWL($j,accAdmDr,"Last","PatDetails")=$g(^TEMPDHCWL($j,accAdmDr,"Last","PatDetails"))+lastPatFee
 e  d
 .s accDataDr=0 f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",lastAccId," C",accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..i admId'="" q:$F(","_admId_",",","_adm_",")=0 
 ..s lastPatFee=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
 ..s ^TEMPDHCWL($j,adm,"Last","PatDetails")=$g(^TEMPDHCWL($j,adm,"Last","PatDetails"))+lastPatFee
 q
}

/// 取明日医嘱费用
/// w ##class(DHCWL.AccountCompare).GetTomorrowFee("21","61206")
ClassMethod GetTomorrowFee(adm, billFlagDate) As %Status
{
 n (adm, billFlagDate)
 s wldr=0 f  s wldr=$o(^DHCWorkLoad(0,"PAADM",adm,wldr)) q:wldr=""  d
 .s orddate=$p(^DHCWorkLoad(wldr),"^",5)
 .q:orddate<=billFlagDate
 .s statdate=$p(^DHCWorkLoad(wldr),"^",7)
 .q:statdate>(billFlagDate+1)
 .;s flagDate=$p(^DHCWorkLoad(wldr),"^",27)
 .;q:(flagDate'="")&&(flagDate<=billFlagDate)
 .s price=$p(^DHCWorkLoad(wldr),"^",16)
 .s totalPrice=$g(totalPrice)+price
 .
 q $g(totalPrice)
}

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAccountDateName") 

ClassMethod GetAccountDateNameExecute(ByRef qHandle As %Binary) As %Status
{
	k ^TEMPDHCWL($j)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s rowid=""
	f  s rowid=$o(^DHCWL.Account.PeriodD(rowid)) q:rowid=""  d
	.s accNa=$li($g(^DHCWL.Account.PeriodD(rowid)),4)
	.s ^TEMPDHCWL($j,accNa)=rowid
	s accDesc="" f  s accDesc=$o(^TEMPDHCWL($j,accDesc),-1) q:accDesc=""  d
	.s accName=$zd(accDesc,3)
	.s rowid=$g(^TEMPDHCWL($j,accDesc))
    .d OutputRow2
     
	q $$$OK	
OutputRow2
    
    s Data=$lb(rowid,accName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAccountDateNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountDateNameExecute ]
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

ClassMethod GetAccountDateNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountDateNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAccountDateName() As %Query(ROWSPEC = "rowid:%Integer,accName:%String") [ SqlProc ]
{
}

//取WORKLOAD表中病人所有费用，按日期、核算子分类汇总

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAdmDetails","4")

Query GetAdmDetails(adm As %String) As %Query(ROWSPEC = "mdate:%String,tECdesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetAdmDetailsExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 k ^TEMPDHCWL($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
   
 q:adm="" $$$OK
 s wldr=0 f  s wldr=$o(^DHCWorkLoad(0,"PAADM",adm,wldr)) q:wldr=""  d
 .s orddate=$p(^DHCWorkLoad(wldr),"^",5)
 .s tarECdr=$p(^DHCWorkLoad(wldr),"^",41)    //核算子分类
 .s price=$p(^DHCWorkLoad(wldr),"^",16)
 .s ^TEMPDHCWL($j,orddate,tarECdr)=$g(^TEMPDHCWL($j,orddate,tarECdr))+price
 
 s date=0 f  s date=$o(^TEMPDHCWL($j,date)) q:date=""  d
 .s tECdr=0 f  s tECdr=$o(^TEMPDHCWL($j,date,tECdr)) q:tECdr=""  d
 ..s mdate=$zd(date,3)
 ..s tECdesc=$p(^DHCTarC("EC",tECdr),"^",2)
 ..s fee=$g(^TEMPDHCWL($j,date,tECdr))
 ..d OutputRow1
 k ^TEMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow1
	set Data=$lb(mdate,tECdesc,fee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmDetailsExecute ]
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

//取WORKLOAD表中病人所有费用，按日期、核算子分类汇总

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAdmPrtDetails","4")

Query GetAdmPrtDetails(adm As %String) As %Query(ROWSPEC = "mastdesc:%String,moeoridr:%String,pbfee:%Float,wlfee:%Float,flag:%Integer") [ SqlProc ]
{
}

ClassMethod GetAdmPrtDetailsExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 k ^TEMPDHCWL($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
   
 q:adm="" $$$OK
 s wldr=0 f  s wldr=$o(^DHCWorkLoad(0,"PAADM",adm,wldr)) q:wldr=""  d
 .s orddate=$p(^DHCWorkLoad(wldr),"^",5)
 .s tarECdr=$p(^DHCWorkLoad(wldr),"^",41)    //核算子分类
 .s price=$p(^DHCWorkLoad(wldr),"^",16)
 .s oeoridr=$p(^DHCWorkLoad(wldr),"^",21)
 .s ItemOrddr=$p(^DHCWorkLoad(wldr),"^",2)
 .s ^TEMPDHCWL($j,oeoridr,ItemOrddr,"wl")=$g(^TEMPDHCWL($j,oeoridr,ItemOrddr,"wl"))+price
 
 s prtdr=0 f  s prtdr=$o(^DHCINVPRTZY(0,"ADM",adm,prtdr)) q:prtdr=""  d
 .s pbdr=$p(^DHCINVPRTZY(prtdr),"^",5)
 .s pbodr=0 f  s pbodr=$o(^DHCPB(pbdr,"O",pbodr)) q:pbodr=""  d
 ..s OEORIDR=$P($G(^DHCPB(pbdr,"O",pbodr)),"^",4)
 ..s ARCIMDR=$P($G(^DHCPB(pbdr,"O",pbodr)),"^",3)
 ..s pbddr=0 f  s pbddr=$o(^DHCPB(pbdr,"O",pbodr,"D",pbddr)) Q:pbddr=""  d
 ...s mPrtFee=$p($g(^DHCPB(pbdr,"O",pbodr,"D",pbddr)),"^",7)
 ...s ^TEMPDHCWL($j,OEORIDR,ARCIMDR,"pb")=$g(^TEMPDHCWL($j,OEORIDR,ARCIMDR,"pb"))+mPrtFee
 
 s moeoridr=0 f  s moeoridr=$o(^TEMPDHCWL($j,moeoridr)) q:moeoridr=""  d
 .s arcmast=0 f  s arcmast=$o(^TEMPDHCWL($j,moeoridr,arcmast)) q:arcmast=""  d
 ..s mastdesc=$p(^ARCIM(+arcmast,1,1),"^",2)
 ..s pbfee=$g(^TEMPDHCWL($j,moeoridr,arcmast,"pb"))
 ..s wlfee=$g(^TEMPDHCWL($j,moeoridr,arcmast,"wl"))
 ..i pbfee'=wlfee s flag=0
 ..e  s flag=1
 ..d OutputRow3
 k ^TEMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow3
	set Data=$lb(mastdesc,moeoridr,pbfee,wlfee,flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmPrtDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmPrtDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmPrtDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmPrtDetailsExecute ]
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

//取病人的明日医嘱费用，按日期、核算子分类汇总

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAdmTomorrowOrdDetails","4")

Query GetAdmTomorrowOrdDetails(adm As %String) As %Query(ROWSPEC = "mdate:%String,tECdesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetAdmTomorrowOrdDetailsExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 k ^TEMPDHCWL($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
   
 q:adm="" $$$OK
 s mbillflagdate=+$$GetBillFlagDate^DHCWLCommon(adm)
 s wldr=0 f  s wldr=$o(^DHCWorkLoad(0,"PAADM",adm,wldr)) q:wldr=""  d
 .s orddate=$p(^DHCWorkLoad(wldr),"^",5)
 .q:orddate<=mbillflagdate
 .s tarECdr=$p(^DHCWorkLoad(wldr),"^",41)    //核算子分类
 .s price=$p(^DHCWorkLoad(wldr),"^",16)
 .s ^TEMPDHCWL($j,orddate,tarECdr)=$g(^TEMPDHCWL($j,orddate,tarECdr))+price
 
 s date=0 f  s date=$o(^TEMPDHCWL($j,date)) q:date=""  d
 .s tECdr=0 f  s tECdr=$o(^TEMPDHCWL($j,date,tECdr)) q:tECdr=""  d
 ..s mdate=$zd(date,3)
 ..s tECdesc=$p(^DHCTarC("EC",tECdr),"^",2)
 ..s fee=$g(^TEMPDHCWL($j,date,tECdr))
 ..d OutputRow4
 k ^TEMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow4
	set Data=$lb(mdate,tECdesc,fee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmTomorrowOrdDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTomorrowOrdDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmTomorrowOrdDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTomorrowOrdDetailsExecute ]
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

//取费用不一致病人数，传给李国良做的项目监控

//类型：PatFeeCheck

//类名：DHCWL.AccountCompare

//方法名：GetErrAdmFee

//参数：sDay开始日期，eDay结束日期

//说明：监控在院病人费用统计系统数据与HIS数据不一致的病人人数，结果1为不一致的人数

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetErrAdmFee","2008-8-10","2008-8-10")

Query GetErrAdmFee(sDay As %String, eDay As %String) As %Query(ROWSPEC = "admQty:%String") [ SqlProc ]
{
}

ClassMethod GetErrAdmFeeExecute(ByRef qHandle As %Binary, sDay As %String, eDay As %String) As %Status
{
 k ^TEMPDHCWL($j)
   
 i sDay="" s sDay=+$h
 i eDay="" s eDay=+$h
 s sDay=$zdh(sDay,3)
 s eDay=$zdh(eDay,3)
 f day=sDay:1:eDay d
 .d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAccPatDetails",$zd(day,3),"1","","")
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s admQty=$g(^TEMPDHCWLData($j))
 d OutputRow5
 k ^TEMPDHCWLData($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow5
	set Data=$lb(admQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetErrAdmFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetErrAdmFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetErrAdmFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetErrAdmFeeExecute ]
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

//在院病人余额分类统计汇总

//d ##class(%ResultSet).RunQuery("DHCWL.AccountCompare","GetAccPatItemFL","2014-08-12","A")

Query GetAccPatItemFL(DateName As %String, status1 As %String) As %Query(ROWSPEC = "wardcode:%String,warddesc:%String,cate:%String,DKName:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetAccPatItemFLExecute(ByRef qHandle As %Binary, DateName As %String, status1 As %String) As %Status
{
 k ^TEMPDHCWLWARD($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:DateName="" $$$OK
 
 d SplitMulitDataItem(status1,,.status1Data)
 s date=$zdh(DateName,3)
 s PATC=0
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",date,AccPeriodID))  q:AccPeriodID=""  d
 .s typeIndex=""  f  s typeIndex=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID,typeIndex)) q:typeIndex=""  d
 ..q:typeIndex'=" C"
 ..s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID,typeIndex,accDataDr)) q:accDataDr=""  d
 ...s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ...s status=##class(web.UDHCJFBaseCommon).GetAdmVistbyDate(adm,DateName)
 ...//判断科室是否为所选状态
 ...q:(status1'="")&&(status="") 
 ...q:(status1'="")&&('$d(status1Data(status)))
 ...s PATC=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
 ...s ward1=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),12)
 ...s cate1=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),6)  
 ...s ^TEMPDHCWLWARD($j,ward1,cate1)=$g(^TEMPDHCWLWARD($j,ward1,cate1))+PATC
 
 s ward=0 f  s ward=$o(^TEMPDHCWLWARD($j,ward)) q:ward=""  d
 .s cate=0 f  s cate=$o(^TEMPDHCWLWARD($j,ward,cate)) q:cate=""  d
 ..s outdata=$g(^TEMPDHCWLWARD($j,ward,cate))
 ..d OutputRowItem
 k ^TEMPDHCWLWARD($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowItem
    i ward="null" s warddesc="null"
    i $d(^CTLOC(ward)) d
    .s wardcode=$P($G(^CTLOC(ward)),"^",1)
    .s warddesc1=$P($G(^CTLOC(ward)),"^",2)
    .i warddesc1 [ "-" s warddesc=$p(warddesc1,"-",2)
    .e  s warddesc=warddesc1
    
    s RowidXm=$p(cate,"||",1)
    s RowidXmsub=$p(cate,"||",2)
    q:'$d(^DHCWLSTAT(41,"ITEM",RowidXmsub))
    s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
  
	set Data=$lb(wardcode,warddesc,cate,DKName,outdata)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SplitMulitDataItem(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetAccPatItemFLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccPatItemFLExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccPatItemFLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccPatItemFLExecute ]
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

/// Creator：      yuanxu
/// CreatDate：    2015-10-15
/// Description:： 财务监审接口
/// Table：       DHCWL_Account.Period DHCWL_Account.DayDetail DHCWLAccount
/// Input：       
/// Output：      
/// Return：      返回0费用一致，'=0费用不一致
/// Others：w ##class(DHCWL.AccountCompare).CompareFee("2014-2-15")
ClassMethod CompareFee(day, admId = "") As %String
{
	
	n (day,admId)
	k ^TEMPDHCWL($j)
	s num=0
	s day=$zdh(day,3)
    s AccOldID=0 f  s AccOldID=$o(^DHCWLACCOUNT(0,"AccName",day,AccOldID)) q:AccOldID=""  d
    .d ..QueryDetailOld(AccOldID)
    s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",day,AccPeriodID))  q:AccPeriodID=""  d
    .d ..GetLastFee(AccPeriodID)
    
    s adm="" f  s adm=$o(^TEMPDHCWL($j,adm)) q:adm=""  d
    .s PATC=+$g(^TEMPDHCWL($j,adm,"Last","PatDetails"))      //计算得到的财务在院费用
    .s PATCOld=+$g(^TEMPDHCWL($j,adm,"C","PatDetailsOld"))   //HIS在院费用
    .i PATC'=PATCOld s num=num+1
    k ^TEMPDHCWL($j)
	q num
}

Storage Default
{
<Data name="AccountCompareDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.AccountCompareD</DataLocation>
<DefaultData>AccountCompareDefaultData</DefaultData>
<IdLocation>^DHCWL.AccountCompareD</IdLocation>
<IndexLocation>^DHCWL.AccountCompareI</IndexLocation>
<StreamLocation>^DHCWL.AccountCompareS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
