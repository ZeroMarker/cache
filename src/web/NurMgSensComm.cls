/// Creator:
/// Desctiptions:
/// Date:2018年4月3日 15:11:51
Class web.NurMgSensComm Extends %RegisteredObject
{

/// creator: lulin
/// createDate: 2018.04.03
/// description: 获取病区参数列表
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSensComm","FindWardParamList","")
Query FindWardParamList(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardParamListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	;.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	k tmpWard
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Sort",Sort,rowid)) q:rowid=""  d
	..q:(isAll=0)&&('$d(tmpWard(rowid)))
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:((parr'="")&&(parr'=rowid))
	..s WardCode=obj.WardCode
	..s WardDesc=obj.WardDesc
	..s WardFire=obj.WardFire
	..s WardBedPR=obj.WardBedPR
	..s WardBedNum=obj.WardBedNum
	..s WardBedNum1=""
	..i $IsObject(obj.CTLocDR) d
	...s loc=obj.CTLocDR.%Id()
	...s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	...s:pacward'="" WardBedNum1=+$p($$BedNum^DHCMRIPday(+$h,"Ward",pacward),"^",1)
	..s ret="WardCode|"_WardCode_"^WardDesc|"_WardDesc_"^WardFire|"_WardFire_"^WardBedPR|"_WardBedPR_"^WardBedNum|"_WardBedNum_"^rowid|"_rowid
	..s ret=ret_"^WardBedNum1|"_WardBedNum1
	..d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardParamListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardParamListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardParamListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardParamListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin
/// createDate: 2018.04.04
/// description: 保存病区参数设置
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other:
ClassMethod SaveWardParams(parr As %String = "") As %String
{
		q:parr="" ""
		s tmp=""
		s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
		s id=$g(tmp("RowId"))
		q:id="" ""
		TS
		s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
		if '$IsObject(obj){
			Tro
			q ""
		}
		s obj.WardFire=tmp("WardFire")
		s obj.WardBedPR=tmp("WardBedPR")
		s obj.WardBedNum=tmp("WardBedNum")
		s sc=obj.%Save()
		s sc=$$$ISOK(sc)
		if $$$ISOK(sc){
			TC
		}else{
			Tro	
		}
		q sc
}

/// creator: lulin
/// createDate: 2018.04.04
/// description: 根据病区id获取病区实际床数、护士数、在编床数
/// table: 
/// input:
/// output:实际床数、在编床数、护士数
/// other:按照新版没有坐标的也取到了
ClassMethod getBedsAndNurses(parr As %String = "")
{
	s ward=$P(parr,"^",1)
	i ward="" q "0^0^0"
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	q:'$IsObject(wardobj) "0^0^0"
	s NurNum=0
	s date=+$h
	s prw="" f  s prw=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_ward,prw)) q:prw=""  d
	.s Obj=##class(DHCNMG.HR.MgPersons).%OpenId(prw)
	.q:'$IsObject(Obj)
	.q:Obj.PerTypeDR'="N"
	.q:Obj.PerCareType'="N"
	.s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Obj.PerStatus)
	.s status=""
	.i statusobj'="" s status=statusobj.SubDesc
	.;q:Obj.PerDepDate>+$h
	.q:(status'="")&&(status'="在职")
	.s NurNum=NurNum+1
	i wardobj.CTLocDR="" q "0^0^"_NurNum
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	s bednum=wardobj.WardBedNum
	s:bednum="" bednum=0
	i pacward="" q "0^"_bednum_"^"_NurNum
	s bednum=wardobj.WardBedNum
	s:bednum="" bednum=+$p($$BedNum^DHCMRIPday(+$h,"Ward",pacward),"^",1)
	s realbednum=0
	s roomid="" f  s roomid=$o(^PAWARD(0,"WardRoom",pacward,roomid)) q:roomid=""  d
	.s bedchlid="" f  s bedchlid=$o(^PAWARD(0,"WardRoom",pacward,roomid,bedchlid)) q:bedchlid=""  d
	..s pacBedObj=##class(User.PACBed).%OpenId(pacward_"||"_bedchlid)
	..q:'$IsObject(pacBedObj)
	..s:pacBedObj.BEDRcFlag="Y" realbednum=realbednum+1
	q realbednum_"^"_bednum_"^"_NurNum
}

