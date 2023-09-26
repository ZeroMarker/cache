Include Nur.DateFormat

Class web.DHCNurSkinTestList Extends %RegisteredObject
{

/// 根据日期(默认当天)查询要做皮试病人
/// 
Query GetSkinTestPat(StartDate As %String, SkinFlag As %String, LocId As %String) As %Query(ROWSPEC = "PatName:%String,RegNo:%String,TestStartTime:%String,ToObserveTime:%String,TestTime:%String,CardNo:%String,EpisodeID:%String,CurStat:%String,ID:%String")
{
}

ClassMethod GetSkinTestPatExecute(ByRef qHandle As %Binary, StartDate As %String, SkinFlag As %String, LocId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNurSkinTestList","GetSkinTestPat","","")
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	if StartDate="" s StartDate=+$h
	s curTime="" f  s curTime=$O(^User.DHCNurSkinTestListI("StartDateTime",StartDate,curTime)) q:(curTime="")  d
	.s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("StartDateTime",StartDate,curTime,curId)) q:(curId="")  d
	..s TestLocDr=$ListGet(^User.DHCNurSkinTestListD(curId),13)
	..q:TestLocDr'=LocId
	..s TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	..q:(SkinFlag'="on")&(TestDate'="") //已做过皮试
	..s TestTime=$ListGet(^User.DHCNurSkinTestListD(curId),7)
	..i TestTime'="" s TestTime=$ZT(TestTime)
	..s TestAdmDr=$ListGet(^User.DHCNurSkinTestListD(curId),2)
	..q:TestAdmDr=""
	..s Papmidr=$P($G(^PAADM(TestAdmDr)),"^",1)
	..q:Papmidr=""
	..s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	..s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	..s CardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",Papmidr,""))
	..i CardDr'="" s CardNo=$P($G(^DHCCARD("CF",CardDr)),"^",2)
	..e  s CardNo=""
	..s EpisodeID=TestAdmDr
	..s TestCallFlag=$ListGet(^User.DHCNurSkinTestListD(curId),3)
	..//判断显示颜色,等待(Wait)\过20分钟查看皮试结果(Ready)\呼叫(Call)\已做皮试(Already)
	..s CurStat="Wait"
	..s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	..s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	..s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	..i ObserveTime'="" d
	...i ObserveTime["分钟" s ObserveTime=+ObserveTime*60
	...i ObserveTime["小时" s ObserveTime=+ObserveTime*3600
	..//
	..i +$h=TestStartDate,($P($h,",",2)-TestStartTime)>ObserveTime d
	...i TestCallFlag'="Y" s CurStat="Ready"
	...e  s CurStat="Call"
	..e  d
	...i TestDate="",TestCallFlag="Y" s CurStat="Call"
	..i TestDate'="" s CurStat="Already"
	..s ToObserveTime=""
	..i TestDate="" d
	...s IntervalTime=(+$h-TestStartDate)*86400+($P($h,",",2)-TestStartTime)
	...i ObserveTime>=IntervalTime d
	....s ToObserveTime=ObserveTime-IntervalTime
	....s ObserveHour=ToObserveTime\3600
	....s ObserveMin=ToObserveTime#3600\60
	....s ObserveSec=ToObserveTime#3600#60
	....s ToObserveTime=$S(ObserveHour>0:ObserveHour_"小时",1:"")_$S(ObserveMin>0:ObserveMin_"分",1:"")	
	....i ObserveHour=0,ObserveMin=0,ObserveSec'="" s ToObserveTime=ObserveSec_"秒"
	..i TestStartTime'="" s TestStartTime=$ZT(TestStartTime)
	..s ID=curId
	..Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(PatName,RegNo,TestStartTime,ToObserveTime,TestTime,CardNo,EpisodeID,CurStat,ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSkinTestPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinTestPatExecute ]
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

ClassMethod GetSkinTestPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinTestPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCurrentTime() As %String
{
	q $$$zd($h,3)_" "_$zt($p($h,",",2),2)
}

Query FindOrditem(wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, DocSearch As %String = "") As %Query(ROWSPEC = "prtFlag,PatName,PatAge,PatSex,PatLoc,RegNo,TestStartTime,ObserveTime,arcimDesc,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,TestResult,TestUser,TestDateTime,ctcpDesc,createDateTime,EpisodeID,oeoriId,SkinTestFlag,TestMethod,EncryptLevel,PatLevel,disposeStatDesc")
{
}

ClassMethod FindOrditemExecute(ByRef qHandle As %Binary, wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, DocSearch As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i userId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	i queryTypeCode="",HospitalRowId="" q $$$OK
 	 
	s tempId=$j
	s rset=##class(%ResultSet).%New("web.DHCCLCom:FindOrditem")
	do rset.Execute(wardId,regNo,userId,startDate,endDate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId,DocSearch)
	while (rset.Next()) {
		s prtFlag=rset.GetData(1)
		s PatName=rset.GetData(4)
		s PatAge=rset.GetData(6)
		s PatSex=""	//
		s PatLoc=""	//
		s RegNo=rset.GetData(2)
		s TestStartTime="" //
		s ObserveTime="" //
		s arcimDesc=rset.GetData(9)
		s doseQtyUnit=rset.GetData(13)
		s phcfrCode=rset.GetData(14)
		s phOrdQtyUnit=rset.GetData(15)
		s phcinDesc=rset.GetData(16)
		s notes=rset.GetData(17)
		s TestResult=""	//
		s TestUser=""	//
		s TestDateTime=rset.GetData(39)
		s ctcpDesc=rset.GetData(21)
		s createDateTime=rset.GetData(32)
		s EpisodeID=rset.GetData(40)
		s oeoriId=rset.GetData(33)
		s disposeStatDesc=rset.GetData(49)
		s SkinTestFlag=$p($g(^OEORD(+oeoriId,"I",$P(oeoriId,"||",2),5)),"^",2)
		s papmiId=+^PAADM(+EpisodeID)
		i papmiId'="" d
		.s SexId=$p($g(^PAPER(papmiId,"ALL")),"^",7)
		.i SexId'="" s PatSex=$p($g(^CT("SEX",SexId)),"^",2)
		s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    	s EncryptLevel=$p(PatEncryptLevel,"^",1)
    	s PatLevel=$p(PatEncryptLevel,"^",2) 
		s ctlocId=$p(^PAADM(EpisodeID),"^",4)
		i ctlocId'="" s PatLoc=$p(^CTLOC(+ctlocId),"^",2)	
		s TestInfo=..GetSkinInfoByOrder(oeoriId)
		s TestStartTime=$P(TestInfo,"^",1)
		s ObserveTime=$P(TestInfo,"^",2)
		s TestMethod=$P(TestInfo,"^",3)
		s TestResult=$P(TestInfo,"^",4)
		s TestUser=$P(TestInfo,"^",5)
		d OutRow
	}	
	d rset.Close()
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRow
	//s Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),data("seqNo"),data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("placerNo"),data("skinTestDateTime"),EpisodeID,data("specDesc"),data("ordlocDesc"))
 	s Data=$lb(prtFlag,PatName,PatAge,PatSex,PatLoc,RegNo,TestStartTime,ObserveTime,arcimDesc,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,TestResult,TestUser,TestDateTime,ctcpDesc,createDateTime,EpisodeID,oeoriId,SkinTestFlag,TestMethod,EncryptLevel,PatLevel,disposeStatDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOrditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOrditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 通过就诊ID与医嘱ID取皮试信息
ClassMethod GetSkinInfoByAdm(Adm, OeoriDr) As %String
{
	//w ##class(web.DHCNurSkinTestList).GetSkinInfoByAdm(1,"1||6||1")
	q:Adm="" ""
	s TestStartDateTime="",ObserveTime="",TestMethod="",TestResult="",skinTestCtcpDesc=""
	s oeordId=$P(OeoriDr,"||",1),oeoriSub=$P(OeoriDr,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub
	s flag=0
	s curDate="" f  s curDate=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate)) q:(curDate="")!(flag=1)  d
	.s curTime="" f  s curTime=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime)) q:(curTime="")!(flag=1)  d
	..s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime,curId)) q:(curId="")!(flag=1)  d
	...s TestOeoriDr=$ListGet(^User.DHCNurSkinTestListD(curId),11)
	...i oeoriId=TestOeoriDr d
	....s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	....i TestStartDate'="" s TestStartDate=$$$ZD(TestStartDate,3)
	....s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	....i TestStartTime'="" s TestStartTime=$ZT(TestStartTime)
	....s TestStartDateTime=TestStartDate_" "_TestStartTime
	....s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	....s TestMethod=$ListGet(^User.DHCNurSkinTestListD(curId),14)
	....s flag=1

	s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
	s TestResult=$S(abnorm="Y":"阳性",abnorm="N":"阴性",1:"")
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId'="" d
	.s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
	.i skinTestCtcpId'="" s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
	.//s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
	.//s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)	
  	q TestStartDateTime_"^"_ObserveTime_"^"_TestMethod_"^"_TestResult_"^"_skinTestCtcpDesc
}

