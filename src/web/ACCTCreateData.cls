/// Class Name:web.ACCTCreateData
/// Description:生成凭证交换系统需要的业务数据
/// Creator:zdm
/// CreatDate:2010-06-30
Class web.ACCTCreateData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(%ResultSet).RunQuery("web.ACCTCreateData","CreateData","2","XYK-西药库","1")
Query CreateData(yearPeriodId As %String, locDesc As %String, busiTypeId As %String) As %Query(ROWSPEC = "No:%String,ProviderId:%String,ProviderDesc:%String,ReceiverId:%String,ReceiverDesc:%String,Date:%String,CreatUser:%String,AuditUser:%String")
{
}

ClassMethod CreateDataExecute(ByRef qHandle As %Binary, yearPeriodId As %String, locDesc As %String, busiTypeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:yearPeriodId="" $$$OK
	q:busiTypeId="" $$$OK
	
	s date=##class(web.ACCTCommon).GetDateByYearPeriod(yearPeriodId)
	s startDate=$p(date,"^",1)
	s endDate=$p(date,"^",2)
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	
	s locRowid=""
	i locDesc'=""  d
	.s locRowid=##class(web.ACCTCommon).LocDescToRowid(locDesc)
	s whileSql=##class(web.ACCTCommon).GetWhileSqlForBusiType(busiTypeId)
	s type=$p(whileSql,",",1)								;业务类型
	
	q:type="" $$$OK
	s acctPid=..GetData(locRowid,startDate,endDate,whileSql)	
	q:acctPid="" $$$OK
	
	d OutPutRow
	
	Quit $$$OK
OutPutRow
	s sub=""	
	f  s sub=$o(^TMPACCTCreateData(acctPid,sub))  q:sub=""  d
	.s data=^TMPACCTCreateData(acctPid,sub)
	.s no=$p(data,"^",1)
	.s provider=$p(data,"^",2)
	.s providerDesc=$p(data,"^",3)
	.s receiver=$p(data,"^",4)
	.s receiverDesc=$p(data,"^",5)
	.s date=$p(data,"^",6)
	.s creatUser=$p(data,"^",7)
	.s auditUser=$p(data,"^",8)
	.
	.s data=$lb(no,provider,providerDesc,receiver,receiverDesc,date,creatUser,auditUser)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.;b
	k ^TMPACCTCreateData(acctPid)
	q
}

