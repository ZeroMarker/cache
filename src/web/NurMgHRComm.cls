/// creator: xbl
/// createdate: 20170902
/// description: 人力资源公共类
Class web.NurMgHRComm Extends %RegisteredObject
{

/// creator: xbl
/// createdate: 200170902
/// description: 获取病区护士列表
/// table: DHCNMG.HR.MgPersons,DHCNMG.HR.MgTransDep
/// input:
/// output:
/// other: d ##class(web.NurMgHRComm).GetWardNurse(1,"2017-08-28","2017-09-03","",.tmp)
ClassMethod GetWardNurse(ward As %String, stdate As %String, enddate As %String, pertype As %String = "", tmp As %String) As %String
{
	k tmp
	q:(ward="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	.s tmp(ward,perdr)=perobj.PerName
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取当前调科记录结束日期
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output: 
/// other: w ##class(web.NurMgHRComm).GetTransEndDate(2267)
ClassMethod GetTransEndDate(trsid As %String) As %String
{
	q:trsid="" ""
	s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	q:obj.PerTranEndDate'="" obj.PerTranEndDate
	s perdr=obj.PerDr,stdate=obj.PerTranStDate
	q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0) ""
	s enddate=999999
	s trsdr="" f  s trsdr=$O(^DHCNMG.HR.MgTransDepI("Current"," P"," "_perdr,trsdr)) q:trsdr=""  d
	.s trsobj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsdr)
	.q:'$IsObject(trsobj)
	.s trsstdate=trsobj.PerTranStDate
	.i (trsstdate<enddate)&&(stdate<trsstdate) s enddate=trsstdate
	s trsappObj=##class(DHCNMG.HR.MgTransApp).%OpenId(obj.PerAppID)
	i ($IsObject(trsappObj))&&(obj.PerTransType="T")&&(enddate=999999) s enddate=trsappObj.TransEndDate
	q enddate
}

/// creator: xbl
/// createdate: 20170902
/// description: 判断护士是否在某个科室
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output:
/// other:
ClassMethod CheckNurWard(perdr As %String, ward As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(ward="")!(stdate="")!(enddate="") 0
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	q:($d(^DHCNMG.HR.MgPersonsD(perdr))=0) 0
	s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	s leavedate=perobj.PerStateDate //离职或退休日期
	q:(leavedate'="")&&(leavedate<=stdate) 0
	s tflag=0,flag=0
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_perdr,trsid)) q:(trsid="")!(flag=1)  d
	.s:tflag=0 tflag=1
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.q:(ward'=obj.PerDepart)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)
	.q:((trsenddate'="")&&(trsenddate<=stdate))
	.s flag=1
	
	q:flag=1 1
	// 调科申请
	s aflag=0,taflag=0
	s date="" f  s date=$O(^DHCNMG.HR.MgTransAppI("date"," T",date)) q:date=""  d
	.s appdr="" f  s arrpdr=$O(^DHCNMG.HR.MgTransAppI("date"," T",date,appdr)) q:appdr=""  d
	..s appObj=##class(DHCNMG.HR.MgTransApp).%OpenId(appdr)
	..q:(appObj.TransStatus'="A") ;过滤未审核的
	..q:((appObj.TransDate'="")&&(appObj.TransDate>enddate))||((appObj.TransEndDate'="")&&(appObj.TransEndDate<stdate))
	..f i=1:1:appObj.TransNurse.Count() d
	...s perward=appObj.TransNurse.GetAt(i)
	...q:perward=""
	...s warddr=$P(perward,"|",1)
	...s perdr1=$P(perward,"|",2)
	...i perdr1=perdr s taflag=1
	...q:(warddr="")||(warddr'=ward)||(perdr1="")||(perdr1'=perdr)
	...s aflag=1
	q:aflag=1 1
	q:(perobj.PerTypeDR'="P")&&(tflag=0)&&(taflag=0)&&(ward=perobj.PerDepDR) 1
	// 实习护士
	s pflag=0,tpflag=0
	s plandr="" f  s plandr=$O(^DHCNMG.Intern.MgTransPlanD(plandr)) q:plandr=""  d
	.s planObj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(plandr)
	.q:(planObj.PlanStatus'="S") ;过滤未生效
	.s subdr="" f  s subdr=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanPerson",plandr,perdr,subdr)) q:subdr=""  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subdr)
	..q:('$IsObject(subObj))||('$IsObject(subObj.PlanTimeDR))||('$IsObject(subObj.PlanWardDR))
	..q:subObj.PlanWardDR.%Id()'=ward
	..s planstdate=subObj.PlanTimeDR.PlanStDate,planenddate=subObj.PlanTimeDR.PlanEndDate
	..q:(planstdate="")||(planstdate>enddate)
	..q:(planenddate="")||(planenddate<stdate)
	..s curward=subObj.PlanWardDR.%Id()
	..s tpflag=1,pflag=1
	q:pflag=1 1
	q:(perobj.PerTypeDR="P")&&(tpflag=0)&&(perobj.PerDepDR=ward) 1
	q flag
}

/// creator: llulin
/// createdate: 2018-07-31
/// description: 判断护士是否在某个科室数组
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output:
/// other:
ClassMethod CheckNurWards(perdr As %String, perWard As %String, tmpward, stdate As %String, enddate As %String) As %String
{
	q:(perdr="") 0
	q:($O(tmpward(""))="") 0
	s flag=0
	q:((stdate)||(enddate=""))&&(perWard="") 0
	q:(stdate="")||(enddate="") $d(tmpward(perWard))
	s ward="" f  s ward=$O(tmpward(ward)) q:(ward="")||(flag=1)  d
	.s flag=..CheckNurWard(perdr,ward,stdate,enddate)
	q flag
}

/// 获取护士当前科室
ClassMethod GetCurrentWard(perdr As %String, date As %String) As %String
{
	q:(perdr="")!(date="") ""
	s:date["-" date=$zdh(date,3)
	q:($d(^DHCNMG.HR.MgPersonsD(perdr))=0) ""
	s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	s leavedate=perobj.PerStateDate //离职或退休日期
	q:((leavedate'="")&&(leavedate<=date)) ""
	s curward=perobj.PerDepDR
	s finalTranType="",beforWard="",beforWardFlag=0
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_perdr,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.q:'$IsObject(obj)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.s FinalTrsid=trsid
	.i obj.PerAppID'="" d
	..s transAppObj=##class(DHCNMG.HR.MgTransApp).%OpenId(obj.PerAppID)
	..i (($IsObject(transAppObj))&&(transAppObj.TranSpecy="T")) d
	...s finalTranType="T"
	...f i=1:1:transAppObj.TransNurse.Count() d
	...s perward=transAppObj.TransNurse.GetAt(i)
	...q:perward=""
	...s warddr=$P(perward,"|",1)
	...q:$P(perward,"|",2)'=perdr
	...s beforWard=warddr,beforWardFlag=1
	..e  s finalTranType="L"
	.e  s finalTranType="L"
	.q:((trsstdate="")||(trsstdate>date)||((trsenddate'="")&&(trsenddate<=date)))
	.s curward=obj.PerDepart
	.s beforWardFlag=0
	i ((finalTranType="T")&&(beforWardFlag=1)) s curward=beforWard
	q:(perobj.PerTypeDR'="P") curward
	// 实习护士
	s plandr="" f  s plandr=$O(^DHCNMG.Intern.MgTransPlanD(plandr)) q:plandr=""  d
	.s planObj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(plandr)
	.q:(planObj.PlanStatus'="S") ;过滤未生效
	.s subdr="" f  s subdr=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanPerson",plandr,perdr,subdr)) q:subdr=""  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subdr)
	..q:('$IsObject(subObj))||('$IsObject(subObj.PlanTimeDR))
	..s planstdate=subObj.PlanTimeDR.PlanStDate,planenddate=subObj.PlanTimeDR.PlanEndDate
	..q:((planstdate="")||(planstdate>date))
	..q:((planenddate="")||(planenddate<date))
	..s curward=subObj.PlanWardDR.%Id()
	q curward
}

/// creator: xbl
/// createdate: 20170907
/// description: 获取病区护士
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHRComm","FindWardNurse","1^2017-09-11^2017-09-17","")
Query FindWardNurse(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardNurseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s pertype=$P(parr,"^",4)
	i (ward="")!(stdate="")!(enddate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	.q:$d(tmp(perdr))
	.s tmp(perdr)="PerDR|"_perdr_"^PerName|"_perobj.PerName_"^PerID|"_perobj.PerID
	.s ret=tmp(perdr)
	.d OutWardNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator: xbl
/// createdate: 20170914
/// description: 获取科室护士列表
/// table: DHCNMG.HR.MgTransDep
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgHRComm","FindLocPerson","109^2018-12-10^2018-12-16^","")
Query FindLocPerson(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocPersonExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s pertype=$P(parr,"^",4)
	i (ward="")!(stdate="")!(enddate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s locid=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",ward,""))
	i locid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s warddr="" f  s warddr=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",locid,warddr)) q:warddr=""  d
	.;s warddr="" f  s warddr=$O(^DHCNMG.DB.MgWardI("Loc",locid,warddr)) q:warddr=""  d
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(warddr)
	.q:'$IsObject(wardObj)
	.s warddesc=wardObj.WardDesc
	.s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("Dep"," "_warddr,trsid)) q:trsid=""  d
	..s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	..s perdr=obj.PerDr
	..q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	..s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	..s leavedate=perobj.PerStateDate //离职或退休日期
	..q:(leavedate'="")&&(leavedate<=stdate)
	..q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	..s trsstdate=obj.PerTranStDate
	..s trsenddate=..GetTransEndDate(trsid)
	..q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	..q:$d(tmp(perdr))
	..s tmp(perdr)="PerDR|"_perdr_"^PerName|"_perobj.PerName_"^PerID|"_perobj.PerID_"^WardDesc|"_warddesc
	..s ret=tmp(perdr)
	..d OutLocNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLocNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocPersonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate:20170920
/// description: 获取在院护士
/// table:
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHRComm","FindHosNurse","P^2019-03-04^2019-03-04","")
Query FindHosNurse(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHosNurseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s types=$P(parr,"^",1) ;类型
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsD(perdr)) q:perdr=""  d
	.q:+perdr=0
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s CodeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerCategroy)
	.q:(types["P")&&($IsObject(CodeSubObj))&&(CodeSubObj.SubDesc["往届")
	.q:(types'="")&&(types'[perobj.PerTypeDR)
	.s comedate=perobj.PerComeDate
	.i perobj.PerStatus'="" d
	..s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerStatus)
	..i statusobj.SubDesc="在职" s leavedate=""
	..e  s leavedate=perobj.PerStateDate
	.e  s leavedate=""
	.q:((stdate'="")&&(leavedate'="")&&(leavedate<stdate))||((enddate'="")&&(comedate'="")&&(enddate<comedate))
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(perobj.PerName)
	.q:(input'="")&&($zcvt(perobj.PerName_","_perobj.PerID_","_pershort,"U")'[$zcvt(input,"U"))
	.s ret="PerName|"_perobj.PerName_"("_perobj.PerNo_")"_"^PerId|"_perobj.PerID_"^PerShort|"_pershort_"^PerDR|"_perdr_"^PerNo|"_perobj.PerNo
	.d OutHosNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHosNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHosNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHosNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHosNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHosNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 获取层级
/// w ##class(web.NurMgHRComm).GetLevelDesc("1","2017-12-04","2017-12-10")
ClassMethod GetLevelDesc(perdr As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	i stdate="" s stdate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	i enddate="" s enddate=+$h
	s level="",maxdate=""
	s id="" f  s id=$O(^DHCNMG.HR.MgLevelI("ssid",perdr,id)) q:id=""  d
	.s obj=##class(DHCNMG.HR.MgLevel).%OpenId(id)
	.q:obj.LevelStatus'="A"
	.q:((obj.LevelDate'="")&&(obj.LevelDate>+$H))
	.q:(obj.LevelDate>enddate)!(maxdate>obj.LevelDate)!(obj.NurLevel="")
	.s level=obj.NurLevel,maxdate=obj.LevelDate
	q:level="" ""
	s levelobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(level)
	q:levelobj="" ""
	q levelobj.SubDesc
}

/// 获取职务
/// w ##class(web.NurMgHRComm).GetDutyDesc("1","2017-12-04","2017-12-10")
ClassMethod GetDutyDesc(perdr As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	i stdate="" s stdate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	i enddate="" s enddate=+$h
	s dutydesc="",maxdate=0
	s id="" f  s id=$O(^DHCNMG.HR.MgPostDutyI("ssid",perdr,id)) q:id=""  d
	.s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.PostStatus'="A"
	.q:((obj.PostStDate'="")&&(obj.PostStDate>+$h))
	.q:((obj.PostStDate="")||(obj.PostStDate>enddate)||((obj.PostEndDate'="")&&(obj.PostEndDate<stdate)))
	.q:obj.PostDuty=""
	.q:maxdate>obj.PostStDate
	.s duty=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PostDuty)
	.q:'$IsObject(duty)
	.;s dutydesc=dutydesc_duty.SubDesc_","
	.s maxdate=obj.PostStDate
	.s dutydesc=duty.SubDesc
	;s dutydesc=$E(dutydesc,1,$L(dutydesc)-1)
	q dutydesc
}

/// 获取职称
/// w ##class(web.NurMgHRComm).GetTitleDesc("1","2017-12-04","2017-12-10")
ClassMethod GetTitleDesc(perdr As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	i stdate="" s stdate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	i enddate="" s enddate=+$h
	s titledesc="",maxdate=0
	s id="" f  s id=$O(^DHCNMG.HR.MgHireDutyI("ssid",perdr,id)) q:id=""  d
	.s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	.q:obj.HireStatus'="A"
	.q:((obj.HireStDate'="")&&(obj.HireStDate>+$H))
	.q:(obj.HireStDate="")||(obj.HireStDate>enddate)||((obj.HireEndDate'="")&&(obj.HireEndDate<stdate))
	.q:obj.HireDuty=""
	.q:maxdate>obj.HireStDate
	.s maxdate=obj.HireStDate
	.s title=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.HireDuty)
	.s titledesc=title.SubDesc
	q titledesc
}

/// creator: xbl
/// createdate: 20180108
/// description: 获取护士信息
/// table: DHCNMG.HR.MgPersons
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHRComm","FindPersonList","","","冯丹")
Query FindPersonList(parr As %String = "", input As %String = "", name As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPersonListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", name As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	i stdate="" s stdate=+$h
	s:stdate["-" stdate=$zdt(stdate,3)
	s enddate=$P(parr,"^",3)
	i enddate="" s enddate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$P(parr,"^",4)
	s duty=$P(parr,"^",5)
	s input=$zcvt(input,"U")
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:perobj.PerTypeDR'="N"
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.;s flag=..CheckNurWard(perdr,ward,stdate,enddate)
	.;q:(ward'="")&&(stdate'="")&&(enddate'="")&&(flag=0)
	.s perward=""
	.s:enddate'=+$H perward=..GetCurrentWard(perdr,enddate)
	.s perward="" s perward=perobj.PerDepDR
	.q:(ward'="")&&(perward'=ward)
	.i perward'="" d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(perward)
	..s warddesc=wardObj.WardDesc
	.q:(type'="")&&(type'=perobj.PerTypeDR)
	.;q:((ward'="")&&(perobj.PerDepDR'=ward))
	.s flag=0
	.s dutyid="" f  s dutyid=$O(^DHCNMG.HR.MgPostDutyI("ssid",perdr,dutyid)) q:dutyid=""  d
	..s dutyobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(dutyid)
	..q:(dutyobj.PostStDate="")||(dutyobj.PostStDate>enddate)||((dutyobj.PostEndDate'="")&&(dutyobj.PostEndDate<stdate))
	..q:(dutyobj.PostDuty="")||((duty'="")&&(dutyobj.PostDuty'=duty))
	..s flag=1
	.q:(duty'="")&&(flag=0)
	.s perid=perobj.PerID
	.i perid="" s perid=perobj.PerNo
	.s pername=perobj.PerName
	.q:(name'="")&&(pername'=name)
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s dutydesc=..GetDutyDesc(perdr,stdate,enddate)
	.s ret="perdr|"_perdr_"^PerID|"_perid_"^PerName|"_pername_"^perward|"_perward_"^WardDesc|"_$g(warddesc)_"^DutyDesc|"_dutydesc
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPersonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator: lulin
/// createdate: 2018-07-02
/// description: 按照病区获取护士信息
/// table: DHCNMG.HR.MgPersons
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHRComm","FindPersonList","","","冯丹")
Query FindPerInOfWardList(parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerInOfWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	i stdate="" s stdate=+$h
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	i enddate="" s enddate=+$h
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$P(parr,"^",4)
	s duty=$P(parr,"^",5)
	s input=$zcvt(input,"U")
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:perobj.PerTypeDR'="N"
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,enddate)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s:curward="" curward=perobj.PerDepDR
	.q:((ward'="")&&(ward'=curward))
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.;s flag=..CheckNurWard(perdr,ward,stdate,enddate)
	.;q:(ward'="")&&(stdate'="")&&(enddate'="")&&(flag=0)
	.q:(type'="")&&(type'=perobj.PerTypeDR)
	.;q:((ward'="")&&(perobj.PerDepDR'=ward))
	.s flag=0
	.s dutyid="" f  s dutyid=$O(^DHCNMG.HR.MgPostDutyI("ssid",perdr,dutyid)) q:dutyid=""  d
	..s dutyobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(dutyid)
	..q:'$IsObject(dutyobj)
	..q:dutyobj.PostStatus'="A"
	..q:(dutyobj.PostStDate="")||(dutyobj.PostStDate>enddate)||((dutyobj.PostEndDate'="")&&(dutyobj.PostEndDate<stdate))
	..q:(dutyobj.PostDuty="")||((duty'="")&&(dutyobj.PostDuty'=duty))
	..s flag=1
	.q:(duty'="")&&(flag=0)
	.s perid=perobj.PerID
	.i perid="" s perid=perobj.PerNo
	.s pername=perobj.PerName
	.;q:(name'="")&&(pername'=name)
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s perward=..GetCurrentWard(perdr,enddate)
	.s warddesc=""
	.i perward'="" d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(perward)
	..s:$IsObject(wardObj) warddesc=wardObj.WardDesc
	.s dutydesc=..GetDutyDesc(perdr,stdate,enddate)
	.s ret="perdr|"_perdr_"^PerID|"_perid_"^PerName|"_pername_"^perward|"_perward_"^WardDesc|"_$g(warddesc)_"^DutyDesc|"_dutydesc
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerInOfWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerInOfWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerInOfWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerInOfWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