/// 通过医嘱ID取皮试信息
ClassMethod GetSkinInfoByOrder(OeoriDr) As %String
{
	//w ##class(web.DHCNurSkinTestList).GetSkinInfoByOrder("77084||18")
	q:OeoriDr="" ""
	s TestStartDateTime="",ObserveTime="",TestMethod="",abnormFlag="",skinTestCtcpDesc="",TestResult="",skinTestDateTime="",TestResultDesc=""
	s oeordId=$P(OeoriDr,"||",1),oeoriSub=$P(OeoriDr,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub

	s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("OeoriDr"," "_oeoriId,curId)) q:(curId="")  d
	.s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	.i TestStartDate'="" s TestStartDate=$$$ZD(TestStartDate,3)
	.s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	.i TestStartTime'="" s TestStartTime=$ZT(TestStartTime)
	.s TestStartDateTime=TestStartDate_" "_TestStartTime
	.s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	.s TestMethod=$ListGet(^User.DHCNurSkinTestListD(curId),14)
	.s TestResult=$ListGet(^User.DHCNurSkinTestListD(curId),15)
	.s TestResultDesc=$ListGet(^User.DHCNurSkinTestListD(curId),16)

	s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
	s abnormFlag=$S(abnorm="Y":"阳性",abnorm="N":"阴性",1:"")
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId'="" d
	.s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
	.i skinTestCtcpId'="" s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
	.s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
	.i skinTestDate'="" s skinTestDate=$$$ZD(skinTestDate,3)
	.s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)
	.i skinTestTime'="" s skinTestTime=$ZT(skinTestTime)
	.s skinTestDateTime=skinTestDate_" "_skinTestTime
  	q TestStartDateTime_"^"_ObserveTime_"^"_TestMethod_"^"_abnormFlag_"^"_skinTestCtcpDesc_"^"_TestResult_"^"_skinTestDateTime_"^"_TestResultDesc
}

