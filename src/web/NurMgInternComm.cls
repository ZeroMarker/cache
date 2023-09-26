/// Creator：gzj
/// Description：Vue版护理管理实习生管理公共类 
/// Date：2017-09-02
Class web.NurMgInternComm Extends %RegisteredObject
{

/// Creator:gzj
/// Date:2018-07-04
/// Description:生成实习生编号
/// Table:
/// Input:
/// Output：
/// Return:
/// Other：
ClassMethod GenerateInternNo(parr As %String) As %String
{
	s PerType="01"
	s nurseno=""
	i parr="专科" d
	.s PerType="02"
	s row=$O(^DHCNMG.HR.MgPersonsI("type"," P",""),-1)
	s lastPerObj=##class(DHCNMG.HR.MgPersons).%OpenId(row)
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
/// Table：DHCNMG.HR.MgPersons
/// Input：
/// Return：成功返回 记录id 
ClassMethod SaveIntern(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	q:((rowid'="")&&(id'="")&&(rowid'=id)) "-1"
	q:((rowid'="")&&(id="")) "-2"
	;q:(id'="")&&(id'=rowid) "-1"
	s tmp("PerYear")=+$g(tmp("PerComeDate"))
	i $g(tmp("PerEspecially"))'="" s tmp("PerIsEspecially")=1
	i id="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersons","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.MgPersons","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..i p="PerCategroy" s tmp(p)=$tr(tmp(p),"__","||")
	..s tmp("PerTypeDR")="P" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..;s tmp("PerCategroy")="34||1" //应届
	..s tmp("PerPassword")="UUUUUU&&&&&&"
	.. 
	..i p="PerPic" d
	...s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	..e  d
	...s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	d obj.%Save()
	q obj.%Id()
}

/// Creator:gzj
/// Description:查询实习人员列表
/// Date:2017-09-02
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindInternList","")
Query FindInternList(parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternListExecute(ByRef qHandle As %Binary, parr As %String = "", nursetype As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",ret1=""
	s nurseinfo=$zcvt($tr($p(parr,"^",1)," ",""),"U")
	s wardcode=$p(parr,"^",2)
	s interntype=$p(parr,"^",3)
	s internYear=$p(parr,"^",4)
	s tmp=""
	s tmpward=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("type"," "_nursetype,rowid)) q:rowid=""  d
	.s InternId=$o(^DHCNMG.HR.MgInternI("ssid",rowid,""),-1)
	.s internStatus=""
	.q:InternId'=""
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(obj.%Id(),+$h)
	.q:(isAll=0)&&((curward'="")&&('$d(tmpWard(curward))))
	.s shortName=##class(web.NurMgVueComm).ToChineseSpell(obj.PerName)
	.q:((nurseinfo'="")&&((obj.PerName_obj.PerNo_shortName)'[nurseinfo))
	.q:((wardcode'="")&&(obj.PerDepDR'=wardcode))
	.s internNo=obj.PerNo
	.s internName=obj.PerName
	.s internDep=##class(web.NurMgDBComm).GetWard(obj.PerDepDR)
	.s internWard=$P($P($g(internDep),"^",3),"|",2)
	.i obj.PerComeDate'="" s internComDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
	.e  s internComDate=""
	.i obj.PerSexDR'="" s internSex=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR)
	.e  s internSex=""
	.s PerCategroy=""
	.q:((interntype'="")&&(obj.PerCategroy'="")&&(obj.PerCategroy'=interntype))
	.i obj.PerCategroy'="" d
	..s CodeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerCategroy)
	..q:'$IsObject(CodeSubObj)
	..s PerCategroy=CodeSubObj.SubDesc
	.s PerYear=obj.PerYear
	.q:((internYear'="")&&(PerYear'=internYear))
	.s ret="internNo|"_internNo_"^internName|"_internName_"^internWard|"_internWard_"^internComDate|"_internComDate_"^internSex|"_internSex_"^rowid|"_rowid_"^internStatus|"_internStatus_"^internid|"_InternId_"^interncategroy|"_PerCategroy
	.s tmp(rowid)=ret
	.do OutputInternData
	s rowid=0 f  s rowid=$O(^DHCNMG.HR.MgInternD(rowid)) q:rowid=""  d
	.s obj1=##class(DHCNMG.HR.MgIntern).%OpenId(rowid)
	.q:'$IsObject(obj1)
	.s curward=obj1.IntDepDR
	.q:(isAll=0)&&((curward'="")&&('$d(tmpWard(curward))))
	.q:((nurseinfo'="")&&((obj1.IntName_obj1.IntNo)'[$zcvt(nurseinfo,"U")))
	.q:((wardcode'="")&&(obj1.IntDepDR'=wardcode))
	.s internNo=obj1.IntNo
	.s internName=obj1.IntName
	.s internDep=##class(web.NurMgDBComm).GetWard(obj1.IntDepDR)
	.s internWard=$P($P($g(internDep),"^",3),"|",2)
	.i obj1.IntComeDate'="" s internComDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj1.IntComeDate)
	.e  s internComDate=""
	.i obj1.IntSexDR'="" s internSex=##class(web.NurMgPersonComm).GetCommCode(obj1.IntSexDR)
	.e  s internSex=""
	.s internStatus=obj1.IntStatus
	.i obj1.IntStatus'="" s internStatus="已转正"
	.s perObj=obj1.IntPerDR
	.s PerCategroy=""
	.q:((interntype'="")&&(obj1.IntPerDR.PerCategroy'="")&&(obj1.IntPerDR.PerCategroy'=interntype))
	.i obj1.IntPerDR.PerCategroy'="" d
	..s CodeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj1.IntPerDR.PerCategroy)
	..q:'$IsObject(CodeSubObj)
	..s PerCategroy=CodeSubObj.SubDesc
	.s perid=""
	.i $IsObject(perObj) s perid=obj1.IntPerDR.%Id()
	.s ret="internNo|"_internNo_"^internName|"_internName_"^internWard|"_internWard_"^internComDate|"_internComDate_"^internSex|"_internSex_"^rowid|"_perid_"^internStatus|"_internStatus_"^internid|"_rowid_"^interncategroy|"_PerCategroy
	.s tmp(perid)=ret
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

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取实习生数据
/// Table：DHCNMG.HR.MgPersons
/// Input：
/// Return： 
ClassMethod GetIntern(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s internrowid=$o(^DHCNMG.HR.MgInternI("ssid",id,""))
	if internrowid'=""
	{
		s ret=..GetValue(internrowid)_"^isPerson|0"
	}
	else
	{
		s PerName=obj.PerName
		s PerSexDR=obj.PerSexDR
		i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
		e  s PerBirthday=""
		s PerNo=obj.PerNo
		;s PerType="本科"
		;s:$E(PerNo,6)=2 PerType="专科"
		s PerType=obj.PerType
		s PerCardId=obj.PerCardId
		s PerNativePlace=obj.PerNativePlace
		s PerDepDR=obj.PerDepDR
		i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
		e  s PerDepDate=""
		i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
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
		;s PerHobby=obj.PerHobby
		s PerEspecially=obj.PerEspecially
		s PerCategroy=obj.PerCategroy
		s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerBirthday|"_PerBirthday_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId_"^PerNativePlace|"_PerNativePlace_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerPic|"_PerPic_"^PerAddress|"_PerAddress_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^RowID|"_id_"^isPerson|1"
		s ret=ret_"^PerNation|"_obj.PerNation_"^PerType|"_PerType_"^PerHeight|"_PerHeight_"^PerWeight|"_PerWeight_"^PerEspecially|"_PerEspecially
		s ret=ret_"^PerInternSchool|"_obj.PerInternSchool_"^PerCategroy|"_PerCategroy
	}
	q ret
}

/// Creator:gzj
/// Description:查询实习人员姓名、实习编号信息
/// Date:2017-09-04
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindInternInfo","")
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
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("type"," "_nursetype,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:((wardcode'="")&&(obj.PerDepDR'=wardcode))
	.s internNo=obj.PerNo
	.s internName=obj.PerName
	.s nurseno=obj.PerID
	.s internInfo=""
	.i nursetype="P" s internInfo=internName_"("_internNo_")"
	.e  i nursetype="N" s internInfo=internName_"("_nurseno_")"
	.q:((nurseinfo'="")&&(internInfo'[$zcvt(nurseinfo,"U")))
	.s internDep=##class(web.NurMgDBComm).GetWard(obj.PerDepDR)
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
/// Table：DHCNMG.HR.MgNurseResign
/// Input：
/// Return：成功返回 记录id 
ClassMethod SaveResign(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=-1
	i tmp("ResignName")'="" d
	.s rw=$O(^DHCNMG.HR.MgNurseResignI("ssid",tmp("ResignName"),""))
	.i ((rw'="")&&(rw'=id)) s flag=0
	q:flag=0 flag
	i id="" s obj=##class(DHCNMG.HR.MgNurseResign).%New()
	e  s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ResignName"))
	s:$IsObject(perObj) obj.ResignWard=perObj.PerDepDR
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgNurseResign","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="ResignName" d
	...s tmp(p)=perObj
	..e  d
	...s ptype=^oddCOM("DHCNMG.HR.MgNurseResign","a",p,"P","XSDTYPE")
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
/// Table:DHCNMG.HR.MgNurseResign
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindResignLists","")
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
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.MgNurseResignI("type"," "_nursetype,date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurseResignI("type"," "_nursetype,date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(isAll=0)&&((obj.ResignWard="")||('$d(tmpWard(obj.ResignWard)))||(obj.ResignReStatus'="E"))
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
	...s WardStr=##class(web.NurMgDBComm).GetWard(obj.ResignWard)
	...s resignWard=$p($p(WardStr,"^",3),"|",2)
	..e  s resignWard=""
	..i obj.ResignDate'="" s resignDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ResignDate)
	..e  s resignDate=""
	..i nursetype="P" s resignReason=obj.ResignReason
	..e  i nursetype="N" s resignReason=..GetReason(obj.ResignReason)
	..e  s resignReason=""
	..s creater=""
	..i obj.ResignCreater'="" d
	...i obj.ResignCreater=0 s creater="管理员"
	...e  d
	....s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignCreater)
	....q:'$IsObject(nurseobj)
	....s creater=nurseobj.PerName
	..i obj.CreateDate'="" s createDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
	..e  s createDate=""
	..s updateUser=""
	..i obj.UpdateUser=0 d
	...s updateUser="管理员"
	..e  d
	...s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.UpdateUser)
	...q:'$IsObject(perobj)
	...s updateUser=perobj.PerName
	..i obj.ResignUpdate'="" s resignUpdate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ResignUpdate)
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
/// Table：DHCNMG.HR.MgNurseResign
/// Input：
/// Return：
ClassMethod GetReason(str As %String) As %String
{
	s ret=""
	q:str="" ""
	i str["~" s len=$l(str,"~") //22||1~22||2~22||3~22||5~22||7~22||9~22||11~22||13~22||15
	e  i str["," s len=$l(str,",")
	e  s len=0
	for i=1:1:len
	{
		i str["~" s rw=$P(str,"~",i)
		e  i str["," s rw=$P(str,",",i)
		e  s rw=""
		i rw'="" d
		.s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(rw)
		.q:'$IsObject(obj)
		.i ret="" s ret=obj.SubDesc
		.e  s ret=ret_";"_obj.SubDesc
	}
	q ret
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取离职数据
/// Table：DHCNMG.HR.MgNurseResign
/// Input：
/// Return： 
ClassMethod GetResign(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj)
	s ResignName=obj.ResignName.%Id()
	s ResignWard=obj.ResignWard
	i obj.ResignDate'="" s ResignDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ResignDate)
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
/// Description: 获取记录状态
/// Table：DHCNMG.HR.MgNurseResign
/// Input：
/// Return： 
ClassMethod GetResignStatu(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.ResignStatus
	q ret
}

ClassMethod DelResignRec(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) ""
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 审核
/// Table：DHCNMG.HR.MgNurseResign
/// Input：
/// Return：
ClassMethod CheckResignRec(id As %String, type As %String, status As %String, parr As %String) As %String
{
	s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	q:'$IsObject(obj) "所选记录不存在"
	s obj.ResignStatus=status
	s obj.ResignOpinion=$tr($p(parr,"^",1)," ","")
	s obj.UpdateUser=$p(parr,"^",2)
	i $p(parr,"^",3)'="" s obj.ResignDate=$zdh($p(parr,"^",3),3)
	s obj.ResignUpdate=+$H
	TS
	s saveflag=1
	i status="A" d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
	.s perObj.PerStatus="17||3"
	.s perObj.PerStateDate=obj.ResignDate
	.s perObj.PerStatuReason=obj.ResignReason
	.i perObj.PerTypeDR="P" s perObj.PerCategroy="34||2"
	.s sc=perObj.%Save()
	.s:$$$ISERR(sc) saveflag=0
	.q:saveflag=0
	.s duty=""
	.s typedate=0
	.s typeid=0
	.f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",obj.ResignName.%Id(),typeid)) q:typeid=""  d
	..s dutyobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	..i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	.i duty'="" s obj.ResignDuty=duty
	.s Academic=""
	.s typedate1=0
	.s typeid1=0
	.f  s typeid1=$o(^DHCNMG.HR.MgEducateI("ssid",obj.ResignName.%Id(),typeid1)) q:typeid1=""  d
	..s Academicobj1=##class(DHCNMG.HR.MgEducate).%OpenId(typeid1)
	..i Academicobj1.EduStDate>typedate1 s Academic=Academicobj1.EduAcademic
	.i Academic'="" s obj.ResignAcademic=Academic
	i saveflag=0{
		TRO
		q "修改人员信息失败"
	}
	s sc=obj.%Save()
	i $$$ISERR(sc) {
		TRO
		q "修改离职记录失败"	
	}
	;删除实习生轮转记录
	s TransFlag=0,TranDate=+$h
	i obj.ResignDate'="" s TranDate=obj.ResignDate
	s plantimeId="" f  s plantimeId=$O(^DHCNMG.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subid)
	..q:'$IsObject(subObj)
	..q:'$IsObject(subObj.PlanPerDR)
	..i subObj.PlanPerDR.%Id()=obj.ResignName.%Id() d
	...s sc=subObj.%DeleteId(subid)
	...i $$$ISERR(sc) s TransFlag="1"
	if TransFlag=0
	{
		TC
		q "1"
	}
	else
	{
		TRO
		d $System.Status.DisplayError(sc)
		q "删除实习生轮转记录失败"
	}
	q 1
}

/// Creator: 
/// CreatDate: 2017-09-04
/// Description: 批量审核
/// Table：DHCNMG.HR.MgNurseResign
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
	.s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	.q:'$IsObject(obj)
	.s obj.ResignStatus="A"
	.s:nurseid'=0 obj.UpdateUser=nurseid
	.s obj.ResignUpdate=+$H
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
	.s perObj.PerStatus="17||3"
	.i perObj.PerTypeDR="P" s perObj.PerCategroy="34||2"
	.s perObj.PerStateDate=obj.ResignDate
	.s perObj.PerStatuReason=obj.ResignReason
	.s sc= perObj.%Save()
	.s:$$$ISERR(sc) flag=0
	.q:$$$ISERR(sc)
	.s duty=""
	.s typedate=0
	.s typeid=0
	.f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",obj.ResignName.%Id(),typeid)) q:typeid=""  d
	..s dutyobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	..i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	.i duty'="" s obj.ResignDuty=duty
	.s Academic=""
	.s typedate1=0
	.s typeid1=0
	.f  s typeid1=$o(^DHCNMG.HR.MgEducateI("ssid",obj.ResignName.%Id(),typeid1)) q:typeid1=""  d
	..s Academicobj1=##class(DHCNMG.HR.MgEducate).%OpenId(typeid1)
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
/// description: 保存实习生转科计划
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other:
ClassMethod SaveTransPlan(parr As %String) As %String
{
	s ^tmp("SaveTransPlan")=parr
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(tmp("rw"))
	.s obj.PlanEditDate=+$h
	.s obj.PlanEditTime=$P($h,",",2)
	.i $g(tmp("PlanStatus"))'="" s obj.PlanStatus=$g(tmp("PlanStatus"))
	e  d
	.s obj=##class(DHCNMG.Intern.MgTransPlan).%New()
	.s obj.PlanCrtDate=+$h
	.s obj.PlanCrtTime=$P($h,",",2)
	.s obj.PlanStatus="N"
	.s obj.PlanEditDate=+$h
	.s obj.PlanEditTime=$P($h,",",2)
	s obj.PlanCode=$g(tmp("PlanCode"))
	s obj.PlanDesc=$g(tmp("PlanDesc"))
	s obj.PlanRemarks=$g(tmp("PlanRemarks"))
	i $g(tmp("PlanCrtUser"))'="" d
	.s crtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PlanCrtUser"))
	.i $IsObject(crtUser) s obj.PlanCrtUser=crtUser
	e  s obj.PlanCrtUser=""
	i $g(tmp("PlanEditUser"))'="" d
	.s PlanEditUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PlanEditUser"))
	.i $IsObject(PlanEditUser) s obj.PlanEditUser=PlanEditUser
	e  s obj.PlanEditUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170918
/// description: 获取实习生转科计划
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other:
ClassMethod GetTransPlan(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s ret="rw|"_id
	s ret=ret_"^PlanCode|"_obj.PlanCode
	s ret=ret_"^PlanDesc|"_obj.PlanDesc
	s ret=ret_"^PlanRemarks|"_obj.PlanRemarks
	s ret=ret_"^PlanStatus|"_obj.PlanStatus
	s ret=ret_"^StatusDesc|"_$case(obj.PlanStatus,"N":"草稿","Y":"保存","S":"生效","T":"停止","V":"作废",:"")
	i obj.PlanCrtUser'="" d
	.s ret=ret_"^PlanCrtUser|"_obj.PlanCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.PlanCrtUser.PerName
	i obj.PlanCrtDate'="" s ret=ret_"^PlanCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanCrtDate)
	i obj.PlanCrtTime'="" s ret=ret_"^PlanCrtTime|"_$zt(obj.PlanCrtTime,1)
	i obj.PlanEditUser'="" d
	.s ret=ret_"^PlanEditUser|"_obj.PlanEditUser.%Id()
	.s ret=ret_"^EditUserName|"_obj.PlanEditUser.PerName
	i obj.PlanEditDate'="" s ret=ret_"^PlanEditDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanEditDate)
	i obj.PlanEditTime'="" s ret=ret_"^PlanEditTime|"_$zt(obj.PlanEditTime,1)
	q ret
}

/// creator: xbl
/// createdate: 20170918
/// description: 删除实习生转科计划
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other:
ClassMethod DeleteTransPlan(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(id)
	s grpid="" f  s grpid=$O(^DHCNMG.Intern.MgTransPlanGroupI("Plan",id,grpid)) q:grpid=""  d
	.d ##class(DHCNMG.Intern.MgTransPlanGroup).%DeleteId(grpid)
	s timeid="" f  s timeid=$O(^DHCNMG.Intern.MgTransPlanTimeI("Plan",id,timeid)) q:timeid=""  d
	.d ##class(DHCNMG.Intern.MgTransPlanTime).%DeleteId(timeid)
	s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("Plan",id,subid)) q:subid=""  d
	.d ##class(DHCNMG.Intern.MgTransPlanSub).%DeleteId(subid)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170918
/// description: 获取实习生转科计划列表
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindTransPlan","","")
Query FindTransPlan(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPlanExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s ^TMP("FindTransPlan")=parr_"&"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s id="" f  s id=$O(^DHCNMG.Intern.MgTransPlanD(id)) q:id=""  d
	.s obj=##Class(DHCNMG.Intern.MgTransPlan).%OpenId(id)
	.q:((stdate'="")&&(stdate<obj.PlanCrtDate))||((enddate'="")&&(enddate>obj.PlanCrtDate))
	.q:(input'="")&&(obj.PlanCode'[input)
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

/// creator: xbl
/// createdate: 20170918
/// description: 保存实习生分组
/// table: DHCNMG.Intern.MgTransPlanGroup
/// input:
/// output:
/// other:
ClassMethod SavePlanGroup(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%New()
	i $g(tmp("PlanDR"))'="" d
	.s obj.PlanDR=##class(DHCNMG.Intern.MgTransPlan).%OpenId(tmp("PlanDR"))
	e  s obj.PlanDR=""
	s obj.GroupCode=$g(tmp("GroupCode"))
	s obj.GroupDesc=$g(tmp("GroupDesc"))
	i $g(tmp("GroupMaster"))'="" d
	.s obj.GroupMaster=##Class(DHCNMG.HR.MgPersons).%OpenId(tmp("GroupMaster"))
	e  s obj.GroupMaster=""
	d obj.GroupMember.Clear()
	f i=1:1:$L(tmp("GroupMember"),",") d
	.s perdr=$P(tmp("GroupMember"),",",i)
	.q:(perdr="")&&(obj.GroupMember.Find(perdr))
	.d obj.GroupMember.Insert(perdr)
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170918
/// description: 删除实习生分组
/// table: DHCNMG.Intern.MgInternGroup
/// input:
/// output:
/// other:
ClassMethod GetPlanGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(id)
	s ret="rw|"_id
	i obj.PlanDR'="" d
	.s ret=ret_"^PlanDR|"_obj.PlanDR.%Id()
	.s ret=ret_"^PlanDesc|"_obj.PlanDR.PlanDesc
	s ret=ret_"^GroupCode|"_obj.GroupCode
	s ret=ret_"^GroupDesc|"_obj.GroupDesc
	i obj.GroupMaster'="" d
	.s ret=ret_"^GroupMaster|"_obj.GroupMaster.%Id()
	.s ret=ret_"^PerName|"_obj.GroupMaster.PerName
	s members="",names=""
	f i=1:1:obj.GroupMember.Count() d
	.s perdr=obj.GroupMember.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i members'="" s members=members_","_perdr,names=names_","_perobj.PerName
	.e  s members=perdr,names=perobj.PerName
	s ret=ret_"^GroupMember|"_members
	s ret=ret_"^MemberName|"_names
	q ret
}

/// creator: xbl
/// createdate: 20170918
/// description: 删除实习生分组
/// table: DHCNMG.Intern.MgInternGroup
/// input:
/// output:
/// other:
ClassMethod DeletePlanGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(id)
	q:'$IsObject(obj) 0
	s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanGroup",obj.PlanDR.%Id(),id,subid)) q:subid=""  d
	.d ##Class(DHCNMG.Intern.MgTransPlanSub).%DeleteId(subid)
 	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170918
/// description: 获取实习生分组
/// table: DHCNMG.Intern.MgInternGroup
/// input:
/// output:
/// other:
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
	s grpid="" f  s grpid=$O(^DHCNMG.Intern.MgTransPlanGroupI("Plan",tpid,grpid)) q:grpid=""  d
	.s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(grpid)
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

/// creator:xbl
/// createdate:20170919
/// description: 保存实习计划时段信息
/// table: DHCNMG.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod SavePlanTime(parr As %String) As %String
{
	s ^TMP("SavePlanTime")=parr
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Intern.MgTransPlanTime).%New()
	i $g(tmp("PlanDR"))'="" d
	.s obj.PlanDR=##class(DHCNMG.Intern.MgTransPlan).%OpenId(tmp("PlanDR"))
	;e  s obj.PlanDR=""
	i $g(tmp("PlanStDate"))'="" s obj.PlanStDate=$zdh(tmp("PlanStDate"),3)
	e  s obj.PlanStDate=""
	i $g(tmp("PlanEndDate"))'="" s obj.PlanEndDate=$zdh(tmp("PlanEndDate"),3)
	e  s obj.PlanEndDate=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator:xbl
/// createdate:20170919
/// description: 获取实习计划时段信息
/// table: DHCNMG.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPlanTime(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(id)
	s ret="rw|"_id
	i obj.PlanDR'="" d
	.s ret=ret_"^PlanDR|"_obj.PlanDR.%Id()
	.s ret=ret_"^PlanDesc|"_obj.PlanDR.PlanDesc
	i obj.PlanStDate'="" d
	.s ret=ret_"^PlanStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanStDate)
	i obj.PlanEndDate'="" d
	.s ret=ret_"^PlanEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanEndDate)
	i (obj.PlanStDate'="")&&(obj.PlanEndDate'="") d
	.s ret=ret_"^TimeDesc|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanStDate)_"至"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.PlanEndDate)
	.s ret=ret_"^TimeCode|Time"_id
	q ret
}

/// creator: xbl
/// createdate: 20170919
/// description: 删除计划时段信息
/// table: DHCNMG.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other:
ClassMethod DeletePlanTime(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(id)
	s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",obj.PlanDR.%Id(),id,subid)) q:subid=""  d
	.d ##class(DHCNMG.Intern.MgTransPlanSub).%DeleteId(subid)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170919
/// description: 获取计划时段信息列表
/// table: DHCNMG.Intern.MgTransPlanTime
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindPlanTime","1")
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
	;s id="" f  s id=$O(^DHCNMG.Intern.MgTransPlanTimeI("Plan",tpid,id)) q:id=""  d
	
	s date="" f  s date=$o(^DHCNMG.Intern.MgTransPlanTimeI("date",tpid,date)) q:date=""  d
	.s id="" f  s id=$o(^DHCNMG.Intern.MgTransPlanTimeI("date",tpid,date,id)) q:id=""  d
	..s obj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(id)
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

/// creator: xbl
/// createdate: 20170919
/// desciption: 保存轮转计划
/// table: DHCNMG.Intern.MgTransPlanSub
/// input: 
/// output:
/// return:
/// other: w ##class(web.NurMgInternComm).SavePlanSub("PlanDR|1^PlanGroupDR|1^PlanTimeDR|1^PlanWardDR|1^PlanPerDR|53")
ClassMethod SavePlanSub(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s plandr=$g(tmp("PlanDR"))
	s grpdr=$g(tmp("PlanGroupDR"))
	s timedr=$g(tmp("PlanTimeDR"))
	s warddr=$g(tmp("PlanWardDR"))
	s perdr=$g(tmp("PlanPerDR"))
	q:(plandr="")!(grpdr="")!(timedr="")!(warddr="")!(perdr="") 0
	i $g(tmp("rw"))="" d
	.s tmp("rw")=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",plandr,grpdr,timedr,warddr,perdr,""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Intern.MgTransPlanSub).%New()
	i $g(tmp("PlanDR"))'="" d
	.s obj.PlanDR=##class(DHCNMG.Intern.MgTransPlan).%OpenId(tmp("PlanDR"))
	e  s obj.PlanDR=""
	i $g(tmp("PlanGroupDR"))'="" d
	.s obj.PlanGroupDR=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(tmp("PlanGroupDR"))
	e  s obj.PlanGroupDR=""
	i $g(tmp("PlanTimeDR"))'="" d
	.s obj.PlanTimeDR=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(tmp("PlanTimeDR"))
	e  s obj.PlanTimeDR=""
	i $g(tmp("PlanWardDR"))'="" d
	.s obj.PlanWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("PlanWardDR"))
	e  s obj.PlanWardDR=""
	i $g(tmp("PlanPerDR"))'="" d
	.s obj.PlanPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PlanPerDR"))
	e  s obj.PlanPerDR=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170921
/// description: 获取计划明细
/// table: DHCNMG.Intern.MgTransPlanSub
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPlanSub(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(id)
	s ret="rw|"_id
	i obj.PlanDR'="" d
	.s ret=ret_"^PlanDR|"_obj.PlanDR.%Id()
	.s ret=ret_"^PlanDesc|"_obj.PlanDR.PlanDesc
	i obj.PlanGroupDR'="" d
	.s ret=ret_"^PlanGroupDR|"_obj.PlanGroupDR.%Id()
	.s ret=ret_"^GroupDesc|"_obj.PlanGroupDR.GroupDesc
	i obj.PlanTimeDR'="" d
	.s ret=ret_"^PlanTimeDR|"_obj.PlanTimeDR.%Id()
	i obj.PlanWardDR'="" d
	.s ret=ret_"^PlanWardDR|"_obj.PlanWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.PlanWardDR.WardDesc
	i obj.PlanPerDR'="" d
	.s ret=ret_"^PlanPerDR|"_obj.PlanPerDR.%Id()
	.s ret=ret_"^PerName|"_obj.PlanPerDR.PerName
	q ret
}

/// creator: xbl
/// createdate: 20170921
/// description: 删除计划明细
/// table: DHCNMG.Intern.MgTransPlanSub
/// input:
/// output:
/// return:
/// other:
ClassMethod DeletePlanSub(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Intern.MgTransPlanSub).%DeleteId(id)
	q $$$ISOK(sc)
}

ClassMethod DeletePlanSub2(tpid As %String, grpdr As %String, timedr As %String, warddr As %String) As %String
{
	q:(tpid="")!(grpdr="")!(timedr="")!(warddr="") 0
	s perdr="" f  s perdr=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr)) q:perdr=""  d
	.s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr,subid)) q:subid=""  d
	..d ..DeletePlanSub(subid)
	q 1
}

/// creator: xbl
/// createdate: 20170921
/// description: 获取病区计划明细
/// table: DHCNMG.Intern.MgTransPlanSub
/// input:
/// output:
/// return:
/// other:
ClassMethod GetWardPlanSub(tpid As %String, grpdr As %String, timedr As %String, warddr As %String) As %String
{
	q:(tpid="")!(grpdr="")!(timedr="")!(warddr="") ""
	s perdrs="",pernames=""
	s perdr="" f  s perdr=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i perdrs="" s perdrs=perdr,pernames=perobj.PerName
	.e  s perdrs=perdrs_","_perdr,pernames=pernames_","_perobj.PerName
	q perdrs_"^"_pernames
}

///  creator: xbl
///  createdate: 20170921
///  description: 获取病区计划明细
///  table: DHCNMG.Intern.MgTransPlanSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindWardPlanSub","1^1^1")
Query FindWardPlanSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPlanSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tpid=$P(parr,"^",1)
	s grpdr=$P(parr,"^",2)
	s timedr=$P(parr,"^",3)
	i (tpid="")!(grpdr="")!(timedr="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s warddr="" f  s warddr=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr)) q:warddr=""  d
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(warddr)
	.s persons=..GetWardPlanSub(tpid,grpdr,timedr,warddr)
	.s perdrs=$P(persons,"^",1)
	.s pernames=$P(persons,"^",2)
	.s ret="PlanWardDR|"_warddr_"^WardDesc|"_wardobj.WardDesc_"^PlanPersons|"_perdrs_"^PerName|"_pernames
	.d OutWardPlanSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPlanSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPlanSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPlanSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPlanSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPlanSubExecute ]
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

///  creator: xbl
///  createdate: 20170921
///  description: 获取计划明细
///  table: DHCNMG.Intern.MgTransPlanSub
///  input:
///  output:
///  return:
///  other: w ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindPlanSub","1")
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
	s grpdr="" f  s grpdr=$O(^DHCNMG.Intern.MgTransPlanGroupI("Plan",tpid,grpdr)) q:grpdr=""  d
	.s grpobj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(grpdr)
	.s persons=""
	.s groupDesc=grpobj.GroupDesc
	.s groupMaster=""
	.i $IsObject(grpobj.GroupMaster)=1 d
	..s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(grpobj.GroupMaster.%Id())
	..q:'$IsObject(NurObj)
	..s groupMaster=NurObj.PerName
	.q:grpobj.GroupMember=""
	.f i=1:1:grpobj.GroupMember.Count() d
	..s perdr=grpobj.GroupMember.GetAt(i)
	..q:perdr=""
	..s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	..i persons'="" s persons=persons_","_perobj.PerName
	..e  s persons=perobj.PerName
	.s ret="GroupPerson|"_persons_"^PlanGroupDR|"_grpdr
	.s timedr="" f  s timedr=$O(^DHCNMG.Intern.MgTransPlanTimeI("Plan",tpid,timedr)) q:timedr=""  d
	..s ret=ret_"^Time"_timedr_"|"
	..s cellvalue=""
	..s warddr="" f  s warddr=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr)) q:warddr=""  d
	...s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(warddr)
	...s persons=""
	...s perdr="" f  s perdr=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr)) q:perdr=""  d
	....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	....s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("Repeat",tpid,grpdr,timedr,warddr,perdr,""))
	....q:subid=""
	....i persons="" s persons=subid_"#"_perobj.PerName
	....e  s persons=persons_","_subid_"#"_perobj.PerName
	...q:persons=""
	...i cellvalue="" s cellvalue=warddr_"!"_wardobj.WardDesc_"!"_persons
	...e  s cellvalue=cellvalue_"@"_warddr_"!"_wardobj.WardDesc_"!"_persons
	..s ret=ret_cellvalue
	.s ret=ret_"^groupDesc|"_groupDesc_"^groupMaster|"_groupMaster
	.d OutPlanSub
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

/// creator: xbl
/// createdate: 20170922
/// description: 获取组成员
/// table: DHCNMG.Intern.MgTransPlanGroup
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindGrpNurse","1")
Query FindGrpNurse(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindGrpNurseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s grpdr=$P(parr,"^",1)
	i grpdr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s obj=##class(DHCNMG.Intern.MgTransPlanGroup).%OpenId(grpdr)
	
	i obj.GroupMember.Count()=0 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	f i=1:1:obj.GroupMember.Count() d
	.s perdr=obj.GroupMember.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s ret="PerDR|"_perdr_"^PerID|"_perobj.PerID_"^PerName|"_perobj.PerName
	.d OutGrpNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGrpNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGrpNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGrpNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGrpNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGrpNurseExecute ]
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
/// createdate: 20170922
/// description: 设置计划状态
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other: 
ClassMethod SetPlanStatus(id As %String, status As %String) As %String
{
	q:(id="")!(status="") 0
	s obj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(id)
	s obj.PlanStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: lulin
/// CreatDate: 2017年11月29日 15:26:09
/// Description: 获取实习生转正状态
/// Table：DHCNMG.HR.MgIntern
/// Input：
/// Return：申请驳回
/// Other:
ClassMethod RejectFullWorkerApply(parr As %String) As %String
{
	q:parr="" ""
	s rowid=$p(parr,"^")
	s RecUser=$p(parr,"^",2)
	q:rowid="" ""
	s obj=##class(DHCNMG.HR.MgIntern).%OpenId(rowid)
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
/// Table：DHCNMG.HR.MgIntern
/// Input：
/// Return：成功返回 状态 Y:已转正
/// Other:d ##class(web.NurMgInternComm).ApplyFullWorkerStatus("")
ClassMethod ApplyFullWorkerStatus(parr As %String) As %String
{
	q:parr="" ""
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(parr)
	q:'$IsObject(perObj) ""
	
	s CodeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perObj.PerCategroy)
	q:'$IsObject(CodeSubObj) ""
	s PerCategroy=CodeSubObj.SubDesc
	s ret=""
	s:PerCategroy["往届" ret="Y"
	q ret
}

/// Creator: lulin
/// CreatDate: 2017-11-28
/// Description: 实习生转正申请
/// Table：DHCNMG.HR.MgPersons、DHCNMG.HR.MgIntern
/// Input：
/// Return：
/// Other:d ##class(web.NurMgInternComm).ApplyFullWorkerStatus("1080")
ClassMethod applyFullWorker(parr As %String) As %String
{
	q:parr=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(parr)
	s InternId=$o(^DHCNMG.HR.MgInternI("ssid",parr,""),-1)
	i InternId="" s objInt=##class(DHCNMG.HR.MgIntern).%New()
	e  s objInt=##class(DHCNMG.HR.MgIntern).%OpenId(InternId)
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

/// Creator: lulin
/// CreatDate: 2017-11-28
/// Description: 实习生转正
/// Table：DHCNMG.HR.MgPersons、DHCNMG.HR.MgIntern
/// Input：perrowid|1801^PerId|LL001^PerDepDR|57^PerDepDate|2017-11-29^HireDuty|14__7^HireStDate|2017-11-29^RowID|2^RecUser|
/// Return：-1工号已存在、1保存成功
/// Other:d ##class(web.NurMgInternComm).CheckFullWorkerApply("PerId|LL3^PerDepDR|57^PerDepDate|2017-11-29^HireDuty|14__7^HireStDate|2017-11-29^RowID|3^RecUser|")
ClassMethod CheckFullWorkerApply(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:'$d(tmp("perrowid")) "无对应人员"
	s flag=$P(##class(web.NurMgPersonComm).IsExist(tmp("PerId")),"^")
	q:flag=0 "此工号已经存在"
	s per=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("perrowid"))
	i 'tmp("RowID") s objInt=##class(DHCNMG.HR.MgIntern).%New()
	e  s objInt=##class(DHCNMG.HR.MgIntern).%OpenId(tmp("RowID"))
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
	s objInt.RecUser=tmp("RecUser")
	s objInt.RecDate=+$h
	s objInt.RecTime=$p($h,"^",2)
	TS
	S sc=objInt.%Save()
	if $$$ISERR(sc){
		Tro
		q "保存实习记录失败"
	}
	s per.PerID=tmp("PerId")
	s per.PerTypeDR="N"
	s per.RecUser=tmp("RecUser")
	s per.RecDate=+$h
	s per.RecTime=$p($h,",",2)
	s per.PerDepDR=tmp("PerDepDR")
	s per.PerStatus="17||1"
	s per.PerCategroy="34||2" //实习生转正后要把实习生类别置成”往届“
	i tmp("PerDepDate")'="" s per.PerDepDate=$zdh(tmp("PerDepDate"),3)
	S sc=per.%Save()
	if $$$ISERR(sc){
		Tro
		q "修改人员档案失败"
	}
	s duty=##class(DHCNMG.HR.MgHireDuty).%New()
	s duty.HirePerDR=per
	s duty.HireDuty=tmp("HireDuty")
	i tmp("PerDepDate")'="" s duty.HireStDate=$zdh(tmp("HireStDate"),3)
	S sc=duty.%Save()
	if $$$ISERR(sc){
		Tro
		q "保存聘任职称失败"
	}
	s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_per.%Id(),""))
	s TransFlag=""
	i transRowID="" d
	.s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_per.%Id()_"^"_per.PerDepDR_"^"_$zd(per.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	e  d
	.s aa=##class(DHCNMG.HR.MgTransDep).%OpenId(transRowID)
	.s aa.PerDr=per.%Id()
    .s aa.PerDepart=per.PerDepDR
    .s aa.PerTranStDate=per.PerDepDate
    .s aa.PerTranCurrent="Y"
    .s aa.PerTranStTime=$P($H,",",2)
    .s aa.PerTransType="L"
    .s sc=aa.%Save()
    .i $$$ISOK(sc) s TransFlag=0
    if TransFlag'=0{
		Tro
		q "保存轮转表失败"
	}
	s TransFlag=0,TranDate=+$h
	i tmp("PerDepDate")'="" s TranDate=$zdh(tmp("PerDepDate"),3)
	s plantimeId="" f  s plantimeId=$O(^DHCNMG.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subid)
	..q:'$IsObject(subObj)
	..q:'$IsObject(subObj.PlanPerDR)
	..i subObj.PlanPerDR.%Id()=tmp("perrowid") d
	...s sc=subObj.%DeleteId(subid)
	...i $$$ISERR(sc) s TransFlag="1"
	if TransFlag=0{
		TC
		q "1"
	}else{
		TRO
		q "删除实习生轮转记录失败"
	}
}

/// Creator: 
/// CreatDate: 2017-12-07
/// Description: 获取实习生转正后实习时数据
/// Table：DHCNMG.HR.MgPersons
/// Input：
/// Return： 
ClassMethod GetValue(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgIntern).%OpenId(id)
	s PerName=obj.IntName
	s PerSexDR=obj.IntSexDR
	i obj.IntBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.IntBirthday)
	e  s PerBirthday=""
	s PerNo=obj.IntNo
	s PerType="本科"
	s:$E(PerNo,6)=2 PerType="专科"
	s PerCardId=obj.IntCardId
	s PerNativePlace=obj.IntNativePlace
	s PerDepDR=obj.IntDepDR
	i obj.IntDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.IntDepDate)
	e  s PerDepDate=""
	i obj.IntComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.IntComeDate)
	e  s PerComeDate=""
	s PerPolitical=obj.IntPolitical
	s PerMarriage=obj.IntMarriage
	s PerPic=obj.IntPic
	s PerAddress=obj.IntAddress
	s PerContact=obj.IntContact
	s PerPhone=obj.IntPhone
	s ret="PerName|"_PerName_"^PerSexDR|"_PerSexDR_"^PerBirthday|"_PerBirthday_"^PerNo|"_PerNo_"^PerCardId|"_PerCardId_"^PerNativePlace|"_PerNativePlace_"^PerDepDR|"_PerDepDR_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerPolitical|"_PerPolitical_"^PerMarriage|"_PerMarriage_"^PerPic|"_PerPic_"^PerAddress|"_PerAddress_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone_"^RowID|"_id
	s ret=ret_"^PertType|"_PerType
	q ret
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 保存带教老师
/// table: DHCNMG.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgInternComm).SaveTeacher("TeachPerDR|98^TeachWardDR|57^TeachStDate|2017-12-20^TeachEndDate|2017-12-20^TeachRemark|测试^rw|^")
ClassMethod SaveTeacher(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Intern.MgTeacher).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Intern.MgTeacher).%New()
	i $g(tmp("TeachPerDR"))'="" d
	.s obj.TeachPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("TeachPerDR"))
	e  d
	.s obj.TeachPerDR=""
	i $g(tmp("TeachWardDR"))'="" d
	.s obj.TeachWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("TeachWardDR"))
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
	.s crtObj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("CrtUser"))
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
/// table: DHCNMG.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other:
ClassMethod GetTeacher(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Intern.MgTeacher).%OpenId(id)
	s ret="rw|"_id
	i obj.TeachPerDR'="" d
	.s ret=ret_"^TeachPerDR|"_obj.TeachPerDR.%Id()
	.s ret=ret_"^PerID|"_obj.TeachPerDR.PerID
	.s ret=ret_"^PerName|"_obj.TeachPerDR.PerName
	i obj.TeachWardDR'="" d
	.s ret=ret_"^TeachWardDR|"_obj.TeachWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.TeachWardDR.WardDesc
	i obj.TeachStDate'="" d
	.s ret=ret_"^TeachStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TeachStDate)
	i obj.TeachEndDate'="" d
	.s ret=ret_"^TeachEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TeachEndDate)
	s ret=ret_"^TeachRemark|"_obj.TeachRemark
	s TeachCrtUser="",CrtUserName=""
	i obj.TeachCrtUser'="" d
	.s TeachCrtUser=obj.TeachCrtUser
	.s:$IsObject(TeachCrtUser) CrtUserName=TeachCrtUser.PerName
	e  s TeachCrtUser=0,CrtUserName="管理员"
	s ret=ret_"^TeachCrtUser|"_TeachCrtUser
	s ret=ret_"^CrtUserName|"_CrtUserName
	i obj.TeachCrtDate'="" d
	.s ret=ret_"^TeachCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TeachCrtDate)
	i obj.TeachCrtTime'="" d
	.s ret=ret_"^TeachCrtTime|"_$zt(obj.TeachCrtTime,2)
	q ret
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 删除带教老师
/// table: DHCNMG.Intern.MgTeacher
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteTeacher(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Intern.MgTeacher).%OpenId(id)
	s sc=obj.%DeleteId(id)
	i $$$ISOK(sc)
	{
		s stuid="" f  s stuid=$O(^DHCNMG.Intern.MgStudentI("Teacher",id,stuid)) q:stuid=""  d
		.q:+stuid=0
		.s stuobj=##class(DHCNMG.Intern.MgStudent).%OpenId(stuid)
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
///  table: DHCNMG.Intern.MgTeacher
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
	s id="" f  s id=$O(^DHCNMG.Intern.MgTeacherD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Intern.MgTeacher).%OpenId(id)
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

/// creator: xbl
/// createdate: 2017/12/18
/// description: 保存学生信息
/// table: DHCNMG.Intern.MgStudent
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveStudent(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s stuid=$g(tmp("StudyPerDR"))
	s tchid=$g(tmp("TeacherDR"))
	q:(stuid="")||(tchid="") 0
	i rw="" s rw=$O(^DHCNMG.Intern.MgStudentI("Repeat",tchid,stuid,""))
	i rw'="" d
	.s obj=##class(DHCNMG.Intern.MgStudent).%OpenId(rw)
	e  d
	.s obj=##class(DHCNMG.Intern.MgStudent).%New()
	i $g(tmp("StudyPerDR"))'="" d
	.s obj.StudyPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("StudyPerDR"))
	e  s obj.StudyPerDR=""
	i $g(tmp("TeacherDR"))'=""  d
	.s obj.TeacherDR=##class(DHCNMG.Intern.MgTeacher).%OpenId(tmp("TeacherDR"))
	e  s obj.TeacherDR=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 获取学生信息
/// table: DHCNMG.Intern.MgStudent
/// input:
/// output:
/// return:
/// other:
ClassMethod GetStudent(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Intern.MgStudent).%OpenId(id)
	s ret="rw|"_id
	i obj.StudyPerDR'="" d
	.s ret=ret_"^StudyPerDR|"_obj.StudyPerDR.%Id()
	.s ret=ret_"^PerID|"_obj.StudyPerDR.PerID
	.s ret=ret_"^PerNo|"_obj.StudyPerDR.PerNo
	.s ret=ret_"^PerName|"_obj.StudyPerDR.PerName
	i obj.TeacherDR'="" d
	.s ret=ret_"^TeacherDR|"_obj.TeacherDR.%Id()
	.i obj.TeacherDR.TeachPerDR'="" d
	..s ret=ret_"^TeacherName|"_obj.TeacherDR.TeachPerDR.PerName
	q ret
}

/// creator: xbl
/// createdate: 2017/12/18
/// description: 删除学生信息
/// table: DHCNMG.Intern.MgStudent
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteStudent(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Intern.MgStudent).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 2017/12/18
///  description: 获取学生列表
///  table: DHCNMG.Intern.MgStudent
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindStudentList","1")
Query FindStudentList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindStudentListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s teachdr=$P(parr,"^",1)
	i teachdr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s id="" f  s id=$O(^DHCNMG.Intern.MgStudentI("Teacher",teachdr,id)) q:id=""  d
	.q:+id=0
	.;s obj=##class(DHCNMG.Intern.MgStudent).%OpenId(id)
	.s ret=..GetStudent(id)
	.d OutStudent
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStudent
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindStudentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStudentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStudentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStudentListExecute ]
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

/// Description:查询量化评分表
/// Date:2017年12月15日 11:07:00
/// Table:DHCNMG.Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindInternScore","","0","0")
Query FindInternScore(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternScoreExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s name=$p(parr,"^") //学生姓名
	s ward=$p(parr,"^",3) //病区
	s recname=$p(parr,"^",2) //创建人
	s date=$p(parr,"^",4)
	i date'="" s date=$zdh(date,3)
	s type=$p(parr,"^",5)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id=0 f  s id=$o(^DHCNMG.Intern.MgScoreD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Intern.MgScore).%OpenId(id)
	.q:(ward'="")&&($IsObject(obj.ScoreWard))&&(obj.ScoreWard.%Id()'=ward)
	.q:(isAll=0)&&(('$IsObject(obj.ScoreWard))||('$d(tmpWard(obj.ScoreWard.%Id()))))
	.q:(date'="")&&(obj.ScoreDate'=date)
	.q:(type'="")&&(obj.ScoreFlag'=type)
	.s stu=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ScoreStu)
	.q:'$IsObject(stu)
	.q:((name'="")&&(stu.PerName'[name))
	.s perid=obj.ScoreRecDR
	.i perid="0" s pername="超级管理员"
	.e  d
	..s per=##class(DHCNMG.HR.MgPersons).%OpenId(perid) 
	..i $IsObject(per) s pername=per.PerName
	..e  s pername=""
	.q:(recname'="")&&(pername'[recname)
	.s ScoreName=stu.PerName
	.s ScoreNo=stu.PerNo
	.s ScoreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ScoreDate)
	.s ScoreWard=""
	.i $IsObject(obj.ScoreWard) s ScoreWard=obj.ScoreWard.WardDesc
	.s ScoreScore=obj.ScoreScore
	.s ScoreNum=obj.ScoreNum
	.s ScoreType="未提交"
	.i obj.ScoreFlag="Y" s ScoreType="已提交"
	.s ret="ScoreNum|"_ScoreNum_"^ScoreScore|"_ScoreScore_"^ScoreName|"_ScoreName_"^ScoreNo|"_ScoreNo_"^ScoreDate|"_ScoreDate_"^ScoreRec|"_pername_"^ScoreWard|"_ScoreWard_"^ScoreType|"_ScoreType_"^rw|"_id
	.d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInternScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInternScoreExecute ]
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

ClassMethod FindInternScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInternScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:根据轮转获取所有病区
/// Date:2017年12月15日 17:56:06
/// Table:DHCNMG.Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindWardByTransPlan","")
Query FindWardByTransPlan(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardByTransPlanExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	k tmp
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id=0 f  s id=$o(^DHCNMG.Intern.MgTransPlanSubD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.PlanWardDR)
	.q:'$IsObject(obj.PlanTimeDR)
	.q:'$IsObject(obj.PlanPerDR)
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PlanPerDR.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.q:(obj.PlanTimeDR.PlanEndDate'="")&&(obj.PlanTimeDR.PlanEndDate>$h)
	.s rw=obj.PlanWardDR.%Id()
	.q:((isAll=0)&&('$d(tmpWard(rw))))
	.q:$d(tmp(rw))
	.q:(parr'="")&&($IsObject(obj.PlanPerDR))&&(obj.PlanPerDR.%Id()'=parr)
	.s tmp(rw)=rw
	.s WardDesc=obj.PlanWardDR.WardDesc
	.s ret="rw|"_rw_"^WardDesc|"_WardDesc
	.d OutputTransPlanData
	Set qHandle=$lb(0,repid,0)
	k tmp
	Quit $$$OK
OutputTransPlanData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardByTransPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardByTransPlanExecute ]
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

ClassMethod FindWardByTransPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardByTransPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取评分项
/// Date:2017年12月15日 17:56:06
/// Table:DHCNMG.DB.MgInternScore,DHCNMG.DB.MgInternScoreSub,DHCNMG.Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgInternComm).getInternScoreSet()
ClassMethod getInternScoreSet(parr As %String = "")
{
		s ndate=+$h
		s ret=""
		s findex=0
		w "["
		i parr="" d
		.s id=0 f  s id=$o(^DHCNMG.DB.MgInternScoreD(id)) q:id=""  d
		..s obj=##class(DHCNMG.DB.MgInternScore).%OpenId(id)
		..q:((obj.ScoreStDate'="")&&(obj.ScoreStDate>ndate))||((obj.ScoreEndDate'="")&&(obj.ScoreEndDate<ndate))
		..s desc=obj.ScoreDesc
		..;s ret=ret_"{"_"""id"":"""_id_""",""index"":"""_findex_""",""fatherdesc"":"""_desc_""",""childs"":["
		..w:findex'=0 ","
		..w "{"_"""id"":"""_id_""",""index"":"""_findex_""",""fatherdesc"":"""_desc_""",""childs"":["
		..s findex=findex+1
		..s index=0
		..s childid=0 f  s childid=$o(^DHCNMG.DB.MgInternScoreSubD(id,childid)) q:childid=""  d
		...s child=##class(DHCNMG.DB.MgInternScoreSub).%OpenId(id_"||"_childid)
		...q:((child.SubStDate'="")&&(child.SubStDate>ndate))||((child.SubEndDate'="")&&(child.SubEndDate<ndate))	
		...s childdesc=child.SubDesc
		...s oscore=child.SubScore
		...s score=child.SubScore
		...s ret=ret_"{"_"""id"":"""_childid_""",""index"":"""_index_""",""childdesc"":"""_childdesc_""",""oscore"":"""_oscore_""",""score"":"""_score_""",""rw"":""""},"
		...w:index'=0 ","
		...w "{"_"""id"":"""_childid_""",""index"":"""_index_""",""childdesc"":"""_childdesc_""",""oscore"":"""_oscore_""",""score"":"""_score_""",""rw"":""""}"
		...s index=index+1
		..w "]}"
		..;s ret=ret_"]},"
		e  d
		.s setid=0 f  s setid=$o(^DHCNMG.Intern.MgScoreSubI("ScoreId",parr,setid)) q:setid=""  d
		..s subsetid=$o(^DHCNMG.Intern.MgScoreSubI("ScoreId",parr,setid,0))
		..s subid=$o(^DHCNMG.Intern.MgScoreSubI("ScoreId",parr,setid,subsetid,0))
		..s scoresubobj=##class(DHCNMG.Intern.MgScoreSub).%OpenId(parr_"||"_subid)
		..s id=$tr(setid," ","")
		..s desc=scoresubobj.SubScoreDesc
		..s ret=ret_"{"_"""id"":"""_id_""",""index"":"""_findex_""",""fatherdesc"":"""_desc_""",""childs"":["
		..w:findex'=0 ","
		..w "{"_"""id"":"""_id_""",""index"":"""_findex_""",""fatherdesc"":"""_desc_""",""childs"":["
		..s findex=findex+1
		..s index=0
		..s subsetid=0 f  s subsetid=$o(^DHCNMG.Intern.MgScoreSubI("ScoreId",parr,setid,subsetid)) q:subsetid=""  d
		...s subid=$o(^DHCNMG.Intern.MgScoreSubI("ScoreId",parr,setid,subsetid,0))
		...s scoresubobj=##class(DHCNMG.Intern.MgScoreSub).%OpenId(parr_"||"_subid)
		...s childid=$tr(subsetid," ","")
		...s childdesc=scoresubobj.SubSubScoreDesc
		...s oscore=scoresubobj.SubScore
		...s score=scoresubobj.SubRelScore
		...s rw=scoresubobj.%Id()
		...;s ret=ret_"{"_"""id"":"""_childid_""",""index"":"""_index_""",""childdesc"":"""_childdesc_""",""oscore"":"""_oscore_""",""score"":"""_score_""",""rw"":"""_rw_"""},"
		...w:index'=0 ","
		...w "{"_"""id"":"""_childid_""",""index"":"""_index_""",""childdesc"":"""_childdesc_""",""oscore"":"""_oscore_""",""score"":"""_score_""",""rw"":"""_rw_"""}"
		...s index=index+1
		..w "]}"
		..;s ret=ret_"]},"
		w "]"
		;i ret'="" s ret="["_ret_"]"
		q ""
}

/// Creator:lulin
/// Description:获取评分
/// Date:2017年12月20日 11:14:46
/// Table:Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgInternComm)getInternScore(1)
ClassMethod getInternScore(parr As %String = "")
{
		q:parr="" ""
		s obj=##class(DHCNMG.Intern.MgScore).%OpenId(parr)
		q:'$IsObject(obj) ""
		s ScoreStu=obj.ScoreStu
		s ScoreWard=""
		s:$IsObject(obj.ScoreWard) ScoreWard=obj.ScoreWard.%Id()
		s ScoreFlag=obj.ScoreFlag
		s ret=obj.%Id()_"^"_ScoreStu_"^"_ScoreWard_"^"_ScoreFlag
		q ret
}

/// Creator:lulin
/// Description:删除评分
/// Date:2018-09-04
/// Table:Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgInternComm).DeleteInternScore(1)
ClassMethod DeleteInternScore(parr As %String = "")
{
		q:parr="" 0
		s obj=##class(DHCNMG.Intern.MgScore).%OpenId(parr)
		q:'$IsObject(obj) 0
		s sc=obj.%DeleteId(parr)
		q 1
}

/// Creator:lulin
/// Description:保存评分
/// Date:2017年12月19日 16:38:02
/// Table:DHCNMG.Intern.MgScore，DHCNMG.Intern.MgScoreSub
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgInternComm).SaveInternScore()
ClassMethod SaveInternScore(parr As %String = "")
{
	q:parr="" ""
	s objdata=$p(parr,"^")
	s rw=$p(objdata,"@")
	s stu=$p(objdata,"@",2)
	s wardid=$p(objdata,"@",3)
	q:(stu="")||(wardid="") 0
	s ward=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	s recid=$p(objdata,"@",4)
	s flag=$p(objdata,"@",5)
	s score=$p(objdata,"@",6)
	s ret=""
	i rw="" d 
	.k tmp
	.;此人所有轮转的时间tmp和本病区tmp 
	.s planid="" f  s planid=$o(^DHCNMG.Intern.MgTransPlanSubI("Plan",planid)) q:planid=""  d
	..s plansubid="" f  s plansubid=$o(^DHCNMG.Intern.MgTransPlanSubI("PlanPerson",planid,stu,plansubid)) q:plansubid=""  d
	...s plansub=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(plansubid)
	...q:'$IsObject(plansub)
	...q:'$IsObject(plansub.PlanTimeDR)
	...q:'$IsObject(plansub.PlanWardDR)
	...q:(plansub.PlanTimeDR.PlanEndDate>(+$h))
	...s tmp("time",plansub.PlanTimeDR.PlanStDate,plansub.PlanWardDR.%Id())=planid_"||"_plansubid
	...;i (wardid=plansub.PlanWardDR.%Id()) s tmp("ward",plansub.PlanWardDR.%Id(),plansub.PlanTimeDR.PlanStDate)=plansubid
	.s beforwardid=""
	.s time="" f  s time=$O(tmp("time",time)) q:time=""  d
	..s twardid="" f  s twardid=$O(tmp("time",time,twardid)) q:twardid=""  d
	...i twardid'=beforwardid d
	....s tmp("all",time,twardid)=tmp("time",time,twardid)
	....i (wardid=twardid) s tmp("ward",twardid,time)=tmp("time",time,twardid)
	....s beforwardid=twardid
	.;此人此病区已评分数量
	.s wardnum=0
	.s scoreid="" f  s scoreid=$o(^DHCNMG.Intern.MgScoreI("Stu"," "_stu,scoreid)) q:scoreid=""  d
	..s scoreobj=##class(DHCNMG.Intern.MgScore).%OpenId(scoreid)
	..i scoreobj.ScoreWard.%Id()=wardid s wardnum=wardnum+1
	.;获取本病区第几次排序
	.s wardnumall=0
	.s StDatee=""
	.s StDate="" f  s StDate=$o(tmp("ward",wardid,StDate)) q:(StDate="")  d
	..i (wardnumall<=wardnum) s StDatee=StDate
	..s wardnumall=wardnumall+1
	.s:(wardnumall=wardnum) ret="本病区已评"
	.q:(wardnumall=wardnum)
	.s order=1
	.;前提条件轮转开始时间不能重复
	.s tmpdate="" f  s tmpdate=$o(tmp("all",tmpdate)) q:(tmpdate="")||(StDatee<=tmpdate)  d
	..s order=order+1
	.;s order=$fn($o(^DHCNMG.Intern.MgScoreI("Num",""),-1),"",0)+order
	.s obj=##class(DHCNMG.Intern.MgScore).%New()
	.s obj.ScoreNum=order
	e  s obj=##class(DHCNMG.Intern.MgScore).%OpenId(rw)
	q:ret'="" ret
	s obj.ChildSub=$p(objdata,"@",2)
	s obj.ScoreStu=stu
	s obj.ScoreWard=ward
	s obj.ScoreRecDR=recid
	s obj.ScoreDate=+$h
	;s obj.ScoreScore=score
	s obj.ScoreFlag=flag
	s allscore=0
	TS
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		TRO
		q "保存数据错误"	
	}
	s retflag=1
	s rw=obj.%Id()
	s len=$l(parr,"^")
	f i=2:1:len q:retflag=0  d
	.s subdata=$p(parr,"^",i)
	.q:subdata="" 
	.s subrw=$p(subdata,"@")
	.s fatherid=$p(subdata,"@",2)
	.s childid=$p(subdata,"@",3)
	.s score=$p(subdata,"@",4)
	.i subrw'="" d
	..s subobj=##class(DHCNMG.Intern.MgScoreSub).%OpenId(subrw)
	..s subobj.SubRelScore=score
	.e  d
	..s subobj=##class(DHCNMG.Intern.MgScoreSub).%New()
	..s scoreset=##class(DHCNMG.DB.MgInternScore).%OpenId(fatherid)
	..s fatherdesc=scoreset.ScoreDesc
	..s scoresubset=##class(DHCNMG.DB.MgInternScoreSub).%OpenId(fatherid_"||"_childid)
	..s childdesc=scoresubset.SubDesc
	..s oscore=scoresubset.SubScore
	..s subobj.Parref=obj
	..s subobj.SubScoreId=fatherid
	..s subobj.SubScoreDesc=fatherdesc
	..s subobj.SubSubScoreId=childid
	..s subobj.SubSubScoreDesc=childdesc
	..s subobj.SubScore=oscore
	..s subobj.SubRelScore=score
	.s sc=subobj.%Save()
	.s allscore=allscore+score
	.s:$$$ISERR(sc) retflag=0
	if retflag=0{
		TRO
		q "保存失败"	
	}
	s obj.ScoreScore=allscore
	s sc=obj.%Save()
	if $$$ISOK(sc){
		TC
		q 1
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Description:获取总的轮转次数
/// Date:2018年1月17日 20:11:40
/// Table:DHCNMG.Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgInternComm).GetPlanNum()
ClassMethod GetPlanNum()
{
	k tmp
	s plansubid="" f  s plansubid=$o(^DHCNMG.Intern.MgTransPlanSubD(plansubid)) q:plansubid=""  d
	.s plansub=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(plansubid)
	.q:'$IsObject(plansub)
	.q:'$IsObject(plansub.PlanTimeDR)
	.q:'$IsObject(plansub.PlanWardDR)
	.q:(plansub.PlanTimeDR.PlanEndDate>(+$h))
	.s tmp("time",plansub.PlanPerDR.%Id(),plansub.PlanTimeDR.PlanStDate,plansub.PlanWardDR.%Id())=plansub.PlanWardDR.%Id()
	s num=0
	s perid="" f  s perid=$o(tmp("time",perid)) q:perid=""  d
	.s pernum=0
	.s beforward=""
	.s time=""  f  s time=$o(tmp("time",perid,time)) q:time=""  d
	..s ward="" f  s ward=$O(tmp("time",perid,time,ward)) q:ward=""  d
	...i ward'=beforward d
	....s pernum=pernum+1,beforward=ward
	.s:num<pernum num=pernum
	k tmp
	q num
}

/// Creator:lulin
/// Description:获取分数统计
/// Date:2018年1月17日 20:11:49
/// Table:DHCNMG.Intern.MgScore
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindScoreSta","")
Query FindScoreSta(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreStaExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	k tmp
	s perid=0 f  s perid=$o(^DHCNMG.Intern.MgScoreI("StuNum",perid)) q:perid=""  d
	.s pid=$tr(perid," ","")
	.s tmp(pid)=pid
	.s per=##class(DHCNMG.HR.MgPersons).%OpenId(pid)
	.q:'$IsObject(per)
	.q:(parr'="")&&(per.PerName'[parr)
	.s ret="ScoreNo|"_per.PerNo_"^ScoreName|"_per.PerName_"^perid|"_pid
	.s order="" f  s order=$o(^DHCNMG.Intern.MgScoreI("StuNum",perid,order)) q:order=""  d
	..s scoreid=$o(^DHCNMG.Intern.MgScoreI("StuNum",perid,order,""))
	..s obj=##class(DHCNMG.Intern.MgScore).%OpenId(scoreid)
	..q:obj.ScoreFlag="N"
	..s ret=ret_"^p"_order_"|"_obj.ScoreScore
	.d OutputScoreStaData
	s perid=0 f  s perid=$O(^DHCNMG.Intern.MgScoreStaI("Stu",perid)) q:perid=""  d
	.s pid=$tr(perid," ","")
	.q:$d(tmp(pid))
	.s per=##class(DHCNMG.HR.MgPersons).%OpenId(pid)
	.q:'$IsObject(per)
	.q:(parr'="")&&(per.PerName'[parr)
	.s ret="ScoreNo|"_per.PerNo_"^ScoreName|"_per.PerName_"^perid|"_pid
	.d OutputScoreStaData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreStaData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreStaExecute ]
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

ClassMethod FindScoreStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreStaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:保存实习生统计分数
/// Date:2018年1月18日 11:34:50
/// Table:DHCNMG.Intern.MgScoreSta
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveScoreSta(parr As %String) As %String
{
	q:parr="" "传入数据为空"
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s tmp("ScoreStaDate")=+$h
	s isExist=$d(^DHCNMG.Intern.MgScoreStaI("Stu"," "_tmp("ScoreStaStu")))
	q:(isExist)&&($g(tmp("RowID"))="") "此学生已打分"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.Intern.MgScoreSta).%New()
	e  s obj=##class(DHCNMG.Intern.MgScoreSta).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Intern.MgScoreSta","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

/// Creator:lulin
/// Description:获取某学生统计评分
/// Date:2018年1月18日 11:34:50
/// Table:DHCNMG.Intern.MgScoreSta
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgInternComm).GetScoreSta("1847")
ClassMethod GetScoreSta(parr As %String = "") As %String
{
	q:parr="" ""
	s staid=$o(^DHCNMG.Intern.MgScoreStaI("Stu"," "_parr,""))
	s obj=##class(DHCNMG.Intern.MgScoreSta).%OpenId(staid)
	q:'$IsObject(obj) ""
	s ScoreStaStu=obj.ScoreStaStu
	s ScoreStaTheory=obj.ScoreStaTheory
	s ScoreStaOperation=obj.ScoreStaOperation
    s ScoreStaMidterm=obj.ScoreStaMidterm
    s ScoreStaTerm=obj.ScoreStaTerm
    s RowID=staid
    s ret="ScoreStaStu|"_ScoreStaStu_"^ScoreStaTheory|"_ScoreStaTheory_"^ScoreStaOperation|"_ScoreStaOperation_"^ScoreStaMidterm|"_ScoreStaMidterm_"^ScoreStaTerm|"_ScoreStaTerm_"^RowID|"_RowID
    q ret
}

/// Creator:lulin
/// Description:导入实习生信息
/// Date:2018-07-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ImportInternData(parr As %String, role As %String, nurseid As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	i rowid="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	;s obj.PerNo=..GenerateInternNo($g(tmp("PerType"))) ;实习编号
	;s obj.PerNo=nowyear_PerType_num
	s isExist=0
	s perNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U")
	q:perNo="" $tr($g(tmp("saveIndex"))," ","")
	q:$d(^DHCNMG.HR.MgPersonsI("PerNo"," "_perNo)) $tr($g(tmp("saveIndex"))," ","")
	s obj.PerNo=perNo //实习编号
	i $g(tmp("PerName"))'="" s obj.PerName=$tr($g(tmp("PerName"))," ","") //姓名
	e  s obj.PerName=""
	i $g(tmp("PerCardId"))'="" s obj.PerCardId=$tr($g(tmp("PerCardId"))," ","") //身份证号
	e  s obj.PerCardId=""
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=##class(web.NurMgImportDBData).GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s obj.PerDepDR=warddr
	.e  s obj.PerDepDR=""
	e  s obj.PerDepDR=""
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s obj.PerDepDate=$zdh($g(tmp("PerDepDate")),3)
	e  s obj.PerDepDate="" //进科日期
	i (($g(tmp("PerComeDate"))'="")&&($l($g(tmp("PerComeDate")),"-")=3)) s obj.PerComeDate=$zdh($g(tmp("PerComeDate")),3)
	e  s obj.PerComeDate="" //来院日期
	i $g(tmp("PerCardId"))'="" d
	.s obj.PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //身份证号码
	.s cardlen=$L($tr($g(tmp("PerCardId"))," ",""))
	.i cardlen=18 d
	..s birthnum=$E($tr($g(tmp("PerCardId"))," ",""),7,14)
	..i birthnum'="" s obj.PerBirthday=$zdh(birthnum,8)
	..e  s obj.PerBirthday=""
	..s sexnum=$E($tr($g(tmp("PerCardId"))," ",""),17)
	..i +sexnum>=0 d
	...i (+sexnum#2)=0 s obj.PerSexDR=##class(web.NurMgImportDBData).GetSetCode("性别","女")
	...e  s obj.PerSexDR=##class(web.NurMgImportDBData).GetSetCode("性别","男")
	e  s obj.PerCardId=""
	i $g(tmp("PerPolitical"))'="" d
	.s politicaldr=##class(web.NurMgImportDBData).GetSetCode("政治面貌",$zcvt($tr($g(tmp("PerPolitical"))," ",""),"U")) //政治面貌
	.i politicaldr'="" s obj.PerPolitical=politicaldr
	.e  s obj.PerPolitical=""
	e  s obj.PerPolitical=""
	i $g(tmp("PerMarriage"))'="" d
	.s marriagedr=##class(web.NurMgImportDBData).GetSetCode("婚姻",$zcvt($tr($g(tmp("PerMarriage"))," ",""),"U")) //婚姻
	.i marriagedr'="" s obj.PerMarriage=marriagedr
	.e  s obj.PerMarriage=""
	i $g(tmp("PerNativePlace"))'="" s obj.PerNativePlace=$tr($g(tmp("PerNativePlace"))," ","")
	e  s obj.PerNativePlace=""
	i $g(tmp("PerAddress"))'="" s obj.PerAddress=$tr($g(tmp("PerAddress"))," ","")
	e  s obj.PerAddress=""
	i $g(tmp("PerContact"))'="" s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
	e  s obj.PerContact=""
	i $g(tmp("PerPhone"))'="" s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","")
	e  s obj.PerPhone=""
	s obj.PerTypeDR="P"
	s obj.PerCareType="N"
	s obj.PerCategroy="34||1"
	s obj.PerHeight=$g(tmp("PerHeight"))
	s obj.PerWeight=$g(tmp("PerWeight"))
	s obj.PerPassword="UUUUUU&&&&&&"
	i $g(tmp("PerNation"))'="" d
	.s nativeId=##class(web.NurMgImportDBData).GetSetCode("民族",$zcvt($tr($g(tmp("PerNation"))," ",""),"U"))
	.i nativeId'="" s obj.PerNation=nativeId
	.e  s obj.PerNation=""
	e  s obj.PerNation=""
	i $g(tmp("PerComeDate"))'="" s obj.PerYear=$p($g(tmp("PerComeDate")),"-",1)
	i $g(tmp("PerType"))'="" d
	.s PerTypeId=##class(web.NurMgImportDBData).GetSetCode("学历",$zcvt($tr($g(tmp("PerType"))," ",""),"U"))
	.i PerTypeId'="" s obj.PerType=PerTypeId
	.e  s obj.PerType=""
	e  s obj.PerType=""
	s sc=obj.%Save()
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
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=$P(##class(web.NurMgPersonComm).IsExist(tmp("PerID")),"^")
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	q:flag=0 saveIndex
	;s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	;s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U") //取得实习编号
	s rowid=$O(^DHCNMG.HR.MgPersonsI("Info"," P"," "_PerNo,""))
	s per=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:'$IsObject(per) saveIndex
	s id=$O(^DHCNMG.HR.MgInternI("ssid",rowid,""))
	i id="" s objInt=##class(DHCNMG.HR.MgIntern).%New()
	e  s objInt=##class(DHCNMG.HR.MgIntern).%OpenId(id)
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
	.s warddr=##class(web.NurMgImportDBData).GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s per.PerDepDR=warddr
	.e  s per.PerDepDR=""
	e  s per.PerDepDR=""
	s per.PerStatus="17||1"
	s per.PerCategroy="34||2"
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s per.PerDepDate=$zdh(tmp("PerDepDate"),3)
	S sc=per.%Save()
	if $$$ISERR(sc){
		Tro
		q saveIndex
	}
	s duty=##class(DHCNMG.HR.MgHireDuty).%New()
	s duty.HirePerDR=per
	s duty.HireDuty=##class(web.NurMgImportDBData).GetSetCode("聘任职称","助理护士")
	i (($g(tmp("HireStDate"))'="")&&($l($g(tmp("HireStDate")),"-")=3)) s duty.HireStDate=$zdh(tmp("HireStDate"),3)
	S sc=duty.%Save()
	if $$$ISERR(sc){
		Tro
		q saveIndex
	}
	s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_per.%Id(),""))
	s TransFlag=""
	i per.PerDepDR'="" d
	.i transRowID="" d
	..s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_per.%Id()_"^"_per.PerDepDR_"^"_$zd(per.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	.e  d
	..s aa=##class(DHCNMG.HR.MgTransDep).%OpenId(transRowID)
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
	s plantimeId="" f  s plantimeId=$O(^DHCNMG.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subid)
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
/// Description:导入实习生成绩
/// Date:2018-07-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ImportInternScoreData(parr As %String, role As %String, nurseid As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	;s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	;s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U") //取得实习编号
	s rowid=$O(^DHCNMG.HR.MgPersonsI("Info"," P"," "_PerNo,""))
	s per=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:'$IsObject(per) saveIndex
	/// 评分实习生
 	//ScoreStaStu,ScoreStaTheory,ScoreStaOperation,ScoreStaMidterm
 	//,ScoreStaTerm,ScoreStaRecDR,ScoreStaDate 
 	i $d(^DHCNMG.Intern.MgScoreStaI("Stu"," "_rowid)) d
 	.s id=$O(^DHCNMG.Intern.MgScoreStaI("Stu"," "_rowid,""))
 	.s obj=##class(DHCNMG.Intern.MgScoreSta).%OpenId(id)
 	e  d
 	.s obj=##class(DHCNMG.Intern.MgScoreSta).%New()
 	.s obj.ScoreStaStu=rowid
 	i $g(tmp("ScoreStaTheory"))'="" s obj.ScoreStaTheory=$tr($g(tmp("ScoreStaTheory"))," ","")
	e  s obj.ScoreStaTheory=""
	i $g(tmp("ScoreStaOperation"))'="" s obj.ScoreStaOperation=$tr($g(tmp("ScoreStaOperation"))," ","")
	e  s obj.ScoreStaOperation=""
	i $g(tmp("ScoreStaMidterm"))'="" s obj.ScoreStaMidterm=$tr($g(tmp("ScoreStaMidterm"))," ","")
	e  s obj.ScoreStaMidterm=""
	i $g(tmp("ScoreStaTerm"))'="" s obj.ScoreStaTerm=$tr($g(tmp("ScoreStaTerm"))," ","")
	e  s obj.ScoreStaTerm=""
	i nurseid'=0 s obj.ScoreStaRecDR=nurseid
	s obj.ScoreStaDate=+$h
 	s sc=obj.%Save()
 	q saveIndex
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
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s saveIndex=$tr($g(tmp("saveIndex"))," ","")
	;s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	;s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	s PerNo=$zcvt($tr($g(tmp("PerNo"))," ",""),"U") //取得实习编号
	s rowid=$O(^DHCNMG.HR.MgPersonsI("Info"," P"," "_PerNo,""))
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:'$IsObject(perObj) saveIndex
	s rw=$O(^DHCNMG.HR.MgNurseResignI("ssid",perObj.%Id(),""))
	q:rw'="" saveIndex
	s nowdate=+$h
	s obj=##class(DHCNMG.HR.MgNurseResign).%New()
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
	f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",perObj.%Id(),typeid)) q:typeid=""  d
	.s dutyobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	.i dutyobj.HireStDate>typedate s duty=dutyobj.HireDuty
	i duty'="" s obj.ResignDuty=duty
	s Academic=""
	s typedate1=0
	s typeid1=0
	f  s typeid1=$o(^DHCNMG.HR.MgEducateI("ssid",perObj.%Id(),typeid1)) q:typeid1=""  d
	.s Academicobj1=##class(DHCNMG.HR.MgEducate).%OpenId(typeid1)
	.i Academicobj1.EduStDate>typedate1 s Academic=Academicobj1.EduAcademic
	i Academic'="" s obj.ResignAcademic=Academic
	TS
	s sc=obj.%Save()
	i $$$ISERR(sc) {
		TRO
		q saveIndex	
	}
	s perObj.PerStatus="17||3"
	s perObj.PerStateDate=obj.ResignDate
	s perObj.PerStatuReason=obj.ResignReason
	;s perObj.PerCategroy="27||2"
	s perObj.PerCategroy="34||2"
	s sc=perObj.%Save()
	i $$$ISERR(sc) {
		TRO
		q saveIndex	
	}
	;删除实习生轮转记录
	s TransFlag=0,TranDate=+$h
	i obj.ResignDate'="" s TranDate=obj.ResignDate
	s plantimeId="" f  s plantimeId=$O(^DHCNMG.Intern.MgTransPlanTimeD(plantimeId)) q:(plantimeId="")||(TransFlag'=0)  d
	.s plantimeObj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(plantimeId)
	.q:'$IsObject(plantimeObj)
	.q:plantimeObj.PlanStDate<TranDate
	.q:'$IsObject(plantimeObj.PlanDR)
	.s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",plantimeObj.PlanDR.%Id(),plantimeId,subid)) q:(subid="")||(TransFlag'=0)  d
	..s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subid)
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

// FindOutputScoreColumn

/// Creator:lulin
/// Description:获取分数统计表头病区信息
/// Date:2018-07-06
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindOutputScoreColumn","")
Query FindOutputScoreColumn(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutputScoreColumnExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^")
	s enddate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s tmp=""
	s date=0 f  s date=$O(^DHCNMG.Intern.MgScoreI("DateWardStu",date)) q:date=""  d
	.q:(stdate'="")&&(stdate>date)
	.q:(enddate'="")&&(enddate<date)
	.s wardid=0 f  s wardid=$o(^DHCNMG.Intern.MgScoreI("DateWardStu",date,wardid)) q:wardid=""  d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	..q:$d(tmp(wardid))
	..q:'$IsObject(wardObj)
	..s perid="" f  s perid=$o(^DHCNMG.Intern.MgScoreI("DateWardStu",date,wardid,perid)) q:perid=""  d
	...q:$d(tmp(wardid))
	...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId($tr(perid," ",""))
	...q:'$IsObject(perObj)
	...s curward=##class(web.NurMgHRComm).GetCurrentWard(perid,date)
	...q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	...s ret="label|"_wardObj.WardDesc_"^prop|"_wardid
	...d OutputScoreColumn
	...s tmp(wardid)=wardid
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreColumn
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutputScoreColumnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutputScoreColumnExecute ]
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

ClassMethod FindOutputScoreColumnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutputScoreColumnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取分数统计
/// Date:2018-07-06
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindOutputScoreData","")
Query FindOutputScoreData(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutputScoreDataExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^")
	s enddate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s tmp="",tmpPer=""
	
	s date=0 f  s date=$O(^DHCNMG.Intern.MgScoreI("DateWardStu",date)) q:date=""  d
	.q:(stdate'="")&&(stdate>date)
	.q:(enddate'="")&&(enddate<date)
	.s wardid=0 f  s wardid=$o(^DHCNMG.Intern.MgScoreI("DateWardStu",date,wardid)) q:wardid=""  d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	..;q:$d(tmp(wardid))
	..q:'$IsObject(wardObj)
	..s perid="" f  s perid=$o(^DHCNMG.Intern.MgScoreI("DateWardStu",date,wardid,perid)) q:perid=""  d
	...;q:$d(tmp(wardid))
	...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId($tr(perid," ",""))
	...q:'$IsObject(perObj)
	...s curward=##class(web.NurMgHRComm).GetCurrentWard(perid,date)
	...q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	...s id="" f  s id=$O(^DHCNMG.Intern.MgScoreI("DateWardStu",date,wardid,perid,id)) q:id=""  d
	....s obj=##class(DHCNMG.Intern.MgScore).%OpenId(id)
	....q:'$IsObject(obj)
	....q:obj.ScoreFlag="N"
	....s tmp($tr(perid," ",""),wardid)=obj.ScoreScore
	....s tmpPer($tr(perid," ",""))=""
	s id="" f  s id=$O(^DHCNMG.Intern.MgScoreStaD(id)) q:id=""  d
	.s StaObj=##class(DHCNMG.Intern.MgScoreSta).%OpenId(id)
	.q:'$IsObject(StaObj)
	.i $d(tmpPer(StaObj.ScoreStaStu)) d
	..s tmpPer(StaObj.ScoreStaStu)="^ScoreStaTheory|"_StaObj.ScoreStaTheory_"^ScoreStaOperation|"_StaObj.ScoreStaOperation_"^ScoreStaMidterm|"_StaObj.ScoreStaMidterm_"^ScoreStaTerm|"_StaObj.ScoreStaTerm
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(StaObj.ScoreStaStu)
	.q:'$IsObject(perObj)
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(StaObj.ScoreStaStu,StaObj.ScoreStaDate)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.q:(stdate'="")&&(stdate>StaObj.ScoreStaDate)
	.q:(enddate'="")&&(enddate<StaObj.ScoreStaDate)
	.i '$d(tmpPer(StaObj.ScoreStaStu)) d
	..s tmpPer(StaObj.ScoreStaStu)="^ScoreStaTheory|"_StaObj.ScoreStaTheory_"^ScoreStaOperation|"_StaObj.ScoreStaOperation_"^ScoreStaMidterm|"_StaObj.ScoreStaMidterm_"^ScoreStaTerm|"_StaObj.ScoreStaTerm
	
	;数据返回
	s perid="" f  s perid=$O(tmpPer(perid)) q:perid=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(perObj)
	.s ret="PerNo|"_perObj.PerNo_"^PerName|"_perObj.PerName_tmpPer(perid)
	.s num=0,score=0,avg=0
	.s wardid=""  f  s wardid=$O(tmp(perid,wardid)) q:wardid=""  d
	..s ret=ret_"^"_wardid_"|"_tmp(perid,wardid)
	..s num=num+1
	..s score=score+tmp(perid,wardid)
	.i num'=0 d
	..s avg=$fn((score/num),"",2)
	..s score=$fn(score,"",2)
	.s:$p(avg,".")="" avg=0_avg
	.s ret=ret_"^average|"_avg_"^score|"_score
	.d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutputScoreDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutputScoreDataExecute ]
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

ClassMethod FindOutputScoreDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutputScoreDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// Description:获取离职原因
/// 
ClassMethod GetResignReason(parr As %String) As %String
{
	w "["
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s n=0
	s code="" f  s code=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
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
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s code="" f  s code=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s tmp(Obj.SubDesc)=0
	s date="" f  s date=$O(^DHCNMG.HR.MgNurseResignI("type"," "_type,date)) q:date=""  d
	.q:date<0
	.q:(($p($zd(date,3),"-",1))'=($p(year,"-",1)))
	.s row="" f  s row=$O(^DHCNMG.HR.MgNurseResignI("type"," "_type,date,row)) q:row=""  d
	..s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(row)
	..q:'$IsObject(obj)
	..q:obj.ResignReStatus'=ResignReStatus
	..s reasons=obj.ResignReason
	..i reasons["~"  s len=$l(reasons,"~")
	..e  i reasons["," s len=$l(reasons,",")
	..e  s len=0
	..f i=1:1:len d
	...i reasons["~" s itm=$p(reasons,"~",i)
	...e  i reasons["," s itm=$p(reasons,",",i)
	...q:itm=""
	...s desc=##class(web.NurMgPersonComm).GetCommCode(itm)
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
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindInternTeacher","")
Query FindInternTeacher(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInternTeacherExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.q:obj.PerTypeDR'="N"
	.s PerName=obj.PerName
	.s NameSpell=##class(web.NurMgVueComm).ToChineseSpell(PerName)
	.q:((parr'="")&&((NameSpell_PerName)'[$zcvt($tr(parr," ",""),"U")))
	.s Sub="" f  s Sub=$o(^DHCNMG.HR.MgNurRoleI("ssid",RowID,Sub)) q:Sub=""  d
	..s SubObj=##class(DHCNMG.HR.MgNurRole).%OpenId(Sub)
	..s RoleDesc=..GetRoleDesc(SubObj.RoleID)
	..q:RoleDesc'="带教老师"
	..q:(SubObj.RoleEndDate'="")&&(SubObj.RoleEndDate<+$H)
	..s ret="PerName|"_PerName_"^rowid|"_RowID_"^spell|"_NameSpell
	..d OutputInternTeacher
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
	s obj=##class(DHCNMG.Set.MgRoles).%OpenId(id)
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
		.s perDR=$O(^DHCNMG.HR.MgPersonsI("PerNo"," "_tperNo,""))
		.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perDR)
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
		.s wardDR1=$O(^DHCNMG.DB.MgWardI("Code"," "_ward1,""))
		.s wardDR2=""
		.s:ward2'="" wardDR2=$O(^DHCNMG.DB.MgWardI("Code"," "_$zcvt($tr(ward2," ",""),"U"),""))
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
/// Others:w ##class(web.NurMgInternComm).IsInternTranImport()
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
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindInternImportData","")
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
/// Others:w ##class(web.NurMgInternComm).SaveInternImport(0,0)
ClassMethod SaveInternImport(role As %String = "", nurseid As %String = "") As %String
{
	q:$d(^NurMgIImportData("error")) "存在错误数据,导入失败"
	q:'$d(^NurMgIImportData) "不存在可保存数据"
	q:(role="")||(nurseid="") "未获取登录人员信息,请刷新重试"
	s obj=##class(DHCNMG.Intern.MgTransPlan).%New()
	s obj.PlanCrtDate=+$h
	s obj.PlanCrtTime=$P($h,",",2)
	s obj.PlanStatus="N"
	s obj.PlanEditDate=+$h
	s obj.PlanEditTime=$P($h,",",2)
	s nowDate=+$h,nowTime=$zt($p($h,",",2))
	s obj.PlanCode=$zd(nowDate,8)_$p(nowTime,":")_$p(nowTime,":",2)
	s obj.PlanDesc=$g(^NurMgIImportData("PlanDesc"))
	i $g(nurseid)'=0 d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
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
	.d ##class(web.NurMgVueComm).SplitStr(tGroup,"^","|",.tTmpGroup)
	.s groupObj=##class(DHCNMG.Intern.MgTransPlanGroup).%New()
	.s groupObj.PlanDR=obj
	.s groupObj.GroupCode=$g(tTmpGroup("GroupCode"))
	.s groupObj.GroupDesc=$g(tTmpGroup("GroupDesc"))
	.i $g(tTmpGroup("GroupMaster"))'="" d
	..s groupObj.GroupMaster=##Class(DHCNMG.HR.MgPersons).%OpenId(tTmpGroup("GroupMaster"))
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
	.s timeObj=##class(DHCNMG.Intern.MgTransPlanTime).%New()
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
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardDR)
	...s perDRs=$g(^NurMgIImportData("data",group,date,wardDR))
	...q:perDRs=""
	...f i=1:1:$l(perDRs,",") q:flag=0  d
	....s perDR=$p(perDRs,",",i)
	....q:perDR=""
	....s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perDR)
	....q:'$IsObject(perObj)
	....s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%New()
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

/// Creator:lulin
/// Description:查询量化评分实习生列表
/// Date:2017-09-02
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindScoreInternList","")
Query FindScoreInternList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreInternListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp="",tmpward=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s planid="" f  s planid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanWard",planid)) q:planid=""  d
	.q:+planid=""
	.s wardid="" f  s wardid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanWard",planid,wardid)) q:wardid=""  d
	..q:+wardid=0
	..q:((isAll=0)&&('$d(tmpWard(wardid))))
	..s subid="" f  s subid=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanWard",planid,wardid,subid)) q:subid=""  d
	...s obj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subid)
	...q:'$IsObject(obj)
	...q:'$IsObject(obj.PlanPerDR)
	...q:'$IsObject(obj.PlanTimeDR)
	...q:obj.PlanDR.PlanStatus'="S"
	...s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PlanPerDR.PerStatus)
	...q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	...q:(obj.PlanTimeDR.PlanEndDate'="")&&(obj.PlanTimeDR.PlanEndDate>$h)
	...q:$d(tmp(obj.PlanPerDR.%Id()))
	...s tmp(obj.PlanPerDR.%Id())=obj.PlanPerDR.%Id()
	...s ret="PerDR|"_obj.PlanPerDR.%Id()_"^PerName|"_obj.PlanPerDR.PerName
	...d OutScoreInternList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreInternList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreInternListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreInternListExecute ]
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

ClassMethod FindScoreInternListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreInternListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 
/// CreatDate: 2017-09-02
/// Description: 获取实习生数据
/// Table：DHCNMG.HR.MgPersons
/// Input：
/// Return： 
ClassMethod GetInternData(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s internrowid=$o(^DHCNMG.HR.MgInternI("ssid",id,""))
	if internrowid'=""
	{
		s ret=..GetValue(internrowid)_"^isPerson|0"
	}
	else
	{
		s PerName=obj.PerName
		s PerSexDR=obj.PerSexDR
		i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
		e  s PerBirthday=""
		s PerNo=""
		s PerType=""
		s PerCardId=obj.PerCardId
		s PerNativePlace=obj.PerNativePlace
		s PerDepDR=obj.PerDepDR
		i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
		e  s PerDepDate=""
		i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
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

/// Creator:gzj
/// Date:2019-06-10
/// Description:实习转学员、助护
/// Table:
/// Input:
/// Output:
/// Other:
/// Return:
ClassMethod ConvertStudent(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=1
	s perNo=$tr(tmp("PerNo")," ","")
	s RowID=$g(tmp("RowID"))
	s rw=$o(^DHCNMG.HR.MgPersonsI("PerNo"," "_perNo,""))
	i ((rw'="")&&(rw'=tmp("RowID"))) q:"此编号已经存在！"
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	q:'$IsObject(obj) 0
	s obj.PerTypeDR=$g(tmp("PerType"))
	s obj.PerNo=$g(perNo)
	i $g(tmp("PerComeDate"))'="" s obj.PerComeDate=$zdh($g(tmp("PerComeDate")),3)
	s obj.PerDepDR=$g(tmp("PerDepDR"))
	i $g(tmp("PerDepDate"))'="" s obj.PerDepDate=$zdh($g(tmp("PerDepDate")),3)
	s obj.PerNation=$g(tmp("PerNation"))
	s obj.PerNativePlace=$g(tmp("PerNativePlace"))
	s obj.PerPolitical=$g(tmp("PerPolitical"))
	s obj.PerMarriage=$g(tmp("PerMarriage"))
	s obj.PerHeight=$g(tmp("PerHeight"))
	s obj.PerWeight=$g(tmp("PerWeight"))
	s obj.PerPhone=$g(tmp("PerPhone"))
	s obj.PerAddress=$g(tmp("PerAddress"))
	s obj.PerContact=$g(tmp("PerContact"))
	s obj.PerContactPhone=$g(tmp("PerContactPhone"))
	s obj.PerHobby=$g(tmp("PerHobby"))
	s obj.PerStatus="17||1"
	ts
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		s transRowID=$O(^DHCNMG.HR.MgTransDepI("flag"," Y"," "_obj.%Id()," "_obj.PerDepDR,""))
		i transRowID="" d
		.s perdepdate=+$h
		.i $g(tmp("PerDepDate"))'="" s perdepdate=$zdh($g(tmp("PerDepDate")),3)
		.s TransObj=##class(DHCNMG.HR.MgTransDep).%New()
		.s TransObj.PerDr=$g(tmp("RowID"))
		.s TransObj.PerDepart=$g(tmp("PerDepDR"))
		.s TransObj.PerTranStDate=perdepdate
		.s TransObj.PerTranStTime=$zth("00:00:00",1)
		.s TransObj.PerTranCurrent="Y"
		.s TransObj.PerTransType="L"
		.s TransSc=TransObj.%Save()
		.s flag=($$$ISOK(TransSc)&&(flag))
		e  d
		.s TransOld=##class(DHCNMG.HR.MgTransDep).%OpenId(transRowID)
		.s TransOld.PerTranEndDate=perdepdate
		.s TransOld.PerTranEndTime=$zth("00:00:00",1)
		.s TransOld.PerTranCurrent="N"
		.s oldSc=TransOld.%Save()
		.s flag=($$$ISOK(oldSc)&&flag)
		.i flag=1 d
		..s TransNew=##class(DHCNMG.HR.MgTransDep).%New()
		..s TransNew.PerDr=$g(tmp("RowID"))
		..s TransNew.PerDepart=$g(tmp("PerDepDR"))
		..s TransNew.PerTranStDate=perdepdate
		..s TransNew.PerTranStTime=$zth("00:00:00",1)
		..s TransNew.PerTranCurrent="Y"
		..s TransNew.PerTransType="L"
		..s NewSc=TransNew.%Save()
		..s flag=($$$ISOK(NewSc)&&flag)
		
	}
	i flag=1 tc
	e  tro
	q flag
}

/// 
/// Description:获取退休原因
/// d ##class(web.NurMgInternComm).GetRetireReason("退休原因")
ClassMethod GetRetireReason(parr As %String) As %String
{
	w "["
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s n=0
	s code="" f  s code=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s n=n+1
	..i n=1 w """"_Obj.SubDesc_""""
	..e  w ","""_Obj.SubDesc_""""
	w "]"
	q ""
}

/// Creator: gyg
/// CreatDate: 2019-09-06
/// Description: 审核退休
/// Table：DHCNMG.HR.MgNurseResign
/// Input：d ##class(web.NurMgInternComm).CheckRetireRec(5,"","Y","")
/// Return：
ClassMethod CheckRetireRec(parr As %String) As %String
{
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s obj=##class(DHCNMG.HR.MgNurseResign).%New()
	
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
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignName.%Id())
	s perObj.PerStatus="17||2"
	s perObj.PerStateDate=obj.ResignDate
	s perObj.PerStatuReason=obj.ResignReason
	i perObj.PerTypeDR="P" s perObj.PerCategroy="34||2"
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

/// d ##class(web.NurMgInternComm).GetResignData("退休原因","2019-01-01","N")
ClassMethod GetRetireData(parr As %String, year As %String, type As %String) As %String
{
	q:year="" ""
	s tmp=""
	i (parr="离职原因") s ResignReStatus="E"
	e  s ResignReStatus="R"
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(parr," ",""),"U"),""))
	q:Par="" ""
	s code="" f  s code=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code)) q:code=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par,code,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(Par_"||"_RowID)
	..s tmp(Obj.SubDesc)=0
	s date="" f  s date=$O(^DHCNMG.HR.MgNurseResignI("type"," "_type,date)) q:date=""  d
	.q:(($p($zd(date,3),"-",1))'=($p(year,"-",1)))
	.s row="" f  s row=$O(^DHCNMG.HR.MgNurseResignI("type"," "_type,date,row)) q:row=""  d
	..s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(row)
	..q:obj.ResignReStatus'=ResignReStatus
	..s reasons=obj.ResignReason
	..s len=$l(reasons,"~")
	..f i=1:1:len d
	...s itm=$p(reasons,"~",i)
	...q:itm=""
	...s desc=##class(web.NurMgPersonComm).GetCommCode(itm)
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
/// Table:DHCNMG.HR.MgNurseResign
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgInternComm","FindRetireLists","")
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
	
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.MgNurseResignI("type"," "_nursetype,date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurseResignI("type"," "_nursetype,date,rowid)) q:rowid=""  d
	
	..s obj=##class(DHCNMG.HR.MgNurseResign).%OpenId(rowid)
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
	...s WardStr=##class(web.NurMgDBComm).GetWard(obj.ResignWard)
	...s resignWard=$p($p(WardStr,"^",3),"|",2)
	..e  s resignWard=""
	..i obj.ResignDate'="" s resignDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ResignDate)
	..e  s resignDate=""
	..i nursetype="P" s resignReason=obj.ResignReason
	..e  i nursetype="N" s resignReason=..GetReason(obj.ResignReason)
	..e  s resignReason=""
	..s creater=""
	..i obj.ResignCreater'="" d
	...i obj.ResignCreater=0 s creater="管理员"
	...e  d
	....s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ResignCreater)
	....q:'$IsObject(nurseobj)
	....s creater=nurseobj.PerName
	..i obj.CreateDate'="" s createDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
	..e  s createDate=""
	..s updateUser=""
	..i obj.UpdateUser=0 d
	...s updateUser="管理员"
	..e  d
	...s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.UpdateUser)
	...q:'$IsObject(perobj)
	...s updateUser=perobj.PerName
	..i obj.ResignUpdate'="" s resignUpdate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ResignUpdate)
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

}
