/// creator: xbl
/// createdate: 20180108
/// description: 科室工作安排
Class web.NurMgDeptWork Extends %RegisteredObject
{

/// creator: xbl
/// createdate: 20180108
/// description: 保存培训信息
/// table: DHCNMG.Arg.MgNurTrain
/// input：
/// output:
/// return:
/// other:
ClassMethod SaveNurTrain(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))="" d
	.s obj=##class(DHCNMG.Arg.MgNurTrain).%New()
	.i $g(tmp("TrainCrtUser"))'="" d
	..s crtobj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("TrainCrtUser"))
	..i $IsObject(crtobj) s obj.TrainCrtUser=crtobj
	.e  s obj.TrainCrtUser=""
	e  d
	.s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(tmp("rw"))
	s obj.TrainType=$g(tmp("TrainType"))
	i $g(tmp("TrainWardDR"))'="" d
	.s obj.TrainWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("TrainWardDR"))
	e  s obj.TrainWardDR=""
	s obj.TrainTeacher=$g(tmp("TrainTeacher"))
	s obj.TrainTeaType=$g(tmp("TrainTeaType"))
	i obj.TrainTeaType'=2 d
	.s:obj.TrainTeaType=0 tmp("TrainTeaWardDR")=tmp("TrainWardDR")
	.i $g(tmp("TrainTeaWardDR"))'="" d
	..s obj.TrainTeaWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("TrainTeaWardDR"))
	.e  s obj.TrainTeaWardDR=""
	i obj.TrainTeaType=2 d
	.s obj.TrainTeaName=$g(tmp("TrainTeaName"))
	.s obj.TrainTeaWork=$g(tmp("TrainTeaWork"))
	.s obj.TrainTeaDuty=$g(tmp("TrainTeaDuty"))
	s obj.TrainTitle=$g(tmp("TrainTitle"))
	i $g(tmp("TrainDate"))'="" d
	.s obj.TrainDate=$zdh(tmp("TrainDate"),3)
	e  s obj.TrainDate=""
	s obj.TrainContent=$g(tmp("TrainContent"))
	s sc=obj.%Save()
	q:$$$ISERR(sc) 0
	q obj.%Id()
}

/// creator: xbl
/// createdate: 20180108
/// description: 获取培训记录
/// table: DHCNMG.Arg.MgNurTrain
/// input：
/// output:
/// return:
/// other:
ClassMethod GetNurTrain(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^TrainType|"_obj.TrainType
	s ret=ret_"^TypeDesc|"_$case(obj.TrainType,"N":"开展新技术新业务","B":"业务学习","C":"夜查房培训","T":"教学培训")
	i obj.TrainWardDR'="" d
	.s ret=ret_"^TrainWardDR|"_obj.TrainWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.TrainWardDR.WardDesc
	s ret=ret_"^TrainTeacher|"_obj.TrainTeacher
	s teacher=""
	f i=1:1:$L(obj.TrainTeacher,",") d
	.s perdr=$P(obj.TrainTeacher,",",i)
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.i teacher="" s teacher=perobj.PerName
	.e  s teacher=teacher_","_perobj.PerName
	//s ret=ret_"^TeacherName|"_teacher
	s ret=ret_"^TrainTitle|"_obj.TrainTitle
	i obj.TrainDate'="" s ret=ret_"^TrainDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainDate)
	;s ret=ret_"^TrainContent|"_obj.TrainContent
	s ret=ret_"^TrainStatus|"_obj.TrainStatus
	s ret=ret_"^StatusDesc|"_$case(obj.TrainStatus,"N":"未提交","Y":"已提交",:"")
	i obj.TrainSubmitDate'="" s ret=ret_"^TrainSubmitDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainSubmitDate)
	i obj.TrainSubmitTime'="" s ret=ret_"^TrainSubmitTime|"_$zt(obj.TrainSubmitTime,2)
 	i obj.TrainCrtUser'="" d
	.s ret=ret_"^TrainCrtUser|"_obj.TrainCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.TrainCrtUser.PerName
	e  s ret=ret_"^TrainCrtUser|0^CrtUserName|超级管理员"
	i obj.TrainCrtDate'="" s ret=ret_"^TrainCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrainCrtDate)
	i obj.TrainCrtTime'="" s ret=ret_"^TrainCrtTime|"_$zt(obj.TrainCrtTime,1)
	s ret=ret_"^TrainTeaType|"_obj.TrainTeaType
	s ret=ret_"^TrainTeaTypeDesc|"_$case(obj.TrainTeaType,"0":"本科","1":"科外","2":"院外",:"")
	i obj.TrainTeaWardDR'="" d
	.s ret=ret_"^TrainTeaWardDR|"_obj.TrainTeaWardDR.%Id()
	.s ret=ret_"^TeaWardDesc|"_obj.TrainTeaWardDR.WardDesc
	e  d
	.s ret=ret_"^TrainTeaWardDR|^TeaWardDesc|"
	;s ret=ret_"^TrainTeaName|"_obj.TrainTeaName
	s ret=ret_"^TrainTeaWork|"_obj.TrainTeaWork
	s ret=ret_"^TrainTeaDuty|"_obj.TrainTeaDuty
	i obj.TrainTeaType=2 d
	.s ret=ret_"^TrainTeaName|"_obj.TrainTeaName
	e  d
	.s ret=ret_"^TrainTeaName|"_teacher
	s ret=ret_"^TrainRefer|"_obj.TrainRefer
	q ret
}

ClassMethod GetTrainContent(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
	q obj.TrainContent
}

/// creator: xbl
/// createdate: 20180108
/// description: 删除培训记录
/// table: DHCNMG.Arg.MgNurTrain
/// input：
/// output:
/// return:
/// other:
ClassMethod DeleteNurTrain(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Arg.MgNurTrain).%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20180108
/// description: 提交培训记录
/// table: DHCNMG.Arg.MgNurTrain
/// input：
/// output:
/// return:
/// other: 
ClassMethod SetNurTrain(id As %String, status As %String) As %String
{
	q:(id="")&&(status="") 0
	s obj=##Class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
	s obj.TrainStatus=status
	i status="Y" d
	.s obj.TrainSubmitDate=+$h
	.s obj.TrainSubmitTime=$P($h,",",2)
	e  d
	.s obj.TrainSubmitDate=""
	.s obj.TrainSubmitTime=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20180108
/// description: 获取培训记录列表
/// table: DHCNMG.Arg.MgNurTrain
/// input：
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNurTrain","N","")
Query FindNurTrain(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurTrainExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$P(parr,"^",2)
	s date=$P(parr,"^",3)
	s:date["-" date=$zdh(date,3)
	s status=$P(parr,"^",4)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s admdate="" f  s admdate=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,admdate)) q:admdate=""  d
	.q:(date'="")&&(admdate'=date)
	.s id="" f  s id=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
	..q:(ward'="")&&(obj.TrainWardDR'="")&&(obj.TrainWardDR.%Id()'=ward)
	..q:(isAll=0)&&(('$IsObject(obj.TrainWardDR))||('$d(tmpWard(obj.TrainWardDR.%Id()))))
	..q:(status'="")&&(obj.TrainStatus'=status)
	..s ret=..GetNurTrain(id)
	..d OutNurTrain
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrain
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurTrainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurTrainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainExecute ]
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
/// description: 保存培训信息参加人员成绩
/// table: DHCNMG.Arg.MgNurTrainSub
/// input：
/// output:
/// return:
/// other:
ClassMethod SaveNurTrainSub(parr As %String, parid As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s perdr=$g(tmp("TrainPerDR"))
	q:(parid="")!(perdr="") 0
	;i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCNMG.Arg.MgNurTrainSubI("Person",perdr,parid,""))
	;i $g(tmp("rw"))'="" d
	;.s obj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(tmp("rw"))
	;e  d
	s obj=##class(DHCNMG.Arg.MgNurTrainSub).%New()
	s obj.Parref=##class(DHCNMG.Arg.MgNurTrain).%OpenId(parid)
	s obj.TrainPerDR=##Class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	s obj.TrainScore=$g(tmp("TrainScore"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// w ##class(web.NurMgDeptWork).SaveTrainSubs(^tmpXbl("trainsubs"))
ClassMethod SaveTrainSubs(parr As %String, parid As %String) As %String
{
	s ^tmpXbl("trainsubs")=parr
	q:parid="" 0
	s flag=1
	TStart
	s id="" f  s id=$O(^DHCNMG.Arg.MgNurTrainSubD(parid,id)) q:(id="")||(flag'=1)  d
	.s obj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(parid_"||"_id)
	.q:'$IsObject(obj)
	.s flag=((flag)&&($$$ISOK(obj.%DeleteId(parid_"||"_id))))
	if flag'=1{
		TRO
		q 0	
	}
	f i=1:1:$L(parr,"@") 
	{
		q:flag=0
		s parm=$P(parr,"@",i)
		i parm'=""
		{
			s ret=..SaveNurTrainSub(parm,parid)
			i ret=0 
			{
				s flag=0
				TRollback
			}
		}
	}
	i flag=1 TCommit
	q flag
}

/// createdate: 20180108
/// description: 获取培训信息参加人员成绩
/// table: DHCNMG.Arg.MgNurTrainSub
/// input：
/// output:
/// return:
/// other:
ClassMethod GetNurTrainSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	i obj.TrainPerDR'="" d
	.s ret=ret_"^TrainPerDR|"_obj.TrainPerDR.%Id()
	.i obj.TrainPerDR.PerID'="" s ret=ret_"^PerID|"_obj.TrainPerDR.PerID
	.e  s ret=ret_"^PerID|"_obj.TrainPerDR.PerNo
	.s ret=ret_"^PerName|"_obj.TrainPerDR.PerName
	s ret=ret_"^TrainScore|"_obj.TrainScore
	q ret
}