/// 皮试方法
ClassMethod GetTestMethodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0,des=""
	d out1
 	s id=1,des="静注法"
	d out1
 	s id=2,des="结膜试验法"
	d out1
 	s id=3,des="点(挑)刺"
	d out1
 	s id=4,des="口含试验法"
	d out1
 	s id=5,des="划痕法"
	d out1
	s id=6,des="皮内试验法"
	d out1
	s id=7,des="点眼法"
	d out1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTestMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestMethodExecute ]
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

ClassMethod GetTestMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTestMethod() As %Query(ROWSPEC = "idv,des")
{
}

/// 通过就诊ID与医嘱ID取皮试信息
ClassMethod SkinTestMessage(LocId = "") As %String
{
	//w ##class(web.DHCNurSkinTestList).SkinTestMessage(18)
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	s retStr=""
	s curTime="" f  s curTime=$O(^User.DHCNurSkinTestListI("StartDateTime",+$h,curTime)) q:(curTime="")  d
	.s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("StartDateTime",+$h,curTime,curId)) q:(curId="")  d
	..s TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	..q:TestDate'="" //已做过皮试
	..s TestLocDr=$ListGet(^User.DHCNurSkinTestListD(curId),13)
	..q:TestLocDr'=LocId
	..s TestAdmDr=$ListGet(^User.DHCNurSkinTestListD(curId),2)
	..q:TestAdmDr=""
	..s Papmidr=$P($G(^PAADM(TestAdmDr)),"^",1)
	..i Papmidr'="" s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	..e  s PatName=""
	..i Papmidr'="" s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	..e  s RegNo=""
	..s TestCallFlag=$ListGet(^User.DHCNurSkinTestListD(curId),3)
	..q:TestCallFlag="Y"	//呼叫过的病人不再提示
	..s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	..s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	..s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	..q:ObserveTime=""
	..i ObserveTime["分钟" s ObserveTime=+ObserveTime*60
	..i ObserveTime["小时" s ObserveTime=+ObserveTime*3600
	..i +$h=TestStartDate,($P($h,",",2)-TestStartTime)>ObserveTime d
	...i TestCallFlag'="Y" d
	....//s retStr=retStr_"请患者"_PatName_"到前台查看皮试结果!"_"^"
	....s retStr=retStr_RegNo_" "_PatName_"^"
	q retStr
}

/// 取皮试观察时间及皮试方法
Query GetSkinTestSet() As %Query(ROWSPEC = "tArcimDesc:%String,tObserveTime:%String,tTestMethod:%String,tArcimDr:%String,Id:%String")
{
}

ClassMethod GetSkinTestSetExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNurSkinTestList","GetSkinTestSet","","")
	s curId="" f  s curId=$O(^User.DHCNurSkinTestSetD(curId)) q:(curId="")  d
	.s tArcimDr=$ListGet(^User.DHCNurSkinTestSetD(curId),2)
	.i tArcimDr'="" d
	..s ARCIMSubscript=$P(tArcimDr,"||",1)
	..s ARCIMVersion=$P(tArcimDr,"||",2)
	..s tArcimDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.e  d
	..s tArcimDesc=""
	.s tObserveTime=$ListGet(^User.DHCNurSkinTestSetD(curId),3)
	.s tTestMethod=$ListGet(^User.DHCNurSkinTestSetD(curId),4)
	.s Id=curId
	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(tArcimDesc,tObserveTime,tTestMethod,tArcimDr,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSkinTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinTestSetExecute ]
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

ClassMethod GetSkinTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinTestSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 观察时间
ClassMethod GetObserveTimeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0,des=""
	d out1
 	s id=1,des="10分钟"
	d out1
 	s id=2,des="15分钟"
	d out1
 	s id=3,des="20分钟"
	d out1
 	s id=4,des="48小时"
	d out1
 	s id=5,des="72小时"
	d out1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetObserveTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetObserveTimeExecute ]
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

