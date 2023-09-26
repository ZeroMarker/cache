Import SQLUser

Class web.DHCBlurQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getscore(funname As %String) As %String
{
 
 s temp(1)="分值<=12"
 s temp(2)="13<=分值<=17"
 s rw="" f  s rw=$O(temp(rw)) q:rw=""  d
 .s a=temp(rw)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(a),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

ClassMethod GetInPatientRecord(JSFunName As %String) As %String
{
	s rtn=0
	s prtListInfo=$$GetInPatList()
	;w prtListInfo
	s prtTxtInfo=""
	
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	KILL ^Temp("DHCInPatientRecord",$j)
	Quit rtn	
	q 0
   
GetInPatList()
   	s myidx=""
	s myList=""
	f  s myidx=$o(^Temp("DHCInPatientRecord",$j,myidx)) q:myidx=""  d
	.i myList="" d
	..s myList=^Temp("DHCInPatientRecord",$j,myidx)
	.e  d
	..s myList=myList_""_$c(2)_^Temp("DHCInPatientRecord",$j,myidx)
	q myList
}

ClassMethod GetAdmDate(adm As %String) As %String
{
	 q:"" ""
     s adm=$ZConvert(adm,"U")
     s admdate=$p(^PAADM(adm),"^",6)
     q $zd(admdate,3)
}

Query wardlookup(desc As %String) As %Query(ROWSPEC = "ward:%String,wardid:%String")
{
}

ClassMethod wardlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=$$ALPHAUP^SSUTIL4(desc)
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=desc_"%"
	&sql(declare ward cursor  for 
	select WARD_rowid,WARD_desc from SQLUser.PAC_WARD where %UPPER(WARD_desc) like :desc)
	&sql(open ward)
	f  &sql(fetch ward into :WARDrowid,:WARDdesc) q:SQLCODE  d
 	.Do OutputRow2 	 	
 	&sql(close ward)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(WARDdesc,WARDrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod wardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = wardlookupExecute ]
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

ClassMethod wardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = wardlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "ctloc:%String,ctlocid:%String")
{
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_rowid
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :desc) and ctloc_type="E")
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
	.;
 	.Do OutputRow4	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCBlurQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCBlurQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DHCBlurQueryExecute(ByRef qHandle As %Binary, InpatientName As %String, wardid As %String, locid As %String, InhospitalDate As %String, JobUnit As %String, patadmreas As %String, Onbed As %String, Indate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s name=$g(InpatientName),loc=$g(locid),ward=$g(wardid),Date=$g(InhospitalDate),Job=$g(JobUnit)
	s sum=0,sumtotalFeeT=0,sumDepostT=0
	s Adm="" f  s Adm=$o(^PAADMi("PAADM_Type","I",Adm)) q:Adm=""  d
	.s AdmStatus=$p(^PAADM(Adm),"^",20)
	.q:AdmStatus'="A"
	.s paadmreasondr=$p(^PAADM(Adm,1),"^",7)
	.q:(($g(patadmreas)'="")&(patadmreas'=paadmreasondr))    ;lgl+
	.s PAADMCurrentBedDr=$p(^PAADM(Adm),"^",73)
    .q:((Onbed="on")&($g(PAADMCurrentBedDr)=""))
    .;if $g(paadmreasondr)="" d
    ..;s papmi=$p(^PAADM(Adm),"^",1)
    ..;s ^lgltest("0628",Adm)=paadmreasondr_"^"_papmi
    .;q:$g(paadmreasondr)=""     ;lgl+
    .s paadmreasondesc=$p( ^PAC("ADMREA",paadmreasondr),"^",2)
	.s paadmdr=$p(^PAADM(Adm),"^",1)
	.s InpatientName=$p(^PAPER(paadmdr,"ALL"),"^",1) //s InpatientNameT=$p(^PAPER(paadmdr,"ALL"),"^",1)
	.s dw=$p($g(^PAPER(paadmdr,"PER","ADD",1)),"^",1)
	.s JobUnit=$g(dw)
	.i Job'="" q:JobUnit'[Job
	.i name'="" q:InpatientName'[name
	.s InpatientId=$p(^PAPER(paadmdr,"PAT",1),"^",1)  //2009/6/22系统故障导致重新编译pa_adm表索引后移改取pa_patmas
	.//s InpatientId=paadmdr //s InpatientIdT=paadmdr
	.s reglen=$l(InpatientId) //s reglen=$l(InpatientIdT)
	.f i=reglen:1:7  d
	..s InpatientId="0"_InpatientId //s InpatientIdT="0"_InpatientIdT
	.s PAADMDepCodeDR=$p(^PAADM(Adm),"^",4)
	.i loc'="" q:PAADMDepCodeDR'=loc
	.s Office=$p(^CTLOC(PAADMDepCodeDR),"^",2) //s OfficeT=$p(^CTLOC(PAADMDepCodeDR),"^",2)
	.s CURRENTWARDDR=$p(^PAADM(Adm),"^",70)
	.i wardid'="" q:wardid'=CURRENTWARDDR
	.s HospitalWard=$p($g(^PAWARD(CURRENTWARDDR)),"^",2) //s HospitalWardT=$p($g(^PAWARD(CURRENTWARDDR)),"^",2)
	.s PAADMCurrentRoom=$p(^PAADM(Adm),"^",69)
	.i PAADMCurrentRoom=""  d
	..s Apartment="" //s ApartmentT=""
	.e  d 
	..s Apartment=$p(^PAROOM(PAADMCurrentRoom),"^",2) //s ApartmentT=$p(^PAROOM(PAADMCurrentRoom),"^",2)
	.i PAADMCurrentBedDr'="" d
	..s WARDRowID=$P(PAADMCurrentBedDr,"||",1)
	..s BEDChildsub=$p(PAADMCurrentBedDr,"||",2)
	..s BedId=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1) //s BedIdT=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1)
	.e  d
	..s BedId="" //s BedIdT=""
	.s PAADMAdmDate=$p(^PAADM(Adm),"^",6)
	.q:($g(Indate)'="")&&((+$h-PAADMAdmDate-Indate)<0)    ;lgl+入院多少天以上的
	.i Date'="" q:PAADMAdmDate'=Date
	.i PAADMAdmDate'="" d
	..s InhospitalDate=$zd(PAADMAdmDate,3) //s InhospitalDateT=$zd(PAADMAdmDate,3)
	.e  d
	..s InhospitalDate="" //s InhospitalDateT=""
	.s InpatientEstate="在院"  //s InpatientEstateT="在院"
	.s INSUFlag=""
	.s Inadmrow="" f  s Inadmrow=$o(^DHCINADM("0","ADM",Adm,Inadmrow)) q:Inadmrow=""  d
	..s INSUFlag=$p(^DHCINADM(Inadmrow),"^",11)      ;lgl+医保状态
	..i INSUFlag="A" s INSUFlag="在院"
	..i INSUFlag="O" s INSUFlag="出院"
	..i INSUFlag="I" s INSUFlag="做废"
	.s totalFeeT=0,DepostT=0
	.s PBRowId=0  f  s PBRowId=$o(^DHCPB(0,"ADM",Adm,PBRowId)) q:PBRowId=""  d 
	..s totalFeeT=$p(^DHCPB(PBRowId),"^",8)
	.s DepostT=##class(web.UDHCJFBaseCommon).deposit(Adm) 
	.s sum=sum+1
	.s sumtotalFeeT=sumtotalFeeT+totalFeeT
	.s sumDepostT=sumDepostT+DepostT
	.Do OutputRow
	s InpatientId="合计" ,InpatientName=sum_"人",HospitalWard="",Office="",BedId="",InhospitalDate="",Apartment="",InpatientEstate="",JobUnit="",paadmreasondesc="",totalFeeT=sumtotalFeeT,DepostT=sumDepostT,INSUFlagT=""
	Do OutputRow

	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	//set Data=$lb(InpatientIdT,InpatientNameT,HospitalWardT,OfficeT,BedIdT,InhospitalDateT,ApartmentT,InpatientEstateT)
	set Data=$lb(InpatientId,InpatientName,HospitalWard,Office,BedId,InhospitalDate,Apartment,InpatientEstate,JobUnit,paadmreasondesc,INSUFlag,totalFeeT,DepostT)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	
	quit
ResetVariables
	set (InpatientId,InpatientName,HospitalWard,Office,BedId,InhospitalDate,Apartment,InpatientEstate,JobUnit,paadmreasondesc,INSUFlag)=""
	//set (InpatientIdT,InpatientNameT,HospitalWardT,OfficeT,BedIdT,InhospitalDateT,ApartmentT,InpatientEstateT)=""
	quit
}

ClassMethod DHCBlurQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCBlurQueryExecute ]
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

Query DHCBlurQuery(InpatientName As %String, wardid As %String, locid As %String, InhospitalDate As %String, JobUnit As %String, patadmreas As %String, Onbed As %String, Indate As %String) As %Query(ROWSPEC = "InpatientIdT:%String,InpatientNameT:%String,HospitalWardT:%String,OfficeT:%String,BedIdT:%String,InhospitalDateT:%String,ApartmentT:%String,InpatientEstateT:%String,JobUnitT:%String,PatAdmReasonT:%String,INSUFlagT:%String,totalFeeT:%String,DepostT:%String")
{
}

Query DHCInPatientRecordQuery(QueryDate As %String) As %Query(ROWSPEC = "InpatientIdT:%String,InpatientNameT:%String,HospitalWardT:%String,OfficeT:%String,BedIdT:%String,InhospitalDateT:%String,ApartmentT:%String,InpatientEstateT:%String,JobUnitT:%String,PatAdmReasonT:%String,INSUFlagT:%String,totalFeeT:%String,DepostT:%String,RecordDateT:%String,RecordTimeT:%String,XHT:%String")
{
}

ClassMethod DHCInPatientRecordQueryExecute(ByRef qHandle As %Binary, QueryDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s QueryDate=+h
	s num=0
	//这个不知道做什么用的，因为编译报错，所以就先注释掉了
	/*
	if (QueryDate'="")
    {
	  &sql(DECLARE EmpCursor CURSOR FOR
	  Select  count(*),sum(totalFeeT),sum(DepostT),ProduceDate,ProduceTime,InpatientId,InpatientName,HospitalWard,Office,BedId,InhospitalDate,Apartment,InpatientEstate,JobUnit,paadmreasondesc,totalFeeT,DepostT,INSUFlagT into :count,:sumtotalFeeT,:sumDepostT,:ProduceDate,:ProduceTime,:InpatientId,:InpatientName,:HospitalWard,:Office,:BedId,:InhospitalDate,:Apartment,:InpatientEstate,:JobUnit,:paadmreasondesc,:totalFeeT,:DepostT,:INSUFlagT From DHC_Blur Where ProduceDate=:QueryDate)	
	  &sql(OPEN EmpCursor)
    
      for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
      .s num=num+1
      .Do OutputRow
	 // &sql(CLOSE EmpCursor)
	  s InpatientId="合计" ,InpatientName=count_"人",HospitalWard="",Office="",BedId="",InhospitalDate="",Apartment="",InpatientEstate="",JobUnit="",paadmreasondesc="",totalFeeT=sumtotalFeeT,DepostT=sumDepostT,INSUFlagT="",ProduceDate="",ProduceTime="",num=""
	  Do OutputRow1
     }
	*/
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	//set Data=$lb(InpatientIdT,InpatientNameT,HospitalWardT,OfficeT,BedIdT,InhospitalDateT,ApartmentT,InpatientEstateT)
	//set ^Temp("DHCInPatientRecord",$j,ind)=num_"^"_InpatientId_"^"_InpatientName_"^"_DepostT
	set Data=$lb(InpatientId,InpatientName,HospitalWard,Office,BedId,InhospitalDate,Apartment,InpatientEstate,JobUnit,paadmreasondesc,INSUFlag,totalFeeT,DepostT,$zd(ProduceDate,3),$zt(ProduceTime,1),num)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	
	quit

OutputRow1
	//set Data=$lb(InpatientIdT,InpatientNameT,HospitalWardT,OfficeT,BedIdT,InhospitalDateT,ApartmentT,InpatientEstateT)
	//set ^Temp("DHCInPatientRecord",$j,ind)=num_"^"_InpatientId_"^"_InpatientName_"^"_DepostT
	set Data=$lb(InpatientId,InpatientName,HospitalWard,Office,BedId,InhospitalDate,Apartment,InpatientEstate,JobUnit,paadmreasondesc,INSUFlag,totalFeeT,DepostT,"","")
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	
	quit
}

ClassMethod DHCInPatientRecordQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCInPatientRecordQueryExecute ]
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

