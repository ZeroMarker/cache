/// Creator：gzj
/// Description：护理人员统计、离退休汇总人员查询类
/// Date：2017-10-16
Class web.INMPersonCountComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:离职率初始化职称、学历tmp（不需要排序只需要数据）
/// Date:2017年12月25日 10:13:58
/// Table:CT.DHCINM.DB.MgSetCode，CT.DHCINM.DB.MgSetCodeSub，CF.DHCINM.DB.MgWard
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod initCountTmpBytime(type, name, warrw, tmp)
{
	if '(type["years") {
		s tmp(type,warrw,"other")=0
		s parid=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_name,0))
		s sort=0 f  s sort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",parid,sort)) q:sort=""  d
		.s subid=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",parid,sort,0))
		.s tmp(type,warrw,parid_"||"_subid)=0
	}else {
		s tmp(type,warrw,"<1")=0
		s tmp(type,warrw,"1≤y<2")=0
		s tmp(type,warrw,"2≤y<5")=0
		s tmp(type,warrw,"5≤y<10")=0
		s tmp(type,warrw,"10≤")=0
#;		s warrw=0
#;		f  s warrw=$o(^CF.DHCINM.DB.MgWardD(warrw)) q:warrw=""  d
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
/// Table:CF.DHCINM.Trans.TransDep
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod saveTmpCountBytime(stdate, enddate, type, warrw, perid, tmp)
{
	
	if type["hireduty" {
		///职称
		s CodePreID=""
		s typeid=0,typedate=0 f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",perid,typeid)) q:typeid=""  d
		.s hireobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
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
		s typeid=0,typedate=0 f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",perid,typeid)) q:typeid=""  d
		.s degreeobj=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
		.q:degreeobj.EduStatus'="A"
		.i (degreeobj.EduStDate<=enddate)&&(degreeobj.EduStDate>typedate) s typedate=degreeobj.EduStDate,CodePreID=degreeobj.EduAcademic
		i CodePreID="" s CodePreID="other"
		;s tmp(type,0,CodePreID)=tmp(type,0,CodePreID)+1
		s tmp(type,warrw,CodePreID)=tmp(type,warrw,CodePreID)+1
	}elseif type["years"{
		///年限;时间段是离职的使用，取变更状态(离职)时间
		s per=##class(CF.DHCINM.HR.Persons).%OpenId(perid)
		s workstdate=per.PerWorkDate
		i stdate=enddate s workenddate=stdate 
		e  s workenddate=per.PerStateDate
		i workstdate="" s workstdate=workenddate
		s years=$p(##class(web.INMVueComm).CalAge($zd(workstdate,3),$zd(workenddate,3))," ")
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
/// Table:CF.DHCINM.Trans.TransDep
/// Input:病区id，开始日期，结束日期
/// Output：
/// Return:
/// Others:
ClassMethod GetTmpCountBytime(stdate, enddate, type, ward, tmp, tmp2)
{
	q:(stdate="")||(enddate="")
	s tmp("num")=0
	s wardids=0 f  s wardids=$o(^CF.DHCINM.Trans.TransDepI("Dep",wardids)) q:wardids=""  d
	.q:(type'="table")&&(ward'=0)&&($tr(wardids," ","")'=ward)
	.s wardid=$tr(wardids," ","")
	.q:wardid=""
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
	.s transid=0 f  s transid=$o(^CF.DHCINM.Trans.TransDepI("Dep",wardids,transid)) q:transid=""  d
	..s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transid)
	..s per=##class(CF.DHCINM.HR.Persons).%OpenId(obj.PerDr)
	..;s perApp=##class(DHCINM.Trans.MgTransApp).%OpenId(obj.PerAppID)
	..;q:(($IsObject(perApp))&&(perApp.TransStatus'="A"))
	..q:'$IsObject(per)
	..s statusobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(per.PerStatus)
	..;b:obj.PerDr=2
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
	...i ($o(^CF.DHCINM.Trans.TransDepI("ssdr"," "_obj.PerDr,transid),-1)="") d
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
	....s tmp2(per.%Id())=1
	....;b
	...e  i type["resign"  d ..saveTmpCountBytime(stdate,enddate,type,ward,obj.PerDr,.tmp)
}

/// Creator:lulin
/// Description:获取病区人员
/// Date:2017年12月23日 14:44:56
/// Table:CF.DHCINM.Trans.TransDep
/// Input:病区id(全院为0)，开始日期，结束日期,类型
/// Output：
/// Return:
/// Others:zw ##class(web.INMPersonCountComm).getCountByTime("0^2017-11-22^2017-12-22^sthireduty")
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
		...s a=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(sub)
		...s name=a.SubDesc
		...i a.SubRemark'="" s color=a.SubRemark
		..s ret=ret_"{""name"":"""_name_""",""value"":"_data_",""color"":"""_color_"""},"
		i ret'="" s ret="["_ret_"]"
		w ret
		q ""
}

/// Creator:lulin
/// Description:离职率列表获取病区人员
/// Date:2017年12月23日 14:44:56
/// Table:CF.DHCINM.Trans.TransDep
/// Input:病区id，开始日期，结束日期
/// Output：
/// Return:
/// Others:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindWardPersonCountBytime","^2021-03-07^2021-04-07",43)
Query FindWardPersonCountBytime(parr As %String = "", nurseid, tmp2) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardPersonCountBytimeExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid, tmp2) As %Status
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
	d ..GetTmpCountBytime(stdate,enddate,"table",0,.tmp,.tmp2)
	s index=0
	s type="table"
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	f i=1:1:$l(ward,",")
	{
		s wardstr=$p(ward,",",i)
		s wardid="" f  s wardid=$o(tmp(type,wardid)) q:wardid=""  d
		.q:(((ward'="")&&(wardid'=wardstr)))
		.q:((isAll'=1)&&('$d(tmpWard(wardid))))
		.i wardid'=0 d
		..s objw=##class(CF.DHCINM.DB.MgWard).%OpenId(wardid)
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
		.s ret="WardCode|"_WardCode_"^WardDesc|"_WardDesc_"^StNum|"_StNum_"^NewNum|"_NewNum_"^ResignNum|"_ResignNum_"^ResignRate|"_(ResignRate*100)_"%"_"^EndNum|"_EndNum_"^TransinNum|"_TransinNum_"^TransoutNum|"_TransoutNum_"^rw|"_rw
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
/// Table:CF.DHCINM.HR.Persons
/// Input:病区id、用户id
/// Output：
/// Return:
/// Others:w ##class(web.INMPersonCountComm).FindWardPersonCount("^^","4","0","0")
ClassMethod FindWardPersonCount(parr As %String = "", ordertype As %String = "0", role As %String, nurseid As %String)
{
	k tmpperson
	s prw=0
	s hiredutydr=$p(parr,"^")
	s selectid=$p(parr,"^",2) //病区、科室、片区id
	s selectsex=$p(parr,"^",3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	f  s prw=$o(^CF.DHCINM.HR.PersonsD(prw)) q:prw=""  d
	.s Obj=##class(CF.DHCINM.HR.Persons).%OpenId(prw)
	.q:Obj.PerTypeDR'="N"
	.q:Obj.PerCareType'="N"
	.q:Obj.PerAuditFlag'="Y"
	.s PerStatus=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Obj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.s name=Obj.PerName
	.s curward=##class(web.INMHRComm).GetCurrentWard(prw,+$h)
	.s curward=Obj.PerDepDR
	.q:curward=""
	.s warrw=curward
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s perSex=##class(web.INMPersonComm).GetCommCode(Obj.PerSexDR)
	.q:((selectsex'="")&&(perSex'[selectsex))
	.;职称统计
	.s hiredutyCode="other2"
	.s color="#000"
	.s typedate=0
	.s typeid=0
	.s type="hireduty"
	.f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s Perobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	..q:Perobj.HireStatus'="A"
	..q:(Perobj.HireEndDate'="")&&(Perobj.HireEndDate<+$H)
	..i Perobj.HireStDate>typedate s typedate=Perobj.HireStDate,hiredutyCode=Perobj.HireDuty
	.q:(hiredutydr'="")&(hiredutydr'=hiredutyCode) //在这里可以让过滤掉病区无人的病区数据
	.i hiredutyCode="" s hiredutyCode="other2"
	.i hiredutyCode'="other2" d
	..s a=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(hiredutyCode)
	..i a.SubRemark'="" s color=a.SubRemark
	.;职务统计
	.s headname=""
	.s typedate=0
	.s typeid=0
	.s type="postduty"
	.f  s typeid=$o(^CF.DHCINM.HR.PostDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s Perobj2=##class(CF.DHCINM.HR.PostDuty).%OpenId(typeid)
	..q:Perobj2.PostStatus'="A"
	..q:(Perobj2.PostEndDate'="")&&(Perobj2.PostEndDate<+$H)
	..i Perobj2.PostStDate>typedate s typedate=Perobj2.PostStDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj2.PostDuty)
	.s isheadnurse=1
	.i headname'="护士长" s isheadnurse=2
	.s sex=##class(web.INMPersonComm).GetCommCode(Obj.PerSexDR)
	.i sex["男" s sex="♂"
	.e  s sex=""
	.;人员
	.s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(warrw)
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
	..s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(locFlag)
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
	s LocId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",wardId,""))
	q:LocId="" ""
	q LocId
}

/// 初始化职务、职称、学历tmp
ClassMethod initCountTmp(type, name, id, tmp)
{
	s tmp(type,id,"name","other2",1)="other2"
	s tmp(type,id,"data","other2",1)=0
	s parid=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_name,0))
	s sort=0 f  s sort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",parid,sort)) q:sort=""  d
	.s subid=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",parid,sort,0))
	.s tmp(type,id,"name",parid,sort)=parid_"||"_subid
	.s tmp(type,id,"data",parid,sort)=0
}

/// 保存tmp数据
ClassMethod SaveCountTmp(id, type, warrw, tmp)
{
	s CodeSort=1
	i id'="" d
	.s CodeSub=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(id)
	.s id=CodeSub.Parref.%Id()
	.s CodeSort=CodeSub.SubSort
	i id="" s id="other2"
	s tmp(type,warrw,"data",id,CodeSort)=tmp(type,warrw,"data",id,CodeSort)+1
	//s tmp(type,"all","data",id,CodeSort)=tmp(type,"all","data",id,CodeSort)+1
}

/// Creator:lulin
/// Description:一览表顶部数据获取总数据：职务、职称、学历、年龄
/// Date:2017-10-17
/// Table:CF.DHCINM.HR.Persons
/// Input:病区id；全院为all
/// Output：
/// Return:
/// Others:w ##class(web.INMPersonCountComm).FindCount("all^3^女","0","0")
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
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	f  s prw=$o(^CF.DHCINM.HR.PersonsD(prw)) q:prw=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(prw)
	.q:'$IsObject(perObj)
	.q:perObj.PerCareType'="N" ;只统计护士
	.q:perObj.PerTypeDR'="N" ;只统计正式
	.q:perObj.PerAuditFlag'="Y"
	.s curward=##class(web.INMHRComm).GetCurrentWard(prw,+$h)
	.s curward=perObj.PerDepDR
	.q:curward=""
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s perSex=##class(web.INMPersonComm).GetCommCode(perObj.PerSexDR)
	.q:(selectsex'="")&&((perSex="")||(perSex'[selectsex))
	.s PerStatus=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(perObj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.s name=perObj.PerName
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perObj.PerDepDR)
	.s select="无对应"
	.i ((selecttype="0")||(selecttype="3"))&&($IsObject(wardObj)) s select=perObj.PerDepDR
	.i (selecttype="1") s select=perObj.PerLocDR
	.i (selecttype="2")&&($IsObject(wardObj))&&($IsObject(wardObj.WardAreaDR)) s select=wardObj.WardAreaDR.%Id()
	.i (selecttype="4")&&($IsObject(wardObj))&&($IsObject(wardObj.WardTypeDR)) s select=wardObj.WardTypeDR.%Id()
	.q:(selectid'="all")&&(selectid'=select)
	.s warrw=selectid
	.;职称统计
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s hireobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	..q:hireobj.HireStatus'="A"
	..q:(hireobj.HireEndDate'="")&&(hireobj.HireEndDate<+$H)
	..i hireobj.HireStDate>typedate s typedate=hireobj.HireStDate,CodePreID=hireobj.HireDuty
	.d ..SaveCountTmp(CodePreID,"hireduty",warrw,.tmp)
	.;职务统计
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^CF.DHCINM.HR.PostDutyI("ssid",prw,typeid)) q:typeid=""  d
	..s postobj=##class(CF.DHCINM.HR.PostDuty).%OpenId(typeid)
	..q:postobj.PostStatus'="A"
	..q:(postobj.PostEndDate'="")&&(postobj.PostEndDate<+$H)
	..i postobj.PostStDate>typedate s typedate=postobj.PostStDate,CodePreID=postobj.PostDuty
	.d ..SaveCountTmp(CodePreID,"postduty",warrw,.tmp)
	.;学历
	.s CodePreID=""
	.s typeid=0,typedate=0 f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",prw,typeid)) q:typeid=""  d
	..s degreeobj=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
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
	.s day=$p($NOW(),",")-$lg(^CF.DHCINM.HR.PersonsD(prw),6)
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
	...i ((type'="hireduty")&(type'="years")&(CodeSubId'="other2")) s Codedesc=##class(web.INMPersonComm).GetCommCode(CodeSubId)
	...i CodeSubId="other2" s Codedesc="未定义"
	...i (type="years")  d 
	....i ret2="" s ret2="{""name"":"""_Codedesc_""",""data"":"""_data_"""}"
	....e  s ret2=ret2_",{""name"":"""_Codedesc_""",""data"":"""_data_"""}"
	...i (type'="years")  d
	....s color="#000" //非年龄颜色特殊处理
	....i (CodeSubId'="other2") d
	.....s a=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(CodeSubId)
	.....s color=a.SubRemark
	.....s Codedesc=a.SubDesc
	....i ret2="" s ret2="{""name"":"""_Codedesc_""",""data"":"""_data_""",""id"":"""_CodeSubId_""",""color"":"""_color_"""}"
	....e  s ret2=ret2_",{""name"":"""_Codedesc_""",""data"":"""_data_""",""id"":"""_CodeSubId_""",""color"":"""_color_"""}"
	.i ret="" s ret=""""_type_""":["_ret2_"]"
	.e  s ret=ret_","""_type_""":["_ret2_"]"
	i ret'="" s ret="{""total"":"""_total_""",""data"":{"_ret_"}}"
	w ret
	q ""
}

/// 下列老系统实现方式暂时未用
/// Creator:lulin
/// Description:查询统计数据表格表头
/// Date:2017-10-17
/// Table:CF.DHCINM.HR.Persons
/// Input:病区id、用户id
/// Output：
/// Return:
/// Others:d ##class(web.INMPersonCountComm).FindTableHead("PerWordType^0")
ClassMethod FindTableHead(parr As %String = "")
{
	
	q:parr=""
	k tmp
	s datatype=$p(parr,"^")
	s dataother=$p(parr,"^",2) //是否是必填,
	;性别统计
	if dataother {
		if datatype="sex" {
			s headcode=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 性别",0))
			s headcodesubrw=0
			f  s headcodesubrw=$o(^CT.DHCINM.DB.MgSetCodeSubD(headcode,headcodesubrw)) q:headcodesubrw=""  d
			.s headname=$lg(^CT.DHCINM.DB.MgSetCodeSubD(headcode,headcodesubrw),3)
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
		f  s NurseDep=$o(^CF.DHCINM.DB.MgWardI("Code",NurseDep)) q:NurseDep=""  d 
		.s warrw=0
		.;病区id
		.f  s warrw=$o(^CF.DHCINM.DB.MgWardI("Code",NurseDep,warrw)) q:warrw=""  d 
		..s prw=0 //personrw
		..;循环每个病人，区分统计数据类型，获取统计数据
		..f  s prw=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_warrw,prw)) q:prw=""  d 
		...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(prw)
		...q:(obj.PerTypeDR'="N")
		...;q:(obj.PerStatus'="17||1") //只统计在职
		...;根据参数不同统计不同类型数据
		...;工作科室统计
		...i datatype="PerWordType" d
		....i obj.PerWordType'="" d
		.....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerWordType)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;工作层级统计
		...i datatype="level" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^CF.DHCINM.HR.MgLevelI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj=##class(CF.DHCINM.HR.MgLevel).%OpenId(typeid)
		.....i Perobj.LevelDate>typedate s typedate=Perobj.LevelDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj.NurLevel)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;聘任职称统计
		...i datatype="hireduty" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
		.....i Perobj.HireStDate>typedate s typedate=Perobj.HireStDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj.HireDuty)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;职务统计
		...i datatype="postduty" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^CF.DHCINM.HR.PostDutyI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj2=##class(CF.DHCINM.HR.PostDuty).%OpenId(typeid)
		.....i Perobj2.PostStDate>typedate s typedate=Perobj2.PostStDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj2.PostDuty)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;男护士衣号
		...i datatype="boyCloth" d
		....q:obj.PerSexDR'="6||1"
		....i obj.PerClothesNo'="" d
		.....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerClothesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;男护士鞋号
		...i datatype="boyShoes" d
		....q:obj.PerSexDR'="6||1"
		....i obj.PerShoesNo'="" d
		.....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerShoesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;女护士衣号
		...i datatype="girlCloth" d
		....q:obj.PerSexDR'="6||2"
		....i obj.PerClothesNo'="" d
		.....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerClothesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;女护士鞋号
		...i datatype="girlShoes" d
		....q:obj.PerSexDR'="6||2"
		....i obj.PerShoesNo'="" d
		.....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerShoesNo)
		.....i $d(tmp("head"," "_headname))=0 s tmp("head"," "_headname)=headname
		...;学历统计
		...i datatype="Academic" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj3=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
		.....i Perobj3.EduStDate>typedate s typedate=Perobj3.EduStDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj3.EduAcademic)
		....i (headname'="")&($d(tmp("head"," "_headname))=0) s tmp("head"," "_headname)=headname
		...;学位统计
		...i datatype="Degree" d
		....s headname=""
		....s typedate=0
		....s typeid=0
		....f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",prw,typeid)) q:typeid=""  d
		.....s Perobj3=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
		.....q:Perobj3.EduDegree="" 
		.....i Perobj3.EduStDate>typedate s typedate=Perobj3.EduStDate,headname=##class(web.INMPersonComm).GetCommCode(Perobj3.EduDegree)
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
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindPersonsCount","PerWordType")
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
	f  s NurseDep=$o(^CF.DHCINM.DB.MgWardI("Code",NurseDep)) q:NurseDep=""  d 
	.s warrw=0
	.;病区id
	.f  s warrw=$o(^CF.DHCINM.DB.MgWardI("Code",NurseDep,warrw)) q:warrw=""  d 
	..s prw=0 //personrw
	..;循环每个病人，区分统计数据类型，获取统计数据
	..f  s prw=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_warrw,prw)) q:prw=""  d 
	...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(prw)
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
	....f  s typeid=$o(^CF.DHCINM.HR.MgLevelI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj=##class(CF.DHCINM.HR.MgLevel).%OpenId(typeid)
	.....s PerobjCode=Perobj.NurLevel
	.....s PerobjDate=Perobj.LevelDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.INMPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------工作职称统计
	...i parr="hireduty" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj2=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	.....s PerobjCode=Perobj2.HireDuty
	.....s PerobjDate=Perobj2.HireStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.INMPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------工作职务统计
	...i parr="postduty" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^CF.DHCINM.HR.PostDutyI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj3=##class(CF.DHCINM.HR.PostDuty).%OpenId(typeid)
	.....s PerobjCode=Perobj3.PostDuty
	.....s PerobjDate=Perobj3.PostStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.INMPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------学历统计
	...i parr="Academic" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj4=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
	.....s PerobjCode=Perobj4.EduAcademic
	.....s PerobjDate=Perobj4.EduStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.INMPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------学位统计
	...i parr="Degree" d
	....s typedate=0
	....s typeid=0
	....f  s typeid=$o(^CF.DHCINM.HR.EducateI("ssid",prw,typeid)) q:typeid=""  d
	.....s Perobj4=##class(CF.DHCINM.HR.Educate).%OpenId(typeid)
	.....s PerobjCode=Perobj4.EduDegree
	.....s PerobjDate=Perobj4.EduStDate
	.....i PerobjDate>typedate s typedate=PerobjDate,headname=##class(web.INMPersonComm).GetCommCode(PerobjCode)
	....d ..saveTmp(headname,warrw,.tmp)
	
	...;-------工作科室统计
	...i parr="PerWordType" d
	....i obj.PerWordType'="" s headname=##class(web.INMPersonComm).GetCommCode(obj.PerWordType)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------男护士衣号统计
	...i parr="boyCloth" d
	....q:obj.PerSexDR'="6||1"
	....i obj.PerClothesNo'="" s headname=##class(web.INMPersonComm).GetCommCode(obj.PerClothesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------男护士鞋号统计
	...i parr="boyShoes" d
	....q:obj.PerSexDR'="6||1"
	....i obj.PerShoesNo'="" s headname=##class(web.INMPersonComm).GetCommCode(obj.PerShoesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------女护士衣号统计
	...i parr="girlCloth" d
	....q:obj.PerSexDR'="6||2"
	....i obj.PerClothesNo'="" s headname=##class(web.INMPersonComm).GetCommCode(obj.PerClothesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	...;-------女护士鞋号统计
	...i parr="girlShoes" d
	....q:obj.PerSexDR'="6||2"
	....i obj.PerShoesNo'="" s headname=##class(web.INMPersonComm).GetCommCode(obj.PerShoesNo)
	....d ..saveTmp(headname,warrw,.tmp)
	
	...;-------性别统计
	...i parr="sex" d
	....s headname=##class(web.INMPersonComm).GetCommCode(obj.PerSexDR)
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
	.s objward=##class(CF.DHCINM.DB.MgWard).%OpenId(warrw)
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
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindResignAndRetire","^4^^2020-09-01^",0,0)
Query FindResignAndRetire(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindResignAndRetireExecute(ByRef qHandle As %Binary, parr As %String = "", roles As %String, nurseid As %String) As %Status
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
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s toprole=$p(##class(web.INMLoginComm).GetTopRoleByLoginId(nurseid),"^",1)
	s tmp=""
	k tmp
	s RowID="" f  s RowID=$O(^DHCINM.HR.MgNurseResignD(RowID),-1) q:RowID=""  d
	.s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:((isAll'=1)&&(((toprole>=8)&&(obj.ResignName.%Id'=nurseid))||((toprole<8)&&('$d(tmpWard(obj.ResignWard))))))
	.s per=##class(CF.DHCINM.HR.Persons).%OpenId(obj.ResignName.%Id())
	.q:'$IsObject(per)
	.q:((nameval'="")&&(per.PerName'[nameval))
	.q:((wardval'="")&&(obj.ResignWard'=wardval))
	.q:((statusval'="")&&(per.PerStatus'="")&&(per.PerStatus'=statusval))
	.q:((stdate'="")&&(obj.ResignDate'="")&&(obj.ResignDate<stdate))
	.q:((enddate'="")&&(obj.ResignDate'="")&&(obj.ResignDate>enddate))
	.i per.PerStatus'="" s PerStatus=##class(web.INMPersonComm).GetCommCode(per.PerStatus)
	.e  s PerStatus=""
	.q:((PerStatus="")||(PerStatus="在职"))
	.s NurseName=per.PerName //姓名
	.s NurseID=per.PerID  //工号
	.s PerStatusReason=##class(web.INMInternComm).GetReason(per.PerStatuReason) //状态原因
	.s NurseDep=$list($g(^CF.DHCINM.DB.MgWardD(obj.ResignWard)),4) //病区
	.i per.PerComeDate'="" s PerComeDate=$zd(per.PerComeDate,3)  //来院日期
	.e  s PerComeDate=""
	.s Hireduty=""
	.s HiredutyID=0
	.s HireStDate=0
	.f  s HiredutyID=$o(^CF.DHCINM.HR.HireDutyI("ssid",obj.ResignName,HiredutyID)) q:HiredutyID=""  d
	..s obj1=##class(CF.DHCINM.HR.HireDuty).%OpenId(HiredutyID)
	..i obj1.HireStDate>HireStDate s Hireduty=##class(web.INMPersonComm).GetCommCode(obj1.HireDuty)
	.s PerWorkYears=""
	.s PerDuty=""
	.s PerAcademic=""
	.s comeDate=per.PerComeDate
	.i comeDate="" d
	..i per.PerWorkDate'="" s comeDate=per.PerWorkDate
	.i comeDate'="" d
	..s days=##class(web.INMVueComm).CalAge($zd(comeDate,3),$zd(obj.ResignDate,3))
	..s PerWorkYears=$e(($p(days," ")),0,($l($p(days," "))-1))_"年"_$e(($p(days," ",2)),0,($l($p(days," ",2))-1))_"月"_$e(($p(days," ",3)),0,($l($p(days," ",3))-1))_"天"
	.s PerDuty=obj.ResignDuty
	.s PerAcademic=obj.ResignAcademic
	.i PerDuty'="" s PerDuty=##class(web.INMPersonComm).GetCommCode(PerDuty)
	.i PerAcademic'="" s PerAcademic=##class(web.INMPersonComm).GetCommCode(PerAcademic)
	.s ResignDate=""
	.s:obj.ResignDate'="" ResignDate=$zd(obj.ResignDate,3)
	.s tmp(RowID)="NurseName|"_NurseName_"^NurseID|"_NurseID_"^PerStatus|"_PerStatus_"^NurseDep|"_NurseDep_"^PerComeDate|"_PerComeDate_"^Hireduty|"_Hireduty_"^PerStatusReason|"_PerStatusReason_"^PerWorkYears|"_PerWorkYears_"^PerAcademic|"_PerAcademic_"^PerDuty|"_PerDuty
	.s tmp(RowID)=tmp(RowID)_"^ResignDate|"_ResignDate
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
/// Table:CT.DHCINM.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindStatusCode","")
Query FindStatusCode() As %Query(ROWSPEC = "SubCode,SubDesc,SubValue")
{
}

ClassMethod FindStatusCodeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr("在职状态"," ",""),"U"),"")) 
	s desc="" f  s desc=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par,desc)) q:desc=""  d
	.s raw="" f  s raw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par,desc,raw)) q:raw=""  d
	..s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_raw)
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
/// Table:CT.DHCINM.DB.MgSetCode
/// Input:统计方式
/// Output：统计表的列信息
/// Return:
/// Others: w ##class(web.INMPersonCountComm).GetNurStatColumn("工作年限")
ClassMethod GetNurStatColumn(type As %String = "") As %String
{
	s legalType=$lb("职务","性别","护士层级","聘任职称","鞋号(男)","鞋号(女)","学历","职工性质","工作年限","平均年龄")
	s commonColor=$lb("#c23531","#2f4554","#61a0a8","#d48265","#91c7ae","#749f83","#ca8622","#bda29a","#6e7074","#546570",'"#c4ccd3")
	s commonColorIndex=0
	i '$lf(legalType,type)
	{
		q "[]"
	}
	s:(type="鞋号(男)")||(type="鞋号(女)") type="鞋号"
	s props=""
	i type="工作年限"
	{
		s props="{""Code"":""A"",""Desc"":""新员工"",""Color"":"""_$lg(commonColor,1)
		_"""},{""Code"":""B"",""Desc"":""1-5年"",""Color"":"""_$lg(commonColor,2)
		_"""},{""Code"":""C"",""Desc"":""5-10年"",""Color"":"""_$lg(commonColor,3)
		_"""},{""Code"":""D"",""Desc"":""10-15年"",""Color"":"""_$lg(commonColor,4)
		_"""},{""Code"":""E"",""Desc"":""15-20年"",""Color"":"""_$lg(commonColor,5)
		_"""},{""Code"":""F"",""Desc"":""20年以上"",""Color"":"""_$lg(commonColor,6)_"""}"
	}
	elseif type="平均年龄"
	{
		s props="{""Code"":""A"",""Desc"":""20岁以下"",""Color"":"""_$lg(commonColor,1)
		_"""},{""Code"":""B"",""Desc"":""20-30岁(不含)"",""Color"":"""_$lg(commonColor,2)
		_"""},{""Code"":""C"",""Desc"":""30-40岁(不含)"",""Color"":"""_$lg(commonColor,3)
		_"""},{""Code"":""D"",""Desc"":""40-50岁(不含)"",""Color"":"""_$lg(commonColor,4)
		_"""},{""Code"":""E"",""Desc"":""50岁以上"",""Color"":"""_$lg(commonColor,5)
		_"""},{""Code"":""AvgAge"",""Desc"":""平均年龄""}"
	}
	else
	{
		s codeId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt(type,"U"),""))
		s codeObj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(codeId)
		q:'$IsObject(codeObj) "[]"
		s props=""
		s subSort="" f  s subSort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
		.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
		..s subObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
		..q:('$IsObject(subObj))
		..q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
		..q:subObj.subFiterSymbol=0
		..s color=subObj.SubRemark
		..s:color="" commonColorIndex=commonColorIndex+1,mod=commonColorIndex#$ll(commonColor),color=$lg(commonColor,$case(mod,0:$ll(commonColor),:mod))
		..i props="" s props=props_"{""Code"":"""_subObj.SubCode_""",""Desc"":"""_subObj.SubDesc_""",""Color"":"""_color_"""}"
		..e  s props=props_","_"{""Code"":"""_subObj.SubCode_""",""Desc"":"""_subObj.SubDesc_""",""Color"":"""_color_"""}"
		s:props'="" props=props_",{""Code"":""UnDef"",""Desc"":""未定义"",""Color"":""#449be2""}"
	}
	i $g(props)'="" s props="[{""Code"":""WardDesc"",""Desc"":""名称""},"_props_",{""Code"":""WardTotal"",""Desc"":""合计""}]"
	e  s props="[]"
	w props
	q ""
}

/// Creator:wangpf
/// Description:统计职务、性别、护士层级、聘任职称、鞋号(男)、鞋号(女)、学历、职工性质、工作年限、平均年龄信息
/// Date:2019-10-25
/// Table:CF.DHCINM.HR.Persons CT.DHCINM.DB.MgSetCode
/// Input:病区ID 统计方式 
/// Output：相应类别的信息
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindNurStatistic","","护士层级",0,0,"","ALL")
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
		s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
		.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
		.q:'$IsObject(wardObj)
		.q:(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.s tmp(wardId,"WardTotal")=0,tmp(wardId,"WardDesc")=wardObj.WardDesc,tmp(wardId,"A")=0,tmp(wardId,"B")=0,tmp(wardId,"C")=0,tmp(wardId,"D")=0,tmp(wardId,"E")=0
		.i type="工作年限" s tmp(wardId,"F")=0
		.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_wardId,perId)) q:perId=""  d
		..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
		..q:('$IsObject(perObj))||(##class(web.INMPersonComm).GetCommCode(perObj.PerStatus)'["在职")
		..s propertyValue=$zobjproperty(perObj,propertyName)
		..i propertyValue'="" s dataDiff=$p(##class(web.INMVueComm).CalAge($zd(propertyValue,3),$zd(+$h,3)),"Y")
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
			s codeId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 性别",""))
			s sexSubId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Code",codeId," 男",""))
			s manSubId=codeId_"||"_sexSubId
		}
		elseif type="鞋号(女)"
		{
			s codeId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 性别",""))
			s sexSubId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Code",codeId," 女",""))
			s womanSubId=codeId_"||"_sexSubId
		}
		i propertyName'="PerShoesNo" s codeId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_type,""))
		e  s codeId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 鞋号",""))
		s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
		.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
		.q:'$IsObject(wardObj)
		.q:(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.s tmp(wardId,"WardTotal")=0,tmp(wardId,"WardDesc")=wardObj.WardDesc
		.s subSort="" f  s subSort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
		..s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
		...s subObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
		...q:('$IsObject(subObj))
		...q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
		...s tmp(wardId,subObj.SubCode)=0
		...s:$g(retAll(subObj.SubCode))="" retAll(subObj.SubCode)=0
		...s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_wardId,perId)) q:perId=""  d
		....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
		....q:('$IsObject(perObj))||(##class(web.INMPersonComm).GetCommCode(perObj.PerStatus)'["在职")
		....s flag=0
		....i type="职务" d
		.....s postData=(+$h+1) f  s postData=$o(^CF.DHCINM.HR.PostDutyI("PostDate",perId,postData),-1) q:(postData="")||(flag=1)  d
		......s postDutyId="" f  s postDutyId=$o(^CF.DHCINM.HR.PostDutyI("PostDate",perId,postData,postDutyId),-1) q:(postDutyId="")||(flag=1)  d
		.......s postDutyObj=##class(CF.DHCINM.HR.PostDuty).%OpenId(postDutyId)
		.......q:('$IsObject(postDutyObj))||((postDutyObj.PostEndDate'="")&&(postDutyObj.PostEndDate<+$h))||(postDutyObj.PostStatus'="A")
		.......q:postDutyObj.PostDuty'=subObj.%Id()
		.......s flag=1
		....e  i type="护士层级" d
		.....s levelDate=(+$h+1) f  s levelDate=$o(^CF.DHCINM.HR.MgLevelI("levelA",perId," A",levelDate),-1) q:(levelDate="")||(flag=1)  d
		......s levelId="" f  s levelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",perId," A",levelDate,levelId),-1) q:(levelId="")||(flag=1)  d
		.......s levelObj=##class(CF.DHCINM.HR.MgLevel).%OpenId(levelId)
		.......q:('$IsObject(levelObj))||(levelObj.LevelStatus'="A")
		.......q:levelObj.NurLevel'=subObj.%Id()
		.......s flag=1
		....e  i type="聘任职称" d
		.....s hireDutyDate=(+$h+1) f  s hireDutyDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",perId,hireDutyDate),-1) q:(hireDutyDate="")||(flag=1)  d
		......s hireDutyId="" f  s hireDutyId=$o(^CF.DHCINM.HR.HireDutyI("HireDate",perId,hireDutyDate,hireDutyId),-1) q:(hireDutyId="")||(flag=1)  d
		.......s hireDutyObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(hireDutyId)
		.......q:('$IsObject(hireDutyObj))||((hireDutyObj.HireEndDate'="")&&(hireDutyObj.HireEndDate<+$h))||(hireDutyObj.HireStatus'="A")
		.......q:hireDutyObj.HireDuty'=subObj.%Id()
		.......s flag=1
		....e  i type="学历" d
		.....s eduDate=(+$h+1) f  s eduDate=$o(^CF.DHCINM.HR.EducateI("flag",perId,eduDate),-1) q:(eduDate="")||(flag=1)  d
		......s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",perId,eduDate,eduId),-1) q:(eduId="")||(flag=1)  d
		.......s eduObj=##class(CF.DHCINM.HR.Educate).%OpenId(eduId)
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
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
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
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s wardSort="" f  s wardSort=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort)) q:wardSort=""  d
	.s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort,wardId)) q:wardId=""  d
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
	d ##class(web.INMDataLimit).GetRoleWardLoc(nurseid,1,.tmpWardLoc)
	s wardLocId="" f  s wardLocId=$o(tmpWardLoc(wardLocId)) q:wardLocId=""  d
	.q:(wardlocid'="")&&(wardlocid'=wardLocId)
	.s ret="WardDesc|"_tmpWardLoc(wardLocId)
	.s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",wardLocId,wardId)) q:wardId=""  d
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
	...s subSort="" f  s subSort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
	....s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
	.....s subObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
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

/// Creator:
/// Description:查询在职护士的人力分布
/// Date:2020-05-26
/// Table:CT.DHCINM.DB.MgSetCodeSub
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindPersonDistribute","0","0","2021-03-19!","Scourse","")
Query FindPersonDistribute(loginId As %String, parr As %String, type As %String, flag) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonDistributeExecute(ByRef qHandle As %Binary, loginId As %String, parr As %String, type As %String, flag) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindPersonDistribute")=loginId_"#"_parr_"#"_type_"#"_flag
	s searchDate=+$p(parr,"!",1)
	s:$p(parr,"!",1)["-" date=$zdh($p(parr,"!",1),3)
	s:$p(parr,"!",1)'["-" date=+$h
	s ward=$p(parr,"!",2)
	s tmpWard="",tmp="",summary=0
	s IsAll=##class(web.INMLoginComm).SetLoginWard(loginId,.tmpWard)
	s wardSort="" f  s wardSort=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort))  q:wardSort=""  d
	.s wardId=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort,""))
	.q:wardId=""
	.q:(ward'="")&&(wardId'=ward)
	.q:(ward="")&&(IsAll'=1)&&('$d(tmpWard(wardId)))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(wardId))
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:((wardStDate="")||(wardStDate>+$h))||((wardEndDate'="")&&(wardEndDate<+$h))
	.s perDR="" f  s perDR=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_wardId,perDR))  q:perDR=""  d
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
	..q:'$IsObject(perObj)
	..s currentFlag=0
	..s:flag="" currentFlag=##class(web.INMHRComm).IsFormalWorkNur(perDR,date,"")
	..i (flag="resign")&&(##class(web.INMPersonComm).GetCommCode(perObj.PerStatus)="离职") d
	...s currentFlag=((perObj.PerStateDate'="")&&(perObj.PerStateDate<date))
	..q:currentFlag=0
	..s wardObj=$g(^CF.DHCINM.DB.MgWardD(wardId))
	..q:wardObj=""
	..s wardDesc=$lg(wardObj,4)
	..s tmp(wardId)=wardDesc
	..;人力分布
	..i (type="Person")  d
	...s tmp(wardId,"PerNum")=$g(tmp(wardId,"PerNum"))+1
	...i flag="" s tmp(wardId,"人数")=$g(tmp(wardId,"人数"))+1
	...e  s tmp(wardId,"离职人数")=$g(tmp(wardId,"离职人数"))+1
	...;s tmp("0","PerNum")=$g(tmp("0","PerNum"))+1
	...s summary=summary+1
	..;职称分布
	..i (type="HireDuty")  d
	...s currentHireDuty=##class(web.INMHRComm).GetNurseHireDuty(perDR,date)
	...s hireID=""
	...i currentHireDuty'=""  d
	....s hireID=$tr($p(currentHireDuty,"^",1),"|","_")
	....s hireDesc=$p(currentHireDuty,"^",2)
	....s tmp(wardId,hireID)=$g(tmp(wardId,hireID))+1
	....s tmp(wardId,hireDesc)=$g(tmp(wardId,hireDesc))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;职务分布
	..i (type="PostDuty")  d
	...s currentPostDuty=##class(web.INMHRComm).GetNurseDuty(perDR,date)
	...s postID=""
	...i currentPostDuty'=""  d
	....s postID=$tr($p(currentPostDuty,"^",1),"|","_")
	....s postDesc=$p(currentPostDuty,"^",2)
	....s tmp(wardId,postID)=$g(tmp(wardId,postID))+1
	....s tmp(wardId,postDesc)=$g(tmp(wardId,postDesc))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;层级分布
	..i (type="Level")  d
	...s currentLevel=##class(web.INMHRComm).GetNurseLevel(perDR,date)
	...s levelID=""
	...i currentLevel'=""  d
	....s levelID=$tr($p(currentLevel,"^",1),"|","_")
	....s levelDesc=$p(currentLevel,"^",2)
	....s tmp(wardId,levelID)=$g(tmp(wardId,levelID))+1
	....s tmp(wardId,levelDesc)=$g(tmp(wardId,levelDesc))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;性别分布
	..i (type="Sex")  d
	...s currentSex=$tr(perObj.PerSexDR,"|","_")
	...i currentSex'=""  d
	....s sexDesc=##class(web.INMPersonComm).GetCommCode(perObj.PerSexDR)
	....s tmp(wardId,currentSex)=$g(tmp(wardId,currentSex))+1
	....s tmp(wardId,sexDesc)=$g(tmp(wardId,sexDesc))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;学历分布
	..i (type="Education")  d
	...s currentEdu=##class(web.INMHRComm).GetNurseEdu(perDR,date)
	...s eduID=""
	...i ((currentEdu'="")&&(currentEdu'="^"))  d
	....s eduID=$tr($p(currentEdu,"^",1),"|","_")
	....s eduDesc=$p(currentEdu,"^",2)
	....s tmp(wardId,eduID)=$g(tmp(wardId,eduID))+1
	....s tmp(wardId,eduDesc)=$g(tmp(wardId,eduDesc))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;聘用类别分布
	..i (type="Scourse")  d
	...s currentEmploye=$tr(perObj.PerSource,"|","_")
	...i currentEmploye'=""  d
	....s employe=##class(web.INMPersonComm).GetCommCode(perObj.PerSource)
	....s tmp(wardId,currentEmploye)=$g(tmp(wardId,currentEmploye))+1
	....s tmp(wardId,employe)=$g(tmp(wardId,employe))+1
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	...e  s tmp(wardId,"0")=$g(tmp(wardId,"0"))
	..;工作年限分布
	..i (type="WorkYear")  d
	...s workStDate=perObj.PerWorkDate
	...s:workStDate="" workStDate=perObj.PerComeDate
	...s days=(+$h)-workStDate
	...s years=days\(12*30)
	...i years<10  d
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	....s:years<1 tmp(wardId,"1")=$g(tmp(wardId,"1"))+1,tmp(wardId,"<1年资")=$g(tmp(wardId,"<1年资"))+1
	....s:(years>=1)&&(years<2) tmp(wardId,"2")=$g(tmp(wardId,"2"))+1,tmp(wardId,"1≤y<2年资")=$g(tmp(wardId,"1≤y<2年资"))+1
	....s:(years>=2)&&(years<5) tmp(wardId,"3")=$g(tmp(wardId,"3"))+1,tmp(wardId,"2≤y<5年资")=$g(tmp(wardId,"2≤y<5年资"))+1
	....s:(years>=5) tmp(wardId,"4")=$g(tmp(wardId,"4"))+1,tmp(wardId,"5≤y<10年资")=$g(tmp(wardId,"5≤y<10年资"))+1
	...e  d
	....s summary=$g(summary)+1
	....s tmp(wardId,"0")=$g(tmp(wardId,"0"))+1
	....s tmp(wardId,"5")=$g(tmp(wardId,"5"))+1,tmp(wardId,">=10年资")=$g(tmp(wardId,">=10年资"))+1
	....s:(years>=10)&&(years<20) tmp(wardId,"6")=$g(tmp(wardId,"6"))+1,tmp(wardId,"10≤y<20年资")=$g(tmp(wardId,"10≤y<20年资"))+1
	....s:(years>=20) tmp(wardId,"7")=$g(tmp(wardId,"7"))+1,tmp(wardId,">=20年资")=$g(tmp(wardId,">=20年资"))+1
	..;续注分布
	..i (type="NeedReg")  d
	...s registedId=$o(^DHCINM.HR.MgQualRegistedI("Assid"," "_perDR," A",""),-1)
	...q:registedId=""
	...s registedObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(registedId)
	...q:'$isObject(registedObj)
	...d ..CountNeedRegByMonth(wardId,registedObj.RegistedDate,searchDate,.tmp,.summary)
	..;年龄分布
	..i type="Age"  d
	...s age=$fn(((+$h)-perObj.PerBirthday)/365,"",0)
	...i age>=40 d
	....s summary=summary+1
	....i age<50 s tmp(wardId,3)=$g(tmp(wardId,3))+1,tmp(wardId,"40<=年龄<50")=$g(tmp(wardId,"40<=年龄<50"))+1
	....e  s tmp(wardId,4)=$g(tmp(wardId,4))+1,tmp(wardId,"年龄>=50")=$g(tmp(wardId,"年龄>=50"))+1
	...e  d
	....s summary=summary+1
	....i age>=30 s tmp(wardId,2)=$g(tmp(wardId,2))+1,tmp(wardId,"30<=年龄<40")=$g(tmp(wardId,"30<=年龄<40"))+1
	....i (age<30)&&(age>=20) s tmp(wardId,1)=$g(tmp(wardId,1))+1,tmp(wardId,"20<=年龄<30")=$g(tmp(wardId,"20<=年龄<30"))+1
	..;离职原因分布
	..i type="Reason"  d
	...s resign=$o(^DHCINM.HR.MgNurseResignI("ssid",perDR,""))
	...q:resign=""
	...s reason=$lg(^DHCINM.HR.MgNurseResignD(resign),5)
	...for i=1:1:$l(reason,"~")  d
	....s summary=summary+1
	....s rw=$tr($P(reason,"~",i),"|","_")
	....s reasonDesc=##class(web.INMPersonComm).GetCommCode($P(reason,"~",i))
	....q:reasonDesc=""
	....s tmp(wardId,rw)=$g(tmp(wardId,rw))+1
	....s tmp(wardId,reasonDesc)=$g(tmp(wardId,reasonDesc))+1
	s getWardId="" f  s getWardId=$o(tmp(getWardId))  q:getWardId=""  d
	.s ret="Ward|"_tmp(getWardId)_"^WardId|"_getWardId
	.s parameter="" f  s parameter=$o(tmp(getWardId,parameter)) q:parameter=""  d
	..i parameter="PerNum"  d
	...s:tmp(getWardId)'=0 value=tmp(getWardId,parameter)_"#"_$fn((tmp(getWardId,parameter)*100)/(summary),"",2)_"%"
	...s:tmp(getWardId)=0 value=tmp(getWardId,parameter)_"#0%"
	..e  d
	...s value=tmp(getWardId,parameter)
	..s ret=ret_"^"_parameter_"|"_value
	.s ret=ret_"^Total|"_$g(summary)
	.do OutputPub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonDistributeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonDistributeExecute ]
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

ClassMethod FindPersonDistributeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonDistributeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(web.INMPersonCountComm).CountNeedRegByMonth(24,61660,2021,"","")

ClassMethod CountNeedRegByMonth(ward, regdate, date, tmp, summary)
{
	;s outDate=regdate+(5*30*12)
	s outYear=$p($zd(regdate,3),"-")
	s outMonth=$p($zd(regdate,3),"-",2)
	s outDay=$p($zd(regdate,3),"-",3)
	s endDate=$zdh((outYear+5)_"-"_outMonth_"-"_outDay,3)
	s year=+($zd(endDate,3))
	i date["-" s date=$zdh(date,3)

	i (endDate-date)<=30  d
	.s month=1
	.s:year=+($zd(date,3)) month=$p($zd(endDate-30,3),"-",2)
	.f i=month:1:12  d
	..s tmp(ward,i)=$g(tmp(ward,i))+1
	..s tmp(ward,i_"月")=$g(tmp(ward,i_"月"))+1
	..s summary=$g(summary)+1
	..s tmp(ward,"0")=$g(tmp(ward,"0"))+1
}

/// creator: wangcc
/// createdate: 20200715
/// description: 获取人力指标详情
/// table: CF.DHCINM.HR.Persons
/// input:parr:'HireDuty|1__1^date|2020-04-05^ward|1'  查询date日期的1__1的职称的人员
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindDetail","ward|1^date|2021-03-22^Reason|20__2","resign")
Query FindDetail(parr As %String = "", flag) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDetailExecute(ByRef qHandle As %Binary, parr As %String = "", flag) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s stdate=+$h
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("date"))'="" s stdate=$zdh(tmp("date"),3)
	s perdr="" f  s perdr=$O(^CF.DHCINM.HR.PersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.q:($g(tmp("ward"))'=perobj.PerDepDR)
	.s currentFlag=0
	.s:flag="" currentFlag=##class(web.INMHRComm).IsFormalWorkNur(perdr,stdate,"")
	.i (flag="resign")&&(##class(web.INMPersonComm).GetCommCode(perobj.PerStatus)="离职") d
	..s currentFlag=((perobj.PerStateDate'="")&&(perobj.PerStateDate<stdate))
	.q:currentFlag=0
	.s warddesc=""
	.s perward=$g(tmp("ward"))
	.s wardObj=$g(^CF.DHCINM.DB.MgWardD(perward))
	.q:wardObj=""
	.s warddesc=$lg(wardObj,4)
	.s perid=perobj.PerID
	.s pername=perobj.PerName
	.s hduty=##class(web.INMHRComm).GetNurseHireDuty(perdr,stdate)
	.q:($g(tmp("HireDuty"))'="")&&(($g(tmp("HireDuty"))'=$p(hduty,"^",1))||(hduty=""))
	.q:(($d(tmp("HireDuty"))=1)&&(tmp("HireDuty")=""))&&(hduty="")
	.s hdutydesc=$p(hduty,"^",2)
	.s pduty=##class(web.INMHRComm).GetNurseDuty(perdr,stdate)
	.q:($g(tmp("PostDuty"))'="")&&(($g(tmp("PostDuty"))'=$p(pduty,"^",1))||(pduty=""))
	.q:(($d(tmp("PostDuty"))=1)&&(tmp("PostDuty")=""))&&(pduty="")
	.s pdutydesc=$p(pduty,"^",2)
	.s levelid=##class(web.INMHRComm).GetNurseLevel(perdr,stdate)
	.q:($g(tmp("Level"))'="")&&(($g(tmp("Level"))'=$p(levelid,"^",1))||(levelid=""))
	.q:(($d(tmp("Level"))=1)&&(tmp("Level")=""))&&(levelid="")
	.s leveldesc=$p(levelid,"^",2)
	.s sexid=perobj.PerSexDR
	.q:($g(tmp("Sex"))'="")&&(sexid'="")&&($g(tmp("Sex"))'=sexid)
	.q:(($d(tmp("Sex"))=1)&&(tmp("Sex")=""))&&(sexid="")
	.s sexdesc=##class(web.INMPersonComm).GetCommCode(sexid)
	.s academicid=##class(web.INMHRComm).GetNurseEdu(perdr,stdate)
	.q:($g(tmp("Education"))'="")&&(($g(tmp("Education"))'=$p(academicid,"^",1))||(academicid=""))
	.q:(($d(tmp("Education"))=1)&&(tmp("Education")=""))&&(academicid="")
	.s academicdesc=$p(academicid,"^",2)
	.s source=perobj.PerSource
	.q:($g(tmp("Scourse"))'="")&&(($g(tmp("Scourse"))'=source)||(source=""))
	.q:(($d(tmp("Scourse"))=1)&&(tmp("Scourse")=""))&&(source="")
	.s sourcedesc=##class(web.INMPersonComm).GetCommCode(source)
	.;年资筛选
	.s flag1=0 
	.s workStDate=perobj.PerWorkDate
	.s:workStDate="" workStDate=perobj.PerComeDate
	.s days=(stdate)-workStDate
	.s years=days\(12*30)
	.i years<1  d
	..s flag1=1
	.i (flag1=0)&&(years<2)&&(years>=1) d
	..s flag1=2
	.i (flag1=0)&&(years<5)&&(years>=2) d
	..s flag1=3
	.i (flag1=0)&&(years<10)&&(years>=5) d
	..s flag1=4
	.i (flag1=0)&&(years<20)&&(years>=10) d
	..s flag1=6
	.i (flag1=0)&&(years>=20) d
	..s flag1=7
	.i ($g(tmp("WorkYear"))=5)&&(years>=10) d
	..s flag1=5
	.q:($g(tmp("WorkYear"))'="")&&($g(tmp("WorkYear"))'=flag1)
	.;是否需要续注册证书
	.q:($g(tmp("NeedReg"))="needreg")&&(..IsNeedRegisted(perdr,stdate)=0)
	.s needreg=..IsNeedRegisted(perdr,stdate)
	.s flag3=0
	.s age=$fn(((+$h)-perobj.PerBirthday)/365,"",0)
	.i age>=40 d
	..i age<50 s flag3=3
	..e  s flag3=4
	.e  d
	..i age>=30 s flag3=2
	..e  i (age>=20) s flag3=1
	.q:($g(tmp("Age"))'="")&&(flag3'=tmp("Age"))
	..;离职原因分布
	.s reason="",reasondesc="",reasonid="",reasons=""
	.i flag="resign"  d
	..s resign=$o(^DHCINM.HR.MgNurseResignI("ssid",perdr,""))
	..q:resign=""
	..s reason=$lg(^DHCINM.HR.MgNurseResignD(resign),5)
	..for i=1:1:$l(reason,"~")  d
	...s rw=$P(reason,"~",i)
	...s reasonid=reasonid_","_rw
	...s reasondesc=##class(web.INMPersonComm).GetCommCode($P(reason,"~",i))
	...s reasons=reasons_","_reasondesc
	.q:($g(tmp("Reason"))'="")&&(((","_reasonid_",")'[(","_tmp("Reason")_","))||(reasonid=""))
	.s perid=perobj.PerID
	.s pername=perobj.PerName
	.s NurType=##class(web.INMPersonComm).GetCommCode(perobj.PerInNursePost)
	.s ret="perdr|"_perdr_"^PerID|"_perid_"^PerName|"_pername_"^perward|"_perward_"^WardDesc|"_warddesc_"^PDuty|"_pdutydesc_"^HDuty|"_hdutydesc_"^Level|"_leveldesc
	.s ret=ret_"^Sex|"_sexdesc_"^NurType|"_NurType_"^Academic|"_academicdesc_"^Scourse|"_sourcedesc_"^WorkYear|"_years_"^NeedReg|"_needreg
	.s ret=ret_"^Resign|"_$e(reasons,2,*)_"^Age|"_age
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailExecute ]
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

/// 是否需要续注册
ClassMethod IsNeedRegisted(perdr, date)
{
	s registedId=$o(^DHCINM.HR.MgQualRegistedI("Assid"," "_perdr," A",""),-1)
	q:registedId="" 0
	s registedObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(registedId)
	q:'$isObject(registedObj) 0
	;s outdate=registedObj.RegistedDate+(5*30*12)
	s regdate=registedObj.RegistedDate
	s outYear=$p($zd(regdate,3),"-")
	s outMonth=$p($zd(regdate,3),"-",2)
	s outDay=$p($zd(regdate,3),"-",3)
	s outdate=$zdh((outYear+5)_"-"_outMonth_"-"_outDay,3)
	q:(outdate-date)>30 0
	q:(outdate-date)<=30 $zd(registedObj.RegistedDate,3)
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子表信息
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindPubCode","职工性质")
Query FindPubCode(type As %String = "") As %Query(ROWSPEC = "SubCode,SubDesc,SubValue")
{
}

ClassMethod FindPubCodeExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	s ^TMP("FindPubCodeExecute")=type
	s repid=$I(^CacheTemp)
	s ind=1
	s par="" f  s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(type," ",""),"U"),par)) q:par=""  d
	.s sort="" f  s sort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort)) q:sort=""  d
	..s raw="" f  s raw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort,raw)) q:raw=""  d
	...s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_raw)
	...s date=+$H
	...s SubStDate=obj.SubStDate
	...s SubEndDate=obj.SubEndDate
	...q:(SubStDate'="")&&(date<SubStDate)
	...q:((SubEndDate'="")&&(date>SubEndDate))
	...s SubCode=obj.SubCode
	...s SubDesc=obj.SubDesc
	...do OutputPub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPub
	set Data=$lb(SubCode,SubDesc,par_"__"_raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPubCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPubCodeExecute ]
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

ClassMethod FindPubCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPubCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询弹性调配统计
/// Date:2020-07-27
/// Table:CF.DHCINM.Trans.TransDep
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindTransCountData","2020-01-01^2020-12-31^month",0)
Query FindTransCountData(parr As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransCountDataExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stdate=$p(parr,"^",1)
	s enddate=$p(parr,"^",2)
	s model=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s tmp=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perId="" f  s perId=$O(^DHCINM.Trans.MgTransNurseI("ssid",perId)) q:perId=""  d
	.s id="" f  s id=$O(^DHCINM.Trans.MgTransNurseI("ssid",perId,id)) q:id=""  d
	..s status=$lg(^DHCINM.Trans.MgTransNurseD(id),13)
	..q:status'="Y"
	..s inFlag=0,outFlag=0
	..s stDate=$lg(^DHCINM.Trans.MgTransNurseD(id),7)
	..s endDate=$lg(^DHCINM.Trans.MgTransNurseD(id),8)
	..q:endDate=""
	..s inWard=$lg(^DHCINM.Trans.MgTransNurseD(id),5)
	..s outWard=$lg(^DHCINM.Trans.MgTransNurseD(id),4)
	..q:(isAll=0)&&('$d(tmpWard(inWard)))&&('$d(tmpWard(outWard)))
	..s:(isAll=1)||($d(tmpWard(inWard))) inFlag=1
	..s:(isAll=1)||($d(tmpWard(outWard))) outFlag=1	
	..i (stDate>=stdate)&&(stDate<=enddate) d
	...s transDate=$zd(stDate,3)
	...s month=$p(transDate,"-",2)
	...s year=+transDate
	...i model="month" d
	....s:inFlag=1 tmp(inWard,month)=$g(tmp(inWard,month))+1
	....s:outFlag=1 tmp(outWard,month)=$g(tmp(outWard,month))+1
	...e  i (model="quarter") d
	....s quarter=""
	....i month<=3 s quarter=1
	....e  i month<=6 s quarter=2
	....e  i month<=9 s quarter=3
	....e  s quarter=4
	....s:inFlag=1 tmp(inWard,quarter)=$g(tmp(inWard,quarter))+1
	....s:outFlag=1 tmp(outWard,quarter)=$g(tmp(outWard,quarter))+1
	...e  i (model="halfyear") d
	....s half=""
	....i month<=6 s half=1
	....e  s half=2
	....s:inFlag=1 tmp(inWard,half)=$g(tmp(inWard,half))+1
	....s:outFlag=1 tmp(outWard,half)=$g(tmp(outWard,half))+1
	...e  d
	....s:inFlag=1 tmp(inWard,year)=$g(tmp(inWard,year))+1
	....s:outFlag=1 tmp(outWard,year)=$g(tmp(outWard,year))+1
	...s:inFlag=1 tmp(inWard)=$g(tmp(inWard))+1
	...s:outFlag=1 tmp(outWard)=$g(tmp(outWard))+1
	s wardid="" f  s wardid=$o(tmp(wardid)) q:wardid=""  d
	.s warddesc=$lg(^CF.DHCINM.DB.MgWardD($tr(wardid," ","")),4)
	.s ret="Ward|"_warddesc
	.s datedesc="" f  s datedesc=$o(tmp(wardid,datedesc)) q:datedesc=""  d
	..s ret=ret_"^"_datedesc_"|"_$g(tmp(wardid,datedesc))_"^WardId|"_wardid
	.s ret=ret_"^Summary|"_$g(tmp(wardid))
	.do OutputTransCountData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransCountData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransCountDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransCountDataExecute ]
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

ClassMethod FindTransCountDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransCountDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询弹性调配统计明细
/// Date:2020-07-27
/// Table:CF.DHCINM.Trans.TransDep
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindTransDetailData","2^2020-11-01^2020-12-01",0)
Query FindTransDetailData(parr As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransDetailDataExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s enddate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s perId="" f  s perId=$O(^DHCINM.Trans.MgTransNurseI("ssid",perId)) q:perId=""  d
	.s id="" f  s id=$O(^DHCINM.Trans.MgTransNurseI("ssid",perId,id)) q:id=""  d
	..s status=$lg(^DHCINM.Trans.MgTransNurseD(id),13)
	..q:status'="Y"
	..s inWard=$lg(^DHCINM.Trans.MgTransNurseD(id),5)
	..s outWard=$lg(^DHCINM.Trans.MgTransNurseD(id),4)
	..q:(ward'=inWard)&&(ward'=outWard)
	..s stDate=$lg(^DHCINM.Trans.MgTransNurseD(id),7)
	..s endDate=$lg(^DHCINM.Trans.MgTransNurseD(id),8)
	..q:(stDate'="")&&(stdate'="")&&((stDate<stdate)||(stDate>enddate))
	..s inWardDesc=$lg(^CF.DHCINM.DB.MgWardD(inWard),4)
	..s outWardDesc=$lg(^CF.DHCINM.DB.MgWardD(outWard),4)
	..s type=$lg(^DHCINM.Trans.MgTransNurseD(id),6)
	..s:type="Plan" type="计划性调配"
	..s:type="Random" type="随机性调配"
	..s days=$lg(^DHCINM.Trans.MgTransNurseD(id),9)
	..s stDate=$zd(stDate,3)
	..s:endDate'="" endDate=$zd(endDate,3)
	..s perName=$lg(^CF.DHCINM.HR.PersonsD($tr(perId," ","")),2)
	..s ret="Person|"_perName_"^InWard|"_inWardDesc_"^OutWard|"_outWardDesc_"^StDate|"_stDate_"^EndDate|"_endDate
	..s ret=ret_"^TransType|"_type_"^Days|"_days
	..do OutputTransPositionData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransPositionData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransDetailDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransDetailDataExecute ]
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

ClassMethod FindTransDetailDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransDetailDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询护理调岗统计
/// Date:2020-07-27
/// Table:DHCINM.Trans.MgTransPositionApp
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindTransPositionData","2021-01-01^2021-12-31^year",0)
Query FindTransPositionData(parr As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPositionDataExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stdate=$p(parr,"^",1)
	s enddate=$p(parr,"^",2)
	s model=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s ward="" f  s ward=$O(^DHCINM.Trans.MgTransPosiI("ward",ward)) q:ward=""  d
	.s tmpWardId=$tr(ward," ","")
	.s:tmpWardId="" tmpWardId=0
	.q:(isAll=0)&&('$d(tmpWard(tmpWardId)))
	.s tmp=""
	.s appid="" f  s appid=$O(^DHCINM.Trans.MgTransPosiI("ward",ward,appid)) q:appid=""  d
	..s obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(appid)
	..q:'$IsObject(obj)
	..q:obj.AppStatus'="A"
	..s appdate=$zd(obj.AppDate,3)
	..i (obj.AppDate>=stdate)&&(obj.AppDate<=enddate)  d
	...s month=$p(appdate,"-",2)
	...s year=+appdate
	...i model="month" d
	....s tmp($tr(ward," ",""),month)=$g(tmp($tr(ward," ",""),month))+1
	...e  i (model="quarter")  d
	....s quarter=""
	....i month<=3 s quarter=1
	....e  i month<=6 s quarter=2
	....e  i month<=9 s quarter=3
	....e  s quarter=4
	....s tmp($tr(ward," ",""),quarter)=$g(tmp($tr(ward," ",""),quarter))+1
	...e  i (model="halfyear")  d
	....s half=""
	....i month<=6 s half=1
	....e  s half=2
	....s tmp($tr(ward," ",""),half)=$g(tmp($tr(ward," ",""),half))+1
	...e  d
	....s tmp($tr(ward," ",""),year)=$g(tmp($tr(ward," ",""),year))+1
	...s tmp($tr(ward," ",""))=$g(tmp($tr(ward," ","")))+1
	.s wardid="" f  s wardid=$o(tmp(wardid))  q:wardid=""  d
	..s warddesc=$lg(^CF.DHCINM.DB.MgWardD($tr(wardid," ","")),4)
	..s ret="Ward|"_warddesc
	..s datedesc="" f  s datedesc=$o(tmp(wardid,datedesc)) q:datedesc=""  d
	...s ret=ret_"^"_datedesc_"|"_$g(tmp(wardid,datedesc))_"^WardId|"_wardid
	..s ret=ret_"^Summary|"_$g(tmp(wardid))
	.q:ret=""
	.do OutputTransPositionData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransPositionData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPositionDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPositionDataExecute ]
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

ClassMethod FindTransPositionDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPositionDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询护理调岗统计明细
/// Date:2020-07-27
/// Table:DHCINM.Trans.MgTransPositionApp
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindTransPosDetailData","7^2020-10-01^2020-12-31",0)
Query FindTransPosDetailData(parr As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPosDetailDataExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s enddate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s appid="" f  s appid=$O(^DHCINM.Trans.MgTransPosiI("ward"," "_ward,appid)) q:appid=""  d
	.s obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(appid)
	.q:'$IsObject(obj)
	.q:obj.AppStatus'="A"
	.s appdate=$zd(obj.AppDate,3)
	.q:(stdate'="")&&(obj.AppDate<stdate)
	.q:(enddate'="")&&(obj.AppDate>enddate)
	.s position=##class(web.INMPersonComm).GetCommCode(obj.AppPosition)
	.s nurse=$lg(^CF.DHCINM.DB.MgUserD(obj.CreateUser),2)
	.s warddesc=$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	.s ret="Person|"_nurse_"^Ward|"_warddesc_"^AppDate|"_appdate_"^AppPosition|"_position
	.do OutputTransPositionData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransPositionData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPosDetailDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPosDetailDataExecute ]
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

ClassMethod FindTransPosDetailDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPosDetailDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: LCY
/// CeateDate: 2020-12-04
/// Description: 人员一览表
/// Table: CF.DHCINM.DB.MgWard,CF.DHCINM.HR.Persons,CF.DHCINM.HR.Educate,CF.DHCINM.HR.PostDuty,CF.DHCINM.HR.HireDuty,CF.DHCINM.HR.MgLevel,CT.DHCINM.DB.MgSetCodeSub,CT.DHCINM.DB.MgSetCode
/// Input: 病区id,查询类型,角色,护士id,科室,查询类型
/// Return：
/// Output: 查询类型下各个子类数量
/// Other: d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindPersonnelList","","工作年限","0","0","OWN","")
Query FindPersonnelList(wardid As %String = "", type As %String = "", role As %String = "", nurseid As %String = "", outputtype As %String = "ALL,WARD", detail As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPersonnelListExecute(ByRef qHandle As %Binary, wardid As %String = "", type As %String = "", role As %String = "", nurseid As %String = "", outputtype As %String = "ALL,WARD", detail As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1,ret="",result=""
	i ((nurseid="")||(role="")||(type=""))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	// 若查询某一项总数与护士档案查询一致，但每一项存在数量不同。原因：获取的数据中启用日期当天存在多条数据，若要准确数据，请项目修改数据
	s retAll="WardDesc|全院",tmpCounterAll=0
	s retAll("A")=0,retAll("B")=0,retAll("C")=0,retAll("D")=0,retAll("E")=0
	s ward="" f  s ward=$O(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:($lg(^CF.DHCINM.DB.MgWardD(ward),11)="")||($lg(^CF.DHCINM.DB.MgWardD(ward),11)>+$H) // 病区启用日期为空或者未到启用日期
	.q:(($lg(^CF.DHCINM.DB.MgWardD(ward),12)'="")&&($lg(^CF.DHCINM.DB.MgWardD(ward),12)<+$H)) // 病区停用日期不为空且停用日期小于今天
	.s tmp(ward,"WardTotal")=0,tmp(ward,"WardDesc")=$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	.i type="平均年龄" d
	..s tmp(ward,"A")=0,tmp(ward,"B")=0,tmp(ward,"C")=0,tmp(ward,"D")=0,tmp(ward,"E")=0
	.e  i ((type="年资")!(type="工作年限")) d
	..s tmp(ward,"A")=0,tmp(ward,"B")=0,tmp(ward,"C")=0,tmp(ward,"D")=0,tmp(ward,"E")=0,tmp(ward,"F")=0
	.e  d
	..i ((type="当前学历")||(type="第一学历")||(type="学历")) d
	...s codeId = $O(^CT.DHCINM.DB.MgSetCodeI("Code"," 学历",""))
	..e  d
	...s codeId=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_type,""))
	..s subId="" f  s subId=$O(^CT.DHCINM.DB.MgSetCodeSubD(codeId,subId)) q:subId=""  d
	...s subGlo = ^CT.DHCINM.DB.MgSetCodeSubD(codeId,subId)
	...q:(($lg(subGlo,5)="")||($lg(subGlo,5)>+$H)||(($lg(subGlo,6)'="")&&($lg(subGlo,6)<+$h))) // 停用日期不为空，且停用日期小于今天
	...q:($lg(subGlo,9)=0)
	...s tmp(ward,$lg(subGlo,2))=0
	...s:'$d(retAll($lg(subGlo,2))) retAll($lg(subGlo,2))=0
	...s:'$d(tmp(ward,"UnDef")) tmp(ward,"UnDef")=0 ;,retAll("UnDef")=0
	...s:'$d(retAll("UnDef")) retAll("UnDef")=0
	.s per="" f  s per=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_ward,per)) q:per=""  d
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..q:($lg(perGlo,25)'="N")
	..q:((##class(web.INMPersonComm).GetCommCode($lg(perGlo,42)))'["在职")
	..s codeSubId="",flag=0
	..i type="平均年龄" d
	...i $lg(perGlo,6)'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd($lg(perGlo,6),3),$zd(+$h,3))),"Y")
	...e  s dataDiff=0
	...s tmp(ward,"WardTotalAge")=$fn($g(tmp(ward,"WardTotalAge")),"")+dataDiff
	...s totalAgeAll=$fn($g(totalAgeAll),"")+dataDiff
	...i dataDiff<20 s tmp(ward,"A")=$g(tmp(ward,"A"))+1,retAll("A")=$g(retAll("A"))+1
	...e  i (dataDiff>=20)&&(dataDiff<30) s tmp(ward,"B")=$g(tmp(ward,"B"))+1,retAll("B")=$g(retAll("B"))+1
	...e  i (dataDiff>=30)&&(dataDiff<40) s tmp(ward,"C")=$g(tmp(ward,"C"))+1,retAll("C")=$g(retAll("C"))+1
	...e  i (dataDiff>=40)&&(dataDiff<50) s tmp(ward,"D")=$g(tmp(ward,"D"))+1,retAll("D")=$g(retAll("D"))+1
	...e  s tmp(ward,"E")=$g(tmp(ward,"E"))+1,retAll("E")=$g(retAll("E"))+1
	...s tmp(ward,"WardTotal")=tmp(ward,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
	..e  i (type="年资")!(type="工作年限") d
	...s flag=1
	...i $lg(perGlo,12)'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd($lg(perGlo,12),3),$zd(+$h,3))),"Y")
	...e  s dataDiff=0
	...i dataDiff<1 s tmp(ward,"A")=$g(tmp(ward,"A"))+1,retAll("A")=$g(retAll("A"))+1,tmp(ward,"A",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...e  i (dataDiff>=1)&&(dataDiff<2) s tmp(ward,"B")=$g(tmp(ward,"B"))+1,retAll("B")=$g(retAll("B"))+1,tmp(ward,"B",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...e  i (dataDiff>=2)&&(dataDiff<5) s tmp(ward,"C")=$g(tmp(ward,"C"))+1,retAll("C")=$g(retAll("C"))+1,tmp(ward,"C",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...e  i (dataDiff>=5)&&(dataDiff<10) s tmp(ward,"D")=$g(tmp(ward,"D"))+1,retAll("D")=$g(retAll("D"))+1,tmp(ward,"D",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...e  i (dataDiff>=10)&&(dataDiff<20) s tmp(ward,"E")=$g(tmp(ward,"E"))+1,retAll("E")=$g(retAll("E"))+1,tmp(ward,"E",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...e  s tmp(ward,"F")=$g(tmp(ward,"F"))+1,retAll("F")=$g(retAll("F"))+1,tmp(ward,"F",per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	...s tmp(ward,"WardTotal")=tmp(ward,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
	..e  i ((type="当前学历")||(type="学历")) d
	...s eduDate=(+$h+1) f  s eduDate=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate),-1) q:(eduDate="")||(flag=1)  d
	....s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate,eduId),-1) q:(eduId="")||(flag=1)  d
	.....q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A") // 状态不是审核状态
	.....;q:($lg(^CF.DHCINM.HR.EducateD(eduId),4)'="")&&($lg(^CF.DHCINM.HR.EducateD(eduId),4)>+$h) // 结束日期不为空且结束日期小于今天
	.....q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
	.....s flag=1,codeSubId=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
	..e  i type="第一学历"  d
	...s eduDate="" f  s eduDate=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate)) q:(eduDate="")||(flag=1)  d
	....s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate,eduId)) q:(eduId="")||(flag=1)  d
	.....q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A") // 状态不是审核状态
	.....q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
	.....s flag=1,codeSubId=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
	..e  i type="职务"  d
	...s postData=(+$h+1) f  s postData=$o(^CF.DHCINM.HR.PostDutyI("PostDate",per,postData),-1) q:(postData="")||(flag=1)  d
	....s postDutyId="" f  s postDutyId=$o(^CF.DHCINM.HR.PostDutyI("PostDate",per,postData,postDutyId),-1) q:(postDutyId="")||(flag=1)  d
	.....q:($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),7)'="A")||(($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),5)'="")&&($lg(^CF.DHCINM.HR.PostDutyD(postDutyId),5)<+$h)) // 状态不是审核状态，截止日期不为空，且截止日期小于今天
	.....q:$lg(^CF.DHCINM.HR.PostDutyD(postDutyId),3)=""
	.....s flag=1,codeSubId=$lg(^CF.DHCINM.HR.PostDutyD(postDutyId),3)
	..e  i type="聘任职称"  d
	...s hireDutyDate=(+$h+1) f  s hireDutyDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",per,hireDutyDate),-1) q:(hireDutyDate="")||(flag=1)  d
	....s hireDutyId="" f  s hireDutyId=$o(^CF.DHCINM.HR.HireDutyI("HireDate",per,hireDutyDate,hireDutyId),-1) q:(hireDutyId="")||(flag=1)  d
	.....q:(($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),8)'="A")||($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)'="")&&($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)<+$h)) // 状态不是审核状态，截止日期不为空，且截止日期小于今天
	.....q:$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)=""
	.....s flag=1,codeSubId=$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)
	..e  i type="护士层级" d
	...s levelDate=(+$h+1) f  s levelDate=$o(^CF.DHCINM.HR.MgLevelI("levelA",per," A",levelDate),-1) q:(levelDate="")||(flag=1)  d
	....s levelId="" f  s levelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",per," A",levelDate,levelId),-1) q:(levelId="")||(flag=1)  d
	.....q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),6)'="A"  // 状态不是审核状态
	.....q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)=""
	.....s flag=1,codeSubId=$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)
	..e  i type="性别" d
	...q:$lg(perGlo,9)=""
	...s flag=1,codeSubId=$lg(perGlo,9)
	..i (flag="1")&&(type'="平均年龄")&&((type'="年资")&&(type'="工作年限")) d
	...s codeSub=$lg(^CT.DHCINM.DB.MgSetCodeSubD($p(codeSubId,"||"),$P(codeSubId,"||",2)),3)
	...s subFiterSymbol=$lg(^CT.DHCINM.DB.MgSetCodeSubD($p(codeSubId,"||"),$P(codeSubId,"||",2)),9)
	...i subFiterSymbol'=0 d
	....s tmp(ward,codeSub)=$g(tmp(ward,codeSub))+1,retAll(codeSub)=$g(retAll(codeSub))+1,tmp(ward,"WardTotal")=tmp(ward,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
	....s tmp(ward,codeSub,per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4),retAll(codeSub,per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	..e  i (flag'="1")&&(type'="平均年龄")&&(type'="年资")&&(type'="工作年限") d
	...s codeSub="UnDef"
	...s tmp(ward,codeSub)=$g(tmp(ward,codeSub))+1,retAll(codeSub)=$g(retAll(codeSub))+1,tmp(ward,"WardTotal")=tmp(ward,"WardTotal")+1,tmpCounterAll=tmpCounterAll+1
	...s tmp(ward,codeSub,per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4),retAll(codeSub,per)=$lg(perGlo,2)_"^"_$lg(perGlo,3)_"^"_$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	d Output	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	f j=1:1:$l(outputtype,",") d
	.i $p(outputtype,",",j)="ALL" d OutAll
	.e  i $p(outputtype,",",j)="WARD" d OutOwnWard
	.e  i $p(outputtype,",",j)="WARDLOC" d OutOwnWardLoc
	.e  i $p(outputtype,",",j)="OWN" d OutOwnAll
	.e  i $p(outputtype,",",j)="AREA" d OutAREA
	q
OutputStatistic
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
OutAll
	;全院汇总数据(1条)
	i detail="" d
	.s i="" f  s i=$o(retAll(i)) q:i=""  d
	..s retAll=retAll_"^"_i_"|"_retAll(i)
	.i type="平均年龄" d
	..i tmpCounterAll'=0 s retAll=retAll_"^AvgAge|"_$fn(totalAgeAll\tmpCounterAll,"",0)
	..e  s retAll=retAll_"^AvgAge|0"
	.s ret=retAll_"^WardTotal|"_tmpCounterAll_"^RowHilight|1"
	.d OutputStatistic
	e  d
	.s tt="" f  s tt=$o(retAll(detail,tt)) q:tt=""  d
	..s ttt=retAll(detail,tt)
	..s ret="Per|"_tt_"^PerName|"_$p(ttt,"^")_"^PerID|"_$p(ttt,"^",2)_"^WardDesc|"_$p(ttt,"^",3)
	..s edu=##class(web.INMHRComm).GetNurseEdu2(tt)
	..s ret=ret_"^PerSchool|"_$p(edu,"^",2)_"^PerDegree|"_$p(edu,"^",1)_"^PerDegreeDate|"_$p(edu,"^",3)
	..s hire=##class(web.INMHRComm).GetNurseHireDuty2(tt)
	..s ret=ret_"^PerHireStDate|"_$p(hire,"^",1)_"^PerHireEndDate|"_$p(hire,"^",2)
	..s levelSt=##class(web.INMHRComm).GetNurseLevel2(tt)
	..s ret=ret_"^PerLevelDate|"_levelSt
	..s perNZ=$lg($g(^CF.DHCINM.HR.PersonsD(tt)),12)
	..i perNZ'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd(perNZ,3),$zd(+$h,3))),"Y")
	..e  s dataDiff=""
	..s ret=ret_"^PerYear|"_dataDiff
	..d OutputStatistic
	q
OutOwnAll
	;所辖科室病区汇总数据(1条)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	i detail="" d
	.s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	..q:(isAll=0)&&('$d(tmpWard(wardId)))
	..q:'$d(tmp(wardId))
	..s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	...s:i'="WardDesc" tmpOwn(i)=$fn($g(tmpOwn(i)),"")+tmp(wardId,i)
	.s ret="WardDesc|所辖科室(病区)"
	.s i="" f  s i=$o(tmpOwn(i)) q:i=""  d
	..s:i'="WardTotalAge" ret=ret_"^"_i_"|"_tmpOwn(i)
	.i type="平均年龄" d
	..i tmpOwn("WardTotalAge")'=0 s ret=ret_"^AvgAge|"_$fn(tmpOwn("WardTotalAge")\tmpOwn("WardTotal"),"",0)
	..e  s ret=ret_"^AvgAge|0"
	.s ret=ret_"^RowHilight|0"
	.d OutputStatistic
	e  d
	.s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	..q:(isAll=0)&&('$d(tmpWard(wardId)))
	..q:'$d(tmp(wardId))
	..s tt="" f  s tt=$o(tmp(wardId,detail,tt)) q:tt=""  d
	...s ttt=tmp(wardId,detail,tt)
	...s ret="Per|"_tt_"^PerName|"_$p(ttt,"^")_"^PerID|"_$p(ttt,"^",2)_"^WardDesc|"_$p(ttt,"^",3)
	...s edu=##class(web.INMHRComm).GetNurseEdu2(tt)
	...s ret=ret_"^PerSchool|"_$p(edu,"^",2)_"^PerDegree|"_$p(edu,"^",1)_"^PerDegreeDate|"_$p(edu,"^",3)
	...s hire=##class(web.INMHRComm).GetNurseHireDuty2(tt)
	...s ret=ret_"^PerHireStDate|"_$p(hire,"^",1)_"^PerHireEndDate|"_$p(hire,"^",2)
	...s levelSt=##class(web.INMHRComm).GetNurseLevel2(tt)
	...s ret=ret_"^PerLevelDate|"_levelSt
	...s perNZ=$lg($g(^CF.DHCINM.HR.PersonsD(tt)),12)
	...i perNZ'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd(perNZ,3),$zd(+$h,3))),"Y")
	...e  s dataDiff=""
	...s ret=ret_"^PerYear|"_dataDiff
	...d OutputStatistic
	q
OutOwnWard
	;所辖(选)病区数据(多条)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	i detail="" d
	.s wardSort="" f  s wardSort=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort)) q:wardSort=""  d
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort,wardId)) q:wardId=""  d
	...q:(wardid'="")&&(wardId'=wardid)
	...q:(isAll=0)&&('$d(tmpWard(wardId)))
	...q:'$d(tmp(wardId))
	...s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	....q:i="WardTotalAge"
	....i ret="" s ret=i_"|"_tmp(wardId,i)
	....e  s ret=ret_"^"_i_"|"_tmp(wardId,i)
	...i type="平均年龄" d
	....i tmp(wardId,"WardTotal")'=0 s ret=ret_"^AvgAge|"_$fn(tmp(wardId,"WardTotalAge")\tmp(wardId,"WardTotal"),"",0)
	....e  s ret=ret_"^AvgAge|0"
	...s ret=ret_"^RowHilight|0"
	...d OutputStatistic
	e  d
	.s wardSort="" f  s wardSort=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort)) q:wardSort=""  d
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardI("Sort",wardSort,wardId)) q:wardId=""  d
	...q:(wardid'="")&&(wardId'=wardid)
	...q:(isAll=0)&&('$d(tmpWard(wardId)))
	...q:'$d(tmp(wardId))
	...s tt="" f  s tt=$o(tmp(wardId,detail,tt)) q:tt=""  d
	....s ttt=tmp(wardId,detail,tt)
	....s ret="Per|"_tt_"^PerName|"_$p(ttt,"^")_"^PerID|"_$p(ttt,"^",2)_"^WardDesc|"_$p(ttt,"^",3)
	....s edu=##class(web.INMHRComm).GetNurseEdu2(tt)
	....s ret=ret_"^PerSchool|"_$p(edu,"^",2)_"^PerDegree|"_$p(edu,"^",1)_"^PerDegreeDate|"_$p(edu,"^",3)
	....s hire=##class(web.INMHRComm).GetNurseHireDuty2(tt)
	....s ret=ret_"^PerHireStDate|"_$p(hire,"^",1)_"^PerHireEndDate|"_$p(hire,"^",2)
	....s levelSt=##class(web.INMHRComm).GetNurseLevel2(tt)
	....s ret=ret_"^PerLevelDate|"_levelSt
	....s perNZ=$lg($g(^CF.DHCINM.HR.PersonsD(tt)),12)
	....i perNZ'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd(perNZ,3),$zd(+$h,3))),"Y")
	....e  s dataDiff=""
	....s ret=ret_"^PerYear|"_dataDiff
	....d OutputStatistic
	q
OutOwnWardLoc
	;所辖(选)科室数据(多条)
	k tmpWardLoc
	d ##class(web.INMDataLimit).GetRoleWardLoc(nurseid,1,.tmpWardLoc)
	i detail="" d
	.s wardLocId="" f  s wardLocId=$o(tmpWardLoc(wardLocId)) q:wardLocId=""  d
	..q:(wardid'="")&&(wardid'=wardLocId)
	..s ret="WardDesc|"_tmpWardLoc(wardLocId)
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",wardLocId,wardId)) q:wardId=""  d
	...q:'$d(tmp(wardId))
	...s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	....q:(i="WardDesc")
	....s tmpLoc(wardLocId,i)=$fn($g(tmpLoc(wardLocId,i)),"")+tmp(wardId,i)
	..i '$d(tmpLoc(wardLocId)) d
	...s tmpLoc(wardLocId,"WardTotal")=0
	...i (type="工作年限")||(type="平均年龄") d
	....s tmpLoc(wardLocId,"A")=0,tmpLoc(wardLocId,"B")=0,tmpLoc(wardLocId,"C")=0,tmpLoc(wardLocId,"D")=0,tmpLoc(wardLocId,"E")=0,tmpLoc(wardLocId,"WardTotal")=0
	....i type="工作年限" s tmpLoc(wardLocId,"F")=0
	....i type="平均年龄" s tmpLoc(wardLocId,"WardTotalAge")=0
	...e  d
	....s subSort="" f  s subSort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
	.....s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
	......s subObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
	......q:('$IsObject(subObj))
	......q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
	......q:subObj.subFiterSymbol=0
	......s tmpLoc(wardLocId,subObj.SubCode)=0
	..s i="" f  s i=$o(tmpLoc(wardLocId,i)) q:i=""  d
	...q:i="WardTotalAge"
	...s ret=ret_"^"_i_"|"_tmpLoc(wardLocId,i)
	..i type="平均年龄" d
	...q:'$d(tmpLoc(wardLocId))
	...i tmpLoc(wardLocId,"WardTotal")'=0 s ret=ret_"^AvgAge|"_$fn(tmpLoc(wardLocId,"WardTotalAge")\tmpLoc(wardLocId,"WardTotal"),"",0)
	...e  s ret=ret_"^AvgAge|0"
	..s ret=ret_"^RowHilight|0"
	..d OutputStatistic
	e  d
	.s wardLocId="" f  s wardLocId=$o(tmpWardLoc(wardLocId)) q:wardLocId=""  d
	..q:(wardid'="")&&(wardid'=wardLocId)
	..s ret="WardDesc|"_tmpWardLoc(wardLocId)
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",wardLocId,wardId)) q:wardId=""  d
	...q:'$d(tmp(wardId))
	...s tt="" f  s tt=$o(tmp(wardId,detail,tt)) q:tt=""  d
	....s ttt=tmp(wardId,detail,tt)
	....s ret="Per|"_tt_"^PerName|"_$p(ttt,"^")_"^PerID|"_$p(ttt,"^",2)_"^WardDesc|"_$p(ttt,"^",3)
	....s edu=##class(web.INMHRComm).GetNurseEdu2(tt)
	....s ret=ret_"^PerSchool|"_$p(edu,"^",2)_"^PerDegree|"_$p(edu,"^",1)_"^PerDegreeDate|"_$p(edu,"^",3)
	....s hire=##class(web.INMHRComm).GetNurseHireDuty2(tt)
	....s ret=ret_"^PerHireStDate|"_$p(hire,"^",1)_"^PerHireEndDate|"_$p(hire,"^",2)
	....s levelSt=##class(web.INMHRComm).GetNurseLevel2(tt)
	....s ret=ret_"^PerLevelDate|"_levelSt
	....s perNZ=$lg($g(^CF.DHCINM.HR.PersonsD(tt)),12)
	....i perNZ'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd(perNZ,3),$zd(+$h,3))),"Y")
	....e  s dataDiff=""
	....s ret=ret_"^PerYear|"_dataDiff
	....d OutputStatistic
	q
OutAREA
	;所选片区数据
	k tmpWardArea
	s areaIsAll=##class(web.INMDataLimit).GetRoleWardArea(nurseid,.tmpWardArea)
	i detail="" d
	.s areaId="" f  s areaId=$O(^CF.DHCINM.DB.MgWardAreaD(areaId)) q:areaId=""  d
	..q:(wardid'="")&&(wardid'=areaId)
	..q:((areaIsAll'=1)&&('$d(tmpWardArea(areaId))))
	..s areaLB=$g(^CF.DHCINM.DB.MgWardAreaD(areaId))
	..q:areaLB=""
	..s ret="WardDesc|"_$lg(areaLB,3)
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardI("Area",areaId,wardId)) q:wardId=""  d
	...q:'$d(tmp(wardId))
	...s i="" f  s i=$o(tmp(wardId,i)) q:i=""  d
	....q:(i="WardDesc")
	....s tmpArea(areaId,i)=$fn($g(tmpArea(areaId,i)),"")+tmp(wardId,i)
	..i '$d(tmpArea(areaId)) d
	...s tmpArea(areaId,"WardTotal")=0
	...i (type="工作年限")||(type="平均年龄") d
	....s tmpArea(areaId,"A")=0,tmpArea(areaId,"B")=0,tmpArea(areaId,"C")=0,tmpArea(areaId,"D")=0,tmpArea(areaId,"E")=0,tmpArea(areaId,"WardTotal")=0
	....i type="工作年限" s tmpArea(areaId,"F")=0
	....i type="平均年龄" s tmpArea(areaId,"WardTotalAge")=0
	...e  d
	....s subSort="" f  s subSort=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort)) q:subSort=""  d
	.....s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Sort",codeId,subSort,subId)) q:subId=""  d
	......s subObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(codeId_"||"_subId)
	......q:('$IsObject(subObj))
	......q:(subObj.SubStDate="")||(subObj.SubStDate>+$h)||((subObj.SubEndDate'="")&&(subObj.SubEndDate<+$h))
	......q:subObj.subFiterSymbol=0
	......s tmpArea(areaId,subObj.SubCode)=0
	..s i="" f  s i=$o(tmpArea(areaId,i)) q:i=""  d
	...q:i="WardTotalAge"
	...s ret=ret_"^"_i_"|"_tmpArea(areaId,i)
	..i type="平均年龄" d
	...q:'$d(tmpArea(areaId))
	...i tmpArea(areaId,"WardTotal")'=0 s ret=ret_"^AvgAge|"_$fn(tmpArea(areaId,"WardTotalAge")\tmpArea(areaId,"WardTotal"),"",0)
	...e  s ret=ret_"^AvgAge|0"
	..s ret=ret_"^RowHilight|0"
	..d OutputStatistic
	e  d
	.s areaId="" f  s areaId=$O(^CF.DHCINM.DB.MgWardAreaD(areaId)) q:areaId=""  d
	..q:(wardid'="")&&(wardid'=areaId)
	..q:((areaIsAll'=1)&&('$d(tmpWardArea(areaId))))
	..s areaLB=$g(^CF.DHCINM.DB.MgWardAreaD(areaId))
	..q:areaLB=""
	..s ret="WardDesc|"_$lg(areaLB,3)
	..s wardId="" f  s wardId=$o(^CF.DHCINM.DB.MgWardI("Area",areaId,wardId)) q:wardId=""  d
	...q:'$d(tmp(wardId))
	...s tt="" f  s tt=$o(tmp(wardId,detail,tt)) q:tt=""  d
	....s ttt=tmp(wardId,detail,tt)
	....s ret="Per|"_tt_"^PerName|"_$p(ttt,"^")_"^PerID|"_$p(ttt,"^",2)_"^WardDesc|"_$p(ttt,"^",3)
	....s edu=##class(web.INMHRComm).GetNurseEdu2(tt)
	....s ret=ret_"^PerSchool|"_$p(edu,"^",2)_"^PerDegree|"_$p(edu,"^",1)_"^PerDegreeDate|"_$p(edu,"^",3)
	....s hire=##class(web.INMHRComm).GetNurseHireDuty2(tt)
	....s ret=ret_"^PerHireStDate|"_$p(hire,"^",1)_"^PerHireEndDate|"_$p(hire,"^",2)
	....s levelSt=##class(web.INMHRComm).GetNurseLevel2(tt)
	....s ret=ret_"^PerLevelDate|"_levelSt
	....s perNZ=$lg($g(^CF.DHCINM.HR.PersonsD(tt)),12)
	....i perNZ'="" s dataDiff=$P((##class(web.INMVueComm).CalAge($zd(perNZ,3),$zd(+$h,3))),"Y")
	....e  s dataDiff=""
	....s ret=ret_"^PerYear|"_dataDiff
	....d OutputStatistic
	q
}

ClassMethod FindPersonnelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonnelListExecute ]
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

ClassMethod FindPersonnelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonnelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:根据传入类型获取统计表的列信息
/// Date:2019-10-25
/// Table:CT.DHCINM.DB.MgSetCode
/// Input:统计方式
/// Output：统计表的列信息
/// Return:
/// Others: w ##class(web.INMPersonCountComm).GetSpecialNumColumn("性别")
ClassMethod GetSpecialNumColumn(type As %String = "") As %String
{
	s legalType=$lb("病区专科护士数量","全院专科护士数量")
	s commonColor=$lb("#c23531","#2f4554","#61a0a8","#d48265","#91c7ae","#749f83","#ca8622","#bda29a","#6e7074","#546570",'"#c4ccd3")
	s commonColorIndex=0
	i '$lf(legalType,type)
	{
		q "[]"
	}
	
	
	i type="病区专科护士数量" d
	.s index=1,ret=""
	.s id="" f  s id=$O(^DHCINM.Special.SpecialNurseD(id)) q:id=""  d
	..s specGlo=$g(^DHCINM.Special.SpecialNurseD(id))
	..q:$lg(specGlo,7)'="A"
	..s per=$lg(specGlo,2)
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	..q:$lg(perGlo,25)'="N"
	..s currentWard=##class(web.INMHRComm).GetCurrentWard(per,+$H)
	..q:currentWard=""
	..q:'$d(^CF.DHCINM.DB.MgWardD(currentWard))
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(currentWard))
	..q:($lg(wardGlo,12)'="")&&($lg(wardGlo,12)<+$H)    // 病区已停用
	..q:$d(tmpWard(currentWard))
	..s color=$case((index#10),0:$ll(commonColor),:(index#10))
	..s tmpWard(currentWard)=1
	..s index=index+1
	..s ret=ret_",{""Code"":"""_$lg(wardGlo,4)_""",""Desc"":"""_$lg(wardGlo,4)_""",""Color"":"""_$lg(commonColor,color)_"""}"
	.s props=$e(ret,2,*)
	i type="全院专科护士数量"
	{
		s props="{""Code"":""专科护士"",""Desc"":""专科护士"",""Color"":"""_$lg(commonColor,1)
		_"""},{""Code"":""非专科护士"",""Desc"":""非专科护士"",""Color"":"""_$lg(commonColor,2)_"""}"

	}
	i $g(props)'="" s props="[{""Code"":""WardDesc"",""Desc"":""名称""},"_props_",{""Code"":""WardTotal"",""Desc"":""合计""}]"
	e  s props="[]"
	w props
	q ""
}

/// Creator: LCY
/// CeateDate: 2020-12-04
/// Description: 人员一览表
/// Table: CF.DHCINM.DB.MgWard,CF.DHCINM.HR.Persons,CF.DHCINM.HR.Educate,CF.DHCINM.HR.PostDuty,CF.DHCINM.HR.HireDuty,CF.DHCINM.HR.MgLevel,CT.DHCINM.DB.MgSetCodeSub,CT.DHCINM.DB.MgSetCode
/// Input: 病区id,查询类型,角色,护士id,科室,查询类型
/// Return：
/// Output: 查询类型下各个子类数量
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindSpecialNum","7^2020-10-01^2020-12-31",0)
Query FindSpecialNum(parr As %String = "", role As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSpecialNumExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s search=$p(parr,"^",1)
	
	k tmpWard,tmpResult
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s per="" f  s per=$O(^CF.DHCINM.HR.PersonsD(per)) q:per=""  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s currentWard = ##class(web.INMHRComm).GetCurrentWard(per,+$h)
	.q:currentWard=""
	.q:'$d(^CF.DHCINM.DB.MgWardD(currentWard))
	.;q:(isAll="0")&&('$d(tmpWard(currentWard)))
	.q:$lg(perGlo,25)'="N"
	.i $d(^DHCINM.Special.SpecialNurseI("Person",per)) d
	..s tmpResult(currentWard,"A")=$g(tmpResult(currentWard,"A"))+1
	.e  d
	..s tmpResult(currentWard,"N")=$g(tmpResult(currentWard,"N"))+1
	s ret="WardDesc|全院",total=0
	i search="病区专科护士数量" d
	.s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	..s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,id)) q:id=""  d
	...q:'$d(^CF.DHCINM.DB.MgWardD(id))
	...s wardGlo=$g(^CF.DHCINM.DB.MgWardD(id))
	...q:($lg(wardGlo,12)'="")&&($lg(wardGlo,12)<+$H)    // 病区已停用
	...s wardDesc=$lg(wardGlo,4)
	...i $d(tmpResult(id,"A")) d
	....s ret=ret_"^"_wardDesc_"|"_$g(tmpResult(id,"A"))
	....s total=total+$g(tmpResult(id,"A"))
	...;e  d
	...;.s ret=ret_"^"_wardDesc_"|0"
	.s ret=ret_"^WardTotal|"_total
	.do OutputData
	e  d
	.s stotal=0,ntotal=0
	.s ward="" f  s ward=$O(tmpResult(ward)) q:ward=""  d
	..s stotal=stotal+$g(tmpResult(ward,"A"))
	..s ntotal=ntotal+$g(tmpResult(ward,"N"))
	.s ret=ret_"^专科护士|"_stotal_"^非专科护士|"_ntotal_"^WardTotal|"_(stotal+ntotal)
	.d OutputData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSpecialNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecialNumExecute ]
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

ClassMethod FindSpecialNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecialNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindHosList",0,"A","层级分布^N2")
Query FindHosList(nurseid As %String = "", seaType As %String = "", detail As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHosListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "", detail As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if $g(^DHCINM.YS)="Y" {
		k tmpHire,tmpEdu,tmpYear,tmpLevel,tmpAge,tmpDetail
		i seaType="A"{
			s tmpAge("A")=1
			s tmpAge("B")=19
			s tmpAge("C")=2
			s tmpAge("D")=2
			s tmpHire("12||1")=11
			s tmpHire("12||2")=5
			s tmpHire("12||3")=5
			s tmpHire("12||4")=3
			s tmpEdu("3||1")=11
			s tmpEdu("3||2")=4
			s tmpEdu("3||3")=5
			s tmpEdu("3||4")=2
			s tmpEdu("3||5")=2
			s tmpYear("A")=1
			s tmpYear("B")=1
			s tmpYear("C")=17
			s tmpYear("D")=2
			s tmpYear("F")=3
			s tmpLevel("19||1")=1
			s tmpLevel("19||2")=6
			s tmpLevel("19||3")=10
			s tmpLevel("19||4")=4
			s tmpLevel("19||5")=3
			s tmpDetail("Age","A",43)=1
			s tmpDetail("Age","A",43,"Detail")="^PerAge|26"
			s tmpDetail("Age","B",2)=1
			s tmpDetail("Age","B",2,"Detail")="^PerAge|39"
			s tmpDetail("Age","B",4)=1
			s tmpDetail("Age","B",4,"Detail")="^PerAge|33"
			s tmpDetail("Age","B",7)=1
			s tmpDetail("Age","B",7,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",8)=1
			s tmpDetail("Age","B",8,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",9)=1
			s tmpDetail("Age","B",9,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",10)=1
			s tmpDetail("Age","B",10,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",11)=1
			s tmpDetail("Age","B",11,"Detail")="^PerAge|33"
			s tmpDetail("Age","B",12)=1
			s tmpDetail("Age","B",12,"Detail")="^PerAge|34"
			s tmpDetail("Age","B",26)=1
			s tmpDetail("Age","B",26,"Detail")="^PerAge|37"
			s tmpDetail("Age","B",27)=1
			s tmpDetail("Age","B",27,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",28)=1
			s tmpDetail("Age","B",28,"Detail")="^PerAge|37"
			s tmpDetail("Age","B",30)=1
			s tmpDetail("Age","B",30,"Detail")="^PerAge|37"
			s tmpDetail("Age","B",31)=1
			s tmpDetail("Age","B",31,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",32)=1
			s tmpDetail("Age","B",32,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",33)=1
			s tmpDetail("Age","B",33,"Detail")="^PerAge|39"
			s tmpDetail("Age","B",44)=1
			s tmpDetail("Age","B",44,"Detail")="^PerAge|36"
			s tmpDetail("Age","B",48)=1
			s tmpDetail("Age","B",48,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",49)=1
			s tmpDetail("Age","B",49,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",50)=1
			s tmpDetail("Age","B",50,"Detail")="^PerAge|32"
			s tmpDetail("Age","C",42)=1
			s tmpDetail("Age","C",42,"Detail")="^PerAge|45"
			s tmpDetail("Age","C",52)=1
			s tmpDetail("Age","C",52,"Detail")="^PerAge|43"
			s tmpDetail("Age","D",57)=1
			s tmpDetail("Age","D",57,"Detail")="^PerAge|58"
			s tmpDetail("Age","D",58)=1
			s tmpDetail("Age","D",58,"Detail")="^PerAge|64"
			s tmpDetail("Edu","3||1",2)=1
			s tmpDetail("Edu","3||1",2,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",8)=1
			s tmpDetail("Edu","3||1",8,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2014-07-24"
			s tmpDetail("Edu","3||1",11)=1
			s tmpDetail("Edu","3||1",11,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",26)=1
			s tmpDetail("Edu","3||1",26,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",27)=1
			s tmpDetail("Edu","3||1",27,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",28)=1
			s tmpDetail("Edu","3||1",28,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",30)=1
			s tmpDetail("Edu","3||1",30,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",31)=1
			s tmpDetail("Edu","3||1",31,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2022-07-06"
			s tmpDetail("Edu","3||1",32)=1
			s tmpDetail("Edu","3||1",32,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",33)=1
			s tmpDetail("Edu","3||1",33,"Detail")="^PerSchool|海南医学院^PerDegree|学士^PerDegreeDate|2004-07-01"
			s tmpDetail("Edu","3||1",49)=1
			s tmpDetail("Edu","3||1",49,"Detail")="^PerSchool|桂林医学院^PerDegree|学士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||2",12)=1
			s tmpDetail("Edu","3||2",12,"Detail")="^PerSchool|安徽理工大学^PerDegree|硕士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||2",42)=1
			s tmpDetail("Edu","3||2",42,"Detail")="^PerSchool|北华大学^PerDegree|硕士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||2",50)=1
			s tmpDetail("Edu","3||2",50,"Detail")="^PerSchool|南方医科大学^PerDegree|硕士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||2",58)=1
			s tmpDetail("Edu","3||2",58,"Detail")="^PerSchool|益阳医学高等专科学校^PerDegree|硕士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||3",7)=1
			s tmpDetail("Edu","3||3",7,"Detail")="^PerSchool|安徽蚌埠医学院^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",10)=1
			s tmpDetail("Edu","3||3",10,"Detail")="^PerSchool|海南医学院^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",44)=1
			s tmpDetail("Edu","3||3",44,"Detail")="^PerSchool|安徽医科大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",48)=1
			s tmpDetail("Edu","3||3",48,"Detail")="^PerSchool|娄底市卫生学校^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",52)=1
			s tmpDetail("Edu","3||3",52,"Detail")="^PerSchool|南宁市卫生学校^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||4",4)=1
			s tmpDetail("Edu","3||4",4,"Detail")="^PerSchool|海南医学院^PerDegree|博士^PerDegreeDate|2022-07-01"
			s tmpDetail("Edu","3||4",57)=1
			s tmpDetail("Edu","3||4",57,"Detail")="^PerSchool|北京大学医学网络教育学院^PerDegree|博士^PerDegreeDate|2014-07-01"
			s tmpDetail("Edu","3||5",9)=1
			s tmpDetail("Edu","3||5",9,"Detail")="^PerSchool|海南医学院^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||5",43)=1
			s tmpDetail("Edu","3||5",43,"Detail")="^PerSchool|安徽理工大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Hire","12||1",2)=1
			s tmpDetail("Hire","12||1",2,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",4)=1
			s tmpDetail("Hire","12||1",4,"Detail")="^PerHireStDate|2022-06-01^PerHireEndDate|2025-05-30"
			s tmpDetail("Hire","12||1",7)=1
			s tmpDetail("Hire","12||1",7,"Detail")="^PerHireStDate|2017-10-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",12)=1
			s tmpDetail("Hire","12||1",12,"Detail")="^PerHireStDate|2017-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",26)=1
			s tmpDetail("Hire","12||1",26,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",28)=1
			s tmpDetail("Hire","12||1",28,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",30)=1
			s tmpDetail("Hire","12||1",30,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",32)=1
			s tmpDetail("Hire","12||1",32,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",48)=1
			s tmpDetail("Hire","12||1",48,"Detail")="^PerHireStDate|2017-10-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",50)=1
			s tmpDetail("Hire","12||1",50,"Detail")="^PerHireStDate|2016-10-01^PerHireEndDate|"
			s tmpDetail("Hire","12||1",52)=1
			s tmpDetail("Hire","12||1",52,"Detail")="^PerHireStDate|2017-10-01^PerHireEndDate|"
			s tmpDetail("Hire","12||2",10)=1
			s tmpDetail("Hire","12||2",10,"Detail")="^PerHireStDate|2022-02-28^PerHireEndDate|2022-11-18"
			s tmpDetail("Hire","12||2",27)=1
			s tmpDetail("Hire","12||2",27,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||2",31)=1
			s tmpDetail("Hire","12||2",31,"Detail")="^PerHireStDate|2018-06-06^PerHireEndDate|"
			s tmpDetail("Hire","12||2",42)=1
			s tmpDetail("Hire","12||2",42,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||2",44)=1
			s tmpDetail("Hire","12||2",44,"Detail")="^PerHireStDate|2017-07-04^PerHireEndDate|"
			s tmpDetail("Hire","12||3",8)=1
			s tmpDetail("Hire","12||3",8,"Detail")="^PerHireStDate|2022-02-01^PerHireEndDate|"
			s tmpDetail("Hire","12||3",9)=1
			s tmpDetail("Hire","12||3",9,"Detail")="^PerHireStDate|2018-07-01^PerHireEndDate|"
			s tmpDetail("Hire","12||3",11)=1
			s tmpDetail("Hire","12||3",11,"Detail")="^PerHireStDate|2018-08-01^PerHireEndDate|"
			s tmpDetail("Hire","12||3",43)=1
			s tmpDetail("Hire","12||3",43,"Detail")="^PerHireStDate|2019-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||3",49)=1
			s tmpDetail("Hire","12||3",49,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||4",33)=1
			s tmpDetail("Hire","12||4",33,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||4",57)=1
			s tmpDetail("Hire","12||4",57,"Detail")="^PerHireStDate|2018-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||4",58)=1
			s tmpDetail("Hire","12||4",58,"Detail")="^PerHireStDate|2015-10-01^PerHireEndDate|"
			s tmpDetail("Level","19||1",10)=1
			s tmpDetail("Level","19||1",10,"Detail")="^PerLevelDate|2022-07-12"
			s tmpDetail("Level","19||2",7)=1
			s tmpDetail("Level","19||2",7,"Detail")="^PerLevelDate|2013-10-01"
			s tmpDetail("Level","19||2",12)=1
			s tmpDetail("Level","19||2",12,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||2",43)=1
			s tmpDetail("Level","19||2",43,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||2",48)=1
			s tmpDetail("Level","19||2",48,"Detail")="^PerLevelDate|2018-10-01"
			s tmpDetail("Level","19||2",50)=1
			s tmpDetail("Level","19||2",50,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||2",52)=1
			s tmpDetail("Level","19||2",52,"Detail")="^PerLevelDate|2018-10-01"
			s tmpDetail("Level","19||3",2)=1
			s tmpDetail("Level","19||3",2,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",4)=1
			s tmpDetail("Level","19||3",4,"Detail")="^PerLevelDate|2022-07-12"
			s tmpDetail("Level","19||3",9)=1
			s tmpDetail("Level","19||3",9,"Detail")="^PerLevelDate|2016-10-01"
			s tmpDetail("Level","19||3",26)=1
			s tmpDetail("Level","19||3",26,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",27)=1
			s tmpDetail("Level","19||3",27,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",28)=1
			s tmpDetail("Level","19||3",28,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",30)=1
			s tmpDetail("Level","19||3",30,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",31)=1
			s tmpDetail("Level","19||3",31,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||3",44)=1
			s tmpDetail("Level","19||3",44,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||3",49)=1
			s tmpDetail("Level","19||3",49,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||4",8)=1
			s tmpDetail("Level","19||4",8,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||4",32)=1
			s tmpDetail("Level","19||4",32,"Detail")="^PerLevelDate|2018-12-02"
			s tmpDetail("Level","19||4",42)=1
			s tmpDetail("Level","19||4",42,"Detail")="^PerLevelDate|2017-10-01"
			s tmpDetail("Level","19||4",57)=1
			s tmpDetail("Level","19||4",57,"Detail")="^PerLevelDate|2016-10-01"
			s tmpDetail("Level","19||5",11)=1
			s tmpDetail("Level","19||5",11,"Detail")="^PerLevelDate|2018-12-03"
			s tmpDetail("Level","19||5",33)=1
			s tmpDetail("Level","19||5",33,"Detail")="^PerLevelDate|2011-12-02"
			s tmpDetail("Level","19||5",58)=1
			s tmpDetail("Level","19||5",58,"Detail")="^PerLevelDate|2016-10-01"
			s tmpDetail("Year","A",50)=1
			s tmpDetail("Year","A",50,"Detail")="^PerYear|0"
			s tmpDetail("Year","B",52)=1
			s tmpDetail("Year","B",52,"Detail")="^PerYear|1"
			s tmpDetail("Year","C",2)=1
			s tmpDetail("Year","C",2,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",4)=1
			s tmpDetail("Year","C",4,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",7)=1
			s tmpDetail("Year","C",7,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",8)=1
			s tmpDetail("Year","C",8,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",9)=1
			s tmpDetail("Year","C",9,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",10)=1
			s tmpDetail("Year","C",10,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",11)=1
			s tmpDetail("Year","C",11,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",12)=1
			s tmpDetail("Year","C",12,"Detail")="^PerYear|3"
			s tmpDetail("Year","C",26)=1
			s tmpDetail("Year","C",26,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",27)=1
			s tmpDetail("Year","C",27,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",28)=1
			s tmpDetail("Year","C",28,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",30)=1
			s tmpDetail("Year","C",30,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",31)=1
			s tmpDetail("Year","C",31,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",32)=1
			s tmpDetail("Year","C",32,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",33)=1
			s tmpDetail("Year","C",33,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",43)=1
			s tmpDetail("Year","C",43,"Detail")="^PerYear|2"
			s tmpDetail("Year","C",48)=1
			s tmpDetail("Year","C",48,"Detail")="^PerYear|3"
			s tmpDetail("Year","D",42)=1
			s tmpDetail("Year","D",42,"Detail")="^PerYear|6"
			s tmpDetail("Year","D",44)=1
			s tmpDetail("Year","D",44,"Detail")="^PerYear|6"
			s tmpDetail("Year","F",49)=1
			s tmpDetail("Year","F",49,"Detail")="^PerYear|22"
			s tmpDetail("Year","F",57)=1
			s tmpDetail("Year","F",57,"Detail")="^PerYear|52"
			s tmpDetail("Year","F",58)=1
			s tmpDetail("Year","F",58,"Detail")="^PerYear|44"
		}else {
			s tmpAge("B")=4
			s tmpHire("12||2")=3
			s tmpHire("12||3")=1
			s tmpEdu("3||3")=4
			s tmpYear("B")=1
			s tmpYear("C")=3
			s tmpLevel("19||3")=4
			s tmpDetail("Age","B",25)=1
			s tmpDetail("Age","B",25,"Detail")="^PerAge|37"
			s tmpDetail("Age","B",34)=1
			s tmpDetail("Age","B",34,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",36)=1
			s tmpDetail("Age","B",36,"Detail")="^PerAge|32"
			s tmpDetail("Age","B",47)=1
			s tmpDetail("Age","B",47,"Detail")="^PerAge|32"
			s tmpDetail("Edu","3||3",25)=1
			s tmpDetail("Edu","3||3",25,"Detail")="^PerSchool|安徽理工大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",34)=1
			s tmpDetail("Edu","3||3",34,"Detail")="^PerSchool|安徽理工大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",36)=1
			s tmpDetail("Edu","3||3",36,"Detail")="^PerSchool|安徽理工大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Edu","3||3",47)=1
			s tmpDetail("Edu","3||3",47,"Detail")="^PerSchool|安徽理工大学^PerDegree|^PerDegreeDate|"
			s tmpDetail("Hire","12||2",25)=1
			s tmpDetail("Hire","12||2",25,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||2",34)=1
			s tmpDetail("Hire","12||2",34,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||2",47)=1
			s tmpDetail("Hire","12||2",47,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Hire","12||3",36)=1
			s tmpDetail("Hire","12||3",36,"Detail")="^PerHireStDate|2015-01-01^PerHireEndDate|"
			s tmpDetail("Level","19||3",25)=1
			s tmpDetail("Level","19||3",25,"Detail")="^PerLevelDate|2015-01-01"
			s tmpDetail("Level","19||3",34)=1
			s tmpDetail("Level","19||3",34,"Detail")="^PerLevelDate|2015-01-01"
			s tmpDetail("Level","19||3",36)=1
			s tmpDetail("Level","19||3",36,"Detail")="^PerLevelDate|2015-01-01"
			s tmpDetail("Level","19||3",47)=1
			s tmpDetail("Level","19||3",47,"Detail")="^PerLevelDate|2015-01-01"
			s tmpDetail("Year","B",34)=1
			s tmpDetail("Year","B",34,"Detail")="^PerYear|1"
			s tmpDetail("Year","C",25)=1
			s tmpDetail("Year","C",25,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",36)=1
			s tmpDetail("Year","C",36,"Detail")="^PerYear|4"
			s tmpDetail("Year","C",47)=1
			s tmpDetail("Year","C",47,"Detail")="^PerYear|4"
		}
	}else {
		k tmpWard
		s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
		
		k tmpHire,tmpEdu,tmpYear,tmpLevel,tmpAge,tmpDetail
		s ward="" f  s ward=$O(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
		.q:($lg(^CF.DHCINM.DB.MgWardD(ward),11)="")||($lg(^CF.DHCINM.DB.MgWardD(ward),11)>+$H)
		.q:(($lg(^CF.DHCINM.DB.MgWardD(ward),12)'="")&&($lg(^CF.DHCINM.DB.MgWardD(ward),12)<+$H))
		.q:(isAll'=1)&&('$d(tmpWard(ward)))
		.s per="" f  s per=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_ward,per)) q:per=""  d
		..s perGlo=^CF.DHCINM.HR.PersonsD(per)
		..q:($lg(perGlo,25)'="N")
		..q:((seaType="A")||(seaType=""))&&((##class(web.INMPersonComm).GetCommCode($lg(perGlo,42)))'["在职")
		..q:(seaType="B")&&((##class(web.INMPersonComm).GetCommCode($lg(perGlo,42)))'["离职")
		..s flag=0
		..s hireDutyDate=(+$h+1) f  s hireDutyDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",per,hireDutyDate),-1) q:(hireDutyDate="")||(flag=1)  d
		...s hireDutyId="" f  s hireDutyId=$o(^CF.DHCINM.HR.HireDutyI("HireDate",per,hireDutyDate,hireDutyId),-1) q:(hireDutyId="")||(flag=1)  d
		....q:(($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),8)'="A")||($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)'="")&&($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)<+$h))
		....q:$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)=""
		....s codeSubId=$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),3)
		....s hireSt=$zd(hireDutyDate,3)
		....s hireEnd=""
		....s:$lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5)'="" hireEnd=$zd($lg(^CF.DHCINM.HR.HireDutyD(hireDutyId),5),3)
		....s flag=1,tmpHire(codeSubId)=$g(tmpHire(codeSubId))+1,tmpDetail("Hire",codeSubId,per)=1,tmpDetail("Hire",codeSubId,per,"Detail")="^PerHireStDate|"_hireSt_"^PerHireEndDate|"_hireEnd
		..s flag=0
		..s eduDate=(+$h+1) f  s eduDate=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate),-1) q:(eduDate="")||(flag=1)  d
		...s eduId="" f  s eduId=$o(^CF.DHCINM.HR.EducateI("flag",per,eduDate,eduId),-1) q:(eduId="")||(flag=1)  d
		....q:($lg(^CF.DHCINM.HR.EducateD(eduId),12)'="A")
		....;q:($lg(^CF.DHCINM.HR.EducateD(eduId),4)'="")&&($lg(^CF.DHCINM.HR.EducateD(eduId),4)>+$h)
		....q:$lg(^CF.DHCINM.HR.EducateD(eduId),6)=""
		....s codeSubId=$lg(^CF.DHCINM.HR.EducateD(eduId),6)
		....s eduSchool="",eduDegree="",eduDegreeDate=""
		....s:$lg(^CF.DHCINM.HR.EducateD(eduId),5)'="" eduSchool=##class(web.INMPersonComm).GetCommCode($lg(^CF.DHCINM.HR.EducateD(eduId),5))
		....s:$lg(^CF.DHCINM.HR.EducateD(eduId),7)'="" eduDegree=##class(web.INMPersonComm).GetCommCode($lg(^CF.DHCINM.HR.EducateD(eduId),7))
		....s:$lg(^CF.DHCINM.HR.EducateD(eduId),11)'="" eduDegreeDate=$zd($lg(^CF.DHCINM.HR.EducateD(eduId),11),3)
		....s flag=1,tmpEdu(codeSubId)=$g(tmpEdu(codeSubId))+1,tmpDetail("Edu",codeSubId,per)=1,tmpDetail("Edu",codeSubId,per,"Detail")="^PerSchool|"_eduSchool_"^PerDegree|"_eduDegree_"^PerDegreeDate|"_eduDegreeDate
		..s perComeDate=$lg(perGlo,12)
		..s:perComeDate="" perComeDate=+$h
		..s year=+##class(web.INMVueComm).CalAge(perComeDate,+$h)
		..i year<1 s tmpYear("A")=$g(tmpYear("A"))+1,tmpDetail("Year","A",per)=1,tmpDetail("Year","A",per,"Detail")="^PerYear|"_year
		..e  i (year>=1)&&(year<2) s tmpYear("B")=$g(tmpYear("B"))+1,tmpDetail("Year","B",per)=1,tmpDetail("Year","B",per,"Detail")="^PerYear|"_year
		..e  i (year>=2)&&(year<5) s tmpYear("C")=$g(tmpYear("C"))+1,tmpDetail("Year","C",per)=1,tmpDetail("Year","C",per,"Detail")="^PerYear|"_year
		..e  i (year>=5)&&(year<10) s tmpYear("D")=$g(tmpYear("D"))+1,tmpDetail("Year","D",per)=1,tmpDetail("Year","D",per,"Detail")="^PerYear|"_year
		..e  i (year>=10)&&(year<20) s tmpYear("E")=$g(tmpYear("E"))+1,tmpDetail("Year","E",per)=1,tmpDetail("Year","E",per,"Detail")="^PerYear|"_year
		..e  i (year>=20) s tmpYear("F")=$g(tmpYear("F"))+1,tmpDetail("Year","F",per)=1,tmpDetail("Year","F",per,"Detail")="^PerYear|"_year
		..s flag=0
		..s levelDate=(+$h+1) f  s levelDate=$o(^CF.DHCINM.HR.MgLevelI("levelA",per," A",levelDate),-1) q:(levelDate="")||(flag=1)  d
		...s levelId="" f  s levelId=$o(^CF.DHCINM.HR.MgLevelI("levelA",per," A",levelDate,levelId),-1) q:(levelId="")||(flag=1)  d
		....q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),6)'="A"
		....q:$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)=""
		....s codeSubId=$lg(^CF.DHCINM.HR.MgLevelD(levelId),3)
		....s flag=1,tmpLevel(codeSubId)=$g(tmpLevel(codeSubId))+1,tmpDetail("Level",codeSubId,per)=1,tmpDetail("Level",codeSubId,per,"Detail")="^PerLevelDate|"_$zd(levelDate,3)
		..s perBirthid=$lg(perGlo,6)
		..s:perBirthid="" perBirthid=+$h
		..s age=+##class(web.INMVueComm).CalAge(perBirthid,+$h)
		..i (age>=20)&&(age<30) s tmpAge("A")=$g(tmpAge("A"))+1,tmpDetail("Age","A",per)=1,tmpDetail("Age","A",per,"Detail")="^PerAge|"_age
		..e  i (age>=30)&&(age<40) s tmpAge("B")=$g(tmpAge("B"))+1,tmpDetail("Age","B",per)=1,tmpDetail("Age","B",per,"Detail")="^PerAge|"_age
		..e  i (age>=40)&&(age<50) s tmpAge("C")=$g(tmpAge("C"))+1,tmpDetail("Age","C",per)=1,tmpDetail("Age","C",per,"Detail")="^PerAge|"_age
		..e  i (age>=50) s tmpAge("D")=$g(tmpAge("D"))+1,tmpDetail("Age","D",per)=1,tmpDetail("Age","D",per,"Detail")="^PerAge|"_age
	}
	
	i detail'="" {
		s seriesName=$p(detail,"^"),detailSub=$p(detail,"^",2)
		
		i (seriesName["职称")||(seriesName["层级")||(seriesName["学历") d
		.s:seriesName["职称" seriesName="聘任职称",seriesType="Hire"
		.s:seriesName["学历" seriesName="学历",seriesType="Edu"
		.s:seriesName["层级" seriesName="护士层级",seriesType="Level"
		.s codeParId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_seriesName,""))
		.q:codeParId=""
		.s codeSubId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Code",codeParId," "_detailSub,""))
		.q:codeSubId=""
		.s per="" f  s per=$o(tmpDetail(seriesType,codeParId_"||"_codeSubId,per)) q:per=""  d
		..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
		..s perName=$lg(perGlo,2)
		..s perNo=$lg(perGlo,3)
		..s ret="PerName|"_perName_"^PerNo|"_perNo_tmpDetail(seriesType,codeParId_"||"_codeSubId,per,"Detail")
		..d OutPersons
		e  i seriesName["年资" d
		.i detailSub="<1" s codeSubId="A"
		.e  i detailSub="1≤y<2" s codeSubId="B"
		.e  i detailSub="2≤y<5" s codeSubId="C"
		.e  i detailSub="5≤y<10" s codeSubId="D"
		.e  i detailSub="10≤y<20" s codeSubId="E"
		.e  s codeSubId="F"
		.s per="" f  s per=$o(tmpDetail("Year",codeSubId,per)) q:per=""  d
		..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
		..s perName=$lg(perGlo,2)
		..s perNo=$lg(perGlo,3)
		..s ret="PerName|"_perName_"^PerNo|"_perNo_tmpDetail("Year",codeSubId,per,"Detail")
		..d OutPersons
		e  i seriesName["年龄" d
		.i detailSub="20≤y<30" s codeSubId="A"
		.e  i detailSub="30≤y<40" s codeSubId="B"
		.e  i detailSub="40≤y<50" s codeSubId="C"
		.e  s codeSubId="D"
		.s per="" f  s per=$o(tmpDetail("Age",codeSubId,per)) q:per=""  d
		..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
		..s perName=$lg(perGlo,2)
		..s perNo=$lg(perGlo,3)
		..s ret="PerName|"_perName_"^PerNo|"_perNo_tmpDetail("Age",codeSubId,per,"Detail")
		..d OutPersons
		
		b ;====
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ret="Type|Hire"
	s id="" f  s id=$o(tmpHire(id)) q:id=""  d
	.s ret=ret_"^"_$tr(id,"|","_")_"|"_tmpHire(id)
	d OutPersons
	
	s ret="Type|Edu"
	s id="" f  s id=$o(tmpEdu(id)) q:id=""  d
	.s ret=ret_"^"_$tr(id,"|","_")_"|"_tmpEdu(id)
	d OutPersons
	
	s ret="Type|Year"
	s id="" f  s id=$o(tmpYear(id)) q:id=""  d
	.s ret=ret_"^"_$tr(id,"|","_")_"|"_tmpYear(id)
	d OutPersons
	
	s ret="Type|Level"
	s id="" f  s id=$o(tmpLevel(id)) q:id=""  d
	.s ret=ret_"^"_$tr(id,"|","_")_"|"_tmpLevel(id)
	d OutPersons
	
	i seaType="B" d
	.s ret="Type|Age"
	.s id="" f  s id=$o(tmpAge(id)) q:id=""  d
	..s ret=ret_"^"_$tr(id,"|","_")_"|"_tmpAge(id)
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSensList",0,1)
Query FindSensList(nurseid As %String = "", seaType As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSensListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k allDate
	s year=+$zd(+$h,3)
	s stDate=$zdh(year_"-01-01",3)
	s endDate=$zdh(year_"-12-31",3)
	s allDate(stDate)=endDate
	s lastYear=year-1
	s lastStDate=$zdh(lastYear-1_"-12-01",3)
	s lastEndDate=$zdh(lastYear_"-12-31",3)
	s allDate(lastStDate)=lastEndDate
	
	s col=""
	i seaType=1 {
		s col="I89"
	}elseif seaType=2 {
		s col="I54"
	}elseif seaType=3 {
		s col="I49"
	}elseif seaType=4 {
		s col="I111"
	}
	
	k tmp
	s index=1
	s date="" f
	{
		s date=$o(allDate(date))
		q:date=""
		s tEndDate=allDate(date)
		s date2=date
		while(date2<tEndDate){
			s firstDate=$zd(date2,3)
			s lastDate=$zd($SYSTEM.SQL.LASTDAY(date2),3)
			i $g(^DHCINM.YS)="Y" {
				s val=0,tb=0,hb=0
				i seaType=1 {
					s:$e($zd(date2,3),1,7)="2022-07" val=2.68
					s:$e($zd(date2,3),1,7)="2022-08" val=8.64,hb=222.39
					s:$e($zd(date2,3),1,7)="2022-09" hb=-100.00
				}elseif seaType=2 {
					s:$e($zd(date2,3),1,7)="2022-07" val=5.26
					s:$e($zd(date2,3),1,7)="2022-08" val=3.62,hb=-31.18
					s:$e($zd(date2,3),1,7)="2022-09" hb=-100.00
				}elseif seaType=3 {
					
				}elseif seaType=4 {
					
				}
			}else {
				s parr="^M^"_firstDate_"^"_lastDate_"^1^"_nurseid
				s rs=##class(%Library.ResultSet).%New("web.NurSensConfigComm:FindCountList")
				d rs.Execute(parr,col)
				s allData=""
				while rs.Next()'=0 {
					s allData=rs.GetData(1)
				}
				k tAllData
				s aa=##class(web.INMVueComm).SplitStr2(allData,"^","|",.tAllData)
				s val=+$g(tAllData(col)) ;,fm=+$g(tAllData("FM")),fz=+$g(tAllData("FZ"))
				s tb=0,hb=0
				i index>1 {
					s last=+tmp(index-1)
					s:last'=0 hb=$fn(val-last/last*100,"",2)
				}
				i index>13 {
					s last=+tmp(index-12)
					s:last'=0 tb=$fn(val-last/last*100,"",2)
				}
			}
			
			s tmp(index)=val_"^"_tb_"^"_hb_"^"_$e($zd(date2,3),1,7)
			s date2=$SYSTEM.SQL.DATEADD("month",1,date2)
			s date2=$zdh($e(date2,1,10),3)
			s index=index+1
		}
	}
	
	s id=13 f  s id=$o(tmp(id)) q:id=""  d
	.s tData=tmp(id)
	.s ret="Date|"_$p(tData,"^",4)_"^Val|"_$p(tData,"^",1)_"^TB|"_$p(tData,"^",2)_"^HB|"_$p(tData,"^",3)
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens2List",0,1)
Query FindSens2List(nurseid As %String = "", seaType As %String = "", month As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens2ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "", month As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s st=$zdh(month_"-01",3)
	s end=$SYSTEM.SQL.LASTDAY(st)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	s ward="" f  s ward=$O(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:($lg(^CF.DHCINM.DB.MgWardD(ward),11)="")||($lg(^CF.DHCINM.DB.MgWardD(ward),11)>+$H)
	.q:(($lg(^CF.DHCINM.DB.MgWardD(ward),12)'="")&&($lg(^CF.DHCINM.DB.MgWardD(ward),12)<+$H))
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s ctLocId=$lg(^CF.DHCINM.DB.MgWardD(ward),2)
	.q:ctLocId=""
	.s pacWardId=$o(^PAWARD(0,"WARD_LocationDR",ctLocId,""))
	.q:pacWardId=""
	.i seaType=1 s method="HighRisk"
	.e  i seaType=2 s method="CareLevel"
	.e  s method="IllLevel"
	.s rs=##class(%Library.ResultSet).%New("Nur.Interface.OutSide.PortalUC.Ward:"_method)
	.d rs.Execute(pacWardId,$zd(st,3),$zd(end,3))
	.f  s sc=rs.Next() q:sc=0  d
	..s desc=rs.GetData(1)
	..s:desc="住院患者VTE风险评估表（高危）" desc="住院患者VTE"
	..s:desc="成人压疮风险（高危）" desc="成人压疮"
	..s:desc="管路滑脱风险（高危）" desc="管路滑脱"
	..s:desc="管路滑脱风险（中危）" desc="管路滑脱(中危)"
	..s:desc="成人跌倒风险(高危）" desc="成人跌倒"
	..s type=rs.GetData(2)
	..s num=rs.GetData(3)
	..q:type=""
	..s tmp(type)=$g(tmp(type))+num
	..s tmp(type,"Desc")=desc
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s tData=tmp(id)
	.s ret="Type|"_id_"^Val|"_tmp(id)_"^Desc|"_tmp(id,"Desc")
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens3List",0,1)
Query FindSens3List(nurseid As %String = "", seaType As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens3ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s end=+$h
	s st=$SYSTEM.SQL.LASTDAY($zdh($e($SYSTEM.SQL.DATEADD("month",-11,end),1,10),3))
	k tmpDate
	f {
		q:st>=end
		s tmpDate(st)=1
		s st=$SYSTEM.SQL.LASTDAY(st+1)
	}
	s tmpDate(end-2)=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	s date="" f  s date=$o(tmpDate(date)) q:date=""  d
	.i $g(^DHCINM.YS)="Y" d
	..s tmp(date,1)=80,tmp(date,2)=33
	..s:$e($zd(date,3),1,7)="2021-11" tmp(date,1)=80,tmp(date,2)=33
	..s:$e($zd(date,3),1,7)="2021-12" tmp(date,1)=80,tmp(date,2)=33
	..s:$e($zd(date,3),1,7)="2022-01" tmp(date,1)=80,tmp(date,2)=30
	..s:$e($zd(date,3),1,7)="2022-02" tmp(date,1)=80,tmp(date,2)=30
	..s:$e($zd(date,3),1,7)="2022-03" tmp(date,1)=65,tmp(date,2)=29
	..s:$e($zd(date,3),1,7)="2022-04" tmp(date,1)=67,tmp(date,2)=28
	..s:$e($zd(date,3),1,7)="2022-05" tmp(date,1)=69,tmp(date,2)=28
	..s:$e($zd(date,3),1,7)="2022-06" tmp(date,1)=63,tmp(date,2)=28
	..s:$e($zd(date,3),1,7)="2022-07" tmp(date,1)=58,tmp(date,2)=24
	..s:$e($zd(date,3),1,7)="2022-08" tmp(date,1)=60,tmp(date,2)=24
	..s:$e($zd(date,3),1,7)="2022-09" tmp(date,1)=55,tmp(date,2)=24
	..s:$e($zd(date,3),1,7)="2022-10" tmp(date,1)=56,tmp(date,2)=24
	..s:$e($zd(date,3),1,7)="2022-11" tmp(date,1)=60,tmp(date,2)=24
	.q:$g(^DHCINM.YS)="Y"
	.s rs=##class(%Library.ResultSet).%New("Nur.Interface.OutSide.Manage:FindBedNurList")
	.s sc=rs.Execute($zd(date,3))
	.f  s sc=rs.Next() q:sc=0  d
	..s bed=rs.GetData(2)
	..s nurse=rs.GetData(3)
	..s tmp(date,1)=$g(tmp(date,1))+bed
	..s tmp(date,2)=$g(tmp(date,2))+nurse
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s bed=tmp(id,1)
	.s nurse=tmp(id,2)
	.s val=0
	.s:bed'=0 val=$fn(nurse/bed,"",2)
	.s:val=0.00 val=0
	.s:$e(val,1,1)="." val=0_val
	.s ret="Date|"_$e($zd(id,3),1,7)_"^Val|"_val_"^Bed|"_bed_"^Nurse|"_nurse
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens4List",0,1)
Query FindSens4List(nurseid As %String = "", seaType As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens4ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s end=+$h
	s st=$SYSTEM.SQL.LASTDAY($zdh($e($SYSTEM.SQL.DATEADD("month",-11,end),1,10),3))
	k tmpDate
	f {
		q:st>=end
		s tmpDate(st)=1
		s st=$SYSTEM.SQL.LASTDAY(st+1)
	}
	s tmpDate(end-2)=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
#;	..s:$e($zd(date,3),1,7)="2021-11" tmp(date,1)=0.09,tmp(date,2)=0.27,tmp(date,3)=0.22
#;	..s:$e($zd(date,3),1,7)="2021-12" tmp(date,1)=0.15,tmp(date,2)=0.27,tmp(date,3)=0.16
#;	..s:$e($zd(date,3),1,7)="2022-01" tmp(date,1)=0.15,tmp(date,2)=0.23,tmp(date,3)=0.45
#;	..s:$e($zd(date,3),1,7)="2022-02" tmp(date,1)=0.17,tmp(date,2)=0.25,tmp(date,3)=0.47
#;	..s:$e($zd(date,3),1,7)="2022-03" tmp(date,1)=0.19,tmp(date,2)=0.19,tmp(date,3)=0.11
#;	..s:$e($zd(date,3),1,7)="2022-04" tmp(date,1)=0.10,tmp(date,2)=0.17,tmp(date,3)=0.45
#;	..s:$e($zd(date,3),1,7)="2022-05" tmp(date,1)=0.13,tmp(date,2)=0.50,tmp(date,3)=0.20
#;	..s:$e($zd(date,3),1,7)="2022-06" tmp(date,1)=0.10,tmp(date,2)=0.17,tmp(date,3)=0.08
#;	..s:$e($zd(date,3),1,7)="2022-07" tmp(date,1)=0.22,tmp(date,2)=0.60,tmp(date,3)=0.26
#;	..s:$e($zd(date,3),1,7)="2022-08" tmp(date,1)=0.34,tmp(date,2)=0.99,tmp(date,3)=0.67
#;	..s:$e($zd(date,3),1,7)="2022-09" tmp(date,1)=0.25,tmp(date,2)=0.48,tmp(date,3)=0.44
#;	..s:$e($zd(date,3),1,7)="2022-10" tmp(date,1)=0.20,tmp(date,2)=0.36,tmp(date,3)=0.67
#;	..s:$e($zd(date,3),1,7)="2022-11" tmp(date,1)=0.19,tmp(date,2)=0.27,tmp(date,3)=0.36
	
	k tmp
	s date="" f  s date=$o(tmpDate(date)) q:date=""  d
	.i $g(^DHCINM.YS)="Y" d
	..s tmp(date,1)=0.19,tmp(date,2)=0.27,tmp(date,3)=0.36
	..s:$e($zd(date,3),1,7)="2021-11" tmp(date,1)=1.6,tmp(date,2)=1.8,tmp(date,3)=1.4
	..s:$e($zd(date,3),1,7)="2021-12" tmp(date,1)=1.8,tmp(date,2)=1.9,tmp(date,3)=1.7
	..s:$e($zd(date,3),1,7)="2022-01" tmp(date,1)=1.8,tmp(date,2)=2,tmp(date,3)=1.6
	..s:$e($zd(date,3),1,7)="2022-02" tmp(date,1)=1.7,tmp(date,2)=1.8,tmp(date,3)=1.6
	..s:$e($zd(date,3),1,7)="2022-03" tmp(date,1)=1.5,tmp(date,2)=1.9,tmp(date,3)=1.1
	..s:$e($zd(date,3),1,7)="2022-04" tmp(date,1)=1.5,tmp(date,2)=1.7,tmp(date,3)=1.3
	..s:$e($zd(date,3),1,7)="2022-05" tmp(date,1)=1.6,tmp(date,2)=1.77,tmp(date,3)=1.43
	..s:$e($zd(date,3),1,7)="2022-06" tmp(date,1)=1.4,tmp(date,2)=1.52,tmp(date,3)=1.28
	..s:$e($zd(date,3),1,7)="2022-07" tmp(date,1)=1.5,tmp(date,2)=1.63,tmp(date,3)=1.37
	..s:$e($zd(date,3),1,7)="2022-08" tmp(date,1)=1.6,tmp(date,2)=1.7,tmp(date,3)=1.5
	..s:$e($zd(date,3),1,7)="2022-09" tmp(date,1)=1.6,tmp(date,2)=1.85,tmp(date,3)=1.35
	..s:$e($zd(date,3),1,7)="2022-10" tmp(date,1)=1.4,tmp(date,2)=1.5,tmp(date,3)=1.3
	..s:$e($zd(date,3),1,7)="2022-11" tmp(date,1)=1.5,tmp(date,2)=1.7,tmp(date,3)=1.3
	.q:$g(^DHCINM.YS)="Y"
	.s rs=##class(%Library.ResultSet).%New("Nur.Interface.OutSide.Manage:FindNurPathList")
	.s sc=rs.Execute($zd(date,3))
	.s counnt=0
	.f  s sc=rs.Next() q:sc=0  d
	..s counnt=counnt+1
	..s val=$p(rs.GetData(4),":",2)
	..s day=$p(rs.GetData(5),":",2)
	..s night=$p(rs.GetData(6),":",2)
	..s tmp(date,1)=$g(tmp(date,1))+val
	..s tmp(date,2)=$g(tmp(date,2))+day
	..s tmp(date,3)=$g(tmp(date,3))+night
	.i counnt>0 d
	..s tmp(date,1)=$fn($g(tmp(date,1))/counnt,"",2)
	..s tmp(date,2)=$fn($g(tmp(date,2))/counnt,"",2)
	..s tmp(date,3)=$fn($g(tmp(date,3))/counnt,"",2)
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s val=tmp(id,1)
	.s:$e(val,1,1)="." val="0"_val
	.s:+val=0 val=0
	.s day=tmp(id,2)
	.s:$e(day,1,1)="." day="0"_day
	.s:+day=0 day=0
	.s night=tmp(id,3)
	.s:$e(night,1,1)="." night="0"_night
	.s:+night=0 night=0
	.s ret="Date|"_$e($zd(id,3),1,7)_"^Val|"_val_"^Day|"_day_"^Night|"_night
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens5List",0,1)
Query FindSens5List(nurseid As %String = "", seaType As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens5ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s end=$zdh($e($zd(+$h,3),1,7)_"-01",3)
	s st=$SYSTEM.SQL.LASTDAY($zdh($e($SYSTEM.SQL.DATEADD("month",-11,end),1,10),3))
	k tmpDate
	f {
		q:st>=end
		s tmpDate(st)=$SYSTEM.SQL.LASTDAY(st)
		s st=$SYSTEM.SQL.LASTDAY(st)+1
	}
	s tmpDate(end)=+$h
	
	k tmp
	s date="" f  s date=$o(tmpDate(date)) q:date=""  d
	.i $g(^DHCINM.YS)="Y" d
	..s tmp(date)=0
	..s:$e($zd(date,3),1,7)="2022-04" tmp(date)=3.4
	..s:$e($zd(date,3),1,7)="2022-06" tmp(date)=3.4
	..s:$e($zd(date,3),1,7)="2022-07" tmp(date)=7.4
	.q:$g(^DHCINM.YS)="Y"
	.s st=$zd(date,3),end=$zd(tmpDate(date),3)
	.s rs=##class(%Library.ResultSet).%New("web.INMPersonCountComm:FindWardPersonCountBytime")
	.s sc=rs.Execute("^"_st_"^"_end,nurseid)
	.s sc=rs.Next()
	.q:sc=0
	.s data=rs.GetData(1)
	.k tmpData
	.d ##class(web.INMVueComm).SplitStr2(data,"^","|",.tmpData)
	.s rate=+$g(tmpData("ResignRate"))
	.s:$e(rate,1,1)="." rate=0_rate
	.s tmp(date)=rate
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s ret="Date|"_$e($zd(id,3),1,7)_"^Val|"_tmp(id)
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens6List",0,1)
Query FindSens6List(nurseid As %String = "", seaType As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens6ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s end=+$h
	s st=$SYSTEM.SQL.LASTDAY($zdh($e($SYSTEM.SQL.DATEADD("month",-11,end),1,10),3))
	k tmpDate
	f {
		q:st>=end
		s tmpDate(st)=1
		s st=$SYSTEM.SQL.LASTDAY(st+1)
	}
	s tmpDate(end-2)=1
	
	k tmp
	s date="" f  s date=$o(tmpDate(date)) q:date=""  d
	.i $g(^DHCINM.YS)="Y" d
	..s tmp(date)=3.2
	..s:$e($zd(date,3),1,7)="2021-11" tmp(date)=13.21
	..s:$e($zd(date,3),1,7)="2021-12" tmp(date)=7.56
	..s:$e($zd(date,3),1,7)="2022-01" tmp(date)=7.44
	..s:$e($zd(date,3),1,7)="2022-02" tmp(date)=6.61
	..s:$e($zd(date,3),1,7)="2022-03" tmp(date)=5.97
	..s:$e($zd(date,3),1,7)="2022-04" tmp(date)=11.14
	..s:$e($zd(date,3),1,7)="2022-05" tmp(date)=8.61
	..s:$e($zd(date,3),1,7)="2022-06" tmp(date)=11.65
	..s:$e($zd(date,3),1,7)="2022-07" tmp(date)=5.1
	..s:$e($zd(date,3),1,7)="2022-08" tmp(date)=3.33
	..s:$e($zd(date,3),1,7)="2022-09" tmp(date)=4.5
	..s:$e($zd(date,3),1,7)="2022-10" tmp(date)=5.1
	..s:$e($zd(date,3),1,7)="2022-11" tmp(date)=6.4
	.q:$g(^DHCINM.YS)="Y"
	.s rs=##class(%Library.ResultSet).%New("Nur.Interface.OutSide.Manage:FindNurHourList")
	.s sc=rs.Execute($zd(date,3))
	.f  s sc=rs.Next() q:sc=0  d
	..s val=rs.GetData(4)
	..s tmp(date)=$g(tmp(date))+val
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s ret="Date|"_$e($zd(id,3),1,7)_"^Val|"_tmp(id)
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Others: w ##class(web.INMPersonCountComm).GetSensRate()
ClassMethod GetSensRate() As %String
{
	q:$g(^DHCINM.YS)="Y" "Rate1|92^Rate2|94^Rate3|90^Rate4|89^Rate5|91^Rate6|95^OffSet|185%"
	s date=$zd(+$h,3)
	s rate=##class(Nur.MNISV4.Service.InterFacecls).GetPdaExeInfo("2022-09-01",date,2)
	s rate1=+$p(rate,"^"),rate2=+$p(rate,"^",2),rate3=+$p(rate,"^",3),rate4=+$p(rate,"^",4)
	s rate5=+$p(rate,"^",5),rate6=+$p(rate,"^",7)
	q "Rate1|"_rate1_"^Rate2|"_rate2_"^Rate3|"_rate3_"^Rate4|"_rate4_"^Rate5|"_rate5_"^Rate6|"_rate6_"^OffSet|185%"
}

/// Others: w ##class(web.INMPersonCountComm).GetTableInfo()
ClassMethod GetTableInfo(GloType As %String = "", parr As %String = "", InnerType As %String = "", SeriesName As %String = "") As %String
{
	q:GloType="" ""
	
	s columns="[]",className="",methodType="",methodName="",other="[]"
	
	i (GloType="HOSEcharts")||(GloType="HOSPie") d
	.s columns="[""PerName^姓名"",""PerNo^工号""]"
	.s:SeriesName["职称" columns="[""PerName^姓名"",""PerNo^工号"",""PerHireStDate^聘任开始日期"",""PerHireEndDate^聘任结束日期""]"
	.s:SeriesName["学历" columns="[""PerName^姓名"",""PerNo^工号"",""PerSchool^学校"",""PerDegree^学位"",""PerDegreeDate^取得学位日期""]"
	.s:SeriesName["层级" columns="[""PerName^姓名"",""PerNo^工号"",""PerLevelDate^晋升日期""]"
	.s:SeriesName["年资" columns="[""PerName^姓名"",""PerNo^工号"",""PerYear^年资""]"
	.s:SeriesName["年龄" columns="[""PerName^姓名"",""PerNo^工号"",""PerAge^年龄""]"
	.s type=$p(parr,"^",2)
	.s className="web.INMPersonCountComm"
	.s methodName="FindHosList"
	.s methodType="RecQuery"
	.s other="[""seaType$"_type_""",""detail$"_SeriesName_"^"_InnerType_"""]"
	e  i GloType="HOSLineB" d
	.s columns="[""PatName^姓名"",""PatNo^登记号"",""Ward^病区""]"
	.s type=$p(parr,"^")
	.s month=$p(parr,"^",2)
	.s className="web.INMPersonCountComm"
	.s methodName="FindSens7List"
	.s methodType="RecQuery"
	.s other="[""seaType$"_type_""",""detail$"_InnerType_""",""month$"_month_"""]"
	e  i GloType="HOSLineE" d
	.s columns="[""PerName^姓名"",""PerNo^工号""]"
	.s type=$p(parr,"^")
	.s className="web.INMPersonCountComm"
	.s methodName="FindSens8List"
	.s methodType="RecQuery"
	.s other="[""seaType$"_type_""",""detail$"_InnerType_"""]"
	
	w "{""Columns"":"_columns_",""ClassName"":"""_className_""",""MethodName"":"""_methodName_""",""MethodType"":"""_methodType_""",""Other"":"_other_"}"
	q ""
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens7List",0,1,"2022-10")
Query FindSens7List(nurseid As %String = "", seaType As %String = "", month As %String = "", detail As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens7ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "", month As %String = "", detail As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s st=$zdh(month_"-01",3)
	s end=$SYSTEM.SQL.LASTDAY(st)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	s ward="" f  s ward=$O(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:($lg(^CF.DHCINM.DB.MgWardD(ward),11)="")||($lg(^CF.DHCINM.DB.MgWardD(ward),11)>+$H)
	.q:(($lg(^CF.DHCINM.DB.MgWardD(ward),12)'="")&&($lg(^CF.DHCINM.DB.MgWardD(ward),12)<+$H))
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s ctLocId=$lg(^CF.DHCINM.DB.MgWardD(ward),2)
	.q:ctLocId=""
	.s pacWardId=$o(^PAWARD(0,"WARD_LocationDR",ctLocId,""))
	.q:pacWardId=""
	.i seaType=1 d
	..s method="HighRiskDetail"
	..i detail["VTE" s typeId=47
	..e  i detail["压疮" s typeId=48
	..e  i detail="管路滑脱" s typeId=50
	..e  i detail="管路滑脱(中危)" s typeId=51
	..e  s typeId=52
	.e  i seaType=2 d
	..s method="CareLevelDetail"
	..i detail["三级" s typeId="11584||1"
	..e  i detail["二级" s typeId="11586||1"
	..e  i detail["一级" s typeId="11588||1"
	..e  s typeId="6151||1"
	.e  d
	..s method="CareLevelDetail"
	..i detail["病重" s typeId="11098||1"
	..e  i detail["病危" s typeId="11099||1"
	..e  s typeId="ex11099||1"
	.s rs=##class(%Library.ResultSet).%New("Nur.Interface.OutSide.PortalUC.Ward:"_method)
	.i seaType=1 d rs.Execute(pacWardId,typeId,$zd(st,3),$zd(end,3))
	.e  d rs.Execute(typeId,pacWardId,$zd(st,3),$zd(end,3))
	.f  s sc=rs.Next() q:sc=0  d
	..i seaType=1 d
	...s name=rs.GetData(3)
	...s regno=rs.GetData(2)
	...s desc=rs.GetData(9)
	..e  d
	...s regno=rs.GetData(2)
	...s name=rs.GetData(3)
	...s desc=rs.GetData(6)
	..q:regno=""
	..s tmp(regno)=name
	..s tmp(regno,"Desc")=desc
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s tData=tmp(id)
	.s ret="PatNo|"_id_"^PatName|"_tmp(id)_"^Ward|"_tmp(id,"Desc")
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonCountComm","FindSens8List",0,1)
Query FindSens8List(nurseid As %String = "", seaType As %String = "", detail As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSens8ListExecute(ByRef qHandle As %Binary, nurseid As %String = "", seaType As %String = "", detail As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	i detail'["-" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if $g(^DHCINM.YS)="Y" {
		k tmp
		i detail="2022-04" {
			s ret="PerName|zfm212^PerNo|ZFM212"
			d OutPersons
		}elseif detail="2022-06" {
			s ret="PerName|zss^PerNo|1989"
			d OutPersons
		}elseif detail="2022-07" {
			s ret="PerName|zfmcs212^PerNo|ZFMCS212"
			d OutPersons
			s ret="PerName|zfm0722^PerNo|ZFM0722"
			d OutPersons
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s now=+$h
	s st=$zdh(detail_"-01",3)
	s end=$SYSTEM.SQL.LASTDAY(st)
	s:end>now end=now
	s tmpDate(st)=end
	
	k tmp
	s date="" f  s date=$o(tmpDate(date)) q:date=""  d
	.s st=$zd(date,3),end=$zd(tmpDate(date),3)
	.s rs=##class(%Library.ResultSet).%New("web.INMPersonCountComm:FindWardPersonCountBytime")
	.s sc=rs.Execute("^"_st_"^"_end,nurseid,.tmp)
	b ;01
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s glo=$g(^CF.DHCINM.HR.PersonsD(id))
	.s ret="PerName|"_$lg(glo,2)_"^PerNo|"_$lg(glo,3)
	.d OutPersons
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Others: w ##class(web.INMPersonCountComm).GetEchartsConf()
ClassMethod GetEchartsConf(type As %String = "") As %String
{
	w:type="A" "{""Radius"":""60%"",""Center"":[""50%"",""40%""]}"
	w:type="B" "{""LineColor"":""#ffffff33""}"
	q ""
}

}
