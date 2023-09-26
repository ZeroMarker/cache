Class DHCWL.CompareOPFee Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 比较dhcworkload费用和发票dhcinvprtzy费用是否一致
/// 增加日期类型选择 1－医嘱日期 2－结算日期
/// d ##class(%ResultSet).RunQuery("DHCWL.CompareOPFee","GetWLAndPrtFee","2014-08-01","2014-08-01","1")
Query GetWLAndPrtFee(Sday As %String, Eday As %String, DateType As %String) As %Query(ROWSPEC = "wlfee:%Float,prtFee:%Float") [ SqlProc ]
{
}

ClassMethod GetWLAndPrtFeeExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String, DateType As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Sday,Eday,DateType)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Sday="" $$$OK
 q:Eday="" $$$OK
 i DateType="1" s WDateType="ORDDATE",PDateType="Date"
 i DateType="2" s WDateType="FlagDate",PDateType="HandDate"
 s Sday=$zdh(Sday,3)
 s Eday=$zdh(Eday,3)
 f day=Sday:1:Eday  d
 .s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,WDateType,day,wlId)) q:wlId=""  d  //ORDDATE
 ..s type=$p(^DHCWorkLoad(wlId),"^",4)
 ..q:(type'="O")&(type'="E")
 ..s price=$p(^DHCWorkLoad(wlId),"^",16)
 ..s wlfee=$g(wlfee)+price
 
 .s prtId=0 f  s prtId=$o(^DHCINVPRT(0,PDateType,day,prtId)) q:prtId=""  d   //Date
 ..s fee=$p(^DHCINVPRT(prtId),"^",1)
 ..s prtFlag=$p(^DHCINVPRT(prtId),"^",8)
 ..q:prtFlag="TP"  
 ..s prtFee=$g(prtFee)+fee
 
 s ^CacheTemp(repid,ind)=$lb(wlfee,prtFee)
 s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod GetWLAndPrtFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWLAndPrtFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWLAndPrtFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWLAndPrtFeeExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询费用不一致的病人
/// d ##class(%ResultSet).RunQuery("DHCWL.CompareOPFee","GetWLAndPrtErrFee","2020-5-1","2020-9-1","2")
Query GetWLAndPrtErrFee(Sday As %String, Eday As %String, DateType As %String, hosId As %String) As %Query(ROWSPEC = "adm:%String,PatNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatReason:%String,admdate:%String,pbidPara:%String,wlfee:%Float,prtfee:%Float,errFee:%Float") [ SqlProc ]
{
}

