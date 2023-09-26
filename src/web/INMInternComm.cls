/// Creator:wangcc
/// Date:2020-07-30
/// Descriptions：实习生相关公共类
Class web.INMInternComm Extends %RegisteredObject
{

/// Creator:gzj
/// Date:2018-07-04
/// Description:生成实习生编号
/// Table:
/// Input:
/// Output：
/// Return:
/// Other
ClassMethod GenerateInternNo(parr As %String) As %String
{
	s PerType="01"
	s nurseno=""
	i parr="专科" d
	.s PerType="02"
	s row=$O(^CF.DHCINM.HR.PersonsI("type"," P",""),-1)
	s lastPerObj=##class(CF.DHCINM.HR.Persons).%OpenId(row)
	s nowyear=$E($zd(+$h,8),1,4),num="001"
	i ($IsObject(lastPerObj))&&(nowyear=$E(lastPerObj.PerNo,1,4)) d
	.s num=$E(lastPerObj.PerNo,7,$l(lastPerObj.PerNo))+1
	s:$l(num)=1 num="00"_num
	s:$l(num)=2 num="0"_num
	s nurseno=nowyear_PerType_num
	q nurseno
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 保存实习生数据
/// Table：CF.DHCINM.HR.Persons
/// Input：
/// Return：成功返回 记录id 
ClassMethod SaveIntern(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	s PerNorowId=$O(^CF.DHCINM.HR.PersonsI("PerNo"," "_PerNo,""))
	q:((rowid'="")&&((id="")||(rowid'=id))) "身份证号重复"
	q:((PerNorowId'="")&&((id="")||(PerNorowId'=id))) "工号重复"
	s tmp("PerYear")=+$g(tmp("PerComeDate"))
	i $g(tmp("PerEspecially"))'="" s tmp("PerIsEspecially")=1
	i id="" s obj=##class(CF.DHCINM.HR.Persons).%New()
	e  s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.Persons","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("CF.DHCINM.HR.Persons","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..i p="PerCategroy" s tmp(p)=$tr(tmp(p),"__","||")
	..s tmp("PerTypeDR")="P" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..s tmp("PerPassword")="UUUUUU&&&&&&"
	..i p="PerPic" d
	...s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	..e  d
	...s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	d obj.%Save()
	///调科记录导入
	s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_obj.%Id(),""))
	i transRowID="" d
	.i obj.PerDepDate'="" s perdepdate=obj.PerDepDate
	.e  s perdepdate=+$h
	.s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(perdepdate,3)_"^^Y")	
	e  d
	.s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
	.s aa.PerDr=obj.%Id()
    .s aa.PerDepart=obj.PerDepDR
    .i obj.PerDepDate'="" s aa.PerTranStDate=obj.PerDepDate
    .e  s aa.PerTranStDate=+$h
    .s aa.PerTranCurrent="Y"
    .d aa.%Save()
    q 1
}