ClassMethod GetObserveTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetObserveTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetObserveTime() As %Query(ROWSPEC = "idv,des")
{
}

/// 皮试执行界面根据医嘱ID自动取观察时间及皮试方法
/// 若无皮试结果取维护的默认项
ClassMethod GetInfoByOrder(oeoriId) As %String
{
	//w ##class(web.DHCNurSkinTestList).GetInfoByOrder("321||9")
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	q:(oeordId="")!(oeoriSub="") ""
	s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
	if abnorm="" {
		s ArcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
		b 
		s retStr=##class(User.DHCNurSkinTestSet).GetInfoByArcimDr(ArcimDr)
		q retStr	
	}
	else {
		s retStr=##class(web.DHCNurSkinTestList).GetSkinInfoByOrder(oeoriId)
		q $P(retStr,"^",2)_"^"_$P(retStr,"^",3)
	}
	q ""
}

/// 医生站检查结果标签中PPD试验结果调用
/// 	设置Global ^DHCCLSet("Exec","PPDArcimDr")
Query GetPPDTest(EpisodeID As %String) As %Query(ROWSPEC = "arcimDesc:%String,createDateTime:%String,ctcpDesc:%String,TestStartTime:%String,ObserveTime:%String,TestResult:%String,skinTestDateTime:%String,TestUser:%String")
{
}