/// createdate: 20180108
/// description: 删除培训信息参加人员成绩
/// table: DHCNMG.Arg.MgNurTrainSub
/// input：
/// output:
/// return:
/// other:
ClassMethod DeleteNurTrainSub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"__","||")
	s sc=##Class(DHCNMG.Arg.MgNurTrainSub).%DeleteId(id)
	q $$$ISOK(sc)
}

///  createdate: 20180108
///  description: 获取开展新业务新技术记录参加人员成绩列表
///  table: DHCNMG.Arg.MgNurTrainSub
///  input：
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNurTrainSub","1")
Query FindNurTrainSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurTrainSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	i parid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNurTrainSubD(parid,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(parid_"||"_subid)
	.s ret=..GetNurTrainSub(parid_"||"_subid)
	.s ret=ret_"^editFlag|0"
	.d OutNurTrainSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurTrainSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurTrainSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTrainSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurTrainSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTrainSubExecute ]
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

///  createdate: 20180108
///  description: 获取培训信息参加人员成绩列表
///  table: DHCNMG.Arg.MgNurTrainSub
///  input：
///  output:
///  return:
///  other:
Query FindTrainScore(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrainScoreExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$P(parr,"^",2)
	s traindate=$P(parr,"^",3)
	s:traindate["-" traindate=$zdh(traindate,3)
	s perinfo=$P(parr,"^",4)
	s minscore=$P(parr,"^",5)
	s maxscore=$P(parr,"^",6)
	s submitdate=$P(parr,"^",7)
	s:submitdate["-" submitdate=$zdh(submitdate,3)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date)) q:date=""  d
	.s parid="" f  s parid=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date,parid)) q:parid=""  d
	..s parobj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(parid)
	..q:(ward'="")&&((parobj.TrainWardDR="")||(parobj.TrainWardDR.%Id()'=ward))
	..q:(isAll=0)&&(('$IsObject(parobj.TrainWardDR))||('$d(tmpWard(parobj.TrainWardDR.%Id()))))
	..q:(traindate'="")&&(traindate'=parobj.TrainDate)
	..q:(submitdate'="")&&(submitdate'=parobj.TrainSubmitDate)
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgNurTrainSubD(parid,subid)) q:subid=""  d
	...s subobj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(parid_"||"_subid)
	...q:subobj.TrainPerDR=""
	...s perid=subobj.TrainPerDR.PerID
	...i perid="" s perid=subobj.TrainPerDR.PerNo
	...s pername=subobj.TrainPerDR.PerName
	...s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	...q:(perinfo'="")&&($zcvt(perid,"U")'[$zcvt(perinfo,"U"))&&($zcvt(pername,"U")'[$zcvt(perinfo,"U"))&&($zcvt(pershort,"U")'[$zcvt(perinfo,"U"))
	...s score=subobj.TrainScore
	...;q:score=""
	...q:((minscore'="")&&(+minscore>score))||((maxscore'="")&&(+maxscore<score))
	...s ret=..GetNurTrain(parid)_"^"_..GetNurTrainSub(parid_"||"_subid)
	...d OutTrainScore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTrainScore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainScoreExecute ]
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
/// createdate: 20180112
/// description: 保存检查内容维护
/// table: DHCNMG.Arg.MgCheckContent
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveCheckContent(parr As %String) As %String
{
	
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("ContentDesc"))="")||($g(tmp("ContentType"))="") 0
	i $g(tmp("rw"))="" d
	.s tmp("rw")=$O(^DHCNMG.Arg.MgCheckContentI("TypeDesc"," "_$zcvt(tmp("ContentType"),"U")," "_$zcvt(tmp("ContentDesc"),"U"),""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgCheckContent).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgCheckContent).%New()
	s obj.ContentType=tmp("ContentType")
	s obj.ContentDesc=tmp("ContentDesc")
	i $g(tmp("ContentStDate"))'="" s obj.ContentStDate=$zdh(tmp("ContentStDate"),3)
	e  s obj.ContentStDate=""
	i $g(tmp("ContentEndDate"))'="" s obj.ContentEndDate=$zdh(tmp("ContentEndDate"),3)
	e  s obj.ContentEndDate=""
	i $g(tmp("ContentCrtUser"))'="" d
	.s obj.ContentCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ContentCrtUser"))
	e  s obj.ContentCrtUser=""
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// w ##class(web.NurMgDeptWork).SaveCheckContents("rw|^ContentDesc|护理管理^ContentStDate|2018-01-12^ContentEndDate|^ContentCrtUser|@")
ClassMethod SaveCheckContents(parr As %String) As %String
{
	q:parr="" 0
	TStart
	s flag=1
	f i=1:1:$L(parr,"@")
	{
		q:flag=0
		s parm=$P(parr,"@",i)
		continue:parm=""
		s flag=..SaveCheckContent(parm)
	}
	i flag=0 
	{
		TRollback 
		q 0
	}
	TCommit
	q 1
}

/// 获取检查内容
/// 
ClassMethod GetCheckContent(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgCheckContent).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ContentType|"_obj.ContentType
	s ret=ret_"^ContentDesc|"_obj.ContentDesc
	i obj.ContentStDate'="" d
	.s ret=ret_"^ContentStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ContentStDate)
	i obj.ContentEndDate'="" d
	.s ret=ret_"^ContentEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ContentEndDate)
	i obj.ContentCrtUser'="" d
	.s ret=ret_"^ContentCrtUser|"_obj.ContentCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.ContentCrtUser.PerName
	i obj.ContentCrtDate'="" d
	.s ret=ret_"^ContentCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ContentCrtDate)
	i obj.ContentCrtTime'="" d
	.s ret=ret_"^ContentCrtTime|"_$zt(obj.ContentCrtTime,3)
	q ret
}

/// 删除检查内容
ClassMethod DeleteCheckContent(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Arg.MgCheckContent).%DeleteId(id)
	q $$$ISOK(sc)
}

