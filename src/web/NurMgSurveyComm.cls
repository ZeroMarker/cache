/// creator: xbl
/// createdate: 20171009
/// description: 调查管理
Class web.NurMgSurveyComm Extends %RegisteredObject
{

/// creator: xbl
/// createdate: 20171009
/// description: 保存护士调查
/// table: DHCNMG.Survey.MgNurSurvey
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgSurveyComm).SaveNurSurvey("SurveyCode|201710091646^SurveyDesc|测试^SurveyContent|2^SurveyFormDR|12__1^SurveyLimitType|A^SurveyLimit|1^SurveyStDate|2017-10-01^SurveyEndDate|2017-10-31^SurveyRemark|测试^SurveyCrtUser|^SurveyCrtDate|2017-10-09^SurveyCrtTime|16:46^rw|^")
ClassMethod SaveNurSurvey(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Survey.MgNurSurvey).%New()
	.s obj.SurveyCrtDate=+$h
	.s obj.SurveyCrtTime=$P($h,",",2)
	.s obj.SurveyStatus="N"
	s obj.SurveyCode=$g(tmp("SurveyCode"))
	s obj.SurveyDesc=$g(tmp("SurveyDesc"))
	i $g(tmp("SurveyContent"))'="" d
	.s obj.SurveyContent=##class(DHCNMG.DB.MgSurveyItem).%OpenId(tmp("SurveyContent"))
	e  s obj.SurveyContent=""
	i $g(tmp("SurveyFormDR"))'="" d
	.s obj.SurveyFormDR=##class(DHCNMG.Set.MgSysParamSub).%OpenId(tmp("SurveyFormDR"))
	e  s obj.SurveyFormDR=""
	s obj.SurveyLimitType=$g(tmp("SurveyLimitType"))
	d obj.SurveyLimit.Clear()
	i $g(tmp("SurveyLimit"))'="" d
	.f i=1:1:$L(tmp("SurveyLimit"),",") d
	..s limit=$P(tmp("SurveyLimit"),",",i)
	..q:limit=""
	..d obj.SurveyLimit.Insert(limit)
	i $g(tmp("SurveyStDate"))'="" s obj.SurveyStDate=$zdh(tmp("SurveyStDate"),3)
	e  s obj.SurveyStDate=""
	i $g(tmp("SurveyEndDate"))'="" s obj.SurveyEndDate=$zdh(tmp("SurveyEndDate"),3)
	e  s obj.SurveyEndDate=""
	s obj.SurveyRemark=$g(tmp("SurveyRemark"))
	i $g(tmp("SurveyCrtUser"))'="" d
	.s obj.SurveyCrtUser=$g(tmp("SurveyCrtUser"))
	e  s obj.SurveyCrtUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20171009