ClassMethod GetPPDTestExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNurSkinTestList","GetPPDTest","446")
	i EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s oeordId=$O(^OEORD(0,"Adm",EpisodeID,0))
	i oeordId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	//设置结核菌药敏试验
	s PPDArcimDr=$G(^DHCCLSet("Exec","PPDArcimDr"))
	f i=1:1:$l(PPDArcimDr,"^") d
	.s ArcimDr=$p(PPDArcimDr,"^",i)
	.s SttDate="" f  s SttDate=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate)) q:SttDate=""  d
	..s oeoriSub="" f  s oeoriSub=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate,oeoriSub)) q:oeoriSub=""  d
	...s oeoriId=oeordId_"||"_oeoriSub
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    ...q:ordStatCode'="V"
	...s OrdBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	...//q:OrdBilled'="P"
	...s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s arcimSub=$p(arcimId,"||"),arcimVer=$p(arcimId,"||",2)
	...s arcimDesc=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)
	...s ordSet=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",10)
 	...i ordSet'="" d
 	....s arcosDesc=$p($g(^ARCOS(ordSet)),"^",2) 
	....i arcosDesc'="" d
	.....i $l(arcosDesc,"-")>1 s arcosDesc=$p(arcosDesc,"-",2)
	.....s arcimDesc=arcosDesc
	...s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    ...s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
	...s createDateTime=##Class(web.DHCCLCom).FormatDate(oeoriDate)_" "_##Class(web.DHCCLCom).FormatTime(oeoriTimeOrd)
	...s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
	...s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
	...s ctcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
	...//s TestResultDesc=""
	...//f rnum=1:1:$g(^OEORD(oeordId,"I",oeoriSub,"DEP",0))  d
	...//.s ordNote=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",rnum))
	...//.i (ordNote["皮肤硬结")!(ordNote["局部水泡")!(ordNote["坏死")!(ordNote["淋巴管炎") d
	...//..s TestResultDesc=TestResultDesc_ordNote
	...s TestInfo=..GetSkinInfoByOrder(oeoriId)
	...s TestStartTime=$P(TestInfo,"^",1)
	...s ObserveTime=$P(TestInfo,"^",2)
	...s skinTestDateTime=$P(TestInfo,"^",7)
	...s TestResult=$P(TestInfo,"^",6)
	...s TestResultDesc=$P(TestInfo,"^",8)
	...s TestResult=TestResult_" "_TestResultDesc
	...s TestUser=$P(TestInfo,"^",5)
	...Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(arcimDesc,createDateTime,ctcpDesc,TestStartTime,ObserveTime,TestResult,skinTestDateTime,TestUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPPDTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPPDTestExecute ]
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

ClassMethod GetPPDTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPPDTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 皮试执行/护士执行置皮试结果中
/// 	判断皮试是否是PPD试验医嘱,是可以不用选皮试结果
/// 	设置Global ^DHCCLSet("Exec","PPDArcimDr")
ClassMethod GetIfPPDOrder(oeoriId) As %String
{
	//w ##class(web.DHCNurSkinTestList).GetIfPPDOrder("343||15||1")
	s oeoriId=$p(oeoriId,"^") 
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	q:(oeordId="")!(oeoriSub="") 0
	s ArcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:$G(^DHCCLSet("Exec","PPDArcimDr"))[ArcimDr 1
	q 0
}

/// qqa 2018-01-03
/// 皮试界面加载数据
/// w ##class(web.DHCNurSkinTestList).GetSkinRsData("50001996||9||1")
ClassMethod GetSkinRsData(oeoriId) As %String
{
	s oeoriId = +oeoriId_"||"_$p(oeoriId,"||",2)
	s IsPPDFlag = ##class(web.DHCNurSkinTestList).GetIfPPDOrder(oeoriId)
	s SkinInfo = ##class(web.DHCNurSkinTestList).GetSkinInfo(oeoriId)
	q IsPPDFlag_"#"_SkinInfo
}

/// w ##class(web.DHCNurSkinTestList).GetSkinInfo("50001996||9")
ClassMethod GetSkinInfo(oeoriId)
{
	s PatSkinInfo=""
	s Abnorm=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),11)),"^",3)
	s Skin =""
	s Skin=$s(Abnorm="N":"-",Abnorm="Y":"+",Abnorm="":"")
	q:Skin="" ""
	s DHCOriId=$o(^DHCORDItem(0,oeoriId,""))
	s SkinCtpcpName="",SkinRecCtpcpName=""
	i DHCOriId'="" d
	.s SkinCtpcpDr = $p(^DHCORDItem(DHCOriId),"^",2)
	.s SkinRecCtpcpDr = $p(^DHCORDItem(DHCOriId),"^",13)
	.q:SkinCtpcpDr=""     
	.q:SkinRecCtpcpDr=""
	.s SkinCtpcpName = $p(^CTPCP(SkinCtpcpDr,1),"^",2)
	.s SkinRecCtpcpName = $p(^CTPCP(SkinRecCtpcpDr,1),"^",2)
	s PatSkinInfo = Skin_"^"_SkinCtpcpName_"^"_SkinRecCtpcpName
	q PatSkinInfo
}