/// 获取检查内容
Query FindCheckContent(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckContentExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s date=$P(parr,"^",1)
	s:date["-" date=$zdh(date,3)
	s type=$P(parr,"^",2)
	s id="" f  s id=$O(^DHCNMG.Arg.MgCheckContentD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgCheckContent).%OpenId(id)
	.q:(type'="")&&(type'=obj.ContentType)
	.s stdate=obj.ContentStDate,enddate=obj.ContentEndDate
	.q:(date'="")&&(((stdate'="")&&(stdate>date))||((enddate'="")&&(enddate<date)))
	.s ret=..GetCheckContent(id)
	.s ret=ret_"^editFlag|0"
	.d OutCheckContent
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckContent
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckContentExecute ]
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
/// createdate: 20180112
/// description: 保存护士长夜查房
/// table: DHCNMG.Arg.MgNurHeadCheck
/// input: 
/// output:
/// return:
/// other:
ClassMethod SaveNHCheck(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%New()
	i $g(tmp("CheckDate"))'="" s obj.CheckDate=$zdh(tmp("CheckDate"),3)
	e  s obj.CheckDate=""
	i $g(tmp("CheckStTime"))'="" s obj.CheckStTime=$zth(tmp("CheckStTime"),2)
	e  s obj.CheckStTime=""
	i $g(tmp("CheckEndTime"))'="" s obj.CheckEndTime=$zth(tmp("CheckEndTime"),2)
	e  s obj.CheckEndTime=""
	d obj.CheckFloor.Clear()
	f i=1:1:$L($g(tmp("CheckFloor")),",") d
	.s floor=$P($g(tmp("CheckFloor")),",",i)
	.q:floor=""
	.d obj.CheckFloor.Insert(floor)
	d obj.CheckWard.Clear()
	f i=1:1:$L($g(tmp("CheckWard")),",") d
	.s ward=$P($g(tmp("CheckWard")),",",i)
	.q:ward=""
	.d obj.CheckWard.Insert(ward)
	;s obj.CheckWardNum=$g(tmp("CheckWardNum"))
	s obj.CheckRecWardNum=$g(tmp("CheckRecWardNum"))
	d obj.CheckContent.Clear()
	f i=1:1:$L($g(tmp("CheckContent")),",") d
	.s itm=$P($g(tmp("CheckContent")),",",i)
	.q:itm=""
	.d obj.CheckContent.Insert(itm)
	s obj.CheckGoodAspect=$g(tmp("CheckGoodAspect"))
	s obj.CheckProblem=$g(tmp("CheckProblem"))
	s obj.CheckSuggest=$g(tmp("CheckSuggest"))
	d obj.CheckUser.Clear()
	f i=1:1:$L($g(tmp("CheckUser")),",") d
	.s perdr=$P($g(tmp("CheckUser")),",",i)
	.q:perdr=""
	.d obj.CheckUser.Insert(perdr)
	i $g(tmp("StatusUser"))'="" d
	.s obj.StatusUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("StatusUser"))
	e  s obj.StatusUser=""
	s obj.StatusRemark=$g(tmp("StatusRemark"))
	i $g(tmp("CheckCrtUser"))'="" d
	.s obj.CheckCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("CheckCrtUser"))
	e  s obj.CheckCrtUser=""
	
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取护士长夜查房检查
/// table: DHCNMG.Arg.MgNurHeadCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod GetNHCheck(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(id)
	s ret="rw|"_id
	i obj.CheckDate'="" d
	.s ret=ret_"^CheckDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckDate)
	i obj.CheckStTime'="" d
	.s ret=ret_"^CheckStTime|"_$zt(obj.CheckStTime,2)
	i obj.CheckEndTime'="" d
	.s ret=ret_"^CheckEndTime|"_$zt(obj.CheckEndTime,2)
	s floors="",floordescs=""
	f i=1:1:obj.CheckFloor.Count() d
	.s floorid=obj.CheckFloor.GetAt(i)
	.q:floorid=""
	.s floorobj=##class(DHCNMG.DB.MgFloor).%OpenId(floorid) 
	.i floors="" s floors=floorid,floordescs=floorobj.FloorDesc
	.e  s floors=floors_","_floorid,floordescs=floordescs_","_floorobj.FloorDesc
	s ret=ret_"^CheckFloor|"_floors_"^FloorDesc|"_floordescs
	s wards="",warddescs=""
	f i=1:1:obj.CheckWard.Count() d
	.s wardid=obj.CheckWard.GetAt(i)
	.q:wardid=""
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	.i wards="" s wards=wardid,warddescs=wardobj.WardDesc
	.e  s wards=wards_","_wardid,warddescs=warddescs_","_wardobj.WardDesc
	s ret=ret_"^CheckWard|"_wards_"^WardDesc|"_warddescs_"^CheckWardNum|"_obj.CheckWard.Count()
	s ret=ret_"^CheckRecWardNum|"_obj.CheckRecWardNum
	s contents="",contentdescs=""
	f i=1:1:obj.CheckContent.Count() d
	.s contentid=obj.CheckContent.GetAt(i)
	.q:contentid=""
	.s contentobj=##class(DHCNMG.Arg.MgCheckContent).%OpenId(contentid)
	.i contents="" s contents=contentid,contentdescs=contentobj.ContentDesc
	.e  s contents=contents_","_contentid,contentdescs=contentdescs_","_contentobj.ContentDesc
	s ret=ret_"^CheckContent|"_contents_"^ContentDesc|"_contentdescs
	s ret=ret_"^CheckGoodAspect|"_obj.CheckGoodAspect
	s ret=ret_"^CheckProblem|"_obj.CheckProblem
	s ret=ret_"^CheckSuggest|"_obj.CheckSuggest
	s users="",usernames=""
	f i=1:1:obj.CheckUser.Count()
	.s perdr=obj.CheckUser.GetAt(id)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i users="" s users=perdr,usernames=perobj.PerName
	.e  s users=users_","_perdr,usernames=usernames_","_perobj.PerName
	s ret=ret_"^CheckUser|"_users_"^CheckUserName|"_usernames
	s ret=ret_"^CheckStatus|"_obj.CheckStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.CheckStatus,"N":"未提交","Y":"已提交","B":"驳回",:"")
	s BackUserName="管理员"
	i obj.StatusUser'="" d
	.s ret=ret_"^StatusUser|"_obj.StatusUser.%Id()
	.s ret=ret_"^StatusUserName|"_obj.StatusUser.PerName
	.s BackUserName=obj.StatusUser.PerName
	i (obj.StatusRemark'="")&&((obj.CheckStatus="B")||(obj.CheckStatus="Y")) d
	.s ret=ret_"^BackUserName|"_BackUserName
	s ret=ret_"^StatusRemark|"_obj.StatusRemark
	i obj.CheckCrtUser'="" d
	.s ret=ret_"^CheckCrtUser|"_obj.CheckCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.CheckCrtUser.PerName
	e  s ret=ret_"^CheckCrtUser|0^CrtUserName|管理员"
	i obj.CheckCrtDate'="" s ret=ret_"^CheckCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckCrtDate)
	i obj.CheckCrtTime'="" s ret=ret_"^CheckCrtTime|"_$zt(obj.CheckCrtTime,2)
	s ret=ret_"^ReviewSuggest|"_obj.CheckRVSuggest
	i obj.CheckRVCrtUser'="" d
	.s ret=ret_"^CheckRVCrtUser|"_obj.CheckRVCrtUser.%Id()
	.s ret=ret_"^RVCrtUserName|"_obj.CheckRVCrtUser.PerName
	i obj.CheckRVCrtDate'="" d 
	.s ret=ret_"^CheckRVCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckRVCrtDate)
	.i obj.CheckRVCrtUser=""  s ret=ret_"^CheckRVCrtUser|0^RVCrtUserName|管理员"
	i obj.CheckRVCrtTime'="" s ret=ret_"^CheckRVCrtTime|"_$zt(obj.CheckRVCrtTime,2)
	q ret
}

/// creator: xbl
/// createdate: 20180115
/// description: 删除护士长夜查房
/// table: DHCNMG.Arg.MgNurHeadCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteNHCheck(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Arg.MgNurHeadCheck).%DeleteId(id)
	q $$$ISOK(sc)
}

