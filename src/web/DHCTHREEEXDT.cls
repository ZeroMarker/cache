Import SQLUser

Class web.DHCTHREEEXDT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPatInfo(Adm As %String) As %String
{
 //病人基本信息
	n (Adm)
	&sql(select distinct(PAADM_PAPMI_DR->PAPMI_No) into :RegNo
	       from PA_Adm
	       where PAADM_RowId=:Adm)
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Bah=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
	s IBirth=$p($g(^PAPER(papmi,"ALL")),"^",6)
	;s today=$p($h,",",1)
	s today=$p($g(^PAADM(Adm)),"^",6)
	s PatAge=##class(web.DHCTHREEEX).CalAge(IBirth,today)
	s PatLoc=$p($g(^CTLOC($p($g(^PAADM(Adm)),"^",4))),"^",2)
	i PatLoc["-" s P4=$p(PatLoc,"-",2)
	else  d 
	.s P4=PatLoc 
    s roomdr=$P(^PAADM(Adm),"^",69)
    if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    e  s room=""
    if $D(^PAPER(papmi,"PAT",3)) s Bah=$P(^PAPER(papmi,"PAT",3),"^",4) ;病案号
    s bedSub=$p($p($g(^PAADM(Adm)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(Adm)),"^",70)  
    s WardDes=$P(^PAWARD(curWardId),"^",2)
    s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    if MotherAdm'=""  s BabyFlag="1"
    else  s BabyFlag=""
    if MotherAdm'=""
    {
	    s MotherInfo=..GetMotherInfo(MotherAdm)
	    s MotherName=$P(MotherInfo,"^",2)
	    s MotherRegNo=$P(MotherInfo,"^",1)
	    s MotherBah=$P(MotherInfo,"^",3)
	   
	}
    if bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s BedCode=""
	s death=$P(^PAPER(papmi,"ALL"),"^",12)	
	if death="Y"  d
	.s OutDate=""
	.s OutTime=""
	else  d
	.s OutDate=$p($g(^PAADM(Adm)),"^",17) 
	.s OutTime=$p($g(^PAADM(Adm)),"^",18)
	//s OutDate=$p($g(^PAADM(Adm)),"^",17)
	//s OutTime=$p($g(^PAADM(Adm)),"^",18)
	if OutDate'="" s OutDate=$ZD(OutDate,3),OutTime=$ZT(OutTime,1)
	s ret=##class(web.DHCTHREEEX).GetDisDate(Adm,"出院")
	if ret'=""  s OutDate=$P(ret,"^",1),OutTime=$P(ret,"^",2)
	i $P(PatLoc,"-",2)'="" s PatLoc=$P(PatLoc,"-",2)
    i $P(WardDes,"-",2)'="" s WardDes=$P(WardDes,"-",2)
    q "PatName|"_PatName_"^RegNo|"_RegNo_"^Sex|"_Sex_"^PatAge|"_PatAge_"^PatLoc|"_PatLoc_"^OutDate|"_OutDate_"^OutTime|"_OutTime_"^room|"_room_"^WardDes|"_WardDes_"^BedCode|"_$G(BedCode)_"^Bah|"_$G(Bah)_"^BabyFlag|"_BabyFlag_"^MotherAdm|"_MotherAdm_"^MotherName|"_$G(MotherName)_"^MotherRegNo|"_$G(MotherRegNo)
	///
}

ClassMethod GetReason(funname As %String) As %String
{
    s rw=0  f  s rw=$O(^PAC("LEA",rw)) q:rw=""  d
	.s reas=$P(^PAC("LEA",rw),"^",2)
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(reas),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

// 根据RowId取离开记录

/// 2010-11-15
ClassMethod GetLeaveSingle(rowid) As %String
{
	//w ##class(web.DHCTHREEEX).GetLeaveSingle("338155||2")
	s parentrowid=$P(rowid,"||",1)
	s chl=$P(rowid,"||",2)
	q:(parentrowid="")!(chl="") ""
	s tm=$G(^PAADM(parentrowid,"LEA",chl))
	s godate=$P(tm,"^",2) //
	if godate'="" s godate=$ZD(godate,3)
	s gotime=$P(tm,"^",3)
	if gotime'="" s gotime=$ZT(gotime,1)
	s edatern=$P(tm,"^",5)  //预期返回日期
	if edatern'="" s edatern=$ZD(edatern,3)
	s etimern=$P(tm,"^",4)
	if etimern'="" s etimern=$zt(etimern,1)
	s rea=$P(tm,"^",6) //原因
	s doc=$P(tm,"^",7) //批准时间
	s nur=$P(tm,"^",8)  //
	s adatern=$P(tm,"^",9)
	if adatern'="" s adatern=$ZD(adatern,3)
	s atimern=$P(tm,"^",10)
	if atimern'="" s atimern=$zt(atimern,1)
	s turn=$P(tm,"^",11) //返回护士
	q godate_"^"_gotime_"^"_nur_"^"_edatern_"^"_etimern_"^"_rea_"^"_doc_"^"_adatern_"^"_atimern_"^"_turn
}

/// 取就诊科室医生或就诊病区的护士
/// 2010-11-15
ClassMethod GetDepPerson(typ As %String, adm As %String) As %String
{
	//w ##class(web.DHCTHREEEX).GetDepPerson("NURSE","338155")
	if typ="NURSE" d
 	.s ward=$P(^PAADM(adm),"^",70)
 	.s Loc=$P(^PAWARD(ward),"^",5)
 	if typ="DOCTOR" s Loc=$P(^PAADM(adm),"^",4)
	s ret=""
	s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",Loc,rw)) q:rw=""  d
	.s ctpcp=$P(^RB("RES",rw),"^",2) 
	.q:ctpcp=""
	.s docdes=$P(^CTPCP(ctpcp,1),"^",2)
	.s ret=ret_ctpcp_"|"_docdes_"^"
 	q ret
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary) As %Status
{
   //web.DHCTHREEEX.GetTimePoint
	Set repid=$I(^CacheTemp)
 	s ind=1
    s id=1,des="04:00:00"
	d out1
 	s id=2,des="08:00:00"
	d out1
 	s id=3,des="12:00:00"
	d out1
 	s id=4,des="16:00:00"
	d out1
 	s id=5,des="20:00:00"
	d out1
	s id=6,des="23:59:59"
	d out1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTimePointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimePointExecute ]
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

ClassMethod GetTimePointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimePointExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTimePoint() As %Query(ROWSPEC = "idv,des")
{
}

Query LeaveGetinfo(parentrowid As %String) As %Query(ROWSPEC = "godate,gotime,nurse,edatern,etimern,reason,drapprove,adatern,atimern,nursern,rowid,chi,nur,rea,doc,turn")
{
}

ClassMethod LeaveGetinfoExecute(ByRef qHandle As %Binary, parentrowid As %String) As %Status
{
  //病人外出记录
	Set repid=$I(^CacheTemp)
 	s ind=1

	s chl=0  f  s chl=$O(^PAADM(parentrowid,"LEA",chl)) q:chl=""  d
	.s tm=^PAADM(parentrowid,"LEA",chl)
	.s godate=$P(tm,"^",2) //
	.if godate'="" s godate=$ZD(godate,3)
	.s gotime=$P(tm,"^",3)
	.if gotime'="" s gotime=$ZT(gotime,1)
	.s edatern=$P(tm,"^",5)  //预期返回日期
	.b
	.if edatern'="" s edatern=$ZD(edatern,3)
	.s etimern=$P(tm,"^",4)
	.if etimern'="" s etimern=$zt(etimern,1)
	.b
	.s rea=$P(tm,"^",6) //原因
	.s doc=$P(tm,"^",7) //批准时间
	.s nur=$P(tm,"^",8)  //
	.s adatern=$P(tm,"^",9)
	.if adatern'="" s adatern=$ZD(adatern,3)
	.s atimern=$P(tm,"^",10)
	.if atimern'="" s atimern=$zt(atimern,1)
	.s turn=$P(tm,"^",11) //返回护士
	.if (rea'="")&((rea'=0)) s reason=$P(^PAC("LEA",rea),"^",2)
	.e  s reason=""
	.if nur'="" s nurse=$P(^CTPCP(nur,1),"^",2)
	.e  s nurse=""
	.if doc'="" s drapprove=$P(^CTPCP(doc,1),"^",2)
	.e   s drapprove=""
	.if turn'="" s nursern=$P(^CTPCP(turn,1),"^",2)
	.e  s nursern=""
	.s rowid=parentrowid_"||"_chl
	.d outleave
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
outleave
	set Data=$lb(godate,gotime,nurse,edatern,etimern,reason,drapprove,adatern,atimern,nursern,rowid,chl,nur,rea,doc,turn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LeaveGetinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LeaveGetinfoExecute ]
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

ClassMethod LeaveGetinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LeaveGetinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMotherInfo(Adm As %String) As %String
{
  //病人基本信息
	n (Adm)
	&sql(select distinct(PAADM_PAPMI_DR->PAPMI_No) into :RegNo
	       from PA_Adm
	       where PAADM_RowId=:Adm)
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Bah=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
	;s today=$p($h,",",1)
	q RegNo_"^"_PatName_"^"_Bah
}

}