ClassMethod DHCInPatientRecordQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCInPatientRecordQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getdatetime()
{
	s stdate="",sttime=""
	s stdate=$zd(+$h,3)
	s sttime=$zt($p($h,",",2),1)
	q stdate_"^"_sttime
}

ClassMethod getadminv(adm)
{
	s invflag="",invS=""
	q:(adm="") "无就诊"
	s invid="" f  s invid=$o(^DHCINVPRTZY(0,"ADM",adm,invid)) q:invid=""  d
	.s invstatus=$p(^DHCINVPRTZY(invid),"^",8)
	.i invstatus="N" d
	..s invSid=$o(^DHCINVPRTZY(0,"InitInv",invid,""))      //判断红冲
	..if invSid="" d
	...//s invSstatus=$p(^DHCINVPRTZY(invS),"^",8)
	...//i invSstatus'="S" d
	...s invno=$p(^DHCINVPRTZY(invid),"^",1)
	...s invdate=$p(^DHCINVPRTZY(invid),"^",2)
	...s invdate=$zd(invdate,3)
	...s invflag=invflag_"患者本次就诊已打印过有效发票:"_invno_" 日期"_invdate_"不允许召回 "

	q invflag
}

ClassMethod NurMasterRight(nur As %String, ctlocdr As %String)
{
	s flag=0
	s ret=""
	s nur=$o(^User.DHCMGPersonsI("SSDR"," "_nur,""))
	s rw="" f  s rw=$O(^User.DHCMGNurExamDepI("Nur"," "_nur,rw)) q:(rw="")  d
	.s a=^User.DHCMGNurExamDepD(rw)
	.s depId=$List(a,2)
	.i ctlocdr=depId s flag=1
	q flag
}

