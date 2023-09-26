/// creator: xbl
/// createdate: 20170902
/// description: 人力资源公共类
Class web.INMHRComm Extends %RegisteredObject
{

Query FindWardNurseList(ward As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardNurseListExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s wardId="" f  s wardId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId)) q:wardId=""  d
	.s tmpWard=$tr(wardId," ","")
	.q:(ward'="")&&(tmpWard'=ward)
	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId,perId)) q:perId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..q:'$IsObject(obj)
	..s perStatus=##class(web.INMPersonComm).GetCommCode(obj.PerStatus)
	..q:(perStatus'="在职") ;过滤掉离职/退休
	..s ret="Per|"_perId_"^PerName|"_obj.PerName_"^PerName|"_obj.PerName_"("_obj.PerID_")"
	..s userId=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
	..s flag=##class(web.INMLoginComm).IsNurInRoleForCode(userId,"NURHEAD",+$h)
	..s ret=ret_"^IsHead|"_$case(flag,1:"Y",:"N")
	..d:ret'="" OutQualTypeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualTypeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNurseListExecute ]
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

Query FindLocNurseList(loc As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocNurseListExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s wardId="" f  s wardId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId)) q:wardId=""  d
	.s tmpWard=$tr(wardId," ","")
	.q:tmpWard=""
	.s locId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",tmpWard,""))
	.q:(locId="")||('$d(^CF.DHCINM.DB.MgWardLocD(locId)))
	.q:(loc'="")&&(loc'=locId)
	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId,perId)) q:perId=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..q:'$IsObject(obj)
	..s perStatus=##class(web.INMPersonComm).GetCommCode(obj.PerStatus)
	..q:(perStatus'="在职") ;过滤掉离职/退休
	..s ret="Per|"_perId_"^PerName|"_obj.PerName_"^PerID|"_obj.PerID
	..d:ret'="" OutQualTypeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualTypeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocNurseListExecute ]
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

/// creator: xbl
/// createdate: 200170902
/// description: 获取病区护士列表
/// table: CF.DHCINM.HR.Persons,CF.DHCINM.Trans.TransDep
/// input:
/// output:
/// other: d ##class(web.INMHRComm).GetWardNurse(1,"2017-08-28","2017-09-03","",.tmp)
ClassMethod GetWardNurse(ward As %String, stdate As %String, enddate As %String, pertype As %String = "", tmp As %String) As %String
{
	k tmp
	q:(ward="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
	.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
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
/// table: CF.DHCINM.Trans.TransDep
/// input: 
/// output: 
/// other: w ##class(web.INMHRComm).GetTransEndDate(17)
ClassMethod GetTransEndDate(trsid As %String) As %String
{
	q:trsid="" ""
	s objLB=$g(^CF.DHCINM.Trans.TransDepD(trsid))
	q:objLB="" ""
	s PerTranEndDate=$lg(objLB,6)
	q:PerTranEndDate'="" PerTranEndDate
	s perdr=$lg(objLB,2),stdate=$lg(objLB,4),inward=$lg(objLB,3)
	q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0) ""
	s enddate=999999,flag=0
	s trsdr="" f  s trsdr=$O(^CF.DHCINM.Trans.TransDepI("Current"," P"," "_perdr,trsdr)) q:(trsdr="")||(flag=1)  d
	.s trsobjLB=$g(^CF.DHCINM.Trans.TransDepD(trsdr))
	.s trsstdate=$lg(trsobjLB,4)
	.s tPerDepart=$lg(trsobjLB,3)
	.i ((stdate<trsstdate)||((stdate=trsstdate)&&(trsdr>trsid)))&&(tPerDepart'=inward) s enddate=trsstdate,flag=1
	q:flag=0 ""
	;q:(flag=1)&&(enddate=999999) ""
	q enddate
}

/// creator: xbl
/// createdate: 20170902
/// description: 判断护士是否在某个科室
/// table: CF.DHCINM.Trans.TransDep
/// input: 
/// output:
/// other:
ClassMethod CheckNurWard(perdr As %String, ward As %String, stdate As %String, enddate As %String) As %String
{
	q:(perdr="")!(ward="")!(stdate="")!(enddate="") 0
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	q:($d(^CF.DHCINM.HR.PersonsD(perdr))=0) 0
	s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	s leavedate=perobj.PerStateDate //离职或退休日期
	q:(leavedate'="")&&(leavedate<=stdate) 0
	s tflag=0,flag=0
	s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_perdr,trsid)) q:(trsid="")!(flag=1)  d
	.s:tflag=0 tflag=1
	.s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
	.q:(ward'=obj.PerDepart)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=..GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)
	.q:((trsenddate'="")&&(trsenddate<=stdate))
	.s flag=1
	
	q:flag=1 1
	// 调科申请
	s aflag=0,taflag=0
	s date="" f  s date=$O(^DHCINM.Trans.MgTransAppI("date"," T",date)) q:date=""  d
	.s appdr="" f  s arrpdr=$O(^DHCINM.Trans.MgTransAppI("date"," T",date,appdr)) q:appdr=""  d
	..s appObj=##class(DHCINM.Trans.MgTransApp).%OpenId(appdr)
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
	s plandr="" f  s plandr=$O(^DHCINM.Intern.MgTransPlanD(plandr)) q:plandr=""  d
	.s planObj=##class(DHCINM.Intern.MgTransPlan).%OpenId(plandr)
	.q:(planObj.PlanStatus'="S") ;过滤未生效
	.s subdr="" f  s subdr=$O(^DHCINM.Intern.MgTransPlanSubI("PlanPerson",plandr,perdr,subdr)) q:subdr=""  d
	..s subObj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subdr)
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
/// table: CF.DHCINM.Trans.TransDep
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
ClassMethod GetCurrentWard(perdr As %String, date As %String, isLeave As %String = "1") As %String
{
	q:(perdr="")!(date="") ""
	s:date["-" date=$zdh(date,3)
	s perObjLB=$g(^CF.DHCINM.HR.PersonsD(perdr))
	q:perObjLB="" ""
	s leavedate=$lg(perObjLB,43) //离职或退休或转岗日期
	q:((leavedate'="")&&(leavedate<=date)&&(isLeave=1)) ""
	s curward=$lg(perObjLB,10)
	s flag=0
	s st=date+1 f  s st=$o(^CF.DHCINM.Trans.TransDepI("pertime"," "_perdr,st),-1) q:(st="")||(flag=1)  d
	.s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("pertime"," "_perdr,st,trsid),-1) q:(trsid="")||(flag=1)  d
	..s objLB=$g(^CF.DHCINM.Trans.TransDepD(trsid))
	..q:objLB=""
	..s trsstdate=$lg(objLB,4)
	..s trsenddate=..GetTransEndDate(trsid)
	..q:((trsstdate="")||(trsstdate>date)||((trsenddate'="")&&(trsenddate<=date)))
	..s curward=$lg(objLB,3)
	..s flag=1
	q curward
}

/// creator: xbl
/// createdate: 20170907
/// description: 获取病区护士
/// table: CF.DHCINM.Trans.TransDep
/// input: 
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMHRComm","FindWardNurse","1^2017-09-11^2017-09-17","")
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
	s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
	.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
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
/// table: CF.DHCINM.Trans.TransDep
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMHRComm","FindLocPerson","109^2018-12-10^2018-12-16^","")
Query FindLocPerson(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocPersonExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindLocPerson")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s pertype=$P(parr,"^",4)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i (ward="")!(stdate="")!(enddate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	;i wardObj.WardLocDR=""
	;{
	;	Set qHandle=$lb(0,repid,0)
	;	Quit $$$OK
	;}
	;s locid=wardObj.WardLocDR.%Id()
	
	s locid=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	s argId=$o(^DHCINM.Arg.MgArrangeI("WardEndDate",ward,enddate,""))
	
	i locid="" {
		s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
		i $IsObject(wardObj){
			s warddesc=wardObj.WardDesc
			s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
			.s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
			.s perdr=obj.PerDr
			.q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
			.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
			.s leavedate=perobj.PerStateDate //离职或退休日期
			.q:(leavedate'="")&&(leavedate<=stdate)
			.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
			.s trsstdate=obj.PerTranStDate
			.s trsenddate=..GetTransEndDate(trsid)
			.q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
			.i (argId="")||('$d(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argId,perdr))) s able="true"
			.e  s able="false"
			.s userId=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perdr,""))
			.s isHead=##class(web.INMLoginComm).IsNurInRoleForCode(userId,"NURHEAD",+$h)
			.s isHead=$case(isHead,1:"true",:"false")
			.q:$d(tmp(perdr))
			.s tmp(perdr)="PerDR|"_perdr_"^PerName|"_perobj.PerName_"^PerID|"_perobj.PerID_"^WardDesc|"_warddesc_"^Selectable|"_able_"^IsHead|"_isHead
			.s ret=tmp(perdr)
			.d OutLocNurse
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s warddr="" f  s warddr=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",locid,warddr)) q:warddr=""  d
	.;s warddr="" f  s warddr=$O(^CF.DHCINM.DB.MgWardI("Loc",locid,warddr)) q:warddr=""  d
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(warddr)
	.q:'$IsObject(wardObj)
	.s warddesc=wardObj.WardDesc
	.s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("Dep"," "_warddr,trsid)) q:trsid=""  d
	..s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
	..s perdr=obj.PerDr
	..q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
	..s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	..s leavedate=perobj.PerStateDate //离职或退休日期
	..q:(leavedate'="")&&(leavedate<=stdate)
	..q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	..s trsstdate=obj.PerTranStDate
	..s trsenddate=..GetTransEndDate(trsid)
	..q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	..i (argId="")||('$d(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argId,perdr))) s able="true"
	..e  s able="false"
	..s userId=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perdr,""))
	..s isHead=##class(web.INMLoginComm).IsNurInRoleForCode(userId,"NURHEAD",+$h)
	..s isHead=$case(isHead,1:"true",:"false")
	..q:$d(tmp(perdr))
	..s tmp(perdr)="PerDR|"_perdr_"^PerName|"_perobj.PerName_"^PerID|"_perobj.PerID_"^WardDesc|"_warddesc_"^Selectable|"_able_"^IsHead|"_isHead
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
 	// Save QHandle
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
/// other: d ##class(%ResultSet).RunQuery("web.INMHRComm","FindHosNurse","P^2019-03-04^2019-03-04","")
Query FindHosNurse(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHosNurseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s ^TMP("FindHosNurse")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s types=$P(parr,"^",1) ;类型
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s perdr="" f  s perdr=$O(^CF.DHCINM.HR.PersonsD(perdr)) q:perdr=""  d
	.q:+perdr=0
	.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.s CodeSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(perobj.PerCategroy)
	.q:(types["P")&&($IsObject(CodeSubObj))&&(CodeSubObj.SubDesc["往届")
	.q:(types'="")&&(types'[perobj.PerTypeDR)
	.s comedate=perobj.PerComeDate
	.i perobj.PerStatus'="" d
	..s statusobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(perobj.PerStatus)
	..i statusobj.SubDesc="在职" s leavedate=""
	..e  s leavedate=perobj.PerStateDate
	.e  s leavedate=""
	.q:((stdate'="")&&(leavedate'="")&&(leavedate<stdate))||((enddate'="")&&(comedate'="")&&(enddate<comedate))
	.s pershort=##class(web.INMVueComm).ToChineseSpell(perobj.PerName)
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

/// creator: xbl
/// createdate: 20180108
/// description: 获取护士信息
/// table: CF.DHCINM.HR.Persons
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMHRComm","FindPersonList","","","",1)
Query FindPersonList(parr As %String = "", input As %String = "", qward As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPersonListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", qward As %String = "", loginID As %String = "") As %Status
{
	s ^TMP("FindPersonList")=parr_"%"_input_"%"
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
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s perdr="" f  s perdr=$O(^CF.DHCINM.HR.PersonsD(perdr)) q:perdr=""  d
	.;s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.s perObjLB=$g(^CF.DHCINM.HR.PersonsD(perdr))
	.q:perObjLB=""
	.s PerTypeDR=$lg(perObjLB,25)
	.q:PerTypeDR'="N"
	.s leavedate=$lg(perObjLB,43) //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.s perward=""
	.s:enddate'=+$H perward=..GetCurrentWard(perdr,enddate)
	.s perward="" s perward=$lg(perObjLB,10)
	.q:perward=""
	.q:'$d(^CF.DHCINM.DB.MgWardD(perward))
	.q:((isAll'=1)&&('$d(tmpWard(perward))))
	.s warddesc=$lg(^CF.DHCINM.DB.MgWardD(perward),4)
	.q:(qward'="")&&(warddesc=qward)
	.q:(ward'="")&&(perward'=ward)
	.s:perward'="" warddesc=$lg($g(^CF.DHCINM.DB.MgWardD(perward)),4)
	.q:(type'="")&&(type'=$lg(perObjLB,25))
	.;q:((ward'="")&&(perobj.PerDepDR'=ward))
	.s flag=0
	.s dutyid="" f  s dutyid=$O(^CF.DHCINM.HR.PostDutyI("ssid",perdr,dutyid)) q:dutyid=""  d
	..s dutyobj=##class(CF.DHCINM.HR.PostDuty).%OpenId(dutyid)
	..q:'$IsObject(dutyobj)
	..q:dutyobj.PostStatus'="A"
	..q:(dutyobj.PostStDate="")||(dutyobj.PostStDate>enddate)||((dutyobj.PostEndDate'="")&&(dutyobj.PostEndDate<stdate))
	..q:(dutyobj.PostDuty="")||((duty'="")&&(dutyobj.PostDuty'=duty))
	..s flag=1
	.q:(duty'="")&&(flag=0)
	.s perid=$lg(perObjLB,3)
	.i perid="" s perid=$lg(perObjLB,4)
	.s pername=$lg(perObjLB,2)
	.s pershort=##class(web.INMVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s dutydesc=$p(..GetNurseDuty(perdr,+$h),"^",2)
	.s level=$p(..GetNurseLevel(perdr,+$h),"^",2)
	.s Sex=##class(web.INMPersonComm).GetCommCode($lg(perObjLB,9))
	.s NurType=##class(web.INMPersonComm).GetCommCode($lg(perObjLB,76))
	.s ydepId=$o(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_perdr,""))
	.s yStdate=""
	.s:ydepId'="" yStdate=$lg($g(^CF.DHCINM.Trans.TransDepD(ydepId)),4)
	.s:yStdate'="" yStdate=$zd(yStdate,3)
	.
	.s ret="perdr|"_perdr_"^PerID|"_perid_"^PerName|"_pername_"^perward|"_perward_"^WardDesc|"_$g(warddesc)_"^DutyDesc|"_dutydesc_"^Level|"_level
	.s ret=ret_"^Sex|"_Sex_"^NurType|"_NurType_"^CurrentTransDate|"_yStdate_"^pershort|"_pershort_"^UserId|"_$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perdr,""))
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
/// table: CF.DHCINM.HR.Persons
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMHRComm","FindPersonList","","","冯丹")
Query FindPerInOfWardList(parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerInOfWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("parrpersonlist")=parr_"%"_input_"%"_role_"%"_nurseid
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
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	b ;11
	s perdr="" f  s perdr=$O(^CF.DHCINM.HR.PersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.q:perobj.PerTypeDR'="N"
	.s curward=##class(web.INMHRComm).GetCurrentWard(perdr,enddate)
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
	.s dutyid="" f  s dutyid=$O(^CF.DHCINM.HR.PostDutyI("ssid",perdr,dutyid)) q:dutyid=""  d
	..s dutyobj=##class(CF.DHCINM.HR.PostDuty).%OpenId(dutyid)
	..q:(dutyobj.PostStDate="")||(dutyobj.PostStDate>enddate)||((dutyobj.PostEndDate'="")&&(dutyobj.PostEndDate<stdate))
	..q:(dutyobj.PostDuty="")||((duty'="")&&(dutyobj.PostDuty'=duty))
	..s flag=1
	.q:(duty'="")&&(flag=0)
	.s perid=perobj.PerID
	.i perid="" s perid=perobj.PerNo
	.s pername=perobj.PerName
	.;q:(name'="")&&(pername'=name)
	.s pershort=##class(web.INMVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s perward=..GetCurrentWard(perdr,enddate)
	.s warddesc=""
	.i perward'="" d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perward)
	..s:$IsObject(wardObj) warddesc=wardObj.WardDesc
	.s dutydesc=$p(..GetNurseDuty(perdr,enddate),"^",2)
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

/// 获取护士某日层级
ClassMethod GetNurseLevel(loginId, date As %Date = "")
{
	s:date="" date=+$h
	s level="",stdate=date+1,levelDate=""
	f  s stdate=$o(^CF.DHCINM.HR.MgLevelI("levelA",loginId," A",stdate),-1) q:(stdate="")||(level'="")  d
	.s levelId="" f  s levelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",loginId," A",stdate,levelId)) q:(levelId="")||(level'="")  d
	..q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),6)'="A"  // 状态不是审核状态
	..q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)="" // 层级字段为空
	..s level=$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)
	..s levelDate=stdate
	q:level="" ""
	s perlevel=##class(web.INMPersonComm).GetCommCode(level) 
	q level_"^"_perlevel_"^"_levelDate
}

/// 获取护士某日职务
/// w ##class(web.INMHRComm)GetNurseDuty("7","2020-07-10")
ClassMethod GetNurseDuty(loginId As %String, date As %Date = "") As %String
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	s postduty="",stdate=date+1,dutyStDate=""
	f  s stdate=$o(^CF.DHCINM.HR.PostDutyI("PostDate",loginId,stdate),-1) q:(stdate="")||(postduty'="")  d
	.s postDutyId="" f  s postDutyId=$o(^CF.DHCINM.HR.PostDutyI("PostDate",loginId,stdate,postDutyId)) q:(postDutyId="")||(postduty'="")  d
	..q:($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),7)'="A") //状态不是审核状态
	..q:(($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),5)'="")&&($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),5)<date)) // 截止日期不为空，且截止日期小于今天
	..q:$lg(^CF.DHCINM.HR.PostDutyD(postDutyId),3)=""
	..s postduty=$lg(^CF.DHCINM.HR.PostDutyD(postDutyId),3)
	..s dutyStDate=$lg(^CF.DHCINM.HR.PostDutyD(postDutyId),4)
	q:postduty="" ""
	s dutydesc=##class(web.INMPersonComm).GetCommCode(postduty)
	q postduty_"^"_dutydesc_"^"_dutyStDate_"^"_##class(web.INMDBComm).GetCommSymbol(postduty)
}

/// 获取护士某日职称
/// w ##class(web.INMHRComm).GetNurseHireDuty("1","2017-12-10")
ClassMethod GetNurseHireDuty(loginId As %String, date As %Date = "") As %String
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	
	s dataLB="",hireDutyDate=date+1
	f  s hireDutyDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",loginId,hireDutyDate),-1) q:(hireDutyDate="")||(dataLB'="")  d
	.s hireDutyId="" f  s hireDutyId=$o(^CF.DHCINM.HR.HireDutyI("HireDate",loginId,hireDutyDate,hireDutyId)) q:(hireDutyId="")||(dataLB'="")  d
	..q:($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),8)'="A") // 状态不是审核状态
	..q:($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)'="")&&($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)<+$h) //截止日期不为空，且截止日期小于今天
	..q:$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)=""
	..s dataLB=$g(^CF.DHCINM.HR.HireDutyD(hireDutyId))
	q:$lg(dataLB,3)="" ""
	s hiredutydesc=##class(web.INMPersonComm).GetCommCode($lg(dataLB,3))
	s MajorDutydesc=##class(web.INMPersonComm).GetCommCode($lg(dataLB,9))
	q $lg(dataLB,3)_"^"_hiredutydesc_"^"_$lg(dataLB,4)_"^"_$lg(dataLB,9)_"^"_MajorDutydesc_"^"_$lg(dataLB,10)_"^"_##class(web.INMDBComm).GetCommSymbol($lg(dataLB,3))
}

/// 获取某日学历
ClassMethod GetNurseEdu(loginId As %String, date As %Date = "") As %String
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	s academic="",eduDate=date
	f  s date=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date),-1) q:(date="")||(academic'="")  d
	.s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date,eduId)) q:(eduId="")||(academic'="")  d
	..q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A") // 状态不是审核状态
	..q:($lg(^CF.DHCINM.HR.EducateD(eduId),4)'="")&&($lg(^CF.DHCINM.HR.EducateD(eduId),4)>eduDate) // 结束日期不为空且结束日期大于今天
	..q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
	..s academic=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
	q:academic="" ""
	s PerCurrentEdu=##class(web.INMPersonComm).GetCommCode(academic)
	q academic_"^"_PerCurrentEdu
}

/// 检查护士当前是否是正式且在职且已审核
ClassMethod IsFormalWorkNur(loginId As %String, date As %Date = "", AuditFlag As %String = "")
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	;s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(loginId)
	s objLB=$G(^CF.DHCINM.HR.PersonsD(loginId))
	q:objLB="" 0
	s PerTypeDR=$LG(objLB,25),PerAuditFlag=$LG(objLB,35),PerInternDate=$LG(objLB,89)
	s PerStuToNurse=$LG(objLB,100),PerAssToNurse=$LG(objLB,101),PerStateDate=$LG(objLB,43)
	s PerStatus=$LG(objLB,42)
	s PerStatusDesc=##class(web.INMPersonComm).GetCommCode(PerStatus)
	q:PerTypeDR'="N" 0
	q:((PerAuditFlag'=AuditFlag)&&(AuditFlag'="")) 0
	q:(PerInternDate'="")&&(PerInternDate>date) 0
	q:(PerStuToNurse'="")&&(PerStuToNurse>date) 0
	q:(PerAssToNurse'="")&&(PerAssToNurse>date) 0
	q:(PerStatusDesc'["在职")&&(PerStateDate'="")&&(PerStateDate<=date) 0
	q 1
}

/// 获取专科护士
ClassMethod GetNurseSpecial(loginId As %String, date As %Date = "") As %String
{
	s ret=""
	s specialId="" f  s specialId=$o(^DHCINM.Special.SpecialNurseI("Person",loginId,specialId)) q:specialId=""  d
	.s objLB=$g(^DHCINM.Special.SpecialNurseD(specialId))
	.q:objLB=""
	.s status=$lg(objLB,7)
	.q:status'="A"
	.s SpecialAuthDate=$LG(objLB,5)
	.q:((SpecialAuthDate'="")&&(date'="")&&(SpecialAuthDate>date))
	.s SpecialType=$LG(objLB,3)
	.q:SpecialType=""
	.s ret=ret_","_SpecialType
	q ret
}

/// 获取最初学历
ClassMethod GetFirstNurseEdu(loginId As %String) As %String
{
	s academic="",date="",EduDegreeDate=""
	f  s date=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date)) q:(date="")||(academic'="")  d
	.s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date,eduId)) q:(eduId="")||(academic'="")  d
	..q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A") // 状态不是审核状态
	..q:($lg(^CF.DHCINM.HR.EducateD(eduId),4)'="")&&($lg(^CF.DHCINM.HR.EducateD(eduId),4)>+$H) // 结束日期不为空且结束日期大于今天
	..q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
	..s academic=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
	..s EduDegreeDate=$lg(^CF.DHCINM.HR.EducateD(eduId),4)
	q:academic="" ""
	s PerCurrentEdu=##class(web.INMPersonComm).GetCommCode(academic)
	q academic_"^"_PerCurrentEdu_"^"_EduDegreeDate
}

/// Description: 获取病区护士统计
/// Date: 2022-03-01
/// Creator: wangpf
/// Table: 
/// Input: nurseid
/// Output: 病区护士统计
/// Other: w ##class(web.INMHRComm).GetNurSta("",0,0,"")
ClassMethod GetNurSta(ward As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmp
	s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	.q:((ward'="")&&(ward'=id))||((isAll'=1)&&('$d(tmpWard(id))))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	.s stDate=$lg(wardGlo,11)
	.s endDate=$lg(wardGlo,12)
	.q:(stDate="")||(stDate>+$h)||((endDate'="")&&(endDate<+$h))
	.s tId="" f  s tId=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_id,tId)) q:tId=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(tId))
	..s perGlo=^CF.DHCINM.HR.PersonsD(tId)
	..s perType=$lg(perGlo,25)
	..q:perType'="N"
	..s perStatus=$lg(perGlo,42)
	..q:perStatus'="17||1"
	..s tmp(id,"PerInB")=$g(tmp(id,"PerInB"))+1
	..s tmp(id,"PerInY")=$g(tmp(id,"PerInY"))+1
	..s tmp(id,"PerInHos")=$g(tmp(id,"PerInHos"))+1
	..s:$d(^DHCINM.Arg.MgArrangeSubI("PerDate",tId,+$h)) tmp(id,"PerInPos")=$g(tmp(id,"PerInPos"))+1
	w:appFlag'=1 "["
	s index=1,wardId="" f  s wardId=$o(tmp(wardId)) q:wardId=""  d
	.s wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
	.s perInB=+$g(tmp(wardId,"PerInB"))
	.s perInY=+$g(tmp(wardId,"PerInY"))
	.s perInHos=+$g(tmp(wardId,"PerInHos"))
	.s perInPos=+$g(tmp(wardId,"PerInPos"))
	.s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	.d tmpRetObj.SetAt(wardId,"Ward")
	.d tmpRetObj.SetAt(wardDesc,"WardDesc")
	.d tmpRetObj.SetAt(perInB,"PerInB")
	.d tmpRetObj.SetAt(perInY,"PerInY")
	.d tmpRetObj.SetAt(perInHos,"PerInHos")
	.d tmpRetObj.SetAt(perInPos,"PerInPos")
	.d appRet.Insert(tmpRetObj)
	.w:(appFlag'=1)&&(index>1) ","
	.w:(appFlag'=1) "{""Ward"":"""_wardId_""",""WardDesc"":"""_wardDesc_""",""PerInB"":"""_perInB_""",""PerInY"":"""_perInY_""",""PerInHos"":"""_perInHos_""",""PerInPos"":"""_perInPos_"""}"
	.s index=index+1
	w:appFlag'=1 "]"
	q:appFlag=1 appRet
	q ""
}

/// Description: 获取科室护士列表
/// Date: 2022-04-14
/// Creator: wangpf
/// Table: 
/// Input: nurseid
/// Output: 科室护士列表
/// Other: zw ##class(web.INMHRComm).GetLocNurList("1^2022-04-18^2022-04-24^")
ClassMethod GetLocNurList(parr As %String = "") As %ListOfDataTypes
{
	s appRet=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.INMHRComm:FindLocPerson")
	s sc=rs.Execute(parr)
	q:$$$ISERR(sc) appRet
	k tmp
	s index=1
	while rs.%Next(){
		s ret=rs.Data("aa")
		k tmpStr
		d ##class(web.INMVueComm).SplitStr2(ret,"^","|",.tmpStr)
		//"PerDR|"_perdr_"^PerName|"_perobj.PerName_"^PerID|"_perobj.PerID_"^WardDesc|"_warddesc_"^Selectable|"_able_"^IsHead|"_isHead
		s perId=$g(tmpStr("PerDR"))
		s perName=$g(tmpStr("PerName"))
		s perID=$g(tmpStr("PerID"))
		s wardDesc=$g(tmpStr("WardDesc"))
		s:wardDesc="" wardDesc=" "
		s able=$g(tmpStr("Selectable"))
		s isHead=$g(tmpStr("IsHead"))
		s tmpRet=##class(%ArrayOfDataTypes).%New()
		d tmpRet.SetAt(perId,"PerDR")
		d tmpRet.SetAt(perName,"PerName")
		d tmpRet.SetAt(perID,"PerID")
		d tmpRet.SetAt(wardDesc,"WardDesc")
		d tmpRet.SetAt(able,"Selectable")
		d tmpRet.SetAt(isHead,"IsHead")
		s tmp(wardDesc,index)=tmpRet
		s index=index+1
	}
	s wardDesc="" f  s wardDesc=$o(tmp(wardDesc)) q:wardDesc=""  d
	.s tmpRet=##class(%ArrayOfDataTypes).%New()
	.d tmpRet.SetAt(wardDesc,"WardDesc")
	.s tmpList=##class(%ListOfDataTypes).%New()
	.s index="" f  s index=$o(tmp(wardDesc,index)) q:index=""  d
	..d tmpList.Insert(tmp(wardDesc,index))
	.d tmpRet.SetAt(tmpList,"Nurse")
	.d appRet.Insert(tmpRet)
	q appRet
}

/// 获取某日学历
ClassMethod GetNurseEdu2(loginId As %String = "", date As %Date = "") As %String
{
	s:date="" date=+$h+1
	s:date["-" date=$zdh(date,3)
	q:loginId="" ""
	
	s academic="",eduDate=date,academic2="",academic3="",academic4=""
	f  s date=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date),-1) q:(date="")||(academic'="")  d
	.s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",loginId,date,eduId)) q:(eduId="")||(academic'="")  d
	..q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A") // 状态不是审核状态
	..;q:($lg(^CF.DHCINM.HR.EducateD(eduId),4)'="")&&($lg(^CF.DHCINM.HR.EducateD(eduId),4)>eduDate) // 结束日期不为空且结束日期大于今天
	..q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
	..s academic=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
	..s academic2=$lg(^CF.DHCINM.HR.EducateD(eduId),5)
	..s academic4=$lg(^CF.DHCINM.HR.EducateD(eduId),7)
	..s:$lg(^CF.DHCINM.HR.EducateD(eduId),11)'="" academic3=$zd($lg(^CF.DHCINM.HR.EducateD(eduId),11),3)
	q:academic="" ""
	s PerCurrentEdu=##class(web.INMPersonComm).GetCommCode(academic4)
	s PerCurrentEdu2=##class(web.INMPersonComm).GetCommCode(academic2)
	q PerCurrentEdu_"^"_PerCurrentEdu2_"^"_academic3
}

/// w ##class(web.INMHRComm).GetNurseHireDuty("1","2017-12-10")
ClassMethod GetNurseHireDuty2(loginId As %String, date As %Date = "") As %String
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	
	s dataLB="",hireDutyDate=date+1
	f  s hireDutyDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",loginId,hireDutyDate),-1) q:(hireDutyDate="")||(dataLB'="")  d
	.s hireDutyId="" f  s hireDutyId=$o(^CF.DHCINM.HR.HireDutyI("HireDate",loginId,hireDutyDate,hireDutyId)) q:(hireDutyId="")||(dataLB'="")  d
	..q:($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),8)'="A") // 状态不是审核状态
	..q:($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)'="")&&($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)<+$h) //截止日期不为空，且截止日期小于今天
	..q:$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)=""
	..s dataLB=$g(^CF.DHCINM.HR.HireDutyD(hireDutyId))
	q:$lg(dataLB,3)="" ""
	s st=$lg(dataLB,4)
	s:st'="" st=$zd(st,3)
	s end=$lg(dataLB,5)
	s:end'="" end=$zd(end,3)
	q st_"^"_end
}

/// 获取护士某日层级
ClassMethod GetNurseLevel2(loginId, date As %Date = "")
{
	s:date="" date=+$h
	s level="",stdate=date+1,levelDate=""
	f  s stdate=$o(^CF.DHCINM.HR.MgLevelI("levelA",loginId," A",stdate),-1) q:(stdate="")||(level'="")  d
	.s levelId="" f  s levelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",loginId," A",stdate,levelId)) q:(levelId="")||(level'="")  d
	..q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),6)'="A"  // 状态不是审核状态
	..q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)="" // 层级字段为空
	..s level=$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)
	..s levelDate=stdate
	q:level="" ""
	s:levelDate'="" levelDate=$zd(levelDate,3)
	q levelDate
}

}