ClassMethod CreateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CreateDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CreateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CreateDataExecute ]
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
		;b
	}
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod GetData(locRowid As %String, dateFrom As %Date, dateTo As %Date, parm As %String) As %String
{
	n (locRowid,dateFrom,dateTo,parm)
	s acctPid=$I(^TMPACCTCreateData)
	s type=$p(parm,",",1)
	
	f date=dateFrom:1:dateTo d
	.s trid=""
	.f  s trid=$o(^DHCINTR(0,"TypeDate",type,date,trid))  q:trid=""  d
	..s pointer=$p(^DHCINTR(trid),"^",9)
	..q:pointer="" 
	..;b
	..q:##class(web.ACCTCommon).CheckIfSpecBusiType(trid,parm)=0	;不符合指定的业务类型
	..;b
	..s trNo=$p(^DHCINTR(trid),"^",13)
	..i type="G"  d
	...s listData=..GetRecMaster(trNo)
	...s providerId=$p(listData,"^",1)
	...s providerDesc=$p(listData,"^",2)
	...s receiverId=$p(listData,"^",3)
	...s receiverDesc=$p(listData,"^",4)
	...s ackDate=$p(listData,"^",5)
	...s createrUser=$p(listData,"^",6)
	...s auditUser=$p(listData,"^",7)
	...q:receiverId'=locRowid
	...s data=trNo_"^"_providerId_"^"_providerDesc_"^"_receiverId_"^"_receiverDesc_"^"_ackDate_"^"_createrUser_"^"_auditUser
	...
	...i '$d(^TMPACCTCreateData(acctPid,trNo))  d
	....s ^TMPACCTCreateData(acctPid,trNo)=data
	..i (type="T")!(type="K") d
	...s listData=..GetTransferMaster(trNo)
	...s providerId=$p(listData,"^",1)
	...s providerDesc=$p(listData,"^",2)
	...s receiverId=$p(listData,"^",3)
	...s receiverDesc=$p(listData,"^",4)
	...s ackDate=$p(listData,"^",5)
	...s createrUser=$p(listData,"^",6)
	...s auditUser=$p(listData,"^",7)
	...q:(type="T")&(providerId'=locRowid)
	...q:(type="K")&(receiverId'=locRowid)
	...s data=trNo_"^"_providerId_"^"_providerDesc_"^"_receiverId_"^"_receiverDesc_"^"_ackDate_"^"_createrUser_"^"_auditUser
	...
	...i '$d(^TMPACCTCreateData(acctPid,trNo))  d
	....s ^TMPACCTCreateData(acctPid,trNo)=data
	...
	..i type="R"  d
	...s listData=..GetRetMaster(trNo)
	...s providerId=$p(listData,"^",3)
	...s providerDesc=$p(listData,"^",4)
	...s receiverId=$p(listData,"^",1)
	...s receiverDesc=$p(listData,"^",2)
	...s ackDate=$p(listData,"^",5)
	...s createrUser=$p(listData,"^",6)
	...s auditUser=$p(listData,"^",7)
	...q:providerId'=locRowid
	...s data=trNo_"^"_providerId_"^"_providerDesc_"^"_receiverId_"^"_receiverDesc_"^"_ackDate_"^"_createrUser_"^"_auditUser
	...
	...i '$d(^TMPACCTCreateData(acctPid,trNo))  d
	....s ^TMPACCTCreateData(acctPid,trNo)=data
	...
	..i type="A"  d
	...s listData=..GetAdjMaster(trNo)
	...s providerId=$p(listData,"^",1)
	...s providerDesc=$p(listData,"^",2)
	...s receiverId=$p(listData,"^",1)
	...s receiverDesc=$p(listData,"^",2)
	...s ackDate=$p(listData,"^",3)
	...s createrUser=$p(listData,"^",4)
	...s auditUser=$p(listData,"^",5)
	...q:providerId'=locRowid
	...s data=trNo_"^"_providerId_"^"_providerDesc_"^"_receiverId_"^"_receiverDesc_"^"_ackDate_"^"_createrUser_"^"_auditUser
	...
	...i '$d(^TMPACCTCreateData(acctPid,trNo))  d
	....s ^TMPACCTCreateData(acctPid,trNo)=data
	... 
    ..
    .
	q acctPid
}

/*
InvNo:InvDate:ItmDesc:Spec:TrUom:TrQty:Rp:RpAmt:Sp:SpAmt:
20100706:2010-07-06:(达菲)磷酸奥司他韦胶囊[75mg*10]:75mg*10:盒(10粒):20:256:5120.0000:270:5400.0000:
20100706:2010-07-06:(阿莫仙)阿莫西林胶囊[0.5g*24]:0.5g*24:盒(24粒):30:23:690.0000:26:780.0000:
20100706:2010-07-06:阿莫西林胶囊[0.25*30]b:0.25g*30:瓶(30粒):40:3:120.0000:9.2:368.0000:
*/
/// d ##class(%ResultSet).RunQuery("web.ACCTCreateData","GetDhcDataDetail","GG20100706R001","1")
Query GetDhcDataDetail(trNo As %String, busiTypeId As %String) As %Query(ROWSPEC = "InvNo:%String,InvDate:%String,ItmDesc:%String,Spec:%String,TrUom:%String,TrQty:%Numeric,Rp:%Numeric,RpAmt:%Numeric,Sp:%Numeric,SpAmt:%Numeric")
{
}

ClassMethod GetDhcDataDetailExecute(ByRef qHandle As %Binary, trNo As %String, busiTypeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1	
	;
	q:busiTypeId="" $$$OK
	s trNo=$$ALPHAUP^SSUTIL4(trNo) 
	q:trNo="" $$$OK
	s whileSql=##class(web.ACCTCommon).GetWhileSqlForBusiType(busiTypeId)
	s type=$p(whileSql,",",1)
	q:type="" $$$OK
	;
 	i type="G" d
 	.s acctPid=..GetRecDetail(trNo)
 	i (type="T")!(type="K")  d
 	.s acctPid=..GetTransferDetail(trNo)
 	i type="R"  d
 	.s acctPid=..GetRetDetail(trNo)
 	i type="A"  d
 	.s acctPid=..GetAdjDetail(trNo)
		
	q:acctPid="" $$$OK
	
	d OutPutRow2
	
	Quit $$$OK
OutPutRow2
	s i=0	
	f  s i=$o(^TMPACCTDataDetail(acctPid,i))  q:i=""  d
	.s data=^TMPACCTDataDetail(acctPid,i)
	.s invNo=$p(data,"^",1)
	.s invDate=$p(data,"^",2)
	.s itmDesc=$p(data,"^",4)
	.s spec=$p(data,"^",11)
	.s recUom=$p(data,"^",5)
	.s recQty=$p(data,"^",6)
	.s rp=$p(data,"^",9)
	.s rpAmt=$p(data,"^",10)
	.s sp=$p(data,"^",7)
	.s spAmt=$p(data,"^",8)
	.
	.s data=$lb(invNo,invDate,itmDesc,spec,recUom,recQty,rp,rpAmt,sp,spAmt)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.;b
	k ^TMPACCTDataDetail(acctPid)
	q
}

ClassMethod GetDhcDataDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDhcRecDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDhcDataDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDhcRecDetailExecute ]
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
		;b
	}
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod GetRecDetail(recNo As %String) As %String
{
	n (recNo)
	s acctPid=$I(^TMPACCTDataDetail)
	q:recNo="" ""
	;
 	s dhcingr=$o(^DHCINGR(0,"No",recNo,"") ) 
 	q:dhcingr="" ""   							; rowid of DHC_InGdRec
 	;
 	s i=0
	s chl=""
 	f  s chl=$O(^DHCINGR(dhcingr,"GRI",chl)) q:chl=""  d
  	.s invNo=$p(^DHCINGR(dhcingr,"GRI",chl),"^",27)
  	.s invDate=$p(^DHCINGR(dhcingr,"GRI",chl),"^",34)
  	.s:invDate'="" invDate=$zd(invDate,3)
  	.s inci=$P(^DHCINGR(dhcingr,"GRI",chl),"^",25)
  	.q:inci=""
    .q:'$d(^INCI(inci,1))
  	.s itmCode=$p(^INCI(inci,1),"^",1)
  	.s itmDesc=$p(^INCI(inci,1),"^",2)
  	.s spec=##class(web.ACCTCommon).GetSpec(inci)
  	.s recUom=$P(^DHCINGR(dhcingr,"GRI",chl),"^",10) 
  	.s:recUom'="" recUom=$p(^CT("UOM",recUom),"^",2)
  	.s recQty=$P(^DHCINGR(dhcingr,"GRI",chl),"^",4)
  	.s sp=$P(^DHCINGR(dhcingr,"GRI",chl),"^",32) 
  	.s spAmt=sp*recQty
  	.s spAmt=$fn(spAmt,"",4)
  	.s rp=$P(^DHCINGR(dhcingr,"GRI",chl),"^",30) 
  	.s rpAmt=$P(^DHCINGR(dhcingr,"GRI",chl),"^",31) 
  	.s rpAmt=$fn(rpAmt,"",4)
  	.s i=i+1
  	.s a1=invNo_"^"_invDate_"^"_itmCode_"^"_itmDesc_"^"_recUom_"^"_recQty
  	.s a2=sp_"^"_spAmt_"^"_rp_"^"_rpAmt_"^"_spec
  	.
 	.s ^TMPACCTDataDetail(acctPid,i)=a1_"^"_a2
    .
	q acctPid
}

