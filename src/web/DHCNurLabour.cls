Import SQLUSER

Include Nur.DateFormat

Class web.DHCNurLabour Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// By    ljw20081230

// 判断病人是否重复

ClassMethod RepOperFloor(Code As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("Floor",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("Floor",OPRowid),"^",1)

	.i (RCode=Code) s flag="Y"
	q flag
}

// 插入数据

ClassMethod InsertProcDelivery(AdmDR As %String, Status As %String, LaborDate As %String, LaborTime As %String, UpdateUserDR As %String = "", UpdateDate As %String = "", UpdateTime As %String = "", UserID As %String = "")
{
 q:$g(^PAADM(AdmDR))="" "就诊号不存在！"
 s MotherAdm=$p($g(^PAADM(AdmDR)),"^",75)
 q:MotherAdm'="" "此患者为婴儿,不能做此操作!"
 s papmiDR=$p($g(^PAADM(AdmDR)),"^",1)
 s LaborDate=$$$ZDH(LaborDate,4)
 s LaborTime=$ZTH(LaborTime)
 s exitfalg=""
 s i=0
 s pregRowID=""
 f  s pregRowID=$o(^PAPRGi("PREG_Person",papmiDR,pregRowID),-1) q:(pregRowID="")!(i>0)  d
 .s pregRowID=$p(pregRowID,$c(1))
 .s pregStatusDR=$p($g(^PAPRG(pregRowID)),"^",23)
 .s pregStatusDR=$p(pregStatusDR,$c(1))
 .s pregstCode=$p($g(^PAC("PREGST",pregStatusDR)),"^",1)
 .i (pregstCode="O") d
 ..i '$d(^PAPRGi("DEL_Adm_DR",AdmDR,pregRowID,"DEL")) d
 ...&SQL(insert into PA_PregDelivery(del_parref,del_adm_dr) values(:pregRowID,:AdmDR)) 
 ...s dhcDelID=%ROWID
 ...s Labor="L"
 ...&SQL(update DHC_PA_PregDelivery set  DEL_Status=:Labor,DEL_LaborDate=:LaborDate,DEL_LaborTime=:LaborTime where DEL_RowID=:dhcDelID)
 ...s i=i+1
 ..e  d
 ...s delsub=""
 ...s delsub=$o(^PAPRGi("DEL_Adm_DR",AdmDR,pregRowID,"DEL",delsub))
 ...s dhcDelID=pregRowID_"||"_delsub
 ...s preDelStatus=$p($g(^PAPRG(pregRowID,"DEL",delsub,"DHC")),"^",10)
 ...s preLaborDate=$p($g(^PAPRG(pregRowID,"DEL",delsub,"DHC")),"^",11)
 ...i (preLaborDate'="")&(preDelStatus'="C") s exitfalg=$$$zd(preLaborDate,3) q
 ...s tmpLabor="L"
 ...&SQL(update DHC_PA_PregDelivery set DEL_Status=:tmpLabor,DEL_LaborDate=:LaborDate,DEL_LaborTime=:LaborTime where DEL_RowID=:dhcDelID)
 ...s i=i+1
 q:(i>0) 0
 q:(exitfalg'="") "此患者在"_exitfalg_"已经有记录!"
 s pregflag=""
 
 i i=0 d
 .i $d(^PAPRGi("PREG_Person",papmiDR)) d
 ..s pregRowID=""
 ..f  s pregRowID=$o(^PAPRGi("PREG_Person",papmiDR,pregRowID),-1) q:(pregRowID="")!(pregflag=1)  d
 ...q:pregflag=1
 ...s pregRowID=$p(pregRowID,$c(1))
 ...s pregStatusDR=$p($g(^PAPRG(pregRowID)),"^",23)
 ...s pregStatusDR=$p(pregStatusDR,$c(1))
 ...s pregstCode=$p($g(^PAC("PREGST",pregStatusDR)),"^",1)
 ...i (pregstCode="O") s pregflag=1
 
 i pregflag="" d
 .s pregstRowID=""
 .s pregstRowID=$o(^PAC("PREGST",0,"Code","O",pregstRowID))
 .s Medtrak="Medtrak"
 .s curdate=+$h
 .s curTime=$p($h,",",2)
 .If $G(UserID)="" Set UserID= $G(%session.Data("LOGON.USERID"))
 .&SQL(insert into PA_Pregnancy(PREG_Person_DR,PREG_Status,PREG_PregType, PREG_UpdateDate,PREG_UpdateTime,PREG_UpdateUser_DR) values(:papmiDR,:pregstRowID,:Medtrak,:curdate,:curTime,:UserID))
 .s pregRowID=%ROWID
 .&SQL(Update PA_Adm Set PAADM_Pregnancy_DR= :pregRowID Where PAADM_RowId= :AdmDR)
 .&SQL(insert into PA_PregDelivery(del_parref,del_adm_dr) values(:pregRowID,:AdmDR)) 
 .s dhcDelID=%ROWID
 .s Labor="L"
 .&SQL(update DHC_PA_PregDelivery set  DEL_Status=:Labor,DEL_LaborDate=:LaborDate,DEL_LaborTime=:LaborTime where DEL_RowID=:dhcDelID)
 q 0
}

Query FindInfo(stdate As %Library.Date, enddate As %Library.Date, IPid As %String, FindStatusIdE As %String = "", CTLocId As %String = "") As %Query(ROWSPEC = "TAdmDr:%String,TStatus:%String,TLaborDate:%String,TLaborTime:%String,TRowId:%String,TRegno:%String,Tpname:%String,TCTLoc:%String,TWard:%String,Tage:%String,canGiveBirth:%String,PatientID:%String,EpisodeID:%String,MedCareNoIP:%String")
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary, stdate As %Library.Date, enddate As %Library.Date, IPid As %String, FindStatusIdE, CTLocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^mltemp($J)
	i $G(stdate)="" s stdate=+$h
	i $G(enddate)="" s enddate=+$h
	i FindStatusIdE="" s FindStatusIdE="L"
	s j=1
	
	f PrtDate=stdate:1:enddate  d
	.s preRowid=0
	.f  s preRowid=$o(^PAPRGi("DEL_LaborDate",PrtDate,preRowid)) q:preRowid=""  d
	..s delChildsub=0 
	..f  s delChildsub=$o(^PAPRGi("DEL_LaborDate",PrtDate,preRowid,"DEL",delChildsub)) q:delChildsub=""  d
	...s AdmID=$p($g(^PAPRG(preRowid,"DEL",delChildsub)),"^",1)
    ...q:AdmID=""
    ...s TStatusCode=$p($g(^PAPRG(preRowid,"DEL",delChildsub,"DHC")),"^",10)
	...i (TStatusCode="L") d
	....s babyIDflag=$o(^PAPRG(preRowid,"DEL",delChildsub,"BABY",0))
	....i $g(babyIDflag)'="" d
	.....s $p(^PAPRG(preRowid,"DEL",delChildsub,"DHC"),"^",10)="D"
	.....s TStatusCode="D"
	...i TStatusCode="M" s TStatus="监护"
	...i TStatusCode="L" s TStatus="待产"
	...i TStatusCode="D" s TStatus="分娩"
	...i TStatusCode="R" s TStatus="产后康复"
	...i TStatusCode="O" s TStatus="手术"
	...i TStatusCode="W" s TStatus="病房"
	...i TStatusCode="C" s TStatus="取消"
	...s Tpapmidr=$p($g(^PAADM(AdmID)),"^",1)
	...s IPDr=$p($g(^PAPER(Tpapmidr,"PAT",1)),"^",1)
	...q:(IPid'="")&(IPDr'=IPid)
	...q:(FindStatusIdE'="ALL")&(FindStatusIdE'=TStatusCode)
	...;q:(TStatusCode="C")
	...;s ^pjftest($i(^pjftest))=FindStatusIdE_"@"_TStatusCode
	...;s MedCareNoIP=##class(web.DHCWMRService).IGetMrTypeInfo(AdmID) //病案号
	...;s MedCareNoIP=$p(MedCareNoIP,"^",1)
	...s MedCareNoIP=$p($g(^PAPER(Tpapmidr,"PAT",1)),"^",22)	//2010-02-02 直接取值
	...s Tpapmidr=$p($g(^PAADM(AdmID)),"^",1)
	...s TRegno=$p($g(^PAPER(Tpapmidr,"PAT",1)),"^",1)
	...s Tpname=$p($g(^PAPER(Tpapmidr,"ALL")),"^",1)
	...s TDepCodedr=$p($g(^PAADM(AdmID)),"^",4)
	...q:(CTLocId'="")&(CTLocId'=TDepCodedr)
	...s TCTLoc=$p($g(^CTLOC(TDepCodedr)),"^",2)
	...s TCurrentWarddr=$p($g(^PAADM(AdmID)),"^",70)
	...i TCurrentWarddr'="" s TWard=$p($g(^PAWARD(TCurrentWarddr)),"^",2)
	...e  s TWard=""
	...s TBriday=$p($g(^PAPER(Tpapmidr,"ALL")),"^",6)
	...s TTodat=$p($h,",",1)
	...;s Tage=##Class(web.DHCCLCom).CalAge(TBriday,TTodat)
	...;s Tage=$p(Tage,"Y",1)_"岁"_$p(Tage,"Y",2)
    ...;s Tage=$p(Tage,"M",1)_"月"_$p(Tage,"M",2)
    ...;s Tage=$p(Tage,"D",1)_"天"_$p(Tage,"D",2)
    ...;i Tage>2 s Tage=$p(Tage," ",1)
    ...;i (Tage>1)&(Tage<3) s Tage=$p(Tage," ",1,2)
    ...;i Tage<1 d
    ...;.s Tage=$p(Tage," ",2,3)
    ...;.i Tage<1 s Tage=$p(Tage," ",2) q
    ...;.i Tage>5 s Tage=$p(Tage," ",1)
    ...s Tage=##Class(web.DHCBillInterface).GetPapmiAge(Tpapmidr,AdmID)
	...s TLaborDate=$p($g(^PAPRG(preRowid,"DEL",delChildsub,"DHC")),"^",11)
	...s Date=TLaborDate
	...i TLaborDate'="" s TLaborDate=$$$zd(TLaborDate,4)
	...s TLaborTime=$p($g(^PAPRG(preRowid,"DEL",delChildsub,"DHC")),"^",12)
	...s Time=TLaborTime
	...i TLaborTime'="" s TLaborTime=$zt(TLaborTime)
	...s TRowId=preRowid_"||"_delChildsub
	...s PatientID=""
	...s sex=$p($g(^CT("SEX",$p($g(^PAPER(Tpapmidr,"ALL")),"^",7))),"^",2)
	...i AdmID'="" s PatientID=+^PAADM(AdmID)
	...s EpisodeID=AdmID
	...s j=j+1
	...;s tmpTDepCodedr="^"_TDepCodedr_"^"
	...;s canGiveBirthLOCID=$g(^DHCCLSet("AnOp","canGiveBirthLOCID"))
	...;s canGiveBirthLOCID="^"_canGiveBirthLOCID_"^"
	...s canGiveBirth=0
	...;i (tmpTDepCodedr'="^^")&(canGiveBirthLOCID[tmpTDepCodedr)&(sex["女") d
	...i (sex["女") d
	....s curADMMotherAdmDR=$p(^PAADM(AdmID),"^",75)
	....i curADMMotherAdmDR="" s canGiveBirth=1
	...s TAdmDr=AdmID
	...s ^mltemp($J,-Date,-Time,j)=$lb(TAdmDr,TStatus,TLaborDate,TLaborTime,TRowId,TRegno,Tpname,TCTLoc,TWard,Tage,canGiveBirth,PatientID,EpisodeID,MedCareNoIP)
	...//d OutputRow
	
	
	s Date=""  f  s Date=$O(^mltemp($J,Date)) q:Date=""  d
	.s Time="" f  s Time=$O(^mltemp($J,Date,Time))  q:Time=""  d
	..s j="" f  s j=$O(^mltemp($J,Date,Time,j)) q:j=""  d
	...do OutputRow
	k ^mltemp($J)
	Set qHandle=$lb(0,repid,0)
	Quit 1
OutputRow
	Set ^CacheTemp(repid,ind)=^mltemp($J,Date,Time,j)
 	Set ind=ind+1
	quit
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UPDATED(Rowid As %String, Status As %String)
{
	i (Rowid'="") d
	.k PLIST
	.TSTART
	.s tmpLabor=Status
    .&SQL(update DHC_PA_PregDelivery set DEL_Status=:tmpLabor where DEL_RowID=:Rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

Query FindStatus() As %Query(ROWSPEC = "StatusCode:%String,StatusDese:%String")
{
}

ClassMethod FindStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s StatusCode="O",StatusDese="手术"
	d OutputRow22
	s StatusCode="D",StatusDese="分娩"
	d OutputRow22
	s StatusCode="R",StatusDese="产后康复"
	d OutputRow22
	s StatusCode="W",StatusDese="病房"
	d OutputRow22
	s StatusCode="M",StatusDese="监护"
	d OutputRow22
	;s StatusCode="C",StatusDese="取消"
	;d OutputRow22
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow22
	set Data=$lb(StatusCode,StatusDese)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusExecute ]
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

ClassMethod FindStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindStatusE() As %Query(ROWSPEC = "StatusCode:%String,StatusDese:%String")
{
}

ClassMethod FindStatusEExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s StatusCode="L",StatusDese="待产"
	d OutputRow22
	s StatusCode="O",StatusDese="手术"
	d OutputRow22
	s StatusCode="D",StatusDese="分娩"
	d OutputRow22
	s StatusCode="R",StatusDese="产后康复"
	d OutputRow22
	s StatusCode="W",StatusDese="病房"
	d OutputRow22
	s StatusCode="M",StatusDese="监护"
	d OutputRow22
	s StatusCode="ALL",StatusDese="全部"
	d OutputRow22

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow22
	set Data=$lb(StatusCode,StatusDese)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusEExecute ]
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

ClassMethod FindStatusEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusEExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "OPRCTLoc:%String,OPRLocID:%String")
{
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
	              WHERE (UPPER(ctloc_desc) like :desc) OR UPPER(CTLOC_ContactName) like :desc)
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
	.s type=$p(^CTLOC(ctlocrowid),"^",19)
	.q:type'=2
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

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query checkqu() As %Query(ROWSPEC = "ord,typ")
{
}

ClassMethod checkquExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s typ="自然",ord="Y"
    d output111
    s typ="人工",ord="N"
    d output111
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output111
 set Data=$lb(ord,typ)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod checkquFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = checkquExecute ]
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

ClassMethod checkquClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = checkquExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