/// description: 获取调查任务
/// table: DHCNMG.Survey.MgNurSurvey
/// input:
/// output:
/// return:
/// other:
ClassMethod GetNurSurvey(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^SurveyCode|"_obj.SurveyCode
	s ret=ret_"^SurveyDesc|"_obj.SurveyDesc
	i obj.SurveyContent'="" d
	.s ret=ret_"^SurveyContent|"_obj.SurveyContent.%Id()
	.s ret=ret_"^ContentDesc|"_obj.SurveyContent.ItemDesc
	i obj.SurveyFormDR'="" d
	.s ret=ret_"^SurveyFormDR|"_$tr(obj.SurveyFormDR.%Id(),"||","__")
	.s ret=ret_"^FormDesc|"_obj.SurveyFormDR.SubDesc
	s ret=ret_"^SurveyLimitType|"_obj.SurveyLimitType
	s ret=ret_"^LimitTypeDesc|"_$case(obj.SurveyLimitType,"A":"片区","L":"科室","W":"病区","R":"角色")
	s limits="",limitdesc=""
	f i=1:1:obj.SurveyLimit.Count() d
	.s limit=obj.SurveyLimit.GetAt(i)
	.q:limit=""
	.s limits=limits_limit_","
	.i obj.SurveyLimitType="A" d
	..s lmtobj=##Class(DHCNMG.DB.MgWardArea).%OpenId(limit)
	..s limitdesc=limitdesc_lmtobj.AreaDesc_","
	.i obj.SurveyLimitType="L" d
	..s lmtobj=##class(DHCNMG.DB.MgWardLoc).%OpenId(limit)
	..s limitdesc=limitdesc_lmtobj.LocDesc_","
	.i obj.SurveyLimitType="W" d
	..s lmtobj=##class(DHCNMG.DB.MgWard).%OpenId(limit)
	..s limitdesc=limitdesc_lmtobj.WardDesc_","
	.i obj.SurveyLimitType="R" d
	..s lmtobj=##class(DHCNMG.Set.MgRoles).%OpenId(limit)
	..s limitdesc=limitdesc_lmtobj.RoleDesc_","
	s ret=ret_"^SurveyLimit|"_$E(limits,1,$L(limits)-1)
	s ret=ret_"^LimitDesc|"_$E(limitdesc,1,$L(limitdesc)-1)
	i obj.SurveyStDate'="" s ret=ret_"^SurveyStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SurveyStDate)
	i obj.SurveyEndDate'="" s ret=ret_"^SurveyEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SurveyEndDate)
	s ret=ret_"^SurveyRemark|"_obj.SurveyRemark
	s ret=ret_"^SurveyStatus|"_obj.SurveyStatus
	s ret=ret_"^StatusDesc|"_$case(obj.SurveyStatus,"N":"未发布","Y":"已发布",:"")
	i obj.SurveyCrtUser'="" d
	.s ret=ret_"^SurveyCrtUser|"_obj.SurveyCrtUser
	.s CrtUserName="管理员"
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.SurveyCrtUser)
	.i $IsObject(perObj) s CrtUserName=perObj.PerName
	.s ret=ret_"^CrtUserName|"_CrtUserName
	i obj.SurveyCrtDate'="" s ret=ret_"^SurveyCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SurveyCrtDate)
	i obj.SurveyCrtTime'="" s ret=ret_"^SurveyCrtTime|"_$zt(obj.SurveyCrtTime,2)
	q ret
}