ClassMethod GetTransferDetail(trNo As %String) As %String
{
	n (trNo)
	s acctPid=$I(^TMPACCTDataDetail)
	q:trNo="" ""
	;
 	s dhcinit=$o(^DHCINIT(0,"No",trNo,"") ) 
 	q:dhcinit="" ""  							
 	;
 	s i=0
	s chl=""
 	f  s chl=$O(^DHCINIT(dhcinit,"ITI",chl)) q:chl=""  d
  	.s invNo=""
  	.s invDate=""
  	.s:invDate'="" invDate=$zd(invDate,3)
  	.s inclb=$p(^DHCINIT(dhcinit,"ITI",chl),"^",3)
  	.s inci=+inclb
  	.q:inci=""
    .q:'$d(^INCI(inci,1))
  	.s itmCode=$p(^INCI(inci,1),"^",1)
  	.s itmDesc=$p(^INCI(inci,1),"^",2)
  	.s spec=##class(web.ACCTCommon).GetSpec(inci)
  	.s trUom=$p(^DHCINIT(dhcinit,"ITI",chl),"^",7)
  	.s:trUom'="" trUom=$p(^CT("UOM",trUom),"^",2)
  	.s trQty=$p(^DHCINIT(dhcinit,"ITI",chl),"^",1)
  	.s sp=$p(^DHCINIT(dhcinit,"ITI",chl),"^",17)
  	.s spAmt=$p(^DHCINIT(dhcinit,"ITI",chl),"^",18)
  	.s spAmt=$fn(spAmt,"",4)
  	.s rp=$p(^DHCINIT(dhcinit,"ITI",chl),"^",15)
  	.s rpAmt=$P(^DHCINIT(dhcinit,"ITI",chl),"^",16) 
  	.s rpAmt=$fn(rpAmt,"",4)
  	.s i=i+1
  	.s a1=invNo_"^"_invDate_"^"_itmCode_"^"_itmDesc_"^"_trUom_"^"_trQty
  	.s a2=sp_"^"_spAmt_"^"_rp_"^"_rpAmt_"^"_spec
  	.
 	.s ^TMPACCTDataDetail(acctPid,i)=a1_"^"_a2
    .
	q acctPid
}