ClassMethod GetSkinTestInfo(oeoriId)
{
	q:oeoriId="" ""
	s skin=""
	s abnorm=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),11)),"^",3)
	s skin=$s(abnorm="N":" 阴性",abnorm="Y":" 阳性",abnorm="":"")
	
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    i dhcoriId'="" d
    .s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
    .i skinTestCtcpId="" q
    .s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
	
	q skin_"^"_skinTestCtcpDesc
}

ClassMethod GetSkinParam(oeoriId)
{
	
	s PPDFlag = ..GetIfPPDOrder(oeoriId)
	s SkinRsInfo = ..GetSkinTestInfo(oeoriId)
}

/// 破伤风的结果如果是阳性,希望自动出现
/// web.DHCEmergency中调用,显示在医生站诊疗菜单的顶部基本信息中
/// 	1.提示再找医生开一支生理盐水
/// 	2.补录四次注射费用且列出四次注射时间
ClassMethod GetTestAbnormalOrder(EpisodeID As %String) As %String
{
	//w ##class(web.DHCNurSkinTestList).GetTestAbnormalOrder(757)
	q:EpisodeID="" ""
	s oeordId=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:oeordId="" ""
	s retStr=""
	s AbnormalArcimDr=$G(^DHCCLSet("Exec","AbnormalArcimDr"))
	f i=1:1:$l(AbnormalArcimDr,"^") d
	.s ArcimDr=$p(AbnormalArcimDr,"^",i)
	.s SttDate="" f  s SttDate=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate)) q:SttDate=""  d
	..s oeoriSub="" f  s oeoriSub=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate,oeoriSub)) q:oeoriSub=""  d
	...s oeoriId=oeordId_"||"_oeoriSub
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    ...q:ordStatCode'="V"
	...s OrdBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	...q:OrdBilled'="P"
	...//查找之后有没有再开药特医嘱,有则不再显示
	...s nextOrdFlag=0
	...s nextSub=oeoriSub f  s nextSub=$O(^OEORD(oeordId,"I",nextSub)) q:(nextSub="")!(nextOrdFlag=1)  d
	....s nextOrdStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_nextSub)
    ....q:nextOrdStatCode'="V"
	....s nextOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	....i nextOrderType="R" s nextOrdFlag=1
	...q:nextOrdFlag=1
	...s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s arcimSub=$p(arcimId,"||"),arcimVer=$p(arcimId,"||",2)
	...s arcimDesc=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)
	...s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
	...i abnorm="Y" d
	....s TestResult="<label Style='FONT-WEIGHT: bold; FONT-SIZE: 13px; COLOR: red;'>阳性</label>"
	....s retStr=arcimDesc_" 皮试结果"_TestResult_" 1.请再开一支生理盐水;2.补录四次注射费用且列出四次注射时间;"
	q retStr
}

ClassMethod FindSkinPPDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSkinPPDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)             //%Persistent
    Quit $$$OK
}

ClassMethod FindSkinPPDExecute(ByRef qHandle As %Binary, Ordid As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
 	 s ind=1
 
     i Ordid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
     s oeorid=+Ordid_"||"_$p(Ordid,"||",2)
     s id="" f  s id=$o(^User.DHCNurSkinPPDI("ResultOeoriDr"," "_oeorid,id)) q:id=""  d
     .s gg=^User.DHCNurSkinPPDD(id)
     .s SkinSity1=$ListGet(gg,7)  //硬结1
     .s SkinSity2=$ListGet(gg,8)   //硬结2
     .s SkinVcl1=$ListGet(gg,9)   //水泡1
     .s SkinVcl2=$ListGet(gg,10)   //水泡2
     .s SkinSwo1=$ListGet(gg,11)   //红肿1
     .s SkinSwo2=$ListGet(gg,12)   //红肿2
     .s SkinNecrosis=$ListGet(gg,13)   //坏死
     .s SkinInflam=$ListGet(gg,14)   //淋巴管炎
     .s SkinSing=$ListGet(gg,15)   //单个
     .s SkinSpora=$ListGet(gg,16)   //散在
     .s oeorid=oeorid   //医嘱id
     .s AdmDr=$ListGet(gg,2)   //就诊id
     .s Date=$ListGet(gg,4)   //置结果日期
     .s Time=$ListGet(gg,5)   //置结果时间
     .s RecUser=$ListGet(gg,3)   //置结果人
     .s PPDResult = $ListGet(gg,17)   //PPD结果
     .if $g(SkinSity1)'="" s TestSkinSity=SkinSity1_"mm*"_$g(SkinSity2)_"mm"
     .e  s TestSkinSity=""
     .if SkinVcl1'="" s TestSkinVcl=SkinVcl1_"mm*"_SkinVcl2_"mm"
     .e  s TestSkinVcl=""
     .if $g(SkinSwo1)'="" s TestSkinSwo=SkinSwo1_"mm*"_$g(SkinSwo2)_"mm"
     .e  s TestSkinSwo=""
     .if SkinNecrosis="1" s TestSkinNecrosis="√"
     .e  s TestSkinNecrosis=""
     .if SkinInflam="1" s TestSkinInflam="√"
     .e  s TestSkinInflam=""
     .if SkinSing="1" s TestSkinSing="√"
     .e  s TestSkinSing=""
     .if SkinSpora="1" s TestSkinSpora="√"
     .e  s TestSkinSpora=""
     .s EpisodeID=AdmDr
     .i Date'="" s TestDate=$$$zd(Date,3)
     .e  s TestDate=""
     .i Time'="" s TestTime=$zt(Time,2)
     .e  s TestTime=""
     .i RecUser'="" s TestUser=$p(^SSU("SSUSR",RecUser),"^",2)
     .e  s RecUser=""
	.d OutputRow1
	
		Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TestSkinSity,TestSkinVcl,TestSkinSwo,TestSkinNecrosis,TestSkinInflam,TestSkinSing,TestSkinSpora,EpisodeID,oeorid,TestDate,TestTime,TestUser,id,PPDResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSkinPPDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSkinPPDExecute ]
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