ClassMethod SetNHCheck(id As %String, status As %String, user As %String = "", remark As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(id)
	s obj.CheckStatus=status
	s:remark'="" obj.StatusRemark=remark
	i user'="" d
	.s obj.StatusUser=##Class(DHCNMG.HR.MgPersons).%OpenId(user)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取护士长查房列表
/// table: DHCNMG.Arg.MgNurHeadCheck
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHCheck","^^^")
Query FindNHCheck(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHCheckExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$P(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s status=$P(parr,"^",3)
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurHeadCheckI("Date",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))||((enddate'="")&&(enddate<date))
	.s id="" f  s id=$O(^DHCNMG.Arg.MgNurHeadCheckI("Date",date,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(id)
	..q:(status'="")&&(status'=obj.CheckStatus)
	..s ret=..GetNHCheck(id)
	..d OutNHCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHCheckExecute ]
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
/// createdate: 20180115
/// description: 保存病房扣分情况
/// table: DHCNMG.Arg.MgNHCheckSub
/// input:
/// output:
/// return:
/// other: w ##Class(web.NurMgDeptWork).SaveNHCheckSub("CheckWardDR|62^CheckProblem|测试^DutyPerson|20,136^CheckScore|-1^CheckRemark|测试2^Parref|1^rw|")
ClassMethod SaveNHCheckSub(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parid=$g(tmp("Parref"))
	s ward=$g(tmp("CheckWardDR"))
	q:(parid="")&&(ward="") 0
	i $g(tmp("rw"))'=""  d
	.s obj=##class(DHCNMG.Arg.MgNHCheckSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNHCheckSub).%New()
	.s obj.Parref=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(parid)
	s obj.CheckWardDR=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	s obj.CheckProblem=$g(tmp("CheckProblem"))
	d obj.DutyPerson.Clear()
	f i=1:1:$L($g(tmp("DutyPerson")),",") d
	.s perdr=$P($g(tmp("DutyPerson")),",",i) 
	.q:perdr=""
	.d obj.DutyPerson.Insert(perdr)
	s obj.CheckScore=$g(tmp("CheckScore"))
	s obj.CheckRemark=$g(tmp("CheckRemark"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取病房扣分情况
/// table: DHCNMG.Arg.MgNHCheckSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod GetNHCheckSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Arg.MgNHCheckSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	i obj.CheckWardDR'="" d
	.s ret=ret_"^CheckWardDR|"_obj.CheckWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.CheckWardDR.WardDesc
	s ret=ret_"^CheckProblem|"_obj.CheckProblem
	s perdrs="",pernames=""
	f i=1:1:obj.DutyPerson.Count() d
	.s perdr=obj.DutyPerson.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i perdrs="" s perdrs=perdr,pernames=perobj.PerName
	.e  s perdrs=perdrs_","_perdr,pernames=pernames_","_perobj.PerName
	s ret=ret_"^DutyPerson|"_perdrs_"^DutyName|"_pernames
	s ret=ret_"^CheckScore|"_obj.CheckScore
	s ret=ret_"^CheckRemark|"_obj.CheckRemark
	q ret
}

/// creator: xbl
/// createdate: 20180115
/// description: 批量保存病房扣分情况
/// table: DHCNMG.Arg.MgNHCheckSub
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDeptWork).SaveNHCheckSubs("CheckWardDR|62^CheckProblem|测试^DutyPerson|20,136^CheckScore|-1^CheckRemark|测试2^Parref|1^rw|@CheckWardDR|43^CheckProblem|测试2^DutyPerson|69,279^CheckScore|-1^CheckRemark|测试23^Parref|1^rw|@")
ClassMethod SaveNHCheckSubs(parr As %String) As %String
{
	q:parr="" 0
	s tmp="",parid="",flag=1
	TStart
	;保存数据
	f i=1:1:$L(parr,"@")
	{
		s parm=$P(parr,"@",i)
		continue:parm=""
		s flag=..SaveNHCheckSub(parm)
		q:flag=0
		i parid="" s parid=+flag
		s tmp(flag)=1
	}
	i (parid="")||(flag=0)
	{
		TRollback
		q 0	
	}
	;清除界面已删除数据
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHCheckSubD(parid,subid)) q:(subid="")||(flag=0)  d
	.q:$g(tmp(parid_"||"_subid))'=""
	.s flag=..DeleteNHCheckSub(parid_"||"_subid)
	i flag=0
	{
		TRollback
		q 0
	}
	TCommit
	q 1
}

/// creator: xbl
/// createdate: 20180115
/// description: 删除病房扣分情况
/// table: DHCNMG.Arg.MgNHCheckSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod DeleteNHCheckSub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"__","||")
	s sc=##class(DHCNMG.Arg.MgNHCheckSub).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180115
///  description: 获取病房扣分情况列表
///  table: DHCNMG.Arg.MgNHCheckSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHCheckSub","1")
Query FindNHCheckSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHCheckSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	i parid="" Set qHandle=$lb(0,repic,0) Quit $$$OK
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHCheckSubD(parid,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.Arg.MgNHCheckSub).%OpenId(parid_"||"_subid)
	.s ret=..GetNHCheckSub(parid_"||"_subid)_"^editFlag|0"
	.d OutNHCheckSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHCheckSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHCheckSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHCheckSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHCheckSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHCheckSubExecute ]
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
///  createdate: 20180115
///  description: 获取病房扣分情况列表
///  table: DHCNMG.Arg.MgNHCheckSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHCheckSub2","")
Query FindNHCheckSub2(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHCheckSub2Execute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s minscore=$P(parr,"^",4)
	s maxscore=$P(parr,"^",5)
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurHeadCheckI("Date",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))||((enddate'="")&&(enddate<date))
	.s parid="" f  s parid=$O(^DHCNMG.Arg.MgNurHeadCheckI("Date",date,parid)) q:parid=""  d
	..s parobj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(parid)
	..;q:(parobj.CheckStatus'="Y")
	..s pret=..GetNHCheck(parid)
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHCheckSubD(parid,subid)) q:subid=""  d
	...s obj=##class(DHCNMG.Arg.MgNHCheckSub).%OpenId(parid_"||"_subid)
	...q:(ward'="")&&((obj.CheckWardDR="")||(obj.CheckWardDR.%Id()'=ward))
	...q:(obj.CheckScore'="")&&((minscore'="")&&(obj.CheckScore<minscore))||((maxscore'="")&&(obj.CheckScore<maxscore))
	...s ret=..GetNHCheckSub(parid_"||"_subid)
	...s ret=pret_ret_"^CheckDesc|检查表"
	...d OutNHCheckSub2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHCheckSub2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHCheckSub2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHCheckSub2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHCheckSub2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHCheckSub2Execute ]
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
/// createdate: 20180123
/// description: 保存护士长夜查房追踪记录
/// table: DHCNMG.Arg.MgNurHeadTrack
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveNHTrack(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNurHeadTrack).%New()
	i $g(tmp("TrackDate"))'="" s obj.TrackDate=$zdh(tmp("TrackDate"),3)
	e  s obj.TrackDate=""
	d obj.TrackUser.Clear()
	f i=1:1:$L($g(tmp("TrackUser")),",") d
	.s perdr=$P($g(tmp("TrackUser")),",",i)
	.q:perdr=""
	.d obj.TrackUser.Insert(perdr)
	i $g(tmp("TrackCrtUser"))'="" d
	.s obj.TrackCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("TrackCrtUser"))
	e  s obj.TrackCrtUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20180123
/// description: 删除护士长夜查房追踪记录
/// table: DHCNMG.Arg.MgNurHeadTrack
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteNHTrack(id As %String) As %String
{
	q:id="" 0
	s sc=##Class(DHCNMG.Arg.MgNurHeadTrack).%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20180123
/// description: 获取护士长夜查房追踪记录
/// table: DHCNMG.Arg.MgNurHeadTrack
/// input:
/// output:
/// return:
/// other:
ClassMethod GetNHTrack(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(id)
	s ret="rw|"_id	
	i obj.TrackDate'="" s ret=ret_"^TrackDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrackDate)
	s ret=ret_"^TrackStatus|"_obj.TrackStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.TrackStatus,"N":"未提交","Y":"已提交","B":"驳回",:"")
	s trackuser="",username=""
	f i=1:1:obj.TrackUser.Count() d
	.s user=obj.TrackUser.GetAt(i)
	.q:user=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(user)
	.i trackuser="" s trackuser=user,username=perobj.PerName
	.e  s trackuser=trackuser_","_user,username=username_","_perobj.PerName
	s ret=ret_"^TrackUser|"_trackuser
	s ret=ret_"^UserName|"_username
	i obj.TrackCrtUser'="" d
	.s ret=ret_"^TrackCrtUser|"_obj.TrackCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.TrackCrtUser.PerName
	i obj.TrackCrtDate'="" s ret=ret_"^TrackCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrackCrtDate)
	i obj.TrackCrtTime'="" s ret=ret_"^TrackCrtTime|"_$zt(obj.TrackCrtTime,2)
	q ret
}

ClassMethod SetNHTrack(id As %String, status As %String, user As %String = "", remark As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(id)
	s obj.TrackStatus=status
	s obj.StatusRemark=remark
	i user'="" d
	.s obj.StatusUser=##Class(DHCNMG.HR.MgPersons).%OpenId(user)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180123
///  description: 获取护士长夜查房追踪列表
///  table: DHCNMG.Arg.MgNurHeadTrack
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHTrack","")
Query FindNHTrack(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHTrackExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s crtdate=$P(parr,"^",1)
	s:crtdate["-" crtdate=$zdh(crtdate,3)
	s status=$P(parr,"^",2)
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurHeadTrackI("Date",date),-1) q:date=""  d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgNurHeadTrackI("Date",date,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(id)
	..q:(crtdate'="")&&(crtdate'=obj.TrackCrtDate)
	..q:(status'="")&&(status'=obj.TrackStatus)
	..s ret=..GetNHTrack(id)
	..s patname="" 
	..s patid="" f  s patid=$O(^DHCNMG.Arg.MgNHTrackPatD(id,patid)) q:patid=""  d
	...s patobj=##class(DHCNMG.Arg.MgNHTrackPat).%OpenId(id_"||"_patid)
	...i patname="" s patname=patobj.TrackPatName
	...e  s patname=patname_","_patobj.TrackPatName
	..s ret=ret_"^PatName|"_patname
	..d OutNHTrack
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHTrack
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHTrackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHTrackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHTrackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHTrackExecute ]
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
///  createdate: 20180123
///  description: 保存护士长夜查房追踪病人信息
///  table: DHCNMG.Arg.MgNurHeadTrackPat
///  input:
///  output:
///  return:
///  other:
ClassMethod SaveNHTrackPat(parr As %String) As %String
{
	s ^TmpXBL("trackpat")=parr
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parid=$g(tmp("Parref"))
	s admdr=$g(tmp("TrackAdmDR"))
	s patno=$g(tmp("TrackPatNo"))
	q:(parid="")||((admdr="")&&(patno="")) 0
	i admdr="" s admdr=##class(web.NurMgHISComm).GetCurrAdm(patno)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgNHTrackPat).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNHTrackPat).%New()
	.s obj.Parref=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(parid)
	i $g(tmp("TrackDate"))'="" s obj.TrackDate=$zdh(tmp("TrackDate"),3)
	e  s obj.TrackDate=""
	i $g(tmp("TrackWardDR"))'="" d
	.s obj.TrackWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("TrackWardDR"))
	e  s obj.TrackWardDR=""
	i admdr'="" d
	.s obj.TrackAdmDR=##class(User.PAAdm).%OpenId(admdr)
	e  s obj.TrackAdmDR=""
	s obj.TrackPatNo=patno
	s obj.TrackBedCode=$g(tmp("TrackBedCode"))
	s obj.TrackPatName=$g(tmp("TrackPatName"))
	s obj.TrackPatAge=$g(tmp("TrackPatAge"))
	s obj.TrackPatSex=$g(tmp("TrackPatSex"))
	s obj.TrackCareLevel=$g(tmp("TrackCareLevel"))	
	s obj.TrackDiagnosis=$g(tmp("TrackDiagnosis"))
	s obj.TrackTreat=$g(tmp("TrackTreat"))
	s obj.TrackTalk=$g(tmp("TrackTalk"))
	s obj.TrackReview=$g(tmp("TrackReview"))
	s obj.TrackCheck=$g(tmp("TrackCheck"))
	s obj.TrackFulfill=$g(tmp("TrackFulfill"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180124
///  description: 获取护士长夜查房追踪病人信息
///  table: DHCNMG.Arg.MgNurHeadTrackPat
///  input:
///  output:
///  return:
///  other:
ClassMethod GetNHTrackPat(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Arg.MgNHTrackPat).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	i obj.TrackDate'="" s ret=ret_"^TrackDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TrackDate)
	i obj.TrackWardDR'="" d
	.s ret=ret_"^TrackWardDR|"_obj.TrackWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.TrackWardDR.WardDesc
	i obj.TrackAdmDR'="" d
	.s ret=ret_"^TrackAdmDR|"_obj.TrackAdmDR.%Id()
	s ret=ret_"^TrackPatNo|"_obj.TrackPatNo
	s ret=ret_"^TrackBedCode|"_obj.TrackBedCode
	s ret=ret_"^TrackPatName|"_obj.TrackPatName
	s ret=ret_"^TrackPatAge|"_obj.TrackPatAge
	s ret=ret_"^TrackPatSex|"_obj.TrackPatSex
	s ret=ret_"^TrackCareLevel|"_obj.TrackCareLevel
	s ret=ret_"^TrackDiagnosis|"_obj.TrackDiagnosis
	s ret=ret_"^TrackTreat|"_obj.TrackTreat
	s ret=ret_"^TrackTalk|"_obj.TrackTalk
	s ret=ret_"^TrackReview|"_obj.TrackReview
	s ret=ret_"^TrackCheck|"_obj.TrackCheck
	s ret=ret_"^TrackFulfill|"_obj.TrackFulfill
	q ret
}

///  creator: xbl
///  createdate: 20180124
///  description: 删除护士长夜查房追踪病人信息
///  table: DHCNMG.Arg.MgNurHeadTrackPat
///  input:
///  output:
///  return:
///  other:
ClassMethod DeletNHTrackPat(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s sc=##class(DHCNMG.Arg.MgNHTrackPat).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180124
///  description: 获取护士长夜查房追踪病人信息
///  table: DHCNMG.Arg.MgNurHeadTrackPat
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHTrackPat","1")
Query FindNHTrackPat(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHTrackPatExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	i parid="" Set qHandle=$lb(0,repic,0) Quit $$$OK
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHTrackPatD(parid,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.Arg.MgNHTrackPat).%OpenId(parid_"||"_subid)
	.s ret=..GetNHTrackPat(parid_"||"_subid)
	.d OutNHTrackPat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHTrackPat
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHTrackPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHTrackPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHTrackPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHTrackPatExecute ]
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
/// createdate: 20180124
/// description: 保存护士长夜查房追踪病房扣分情况
/// table: DHCNMG.Arg.MgNHTrackSub
/// input:
/// output:
/// return:
/// other: w ##Class(web.NurMgDeptWork).SaveNHTrackSub()
ClassMethod SaveNHTrackSub(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parid=$g(tmp("Parref"))
	s ward=$g(tmp("TrackWardDR"))
	q:(parid="")&&(ward="") 0
	i $g(tmp("rw"))'=""  d
	.s obj=##class(DHCNMG.Arg.MgNHTrackSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNHTrackSub).%New()
	.s obj.Parref=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(parid)
	s obj.TrackWardDR=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	s obj.TrackProblem=$g(tmp("TrackProblem"))
	d obj.DutyPerson.Clear()
	f i=1:1:$L($g(tmp("DutyPerson")),",") d
	.s perdr=$P($g(tmp("DutyPerson")),",",i) 
	.q:perdr=""
	.d obj.DutyPerson.Insert(perdr)
	s obj.TrackScore=$g(tmp("TrackScore"))
	s obj.TrackRemark=$g(tmp("TrackRemark"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取护士长夜查房追踪病房扣分情况
/// table: DHCNMG.Arg.MgNHTrackSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod GetNHTrackSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Arg.MgNHTrackSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	i obj.TrackWardDR'="" d
	.s ret=ret_"^TrackWardDR|"_obj.TrackWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.TrackWardDR.WardDesc
	s ret=ret_"^TrackProblem|"_obj.TrackProblem
	s perdrs="",pernames=""
	f i=1:1:obj.DutyPerson.Count() d
	.s perdr=obj.DutyPerson.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i perdrs="" s perdrs=perdr,pernames=perobj.PerName
	.e  s perdrs=perdrs_","_perdr,pernames=pernames_","_perobj.PerName
	s ret=ret_"^DutyPerson|"_perdrs_"^DutyName|"_pernames
	s ret=ret_"^TrackScore|"_obj.TrackScore
	s ret=ret_"^TrackRemark|"_obj.TrackRemark
	q ret
}

/// creator: xbl
/// createdate: 20180115
/// description: 批量保存护士长夜查房追踪病房扣分情况
/// table: DHCNMG.Arg.MgNHTrackSub
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDeptWork).SaveNHTrackSubs()
ClassMethod SaveNHTrackSubs(parr As %String) As %String
{
	q:parr="" 0
	s tmp="",parid="",flag=1
	TStart
	;保存数据
	f i=1:1:$L(parr,"@")
	{
		s parm=$P(parr,"@",i)
		continue:parm=""
		s flag=..SaveNHTrackSub(parm)
		q:flag=0
		i parid="" s parid=+flag
		s tmp(flag)=1
	}
	i (parid="")||(flag=0)
	{
		TRollback
		q 0	
	}
	;清除界面已删除数据
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHTrackSubD(parid,subid)) q:(subid="")||(flag=0)  d
	.q:$g(tmp(parid_"||"_subid))'=""
	.s flag=..DeleteNHTrackSub(parid_"||"_subid)
	i flag=0
	{
		TRollback
		q 0
	}
	TCommit
	q 1
}

/// creator: xbl
/// createdate: 20180115
/// description: 删除护士长夜查房追踪病房扣分情况
/// table: DHCNMG.Arg.MgNHTrackSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod DeleteNHTrackSub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"__","||")
	s sc=##class(DHCNMG.Arg.MgNHTrackSub).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180115
///  description: 获取病房扣分情况列表
///  table: DHCNMG.Arg.MgNHTrackSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindNHTrackSub","1")
Query FindNHTrackSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHTrackSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	i parid="" Set qHandle=$lb(0,repic,0) Quit $$$OK
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHTrackSubD(parid,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.Arg.MgNHTrackSub).%OpenId(parid_"||"_subid)
	.s ret=..GetNHTrackSub(parid_"||"_subid)_"^editFlag|0"
	.d OutNHTrackSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHTrackSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHTrackSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHTrackSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHTrackSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHTrackSubExecute ]
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

Query FindNHTrackSub2(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHTrackSub2Execute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s minscore=$P(parr,"^",4)
	s maxscore=$P(parr,"^",5)
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurHeadTrackI("Date",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))||((enddate'="")&&(enddate<date))
	.s parid="" f  s parid=$O(^DHCNMG.Arg.MgNurHeadTrackI("Date",date,parid)) q:parid=""  d
	..s parobj=##class(DHCNMG.Arg.MgNurHeadTrack).%OpenId(parid)
	..;q:(parobj.CheckStatus'="Y")
	..s pret=..GetNHTrack(parid)
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgNHTrackSubD(parid,subid)) q:subid=""  d
	...s obj=##class(DHCNMG.Arg.MgNHTrackSub).%OpenId(parid_"||"_subid)
	...q:(ward'="")&&((obj.TrackWardDR="")||(obj.TrackWardDR.%Id()'=ward))
	...q:(obj.TrackScore'="")&&((minscore'="")&&(obj.TrackScore<minscore))||((maxscore'="")&&(obj.CheckScore<maxscore))
	...s ret=..GetNHTrackSub(parid_"||"_subid)
	...s ret=pret_ret_"^TrackDesc|追踪表"
	...d OutNHTrackSub2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHTrackSub2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHTrackSub2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHTrackSub2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHTrackSub2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHTrackSub2Execute ]
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
/// createdate: 20180112
/// description: 保存值班人员查房
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input: 
/// output:
/// return:
/// other:
ClassMethod SaveDNCheck(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%New()
	i $g(tmp("CheckStDate"))'="" s obj.CheckStDate=$zdh(tmp("CheckStDate"),3)
	e  s obj.CheckStDate=""
	i $g(tmp("CheckStTime"))'="" s obj.CheckStTime=$zth(tmp("CheckStTime"),2)
	e  s obj.CheckStTime=""
	i $g(tmp("CheckEndDate"))'="" s obj.CheckEndDate=$zdh(tmp("CheckEndDate"),3)
	e  s obj.CheckEndDate=""
	i $g(tmp("CheckEndTime"))'="" s obj.CheckEndTime=$zth(tmp("CheckEndTime"),2)
	e  s obj.CheckEndTime=""
	d obj.CheckFloor.Clear()
	f i=1:1:$L($g(tmp("CheckFloor")),",") d
	.s floor=$P($g(tmp("CheckFloor")),",",i)
	.q:floor=""
	.d obj.CheckFloor.Insert(floor)
	d obj.CheckWard.Clear()
	f i=1:1:$L($g(tmp("CheckWard")),",") d
	.s ward=$P($g(tmp("CheckWard")),",",i)
	.q:ward=""
	.d obj.CheckWard.Insert(ward)
	d obj.CheckContent.Clear()
	f i=1:1:$L($g(tmp("CheckContent")),",") d
	.s itm=$P($g(tmp("CheckContent")),",",i)
	.q:itm=""
	.d obj.CheckContent.Insert(itm)
	s obj.CheckGoodAspect=$g(tmp("CheckGoodAspect"))
	s obj.CheckProblem=$g(tmp("CheckProblem"))
	s obj.CheckAtDeathNum=$g(tmp("CheckAtDeathNum"))  ;保存病危人数
	s obj.CheckSeriousNum=$g(tmp("CheckSeriousNum"))  ;保存病重人数
	d obj.CheckUser.Clear()
	f i=1:1:$L($g(tmp("CheckUser")),",") d
	.s perdr=$P($g(tmp("CheckUser")),",",i)
	.q:perdr=""
	.d obj.CheckUser.Insert(perdr)
	i $g(tmp("StatusUser"))'="" d
	.s obj.StatusUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("StatusUser"))
	e  s obj.StatusUser=""
	s obj.StatusRemark=$g(tmp("StatusRemark"))
	i $g(tmp("CheckCrtUser"))'="" d
	.s obj.CheckCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("CheckCrtUser"))
	e  s obj.CheckCrtUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: lulin
/// description: 删除护士长夜查房检查
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteDHCheck(ids As %String) As %String
{
		q:ids="" ""
		s sc=1
		for i=1:1:$l(ids,"^") d
		.s id=$p(ids,"^",i)
		.s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(id)
		.s sc=obj.%DeleteId(id)
		i $$$ISERR(sc) s sc=0
		q sc
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取护士长夜查房检查
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod GetDNCheck(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(id)
	s ret="rw|"_id
	i obj.CheckStDate'="" d
	.s ret=ret_"^CheckStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckStDate)
	i obj.CheckStTime'="" d
	.s ret=ret_"^CheckStTime|"_$zt(obj.CheckStTime,2)
	i obj.CheckEndDate'="" d
	.s ret=ret_"^CheckEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckEndDate)
	i obj.CheckEndTime'="" d
	.s ret=ret_"^CheckEndTime|"_$zt(obj.CheckEndTime,2)
	s floors="",floordescs=""
	f i=1:1:obj.CheckFloor.Count() d
	.s floorid=obj.CheckFloor.GetAt(i)
	.q:floorid=""
	.s floorobj=##class(DHCNMG.DB.MgFloor).%OpenId(floorid) 
	.i floors="" s floors=floorid,floordescs=floorobj.FloorDesc
	.e  s floors=floors_","_floorid,floordescs=floordescs_","_floorobj.FloorDesc
	s ret=ret_"^CheckFloor|"_floors_"^FloorDesc|"_floordescs
	s wards="",warddescs=""
	f i=1:1:obj.CheckWard.Count() d
	.s wardid=obj.CheckWard.GetAt(i)
	.q:wardid=""
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	.i wards="" s wards=wardid,warddescs=wardobj.WardDesc
	.e  s wards=wards_","_wardid,warddescs=warddescs_","_wardobj.WardDesc
	s ret=ret_"^CheckWard|"_wards_"^WardDesc|"_warddescs
	s contents="",contentdescs=""
	f i=1:1:obj.CheckContent.Count() d
	.s contentid=obj.CheckContent.GetAt(i)
	.q:contentid=""
	.s contentobj=##class(DHCNMG.Arg.MgCheckContent).%OpenId(contentid)
	.q:'$IsObject(contentobj)
	.i contents="" s contents=contentid,contentdescs=contentobj.ContentDesc
	.e  s contents=contents_","_contentid,contentdescs=contentdescs_","_contentobj.ContentDesc
	s ret=ret_"^CheckContent|"_contents_"^ContentDesc|"_contentdescs
	s ret=ret_"^CheckGoodAspect|"_obj.CheckGoodAspect
	s ret=ret_"^CheckProblem|"_obj.CheckProblem
	s users="",usernames=""
	f i=1:1:obj.CheckUser.Count()
	.s perdr=obj.CheckUser.GetAt(id)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i users="" s users=perdr,usernames=perobj.PerName
	.e  s users=users_","_perdr,usernames=usernames_","_perobj.PerName
	s ret=ret_"^CheckUser|"_users_"^CheckUserName|"_usernames
	s ret=ret_"^CheckStatus|"_obj.CheckStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.CheckStatus,"N":"未提交","Y":"已提交","B":"驳回",:"")
	s BackUserName="管理员"
	i obj.StatusUser'="" d
	.s ret=ret_"^StatusUser|"_obj.StatusUser.%Id()
	.s ret=ret_"^StatusUserName|"_obj.StatusUser.PerName
	.s BackUserName=obj.StatusUser.PerName
	i (obj.StatusRemark'="")&&((obj.CheckStatus="B")||(obj.CheckStatus="Y")) d
	.s ret=ret_"^BackUserName|"_BackUserName
	s ret=ret_"^StatusRemark|"_obj.StatusRemark
	i obj.CheckCrtUser'="" d
	.s ret=ret_"^CheckCrtUser|"_obj.CheckCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.CheckCrtUser.PerName
	e  s ret=ret_"^CheckCrtUser|0^CrtUserName|管理员"
	i obj.CheckCrtDate'="" s ret=ret_"^CheckCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.CheckCrtDate)
	i obj.CheckCrtTime'="" s ret=ret_"^CheckCrtTime|"_$zt(obj.CheckCrtTime,2)
	s ret=ret_"^CheckAtDeathNum|"_obj.CheckAtDeathNum	;新增病危人数
	s ret=ret_"^CheckSeriousNum|"_obj.CheckSeriousNum	;新增病重人数
	q ret
}

/// creator: xbl
/// createdate: 20180115
/// description: 删除护士长夜查房
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod DeleteDNCheck(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Arg.MgDutyNurCheck).%DeleteId(id)
	q $$$ISOK(sc)
}

ClassMethod SetDNCheck(id As %String, status As %String, user As %String = "", remark As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(id)
	s obj.CheckStatus=status
	s:remark'="" obj.StatusRemark=remark
	i user'="" d
	.s obj.StatusUser=##Class(DHCNMG.HR.MgPersons).%OpenId(user)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取护士长查房列表
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindDNCheck","^^^")
Query FindDNCheck(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDNCheckExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$P(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s date="" f  s date=$O(^DHCNMG.Arg.MgDutyNurCheckI("Date",date)) q:date=""  d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgDutyNurCheckI("Date",date,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(id)
	..q:((stdate'="")&&(obj.CheckEndDate>stdate))||((enddate'="")&&(enddate<obj.CheckStDate))
	..s ret=..GetDNCheck(id)
	..d OutDNCheck
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDNCheck
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDNCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDNCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDNCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDNCheckExecute ]
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
/// createdate: 20180115
/// description: 保存病房扣分情况
/// table: DHCNMG.Arg.MgDNCheckSub
/// input:
/// output:
/// return:
/// other: w ##Class(web.NurMgDeptWork).SaveDNCheckSub("CheckWardDR|62^CheckProblem|测试^DutyPerson|20,136^CheckScore|-1^CheckRemark|测试2^Parref|1^rw|")
ClassMethod SaveDNCheckSub(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parid=$g(tmp("Parref"))
	s ward=$g(tmp("CheckWardDR"))
	q:(parid="")&&(ward="") 0
	i $g(tmp("rw"))'=""  d
	.s obj=##class(DHCNMG.Arg.MgDNCheckSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgDNCheckSub).%New()
	.s obj.Parref=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(parid)
	s obj.CheckWardDR=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	s obj.CheckProblem=$g(tmp("CheckProblem"))
	d obj.DutyPerson.Clear()
	f i=1:1:$L($g(tmp("DutyPerson")),",") d
	.s perdr=$P($g(tmp("DutyPerson")),",",i) 
	.q:perdr=""
	.d obj.DutyPerson.Insert(perdr)
	s obj.CheckScore=$g(tmp("CheckScore"))
	s obj.CheckRemark=$g(tmp("CheckRemark"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20180115
/// description: 获取病房扣分情况
/// table: DHCNMG.Arg.MgDNCheckSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod GetDNCheckSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Arg.MgDNCheckSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^Parref|"_obj.Parref.%Id()
	i obj.CheckWardDR'="" d
	.s ret=ret_"^CheckWardDR|"_obj.CheckWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.CheckWardDR.WardDesc
	s ret=ret_"^CheckProblem|"_obj.CheckProblem
	s perdrs="",pernames=""
	f i=1:1:obj.DutyPerson.Count() d
	.s perdr=obj.DutyPerson.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i perdrs="" s perdrs=perdr,pernames=perobj.PerName
	.e  s perdrs=perdrs_","_perdr,pernames=pernames_","_perobj.PerName
	s ret=ret_"^DutyPerson|"_perdrs_"^DutyName|"_pernames
	s ret=ret_"^CheckScore|"_obj.CheckScore
	s ret=ret_"^CheckRemark|"_obj.CheckRemark
	q ret
}

/// creator: xbl
/// createdate: 20180115
/// description: 批量保存病房扣分情况
/// table: DHCNMG.Arg.MgDNCheckSub
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDeptWork).SaveDNCheckSubs("CheckWardDR|62^CheckProblem|测试^DutyPerson|20,136^CheckScore|-1^CheckRemark|测试2^Parref|1^rw|@CheckWardDR|43^CheckProblem|测试2^DutyPerson|69,279^CheckScore|-1^CheckRemark|测试23^Parref|1^rw|@")
ClassMethod SaveDNCheckSubs(parr As %String) As %String
{
	q:parr="" 0
	s tmp="",parid="",flag=1
	TStart
	;保存数据
	f i=1:1:$L(parr,"@")
	{
		s parm=$P(parr,"@",i)
		continue:parm=""
		s flag=..SaveDNCheckSub(parm)
		q:flag=0
		i parid="" s parid=+flag
		s tmp(flag)=1
	}
	i (parid="")||(flag=0)
	{
		TRollback
		q 0	
	}
	;清除界面已删除数据
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgDNCheckSubD(parid,subid)) q:(subid="")||(flag=0)  d
	.q:$g(tmp(parid_"||"_subid))'=""
	.s flag=..DeleteDNCheckSub(parid_"||"_subid)
	i flag=0
	{
		TRollback
		q 0
	}
	TCommit
	q 1
}

/// creator: xbl
/// createdate: 20180115
/// description: 删除病房扣分情况
/// table: DHCNMG.Arg.MgDNCheckSub
/// input:
/// output:
/// return:
/// other: 
ClassMethod DeleteDNCheckSub(id As %String) As %String
{
	q:id="" 0
	s id=$tr(id,"__","||")
	s sc=##class(DHCNMG.Arg.MgDNCheckSub).%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 20180115
///  description: 获取值班人员病房扣分情况列表
///  table: DHCNMG.Arg.MgDNCheckSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindDNCheckSub","1")
Query FindDNCheckSub(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDNCheckSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	i parid="" Set qHandle=$lb(0,repic,0) Quit $$$OK
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgDNCheckSubD(parid,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.Arg.MgDNCheckSub).%OpenId(parid_"||"_subid)
	.s ret=..GetDNCheckSub(parid_"||"_subid)_"^editFlag|0"
	.d OutDNCheckSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDNCheckSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDNCheckSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDNCheckSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDNCheckSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDNCheckSubExecute ]
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
///  createdate: 20180115
///  description: 获取病房扣分情况列表
///  table: DHCNMG.Arg.MgDNCheckSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindDNCheckSub2","")
Query FindDNCheckSub2(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDNCheckSub2Execute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s minscore=$P(parr,"^",4)
	s maxscore=$P(parr,"^",5)
	s date="" f  s date=$O(^DHCNMG.Arg.MgDutyNurCheckI("Date",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))||((enddate'="")&&(enddate<date))
	.s parid="" f  s parid=$O(^DHCNMG.Arg.MgDutyNurCheckI("Date",date,parid)) q:parid=""  d
	..s parobj=##class(DHCNMG.Arg.MgDutyNurCheck).%OpenId(parid)
	..;q:(parobj.CheckStatus'="Y")
	..s pret=..GetDNCheck(parid)
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgDNCheckSubD(parid,subid)) q:subid=""  d
	...s obj=##class(DHCNMG.Arg.MgDNCheckSub).%OpenId(parid_"||"_subid)
	...q:(ward'="")&&((obj.CheckWardDR="")||(obj.CheckWardDR.%Id()'=ward))
	...q:(obj.CheckScore'="")&&((minscore'="")&&(obj.CheckScore<minscore))||((maxscore'="")&&(obj.CheckScore<maxscore))
	...s ret=..GetDNCheckSub(parid_"||"_subid)
	...s ret=pret_ret_"^CheckDesc|检查表"
	...d OutDNCheckSub2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDNCheckSub2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDNCheckSub2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDNCheckSub2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDNCheckSub2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDNCheckSub2Execute ]
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
///  createdate: 20180115
///  description: 获取病房扣分情况列表
///  table: DHCNMG.Arg.MgDNCheckSub
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgDeptWork","FindCheckerList","B")
Query FindCheckerList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckerListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s type=$p(parr,"^")
    s Iperinfo=$p(parr,"^",2)
    s Iwork=$p(parr,"^",3)
    s Iduty=$p(parr,"^",4)
    i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s id="" f  s id=$O(^DHCNMG.Arg.MgNurTrainI("TypeTeaType"," "_type," 2",id)) q:id=""  d
    .s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
    .q:'$IsObject(obj)
    .s perinfo=obj.TrainTeaName
    .s work=obj.TrainTeaWork
    .s duty=obj.TrainTeaDuty
    .q:(Iperinfo'="")&&(perinfo'[Iperinfo)
    .q:(Iwork'="")&&(work'[Iwork)
    .q:(Iduty'="")&&(duty'[Iduty)
	.s ret="perinfo|"_perinfo_"^work|"_work_"^duty|"_duty
	.d OutCheckerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckerListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckerListExecute ]
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

///  creator: lulin
///  createdate: 
///  description: 保存附件
///  table: DHCNMG.Arg.MgNurTrain
///  input:
///  output:
///  return:
///  other:
ClassMethod saveTrainRefer(parr As %String) As %String
{
		s id=$p(parr,"^")
		s url=$tr($p(parr,"^",2)," ","")
		s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
		q:'$IsObject(obj) ""
		i obj.TrainRefer="" d
		.s obj.TrainRefer=url
		e  s obj.TrainRefer=obj.TrainRefer_","_url
		s sc=obj.%Save()
		i $$$ISOK(sc){
			q 1	
		}else{
			q 0
			}
}

///  creator: lulin
///  createdate: 
///  description: 保存附件
///  table: DHCNMG.Arg.MgNurTrain
///  input:
///  output:
///  return:
///  other:
ClassMethod deleteTrainRefer(parr As %String) As %String
{
		s id=$p(parr,"^")
		s url=$tr($p(parr,"^",2)," ","")
		s obj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(id)
		q:'$IsObject(obj) ""
		s newRefer=""
		f i=1:1:$l(obj.TrainRefer,",") d
		.q:url=$p(obj.TrainRefer,",",i)
		.s:newRefer'="" newRefer=newRefer_","_$p(obj.TrainRefer,",",i)
		.s:newRefer="" newRefer=$p(obj.TrainRefer,",",i)
		s obj.TrainRefer=newRefer
		s sc=obj.%Save()
		i $$$ISOK(sc){
			q 1	
		}else{
			q 0
		}
}

/// creator: zhangjz
/// createdate: 20180720
/// description: 护理部值班人员查房-添加模块-依据查房区域统计病危病重人数
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDeptWork).getWardPatientsNum("23")
ClassMethod getWardPatientsNum(floorids As %String) As %String
{
	s atdeathnum=0,seriousnum=0,tmpPat=""
	f i=1:1:$L(floorids,",") d
	.s fid=$P(floorids,",",i)
	.s obj=##class(DHCNMG.DB.MgFloor).%OpenId(fid)
	.q:'$IsObject(obj)
	.s code=obj.FloorCode
	.s desc=obj.FloorDesc
	.s ret=##class(web.NurMgDBComm).GetFloor(fid)
	.f j=1:1:obj.FloorWards.Count() d
	..s ward=obj.FloorWards.GetAt(j)
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	..q:'$IsObject(wardobj) 
	..q:'$IsObject(wardobj.CTLocDR)
	..s loc=wardobj.CTLocDR.%Id()
	..s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	..q:pacward=""
	..s room="" f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	...q:room=0 ;去除等候区病人
	...s adm="" f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d
	....q:$d(tmpPat(adm))
	....s sickflag=##class(web.NurMgHISComm).IfOrddailyExistByConfig(adm,"CRITICALLY",+$H)  //"病危"
	....i sickflag="1" s atdeathnum=atdeathnum+1
	....s sickflag=##class(web.NurMgHISComm).IfOrddailyExistByConfig(adm,"SERIOUSLY",+$H)  //"病重"
	....i sickflag="1" s seriousnum=seriousnum+1
	....s tmpPat(adm)=adm
	s ret="rw|"_floorids_"^CheckAtDeathNum|"_atdeathnum_"^CheckSeriousNum|"_seriousnum
	q ret
}

/// creator: llin
/// createdate: 2018-08-10
/// description: 护士长夜查房是否有权限修改、查看
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgDeptWork).IsNHCheckEditable("0")
ClassMethod IsNHCheckEditable(nurseid As %String) As %String
{
	q:(nurseid="") 0
	q:nurseid=0 1
	s date=+$h
	s flag=0
	s id="" f  s id=$O(^DHCNMG.Set.MgNHChkArrangeI("TypeDate"," C",64870,id)) q:(id="")||(flag=1)  d
	.s obj=##class(DHCNMG.Set.MgNHChkArrange).%OpenId(id)
	.q:'$IsObject(obj)
	.f i=1:1:obj.ArgCheckUser.Count() q:flag=1  d
	..s perId=obj.ArgCheckUser.GetAt(i)
	..i perId=nurseid s flag=1
	q flag
}

/// creator: llin
/// createdate: 2018-08-10
/// description: 保存护士长查房复查
/// table: DHCNMG.Arg.MgDutyNurCheck
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveNHCheckReView(parr) As %String
{
	s Suggest=$p(parr,"^")
	s loginID=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCNMG.Arg.MgNurHeadCheck).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.CheckRVSuggest=Suggest
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(loginID)
	i $IsObject(perObj) d
	.s obj.CheckRVCrtUser=perObj
	s obj.CheckRVCrtDate=+$h
	s obj.CheckRVCrtTime=$p(+$h,",",2)
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q 0	
	}
}

/// Creator:gzj
/// Date: 2019-06-11
/// Description: 导出培训信息参加人员成绩列表
/// Table: DHCNMG.Arg.MgNurTrainSub
/// Input：
/// Output:
/// Return:
/// Other:
ClassMethod GetTrainExport(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %String
{
	s type=$P(parr,"^",1)
	s ward=$P(parr,"^",2)
	s traindate=$P(parr,"^",3)
	s:traindate["-" traindate=$zdh(traindate,3)
	s perinfo=$P(parr,"^",4)
	s minscore=$P(parr,"^",5)
	s maxscore=$P(parr,"^",6)
	s submitdate=$P(parr,"^",7)
	s:submitdate["-" submitdate=$zdh(submitdate,3)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s title=""
	s date1="" f  s date1=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date1)) q:date1=""  d
	.s parid1="" f  s parid1=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date1,parid1)) q:parid1=""  d
	..s parobj1=##class(DHCNMG.Arg.MgNurTrain).%OpenId(parid1)
	..q:(ward'="")&&((parobj1.TrainWardDR="")||(parobj1.TrainWardDR.%Id()'=ward))
	..q:(isAll=0)&&(('$IsObject(parobj1.TrainWardDR))||('$d(tmpWard(parobj1.TrainWardDR.%Id()))))
	..q:(traindate'="")&&(traindate'=parobj1.TrainDate)
	..q:(submitdate'="")&&(submitdate'=parobj1.TrainSubmitDate)
	..s TrainTitle=parobj1.TrainTitle
	..s title(parid1)="title"_parid1_"^"_TrainTitle
	w "["
	s n=1
	s rw="" f  s rw=$o(title(rw)) q:rw=""  d
	.i n=1 w "{""title"":""score"_rw_""",""desc"":"""_$p(title(rw),"^",2)_"""}"
	.e  w ",{""title"":""score"_rw_""",""desc"":"""_$p(title(rw),"^",2)_"""}"
	.s n=n+1
	w "]"
	q ""
}

Query FindTrainExport(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrainExportExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$P(parr,"^",2)
	s traindate=$P(parr,"^",3)
	s:traindate["-" traindate=$zdh(traindate,3)
	s perinfo=$P(parr,"^",4)
	s minscore=$P(parr,"^",5)
	s maxscore=$P(parr,"^",6)
	s submitdate=$P(parr,"^",7)
	s:submitdate["-" submitdate=$zdh(submitdate,3)
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s title=""
	s date1="" f  s date1=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date1)) q:date1=""  d
	.s parid1="" f  s parid1=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date1,parid1)) q:parid1=""  d
	..s parobj1=##class(DHCNMG.Arg.MgNurTrain).%OpenId(parid1)
	..q:(ward'="")&&((parobj1.TrainWardDR="")||(parobj1.TrainWardDR.%Id()'=ward))
	..q:(isAll=0)&&(('$IsObject(parobj1.TrainWardDR))||('$d(tmpWard(parobj1.TrainWardDR.%Id()))))
	..q:(traindate'="")&&(traindate'=parobj1.TrainDate)
	..q:(submitdate'="")&&(submitdate'=parobj1.TrainSubmitDate)
	..
	..s TrainTitle=parobj1.TrainTitle
	..s title(parid1)="title"_parid1_"^"_TrainTitle
	
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date)) q:date=""  d
	.s parid="" f  s parid=$O(^DHCNMG.Arg.MgNurTrainI("TypeDate"," "_type,date,parid)) q:parid=""  d
	..s parobj=##class(DHCNMG.Arg.MgNurTrain).%OpenId(parid)
	..q:(ward'="")&&((parobj.TrainWardDR="")||(parobj.TrainWardDR.%Id()'=ward))
	..q:(isAll=0)&&(('$IsObject(parobj.TrainWardDR))||('$d(tmpWard(parobj.TrainWardDR.%Id()))))
	..q:(traindate'="")&&(traindate'=parobj.TrainDate)
	..q:(submitdate'="")&&(submitdate'=parobj.TrainSubmitDate)
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgNurTrainSubD(parid,subid)) q:subid=""  d
	...s subobj=##class(DHCNMG.Arg.MgNurTrainSub).%OpenId(parid_"||"_subid)
	...q:subobj.TrainPerDR=""
	...s perid=subobj.TrainPerDR.%Id()
	...;i perid="" s perid=subobj.TrainPerDR.PerNo
	...s pername=subobj.TrainPerDR.PerName
	...s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	...q:(perinfo'="")&&($zcvt(perid,"U")'[$zcvt(perinfo,"U"))&&($zcvt(pername,"U")'[$zcvt(perinfo,"U"))&&($zcvt(pershort,"U")'[$zcvt(perinfo,"U"))
	...s score=subobj.TrainScore
	...q:((minscore'="")&&(+minscore>score))||((maxscore'="")&&(+maxscore<score))
	...s TrainType=parobj.TrainType
	...s TrainTitle=parobj.TrainTitle
	...s TypeDesc=$case(TrainType,"N":"开展新技术新业务","B":"业务学习","C":"夜查房培训","T":"教学培训")
	...s TrainStatus=parobj.TrainStatus
	...s StatusDesc=$case(TrainStatus,"N":"未提交","Y":"已提交",:"")
	...s PerID="",PerName="",TrainScore=""
	...i subobj.TrainPerDR'="" d
	....s TrainPerDR=subobj.TrainPerDR.%Id()
	....i subobj.TrainPerDR.PerID'="" s PerID=subobj.TrainPerDR.PerID
	....e  s PerID=subobj.TrainPerDR.PerNo
	....s PerName=subobj.TrainPerDR.PerName
	....s TrainScore=subobj.TrainScore
	...s tmp(perid,parid)="PerID|"_PerID_"^PerName|"_PerName_"^TrainScore|"_TrainScore_"^TrainTitle|"_TrainTitle
	
	s temp=""
	s tmpRw="" f  s tmpRw=$o(title(tmpRw)) q:tmpRw=""  d
	.s nurseID="" f  s nurseID=$o(tmp(nurseID)) q:nurseID=""  d
	..i $g(tmp(nurseID,tmpRw))'="" d
	...s temp(nurseID,tmpRw)="score"_tmpRw_"|"_$p($p(tmp(nurseID,tmpRw),"^",3),"|",2)
	..e  s temp(nurseID,tmpRw)="score"_tmpRw_"|"
	
	s tempID="" f  s tempID=$o(temp(tempID)) q:tempID=""  d
	.s NurseName="",totalScore=0,avgScore=0,ret=""
	.s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(tempID)
	.q:'$IsObject(PerObj)
	.s NurseName=PerObj.PerName
	.s ret="NurseName|"_NurseName
	.s n=0
	.s tempRw="" f  s tempRw=$o(temp(tempID,tempRw)) q:tempRw=""  d
	..s score=$p(temp(tempID,tempRw),"|",2)
	..i score'="" s n=n+1,totalScore=totalScore+score
	..s ret=ret_"^score"_tempRw_"|"_score
	.i n'=0 s avgScore=$fn(totalScore/n,"",2)
	.e  s avgScore=""
	.s ret=ret_"^avgScore|"_avgScore
	.d OutTrainScore
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTrainScore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrainExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainExportExecute ]
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