/// Creator:gzj
/// Description:查询实习人员列表
/// Date:2017-09-02
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternList","^^T^^^",0)
Query FindInternList(parr As %String = "", nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",ret1=""
	s nurseinfo=$zcvt($tr($p(parr,"^",2)," ",""),"U")
	s wardcode=$p(parr,"^",6)
	s interntype=$p(parr,"^",1)
	s status=$p(parr,"^",3)
	s stdate=$p(parr,"^",4)
	s:stdate'="" stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",5)
	s:enddate'="" enddate=$zdh(enddate,3)
	s tmpward=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s rowid="" f  s rowid=$O(^CF.DHCINM.HR.PersonsI("type"," P",rowid)) q:rowid=""  d
	.s InternId=$o(^DHCINM.Intern.MgInternI("ssid",rowid,""),-1)
	.s internStatus="",disable="false",ingroup="false",adjustDisable="false"
	.q:InternId'=""
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s:(obj.PerStatus'="")&&(##class(web.INMPersonComm).GetCommCode(obj.PerStatus)="离职") disable="true",adjustDisable="true"
	.s curward=##class(web.INMHRComm).GetCurrentWard(rowid,+$h)
	.q:(isAll=0)&&((curward'="")&&('$d(tmpWard(curward))))
	.s shortName=##class(web.INMVueComm).ToChineseSpell(obj.PerName)
	.q:((nurseinfo'="")&&((obj.PerName_obj.PerNo_shortName)'[nurseinfo))
	.q:((wardcode'="")&&(obj.PerDepDR'=wardcode))
	.q:((stdate'="")&&(obj.PerInternEndDate<stdate))||((enddate'="")&&(obj.PerInternStDate>enddate))
	.q:((interntype'="")&&(obj.PerCategroy'="")&&(obj.PerCategroy'=interntype))
	.;q:(status="N")&&(obj.PerInternStDate<+$h)
	.;q:(status="E")&&(obj.PerInternEndDate>+$h)
	.s realStatus=""
	.s:obj.PerInternStDate>+$h internStatus="待实习",realStatus="N"
	.s:(obj.PerInternStDate<=+$h)&&(obj.PerInternEndDate>=+$h) internStatus="实习中",realStatus="Y"
	.s:obj.PerInternEndDate<+$h internStatus="实习结束",disable="true",realStatus="E"
	.q:((status'="")&&(status'=realStatus))
	.s internNo=obj.PerNo
	.s internName=obj.PerName
	.s internDep=##class(web.INMDBComm).GetWard(obj.PerDepDR)
	.s internWard=$P($P($g(internDep),"^",3),"|",2)
	.i obj.PerComeDate'="" s internComDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
	.e  s internComDate=""
	.i obj.PerSexDR'="" s internSex=##class(web.INMPersonComm).GetCommCode(obj.PerSexDR)
	.e  s internSex=""
	.s PerCategroy=""
	.i obj.PerCategroy'="" d
	..s PerCategroy=##class(web.INMPersonComm).GetCommCode(obj.PerCategroy)
	.s internDays=obj.PerInternEndDate-obj.PerInternStDate+1
	.s internStDate=$zd(obj.PerInternStDate,3)
	.s internEndDate=$zd(obj.PerInternEndDate,3)
	.s internSchool=""
	.s:obj.PerInternSchool'="" internSchool=##class(web.INMPersonComm).GetCommCode(obj.PerInternSchool)
	.s internSex=""
	.s:obj.PerSexDR'="" internSex=##class(web.INMPersonComm).GetCommCode(obj.PerSexDR)
	.s:..IsInPlan(rowid)="1" disable="true"
	.s:..IsInGroup(rowid,"")=1 ingroup="true"
	.s ret="internNo|"_internNo_"^internName|"_internName_"^internWard|"_internWard_"^internComDate|"_internComDate_"^rowid|"_rowid_"^internStatus|"_internStatus_"^internid|"_InternId_"^interncategroy|"_PerCategroy
	.s ret=ret_"^internStDate|"_internStDate_"^internEndDate|"_internEndDate_"^internDays|"_internDays_"^internSchool|"_internSchool_"^key|"_rowid_"^label|"_internName_"^internSex|"_internSex_"^disabled|"_disable_"^ingroup|"_ingroup
	.s ret=ret_"^adjustDisable|"_adjustDisable
	.do OutputInternData
	s rowid=0 f  s rowid=$O(^DHCINM.Intern.MgInternD(rowid)) q:rowid=""  d
	.s obj1=##class(DHCINM.Intern.MgIntern).%OpenId(rowid)
	.q:'$IsObject(obj1)
	.s curward=obj1.IntDepDR
	.q:(isAll=0)&&((curward'="")&&('$d(tmpWard(curward))))
	.q:((nurseinfo'="")&&((obj1.IntName_obj1.IntNo)'[$zcvt(nurseinfo,"U")))
	.q:((wardcode'="")&&(obj1.IntDepDR'=wardcode))
	.q:((stdate'="")&&(obj1.PerInternEndDate<stdate))||((enddate'="")&&(obj1.PerInternStDate>enddate))
	.q:((interntype'="")&&(obj1.IntPerDR.PerCategroy'="")&&(obj1.IntPerDR.PerCategroy'=interntype))
	.s internNo=obj1.IntNo
	.s internName=obj1.IntName
	.s internDep=##class(web.INMDBComm).GetWard(obj1.IntDepDR)
	.s internWard=$P($P($g(internDep),"^",3),"|",2)
	.i obj1.IntComeDate'="" s internComDate=##class(web.INMHISComm).DateLogicalToHtml(obj1.IntComeDate)
	.e  s internComDate=""
	.i obj1.IntSexDR'="" s internSex=##class(web.INMPersonComm).GetCommCode(obj1.IntSexDR)
	.e  s internSex=""
	.s internStatus=obj1.IntStatus
	.i obj1.IntStatus'="" s internStatus="已转正"
	.q:((status'="")&&(status'="T"))
	.s perObj=obj1.IntPerDR
	.s PerCategroy=""
	.i obj1.IntPerDR.PerCategroy'="" d
	..s PerCategroy=##class(web.INMPersonComm).GetCommCode(obj1.IntPerDR.PerCategroy)
	.s internDays=obj1.PerInternEndDate-obj1.PerInternStDate+1
	.s internStDate=$zd(obj1.PerInternStDate,3)
	.s internEndDate=$zd(obj1.PerInternEndDate,3)
	.s perid="",internSchool=""
	.i $IsObject(perObj) d
	..s perid=obj1.IntPerDR.%Id()
	..s:obj1.IntPerDR.PerInternSchool'="" internSchool=##class(web.INMPersonComm).GetCommCode(obj1.IntPerDR.PerInternSchool)
	.s ret="internNo|"_internNo_"^internName|"_internName_"^internWard|"_internWard_"^internComDate|"_internComDate_"^rowid|"_perid_"^internStatus|"_internStatus_"^internid|"_rowid_"^interncategroy|"_PerCategroy
	.s ret=ret_"^internStDate|"_internStDate_"^internEndDate|"_internEndDate_"^internDays|"_internDays_"^internSchool|"_internSchool_"^key|"_perid_"^label|"_internName_"^internSex|"_internSex_"^disabled|true^adjustDisable|true^ingroup|true"
	.do OutputInternData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputInternData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternListExecute ]
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

ClassMethod FindInternListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 是否已经分过批次  0:没  1:有
/// w ##class(web.INMInternComm).IsInPlan(14)
ClassMethod IsInPlan(perid)
{
	s flag=0
	s member="" f  s member=$o(^DHCINM.Intern.MgTransPlanI("member",member)) q:((member="")||(flag=1))  d
	.s:(","_$tr(member," ","")_",")[(","_perid_",") flag=1
	q flag
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取实习生数据
/// Table：CF.DHCINM.HR.Persons
/// Input：
/// Return： 
ClassMethod GetIntern(id As %String) As %String
{
	s ret=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj) ""
	s internrowid=$o(^DHCINM.Intern.MgInternI("ssid",id,""))
	if internrowid'=""
	{
		s ret=..GetValue(internrowid)_"^isPerson|0"
	}
	else
	{
		s PerName=obj.PerName
		s PerSexDR=obj.PerSexDR
		i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
		e  s PerBirthday=""
		s PerNo=obj.PerNo
		s PerCardId=obj.PerCardId
		s PerDepDR=obj.PerDepDR
		i obj.PerDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerDepDate)
		e  s PerDepDate=""
		i obj.PerComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
		e  s PerComeDate=""
		i obj.PerInternEndDate'="" s PerInternEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerInternEndDate)
		e  s PerInternEndDate=""
		i obj.PerInternStDate'="" s PerInternStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerInternStDate)
		e  s PerInternStDate=""
		s PerPolitical=obj.PerPolitical
		s PerMarriage=obj.PerMarriage
		s PerPic=obj.PerPic
		s CurrentAddress=obj.CurrentAddress
		s CurrentCity=obj.CurrentCity
		s CurrentProvince=obj.CurrentProvince
		s CurrentArea=obj.CurrentArea
		s NativeAddress=obj.NativeAddress
		s NativeCity=obj.NativeCity
		s NativeProvince=obj.NativeProvince
		s NativeArea=obj.NativeArea
		s PerContact=obj.PerContact
		s PerPhone=obj.PerPhone
		s PerContactPhone=obj.PerContactPhone
		s PerInternSchool=obj.PerInternSchool
		s PerHeight=obj.PerHeight
		s PerWeight=obj.PerWeight
		s PerEspecially=obj.PerEspecially
		s PerCategroy=obj.PerCategroy
		s PerNation=obj.PerNation
		i obj.PerBirthday'="" d
		.s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
		.s PerAge=$p(age,"Y",1)
		s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerBirthday|"_PerBirthday_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId
		s ret=ret_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerCategroy|"_PerCategroy
		s ret=ret_"^PerComeDate|"_PerComeDate_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerPic|"_PerPic
		s ret=ret_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^RowID|"_id_"^PerInternSchool|"_PerInternSchool
		s ret=ret_"^PerContactPhone|"_PerContactPhone_"^NativeAddress|"_NativeAddress_"^NativeCity|"_NativeCity
		s ret=ret_"^NativeProvince|"_NativeProvince_"^CurrentAddress|"_CurrentAddress_"^CurrentCity|"_CurrentCity_"^CurrentProvince|"_CurrentProvince
		s ret=ret_"^NativeArea|"_NativeArea_"^CurrentArea|"_CurrentArea_"^PerAge|"_PerAge_"^PerNation|"_PerNation
		s ret=ret_"^PerHeight|"_PerHeight_"^PerWeight|"_PerWeight_"^PerEspecially|"_PerEspecially_"^PerInternEndDate|"_PerInternEndDate_"^PerInternStDate|"_PerInternStDate
	}
	q ret
}

/// Creator:gzj
/// Description:查询实习人员姓名、实习编号信息
/// Date:2017-09-04
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternInfo","")
Query FindInternInfo(parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternInfoExecute(ByRef qHandle As %Binary, parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s nurseinfo=$p(parr,"^",1)
	s wardcode=$p(parr,"^",2)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s rowid="" f  s rowid=$O(^CF.DHCINM.HR.PersonsI("type"," "_nursetype,rowid)) q:rowid=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	.q:((wardcode'="")&&(obj.PerDepDR'=wardcode))
	.s internNo=obj.PerNo
	.s internName=obj.PerName
	.s nurseno=obj.PerID
	.s internInfo=""
	.i nursetype="P" s internInfo=internName_"("_internNo_")"
	.e  i nursetype="N" s internInfo=internName_"("_nurseno_")"
	.q:((nurseinfo'="")&&(internInfo'[$zcvt(nurseinfo,"U")))
	.s internDep=##class(web.INMDBComm).GetWard(obj.PerDepDR)
	.q:(isAll=0)&&((obj.PerDepDR="")||('$d(tmpWard(obj.PerDepDR))))
	.s internWard=$P($P($g(internDep),"^",3),"|",2)
	.s ret="internInfo|"_internInfo_"^inWardCode|"_obj.PerDepDR_"^internWard|"_internWard_"^rowid|"_rowid
	.do OutputInternData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputInternData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternInfoExecute ]
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

ClassMethod FindInternInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 保存实习生离职申请数据
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return：成功返回 记录id 
ClassMethod SaveResign(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=-1
	i tmp("ResignName")'="" d
	.s rw=$O(^DHCINM.HR.MgNurseResignI("ssid",tmp("ResignName"),""))
	.i ((rw'="")&&(rw'=id)) s flag=0
	q:flag=0 flag
	i id="" s obj=##class(DHCINM.HR.MgNurseResign).%New()
	e  s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("ResignName"))
	s:$IsObject(perObj) obj.ResignWard=perObj.PerDepDR
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgNurseResign","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="ResignName" d
	...s tmp(p)=perObj
	..e  d
	...s ptype=^oddCOM("DHCINM.HR.MgNurseResign","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s obj.ResignReStatus="E" ///保存离职状态
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q obj.%Id()
}

/// Creator:gzj
/// Description:查询离职申请信息
/// Date:2017-09-04
/// Table:DHCINM.HR.MgNurseResign
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindResignLists","^^2020-07-31^2020-08-31^","N",0,0)
Query FindResignLists(parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindResignListsExecute(ByRef qHandle As %Binary, parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s nurseno=$p(parr,"^",1)
	s nurseward=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",4)
	i enddate'="" s enddate=$zdh(enddate,3)
	s status=$p(parr,"^",5)
	k tmpWard
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgNurseResignI("type"," "_nursetype,date),-1) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCINM.HR.MgNurseResignI("type"," "_nursetype,date,rowid)) q:rowid=""  d
	..s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(isAll=0)&&((obj.ResignWard="")||('$d(tmpWard(obj.ResignWard))))||(obj.ResignReStatus'="E")
	..s PerObj=obj.ResignName
	..s resignStatu=obj.ResignStatus
	..i obj.ResignStatus="N" s resignStatuDesc="未提交"
	..e  i obj.ResignStatus="Y" s resignStatuDesc="提交"
	..e  i obj.ResignStatus="A" s resignStatuDesc="已审核"
	..e  i obj.ResignStatus="B" s resignStatuDesc="驳回"
	..e  s resignStatuDesc=""
	..s internNo="",nurseID="",nurseinfo=""
	..i nursetype="P" s internNo=PerObj.PerNo,nurseinfo=PerObj.PerNo_PerObj.PerName
	..e  i nursetype="N" s nurseID=PerObj.PerID,nurseinfo=PerObj.PerID_PerObj.PerName
	..e  s internNo=PerObj.PerNo,nurseinfo=PerObj.PerNo_PerObj.PerName
	..q:((nursetype="P")&&((nurseno'="")&&(nurseinfo'[nurseno)))
	..q:((nursetype="N")&&((nurseno'="")&&(nurseinfo'[nurseno)))
	..q:(((nursetype="T")!(nursetype="A"))&&(nurseinfo'[nurseno))
	..q:((nurseward'="")&&(obj.ResignWard'=nurseward))
	..q:((stdate'="")&&(obj.ResignDate'="")&&(obj.ResignDate<stdate))
	..q:((enddate'="")&&(obj.ResignDate'="")&&(obj.ResignDate>enddate))
	..q:((status'="")&&(obj.ResignStatus'=status))
	..s resignName=PerObj.PerName
	..i obj.ResignWard'="" d
	...s WardStr=##class(web.INMDBComm).GetWard(obj.ResignWard)
	...s resignWard=$p($p(WardStr,"^",3),"|",2)
	..e  s resignWard=""
	..i obj.ResignDate'="" s resignDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ResignDate)
	..e  s resignDate=""
	..i nursetype="P" s resignReason=obj.ResignReason
	..e  i nursetype="N" s resignReason=..GetReason(obj.ResignReason)
	..e  s resignReason=""
	..s creater=""
	..i obj.ResignCreater'="" d
	...i obj.ResignCreater=0 s creater="管理员"
	...e  d
	....s nurseobj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.ResignCreater)
	....q:'$IsObject(nurseobj)
	....s creater=nurseobj.UserName
	..i obj.CreateDate'="" s createDate=##class(web.INMHISComm).DateLogicalToHtml(obj.CreateDate)
	..e  s createDate=""
	..s updateUser=""
	..i obj.UpdateUser=0 d
	...s updateUser="管理员"
	..e  d
	...s perobj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.UpdateUser)
	...q:'$IsObject(perobj)
	...s updateUser=perobj.UserName
	..i obj.ResignUpdate'="" s resignUpdate=##class(web.INMHISComm).DateLogicalToHtml(obj.ResignUpdate)
	..e  s resignUpdate=""
	..s ret="resignStatu|"_resignStatu_"^resignStatuDesc|"_resignStatuDesc_"^resignNo|"_internNo_"^nurseID|"_nurseID_"^resignName|"_resignName_"^resignWard|"_resignWard_"^resignDate|"_resignDate_"^resignReason|"_resignReason_"^creater|"_creater_"^createDate|"_createDate_"^updateUser|"_updateUser_"^resignUpdate|"_resignUpdate_"^rowid|"_rowid
	..do OutputResignData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputResignData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindResignListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResignListsExecute ]
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

ClassMethod FindResignListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindResignListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 
/// CreatDate: 2017-09-05
/// Description: 获取离职原因
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return：
ClassMethod GetReason(str As %String) As %String
{
	s ret=""
	q:str="" ""
	i str["~" s len=$l(str,"~") //22||1~22||2~22||3~22||5~22||7~22||9~22||11~22||13~22||15
	e  i str["," s len=$l(str,",")
	e  s len=1
	for i=1:1:len
	{
		i str["~" s rw=$P(str,"~",i)
		e  i str["," s rw=$P(str,",",i)
		e  s rw=str
		i rw'="" d
		.s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(rw)
		.q:'$IsObject(obj)
		.i ret="" s ret=obj.SubDesc
		.e  s ret=ret_";"_obj.SubDesc
	}
	q ret
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取离职数据
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return： 
ClassMethod GetResign(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj)
	s ResignName=obj.ResignName.%Id()
	s ResignWard=obj.ResignWard
	i obj.ResignDate'="" s ResignDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ResignDate)
	e  s ResignDate=""
	s ResignReason=obj.ResignReason
	s ResignOther=obj.ResignOther
	s ResignOpinion=obj.ResignOpinion
	s ResignStatus=obj.ResignStatus
	s ret="ResignName|"_ResignName_"^ResignWard|"_ResignWard_"^ResignDate|"_ResignDate_"^ResignReason|"_ResignReason_"^RowID|"_id_"^ResignOther|"_ResignOther
	s ret=ret_"^ResignOpinion|"_ResignOpinion_"^ResignStatus|"_ResignStatus
	q ret
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 获取离职或退休记录状态
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return： 
ClassMethod GetResignStatu(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.ResignStatus
	q ret
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 删除离职或退休记录
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return： 
ClassMethod DelResignRec(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) ""
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 审核
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return：
ClassMethod CheckResignRec(id As %String, type As %String, status As %String, parr As %String) As %String
{
	s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) "所选记录不存在"
	s obj.ResignStatus=status
	s obj.ResignOpinion=$tr($p(parr,"^",1)," ","")
	s obj.UpdateUser=$p(parr,"^",2)
	i $p(parr,"^",3)'="" s obj.ResignDate=$zdh($p(parr,"^",3),3)
	s obj.ResignUpdate=+$H
	TS
	s saveflag=1,endRotationSc=-1
	i status="A" d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(obj.ResignName.%Id())
	.s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","离职")
	.s perObj.PerStateDate=obj.ResignDate
	.s perObj.PerStatuReason=obj.ResignReason
	.i perObj.PerTypeDR="P" s perObj.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届")
	.s sc=perObj.%Save()
	.s:$$$ISERR(sc) saveflag=0
	.q:saveflag=0
	.s inPostState=##class(web.INMPersonComm).GetCommCode(perObj.PerInNursePost)
	.s:inPostState="轮转" endRotationSc=##class(web.INMPersonComm).EndRotationPlan(perObj.%Id(),obj.ResignDate,"RE")
	.s:(endRotationSc'=-1)&&(endRotationSc'=1) saveflag=0
	.q:saveflag=0
	.s duty=""
	.s typedate=0
	.s typeid=0
	.f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",obj.ResignName.%Id(),typeid)) q:typeid=""  d
	..s dutyobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	..i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	.i duty'="" s obj.ResignDuty=duty
	.s Academic=""
	.s typedate1=0
	.s typeid1=0
	.f  s typeid1=$o(^CF.DHCINM.HR.EducateI("ssid",obj.ResignName.%Id(),typeid1)) q:typeid1=""  d
	..s Academicobj1=##class(CF.DHCINM.HR.Educate).%OpenId(typeid1)
	..i Academicobj1.EduStDate>typedate1 s Academic=Academicobj1.EduAcademic
	.i Academic'="" s obj.ResignAcademic=Academic
	i saveflag=0{
		TRO
		q:endRotationSc=0 "轮转计划终止失败"
		q:(endRotationSc'="-1")&&(endRotationSc'=0)&&(endRotationSc'=1) endRotationSc
		q "修改人员信息失败"
	}
	s sc=obj.%Save()
	i $$$ISERR(sc) {
		TRO
		q "修改离职记录失败"	
	}
	TC
	try{
		i ((obj.ResignStatus="A")||(obj.ResignStatus="B")) d
		.s ResignStatus=$case(obj.ResignStatus,"A":"审核","B":"驳回") ;状态描述
		.s perId=$lg($g(^DHCINM.HR.MgNurseResignD(id)),2) 
		.s PerID=$lg($g(^CF.DHCINM.HR.PersonsD(perId)),3)
		.s perName=$lg($g(^CF.DHCINM.HR.PersonsD(perId)),2)
		.s wardDesc=$LG($g(^CF.DHCINM.DB.MgWardD(obj.ResignWard)),4)
		.s ResignDate1=$lg($g(^DHCINM.HR.MgNurseResignD(id)),4)
		.s ResignDate=""
		.s:ResignDate1'="" ResignDate=$zd(ResignDate1,3)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/护士离职】"_ResignStatus_" "_PerID_" "_perName_" "_wardDesc_" "_ResignDate
		.d:userID'="" ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurseResign",id)
	}catch{
	}
	q 1
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 批量审核
/// Table：DHCINM.HR.MgNurseResign
/// Input：
/// Return：
ClassMethod CheckResignRecs(parr As %String, role As %String, nurseid As %String) As %String
{
	q:parr="" ""
	s flag=1
	Ts
	f i=1:1:$L(parr,",") q:flag'=1  d
	.s id=$p(parr,",",i)
	.q:id=""
	.s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(id)
	.q:'$IsObject(obj)
	.s obj.ResignStatus="A"
	.s:nurseid'=0 obj.UpdateUser=nurseid
	.s obj.ResignUpdate=+$H
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(obj.ResignName.%Id())
	.s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","离职")
	.i perObj.PerTypeDR="P" s perObj.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届")
	.s perObj.PerStateDate=obj.ResignDate
	.s perObj.PerStatuReason=obj.ResignReason
	.s sc= perObj.%Save()
	.s:$$$ISERR(sc) flag=0
	.q:$$$ISERR(sc)
	.s duty=""
	.s typedate=0
	.s typeid=0
	.f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",obj.ResignName.%Id(),typeid)) q:typeid=""  d
	..s dutyobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	..i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	.i duty'="" s obj.ResignDuty=duty
	.s Academic=""
	.s typedate1=0
	.s typeid1=0
	.f  s typeid1=$o(^CF.DHCINM.HR.EducateI("ssid",obj.ResignName.%Id(),typeid1)) q:typeid1=""  d
	..s Academicobj1=##class(CF.DHCINM.HR.Educate).%OpenId(typeid1)
	..i Academicobj1.EduStDate>typedate1 s Academic=Academicobj1.EduAcademic
	.i Academic'="" s obj.ResignAcademic=Academic
	.s sc=obj.%Save()
	.s:$$$ISERR(sc) flag=0
	.q:$$$ISERR(sc)
	d $System.Status.DisplayError(sc)
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0
	}
}

/// creator: xbl
/// createdate: 20170918
/// description: 保存实习生轮转计划
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other:w ##class(web.INMInternComm).SaveTransPlan("PlanCode|2020080301^PlanDesc|12313131^PlanStatus|N^RowID|3^PlanIntern|",0)
ClassMethod SaveTransPlan(parr As %String, nurseid) As %String
{
	s ^tmp("SaveTransPlan")=parr
	q:parr="" 0
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("RowID"))'="" d
	.s obj=##class(DHCINM.Intern.MgTransPlan).%OpenId(tmp("RowID"))
	e  d
	.s obj=##class(DHCINM.Intern.MgTransPlan).%New()
	.s obj.PlanCrtDate=+$h
	.s obj.PlanStatus="N"
	s obj.PlanCode=$g(tmp("PlanCode"))
	s obj.PlanDesc=$g(tmp("PlanDesc"))
	s obj.PlanCrtUser=nurseid
	s obj.PlanIntern=$g(tmp("PlanIntern"))
	s min=999999
	s max=0
	i tmp("PlanIntern")'=""  d
	.f i=1:1:$l($g(tmp("PlanIntern")),",")  d
	..s internid=$p($g(tmp("PlanIntern")),",",i)
	..s stdate=$lg(^CF.DHCINM.HR.PersonsD(internid),131)
	..s enddate=$lg(^CF.DHCINM.HR.PersonsD(internid),132)
	..s:stdate<=min min=stdate
	..s:enddate>=max max=enddate
	.s obj.PlanStDate=min
	.s obj.PlanEndDate=max
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: wangcc
/// createdate: 20170918
/// description: 获取实习生批次成员
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other:w ##class(web.INMInternComm).GetTransPlan(1)
ClassMethod GetTransPlan(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s ret="RowID|"_id
	s ret=ret_"^PlanCode|"_obj.PlanCode
	s ret=ret_"^PlanName|"_obj.PlanDesc
	s:(obj.PlanStatus="S") internStatus="已发布"
	s:(obj.PlanStatus'="S") internStatus="未发布"
	s ret=ret_"^PlanStatus|"_internStatus
	i obj.PlanCrtUser'=0 d
	.s ret=ret_"^CreateUser|"_$lg($g(^CF.DHCINM.DB.MgUserD(obj.PlanCrtUser)),2)
	e  s ret=ret_"^CreateUser|超级管理员"
	i obj.PlanCrtDate'="" s ret=ret_"^PlanCrtDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PlanCrtDate)
	s:obj.PlanIntern'="" ret=ret_"^PlanPerNum|"_($l(obj.PlanIntern,","))
	s:obj.PlanIntern="" ret=ret_"^PlanPerNum|0"
	s stdate="",enddate=""
	s:obj.PlanStDate'="" stdate=$zd(obj.PlanStDate,3)
	s:obj.PlanEndDate'="" enddate=$zd(obj.PlanEndDate,3)
	s ret=ret_"^PlanStDate|"_stdate
	s ret=ret_"^PlanEndDate|"_enddate
	s ret=ret_"^Member|"_obj.PlanIntern
	s groupnum=0
	s group="" f  s group=$o(^DHCINM.Intern.MgTransPlanGroupI("Plan",id,group)) q:group=""  d
	.s groupnum=groupnum+1
	s ret=ret_"^PlanGroupNum|"_groupnum
	q ret
}

/// creator: wangcc
/// createdate: 20200803
/// description: 获取实习生批次成员
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTransPlanMember","1")
Query FindTransPlanMember(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPlanMemberExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TMP("FindTransPlanMember")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s obj=##class(DHCINM.Intern.MgTransPlan).%OpenId(parr)
	q:'$IsObject(obj)
	f i=1:1:$l(obj.PlanIntern,",")  d
	.s internid=$p(obj.PlanIntern,",",i)
	.s name=$lg(^CF.DHCINM.HR.PersonsD(internid),2)
	.s no=$lg(^CF.DHCINM.HR.PersonsD(internid),3)
	.s disabled="false"
	.;s:..IsInGroup(internid,parr)=1 disabled="true"
	.s ret="rw|"_internid_"^internName|"_name_"^disable|"_disabled_"^internNo|"_no
	.d OutTransPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTransPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPlanMemberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPlanMemberExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTransPlanMemberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPlanMemberExecute ]
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

/// creator: wangcc
/// createdate: 20170918
/// description: 实习生是否已经分组
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other:
ClassMethod IsInGroup(intern, plan)
{
	s flag=0
	i plan'=""  d
	.s grp="" f  s grp=$o(^DHCINM.Intern.MgTransPlanGroupI("Plan",plan,grp)) q:((grp="")||(flag=1))  d
	..s member=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),6)
	..s:(","_member_",")[(","_intern_",") flag=1
	..i flag'=1 d
	...s master=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),5)
	...s:master=intern flag=1
	e  d
	.s member="" f  s member=$o(^DHCINM.Intern.MgTransPlanGroupI("Member",member)) q:((member="")||(flag=1))  d
	..s:(","_$tr(member," ","")_",")[(","_intern_",") flag=1
	..i flag'=1 d
	...s grp=$o(^DHCINM.Intern.MgTransPlanGroupI("Member",member,""))
	...s master=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),5)
	...s:master=intern flag=1
	q flag
}

/// creator: wangcc
/// createdate: 20170918
/// description: 删除实习生批次
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other:
ClassMethod DeleteTransPlan(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlan).%OpenId(id)
	s grpid="" f  s grpid=$O(^DHCINM.Intern.MgTransPlanGroupI("Plan",id,grpid)) q:grpid=""  d
	.d ##class(DHCINM.Intern.MgTransPlanGroup).%DeleteId(grpid)
	s timeid="" f  s timeid=$O(^DHCINM.Intern.MgTransPlanTimeI("Plan",id,timeid)) q:timeid=""  d
	.d ##class(DHCINM.Intern.MgTransPlanTime).%DeleteId(timeid)
	s subid="" f  s subid=$O(^DHCINM.Intern.MgTransPlanSubI("Plan",id,subid)) q:subid=""  d
	.d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: wangcc
/// createdate: 20200805
/// description: 获取实习生转科计划列表
/// table: DHCINM.Intern.MgTransPlan
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTransPlan","^^")
Query FindTransPlan(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPlanExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TMP("FindTransPlan")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s status=$p(parr,"^",3)
	s id="" f  s id=$O(^DHCINM.Intern.MgTransPlanD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgTransPlan).%OpenId(id)
	.q:((stdate'="")&&(stdate>obj.PlanCrtDate))
	.q:((enddate'="")&&(enddate<obj.PlanCrtDate))
	.q:(status="S")&&(obj.PlanStatus'="S")
	.q:(status="NS")&&(obj.PlanStatus="S")
	.s ret=..GetTransPlan(id)
	.d OutTransPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTransPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTransPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPlanExecute ]
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

/// creator: wangcc
/// createdate: 20170918
/// description: 保存实习生分组
/// table: DHCINM.Intern.MgTransPlanGroup
/// input:
/// output:
/// other:
ClassMethod SavePlanGroup(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCINM.Intern.MgTransPlanGroup).%New()
	s obj.PlanDR=##class(DHCINM.Intern.MgTransPlan).%OpenId(tmp("PlanDR"))
	s obj.GroupDesc=$g(tmp("GroupName"))
	s obj.GroupMaster=$g(tmp("GroupMaster"))
	s obj.GroupMember=$g(tmp("GroupMember"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: wangcc
/// createdate: 20170918
/// description: 获取实习生分组
/// table: DHCINM.Intern.MgInternGroup
/// input:
/// output:
/// other:w ##class(web.INMInternComm).GetPlanGroup(1)
ClassMethod GetPlanGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(id)
	s ret="RowID|"_id
	s ret=ret_"^PlanDR|"_obj.PlanDR.%Id()
	s ret=ret_"^GroupName|"_obj.GroupDesc
	s master="",masterName=""
	s:obj.GroupMaster'="" master=obj.GroupMaster,masterName=$lg(^CF.DHCINM.HR.PersonsD(obj.GroupMaster),2)
	s ret=ret_"^GroupMaster|"_master
	s ret=ret_"^PerName|"_masterName
	s members=0
	s:obj.GroupMember'="" members=$l(obj.GroupMember,",")
	s:(","_obj.GroupMember_",")'[(","_obj.GroupMaster_",") members=members+1
	s ret=ret_"^PerNum|"_members_"^GroupMember|"_obj.GroupMember
	q ret
}

/// creator: wangcc
/// createdate: 20170918
/// description: 删除实习生分组
/// table: DHCINM.Intern.MgInternGroup
/// input:
/// output:
/// other:
ClassMethod DeletePlanGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(id)
	q:'$IsObject(obj) 0
	s subid="" f  s subid=$O(^DHCINM.Intern.MgTransPlanSubI("PlanGroup",obj.PlanDR.%Id(),id,subid)) q:subid=""  d
	.d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
 	s sc=obj.%DeleteId(id)
	q:$$$ISOK(sc) 1
	q 0
}

/// creator: wangcc
/// createdate: 20170918
/// description: 获取实习生分组
/// table: DHCINM.Intern.MgInternGroup
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindPlanGroup","1")
Query FindPlanGroup(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPlanGroupExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tpid=$P(parr,"^",1)
	i tpid=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s grpid="" f  s grpid=$O(^DHCINM.Intern.MgTransPlanGroupI("Plan",tpid,grpid)) q:grpid=""  d
	.s obj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(grpid)
	.s ret=..GetPlanGroup(grpid)
	.d OutPlanGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanGroupExecute ]
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

/// creator:wangcc
/// createdate:20170919
/// description: 保存实习计划时段信息
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod SavePlanTime(parr As %String) As %String
{
	s ^TMP("SavePlanTime")=parr
	q:parr="" 0
	s flag=1
	ts
	f i=1:1:$l(parr,"「") q:flag=0  d
	.s sub=$p(parr,"「",i)
	.d ##class(web.INMVueComm).SplitStr(sub,"^","|",.tmp)
	.i $g(tmp("rw"))'="" s obj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(tmp("rw"))
	.e  s obj=##class(DHCINM.Intern.MgTransPlanTime).%New()
	.i $g(tmp("PlanDR"))'="" s obj.PlanDR=##class(DHCINM.Intern.MgTransPlan).%OpenId(tmp("PlanDR"))
	.i $g(tmp("PlanStDate"))'="" s obj.PlanStDate=$zdh(tmp("PlanStDate"),3)
	.e  s obj.PlanStDate=""
	.i $g(tmp("PlanEndDate"))'="" s obj.PlanEndDate=$zdh(tmp("PlanEndDate"),3)
	.e  s obj.PlanEndDate=""
	.s sc=obj.%Save()
	.s:'$$$ISOK(sc) flag=0
	i flag=0{
		tro
		q 0
	}
	tc
	q 1
}

/// creator:wangcc
/// createdate:20200803
/// description: 保存病区实习生上下限
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveRange(parr As %String) As %String
{
	s ^TMP("SaveRange")=parr
	q:parr="" 0
	s flag=1
	ts
	f i=1:1:$l(parr,"「") q:flag=0  d
	.s sub=$p(parr,"「",i)
	.d ##class(web.INMVueComm).SplitStr(sub,"^","|",.tmp)
	.i $g(tmp("rw"))'="" s obj=##class(DHCINM.Intern.MgWardPerRange).%OpenId(tmp("rw"))
	.e  s obj=##class(DHCINM.Intern.MgWardPerRange).%New()
	.s obj.Max=$g(tmp("max"))
	.s obj.Min=$g(tmp("min"))
	.s obj.Ward=$g(tmp("ward")) 
	.s sc=obj.%Save()
	.s:'$$$ISOK(sc) flag=0
	i flag=0{
		tro
		q 0
	}
	tc
	q 1
}

/// creator:xbl
/// createdate:20170919
/// description: 获取实习计划时段信息
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPlanTime(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(id)
	s ret="RowID|"_id
	i obj.PlanDR'="" d
	.s ret=ret_"^PlanDR|"_obj.PlanDR.%Id()
	.s ret=ret_"^PlanDesc|"_obj.PlanDR.PlanDesc
	i obj.PlanStDate'="" d
	.s ret=ret_"^PlanStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PlanStDate)
	i obj.PlanEndDate'="" d
	.s ret=ret_"^PlanEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PlanEndDate)
	i (obj.PlanStDate'="")&&(obj.PlanEndDate'="") d
	.s ret=ret_"^TimeDesc|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PlanStDate)_"至"_##class(web.INMHISComm).DateLogicalToHtml(obj.PlanEndDate)
	.s ret=ret_"^TimeCode|Time"_id
	q ret
}

/// creator: xbl
/// createdate: 20170919
/// description: 删除计划时段信息
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:w ##class(web.INMInternComm).DeletePlanTime(2)
ClassMethod DeletePlanTime(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(id)
	s subid="" f  s subid=$O(^DHCINM.Intern.MgTransPlanSubI("PlanTime",obj.PlanDR.%Id(),id,subid)) q:subid=""  d
	.d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: wangcc
/// createdate: 20170919
/// description: 删除病区人数范围
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:w ##class(web.INMInternComm).DeletePlanTime(2)
ClassMethod DeleteRange(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgWardPerRange).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170919
/// description: 获取计划时段信息列表
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindPlanTime","1")
Query FindPlanTime(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPlanTimeExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tpid=$P(parr,"^",1)
	i tpid=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s date="" f  s date=$o(^DHCINM.Intern.MgTransPlanTimeI("date",tpid,date)) q:date=""  d
	.s id="" f  s id=$o(^DHCINM.Intern.MgTransPlanTimeI("date",tpid,date,id)) q:id=""  d
	..s obj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(id)
	..s ret=..GetPlanTime(id)
	..d OutPlanTime
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanTime
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanTimeExecute ]
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

/// creator: wangcc
/// createdate: 20200804
/// description: 获取各个科室人数范围
/// table: DHCINM.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindRange")
Query FindRange() As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRangeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$o(^DHCINM.Intern.MgWardPerRangeD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgWardPerRange).%OpenId(id)
	.s ret="PlanWard|"_obj.Ward_"^max|"_obj.Max_"^min|"_obj.Min_"^RowID|"_id
	.d OutPlanTime
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanTime
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRangeExecute ]
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

/// creator: wangcc
/// createdate: 20170919
/// desciption: 保存轮转计划
/// table: DHCINM.Intern.MgTransPlanSub
/// input: 
/// output:
/// return:
/// other: w ##class(web.INMInternComm).SavePlanSub("Ward|2^Member|24,5,13,25,25^TimeDr|1^PlanGroupDR|1@Ward|4^Member|24,5,13,25,25^TimeDr|3^PlanGroupDR|1",1)
ClassMethod SavePlanSub(parr As %String, plan, status) As %String
{
	s isHasArg=..IsHasArg(parr)
	q:isHasArg'="" isHasArg_"存在其他病区的排班"
	s flag=1
	ts
	s planobj=##class(DHCINM.Intern.MgTransPlan).%OpenId(plan)
	s planobj.PlanStatus=status
	s sc=planobj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q 0
	}
	f i=1:1:$l(parr,"@") q:flag=0  d
	.s parritm=$p(parr,"@",i)
	.s tmp=""
	.d ##class(web.INMVueComm).SplitStr(parritm,"^","|",.tmp)
	.q:$g(tmp("PlanGroupDR"))=""
	.q:$g(tmp("TimeDr"))=""
	.q:$g(tmp("Ward"))=""
	.q:$g(tmp("Member"))=""
	.f j=1:1:$l(tmp("Member"),",") q:flag=0  d
	..s perdr=$p(tmp("Member"),",",j)
	..s rw=$O(^DHCINM.Intern.MgTransPlanSubI("PerTime",plan,tmp("PlanGroupDR"),tmp("TimeDr")," "_perdr,""))
	..s obj=##class(DHCINM.Intern.MgTransPlanSub).%New()
	..i rw'="" d
	...s obj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(rw)
	..s obj.PlanPerDR=perdr
	..s obj.PlanDR=##class(DHCINM.Intern.MgTransPlan).%OpenId(plan)
	..s obj.PlanGroupDR=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(tmp("PlanGroupDR"))
	..s obj.PlanTimeDR=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(tmp("TimeDr"))
	..s obj.PlanWardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("Ward"))
	..s sc=obj.%Save()
	..s:'$$$ISOK(sc) flag=0
	..q:flag=0
	..i status="S" d
	...s parr1="NurseId|"_perdr_"^InWard|"_tmp("Ward")_"^TransStDate|"_$zd(obj.PlanTimeDR.PlanStDate,3)_"^TransEndDate|"_$zd(obj.PlanTimeDR.PlanEndDate,3)
	...s flag=##class(web.INMPersonComm).SaveTransDep(parr1,"","","",obj.%Id())
	tro:flag=0
	tc:flag=1
	q flag
}

///  creator: wangcc
///  createdate: 20170921
///  description: 获取计划明细
///  table: DHCINM.Intern.MgTransPlanSub
///  input:
///  output:
///  return:
///  other: w ##class(%ResultSet).RunQuery("web.INMInternComm","FindPlanSub","1")
Query FindPlanSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tpid=$P(parr,"^",1)
	i tpid=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s disable="false"
	s planobj=##class(DHCINM.Intern.MgTransPlan).%OpenId(tpid)
	s:planobj.PlanStatus="S" disable="true"
	s desc="" f  s desc=$O(^DHCINM.Intern.MgTransPlanGroupI("GroupDesc",tpid,desc)) q:desc=""  d
	.s grpdr="" f  s grpdr=$O(^DHCINM.Intern.MgTransPlanGroupI("GroupDesc",tpid,desc,grpdr)) q:grpdr=""  d
	..s grpobj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(grpdr)
	..s groupDesc=grpobj.GroupDesc
	..s ret="^PlanGroupDR|"_grpdr_"^PlanDesc|"_planobj.PlanDesc	
	..s groupMaster=""
	..s timedr="" f  s timedr=$O(^DHCINM.Intern.MgTransPlanTimeI("Plan",tpid,timedr)) q:timedr=""  d
	...s ret=ret_"^Time"_timedr_"|"
	...s timeobj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(timedr)
	...s st=timeobj.PlanStDate
	...s end=timeobj.PlanEndDate
	...s persons="",perdrs=""
	...s range=""
	...i '$O(^DHCINM.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,"")) d
	....f i=1:1:$l(grpobj.GroupMember,",") d
	.....s perdr=$p(grpobj.GroupMember,",",i)
	.....q:perdr=""
	.....s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.....q:(perobj.PerInternStDate>end)||(perobj.PerInternEndDate<st)
	.....i persons'="" s persons=persons_","_perobj.PerName
	.....e  s persons=perobj.PerName
	.....i perdrs'="" s perdrs=perdrs_","_perdr
	.....e  s perdrs=perdr
	....s NurObj=##class(CF.DHCINM.HR.Persons).%OpenId(grpobj.GroupMaster)
	....q:'$IsObject(NurObj)
	....i '((NurObj.PerInternStDate>end)||(NurObj.PerInternEndDate<st)) d
	.....i (","_grpobj.GroupMember_",")'[(","_grpobj.GroupMaster_",") d
	......s persons=persons_","_NurObj.PerName
	......s perdrs=perdrs_","_grpobj.GroupMaster
	.....s groupMaster=NurObj.PerName
	....s ret=ret_"#"_persons_"#"_"当前总人数:"_0_"「"_"范围:"_range_"「#"_perdrs_"#"
	...e  d
	....s cellvalue=""
	....s warddr="" f  s warddr=$O(^DHCINM.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr)) q:warddr=""  d
	.....s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(warddr)
	.....s num=..GetRotationIntern(warddr,timedr)
	.....s max="",min=""
	.....s rangeid=$o(^DHCINM.Intern.MgWardPerRangeI("ward"," "_warddr,""))
	.....s:rangeid'="" max=$lg(^DHCINM.Intern.MgWardPerRangeD(rangeid),3)
	.....s:rangeid'="" min=$lg(^DHCINM.Intern.MgWardPerRangeD(rangeid),4)
	.....s:(max'="")&&(min'="") range=min_"-"_max
	.....s persons=""
	.....s perdr="" f  s perdr=$O(^DHCINM.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr)) q:perdr=""  d
	......s perobj=##class(CF.DHCINM.HR.Persons).%OpenId($tr(perdr," ",""))
	......s subid=$O(^DHCINM.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr,""))
	......q:subid=""
	......i persons="" s persons=perobj.PerName
	......e  s persons=persons_","_perobj.PerName
	......i perdrs'="" s perdrs=perdrs_","_$tr(perdr," ","")
	......e  s perdrs=$tr(perdr," ","")
	.....q:persons=""
	.....s color=""
	.....i (range'="")&&((num<min)||(num>max)) s color="danger"
	.....i cellvalue="" s cellvalue=warddr_"#"_persons_"#"_"当前总人数:"_num_"「"_"范围:"_range_"「"_color_"#"_perdrs_"#"_wardobj.WardDesc
	.....e  s cellvalue=cellvalue_warddr_"#"_persons_"#"_"当前总人数:"_num_"「"_"范围:"_range_"「"_color_"#"_perdrs_"#"_wardobj.WardDesc
	....s ret=ret_cellvalue
	..s ret=ret_"^groupDesc|"_groupDesc_"^groupMaster|"_groupMaster_"^disable|"_disable
	..d OutPlanSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanSubExecute ]
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

/// Creator: lulin
/// CreatDate: 2017年11月29日 15:26:09
/// Description: 获取实习生转正状态
/// Table：DHCINM.Intern.MgIntern
/// Input：
/// Return：申请驳回
/// Other:
ClassMethod RejectFullWorkerApply(parr As %String) As %String
{
	q:parr="" ""
	s rowid=$p(parr,"^")
	s RecUser=$p(parr,"^",2)
	q:rowid="" ""
	s obj=##class(DHCINM.Intern.MgIntern).%OpenId(rowid)
	s obj.IntStatus="N"
	s obj.RecUser=RecUser
	s obj.RecDate=+$h
	s obj.RecTime=$p($h,"^",2)
	d obj.%Save()
	q obj.%Id()
}

/// Creator: lulin
/// CreatDate: 2017-11-28
/// Description: 获取实习生是否是往届
/// Table：DHCINM.Intern.MgIntern
/// Input：
/// Return：成功返回 状态 Y:已转正
/// Other:d ##class(web.INMInternComm).ApplyFullWorkerStatus("")
ClassMethod ApplyFullWorkerStatus(parr As %String) As %String
{
	q:parr="" ""
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(parr)
	q:'$IsObject(perObj) ""
	s PerCategroy=##class(web.INMPersonComm).GetCommCode(perObj.PerCategroy)
	s ret=""
	s:PerCategroy["往届" ret="Y"
	q ret
}

/// Creator: lulin
/// CreatDate: 2017-11-28
/// Description: 实习生转正申请
/// Table：CF.DHCINM.HR.Persons、DHCINM.Intern.MgIntern
/// Input：
/// Return：
/// Other:d ##class(web.INMInternComm).ApplyFullWorkerStatus("1080")
ClassMethod applyFullWorker(parr As %String) As %String
{
	q:parr=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(parr)
	s InternId=$o(^DHCINM.Intern.MgInternI("ssid",parr,""),-1)
	i InternId="" s objInt=##class(DHCINM.Intern.MgIntern).%New()
	e  s objInt=##class(DHCINM.Intern.MgIntern).%OpenId(InternId)
	s objInt.IntPerDR=obj
	s objInt.IntName=obj.PerName
	s objInt.IntNo=obj.PerNo
	s objInt.IntBirthday=obj.PerBirthday
	s objInt.IntCardId=obj.PerCardId
	s objInt.IntSexDR=obj.PerSexDR
	s objInt.IntDepDR=obj.PerDepDR
	s objInt.IntDepDate=obj.PerDepDate
	s objInt.IntComeDate=obj.PerComeDate
	s objInt.IntPolitical=obj.PerPolitical
	s objInt.IntNativePlace=obj.PerNativePlace
	s objInt.IntMarriage=obj.PerMarriage
	s objInt.IntAddress=obj.PerAddress
	s objInt.IntContact=obj.PerContact
	s objInt.IntPhone=obj.PerPhone
	s objInt.IntStatus="A"
	s objInt.RecUser=obj.%Id()
	s objInt.RecDate=+$h
	s objInt.RecTime=$p($h,"^",2)
	d objInt.%Save()
}

/// Creator: wangcc
/// CreatDate: 2020-08-12
/// Description: 实习生转正
/// Table：CF.DHCINM.HR.Persons、DHCINM.Intern.MgIntern
/// Input：perrowid|1801^PerId|LL001^PerDepDR|57^PerDepDate|2017-11-29^HireDuty|14__7^HireStDate|2017-11-29^RowID|2^RecUser|
/// Return：-1工号已存在、1保存成功
/// Other:d ##class(web.INMInternComm).CheckFullWorkerApply("PerId|LL3^PerDepDR|57^PerDepDate|2017-11-29^HireDuty|14__7^HireStDate|2017-11-29^RowID|3^RecUser|")
ClassMethod SetInternRegular(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:'$d(tmp("perrowid")) "无对应人员"
	;s flag=$P(##class(web.INMPersonComm).IsExist(tmp("PerId")),"^")
	;q:flag=0 "此工号已经存在"
	s per=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("perrowid"))
	i 'tmp("RowID") s objInt=##class(DHCINM.Intern.MgIntern).%New()
	e  s objInt=##class(DHCINM.Intern.MgIntern).%OpenId(tmp("RowID"))
	s objInt.IntPerDR=per
	s objInt.IntName=per.PerName
	s objInt.IntNo=per.PerNo
	s objInt.IntBirthday=per.PerBirthday
	s objInt.IntCardId=per.PerCardId
	s objInt.IntSexDR=per.PerSexDR
	s objInt.IntDepDR=per.PerDepDR
	s objInt.IntDepDate=per.PerDepDate
	s objInt.IntComeDate=per.PerComeDate
	s objInt.IntPolitical=per.PerPolitical
	s objInt.IntNativePlace=per.PerNativePlace
	s objInt.IntMarriage=per.PerMarriage
	s objInt.IntAddress=per.PerAddress
	s objInt.IntContact=per.PerContact
	s objInt.IntPhone=per.PerPhone
	s objInt.PerInternStDate=per.PerInternStDate
	s objInt.PerInternEndDate=per.PerInternEndDate
	s objInt.IntStatus="Y"
	s objInt.RecUser=tmp("RecUser")
	s objInt.RecDate=+$h
	s objInt.RecTime=$p($h,"^",2)
	TS
	S sc=objInt.%Save()
	if $$$ISERR(sc){
		Tro
		q "保存实习记录失败"
	}
	;s per.PerID=tmp("PerId")
	s per.PerTypeDR="N"
	s per.RecUser=tmp("RecUser")
	s per.RecDate=+$h
	s per.RecTime=$p($h,",",2)
	s per.PerDepDR=tmp("PerDepDR")
	s per.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
	s per.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届") //实习生转正后要把实习生类别置成”往届“
	i tmp("PerDepDate")'="" s per.PerDepDate=tmp("PerDepDate")
	S sc=per.%Save()
	if $$$ISERR(sc){
		Tro
		q "修改人员档案失败"
	}
	s duty=##class(CF.DHCINM.HR.HireDuty).%New()
	s duty.HirePerDR=per
	s duty.HireDuty=tmp("HireDuty")
	i tmp("PerDepDate")'="" s duty.HireStDate=tmp("HireStDate")
	S sc=duty.%Save()
	if $$$ISERR(sc){
		Tro
		q "保存聘任职称失败"
	}
	s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_per.%Id(),""))
	s TransFlag=""
	i transRowID="" d
	.s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_per.%Id()_"^"_per.PerDepDR_"^"_$zd(per.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	e  d
	.s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
	.s aa.PerDr=per.%Id()
    .s aa.PerDepart=per.PerDepDR
    .s aa.PerTranStDate=per.PerDepDate
    .s aa.PerTranCurrent="Y"
    .s aa.PerTranStTime=$P($H,",",2)
    .s sc=aa.%Save()
    .i $$$ISOK(sc) s TransFlag=0
    if TransFlag'=0{
		Tro
		q "保存调配记录表失败"
	}
	else{
		TC
		q ""
	}
}

/// Creator: 
/// CreatDate: 2017-12-07
/// Description: 获取实习生转正后实习时数据
/// Table：CF.DHCINM.HR.Persons
/// Input：
/// Return： 
ClassMethod GetValue(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.Intern.MgIntern).%OpenId(id)
	s PerName=obj.IntName
	s PerSexDR=obj.IntSexDR
	i obj.IntBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.IntBirthday)
	e  s PerBirthday=""
	s PerNo=obj.IntNo
	s PerCategroy=obj.PerCategroy
	s PerCardId=obj.IntCardId
	s PerDepDR=obj.IntDepDR
	i obj.IntDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.IntDepDate)
	e  s PerDepDate=""
	i obj.IntComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.IntComeDate)
	e  s PerComeDate=""
	i obj.PerInternEndDate'="" s PerInternEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerInternEndDate)
	e  s PerInternEndDate=""
	i obj.PerInternStDate'="" s PerInternStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerInternStDate)
	e  s PerInternStDate=""
	s PerPolitical=obj.IntPolitical
	s PerMarriage=obj.IntMarriage
	s PerPic=obj.IntPic
	s CurrentAddress=obj.CurrentAddress
	s CurrentCity=obj.CurrentCity
	s CurrentProvince=obj.CurrentProvince
	s NativeAddress=obj.NativeAddress
	s NativeCity=obj.NativeCity
	s NativeProvince=obj.NativeProvince
	s PerContact=obj.IntContact
	s PerPhone=obj.IntPhone
	s PerContactPhone=""
	s PerInternSchool=obj.PerInternSchool
	s PerNation=""
	i obj.IntBirthday'="" d
	.s age=##class(web.INMVueComm).CalAge($zd(obj.IntBirthday,3),$zd(+$H,3))
	.s PerAge=$p(age,"Y",1)
	s PerNativePlace=""
	s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerBirthday|"_PerBirthday_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId
	s ret=ret_"^PerNativePlace|"_PerNativePlace_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerNation|"_PerNation
	s ret=ret_"^PerComeDate|"_PerComeDate_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerPic|"_PerPic
	s ret=ret_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^RowID|"_id_"^PerInternSchool|"_PerInternSchool_"^PerCategroy|"_PerCategroy
	s ret=ret_"^PerContactPhone|"_PerContactPhone_"^NativeAddress|"_NativeAddress_"^NativeCity|"_NativeCity_"^PerAge|"_PerAge
	s ret=ret_"^NativeProvince|"_NativeProvince_"^CurrentAddress|"_CurrentAddress_"^CurrentCity|"_CurrentCity_"^CurrentProvince|"_CurrentProvince
	s ret=ret_"^PerInternEndDate|"_PerInternEndDate_"^PerInternStDate|"_PerInternStDate
	q ret
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 保存带教老师
/// table: DHCINM.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other: w ##class(web.INMInternComm).SaveTeacher("TeachPerDR|98^TeachWardDR|57^TeachStDate|2017-12-20^TeachEndDate|2017-12-20^TeachRemark|测试^rw|^")
ClassMethod SaveTeacher(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCINM.Intern.MgTeacher).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCINM.Intern.MgTeacher).%New()
	i $g(tmp("TeachPerDR"))'="" d
	.s obj.TeachPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("TeachPerDR"))
	e  d
	.s obj.TeachPerDR=""
	i $g(tmp("TeachWardDR"))'="" d
	.s obj.TeachWardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("TeachWardDR"))
	e  d
	.s obj.TeachWardDR=""
	i $g(tmp("TeachStDate"))'="" d
	.s obj.TeachStDate=$zdh(tmp("TeachStDate"),3)
	e  s obj.TeachStDate=""
	i $g(tmp("TeachEndDate"))'="" d
	.s obj.TeachEndDate=$zdh(tmp("TeachEndDate"),3)
	e  s obj.TeachEndDate=""
	s obj.TeachRemark=$g(tmp("TeachRemark"))
	i (tmp("CrtUser")'="")&&(tmp("CrtUser")'=0) d
	.s crtObj=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("CrtUser"))
	.q:'$IsObject(crtObj)
	.s obj.TeachCrtUser=crtObj
	s obj.TeachCrtDate=+$H
	s obj.TeachCrtTime=$P($H,",",2)
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 获取带教老师
/// table: DHCINM.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other:
ClassMethod GetTeacher(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.Intern.MgTeacher).%OpenId(id)
	s ret="rw|"_id
	i obj.TeachPerDR'="" d
	.s ret=ret_"^TeachPerDR|"_obj.TeachPerDR.%Id()
	.s ret=ret_"^PerID|"_obj.TeachPerDR.PerID
	.s ret=ret_"^PerName|"_obj.TeachPerDR.PerName
	i obj.TeachWardDR'="" d
	.s ret=ret_"^TeachWardDR|"_obj.TeachWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.TeachWardDR.WardDesc
	i obj.TeachStDate'="" d
	.s ret=ret_"^TeachStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.TeachStDate)
	i obj.TeachEndDate'="" d
	.s ret=ret_"^TeachEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.TeachEndDate)
	s ret=ret_"^TeachRemark|"_obj.TeachRemark
	s TeachCrtUser="",CrtUserName=""
	i obj.TeachCrtUser'="" d
	.s TeachCrtUser=obj.TeachCrtUser
	.s:$IsObject(TeachCrtUser) CrtUserName=TeachCrtUser.PerName
	e  s TeachCrtUser=0,CrtUserName="管理员"
	s ret=ret_"^TeachCrtUser|"_TeachCrtUser
	s ret=ret_"^CrtUserName|"_CrtUserName
	i obj.TeachCrtDate'="" d
	.s ret=ret_"^TeachCrtDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.TeachCrtDate)
	i obj.TeachCrtTime'="" d
	.s ret=ret_"^TeachCrtTime|"_$zt(obj.TeachCrtTime,2)
	q ret
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 删除带教老师
/// table: DHCINM.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteTeacher(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Intern.MgTeacher).%OpenId(id)
	s sc=obj.%DeleteId(id)
	i $$$ISOK(sc)
	{
		s stuid="" f  s stuid=$O(^DHCINM.Intern.MgStudentI("Teacher",id,stuid)) q:stuid=""  d
		.q:+stuid=0
		.s stuobj=##class(DHCINM.Intern.MgStudent).%OpenId(stuid)
		.d stuobj.%DeleteId(stuid)
		q 1
	}
	else
	{
		q 0
	}
}

///  creator: xbl
///  createdate: 2017/12/18
///  description: 获取带教老师列表
///  table: DHCINM.Intern.MgTeacher
///  input:
///  output:
///  return:
///  other:
Query FindTeacherList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTeacherListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s id="" f  s id=$O(^DHCINM.Intern.MgTeacherD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgTeacher).%OpenId(id)
	.q:(obj.TeachWardDR="")||(obj.TeachPerDR="")
	.q:(ward'="")&&(ward'=obj.TeachWardDR.%Id())
	.s perdr=obj.TeachPerDR.%Id()
	.s perinfo=obj.TeachPerDR.PerID_","_obj.TeachPerDR.PerName
	.q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	.s ret=..GetTeacher(id)
	.d OutTeacher
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTeacher
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTeacherListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTeacherListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTeacherListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTeacherListExecute ]
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

/// Creator:lulin
/// Description:导入实习生信息
/// Date:2018-07-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.INMInternComm).ImportInternData("PerNo|11121^PerName|李时^PerDepDR|产科二病区^PerCardId|530121198709185389^PerCategroy|应届^PerInternStDate|2020-09-03^PerInternEndDate|2020-12-08^PerDepDate|2019-06-08^PerComeDate|2019-06-08^PerType|大专^PerInternSchool|海南医学院^PerPolitical|共青团员^PerMarriage|未婚^PerNativePlace1|北京市^PerNativePlace2|北京城区^PerNativePlace3|东城区^saveIndex|0")
ClassMethod ImportInternData(parr As %String) As %String
{
	s ^tmp("ImportInternData")=parr
	s tmp=""
	s flag=1
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	i PerCardId'="" s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	e  s ^TMP("INMImportDBData","1",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 1
	i rowid="" s obj=##class(CF.DHCINM.HR.Persons).%New()
	e  s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	s isExist=0
	s perNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	i perNo="" s ^TMP("INMImportDBData","2",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 2
	s perNoRowID=$o(^CF.DHCINM.HR.PersonsI("PerNo"," "_perNo,""))
	i ((perNoRowID'="")&&(perNoRowID'=rowid)) s ^TMP("INMImportDBData","3",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 3
	s obj.PerNo=perNo //实习编号
	i $g(tmp("PerName"))'="" s obj.PerName=$tr($g(tmp("PerName"))," ","") //姓名
	e  s ^TMP("INMImportDBData","4",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 4
	s obj.NativeProvince=$tr($g(tmp("PerNativePlace1"))," ","") //籍贯
	s obj.NativeCity=$tr($tr($g(tmp("PerNativePlace2"))," ",""),"城区","市") //籍贯
	s obj.NativeArea=$tr($g(tmp("PerNativePlace3"))," ","") //籍贯
	s obj.NativeAddress=$tr($g(tmp("PerNativePlace4"))," ","") //籍贯
	s obj.CurrentProvince=$tr($g(tmp("PerAddress1"))," ","") //现住址所在省  
	s obj.CurrentCity=$tr($tr($g(tmp("PerAddress2"))," ",""),"城区","市") //现住址所在市  
	s obj.CurrentArea=$tr($g(tmp("PerAddress3"))," ","") //现住址所在区(县)  
	s obj.CurrentAddress=$tr($g(tmp("PerAddress4"))," ","") //现住址详细信息
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=##class(web.INMImportDBData).GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s obj.PerDepDR=warddr
	.e  s ^TMP("INMImportDBData","11",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 5
	e  s ^TMP("INMImportDBData","10",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 6
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s obj.PerDepDate=$zdh($g(tmp("PerDepDate")),3)
	e  s ^TMP("INMImportDBData","5",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 //进科日期
	i (($g(tmp("PerComeDate"))'="")&&($l($g(tmp("PerComeDate")),"-")=3)) s obj.PerComeDate=$zdh($g(tmp("PerComeDate")),3)
	e  s ^TMP("INMImportDBData","6",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 //来院日期
	i (($g(tmp("PerInternStDate"))'="")&&($l($g(tmp("PerInternStDate")),"-")=3)) s obj.PerInternStDate=$zdh($g(tmp("PerInternStDate")),3)
	e  s ^TMP("INMImportDBData","8",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 //实习开始日期
	i (($g(tmp("PerInternEndDate"))'="")&&($l($g(tmp("PerInternEndDate")),"-")=3)) s obj.PerInternEndDate=$zdh($g(tmp("PerInternEndDate")),3)
	e  s ^TMP("INMImportDBData","9",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 //实习结束日期
	i $g(tmp("PerCardId"))'="" d
	.s obj.PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //身份证号码
	.s cardlen=$L($tr($g(tmp("PerCardId"))," ",""))
	.i cardlen=18 d
	..s birthnum=$E($tr($g(tmp("PerCardId"))," ",""),7,14)
	..i birthnum'="" s obj.PerBirthday=$zdh(birthnum,8)
	..e  s obj.PerBirthday=""
	..s sexnum=$E($tr($g(tmp("PerCardId"))," ",""),17)
	..i +sexnum>=0 d
	...i (+sexnum#2)=0 s obj.PerSexDR=##class(web.INMImportDBData).GetSetCode("性别","女")
	...e  s obj.PerSexDR=##class(web.INMImportDBData).GetSetCode("性别","男")
	i $g(tmp("PerPolitical"))'="" d
	.s politicaldr=##class(web.INMImportDBData).GetSetCode("政治面貌",$zcvt($tr($g(tmp("PerPolitical"))," ",""),"U")) //政治面貌
	.i politicaldr'="" s obj.PerPolitical=politicaldr
	.e  s obj.PerPolitical=""
	e  s obj.PerPolitical=""
	i $g(tmp("PerMarriage"))'="" d
	.s marriagedr=##class(web.INMImportDBData).GetSetCode("婚姻",$zcvt($tr($g(tmp("PerMarriage"))," ",""),"U")) //婚姻
	.i marriagedr'="" s obj.PerMarriage=marriagedr
	.e  s obj.PerMarriage=""
	i $g(tmp("PerContact"))'="" s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
	e  s obj.PerContact=""
	i $g(tmp("PerContactPhone"))'="" s obj.PerContactPhone=$tr($g(tmp("PerContactPhone"))," ","")
	e  s obj.PerContactPhone=""
	i $g(tmp("PerPhone"))'="" s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
	e  s obj.PerPhone=""
	s obj.PerTypeDR="P"
	s obj.PerCareType="N"
	i $g(tmp("PerCategroy"))'="" s obj.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别",$zcvt($tr($g(tmp("PerCategroy"))," ",""),"U"))
	e  s ^TMP("INMImportDBData","7",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 //来院日期
	s obj.PerHeight=$g(tmp("PerHeight"))
	s obj.PerWeight=$g(tmp("PerWeight"))
	s obj.PerPassword="UUUUUU&&&&&&"
	i $g(tmp("PerNation"))'="" d
	.s nativeId=##class(web.INMImportDBData).GetSetCode("民族",$zcvt($tr($g(tmp("PerNation"))," ",""),"U"))
	.i nativeId'="" s obj.PerNation=nativeId
	.e  s obj.PerNation=""
	e  s obj.PerNation=""
	i $g(tmp("PerComeDate"))'="" s obj.PerYear=$p($g(tmp("PerComeDate")),"-",1)
	i $g(tmp("PerType"))'="" d
	.s PerTypeId=##class(web.INMImportDBData).GetSetCode("学历",$zcvt($tr($g(tmp("PerType"))," ",""),"U"))
	.i PerTypeId'="" s obj.PerType=PerTypeId
	.e  s obj.PerType=""
	e  s obj.PerType=""
	i $g(tmp("PerInternSchool"))'=""  d
	.s obj.PerInternSchool=##class(web.INMImportDBData).GetSetCode("毕业院校",$zcvt($tr($g(tmp("PerInternSchool"))," ",""),"U"))
	s obj.PerEspecially=$g(tmp("PerEspecially"))
	s sc=obj.%Save()
	///调科记录导入
	s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_obj.%Id(),""))
	i transRowID="" d
	.i obj.PerDepDate'="" s perdepdate=obj.PerDepDate
	.e  s perdepdate=+$h
	.s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(perdepdate,3)_"^^Y")	
	e  d
	.s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
	.s aa.PerDr=obj.%Id()
    .s aa.PerDepart=obj.PerDepDR
    .i obj.PerDepDate'="" s aa.PerTranStDate=obj.PerDepDate
    .e  s aa.PerTranStDate=+$h
    .s aa.PerTranCurrent="Y"
    .d aa.%Save()
	q $tr($g(tmp("saveIndex"))," ","")
}

/// Creator:lulin
/// Description:导入实习生转正信息
/// Date:2018-07-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ImportInternApplyData(parr As %String, role As %String, nurseid As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=$P(##class(web.INMPersonComm).IsExist(tmp("PerID")),"^")
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	q:flag=0 saveIndex
	;s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	;s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U") //取得实习编号
	s rowid=$O(^CF.DHCINM.HR.PersonsI("Info"," P"," "_PerNo,""))
	s per=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	q:'$IsObject(per) saveIndex
	s id=$O(^DHCINM.Intern.MgInternI("ssid",rowid,""))
	i id="" s objInt=##class(DHCINM.Intern.MgIntern).%New()
	e  s objInt=##class(DHCINM.Intern.MgIntern).%OpenId(id)
	s objInt.IntPerDR=per
	s objInt.IntName=per.PerName
	s objInt.IntNo=per.PerNo
	s objInt.IntBirthday=per.PerBirthday
	s objInt.IntCardId=per.PerCardId
	s objInt.IntSexDR=per.PerSexDR
	s objInt.IntDepDR=per.PerDepDR
	s objInt.IntDepDate=per.PerDepDate
	s objInt.IntComeDate=per.PerComeDate
	s objInt.IntPolitical=per.PerPolitical
	s objInt.IntNativePlace=per.PerNativePlace
	s objInt.IntMarriage=per.PerMarriage
	s objInt.IntAddress=per.PerAddress
	s objInt.IntContact=per.PerContact
	s objInt.IntPhone=per.PerPhone
	s objInt.IntStatus="Y"
	s objInt.RecUser=nurseid
	s objInt.RecDate=+$h
	s objInt.RecTime=$p($h,"^",2)
	TS
	S sc=objInt.%Save()
	if $$$ISERR(sc){
		Tro
		q saveIndex
	}
	s:$g(tmp("PerID"))'="" per.PerID=$tr($g(tmp("PerID"))," ","")
	s per.PerTypeDR="N"
	s:nurseid'=0 per.RecUser=nurseid
	s per.RecDate=+$h
	s per.RecTime=$p($h,",",2)
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=##class(web.INMImportDBData).GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s per.PerDepDR=warddr
	.e  s per.PerDepDR=""
	e  s per.PerDepDR=""
	s per.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
	s per.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届")
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s per.PerDepDate=$zdh(tmp("PerDepDate"),3)
	S sc=per.%Save()
	if $$$ISERR(sc){
		Tro
		q saveIndex
	}
	s duty=##class(CF.DHCINM.HR.HireDuty).%New()
	s duty.HirePerDR=per
	s duty.HireDuty=##class(web.INMImportDBData).GetSetCode("聘任职称","助理护士")
	i (($g(tmp("HireStDate"))'="")&&($l($g(tmp("HireStDate")),"-")=3)) s duty.HireStDate=$zdh(tmp("HireStDate"),3)
	S sc=duty.%Save()
	if $$$ISERR(sc){
		Tro
		q saveIndex
	}
	s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_per.%Id(),""))
	s TransFlag=""
	i per.PerDepDR'="" d
	.i transRowID="" d
	..s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_per.%Id()_"^"_per.PerDepDR_"^"_$zd(per.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	.e  d
	..s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
	..s aa.PerDr=per.%Id()
    ..s aa.PerDepart=per.PerDepDR
    ..s aa.PerTranStDate=per.PerDepDate
    ..s aa.PerTranCurrent="Y"
    ..s aa.PerTranStTime=$P($H,",",2)
    ..s aa.PerTransType="L"
    ..s sc=aa.%Save()
    ..i $$$ISOK(sc) s TransFlag=0
    if TransFlag'=0{
		Tro
		q saveIndex
	}
	//PerName|测试3^PerCardId|110101199003057896^PerID|CeShi3
	//^PerDepDR|产房^PerDepDate|2018-07-05^HireStDate|2018-07-05^saveIndex|0
	s TransFlag=0,TranDate=+$h
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s TranDate=$zdh(tmp("PerDepDate"),3)
	s plantimeId="" f  s plantimeId=$O(^DHCINM.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCINM.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
	..q:'$IsObject(subObj)
	..q:'$IsObject(subObj.PlanPerDR)
	..i subObj.PlanPerDR.%Id()=rowid d
	...s sc=subObj.%DeleteId(subid)
	...i $$$ISERR(sc) s TransFlag="1"
	if TransFlag=0{
		TC
		q saveIndex
	}else{
		TRO
		q saveIndex
	}
}

/// Creator:lulin
/// Description:导入实习生离职信息
/// Date:2018-07-18
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ImportResignData(parr As %String, role As %String, nurseid As %String) As %String
{
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	;s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	;s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U") //取得实习编号
	s rowid=$O(^CF.DHCINM.HR.PersonsI("Info"," P"," "_PerNo,""))
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	q:'$IsObject(perObj) saveIndex
	s rw=$O(^DHCINM.HR.MgNurseResignI("ssid",perObj.%Id(),""))
	q:rw'="" saveIndex
	s nowdate=+$h
	s obj=##class(DHCINM.HR.MgNurseResign).%New()
	s obj.ResignWard=perObj.PerDepDR
	s obj.ResignName=perObj
	s obj.ResignType="P"
	s ResignDate=$tr($g(tmp("ResignDate"))," ","")
	i ((ResignDate'="")&&($l(ResignDate,"-")=3)) s ResignDate=$zdh(ResignDate,3)
	e  s ResignDate=nowdate
	s obj.ResignDate=ResignDate
	i ($tr($g(tmp("ResignReason"))," ","")'="") s obj.ResignReason=($zcvt($tr($g(tmp("ResignReason"))," ",""),"U"))
	s obj.ResignCreater=nurseid
	s obj.CreateDate=nowdate
	s obj.UpdateUser=nurseid
	s obj.ResignUpdate=nowdate
	s obj.ResignStatus="Y"
	s obj.ResignReStatus="E"
	s obj.ResignWard=perObj.PerDepDR
	i ($tr($g(tmp("ResignOpinion"))," ","")'="") s obj.ResignReason=($zcvt($tr($g(tmp("ResignOpinion"))," ",""),"U"))
	s duty=""
	s typedate=0
	s typeid=0
	f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",perObj.%Id(),typeid)) q:typeid=""  d
	.s dutyobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	.i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	i duty'="" s obj.ResignDuty=duty
	s Academic=""
	s typedate1=0
	s typeid1=0
	f  s typeid1=$o(^CF.DHCINM.HR.EducateI("ssid",perObj.%Id(),typeid1)) q:typeid1=""  d
	.s Academicobj1=##class(CF.DHCINM.HR.Educate).%OpenId(typeid1)
	.i Academicobj1.EduStDate>typedate1 s Academic=Academicobj1.EduAcademic
	i Academic'="" s obj.ResignAcademic=Academic
	TS
	s sc=obj.%Save()
	i $$$ISERR(sc) {
		TRO
		q saveIndex	
	}
	s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","离职")
	s perObj.PerStateDate=obj.ResignDate
	s perObj.PerStatuReason=obj.ResignReason
	;s perObj.PerCategroy="27||2"
	s perObj.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届")
	s sc=perObj.%Save()
	i $$$ISERR(sc) {
		TRO
		q saveIndex	
	}
	;删除实习生轮转记录
	s TransFlag=0,TranDate=+$h
	i obj.ResignDate'="" s TranDate=obj.ResignDate
	s plantimeId="" f  s plantimeId=$O(^DHCINM.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCINM.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
	..q:'$IsObject(subObj)
	..q:'$IsObject(subObj.PlanPerDR)
	..i subObj.PlanPerDR.%Id()=obj.ResignName.%Id() d
	...s sc=subObj.%DeleteId(subid)
	...i $$$ISERR(sc) s TransFlag="1"
	if TransFlag=0{
		TC
		q saveIndex	
	}else{
		TRO
		q saveIndex	
	}
	q saveIndex
}

/// Description:获取离职原因
/// d ##class(web.INMInternComm).GetResignReason("离职原因")
ClassMethod GetResignReason(parr As %String) As %String
{
	w "["
	s Par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s n=0
	s code="" f  s code=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s n=n+1
	..i n=1 w """"_Obj.SubDesc_""""
	..e  w ","""_Obj.SubDesc_""""
	w "]"
	q ""
}

ClassMethod GetResignData(parr As %String, year As %String, type As %String) As %String
{
	q:year="" ""
	s tmp=""
	i (parr="离职原因") s ResignReStatus="E"
	e  s ResignReStatus="R"
	s Par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s code="" f  s code=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s tmp(Obj.SubDesc)=0
	s date="" f  s date=$O(^DHCINM.HR.MgNurseResignI("type"," "_type,date)) q:date=""  d
	.q:(date>0)&&(($p($zd(date,3),"-",1))'=($p(year,"-",1)))
	.s row="" f  s row=$O(^DHCINM.HR.MgNurseResignI("type"," "_type,date,row)) q:row=""  d
	..s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(row)
	..q:'$IsObject(obj)
	..q:obj.ResignReStatus'=ResignReStatus
	..q:obj.ResignStatus'="A"
	..s reasons=obj.ResignReason
	..i reasons["~"  s len=$l(reasons,"~")
	..e  i reasons["," s len=$l(reasons,",")
	..e  s len=1
	..f i=1:1:len d
	...i reasons["~" s itm=$p(reasons,"~",i)
	...e  i reasons["," s itm=$p(reasons,",",i)
	...e  s itm=reasons
	...q:itm=""
	...s desc=##class(web.INMPersonComm).GetCommCode(itm)
	...s tmp(desc)=tmp(desc)+1
	w "["
	s n=0
	s des="" f  s des=$O(tmp(des)) q:des=""  d
	.s n=n+1
	.i n=1 w "{""value"":"""_tmp(des)_""",""name"":"""_des_"""}"
	.e  w ",{""value"":"""_tmp(des)_""",""name"":"""_des_"""}"
	w "]"
	q ""
}

/// Creator:lulin
/// Description:获取带教老师
/// Date:2018-08-08
/// Table:8
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternTeacher","","",0)
Query FindInternTeacher(parr As %String = "", role As %String, nurseid As %String, wardId As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternTeacherExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String, wardId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindInternTeacher")=parr_"%"_role_"%"_nurseid_"%"_wardId //%%139%3
	s ret=""
	s tmpward=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s RowID="" f  s RowID=$O(^CF.DHCINM.HR.PersonsD(RowID)) q:RowID=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	.q:obj.PerTypeDR'="N"
	.q:(wardId'="")&&(obj.PerDepDR'=wardId)
	.s Wardnurse=obj.PerDepDR
	.;q:(isAll=0)&&((Wardnurse'="")&&('$d(tmpWard(Wardnurse))))
	.s PerName=obj.PerName
	.s NameSpell=##class(web.INMVueComm).ToChineseSpell(PerName)
	.q:((parr'="")&&((NameSpell_PerName)'[$zcvt($tr(parr," ",""),"U")))
	.s userid=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_RowID,""))
	.s roles=##class(web.INMLoginComm).GetRolesByLoginId(userid)
	.s roleId=$o(^CT.DHCINM.Set.MgRolesI("desc"," Y"," 带教老师",""))
	.q:roles'[roleId
	.s ret="PerName|"_PerName_"^rowid|"_RowID_"^spell|"_NameSpell
	.d OutputInternTeacher
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputInternTeacher
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternTeacherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternTeacherExecute ]
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

ClassMethod FindInternTeacherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternTeacherExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleDesc(id As %String) As %String
{
	q:id="" ""
	s desc=""
	s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(id)
	q:'$IsObject(obj) ""
	s desc=obj.RoleDesc
	q desc
}

/// Creator:lulin
/// Description:检测要导入的实习生数据是否正确，正确返回index，负责返回-1
/// Date:2018-08-17
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod CheckInternTranImport(parr As %String, parr1 As %String = "", index As %String = "") As %String
{
		q:(parr="")||(parr1="")||(index="") index
		s PlanDesc=$p(parr,"^")
		s PlanDesc=$p(PlanDesc,"|",2)
		i index=1 d
		.k ^NurMgIImportData
		.s ^NurMgIImportData("PlanDesc")=PlanDesc
		.;保存column日期
		.f i=1:1:$L(parr1,"^") d
		..s date=$p(parr1,"^",i)
		..s stdate=$zdh($p(date,","),3)
		..s endate=$zdh($p(date,",",2),3)
		..s endate1=stdate+((endate-stdate)\2)
		..s stdate2=endate1+1
		..s ^NurMgIImportData("time",stdate)=stdate_","_endate1
		..s ^NurMgIImportData("time",stdate2)=stdate2_","_endate
		;每次检验病区、人员编号是否正确。正确保存global，错误，清楚global返回。
		s GroupDesc=$P(parr,"^",2)
		s GroupDesc=$p(GroupDesc,"|",2)
		s sort=index
		s member=$p(parr,"^",3)
		s member=$p(member,"|",2)
		s ^NurMgIImportData("group",index)="GroupCode|"_GroupDesc_"^GroupDesc|"_GroupDesc_"^RowSort|"_index
		s ^NurMgIImportData("tableData",index)="PlanGroup|"_PlanDesc_"^GroupDesc|"_GroupDesc_"^GroupMember|"_member
		s groupMemberName="",groupMember=""
		f i=1:1:$l(member,"/") d
		.s tperNo=$zcvt($tr($p(member,"/",i)," ",""),"U")
		.q:tperNo=""
		.s perDR=$O(^CF.DHCINM.HR.PersonsI("PerNo"," "_tperNo,""))
		.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
		.i '$IsObject(perObj) d
		..s ^NurMgIImportData("error","实习编号",tperNo)=tperNo
		.e  d
		..i groupMemberName="" d
		...s ^NurMgIImportData("group",index)=^NurMgIImportData("group",index)_"^GroupMaster|"_perDR
		...s groupMember=perDR
		...s groupMemberName=perObj.PerName
		..e  d
		...s groupMember=groupMember_","_perDR
		...s groupMemberName=groupMemberName_","_perObj.PerName
		s ^NurMgIImportData("group",index)=^NurMgIImportData("group",index)_"^GroupMember|"_groupMember
		s ^NurMgIImportData("tableData",index)=^NurMgIImportData("tableData",index)_"^GroupMemberName|"_groupMemberName
		s firstPer="",nextPer=""
		f i=1:1:$l(groupMember,",") d
		.i i<3 d
		..i firstPer="" s firstPer=$p(groupMember,",",i)
		..e  s firstPer=firstPer_","_$p(groupMember,",",i)
		.e  d
		..i nextPer="" s nextPer=$p(groupMember,",",i)
		..e  s nextPer=nextPer_","_$p(groupMember,",",i)
		f i=1:1:$l(parr,"^") d
		.s data=$p(parr,"^",i)
		.s key=$p(data,"|")
		.q:key=""
		.q:(key="PlanDesc")||(key="PlanGroup")||(key="GroupMember")
		.s ^NurMgIImportData("tableData",index)=^NurMgIImportData("tableData",index)_"^"_$p(parr,"^",i)
		.s value=$P(data,"|",2)
		.s stdate=$zdh($p(key,","),3)
		.s endate=$zdh($p(key,",",2),3)
		.s endate1=stdate+((endate-stdate)\2)
		.s stdate2=endate1+1
		.s type=0
		.s type=value["*" 
		.s ward1=$zcvt($tr($P(value,"/")," ",""),"U") ;第一个病区
		.i type=1 d
		..s ward1=$e(ward1,2,$l(ward1))
		.s ward2=$zcvt($tr($P(value,"/",2)," ",""),"U") ;第二个病区可能为空
		.s wardDR1=$O(^CF.DHCINM.DB.MgWardI("Code"," "_ward1,""))
		.s wardDR2=""
		.s:ward2'="" wardDR2=$O(^CF.DHCINM.DB.MgWardI("Code"," "_$zcvt($tr(ward2," ",""),"U"),""))
		.i wardDR1="" d
		..s ^NurMgIImportData("error","病区",ward1)=ward1
		.i (ward2'="")&&(wardDR2="") d
		..s ^NurMgIImportData("error","病区",ward2)=ward2
		.q:(wardDR1="")||((ward2'="")&&(wardDR2=""))
		.i ward2="" d ;仅有一个病区，保存两个时间段所有人
		..s ^NurMgIImportData("data",index,stdate,wardDR1)=firstPer_","_nextPer
		..s ^NurMgIImportData("data",index,stdate2,wardDR1)=firstPer_","_nextPer
		.e  d
		..i type=1 d ;带*号，前两个同学前半段时间去第一个病区，后半段去第二个病区，后半段时间反过来
		...s ^NurMgIImportData("data",index,stdate,wardDR1)=firstPer
		...s ^NurMgIImportData("data",index,stdate,wardDR2)=nextPer
		...s ^NurMgIImportData("data",index,stdate2,wardDR1)=nextPer
		...s ^NurMgIImportData("data",index,stdate2,wardDR2)=firstPer
		..e  d ;不带*号，所有时间前两个同学去第一个病区，其他同学去第二个病区
		...s ^NurMgIImportData("data",index,stdate,wardDR1)=firstPer
		...s ^NurMgIImportData("data",index,stdate,wardDR2)=nextPer
		...s ^NurMgIImportData("data",index,stdate2,wardDR1)=firstPer
		...s ^NurMgIImportData("data",index,stdate2,wardDR2)=nextPer
		;写global存储
		q index
}

/// Creator:lulin
/// Description:导入轮转临时数据是否有错误，有返回错误信息
/// Date:2018-08-18
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.INMInternComm).IsInternTranImport()
ClassMethod IsInternTranImport() As %String
{
	q:'$d(^NurMgIImportData("error")) 1
	s ret=""
	s type="" f  s type=$O(^NurMgIImportData("error",type)) q:type=""  d
	.s tRet=""
	.s itm="" f  s itm=$O(^NurMgIImportData("error",type,itm)) q:itm=""  d
	..s value=^NurMgIImportData("error",type,itm)
	..i tRet="" s tRet=value
	..e  s tRet=tRet_","_value
	.i ret="" s ret=type_"未找到对应数据:"_tRet
	.e  s ret=ret_";"_type_"未找到对应数据:"_tRet
	q ret
}

/// Creator:lulin
/// Description:获取导入轮转临时数据
/// Date:2018-08-18
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternImportData","")
Query FindInternImportData(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternImportDataExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s index="" f  s index=$O(^NurMgIImportData("tableData",index)) q:index=""  d
	.s ret=^NurMgIImportData("tableData",index)
	.d OutputInternImportData
	K:$d(^NurMgIImportData("error")) ^NurMgIImportData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputInternImportData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternImportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternImportDataExecute ]
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

ClassMethod FindInternImportDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternImportDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:保存导入轮转临时数据
/// Date:2018-08-19
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.INMInternComm).SaveInternImport(0,0)
ClassMethod SaveInternImport(role As %String = "", nurseid As %String = "") As %String
{
	q:$d(^NurMgIImportData("error")) "存在错误数据,导入失败"
	q:'$d(^NurMgIImportData) "不存在可保存数据"
	q:(role="")||(nurseid="") "未获取登录人员信息,请刷新重试"
	s obj=##class(DHCINM.Intern.MgTransPlan).%New()
	s obj.PlanCrtDate=+$h
	s obj.PlanCrtTime=$P($h,",",2)
	s obj.PlanStatus="N"
	s obj.PlanEditDate=+$h
	s obj.PlanEditTime=$P($h,",",2)
	s nowDate=+$h,nowTime=$zt($p($h,",",2))
	s obj.PlanCode=$zd(nowDate,8)_$p(nowTime,":")_$p(nowTime,":",2)
	s obj.PlanDesc=$g(^NurMgIImportData("PlanDesc"))
	i $g(nurseid)'=0 d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
	.s obj.PlanCrtUser=perObj
	.s obj.PlanEditUser=perObj
	TS
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		Tro
		k ^NurMgIImportData
		q "保存转科失败"	
	}
	s tmpGroup=""
	s flag=1
	s sort="" f  s sort=$O(^NurMgIImportData("group",sort)) q:(sort="")||(flag=0)  d
	.s tTmpGroup=""
	.s tGroup=$g(^NurMgIImportData("group",sort))
	.d ##class(web.INMVueComm).SplitStr(tGroup,"^","|",.tTmpGroup)
	.s groupObj=##class(DHCINM.Intern.MgTransPlanGroup).%New()
	.s groupObj.PlanDR=obj
	.s groupObj.GroupCode=$g(tTmpGroup("GroupCode"))
	.s groupObj.GroupDesc=$g(tTmpGroup("GroupDesc"))
	.i $g(tTmpGroup("GroupMaster"))'="" d
	..s groupObj.GroupMaster=##Class(CF.DHCINM.HR.Persons).%OpenId(tTmpGroup("GroupMaster"))
	.f i=1:1:$L(tTmpGroup("GroupMember"),",") d
	..s perdr=$P(tTmpGroup("GroupMember"),",",i)
	..d groupObj.GroupMember.Insert(perdr)
	.s groupObj.RowSort=sort
	.s sc=groupObj.%Save()
	.i $$$ISERR(sc) s flag=0
	.q:flag=0
	.s tmpGroup(sort)=groupObj
	i flag=0 {
		TRO
		k ^NurMgIImportData
		q "保存组成员失败"	
	}
	s tmpTime=""
	s date="" f  s date=$O(^NurMgIImportData("time",date)) q:(date="")||(flag=0)  d
	.s timeObj=##class(DHCINM.Intern.MgTransPlanTime).%New()
	.s time=$g(^NurMgIImportData("time",date))
	.s stTime=$p(time,",")
	.s endTime=$p(time,",",2)
	.s timeObj.PlanDR=obj
	.s timeObj.PlanStDate=stTime
	.s timeObj.PlanEndDate=endTime
	.s sc=timeObj.%Save()
	.i $$$ISERR(sc) s flag=0
	.q:flag=0
	.s tmpTime(date)=timeObj
	i flag=0{
		TRO
		k ^NurMgIImportData
		q "保存时间失败"	
	}
	s group="" f  s group=$O(^NurMgIImportData("data",group)) q:(group="")||(flag=0)  d
	.s groupObj=tmpGroup(group)
	.s date="" f  s date=$O(^NurMgIImportData("data",group,date)) q:(date="")||(flag=0)  d
	..s dateObj=tmpTime(date)
	..s wardDR="" f  s wardDR=$O(^NurMgIImportData("data",group,date,wardDR)) q:(wardDR="")||(flag=0)  d
	...s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardDR)
	...s perDRs=$g(^NurMgIImportData("data",group,date,wardDR))
	...q:perDRs=""
	...f i=1:1:$l(perDRs,",") q:flag=0  d
	....s perDR=$p(perDRs,",",i)
	....q:perDR=""
	....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
	....q:'$IsObject(perObj)
	....s subObj=##class(DHCINM.Intern.MgTransPlanSub).%New()
	....s subObj.PlanDR=obj
	....s subObj.PlanGroupDR=groupObj
	....s subObj.PlanTimeDR=dateObj
	....s subObj.PlanWardDR=wardObj
	....s subObj.PlanPerDR=perObj
	....s sc=subObj.%Save()
	....i $$$ISERR(sc) s flag=0
	i flag=0 {
		TRO
		k ^NurMgIImportData
		q "保存轮转明细失败"	
	}
	k ^NurMgIImportData
	TC
	q 1
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取实习生数据
/// Table：CF.DHCINM.HR.Persons
/// Input：
/// Return： 
ClassMethod GetInternData(id As %String) As %String
{
	s ret=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj) ""
	s internrowid=$o(^DHCINM.Intern.MgInternI("ssid",id,""))
	if internrowid'=""
	{
		s ret=..GetValue(internrowid)_"^isPerson|0"
	}
	else
	{
		s PerName=obj.PerName
		s PerSexDR=obj.PerSexDR
		i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
		e  s PerBirthday=""
		s PerNo=""
		s PerType=""
		s PerCardId=obj.PerCardId
		s PerNativePlace=obj.PerNativePlace
		s PerDepDR=obj.PerDepDR
		i obj.PerDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerDepDate)
		e  s PerDepDate=""
		i obj.PerComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
		e  s PerComeDate=""
		s PerPolitical=obj.PerPolitical
		s PerMarriage=obj.PerMarriage
		s PerPic=obj.PerPic
		s PerAddress=obj.PerAddress
		s PerContact=obj.PerContact
		s PerContact=obj.PerContact
		s PerPhone=obj.PerPhone
		s PerHeight=obj.PerHeight
		s PerWeight=obj.PerWeight
		s PerHobby=obj.PerHobby
		s PerEspecially=obj.PerEspecially
		s PerContactPhone=obj.PerContactPhone
		s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerBirthday|"_PerBirthday_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId_"^PerNativePlace|"_PerNativePlace_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerPic|"_PerPic_"^PerAddress|"_PerAddress_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^RowID|"_id_"^isPerson|1"
		s ret=ret_"^PerNation|"_obj.PerNation_"^PerType|"_PerType_"^PerHeight|"_PerHeight_"^PerWeight|"_PerWeight_"^PerEspecially|"_PerEspecially
		s ret=ret_"^PerInternSchool|"_obj.PerInternSchool_"^PerContactPhone|"_PerContactPhone
	}
	q ret
}

/// Description:获取退休原因
/// d ##class(web.INMInternComm).GetRetireReason("退休原因")
ClassMethod GetRetireReason(parr As %String) As %String
{
	w "["
	s Par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s n=0
	s code="" f  s code=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s n=n+1
	..i n=1 w """"_Obj.SubDesc_""""
	..e  w ","""_Obj.SubDesc_""""
	w "]"
	q ""
}

/// Creator: gyg
/// CreatDate: 2019-09-06
/// Description: 审核退休
/// Table：DHCINM.HR.MgNurseResign
/// Input：d ##class(web.INMInternComm).CheckRetireRec(5,"","Y","")
/// Return：
ClassMethod CheckRetireRec(parr As %String) As %String
{
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s obj=##class(DHCINM.HR.MgNurseResign).%New()
	
	q:'$IsObject(obj) ""
	s obj.ResignStatus=$g(tmp("ResignStatus"))
	d obj.ResignNameSetObjectId($g(tmp("ResignName")))
	s obj.ResignDate=$zdh($g(tmp("ResignDate")),3)
	s obj.ResignReason=$g(tmp("ResignReason"))
	s obj.ResignWard=$g(tmp("ResignWard"))
	s obj.ResignCreater=$g(tmp("ResignCreater"))
	s obj.ResignStatus="A"
	s obj.ResignType="N"
	s obj.ResignReStatus="R" ///区分离职退休状态
	s sc1=obj.%Save()
	s:$$$ISERR(sc1) flag=0
	s flag=$$$ISOK(sc1)
	i flag=0 {
		TRO
		d $System.Status.DisplayError(sc1)
		q flag
	}
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(obj.ResignName.%Id())
	s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","退休")
	s perObj.PerStateDate=obj.ResignDate
	s perObj.PerStatuReason=obj.ResignReason
	i perObj.PerTypeDR="P" s perObj.PerCategroy=##class(web.INMImportDBData).GetSetCode("实习生类别","往届")
	s sc=perObj.%Save()
	s:$$$ISERR(sc) flag=0
	s flag=$$$ISOK(sc)
	i flag=0 {
		TRO
		q flag
	}
	else{
		tc
		q flag
	}
}

/// d ##class(web.INMInternComm).GetResignData("退休原因","2019-01-01","N")
ClassMethod GetRetireData(parr As %String, year As %String, type As %String) As %String
{
	q:year="" ""
	s tmp=""
	i (parr="离职原因") s ResignReStatus="E"
	e  s ResignReStatus="R"
	s Par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s code="" f  s code=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s tmp(Obj.SubDesc)=0
	s date="" f  s date=$O(^DHCINM.HR.MgNurseResignI("type"," "_type,date)) q:date=""  d
	.q:(($p($zd(date,3),"-",1))'=($p(year,"-",1)))
	.s row="" f  s row=$O(^DHCINM.HR.MgNurseResignI("type"," "_type,date,row)) q:row=""  d
	..s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(row)
	..q:obj.ResignReStatus'=ResignReStatus
	..s reasons=obj.ResignReason
	..s len=$l(reasons,"~")
	..f i=1:1:len d
	...s itm=$p(reasons,"~",i)
	...q:itm=""
	...s desc=##class(web.INMPersonComm).GetCommCode(itm)
	...;s tmp(desc)=""
	...s tmp(desc)=tmp(desc)+1
	w "["
	s n=0
	s des="" f  s des=$O(tmp(des)) q:des=""  d
	.s n=n+1
	.i n=1 w "{""value"":"""_tmp(des)_""",""name"":"""_des_"""}"
	.e  w ",{""value"":"""_tmp(des)_""",""name"":"""_des_"""}"
	w "]"
	q ""
}

/// Creator:gyg
/// Description:查询退休信息
/// Date:2019-09-06
/// Table:DHCINM.HR.MgNurseResign
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindRetireLists","")
Query FindRetireLists(parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRetireListsExecute(ByRef qHandle As %Binary, parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s nurseno=$p(parr,"^",1)
	s nurseward=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",4)
	i enddate'="" s enddate=$zdh(enddate,3)
	s status=$p(parr,"^",5)
	s tmpWard=""
	s isAll=0
	
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgNurseResignI("type"," "_nursetype,date),-1) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCINM.HR.MgNurseResignI("type"," "_nursetype,date,rowid)) q:rowid=""  d
	
	..s obj=##class(DHCINM.HR.MgNurseResign).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(isAll=0)&&((obj.ResignWard="")||('$d(tmpWard(obj.ResignWard))))||(obj.ResignReStatus'="R")
	..s PerObj=obj.ResignName
	..s resignStatu=obj.ResignStatus
	..i obj.ResignStatus="N" s resignStatuDesc="未提交"
	..e  i obj.ResignStatus="Y" s resignStatuDesc="提交"
	..e  i obj.ResignStatus="A" s resignStatuDesc="已审核"
	..e  i obj.ResignStatus="B" s resignStatuDesc="驳回"
	..e  s resignStatuDesc=""
	..s internNo="",nurseID="",nurseinfo=""
	..i nursetype="P" s internNo=PerObj.PerNo,nurseinfo=PerObj.PerNo_PerObj.PerName
	..e  i nursetype="N" s nurseID=PerObj.PerID,nurseinfo=PerObj.PerID_PerObj.PerName
	..e  s internNo=PerObj.PerNo,nurseinfo=PerObj.PerNo_PerObj.PerName
	..q:((nursetype="N")&&((nurseno'="")&&(nurseinfo'[nurseno)))
	..q:(((nursetype="T")!(nursetype="A"))&&(nurseinfo'[nurseno))
	..q:((nurseward'="")&&(obj.ResignWard'=nurseward))
	..q:((stdate'="")&&(obj.ResignDate'="")&&(obj.ResignDate<stdate))
	..q:((enddate'="")&&(obj.ResignDate'="")&&(obj.ResignDate>enddate))
	..q:((status'="")&&(obj.ResignStatus'=status))
	..s resignName=PerObj.PerName
	..i obj.ResignWard'="" d
	...s WardStr=##class(web.INMDBComm).GetWard(obj.ResignWard)
	...s resignWard=$p($p(WardStr,"^",3),"|",2)
	..e  s resignWard=""
	..i obj.ResignDate'="" s resignDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ResignDate)
	..e  s resignDate=""
	..i nursetype="P" s resignReason=obj.ResignReason
	..e  i nursetype="N" s resignReason=..GetReason(obj.ResignReason)
	..e  s resignReason=""
	..s creater=""
	..i obj.ResignCreater'="" d
	...i obj.ResignCreater=0 s creater="管理员"
	...e  d
	....s userObj=$g(^CF.DHCINM.DB.MgUserD(obj.ResignCreater))
	....q:userObj=""
	....s creater=$lg(userObj,2)
	..i obj.CreateDate'="" s createDate=##class(web.INMHISComm).DateLogicalToHtml(obj.CreateDate)
	..e  s createDate=""
	..s updateUser=""
	..i obj.UpdateUser=0 d
	...s updateUser="管理员"
	..e  d
	...s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(obj.UpdateUser)
	...q:'$IsObject(perobj)
	...s updateUser=perobj.PerName
	..i obj.ResignUpdate'="" s resignUpdate=##class(web.INMHISComm).DateLogicalToHtml(obj.ResignUpdate)
	..e  s resignUpdate=""
	..s ret="resignStatu|"_resignStatu_"^resignStatuDesc|"_resignStatuDesc_"^resignNo|"_internNo_"^nurseID|"_nurseID_"^resignName|"_resignName_"^resignWard|"_resignWard_"^resignDate|"_resignDate_"^resignReason|"_resignReason_"^creater|"_creater_"^createDate|"_createDate_"^updateUser|"_updateUser_"^resignUpdate|"_resignUpdate_"^rowid|"_rowid
	..do OutputResignData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputResignData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRetireListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRetireListsExecute ]
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

ClassMethod FindRetireListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRetireListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetErrorInfor()
{
	q:'$d(^TMP("INMImportDBData")) 1
	s error=""
	s id=""  f  s id=$o(^TMP("INMImportDBData",id)) q:id=""  d
	.s name=""  f  s name=$o(^TMP("INMImportDBData",id,name)) q:name=""  d
	..s:error'="" error=error_","_name
	..s:error="" error=name
	.s error=error_$case(id,"1":"身份证不能为空","2":"实习生编号不能为空","3":"实习生编号已存在","4":"姓名不能为空","5":"进科日期不能为空","6":"来院日期不能为空","7":"实习生类别不能为空","8":"实习开始日期不能为空","9":"实习结束日期不能为空","10":"病区不能为空","11":"所在病区不存在")	
	q error
}

/// Date:20200805
/// Description:检查实习生今天所在时段之后是否有排班
ClassMethod CheckInternArg(parr) As %String
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s plan=$g(tmp("PlanDR"))
	s member=$g(tmp("GroupMember"))_","_$g(tmp("GroupMaster"))
	s grp=$g(tmp("rw"))
	s:grp'="" grpmember=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),6)_","_$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),5)
	s end=""
	s pers=""
	s subid=""
	s time="" f  s time=$o(^DHCINM.Intern.MgTransPlanTimeI("Plan",plan,time)) q:(time="")||(end'="")  d
	.s timeObj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(time)
	.s stdate=timeObj.PlanStDate
	.s enddate=timeObj.PlanEndDate
	.s:(stdate<=+$h)&&(enddate<=+$h) end=timeObj.PlanEndDate
	q:end="" 0
	s ret="",ret1=""
	f j=1:1:$l(grpmember,",") d
	.s itm=$p(grpmember,",",j)
	.s k=0
	.f i=1:1:$l(member,",")  d
	..s id=$p(member,"^",i)
	..s:itm'=id k=k+1
	.i k=$l(member,",") d
	..s:pers'="" pers=pers_","_itm
	..s:pers="" pers=itm
	..s stdate=end-1 f  s stdate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",itm,stdate)) q:stdate=""  d
	...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(itm)
	...q:'$IsObject(obj)
	...i ret'="" s ret=ret_","_obj.PerName
	...e  s ret=obj.PerName
	..i ret=""  d
	...s time1=$o(^DHCINM.Intern.MgTransPlanTimeI("Plan",plan,time))
	...s subid=$o(^DHCINM.Intern.MgTransPlanSubI("PerTime",plan,grp,time1," "_itm,subid))
	...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(itm)
	...q:'$IsObject(obj)
	...i ret1'="" s ret1=ret1_","_obj.PerName
	...e  s ret1=obj.PerName
	q:ret'="" ret_"在"_$zd(end,3)_"日期之后有排班，#"_$zd(end,3)_"#"_pers_"#"_time
	q:ret1'="" ret1_"在"_$zd(end,3)_"日期之后有轮转计划，#"_$zd(end,3)_"#"_pers_"#"_time
	q 0
}

/// 删除某人的轮转计划
/// d ##class(web.INMInternComm).DeletePlanSubByPer("GroupMaster|23^GroupName|张四组^GroupMember|5^rw|1^PlanDR|1")
ClassMethod DeletePlanSubByPer(parr)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s grp=$g(tmp("rw"))
	s plan=$g(tmp("PlanDR"))
	s member=$g(tmp("GroupMember"))_","_$g(tmp("GroupMaster"))
	s grpmember=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),6)_","_$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),5)
	f j=1:1:$l(grpmember,",") d
	.s itm=$p(grpmember,",",j)
	.s k=0
	.f i=1:1:$l(member,",")  d
	..s id=$p(member,",",i)
	..s:itm'=id k=k+1
	.i k=$l(member,",") d
	..s subid="" f  s subid=$o(^DHCINM.Intern.MgTransPlanSubI("PlanPerson",plan," "_itm,subid)) q:subid=""  d
	...d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
}

/// 删除某人某天之后的排班和轮转计划
ClassMethod DeleteArgAfterDate(parr)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s pers=$g(tmp("Per"))
	s date=$g(tmp("date"))
	s time=$g(tmp("time"))
	s group=$g(tmp("group"))
	s plan=$g(tmp("PlanDR"))
	f i=1:1:$l(pers,",")  d
	.s id=$p(pers,",",i)
	.s stdate=date-1 f  s stdate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",id,stdate)) q:stdate=""  d
	..s argsubid="" f  s argsubid=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",id,stdate,argsubid)) q:argsubid=""  d
	...d ##class(DHCINM.Arg.MgArrangeSub).%DeleteId(argsubid)
	.s subid="" f  s subid=$o(^DHCINM.Intern.MgTransPlanSubI("PerTime",plan,group,time," "_id,subid)) q:subid=""  d
	..d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
}

/// 组内成员是否已经分到其他组组/包含组长
/// w ##class(web.INMInternComm).IsInOtherGroup("GroupMaster|23^GroupName|张四组^GroupMember|24,5,13,14^rw|1^PlanDR|1")
ClassMethod IsInOtherGroup(parr)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s plan=$g(tmp("PlanDR"))
	s member=$g(tmp("GroupMember"))_","_$g(tmp("GroupMaster"))
	s grpid=$g(tmp("rw"))
	s flag=0
	;s:(","_$g(tmp("GroupMember"))_",")[(","_$g(tmp("GroupMaster"))_",") flag=$lg(^CF.DHCINM.HR.PersonsD($g(tmp("GroupMaster"))),2)
	;q:flag'=0 -1
	f i=1:1:$l(member,",") d
	.s intern=$p(member,",",i)
	.s grp="" f  s grp=$o(^DHCINM.Intern.MgTransPlanGroupI("Plan",plan,grp)) q:((grp="")||(flag'=0))  d
	..s member1=$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),6)_","_$lg(^DHCINM.Intern.MgTransPlanGroupD(grp),5)
	..s:((","_member1_",")[(","_intern_","))&&((grp'=grpid)) flag=$lg(^CF.DHCINM.HR.PersonsD(intern),2),i=$l(member,",")+1
	q flag
}

/// Creator:wangcc
/// Description:通过病区和时段查询轮转人员
/// Date:2019-09-06
/// Table:DHCINM.HR.MgNurseResign
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternByWardTime",2,1)
Query FindInternByWardTime(ward As %String = "", time As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternByWardTimeExecute(ByRef qHandle As %Binary, ward As %String = "", time As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s timeobj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(time)
	q:'$IsObject(timeobj)
	s stdate=timeobj.PlanStDate
	s enddate=timeobj.PlanEndDate
	;输出和time时间段有交叉的且轮转病区为ward的已发布的轮转计划小组
	s grp="" f  s grp=$o(^DHCINM.Intern.MgTransPlanSubI("WardGroup",ward,grp)) q:grp=""  d
	.s subid=$o(^DHCINM.Intern.MgTransPlanSubI("WardGroup",ward,grp,""))
	.s subobj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
	.q:'$IsObject(subobj)
	.s stdate1=subobj.PlanTimeDR.PlanStDate
	.s enddate1=subobj.PlanTimeDR.PlanEndDate
	.q:(enddate1<stdate)||(stdate1>enddate)
	.q:subobj.PlanDR.PlanStatus'="S"
	.s plan=subobj.PlanDR.PlanDesc
	.s grpname=subobj.PlanGroupDR.GroupDesc
	.s num=0
	.s subid1="" f  s subid1=$o(^DHCINM.Intern.MgTransPlanSubI("WardGroup",ward,grp,subid1)) q:subid1=""  d
	..s num=num+1
	.s ret="Plan|"_plan_"^Group|"_grpname_"^Num|"_num_"^StDate|"_$zd(stdate1,3)_"^EndDate|"_$zd(enddate1,3)
	.do OutputPlanSubData
	s adjust="" f  s adjust=$o(^DHCINM.Intern.MgInternAdjustI("ward"," "_ward,adjust)) q:adjust=""  d
	.s adjustObj=##class(DHCINM.Intern.MgInternAdjust).%OpenId(adjust)
	.q:'$IsObject(adjustObj)
	.q:(adjustObj.AdjustEndDate<stdate)||(adjustObj.AdjustStDate>enddate)
	.s plan=adjustObj.AdjustDesc
	.s member=""
	.f i=1:1:$l(adjustObj.AdjustIntern,",") d
	..s intern=$p(adjustObj.AdjustIntern,",",i)
	..s internObj=##class(CF.DHCINM.HR.Persons).%OpenId(intern)
	..s:member'="" member=member_","_internObj.PerName
	..s:member="" member=internObj.PerName
	.s ret="Plan|"_plan_"^Group|"_member_"^Num|"_$l(adjustObj.AdjustIntern,",")_"^StDate|"_$zd(adjustObj.AdjustStDate,3)_"^EndDate|"_$zd(adjustObj.AdjustEndDate,3)
	.do OutputPlanSubData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPlanSubData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternByWardTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternByWardTimeExecute ]
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

ClassMethod FindInternByWardTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternByWardTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: wangcc
/// createdate: 20200805
/// description: 查看人员调整详情
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
/// other: 
ClassMethod GetAdjustData(id)
{
	s adjustObj=##class(DHCINM.Intern.MgInternAdjust).%OpenId(id)
	q:'$IsObject(adjustObj)
	s planName=adjustObj.AdjustDesc
	s planType=$case(adjustObj.AdjustType,"P":"暂停","E":"终止","H":"支援","Z":"转正","L":"延长")
	s status=$case(adjustObj.AdjustStatus,"N":"已保存","Y":"已提交")
	s ctrDate=$zd(adjustObj.AdjustCrtDate,3)
	s:adjustObj.AdjustCrtUser'=0 ctrPer=$lg(^CF.DHCINM.DB.MgUserD(adjustObj.AdjustCrtUser),2)
	s:adjustObj.AdjustCrtUser=0 ctrPer="管理员"
	s:adjustObj.AdjustIntern="" internNum=0
	s:adjustObj.AdjustIntern'="" internNum=$l(adjustObj.AdjustIntern,",")
	s enddate="",stdate="",regDate="",hiredate="",ResignDate=""
	s:adjustObj.AdjustStDate'="" stdate=$zd(adjustObj.AdjustStDate,3)
	s:adjustObj.AdjustEndDate'="" enddate=$zd(adjustObj.AdjustEndDate,3)
	s:adjustObj.PerDepDate'="" regDate=$zd(adjustObj.PerDepDate,3)
	s days=adjustObj.Days
	s ward=adjustObj.AdjustWard
	s remark=adjustObj.Remark
	s member=adjustObj.AdjustIntern
	s:adjustObj.AdjustHireStDate'="" hiredate=$zd(adjustObj.AdjustHireStDate,3)
	s:adjustObj.AdjustResignDate'="" ResignDate=$zd(adjustObj.AdjustResignDate,3) 
	s ret="PlanName|"_planName_"^PlanType|"_planType_"^PlanStatus|"_status_"^CreateDate|"_ctrDate_"^CreateUserName|"_ctrPer_"^Ward|"_ward
	s ret=ret_"^Days|"_days_"^PerDepDate|"_regDate_"^Remark|"_remark_"^RowID|"_id_"^PlanNum|"_internNum_"^StDate|"_stdate_"^EndDate|"_enddate
	s ret=ret_"^PerDepDR|"_adjustObj.AdjustDep_"^HireDuty|"_adjustObj.AdjustHireDuty_"^HireStDate|"_hiredate_"^ResignDate|"_ResignDate
	s ret=ret_"^Member|"_member_"^Type|"_adjustObj.AdjustType_"^CreateUser|"_adjustObj.AdjustCrtUser
	q ret
}

/// creator: wangcc
/// createdate: 20200805
/// description: 获取实习生人员调整列表
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindInternAjustList","2020-08-01^2020-08-31^^^L")
Query FindInternAjustList(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternAjustListExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s ^TMP("FindInternAjustList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s status=$p(parr,"^",3)
	s name=$p(parr,"^",4)
	s type=$p(parr,"^",5)
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb,hlbzr,manager,admin",+$H)
	s id="" f  s id=$O(^DHCINM.Intern.MgInternAdjustD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgInternAdjust).%OpenId(id)
	.q:'$IsObject(obj)
	.q:((isHLB'=1)&&(obj.AdjustCrtUser'=loginID))
	.q:((stdate'="")&&(stdate>obj.AdjustCrtDate))
	.q:((enddate'="")&&(enddate<obj.AdjustCrtDate))
	.q:(status'="")&&(obj.AdjustStatus'=status)
	.q:(name'="")&&(obj.AdjustDesc'[name)
	.q:(type'="")&&(obj.AdjustType'=type)
	.s ret=..GetAdjustData(id)
	.d OutAjustPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAjustPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternAjustListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternAjustListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInternAjustListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternAjustListExecute ]
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

/// creator: wangcc
/// createdate: 20200805
/// description: 保存人员调整
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
/// w ##class(web.INMInternComm).SaveAdjust("PlanName|支援CT中心^Type|H^StDate|2020-08-31^EndDate|2020-09-30^PerDepDate|^HireStDate|^ResignDate|^PerDepDR|^Ward|1^HireDuty|^Days|^CreateUser|0^CreateDate|2020-08-22^Remark|^RowID|1^PlanStatus|已保存^PlanIntern|44,46^Status|Y") 
ClassMethod SaveAdjust(parr, nurseid)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s error=""
	ts
	s obj=##class(DHCINM.Intern.MgInternAdjust).%New()
	s:$g(tmp("RowID"))'="" obj=##class(DHCINM.Intern.MgInternAdjust).%OpenId(tmp("RowID"))
	s type=tmp("Type")
	s obj.AdjustCrtUser=$g(tmp("CreateUser"))
	s obj.AdjustCrtDate=$zdh(tmp("CreateDate"),3)
	s obj.AdjustDesc=$g(tmp("PlanName"))
	s:("PH"[type)&&($g(tmp("StDate"))'="") obj.AdjustStDate=$zdh(tmp("StDate"),3)
	s:("PH"[type)&&($g(tmp("EndDate"))'="") obj.AdjustEndDate=$zdh(tmp("EndDate"),3)
	s:(type="Z")&&($g(tmp("PerDepDate"))'="") obj.PerDepDate=$zdh(tmp("PerDepDate"),3)
	s:(type="L")&&($g(tmp("Days"))'="") obj.Days=tmp("Days")
	s obj.Remark=$g(tmp("Remark"))
	s obj.AdjustType=type
	s obj.AdjustStatus=tmp("Status")
	s obj.AdjustIntern=$g(tmp("PlanIntern"))
	s:(type="Z") obj.AdjustDep=$g(tmp("PerDepDR"))
	s:(type="H") obj.AdjustWard=tmp("Ward")
	s:(type="Z") obj.AdjustHireDuty=$tr(tmp("HireDuty"),"__","||")
	s:(type="Z") obj.AdjustHireStDate=$zdh(tmp("HireStDate"),3)
	s:(type="E") obj.AdjustResignDate=$zdh(tmp("ResignDate"),3)
	s sc=obj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "保存失败"
	}
	/// 提交人员调整记录操作
	if (tmp("Status")="Y")
	{
		f i=1:1:$l(tmp("PlanIntern"),",")
		{
			s member=$p(tmp("PlanIntern"),",",i)
			if ((type="P")||(type="H"))
			{
				///将支援/暂停时段内的调配（轮转）记录作废
				s sc2=##class(web.INMPersonComm).SaveRotationDepInTrans(obj.AdjustStDate,obj.AdjustEndDate,member)
				if ('$$$ISOK(sc2))
				{
					tro
					s i=$l(tmp("PlanIntern"),",")+1
					s error="保存失败"
				}
				/// 延长相应的暂停时长
				if (type="P")
				{
					s StopDays=obj.AdjustEndDate-obj.AdjustStDate
					s perObj2=##class(CF.DHCINM.HR.Persons).%OpenId(member)
					q:'$IsObject(perObj2)
					s perObj2.PerInternEndDate=perObj2.PerInternEndDate+StopDays
					s sc1=perObj2.%Save()
					i '$$$ISOK(sc1)
					{
						tro
						s i=$l(tmp("PlanIntern"),",")+1
						s error="保存失败"
					}
					/// 插入一条以暂停结束日期为调配开始日期的记录
					s inward=##class(web.INMHRComm).GetCurrentWard(member,obj.AdjustEndDate)
					s parr2="TransStDate|"_$zd(obj.AdjustEndDate,3)_"^TransEndDate|^NurseId|"_member_"^InWard|"_inward
					s sc7=##class(web.INMPersonComm).SaveTransDep(parr2,"","","","")
					i sc7'=1
					{
						tro
						s i=$l(tmp("PlanIntern"),",")+1
						s error="保存失败"
					}
				}
				/// 生成支援对应的调科记录
				if (type="H")
				{
					s parr1="TransStDate|"_$zd(obj.AdjustStDate,3)_"^TransEndDate|"_$zd(obj.AdjustEndDate,3)_"^NurseId|"_member_"^InWard|"_obj.AdjustWard
					s sc6=##class(web.INMPersonComm).SaveTransDep(parr1,"","","Adj","")
					i sc6'=1
					{
						tro
						s i=$l(tmp("PlanIntern"),",")+1
						s error="保存失败"
					}
				}
				///把支援或暂停的人从所在分组移除（但还在原批次）
				;s subid=$o(^DHCINM.Intern.MgTransPlanSubI("ssid"," "_member,""),-1)
				;q:subid=""
				;s subobj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
				;q:'$IsObject(subobj)
				;i ((subobj.PlanDR'="")&&(subobj.PlanGroupDR'=""))
				;{
				;	s groupobj=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(subobj.PlanGroupDR.%Id())
				;	s members=""
				;	i groupobj.GroupMaster=member  s groupobj.GroupMaster=""
				;	e  d
				;	.s groupmember=groupobj.GroupMember
				;	.f i=1:1:$l(groupmember,",")  d
				;	..s intern=$p(groupmember,",",i)
				;	..i intern'=member d
				;	...s:members'="" members=members_","_intern
				;	...s:members="" members=intern
				;	.s groupobj.GroupMember=members
				;	s sc3=groupobj.%Save()
				;	i '$$$ISOK(sc3)
				;	{
				;		tro
				;		s i=$l(tmp("PlanIntern"),",")+1
				;		s error="保存失败"
				;	}
				;}
				//删除暂停/支援时段之间的轮转计划和排班
				d ..DeleteArgAndPlan(member,obj.AdjustStDate,obj.AdjustEndDate)
			}
			if (type="E")
			{
				s sc4=..SaveInternResign(member,obj.AdjustResignDate,obj.Remark,nurseid)
				if (sc4=0)
				{
					tro
					s i=$l(tmp("PlanIntern"),",")+1
					s error="保存失败"
				}
			}
			if (type="L")
			{
				s perObj1=##class(CF.DHCINM.HR.Persons).%OpenId(member)
				q:'$IsObject(perObj1)
				s perObj1.PerInternEndDate=perObj1.PerInternEndDate+$g(tmp("Days"))
				s sc5=perObj1.%Save()
				i '$$$ISOK(sc5)
				{
					tro
					s i=$l(tmp("PlanIntern"),",")+1
					s error="保存失败"
				}
			}
			if (type="Z")
			{
				s isRegular=$o(^DHCINM.Intern.MgInternI("ssid",member,""))
				i isRegular'="" 
				{
					s error="已转正，不能再次转正！"
					s i=$l(tmp("PlanIntern"),",")+1
				}
				else
				{
					s parr1="perrowid|"_member_"^RowID|^RecUser|"_obj.AdjustCrtUser_"^PerDepDR|"_obj.AdjustDep
					s parr1=parr1_"^PerDepDate|"_obj.PerDepDate_"^HireDuty|"_obj.AdjustHireDuty_"^HireStDate|"_obj.AdjustHireStDate
					s error=..SetInternRegular(parr1)
					i error'=""
					{
						tro
						s i=$l(tmp("PlanIntern"),",")+1
					}
					else
					{
						d ..DeleteArgAndPlan(member,obj.PerDepDate,"999999")
					}
				}
			}
		}
	}
	q:error'="" error
	tc
	q ""
}

/// creator: wangcc
/// createdate: 20201111
/// desciption: 实习生在轮转计划时段开始日期之后是否有排班
/// table: DHCINM.Intern.MgTransPlanSub
/// input: 
/// output:
/// return:
/// other: w ##class(web.INMInternComm).IsHasArg("Ward|2^Member|24,5,13,25,25^TimeDr|1^PlanGroupDR|1@Ward|4^Member|24,5,13,25,25^TimeDr|3^PlanGroupDR|1",1)
ClassMethod IsHasArg(parr As %String) As %String
{
	s ret=""
	f i=1:1:$l(parr,"@")  d
	.s parritm=$p(parr,"@",i)
	.s tmp=""
	.s hasargTmp=""
	.d ##class(web.INMVueComm).SplitStr(parritm,"^","|",.tmp)
	.q:$g(tmp("TimeDr"))=""
	.q:$g(tmp("Ward"))=""
	.q:$g(tmp("Member"))=""
	.f j=1:1:$l(tmp("Member"),",") d
	..s perdr=$p(tmp("Member"),",",j)
	..s timeObj=##class(DHCINM.Intern.MgTransPlanTime).%OpenId(tmp("TimeDr"))
	..s stdate=timeObj.PlanStDate
	..s enddate=timeObj.PlanEndDate
	..s ward=$g(tmp("Ward"))
	..s flag=0
	..s date=stdate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date)) q:(date="")||(date>enddate)||(flag=1)  d
	...s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,rw)) q:(rw="")||(flag=1)  d
	....s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	....q:'$IsObject(obj)
	....q:obj.ArgWardDR.%Id()=ward
	....s flag=1
	..i (flag=1) d
	...s perName=$lg(^CF.DHCINM.HR.PersonsD(perdr),2)
	...s times=$zd(stdate,3)_"至"_$zd(enddate,3)
	...i ($g(hasargTmp(times))="") s hasargTmp(times)=perName
	...e  s hasargTmp(times)=hasargTmp(times)_","_perName
	i $d(hasargTmp) d
	.s d="" f  s d=$o(hasargTmp(d)) q:d=""  d
	..i ret="" s ret=hasargTmp(d)_"在"_d
	..e  s ret=ret_","_hasargTmp(d)_"在"_d
	q ret
}

/// creator: wangcc
/// createdate: 20200805
/// description: 判断成员是否在某日期所在时段内有排班或轮转计划
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
/// w ##class(web.INMInternComm).HasArgAndPlan("44,46","2020-08-31","2020-09-10")
ClassMethod HasArgAndPlan(PlanIntern, StDate, EndDate)
{
	s ret="",ret1="",infor=""
	s:StDate'="" stdate=$zdh(StDate,3)
	s:EndDate="" enddate=999999
	s:EndDate'="" enddate=$zdh(EndDate,3)
	f i=1:1:$l(PlanIntern,",")
	{
		s member=$p(PlanIntern,",",i)
		s subid="" 
		s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(member)
		q:'$IsObject(perObj)
		f
		{
			s flag=0
			s subid=$o(^DHCINM.Intern.MgTransPlanSubI("ssid"," "_member,subid))
			q:(subid="")||(flag=1)
			s subobj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
			q:'$IsObject(subobj)
			s stDate=subobj.PlanTimeDR.PlanStDate
			s endDate=subobj.PlanTimeDR.PlanEndDate
			i (stDate>=stdate)&&(endDate<=enddate)
			{
				s flag=1
				s:ret'="" ret=ret_","_perObj.PerName
				s:ret="" ret=perObj.PerName
			}
		}
		s argdate=stdate-1
		f
		{
			s flag=0
			s argdate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perObj.%Id(),argdate))
			q:(argdate="")||(argdate>enddate)||(flag=1)
			s flag=1
			s:ret1'="" ret1=ret1_","_perObj.PerName
			s:ret1="" ret1=perObj.PerName
		}
	}
	i EndDate'=""
	{
		s:ret1'="" infor=ret1_"在"_$zd(stdate,3)_"-"_$zd(enddate,3)_"之间有排班"
		i ret'=""
		{
			s:infor'="" infor=infor_","_ret_"在"_$zd(stdate,3)_"-"_$zd(enddate,3)_"之间有轮转计划,"
			s:infor="" infor=ret_"在"_$zd(stdate,3)_"-"_$zd(enddate,3)_"之间有轮转计划,"
		}
	}
	else
	{
		s:ret1'="" infor=ret1_"在"_StDate_"之后有排班"
		i ret'=""
		{
			s:infor'="" infor=infor_","_ret_"在"_StDate_"之后有轮转计划,"
			s:infor="" infor=ret_"在"_StDate_"之后有轮转计划,"
		}
	}
	q:infor'="" infor
	q ""
}

/// creator: wangcc
/// createdate: 20200805
/// description: 删除时段之间的某人的排班和轮转计划子表记录
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod DeleteArgAndPlan(per, stdate, enddate)
{
	s subid="" f  s subid=$o(^DHCINM.Intern.MgTransPlanSubI("ssid"," "_per,subid)) q:subid=""  d
	.s subobj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subid)
	.q:'$IsObject(subobj)
	.s Stdate=subobj.PlanTimeDR.PlanStDate
	.s Enddate=subobj.PlanTimeDR.PlanEndDate
	.i (Stdate>=stdate)&&(Enddate<=enddate) d
	..d ##class(DHCINM.Intern.MgTransPlanSub).%DeleteId(subid)
	s argdate=stdate-1 f  s argdate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",per,argdate)) q:(argdate="")||(argdate>=enddate)  d
	.s argid="" f  s argid=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",per,argdate,argid)) q:argid=""  d
	..d ##class(DHCINM.Arg.MgArrangeSub).%DeleteId(argid)
}

/// creator: wangcc
/// createdate: 20200805
/// description: 保存护士离职信息
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod SaveInternResign(per, resigndate, remark, createuser)
{
	s rw=$o(^DHCINM.HR.MgNurseResignI("ssid",per,""))
	i rw'="" q 0
	ts
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(per)
	q:'$IsObject(perObj)
	s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","离职")
	s perObj.PerStateDate=resigndate
	s sc=perObj.%Save()
	i '$$$ISOK(sc)
	{
		tro
	}
	s obj=##class(DHCINM.HR.MgNurseResign).%New()
	s obj.ResignCreater=createuser
	s obj.ResignDate=resigndate
	s obj.ResignName=##class(CF.DHCINM.HR.Persons).%OpenId(per)
	s obj.ResignType="P"
	s obj.ResignReason=remark
	s obj.ResignReStatus="E"
	s obj.ResignStatus="A"
	s obj.ResignWard=perObj.PerDepDR
	s sc1=obj.%Save()
	if '$$$ISOK(sc1)
	{
		tro
	}
	tc
	q 1
}

/// creator: wangcc
/// createdate: 20200805
/// description: 删除实习生人员调整计划
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod DeleteAdjust(id)
{
	q:id="" 0
	s sc=##class(DHCINM.Intern.MgInternAdjust).%DeleteId(id)
	i $$$ISOK(sc) q 1
	e  q 0
}

/// creator: wangcc
/// createdate: 20200805
/// description: 获取轮转计划状态
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod GetPlanStatus(id)
{
	s plan=##class(DHCINM.Intern.MgTransPlan).%OpenId(id)
	q plan.PlanStatus
}

/// creator: wangcc
/// createdate: 20200805
/// description: 保存实习生培训制度
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod SaveRule(parr, nurseid)
{
	s id=$p(parr,"^",3)
	s title=$p(parr,"^",1)
	s refer=$p(parr,"^",2)
	s:id="" obj=##class(DHCINM.Intern.MgTrainRule).%New()
	s:id'="" obj=##class(DHCINM.Intern.MgTrainRule).%OpenId(id)
	s obj.RuleName=title
	s obj.RuleUpDate=+$h
	s obj.RuleUpPer=nurseid
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: wangcc
/// createdate: 20200805
/// description: 删除实习生培训制度
/// table: DHCINM.Intern.MgInternAdjust
/// input:
/// output:
ClassMethod DeleteRule(id)
{
	s sc=##class(DHCINM.Intern.MgTrainRule).%DeleteId(id)
	q:$$$ISOK(sc) 1
	q 0
}

/// creator: wangcc
/// createdate: 20200805
/// description: 获取实习生培训制度列表
/// table: DHCINM.Intern.MgInternRule
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainRuleList","","")
Query FindTrainRuleList(stdate As %String = "", enddate) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTrainRuleListExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s id="" f  s id=$O(^DHCINM.Intern.MgTrainRuleD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgTrainRule).%OpenId(id)
	.q:((stdate'="")&&(stdate>obj.RuleUpDate))
	.q:((enddate'="")&&(enddate<obj.RuleUpDate))
	.s RuleName=obj.RuleName
	.i obj.RuleUpPer=0 d
	..s UpPerson="管理员"
	.e  d
	..s UpPerson=$lg($g(^CF.DHCINM.DB.MgUserD(obj.RuleUpPer)),2)
	.s UpDate=$zd(obj.RuleUpDate,3)
	.s Refer=obj.RuleRefer
	.s ret="RuleName|"_RuleName_"^UpPerson|"_UpPerson_"^UpDate|"_UpDate_"^RowID|"_id_"^Refer|"_Refer
	.d OutRulePlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRulePlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainRuleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainRuleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainRuleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainRuleListExecute ]
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

ClassMethod deleteTrainRefer(parr)
{
	s type=$p(parr,"^",1)
	s id=$p(parr,"^",2)
	s:type="rules" obj=##class(DHCINM.Intern.MgTrainRule).%OpenId(id)
	s:type="plan" obj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s:type="rules" obj.RuleRefer=""
	s:type="plan" obj.PlanRefer=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q 0
}

ClassMethod saveTrainRefer(parr)
{
	s type=$p(parr,"^",1)
	s id=$p(parr,"^",2)
	s refer=$p(parr,"^",3)
	s:type="rules" obj=##class(DHCINM.Intern.MgTrainRule).%OpenId(id)
	s:type="plan" obj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s:type="rules" obj.RuleRefer=refer
	s:type="plan" obj.PlanRefer=refer
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q 0
}

/// Creator:wangcc
/// Createdate:
/// Description:获取启用的片区信息列表
/// Input:
/// Output:
/// Other:
Query FindWardAreaList() As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardAreaListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$O(^CF.DHCINM.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardAreaI("Code",code,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardArea).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(obj.AreaEndDate'="")&&(obj.AreaEndDate<=+$h)
	..s ret=##class(web.INMDBComm).GetWardArea(id)
	..d OutWardArea
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardArea
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardAreaListExecute ]
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

/// Creator:
/// Createdate:
/// Description:保存科室信息列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardLocList","")
Query FindWardLocList() As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardLocListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$O(^CF.DHCINM.DB.MgWardLocI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardLocI("Code",code,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(obj.LocEndDate'="")&&(obj.LocEndDate<=+$h)
	..s ret=##class(web.INMDBComm).GetWardLoc(id)
	..d OutWardLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocListExecute ]
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

/// Creator:wangcc
/// Createdate:
/// Description:查询培训计划列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainPlanList","^2020-01-01^2020-12-31")
Query FindTrainPlanList(parr, nurseid) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrainPlanListExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$p(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s enddate=$p(parr,"^",3)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s id=""
	f  s id=$o(^DHCINM.Intern.MgTrainPlanD(id)) q:id=""  d
	.s obj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	.q:'$IsObject(obj)
	.q:((stdate'="")&&(obj.EndDate'="")&&(obj.EndDate<stdate))||((enddate'="")&&(obj.StDate'="")&&(obj.StDate>enddate))
	.q:(status'="")&&(status'=obj.Status)
	.q:nurseid'=obj.Creator
	.s ret=..GetTrainPlan(id)
	.d Out
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainPlanListExecute ]
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

/// Creator:wangcc
/// Createdate:
/// Description:查询培训计划列表
/// Input:
/// Output:
/// Other:d ##class("web.INMInternComm").GetTrainPlan("")
ClassMethod GetTrainPlan(id)
{
	s obj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	q:'$IsObject(obj)
	s title=obj.PlanName
	s level=obj.PlanLevel
	s levelDesc=$case(level,"H":"护理部","L":"科室")
	s range=obj.PlanRange
	s rangeDesc=$case(range,"A":"片区","L":"科室","W":"病区")
	s rangeSub=obj.PlanRangeSub
	s speakerType=obj.SpeakerType
	s speakerTypeDesc=$case(speakerType,"T":"统一指定","L":"科室指定")
	s speaker=obj.Speaker
	s place=obj.Place
	s planDate="",planTime="",endDate=""
	s:(obj.PlanDate'="")&&(obj.PlanTime'="") planDate=$zd(obj.PlanDate,3),planTime=$zt(obj.PlanTime,2)
	s stDate=$zd(obj.StDate,3)
	s:obj.EndDate'="" endDate=$zd(obj.EndDate,3)
	s content=obj.Content
	s refer=obj.PlanRefer
	s status=$case(obj.Status,"N":"已保存","S":"已发布","E":"已结束")
	s ret="Title|"_title_"^LevelDesc|"_levelDesc_"^Level|"_level_"^Place|"_place_"^SpeakerType|"_speakerType_"^State|"
	s ret=ret_"^PlanDateTime|"_planDate_" "_planTime_"^Range|"_range_"^RangeSub|"_rangeSub_"^Speaker|"_speaker_"^Refer|"_refer
	s ret=ret_"^Content|"_content_"^PlanDate|"_planDate_"^PlanTime|"_planTime_"^StDate|"_stDate_"^EndDate|"_endDate_"^Status|"_status
	s ret=ret_"^rw|"_id
	q ret
}

/// Creator:wangcc
/// Createdate:
/// Description:保存培训计划
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).SaveTrainPlan("Title|导尿管注意事项^Level|H^Range|W^RangeSub|1,2^SpeakerType|T^Speaker|2,4,6^PlanDate|2020-10-09^PlanTime|14:30^StDate|2020-09-30^EndDate|^Content|1231131^Refer|^Place|三楼^rw|")
ClassMethod SaveTrainPlan(parr, nurseid)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s newObj=##class(DHCINM.Intern.MgTrainPlan).%New()
	s:id'="" newObj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	s newObj.PlanName=tmp("Title")
	s newObj.PlanLevel=tmp("Level")
	s newObj.PlanRange=tmp("Range")
	s newObj.PlanRangeSub=tmp("RangeSub")
	s:$g(tmp("PlanDate"))'="" newObj.PlanDate=$zdh(tmp("PlanDate"),3)
	s:$g(tmp("PlanTime"))'="" newObj.PlanTime=$zth(tmp("PlanTime"),2)
	s newObj.StDate=$zdh(tmp("StDate"),3)
	s:$g(tmp("EndDate"))'="" newObj.EndDate=$zdh(tmp("EndDate"),3)
	s:$g(tmp("Place"))'="" newObj.Place=tmp("Place")
	s newObj.Content=tmp("Content")
	s newObj.Creator=nurseid
	s newObj.CreateDate=+$h
	s newObj.SpeakerType=tmp("SpeakerType")
	s newObj.Speaker=$g(tmp("Speaker"))
	s newObj.Status="N"
	s sc=newObj.%Save()
	q:'$$$ISOK(sc) 0
	q newObj.%Id()
}

/// Creator:wangcc
/// Createdate:
/// Description:发布培训计划
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).PublicTrainPlan("")
ClassMethod PublicTrainPlan(id)
{
	s planObj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	s planObj.Status="S"
	s sc=planObj.%Save()
	try{
		s PlanStatus="未培训"                     ;状态描述
		s PlanName=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),2)  ;培训题目
		s PlanLevel=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),3)
		s PlanLevelDesc =""
		s:PlanLevel'="" PlanLevelDesc=$case(PlanLevel,"H":"护理部","L":"科室")  ;级别
		s PlanDate=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),6) ;计划日期
		s:PlanDate'="" PlanDateDesc=$zd(PlanDate,3)
		s PlanTime=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),7) ;;计划时间
		s:PlanTime'="" PlanTimeDesc=$zt(PlanTime,3)
		s PlanRange=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),4)  ;发布范围
		s PlanRangeDesc="" ;{code:'A',desc:'片区'},{code:'L',desc:'科室'},{code:'W',desc:'病区'}
		s:PlanRange'="" PlanRangeDesc=$case(PlanRange,"L":"科室","A":"片区","W":"病区")
		s PlanRangeSub=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),5) ;培训范围描述
		
		s PlanRangeSubDesc=""
		for i=1:1:$L(PlanRangeSub,",")
		{
			s WardDescID=$p(PlanRangeSub,",",i)
			i i<$L(PlanRangeSub,",") s PlanRangeSubDesc=PlanRangeSubDesc_$lg($g(^CF.DHCINM.DB.MgWardD(WardDescID)),4)_","
			e  s PlanRangeSubDesc=PlanRangeSubDesc_$lg($g(^CF.DHCINM.DB.MgWardD(WardDescID)),4)
		
		}
		
		s Place=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),14) ;培训地点
		s Speaker=$lg($g(^DHCINM.Intern.MgTrainPlanD(id)),16)
		
		for i=1:1:$L(Speaker,",")
		{
			s SpeakerID=$p(Speaker,",",i)
			q:SpeakerID=""
			s ret="【实习进修/培训管理/培训记录】"_PlanStatus_" "_PlanName_" "_PlanLevelDesc_" "_PlanDateDesc_","_PlanTimeDesc_" "_PlanRangeDesc_" "_PlanRangeSubDesc_" "_Place
	    	d ##class(web.INMPlatform).SaveTrackMessage(SpeakerID,+$H,ret,"","DHCINM.Intern.MgTrainPlan",id)		
			
		}
				
	}catch{
	}
	q:'$$$ISOK(sc) 0
	q 1
}

/// Creator:wangcc
/// Createdate:
/// Description:删除培训计划
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).DeleteTrainPlan("")
ClassMethod DeleteTrainPlan(id)
{
	s sc=##class(DHCINM.Intern.MgTrainPlan).%DeleteId(id)
	q:'$$$ISOK(sc) 0
	q 1
}

/// Creator:wangcc
/// Createdate:
/// Description:查询培训记录列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainPlanSubList","^^^",2)
Query FindTrainPlanSubList(parr, nurseid) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrainPlanSubListExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$p(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s enddate=$p(parr,"^",3)
	s ward=$p(parr,"^",4)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmpWard=""
	s tmp=""
	s rangeWard=""
	s ret=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id=""
	f  s id=$o(^DHCINM.Intern.MgTrainPlanD(id)) q:id=""  d
	.k rangeWard
	.s rangeWard=""
	.s obj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.Status'="S"
	.s speakType=obj.SpeakerType
	.s title=obj.PlanName
	.s level=obj.PlanLevel
	.s levelDesc=$case(level,"H":"护理部","L":"科室")
	.s range=obj.PlanRange
	.s rangeDesc=$case(range,"A":"片区","L":"科室","W":"病区")
	.s planDate=$zd(obj.PlanDate,3)_" "_$zt(obj.PlanTime,2)
	.s rangSub=obj.PlanRangeSub
	.s place=obj.Place
	.i speakType="L" d
	..d ..GetRelatedWard(range,rangSub,.rangeWard)
	..b:id=2
	..s wardId="" f  s wardId=$o(rangeWard(wardId)) q:wardId=""  d
	...q:(isAll'=1)&&('$d(tmpWard(wardId)))
	...q:(ward'="")&&(ward'=wardId)
	...s trainward=$lg(^CF.DHCINM.DB.MgWardD(wardId),4)
	...s place="",speaker="",trainDate="",members="",member=0,num=0,state="",trainStatus=""
	...s subId="" f  s subId=$o(^DHCINM.Intern.MgTrainPlanSubI("ward",id," "_wardId,subId)) q:subId=""  d
	....s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(id_"||"_subId)
	....q:'$IsObject(subObj)
	....s place=subObj.TrainPlace
	....s speaker=subObj.Speaker
	....s:subObj.TrainDate'="" trainDate=$zd(subObj.TrainDate,3)_" "_$zt(subObj.TrainTime,2)
	....s num=..GetInternNumByWard(subObj.TrainDate,wardId)
	....s:subObj.TrainMember'="" member=$l(subObj.TrainMember,",")
	....s members=subObj.TrainMember
	....s state=member_"/"_num
	....s trainStatus=$case(subObj.TrainStatus,"N":"未培训","Y":"已培训")
	...i speaker=""  d
	....s num=..GetInternNumByWard(+$h,wardId)
	....s trainStatus="待指定"
	....s:(obj.EndDate'="")&&(obj.EndDate<+$h) trainStatus="已结束"
	....s state="0/"_num
	...q:(status'="")&&(status'=trainStatus)
	...q:(stdate'="")&&(trainDate'="")&&(stdate>$zdh(trainDate,3))
	...q:(enddate'="")&&(trainDate'="")&&(enddate<$zdh(trainDate,3))
	...s ret="Title|"_title_"^Status|"_trainStatus_"^LevelDesc|"_levelDesc_"^PlanDateTime|"_planDate_"^Place|"_place_"^Range|"_rangeDesc
	...s ret=ret_"^State|"_state_"^TrainDate|"_trainDate_"^Par|"_id_"^Ward|"_wardId_"^WardDesc|"_trainward_"^SpeakType|"_speakType_"^Members|"_members
	...d Out
	.e  d
	..s flag=0
	..s:place="" place="各科室教室"
	..d ..GetRelatedWard(range,rangSub,.rangeWard)
	..s wardId="" f  s wardId=$o(rangeWard(wardId)) q:(wardId="")||(flag=1)  d
	...q:(isAll'=1)&&('$d(tmpWard(wardId)))
	...q:(ward'="")&&(ward'=wardId)
	...s flag=1
	..q:flag=0
	..s trainDate="",member=0,num=0,state="",trainStatus="",members=""
	..s trainward=..GetRangeDesc(range,rangSub)
	..s speaker=obj.Speaker
	..s subId=$o(^DHCINM.Intern.MgTrainPlanD(id,"ChildSub",""))
	..i subId'="" d
	...s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(id_"||"_subId)
	...q:'$IsObject(subObj)
	...s:subObj.TrainDate'="" trainDate=$zd(subObj.TrainDate,3)_" "_$zt(subObj.TrainTime,2)
	...s wardId="" f  s wardId=$o(rangeWard(wardId)) q:wardId=""  d
	....s num=num+..GetInternNumByWard(subObj.TrainDate,wardId)
	...s:subObj.TrainMember'="" member=$l(subObj.TrainMember,",")
	...s members=subObj.TrainMember
	...s state=member_"/"_num
	...s trainStatus=$case(subObj.TrainStatus,"N":"未培训","Y":"已培训")
	..e  d
	...s wardId="" f  s wardId=$o(rangeWard(wardId)) q:wardId=""  d
	....s num=num+..GetInternNumByWard(+$h,wardId)
	...s trainStatus="未培训"
	...s:(obj.EndDate'="")&&(obj.EndDate<+$h) trainStatus="已结束"
	...s state="0/"_num
	..q:(status'="")&&(status'=trainStatus)
	..q:(stdate'="")&&(trainDate'="")&&(stdate>$zdh(trainDate,3))
	..q:(enddate'="")&&(trainDate'="")&&(enddate<$zdh(trainDate,3))
	..s ret="Title|"_title_"^Status|"_trainStatus_"^LevelDesc|"_levelDesc_"^PlanDateTime|"_planDate_"^Place|"_place_"^Range|"_rangeDesc
	..s ret=ret_"^State|"_state_"^TrainDate|"_trainDate_"^Par|"_id_"^Ward|^WardDesc|"_trainward_"^SpeakType|"_speakType_"^Members|"_members
	..d Out
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainPlanSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainPlanSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainPlanSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainPlanSubListExecute ]
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

/// Creator:wangcc
/// Createdate:
/// Description:查询片区或科室关联的病区
/// Input:type :A 片区 L 科室  str:1,2,3   tmpWard 
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainPlanSubList","^2020-01-01^2020-12-31")
ClassMethod GetRelatedWard(type, str, tmpWard)
{
	q:str="" ""
	i type="A" d
	.f i=1:1:$l(str,",") d
	..s area=$p(str,",",i)
	..s loc="" f  s loc=$o(^CF.DHCINM.DB.MgWardLocI("Area",area,loc)) q:loc=""  d
	...s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",loc,ward)) q:ward=""  d
	....s tmpWard(ward)=ward
	e  i type="L"  d
	.f i=1:1:$l(str,",") d
	..s loc=$p(str,",",i)
	..s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",loc,ward)) q:ward=""  d
	...s tmpWard(ward)=ward
	e  d
	.f i=1:1:$l(str,",") d
	..s ward=$p(str,",",i)
	..s tmpWard(ward)=ward
}

/// Creator:wangcc
/// Createdate:
/// Description:按计划id和培训病区查询培训记录
/// Input:type :A 片区 L 科室  str:1,2,3   tmpWard 
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainPlanSubList","^2020-01-01^2020-12-31")
ClassMethod GetRangeDesc(type, str)
{
	q:str="" ""
	s desc=""
	i type="A" d
	.f i=1:1:$l(str,",") d
	..s area=$p(str,",",i)
	..s areadesc=$lg(^CF.DHCINM.DB.MgWardAreaD(area),3)
	..s:desc'="" desc=desc_","_areadesc
	..s:desc="" desc=areadesc
	e  i type="L" d
	.f i=1:1:$l(str,",") d
	..s loc=$p(str,",",i)
	..s locdesc=$lg(^CF.DHCINM.DB.MgWardLocD(loc),3)
	..s:desc'="" desc=desc_","_locdesc
	..s:desc="" desc=locdesc
	e  d
	.f i=1:1:$l(str,",") d
	..s ward=$p(str,",",i)
	..s warddesc=$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	..s:desc'="" desc=desc_","_warddesc
	..s:desc="" desc=warddesc
	q desc
}

/// Creator:wangcc
/// Createdate:
/// Description:查询某天在某个病区的实习生数
/// Input: 
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindTrainPlanSubList","^2020-01-01^2020-12-31")
ClassMethod GetInternNumByWard(date, ward)
{
	s:date="" date=+$h
	s:date["-" date=$zdh(date,3)
	s num=0
	s per="" f  s per=$o(^CF.DHCINM.HR.PersonsI("type"," P",per)) q:per=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(per)
	.q:'$IsObject(perObj)
	.q:(perObj.PerInternStDate>date)||(perObj.PerInternEndDate<=date)
	.s currentWard=##class(web.INMHRComm).GetCurrentWard(per,date)
	.q:currentWard'=ward
	.s num=num+1
	s intern="" f  s intern=$o(^DHCINM.Intern.MgInternD(intern)) q:intern=""  d
	.s internObj=##class(DHCINM.Intern.MgIntern).%OpenId(intern)
	.q:'$IsObject(internObj)
	.q:(internObj.RecDate>=date)
	.s perId=internObj.IntPerDR.%Id()
	.s currentWard=##class(web.INMHRComm).GetCurrentWard(perId,date)
	.q:currentWard'=ward
	.s num=num+1
	q num
}

/// Creator:wangcc
/// Createdate:
/// Description:获取培训记录内容
/// Input: 
/// Output:
/// Other:w ##class(web.INMInternComm).GetTrainPlanSub(9,3)
ClassMethod GetTrainPlanSub(par, ward)
{
	s planObj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(par)
	s title=planObj.PlanName
	s trainDate=$zd(+$h,3)
	s trainTime=$zt($p($h,",",2),2)
	s level=planObj.PlanLevel
	s planDate=$zd(planObj.PlanDate,3)
	s speaker=planObj.Speaker
	s member=""
	s content=planObj.Content
	s refer=planObj.PlanRefer
	s place=planObj.Place
	i ward'="" d
	.s subId=$o(^DHCINM.Intern.MgTrainPlanSubI("ward",par," "_ward,""))
	.i subId'="" d
	..s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	..s speaker=subObj.Speaker
	..s trainDate=$zd(subObj.TrainDate,3)
	..s trainTime=$zt(subObj.TrainTime,2)
	..s place=subObj.TrainPlace
	..s member=subObj.TrainMember
	e  d
	.s subId=$o(^DHCINM.Intern.MgTrainPlanD(par,"ChildSub",""))
	.i subId'="" d
	..s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	..s trainDate=$zd(subObj.TrainDate,3)
	..s trainTime=$zt(subObj.TrainTime,2)
	..s member=subObj.TrainMember
	s ret="Title|"_title_"^TrainDate|"_trainDate_"^TrainTime|"_trainTime_"^Level|"_level_"^PlanDate|"_planDate_"^Speaker|"_speaker
	s ret=ret_"^Place|"_place_"^Content|"_content_"^Refer|"_refer_"^Member|"_member
	q ret
}

/// Creator:wangcc
/// Createdate:
/// Description:获取培训发布范围内的实习生
/// Input: 
/// Output:
/// Other:d ##class(web.INMInternComm).GetTrainMemberList(3,3)
ClassMethod GetTrainMemberList(par, ward)
{
	s date=+$h
	s rangeWard=""
	s ret=""
	i ward'="" d
	.s rangeWard(ward)=""
	.s subId=$o(^DHCINM.Intern.MgTrainPlanSubI("ward",par," "_ward,""))
	.i subId'="" d
	..s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	..s date=subObj.TrainDate
	e  d
	.s planObj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(par)
	.d ..GetRelatedWard(planObj.PlanRange,planObj.PlanRangeSub,.rangeWard)
	.s subId=$o(^DHCINM.Intern.MgTrainPlanI(par,"ChildSub",""))
	.i subId'="" d
	..s subObj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	..s date=subObj.TrainDate
	b ;001
	s wardid=""  f  s wardid=$o(rangeWard(wardid)) q:wardid=""  d
	.s per="" f  s per=$o(^CF.DHCINM.HR.PersonsI("type"," P",per)) q:per=""  d
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(per)
	..q:'$IsObject(perObj)
	..q:(perObj.PerInternStDate>date)||(perObj.PerInternEndDate<=date)
	..s currentWard=##class(web.INMHRComm).GetCurrentWard(per,date)
	..q:currentWard'=wardid
	..s:ret'="" ret=ret_","_perObj.PerName_"-"_perObj.PerNo
	..s:ret="" ret=perObj.PerName_"-"_perObj.PerNo
	.s intern="" f  s intern=$o(^DHCINM.Intern.MgInternD(intern)) q:intern=""  d
	..s internObj=##class(DHCINM.Intern.MgIntern).%OpenId(intern)
	..q:'$IsObject(internObj)
	..q:(internObj.RecDate>=date)
	..s perId=internObj.IntPerDR.%Id()
	..s currentWard=##class(web.INMHRComm).GetCurrentWard(perId,date)
	..q:currentWard'=wardid
	..s:ret'="" ret=ret_","_internObj.IntName_"-"_internObj.IntNo
	..s:ret="" ret=internObj.IntName_"-"_internObj.IntNo
	q ret
}

/// Creator:wangcc
/// Createdate:
/// Description:保存培训记录
/// Input: 
/// Output:
/// Other:d ##class(web.INMInternComm).SaveTrainPlanSub("2,4^李留-1125^大厦四楼^2020-09-25^18:14^N",9,3,"待指定")
ClassMethod SaveTrainPlanSub(parr, par, ward, status)
{
	s speaker=$p(parr,"^",1)
	s member=$p(parr,"^",2)
	s place=$p(parr,"^",3)
	s traindate=$p(parr,"^",4)
	s:traindate["-" traindate=$zdh(traindate,3)
	s traintime=$p(parr,"^",5)
	s traintime=$zth(traintime,2)
	s flag=$p(parr,"^",6)
	s obj=##class(DHCINM.Intern.MgTrainPlanSub).%New()
	i status'="待指定" d
	.i ward'="" d
	..s subId=$o(^DHCINM.Intern.MgTrainPlanSubI("ward",par," "_ward,""))
	..s obj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	.e  d
	..s subId=$o(^DHCINM.Intern.MgTrainPlanD(par,"ChildSub",""))
	..s:subId'="" obj=##class(DHCINM.Intern.MgTrainPlanSub).%OpenId(par_"||"_subId)
	s obj.Parref=##class(DHCINM.Intern.MgTrainPlan).%OpenId(par)
	s obj.Speaker=speaker
	s obj.TrainDate=traindate
	s obj.TrainMember=member
	s obj.TrainPlace=place
	s obj.TrainStatus=flag
	s obj.TrainTime=traintime
	s obj.TrainWard=ward
	s sc=obj.%Save()
	
	try{
		i flag="N" 
		{
			s TrainStatus="未培训"									;状态描述
			;s PlanName=obj.Parref.PlanName  ;培训题目
			s PlanName=$lg($g(^DHCINM.Intern.MgTrainPlanD(par)),2)   ;培训题目
			s PlanLevel=$lg($g(^DHCINM.Intern.MgTrainPlanD(par)),3)		 ;级别
			s PlanLevelDesc =""
			s:PlanLevel'="" PlanLevelDesc=$case(PlanLevel,"H":"护理部","L":"科室")
			s PlanDate=$lg($g(^DHCINM.Intern.MgTrainPlanD(par)),6) ;计划日期
			s PlanDateDesc=$zd(PlanDate,3)
			s PlanTime=$lg($g(^DHCINM.Intern.MgTrainPlanD(par)),7) ;;计划时间
			s PlanTimeDesc=$zt(PlanTime,3)
			s PlanRange=$lg($g(^DHCINM.Intern.MgTrainPlanD(par)),4)  ;发布范围
			s PlanRangeDesc="" 											
			s:PlanRange'="" PlanRangeDesc=$case(PlanRange,"L":"科室","A":"片区","W":"病区")
			;s PlanRangeSub=$lg($g(^DHCINM.Intern.MgTrainPlanSubD(par_"||"_subId)),7) 
			s PlanRangeSub=obj.TrainWard                   ;培训范围描述
			s PlanRangeSubDesc=$lg($g(^CF.DHCINM.DB.MgWardD(PlanRangeSub)),4)
			;培训地点  传参获取 place 
			for i=1:1:$L(speaker,",") 
			{         
				s SpeakerID=$p(speaker,",",i)    ;主讲人
				q:SpeakerID=""
				s ret="【实习进修/培训管理/培训记录】"_" "_TrainStatus_" "_PlanName_" "_PlanLevelDesc_" "_PlanDateDesc_","_PlanTimeDesc_" "_PlanRangeDesc_" "_PlanRangeSubDesc_" "_place
		    	d ##class(web.INMPlatform).SaveTrackMessage(SpeakerID,+$H,ret,"","DHCINM.Intern.MgTrainPlan",par)				      	
			}
		}       	
	}catch{
		
			
	}
	
	q:$$$ISOK(sc) 1
	q 0
}

ClassMethod GetRuleRefer(id)
{
	s obj=##class(DHCINM.Intern.MgTrainRule).%OpenId(id)
	q obj.RuleRefer
}

///  creator: wangcc
///  createdate: 
///  description: 删除附件
///  table: DHCINM.Intern.MgAPRecord
///  input:
///  output:
///  return:
///  other:
ClassMethod deleteRecordRefer(parr As %String) As %String
{
		s id=$p(parr,"^")
		s url=$tr($p(parr,"^",2)," ","")
		s obj=##class(DHCINM.Intern.MgAPRecord).%OpenId(id)
		q:'$IsObject(obj) ""
		s newRefer=""
		f i=1:1:$l(obj.RecordRefer,",") d
		.q:url=$p(obj.RecordRefer,",",i)
		.s:newRefer'="" newRefer=newRefer_","_$p(obj.RecordRefer,",",i)
		.s:newRefer="" newRefer=$p(obj.RecordRefer,",",i)
		s obj.RecordRefer=newRefer
		s sc=obj.%Save()
		i $$$ISOK(sc){
			q 1	
		}else{
			q 0
		}
}

///  creator: wangcc
///  createdate: 
///  description: 保存附件
///  table: DHCINM.Intern.MgAPRecord
///  input:
///  output:
///  return:
///  other:
ClassMethod saveRecordRefer(parr As %String) As %String
{
		s id=$p(parr,"^")
		s url=$tr($p(parr,"^",2)," ","")
		s obj=##class(DHCINM.Intern.MgAPRecord).%OpenId(id)
		q:'$IsObject(obj) ""
		i obj.RecordRefer="" d
		.s obj.RecordRefer=url
		e  s obj.RecordRefer=obj.RecordRefer_","_url
		s sc=obj.%Save()
		i $$$ISOK(sc){
			q 1	
		}else{
			q 0
			}
}

/// Creator:wangcc
/// Createdate:
/// Description:保存奖惩记录
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).SaveRecord("Title|12322^Batch|1^Group|1^Name|43^Ward|2^Type|R^isRelate|false^episodeID|^Bed|^patName|^Content|^RowID|^flag|N",0)
ClassMethod SaveRecord(parr, nurseid)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(DHCINM.Intern.MgAPRecord).%New()
	s:tmp("RowID")'="" obj=##class(DHCINM.Intern.MgAPRecord).%OpenId(tmp("RowID"))
	s obj.Batch=##class(DHCINM.Intern.MgTransPlan).%OpenId(tmp("Batch"))
	s obj.Group=##class(DHCINM.Intern.MgTransPlanGroup).%OpenId(tmp("Group"))
	s obj.isRelate=tmp("isRelate")
	s obj.Name=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("Name"))
	i tmp("isRelate")="true" d
	.s obj.PatName=tmp("patName")
	.s obj.Bed=(tmp("Bed"))
	.s obj.episodeID=tmp("episodeID")
	e  d
	.s obj.PatName=""
	.s obj.Bed=""
	.s obj.episodeID=""
	s obj.Recorder=nurseid
	s obj.Title=tmp("Title")
	s obj.Ward=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("Ward"))
	s obj.RecordContent=tmp("Content")
	s obj.RecordType=tmp("Type")
	s obj.RecordStatus=tmp("flag")
	s sc=obj.%Save()
	q obj.%Id()
}

/// Creator:wangcc
/// Createdate:
/// Description:获取某条奖惩记录
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).GetRecord(1)
ClassMethod GetRecord(id)
{
	s obj=##class(DHCINM.Intern.MgAPRecord).%OpenId(id)
	q:'$IsObject(obj) ""
	s title=obj.Title
	s batch=obj.Batch.%Id()
	s batchDesc=obj.Batch.PlanDesc
	s group=obj.Group.%Id()
	s groupDesc=obj.Group.GroupDesc
	s name=obj.Name.%Id()
	s nameDesc=obj.Name.PerName
	s ward=obj.Ward.%Id()
	s wardDesc=obj.Ward.WardDesc
	s isRelate=obj.isRelate
	s episodeID=obj.episodeID
	s bed=obj.Bed
	s patName=obj.PatName
	s content=obj.RecordContent
	s refer=obj.RecordRefer
	s type=obj.RecordType
	s recorder="demo"
	s:obj.Recorder'=0 recorder=$lg(^CF.DHCINM.HR.PersonsD(obj.Recorder),2)
	s typeDesc=$case(obj.RecordType,"R":"表扬","P":"批评","T":"投诉")
	s recordDate=$zd(obj.RecordDate,3)_" "_$zt(obj.RecordTime,2)
	s status=obj.RecordStatus
	s statusDesc=$case(obj.RecordStatus,"N":"保存","Y":"提交")
	s ret="Title|"_title_"^Batch|"_batch_"^BatchDesc|"_batchDesc_"^Group|"_group_"^GroupDesc|"_groupDesc_"^Name|"_name_"^NameDesc|"_nameDesc
		   _"^Ward|"_ward_"^WardDesc|"_wardDesc_"^Type|"_type_"^TypeDesc|"_typeDesc_"^isRelate|"_isRelate_"^episodeID|"_episodeID_"^Bed|"_bed
		   _"^patName|"_patName_"^Status|"_status_"^StatusDesc|"_statusDesc_"^Content|"_content_"^Refer|"_refer_"^RecordTime|"_recordDate_"^Recorder|"_recorder_"^RowID|"_id
	q ret
}

/// Creator:wangcc
/// Createdate:
/// Description:查询奖惩记录列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMInternComm","FindAPRecords","2020-11-01^2020-11-30^^^",0)
Query FindAPRecords(parr, nurseid) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAPRecordsExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s batch=$p(parr,"^",5)
	s id="" f  s id=$o(^DHCINM.Intern.MgAPRecordD(id)) q:id=""  d
	.s recordDate=$lg(^DHCINM.Intern.MgAPRecordD(id),12)
	.q:(stdate'="")&&(stdate>recordDate)
	.q:(enddate'="")&&(enddate<recordDate)
	.s recordType=$lg(^DHCINM.Intern.MgAPRecordD(id),17)
	.q:(type'="")&&(type'=recordType)
	.s recordStatus=$lg(^DHCINM.Intern.MgAPRecordD(id),16)
	.q:(status'="")&&(status'=recordStatus)
	.s recordBatch=$lg(^DHCINM.Intern.MgAPRecordD(id),3)
	.q:(batch'="")&&(batch'=recordBatch)
	.s ret=..GetRecord(id)
	.d Out
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAPRecordsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAPRecordsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAPRecordsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAPRecordsExecute ]
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

/// Creator:wangcc
/// Createdate:
/// Description:根据就诊号获取病人姓名和床位
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).GetPatNameAndBed(4)
ClassMethod GetPatNameAndBed(episodeID)
{
	s name=##class(Nur.CommonInterface.Patient).getPatient(episodeID).GetAt("name")
	s bedCode=##class(Nur.CommonInterface.Patient).getPatient(episodeID).GetAt("bedCode")
	q:(name="") "-1"
	q name_"^"_bedCode
}

/// Creator:wangcc
/// Createdate:
/// Description:获取实习生某分组的成员
/// Input:
/// Output:
/// Other:d ##class(web.INMInternComm).GetMemberByGrp(4)
Query FindMemberByGrp(id) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMemberByGrpExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i '$d(^DHCINM.Intern.MgTransPlanGroupD(id))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s master=$lg(^DHCINM.Intern.MgTransPlanGroupD(id),5)
	s member=$lg(^DHCINM.Intern.MgTransPlanGroupD(id),6)
	s nameStr=member
	s:(","_member_",")'[(","_master_",") nameStr=nameStr_","_master
	f i=1:1:$l(nameStr,",") d
	.s perdr=$p(nameStr,",",i)
	.s name=$lg(^CF.DHCINM.HR.PersonsD(perdr),2)
	.s ret="MemberName|"_name_"^RowID|"_perdr
	.d Out
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMemberByGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMemberByGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMemberByGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMemberByGrpExecute ]
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

ClassMethod DeleteRecord(id)
{
	d ##class(DHCINM.Intern.MgAPRecord).%DeleteId(id)
}

/// desc:4.1的2021.1.15版本之前已经使用了实习生轮转计划，需要执行此方法 
/// 		1.在CF.DHCINM.Trans.TransDep加索引 Index perwardtime On (PerDr, PerDepart, PerTranStDate);
/// 		2.d ##class(CF.DHCINM.Trans.TransDep).%BuildIndices()
/// 		3.w ##class(web.INMInternComm).SetInternPlanSubInDep()
ClassMethod SetInternPlanSubInDep()
{
	s flag=0
	ts
	s plan="" f  s plan=$o(^DHCINM.Intern.MgTransPlanSubI("PlanPerson",plan)) q:(plan="")||(flag=1)  d
	.q:'$d(^DHCINM.Intern.MgTransPlanD(plan))
	.s status=$lg(^DHCINM.Intern.MgTransPlanD(plan),4)
	.q:status'="S"
	.s perdr="" f  s perdr=$o(^DHCINM.Intern.MgTransPlanSubI("PlanPerson",plan,perdr)) q:(perdr="")||(flag=1)  d
	..s subId="" f  s subId=$o(^DHCINM.Intern.MgTransPlanSubI("PlanPerson",plan,perdr,subId)) q:(subId="")||(flag=1)  d
	...s subObj=##class(DHCINM.Intern.MgTransPlanSub).%OpenId(subId)
	...q:'$IsObject(subObj)
	...s stdate=subObj.PlanTimeDR.PlanStDate
	...s enddate=subObj.PlanTimeDR.PlanEndDate
	...s ward=subObj.PlanWardDR.%Id()
	...s depDr=##class(web.INMHRComm).GetCurrentWard($tr(perdr," ",""),enddate)
	...s stDep=$o(^CF.DHCINM.Trans.TransDepI("perwardtime",perdr," "_ward,stdate,""))
	...s endDep=$o(^CF.DHCINM.Trans.TransDepI("perwardtime",perdr," "_depDr,enddate,""))
	...b
	...i stDep'="" d
	....s stDepObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(stDep)
	....q:'$IsObject(stDepObj)
	....s stDepObj.InternPlanSub=subId
	....s sc=stDepObj.%Save()
	....s:'$$$ISOK(sc) flag=1
	...q:flag=1
	...i endDep'="" d
	....s endDepObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(endDep)
	....q:'$IsObject(endDepObj)
	....s endDepObj.InternPlanSub=subId
	....s sc=endDepObj.%Save()
	....s:'$$$ISOK(sc) flag=1
	...q:flag=1
	i flag=1
	{
		tro
	}
	else
	{
		tc
	}
	q flag
}

/// Creator:liwenzhen 
/// Createdate:
/// Description:撤销发布培训计划
/// Input:
/// Output:
/// Other:w ##class(web.INMInternComm).CancelPublicTrainPlan("8")
ClassMethod CancelPublicTrainPlan(id)
{
       s planObj=##class(DHCINM.Intern.MgTrainPlan).%OpenId(id)
       q:($d(^DHCINM.Intern.MgTrainPlanSubI("status",id," Y"))'=0) "已培训不可撤销！"
       s planObj.Status="N"
       s sc=planObj.%Save() 
       d ##class(web.INMPlatform).DeleteTrackMessage("DHCINM.Intern.MgTrainPlan",id)
       q:'$$$ISOK(sc) 0
       q 1
}

/// Creator:wangpengfei 
/// Createdate:
/// Description:实习生调整人员调整恢复功能
/// Input:
/// Output:
/// Other: w ##class(web.INMInternComm).ReAdjust()
ClassMethod ReAdjust(id As %String = "")
{
 	q:id="" 0
 	s obj=##class(DHCINM.Intern.MgInternAdjust).%OpenId(id)
 	q:'$IsObject(obj) 0
 	s transId=$o(^CF.DHCINM.Trans.TransDepI("pertime"," "_obj.AdjustIntern,obj.AdjustEndDate,""))
 	q:transId="" 0
 	s transObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transId)
 	q:'$IsObject(transObj) 0
 	s transObj.PerTranStDate=obj.AdjustStDate
 	s sc=transObj.%Save()
 	q $$$ISOK(sc)
}

ClassMethod GetRotationIntern(ward, time)
{
	s num=0
	s subid="" f  s subid=$o(^DHCINM.Intern.MgTransPlanSubI("WardTime",ward,time,subid)) q:subid=""  d
	.s num=num+1
	q num
}

}
