/// Creator：gzj
/// Description：护理人员统计、离退休汇总人员查询类
/// Date：2017-10-16
Class web.NurMgPersonCountComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:离职率初始化职称、学历tmp（不需要排序只需要数据）
/// Date:2017年12月25日 10:13:58
/// Table:DHCNMG.DB.MgSetCode，DHCNMG.DB.MgSetCodeSub，DHCNMG.DB.MgWard
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod initCountTmpBytime(type, name, warrw, tmp)
{
	if '(type["years") {
		s tmp(type,warrw,"other")=0
		s parid=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_name,0))
		s sort=0 f  s sort=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",parid,sort)) q:sort=""  d
		.s subid=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",parid,sort,0))
		.s tmp(type,warrw,parid_"||"_subid)=0
	}else {
		s tmp(type,warrw,"<1")=0
		s tmp(type,warrw,"1≤y<2")=0
		s tmp(type,warrw,"2≤y<5")=0
		s tmp(type,warrw,"5≤y<10")=0
		s tmp(type,warrw,"10≤")=0
#;		s warrw=0
#;		f  s warrw=$o(^DHCNMG.DB.MgWardD(warrw)) q:warrw=""  d
#;		.s tmp(type,warrw,"<1")=0
#;		.s tmp(type,warrw,"1≤y<2")=0
#;		.s tmp(type,warrw,"2≤y<5")=0
#;		.s tmp(type,warrw,"5≤y<10")=0
#;		.s tmp(type,warrw,"10≤")=0
	}
}