ClassMethod GetRetDetail(retNo As %String) As %String
{
	n (retNo)
	s acctPid=$I(^TMPACCTDataDetail)
	q:retNo="" ""
	;
 	s ingrt=$o(^INGRT(0,"RETNO",retNo,"")) 
 	q:ingrt="" ""   												
 	;
 	s i=0
	s chl=""
 	f  s chl=$O(^INGRT(ingrt,"DHCGRR",chl)) q:chl=""  d
  	.s invNo=$p(^INGRT(ingrt,"DHCGRR",chl),"^",12)
  	.s invDate=$p(^INGRT(ingrt,"DHCGRR",chl),"^",14)
  	.s:invDate'="" invDate=$zd(invDate,3)
  	.s dhcingri=$p(^INGRT(ingrt,"DHCGRR",chl),"^",1)
  	.q:dhcingri=""
  	.s inci=$P(^DHCINGR(+dhcingri,"GRI",$p(dhcingri,"||",2)),"^",25)
  	.q:inci=""
    .q:'$d(^INCI(inci,1))
  	.s itmCode=$p(^INCI(inci,1),"^",1)
  	.s itmDesc=$p(^INCI(inci,1),"^",2)
  	.s spec=##class(web.ACCTCommon).GetSpec(inci)
  	.s retUom=$p(^INGRT(ingrt,"DHCGRR",chl),"^",3)
  	.s:retUom'="" retUom=$p(^CT("UOM",retUom),"^",2)
  	.s retQty=$p(^INGRT(ingrt,"DHCGRR",chl),"^",2)
  	.s sp=$p(^INGRT(ingrt,"DHCGRR",chl),"^",8)
  	.s spAmt=$p(^INGRT(ingrt,"DHCGRR",chl),"^",9)
  	.s spAmt=$fn(spAmt,"",4)
  	.s rp=$p(^INGRT(ingrt,"DHCGRR",chl),"^",7)
  	.s rpAmt=$p(^INGRT(ingrt,"DHCGRR",chl),"^",4)
  	.s rpAmt=$fn(rpAmt,"",4)
  	.s i=i+1
  	.s a1=invNo_"^"_invDate_"^"_itmCode_"^"_itmDesc_"^"_retUom_"^"_retQty
  	.s a2=sp_"^"_spAmt_"^"_rp_"^"_rpAmt_"^"_spec
  	.
 	.s ^TMPACCTDataDetail(acctPid,i)=a1_"^"_a2
    .
	q acctPid
}