/// creator: lulin
/// createDate: 2018.04.03
/// description: 获取实时床护比
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other:
Query FindRealBedPR(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRealBedPRExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpward=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpward)
	s wardid=$p(parr,"^"),color=$p(parr,"^",2)
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:((isAll=0)&&('$d(tmpward(rowid))))
	..q:((wardid'="")&&(wardid'=rowid))
	..q:(obj.WardDesc="")
	..s WardDesc=obj.WardDesc
	..s WardBedPR=+obj.WardBedPR
	..s num=..getBedsAndNurses(rowid) ;实际床数、在编床数、护士数
	..s BedNum=$p(num,"^",2)
	..s NurseNum=$p(num,"^",3)
	..s RealBedNum=$p(num,"^")
	..s BedPR="无效值"
	..s BedPRColor=1
	..i ((NurseNum'=0)&&(BedNum'=0)) d
	...s pr=$fn(NurseNum/BedNum,"",3)
	...s BedPRColor=2
	...s:(pr<WardBedPR) BedPRColor=3
	...s BedPR="1:"_pr
	..s RealBedPR="无效值"
	..s RealBedPRColor=1
	..i ((NurseNum'=0)&&(RealBedNum'=0)) d
	...s pr=$fn(NurseNum/RealBedNum,"",3)
	...s RealBedPRColor=2
	...s:(pr<WardBedPR) RealBedPRColor=3
	...s RealBedPR="1:"_pr
	..q:((color'="")&&(color'=RealBedPRColor)&&(color'=BedPRColor))
	..s:$l(WardBedPR,".")>1 WardBedPR="0"_WardBedPR
	..s ret="WardDesc|"_WardDesc_"^NurseNum|"_NurseNum_"^BedNum|"_BedNum_"^RealBedNum|"_RealBedNum_"^WardBedPR|"_WardBedPR
	..s ret=ret_"^BedPR|"_BedPR_"^BedPRColor|"_BedPRColor_"^RealBedPR|"_RealBedPR_"^RealBedPRColor|"_RealBedPRColor
	..d OutRealBedPR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRealBedPR
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRealBedPRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRealBedPRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRealBedPRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRealBedPRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin
/// createDate: 2018.04.04
/// description: 获取全院实时
/// table:
/// input:
/// output:
/// other:w ##class(web.NurMgSensComm).getHospitalBedPR()
ClassMethod getHospitalBedPR(role As %String = "", nurseid As %String = "") As %String
{
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s BedNum=0,NurseNum=0,RealBedNum=0
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(obj.WardDesc="")
	..q:((isAll=0)&&('$d(tmpWard(rowid))))
	..s num=..getBedsAndNurses(rowid) ;实际床数、在编床数、护士数
	..s wardbed=$p(num,"^",2)
	..s BedNum=BedNum+wardbed
	..s NurseNum=NurseNum+$p(num,"^",3)
	..s RealBedNum=RealBedNum+$p(num,"^")
	s BedPR="无效值",realBedPR="无效值",BedPRColor="1",realBedPRColor="1"
	s paramId=$O(^DHCNMG.Set.MgArgParamSetD(""))
	s paramObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(paramId)
	s hBedPR=""
	i $IsObject(paramObj) s hBedPR=paramObj.BedBR
	;在编
	i ((NurseNum'=0)&&(BedNum'=0)) d
	.s BedPR=$fn(NurseNum/BedNum,"",3)
	.s BedPRColor=2
	.s:(hBedPR>BedPR) BedPRColor=3
	;实际
	i ((NurseNum'=0)&&(RealBedNum'=0)) d
	.s realBedPR=$fn(NurseNum/RealBedNum,"",3)
	.s realBedPRColor=2
	.s:(hBedPR>realBedPR) realBedPRColor=3
	s:$l(realBedPR,".")>1&$p(realBedPR,".")="" realBedPR="0"_realBedPR
	s:$l(BedPR,".")>1&$p(BedPR,".")="" BedPR="0"_BedPR
	s:$l(hBedPR,".")>1&$p(hBedPR,".")="" hBedPR="0"_hBedPR
	s ret="NurseNum|"_NurseNum_"^BedNum|"_BedNum_"^RealBedNum|"_RealBedNum
	s ret=ret_"^hBedPR|"_hBedPR_"^BedPR|"_BedPR_"^realBedPR|"_realBedPR_"^BedPRColor|"_BedPRColor_"^realBedPRColor|"_realBedPRColor
	q ret
}

/// creator: lulin
/// createDate: 2018-04-08
/// description: 保存床护比
/// table:
/// input:
/// output:
/// other:d ##class(web.NurMgSensComm).SaveBedPR()
ClassMethod SaveBedPR() As %String
{
	TS
	s date=+$h
	s flag=1
	s hNurseNum=0,hBedNum=0,hRealBedNum=0
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardD(rowid)) q:((rowid="")||(flag=0))  d
	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:(obj.WardDesc="")
	.s WardBedPR=+obj.WardBedPR
	.s num=..getBedsAndNurses(rowid) ;实际床数、在编床数、护士数
	.s BedNum=$p(num,"^",2)
	.s NurseNum=$p(num,"^",3)
	.s RealBedNum=$p(num,"^")
	.s hNurseNum=hNurseNum+NurseNum,hBedNum=hBedNum+BedNum,hRealBedNum=hRealBedNum+RealBedNum
	.s BedPR="无效值"
	.s BedPRColor=1
	.i ((NurseNum'=0)&&(BedNum'=0)) d
	..s pr=$fn(NurseNum/BedNum,"",3)
	..s BedPRColor=2
	..s:(pr<WardBedPR) BedPRColor=3
	..s BedPR="1:"_pr
	.s RealBedPR="无效值"
	.s RealBedPRColor=1
	.i ((NurseNum'=0)&&(RealBedNum'=0)) d
	..s pr=$fn(NurseNum/RealBedNum,"",3)
	..s RealBedPRColor=2
	..s:(pr<WardBedPR) RealBedPRColor=3
	..s RealBedPR="1:"_pr
	.s:$l(WardBedPR,".")>1 WardBedPR="0"_WardBedPR
	.s PRObj=##class(DHCNMG.Sens.MgBedPR).%New()
	.s PRObj.BedPRWard=obj
	.s PRObj.BedPRDate=date
	.s PRObj.BedPRNurseNum=NurseNum
	.s PRObj.BedPRBedNum=BedNum
	.s PRObj.BedPRRealBedNum=RealBedNum
	.s PRObj.BedPRParam=WardBedPR
	.s PRObj.BedPRBedPR=BedPR
	.s PRObj.BedPRRealBedPR=RealBedPR
	.s PRObj.BedPRColor=BedPRColor
	.s PRObj.BedPRRealColor=RealBedPRColor
	.s sc=PRObj.%Save()
	.s:$$$ISERR(sc) flag=0
	i flag=1 {
		s hBedPR=0
		s id=$o(^DHCNMG.Set.MgSysParamI("Code"," HOSPITYBEDPR",""))
		s subid=""
		s:id'="" subid=$o(^DHCNMG.Set.MgSysParamSubI("Code"," BEDPR",id,""))
		s obj1=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id_"||"_subid)
		s:$IsObject(obj1) hBedPR=+obj1.SubValue
		s hPR="无效值",hColor=1
		i ((hNurseNum'=0)&&(hBedNum'=0)) d
		.s hPR=$fn(hNurseNum/hBedNum,"",3)
		.s hColor=2
		.s:(hPR<hBedPR) hColor=3
		.s hPR="1:"_hPR
		s hRealPR="无效值",hRealColor=1
		i ((hNurseNum'=0)&&(hRealBedNum'=0)) d
		.s hRealPR=$fn(hNurseNum/hRealBedNum,"",3)
		.s hRealColor=2
		.s:(hRealPR<hBedPR) hRealColor=3
		.s hRealPR="1:"_hRealPR
		s:$l(hBedPR,".")>1 hBedPR="0"_hBedPR
		s PRObj=##class(DHCNMG.Sens.MgBedPR).%New()
		s PRObj.BedPRDate=date
		s PRObj.BedPRNurseNum=hNurseNum
		s PRObj.BedPRBedNum=hBedNum
		s PRObj.BedPRRealBedNum=hRealBedNum
		s PRObj.BedPRParam=hBedPR
		s PRObj.BedPRBedPR=hPR
		s PRObj.BedPRRealBedPR=hRealPR
		s PRObj.BedPRColor=hColor
		s PRObj.BedPRRealColor=hRealColor
		s sc=PRObj.%Save()
		i $$$ISOK(sc) {
			TC
		}else{
			Tro		
		}
	}else{
		Tro	
	}
	q ""
}

/// creator: lulin
/// createDate: 2018-04-08
/// description: 获取历史床护比
/// table: DHCNMG.Sens.MgBedPR
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSensComm","FindPastBedPR","")
Query FindPastBedPR(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPastBedPRExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s wardid=$p(parr,"^"),color=$p(parr,"^",2),stdate=$p(parr,"^",3),enddate=$p(parr,"^",4)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmpward=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpward)
	s isHospital=0
	s:wardid<0 isHospital=1
	s date="" f  s date=$o(^DHCNMG.Sens.MgBedPRI("date",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))||((enddate'="")&&(date>enddate))
	.s ward="" f  s ward=$o(^DHCNMG.Sens.MgBedPRI("date",date,ward)) q:ward=""  d
	..s isExist=0
	..i isHospital=0 d
	...i ward<0 s isExist=1
	...i (wardid'="")&&(wardid'=ward) s isExist=1
	...i (isAll=0)&&('$d(tmpward(ward))) s isExist=1
	..e  d
	...i ward>0 s isExist=1
	..q:isExist=1
	..s rowid="" f  s rowid=$o(^DHCNMG.Sens.MgBedPRI("date",date,ward,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.Sens.MgBedPR).%OpenId(rowid)
	...q:'$IsObject(obj)
	...q:((color'="")&&(color'=obj.BedPRColor)&&(color'=obj.BedPRRealColor))
	...s WardDesc=""
	...s:$IsObject(obj.BedPRWard) WardDesc=obj.BedPRWard.WardDesc
	...q:(('+wardid<0)&&(WardDesc=""))
	...s NurseNum=obj.BedPRNurseNum
	...s BedNum=obj.BedPRBedNum
	...s WardBedPR=obj.BedPRParam
	...s RealBedNum=obj.BedPRRealBedNum
	...s BedPR=obj.BedPRBedPR
	...s RealBedPR=obj.BedPRRealBedPR
	...s BedPRColor=obj.BedPRColor
	...s RealBedPRColor=obj.BedPRRealColor
	...s outDate=##class(web.NurMgHISComm).DateLogicalToHtml(date)
	...s ret="Date|"_outDate_"^WardDesc|"_WardDesc_"^NurseNum|"_NurseNum_"^BedNum|"_BedNum_"^WardBedPR|"_WardBedPR
	...s ret=ret_"^RealBedNum|"_RealBedNum_"^BedPR|"_BedPR_"^RealBedPR|"_RealBedPR_"^BedPRColor|"_BedPRColor_"^RealBedPRColor|"_RealBedPRColor
	...d OutPastBedPR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPastBedPR
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPastBedPRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPastBedPRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPastBedPRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPastBedPRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin
/// createDate: 2018-04-09
/// description: 获取实时护患比
/// table: 
/// input:
/// output:
/// other:
Query FindRealNursePR(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRealNursePRExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=$p(parr,"^")
	s date=+$h
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..q:((wardid'="")&&(wardid'=rowid))
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(wardobj)
	..q:wardobj.WardDesc=""
	..s NurNum=0
	..s argsubid="" f  s argsubid=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",rowid,date,argsubid)) q:argsubid=""  d
	...s argsubobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argsubid)
	...q:'$IsObject(argsubobj)
	...q:argsubobj.ArgHolidayTime'=""
	...q:'$IsObject(argsubobj.ArgPerDR)
	...s per=argsubobj.ArgPerDR
	...q:per.PerTypeDR'="N"
	...q:per.PerCareType'="N"
	...s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(per.PerStatus)
	...s status=""
	...i statusobj'="" s status=statusobj.SubDesc
	...q:(status'="")&&(status'="在职")
	...s NurNum=NurNum+1
	..s PatNum=0
	..i $IsObject(wardobj.CTLocDR) d
	...s loc=wardobj.CTLocDR.%Id()
	...s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	...i pacward'="" d
	....s room="" f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.....q:room=0 ;去除等候区病人
	.....s adm="" f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d
	......s PatNum=PatNum+1
	..s WardDesc=wardobj.WardDesc
	..s NurPR="无效值"
	..s:((NurNum'=0)&&(PatNum'=0)) NurPR="1:"_$fn(PatNum/NurNum,"",3)
	..s ret="WardDesc|"_WardDesc_"^NurNum|"_NurNum_"^PatNum|"_PatNum_"^NurPR|"_NurPR
	..d OutRealBedPR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRealBedPR
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRealNursePRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRealNursePRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRealNursePRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRealNursePRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin
/// createDate: 2018-04-09
/// description: 获取全院实时护患比
/// table: 
/// input:
/// output:
/// other:
ClassMethod getHospitalNurPR() As %String
{
	s NurNum=0,PatNum=0
	s date=+$h
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(wardobj)
	..q:wardobj.WardDesc=""
	..s argsubid="" f  s argsubid=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",rowid,date,argsubid)) q:argsubid=""  d
	...s argsubobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argsubid)
	...q:'$IsObject(argsubobj)
	...q:argsubobj.ArgHolidayTime'=""
	...q:'$IsObject(argsubobj.ArgPerDR)
	...s per=argsubobj.ArgPerDR
	...q:per.PerTypeDR'="N"
	...q:per.PerCareType'="N"
	...s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(per.PerStatus)
	...s status=""
	...i statusobj'="" s status=statusobj.SubDesc
	...q:(status'="")&&(status'="在职")
	...s NurNum=NurNum+1
	..i $IsObject(wardobj.CTLocDR) d
	...s loc=wardobj.CTLocDR.%Id()
	...s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	...i pacward'="" d
	....s room="" f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.....q:room=0 ;去除等候区病人
	.....s adm="" f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d
	......s PatNum=PatNum+1
	s NurPR="无效值"
	s:((NurNum'=0)&&(PatNum'=0)) NurPR="1:"_$fn(PatNum/NurNum,"",3)
	s ret=NurNum_"^"_PatNum_"^"_NurPR
	q ret
}

/// creator: lulin
/// createDate: 2018-04-09
/// description: 保存护患比
/// table: 
/// input:
/// output:
/// other:w ##class(web.NurMgSensComm).saveNurPR()
ClassMethod saveNurPR() As %String
{
	s date=+$h-2
	s hNurNum=0,hPatNum=0,flag=1
	s paramObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s:$IsObject(paramObj) stTime=paramObj.NightEndTime1,endTime=paramObj.NightStTime1
	s:stTime="" stTime=28800
	s:endTime="" endTime=64800
	s tmpPatData=""
	d ..getPatInfo(date,.tmpPatData, stTime, endTime)
	Ts
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardD(rowid)) q:((rowid="")||(flag=0))  d
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	.q:'$IsObject(wardobj)
	.q:wardobj.WardDesc=""
	.s dayCount=0,nightCount=0
	.s time=..GetWorkCount(date,rowid,stTime,endTime)
	.s dayCount=$fn(($P(time,"^",1)/8),"",8)  ;工作小时数/8算人数
	.s nightCount=$fn(($P(time,"^",2)/8),"",8) ;工作小时数/8
	.q:'$IsObject(wardobj.CTLocDR)
	.s loc=wardobj.CTLocDR.%Id()
	.s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	.q:pacward=""
	.s PatNum=$g(tmpPatData(pacward,"D"))
	.s PatNumN=$g(tmpPatData(pacward,"N"))
	.s NurPR="无效值",NurPRN="无效值"
	.s:((dayCount>0)&&(PatNum>0)) NurPR="1:"_$fn(PatNum/dayCount,"",2)
	.s:((nightCount>0)&&(PatNumN>0)) NurPRN="1:"_$fn(PatNumN/nightCount,"",2)
	.s obj=##class(DHCNMG.Sens.MgNurPR).%New()
	.s obj.NurPRWard=wardobj
	.s obj.NurPRDate=date
	.s obj.NurPRNurNum=dayCount
	.s obj.NurPRNurNumN=nightCount
	.s obj.NurPRPatNum=PatNum
	.s obj.NurPRPatNumN=PatNumN
	.s obj.NurPRNurPR=NurPR
	.s obj.NurPRNurPRN=NurPRN
	.s sc=obj.%Save()
	.s:$$$ISERR(sc) flag=0
	i flag=1 {
		TC
	}else{
		Tro
	}
	q 0
}

/// creator: lulin
/// createDate: 2018-04-08
/// description: 获取历史床护比
/// table: DHCNMG.Sens.MgBedPR
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSensComm","FindPastNurPR","")
Query FindPastNurPR(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPastNurPRExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s wardid=$p(parr,"^"),stdate=$p(parr,"^",2),enddate=$p(parr,"^",3)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmp=""
	s tmpward=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpward)
	s loginHospital=##class(web.NurMgSetComm).loginHospitalId(nurseid)
	s isHospital=0
	s:wardid<0 isHospital=1
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s ward="" f  s ward=$O(^DHCNMG.DB.MgWardI("Sort",Sort,ward)) q:ward=""  d
	..q:($g(wardid)>0)&&(wardid'=ward)
	..s isExist=0
	..i isHospital'=1 d
	...i (wardid'="")&&(wardid'=ward) s isExist=1
	...i (isAll=0)&&('$d(tmpward(ward))) s isExist=1
	..q:isExist=1
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	..q:'$IsObject(wardObj)
	..s date="" f  s date=$o(^DHCNMG.Sens.MgNurPRI("dateward",date)) q:date=""  d
	...q:((stdate'="")&&(date<stdate))||((enddate'="")&&(date>enddate))
	...s NurNum=""
	...s rowid=$o(^DHCNMG.Sens.MgNurPRI("dateward",date,ward,""))
	...s obj=##class(DHCNMG.Sens.MgNurPR).%OpenId(rowid)
	...s NurNum="",PatNum="",NurPR="",NurNumN="",PatNumN="",NurPRN=""
	...i $IsObject(obj) d
	....s NurNum=obj.NurPRNurNum
	....s PatNum=obj.NurPRPatNum
	....s NurPR=obj.NurPRNurPR
	....s NurNumN=obj.NurPRNurNumN
	....s PatNumN=obj.NurPRPatNumN
	....s NurPRN=obj.NurPRNurPRN
	...s outDate=##class(web.NurMgHISComm).DateLogicalToHtml(date)
	...s WardDesc=wardObj.WardDesc
	...i wardid'=-1 d
	....s ret="Date|"_outDate_"^WardDesc|"_WardDesc_"^NurNum|"_$fn(NurNum,"",2)_"^PatNum|"_PatNum_"^NurPR|"_NurPR
	....s ret=ret_"^NurNumN|"_$fn(NurNumN,"",2)_"^PatNumN|"_PatNumN_"^NurPRN|"_NurPRN
	....d OutPastBedPR
	...e  d
	....s tmp(date,"NurNum")=+$g(tmp(date,"NurNum"))+NurNum
	....s tmp(date,"PatNum")=+$g(tmp(date,"PatNum"))+PatNum
	....s tmp(date,"NurNumN")=+$g(tmp(date,"NurNumN"))+NurNumN
	....s tmp(date,"PatNumN")=+$g(tmp(date,"PatNumN"))+PatNumN
	i wardid=-1 d
	.s ret=""
	.s date="" f  s date=$O(tmp(date)) q:date=""  d
	..s outDate=##class(web.NurMgHISComm).DateLogicalToHtml(date)
	..s NurNum=$g(tmp(date,"NurNum"))
	..s:(NurNum'="")&&($P(NurNum,".")="") NurNum="0"_NurNum
	..s PatNum=$g(tmp(date,"PatNum"))
	..s:(PatNum'="")&&($P(PatNum,".")="") PatNum="0"_PatNum
	..s NurNumN=$g(tmp(date,"NurNumN"))
	..s:(NurNumN'="")&&($P(NurNumN,".")="") NurNumN="0"_NurNumN
	..s PatNumN=$g(tmp(date,"PatNumN"))
	..s:(PatNumN'="")&&($P(PatNumN,".")="") PatNumN="0"_PatNumN
	..s NurPR="无效值"
	..s:(+NurNum'=0)&&(+PatNum'=0) NurPR="1:"_$fn(PatNum/NurNum,"",1)
	..s:$P(NurPR,".")="" NurPR="0"_NurPR
	..s NurPRN="无效值"
	..s:(+NurNumN'=0)&&(+PatNumN'=0) NurPRN="1:"_$fn(PatNumN/NurNumN,"",1)
	..s:$P(NurPRN,".")="" NurPRN="0"_NurPRN
	..s ret="Date|"_outDate_"^NurNum|"_$fn(NurNum,"",2)_"^PatNum|"_PatNum_"^NurPR|"_NurPR
	..s ret=ret_"^NurNumN|"_$fn(NurNumN,"",2)_"^PatNumN|"_PatNumN_"^NurPRN|"_NurPRN
	..d OutPastBedPR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPastBedPR
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPastNurPRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPastNurPRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPastNurPRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPastNurPRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-08-16
/// Decription：根据病区获取病区的患者总数，以及入院、出院 病危 病重 一级 手术 跌倒 压疮 气道？
/// 
ClassMethod GetWardPatient() As %String
{
	w "["
	s num=0
	s WardSpell="" f  s WardSpell=$o(^DHCNMG.DB.MgWardI("Spell",WardSpell)) q:WardSpell=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Spell",WardSpell,RowID)) q:RowID=""  d
	..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..q:'$IsObject(WardObj.CTLocDR)
	..s CtLocId=WardObj.CTLocDR.%Id()
	..q:CtLocId=""
	..s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	..q:wardID=""
	..s num=num+1
	..s inHospitalPatNum=0 //在院人数
	..s sick=0,ill=0 //病重 病危
	..s firstCare=0,secondCare=0,sepcial=0 //一级 二级 特级护理
	..s bedNum=0 //床位数
	..s bedNum=..GetWardBedsNum(wardID)
	..s surgery=0 //手术
	..s surgery=##class(web.NurArgWorkLoadComm).GetOprationsCounts($zd(+$h,3),$zd(+$h,3),RowID)
	..s advTypeNum=0,fallNum=0,pressNum=0
	..s advTypeNum=..GetAdvTypeNum(CtLocId,$zd(+$h,3))
	..s airWayNum=0
	..;s airWayNum=..GetAriWayNum(CtLocId,$zd(+$H,3)) //获取人工气道数目
	..s fallNum=$p(advTypeNum,"^",1) //获得跌倒人数
	..s pressNum=$p(advTypeNum,"^",2) // 获得压疮人数
	..s InHosNum=0 //新入院
	..s OutHosNum=0 //出院人数
	..s OutHosRw="" f  s OutHosRw=$o(^PAADMi("DischDate",+$h,OutHosRw)) q:OutHosRw=""  d
	...s OutAdmType=$p($g(^PAADM(OutHosRw)),"^",2) //就诊类型
	...q:OutAdmType'="I"
	...s OutVisit=$p($g(^PAADM(OutHosRw)),"^",20) //获取在院状态
	...q:OutVisit'="D"
	...s currentWardID=$p($g(^PAADM(OutHosRw)),"^",70) //获取当前所在病区
	...q:currentWardID=""
	...q:((currentWardID'="")&&(currentWardID'=wardID))
	...s OutHosNum=OutHosNum+1
	..s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	...s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    ....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    ....q:padmType'="I"
    ....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    ....q:patVisit'="A" //过滤掉不是在院状态的记录
    ....s IllState=##class(Nur.CommonInterface.Patient).getIllState(episodeID) //获取病人病情
    ....i IllState="病重" s sick=sick+1
    ....i IllState="病危" s ill=ill+1
    ....s inHospitalPatNum=inHospitalPatNum+1
    ....s PatAdmDate=$p($g(^PAADM(episodeID)),"^",6)
    ....i ((PatAdmDate'="")&&(PatAdmDate=+$h)) s InHosNum=InHosNum+1
    ....s flag=##class(web.NurMgHISComm).getPatCareLevel(episodeID,+$H)
    ....i flag["一级" s firstCare=firstCare+1
    ....e  i flag["二级" s secondCare=secondCare+1
    ....e  i flag["特级" s sepcial=sepcial+1
    ....s airflag=..IsHasAirOrder(episodeID)
    ....i airflag=1 s airWayNum=airWayNum+1
    ..s waitNum=..GetWardWaitNum(wardID) //获取等待区的人数
    ..s inHospitalPatNum=inHospitalPatNum+waitNum
	..i num=1 w "{""WardID"":"""_RowID_""",""WardDesc"":"""_WardObj.WardDesc_""",""BedNum"":"""_bedNum_""",""InPatNum"":"""_inHospitalPatNum_""",""PatSick"":"""_sick_""",""PatIll"":"""_ill_""",""FirstCare"":"""_firstCare_""",""SecondCare"":"""_secondCare_""",""SepcialCare"":"""_sepcial_""",""PatSurgery"":"""_surgery_""",""PatFall"":"""_fallNum_""",""PatPress"":"""_pressNum_""",""InHosNum"":"""_InHosNum_""",""OutHosNum"":"""_OutHosNum_""",""AirWayNum"":"""_airWayNum_"""}"
	..e  w ",{""WardID"":"""_RowID_""",""WardDesc"":"""_WardObj.WardDesc_""",""BedNum"":"""_bedNum_""",""InPatNum"":"""_inHospitalPatNum_""",""PatSick"":"""_sick_""",""PatIll"":"""_ill_""",""FirstCare"":"""_firstCare_""",""SecondCare"":"""_secondCare_""",""SepcialCare"":"""_sepcial_""",""PatSurgery"":"""_surgery_""",""PatFall"":"""_fallNum_""",""PatPress"":"""_pressNum_""",""InHosNum"":"""_InHosNum_""",""OutHosNum"":"""_OutHosNum_""",""AirWayNum"":"""_airWayNum_"""}"
	w "]"
	q ""
}

ClassMethod GetWardPatients(role As %String = "", nurseid As %String = "") As %String
{
	s ^TMP("GetWardPatients")=role_"%"_nurseid
	w "[{""Children"":["
	s n=0
	s PatSum=0,BedSum=0,InHosSum=0,OutHosSum=0,SickSum=0,IllSum=0 //病人总数 入院总数 出院总数 病重总数 病危总数
	s ICUPatSum=0,ICUInHosSum=0,ICUOutHosSum=0,ICUSickSum=0,ICUIllSum=0 //ICU病人数 ICU新入院 ICU出院 ICU病重 ICU病危
	s FirstSum=0,SecondSum=0,SepcialSum=0 //一级护理总数 二级护理总数 特级护理总数
	s ICUFirseSum=0,ICUSecondSum=0,ICUSpecialSum=0 //ICU一级护理 ICU二级护理 ICU特级护理
	s SurgerySum=0,FallSum=0,PressSum=0 //手术总数 跌倒总数 压疮总数
	s ICUSurgery=0,ICUFall=0,ICUPress=0 //ICU手术 ICU跌倒 ICU压疮
	s AirWaySum=0,ICUAirWay=0 //气道总数 ICU气道数
	;s WardSpell="" f  s WardSpell=$o(^DHCNMG.DB.MgWardI("Spell",WardSpell)) q:WardSpell=""  d
	;.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Spell",WardSpell,RowID)) q:RowID=""  d
	k tmpWard
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..q:(isAll=0)&&('$d(tmpWard(RowID)))
	..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..q:'$IsObject(WardObj.CTLocDR)
	..q:(WardObj.WardStDate'="")&&(WardObj.WardStDate>+$H)
	..q:(WardObj.WardEndDate'="")&&(WardObj.WardEndDate<+$H)
	..s CtLocId=WardObj.CTLocDR.%Id()
	..q:CtLocId=""
	..s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	..q:wardID=""
	..s n=n+1
	..s inHospitalPatNum=0 //在院人数
	..s sick=0,ill=0 //病重 病危
	..s firstCare=0,secondCare=0,sepcial=0 //一级 二级 特级护理
	..s num=..getBedsAndNurses(RowID) ;实际床数、在编床数、护士数
	..s NurseNum=$p(num,"^",3)
	..s bedNum=$p(num,"^",2) //床位数
	..;s bedNum=..GetWardBedsNum(wardID)
	..s surgery=0 //手术
	..s surgery=##class(web.NurArgWorkLoadComm).GetOprationsCounts($zd(+$h,3),$zd(+$h,3),RowID)
	..s SurgerySum=SurgerySum+surgery
	..s advTypeNum=0,fallNum=0,pressNum=0
	..s advTypeNum=..GetAdvTypeNum(CtLocId,$zd(+$h,3))
	..s airWayNum=0
	..;s airWayNum=..GetAriWayNum(CtLocId,$zd(+$H,3)) //获取人工气道数目
	..s fallNum=$p(advTypeNum,"^",1) //获得跌倒人数
	..s pressNum=$p(advTypeNum,"^",2) // 获得压疮人数
	..s InHosNum=0 //新入院
	..s OutHosNum=0 //出院人数
	..s OutHosRw="" f  s OutHosRw=$o(^PAADMi("DischDate",+$h,OutHosRw)) q:OutHosRw=""  d
	...s OutAdmType=$p($g(^PAADM(OutHosRw)),"^",2) //就诊类型
	...q:OutAdmType'="I"
	...s OutVisit=$p($g(^PAADM(OutHosRw)),"^",20) //获取在院状态
	...q:OutVisit'="D"
	...s currentWardID=$p($g(^PAADM(OutHosRw)),"^",70) //获取当前所在病区
	...q:currentWardID=""
	...q:((currentWardID'="")&&(currentWardID'=wardID))
	...s OutHosNum=OutHosNum+1
	...s OutHosSum=OutHosSum+1
	..s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	...s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    ....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    ....q:padmType'="I"
    ....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    ....q:patVisit'="A" //过滤掉不是在院状态的记录
    ....;s IllState=##class(Nur.CommonInterface.Patient).getIllState(episodeID) //获取病人病情
    ....;i IllState="病重" d
    .....;s sick=sick+1
    .....;s SickSum=SickSum+1 //病重总数
    ....;i IllState="病危" d
    .....;s ill=ill+1
    .....;s IllSum=IllSum+1 //病危总数
    ....s sickflag=##class(web.DHCSETIMAGE).IfOrddailyExist(episodeID,"WFY000811")
	....i sickflag="1" s sick=sick+1,SickSum=SickSum+1 //病重
	....s sickflag=##class(web.DHCSETIMAGE).IfOrddailyExist(episodeID,"WFY000810")
	....i sickflag="1" s ill=ill+1,IllSum=IllSum+1 //病危
    ....s inHospitalPatNum=inHospitalPatNum+1
    ....s PatAdmDate=$p($g(^PAADM(episodeID)),"^",6)
    ....i ((PatAdmDate'="")&&(PatAdmDate=+$h)) d
    .....s InHosNum=InHosNum+1
    .....s InHosSum=InHosSum+1
    ....s flag=##class(web.NurMgHISComm).getPatCareLevel(episodeID,+$H)
    ....i flag["一级" d
    .....s firstCare=firstCare+1
    .....s FirstSum=FirstSum+1
    ....e  i flag["二级" d
    .....s secondCare=secondCare+1
    .....s SecondSum=SecondSum+1
    ....e  i flag["特级" d
    .....s sepcial=sepcial+1
    .....s SepcialSum=SepcialSum+1
    ....s airflag=..IsHasAirOrder(episodeID)
    ....i airflag=1 d
    .....s airWayNum=airWayNum+1
    .....s AirWaySum=AirWaySum+1
    ..s waitNum=..GetWardWaitNum(wardID) //获取等待区的人数
    ..s inHospitalPatNum=inHospitalPatNum+waitNum
    ..s PatSum=PatSum+inHospitalPatNum //患者总数
    ..s BedSum=BedSum+bedNum
    ..i WardObj.WardShort'="" s WardDesc=WardObj.WardShort
    ..e  s WardDesc=WardObj.WardDesc
	..i n=1 w "{""WardID"":"""_RowID_""",""WardDesc"":"""_WardDesc_""",""BedNum"":"""_bedNum_""",""NurseNum"":"""_NurseNum_""",""InPatNum"":"""_bedNum_"/"_inHospitalPatNum_""",""PatSick"":"""_sick_""",""PatIll"":"""_ill_""",""FirstCare"":"""_firstCare_""",""SecondCare"":"""_secondCare_""",""SepcialCare"":"""_sepcial_""",""PatSurgery"":"""_surgery_""",""PatFall"":"""_fallNum_""",""PatPress"":"""_pressNum_""",""InHosNum"":"""_InHosNum_""",""OutHosNum"":"""_OutHosNum_""",""AirWayNum"":"""_airWayNum_"""}"
	..e  w ",{""WardID"":"""_RowID_""",""WardDesc"":"""_WardDesc_""",""BedNum"":"""_bedNum_""",""NurseNum"":"""_NurseNum_""",""InPatNum"":"""_bedNum_"/"_inHospitalPatNum_""",""PatSick"":"""_sick_""",""PatIll"":"""_ill_""",""FirstCare"":"""_firstCare_""",""SecondCare"":"""_secondCare_""",""SepcialCare"":"""_sepcial_""",""PatSurgery"":"""_surgery_""",""PatFall"":"""_fallNum_""",""PatPress"":"""_pressNum_""",""InHosNum"":"""_InHosNum_""",""OutHosNum"":"""_OutHosNum_""",""AirWayNum"":"""_airWayNum_"""}"
	w "],"
	w """PatSum"":"""_BedSum_"/"_PatSum_""",""InHosSum"":"""_InHosSum_""",""OutHosSum"":"""_OutHosSum_""",""SickSum"":"""_SickSum
	_""",""IllSum"":"""_IllSum_""",""FirstSum"":"""_FirstSum_""",""SecondSum"":"""_SecondSum_""",""SepcialSum"":"""_SepcialSum
	_""",""SurgerySum"":"""_SurgerySum_""",""FallSum"":"""_FallSum_""",""PressSum"":"""_PressSum_""",""AirWaySum"":"""_AirWaySum_"""}"
	w "]"
	q ""
}

ClassMethod IsHasAirOrder(episodeID As %String) As %String
{
	q:episodeID="" 0
	s status=0
	s OEOrd="" f  s OEOrd=$o(^OEORD(0,"Adm",episodeID,OEOrd)) q:OEOrd=""  d
	.s OEOrdSub="" f  s OEOrdSub=$o(^OEORDi(0,"StDt",+$h,OEOrd,OEOrdSub)) q:OEOrdSub=""  d
	..s orderStatus=$p(^OEORD(OEOrd,"I",OEOrdSub,1),"^",13)
	..q:"V^E"'[orderStatus
	..s ItmMast=$p(^OEORD(OEOrd,"I",OEOrdSub,1),"^",2) //获取医嘱项
	..s flag=..IsItmMastFlag(ItmMast)
	..i flag=1 s status=1
	q status
}

ClassMethod IsItmMastFlag(itmMast As %String) As %String
{
	s flag=0
	s str="14975||1^7524||1^7525||1"
	s len=$l(str,"^")
	f i=1:1:len
	{
		s itm=$p(str,"^",i)
		i itm="" continue
		i itm=itmMast s flag=1
	}
	q flag
}

/// 
/// 
/// 获取病区床位数量
ClassMethod GetWardBedsNum(wardID As %String) As %String
{
	q:wardID="" 0
	s num=0
	s rowID=0 f  s rowID=$o(^PAWARD(wardID,"BED",rowID)) q:rowID=""  d
	.s num=num+1
	q num
}

/// 
/// 获取人工气道的医嘱数量
ClassMethod GetAriWayNum(ward As %String, date As %String) As %String
{
	q:((ward="")||(date="")) 0
	s date=$zdh(date,3)
	s num=0
	
	;s OEOrdID="" f  s OEOrdID=$o(^OEORDi(0,"StDt",date,OEOrdID)) q:OEOrdID=""  d
	;.s OEOrdRowID="" f  s OEOrdRowID=$o(^OEORDi(0,"StDt",date,OEOrdID,OEOrdRowID)) q:OEOrdRowID=""  d
	;..s OrderStatus=$p(^OEORD(OEOrdID,"I",OEOrdRowID,1),"^",13)
	q num
}

/// Creator:gzj
/// Date：2018.08.17
/// Description:获取不良事件的类型数量
ClassMethod GetAdvTypeNum(ward As %String, date As %String) As %String
{
	q:((ward="")||(date="")) 0
	s date=$zdh(date,3)
	s num=0
	s fallNum=0,pressNum=0 //高危跌倒 高危压疮人数
	s RowID="" f  s RowID=$o(^DHCADVMASTER(0,"OccDate",date,RowID)) q:RowID=""  d
	.s RepRecord=$p(^DHCADVMASTER(RowID),"^",1)
	.s typeCode=$p(^DHCADVMASTER(RowID),"^",8) //上报类型
	.s RepLoc=$p(^DHCADVMASTER(RowID),"^",7) //上报科室
	.s EpisodeID=$p(^DHCADVMASTER(RowID),"^",16) //患者就诊号
	.s BradenSca=$p(^DHCADVMASTER(RowID),"^",32) //Braden评分得分
	.s RepStatus=$p(^DHCADVMASTER(RowID),"^",31) //报告状态
	.q:((ward'="")&&(RepLoc'=ward))
	.i typeCode="NurEventType-93968" d
	..i EpisodeID'="" d
	...s MorseScore=##class(Nur.DHCMoudDataSub).getMorseValue(EpisodeID,$zd(date,3),ward)
	...i ((MorseScore'="")&&(MorseScore>=45)) s fallNum=fallNum+1
	.i typeCode="advNurUlcerNew" d
	..i ((BradenSca'="")&&(RepStatus="提交")) s pressNum=pressNum+1
	q fallNum_"^"_pressNum
}

/// Creator:gzj
/// Date:2018.08.16
/// Description:获取等候区的病人数目
ClassMethod GetWardWaitNum(ward As %String) As %String
{
	q:ward="" 0
	s num=0
	s sub=0 f  s sub=$o(^PAWARDA(ward,"WADM",sub)) q:sub=""  d
	.s num=num+1
	q num
}

/// Creator:gzj
/// Date:2018.08.17
/// Description:获取排班病区数据
ClassMethod GetShcduleWardData() As %String
{
	w "["
	s n=0
	s NurseSum=0,PatSum=0,DayWorkSum=0,LunchWorkSum=0,NightWorkSum=0 //护士总数 患者总数 白班总数 晚班总数 夜班总数 
	s MarryLeaveSum=0,SickLeaveSum=0,AnnualLeaveSum=0 //婚假总数 病假总数 年假总数
	s FamilyLeaveSum=0,MaternitySum=0 //探亲假总数 产假总数
	s Spell="" f  s Spell=$o(^DHCNMG.DB.MgWardI("Spell",Spell)) q:Spell=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgWardI("Spell",Spell,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..s WardDesc=obj.WardDesc
	..s n=n+1
	..s NurseNum=0 //护士人数
	..s inHospitalPatNum=0 //在院患者人数
	..s Rw="" f  s Rw=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_RowID,Rw)) q:Rw=""  d
	...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(Rw)
	...q:PerObj.PerTypeDR'="N"
	...s NurseNum=NurseNum+1
	..i $IsObject(obj.CTLocDR) d
	...s CtLocId=obj.CTLocDR.%Id()
	...q:CtLocId=""
	...s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	...q:wardID=""
	...s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	....s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    .....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    .....q:padmType'="I"
    .....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    .....q:patVisit'="A" //过滤掉不是在院状态的记录
    .....s inHospitalPatNum=inHospitalPatNum+1
    ...s waitNum=..GetWardWaitNum(wardID) //获取等待区的人数
    ...s inHospitalPatNum=inHospitalPatNum+waitNum
	..s DayWorkNum=0,LunchWorkNum=0,NightWorkNum=0 //白班 夜班数
	..s MarryLeaveNum=0,SickLeave=0,AnnualLeaveNum=0 //婚假 病假 年假
	..s FamilyLeaveNum=0,MaternityNum=0 //探亲 产假
	..s ArgRowID="" f  s ArgRowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",+$H,ArgRowID)) q:ArgRowID=""  d
	...s ArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(ArgRowID)
	...q:'$IsObject(ArgObj)
	...q:ArgObj.ArrangeDR.ArgStatus'="R"
	...s ArgPost=ArgObj.ArgPostDR.PostDesc
	...i ArgPost["A" s DayWorkNum=DayWorkNum+1
	...i ArgPost["P" s LunchWorkNum=LunchWorkNum+1
	...i ArgPost["N" s NightWorkNum=NightWorkNum+1
	...i ArgPost["婚假" s MarryLeaveNum=MarryLeaveNum+1
	...i ArgPost["病假" s SickLeave=SickLeave+1
	...i ArgPost["年" s AnnualLeaveNum=AnnualLeaveNum+1
	...i ArgPost["探" s FamilyLeaveNum=FamilyLeaveNum+1
	...i ArgPost["产" s MaternityNum=MaternityNum+1
	..i n=1 w "{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_""",""NurseNum"":"""_NurseNum_""",""PatNum"":"""_inHospitalPatNum_""",""DayWorkNum"":"""_DayWorkNum_""",""LunchWorkNum"":"""_LunchWorkNum_""",""NightWorkNum"":"""_NightWorkNum_""",""MarryLeaveNum"":"""_MarryLeaveNum_""",""MaternityNum"":"""_MaternityNum_""",""SickLeave"":"""_SickLeave_""",""AnnualLeaveNum"":"""_AnnualLeaveNum_""",""FamilyLeaveNum"":"""_FamilyLeaveNum_"""}"
	..e  w ",{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_""",""NurseNum"":"""_NurseNum_""",""PatNum"":"""_inHospitalPatNum_""",""DayWorkNum"":"""_DayWorkNum_""",""LunchWorkNum"":"""_LunchWorkNum_""",""NightWorkNum"":"""_NightWorkNum_""",""MarryLeaveNum"":"""_MarryLeaveNum_""",""MaternityNum"":"""_MaternityNum_""",""SickLeave"":"""_SickLeave_""",""AnnualLeaveNum"":"""_AnnualLeaveNum_""",""FamilyLeaveNum"":"""_FamilyLeaveNum_"""}"
	
	w "]"
	q ""
}

ClassMethod GetShcduleWardDatas(parr As %String, role As %String = "", nurseid As %String = "") As %String
{
	w "[{""Children"":["
	s n=0,tmpArrangePer=""
	s NurseSum=0,ANurseSum=0,BedSum=0,PatSum=0,DayWorkSum=0,LunchWorkSum=0,NightWorkSum=0 //护士总数 排班护士数 在编床位数 患者总数 白班总数 晚班总数 夜班总数 
	s MarryLeaveSum=0,SickLeaveSum=0,AnnualLeaveSum=0 //婚假总数 病假总数 年假总数
	s FamilyLeaveSum=0,MaternitySum=0 //探亲假总数 产假总数
	;s Spell="" f  s Spell=$o(^DHCNMG.DB.MgWardI("Spell",Spell)) q:Spell=""  d
	;.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgWardI("Spell",Spell,RowID)) q:RowID=""  d
	;获取权限病区
	k tmpWard
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..;过滤没有权限的病区
	..q:(isAll=0)&&('$d(tmpWard(RowID)))
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..i obj.WardShort'="" s WardDesc=obj.WardShort
	..e  s WardDesc=obj.WardDesc
	..q:((obj.CTLocDR="")&&(parr=2))
	..s n=n+1
	..s NurseNum=0 //护士人数
	..s inHospitalPatNum=0 //在院患者人数
	..s Rw="" f  s Rw=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_RowID,Rw)) q:Rw=""  d
	...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(Rw)
	...q:PerObj.PerTypeDR'="N"
	...q:PerObj.PerStatus'="17||1"
	...s NurseNum=NurseNum+1
	...s NurseSum=NurseSum+1
	..i $IsObject(obj.CTLocDR) d
	...s CtLocId=obj.CTLocDR.%Id()
	...q:CtLocId=""
	...s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	...q:wardID=""
	...s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	....s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    .....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    .....q:padmType'="I"
    .....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    .....q:patVisit'="A" //过滤掉不是在院状态的记录
    .....s inHospitalPatNum=inHospitalPatNum+1
    ...s waitNum=..GetWardWaitNum(wardID) //获取等待区的人数
    ...s inHospitalPatNum=inHospitalPatNum+waitNum
    ...s PatSum=PatSum+inHospitalPatNum
    ..s ANurseNum=0 //上班护士
	..s DayWorkNum=0,LunchWorkNum=0,NightWorkNum=0 //白班 夜班数
	..s MarryLeaveNum=0,SickLeave=0,AnnualLeaveNum=0 //婚假 病假 年假
	..s FamilyLeaveNum=0,MaternityNum=0 //探亲 产假
	..s ArgRowID="" f  s ArgRowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",RowID,+$H,ArgRowID)) q:ArgRowID=""  d
	...s ArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(ArgRowID)
	...q:'$IsObject(ArgObj)
	...q:(ArgObj.ArrangeDR.ArgStatus'="R")&&(ArgObj.ArrangeDR.ArgStatus'="A")
	...i $IsObject(ArgObj.ArgPerDR)&&('$d(tmpArrangePer(ArgObj.ArgPerDR.%Id()))) d
	....s tmpArrangePer(ArgObj.ArgPerDR.%Id())= ArgObj.ArgPerDR.%Id()
	....s ANurseNum=ANurseNum+1
	...s ArgPost=ArgObj.ArgPostDR.PostDesc
	...i ArgPost["A" d
	....s DayWorkNum=DayWorkNum+1
	....s DayWorkSum=DayWorkSum+1
	...i ArgPost["P" d
	....s LunchWorkNum=LunchWorkNum+1
	....s LunchWorkSum=LunchWorkSum+1
	...i ArgPost["N" d
	....s NightWorkNum=NightWorkNum+1
	....s NightWorkSum=NightWorkSum+1
	...i ArgPost["婚假" d
	....s MarryLeaveNum=MarryLeaveNum+1
	....s MarryLeaveSum=MarryLeaveSum+1
	...i ArgPost["病假" d
	....s SickLeave=SickLeave+1
	....s SickLeaveSum=SickLeaveSum+1
	...i ArgPost["年" d
	....s AnnualLeaveNum=AnnualLeaveNum+1
	....s AnnualLeaveSum=AnnualLeaveSum+1
	...i ArgPost["探" d
	....s FamilyLeaveNum=FamilyLeaveNum+1
	....s FamilyLeaveSum=FamilyLeaveSum+1
	...i ArgPost["产" d
	....s MaternityNum=MaternityNum+1
	....s MaternitySum=MaternitySum+1
	..s num=..getBedsAndNurses(RowID) ;实际床数、在编床数、护士数
	..s BedNum=$p(num,"^",2)
	..s BedSum=BedSum+BedNum
	..s ANurseSum=ANurseSum+ANurseNum
	..i n=1 w "{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_""",""NurseNum"":"""_NurseNum_"/"_ANurseNum_""",""PatNum"":"""_BedNum_"/"_inHospitalPatNum_""",""DayWorkNum"":"""_DayWorkNum_""",""LunchWorkNum"":"""_LunchWorkNum_""",""NightWorkNum"":"""_NightWorkNum_""",""MarryLeaveNum"":"""_MarryLeaveNum_""",""MaternityNum"":"""_MaternityNum_""",""SickLeave"":"""_SickLeave_""",""AnnualLeaveNum"":"""_AnnualLeaveNum_""",""FamilyLeaveNum"":"""_FamilyLeaveNum_"""}"
	..e  w ",{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_""",""NurseNum"":"""_NurseNum_"/"_ANurseNum_""",""PatNum"":"""_BedNum_"/"_inHospitalPatNum_""",""DayWorkNum"":"""_DayWorkNum_""",""LunchWorkNum"":"""_LunchWorkNum_""",""NightWorkNum"":"""_NightWorkNum_""",""MarryLeaveNum"":"""_MarryLeaveNum_""",""MaternityNum"":"""_MaternityNum_""",""SickLeave"":"""_SickLeave_""",""AnnualLeaveNum"":"""_AnnualLeaveNum_""",""FamilyLeaveNum"":"""_FamilyLeaveNum_"""}"
	w "],"
	w """NurseSum"":"""_NurseSum_"/"_ANurseSum_""",""PatSum"":"""_BedSum_"/"_PatSum_
	""",""DayWorkSum"":"""_DayWorkSum_""",""LunchWorkSum"":"""_LunchWorkSum_""",""NightWorkSum"":"""_NightWorkSum
	_""",""MarryLeaveSum"":"""_MarryLeaveSum_""",""SickLeaveSum"":"""_SickLeaveSum_""",""AnnualLeaveSum"":"""_AnnualLeaveSum
	_""",""FamilyLeaveSum"":"""_FamilyLeaveSum_""",""MaternitySum"":"""_MaternitySum_"""}"
	w "]"
	q ""
}

/// Creator:
/// Date:2020-03-27
/// Description:根据日期获取某人当天白班小时数、夜班小时数
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetWorkCount(date, rowid, stTime, endTime) As %String
{
	s DayCount=0,NightCount=0	
	s:date["-" date=$zdh(date,3)
	;s isAskLeave=..IsPerAskLeavel2(perid_"^"_date)
	;q:isAskLeave=1 "0^0"
	;前一天
	s argid="" f  s argid=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",rowid,date,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostLevel'="一线班")) //排除非一线班
	.q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostType="H")) ;排除休假
	.s time=..GetTime(obj.ArgStTime1,obj.ArgEndTime1,stTime,endTime,1)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	.s time=..GetTime(obj.ArgStTime2,obj.ArgEndTime2,stTime,endTime,1)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	.s time=..GetTime(obj.ArgStTime3,obj.ArgEndTime3,stTime,endTime,1)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	;当天
	s argid="" f  s argid=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",rowid,date+1,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostLevel'="一线班")) //排除非一线班
	.q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostType="H")) ;排除休假
	.s time=..GetTime(obj.ArgStTime1,obj.ArgEndTime1,stTime,endTime,2)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	.s time=..GetTime(obj.ArgStTime2,obj.ArgEndTime2,stTime,endTime,2)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	.s time=..GetTime(obj.ArgStTime3,obj.ArgEndTime3,stTime,endTime,2)
	.s DayCount=DayCount+$P(time,"^",1)
	.s NightCount=NightCount+$P(time,"^",2)
	q DayCount_"^"_NightCount
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 
/// table: 
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel2("60^2018-05-07")
ClassMethod IsPerAskLeavel2(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") 0
		s:date["-" date=$zdh(date,3)
		s flag=0
		s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
		.q:'$IsObject(obj)
		.q:obj.LeaveStatus'="NH"
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))
		.q:((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s flag=1
		i flag=0 d
		.s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		..s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
		..q:'$IsObject(obj2)
		..q:obj2.LeaveStatus'="HH"
		..q:((obj2.LeaveStDate'="")&&(obj2.LeaveStDate>date))
		..q:((obj2.LeaveEndDate'="")&&(obj2.LeaveEndDate<date))
		..s flag=1
		q flag
}

/// creator: lulin	
/// createdate: 2020-03-27
/// description: 
/// table: 
/// input: 
/// output:
/// other:
ClassMethod GetTime(st, end, stTime, endTime, flag) As %String
{
	s day=0,night=0
	q:(st="")||(end="") "0^0"
	s tSt=0,tEnd=0
	if flag=1  {
		i (end["次日") d
		.s tEnd=$zth($E(end,3,$L(end)),1)+86400
		.i st["次日" s tSt=$zth($E(st,3,$L(st)),1)+86400
		.e  s tSt=$zth(st,1)
		e  s tSt=$zth(st,1),tEnd=$zth(end,1)
		s:tSt<stTime tSt=stTime
		s:tEnd<stTime tEnd=stTime
	}else{ ;第二天截至到
		i (st'["次日")  d
		.s tSt=$zth(st,1)
		.i (end'["次日") s tEnd=$zth(end,1)
		.e  s tEnd=stTime
		.i tSt<stTime  d
		..s tSt=tSt+86400
		..i tEnd>stTime s tEnd=stTime+86400
		..e  s tEnd=tEnd+86400
	}
	q:(tSt=0)||(tEnd=0) "0^0"
	i tEnd<endTime s day=tEnd-tSt
	e  i tSt<endTime  s day=endTime-tSt,night=tEnd-endTime
	e  s night=tEnd-tSt
	b:night<0
	s day=day/3600,night=night/3600
	q day_"^"_night
}

/// Creator:lulin
/// Description:获取患者信息接口
/// Date:2020-02-19
/// Table:
/// Input:日期,结果数组，白班开始时间，夜班开始时间
/// Output：
/// Others:
ClassMethod getPatInfo(date, tmpPatData, dStTime, dEndTime) As %String
{
	s EpisodeID=""  f  s EpisodeID=$O(^PAADMi("PAADM_Type","I",EpisodeID)) q:EpisodeID=""  d
	.q:+EpisodeID=0
	.q:$g(^PAADM(EpisodeID))=""
	.s disdate=$p($g(^PAADM(EpisodeID)),"^",17)  ;出院日期
 	.s distime=$p($g(^PAADM(EpisodeID)),"^",18)  ;出院时间
 	.s visstu=$p($g(^PAADM(EpisodeID)),"^",20)   ;出院状态
 	.q:visstu="C"
 	.q:(disdate'="")&&(disdate<date) ;入参日期已出院
 	.s papmidr=$P(^PAADM(EpisodeID),"^",1)
 	.q:papmidr=""
 	.s patname=$P($g(^PAPER(papmidr,"ALL")),"^",1)
	.s Medicare=$P($g(^PAPER(papmidr,"PAT",1)),"^",22) ;住院号
	.s index=1,bTranWard=""
	.s stDate="" f  s stDate=$O(^PAADMi("TransDateTime1",EpisodeID,stDate)) q:stDate=""  d
	..q:(stDate>(date+1))
	..s stTime="" f  s stTime=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime)) q:stTime=""  d
	...q:(stDate=(date+1))&&(stTime>dStTime)  ;只考虑次日白班开始时间之前的转科信息
	...s tranid="" f  s tranid=$O(^PAADMi("TransDateTime1",EpisodeID,stDate,stTime,tranid)) q:tranid=""  d
	....q:+tranid=0
	....s bed=$P(^PAADM(EpisodeID,"TRANS",tranid),"^",8)
	....q:+bed=0
	....s tTranWard=$P($g(^PAADM(EpisodeID,"TRANS",tranid)),"^",9)  ;PACWard
	....q:tTranWard=""  ;过滤无效数据,如第一次登记
	....q:tTranWard=bTranWard ;转床不做考虑
	....s nextTranDate=disdate,nextTranTime=distime,nextFlag=0
	....s nextTranId=""  f  s nextTranId=$O(^PAADM(EpisodeID,"TRANS",nextTranId)) q:(nextTranId="")||(nextFlag=1)  d
	.....q:+nextTranId=0
	.....s bed=$P(^PAADM(EpisodeID,"TRANS",nextTranId),"^",8)
	.....q:+bed=0
	.....s nextTranWard=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",9)  ;PACWard
	.....q:nextTranWard=""
	.....q:nextTranWard=tTranWard
	.....s nextTranDate=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",1)
	.....s nextTranTime=$P($g(^PAADM(EpisodeID,"TRANS",nextTranId)),"^",2)
	.....s nextFlag=1
	....;转入日期小于今天或者转日日期小于白班开始日期。并且转出或者梨园时间>今天或白班开始时间
	....;8点接班患者数
	....i ((stDate<date)||((stDate=date)&&(stTime<dStTime)))&&((nextTranDate="")||(nextTranDate>date)||(nextTranTime>dStTime)) d  
	.....s tmpPatData(tTranWard,"D")=$g(tmpPatData(tTranWard,"D"))+1
	....;16点接班患者数
	....i ((stDate<date)||((stDate=date)&&(stTime<dEndTime)))&&((nextTranDate="")||(nextTranDate>date)||(nextTranTime>dEndTime)) d
	.....s tmpPatData(tTranWard,"N")=$g(tmpPatData(tTranWard,"N"))+1
	....i index=1  d  ;新入患者
	.....i (stDate=date)&&(stTime>=dStTime)&&(stTime<dEndTime)  d
	......s tmpPatData(tTranWard,"D")=$g(tmpPatData(tTranWard,"D"))+1
	.....i (stDate>date)||((stDate=date)&&(stTime>=dEndTime)) d
	......s tmpPatData(tTranWard,"D")=$g(tmpPatData(tTranWard,"N"))+1
	....s index=index+1
}

ClassMethod SaveNurPRTest() As %String
{
	f date=65440:1:(+$H-2) d
	.d ..saveNurPR(date)
}

}