Query DHCNURKPQuery(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURKPQueryExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURKPQuery","2017-02-01^2017-08-18^ZXYJHEKHLDY-中西医结合二科护理单元^27^DHCNURANHUI10^")
	//s userid=%session.Get("LOGON.USERID")   权限控制查后放开
	s aa=""
	s TWard="",TPat="",TItem="",TDate="",TTime="",TCreator="",TState="",ddflag="",sfycflag="",TScore="",TSkinulcerQuality="",TYOrNSkinulcer="",YOrNSkinulcerQuality=""
	s StartDate=$p(Parr,"^",1)
	s EndDate=$p(Parr,"^",2)
	s PacWard=$p(Parr,"^",3)
	s PacWard=$tr(PacWard," ","")
	s PacWardDesc=""
	i PacWard'="" s PacWardDesc=$P(^CTLOC(PacWard),"^",2)
	i PacWardDesc["-" s PacWardDesc=$P(PacWardDesc,"-",2)
	s EmrCode=$p(Parr,"^",5)
	s ddflag=$p($g(Parr),"^",6)
	s DHCNURImpressScoreS=$p($g(Parr),"^",7)
	s YCDYflag=$p($g(Parr),"^",8)
	i EmrCode="DHCNURANHUI8" s TItem="不良事件"
	i EmrCode="DHCNURANHUI9" s TItem="压疮上报"
	i EmrCode="DHCNURANHUI10" s TItem="跌倒坠床"
	s EmrCode=" "_EmrCode
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s DHCMoudid="" f  s DHCMoudid=$o(^Nur.DHCMoudDataI("Anaes",EmrCode," ",DHCMoudid)) q:DHCMoudid=""  d
	.s tmpstr=^Nur.DHCMoudDataD(DHCMoudid)
	.s obj=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	.s adm=$List(tmpstr,109)
	.s PAADMCurrentWardDr=$p(^PAADM(adm),"^",70)
	.s ctlocdr=$p(^PAWARD(PAADMCurrentWardDr),"^",5)
	.//s flag=..NurMasterRight(userid,ctlocdr)  权限控制查后放开
	.//q:flag'=1   权限控制查后放开
	.s WardDesc=$p(^PAWARD(PAADMCurrentWardDr),"^",2)
	.i EmrCode=" DHCNURANHUI9" s WardDesc=obj.Item1
	.i EmrCode=" DHCNURANHUI10" s WardDesc=obj.Item2
	.s WardDesc=$tr(WardDesc," ","")
	.q:(PacWardDesc'="")&&(PacWardDesc'=WardDesc)&&(PacWardDesc'="undefined")
	.s TWard=$p(^PAWARD(PAADMCurrentWardDr),"^",2)
	.s PAADMPAPMIDR=$p(^PAADM(adm),"^",1)
	.s TPat=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
	.//s TItem="压疮上报"
	.//s TItem="跌倒坠床"
	.s TDate=$List(tmpstr,4)
	.q:(TDate<StartDate)!(TDate>EndDate)
	.s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	.s TTime=$List(tmpstr,5)
	.s TTime=$zt(TTime,3)
	.s TCreator=$List(tmpstr,54)
	.i EmrCode=" DHCNURANHUI9" s TCreator=obj.Item40
	.i EmrCode=" DHCNURANHUI10" s TCreator=obj.Item15
	.i TCreator'="" d
	..i TCreator["!" s TCreator=$p(TCreator,"!",2)
	..e  s TCreator=$P($g(^SSU("SSUSR",TCreator)),"^",2)
	.i (EmrCode=" DHCNURANHUI10")&&(TCreator="") s TCreator=obj.Item15
	.i (EmrCode=" DHCNURANHUI9")&&(TCreator="") s TCreator=obj.Item40
	.//s TCreator=$p(TCreator,"!",2)
	.s Item27=$List(tmpstr,27)
	.s Item29=$List(tmpstr,29)
	.s Item14=$List(tmpstr,14)
	.s Item15=$List(tmpstr,15)
	.s Item16=$List(tmpstr,16)
	.s Item17=$List(tmpstr,17)
	.s Item18=$List(tmpstr,18)
	.s Item57=$List(tmpstr,57)
	.s Item20=$List(tmpstr,20)
	.s Item21=$List(tmpstr,21)
	.s Item13=$List(tmpstr,13)
	.i (EmrCode=" DHCNURANHUI9") d
	..s TScore=Item29,TSkinulcerQuality=$p(Item13,"!",1)
	..i (TSkinulcerQuality="压疮高危患者")!(TSkinulcerQuality="") s YOrNSkinulcerQuality="否"  //判断是否院外压疮带入
	..e  s YOrNSkinulcerQuality="是"
	..i TScore="NaN" s TScore=""
	..s rw=$O(^Nur.DHCNurseRecParentI("Episode"," "_adm,""))
	..i rw="" s TYOrNSkinulcer="否"
	..e  d
	...s subrowid=""  f  s subrowid=$o(^Nur.DHCNurseRecSubD(rw,subrowid)) q:subrowid=""  d
	....s tmp("Id")=rw_"||"_subrowid
	....s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	....i (a.Item36="是")&&(a.RecCancelUser="")  s TYOrNSkinulcer="是"
	....e  s TYOrNSkinulcer="否"
	.q:(EmrCode=" DHCNURANHUI9")&&(YOrNSkinulcerQuality'[YCDYflag)&&(YCDYflag="是")
	.q:(EmrCode=" DHCNURANHUI9")&&(YOrNSkinulcerQuality["是")&&(YCDYflag="否")
	.q:(EmrCode=" DHCNURANHUI9")&&(TYOrNSkinulcer'[ddflag)&&(ddflag="是")
	.q:(EmrCode=" DHCNURANHUI9")&&(TYOrNSkinulcer["是")&&(ddflag="否")
	.//i (EmrCode=" DHCNURANHUI9")&&(Item14="!")&&(Item15="!")&&(Item16="!")&&(Item17="!")&&(Item18="!")&&(Item20="!")&&(Item21="!")&&(Item57="!")  s sfycflag="否"
	.//e  s sfycflag="是"
	.q:(EmrCode=" DHCNURANHUI9")&&(Item29>12)&&(DHCNURImpressScoreS="分值<=12")  //压疮大于12分的不看 护理部 叶祺  2012-09-14
	.q:(EmrCode=" DHCNURANHUI9")&&(Item29>17)&&(DHCNURImpressScoreS="13<=分值<=17")
	.q:(EmrCode=" DHCNURANHUI9")&&(Item29<13)&&(DHCNURImpressScoreS="13<=分值<=17")
	.//q:(EmrCode=" DHCNURANHUI9")&&(sfycflag'[ddflag)&&(ddflag'="全部")
	.q:(EmrCode=" DHCNURANHUI10")&&(Item27'[ddflag)&&(ddflag="是") //增加跌倒坠床是否发生的判断
	.q:(EmrCode=" DHCNURANHUI10")&&(Item27["是")&&(ddflag="否")
	.s TState="保存"
	.s aa="TWard"_"|"_TWard_"^"_"TPat"_"|"_TPat_"^"_"TItem"_"|"_$g(TItem)_"^"_"TDate"_"|"_TDate_"^"_"TTime"_"|"_TTime_"^"_"TCreator"_"|"_TCreator_"^"_"TState"_"|"_TState_"^"_"Tadm"_"|"_adm_"^"_"Tid"_"|"_DHCMoudid_"^"_"TScore"_"|"_TScore_"^"_"TSkinulcerQuality"_"|"_TSkinulcerQuality_"^"_"TYOrNSkinulcer"_"|"_TYOrNSkinulcer 
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURKPQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURKPQueryExecute ]
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

ClassMethod DHCNURKPQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURKPQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*
Query DHCNURANHUI12grid(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURANHUI12gridExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURThirtyDaysgrid","2011-10-10^2011-10-11")
	s aa=""
	s TWard="",TPat="",TItem="",TDate="",TTime="",TCreator="",TState=""
	s StartDate=$p(Parr,"^",1)
	s EndDate=$p(Parr,"^",2)
	s PacWard=$p(Parr,"^",3)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	i EndDate["-" s EndDate=$ZDH(EndDate,3)
	i EndDate["/" s EndDate=$ZDH(EndDate,4)
	s DHCMoudid="" f  s DHCMoudid=$o(^Nur.DHCMoudDataI("Anaes"," DHCNURANHUI10"," ",DHCMoudid)) q:DHCMoudid=""  d
	.s tmpstr=^Nur.DHCMoudDataD(DHCMoudid)
	.s adm=$List(tmpstr,109)
	.s PAADMCurrentWardDr=$p(^PAADM(adm),"^",70)
	.s WardDesc=$p(^PAWARD(PAADMCurrentWardDr),"^",2)
	.//s ^odj(adm)=WardDesc_"^"_PacWard
	.q:(PacWard'="")&&(PacWard'=WardDesc)&&(PacWard'="undefined")
	.s TWard=$p(^PAWARD(PAADMCurrentWardDr),"^",1)
	.s PAADMPAPMIDR=$p(^PAADM(adm),"^",1)
	.s TPat=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
	.s TItem="跌倒坠床"
	.s TDate=$List(tmpstr,4)
	.q:(TDate<StartDate)!(TDate>EndDate)
	.s TDate=$zd(TDate,3)
	.s TTime=$List(tmpstr,5)
	.s TTime=$zt(TTime,3)
	.s TCreator=$List(tmpstr,54)
	.s TCreator=$p(TCreator,"!",2)
	.s TState="保存"
	.s aa="TWard"_"|"_TWard_"^"_"TPat"_"|"_TPat_"^"_"TItem"_"|"_$g(TItem)_"^"_"TDate"_"|"_TDate_"^"_"TTime"_"|"_TTime_"^"_"TCreator"_"|"_TCreator_"^"_"TState"_"|"_TState_"^"_"Tadm"_"|"_adm_"^"_"Tid"_"|"_DHCMoudid_"^"
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURANHUI12gridFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURANHUI12gridExecute ]
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

ClassMethod DHCNURANHUI12gridClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURANHUI12gridExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}
*/
Query DHCNURThirtyDaysgrid(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURThirtyDaysgridExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURThirtyDaysgrid","2011-10-10^2011-10-11")
	s aa=""
	s XuHao=0,RegNo="",PatName="",Age="",Sex="",AdmDate="",AdmCtloc="",AdmDiag="",OperateDesc="",OperateDoctor="",TotalFee=""
	s StartDate=$p(Parr,"^",1)
	s EndDate=$p(Parr,"^",2)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	i EndDate["-" s EndDate=$ZDH(EndDate,3)
	i EndDate["/" s EndDate=$ZDH(EndDate,4)
	s Adm="" f  s Adm=$o(^PAADMi("PAADM_Type","I",Adm)) q:Adm=""  d
	.s OperateDoctor="",OperateDesc=""
	.s AdmStatus=$p(^PAADM(Adm),"^",20)
	.q:AdmStatus'="A"
	.s PAADMAdmDate=$p(^PAADM(Adm),"^",6)
	.s QTRECRowID=$o(^DHCADMQTREC("adm",Adm,""))
    .q:$g(QTRECRowID)=""
	.s DHCADMDate=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
	.s PAADMAdmDate=DHCADMDate
	.q:(+$h-PAADMAdmDate)<30    ;在院时间小于30天的离开
	.s paadmdr=$p(^PAADM(Adm),"^",1)
	.s RegNo=$p(^PAPER(paadmdr,"PAT",1),"^",1) 
	.s reglen=$l(RegNo)
	.f i=reglen:1:7  d
	..s RegNo="0"_RegNo          //住院号
	.s PAADMDepCodeDR=$p(^PAADM(Adm),"^",4)
	.s pinfo=..Patinfo(Adm)
	.q:pinfo=""
	.s PatName=$P(pinfo,"#",2)
	.s Sex=$P(pinfo,"#",9)
	.s AdmCtloc=$p(^CTLOC(PAADMDepCodeDR),"^",2) 
	.s AdmCtloc=$p(AdmCtloc,"-",2)
	.q:AdmCtloc["肿瘤放疗简易"
	.s AdmDate=$zd(PAADMAdmDate,3)
	.s XuHao=XuHao+1
	.s dob=$p($G(^PAPER(paadmdr,"ALL")),"^",6)
    .s Age=..CalAge(dob,$h)
    .//s AdmDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"#TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V")
    .s AdmDiag=$$GetInDiag^DHCINSUPatInfo(Adm)
    .s AdmDiag=$p(AdmDiag,"^",4) 
    .s TotalFee=..totalamount(Adm) 
	.s chl=0 f  s chl=$O(^OR(Adm,"ANA",chl)) q:(chl="")  d
	..s subchl=0 f  s subchl=$O(^OR(Adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	...s docdr=$P(^OR(Adm,"ANA",chl,"OP",subchl),"^",8)      ;ANAOP_Surgeon_DR  ；手术医师
	...if docdr'="" s OperateDoctor=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	...s opdr=$P(^OR(Adm,"ANA",chl,"OP",subchl),"^",6)       ;ANAOP_Type_DR     ；手术名称
	...q:opdr=""
	...if $D(^ORC("OPER",opdr)) s OperateDesc=$P(^ORC("OPER",opdr),"^",2)
	.s aa="XH"_"|"_XuHao_"^"_"RegNo"_"|"_RegNo_"^"_"PatName"_"|"_$g(PatName)_"^"_"Age"_"|"_Age_"^"_"Sex"_"|"_Sex_"^"_"AdmDate"_"|"_AdmDate_"^"_"AdmCtloc"_"|"_AdmCtloc_"^"_"AdmDiag"_"|"_AdmDiag_"^"_"OperateDesc"_"|"_OperateDesc_"^"_"OperateDoctor"_"|"_OperateDoctor_"^"_"TotalFee"_"|"_TotalFee_"^"
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURThirtyDaysgridFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURThirtyDaysgridExecute ]
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

ClassMethod DHCNURThirtyDaysgridClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURThirtyDaysgridExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 取病人基本信息的函数

ClassMethod Patinfo(Adm As %String) As %String
{
		   s CurrentBedDR=""
		   s VisitStatus=""
		   s VisitStatus=$P(^PAADM(Adm),"^",20)
		   i VisitStatus="D" d  //出院病人取转床最后一条记录的床号
           .s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       ..s CurrentBedDRTMP=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       ..i CurrentBedDRTMP'="" s CurrentBedDR=CurrentBedDRTMP
           i VisitStatus="A" s CurrentBedDR=$P(^PAADM(Adm),"^",73)   //在院病人取PA_adm表里的记录,因为存在在等待区未入床的情况所以不能取转床最后一条记录
	       q:CurrentBedDR="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s ctlocdesc=$P(^CTLOC(ctlocdr),"^",2)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s Sexdr=$P(^PAPER(Papmidr,"ALL"),"^",7)
	       s sex=$P(^CT("SEX",Sexdr),"^",2) 
	       s bedchl=$P(CurrentBedDR,"||",2)
	       s Ward=$P(CurrentBedDR,"||",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"

	       s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdesc)_"#"_$G(wardloc)_"#"_pstop_"#"_psleft_"#"_RegNo_"#"_sex
         q adm(Bed)
}

// 取年龄的函数

ClassMethod CalAge(IBirth As %String, IToday As %String) As %String
{
 s IBirth=$g(IBirth),IToday=$g(IToday)
 ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
 ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
 ;
 s $P(AgeYr,"|",12)=AgeYear
 q AgeYear
}

// 取总费的函数

ClassMethod totalamount(PatID) As %String
{
	s cost=0
	s atadr=""
	;I $D(^DHCATA(0,"ADM",PatID)) s atadr=$o(^DHCATA(0,"ADM",PatID,""))
	;i atadr'="" s cost=$p(^DHCATA(atadr),"^",5)
	i $d(^DHCPB(0,"ADM",PatID))  d
	.f  s atadr=$o(^DHCPB(0,"ADM",PatID,atadr))  q:atadr=""  d 
	..i $d(^DHCPB(atadr))  d
	...s bill=$p(^DHCPB(atadr),"^",16)
	...q:bill="P"
	...s cost=cost+$p(^DHCPB(atadr),"^",12)
	q cost
}

// 判断住院超30日病人的床位图函数

ClassMethod GetExceedInPat30Days(Adm As %String) As %String
{
	//w ##class(web.DHCBlurQuery).GetExceedInPat30Days("10065500")
	s ret=0,DHCADMDate=""
    s NowDate=$p($h,",",1)
	s PAADMAdmDate=$p(^PAADM(Adm),"^",6)  //入院日期
	s QTRECRowID=$o(^DHCADMQTREC("adm",Adm,""))
	i $g(QTRECRowID)'="" d
	.s DHCADMDate=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)  //按医务处要求取入床时间
	i (DHCADMDate=0)!(DHCADMDate="") s DHCADMDate=PAADMAdmDate  //如果没有入床时间那么取入院时间
	i $g(DHCADMDate)'="" d
    .i (+$h-DHCADMDate)>=30 s ret=1 
    //i (+$h-PAADMAdmDate)>=30 s ret=1
    q ret
}

ClassMethod ProduceDHCBlur()
{
	//w ##class(web.DHCBlurQuery).ProduceDHCBlur() 
	s Adm="" f  s Adm=$o(^PAADMi("PAADM_Type","I",Adm)) q:Adm=""  d
	.s AdmStatus=$p(^PAADM(Adm),"^",20)
	.q:AdmStatus'="D"
	.s PBRowId=""  f  s PBRowId=$o(^DHCPB(0,"ADM",Adm,PBRowId))  q:PBRowId=""  d
	..q:PBRowId=0
	..s PBPayedFlag=$p(^DHCPB(PBRowId),"^",16) 
	..q:PBPayedFlag="P"
	..s totalFeeT=0,DepostT=0
	..s totalFeeT=$p(^DHCPB(PBRowId),"^",8)  //总费用
	..s DepostT=##class(web.UDHCJFBaseCommon).deposit(Adm)  //住院预交金
	..q:(totalFeeT=0)&&(DepostT="0.00")
	..s paadmreasondr=$p(^PAADM(Adm,1),"^",7)
	..s paadmreasondesc=$p( ^PAC("ADMREA",paadmreasondr),"^",2) //患者就诊类型
	..s AdmWard=$p(^PAADM(Adm),"^",70)
	..q:AdmWard="238" //JJMZGCS-急救门诊观察室(3F)病区退出
	..q:AdmWard="237" //JJMZQJS-急救门诊抢救室(1F)病区退出
	..s HospitalWard=$p(^PAWARD(AdmWard),"^",2)  //病区
	..s PatRowid=$p(^PAADM(Adm),"^",1)
	..s InpatientName=$p(^PAPER(PatRowid,"ALL"),"^",1)  //姓名
	..s dw=$p($g(^PAPER(PatRowid,"PER","ADD",1)),"^",1)
	..s JobUnit=$g(dw)  //地址
	..s InpatientId=$p(^PAPER(PatRowid,"PAT",1),"^",1)  //住院号
	..s PAADMDepCodeDR=$p(^PAADM(Adm),"^",4)
	..s Office=$p(^CTLOC(PAADMDepCodeDR),"^",2)  //科室
	..s PAADMCurrentBedDr=$p(^PAADM(Adm),"^",73)
	..i PAADMCurrentBedDr'="" d
	...s WARDRowID=$P(PAADMCurrentBedDr,"||",1)
	...s BEDChildsub=$p(PAADMCurrentBedDr,"||",2)
	...s BedId=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1)
	..e  d
	...s BedId=""
	..s PAADMAdmDate=$p(^PAADM(Adm),"^",6)
	..i PAADMAdmDate'="" d
	...s InhospitalDate=$zd(PAADMAdmDate,3)
	..e  d
	...s InhospitalDate=""
	..s InpatientEstate="出院未结算"   //状态
	..s PAADMCurrentRoom=$p(^PAADM(Adm),"^",69)
	..i PAADMCurrentRoom=""  d
	...s Apartment=""
	..e  d
	...s Apartment=$p(^PAROOM(PAADMCurrentRoom),"^",2) //房间
	..//s totalFeeT=0,DepostT=0
	..//s totalFeeT=$p(^DHCPB(PBRowId),"^",8)  //总费用
	..//s DepostT=##class(web.UDHCJFBaseCommon).deposit(Adm)  //住院预交金
	..s INSUFlag=""
	..s Inadmrow="" f  s Inadmrow=$o(^DHCINADM("0","ADM",Adm,Inadmrow)) q:Inadmrow=""  d
	...s INSUFlag=$p(^DHCINADM(Inadmrow),"^",11)      ;lgl+医保状态
	...i INSUFlag="A" s INSUFlag="在院"
	...i INSUFlag="O" s INSUFlag="出院"
	...i INSUFlag="I" s INSUFlag="做废"
	..Do OutputRow
	s cward="" f  s cward=$o(^PAADMi("CurrWard",cward)) q:cward=""  d
	.s croom="" f  s croom=$o(^PAADMi("CurrWard",cward,croom)) q:croom=""  d
	..s Adm="" f  s Adm=$o(^PAADMi("CurrWard",cward,croom,Adm)) q:Adm=""  d
	...//s Adm="" f  s Adm=$o(^PAADMi("PAADM_Type","I",Adm)) q:Adm=""  d
	...s AdmStatus=$p(^PAADM(Adm),"^",20)
	...q:AdmStatus'="A"
	...s paadmreasondr=$p(^PAADM(Adm,1),"^",7)
	...//q:(($g(patadmreas)'="")&(patadmreas'=paadmreasondr))    ;lgl+
	...s PAADMCurrentBedDr=$p(^PAADM(Adm),"^",73)
    ...//q:((Onbed="on")&($g(PAADMCurrentBedDr)=""))
    ...;if $g(paadmreasondr)="" d
    ....;s papmi=$p(^PAADM(Adm),"^",1)
    ....;s ^lgltest("0628",Adm)=paadmreasondr_"^"_papmi
    ...;q:$g(paadmreasondr)=""     ;lgl+
    ...s paadmreasondesc=$p( ^PAC("ADMREA",paadmreasondr),"^",2)
	...s paadmdr=$p(^PAADM(Adm),"^",1)
	...s InpatientName=$p(^PAPER(paadmdr,"ALL"),"^",1) //s InpatientNameT=$p(^PAPER(paadmdr,"ALL"),"^",1)
	...s dw=$p($g(^PAPER(paadmdr,"PER","ADD",1)),"^",1)
	...s JobUnit=$g(dw)
	...//i Job'="" q:JobUnit'[Job
	...//i name'="" q:InpatientName'[name
	...s InpatientId=$p(^PAPER(paadmdr,"PAT",1),"^",1)  //2009/6/22系统故障导致重新编译pa_adm表索引后移改取pa_patmas
	...//s InpatientId=paadmdr //s InpatientIdT=paadmdr
	...s reglen=$l(InpatientId) //s reglen=$l(InpatientIdT)
	...f i=reglen:1:7  d
	....s InpatientId="0"_InpatientId //s InpatientIdT="0"_InpatientIdT
	...s PAADMDepCodeDR=$p(^PAADM(Adm),"^",4)
	...//i loc'="" q:PAADMDepCodeDR'=loc
	...s Office=$p(^CTLOC(PAADMDepCodeDR),"^",2) //s OfficeT=$p(^CTLOC(PAADMDepCodeDR),"^",2)
	...s CURRENTWARDDR=$p(^PAADM(Adm),"^",70)	
	...q:CURRENTWARDDR="238" //JJMZGCS-急救门诊观察室(3F)病区退出
	...q:CURRENTWARDDR="237" //JJMZQJS-急救门诊抢救室(1F)病区退出	
	...//i wardid'="" q:wardid'=CURRENTWARDDR
	...s HospitalWard=$p($g(^PAWARD(CURRENTWARDDR)),"^",2) //s HospitalWardT=$p($g(^PAWARD(CURRENTWARDDR)),"^",2)
	...s PAADMCurrentRoom=$p(^PAADM(Adm),"^",69)
	...i PAADMCurrentRoom=""  d
	....s Apartment="" //s ApartmentT=""
	...e  d 
	....s Apartment=$p(^PAROOM(PAADMCurrentRoom),"^",2) //s ApartmentT=$p(^PAROOM(PAADMCurrentRoom),"^",2)
	...i PAADMCurrentBedDr'="" d
	....s WARDRowID=$P(PAADMCurrentBedDr,"||",1)
	....s BEDChildsub=$p(PAADMCurrentBedDr,"||",2)
	....s BedId=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1) //s BedIdT=$p(^PAWARD(WARDRowID,"BED",BEDChildsub),"^",1)
	...e  d
	....s BedId="" //s BedIdT=""
	...s PAADMAdmDate=$p(^PAADM(Adm),"^",6)
	...//q:($g(Indate)'="")&&((+$h-PAADMAdmDate-Indate)<0)    ;lgl+入院多少天以上的
	...//i Date'="" q:PAADMAdmDate'=Date
	...i PAADMAdmDate'="" d
	....s InhospitalDate=$zd(PAADMAdmDate,3) //s InhospitalDateT=$zd(PAADMAdmDate,3)
	...e  d
	....s InhospitalDate="" //s InhospitalDateT=""
	...s InpatientEstate="在院"  //s InpatientEstateT="在院"
	...s INSUFlag=""
	...s Inadmrow="" f  s Inadmrow=$o(^DHCINADM("0","ADM",Adm,Inadmrow)) q:Inadmrow=""  d
	....s INSUFlag=$p(^DHCINADM(Inadmrow),"^",11)      ;lgl+医保状态
	....i INSUFlag="A" s INSUFlag="在院"
	....i INSUFlag="O" s INSUFlag="出院"
	....i INSUFlag="I" s INSUFlag="做废"
	...s totalFeeT=0,DepostT=0
	...s PBRowId=0  f  s PBRowId=$o(^DHCPB(0,"ADM",Adm,PBRowId)) q:PBRowId=""  d 
	....s totalFeeT=$p(^DHCPB(PBRowId),"^",8)
	...s DepostT=##class(web.UDHCJFBaseCommon).deposit(Adm) 
	...Do OutputRow
    Quit $$$OK 
     
OutputRow
    s a=##class(User.DHCBlur).%New()
    s a.ProduceDate=+$h
    s a.ProduceTime=$p($h,",",2)
    s a.InpatientId=InpatientId
	s a.InpatientName=InpatientName 
	s a.HospitalWard=HospitalWard 
	s a.Office=Office 
	s a.BedId=BedId
	s a.InhospitalDate=InhospitalDate
	s a.Apartment=Apartment
	s a.InpatientEstate=InpatientEstate
	s a.JobUnit=JobUnit
	s a.paadmreasondesc=paadmreasondesc
	s a.totalFeeT=totalFeeT
	s a.DepostT=DepostT
	s a.INSUFlagT=INSUFlag
	d a.%Save()
    quit
}

ClassMethod DelteRecord(Adm As %String, id As %String, code As %String, user As %String) As %String
{
	q:Adm="" 0
	q:code="" 0
	s code=$ZCvt(code,"U")
	i id'="" d
	.s a=##class(Nur.DHCMoudData).%DeleteId(id)
	.s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	.i par'=""  d
	..s inout="" f  s inout=$O(^Nur.DHCNurseRecSubI("TypInout"," "_code,inout)) q:inout=""  d
	...s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypInout"," "_code,inout,par,rw)) q:rw=""  d
	...s subid=par_"||"_rw
	...s subobj=##class(Nur.DHCNurseRecSub).%OpenId(subid)
	...q:subobj=""
	...s subobj.RecCancelDate=+$H
	...s subobj.RecCancelTime=$P($H,",",2)
	...s subobj.RecCancelUser=user
	...d subobj.%Save()
	q 0
}

}