ClassMethod GetAdjDetail(adjNo As %String) As %String
{
	n (adjNo)
	s acctPid=$I(^TMPACCTDataDetail)
	q:adjNo="" ""
	;
 	s dhcinad=$o(^DHCINAD(0,"No",adjNo,"") ) 
 	q:dhcinad="" ""   							; rowid of DHC_InAdj							
 	;
 	s i=0
	s chl=""
 	f  s chl=$O(^DHCINAD(dhcinad,"ADI",chl)) q:chl=""  d
  	.s invNo=""
  	.s invDate=""
  	.s:invDate'="" invDate=$zd(invDate,3)
  	.s inclb=$p(^DHCINAD(dhcinad,"ADI",chl),"^",1)
  	.s inci=+inclb
  	.q:inci=""
    .q:'$d(^INCI(inci,1))
  	.s itmCode=$p(^INCI(inci,1),"^",1)
  	.s itmDesc=$p(^INCI(inci,1),"^",2)
  	.s spec=##class(web.ACCTCommon).GetSpec(inci)
  	.s adjUomDr=$p(^DHCINAD(dhcinad,"ADI",chl),"^",5)
  	.s:adjUomDr'="" adjUom=$p(^CT("UOM",adjUom),"^",2)
  	.s adjQty=$p(^DHCINAD(dhcinad,"ADI",chl),"^",2)
  	.s sp=+##class(web.ACCTCommon).GetSp(inci,adjUomDr)
  	.s spAmt=adjQty*sp
  	.s spAmt=$fn(spAmt,"",4)
  	.s rp=+##class(web.ACCTCommon).GetRp(inclb,adjUomDr)
  	.s rpAmt=rp*adjQty 
  	.s rpAmt=$fn(rpAmt,"",4)
  	.s i=i+1
  	.s a1=invNo_"^"_invDate_"^"_itmCode_"^"_itmDesc_"^"_trUom_"^"_trQty
  	.s a2=sp_"^"_spAmt_"^"_rp_"^"_rpAmt_"^"_spec
  	.
 	.s ^TMPACCTDataDetail(acctPid,i)=a1_"^"_a2
    .
	q acctPid
}

ClassMethod GetRecMaster(recNo As %String) As %String
{
	n (recNo)
	s recNo=$$ALPHAUP^SSUTIL4(recNo) 
	q:recNo="" ""
	;
 	s dhcingr=$o(^DHCINGR(0,"No",recNo,"") ) 
 	q:dhcingr="" ""   							; rowid of DHC_InGdRec
 	;
 	s createDate=$p(^DHCINGR(dhcingr),"^",14)
 	s:createDate'="" createDate=$zd(createDate,3)
 	s date=$p(^DHCINGR(dhcingr),"^",4)
 	s:date'="" date=$zd(date,3)
 	s apcvmDr=$p(^DHCINGR(dhcingr),"^",3)
	s apcvmDesc="*"
	s:apcvmDr'="" apcvmDesc=$p(^APC("APCVM",apcvmDr),"^",3)
	s locDr=$p(^DHCINGR(dhcingr),"^",13)
	s locDesc="*"
	s:locDr'="" locDesc=$p(^CTLOC(locDr),"^",2)
	s creatUser=$p(^DHCINGR(dhcingr),"^",16)
	s creatUserName="*"
	s:creatUser'="" creatUserName=$p(^SSU("SSUSR",creatUser),"^",2)
	s auditUser=$p(^DHCINGR(dhcingr),"^",8)
	s auditUserName="*"
	s:auditUser'="" auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
  	s data=apcvmDr_"^"_apcvmDesc_"^"_locDr_"^"_locDesc_"^"_date_"^"_creatUserName_"^"_auditUserName_"^"_createDate
	q data
}