/// creator: xbl
/// createdate: 20171009
/// description: 删除调查任务
/// table: DHCNMG.Survey.MgNurSurvey
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteNurSurvey(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Survey.MgNurSurvey).%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20171009
/// description: 删除调查任务
/// table: DHCNMG.Survey.MgNurSurvey
/// input:
/// output:
/// return:
/// other:
ClassMethod SendNurSurvey(id As %String, status As %String) As %String
{
	q:(id="")!(status="") 0
	s obj=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(id)
	s obj.SurveyStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20171009
/// description: 获取调查任务列表
/// table: DHCNMG.Survey.MgNurSurvey
/// input:
/// output:
/// return:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgSurveyComm","FindNurSurvey","")
Query FindNurSurvey(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurSurveyExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s content=$tr($P(parr,"^",1),"__","||")
	s stdate=$P(parr,"^",2)
	i stdate["-" s stdate=$zdh(stdate,3)
	e  s stdate=""
	s enddate=$P(parr,"^",3)
	i enddate["-" s enddate=$zdh(enddate,3)
	e  s enddate=""
	k tmpward
	s isAll=0,tmpward=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpward)
	s id="" f  s id=$O(^DHCNMG.Survey.MgNurSurveyD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(id)
	.q:(content'="")&&(obj.SurveyContent'="")&&(obj.SurveyContent.%Id()'=content)
	.q:(stdate'="")&&(obj.SurveyEndDate'="")&&(stdate>obj.SurveyEndDate)
	.q:(enddate'="")&&(obj.SurveyStDate'="")&&(enddate<obj.SurveyStDate)
	.s isExist=1
	.i isAll=0 d
	..i obj.SurveyLimitType="W" d
	...f i=1:1:obj.SurveyLimit.Count() q:isExist=0  d
	....i $d(tmpward(obj.SurveyLimit.GetAt(i))) s isExist=0
	..e  i obj.SurveyLimitType="A" d
	...f i=1:1:obj.SurveyLimit.Count() q:isExist=0  d
	....s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardI("Area",obj.SurveyLimit.GetAt(i),wardid)) q:(wardid="")||(isExist=0)  d
	.....q:wardid=""
	.....i $d(tmpward(wardid)) s isExist=0
	..e  i obj.SurveyLimitType="L" d
	...f i=1:1:obj.SurveyLimit.Count() q:isExist=0  d
	....s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardLocUnitI("Loc",obj.SurveyLimit.GetAt(i),wardid)) q:(wardid="")||(isExist=0)  d
	.....q:wardid=""
	.....i $d(tmpward(wardid)) s isExist=0
	..e  i obj.SurveyLimitType="R" d
	...f i=1:1:obj.SurveyLimit.Count() q:isExist=0  d
	....s tRole=obj.SurveyLimit.GetAt(i)
	....s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(tRole)
	....q:'$IsObject(roleObj)
	....i ("^"_$zcvt(role,"U"))[("^"_$zcvt(roleObj.RoleCode,"U")) i isExist=0
	.e  s isExist=0
	.q:isExist=1
	.s ret=..GetNurSurvey(id)
	.d OutNurSurvey
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurSurvey
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurSurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurSurveyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurSurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurSurveyExecute ]
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
/// createdate: 20171010
/// description: 保存护士满意度调查记录
/// table: DHCNMG.Survey.MgNurSurveyList
/// input:
/// output:
/// return:
/// other:
ClassMethod SavePerNurSurvey(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s surid=$g(tmp("SurveyDR")) 
	s perdr=$g(tmp("SurveyPerDR"))
	q:(surid="")!(perdr="") 0
	i id="" s id=$O(^DHCNMG.Survey.MgNurSurveyListI("SurveyPerson",surid,perdr,""))
	i id'="" d
	.s obj=##class(DHCNMG.Survey.MgNurSurveyList).%OpenId(id)
	e  d
	.s obj=##class(DHCNMG.Survey.MgNurSurveyList).%New()
	.s obj.SurveyStatus="N"
	.s obj.SurveyCrtDate=+$h
	.s obj.SurveyCrtTime=$P($h,",",2)
	i $g(tmp("SurveyDR"))'="" d
	.s obj.SurveyDR=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(surid)
	e  s obj.SurveyDR=""
	i $g(tmp("SurveyPerDR"))'="" d
	.s obj.SurveyPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	e  s obj.SurveyPerDR=""
	i $g(tmp("SurveyWardDR"))'="" d
	.s obj.SurveyWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("SurveyWardDR"))
	e  s obj.SurveyWardDR=""
	s obj.SurveyScore=$g(tmp("SurveyScore"))
	s obj.SurveySuggest=$g(tmp("SurveySuggest"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20171010
/// description: 获取护士满意度调查记录
/// table: DHCNMG.Survey.MgNurSurveyList
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPerNurSurvey(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Survey.MgNurSurveyList).%OpenId(id)
	s ret="rw|"_id
	i obj.SurveyDR'="" d
	.s ret=ret_"^SurveyDR|"_obj.SurveyDR.%Id()
	.s ret=ret_"^SurveyDesc|"_obj.SurveyDR.SurveyDesc
	.i obj.SurveyDR.SurveyContent'="" d
	..s ret=ret_"^SurveyContent|"_obj.SurveyDR.SurveyContent.%Id()
	i obj.SurveyPerDR'="" d
	.s ret=ret_"^SurveyPerDR|"_obj.SurveyPerDR.%Id()
	.s ret=ret_"^PerName|"_obj.SurveyPerDR.PerName
	i obj.SurveyWardDR'="" d
	.s ret=ret_"^SurveyWardDR|"_obj.SurveyWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.SurveyWardDR.WardDesc
	s ret=ret_"^SurveyScore|"_obj.SurveyScore
	s ret=ret_"^SurveyStatus|"_obj.SurveyStatus
	s ret=ret_"^StatusDesc|"_$case(obj.SurveyStatus,"N":"草稿","Y":"已提交",:"")
	i obj.SurveyCrtDate'="" s ret=ret_"^SurveyCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SurveyCrtDate)
	i obj.SurveyCrtTime'="" s ret=ret_"^SurveyCrtTime|"_$zt(obj.SurveyCrtTime,1)
	s ret=ret_"^SurveySuggest|"_obj.SurveySuggest
	q ret
}

/// creator: xbl
/// createdate: 20171010
/// description: 获取护士满意度调查记录
/// table: DHCNMG.Survey.MgNurSurveyList
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPerNurSurvey2(surid As %String, perdr As %String) As %String
{
	q:(surid="")!(perdr="") ""
	s id=$O(^DHCNMG.Survey.MgNurSurveyListI("SurveyPerson",surid,perdr,""))
	q:id="" ""
	s ret=..GetPerNurSurvey(id)
	q ret
}

/// creator: xbl
/// createdate: 20171010
/// description: 删除护士满意度调查记录
/// table: DHCNMG.Survey.MgNurSurveyList
/// input:
/// output:
/// return:
/// other:
ClassMethod DeletePerNurSurvey(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Survey.MgNurSurveyList).%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20171010
/// description: 删除护士满意度调查记录
/// table: DHCNMG.Survey.MgNurSurveyList
/// input:
/// output:
/// return:
/// other:
ClassMethod SubmitPerNurSurvey(id As %String, status As %String) As %String
{
	q:(id="")!(status="") 0
	s obj=##class(DHCNMG.Survey.MgNurSurveyList).%OpenId(id)
	s obj.SurveyStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20171010
///  description: 获取护士满意度调查记录
///  table: DHCNMG.Survey.MgNurSurveyList
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgSurveyComm","FindPerNurSurvey","1^^N")
Query FindPerNurSurvey(parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerNurSurveyExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s surid=$P(parr,"^",1)
	s ward=$P(parr,"^",2)
	s type=$P(parr,"^",3)
	s nurse=$p(parr,"^",4)
	i surid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tmp=""
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	i type="" s type="W"
	s perdr="" f  s perdr=$O(^DHCNMG.Survey.MgNurSurveyListI("SurveyPerson",surid,perdr)) q:perdr=""  d
	.s id="" f  s id=$O(^DHCNMG.Survey.MgNurSurveyListI("SurveyPerson",surid,perdr,id)) q:id=""  d
	..s obj=##class(DHCNMG.Survey.MgNurSurveyList).%OpenId(id)
	..q:(ward'="")&&(obj.SurveyWardDR'="")&&(obj.SurveyWardDR.%Id()'=ward)
	..q:(isAll=0)&&((obj.SurveyWardDR="")||('$d(tmpWard(obj.SurveyWardDR.%Id()))))
	..q:'$IsObject(obj.SurveyPerDR)
	..s name=obj.SurveyPerDR.PerName
	..s perId=obj.SurveyPerDR.PerID
	..s shell=##class(web.NurMgVueComm).ToChineseSpell(name)
	..q:(name_perId_shell)'[nurse
	..i type="N" d
	...s ret=..GetPerNurSurvey(id)
	...d OutNurSurvey
	..i type="W" d
	...q:obj.SurveyWardDR=""
	...s tmp(obj.SurveyWardDR.%Id(),"Num")=+$g(tmp(obj.SurveyWardDR.%Id(),"Num"))+1
	...s tmp(obj.SurveyWardDR.%Id(),"Score")=+$g(tmp(obj.SurveyWardDR.%Id(),"Score"))+obj.SurveyScore
	i type="W" d
	.s ward="" f  s ward=$O(tmp(ward)) q:ward=""  d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	..q:+$g(tmp(obj.SurveyWardDR.%Id(),"Num"))=0
	..s score=$fn(+$g(tmp(obj.SurveyWardDR.%Id(),"Score"))/$g(tmp(obj.SurveyWardDR.%Id(),"Num")),"",1)
	..s ret="SurveyWardDR|"_ward_"^WardDesc|"_wardObj.WardDesc_"^SurveyScore|"_score
	..d OutNurSurvey
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurSurvey
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerNurSurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerNurSurveyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerNurSurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerNurSurveyExecute ]
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
///  createdate: 20171010
///  description: 保存护士满意度调查评分明细
///  table: DHCNMG.Survey.MgNurSurveySub
///  input:
///  output:
///  return:
///  other:
ClassMethod SaveNurSurveySub(parr As %String, index As %String) As %String
{
	q:(parr="")!(index="") 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s parid=$g(tmp("Parref"))
	s itmdr=$g(tmp("SurveyItemDR"))
	q:(parid="")!(itmdr="") 0
	i id="" s id=$O(^DHCNMG.Survey.MgNurSurveySubI("Item",itmdr,parid,""))
	i id'="" d
	.s obj=##class(DHCNMG.Survey.MgNurSurveySub).%OpenId(id)
	e  d
	.s obj=##class(DHCNMG.Survey.MgNurSurveySub).%New()
	.s obj.Parref=##class(DHCNMG.Survey.MgNurSurveyList).%OpenId(parid)
	.s obj.SurveyItemDR=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(itmdr)
	i $g(tmp("SurveyScoreDR"))'="" d
	.s obj.SurveyScoreDR=##class(DHCNMG.DB.MgSurveyStandard).%OpenId(tmp("SurveyScoreDR"))
	e  s obj.SurveyScoreDR=""
	s sc=obj.%Save()
	q index
}

///  creator: xbl
///  createdate: 20171010
///  description: 获取护士满意度调查评分明细
///  table: DHCNMG.Survey.MgNurSurveySub
///  input:
///  output:
///  return:
///  other:
ClassMethod GetNurSurveySub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"_","|")
	s obj=##class(DHCNMG.Survey.MgNurSurveySub).%OpenId(id)
	s ret="rw|"_$tr(id,"|","_")
	i obj.SurveyItemDR'="" d
	.s ret=ret_"^SurveyItemDR|"_$tr(obj.SurveyItemDR.%Id(),"|","_")
	.s ret=ret_"^ItemDesc|"_obj.SurveyItemDR.ItemDesc
	i obj.SurveyScoreDR'="" d
	.s ret=ret_"^SurveyScoreDR|"_$tr(obj.SurveyScoreDR.%Id(),"|","_")
	.s ret=ret_"^ScoreDesc|"_obj.SurveyScoreDR.StandardDesc
	q ret
}

///  creator: xbl
///  createdate: 20171011
///  description: 删除护士满意度调查评分明细
///  table: DHCNMG.Survey.MgNurSurveySub
///  input:
///  output:
///  return:
///  other: 
ClassMethod DeleteNurSurveySub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"_","|")
	s sc=##class(DHCNMG.Survey.MgNurSurveySub).%DeleteId(id)
	q $$$ISOK(sc)
}

///   creator: xbl
///   createdate: 20171011
///   description: 获取护士满意度调查评分明细
///   table: DHCNMG.Survey.MgNurSurveySub
///   input:
///   output:
///   return:
///   other: d ##class(%ResultSet).RunQuery("web.NurMgSurveyComm","FindNurSurveySub","1^45","")
Query FindNurSurveySub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurSurveySubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s surid=$P(parr,"^",1)
	s perdr=$P(parr,"^",2)
	i (surid="")!(perdr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s surobj=##class(DHCNMG.Survey.MgNurSurvey).%OpenId(surid)
	i surobj.SurveyContent="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s itmdr=surobj.SurveyContent.%Id()
	s parid=$O(^DHCNMG.Survey.MgNurSurveyListI("SurveyPerson",surid,perdr,""))
	s itmsubid="" f  s itmsubid=$O(^DHCNMG.DB.MgSurveyItemSubD(itmdr,itmsubid)) q:itmsubid=""  d
	.s itmobj=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(itmdr_"||"_itmsubid)
	.s itmdesc=itmobj.ItemDesc
	.s ret="ItemDesc|"_itmdesc_"^SurveyItemDR|"_itmdr_"__"_itmsubid
	.i parid'="" d
	..s subid=$O(^DHCNMG.Survey.MgNurSurveySubI("Item",itmdr_"||"_itmsubid,parid,""))
	..q:subid=""
	..s subobj=##class(DHCNMG.Survey.MgNurSurveySub).%OpenId(parid_"||"_subid)
	..q:subobj.SurveyScoreDR=""
	..s scoredr=$tr(subobj.SurveyScoreDR.%Id(),"||","__")
	..s scoredesc=subobj.SurveyScoreDR.StandardDesc
	..s rw=parid_"__"_subid
	.s ret=ret_"^SurveyScoreDR|"_$g(scoredr)_"^ScoreDesc|"_$g(scoredesc)_"^rw|"_$g(rw)
	.d OutNurSurveySub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurSurveySub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurSurveySubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurSurveySubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurSurveySubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurSurveySubExecute ]
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
/// createdate: 20171016
/// description: 保存病人调查记录
/// table: DHCNMG.Survey.MgPatSurvey
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgSurveyComm).SavePatSurvey("^SurveyItemDR|2^SurveyAdmDR|9^SurveyWardDR|1^SurveyBedDR|10__1^SurveySuggest|^SurveyScore|10^rw|")
ClassMethod SavePatSurvey(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s admid=$g(tmp("SurveyAdmDR"))
	s itmdr=$g(tmp("SurveyItemDR"))
	q:(admid="")!(itmdr="") 0
	i id="" s id=$O(^DHCNMG.Survey.MgPatSurveyI("Patient",admid,itmdr,""))
	i id'="" d
	.s obj=##class(DHCNMG.Survey.MgPatSurvey).%OpenId(id)
	e  d
	.s obj=##class(DHCNMG.Survey.MgPatSurvey).%New()
	.s obj.SurveyCrtDate=+$h
	.s obj.SurveyCrtTime=$P($h,",",2)
	i $g(tmp("SurveyAdmDR"))'="" s obj.SurveyAdmDR=##class(User.PAAdm).%OpenId(tmp("SurveyAdmDR"))
	e  s obj.SurveyAdmDR=""
	i $g(tmp("SurveyWardDR"))'="" s obj.SurveyWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("SurveyWardDR"))
	e  s obj.SurveyWardDR=""
	i $g(tmp("SurveyBedDR"))'="" s obj.SurveyBedDR=##class(User.PACBed).%OpenId(tmp("SurveyBedDR"))
	e  s obj.SurveyBedDR=""
	i $g(tmp("SurveyItemDR"))'="" s obj.SurveyItemDR=##class(DHCNMG.DB.MgSurveyItem).%OpenId(tmp("SurveyItemDR"))
	e  s obj.SurveyItemDR=""
	s obj.SurveyScore=$g(tmp("SurveyScore"))
	s obj.SurveySuggest=$g(tmp("SurveySuggest"))
	i $g(tmp("SurveyCrtUser"))'="" s obj.SurveyCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("SurveyCrtUser"))
	e  s obj.SurveyCrtUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20171016
/// description: 获取病人调查记录
/// table: DHCNMG.Survey.MgPatSurvey
/// input:
/// output:
/// return:
/// other: d ##class(web.NurMgSurveyComm).GetPatSurvey(1)
ClassMethod GetPatSurvey(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Survey.MgPatSurvey).%OpenId(id)
	s ret="rw|"_id
	i obj.SurveyAdmDR'="" d
	.s ret=ret_"^SurveyAdmDR|"_obj.SurveyAdmDR.%Id()
	.i obj.SurveyAdmDR.PAADMPAPMIDR'="" d
	..s ret=ret_"^PatName|"_obj.SurveyAdmDR.PAADMPAPMIDR.PAPMIName
	i obj.SurveyWardDR'="" d
	.s ret=ret_"^SurveyWardDR|"_obj.SurveyWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.SurveyWardDR.WardDesc
	i obj.SurveyBedDR'="" d
	.s ret=ret_"^SurveyBedDR|"_$tr(obj.SurveyBedDR.%Id(),"|","_")
	.s ret=ret_"^BedCode|"_obj.SurveyBedDR.BEDCode
	i obj.SurveyItemDR'="" d
	.s ret=ret_"^SurveyItemDR|"_obj.SurveyItemDR.%Id()
	.s ret=ret_"^ItemDesc|"_obj.SurveyItemDR.ItemDesc
	s ret=ret_"^SurveyScore|"_obj.SurveyScore
	s ret=ret_"^SurveySuggest|"_obj.SurveySuggest
	i obj.SurveyCrtUser'="" d
	.s ret=ret_"^SurveyCrtUser|"_obj.SurveyCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.SurveyCrtUser.PerName
	i obj.SurveyCrtDate'="" s ret=ret_"^SurveyCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SurveyCrtDate)
	i obj.SurveyCrtTime'="" s ret=ret_"^SurveyCrtTime|"_$zt(obj.SurveyCrtTime,2)
	q ret
}

/// creator: xbl
/// createdate: 20171016
/// description: 获取病人调查记录
/// table: DHCNMG.Survey.MgPatSurvey
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPatSurvey2(adm As %String, itm As %String) As %String
{
	q:(adm="")!(itm="") ""
	s id=$O(^DHCNMG.Survey.MgPatSurveyI("Patient",adm,itm,""))
	q:id="" ""
	s ret=..GetPatSurvey(id)
	q ret
}

/// creator: xbl
/// createdate: 20171016
/// description: 删除病人调查记录
/// table: DHCNMG.Survey.MgPatSurvey
/// input:
/// output:
/// return:
/// other:
ClassMethod DeletePatSurvey(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Survey.MgPatSurvey).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20171016
///  description: 获取病人调查列表
///  table: DHCNMG.Survey.MgPatSurvey
///  input:
///  output:
///  return:
///  other: w ##class(%ResultSet).RunQuery("web.NurMgSurveyComm","FindPatSurvey","^^2017-10-01^2017-10-31^","")
Query FindPatSurvey(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatSurveyExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s itmdr=$P(parr,"^",1)
	s warddr=$P(parr,"^",2)
	s stdate=$P(parr,"^",3)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",4)
	s:enddate["-" enddate=$zdh(enddate,3)
	s admid=$P(parr,"^",5)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id="" f  s id=$O(^DHCNMG.Survey.MgPatSurveyD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Survey.MgPatSurvey).%OpenId(id)
	.q:(itmdr'="")&&(obj.SurveyItemDR'="")&&(itmdr'=obj.SurveyItemDR.%Id())
	.q:(warddr'="")&&(obj.SurveyWardDR'="")&&(warddr'=obj.SurveyWardDR.%Id())
	.q:(isAll=0)&&(('$IsObject(obj.SurveyWardDR))||('$d(tmpWard(obj.SurveyWardDR.%Id()))))
	.q:(admid'="")&&(obj.SurveyAdmDR'="")&&(admid'=obj.SurveyAdmDR.%Id())
	.q:((stdate'="")&&(obj.SurveyCrtDate<stdate))||((enddate'="")&&(enddate<obj.SurveyCrtDate))
	.s ret=..GetPatSurvey(id)
	.d OutPatSurvey
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatSurvey
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatSurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatSurveyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatSurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatSurveyExecute ]
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
/// createdate: 20171016
/// description: 保存病人调查明细
/// table: DHCNMG.Survey.MgPatSurveySub
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgSurveyComm).SavePatSurveySub("Parref|5^SurveyItemDR|2__1^SurveyScoreDR|2__1^rw|5__1")
ClassMethod SavePatSurveySub(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s parid=$g(tmp("Parref"))
	s itmdr=$g(tmp("SurveyItemDR"))
	q:(parid="")!(itmdr="") 0
	i id="" s id=$O(^DHCNMG.Survey.MgPatSurveySubI("Item",itmdr,parid,""))
	i id="" d
	.s obj=##Class(DHCNMG.Survey.MgPatSurveySub).%New()
	.s obj.Parref=##Class(DHCNMG.Survey.MgPatSurvey).%OpenId(parid)
	e  s obj=##class(DHCNMG.Survey.MgPatSurveySub).%OpenId(id)
	s obj.SurveyItemDR=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(itmdr)
	i $g(tmp("SurveyScoreDR"))'="" d
	.s obj.SurveyScoreDR=##class(DHCNMG.DB.MgSurveyStandard).%OpenId(tmp("SurveyScoreDR"))
	e  s obj.SurveyScoreDR=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20171016
/// description: 获取病人调查明细
/// table: DHCNMG.Survey.MgPatSurveySub
/// input:
/// output:
/// return:
/// other:
ClassMethod GetPatSurveySub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"_","|")
	s obj=##class(DHCNMG.Survey.MgPatSurveySub).%OpenId(id)
	s ret="rw|"_$tr(id,"|","_")
	i obj.SurveyItemDR'="" d
	.s ret=ret_"^SurveyItemDR|"_$tr(obj.SurveyItemDR.%Id(),"|","_")
	.s ret=ret_"^ItemDesc|"_obj.SurveyItemDR.ItemDesc
	i obj.SurveyScoreDR'="" d
	.s ret=ret_"^SurveyScoreDR|"_$tr(obj.SurveyScoreDR.%Id(),"|","_")
	.s ret=ret_"^ScoreDesc|"_obj.SurveyScoreDR.StandardDesc
	q ret
}

/// creator: xbl
/// createdate: 20171016
/// description: 删除病人调查明细
/// table: DHCNMG.Survey.MgPatSurveySub
/// input:
/// output:
/// return:
/// other:
ClassMethod DeletePatSurveySub(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Survey.MgPatSurveySub).%DeleteId(id)
	q $$$ISOK(sc)
}

///   creator: xbl
///   createdate: 20171011
///   description: 获取病人满意度调查评分明细
///   table: DHCNMG.Survey.MgPatSurveySub
///   input:
///   output:
///   return:
///   other: d ##class(%ResultSet).RunQuery("web.NurMgSurveyComm","FindPatSurveySub","9^2","")
Query FindPatSurveySub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatSurveySubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s admid=$P(parr,"^",1)
	s itmdr=$P(parr,"^",2)
	i (admid="")!(itmdr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s parid=$O(^DHCNMG.Survey.MgPatSurveyI("Patient",admid,itmdr,""))
	s itmsubid="" f  s itmsubid=$O(^DHCNMG.DB.MgSurveyItemSubD(itmdr,itmsubid)) q:itmsubid=""  d
	.s itmobj=##class(DHCNMG.DB.MgSurveyItemSub).%OpenId(itmdr_"||"_itmsubid)
	.s itmdesc=itmobj.ItemDesc
	.s ret="ItemDesc|"_itmdesc_"^SurveyItemDR|"_itmdr_"__"_itmsubid
	.i parid'="" d
	..s subid=$O(^DHCNMG.Survey.MgPatSurveySubI("Item",itmdr_"||"_itmsubid,parid,""))
	..q:subid=""
	..s subobj=##class(DHCNMG.Survey.MgPatSurveySub).%OpenId(parid_"||"_subid)
	..q:subobj.SurveyScoreDR=""
	..s scoredr=$tr(subobj.SurveyScoreDR.%Id(),"||","__")
	..s scoredesc=subobj.SurveyScoreDR.StandardDesc
	..s rw=parid_"__"_subid
	.s ret=ret_"^SurveyScoreDR|"_$g(scoredr)_"^ScoreDesc|"_$g(scoredesc)_"^rw|"_$g(rw)
	.d OutPatSurveySub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatSurveySub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatSurveySubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatSurveySubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatSurveySubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatSurveySubExecute ]
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