ClassMethod GetWLAndPrtErrFeeExecute(ByRef qHandle As %Binary, Sday As %String, Eday As %String, DateType As %String, hosId As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Sday,Eday,DateType,hosId)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Sday="" $$$OK
 q:Eday="" $$$OK
 i DateType="1" s WDateType="ORDDATE",PDateType="Date"
 i DateType="2" s WDateType="FlagDate",PDateType="HandDate"
 s Sday=$zdh(Sday,3)
 s Eday=$zdh(Eday,3)
 f day=Sday:1:Eday  d
 .s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,WDateType,day,wlId)) q:wlId=""  d  //ORDDATE
 ..s type=$p(^DHCWorkLoad(wlId),"^",4)
 ..q:(type'="O")&(type'="E")
 ..s price=$p(^DHCWorkLoad(wlId),"^",16)
 ..s wlAdmId=$p(^DHCWorkLoad(wlId),"^",12)
 ..s patDepDr=$p(^DHCWorkLoad(wlId),"^",3)
 ..s hosDr=$p(^CTLOC(patDepDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ..s ^TEMPDHCWL($j,wlAdmId,"wl")=$g(^TEMPDHCWL($j,wlAdmId,"wl"))+price
 ..//s wlfee=$g(wlfee)+price
 
 .s prtId=0 f  s prtId=$o(^DHCINVPRT(0,PDateType,day,prtId)) q:prtId=""  d   //Date
 ..s BCIRowid=0 f  s BCIRowid=$o(^DHCBCI(0,"INV",prtId,BCIRowid)) q:BCIRowid=""  d         ;门诊帐单与发票的对应表
 ...s prtAdmId=$p(^DHCBCI(BCIRowid),"^",3)
 ...s depDr=$p(^PAADM(prtAdmId),"^",4)
 ...s hosDr=$p(^CTLOC(depDr),"^",22)
 ..q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
 ...;s fee=$p(^DHCINVPRT(prtId),"^",1)
 ...s prtFlag=$p(^DHCINVPRT(prtId),"^",8)
 ...q:prtFlag="TP"  
 ...s mPBID=$p(^DHCBCI(BCIRowid),"^",2)
 ...s fee=$P(^DHCPB(+mPBID),"^",8)
 ...//i prtAdmId=8 b //
 ...//w !,"fee"_fee_"BCIRowid"_BCIRowid_"prtId"_prtId
 ...s ^TEMPDHCWL($j,prtAdmId,"prt")=$g(^TEMPDHCWL($j,prtAdmId,"prt"))+fee
 ..//s prtfee=$g(prtfee)+fee
 
 s admId=0 f  s admId=$o(^TEMPDHCWL($j,admId)) q:admId=""  d
 .s errFee=$g(^TEMPDHCWL($j,admId,"wl"))-$g(^TEMPDHCWL($j,admId,"prt"))
 .q:errFee=0
 .s papmi=$p(^PAADM(admId),"^",1)
 .s pbidPara=""
 .s pbId=0 f  s pbId=$o(^DHCPB(0,"ADM",admId,pbId)) q:pbId=""  d
 ..s pbFlag=$p(^DHCPB(pbId),"^",16)
 ..i pbidPara="" s pbidPara=pbId_"("_pbFlag_")"
 ..e  s pbidPara=pbidPara_","_pbId_"("_pbFlag_")"
 .//s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 .If (+$p($g(^PAPER(papmi,"PAT",1)),"^",1) '=0) d
 ..Set PatNo = $p($g(^PAPER(papmi,"PAT",1)),"^",1)
 .e  d 
 ..Set PatNo = $p($g(^PAPER(papmi,"PAT",2)),"^",1)
 .s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 .//s PatAge=$$GetAge^DHCWLCommon(papmi)
 .s TPAPERDob = $p($g(^PAPER(papmi,"ALL")),"^",6)
 .set PatAge=0
 .if TPAPERDob'="" d
 ..set PatAge=##class(web.DHCDTHealthCommon).GetAgeDesc(TPAPERDob,"")
 .s PatSex=$$GetSex^DHCWLCommon(papmi)
 .s PatReason=$$GetReason^DHCWLCommon(admId)
 .s admdate=$zd($p(^PAADM(admId),"^",6),3)
 .s wlfee=$g(^TEMPDHCWL($j,admId,"wl"))
 .s prtfee=$g(^TEMPDHCWL($j,admId,"prt"))
 .d OutputRow
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
 
OutputRow
	set Data=$lb(admId,PatNo,PatName,PatAge,PatSex,PatReason,admdate,pbidPara,wlfee,prtfee,errFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWLAndPrtErrFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWLAndPrtErrFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWLAndPrtErrFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWLAndPrtErrFeeExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 取WORKLOAD表中和发票表中病人所有费用，按医嘱汇总 mod by czx in 2018-04-24 与主表时间口径一致

// d ##class(%ResultSet).RunQuery("DHCWL.CompareOPFee","GetAdmPrtDetails","739","2018-04-23","2018-04-23","1")

Query GetAdmPrtDetails(adm As %String, Sday As %String, Eday As %String, DateType As %String) As %Query(ROWSPEC = "mastdesc:%String,moeoridr:%String,pbfee:%Float,wlfee:%Float,flag:%Integer") [ SqlProc ]
{
}

ClassMethod GetAdmPrtDetailsExecute(ByRef qHandle As %Binary, adm As %String, Sday As %String, Eday As %String, DateType As %String) As %Status
{
 k ^TEMPDHCWL($j)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s Sday=$zdh(Sday,3)
 s Eday=$zdh(Eday,3)
   
 q:adm="" $$$OK
 i DateType="1" s WDateType="ORDDATE"
 i DateType="2" s WDateType="FlagDate"
 f day=Sday:1:Eday  d
 .s wldr=0 f  s wldr=$o(^DHCWorkLoad(0,WDateType,day,wldr)) q:wldr=""  d  //ORDDATE
 ..s type=$p(^DHCWorkLoad(wldr),"^",4)
 ..q:(type'="O")&(type'="E")
 ..s orddate=$p(^DHCWorkLoad(wldr),"^",5)
 ..s admId=$p(^DHCWorkLoad(wldr),"^",12)
 ..q:admId'=adm
 ..s tarECdr=$p(^DHCWorkLoad(wldr),"^",41)    //核算子分类
 ..s price=$p(^DHCWorkLoad(wldr),"^",16)
 ..s oeoridr=$p(^DHCWorkLoad(wldr),"^",21)
 ..s ItemOrddr=$p(^DHCWorkLoad(wldr),"^",2)
 ..s ^TEMPDHCWL($j,oeoridr,ItemOrddr,"wl")=$g(^TEMPDHCWL($j,oeoridr,ItemOrddr,"wl"))+price
 
 s bciId=0 f  s bciId=$o(^DHCBCI(0,"ADM",adm,bciId)) q:bciId=""  d
 .s pbdr=$p(^DHCBCI(bciId),"^",2)
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

}