ClassMethod GetTransferMaster(trNo As %String) As %String
{
	n (trNo)
	s trNo=$$ALPHAUP^SSUTIL4(trNo) 
	q:trNo="" ""
	;
 	s dhcinit=$o(^DHCINIT(0,"No",trNo,"") ) 
 	q:dhcinit="" ""   							; rowid of DHC_InIsTrf
 	;
 	s createDate=$p(^DHCINIT(dhcinit),"^",2)
 	s:createDate'="" createDate=$zd(createDate,3)
 	s ackDate=$p(^DHCINIT(dhcinit),"^",9)
 	s:ackDate'="" ackDate=$zd(ackDate,3)
 	s fromLocDr=$p(^DHCINIT(dhcinit),"^",5)
	s frLocDesc="*"
	s:fromLocDr'="" frLocDesc=$p(^CTLOC(fromLocDr),"^",2)
	s toLocDr=$p(^DHCINIT(dhcinit),"^",6)
	s toLocDesc="*"
	s:toLocDr'="" toLocDesc=$p(^CTLOC(toLocDr),"^",2)
	s creatUser=$p(^DHCINIT(dhcinit),"^",8)
	s creatUserName="*"
	s:creatUser'="" creatUserName=$p(^SSU("SSUSR",creatUser),"^",2)
	s auditUser=$p(^DHCINIT(dhcinit),"^",11)
	s auditUserName="*"
	s:auditUser'="" auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
  	s data=fromLocDr_"^"_frLocDesc_"^"_toLocDr_"^"_toLocDesc_"^"_ackDate_"^"_creatUserName_"^"_auditUserName_"^"_createDate
	q data
}

ClassMethod GetAdjMaster(adjNo As %String) As %String
{
	n (adjNo)
	s adjNo=$$ALPHAUP^SSUTIL4(adjNo) 
	q:adjNo="" ""
	;
 	s dhcinad=$o(^DHCINAD(0,"No",adjNo,"") ) 
 	q:dhcinad="" ""   							; rowid of DHC_InAdj
 	;
 	s createDate=$p(^DHCINAD(dhcinad),"^",2)
 	s:createDate'="" createDate=$zd(createDate,3)
 	s ackDate=$p(^DHCINAD(dhcinad),"^",8)
 	s:ackDate'="" ackDate=$zd(date,3)
 	s chl=$o(^DHCINAD(dhcinad,"ADI",0))
 	q:chl="" ""
 	s inclb=$p(^DHCINAD(dhcinad,"ADI",chl),"^",1)
 	s inci=+inclb
 	s il=$p(inclb,"||",2)
 	s locDr=$p(^INCI(inci,"IL",il),"^",1)
	s:locDr'="" locDesc=$p(^CTLOC(locDr),"^",2)
	s creatUser=$p(^DHCINAD(dhcinad),"^",3)
	s creatUserName="*"
	s:creatUser'="" creatUserName=$p(^SSU("SSUSR",creatUser),"^",2)
	s auditUser=$p(^DHCINAD(dhcinad),"^",10)
	s auditUserName="*"
	s:auditUser'="" auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
  	s data=locDr_"^"_locDesc_"^"_ackDate_"^"_creatUserName_"^"_auditUserName_"^"_createDate
	q data
}

ClassMethod GetRetMaster(retNo As %String) As %String
{
	n (retNo)
	s retNo=$$ALPHAUP^SSUTIL4(retNo) 
	q:retNo="" ""
	;
 	s ingrt=$o(^INGRT(0,"RETNO",retNo,"") ) 
 	q:ingrt="" ""   							; rowid of DHC_InGdRec
 	;
 	s createDate=$p(^INGRT(ingrt),"^",3)
 	s:createDate'="" createDate=$zd(createDate,3)
 	s date=$p(^INGRT(ingrt),"^",9)
 	s:date'="" date=$zd(date,3)
 	s apcvmDr=$p(^INGRT(ingrt),"^",2)
	s apcvmDesc="*"
	s:apcvmDr'="" apcvmDesc=$p(^APC("APCVM",apcvmDr),"^",3)
	s locDr=$p(^INGRT(ingrt),"^",7)
	s locDesc="*"
	s:locDr'="" locDesc=$p(^CTLOC(locDr),"^",2)
	s creatUser=$p(^INGRT(ingrt),"^",5)
	s creatUserName="*"
	s:creatUser'="" creatUserName=$p(^SSU("SSUSR",creatUser),"^",2)
	s auditUser=$p(^INGRT(ingrt),"^",8)
	s auditUserName="*"
	s:auditUser'="" auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
  	s data=apcvmDr_"^"_apcvmDesc_"^"_locDr_"^"_locDesc_"^"_date_"^"_creatUserName_"^"_auditUserName_"^"_createDate
	q data
}

}