// 硬结 局部水泡 红肿 坏死 淋巴管炎 单个 散在

Query FindSkinPPD(Ordid As %String) As %Query(ROWSPEC = "TestSkinSity,TestSkinVcl,TestSkinSwo,TestSkinNecrosis,TestSkinInflam,TestSkinSing,TestSkinSpora,EpisodeID,oeorid,TestDate,TestTime,TestUser,id,PPDResult")
{
}

/// ##class(web.DHCNurSkinTestList).InsertPPDConfig
ClassMethod InsertPPDConfig(arcimID, HospID = "")
{
	
	s val=$G(^DHCCLSet("Exec","PPDArcimDr",HospID))
	q:HospID="" "请选择医院！"
	#;q:val[arcimID "已经存在！"
	i val="" S ^DHCCLSet("Exec","PPDArcimDr",HospID)= arcimID
	e  S ^DHCCLSet("Exec","PPDArcimDr",HospID)=val_"^"_arcimID
	q 0
}

/// 获取PPD医嘱配置
/// ##class(web.DHCNurSkinTestList).GetPPDConfig()
ClassMethod GetPPDConfig(HospitalRowId = "")
{
	s ^tempsc("GetPPDConfig")=HospitalRowId
	s ret=##class(%ListOfDataTypes).%New()
	if $d(%session)&&(HospitalRowId=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospitalRowId=%session.Get("LOGON.HOSPID")
 	}
	q:HospitalRowId="" ret
	i $d(^DHCCLSet("Exec","PPDArcimDr",HospitalRowId)) d
	.s val=$G(^DHCCLSet("Exec","PPDArcimDr",HospitalRowId))
	.q:val=""
	.s num=$l(val,"^")
	.f i=1:1:num d
	..s arcimID=$p(^DHCCLSet("Exec","PPDArcimDr",HospitalRowId),"^",i)
	..q:arcimID=""
	..s arcimID1=$p(arcimID,"||",1)
	..s arcimID2=$p(arcimID,"||",2)
	..s arcimDesc=$p($g(^ARCIM(arcimID1,arcimID2,1)),"^",2)
	..s row=##class(%ArrayOfDataTypes).%New()
	..d row.SetAt(arcimID,"arcimID")
	..d row.SetAt(arcimDesc,"arcimDesc")
	..d ret.Insert(row)
	q ret
}

ClassMethod UpdatePPDConfig(ppdConfig, HospitalRowId)
{
	i ppdConfig="" k ^DHCCLSet("Exec","PPDArcimDr",HospitalRowId)
	i ppdConfig'="" S ^DHCCLSet("Exec","PPDArcimDr",HospitalRowId)=$replace(^DHCCLSet("Exec","PPDArcimDr",HospitalRowId),ppdConfig,"")
	q 0
}

}