/// Creator:lulin
/// Description:保存临时数据
/// Date:2017年12月25日 10:13:58
/// Table:DHCNMG.HR.MgTransDep
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod saveTmpCountBytime(stdate, enddate, type, warrw, perid, tmp)
{
	
	if type["hireduty" {
		///职称
		s CodePreID=""
		s typeid=0,typedate=0 f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",perid,typeid)) q:typeid=""  d
		.s hireobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
		.s hs=hireobj.HireStDate
		.s he=hireobj.HireDuty
		.q:hireobj.HireStatus'="A"
		.i ('((hireobj.HireEndDate'=""&&hireobj.HireEndDate<stdate)||hireobj.HireStDate>enddate))&&(hireobj.HireStDate>typedate) s typedate=hireobj.HireStDate,CodePreID=hireobj.HireDuty
		i CodePreID="" s CodePreID="other"
		;s tmp(type,0,CodePreID)=tmp(type,0,CodePreID)+1
		s tmp(type,warrw,CodePreID)=tmp(type,warrw,CodePreID)+1
	}elseif type["degree" {
		///学历
		s CodePreID=""
		s typeid=0,typedate=0 f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",perid,typeid)) q:typeid=""  d
		.s degreeobj=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
		.q:degreeobj.EduStatus'="A"
		.i (degreeobj.EduStDate<=enddate)&&(degreeobj.EduStDate>typedate) s typedate=degreeobj.EduStDate,CodePreID=degreeobj.EduAcademic
		i CodePreID="" s CodePreID="other"
		;s tmp(type,0,CodePreID)=tmp(type,0,CodePreID)+1
		s tmp(type,warrw,CodePreID)=tmp(type,warrw,CodePreID)+1
	}elseif type["years"{
		///年限;时间段是离职的使用，取变更状态(离职)时间
		s per=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
		s workstdate=per.PerWorkDate
		i stdate=enddate s workenddate=stdate 
		e  s workenddate=per.PerStateDate
		i workstdate="" s workstdate=workenddate
		s years=$p(##class(web.NurMgVueComm).CalAge($zd(workstdate,3),$zd(workenddate,3))," ")
		s years=$e(years,0,($l(years)-1))
		i years<1 s tmp(type,warrw,"<1")=tmp(type,warrw,"<1")+1
		i (years>=1)&&(years<2) s tmp(type,warrw,"1≤y<2")=tmp(type,warrw,"1≤y<2")+1
		i (years>=2)&&(years<5) s tmp(type,warrw,"2≤y<5")=tmp(type,warrw,"2≤y<5")+1
		i (years>=5)&&(years<10) s tmp(type,warrw,"5≤y<10")=tmp(type,warrw,"5≤y<10")+1
		i (years>=10) s tmp(type,warrw,"10≤")=tmp(type,warrw,"10≤")+1
	}
}

/// Creator:lulin
/// Description:离职率获取病区人员
/// Date:2017年12月22日 15:36:44
/// Table:DHCNMG.HR.MgTransDep
/// Input:病区id，开始日期，结束日期
/// Output：
/// Return:
/// Others:
ClassMethod GetTmpCountBytime(stdate, enddate, type, ward, tmp)
{
	q:(stdate="")||(enddate="")
	s tmp("num")=0
	s wardids=0 f  s wardids=$o(^DHCNMG.HR.MgTransDepI("Dep",wardids)) q:wardids=""  d
	.q:(type'="table")&&(ward'=0)&&($tr(wardids," ","")'=ward)
	.s wardid=$tr(wardids," ","")
	.i type="table" d
	..i '$d(tmp("table",wardid,"StNum")) s tmp("table",wardid,"StNum")=0
	..i '$d(tmp("table",wardid,"EndNum")) s tmp("table",wardid,"EndNum")=0
	..i '$d(tmp("table",wardid,"NewNum")) s tmp("table",wardid,"NewNum")=0
	..i '$d(tmp("table",wardid,"ResignNum")) s tmp("table",wardid,"ResignNum")=0
	..i '$d(tmp("table",wardid,"TransinNum")) s tmp("table",wardid,"TransinNum")=0
	..i '$d(tmp("table",wardid,"TransoutNum")) s tmp("table",wardid,"TransoutNum")=0
	..i '$d(tmp("table",0,"TransoutNum")) s tmp("table",0,"TransoutNum")=0
	..i '$d(tmp("table",0,"TransinNum")) s tmp("table",0,"TransinNum")=0
	..i '$d(tmp("table",0,"ResignNum")) s tmp("table",0,"ResignNum")=0
	..i '$d(tmp("table",0,"NewNum")) s tmp("table",0,"NewNum")=0
	..i '$d(tmp("table",0,"StNum")) s tmp("table",0,"StNum")=0
	..i '$d(tmp("table",0,"EndNum")) s tmp("table",0,"EndNum")=0
	.s transid=0 f  s transid=$o(^DHCNMG.HR.MgTransDepI("Dep",wardids,transid)) q:transid=""  d
	..s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(transid)
	..s per=##class(DHCNMG.HR.MgPersons).%OpenId(obj.PerDr)
	..s perApp=##class(DHCNMG.HR.MgTransApp).%OpenId(obj.PerAppID)
	..q:(($IsObject(perApp))&&(perApp.TransStatus'="A"))
	..q:'$IsObject(per)
	..s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(per.PerStatus)
	..s status=""
	..i statusobj'="" s status=statusobj.SubDesc
	..;期初人数。
	..i ((status="在职")||(per.PerStateDate>=stdate))&&(stdate>=obj.PerTranStDate)&&((obj.PerTranEndDate="")||((obj.PerTranEndDate>stdate)||(per.PerStateDate=obj.PerTranEndDate)))  d
	...i type="table"  d
 	....s tmp("table",wardid,"StNum")=$g(tmp("table",wardid,"StNum"))+1
	....s tmp("table",0,"StNum")=$g(tmp("table",0,"StNum"))+1
	...e  i type["st" d ..saveTmpCountBytime(stdate,stdate,type,ward,obj.PerDr,.tmp)
	..;期末人数
	..i ((status="在职")||(per.PerStateDate>=enddate))&&(enddate>=obj.PerTranStDate)&((obj.PerTranEndDate="")||((obj.PerTranEndDate>enddate)||(per.PerStateDate=obj.PerTranEndDate)))  d
	...i type="table"  d
	....s tmp("table",wardid,"EndNum")=$g(tmp("table",wardid,"EndNum"))+1
	....s tmp("table",0,"EndNum")=$g(tmp("table",0,"EndNum"))+1
	...e  i type["end"  d ..saveTmpCountBytime(enddate,enddate,type,ward,obj.PerDr,.tmp)
	..;新增人数、转入人数
	..i (type="table")&&(obj.PerTranStDate>stdate)&&(obj.PerTranStDate<=enddate) d
	...i ($o(^DHCNMG.HR.MgTransDepI("ssdr"," "_obj.PerDr,transid),-1)="") d
	....s tmp("table",wardid,"NewNum")=$g(tmp("table",wardid,"NewNum"))+1,tmp("table",0,"NewNum")=$g(tmp("table",0,"NewNum"))+1
	...e  s tmp("table",wardid,"TransinNum")=$g(tmp("table",wardid,"TransinNum"))+1,tmp("table",0,"TransinNum")=$g(tmp("table",0,"TransinNum"))+1
	..;出科人数
	..i (type="table")&&(obj.PerTranEndDate'="")&&(obj.PerTranEndDate>stdate)&&(obj.PerTranEndDate<=enddate) d
	...s tmp("table",wardid,"TransoutNum")=$g(tmp("table",wardid,"TransoutNum"))+1,tmp("table",0,"TransoutNum")=$g(tmp("table",0,"TransoutNum"))+1
	..;离职人数
	..i (status="离职")&&(per.PerStateDate>=stdate)&&(per.PerStateDate<=enddate) d
	...i type="table"  d
	....s tmp("table",wardid,"ResignNum")=$g(tmp("table",wardid,"ResignNum"))+1
	....s tmp("table",0,"ResignNum")=$g(tmp("table",0,"ResignNum"))+1
	...e  i type["resign"  d ..saveTmpCountBytime(stdate,enddate,type,ward,obj.PerDr,.tmp)
}

/// Creator:lulin
/// Description:获取病区人员
/// Date:2017年12月23日 14:44:56
/// Table:DHCNMG.HR.MgTransDep
/// Input:病区id(全院为0)，开始日期，结束日期,类型
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgPersonCountComm).getCountByTime("0^2017-11-22^2017-12-22^sthireduty")
ClassMethod getCountByTime(parr As %String = "")
{
		k tmp
		s ward=$p(parr,"^")
		s stdate=$p(parr,"^",2)
		s:stdate["-" stdate=$zdh(stdate,3)
		s enddate=$p(parr,"^",3)
		s:enddate["-" enddate=$zdh(enddate,3)
		s type=$p(parr,"^",4)
		q:type="" ""
		q:ward="" ""
		s typename=""
		i type["hireduty" d ..initCountTmpBytime(type,"聘任职称",ward,.tmp)
		i type["degree"  d ..initCountTmpBytime(type,"学历",ward,.tmp)
		i type["years" d ..initCountTmpBytime(type,"年资",ward,.tmp)
		d ..GetTmpCountBytime(stdate,enddate,type,ward,.tmp)
		s sub=""
		s ret="" //数据
		f  s sub=$o(tmp(type,ward,sub)) q:sub=""  d
		.s name=sub
		.i name="other" s name="未定义"
		.s data=tmp(type,ward,sub)
		.i type["years" s ret=ret_"{""name"":"""_name_"年资"",""value"":"_data_"},"
		.e  d
		..s color="#000"
		..i sub'="other"  d
		...s a=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(sub)
		...s name=a.SubDesc
		...i a.SubRemark'="" s color=a.SubRemark
		..s ret=ret_"{""name"":"""_name_""",""value"":"_data_",""color"":"""_color_"""},"
		i ret'="" s ret="["_ret_"]"
		q ret
}

/// Creator:lulin
/// Description:离职率列表获取病区人员
/// Date:2017年12月23日 14:44:56
/// Table:DHCNMG.HR.MgTransDep
/// Input:病区id，开始日期，结束日期
/// Output：
/// Return:
/// Others:d ##class(%ResultSet).RunQuery("web.NurMgPersonCountComm","FindWardPersonCountBytime","^2017-11-22^2017-12-22")
Query FindWardPersonCountBytime(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardPersonCountBytimeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="" //数据
	k tmp
	s ward=$p(parr,"^")
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	d ..GetTmpCountBytime(stdate,enddate,"table",0,.tmp)
	s index=0
	s type="table"
	f i=1:1:$l(ward,",")
	{
		s wardstr=$p(ward,",",i)
		s wardid="" f  s wardid=$o(tmp(type,wardid)) q:wardid=""  d
		.q:(ward'="")&&(wardid'=wardstr)
		.i wardid'=0 d
		..s objw=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
		..q:'$IsObject(objw)
		..s WardCode=objw.WardCode
		..s WardDesc=objw.WardDesc
		.e  s WardCode="全院",WardDesc="全院"
		.s StNum=tmp(type,wardid,"StNum")
		.s NewNum=tmp(type,wardid,"NewNum")
		.s ResignNum=tmp(type,wardid,"ResignNum")
		.s EndNum=tmp(type,wardid,"EndNum")
		.s ResignD=(StNum+EndNum)/2
		.i ResignD'=0  d
		..s ResignRate=+$fn(ResignNum/ResignD,"",3)
		..i $p(ResignRate,".")="" s ResignRate="0"_ResignRate
		.e  s ResignRate=0
		.s TransinNum=tmp(type,wardid,"TransinNum")
		.s TransoutNum=tmp(type,wardid,"TransoutNum")
		.s rw=wardid
		.;s sub=sub_"{""WardCode"":"""_WardCode_""",""WardDesc"":"""_WardDesc_""",""StNum"":"""_StNum_""",""NewNum"":"""_NewNum_""",""ResignNum"":"""_ResignNum_""",""EndNum"":"""_EndNum_""",""ResignRate"":"""_ResignRate_""",""rw"":"""_rw_"""},"
		.s ret="WardCode|"_WardCode_"^WardDesc|"_WardDesc_"^StNum|"_StNum_"^NewNum|"_NewNum_"^ResignNum|"_ResignNum_"^ResignRate|"_ResignRate_"^EndNum|"_EndNum_"^TransinNum|"_TransinNum_"^TransoutNum|"_TransoutNum_"^rw|"_rw
		.d OutCountData
	}
	k tmp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPersonCountBytimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPersonCountBytimeExecute ]
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

ClassMethod FindWardPersonCountBytimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPersonCountBytimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:一览表表格获取病区人员
/// Date:2017-10-24
/// Table:DHCNMG.HR.MgPersons
/// Input:病区id、用户id
/// Output：
/// Return:
/// Others:w ##class(web.NurMgPersonCountComm).FindWardPersonCount("^^","4","0","0")
ClassMethod FindWardPersonCount(parr As %String = "", ordertype As %String = "0", role As %String, nurseid As %String)
{
	k tmpperson
	s prw=0
	s hiredutydr=$p(parr,"^")
	s selectid=$p(parr,"^",2) //病区、科室、片区id
	s selectsex=$p(parr,"^",3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	f  s prw=$o(^DHCNMG.HR.MgPersonsD(prw)) q:prw=""  d
	.s Obj=##class(DHCNMG.HR.MgPersons).%OpenId(prw)
	.q:Obj.PerTypeDR'="N"
	.q:Obj.PerCareType'="N"
	.q:Obj.PerAuditFlag'="Y"
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Obj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.s name=Obj.PerName
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(prw,+$h)
	.s curward=Obj.PerDepDR
	.q:curward=""
	.s warrw=curward
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s perSex=##class(web.NurMgPersonComm).GetCommCode(Obj.PerSexDR)
	.q:((selectsex'="")&&(perSex'[selectsex))
	.;职称统计
	.s hiredutyCode="other2"
	.s color="#000"
	.s typedate=0
	.s typeid=0
	.s type="hireduty"
	.f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s Perobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	..q:Perobj.HireStatus'="A"
	..q:(Perobj.HireEndDate'="")&&(Perobj.HireEndDate<+$H)
	..i Perobj.HireStDate>typedate s typedate=Perobj.HireStDate,hiredutyCode=Perobj.HireDuty
	.q:(hiredutydr'="")&(hiredutydr'=hiredutyCode) //在这里可以让过滤掉病区无人的病区数据
	.i hiredutyCode="" s hiredutyCode="other2"
	.i hiredutyCode'="other2" d
	..s a=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(hiredutyCode)
	..i a.SubRemark'="" s color=a.SubRemark
	.;职务统计
	.s headname=""
	.s typedate=0
	.s typeid=0
	.s type="postduty"
	.f  s typeid=$o(^DHCNMG.HR.MgPostDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s Perobj2=##class(DHCNMG.HR.MgPostDuty).%OpenId(typeid)
	..q:Perobj2.PostStatus'="A"
	..q:(Perobj2.PostEndDate'="")&&(Perobj2.PostEndDate<+$H)
	..i Perobj2.PostStDate>typedate s typedate=Perobj2.PostStDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj2.PostDuty)
	.s isheadnurse=1
	.i headname'="护士长" s isheadnurse=2
	.s sex=##class(web.NurMgPersonComm).GetCommCode(Obj.PerSexDR)
	.i sex["男" s sex="♂"
	.e  s sex=""
	.;人员
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(warrw)
	.s order="zzwubingqu",warrw="无对应",warrwdesc="无对应",select="无对应"
	.i $IsObject(wardobj) d
	..i (ordertype="0")||(ordertype="3")||(selectid'="") d //病区:默认、按简拼
	...s order=wardobj.WardSort
	...s warrw=wardobj.%Id()
	...s warrwdesc=wardobj.WardDesc
	...i (ordertype="3") d
	....s order=wardobj.WardSpell
	....i order="" s order="zzzz"
	..i (ordertype="2")&&($IsObject(wardobj.WardAreaDR)) d //片区
	...s select=wardobj.WardAreaDR.%Id()
	...i selectid="" d
	....s order=wardobj.WardAreaDR.AreaCode
	....s warrw=wardobj.WardAreaDR.%Id()
	....s warrwdesc=wardobj.WardAreaDR.AreaDesc
	..i (ordertype="4")&&$IsObject(wardobj.WardTypeDR) d
	...s select=wardobj.WardTypeDR.%Id()
	...i selectid="" d
	....s order=wardobj.WardTypeDR.SubCode
	....s warrw=wardobj.WardTypeDR.%Id()
	....s warrwdesc=wardobj.WardTypeDR.SubDesc
	.s locFlag=..isLocWard(Obj.PerDepDR)
	.i (ordertype="1")&&(locFlag'="") d //科室
	..s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(locFlag)
	..i $IsObject(locObj) d
	...s select=locFlag 
	...i selectid="" d
	....s order=locObj.LocCode
	....s warrw=locFlag
	....s warrwdesc=locObj.LocDesc
	.q:(selectid'="")&&(selectid'=select)
	.s tmpperson(order,warrw)=warrwdesc
	.s tmpperson(order,warrw,isheadnurse,prw)=name_sex_"!"_color
	;数据输出
	s ret=""
	w "["
	s n=1
	s order="" f  s order=$o(tmpperson(order)) q:order=""  d
	.s warrw=0 f  s warrw=$o(tmpperson(order,warrw)) q:warrw=""  d
	..s warrwname=tmpperson(order,warrw)
	..s nurse=""
	..s isheadnurse="" f  s isheadnurse=$o(tmpperson(order,warrw,isheadnurse)) q:isheadnurse=""  d
	...s perdr="" f  s perdr=$o(tmpperson(order,warrw,isheadnurse,perdr)) q:perdr=""  d
	....s:nurse'="" nurse=nurse_","_"'"_tmpperson(order,warrw,isheadnurse,perdr)_"'"
	....s:nurse="" nurse="'"_tmpperson(order,warrw,isheadnurse,perdr)_"'"
	..;i ret'="" s ret=ret_",{""id"":"""_warrw_""",""name"":"""_warrwname_""",""nurse"":["_nurse_"]}"
	..;i ret="" s ret="{""id"":"""_warrw_""",""name"":"""_warrwname_""",""nurse"":["_nurse_"]}"
	..i n=1 w "{""id"":"""_warrw_""",""name"":"""_warrwname_""",""nurse"":""["_nurse_"]""}"
	..e  w ",{""id"":"""_warrw_""",""name"":"""_warrwname_""",""nurse"":""["_nurse_"]""}"
	..s n=n+1
	;i ret'="" s ret="["_ret_"]"
	;w ret
	w "]"
	q ""
}

ClassMethod isLocWard(wardId As %String) As %String
{
	q:wardId="" ""
	s LocId=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",wardId,""))
	q:LocId="" ""
	q LocId
}

/// 初始化职务、职称、学历tmp
ClassMethod initCountTmp(type, name, id, tmp)
{
	s tmp(type,id,"name","other2",1)="other2"
	s tmp(type,id,"data","other2",1)=0
	s parid=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_name,0))
	s sort=0 f  s sort=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",parid,sort)) q:sort=""  d
	.s subid=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",parid,sort,0))
	.s tmp(type,id,"name",parid,sort)=parid_"||"_subid
	.s tmp(type,id,"data",parid,sort)=0
}

/// 保存tmp数据
ClassMethod SaveCountTmp(id, type, warrw, tmp)
{
	s CodeSort=1
	i id'="" d
	.s CodeSub=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(id)
	.s id=CodeSub.Parref.%Id()
	.s CodeSort=CodeSub.SubSort
	i id="" s id="other2"
	s tmp(type,warrw,"data",id,CodeSort)=tmp(type,warrw,"data",id,CodeSort)+1
	//s tmp(type,"all","data",id,CodeSort)=tmp(type,"all","data",id,CodeSort)+1
}

/// Creator:lulin
/// Description:一览表顶部数据获取总数据：职务、职称、学历、年龄
/// Date:2017-10-17
/// Table:DHCNMG.HR.MgPersons
/// Input:病区id；全院为all
/// Output：
/// Return:
/// Others:w ##class(web.NurMgPersonCountComm).FindCount("all^3^女","0","0")
ClassMethod FindCount(parr As %String = "all", role As %String, nurseid As %String)
{
	k tmp
	s selectid=$p(parr,"^")
	s selecttype=$p(parr,"^",2)
	s selectsex=$p(parr,"^",3)
	s prw=0
	d ..initCountTmp("hireduty","聘任职称",selectid,.tmp)
	d ..initCountTmp("postduty","职务",selectid,.tmp)
	d ..initCountTmp("degree","学历",selectid,.tmp)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	f  s prw=$o(^DHCNMG.HR.MgPersonsD(prw)) q:prw=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(prw)
	.q:'$IsObject(perObj)
	.q:perObj.PerCareType'="N" ;只统计护士
	.q:perObj.PerTypeDR'="N" ;只统计正式
	.q:perObj.PerAuditFlag'="Y"
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(prw,+$h)
	.s curward=perObj.PerDepDR
	.q:curward=""
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s perSex=##class(web.NurMgPersonComm).GetCommCode(perObj.PerSexDR)
	.q:(selectsex'="")&&((perSex="")||(perSex'[selectsex))
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perObj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.s name=perObj.PerName
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(perObj.PerDepDR)
	.s select="无对应"
	.i ((selecttype="0")||(selecttype="3"))&&($IsObject(wardObj)) s select=perObj.PerDepDR
	.i (selecttype="1") s select=perObj.PerLocDR
	.i (selecttype="2")&&($IsObject(wardObj))&&($IsObject(wardObj.WardAreaDR)) s select=wardObj.WardAreaDR.%Id()
	.i (selecttype="4")&&($IsObject(wardObj))&&($IsObject(wardObj.WardTypeDR)) s select=wardObj.WardTypeDR.%Id()
	.q:(selectid'="all")&&(selectid'=select)
	.s warrw=selectid
	.;职称统计
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s hireobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	..q:hireobj.HireStatus'="A"
	..q:(hireobj.HireEndDate'="")&&(hireobj.HireEndDate<+$H)
	..i hireobj.HireStDate>typedate s typedate=hireobj.HireStDate,CodePreID=hireobj.HireDuty
	.d ..SaveCountTmp(CodePreID,"hireduty",warrw,.tmp)
	.;职务统计
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^DHCNMG.HR.MgPostDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s postobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(typeid)
	..q:postobj.PostStatus'="A"
	..q:(postobj.PostEndDate'="")&&(postobj.PostEndDate<+$H)
	..i postobj.PostStDate>typedate s typedate=postobj.PostStDate,CodePreID=postobj.PostDuty
	.d ..SaveCountTmp(CodePreID,"postduty",warrw,.tmp)
	.;学历
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",prw,typeid)) q:typeid=""  d
	..s degreeobj=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
	..q:degreeobj.EduStatus'="A"
	..i degreeobj.EduStDate>typedate s typedate=degreeobj.EduStDate,CodePreID=degreeobj.EduAcademic
	.d ..SaveCountTmp(CodePreID,"degree",warrw,.tmp)
	.;年龄
	.i $d(tmp("years",warrw,"name",10,1))=0 s tmp("years",warrw,"name",10,1)="20岁以下",tmp("years",warrw,"data",10,1)=0
	.i $d(tmp("years",warrw,"name",20,1))=0 s tmp("years",warrw,"name",20,1)="20-30岁",tmp("years",warrw,"data",20,1)=0
	.i $d(tmp("years",warrw,"name",30,1))=0 s tmp("years",warrw,"name",30,1)="30-40岁",tmp("years",warrw,"data",30,1)=0
	.i $d(tmp("years",warrw,"name",40,1))=0 s tmp("years",warrw,"name",40,1)="40-50岁",tmp("years",warrw,"data",40,1)=0
	.i $d(tmp("years",warrw,"name",50,1))=0 s tmp("years",warrw,"name",50,1)="50-55岁",tmp("years",warrw,"data",50,1)=0
	.i $d(tmp("years",warrw,"name",60,1))=0 s tmp("years",warrw,"name",60,1)="55岁以上",tmp("years",warrw,"data",60,1)=0
	.s type="years"
	.s day=$p($NOW(),",")-$lg(^DHCNMG.HR.MgPersonsD(prw),6)
	.s years=day\(30*12)
	.s yearRange=(years\10)*10
	.i years<20 s yearRange=10
	.i years>55 s yearRange=60
	.s tmp(type,warrw,"data",yearRange,1)=tmp(type,warrw,"data",yearRange,1)+1
	;数据输出
	s type=""
	s ret="" 
	s total=0
	f  s type=$o(tmp(type)) q:type=""  d
	.s ret2=""
	.s CodeId=0 f  s CodeId=$o(tmp(type,selectid,"name",CodeId)) q:CodeId=""  d
	..s CodeSort=0 f  s CodeSort=$o(tmp(type,selectid,"name",CodeId,CodeSort)) q:CodeSort=""  d
	...s CodeSubId=tmp(type,selectid,"name",CodeId,CodeSort) 
	...s data=tmp(type,selectid,"data",CodeId,CodeSort) 
	...q:(type'="years")&&(type'="degree")&&(data=0)
	...s:type="hireduty" total=total+data
	...s Codedesc=CodeSubId
	...i ((type'="hireduty")&(type'="years")&(CodeSubId'="other2")) s Codedesc=##class(web.NurMgPersonComm).GetCommCode(CodeSubId)
	...i CodeSubId="other2" s Codedesc="未定义"
	...i (type="years")  d 
	....i ret2="" s ret2="{""name"":"""_Codedesc_""",""data"":"""_data_"""}"
	....e  s ret2=ret2_",{""name"":"""_Codedesc_""",""data"":"""_data_"""}"
	...i (type'="years")  d
	....s color="#000" //非年龄颜色特殊处理
	....i (CodeSubId'="other2") d
	.....s a=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(CodeSubId)
	.....s color=a.SubRemark
	.....s Codedesc=a.SubDesc
	....i ret2="" s ret2="{""name"":"""_Codedesc_""",""data"":"""_data_""",""id"":"""_CodeSubId_""",""color"":"""_color_"""}"
	....e  s ret2=ret2_",{""name"":"""_Codedesc_""",""data"":"""_data_""",""id"":"""_CodeSubId_""",""color"":"""_color_"""}"
	.i ret="" s ret=""""_type_""":["_ret2_"]"
	.e  s ret=ret_","""_type_""":["_ret2_"]"
	i ret'="" s ret="{""total"":"""_total_""",""data"":{"_ret_"}}"
	q ret
}

/// 下列老系统实现方式暂时未用
/// Creator:lulin
/// Description:查询统计数据表格表头
/// Date:2017-10-17
/// Table:DHCNMG.HR.MgPersons
/// Input:病区id、用户id
/// Output：
/// Return:
/// Others:d ##class(web.NurMgPersonCountComm).FindTableHead("PerWordType^0")
ClassMethod FindTableHead(parr As %String = "")
{
	
	q:parr=""
	k tmp
	s datatype=$p(parr,"^")
	s dataother=$p(parr,"^",2) //是否是必填,
	;性别统计
	if dataother {
		if datatype="sex" {
			s headcode=$o(^DHCNMG.DB.MgSetCodeI("Code"," 性别",0))
			s headcodesubrw=0
			f  s headcodesubrw=$o(^DHCNMG.DB.MgSetCodeSubD(headcode,headcodesubrw)) q:headcodesubrw=""  d
			.s headname=$lg(^DHCNMG.DB.MgSetCodeSubD(headcode,headcodesubrw),3)
			.s tmp("head",headcode_"||"_headcodesubrw)=headname
		}
		if datatype="PerYear"{
			s tmp("head",1)="1年以内"
			s tmp("head",5)="1-5年"
			s tmp("head",10)="5-10年"
			s tmp("head",15)="10-15年"
			s tmp("head",20)="15-20年"
			s tmp("head",21)="20年以上"
		}
		if datatype="years"{
			s tmp("head",19)="20岁以内"
			s tmp("head",20)="20-30岁"
			s tmp("head",30)="30-40岁"
			s tmp("head",40)="40-50岁"
			s tmp("head",50)="50-60岁"
			s tmp("head",60)="60岁以上"
		}
	}else{
		s NurseDep=""
		;循环病区
		f  s NurseDep=$o(^DHCNMG.DB.MgWardI("Code",NurseDep)) q:NurseDep=""  d 
		.s warrw=0
		.;病区id
		.f  s warrw=$o(^DHCNMG.DB.MgWardI("Code",NurseDep,warrw)) q:warrw=""  d 
		..s prw=0 //personrw
		..;循环每个病人，区分统计数据类型，获取统计数据
		..f  s prw=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_warrw,prw)) q:prw=""  d 
		...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(prw)
		...q:(obj.PerTypeDR'="N")
		...;q:(obj.PerStatus'="17||1") //只统计在职
		...;根据参数不同统计不同类型数据
		...;工作科室统计
		...i datatype="PerWordType" d
		....i obj.PerWordType'="" d
		.....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerWordType)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;工作层级统计
		...i datatype="level" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^DHCNMG.HR.MgLevelI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj=##class(DHCNMG.HR.MgLevel).%OpenId(typeid)
		.....i Perobj.LevelDate>typedate s typedate=Perobj.LevelDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj.NurLevel)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;聘任职称统计
		...i datatype="hireduty" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
		.....i Perobj.HireStDate>typedate s typedate=Perobj.HireStDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj.HireDuty)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;职务统计
		...i datatype="postduty" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^DHCNMG.HR.MgPostDutyI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj2=##class(DHCNMG.HR.MgPostDuty).%OpenId(typeid)
		.....i Perobj2.PostStDate>typedate s typedate=Perobj2.PostStDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj2.PostDuty)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;男护士衣号
		...i datatype="boyCloth" d
		....q:obj.PerSexDR'="6||1"
		....i obj.PerClothesNo'="" d
		.....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerClothesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;男护士鞋号
		...i datatype="boyShoes" d
		....q:obj.PerSexDR'="6||1"
		....i obj.PerShoesNo'="" d
		.....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerShoesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;女护士衣号
		...i datatype="girlCloth" d
		....q:obj.PerSexDR'="6||2"
		....i obj.PerClothesNo'="" d
		.....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerClothesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;女护士鞋号
		...i datatype="girlShoes" d
		....q:obj.PerSexDR'="6||2"
		....i obj.PerShoesNo'="" d
		.....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerShoesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;学历统计
		...i datatype="Academic" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj3=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
		.....i Perobj3.EduStDate>typedate s typedate=Perobj3.EduStDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj3.EduAcademic)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;学位统计
		...i datatype="Degree" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj3=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
		.....q:Perobj3.EduDegree="" 
		.....i Perobj3.EduStDate>typedate s typedate=Perobj3.EduStDate,headname=##class(web.NurMgPersonComm).GetCommCode(Perobj3.EduDegree)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		
		
		
		
		;其他
		s tmp("head","other2")="其他"
	}
	
	
	///数据传出
	s header=""
	s headerid=0
	//表头
	f  s header=$o(tmp("head",header)) q:header=""  d
	.i headerid=0 s ret=tmp("head",header)_"|"_tmp("head",header)
	.e  s ret=ret_"^"_tmp("head",header)_"|"_tmp("head",header)
	.s headerid=headerid+1
	i ret'="" s ret=ret_"^"_"total|总计"
	k tmp 
	q ret
}

/// 临时参数保存
ClassMethod saveTmp(headname As %String = "", warrw, tmp)
{
	;全院数据
	i (headname'="")&($d(tmp("head"," "_headname))'=0) s tmp("data"," "_headname)=tmp("data"," "_headname)+1
	i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname,tmp("data"," "_headname)=1
	i (headname="")&($d(tmp("head","other2"))'=0) s tmp("data","other2")=tmp("data","other2")+1
	i (headname="")&($d(tmp("head","other2"))=0) s tmp("head","other2")="其他",tmp("data","other2")=1
	;病区数据
	i (headname'="")&($d(tmp("headwr",warrw," "_headname))'=0) s tmp("datawr",warrw," "_headname)=tmp("datawr",warrw," "_headname)+1
	i (headname'="")&($d(tmp("headwr",warrw," "_headname))=0) s tmp("headwr",warrw," "_headname)=headname,tmp("datawr",warrw," "_headname)=1
	i (headname="")&($d(tmp("headwr",warrw,"other2"))'=0) s tmp("datawr",warrw,"other2")=tmp("datawr",warrw,"other2")+1
	i (headname="")&($d(tmp("headwr",warrw,"other2"))=0) s tmp("headwr",warrw,"other2")="其他",tmp("datawr",warrw,"other2")=1
}

/// Creator:lulin
/// Description:查询人员列表
/// Date:2017-10-16
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonCountComm","FindPersonsCount","PerWordType")
/// Info:修改代码注意同时修改FindTableHead，两者在tmp("head",header)要保持一直
Query FindPersonsCount(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

/// level：层级分布、PerCareType：工作科室、工作类别、工作年限、聘任职称、平均年龄、性别
/// 职务、种类、男护士鞋号、男护士医号、女护士鞋号、女护士医号、护士学历
ClassMethod FindPersonsCountExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="" //数据
	k tmp
	s NurseDep=""
	;循环病区
	f  s NurseDep=$o(^DHCNMG.DB.MgWardI("Code",NurseDep)) q:NurseDep=""  d 
	.s warrw=0
	.;病区id
	.f  s warrw=$o(^DHCNMG.DB.MgWardI("Code",NurseDep,warrw)) q:warrw=""  d 
	..s prw=0 //personrw
	..;循环每个病人，区分统计数据类型，获取统计数据
	..f  s prw=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_warrw,prw)) q:prw=""  d 
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(prw)
	...q:(obj.PerTypeDR'="N") //只统计护士
	...;q:(obj.PerStatus'="17||1") //只统计在职
	...;护士成员姓名保存
	...s CnurseName=1
	...i (parr="boyCloth")&(obj.PerSexDR'="6||1") s CnurseName=0
	...i (parr="boyShoes")&(obj.PerSexDR'="6||1") s CnurseName=0
	...i (parr="girlCloth")&(obj.PerSexDR'="6||2") s CnurseName=0
	...i (parr="girlShoes")&(obj.PerSexDR'="6||2") s CnurseName=0
	...i (obj.PerCareType="N")&(CnurseName=1) d 
	....i $d(tmp("nurseName")) s tmp("nurseName")=tmp("nurseName")_","_obj.PerName
	....e  s tmp("nurseName")=obj.PerName
	....i $d(tmp("nurseName",warrw)) s tmp("nurseName",warrw)=tmp("nurseName",warrw)_","_obj.PerName
	....e  s tmp("nurseName",warrw)=obj.PerName
	
	...;根据参数不同统计不同类型数据，全院数据和护理单元分别统计
	...s headname=""
	...;-------工作层级统计
	...i parr="level" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^DHCNMG.HR.MgLevelI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj=##class(DHCNMG.HR.MgLevel).%OpenId(typeid)
	.....s PerobjCode=Perobj.NurLevel
	.....s PerobjDate=Perobj.LevelDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.NurMgPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------工作职称统计
	...i parr="hireduty" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj2=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	.....s PerobjCode=Perobj2.HireDuty
	.....s PerobjDate=Perobj2.HireStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.NurMgPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------工作职务统计
	...i parr="postduty" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^DHCNMG.HR.MgPostDutyI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj3=##class(DHCNMG.HR.MgPostDuty).%OpenId(typeid)
	.....s PerobjCode=Perobj3.PostDuty
	.....s PerobjDate=Perobj3.PostStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.NurMgPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------学历统计
	...i parr="Academic" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj4=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
	.....s PerobjCode=Perobj4.EduAcademic
	.....s PerobjDate=Perobj4.EduStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.NurMgPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------学位统计
	...i parr="Degree" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^DHCNMG.HR.MgEducateI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj4=##class(DHCNMG.HR.MgEducate).%OpenId(typeid)
	.....s PerobjCode=Perobj4.EduDegree
	.....s PerobjDate=Perobj4.EduStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.NurMgPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	
	...;-------工作科室统计
	...i parr="PerWordType" d
	....i obj.PerWordType'="" s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerWordType)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------男护士衣号统计
	...i parr="boyCloth" d
	....q:obj.PerSexDR'="6||1"
	....i obj.PerClothesNo'="" s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerClothesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------男护士鞋号统计
	...i parr="boyShoes" d
	....q:obj.PerSexDR'="6||1"
	....i obj.PerShoesNo'="" s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerShoesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------女护士衣号统计
	...i parr="girlCloth" d
	....q:obj.PerSexDR'="6||2"
	....i obj.PerClothesNo'="" s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerClothesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------女护士鞋号统计
	...i parr="girlShoes" d
	....q:obj.PerSexDR'="6||2"
	....i obj.PerShoesNo'="" s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerShoesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	
	...;-------性别统计
	...i parr="sex" d
	....s headname=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------年龄统计
	...i parr="years" d
	....i $d(tmp("head",10))=0 s tmp("head",10)="20岁以内",tmp("data",10)=0
	....i $d(tmp("head",20))=0 s tmp("head",20)="20-30岁",tmp("data",20)=0
	....i $d(tmp("head",30))=0 s tmp("head",30)="30-40岁",tmp("data",30)=0
	....i $d(tmp("head",40))=0 s tmp("head",40)="40-50岁",tmp("data",40)=0
	....i $d(tmp("head",50))=0 s tmp("head",50)="50-60岁",tmp("data",50)=0
	....i $d(tmp("head",60))=0 s tmp("head",60)="50岁以上",tmp("data",60)=0
	....i $d(tmp("headwr",warrw,10))=0 s tmp("headwr",warrw,10)="20岁以内",tmp("datawr",warrw,10)=0
	....i $d(tmp("headwr",warrw,20))=0 s tmp("headwr",warrw,20)="20-30岁",tmp("datawr",warrw,20)=0
	....i $d(tmp("headwr",warrw,30))=0 s tmp("headwr",warrw,30)="30-40岁",tmp("datawr",warrw,30)=0
	....i $d(tmp("headwr",warrw,40))=0 s tmp("headwr",warrw,40)="40-50岁",tmp("datawr",warrw,40)=0
	....i $d(tmp("headwr",warrw,50))=0 s tmp("headwr",warrw,50)="50-60岁",tmp("datawr",warrw,50)=0
	....i $d(tmp("headwr",warrw,60))=0 s tmp("headwr",warrw,60)="50岁以上",tmp("datawr",warrw,60)=0
	....s day=$p($NOW(),",")-obj.PerBirthday
	....s years=day\(30*12)
	....s yearRange=(years\10)*10
	....i years<20 s yearRange=10
	....i years>59 s yearRange=60
	....s tmp("data",yearRange)=tmp("data",yearRange)+1
	....s tmp("datawr",warrw,yearRange)=tmp("datawr",warrw,yearRange)+1
	...;-------工作年限统计
	...i parr="PerYear" d
	....s day=$p($NOW(),",")-obj.PerComeDate
	....i $d(tmp("head",0))=0 s tmp("head",0)="1年以内",tmp("data",0)=0
	....i $d(tmp("head",1))=0 s tmp("head",1)="1-5年",tmp("data",1)=0
	....i $d(tmp("head",5))=0 s tmp("head",5)="5-10年",tmp("data",5)=0
	....i $d(tmp("head",10))=0 s tmp("head",10)="10-15年",tmp("data",10)=0
	....i $d(tmp("head",15))=0 s tmp("head",15)="15-20年",tmp("data",15)=0
	....i $d(tmp("head",20))=0 s tmp("head",20)="20年以上",tmp("data",20)=0
	....i $d(tmp("headwr",warrw,0))=0 s tmp("headwr",warrw,0)="1年以内",tmp("datawr",warrw,0)=0
	....i $d(tmp("headwr",warrw,1))=0 s tmp("headwr",warrw,1)="1-5年",tmp("datawr",warrw,1)=0
	....i $d(tmp("headwr",warrw,5))=0 s tmp("headwr",warrw,5)="5-10年",tmp("datawr",warrw,5)=0
	....i $d(tmp("headwr",warrw,10))=0 s tmp("headwr",warrw,10)="10-15年",tmp("datawr",warrw,10)=0
	....i $d(tmp("headwr",warrw,15))=0 s tmp("headwr",warrw,15)="15-20年",tmp("datawr",warrw,15)=0
	....i $d(tmp("headwr",warrw,20))=0 s tmp("headwr",warrw,20)="20年以上",tmp("datawr",warrw,20)=0
	....s years=day\(30*12)
	....s yearRange=(years\5)*5
	....;i years<1 s yearRange=0 //区间years<1
	....i (years>1)&(yearRange=0) s yearRange=1 //区间1-5
	....i years>19 s yearRange=20 //区间>59
	....s tmp("data",yearRange)=tmp("data",yearRange)+1
	....s tmp("datawr",warrw,yearRange)=tmp("datawr",warrw,yearRange)+1
	
	///数据传出
	//全院数据
	s header=""
	s headerid=0
	s total=0
	f  s header=$o(tmp("data",header)) q:header=""  d
	.i headerid=0 s ret="NurseDep|全院^"_tmp("head",header)_"|"_tmp("data",header)
	.e  s ret=ret_"^"_tmp("head",header)_"|"_tmp("data",header)
	.s headerid=headerid+1
	.s total=total+tmp("data",header)
	
	i ret'="" s ret=ret_"^"_"total|"_total_"^"_"nurseName|"_tmp("nurseName")
	i ret'="" d OutCountData
	//病区数据
	s ret=""
	s warrw=""
	f  s warrw=$o(tmp("datawr",warrw)) q:warrw=""  d
	.s objward=##class(DHCNMG.DB.MgWard).%OpenId(warrw)
	.s ret="NurseDep|"_objward.WardDesc
	.s header="",total=0
	.f  s header=$o(tmp("data",header)) q:header=""  d
	..s d=$d(tmp("datawr",warrw,header))
	..i d=1 s d=tmp("datawr",warrw,header)
	..s ret=ret_"^"_tmp("head",header)_"|"_d
	..s total=total+d
	.i ret'="" s ret=ret_"^"_"total|"_total_"^"_"nurseName|"_tmp("nurseName",warrw)
	.d OutCountData
	
	
	k tmp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonsCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonsCountExecute ]
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

ClassMethod FindPersonsCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询离退人员列表
/// Date:2017-06-26
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonCountComm","FindResignAndRetire","^^^^")
Query FindResignAndRetire(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindResignAndRetireExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s nameval=$p(parr,"^",1)
	s wardval=$p(parr,"^",2)
	s statusval=$p(parr,"^",3)
	s stdate=$p(parr,"^",4)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",5)
	i enddate'="" s enddate=$zdh(enddate,3)
	s ret=""
	s tmp=""
	k tmp
	i role=0
	{
		
		s RowID=0 f  s RowID=$O(^DHCNMG.HR.MgNurseResignD(RowID)) q:RowID=""  d
		.s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(RowID)
		.q:'$IsObject(obj)
		.s per=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
		.q:'$IsObject(per)
		.q:((nameval'="")&&(per.PerName'[nameval))
		.q:((wardval'="")&&(obj.ResignWard'=wardval))
		.q:((statusval'="")&&(per.PerStatus'="")&&(per.PerStatus'=statusval))
		.q:((stdate'="")&&(obj.ResignDate'="")&&(obj.ResignDate<stdate))
		.q:((enddate'="")&&(obj.ResignDate'="")&&(obj.ResignDate>enddate))
		.i per.PerStatus'="" s PerStatus=##class(web.NurMgPersonComm).GetCommCode(per.PerStatus)
		.e  s PerStatus=""
		.q:((PerStatus="")||(PerStatus="在职"))
		.s NurseName=per.PerName //姓名
		.s NurseID=per.PerID  //工号
		.s PerStatusReason=##class(web.NurMgInternComm).GetReason(per.PerStatuReason) //状态原因
		.s NurseDep=$P($P($g(^CTLOC(obj.ResignWard)),"^",2),"-",2)  //病区
		.s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.ResignWard)),3)
		.i per.PerComeDate'="" s PerComeDate=$zd(per.PerComeDate,3)  //来院日期
		.e  s PerComeDate=""
		.s Hireduty=""
		.s HiredutyID=0
		.s HireStDate=0
		.f  s HiredutyID=$o(^DHCNMG.HR.MgHireDutyI("ssid",obj.ResignName,HiredutyID)) q:HiredutyID=""  d
		..s obj1=##class(DHCNMG.HR.MgHireDuty).%OpenId(HiredutyID)
		..i obj1.HireStDate>HireStDate s Hireduty=##class(web.NurMgPersonComm).GetCommCode(obj1.HireDuty)
		.s PerWorkYears=""
		.s PerDuty=""
		.s PerAcademic=""
		.s comeDate=per.PerComeDate
		.i comeDate="" d
		..i per.PerWorkDate'="" s comeDate=per.PerWorkDate
		.i comeDate'="" d
		..s days=##class(web.NurMgVueComm).CalAge($zd(comeDate,3),$zd(obj.ResignDate,3))
		..s PerWorkYears=$e(($p(days," ")),0,($l($p(days," "))-1))_"年"_$e(($p(days," ",2)),0,($l($p(days," ",2))-1))_"月"_$e(($p(days," ",3)),0,($l($p(days," ",3))-1))_"天"
		.s PerDuty=obj.ResignDuty
		.s PerAcademic=obj.ResignAcademic
		.i PerDuty'="" s PerDuty=##class(web.NurMgPersonComm).GetCommCode(PerDuty)
		.i PerAcademic'="" s PerAcademic=##class(web.NurMgPersonComm).GetCommCode(PerAcademic)
		.s tmp(RowID)="NurseName|"_NurseName_"^NurseID|"_NurseID_"^PerStatus|"_PerStatus_"^NurseDep|"_NurseDep_"^PerComeDate|"_PerComeDate_"^Hireduty|"_Hireduty_"^PerStatusReason|"_PerStatusReason_"^PerWorkYears|"_PerWorkYears_"^PerAcademic|"_PerAcademic_"^PerDuty|"_PerDuty
		;.s ret="NurseName|"_NurseName_"^NurseID|"_NurseID_"^PerStatus|"_PerStatus_"^NurseDep|"_NurseDep_"^PerComeDate|"_PerComeDate_"^Hireduty|"_Hireduty_"^PerStatusReason|"_PerStatusReason_"^PerWorkYears|"_PerWorkYears_"^PerAcademic|"_PerAcademic_"^PerDuty|"_PerDuty
		;.do OutputPerData
	}
	else
	{
		s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(role)
		s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurseid,rolerw)) q:rolerw=""  d
		.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
		..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
		..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		....q:(id'=roledepobj.SubWard)
		....s RowID=0 f  s RowID=$O(^DHCNMG.HR.MgNurseResignD(RowID)) q:RowID=""  d
		.....s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(RowID)
		.....q:'$IsObject(obj)
		.....q:obj.ResignWard'=id
		.....q:((rolecode="nurse")&&(nurseid'="")&&(obj.ResignName'=nurseid))
		.....s per=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
		.....q:'$IsObject(per)
		.....q:((nameval'="")&&(per.PerName'[nameval))
		.....q:((wardval'="")&&(obj.ResignWard'=wardval))
		.....q:((statusval'="")&&(per.PerStatus'="")&&(per.PerStatus'=statusval))
		.....q:((stdate'="")&&(obj.ResignDate'="")&&(obj.ResignDate<stdate))
		.....q:((enddate'="")&&(obj.ResignDate'="")&&(obj.ResignDate>enddate))
		.....i per.PerStatus'="" s PerStatus=##class(web.NurMgPersonComm).GetCommCode(per.PerStatus)
		.....e  s PerStatus=""
		.....q:((PerStatus="")||(PerStatus="在职"))
		.....s NurseName=per.PerName //姓名
		.....s NurseID=per.PerID  //工号
		.....s PerStatusReason=##class(web.NurMgInternComm).GetReason(per.PerStatuReason) //状态原因
		.....s NurseDep=$P($P($g(^CTLOC(obj.ResignWard)),"^",2),"-",2)  //病区
		.....s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.ResignWard)),3)
		.....i per.PerComeDate'="" s PerComeDate=$zd(per.PerComeDate,3)  //来院日期
		.....e  s PerComeDate=""
		.....s Hireduty=""
		.....s HiredutyID=0
		.....s HireStDate=0
		.....f  s HiredutyID=$o(^DHCNMG.HR.MgHireDutyI("ssid",obj.ResignName,HiredutyID)) q:HiredutyID=""  d
		......s obj1=##class(DHCNMG.HR.MgHireDuty).%OpenId(HiredutyID)
		......i obj1.HireStDate>HireStDate s Hireduty=##class(web.NurMgPersonComm).GetCommCode(obj1.HireDuty)
		.....s PerWorkYears=""
		.....s PerDuty=""
		.....s PerAcademic=""
		.....s comeDate=per.PerComeDate
		.....i comeDate="" d
		......i per.PerWorkDate'="" s comeDate=per.PerWorkDate
		.....i comeDate'="" d
		......s days=##class(web.NurMgVueComm).CalAge($zd(comeDate,3),$zd(obj.ResignDate,3))
		......s PerWorkYears=$e(($p(days," ")),0,($l($p(days," "))-1))_"年"_$e(($p(days," ",2)),0,($l($p(days," ",2))-1))_"月"_$e(($p(days," ",3)),0,($l($p(days," ",3))-1))_"天"
		.....s PerDuty=obj.ResignDuty
		.....s PerAcademic=obj.ResignAcademic
		.....i PerDuty'="" s PerDuty=##class(web.NurMgPersonComm).GetCommCode(PerDuty)
		.....i PerAcademic'="" s PerAcademic=##class(web.NurMgPersonComm).GetCommCode(PerAcademic)
		.....s tmp(RowID)="NurseName|"_NurseName_"^NurseID|"_NurseID_"^PerStatus|"_PerStatus_"^NurseDep|"_NurseDep_"^PerComeDate|"_PerComeDate_"^Hireduty|"_Hireduty_"^PerStatusReason|"_PerStatusReason_"^PerWorkYears|"_PerWorkYears_"^PerAcademic|"_PerAcademic_"^PerDuty|"_PerDuty
		;.....s ret="NurseName|"_NurseName_"^NurseID|"_NurseID_"^PerStatus|"_PerStatus_"^NurseDep|"_NurseDep_"^PerComeDate|"_PerComeDate_"^Hireduty|"_Hireduty_"^PerStatusReason|"_PerStatusReason_"^PerWorkYears|"_PerWorkYears_"^PerAcademic|"_PerAcademic_"^PerDuty|"_PerDuty
		;.....do OutputPerData
	}
	s rw="" f  s rw=$o(tmp(rw)) q:rw=""  d
	.s ret=tmp(rw)
	.do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindResignAndRetireFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResignAndRetireExecute ]
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

ClassMethod FindResignAndRetireClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindResignAndRetireExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:查询在职状态非在职明细
/// Date:2017-08-17
/// Table:DHCNMG.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonCountComm","FindStatusCode","")
Query FindStatusCode() As %Query(ROWSPEC = "SubCode,SubDesc,SubValue")
{
}

ClassMethod FindStatusCodeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr("在职状态"," ",""),"U"),"")) 
	s desc="" f  s desc=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par,desc)) q:desc=""  d
	.s raw="" f  s raw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par,desc,raw)) q:raw=""  d
	..s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_raw)
	..s date=+$H
	..s SubStDate=obj.SubStDate
	..s SubEndDate=obj.SubEndDate
	..q:(SubStDate'="")&&(date<SubStDate)
	..q:((SubEndDate'="")&&(date>SubEndDate))
	..s SubCode=obj.SubCode
	..s SubDesc=obj.SubDesc
	..q:SubDesc="在职"
	..do OutputPub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPub
	set Data=$lb(SubCode,SubDesc,par_"||"_raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindStatusCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusCodeExecute ]
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

ClassMethod FindStatusCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:根据传入类型获取统计表的列信息
/// Date:2019-10-25
/// Table:DHCNMG.DB.MgSetCode
/// Input:统计方式
/// Output：统计表的列信息
/// Return:
/// Others: w ##class(web.NurMgPersonCountComm).GetNurStatColumn("性别")
ClassMethod GetNurStatColumn(type As %String = "") As %String
{
	s legalType=$lb("职务","性别","护士层级","聘任职称","鞋号(男)","鞋号(女)","学历","职工性质","工作年限","平均年龄")
	i '$lf(legalType,type)
	{
		q "[]"
	}
	s:(type="鞋号(男)")||(type="鞋号(女)") type="鞋号"
	s props=""
	i type="工作年限"
	{
		s props="{""Code"":""A"",""Desc"":""新员工""},{""Code"":""B"",""Desc"":""1-5年""},{""Code"":""C"",""Desc"":""5-10年""},{""Code"":""D"",""Desc"":""10-15年""},{""Code"":""E"",""Desc"":""15-20年""},{""Code"":""F"",""Desc"":""20年以上""}"
	}
	elseif type="平均年龄"
	{
		s props="{""Code"":""A"",""Desc"":""20岁以下""},{""Code"":""B"",""Desc"":""20-30岁(不含)""},{""Code"":""C"",""Desc"":""30-40岁(不含)""},{""Code"":""D"",""Desc"":""40-50岁(不含)""},{""Code"":""E"",""Desc"":""50岁以上""},{""Code"":""AvgAge"",""Desc"":""平均年龄""}"
	}
	else
	{
		s codeId=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt(type,"U"),""))
		s codeObj=##class(DHCNMG.DB.MgSetCode).%OpenId(codeId)
		q:'$IsObject(codeObj) "[]"
		s props=""
		s subSort="" f  s subSort=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
		.s subId="" f  s subId=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
		..s subObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
		..q:('$IsObject(subObj))
		..q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
		..i props="" s props=props_"{""Code"":"""_subObj.SubCode_""",""Desc"":"""_subObj.SubDesc_"""}"
		..e  s props=props_","_"{""Code"":"""_subObj.SubCode_""",""Desc"":"""_subObj.SubDesc_"""}"
	}
	i $g(props)'="" s props="[{""Code"":""WardDesc"",""Desc"":""名称""},"_props_",{""Code"":""WardTotal"",""Desc"":""合计""}]"
	e  s props="[]"
	q props
}

/// Creator:wangpf
/// Description:统计职务、性别、护士层级、聘任职称、鞋号(男)、鞋号(女)、学历、职工性质、工作年限、平均年龄信息
/// Date:2019-10-25
/// Table:DHCNMG.HR.MgPersons DHCNMG.DB.MgSetCode
/// Input:病区ID 统计方式 
/// Output：相应类别的信息
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonCountComm","FindNurStatistic","","性别",0,0)
Query FindNurStatistic(wardid As %String = "", type As %String = "", role As %String = "", nurseid As %String = "", wardlocid As %String = "", outputtype As %String = "ALL,WARD") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurStatisticExecute(ByRef qHandle As %Binary, wardid As %String = "", type As %String = "", role As %String = "", nurseid As %String = "", wardlocid As %String = "", outputtype As %String = "ALL,WARD") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret="",result=""
	
	s legalType=$lb("职务","性别","护士层级","聘任职称","鞋号(男)","鞋号(女)","学历","职工性质","工作年限","平均年龄")
	i ('$lf(legalType,type))||(nurseid="")||(role="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s retAll="WardDesc|全院",tmpCounterAll=0
	i (type="工作年限")||(type="平均年龄")
	{
		s propertyName=$case(type,"工作年限":"PerComeDate","平均年龄":"PerBirthday",:"")
		s retAll("A")=0,retAll("B")=0,retAll("C")=0,retAll("D")=0,retAll("E")=0
		s:type="工作年限" retAll("F")=0
		s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardD(wardId)) q:wardId=""  d
		.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		.q:'$IsObject(wardObj)
		.q:(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.s tmp(wardId,"WardTotal")=0,tmp(wardId,"WardDesc")=wardObj.WardDesc,tmp(wardId,"A")=0,tmp(wardId,"B")=0,tmp(wardId,"C")=0,tmp(wardId,"D")=0,tmp(wardId,"E")=0
		.i type="工作年限" s tmp(wardId,"F")=0
		.s perId="" f  s perId=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_wardId,perId)) q:perId=""  d
		..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perId)
		..q:('$IsObject(perObj))||(##class(web.NurMgPersonComm).GetCommCode(perObj.PerStatus)'["在职")
		..q:perObj.PerTypeDR'="N"
		..q:perObj.PerAuditFlag'="Y"
		..s propertyValue=$zobjproperty(perObj,propertyName)
		..i propertyValue'="" s dataDiff=$p(##class(web.NurMgVueComm).CalAge($zd(propertyValue,3),$zd(+$h,3)),"Y")
		..e  s dataDiff=0
		..i type="工作年限" d
		...i dataDiff<1 s tmp(wardId,"A")=tmp(wardId,"A")+1,retAll("A")=retAll("A")+1
		...e  i (dataDiff>=1)&&(dataDiff<5) s tmp(wardId,"B")=tmp(wardId,"B")+1,retAll("B")=retAll("B")+1
		...e  i (dataDiff>=5)&&(dataDiff<10) s tmp(wardId,"C")=tmp(wardId,"C")+1,retAll("C")=retAll("C")+1
		...e  i (dataDiff>=10)&&(dataDiff<15) s tmp(wardId,"D")=tmp(wardId,"D")+1,retAll("D")=retAll("D")+1
		...e  i (dataDiff>=15)&&(dataDiff<20) s tmp(wardId,"E")=tmp(wardId,"E")+1,retAll("E")=retAll("E")+1
		...e  s tmp(wardId,"F")=tmp(wardId,"F")+1,retAll("F")=retAll("F")
		..e  i type="平均年龄" d
		...s tmp(wardId,"WardTotalAge")=$fn($g(tmp(wardId,"WardTotalAge")),"")+dataDiff
		...s totalAgeAll=$fn($g(totalAgeAll),"")+dataDiff
		...i dataDiff<20 s tmp(wardId,"A")=tmp(wardId,"A")+1,retAll("A")=retAll("A")+1
		...e  i (dataDiff>=20)&&(dataDiff<30) s tmp(wardId,"B")=tmp(wardId,"B")+1,retAll("B")=retAll("B")+1
		...e  i (dataDiff>=30)&&(dataDiff<40) s tmp(wardId,"C")=tmp(wardId,"C")+1,retAll("C")=retAll("C")+1
		...e  i (dataDiff>=40)&&(dataDiff<50) s tmp(wardId,"D")=tmp(wardId,"D")+1,retAll("D")=retAll("D")+1
		...e  s tmp(wardId,"E")=tmp(wardId,"E")+1,retAll("E")=retAll("E")+1
		..s tmp(wardId,"WardTotal")=tmp(wardId,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
		d Output
	}
	else
	{
		s propertyName=$case(type,"性别":"PerSexDR","职工性质":"PerSource","鞋号(男)":"PerShoesNo","鞋号(女)":"PerShoesNo",:"")
		i type="鞋号(男)"
		{
			s codeId=$o(^DHCNMG.DB.MgSetCodeI("Code"," 性别",""))
			s sexSubId=$o(^DHCNMG.DB.MgSetCodeSubI("Code",codeId," 男",""))
			s manSubId=codeId_"||"_sexSubId
		}
		elseif type="鞋号(女)"
		{
			s codeId=$o(^DHCNMG.DB.MgSetCodeI("Code"," 性别",""))
			s sexSubId=$o(^DHCNMG.DB.MgSetCodeSubI("Code",codeId," 女",""))
			s womanSubId=codeId_"||"_sexSubId
		}
		i propertyName'="PerShoesNo" s codeId=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_type,""))
		e  s codeId=$o(^DHCNMG.DB.MgSetCodeI("Code"," 鞋号",""))
		s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardD(wardId)) q:wardId=""  d
		.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		.q:'$IsObject(wardObj)
		.q:(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.s tmp(wardId,"WardTotal")=0,tmp(wardId,"WardDesc")=wardObj.WardDesc
		.s subSort="" f  s subSort=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
		..s subId="" f  s subId=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
		...s subObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
		...q:('$IsObject(subObj))
		...q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
		...s tmp(wardId,subObj.SubCode)=0
		...s:$g(retAll(subObj.SubCode))="" retAll(subObj.SubCode)=0
		...s perId="" f  s perId=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_wardId,perId)) q:perId=""  d
		....s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perId)
		....q:('$IsObject(perObj))||(##class(web.NurMgPersonComm).GetCommCode(perObj.PerStatus)'["在职")
		....q:perObj.PerTypeDR'="N"
		....q:perObj.PerAuditFlag'="Y"
		....s flag=0
		....i type="职务" d
		.....s postData=(+$h+1) f  s postData=$o(^DHCNMG.HR.MgPostDutyI("PostDate",perId,postData),-1) q:(postData="")||(flag=1=1)  d
		......s postDutyId="" f  s postDutyId=$o(^DHCNMG.HR.MgPostDutyI("PostDate",perId,postData,postDutyId),-1) q:(postDutyId="")||(flag=1=1)  d
		.......s postDutyObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(postDutyId)
		.......q:('$IsObject(postDutyObj))||((postDutyObj.PostEndDate'="")&&(postDutyObj.PostEndDate<+$h))||(postDutyObj.PostStatus'="A")
		.......q:postDutyObj.PostDuty'=subObj.%Id()
		.......s flag=1
		....e  i type="护士层级" d
		.....s levelDate=(+$h+1) f  s levelDate=$o(^DHCNMG.HR.MgLevelI("perDate",perId,levelDate),-1) q:(levelDate="")||(flag=1=1)  d
		......s levelId="" f  s levelId=$o(^DHCNMG.HR.MgLevelI("perDate",perId,levelDate,levelId),-1) q:(levelId="")||(flag=1=1)  d
		.......s levelObj=##class(DHCNMG.HR.MgLevel).%OpenId(levelId)
		.......q:('$IsObject(levelObj))||(levelObj.LevelStatus'="A")
		.......q:levelObj.NurLevel'=subObj.%Id()
		.......s flag=1
		....e  i type="聘任职称" d
		.....s hireDutyDate=(+$h+1) f  s hireDutyDate=$o(^DHCNMG.HR.MgHireDutyI("HireDate",perId,hireDutyDate),-1) q:(hireDutyDate="")||(flag=1=1)  d
		......s hireDutyId="" f  s hireDutyId=$o(^DHCNMG.HR.MgHireDutyI("HireDate",perId,hireDutyDate,hireDutyId),-1) q:(hireDutyId="")||(flag=1=1)  d
		.......s hireDutyObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(hireDutyId)
		.......q:('$IsObject(hireDutyObj))||((hireDutyObj.HireEndDate'="")&&(hireDutyObj.HireEndDate<+$h))||(hireDutyObj.HireStatus'="A")
		.......q:hireDutyObj.HireDuty'=subObj.%Id()
		.......s flag=1
		....e  i type="学历" d
		.....s eduDate=(+$h+1) f  s eduDate=$o(^DHCNMG.HR.MgEducateI("flag",perId,eduDate),-1) q:(eduDate="")||(flag=1=1)  d
		......s eduId="" f  s eduId=$o(^DHCNMG.HR.MgEducateI("flag",perId,eduDate,eduId),-1) q:(eduId="")||(flag=1=1)  d
		.......s eduObj=##class(DHCNMG.HR.MgEducate).%OpenId(eduId)
		.......q:('$IsObject(eduObj))||(eduObj.EduStatus'="A")
		.......q:eduObj.EduAcademic'=subObj.%Id()
		.......s flag=1
		....e  d
		.....q:$zobjproperty(perObj,propertyName)'=subObj.%Id()
		.....q:(propertyName="PerShoesNo")&&(type["男")&&(manSubId'=perObj.PerSexDR)
		.....q:(propertyName="PerShoesNo")&&(type["女")&&(womanSubId'=perObj.PerSexDR)
		.....s flag=1
		....i flag d
		.....s tmp(wardId,subObj.SubCode)=tmp(wardId,subObj.SubCode)+1
		.....s retAll(subObj.SubCode)=retAll(subObj.SubCode)+1
		.....s tmp(wardId,"WardTotal")=tmp(wardId,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
		d Output
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	f j=1:1:$l(outputtype,",") d
	.i $p(outputtype,",",j)="ALL" d OutAll
	.e  i $p(outputtype,",",j)="WARD" d OutOwnWard
	.e  i $p(outputtype,",",j)="WARDLOC" d OutOwnWardLoc
	.e  i $p(outputtype,",",j)="OWN" d OutOwnAll
	q
OutputStatistic
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
OutAll
	;全院汇总数据(1条)
	s i="" f  s i=$o(retAll(i)) q:i=""  d
	.s retAll=retAll_"^"_i_"|"_retAll(i)
	i type="平均年龄" d
	.i tmpCounterAll'=0 s retAll=retAll_"^AvgAge|"_$fn(totalAgeAll\tmpCounterAll,"",0)
	.e  s retAll=retAll_"^AvgAge|0"
	s ret=retAll_"^WardTotal|"_tmpCounterAll_"^RowHilight|1"
	d OutputStatistic
	q
OutOwnAll
	;所辖科室病区汇总数据(1条)
	k tmpWard
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardD(wardId)) q:wardId=""  d
	.q:(isAll=0)&&('$d(tmpWard(wardId)))
	.q:'$d(tmp(wardId))
	.s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	..s:i'="WardDesc" tmpOwn(i)=$fn($g(tmpOwn(i)),"")+tmp(wardId,i)
	s ret="WardDesc|所辖科室(病区)"
	s i="" f  s i=$o(tmpOwn(i)) q:i=""  d
	.s:i'="WardTotalAge" ret=ret_"^"_i_"|"_tmpOwn(i)
	i type="平均年龄" d
	.i tmpOwn("WardTotalAge")'=0 s ret=ret_"^AvgAge|"_$fn(tmpOwn("WardTotalAge")\tmpOwn("WardTotal"),"",0)
	.e  s ret=ret_"^AvgAge|0"
	s ret=ret_"^RowHilight|0"
	d OutputStatistic
	q
OutOwnWard
	;所辖(选)病区数据(多条)
	k tmpWard
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s wardSort="" f  s wardSort=$o(^DHCNMG.DB.MgWardI("Sort",wardSort)) q:wardSort=""  d
	.s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardI("Sort",wardSort,wardId)) q:wardId=""  d
	..q:(wardid'="")&&(wardId'=wardid)
	..q:(isAll=0)&&('$d(tmpWard(wardId)))
	..q:'$d(tmp(wardId))
	..s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	...q:i="WardTotalAge"
	...i ret="" s ret=i_"|"_tmp(wardId,i)
	...e  s ret=ret_"^"_i_"|"_tmp(wardId,i)
	..i type="平均年龄" d
	...i tmp(wardId,"WardTotal")'=0 s ret=ret_"^AvgAge|"_$fn(tmp(wardId,"WardTotalAge")\tmp(wardId,"WardTotal"),"",0)
	...e  s ret=ret_"^AvgAge|0"
	..s ret=ret_"^RowHilight|0"
	..d OutputStatistic
	q
OutOwnWardLoc
	;所辖(选)科室数据(多条)
	k tmpWardLoc
	d ##class(web.NurMgDataLimit).GetRoleWardLoc(nurseid,1,.tmpWardLoc)
	s wardLocId="" f  s wardLocId=$o(tmpWardLoc(wardLocId)) q:wardLocId=""  d
	.q:(wardlocid'="")&&(wardlocid'=wardLocId)
	.s ret="WardDesc|"_tmpWardLoc(wardLocId)
	.s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",wardLocId,wardId)) q:wardId=""  d
	..q:'$d(tmp(wardId))
	..s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	...q:(i="WardDesc")
	...s tmpLoc(wardLocId,i)=$fn($g(tmpLoc(wardLocId,i)),"")+tmp(wardId,i)
	.i '$d(tmpLoc(wardLocId)) d
	..s tmpLoc(wardLocId,"WardTotal")=0
	..i (type="工作年限")||(type="平均年龄") d
	...s tmpLoc(wardLocId,"A")=0,tmpLoc(wardLocId,"B")=0,tmpLoc(wardLocId,"C")=0,tmpLoc(wardLocId,"D")=0,tmpLoc(wardLocId,"E")=0,tmpLoc(wardLocId,"WardTotal")=0
	...i type="工作年限" s tmpLoc(wardLocId,"F")=0
	...i type="平均年龄" s tmpLoc(wardLocId,"WardTotalAge")=0
	..e  d
	...s subSort="" f  s subSort=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
	....s subId="" f  s subId=$o(^DHCNMG.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
	.....s subObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
	.....q:('$IsObject(subObj))
	.....q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
	.....s tmpLoc(wardLocId,subObj.SubCode)=0
	.s i="" f  s i=$o(tmpLoc(wardLocId,i)) q:i=""  d
	..q:i="WardTotalAge"
	..s ret=ret_"^"_i_"|"_tmpLoc(wardLocId,i)
	.i type="平均年龄" d
	..q:'$d(tmpLoc(wardLocId))
	..i tmpLoc(wardLocId,"WardTotal")'=0 s ret=ret_"^AvgAge|"_$fn(tmpLoc(wardLocId,"WardTotalAge")\tmpLoc(wardLocId,"WardTotal"),"",0)
	..e  s ret=ret_"^AvgAge|0"
	.s ret=ret_"^RowHilight|0"
	.d OutputStatistic
	q
}

ClassMethod FindNurStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurStatisticExecute ]
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

ClassMethod FindNurStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
