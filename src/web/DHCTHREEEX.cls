Import SQLUser

/// web.DHCTHREEEX
Class web.DHCTHREEEX Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 185;

ClassMethod CalAge(IBirth, IToday) As %String
{
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
	s IBirth=$g(IBirth),IToday=$g(IToday)
	i IBirth>2980000 s IBirth=""
	i IBirth<0 s IBirth=""
	q:'$G(IBirth) ""
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
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	;q AgeYr_"|"_AgeMth_"|"_AgeDay
	q reage
}

ClassMethod LeaveDelete(rowid As %String) As %String
{
		&sql(delete from pa_admleave where adml_rowId =:rowid)       
	q SQLCODE
}

ClassMethod LeaveInsert(para As %String, parentrowid As %String, childrowid As %String) As %String
{
	; para = godate,gotime,nurse,edatern,etimern,reason,drapprove,adatern,atimern,nursern
	n (para,parentrowid,childrowid)
	//s para="2006-02-27!10:18:00!29!2006-02-27!10:18:27!1!15!2006-02-27!10:18:52!193"
	//s parentrowid=1
	s godate=$p(para,"!",1)
	if godate'="" 
	{
		set godate=$ZDH(godate,3)
	}
	else
	{
	}
	s gotime=$p(para,"!",2)
	s flag=##class(web.DHCLCNUREXCUTE).istime(gotime)
	q:(gotime'="")&&(flag=0) "时间格式不对"
	if gotime'="" 
	{
		s gotime=$ZTH(gotime,3)
	}
	s nurse=$p(para,"!",3)
	
	s edatern=$p(para,"!",4)
	if edatern'=""
	{
	  s edatern=$ZDH(edatern,3)	
	}
	s etimern=$p(para,"!",5)
	s flag=##class(web.DHCLCNUREXCUTE).istime(etimern)
	q:(etimern'="")&&(flag=0) "时间格式不对"
	if etimern'=""
	{
		s etimern=$ZTH(etimern)
	}
	s reason=$p(para,"!",6)
	s drapprove=$p(para,"!",7)
	s adatern=$p(para,"!",8)
	s atimern=$p(para,"!",9)
	if adatern'=""
	{
	  s adatern=$ZDH(adatern,3)	
	}
	s flag=##class(web.DHCLCNUREXCUTE).istime(atimern)
	q:(atimern'="")&&(flag=0) "时间格式不对"
	if atimern'=""
	{
		s atimern=$ZTH(atimern)
	}
	s nursern=$p(para,"!",10)
	q:(nurse'="")&&('$d(^CTPCP(nurse,1))) "医护人员不正确"       
	    q:(drapprove'="")&&('$d(^CTPCP(drapprove,1))) "医护人员不正确" 
	    q:(nursern'="")&&('$d(^CTPCP(nursern,1))) "医护人员不正确"     
	    q:'$d(^PAC("LEA",reason)) "请从下拉框选择理由" 
	&sql(insert into pa_admleave( adml_parref,
	        adml_goingoutdate,adml_goingouttime,
	        adml_nurse_dr,adml_expecteddatereturn,
	        adml_expectedtimereturn,adml_reason_dr,
	        adml_doctorapprove_dr,adml_actualdatereturn,
	        adml_actualtimereturn,adml_nursereturn_dr)
	 values( :parentrowid,:godate,:gotime,:nurse,:edatern,:etimern,:reason,:drapprove,:adatern,:atimern,:nursern)
	   )      
	q SQLCODE
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
	.if rea'="" s reason=$P(^PAC("LEA",rea),"^",2)
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

ClassMethod LeaveUpdate(rowid As %String, para As %String) As %String
{
	
    n (rowid,para)
	s godate=$p(para,"!",1)
	if godate'="" 
	{
		set godate=$ZDH(godate,3)
	}
	else
	{
	}
	s gotime=$p(para,"!",2)
	s flag=##class(web.DHCLCNUREXCUTE).istime(gotime)
	q:(gotime'="")&&(flag=0) "时间格式不对"
	if gotime'="" 
	{
		s gotime=$ZTH(gotime,3)
	}
	s nurse=$p(para,"!",3)
	
	s edatern=$p(para,"!",4)
	if edatern'=""
	{
	  s edatern=$ZDH(edatern,3)	
	}
	s etimern=$p(para,"!",5)
	s flag=##class(web.DHCLCNUREXCUTE).istime(etimern)
	q:(etimern'="")&&(flag=0) "时间格式不对"
	if etimern'=""
	{
		s etimern=$ZTH(etimern)
	}
	s reason=$p(para,"!",6)
	s drapprove=$p(para,"!",7)
	s adatern=$p(para,"!",8)
	s atimern=$p(para,"!",9)
	if adatern'=""
	{
	  s adatern=$ZDH(adatern,3)	
	}
	s flag=##class(web.DHCLCNUREXCUTE).istime(atimern)
	q:(atimern'="")&&(flag=0) "时间格式不对"
	if atimern'=""
	{
		s atimern=$ZTH(atimern)
	}
	s nursern=$p(para,"!",10)
	q:(nurse'="")&&('$d(^CTPCP(nurse,1))) "医护人员不正确"       
	    q:(drapprove'="")&&('$d(^CTPCP(drapprove,1))) "医护人员不正确"  
	     q:(nursern'="")&&('$d(^CTPCP(nursern,1))) "医护人员不正确"     
	    q:'$d(^PAC("LEA",reason)) "请从下拉框选择理由"  
	&sql(update pa_admleave set adml_goingoutdate=:godate,
	       adml_goingouttime=:gotime,
	       adml_nurse_dr=:nurse,
	       adml_expecteddatereturn=:edatern,
	       adml_expectedtimereturn=:etimern,
	       adml_reason_dr=:reason,
	       adml_doctorapprove_dr=:drapprove,
	       adml_actualdatereturn=:adatern,
	       adml_actualtimereturn=:atimern,
	       adml_nursereturn_dr=:nursern
	     where adml_rowid=:rowid)
	 q SQLCODE
}

ClassMethod GetDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocExecute ]
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

ClassMethod GetDocExecute(ByRef qHandle As %Binary, name As %String, typ As %String, adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if typ="NURSE" d
 	.s ward=$P(^PAADM(adm),"^",70)
 	.s Loc=$P(^PAWARD(ward),"^",5)
 	if typ="DOCTOR" s Loc=$P(^PAADM(adm),"^",4)
    //s wloc=$P(^PAWARD(ward),"^",5) //s name="F",cttypdes="NURSE"
	s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",Loc,rw)) q:rw=""  d
	.s ctpcp=$P(^RB("RES",rw),"^",2) 
	.//s rw=0 f  s rw=$O(^CTPCP(rw)) q:rw=""  d
	.//s typdr=$P(^CTPCP(rw,1),"^",4)
	.//s typ=$P(^CT("CPT",typdr),"^",4)
	.//q:typ'=cttypdes
	.s docdes=$P(^CTPCP(ctpcp,1),"^",2)
	.q:docdes'[name
	.d outctcp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outctcp
	set Data=$lb(docdes,ctpcp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetDoc(name As %String, typ As %String, adm As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod GetDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHospitalName() As %String
{
  ///医院名称
   s rw="" f  s rw=$O(^CF("SM",rw)) q:rw=""  d
   .s HosName=$P(^CF("SM",rw),"^",5)
   q $g(HosName)
}

/// w ##class(web.DHCTHREEEX).GetMotherInfo(135)
ClassMethod GetMotherInfo(Adm As %String) As %String
{
  //病人基本信息
	n (Adm)
	&sql(select distinct(PAADM_PAPMI_DR->PAPMI_No) into :RegNo
	       from PA_Adm
	       where PAADM_RowId=:Adm)
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Bah=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Adm) //调用病案接口取病案号g
    
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
	q RegNo_"^"_PatName_"^"_Bah
}

/// w ##class(web.DHCTHREEEX).GetPatInfo("5906","2017-10-24")
ClassMethod GetPatInfo(Adm As %String, date) As %String
{
  //病人基本信息
	n (Adm,date)
	&sql(select distinct(PAADM_PAPMI_DR->PAPMI_No) into :RegNo
	       from PA_Adm
	       where PAADM_RowId=:Adm)
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Bah=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
	s IBirth=$p($g(^PAPER(papmi,"ALL")),"^",6)
	i $d(IBirth) s IBirth=$ZD(IBirth,3)
	s today=$p($g(^PAADM(Adm)),"^",6)
	s admtime=$ZT($p($g(^PAADM(Adm)),"^",7),1)
	s AdmDate=$ZD($p($g(^PAADM(Adm)),"^",6),3)
	
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(papmi,Adm) ;..CalAge(IBirth,today)
	s PatLoc=$p($g(^CTLOC($p($g(^PAADM(Adm)),"^",4))),"^",2)
	i PatLoc["-" s P4=$p(PatLoc,"-",2)
	else  d 
	.s P4=PatLoc 
	s PatHospDr=$p($g(^CTLOC($p($g(^PAADM(Adm)),"^",4))),"^",22)
	s PatHospDesc = $p($g(^CT("HOSP",PatHospDr)),"^",2)
    s roomdr=$P(^PAADM(Adm),"^",69)
    if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    e  s room=""
    if $D(^PAPER(papmi,"PAT",3)) ;s Bah=$P(^PAPER(papmi,"PAT",3),"^",4) ;病案号
    s Bah=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Adm) //调用病案接口取病案号
    s bedSub=$p($p($g(^PAADM(Adm)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(Adm)),"^",70)  
    s WardDes=""
    s:curWardId'="" WardDes=$P($G(^PAWARD(curWardId)),"^",2)
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
	s OutDate=$p($g(^PAADM(Adm)),"^",17)
	s OutTime=$p($g(^PAADM(Adm)),"^",18)
	if OutDate'="" s OutDate=$ZD(OutDate,3),OutTime=$ZT(OutTime,1)
	s ret=..GetDisDate(Adm,"出院")
	
	if ret'=""  s OutDate=$P(ret,"^",1),OutTime=$P(ret,"^",2)
	s ret=..GetDisDate(Adm,"入院")
	if ret'=""  s AdmDate=$P(ret,"^",1),admtime=$P(ret,"^",2)
	s transWardInfo=..getPatTransWard(Adm,date)
	//s PatLoc=..getPatWeekTransLOC(Adm,date)
	//s FirstDiagnose=##CLASS(EPRservice.BOScatterData).GetEPRData(Adm,"初步诊断   入院记录.诊断.诊断.初步诊断#TYPE:Segment#TID:26#TVER:0#GCODE:G0001")
    // s SecondDiagnose=##CLASS(EPRservice.BOScatterData).GetEPRData(Adm,"入院记录.诊断.诊断.确定诊断#TYPE:TextDesc#TID:26#TVER:0#ECODE:E0002")
	q "PatName|"_PatName_"^RegNo|"_RegNo_"^AdmDate|"_AdmDate_" "_admtime_"^Sex|"_Sex_"^Age|"_PatAge_"^PatLoc|"_PatLoc_"^DischgDate|"_OutDate_" "_OutTime_"^Ward|"_$P(WardDes,"-",2)_"^Room|"_room_"^BedCode|"_$G(BedCode)_"^Bah|"_$G(Bah)_"^BabyFlag|"_BabyFlag_"^MotherAdm|"_MotherAdm_"^MotherName|"_$G(MotherName)_"^MotherRegNo|"_$G(MotherRegNo)_"^BirthDate|"_$G(IBirth)_"^PatHosp|"_$G(PatHospDesc)
	///
}

/// w ##class("web.DHCTHREEEX").GetPatInfo1(550)
ClassMethod GetPatInfo1(Adm As %String) As %String
{
  //病人基本信息
	n (Adm,date)
	&sql(select distinct(PAADM_PAPMI_DR->PAPMI_No) into :RegNo
	       from PA_Adm
	       where PAADM_RowId=:Adm)
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	w papmi,!
	s PatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
    s Bah=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
	s IBirth=$p($g(^PAPER(papmi,"ALL")),"^",6)
	;s today=$p($h,",",1)
	s today=$p($g(^PAADM(Adm)),"^",6)
	s admtime=$ZT($p($g(^PAADM(Adm)),"^",7),1)
	s AdmDate=$ZD($p($g(^PAADM(Adm)),"^",6),3)
	
	s PatAge=..CalAge(IBirth,today)
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
	s OutDate=$p($g(^PAADM(Adm)),"^",17)
	s OutTime=$p($g(^PAADM(Adm)),"^",18)
	if OutDate'="" s OutDate=$ZD(OutDate,3),OutTime=$ZT(OutTime,1)
	s ret=..GetDisDate(Adm,"出院")
	
	if ret'=""  s OutDate=$P(ret,"^",1),OutTime=$P(ret,"^",2)
	s ret=..GetDisDate(Adm,"入院")
	if ret'=""  s AdmDate=$P(ret,"^",1),admtime=$P(ret,"^",2)
	//s transWardInfo=..getPatTransWard(Adm,date)
	//s FirstDiagnose=##CLASS(EPRservice.BOScatterData).GetEPRData(Adm,"初步诊断   入院记录.诊断.诊断.初步诊断#TYPE:Segment#TID:26#TVER:0#GCODE:G0001")
   // s SecondDiagnose=##CLASS(EPRservice.BOScatterData).GetEPRData(Adm,"入院记录.诊断.诊断.确定诊断#TYPE:TextDesc#TID:26#TVER:0#ECODE:E0002")
	i IBirth'="" s IBirth=$zd(IBirth,3)
	q "PatName|"_PatName_"^RegNo|"_RegNo_"^AdmDate|"_AdmDate_" "_admtime_"^Sex|"_Sex_"^Age|"_PatAge_"^PatLoc|"_$P(PatLoc,"-",2)_"^DischgDate|"_OutDate_" "_OutTime_"^Ward|"_$P(WardDes,"-",2)_"^Room|"_room_"^BedCode|"_$G(BedCode)_"^Bah|"_$G(Bah)_"^BabyFlag|"_BabyFlag_"^MotherAdm|"_MotherAdm_"^MotherName|"_$G(MotherName)_"^MotherRegNo|"_$G(MotherRegNo)_"^BirthDate|"_$G(IBirth)
	///n
}

/// w ##class(web.DHCThreeNew).getWardLoc(576)
ClassMethod getWardLoc(Adm) As %String
{
	s ward=$p(^PAADM(Adm),"^",70) 
	w ward,!
	s wardloc=$P(^PAWARD(ward),"^",5) 
	q wardloc
}

/// 获取患者一周之内转科室
/// w ##class(web.DHCTHREEEX).getPatWeekTransLOC("576","2014-11-04")
ClassMethod getPatWeekTransLOC(adm As %String, Stdate As %String)
{
	s date=$zdh(Stdate,5)
	s ret=""
	s lastWardDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.q:(startDate>(date+6))
	.q:(endDate<date)&(endDate'="")
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	.//q:lastWardDr=wardDr
	.s LocRowID=$p(^PAWARD(wardDr),"^",5)
	.s PatLocDR=^CTLOC(LocRowID,"LINK",^CTLOC(LocRowID,"LINK",0))
	.s PatLocDesc=$p(^CTLOC(PatLocDR),"^",1)
	.i ret="" s ret=$ZD(startDate,3)_PatLocDesc
	.e  s ret=ret_"->"_$ZD(startDate,3)_PatLocDesc
	.s lastWardDr=wardDr
	q ret
}

/// w ##class(web.DHCTHREEEX).getPatTransWardTest("576","2014-11-04")
ClassMethod getPatTransWardTest(adm, date) As %String
{
	s date=$zdh(date,5)
	s ret=""
	s lastWardDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.//q:((startDate<date)!(startDate>(date+6))) 
	.q:(startDate>(date+6)) //当转移开始时间在本页时间之后时退出
	.q:(endDate<date)&(endDate'="") //当转科结束时间在本页开始时间之前时退出
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	.q:lastWardDr=wardDr
	.i ret="" s ret=$p(^PAWARD(wardDr),"^",1)
	.e  d
	..i ('(startDate>(date-1))&&(startDate<(date+7))) s ret=$p(^PAWARD(wardDr),"^",1) //转科开始时间不在本周之间时，设置转科后的科室
	.s lastWardDr=wardDr
	q ret
}

/// w ##class(web.DHCTHREEEX).getPatTransWard("576","2014-11-04")
/// 邯钢用，病人转科当页显示转科前科室，转科后第二页显示转科后的科室
ClassMethod getPatTransWard(adm, date) As %String
{
	s date=$zdh(date,5)
	s ret=""
	s lastWardDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.q:(startDate>(date+6))
	.q:(endDate<date)&(endDate'="")
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	.q:lastWardDr=wardDr
	.i ret="" s ret=$p(^PAWARD(wardDr),"^",1)
	.e  s ret=$e(ret,1,3)_"->"_$e($p(^PAWARD(wardDr),"^",1),1,3)
	.s lastWardDr=wardDr
	q ret
}

Query LeaveGetinfo(parentrowid As %String) As %Query(ROWSPEC = "godate,gotime,nurse,edatern,etimern,reason,drapprove,adatern,atimern,nursern,rowid,chi,nur,rea,doc,turn")
{
}

ClassMethod GetDisDateold(Adm As %String, STyp As %String) As %String
{
	n (Adm,STyp)
	s ret=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P($g(^DHCQTRECTYP("typ",TypDr)),"^",2)
	.q:Typ'=STyp
	.s ret=ADate_"^"_ATime
	q ret
}

ClassMethod GetDisDate(Adm As %String, STyp As %String) As %String
{
	n (Adm,STyp)
	s ret=""
	s patinfo=##class(web.DHCMGNurComm).PatInfo(Adm,"")
	s ADate=$p($P(patinfo,"^",15),"@",2)
	s ATime=$p($P(patinfo,"^",16),"@",2)
	if ATime'="" s ATime=$ZT(ATime,2)
	
	s ret=ADate_"^"_ATime
	q ret
}

ClassMethod GetReasonExecute(ByRef qHandle As %Binary) As %Status
{
	//^PAC("LEA",{RFL_RowId})
	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw=0  f  s rw=$O(^PAC("LEA",rw)) q:rw=""  d
	.s reas=$P(^PAC("LEA",rw),"^",2)
	.d outreason
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outreason
	set Data=$lb(reas,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonExecute ]
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

ClassMethod SaveGridLayOut(gridpos As %String) As %String
{
 //超级用户保存默认值
 //;保存gridpos位置
 n (gridpos)
	 s Grp=$P(gridpos,"!",1)
	 s ssgrp=$P(^SSU("SSGRP",Grp),"^",1)
	 s ^DHCMZGRIDPOS("indatagrid",Grp)=$P(gridpos,"!",2)
	 if ssgrp["Demo" s ^DHCMZGRIDPOS("indatagrid")=$P(gridpos,"!",2)
	 q 0
}

ClassMethod SchGridPos(uid As %String) As %String
{
 //如果没有对应安全组的数据 取默认值
	 n (uid)
     s Grp=..GetSSGrp(uid)
	 s gridpos=$G(^DHCMZGRIDPOS("indatagrid",Grp))
	 if gridpos="" s gridpos=$G(^DHCMZGRIDPOS("indatagrid"))
	 q gridpos
}

ClassMethod GetSSGrp(UserId As %String) As %String
{
	n (UserId)
	 s SSGrpDr=$P(^SSU("SSUSR",UserId),"^",5)
     s SSGrp=$P(^SSU("SSGRP",SSGrpDr),"^",1)
     q SSGrpDr
}

Query GetReason() As %Query(ROWSPEC = "desc,id")
{
}

Query GetQtData(Adm As %String, STyp As %String) As %Query(ROWSPEC = "StDate,StTime,Typ")
{
}

ClassMethod GetQtDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQtDataExecute ]
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

ClassMethod GetQtDataExecute(ByRef qHandle As %Binary, Adm As %String, STyp As %String) As %Status
{
  //出院，手术，转科，分娩，
	Set repid=$I(^CacheTemp)
 	s ind=1
	//D ##CLASS(%ResultSet).RunQuery("web.DHCTHREEEX","GetQtData","325017","死亡")
	s OpNum=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.q:(STyp'="手术")&(Typ'=STyp)
	.q:(STyp="手术")&(Typ'="手术")&(Typ'="分娩")
	.i STyp="手术" d
	..i OpNum="" s OpNum=ADate_"!"_ATime_"!"_Typ
	..e  s OpNum=OpNum_"^"_ADate_"!"_ATime_"!"_Typ
	.q:STyp="手术"
	.d outqt
	if STyp="手术"
	{
		s startnum=1
		s maxnum=$L(OpNum,"^")
		if maxnum>2  s startnum=maxnum-1
		b 
		for i=startnum:1:maxnum
		{
			s OpInfo=$P(OpNum,"^",i)
			s ADate=$P(OpInfo,"!",1)
			s ATime=$P(OpInfo,"!",2)
			s Typ=$P(OpInfo,"!",3)
			if (ADate="")!(ATime="")!(Typ="") continue
			d outqt	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outqt
	set Data=$lb(ADate,ATime,Typ)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQtDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQtDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOutInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutInfoExecute ]
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

ClassMethod GetOutInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
 //病人外出记录
	//d ##class(%ResultSet).RunQuery("web.DHCTHREEEX","GetOutInfo","285665")
	Set repid=$I(^CacheTemp)
 	s ind=1
	k Leav
	s chl=0  f  s chl=$O(^PAADM(Adm,"LEA",chl)) q:chl=""  d
	.s tm=^PAADM(Adm,"LEA",chl)
	.s godate=$P(tm,"^",2) //
	.s gotime=$P(tm,"^",3)
	.s retdate=$P(tm,"^",9) 	//实际返回日期
	.s rettime=$P(tm,"^",10) 	//实际返回时间
	.i retdate=godate q			//如果实际返回日期与离开日期相同,则连线
	.i retdate=(godate+1),rettime<=21600 q	//如果第二天6:00前回来,则连线
	.s rea=$P(tm,"^",6) //原因
	.if rea'="" s reason=$P(^PAC("LEA",rea),"^",2)
	.e  s reason=""
	.s Leav(godate,gotime)=reason
	s godate="" f  s godate=$O(Leav(godate)) q:godate=""  d
	.s gotime=""  f  s gotime=$O(Leav(godate,gotime)) q:gotime=""  d
	..s GDate=$ZD(godate,3)
	..s GTime=$ZT(gotime,1)
	..s Reason=Leav(godate,gotime)
	..d outleave1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
outleave1
	set Data=$lb(GDate,GTime,Reason)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOutInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetServerNameSpace() As %String
{
  //&sql(select pathtoreports into :reportPath from websys.configuration)

  &sql(select layoutmanager into :reportPath from websys.configuration)
  q $G(reportPath)
}

ClassMethod GetSingleTempdata() As %String
{
  //设置物理降温，和每天只录入一条数据的项目；
	set wultemp=3
	set tempid=14  //体温
	set singldata="|12|"  //16|17|
	q wultemp_"^"_singldata_"^"_tempid
}

ClassMethod GetWHData(Adm As %String) As %String
{
  //身高，体重
	n (Adm)
	s Mradm=$P(^PAADM(Adm),"^",61)
	s Height=$P(^MR(Mradm,"PRO",1),"^",20)
	s Weight=$P(^MR(Mradm,"PRO",1),"^",27)
   q Height_"^"_Weight
}

ClassMethod InitiData() As %String
{
  //三测但初始化数据
   n
	s Width=182 	//220
	s Height=215 	//270//260
	s Fwidth=25
	s PrnLeftNum=3.5
	s PrnRightNum=3.5
	s PrnTop=25
	s PrnBottom=8
	s BottomRows=11
	s TopRows=4
	s TopDataHeight=20
	s BottomDataHeight=50.6
	s KDNum=100
	s LeftNum=25
	s TopNum=20
	q Width_"^"_Height_"^"_Fwidth_"^"_PrnLeftNum_"^"_PrnRightNum_"^"_PrnTop_"^"_PrnBottom_"^"_BottomRows_"^"_TopRows_"^"_TopDataHeight_"^"_BottomDataHeight_"^"_KDNum_"^"_LeftNum_"^"_TopNum
}

Query GetOutInfo(Adm As %String) As %Query(ROWSPEC = "OutDate,OutTime,OutReason")
{
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary) As %Status
{
   //web.DHCTHREEEX.GetTimePoint
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=1,des="02:00:00"
	d out1
 	s id=2,des="06:00:00"
	d out1
 	s id=3,des="10:00:00"
	d out1
 	s id=4,des="14:00:00"
	d out1
 	s id=5,des="18:00:00"
	d out1
	s id=6,des="22:00:00"
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

ClassMethod GetGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	s rw=0  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
	.s des=""
	.s des=$p(^SSU("SSGRP",rw),"^",1)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(des,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupExecute ]
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

ClassMethod GetGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetGroup() As %Query(ROWSPEC = "desc,rw")
{
}

/// 取批准理由
/// 2010-11-15
ClassMethod GetReason(funname As %String) As %String
{
    s rw=0  f  s rw=$O(^PAC("LEA",rw)) q:rw=""  d
	.s reas=$P(^PAC("LEA",rw),"^",2)
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(reas),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
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

/// 根据RowId取离开记录
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

// 返回0不是时间格式,返回1是

ClassMethod istime(str)
{
	s length=$l(str,":")
	if (length=3) 
	{
	s ret=1
	s p1=$p(str,":",1)
	s p2=$p(str,":",2)
	s p3=$p(str,":",3)
	s ret=..isnum(p1)
	q:ret=0 ret
	s ret=..isnum(p2)
	q:ret=0 ret
	s ret=..isnum(p3)
	q:ret=0 ret
	if (p1>24)!(p2>60)!(p3>60) s ret=0
	q ret
	}
	if (length=2)
	{
	s ret=1
	s p1=$p(str,":",1)
	s p2=$p(str,":",2)
	s ret=..isnum(p1)
	q:ret=0 ret
	s ret=..isnum(p2)
	q:ret=0 ret
	if (p1>24)!(p2>60) s ret=0
	q ret
		}
	s ret=0 
	q ret
}

// 返回1表示数字字符,

ClassMethod isnum(str)
{
	q:str="" 0
	s rs=1
	s len=$l(str)
	f i=1:1:len
	{
		q:rs=0
		i ($a($e(str,i,i))<48)!($a($e(str,i,i))>57) s rs=0
		}
	q rs
}

}
