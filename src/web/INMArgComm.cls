/// Creator:wangpf
/// Desctiptions:排班模块方法类
/// Date:2020-06-22
Class web.INMArgComm Extends %RegisteredObject
{

/// Description: 保存排班人员分组
/// Date: 2020-06-22
/// Creator: wangpf
/// Table: DHCINM.Arg.MgNurGroup
/// Input: 
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).SaveNurGroup("")
ClassMethod SaveNurGroup(parr As %String) As %String
{
	q:parr="" 0
	s ward=$p(parr,"^")
	s groupDesc=$p(parr,"^",2)
	s groupMaster=$p(parr,"^",3)
	s groupMember=$p(parr,"^",4)
	s groupMemberList=$lfs(groupMember,",")
	s groupBedGroup=$p(parr,"^",5)
	s groupResBeds=$p(parr,"^",6)
	s groupResBedsList=$lfs(groupResBeds,",")
	s groupRemark=$p(parr,"^",7)
	s rw=$p(parr,"^",8)
	q:(ward="")||(groupDesc="")||(groupMaster="") 0
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	q:'$d(^CF.DHCINM.HR.PersonsD(groupMaster)) 0
	
	i rw="" d
	.s obj=##class(DHCINM.Arg.MgNurGroup).%New()
	.s obj.GroupSort=$o(^DHCINM.Arg.MgNurGroupI("Sort",ward,""),-1)+1
	e  s obj=##class(DHCINM.Arg.MgNurGroup).%OpenId(rw)
	d obj.GroupWardDRSetObjectId(ward)
	s obj.GroupDesc=groupDesc
	d obj.GroupMasterSetObjectId(groupMaster)
	d obj.GroupMember.Clear()
	s ptr=0 f  s status=$listnext(groupMemberList,ptr,per) q:status'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.GroupMember.Insert(per)
	s obj.GroupBedGroup=groupBedGroup
	d obj.GroupResBeds.Clear()
	s ptr=0 f  s status=$listnext(groupResBedsList,ptr,bed) q:status'=1  d
	.d obj.GroupResBeds.Insert(bed)
	s obj.GroupRemark=groupRemark
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取排班人员分组数据
/// Date: 2020-06-22
/// Creator: wangpf
/// Table: DHCINM.Arg.MgNurGroup
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).GetNurGroup("")
ClassMethod GetNurGroup(id As %String) As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgNurGroupD(id))) "入参不能为空"
	s groupGlo=^DHCINM.Arg.MgNurGroupD(id)
	s groupWard=$lg(groupGlo,2)
	s groupWardDesc=""
	i groupWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(groupWard))
	.s groupWardDesc=$lg(wardGlo,4)
	s groupDesc=$lg(groupGlo,3)
	s groupMaster=$lg(groupGlo,4)
	s groupMasterName=""
	i groupMaster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(groupMaster))
	.s groupMasterName=$lg(perGlo,2)
	s groupMemberList=$lg(groupGlo,5)
	s groupMemberId=$lts(groupMemberList)
	s groupMemberName="",counter=0
	s ptr=0 f  s status=$listnext(groupMemberList,ptr,per) q:status'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i counter=0 s groupMemberName=perName
	.e  s groupMemberName=groupMemberName_","_perName
	.s counter=counter+1
	s groupResBeds=$lg(groupGlo,6)
	s groupResBedId=$lts(groupResBeds)
	s groupResBedDesc="",counter=0
	s ptr=0 f  s status=$listnext(groupResBeds,ptr,bed) q:status'=1  d
	.s pacWard=$p(bed,"__")
	.s SubId=$p(bed,"__",2)
	.s bedCode=$p($g(^PAWARD(pacWard,"BED",SubId)),"^",1)
	.q:bedCode=""
	.i counter=0 s groupResBedDesc=bedCode
	.e  s groupResBedDesc=groupResBedDesc_","_bedCode
	.s counter=counter+1
	s groupRemark=$lg(groupGlo,7)
	s groupBedGroup=$lg(groupGlo,8)
	s groupBedGroupDesc=##class(web.INMHISComm).GetWardProGroup(groupBedGroup)
	s ret="GroupWard|"_groupWard_"^GroupWardDesc|"_groupWardDesc_"^GroupDesc|"_groupDesc_"^GroupMaster|"_groupMaster_"^GroupMasterName|"_groupMasterName
	s ret=ret_"^GroupMember|"_groupMemberId_"^GroupMemberName|"_groupMemberName_"^GroupResBeds|"_groupResBedId_"^GroupResBedsDesc|"_groupResBedDesc
	s ret=ret_"^GroupRemark|"_groupRemark_"^GroupBedGroup|"_groupBedGroup_"^GroupBedGroupDesc|"_groupBedGroupDesc_"^rw|"_id
	q ret
}

/// Description：查询病区护士分组
/// Date:2020-06-22
/// Creator:wangpf
/// Table:DHCINM.Arg.MgNurGroup
/// Input: 病区Id
/// Output:病区护士分组
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindNurGroupList",1,0,0)
Query FindNurGroupList(ward As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurGroupListExecute(ByRef qHandle As %Binary, ward As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (ward="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s groupWard="" f  s groupWard=$o(^DHCINM.Arg.MgNurGroupI("Sort",groupWard)) q:groupWard=""  d
	.q:(ward'="")&&(ward'=groupWard)
	.q:(isAll'=1)&&('$d(tmpWard(groupWard)))
	.s groupSort="" f  s groupSort=$O(^DHCINM.Arg.MgNurGroupI("Sort",groupWard, groupSort)) q:groupSort=""  d
	..s groupId="" f  s groupId=$o(^DHCINM.Arg.MgNurGroupI("Sort",groupWard, groupSort,groupId)) q:groupId=""  d
	...q:'$d(^DHCINM.Arg.MgNurGroupD(groupId))
	...s ret=..GetNurGroup(groupId)
	...d:ret'="" OutNurseList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurGroupListExecute ]
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

/// Description: 删除排班人员分组
/// Date: 2020-06-22
/// Creator: wangpf
/// Table: DHCINM.Arg.MgNurGroup
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).DeleteNurGroup(1)
ClassMethod DeleteNurGroup(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Arg.MgNurGroup).%DeleteId(id)
	q $$$ISOK(sc)
}

/*
*---------------------------分割线----------------------------
*/
/// creator: xbl
/// createdate: 20170901
/// description: 获取排班记录
/// table: DHCINM.Arg.MgArrange
/// input:
/// output:
/// other: w ##class(web.INMArgComm).GetArrange(22)
ClassMethod GetArrange(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.Arg.MgArrange).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ArgListNo|"_obj.ArgListNo
	i obj.ArgWardDR'="" d
	.s ret=ret_"^ArgWardDR|"_obj.ArgWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.ArgWardDR.WardDesc
	i obj.ArgStDate'="" s ret=ret_"^ArgStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgStDate)
	i obj.ArgEndDate'="" s ret=ret_"^ArgEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgEndDate)
	s ArgRemarks=""
	i ((obj.ArgRemarks="")&&(obj.ArgStatus="N")) d
	.s lastWeek=obj.ArgStDate-1
	.s lastRw=$o(^DHCINM.Arg.MgArrangeI("WardEndDate",obj.ArgWardDR.%Id(),lastWeek,""))
	.i lastRw'="" d
	..s lastObj=##class(DHCINM.Arg.MgArrange).%OpenId(lastRw)
	..q:'$IsObject(lastObj)
	..s ArgRemarks=lastObj.ArgRemarks
	e  s ArgRemarks=obj.ArgRemarks
	s ret=ret_"^ArgRemarks|"_ArgRemarks
	s ret=ret_"^ArgStatus|"_obj.ArgStatus
	s ret=ret_"^StatusDesc|"_$case(obj.ArgStatus,"N":"草稿","S":"保存","R":"提交","B":"驳回",:"")
	;i obj.ArgCrtUser'="" d
	;.s ret=ret_"^ArgCrtUser|"_obj.ArgCrtUser.%Id()
	;.s ret=ret_"^CrtUserName|"_obj.ArgCrtUser.PerName
	;e  d
	;.s ret=ret_"^ArgCrtUser|0"
	;.s ret=ret_"^CrtUserName|管理员"
	s ret=ret_"^ArgCrtUser|"_obj.ArgCrtUser
	s ArgCrtUserName=""
	i obj.ArgCrtUser=0 s ArgCrtUserName="管理员"
	e  d
	.s argCrtUserObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.ArgCrtUser)
	.s:$IsObject(argCrtUserObj) ArgCrtUserName=argCrtUserObj.UserName
	s ret=ret_"^CrtUserName|"_ArgCrtUserName
	i obj.ArgCrtDate'="" s ret=ret_"^ArgCrtDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgCrtDate)
	i obj.ArgCrtTime'="" s ret=ret_"^ArgCrtTime|"_$zt(obj.ArgCrtTime,1)
	s ret=ret_"^ArgEditFlag|"_obj.ArgEditFlag
	s ret=ret_"^EditFlagDesc|"_$case(obj.ArgEditFlag,"S":"申请","A":"批准",:"")
	i obj.ArgAuthorDate'="" s ret=ret_"^ArgAuthorDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgAuthorDate)
	i obj.ArgAuthorTime'="" s ret=ret_"^ArgAuthorTime|"_$zt(obj.ArgAuthorTime,1)
	s ret=ret_"^ArgAuthorHours|"_obj.ArgAuthorHours
	i obj.ArgSubmitDate'="" s ret=ret_"^ArgSubmitDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgSubmitDate)
	i obj.ArgSubmitTime'="" s ret=ret_"^ArgSubmitTime|"_$zt(obj.ArgSubmitTime,1)
	s ArgCurrentWeek=""
	i obj.ArgStDate'="" s ArgCurrentWeek="第"_$SYSTEM.SQL.CEILING($zd(obj.ArgStDate,14)/7)_"周"
	s ret=ret_"^ArgCurrentWeek|"_ArgCurrentWeek
	i (obj.ArgSubmitDate'="")&&((obj.ArgStatus="R")||(obj.ArgStatus="A")) s ArgSubmitDate=$zd(obj.ArgSubmitDate,3)
	e  s ArgSubmitDate=""
	s ArgCrtUpdateLog="否"
	i $D(^DHCINM.Arg.MgArrangeLogI("Arrange",obj.%Id())) s ArgCrtUpdateLog="是"
	s ret=ret_"^ArgCrtUpdateLog|"_ArgCrtUpdateLog_"^ArgOtherRemark|"_obj.ArgOtherRemark_"^ArgSubmitDate|"_ArgSubmitDate
	q ret
}

///  creator: xbl
///  createdate: 20170901
///  description: 排班记录列表
///  table: DHCINM.Arg.MgArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArrangeList","^2017-10-01^2017-11-30^","")
Query FindArrangeList(parr As %String = "", input As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArrangeListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s status=$P(parr,"^",4)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s listno="" f  s listno=$O(^DHCINM.Arg.MgArrangeI("ListNo",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCINM.Arg.MgArrangeI("ListNo",listno,id),-1) q:id=""  d
	..s obj=##class(DHCINM.Arg.MgArrange).%OpenId(id)
	..q:(isAll=0)&&(('$IsObject(obj.ArgWardDR))||('$d(tmpWard(obj.ArgWardDR.%Id()))))
	..q:(ward'="")&&(obj.ArgWardDR'="")&&(ward'=obj.ArgWardDR.%Id())
	..q:((stdate'="")&&(obj.ArgEndDate'="")&&(stdate>obj.ArgEndDate))||((enddate'="")&&(obj.ArgStDate'="")&&(enddate<obj.ArgStDate))
	..q:(status'="")&&(obj.ArgStatus'=status)
	..s ret=..GetArrange(id)
	..d OutArrange
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArrange
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeListExecute ]
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

/// Creator:gzj
/// CreateDate:2019-01-10
/// Description:获取排班主表记录状态
/// Table:DHCINM.Arg.MgArrange
/// Input：主表记录ID
/// Output:输出状态
/// Return:返回状态码 1：提交 2：审核 0：其他
/// Other:
ClassMethod GetArgRowState(id As %String) As %String
{
	s ^TMP("GetArgRowState")=id
	q:id="" ""
	s flag=""
	s obj=##class(DHCINM.Arg.MgArrange).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.ArgStatus="R" s flag="提交"
	e  i obj.ArgStatus="A" s flag="审核"
	e  i obj.ArgStatus="B" s flag="驳回"
	q flag
}

/// creator: xbl
/// createdate: 20170901
/// description: 删除排班记录
/// table: DHCINM.Arg.MgArrange
/// input:
/// output:
/// other:
ClassMethod DeleteArrange(id As %String) As %String
{
	q:id="" ""
	TStart
	s sc=##class(DHCINM.Arg.MgArrange).%DeleteId(id)
	i $$$ISOK(sc) 
	{	
		s flag=0
		s rid=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",id,""))
		f {
			q:rid=""
			s rsc=##class(DHCINM.Arg.MgArrangeRow).%DeleteId(rid)
			i $$$ISERR(rsc) s flag=1 d $System.Status.DisplayError(rsc) w !,"r"
			q:$$$ISERR(rsc)
			s rid=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",id,rid))
		}
		q:flag=1
		s sid=$O(^DHCINM.Arg.MgArrangeSubI("Arg",id,""))
		f {
			q:sid=""
			s ssc=##class(DHCINM.Arg.MgArrangeSub).%DeleteId(sid) 
			i $$$ISERR(ssc) s flag=1 d $System.Status.DisplayError(ssc) w !,"s"_sid
			q:$$$ISERR(ssc)
			s sid=$O(^DHCINM.Arg.MgArrangeSubI("Arg",id,sid))
		}
		q:flag=1
		s gid=$O(^DHCINM.Arg.MgArrangeGroupI("Arrange",id,""))
		f {
			q:gid=""
			s gsc=##class(DHCINM.Arg.MgArrangeGroup).%DeleteId(gid)
			i $$$ISERR(gsc) s flag=1 d $System.Status.DisplayError(gsc) w !,"g"
			q:$$$ISERR(gsc)
			s gid=$O(^DHCINM.Arg.MgArrangeGroupI("Arrange",id,gid))
		}
		TCommit
		q 1
	}
	TRollback
	q 0
}

///  creator: lulin
///  createdate: 2018-08-23
///  description: 未按时提交排班记录列表【提交晚于开始日期，未提交但开始日期大于当前日期】
///  table: DHCINM.Arg.MgArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindNotCurrentArgList","2022-01-01^2022-03-31","",0)
Query FindNotCurrentArgList(parr As %String = "", input As %String = "", nurseid As %String = "", outType As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNotCurrentArgListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "", outType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:+stdate=0 stdate=+$h
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s:+enddate=0 enddate=+$h
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s type=$lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),2)
	i type'="Month" d
	.s stDay=$zd(stdate,10)
	.s stdate=stdate-(stDay+6#7)
	.s endDay=$zd(enddate,10)
	.s enddate=enddate-(endDay+6#7)
	e  d
	.s stDay=+$zd(stdate,4)
	.s stdate=stdate-stDay+1
	.s endDay=+$zd(enddate,4)
	.s enddate=enddate-endDay+1
	
	s count=0,dayCount=0,wardCount=0
	s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	.q:(isAll'=1)&&('$d(tmpWard(id)))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	.s wardDesc=$lg(wardGlo,4)
	.s wardCount=wardCount+1
	.s date=stdate
	.f  q:date>enddate  d
	..s dayCount=dayCount+1
	..s argListNo=$zd(date,8)_id
	..s dateEnd=$case(type,"Month":$SYSTEM.SQL.LASTDAY(date),:date+6)
	..s argId=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_argListNo,""))
	..s ret="ArgWardDR|"_id_"^WardDesc|"_wardDesc_"^ArgStDate|"_$zd(date,3)_"^ArgEndDate|"_$zd(dateEnd,3)
	..i (argId="")&&(+$h>date) d ;i (argId="")&&(+$h-7>date)
	...s count=count+1
	...q:outType=1
	...s ret=ret_"^ArgSubmitDate|^ArgCrtUser|^CrtUserName|^ArgCrtDate|"
	...d OutNotCurrentArg
	..e  i argId'="" d
	...q:'$d(^DHCINM.Arg.MgArrangeD(argId))
	...s argGlo=^DHCINM.Arg.MgArrangeD(argId)
	...s argStatus=$lg(argGlo,7)
	...s argSubDate=$lg(argGlo,15)
	...q:((argStatus="R")||(argStatus="A"))&&((argSubDate="")||(date>argSubDate))
	...q:(argStatus'="R")&&(argStatus'="A")&&(date>+$h)
	...s count=count+1
	...q:outType=1
	...s:argSubDate'="" argSubDate=$zd(argSubDate,3)
	...s creator=$lg(argGlo,8)
	...s creatorName=""
	...i creator=0 s creatorName="管理员"
	...e  i creator'="" d
	....s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	....s creatorName=$lg(perGlo,2)
	...s createDate=$lg(argGlo,9)
	...s:createDate'="" createDate=$zd(createDate,3)
	...s ret=ret_"^ArgSubmitDate|"_argSubDate_"^ArgCrtUser|"_creator_"^CrtUserName|"_creatorName_"^ArgCrtDate|"_createDate
	...d OutNotCurrentArg
	..s date=dateEnd+1
	
	i outType=1 d
	.s ret="Count|"_(dayCount*wardCount-count)_"^Desc|及时提交"
	.d OutNotCurrentArg
	.s ret="Count|"_count_"^Desc|未及时提交"
	.d OutNotCurrentArg
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNotCurrentArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNotCurrentArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNotCurrentArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNotCurrentArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNotCurrentArgListExecute ]
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

/// creator: llin	
/// createdate: 2018-08-02
/// description: 获取修改记录表
/// table: DHCINM.Arg.MgArrangeLog
/// input: 
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgLogList","12^2018-12-01^2018-12-31^",0,0)
Query FindArgLogList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgLogListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s ^TMP("FindArgLogList")=parr_"%"_nurseid
	s repid=$I(^CacheTemp)
	s ind=1
	s sargid=$p(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s ward=$P(parr,"^",4)
	i sargid="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeD(argid)) q:argid=""  d
	.q:(sargid'="")&&(sargid'=argid)
	.s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	.q:'$IsObject(argObj)
	.q:'$IsObject(argObj.ArgWardDR)
	.q:(ward'="")&&(argObj.ArgWardDR.%Id()'=ward)
	.q:(isAll=0)&&('$d(tmpWard(argObj.ArgWardDR.%Id())))
	.q:(sargid="")&&(stdate'="")&&(stdate>argObj.ArgStDate)
	.q:(sargid="")&&(enddate'="")&&(enddate<argObj.ArgStDate)
	.s id=""  f  s id=$O(^DHCINM.Arg.MgArrangeLogI("Arrange",argid,id)) q:id=""  d
	..s obj=##class(DHCINM.Arg.MgArrangeLog).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(sargid'="")&&(stdate'="")&&(stdate>obj.ArgLogCrtDate)
	..q:(sargid'="")&&(enddate'="")&&(enddate<obj.ArgLogCrtDate)
	..s perdr=obj.ArgLogPerDR
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	..q:'$IsObject(perObj)
	..s perID=perObj.PerID
	..s ret="logWard|"_argObj.ArgWardDR.WardDesc_"^logArgStDate|"_##class(web.INMHISComm).DateLogicalToHtml(argObj.ArgStDate)
	..s ret=ret_"^perID|"_perID
	..s perName=perObj.PerName
	..s ret=ret_"^perName|"_perName
	..s logBefor=obj.ArgLogBefor
	..s ret=ret_"^logBefor|"_logBefor
	..s logAfter=obj.ArgLogAfter
	..s ret=ret_"^logAfter|"_logAfter
	..s logPost=logAfter
	..s:logAfter="" logPost=logBefor
	..s ret=ret_"^logPost|"_logPost
	..s argDate=obj.ArgLogArgDate
	..s:argDate'="" argDate=##class(web.INMHISComm).DateLogicalToHtml(argDate)
	..s ret=ret_"^argDate|"_argDate
	..s logMark=obj.ArgLogRemark
	..s:(((logBefor'="")||(logAfter'=""))&&(logMark'["删除")) logMark=logMark_logBefor_"->"_logAfter
	..s ret=ret_"^logMark|"_logMark
	..s logcrtid=obj.ArgLogCrt
	..s logCrtName=""
	..i logcrtid=0 d
	...s logCrtName="管理员"
	..e  d
	...s logCrtObj=##class(CF.DHCINM.DB.MgUser).%OpenId(logcrtid)
	...;s logCrtObj=##class(CF.DHCINM.HR.Persons).%OpenId(logcrtid)
	...s logCrtName=logCrtObj.UserName
	..s:logCrtName="" logCrtName=logcrtid
	..s ret=ret_"^logCrtName|"_logCrtName
	..s logCrtDate=obj.ArgLogCrtDate
	..s:logCrtDate'="" logCrtDate=##class(web.INMHISComm).DateLogicalToHtml(logCrtDate)
	..s ret=ret_"^logCrtDate|"_logCrtDate
	..s logCrtTime=obj.ArgLogCrtTime
	..s:logCrtTime'="" logCrtTime=$zt(logCrtTime,1)
	..s ret=ret_"^logCrtTime|"_logCrtTime
	..s ret=ret_"^rw|"_obj.%Id()
	..s reason=obj.ArgLogReason
	..i reason="null" s reason=""
	..s ret=ret_"^logReason|"_reason
	..d OutArgLogData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgLogData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgLogListExecute ]
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
/// createdate: 2018-05-02
/// description: 是否存在某排班
/// table: 
/// input: 病区id^病区开始日期
/// output:
/// other:w ##class(web.INMArgComm).IsExsitArg("62^2018-04-30")
ClassMethod IsExsitArg(parr As %String = "") As %String
{
	s ward=$p(parr,"^")
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	q:((ward="")||(stdate="")) 0
	s argid=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_$zd(stdate,8)_ward,""))
	s:argid="" argid=0
	q argid
}

/// creator: 
/// createdate: 2017-09-02
/// description: 排班明细
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArrangeSubList","2^2022-06-06^2022-06-12","",0)
Query FindArrangeSubList(parr As %String = "", input As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArrangeSubListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s starttime= $p($H,",",2)
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i (ward="")!(stdate="")!(enddate="")!(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tmpHoliday="",tmpWorkDay=""
	s yearSt=$p($zd(stdate,3),"-",1)
	s yearEnd=$p($zd(enddate,3),"-",1)
	s sc=..setHolidayTmp(yearSt,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearSt,.tmpWorkDay,1)
	s sc=..setHolidayTmp(yearEnd,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearEnd,.tmpWorkDay,1)
	
	s isEditPost=0 ;编辑权限
	s moduleId=$o(^CT.DHCINM.Set.MgModuleI("Code"," WARDARRANGE",""))
	s menuId=$o(^CT.DHCINM.Set.MgMenuI("Code"," ARRANGELIST",""))
	s argBtnId=""
	i menuId'="" d
	.s argBtnId=$o(^CT.DHCINM.Set.MgMenuElementI("Code",menuId," ARGTABLESURE",""))
	i nurseid=0  s isEditPost=1
	e  d
	.q:(moduleId="")||(menuId="")||(argBtnId="")
	.s userRoleIds=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	.f i=1:1:$l(userRoleIds,"^") q:isEditPost=1  d
	..s role=$p(userRoleIds,"^",i)
	..s limitId=$o(^CT.DHCINM.Set.MgLimitSetI("sort"," "_role," "_moduleId,""))
	..q:limitId=""
	..s limitSubId=$o(^CT.DHCINM.Set.MgLimitSetSubI("Menu",limitId," "_moduleId_"-"_menuId,""))
	..q:limitSubId=""
	..s limitSubObj=##class(CT.DHCINM.Set.MgLimitSetSub).%OpenId(limitId_"||"_limitSubId)
	..q:limitSubObj.Elements.Find(moduleId_"-"_menuId_"-"_argBtnId)=""
	..s isEditPost=1
	
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s row=1
	s PerSort=1
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s GrpDesc=""
	...s grpobj=""
	...i grptyp="G" d //分组行数据
	....i (+grp=0)||($d(^DHCINM.Arg.MgNurGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^remarkedit|0^bededit|0"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grp)
	.....s bedCodes=""
	.....f i=1:1:grpobj.GroupResBeds.Count() d
	......s bedId=grpobj.GroupResBeds.GetAt(i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"__",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^remarkedit|0^bededit|0"_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCINM.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^remarkedit|0^bededit|0"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(grp)
	.....s bedCodes=""
	.....f i=1:1:grpobj.GroupResBeds.Count() d
	......s bedId=grpobj.GroupResBeds.GetAt(i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"__",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^remarkedit|0^bededit|0"_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...//护士行数据信息
	...s GrpSort=0
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s GrpSort=GrpSort+1
	.....s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.....q:'$IsObject(perobj)
	.....s PerWorkDate=perobj.PerWorkDate
	.....s WorlYear=""
	.....s:PerWorkDate'="" WorlYear=$P(##class(web.INMVueComm).CalAge($zd(PerWorkDate,3),$zd(+$H,3)),"Y",1)
	.....s nurInfo=..GetNurseLevel(stdate,perdr) //珠海改进方法 2019-01-04 gzj新增
	.....s roledesc=""
	.....s argParamGlo=$g(^CT.DHCINM.Set.MgArgParamSetD(1))
	.....s argIconSort=$lg(argParamGlo,40)
	.....s argIconLen=$ll(argIconSort)
	.....f argIconIndex=argIconLen:-1:1 d
	......s curSort=$lg(argIconSort,argIconIndex)
	......i curSort="T" d
	.......s:perobj.PerTypeDR="S" roledesc=$lg(argParamGlo,38)
	.......s:..IsPerOutTrain(perdr_"^"_stdate) roledesc=$lg(argParamGlo,39)
	.......s:(($IsObject(grpobj))&&($IsObject(grpobj.GroupMaster))&&(grpobj.GroupMaster.%Id()=perdr)) roledesc=$lg(argParamGlo,37)
	......e  i curSort="P" d
	.......s roledesc=$p(##class(web.INMHRComm).GetNurseDuty(perdr,+$h),"^",4)
	......e  i curSort="H" d
	.......s roledesc=$p(##class(web.INMHRComm).GetNurseHireDuty(perdr,+$h),"^",8)
	.....s argrowid=nurlist(ward,grptyp,grp,sort,perdr)
	.....s leveldesc=$P(nurInfo,"^",1)
	.....s showPerName=roledesc_perobj.PerName_perobj.PerID
	.....s ret="PerName|"_showPerName_"^PerID|"_perobj.PerID_"^WorlYear|"_WorlYear_"^ArgPerDR|"_perdr_"^ArgRowId|"_$case(argrowid,"-":"",:argrowid)_"^ArgPerSort|"_row
	.....s ret=ret_"^LevelDesc|"_leveldesc_"^GrpDesc|"_GrpDesc_"^GrpSort|"_GrpSort_"^isEditPost|"_isEditPost_"^PerSort|"_PerSort
	.....s PerSort=PerSort+1
	.....s PerPost=$p(##class(web.INMHRComm).GetNurseHireDuty(perdr,+$h),"^",2)
	.....s ret=ret_"^PerPost|"_PerPost
	.....s ret=ret_"^ArgGroupDR|"_grp
	.....s PerCode=perobj.PerPostName
	.....s totalminute=0,nightminute=0,secminute=0,plusminute=0
	.....i ((argid'="")&&(+argrowid'=0)&&($d(^DHCINM.Arg.MgArrangeRowD(argrowid)))) d
	......s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	......q:'$IsObject(rowObj)
	......s:rowObj.ArrangeDR.ArgStatus'="N" PerCode=rowObj.ArgPerCode
	......s ret=ret_"^ArgWorkRemark|"_rowObj.ArgWorkRemark
	......s ret=ret_"^ArgPerBeds|"_rowObj.ArgPerBeds
	......;s totalminute=0,nightminute=0,secminute=0,plusminute=0
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc="",cellstyle="",appCellDesc="",appHasRemark="N"
	.......s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	.......s isAskLeave=$p(tmpIsAskLeave,"^")
	.......s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	.......i (isAskLeave=1)&&($p(tmpIsAskLeave,"^",3)'="") d
	........s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId($p(tmpIsAskLeave,"^",3))
	........s:$IsObject(postObj) cellstyle=postObj.PostDR.PostFontColor_"!"_postObj.PostDR.PostBgColor,leaveflag=1
	.......s replaceDesc="%"
	.......s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.......s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||本病区护士在其他病区有排班...||护士长添加人员其他病区有排班
	.......;i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	.......i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)) d
	........s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	........s celldesc="」"_curwardObj.WardDesc,appCellDesc=celldesc
	.......e  d
	........s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.........q:+id=0
	.........q:isAskLeave=1
	.........s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.........q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	.........s PostDesc=""
	.........i obj.ArgType="Y" d
	..........s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  i obj.ArgType="N" d
	..........s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  s PostDesc=obj.ArgPostDR.PostDesc
	.........;【南通中医备注添加上】
	.........;i celldesc="" s celldesc=id_"」"_obj.ArgPostDR.PostDesc
	.........;e  s celldesc=celldesc_"「"_id_"」"_obj.ArgPostDR.PostDesc
	.........s workTime=""
	.........s:obj.ArgStTime1'="" workTime=obj.ArgStTime1_"-"_obj.ArgEndTime1
	.........s:obj.ArgStTime2'="" workTime=workTime_";"_obj.ArgStTime2_"-"_obj.ArgEndTime2
	.........s:obj.ArgStTime3'="" workTime=workTime_";"_obj.ArgStTime3_"-"_obj.ArgEndTime3
	.........i celldesc="" s celldesc=id_"」"_PostDesc_obj.ArgRemark_"『"_workTime,appCellDesc=id_"」"_PostDesc_"『"_workTime
	.........e  s celldesc=celldesc_"「"_id_"」"_PostDesc_obj.ArgRemark_"『"_workTime,appCellDesc=appCellDesc_"「"_id_"」"_PostDesc_"『"_workTime
	.........s:cellstyle'="" cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.........s:cellstyle="" cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.........s:(appHasRemark'="Y")&&(obj.ArgRemark'="") appHasRemark="Y"
	.........//请假处理
	.........s:obj.ArgPostDR.PostDR.PostType="H" isAskLeave=0
	.........q:obj.ArgPostDR.PostDR.PostType="H"
	.........s ArgIsReplace=obj.ArgIsReplace
	.........i (ArgIsReplace'="") d
	..........s:$IsObject(obj.ArgReplaceDR) replaceDesc=$Case(ArgIsReplace,"2":"替",:"")_obj.ArgReplaceDR.PerName_$Case(ArgIsReplace,"1":"替",:"")
	........s totalminute=totalminute+..CountMinutes(perdr,date,ward,0)+..CountOutTrainMinutes(perdr,date,.tmpHoliday,.tmpWorkDay)
	........s nightminute=0 ;nightminute+..CountNightMinutes(perdr,date,ward,0)
	........s secminute=0 ;secminute+..CountSecondMinutes(perdr,date,ward,0)
	........s plusminute=plusminute+..CountMinutesPlus(perdr,date,ward,0)
	.......s:(replaceDesc="%")&&(isAskLeave=1) replaceDesc="%"_askLeaveDesc
	.......//意愿排班
	.......s wishArg="%"_..getWishArrangeForArgSub(ward,date,perdr)
	.......s ret=ret_celldesc_replaceDesc_wishArg_"^Color"_$zd(date,3)_"|"_cellstyle_"^AppDate"_$zd(date,3)_"|"_appCellDesc_replaceDesc_wishArg_"^AppRemark"_$zd(date,3)_"|"_appHasRemark
	......s totalminute=totalminute+plusminute
	......s ret=ret_"^ArgTotalHour|"_(totalminute\60)_"时"_(totalminute#60)_"分"_"^ArgNightHour|"_(nightminute\60)_"时"_(nightminute#60)_"分"
	......s ret=ret_"^ArgSecondHour|"_(secminute\60)_"时"_(secminute#60)_"分"
	.....e  d
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc="",wishArg="%",appCellDesc="",appHasRemark="N"
	.......s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.......;s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||非本病区排班且护士长添加
	.......i ((curward'="")&&(curward'=ward))||((tWard'="")&&(tWard'=ward)) d ;不是当前科室的
	........s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	........s celldesc="」"_curwardObj.WardDesc_"%",appCellDesc=celldesc
	.......e  d
	........s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	........s isAskLeave=$p(tmpIsAskLeave,"^")
	........s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	........s:isAskLeave=1 celldesc="%"_askLeaveDesc,appCellDesc=celldesc
	.......s:celldesc="" celldesc="%",appCellDesc=celldesc
	.......s totalminute=totalminute+..CountOutTrainMinutes(perdr,date,.tmpHoliday,.tmpWorkDay)
	.......//意愿排班数据
	.......s wishArg=wishArg_..getWishArrangeForArgSub(ward,date,perdr)
	.......s ret=ret_celldesc_wishArg_"^Color"_$zd(date,3)_"|"_"^AppDate"_$zd(date,3)_"|"_appCellDesc_wishArg_"^AppRemark"_$zd(date,3)_"|"_appHasRemark
	......s ret=ret_"^ArgTotalHour|"_(totalminute\60)_"时"_(totalminute#60)_"分"
	.....s:PerCode'="" PerCode=""  ;##class(web.INMPersonComm).GetCommCode(PerCode) ;岗位
	.....s ProductHour=""
	.....s ProductHour=..GetArgProductHour(stdate,enddate,perdr,.tmpHoliday,.tmpWorkDay)
	.....s ret=ret_"^PerCode|"_PerCode_"^ArgProductHour|"_$p(ProductHour,"^")_"^ArgAllProductHour|"_$p(ProductHour,"^",2)_"^remarkedit|0"_"^bededit|0"
	.....d OutArrangeSub
	.....s row=row+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArrangeSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArrangeSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArrangeSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeSubListExecute ]
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

// 设置假日的临时数组

ClassMethod setHolidayTmp(year, tmpHoliday, flag) As %String
{
	q:year="" ""
	s code="" f  s code=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	.s rw="" f  s rw=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(rw)
	..q:'$IsObject(obj)
	..q:obj.HolidayDate=""
	..s start=$zdh($p(obj.HolidayDate,",",1),3)
	..s end=$zdh($p(obj.HolidayDate,",",2),3)
	..q:(flag'=1)&&(obj.HolidayID.SubDesc="班")
	..q:(flag=1)&&(obj.HolidayID.SubDesc'="班")
	..s date="" 
	..f date=start:1:end  d
	...q:$d(tmpHoliday(date))
	...s tmpHoliday(date)=1
	q 1
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取排班表人员列表
/// table: DHCINM.Arg.MgArrangeRow
/// input: 
/// output:
/// other: d ##class(web.INMArgComm).GetWardNurse("","1","2020-08-17","2020-08-23","",.tmp,.tmp2)
ClassMethod GetWardNurse(argid As %String = "", ward As %String = "", stdate As %String = "", enddate As %String = "", pertype As %String, tmp As %String, tmpGroup As %String) As %String
{
	q:(ward="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s OutArgPerType=$lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),35)
	s OutArgPerType=$LFS(OutArgPerType,",")
	s array="",array1=""
	i argid'="" d
	.s argobj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	.q:(argobj.ArgWardDR'="")&&(argobj.ArgWardDR.%Id()'=ward)
	.q:(argobj.ArgStDate'=stdate)&&(argobj.ArgEndDate'=enddate)
	.s perdr="" f  s perdr=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr)) q:perdr=""  d
	..s rowid="" f  s rowid=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,rowid)) q:rowid=""  d
	...s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowid)
	...q:obj.ArgPerDR=""
	...i obj.ArgGroupDR'="" s grpid=obj.ArgGroupDR.%Id()
	...e  s grpid="-"
	...i obj.ArgPerSort'="" s sort=obj.ArgPerSort
	...e  s sort="-"
	...s tmp(ward,"A",grpid,sort,perdr)=rowid
	...s array(perdr)=1
	...i '$d(array1("A",grpid)) s array1("A",grpid)=1,tmpGroup("A",sort,grpid)=grpid
	;q:argid'="" 1
	;1、设置已分的组
	k groupNurSort,groupSort
	s grpid="" f  s grpid=$O(^DHCINM.Arg.MgNurGroupI("Ward",ward,grpid)) q:grpid=""  d
	.s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grpid)
	.s:$IsObject(grpobj.GroupMaster) group(grpobj.GroupMaster.%Id())=grpid
	.f i=1:1:grpobj.GroupMember.Count() d
	..s perdr=grpobj.GroupMember.GetAt(i)
	..q:perdr=""
	..s group(perdr)=grpid
	..s groupNurSort(perdr)=i+1
	.s tGroupSort=grpobj.GroupSort
	.s:tGroupSort="" tGroupSort=99999
	.s groupSort(grpid)=tGroupSort
	
	//调配记录表
	s transst=enddate+1 f  s transst=$O(^CF.DHCINM.Trans.TransDepI("wardtime"," "_ward,transst),-1) q:transst=""  d
	.s trsid="" f  s trsid=$O(^CF.DHCINM.Trans.TransDepI("wardtime"," "_ward,transst,trsid)) q:trsid=""  d
	..s obj1=##class(CF.DHCINM.Trans.TransDep).%OpenId(trsid)
	..q:'$IsObject(obj1)
	..;q:obj1.PerTranCurrent="N"
	..s perdr=obj1.PerDr
	..q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
	..q:$d(array(perdr))
	..s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	..s leavedate=perobj.PerStateDate //离职或退休日期
	..q:(leavedate'="")&&(leavedate<=stdate)
	..q:((perobj.PerTypeDR'="N")&&(OutArgPerType'="")&&($LF(OutArgPerType,perobj.PerTypeDR)>0))
	..q:((perobj.PerTypeDR="P")&&(((perobj.PerInternStDate'="")&&(perobj.PerInternStDate>enddate))||((perobj.PerInternEndDate'="")&&(perobj.PerInternEndDate<stdate))))
	..q:((perobj.PerTypeDR="S")&&(((perobj.PerTrainStDate'="")&&(perobj.PerTrainStDate>enddate))||((perobj.PerTrainEndDate'="")&&(perobj.PerTrainEndDate<stdate))))
	..q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	..s trsstdate=obj1.PerTranStDate
	..s trsenddate=##class(web.INMHRComm).GetTransEndDate(trsid)
	..q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&((trsenddate<=stdate)||(trsenddate=trsstdate)))
	..s grpid=$g(group(perdr)),grptype="G"
	..i argid'="" s grpid="-",grptype="A"
	..i grpid="" s grpid="-"
	..s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grpid)
	..i (($IsObject(grpobj))&&(grpobj.GroupMaster.%Id()=perdr)) d
	...s tmp(ward,grptype,grpid,1,perdr)="-" ;组长放在第一位
	..e  d
	...s tmpSort=$g(groupNurSort(perdr))
	...s:tmpSort="" tmpSort=9999
	...s tmp(ward,grptype,grpid,tmpSort,perdr)="-"
	..i '$d(array1(grptype,grpid)) d
	...s array1(grptype,grpid)=1
	...s tGroupSort=$g(groupSort(grpid))
	...s:tGroupSort="" tGroupSort=99999
	...s tmpGroup(grptype,tGroupSort,grpid)=grpid
#;	..i (($IsObject(grpobj))&&(grpobj.GroupMaster.%Id()=perdr)) d
#;	...s tmp(ward,grptype,grpid,"+",perdr)="-" ;组长放在第一位
#;	..e  s tmp(ward,grptype,grpid,"-",perdr)="-"
#;	..i '$d(array1(grptype,grpid)) s array1(grptype,grpid)=1,tmpGroup(grptype,"-",grpid)=grpid
	q 1
}

/// Creator:gzj
/// CreateDate:2019-01-11
/// Desccription:根据日期获取人员的层级以及显示符号和周标准工作时长
/// 
ClassMethod GetNurseLevel(stdate As %String, perdr As %String) As %String
{
	q:((stdate="")!(perdr="")) ""
	s ret=""
	s level="",status="",hours=0,nurType=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	q:'$IsObject(obj) ""
	
	s PerInternDate=obj.PerInternDate  ///实习生转助护日期	
	s PerInternToStu=obj.PerInternToStu ///实习生转学员日期
	s PerStuToAss=obj.PerStuToAss // 学员 转成助护的日期
	s PerStuToNurse=obj.PerStuToNurse /// 学员转成护士的日期
	s PerAssToNurse=obj.PerAssToNurse /// 助护转成护士的日期
	s PerAssToStu=obj.PerAssToStu /// 助护转 学员 日期
	s PerTypeDR=obj.PerTypeDR //人员类型
	///判断是实习生
	///第一种情况 所有日期都为空 并且类型为P
	///第二种情况 实习生转助护的日期不为空 类型为A（助护） 其他日期都为空 且stdate小于该日期
	///第三种情况 实习生转学员的日期不为空 类型为T（学员） 其他日期都为空 且stdate小于该日期
	///第四种情况 实习生转为学员的日期不为空 学员转为助护的日期不为空 且实习转为学员的日期小于学员转为助护的日期且stdate 小于实习生转为学员的日期
	///第五种情况 实习生转为助护的日期不为空 助护转为学员的日期不为空 且实习生转助护的日期小于助护转学员的日期且stdate小于实习生转助护的日期
	///第六种情况实习生转学员日期不空 学员转助护日期不空 助护转正日期不空 且实习生转学员小于学员转助护  学员转助护小于助护转正 stdate小于实习生转学员
	///第七种情况 实习生转助护日期不空 助护转学员日期不空 学员转正日期不空且实习生转助护小于助护转学员 助护转学员小于学员转正 stdate小于实习生转助护
	i ((PerInternDate="")&&(PerInternToStu="")&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="P") d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="A")&&(stdate<PerInternDate) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="A")&&(stdate<PerInternToStu) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerInternToStu<PerStuToAss)&&(stdate<PerInternToStu)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerInternDate<PerAssToStu)&&(stdate<PerInternDate)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate<PerInternToStu)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate<PerInternDate)) d
	.s level="",status="$",hours=35,nurType="P"
	///判断是学员
	///第一种情况日期都为空 且类型为T 则一定是学员
	///第二种情况 实习转学员日期不空，其他日期都空且stdate大于该日期
	///第三种情况 实习转学员日期不空且 学员转助护日期不空且 实习转学员小于学员转助护且stdate大于实习生转学员 且stdate小于学员转助护
	///第四种情况 实习转学员日期不空且学员转助护日期不空且助护转正日期不空且 实转学小于学转助 小于助转正 且stdate小于学转助 且大于实习转学员
	///第五种情况 实习转学员日期不空且 学员转正日期不为空 其他为空且 实转学小于学转正 且stdate小于学转正 stdate大于实转学
	///第六种情况 实习转学员日期空 学员转助护不空 且类型为A 且stdate小于学员转助护
	///第七种情况 实习转学员日期空 学员转助护不空 助护转正不空 且学转助小于 助转正 且stdate小于 学转助
	///第八种情况 实习转学员日期空 学员转正日期不空其他都空且stdte小于学转正
	///第九种情况 实习转学员日期空 助护转学员日期不空 类型为T 且stdate大于助护转学员
	///第十种情况 实习转学员日期空 助护转学员日期不空 学员转正不空 且助护转学员小于学员转正 且stdate小于学转正大于助转学员日期
	///第十一情况 实习转助护日期不空 助护转学员不空 且类型为T 实习生转助护小于助护转学员 且stdate大于助护转学员
	///第十二情况 实习转助护日期不空 助护转学员不空 学员转正不空且 实转助小于助护转学员 且助转学小于学转正 且stdate大于助转学 且stdate小于学转正
	e  i ((PerInternDate="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerTypeDR="T")) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate>PerInternDate)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerInternToStu<PerStuToAss)&&(stdate>=PerInternToStu)&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate<PerStuToAss)&&(stdate>PerInternToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToNurse'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerInternToStu<PerStuToNurse)&&(stdate<PerStuToNurse)&&(stdate>PerInternToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerStuToAss<PerAssToNurse)&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToNurse'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate<PerStuToNurse)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerAssToStu<PerStuToNurse)&&(stdate<PerStuToNurse)&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(PerInternDate)<(PerAssToStu)&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate>=PerAssToStu)&&(stdate<PerStuToNurse)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	//判断是助护
	///第一种情况 所有日期都为空 且类型为A 则一定是助护
	///第二种情况 实习转助护日期不空 其他日期都空且stdate大于该日期
	///第三种情况 实习转助护日期不空 且助护转学员日期不空 且实习转助护小于助护转学员且stdate大于实习转助护日期且stdate小于助护转学员日期
	///第四种情况 实习转助护日期不空且 助护转学员日期不空且 学员转正不空且 实写转助护小于助护转学员小于学员转正 且stdate大于实习转助 小于助护转学员
	///第五种情况 实习转助护日期不空 助护转正不空 其他空 且实习转助护小于助护转正且stdate大于实习转助护小于助护转正
	///第六种情况 实习转助护日期空 助护转学员不空 且类型为T 且stdate小于助护转学员
	///第七种情况 实习转助护日期空 助护转学员不空 学员转正不空 且助护转学员小于学员转正 且stdate 小于助护转学员
	///第八种情况 实习转助护日期空 助护转正不空 其他空 且stdate小于助护转正日期
	///第九种情况 实习转助护日期空 学员转助护不空 类型为A 且stdate大于学员转助护日期
	///第十种情况 实习转助护日期空 学员转助护不空 助护转正不空 且学员转助护小于助护转正 且stdate大于学员转助护 小于助护转正
	///第十一种情况 实习转学员不空 学员转助护不空 且类型为A 实习转学员小于学员转助护 且stdate大于实习转学员 小于学员转助护
	//第十二情况 实习转学员不空 学员转助护不空 助护转正不空 且实习转学员小于学员转助护 且学员转助护小于助护转正 且stdate大于学员转助护 小于助护转正
	
	e  i ((PerInternDate="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerTypeDR="A")) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate>=PerInternDate)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerInternDate<PerAssToStu)&&(stdate>=PerInternDate)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate>=PerInternDate)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToNurse'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToStu="")&&(PerInternDate<PerAssToNurse)&&(stdate>=PerInternDate)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerAssToStu<PerStuToNurse)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToNurse'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToStu="")&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(stdate>=PerStuToAss)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerStuToAss<PerAssToNurse)&&(stdate>=PerStuToAss)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(PerInternToStu<PerStuToAss)&&(stdate>=PerInternToStu)&&(stdate<PerStuToAss)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate>=PerStuToAss)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  d
	.s level=$p(##class(web.INMHRComm).GetNurseLevel(perdr,stdate),"^",2)
	.s hours=35,nurType="N"
	;s status="" ;.. 
	//进修（S）、实习（P）、护理员（W） 管理员（M） 工人（G）） 助理护士（A） 护理学员（T)
	;i nurType="A" s status=..GetNurseStatus("助理护士","职务")
	;e  i nurType="P" s status=..GetNurseStatus("学员","职务")
	;e  i nurType="S" s status=..GetNurseStatus("进修护士","职务")
	s ret=level_"^"_status_"^"_hours_"^"_nurType
	q ret
}

/// Description: 获取某人某天是否有假
/// Date: 2020-06-28
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: 护士id^date
/// Output: 0：无 1：有
/// Other: w ##class(web.INMArgComm).IsPerAskLeavel2(1^2020-06-30)
ClassMethod IsPerAskLeavel2(parr As %String = "") As %String
{
		s per=$p(parr,"^")
		s date=$p(parr,"^",2)
		s:date["-" date=$zdh(date,3)
		q:(per="")||(date="") 0
		s flag=0
		s id="" f  s id=$o(^DHCINM.Arg.MgLeaveAppI("Nurse",per,id)) q:(id="")||(flag=1)  d
		.q:'$d(^DHCINM.Arg.MgLeaveAppD(id))
		.s leaveGlo=^DHCINM.Arg.MgLeaveAppD(id)
		.s source=$lg(leaveGlo,2)
		.s status=$lg(leaveGlo,13)
		.q:((source="N")&&(status'["A"))||((source="H")&&(status'="HA"))
		.s stDate=$lg(leaveGlo,5)
		.s endDate=$lg(leaveGlo,7)
		.s workDate=$lg(leaveGlo,29)
		.q:$lf(workDate,date)
		.q:(date<stDate)||(date>endDate)
		.s flag=1
		q flag
}

/// Description: 获取某人某天是否有假
/// Date: 2020-06-28
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: 护士id^date
/// Output: 0：无 1：有
/// Other: w ##class(web.INMArgComm).IsPerAskLeavel3(1^2020-06-30)
ClassMethod IsPerAskLeavel3(parr As %String = "") As %String
{
		s per=$p(parr,"^")
		s date=$p(parr,"^",2)
		s:date["-" date=$zdh(date,3)
		q:(per="")||(date="") 0
		s flag=0,decs="",retType=""
		s id="" f  s id=$o(^DHCINM.Arg.MgLeaveAppI("Nurse",per,id)) q:(id="")||(flag=1)  d
		.q:'$d(^DHCINM.Arg.MgLeaveAppD(id))
		.s leaveGlo=^DHCINM.Arg.MgLeaveAppD(id)
		.s source=$lg(leaveGlo,2)
		.s status=$lg(leaveGlo,13)
		.q:((source="N")&&(status'["A"))||((source="H")&&(status'="HA"))
		.s stDate=$lg(leaveGlo,5)
		.s endDate=$lg(leaveGlo,7)
		.s workDate=$lg(leaveGlo,29)
		.q:$lf(workDate,date)
		.q:(date<stDate)||(date>endDate)
		.s type=$lg(leaveGlo,4)
		.s typeDesc=""
		.i (type'="")&&($d(^CF.DHCINM.DB.MgArgWardPostD(type))) d
		..s typeGlo=^CF.DHCINM.DB.MgArgWardPostD(type)
		..s typeDesc=$lg(typeGlo,2)
		.s holidayNum=0
		.f i=stDate:1:date d
		..q:$lf(workDate,i)
		..s holidayNum=holidayNum+1
		.s decs=typeDesc_"["_holidayNum_"]"
		.s flag=1,retType=type,leaveId=id
		q:flag=1 flag_"^"_decs_"^"_retType_"^"_leaveId
		s:..IsPerOutTrain(parr)=1 flag="1^进修"
		q flag
}

/// Description: 获取某人某天是否进修
/// Date: 2022-06-30
/// Creator: liwenzhen
/// Table: DHCINM.HR.MgOutTrain
/// Input: 护士id^date
/// Output: 0：无 1：有
/// Other: w ##class(web.INMArgComm).IsPerOutTrain("22^66294")
ClassMethod IsPerOutTrain(parr As %String = "") As %String
{
	s per=$p(parr,"^")
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	q:(per="")||(date="") 0
	s flag=0
	s outId="" f  s outId=$o(^DHCINM.HR.MgOutTrainI("Per",per,outId)) q:(outId="")||(flag=1)  d
	.s trainGlo=$g(^DHCINM.HR.MgOutTrainD(outId))
	.s trainStDate=$lg(trainGlo,4)
	.s trainEndDate=$lg(trainGlo,5)
	.q:(date<trainStDate)||(date>trainEndDate)
	.s flag=1
		q flag
}

///  creator: lulin
///  createdate: 2018-11-06
///  description: 判断某人某天是否存在不在本病区的排班
///  table: DHCINM.Arg.MgArrange
///  input:
///  output:
///  other:
ClassMethod GetPostForOther(perdr As %String, date As %String, ward As %String) As %String
{
	q:((perdr="")!(date="")!(ward="")) ""
	s retWard=""
	s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,id)) q:((id="")||(retWard'=""))  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgRowDR)
	.;q:obj.ArgRowDR.ArgPerAddFlag'="Y"
	.i (($IsObject(obj.ArgWardDR))&&(obj.ArgWardDR.%Id()'=ward))  s retWard=obj.ArgWardDR.%Id()
	q retWard
}

/// creator: liwenhzen
/// date: 2022-07-01
/// desc:计算当日进修工作时长
/// other: w ##class(web.INMArgComm).CountOutTrainMinutes(3,"2017-11-27")
ClassMethod CountOutTrainMinutes(perdr As %String, date As %String, tmpHoliday, tmpWork)
{
	s argParamGlo=$g(^CT.DHCINM.Set.MgArgParamSetD(1))
	q:argParamGlo="" 0
	s step=+$lg(argParamGlo,17,7)
	s isOutTrain=..IsPerOutTrain(perdr_"^"_date)
	s Minutes=0
	i isOutTrain=1 d
	.i (($zd(date,10)'=6)&&($zd(date,10)'=0))&&('$d(tmpHoliday(date)))||($d(tmpWork(date))) d //(周一到周五&&非假)||(补班)
	..s Minutes=step*60
	q Minutes
}

/// creator: xbl
/// date: 20171120
/// desc:计算当日工作时长【type:1,只取审核。0：取所有】
/// other: w ##class(web.INMArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountMinutes(perdr As %String, date As %String, ward As %String, type As %String) As %Integer
{
	q:((perdr="")||(date="")||(type="")) ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
#;	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
#;	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
#;	.q:'$IsObject(obj)
#;	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
#;	.q:'$IsObject(obj.ArgPostDR)
#;	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
#;	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
#;	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
#;	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
#;	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
#;	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
#;	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
#;	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
#;	..i sttime1["次日" s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
#;	..else  s sttime=0
#;	..s time=time+(endtime-sttime)
#;	.i (sttime2'="")&&(endtime2'="")&&(endtime2["次日") d
#;	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
#;	..i sttime2["次日" s sttime=$zth($E(sttime2,3,$L(sttime2)),1)
#;	..else  s sttime=0
#;	..s time=time+(endtime-sttime)
#;	.i (sttime3'="")&&(endtime3'="")&&(endtime3["次日") d
#;	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
#;	..i sttime3["次日" s sttime=$zth($E(sttime3,3,$L(sttime3)),1)
#;	..else  s sttime=0
#;	..s time=time+(endtime-sttime)
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:'$IsObject(obj.ArgPostDR)
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="") d
	..s sttime=$zth(sttime1,1)
	..i endtime1["次日" s endtime=86400+$zth($e(endtime1,3,*),1)
	..e  s endtime=$zth(endtime1,1)
	..s time=time+(endtime-sttime)
	.i (sttime2'="")&&(endtime2'="") d
	..i sttime2["次日" s sttime=86400+$zth($e(sttime2,3,*),1)
	..e  s sttime=$zth(sttime2,1)
	..i endtime2["次日" s endtime=86400+$zth($e(endtime2,3,*),1)
	..e  s endtime=$zth(endtime2,1)
	..s time=time+(endtime-sttime)
	.i (sttime3'="")&&(endtime3'="") d
	..i sttime3["次日" s sttime=86400+$zth($e(sttime3,3,*),1)
	..e  s sttime=$zth(sttime3,1)
	..i endtime3["次日" s endtime=86400+$zth($e(endtime3,3,*),1)
	..e  s endtime=$zth(endtime3,1)
	..s time=time+(endtime-sttime)

	s minute=time\60
	q minute
}

/// creator: lulin
/// date: 20171120
/// desc:计算当日二线班时长
/// other: w ##class(web.INMArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountSecondMinutes(perdr As %String, date As %String, ward As %String = "", type As %String = "") As %Integer
{
	q:((perdr="")||(date="")||(type="")) ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&((obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A"))
	.q:'$IsObject(obj.ArgPostDR)
	.q:(ward'="")&&('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward)
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgSecStTime,endtime1=obj.ArgSecEndTime
	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..i sttime1["次日" s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
	..else  s sttime=0
	..s time=time+(endtime-sttime)
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgSecStTime,endtime1=obj.ArgSecEndTime
	.i (sttime1'="")&&(endtime1'="")&&(sttime1'["次日") d
	..s sttime=$zth(sttime1,1)
	..i endtime1["次日" s endtime=86400
	..e  s endtime=$zth(endtime1,1)
	..s time=time+(endtime-sttime)
	s minute=time\60
	q minute
}

/// 计算当日夜班小时数
/// other: w ##class(web.INMArgComm).CountNightMinutes(3,"2017-11-27")
ClassMethod CountNightMinutes(perdr As %String, date As %String, ward As %String = "", type As %String = "") As %String
{
	q:(perdr="")!(date="")!(type="") ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s obj1=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(1)
	s monthday=$P($zd(+$h,3),"-",2)_$P($zd(+$h,3),"-",3)
	i (monthday<"1001")&&((monthday>"0501")||(monthday="0501")) d
	.s nsttime=obj1.NightStTime1,nendtime=obj1.NightEndTime1
	e  s nsttime=obj1.NightStTime2,nendtime=obj1.NightEndTime2 
	i nsttime="" s nsttime=$zth("16:00:00",1)
	i nendtime="" s nendtime=$zth("08:00:00",1)
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgPostDR)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..i (sttime1["次日") s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	.i (sttime2'="")&&(endtime2'="")&&(endtime2["次日") d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..i (sttime2["次日") s sttime=$zth($E(sttime2,3,$L(sttime2)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	.i (sttime3'="")&&(endtime3'="")&&(endtime3["次日") d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..i (sttime3["次日") s sttime=$zth($E(sttime3,3,$L(sttime3)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgPostDR)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2	
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="") d
	..s sttime=$zth(sttime1,1)
	..i (endtime1'["次日") s endtime=$zth(endtime1,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	.i (sttime2'="")&&(endtime2'="") d
	..s sttime=$zth(sttime2,1)
	..i (endtime2'["次日") s endtime=$zth(endtime2,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	.i (sttime3'="")&&(endtime3'="") d
	..s sttime=$zth(sttime3,1)
	..i (endtime3'["次日") s endtime=$zth(endtime3,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	s minute=time\60
	q minute
}

/// creator: lulin
/// date: 2018-11-21
/// desc:计算当日加减班
/// other: w ##class(web.INMArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountMinutesPlus(perdr As %String, date As %String, ward As %String = "", type As %String = "", plusType As %String = "", ByRef tmpPlus As %String = "") As %Integer
{
	q:(perdr="")||(date="")||(type="") ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:((obj.ArgType'="Y")&&(obj.ArgType'="N"))
	.q:(plusType'="")&&(obj.ArgType'=plusType)
	.;q:obj.ArgApplyFlag="C" ;排除拒绝的申请
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.i (sttime1'="")&&(endtime1'="") d
	..s endtime=$zth(endtime1,1)
	..s sttime=$zth(sttime1,1)
	..i obj.ArgType="Y" s time=time+(endtime-sttime)
	..e  s time=time-(endtime-sttime)
	..s tmpPlus(obj.ArgWardDR.%Id(),perdr,date,obj.ArgType)=$g(tmpPlus(obj.ArgWardDR.%Id(),perdr,date,obj.ArgType))+time
	s minute=time\60
	q minute
}

/// 本周期积假^累计积假
ClassMethod GetArgProductHour(stdate As %String, enddate As %String, perdr As %String, tmpHoliday, tmpWork) As %String
{
	q:((stdate="")!(enddate="")!(perdr="")!(stdate>enddate)) "0^0"
	
	;默认标准时长7小时
	s argParamObj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(1)
	q:'$IsObject(argParamObj) "0^0"
	s step=+argParamObj.ArgStandardTime
	s:step=0 step=7
	
	;累计积假开始时间:
	;1、周排从本年第一个完整周的周一算起,月排从本年1月1日算起.
	;2、若护士第一次进排班系统日期晚于条件1,从第一次排班日期算起(请假、设置初始化积假也算进入排班系统).
	s yearStart=$zdh(+$zd(stdate,3)_"-01"_"-01",3)
	i argParamObj.ArgPeriod="Week"
	{
		s yearStartWeek=$zd(yearStart,10)
		s:yearStartWeek'=1 yearStart=8-yearStartWeek#7+yearStart
	}
	;第一次排班日期
	s firstDate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,""))
	;第一次请假日期
	k tmpPerLeave
	d ..SetPerLeaveTmp(perdr,.tmpPerLeave)
	s firstLeave=$o(tmpPerLeave(""))
	i (firstDate="")||((firstLeave'="")&&(firstLeave<firstDate)) s firstDate=firstLeave
	;第一次初始化积假日期
	s firstHourDate=$o(^DHCINM.Arg.MgArgHourI("Per",perdr,""))
	;第一次进入排班系统的日期 取第一次排班日期、第一次请假日期、初始化积假日期三者之中的最小值
	i (firstDate="")||((firstHourDate'="")&&(firstHourDate<firstDate)) s firstDate=firstHourDate
	
	;未进入排班系统或者晚于结束日期
	q:(firstDate="")||(firstDate>enddate) "0^0"
	;更新累计积假开始时间
	i firstDate>yearStart s yearStart=firstDate
	
	s hourDate=$o(^DHCINM.Arg.MgArgHourI("Per",perdr,enddate+1),-1)
	s hourId=""
	i hourDate>=yearStart s hourId=$o(^DHCINM.Arg.MgArgHourI("Per",perdr,hourDate,""),-1)
	
	i (hourId'="")&&(hourDate>yearStart) s yearStart=hourDate
	
	;法定假日天数
	s numWeekHoliday=0,numYearHoliday=0
	s date=yearStart-1 f  s date=$o(tmpHoliday(date)) q:(date="")||(date>enddate)  d
	.q:(hourId'="")&&(date<hourDate)
	.s holidayFlag=tmpHoliday(date)
	.i (holidayFlag)&&(($zd(date,10)'=6)&&($zd(date,10)'=0)) d
	..s:(date>=stdate)&&(date<=enddate) numWeekHoliday=numWeekHoliday+1
	..s numYearHoliday=numYearHoliday+1
	
	;周末补班天数
	s numWeekFillWork=0,numYearFillWork=0
	s date=yearStart-1 f  s date=$O(tmpWork(date)) q:(date="")||(date>enddate)  d
	.q:(hourId'="")&&(date<hourDate)
	.s workFlag=tmpWork(date)
	.i workFlag d
	..s:(date>=stdate)&&(date<=enddate) numWeekFillWork=numWeekFillWork+1
	..s numYearFillWork=numYearFillWork+1
	
	;周六周日天数
	s numWeekend=0,numYearWeekend=0
	f date=yearStart:1:enddate  d
	.q:(hourId'="")&&(date<hourDate)
	.i ($zd(date,10)=6)||($zd(date,10)=0) d
	..s:(date>=stdate)&&(date<=enddate) numWeekend=numWeekend+1
	..s numYearWeekend=numYearWeekend+1
	
	;若护士从未进入排班系统或者晚于结束日期:
	;1、若设置了初始化积假 从初始化积假生效日期开始正常计算工时、积假
	;2、否则返回0^0
	
	;计算已工作时长
	s yearTime=0
	i (hourId'="")&&(hourDate<=enddate) d
	.s hourObj=##class(DHCINM.Arg.MgArgHour).%OpenId(hourId)
	.q:'$IsObject(hourObj)
	.s hourLong=$fn(hourObj.ArgHour,"",1)*3600
	.s yearTime=hourLong
	s weekTime=0
	s filterLeave=$LB("事假","病假","年假","产假","婚假","丧假","公休","进修") ;带薪假,不同医院修改.
	s tStDate=yearStart-1 f date=tStDate:1:enddate d
	.;初始化积假生效日期之前的累计积假设置为积假初始值 周(月)积假归零
	.q:(hourId'="")&&(date<hourDate)
	.i (hourId'="")&&(date=hourDate) d
	..s hourObj=##class(DHCINM.Arg.MgArgHour).%OpenId(hourId)
	..q:'$IsObject(hourObj)
	..s yearTime=$fn(hourObj.ArgHour,"",1)*3600
	..s weekTime=0
	.;当日请假时 根据filterLeave里的类型确定是否算时长(一个标准工作日时长)
	.i $d(tmpPerLeave(date)) d
	..s ArgDesc=tmpPerLeave(date)
	..;&&('$d(tmpHoliday(date)))&&($d(tmpWork(date))||(($zd(date,10)'=6)&&($zd(date,10)'=0)))
	..i ($lf(filterLeave,ArgDesc)'=0) d
	...i (($zd(date,10)'=6)&&($zd(date,10)'=0))&&('$d(tmpHoliday(date)))||($d(tmpWork(date))) d //(周一到周五&&非假)||(补班)
	....s:(date>=stdate)&&(date<=enddate) numWeekHoliday=numWeekHoliday+1
	....s numYearHoliday=numYearHoliday+1
	.q:$d(tmpPerLeave(date))
	.;正常计算当日工作时长
	.q:'$d(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date))
	.s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,id)) q:id=""  d
	..s time=0,plusTime=0
	..s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj)
	..q:'$IsObject(obj.ArgPostDR)&&(obj.ArgType'="Y")&&(obj.ArgType'="N")
	..;q:(obj.ArrangeDR.ArgStatus'="R") //R 提交 A 审核
	..i (obj.ArgType="Y")||(obj.ArgType="N") d
	...s plusTime=($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))
	...s:obj.ArgType="N" plusTime=0-plusTime
	..e  d
	...s ArgDesc=obj.ArgPostDR.PostDR.PostDesc
	...;属于filterLeave类型假且为工作日
	...;&&('$d(tmpHoliday(date)))&&($d(tmpWork(date))||(($zd(date,10)'=6)&&($zd(date,10)'=0)))
	...i ($lf(filterLeave,ArgDesc)'=0) d
	....i (($zd(date,10)'=6)&&($zd(date,10)'=0))&&('$d(tmpHoliday(date)))||($d(tmpWork(date))) d //(周一到周五&&非假)||(补班)
	.....s tDateHolidayNum=$case(obj.ArgHolidayTime,"A":0.5,"P":0.5,"H":1,:1)
	.....s:(date>=stdate)&&(date<=enddate) numWeekHoliday=numWeekHoliday+tDateHolidayNum
	.....s numYearHoliday=numYearHoliday+tDateHolidayNum
	...q:obj.ArgPostDR.PostDR.PostLevel'="一线班" ;排除非一线班
	...q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	...;一阶段
	...s sttime=obj.ArgStTime1,endtime=obj.ArgEndTime1
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....;s:date=enddate endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....;s:date=enddate sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	...;二阶段
	...s sttime=obj.ArgStTime2,endtime=obj.ArgEndTime2
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....;s:date=enddate endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....;s:date=enddate sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	...;三阶段
	...s sttime=obj.ArgStTime3,endtime=obj.ArgEndTime3
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....;s:date=enddate endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....;s:date=enddate sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	..s yearTime=yearTime+time+plusTime
	..i ((date>=stdate)&&(date<=enddate)) s weekTime=weekTime+time+plusTime
	s weekStDate=stdate
	;s:yearStart>weekStDate weekStDate=yearStart
	;周(月)标准时长
	s weekStandard=enddate-weekStDate+1-numWeekHoliday-numWeekend+numWeekFillWork*step
	;累计积假标准时长
	;i (hourId'="")&&(hourDate>yearStart) s yearStandard=enddate-hourDate+1-numYearHoliday-numYearWeekend+numYearFillWork*step
	s yearStandard=enddate-yearStart+1-numYearHoliday-numYearWeekend+numYearFillWork*step
	
	;已工作小时数-应工作小时数
	s weekTime=$fn((weekTime/3600-weekStandard),"",1)
	s yearTime=$fn((yearTime/3600-yearStandard),"",1)
	
	q weekTime_"^"_yearTime
}

/// Description: 设置某人某时间段请假日期临时数组
/// Date: 2020-06-28
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: 护士id^date
/// Output: 
/// Other: w ##class(web.INMArgComm).SetPerLeaveTmp(1,.tmp)
ClassMethod SetPerLeaveTmp(nurseid, tmpLeave) As %String
{
	s id="" f  s id=$o(^DHCINM.Arg.MgLeaveAppI("Nurse",nurseid,id)) q:id=""  d
	.q:'$d(^DHCINM.Arg.MgLeaveAppD(id))
	.s leaveGlo=^DHCINM.Arg.MgLeaveAppD(id)
	.s source=$lg(leaveGlo,2)
	.s status=$lg(leaveGlo,13)
	.q:((source="N")&&(status'["A"))||((source="H")&&(status'="HA"))
	.s stDate=$lg(leaveGlo,5)
	.q:stDate=""
	.s endDate=$lg(leaveGlo,7)
	.q:endDate=""
	.s workDate=$lg(leaveGlo,29)
	.f tDate=stDate:1:endDate  d
	..q:$lf(workDate,tDate)
	..s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD($lg(leaveGlo,4)))
	..q:wardPostGlo=""
	..s tmpLeave(tDate)=$lg(wardPostGlo,2)
	s outId="" f  s outId=$o(^DHCINM.HR.MgOutTrainI("Per",nurseid,outId)) q:outId=""  d
	.q:'$d(^DHCINM.HR.MgOutTrainD(outId)) 
	.s trainGlo=^DHCINM.HR.MgOutTrainD(outId)
	.s stDate=$lg(trainGlo,4)
	.q:stDate=""
	.s endDate=$lg(trainGlo,5)
	.q:endDate=""
	.f outDate=stDate:1:endDate  d
	..q:$g(tmpLeave(outDate))'=""
	..s tmpLeave(outDate)="进修"
	q ""
}

ClassMethod getBeforStWorkTime(date, perdr) As %String
{
	s time=0
	s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perdr,date,""))
	i rw'="" d
	.s ProObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	.q:'$IsObject(ProObj)
	.q:ProObj.ArgPostDR.PostDR.PostLevel'="一线班"
	.s endtime=0
	.s endtime1=ProObj.ArgEndTime1
	.s endtime2=ProObj.ArgEndTime2
	.s endtime3=ProObj.ArgEndTime3
	.i ((endtime1'="")&&(endtime1["次日")) d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..s time=time+endtime
	.i ((endtime2'="")&&(endtime2["次日")) d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..s time=time+endtime
	.i ((endtime3'="")&&(endtime3["次日")) d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..s time=time+endtime
	q time
}

/// creator: xbl
/// createDate: 20170918
/// description: 获取排班表格单元格样式
/// table: DHNMG.Arg.MgArrange,CF.DHCINM.DB.MgArgPost
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgStyle","109^2019-08-12^2019-08-18","")
Query FindArgStyle(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgStyleExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s startTime=$P($h,",",2)
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i ((ward="")!(stdate="")!(enddate=""))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s row=1
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s GrpDesc=""
	...i grptyp="G" d
	....i (+grp=0)||($d(^DHCINM.Arg.MgNurGroupD(grp))=0) d
	.....s ret="PerName|未分组^editFlag|0"
	.....d OutArgStyle
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grp)
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^editFlag|0"
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArgStyle
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCINM.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret="PerName|未分组^editFlag|0"
	.....d OutArgStyle
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(grp)
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^editFlag|0"
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArgStyle
	...s GrpSort=0
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d 
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s GrpSort=GrpSort+1
	.....s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.....s argrowid=nurlist(ward,grptyp,grp,sort,perdr)
	.....s ret="PerName|"_perobj.PerName_"^PerID|^ArgPerDR|^ArgRowId|^ArgPerSort|"
	.....s ret=ret_"^LevelDesc|^GrpDesc|^GrpSort|^ArgGroupDR|^ArgWorkRemark|^ArgPerBeds|"
	.....s PerCode=perobj.PerPostName
	.....i (argid'="")&&(+argrowid'=0)&&$d(^DHCINM.Arg.MgArrangeRowD(argrowid)) d
	......s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	......s totalminute=0,nightminute=0,secondminute=0
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s cellstyle=""
	.......s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	.......s leaveflag=0
	.......i (($p(tmpIsAskLeave,"^",1)=1)&&($p(tmpIsAskLeave,"^",3)'="")) d
	........s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId($p(tmpIsAskLeave,"^",3))
	........s:$IsObject(postObj) cellstyle=postObj.PostDR.PostFontColor_"!"_postObj.PostDR.PostBgColor,leaveflag=1
	.......s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||本病区护士在其他病区有排班||护士长添加人员其他病区有排班
	.......i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	........s cellstyle=""
	.......e  d
	........q:leaveflag=1
	........s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.........q:+id=0
	.........s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.........q:(obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N")
	.........;请假处理
	.........;s:obj.ArgPostDR.PostDR.PostType="H" isAskLeave=1
	.........s:cellstyle'="" cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.........s:cellstyle="" cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.......s ret=ret_cellstyle_"^editFlag|"
	.....e  d
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.....s ret=ret_"^ArgWorkRemark|^PerCode|"
	.....d OutArgStyle
	.....s row=row+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgStyle
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgStyleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgStyleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgStyleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgStyleExecute ]
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

/// Creator:
/// Createdate:
/// Description: 
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 
/// Output:
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindNurseArgSub","2","2020-11-16","2020-11-22","8!18613")
Query FindNurseArgSub(ward As %String, stDate As %String, endDate As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurseArgSubExecute(ByRef qHandle As %Binary, ward As %String, stDate As %String, endDate As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i $l(stDate,"-")=3 s stDate=$zdh(stDate,3)
	e  i (($l(stDate,"/")=3)&&($l($p(stDate,"/",1))=4)) s stDate=$zdh( stDate,5)
	e  i (($l(stDate,"/")=3)&&($l($p(stDate,"/",3))=4)) s stDate=$zdh( stDate,5)
	i $l(endDate,"-")=3 s endDate=$zdh(endDate,3)
	e  i (($l(endDate,"/")=3)&&($l($p(endDate,"/",1))=4)) s endDate=$zdh(endDate,5)
	e  i (($l(endDate,"/")=3)&&($l($p(endDate,"/",3))=4)) s endDate=$zdh(endDate,5)
	s tmpHoliday="",tmpWorkDay=""
	s year=$p($zd(stDate,3),"-",1)
	s year2=$p($zd(endDate,3),"-",1)
	s sc=..setHolidayTmp(year,.tmpHoliday,0)
	s sc=..setHolidayTmp(year,.tmpWorkDay,1)
	s sc=..setHolidayTmp(year2,.tmpHoliday,0)
	s sc=..setHolidayTmp(year2,.tmpWorkDay,1)
	s len=$l(parr,"^")
	s tmp=""
	s argId=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_$tr($zd(stDate,3),"-","")_ward,""))
	f i=1:1:len
	{
		//14!7345^14!7345^120!7346^120!7346
		s itm=$p(parr,"^",i)
		i itm="" continue
		s per=$p(itm,"!",1)
		s rowId=$P(itm,"!",2)
		i rowId=""  s rowId=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argId,per,""))
		s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowId)
		i '$IsObject(rowObj) continue
		i $g(tmp(per))="" s tmp(per)=rowId
	}
	
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret="ArgPerDR|"_tmpPer
	.s totalminute=0,plusminute=0
	.s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(tmp(tmpPer))
	.f date=stDate:1:endDate d
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..s celldesc=""
	..s tmpIsAskLeave=..IsPerAskLeavel3(tmpPer_"^"_date)
	..s isAskLeave=$p(tmpIsAskLeave,"^")
	..s askLeaveDesc="%"_$p(tmpIsAskLeave,"^",2)
	..s curward=##class(web.INMHRComm).GetCurrentWard(tmpPer,date)
	..s secondWard=..GetPostForOther(tmpPer,date,curward)
	..s tWard=..GetPostForOther(tmpPer,date,ward)
	..;不在本病区且不是护士长添加||本病区护士在其他病区有排班||护士长添加人员其他病区有排班
	..;i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	..i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)) d
	...s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	...i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	...s celldesc="」"_curwardObj.WardDesc
	..e  i isAskLeave=0 d
	...s Row="" f  s Row=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,Row)) q:Row=""  d
	....s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(Row)
	....q:'$IsObject(obj)
	....q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	....s PostDesc=""
	....i obj.ArgType="Y" d
	.....s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  i obj.ArgType="N" d
	.....s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  s PostDesc=obj.ArgPostDR.PostDesc
	....s workTime=""
	....s:obj.ArgStTime1'="" workTime=obj.ArgStTime1_"-"_obj.ArgEndTime1
	....s:obj.ArgStTime2'="" workTime=workTime_";"_obj.ArgStTime2_"-"_obj.ArgEndTime2
	....s:obj.ArgStTime3'="" workTime=workTime_";"_obj.ArgStTime3_"-"_obj.ArgEndTime3
	....i celldesc="" s celldesc=Row_"」"_PostDesc_obj.ArgRemark_"『"_workTime
	....e  s celldesc=celldesc_"「"_Row_"」"_PostDesc_obj.ArgRemark_"『"_workTime
	..;s:isAskLeave=1 askLeaveDesc="请假"
	..s wishArg="%"_..getWishArrangeForArgSub(ward,date,tmpPer)
	..s ret=ret_celldesc_askLeaveDesc_wishArg
	..s totalminute=totalminute+..CountMinutes(tmpPer,date,ward,0)
	..s plusminute=plusminute+..CountMinutesPlus(tmpPer,date,ward,0)
	.s totalminute=totalminute+plusminute
	.s ProductHour=..GetArgProductHour(stDate,endDate,tmpPer,.tmpHoliday,.tmpWorkDay)
	.s ret=ret_"^ArgTotalHour|"_(totalminute\60)_"时"_(totalminute#60)_"分"_"^ArgProductHour|"_$p(ProductHour,"^")_"^ArgAllProductHour|"_$p(ProductHour,"^",2)
	.d OutNurseArgSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseArgSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseArgSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseArgSubExecute ]
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

ClassMethod FindNurseArgSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseArgSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班记录行
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).SaveArgRows(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgRows(parr1 As %String, parr2 As %String, appFlag As %String = 0) As %String
{
	q:(parr1="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s flag=1
	f i=1:1:$L(parr2,"@") d
	.s parr=$P(parr2,"@",i)
	.q:parr=""
	.s parm="ArgPerDR|"_$P(parr,"^",1)_"^ArgPerSort|"_$P(parr,"^",2)_"^ArgWorkRemark|"_$P(parr,"^",3)_"^ArgGroupDR|"_$P(parr,"^",4)_"^rw|"_$P(parr,"^",5)_"^ArrangeDR|"_argid_"^ArgPerBeds|"_$P(parr,"^",6)
	.s argrowid=..SaveArgRow(parr1,parm)
	.i +argrowid=0 s flag=0
	q:appFlag=1 argid
	q flag
}

/// creator: xbl
/// createdate: 20170901
/// description: 保存排班记录
/// table: DHCINM.Arg.MgArrange
/// input:
/// output:
/// other: w ##class(web.INMArgComm).SaveArrange("ArgListNo|201708281^ArgWardDR|1^ArgStDate|2017-08-28^ArgEndDate|2017-09-03^ArgRemark|^ArgCrtUser|45")
ClassMethod SaveArrange(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	;i +$g(tmp("ArgCrtUser"))=0 s tmp("ArgCrtUser")=""
	s ward=$g(tmp("ArgWardDR"))
	s stdate=$g(tmp("ArgStDate"))
	q:(ward="")!(stdate="") 0
	s:stdate["-" stdate=$zdh(stdate,3)
	i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_$zd(stdate,8)_ward,""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCINM.Arg.MgArrange).%OpenId(tmp("rw"))
	.i $g(tmp("ArgStatus"))'="" s obj.ArgStatus=tmp("ArgStatus")
	.i $g(tmp("ArgStatus"))="R" d
	..s obj.ArgSubmitDate=+$h
	..s obj.ArgSubmitTime=$p($h,",",2)
	e  d	
	.s obj=##class(DHCINM.Arg.MgArrange).%New()
	.s obj.ArgWardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("ArgWardDR"))
	.s obj.ArgStatus="N"
	.i $g(tmp("ArgStatus"))'="" s obj.ArgStatus=tmp("ArgStatus")
	.s obj.ArgCrtDate=+$h
	.s obj.ArgCrtTime=$P($h,",",2)
	.s obj.ArgEditFlag="N"
	.s obj.ArgCrtUser=$g(tmp("ArgCrtUser"))
	i $g(tmp("ArgListNo"))'="" s obj.ArgListNo=$g(tmp("ArgListNo"))
	e  s obj.ArgListNo=$zd(stdate,8)_ward
	i $g(tmp("ArgStDate"))'="" d
	.s obj.ArgStDate=$zdh(tmp("ArgStDate"),3)
	e  s obj.ArgStDate=""
	i $g(tmp("ArgEndDate"))'="" d
	.s obj.ArgEndDate=$zdh(tmp("ArgEndDate"),3)
	e  s obj.ArgEndDate=""
	s obj.ArgRemarks=$tr($g(tmp("ArgRemarks"))," ","")
	;i $g(tmp("ArgCrtUser"))'="" d
	;.s obj.ArgCrtUser=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("ArgCrtUser"))
	;e  s obj.ArgCrtUser=""
	s obj.ArgOtherRemark=$tr($g(tmp("ArgOtherRemark"))," ","")
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班记录行
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).SaveArgRow(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgRow(parr1 As %String, parr2 As %String) As %String
{
	q:(parr1="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	d ##class(web.INMVueComm).SplitStr(parr2,"^","|",.tmp)
	q:$g(tmp("ArgPerDR"))="" 0
	i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,tmp("ArgPerDR"),""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%New()
	.i argid'="" d
	..s obj.ArrangeDR=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	.e  s obj.ArrangeDR=""
	i $g(tmp("ArgPerDR"))'="" d
	.s obj.ArgPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("ArgPerDR"))
	e  s obj.ArgPerDR=""
	s obj.ArgPerSort=$g(tmp("ArgPerSort"))
	s obj.ArgWorkRemark=$g(tmp("ArgWorkRemark"))
	i $g(tmp("ArgGroupDR"))'="" d
	.i $g(tmp("ArgGroupDR"))="-" s obj.ArgGroupDR=""
	.e  d
	..s ArgGroupObj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(tmp("ArgGroupDR"))
	..i ($IsObject(ArgGroupObj))&&($IsObject(ArgGroupObj.ArrangeDR))&&(ArgGroupObj.ArrangeDR.%Id()=argid) s obj.ArgGroupDR=ArgGroupObj
	..e  d
	...s grpid=..GetPerGroup(obj.ArrangeDR.ArgWardDR.%Id(),obj.ArrangeDR.ArgStDate,obj.ArrangeDR.ArgEndDate,tmp("ArgPerDR"))
	...i grpid="" s obj.ArgGroupDR=""
	...e  s obj.ArgGroupDR=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(grpid)
	e  d
	.s grpid=..GetPerGroup(obj.ArrangeDR.ArgWardDR.%Id(),obj.ArrangeDR.ArgStDate,obj.ArrangeDR.ArgEndDate,tmp("ArgPerDR"))
	.i grpid="" s obj.ArgGroupDR=""
	.e  s obj.ArgGroupDR=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(grpid)
	i $g(tmp("rw"))="" d
	.i $g(tmp("ArgPerAddFlag"))="" s obj.ArgPerAddFlag="N"
	.e  s obj.ArgPerAddFlag=tmp("ArgPerAddFlag")
	i ($IsObject(obj.ArrangeDR))&&(obj.ArrangeDR.ArgStatus'="N")&&(obj.ArgPerDR'="") d
	.s obj.ArgPerCode=obj.ArgPerDR.PerPostName
	s obj.ArgPerBeds=$g(tmp("ArgPerBeds"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20171202
/// description: 获取护士所在分组
/// table:DHCINM.Arg.MgArrangeGroup
/// input:
/// output:
/// return:
/// other: w ##class(web.INMArgComm).GetPerGroup(1,"2017-12-11","2017-12-17",1537)
ClassMethod GetPerGroup(ward As %String, stdate As %String, enddate As %String, perdr As %String) As %String
{
	q:(ward="")!(stdate="")!(enddate="")!(perdr="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s argid=$O(^DHCINM.Arg.MgArrangeI("WardDate",ward,stdate,enddate,""))
	q:argid="" ""
	s id=""
	s rowid="" f  s rowid=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",argid,rowid)) q:(rowid="")||(id'="")  d
	.s rowobj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowid)
	.q:(rowobj.ArgPerDR'="")&&(rowobj.ArgPerDR.%Id()'=perdr)
	.q:rowobj.ArgGroupDR=""
	.s id=rowobj.ArgGroupDR.%Id()
	q:id'="" id
	s grpid="" f  s grpid=$O(^DHCINM.Arg.MgNurGroupI("Ward",ward,grpid)) q:(grpid="")||(id'="")  d
	.s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grpid)
	.s:(($IsObject(grpobj.GroupMaster))&&(grpobj.GroupMaster.%Id()=perdr)) id=grpid
	.q:grpobj.GroupMember.Find(perdr)=""
	.s id=grpid
	q:id="" ""
	s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(id)
	s id=$O(^DHCINM.Arg.MgArrangeGroupI("ArgCode",argid," "_$zcvt(grpobj.GroupDesc,"U"),""))
	q:id'="" id
	s obj=##class(DHCINM.Arg.MgArrangeGroup).%New()
	s obj.ArrangeDR=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	s obj.GroupCode=grpobj.GroupDesc
	s obj.GroupDesc=grpobj.GroupDesc
	s obj.GroupMaster=grpobj.GroupMaster
	s obj.GroupRemark=grpobj.GroupRemark
	s obj.GroupBedGroup=grpobj.GroupBedGroup
	s obj.GroupResBeds=grpobj.GroupResBeds
#;	d obj.GroupResBeds.Clear()
#;	s GroupResBeds=##class(web.INMHISComm).GetBedIdByGroup(grpobj.GroupBedGroup)
#;	i GroupResBeds'="" d
#;	.f i=1:1:$L(GroupResBeds,",") d
#;	..s bedid=$P(GroupResBeds,",",i)
#;	..q:bedid=""
#;	..s bedid=$tr(bedid,"__","||")
#;	..d obj.GroupResBeds.Insert(bedid)
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q ""
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班明细
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).SaveArgSub(^tmpArg("parr1"),^tmpArg("parr2"),^tmpArg("parr3"))
ClassMethod SaveArgSub(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	s ^tmpArg("parr1")=parr1,^tmpArg("parr2")=parr2,^tmpArg("parr3")=parr3
	q:(parr1="")||(parr2="")||(parr3="") "入参为空"
	s repeatFlag=..CheckRepeat(parr3)
	q:repeatFlag'="" repeatFlag
	s argid=..SaveArrange(parr1)
	q:+argid=0 "保存排班失败"
	s argrowid=..SaveArgRow(parr1,parr2)
	q:+argrowid=0 "保存排班失败"
	s argobj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	q:argobj.ArgWardDR="" "获取排班病区失败"
	s ward=argobj.ArgWardDR.%Id()
	d ##class(web.INMVueComm).SplitStr(parr3,"^","|",.tmp)
	s perdr=$g(tmp("ArgPerDR"))
	s date=$g(tmp("ArgDate"))
	s:date["-" date=$zdh(date,3)
	s postdr=$g(tmp("ArgPostDR"))
	s ArgType=$g(tmp("ArgType"))
	q:(perdr="")!(date="")!((postdr="")&&(ArgType'="Y")&&(ArgType'="N")) "入参不合法"
	s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	s argrowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	q:(curward'=ward)&&(argrowObj.ArgPerAddFlag'="Y") "不在当前病区,不可排班"
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%New()
	s obj.ArrangeDR=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	s obj.ArgRowDR=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	s obj.ArgWardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	s obj.ArgPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	s obj.ArgPostDR=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId($g(tmp("ArgPostDR")))
	s:$IsObject(obj.ArgPostDR) obj.ArgCategory=obj.ArgPostDR.PostCategory
	s obj.ArgDate=date
	s obj.ArgStTime1=$g(tmp("ArgStTime1"))
	s obj.ArgEndTime1=$g(tmp("ArgEndTime1"))
	s obj.ArgStTime2=$g(tmp("ArgStTime2"))
	s obj.ArgEndTime2=$g(tmp("ArgEndTime2"))
	s obj.ArgStTime3=$g(tmp("ArgStTime3"))
	s obj.ArgEndTime3=$g(tmp("ArgEndTime3"))
	s remark=$g(tmp("ArgWorkRemark"))
	;s:remark="" remark=$g(tmp("ArgRemark"))
	s obj.ArgRemark=remark
	i obj.ArgPostDR.PostDR.PostType="H" d
	.s obj.ArgHolidayTime=$g(tmp("ArgHolidayTime"))
	e  s obj.ArgHolidayTime=""
	;i $g(tmp("ArgEditUser"))'="" d
	;.s obj.ArgEditUser=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("ArgEditUser"))
	;e  s obj.ArgEditUser=""
	s obj.ArgEditUser=$g(tmp("ArgEditUser"))
	s obj.ArgEditDate=+$h
	s obj.ArgEditTime=$P($h,",",2)
	s obj.ArgSecStTime=$g(tmp("ArgSecStTime"))
	s obj.ArgSecEndTime=$g(tmp("ArgSecEndTime"))
	s obj.ArgType=ArgType
	i (((argobj.ArgStatus="R")||(argobj.ArgStatus="A")||(argobj.ArgStatus="B"))&&((ArgType="Y")||(ArgType="N"))) d
	.s LogObj=##class(DHCINM.Arg.MgArrangeLog).%New()
	.s LogObj.ArgLogPerDR=obj.ArgPerDR.%Id()
	.s LogObj.ArrangeDR=obj.ArrangeDR
	.s LogObj.ArgLogArgDate=obj.ArgDate
	.s LogObj.ArgLogAfter=$case(obj.ArgType,"Y":"加班"_obj.ArgStTime1_"-"_obj.ArgEndTime1,"N":"减班"_obj.ArgStTime1_"-"_obj.ArgEndTime1)
	.s LogObj.ArgLogRemark="添加班次"
	.s LogObj.ArgLogCrt=$g(tmp("ArgEditUser"))
	.s LogObj.ArgLogCrtDate=+$h
	.s LogObj.ArgLogCrtTime=$p($h,",",2)
	.s sc1=LogObj.%Save()
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q "保存失败"
}

ClassMethod GetArgStOrEndTime(time)
{
	i (time["次日") s time=86400+$zth($e(time,3,*),1)
	e  i time'="" s time=$zth(time,1)
	q time
}

/// Description: 检查人员当天的班次时间段是否有重复
/// Date: 2020-06-29
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: parr
/// Output: 0：无 1：有
/// Other: w ##class(web.INMArgComm).CheckRepeat()
ClassMethod CheckRepeat(parr) As %String
{
	q:parr="" ""
	k tmp
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	
	s rw=$g(tmp("rw"))
	s argSubPer=$g(tmp("ArgPerDR"))
	s argSubDate=$g(tmp("ArgDate"))
	s:argSubDate["-" argSubDate=$zdh(argSubDate,3)
	q:(argSubPer="")||(argSubDate="") ""
	
	s reduceFlag=1
	i $g(tmp("ArgType"))="N" s reduceFlag=..CheckReducePost(parr)
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=0)) "没有排班不能添加减班"
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=-2)) "时间不能为空"
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=-1)) "不能在排班时间外添加减班"
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=1)) ""
	s curStTime1=..GetArgStOrEndTime($g(tmp("ArgStTime1")))
	s curEndTime1=..GetArgStOrEndTime($g(tmp("ArgEndTime1")))
	s curStTime2=..GetArgStOrEndTime($g(tmp("ArgStTime2")))
	s curEndTime2=..GetArgStOrEndTime($g(tmp("ArgEndTime2")))
	s curStTime3=..GetArgStOrEndTime($g(tmp("ArgStTime3")))
	s curEndTime3=..GetArgStOrEndTime($g(tmp("ArgEndTime3")))
	s base=argSubDate*86400
	s:curStTime1'="" curStTime1=base+curStTime1
	s:curEndTime1'="" curEndTime1=base+curEndTime1
	s:curStTime2'="" curStTime2=base+curStTime2
	s:curEndTime2'="" curEndTime2=base+curEndTime2
	s:curStTime3'="" curStTime3=base+curStTime3
	s:curEndTime3'="" curEndTime3=base+curEndTime3
	s stDate=argSubDate-2
	s endDate=argSubDate+1
	s flag=0
	s argSubDate=stDate f  s argSubDate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",argSubPer,argSubDate)) q:(argSubDate="")||(argSubDate>endDate)||(flag'=0)  d
	.s base=argSubDate*86400
	.s argSubId="" f  s argSubId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",argSubPer,argSubDate,argSubId)) q:(argSubId="")||(flag'=0)  d
	..q:rw=argSubId
	..q:'$d(^DHCINM.Arg.MgArrangeSubD(argSubId))
	..s argSubGlo=^DHCINM.Arg.MgArrangeSubD(argSubId)
	..s stTime1=..GetArgStOrEndTime($lg(argSubGlo,8))
	..s endTime1=..GetArgStOrEndTime($lg(argSubGlo,9))
	..s stTime2=..GetArgStOrEndTime($lg(argSubGlo,10))
	..s endTime2=..GetArgStOrEndTime($lg(argSubGlo,11))
	..s stTime3=..GetArgStOrEndTime($lg(argSubGlo,12))
	..s endTime3=..GetArgStOrEndTime($lg(argSubGlo,13))
	..s:stTime1'="" stTime1=base+stTime1
	..s:endTime1'="" endTime1=base+endTime1
	..s:stTime2'="" stTime2=base+stTime2
	..s:endTime2'="" endTime2=base+endTime2
	..s:stTime3'="" stTime3=base+stTime3
	..s:endTime3'="" endTime3=base+endTime3
	..i (stTime1'="")&&(endTime1'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime1)&&(stTime1<curEndTime1) s flag=1
	..i (stTime2'="")&&(endTime2'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime2)&&(stTime2<curEndTime1) s flag=1
	..i (stTime3'="")&&(endTime3'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime3)&&(stTime3<curEndTime1) s flag=1
	..i (stTime1'="")&&(endTime1'="")&&(curStTime2'="")&&(curEndTime2'="")&&(curStTime2<endTime1)&&(stTime1<curEndTime2) s flag=1
	..i (stTime2'="")&&(endTime2'="")&&(curStTime2'="")&&(curEndTime2'="")&&(curStTime2<endTime2)&&(stTime2<curEndTime2) s flag=1
	..i (stTime3'="")&&(endTime3'="")&&(curStTime2'="")&&(curEndTime2'="")&&(curStTime2<endTime3)&&(stTime3<curEndTime2) s flag=1
	..i (stTime1'="")&&(endTime1'="")&&(curStTime3'="")&&(curEndTime3'="")&&(curStTime3<endTime1)&&(stTime1<curEndTime3) s flag=1
	..i (stTime2'="")&&(endTime2'="")&&(curStTime3'="")&&(curEndTime3'="")&&(curStTime3<endTime2)&&(stTime2<curEndTime3) s flag=1
	..i (stTime3'="")&&(endTime3'="")&&(curStTime3'="")&&(curEndTime3'="")&&(curStTime3<endTime3)&&(stTime3<curEndTime3) s flag=1
	k tmp
	i flag=1{
		q "当天班次时间有交叉"	
	}else{
		q ""
	}
}

/// Date:20200415
/// Creator:gzj
/// Description:判断减班是不是在合理的时间范围内
ClassMethod CheckReducePost(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s curStTime1=$g(tmp("ArgStTime1")) ;|00:00^ArgEndTime1|00:10
	i curStTime1'="" s curStTime1=$zth(curStTime1,1)
	s curEndTime1=$g(tmp("ArgEndTime1"))
	i curEndTime1'="" s curEndTime1=$zth(curEndTime1,1)
	q:(curStTime1="")||(curEndTime1="") -2
	
	;s argRow=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),$zdh($g(tmp("ArgDate")),3),""))
	;q:argRow="" 0 //如果没有排班记录 则返回0 不允许减班操作
	
	s argSubDate=$zdh($g(tmp("ArgDate")),3)
	s base=argSubDate*86400
	s curStTime1=base+curStTime1
	s curEndTime1=base+curEndTime1
	s stDate=argSubDate-2
	s endDate=argSubDate+1
	s flag=-1
	s argSubDate=stDate f  s argSubDate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),argSubDate)) q:(argSubDate="")||(argSubDate>endDate)||(flag'=-1)  d
	.s base=argSubDate*86400
	.s argSubId="" f  s argSubId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),argSubDate,argSubId)) q:(argSubId="")||(flag'=-1)  d
	..q:tmp("rw")=argSubId
	..q:'$d(^DHCINM.Arg.MgArrangeSubD(argSubId))
	..s argSubGlo=^DHCINM.Arg.MgArrangeSubD(argSubId)
	..s stTime1=..GetArgStOrEndTime($lg(argSubGlo,8))
	..s endTime1=..GetArgStOrEndTime($lg(argSubGlo,9))
	..s stTime2=..GetArgStOrEndTime($lg(argSubGlo,10))
	..s endTime2=..GetArgStOrEndTime($lg(argSubGlo,11))
	..s stTime3=..GetArgStOrEndTime($lg(argSubGlo,12))
	..s endTime3=..GetArgStOrEndTime($lg(argSubGlo,13))
	..s:stTime1'="" stTime1=base+stTime1
	..s:endTime1'="" endTime1=base+endTime1
	..s:stTime2'="" stTime2=base+stTime2
	..s:endTime2'="" endTime2=base+endTime2
	..s:stTime3'="" stTime3=base+stTime3
	..s:endTime3'="" endTime3=base+endTime3
	..i (stTime1'="")&&(endTime1'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime1)&&(stTime1<curEndTime1) s flag=1
	..i (stTime2'="")&&(endTime2'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime2)&&(stTime2<curEndTime1) s flag=1
	..i (stTime3'="")&&(endTime3'="")&&(curStTime1'="")&&(curEndTime1'="")&&(curStTime1<endTime3)&&(stTime3<curEndTime1) s flag=1
	
	q flag
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班明细
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).GetArgSubById(19)
ClassMethod GetArgSubById(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="rw|"_id
	i obj.ArgWardDR'="" d
	.s ret=ret_"^ArgWardDR|"_obj.ArgWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.ArgWardDR.WardDesc
	i obj.ArgPerDR'="" d
	.s ret=ret_"^ArgPerDR|"_obj.ArgPerDR.%Id()
	.s ret=ret_"^PerName|"_obj.ArgPerDR.PerName
	i obj.ArgDate'="" s ret=ret_"^ArgDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgDate)
	i obj.ArgPostDR'="" d
	.s ret=ret_"^ArgPostDR|"_obj.ArgPostDR.%Id()
	.s ret=ret_"^PostDesc|"_obj.ArgPostDR.PostDesc
	.i obj.ArgPostDR.PostDR'="" d
	..s ret=ret_"^ArgPostType|"_obj.ArgPostDR.PostDR.PostType 
	s ret=ret_"^ArgStTime1|"_obj.ArgStTime1
	s ret=ret_"^ArgEndTime1|"_obj.ArgEndTime1
	s ret=ret_"^ArgStTime2|"_obj.ArgStTime2
	s ret=ret_"^ArgEndTime2|"_obj.ArgEndTime2
	s ret=ret_"^ArgWorkRemark|"_obj.ArgRemark
	s ret=ret_"^ArgRemark|"_obj.ArgRemark
	s ret=ret_"^ArgStTime3|"_obj.ArgStTime3
	s ret=ret_"^ArgEndTime3|"_obj.ArgEndTime3
	s ret=ret_"^ArgSecStTime|"_obj.ArgSecStTime
	s ret=ret_"^ArgSecEndTime|"_obj.ArgSecEndTime
	s ret=ret_"^ArgHolidayTime|"_obj.ArgHolidayTime
	s ret=ret_"^HolidayTime|"_$case(obj.ArgHolidayTime,"H":"全天","A":"上午","P":"下午",:"")
	;i obj.ArgEditUser'="" d
	;.s ret=ret_"^ArgEditUser|"_obj.ArgEditUser.%Id()
	;.s ret=ret_"EditUserName|"_obj.ArgEditUser.PerName
	s ret=ret_"^ArgEditUser|"_obj.ArgEditUser
	s ArgEditUserName=""
	i obj.ArgEditUser s ArgEditUserName="管理员"
	e  d
	.s ArgEditUserObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.ArgEditUser)
	.s:$IsObject(ArgEditUserObj) ArgEditUserName=ArgEditUserObj.UserName
	s ret=ret_"^EditUserName|"_ArgEditUserName
	i obj.ArgEditDate'="" d
	.s ret=ret_"^ArgEditDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ArgEditDate)
	i obj.ArgEditTime'="" d
	.s ret=ret_"^ArgEditTime|"_$zt(obj.ArgEditTime,2)
	s ret=ret_"^ArgType|"_obj.ArgType
	q ret
}

/// Creator:
/// CreateDate: 
/// Description: 
/// Table: DHNMG.Arg.MgArrange,CF.DHCINM.DB.MgArgPost
/// Input:
/// Output:
/// Other: w ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgCellStyle","109^2019-08-12^2019-08-18","")
Query FindArgCellStyle(ward As %String, stdate As %String, enddate As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgCellStyleExecute(ByRef qHandle As %Binary, ward As %String, stdate As %String, enddate As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i ((ward="")!(stdate="")!(enddate="")!(parr="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
	//109%2019-08-12%2019-08-18%120!7526^120!7526^361!7527^361!7527^781!7528^781!7528
	s tmp=""
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s item=$p(parr,"^",i)
		i item="" continue
		s perDr=$p(item,"!",1)
		s argRow=$p(item,"!",2)
		i $g(tmp(perDr))="" s tmp(perDr)=1
	}
	
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret=""
	.s ret="ArgPerDR|"_tmpPer
	.f date=stdate:1:enddate d
	..s cellstyle=""
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..s tmpIsAskLeave=..IsPerAskLeavel3(tmpPer_"^"_date)
	..i (($p(tmpIsAskLeave,"^",1)=1)&&($p(tmpIsAskLeave,"^",3)'="")) d
	...s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId($p(tmpIsAskLeave,"^",3))
	...s:$IsObject(postObj) cellstyle=postObj.PostDR.PostFontColor_"!"_postObj.PostDR.PostBgColor
	..s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,rw)) q:rw=""  d
	...s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	...q:'$IsObject(obj)
	...i ((obj.ArgType'="Y")&&(obj.ArgType'="N")) d
	....i cellstyle="" s cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	....e  s cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	..s ret=ret_cellstyle
	.d OutArgStyle

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgStyle
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgCellStyleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgCellStyleExecute ]
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

ClassMethod FindArgCellStyleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgCellStyleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除人员分组
/// table: DHCINM.Arg.MgArrangeRow
/// input:
/// output:
/// other: w ##class(web.INMArgComm).DeleteArgGroup(2)
ClassMethod DeleteArgGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(id)
	q:obj.ArrangeDR="" 0
	s argid=obj.ArrangeDR.%Id()
	s rowid="" f  s rowid=$O(^DHCINM.Arg.MgArrangeRowI("ArgGrp",argid,id,rowid)) q:rowid=""  d
	.s rowobj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowid)
	.s rowobj.ArgGroupDR=""
	.d rowobj.%Save()
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除排班明细
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).DeletePerArgSub(^tmpXbl("parr1"),^tmpXbl("parr2"))
ClassMethod DeletePerArgSub(parr1 As %String, parr2 As %String) As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("parr2")=parr2
	q:(parr1="")!(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s flag=1
	f i=1:1:$L(parr2,",") d
	.s perdr=$P(parr2,",",i)
	.q:(perdr="")||($d(^CF.DHCINM.HR.PersonsD(perdr))=0)
	.s rowid=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowid=""
	.s date="" f  s date=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	..s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	...s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	...s sc=obj.%DeleteId(id)
	...i $$$ISERR(sc) s flag=0
	q flag
}

/// creator: xbl
/// createdate: 20170902
/// description: 复制排班
/// table: DHCINM.Arg.MgArrangeRow
/// input: copy2:复制区域，paste2:粘贴区域
/// output:
/// other: w ##class(web.INMArgComm).CopyArgSub(^tmpXbl("copy1"),^tmpXbl("copy2"),^tmpXbl("paste1"),^tmpXbl("paste2"),"copy")
ClassMethod CopyArgSub(copy1 As %String, copy2 As %String, paste1 As %String, paste2 As %String, type As %String) As %String
{
	s ^tmpXbl("copy1")=copy1,^tmpXbl("copy2")=copy2,^tmpXbl("paste1")=paste1,^tmpXbl("paste2")=paste2
	q:(copy1="")!(copy2="")!(paste1="")!(paste2="")!(type="") 0
	s copyargid=..SaveArrange(copy1)
	q:+copyargid=0 0
	s copyrowid=..SaveArgRow(copy1,copy2)
	q:+copyrowid=0 0
	d ##class(web.INMVueComm).SplitStr(copy2,"^","|",.tmp1)
	q:$g(tmp1("ArgDate"))="" 0
	s copydate=tmp1("ArgDate")
	s:copydate["-" copydate=$zdh(copydate,3)
	s copysubid=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",copyargid,copyrowid,copydate,""))
	q:+copysubid=0 0
	s pasteargid=..SaveArrange(paste1)
	q:+pasteargid=0 0
	s pasterowid=..SaveArgRow(paste1,paste2)
	q:+pasterowid=0 0
	s ^TMP("copyPasterrowid")=pasterowid
	d ##class(web.INMVueComm).SplitStr(paste2,"^","|",.tmp2)
	q:$g(tmp2("ArgDate"))="" 0
	s pastedate=tmp2("ArgDate")
	s:pastedate["-" pastedate=$zdh(pastedate,3)
	s flag=0
	s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",pasteargid,pasterowid,pastedate,id)) q:id=""  d
	.d ##class(DHCINM.Arg.MgArrangeSub).%DeleteId(id)
	s cid="" f  s cid=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",copyargid,copyrowid,copydate,cid)) q:cid=""  d
	.s cobj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(cid)
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%New()
	.s obj.ArrangeDR=##class(DHCINM.Arg.MgArrange).%OpenId(pasteargid)
	.s obj.ArgRowDR=##class(DHCINM.Arg.MgArrangeRow).%OpenId(pasterowid)
	.s obj.ArgWardDR=obj.ArrangeDR.ArgWardDR
	.s obj.ArgPerDR=obj.ArgRowDR.ArgPerDR
	.s obj.ArgDate=pastedate
	.q:'$IsObject(cobj.ArgPostDR)
	.s obj.ArgPostDR=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(cobj.ArgPostDR.%Id())
	.s obj.ArgStTime1=cobj.ArgStTime1
	.s obj.ArgEndTime1=cobj.ArgEndTime1
	.s obj.ArgStTime2=cobj.ArgStTime2
	.s obj.ArgEndTime2=cobj.ArgEndTime2
	.s obj.ArgStTime3=cobj.ArgStTime3
	.s obj.ArgEndTime3=cobj.ArgEndTime3
	.s obj.ArgRemark=cobj.ArgRemark
	.s obj.ArgEditUser=obj.ArrangeDR.ArgCrtUser
	.s obj.ArgEditDate=+$h
	.s obj.ArgEditTime=$P($h,",",2)
	.s obj.ArgCategory=cobj.ArgCategory
	.s obj.ArgType=cobj.ArgType
	.s curward=##class(web.INMHRComm).GetCurrentWard(obj.ArgRowDR.ArgPerDR.%Id(),pastedate)
	.q:curward'=obj.ArrangeDR.ArgWardDR.%Id()
	.q:(cobj.ArgRowDR.ArgPerAddFlag'="Y")&&(curward'=obj.ArrangeDR.ArgWardDR.%Id())
	.d obj.%Save()
	.s flag=1
	.i type="cut" d cobj.%DeleteId(cid)
	q flag
}

/// creator: llin
/// createdate: 2018-07-24
/// description: 根据id删除班次
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other:
ClassMethod DeleteArgSubById(parr) As %String
{
	q:parr="" 0
	s argIdList=$lfs(parr)
	s sc=1
	ts
	s ptr=0 f  s status=$listnext(argIdList,ptr,value) q:(status'=1)||(sc'=1)  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(value)
	.i '$IsObject(obj) s sc=0 q
	.s sc=obj.%DeleteId(value)
	i sc'=1 {
		tro
		q 0
	}else {
		tc
		q 1
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除排班明细
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).DeleteArgSub(^tmpXbl("parr1"),^tmpXbl("parr2"),"2017-09-11")
ClassMethod DeleteArgSub(parr1 As %String, parr2 As %String, date As %String) As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("parr2")=parr2
	q:(parr1="")!(parr2="")!(date="") 0
	s:date["-" date=$zdh(date,3)
	Ts
	s argid=..SaveArrange(parr1)
	i +argid=0 {
		Tro
		q "保存排班表失败"
	}
	q:+argid=0 0
	s argrowid=..SaveArgRow(parr1,parr2)
	i +argrowid=0 
	{
		Tro
		q "保存行表失败"
	}
	s flag=1
	s ret=""
	s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:(id="")||(flag=0)  d
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.i obj.ArgReplaceDR'="" s flag=0,ret="存在替班,不可删除"
	.i (obj.ArgConfirmDR'="")||(obj.ArgConfirmDate'="") s flag=0,ret="已确认,不可删除"
	.;i ((obj.ArrangeDR.ArgStatus="R")||(obj.ArrangeDR.ArgStatus="A"))&&(date<+$h) s flag=0,ret="已提交且小于当前日期,不可删除"
	.q:flag=0
	.d obj.%DeleteId(id)
	if flag=1 
	{
		Tc
		q 1	
	}else{
		Tro
		q ret	
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 快选排班
/// table: DHCINM.Arg.MgArrangeSub
/// input: 
/// output:
/// other: 
ClassMethod QuickArg(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	q:(parr1="")!(parr2="")!(parr3="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	s argrowid=..SaveArgRow(parr1,parr2)
	q:+argrowid=0 0
	s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	s post=$P(parr3,"^",1)
	s date=$P(parr3,"^",2)
	s:date["-" date=$zdh(date,3)
	q:(post="")!(date="") 0
	ts
	s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.d ##class(DHCINM.Arg.MgArrangeSub).%DeleteId(id)
	
	s tmpWardPost=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(post)
	i '$IsObject(tmpWardPost){
		tro
		q 0
	}
	s checkStr="ArgStTime1|"_tmpWardPost.PostStTime1_"^ArgEndTime1|"_tmpWardPost.PostEndTime1
	s checkStr=checkStr_"^ArgStTime2|"_tmpWardPost.PostStTime2_"^ArgEndTime2|"_tmpWardPost.PostEndTime2
	s checkStr=checkStr_"^ArgStTime3|"_tmpWardPost.PostStTime3_"^ArgEndTime3|"_tmpWardPost.PostEndTime3
	s checkStr=checkStr_"^ArgPerDR|"_rowObj.ArgPerDR.%Id()_"^ArgDate|"_date
	s flag=..CheckRepeat(checkStr)
	i flag'=""{
		tro
		q -1
	}
	s obj=##class(DHCINM.Arg.MgArrangeSub).%New()
	s obj.ArrangeDR=argObj
	s obj.ArgRowDR=rowObj
	s obj.ArgWardDR=argObj.ArgWardDR
	s obj.ArgPerDR=rowObj.ArgPerDR
	s obj.ArgDate=date
	s obj.ArgPostDR=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(post)
	i obj.ArgPostDR.PostDR.PostType="H" d
	.s obj.ArgHolidayTime=$case(obj.ArgPostDR.PostDR.HolidayTime,"H":"A","A":"H",:obj.ArgPostDR.PostDR.HolidayTime)
	s obj.ArgStTime1=obj.ArgPostDR.PostStTime1
	s obj.ArgEndTime1=obj.ArgPostDR.PostEndTime1
	s obj.ArgStTime2=obj.ArgPostDR.PostStTime2
	s obj.ArgEndTime2=obj.ArgPostDR.PostEndTime2
	s obj.ArgStTime3=obj.ArgPostDR.PostStTime3
	s obj.ArgEndTime3=obj.ArgPostDR.PostEndTime3
	s obj.ArgRemark=""
	s obj.ArgEditUser=obj.ArrangeDR.ArgCrtUser
	s obj.ArgEditDate=+$h
	s obj.ArgEditTime=$P($h,",",2)
	s obj.ArgCategory=obj.ArgPostDR.PostCategory
	s sc=obj.%Save()
	i $$$ISOK(sc){
		tc
		q obj.%Id()
	}else {
		tro
		q 0
	}
}

/// creator: xbl
/// createdate: 20170915
/// description: 删除排班人员
/// table: DHCINM.Arg.MgArrangeRow,DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.INMArgComm).DeleteArgPersons()
ClassMethod DeleteArgPersons(parr1 As %String, persons As %String) As %String
{
	q:(parr1="")!(persons="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s ret=""
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowid=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.i rowid="" s ret="未查找到人员请刷新重试"
	.q:rowid=""
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowid)
	.;i obj.ArgPerAddFlag="N" s ret="存在人员为调科到本病区，不可以删除，需要进行调科操作"
	.;q:obj.ArgPerAddFlag="N"
	.s date="" f  s date=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	..s subid="" f  s subid=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:subid=""  d
	...d ##class(DHCINM.Arg.MgArrangeSub).%DeleteId(subid)
	.d obj.%DeleteId(rowid)
	q:ret'="" ret
	q 1
}

/// creator: xbl
/// createdate: 20170915
/// description: 添加排班人员
/// table: DHCINM.Arg.MgArrangeRow
/// input:
/// output:
/// other:
ClassMethod AddArgPersons(parr1 As %String, persons As %String) As %String
{
	q:(parr1="")!(persons="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s id=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:id'=""
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%New()
	.s obj.ArrangeDR=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	.s obj.ArgPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.s obj.ArgPerSort=..GetArgRowSort(argid)
	.s obj.ArgPerAddFlag="Y"
	.d obj.%Save()
	q 1
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取排班人员当前已存最大序号
/// table: DHCINM.Arg.MgArrangeRow
/// input:
/// output:
/// other:
ClassMethod GetArgRowSort(argid As %String) As %Integer
{
	q:argid="" 1
	s maxsort=1
	s sort="" f  s sort=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,sort,id)) q:id=""  d
	..s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id)
	..s maxsort=maxsort+1
	q maxsort
}

/// creator: lulin
/// createdate: 2018-11-01
/// description: 全部班次上下移动
/// table: DHCINM.Arg.MgArrangeSub
/// input: type: U 上移，R 下移
/// output:
/// other:
ClassMethod MovePostAllH(parr1 As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s flag=1,step=1
	i type="D" s step=-1
	k tmp
	s tmp=""
	s endSort=$o(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	s rowSort="" f  s rowSort=$o(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,rowSort),step) q:rowSort=""  d
	.s rowId="" f  s rowId=$o(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,rowSort,rowId)) q:rowId=""  d
	..s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowId,date)) q:date=""  d
	...s subid="" f  s subid=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowId,date,subid)) q:(subid="")  d
	....s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....s nextSort=rowSort-step
	....s replaceRowId=..getNextRowId(step,date,argid,subObj.ArgWardDR.%Id(),rowSort,nextSort)
	....q:replaceRowId=""
	....q:replaceRowId=rowId
	....s tmp(subid)=replaceRowId
	TS
	s flag=1
	s subid="" f  s subid=$O(tmp(subid)) q:(subid="")||(flag=0)  d
	.s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subid)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.ArgPerDR)
	.q:'$IsObject(subObj.ArgRowDR)
	.s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(tmp(subid))
	.q:'$IsObject(rowObj)
	.s subObj.ArgRowDR=rowObj
	.s subObj.ArgPerDR=rowObj.ArgPerDR
	.s flag=flag&&$$$ISOK(subObj.%Save())
	if flag=1{
		TC	
		q 1
	}else{
		TRO
		q 0
	}
}

/// creator: lulin
/// createdate: 2018-11-01
/// description: 获取移动班次下一个次序rowid
/// table: 
/// input: 
/// output:
/// other:
ClassMethod getNextRowId(step, date, argid, wardid, sort, nextsort)
{
	;q:(step="")||(date="")||(argid="")||(sort="")||(nextsort="") ""
	s endSort=$o(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	i nextsort=0 s nextsort=endSort
	e  i nextsort>endSort  s nextsort=1
	s RowId=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,nextsort,""))
	s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(RowId)
	s tNextSort=nextsort-step
	q:('$IsObject(obj))||('$IsObject(obj.ArgPerDR)) ..getNextRowId(step,date,argid,wardid,sort,tNextSort)
	q:sort=nextsort obj.%Id()
	s currentWard=##class(web.INMHRComm).GetCurrentWard(obj.ArgPerDR.%Id(),date)
	s secondWard=..GetPostForOther(obj.ArgPerDR.%Id(),date,wardid)
	q:(currentWard'=wardid)&&(secondWard'="") ..getNextRowId(step,date,argid,wardid,sort,tNextSort)
	q obj.%Id()
}

/// creator: lulin
/// createdate: 2018-10-31
/// description: 班次上下移动
/// table: DHCINM.Arg.MgArrangeSub
/// input: type: U 上移，R 下移
/// output:
/// other:
ClassMethod MoveHArgSub(parr1 As %String, persons As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s flag=1
	s start=1,step=1,end=$L(persons,",")
	i type="D" s start=$L(persons,","),step=-1,end=1
	s endSort=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	TS
	f i=start:step:end q:flag=0  d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowId=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowId=""
	.s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowId)
	.q:'$IsObject(rowObj)
	.q:'$IsObject(rowObj.ArgPerDR)
	.s sort=rowObj.ArgPerSort
	.s nextSort=sort-step
	.s:nextSort>endSort nextSort=1
	.s:nextSort=0 nextSort=endSort
	.q:nextSort=sort
	.s nextRowId=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,nextSort,""))
	.q:nextRowId=""
	.s nextRowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(nextRowId)
	.q:'$IsObject(nextRowObj)
	.q:'$IsObject(nextRowObj.ArgPerDR)
	.s subRowId="" f  s subRowId=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,subRowId)) q:(subRowId="")||(flag=0)  d
	..q:(subRowId'=rowId)
	..s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,subRowId,date)) q:(date="")||(flag=0)  d
	...q:..IsPerAskLeavel2(nextRowObj.ArgPerDR.%Id()_"^"_date)=1
	...s nextPerWard=##class(web.INMHRComm).GetCurrentWard(nextRowObj.ArgPerDR.%Id(),date)
	...s subid="" f  s subid=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,subRowId,date,subid)) q:(subid="")||(flag=0)  d
	....s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....q:'$IsObject(subObj.ArgPerDR)
	....q:'$IsObject(subObj.ArgWardDR)
	....s ward=##class(web.INMHRComm).GetCurrentWard(subObj.ArgPerDR.%Id(),date)
	....q:(ward'="")&&($IsObject(subObj.ArgWardDR))&&(ward'=subObj.ArgWardDR.%Id())
	....q:subObj.ArgWardDR.%Id()'=nextPerWard
	....s subObj.ArgRowDR=nextRowObj
	....s subObj.ArgPerDR=nextRowObj.ArgPerDR
	....s flag=flag&&$$$ISOK(subObj.%Save())
	if flag=1{
		TC	
		q 1
	}else{
		TRO
		q 0
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 班次左右移动
/// table: DHCINM.Arg.MgArrangeRow
/// input: type: L 左移，R 右移
/// output:
/// other:
ClassMethod MoveArgSub(parr1 As %String, persons As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowid=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowid=""
	.k tmpFirstId
	.s tmpFirstId="",lastDate=argObj.ArgEndDate
	.i type="L" d
	..f date=argObj.ArgStDate:1:argObj.ArgEndDate d
	...s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	....s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	....i obj.ArgDate=argObj.ArgStDate d
	.....;d obj.%DeleteId(id)
	.....;s obj.ArgDate=argObj.ArgEndDate
	.....s tmpFirstId(id)=id
	....e  d
	.....s obj.ArgDate=obj.ArgDate-1
	....d obj.%Save()
	.i type="R" d
	..s lastDate=argObj.ArgStDate
	..f date=argObj.ArgEndDate:-1:argObj.ArgStDate d
	...s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	....s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	....i obj.ArgDate=argObj.ArgEndDate d
	.....;d obj.%DeleteId(id)
	.....;s obj.ArgDate=argObj.ArgStDate
	.....s tmpFirstId(id)=id
	....e  d
	.....s obj.ArgDate=obj.ArgDate+1
	....d obj.%Save()
	.s firstId="" f  s firstId=$O(tmpFirstId(firstId)) q:firstId=""  d
	..s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(firstId)
	..q:'$IsObject(obj)
	..s obj.ArgDate=lastDate
	..d obj.%Save()
	q 1
}

/// creator: lulin
/// createdate: 2018-09-02
/// description: 移动组
/// table: DHCINM.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.INMArgComm).MoveArgGroup("10^7","D")
ClassMethod MoveArgGroup(parr As %String, type As %String, parr1 As %String, parr2 As %String) As %String
{
	s argId=$tr($p(parr,"^")," ","")
	s grpId=$tr($p(parr,"^",2)," ","")
	q:(argId="")||(grpId="")||(type="")||(parr1="")||(parr2="") "传参有空值"
	;d ..SaveArgRows(parr1,parr2)
	s:grpId="-" grpId=""
	//要移动组排序，移动组对象，下一个组对象，是否是下一个组，下一组数量
	s tSort="",tgrp="",nextgrp="",isNextGrp=0
	s tmpSort="",tmp=""
	s step=1 ;下移，从大到小，
	i type="U" s step=-1 ;上移，从小到大
	s sort="" f  s sort=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argId,sort),step) q:sort=""  d
	.s id=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argId,sort,""))
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id)
	.q:'$IsObject(obj)
	.i ((($IsObject(obj.ArgGroupDR))&&(obj.ArgGroupDR.%Id()=grpId))||((obj.ArgGroupDR="")&&(grpId=""))) d
	..s:tSort="" tSort=sort,tgrp=obj.ArgGroupDR
	..s tmpSort(sort)=id
	.i ((tSort'="")&&(obj.ArgGroupDR'=tgrp)) d
	..i (isNextGrp=0)||(nextgrp=obj.ArgGroupDR) d
	...s nextgrp=obj.ArgGroupDR,isNextGrp=1
	...s tmp(id)=tSort
	...s tSort=tSort+step
	q:(tSort="")||($d(tmp)'=11) "未获取正确顺序"
	s sort="" f  s sort=$o(tmpSort(sort),step) q:sort=""  d
	.s tmp(tmpSort(sort))=tSort
	.s tSort=tSort+step
	s id="" f  s id=$O(tmp(id)) q:id=""  d
	.s obj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id)
	.s obj.ArgPerSort=tmp(id)
	.d obj.%Save()
	q 1
}

/// creator: lulin
/// createdate: 2018-05-16
/// description: 人员移动不含班次
/// table: DHCINM.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.INMArgComm).MoveArgOnlyPerson(^tmpXbl("parr1"),^tmpXbl("persons"),"D")
ClassMethod MoveArgOnlyPerson(parr1 As %String, persons As %String, type As %String, parr2 As %String) As %String
{
	//s ^tmpXbl("parr1")=parr1,^tmpXbl("persons")=persons
	q:(parr1="")!(persons="")!(type="")!(parr2="") 0
	q:(type'="U")&&(type'="D") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s ret=1
	s start=1,step=1,end=$L(persons,",")
	i type="D" s start=$L(persons,","),step=-1,end=1
	TS
	f i=start:step:end q:ret=0  d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s id1=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:id1=""
	.s obj1=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id1)
	.q:'$IsObject(obj1)
	.q:'$IsObject(obj1.ArgPerDR)
	.s sort1=obj1.ArgPerSort
	.s sort2=sort1-step
	.s id2=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	.q:id2=""
	.s obj2=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id2)
	.q:'$IsObject(obj2)
	.q:'$IsObject(obj2.ArgPerDR)
	.s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeRow","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..q:p["ArgGroupDR"
	..q:p["ArgPerSort"
	..s value1=$ZOBJPROPERTY(obj1,p)
	..s $ZOBJPROPERTY(obj1,p)=$ZOBJPROPERTY(obj2,p)
	..s $ZOBJPROPERTY(obj2,p)=value1
	.s sc=obj2.%Save()
	.s ret=$$$ISOK(sc)
	.q:ret=0
	.s sc=obj1.%Save()
	.s ret=$$$ISOK(sc)
	.q:ret=0
	.s rowid="" f  s rowid=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid)) q:(rowid="")||(ret=0)  d
	..q:(rowid'=id1)&&(rowid'=id2)
	..s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:(date="")||(ret=0)  d
	...s subid="" f  s subid=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:(subid="")||(ret=0)  d
	....s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....q:('$IsObject(subObj.ArgPerDR))
	....q:(subObj.ArgPerDR.%Id()'=obj1.ArgPerDR.%Id())&&(subObj.ArgPerDR.%Id()'=obj2.ArgPerDR.%Id())
	....s replacePerDR=obj1.ArgPerDR
	....s replaceRowDR=obj2
	....i rowid=id2 d
	.....s replacePerDR=obj2.ArgPerDR
	.....s replaceRowDR=obj1
	....i ..IsPerAskLeavel2(replacePerDR.%Id()_"^"_date)=1 d
	.....s replacePerDR=subObj.ArgPerDR
	.....s subObj.ArgRowDR=replaceRowDR
	....s ward=##class(web.INMHRComm).GetCurrentWard(replacePerDR.%Id(),date)
	....i (ward'="")&&($IsObject(subObj.ArgWardDR))&&(ward'=subObj.ArgWardDR.%Id()) s ret=0
	....q:ret=0
	....s subObj.ArgPerDR=replacePerDR
	....s sc=subObj.%Save()
	....s ret=$$$ISOK(sc)
	....q:ret=0
	if ret=1{
		TC
		q ret	
	}else{
		TRO
		q ret	
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 人员移动含班次
/// table: DHCINM.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.INMArgComm).MoveArgPerson(^tmpXbl("parr1"),^tmpXbl("persons"),"D")
ClassMethod MoveArgPerson(parr1 As %String, persons As %String, type As %String, parr2 As %String = "") As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("persons")=persons_"^"_type
	q:(parr1="")!(persons="")!(type="")!(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s ret=0
	i type="U" d
	.f i=1:1:$L(persons,",") d
	..s perdr=$P(persons,",",i)
	..q:perdr=""
	..s id1=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	..q:id1=""
	..s obj1=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id1)
	..s sort1=obj1.ArgPerSort
	..s sort2=sort1-1
	..s id2=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	..q:id2=""
	..s obj2=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id2)
	..i obj1.ArgGroupDR'=obj2.ArgGroupDR d
	...i obj2.ArgGroupDR'="" d
	....s obj1.ArgGroupDR=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(obj2.ArgGroupDR.%Id())
	...e  s obj1.ArgGroupDR=""
	...s ret=1
	..e  d
	...s obj2.ArgPerSort=sort1
	...s sc=obj2.%Save()
	...s ret=$$$ISOK(sc)
	...q:ret=0
	...s obj1.ArgPerSort=sort2
	..q:ret=0
	..s sc=obj1.%Save()
	..s ret=$$$ISOK(sc)
	i type="D" d
	.f i=$L(persons,","):-1:1 d
	..s perdr=$P(persons,",",i)
	..q:perdr=""
	..s id1=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	..q:id1=""
	..s obj1=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id1)
	..s sort1=obj1.ArgPerSort
	..s sort2=sort1+1
	..s id2=$O(^DHCINM.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	..q:id2=""
	..s obj2=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id2)
	..i obj1.ArgGroupDR'=obj2.ArgGroupDR d
	...i obj2.ArgGroupDR'="" d
	....s obj1.ArgGroupDR=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(obj2.ArgGroupDR.%Id())
	...e  s obj1.ArgGroupDR=""
	...s ret=1
	..e  d
	...s obj2.ArgPerSort=sort1
	...s sc=obj2.%Save()
	...s ret=$$$ISOK(sc)
	...q:ret=0
	...s obj1.ArgPerSort=sort2
	..q:ret=0
	..s sc=obj1.%Save()
	..s ret=$$$ISOK(sc)
	q ret
}

/// creator: lulin	
/// createdate: 2018-07-17
/// description: 复制上个周期排班
/// table: 
/// input: 
/// output:0:失败，id：排班id
/// other:
ClassMethod copyLastArg(parr As %String = "", lastid As %String = "") As %String
{
	q:lastid="" 0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s stdate=tmp("ArgStDate")
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=tmp("ArgEndDate")
	s:enddate["-" enddate=$zdh(enddate,3)
	q:(stdate="")||(enddate="") 0
	s dateStep=enddate-stdate+1
	TS
	s argid=..SaveArrange(parr)
	if +argid=0{
		Tro 
		q 0	
	}
	q:+argid=0 0
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	s flag=1
	k tmpgroup
	s tmpgroup=""
	s groupid="" f  s groupid=$O(^DHCINM.Arg.MgArrangeGroupI("Arrange",lastid,groupid)) q:(groupid="")||(flag=0)  d
	.s oldGroup=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(groupid)
	.q:'$IsObject(oldGroup)
	.s newGroup=##class(DHCINM.Arg.MgArrangeGroup).%New()
	.s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeGroup","a",p)) q:p=""  d
	..q:p["%"
	..i p="ArrangeDR" d
	...s newGroup.ArrangeDR=argObj
	..e  s $ZOBJPROPERTY(newGroup,p)=$ZOBJPROPERTY(oldGroup,p)
	.s sc=newGroup.%Save()
	.s:$$$ISERR(sc) flag=0
	.s:flag'=0 tmpgroup(oldGroup.%Id())=newGroup
	if flag=0 {
		Tro
		q 0	
	}
	s tmpRow=""
	s rowid="" f  s rowid=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",lastid,rowid)) q:(rowid="")||(flag=0)  d
	.s oldRow=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowid)
	.q:'$IsObject(oldRow)
	.//过滤掉非本病区人员
	.q:'$IsObject(oldRow.ArgPerDR)
	.s isinWard=##class(web.INMHRComm).CheckNurWard(oldRow.ArgPerDR.%Id(),argObj.ArgWardDR.%Id(),stdate,enddate)
	.q:isinWard'=1 //这段时间内不在本病区的
	.s newRow=##class(DHCINM.Arg.MgArrangeRow).%New()
	.s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeRow","a",p)) q:p=""  d
	..q:p["%"
	..i p="ArrangeDR" d
	...s newRow.ArrangeDR=argObj
	..e  i p="ArgGroupDR" d
	...i (oldRow.ArgGroupDR'="")&&($d(tmpgroup(oldRow.ArgGroupDR.%Id())))  s newRow.ArgGroupDR=tmpgroup(oldRow.ArgGroupDR.%Id())
	..e  s $ZOBJPROPERTY(newRow,p)=$ZOBJPROPERTY(oldRow,p)
	.s sc=newRow.%Save()
	.s:$$$ISERR(sc) flag=0
	.s:flag'=0 tmpRow(oldRow.%Id())=newRow
	if flag=0 {
		Tro
		q 0	
	}
	s ward=argObj.ArgWardDR.%Id(),local=$h,flag=1
	s subid="" f  s subid=$O(^DHCINM.Arg.MgArrangeSubI("Arg",lastid,subid)) q:(subid="")||(flag=0)  d
	.s oSubObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subid)
	.q:'$IsObject(oSubObj)
	.q:'$IsObject(oSubObj.ArgPerDR)
	.q:'$IsObject(oSubObj.ArgPostDR)
	.q:'$IsObject(oSubObj.ArgRowDR)
	.q:oSubObj.ArgIsReplace=2
	.//g过滤掉非本病区人员
	.s perdr=oSubObj.ArgPerDR.%Id()
	.s date=oSubObj.ArgDate+dateStep
	.s postdr=oSubObj.ArgPostDR.%Id()
	.s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.q:curward'=ward
	.q:'$d(tmpRow(oSubObj.ArgRowDR.%Id()))
	.s nSubObj=##class(DHCINM.Arg.MgArrangeSub).%New()
	.s nSubObj.ArrangeDR=argObj
	.s:$d(tmpRow(oSubObj.ArgRowDR.%Id())) nSubObj.ArgRowDR=tmpRow(oSubObj.ArgRowDR.%Id())
	.s nSubObj.ArgWardDR=oSubObj.ArgWardDR
	.s nSubObj.ArgPerDR=oSubObj.ArgPerDR
	.s nSubObj.ArgPostDR=oSubObj.ArgPostDR
	.s nSubObj.ArgCategory=oSubObj.ArgCategory
	.s nSubObj.ArgDate=oSubObj.ArgDate+dateStep
	.s nSubObj.ArgStTime1=oSubObj.ArgStTime1
	.s nSubObj.ArgEndTime1=oSubObj.ArgEndTime1
	.s nSubObj.ArgStTime2=oSubObj.ArgStTime2
	.s nSubObj.ArgEndTime2=oSubObj.ArgEndTime2
	.s nSubObj.ArgStTime3=oSubObj.ArgStTime3
	.s nSubObj.ArgEndTime3=oSubObj.ArgEndTime3
	.s nSubObj.ArgRemark=oSubObj.ArgRemark
	.s nSubObj.ArgHolidayTime=oSubObj.ArgHolidayTime
	.s nSubObj.ArgSecStTime=oSubObj.ArgSecStTime
	.s nSubObj.ArgSecEndTime=oSubObj.ArgSecEndTime
	.;i $g(tmp("ArgCrtUser"))'="" d
	..;s nSubObj.ArgEditUser=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("ArgCrtUser"))
	.;e  s nSubObj.ArgEditUser=""
	.s nSubObj.ArgEditUser=$g(tmp("ArgCrtUser"))
	.s nSubObj.ArgEditDate=+local
	.s nSubObj.ArgEditTime=$P(local,",",2)
	.s sc=nSubObj.%Save()
	.s:$$$ISERR(sc) flag=0
	if flag=0 {
		Tro
		q 0	
	}else{
		TC
		q argid	
	}
	q 0
}

/// creator: llin	
/// createdate: 2018-08-02
/// description: 保存审核后班次修改记录
/// table: 
/// input: 
/// output:1：成功;其他：失败原因
/// other:
ClassMethod SaveArgLog(parr) As %String
{
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId($g(tmp("ArrangeDR")))
	q:'$IsObject(argObj) "未找到排班记录，请刷新界面"
	s obj=##class(DHCINM.Arg.MgArrangeLog).%New()
	s obj.ArrangeDR=argObj
	s obj.ArgLogPerDR=$g(tmp("ArgLogPerDR"))
	s argdate=$g(tmp("argDate"))
	s:$l(argdate,"-")'=3 argdate=""
	s:$l(argdate,"-")=3 argdate=$zdh(argdate,3)
	s obj.ArgLogArgDate=argdate
	s ArgLogBefor=$g(tmp("ArgLogBefor"))
	s beforObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(ArgLogBefor)
	s:$IsObject(beforObj) ArgLogBefor=beforObj.PostDesc
	s obj.ArgLogBefor=ArgLogBefor
	s ArgLogAfter=$g(tmp("ArgLogAfter"))
	s afterObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(ArgLogAfter)
	s:$IsObject(afterObj) ArgLogAfter=beforObj.PostDesc
	s obj.ArgLogAfter=$g(tmp("ArgLogAfter"))
	s obj.ArgLogRemark=$g(tmp("ArgLogRemark"))
	s obj.ArgLogCrt=$g(tmp("ArgLogCrt"))
	s obj.ArgLogCrtDate=+$h
	s obj.ArgLogCrtTime=$p($h,",",2)
	i $g(tmp("ArgLogReason"))="null" s tmp("ArgLogReason")=""
	s obj.ArgLogReason=$g(tmp("ArgLogReason"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q "保存失败"
}

/// Creator:gzj
/// Date:2019-05-15
/// Description:删除加班班次
/// Table:DHCINM.Arg.MgArrangeSub
/// Input:id 记录ID
/// Output:
/// Return:
/// Other:
ClassMethod DeleteArgPlus(id As %String, nurseId As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	q:'$IsObject(obj) 0
	s flag=1
	Ts
	i ((obj.ArrangeDR.ArgStatus="R")!(obj.ArrangeDR.ArgStatus="A"))
	{
		s LogObj=##class(DHCINM.Arg.MgArrangeLog).%New()
		s LogObj.ArgLogPerDR=obj.ArgPerDR.%Id()
		s LogObj.ArrangeDR=obj.ArrangeDR
		s LogObj.ArgLogArgDate=obj.ArgDate
		s LogObj.ArgLogBefor=$case(obj.ArgType,"Y":"加班"_obj.ArgStTime1_"-"_obj.ArgEndTime1,"N":"减班"_obj.ArgStTime1_"-"_obj.ArgEndTime1)
		s LogObj.ArgLogRemark="删除班次"
		s LogObj.ArgLogCrt=nurseId
		s LogObj.ArgLogCrtDate=+$h
		s LogObj.ArgLogCrtTime=$p($h,",",2)
		s sc=LogObj.%Save()
		s flag=($$$ISOK(sc)&&flag)
	}
	s argSc=obj.%DeleteId(id)
	s flag=($$$ISOK(argSc)&&flag)
	i flag=1
	{
		tc
	}
	else
	{
		tro
	}
	q flag
}

/// Creator:lulin
/// CreateDate:2019年9月18日
/// Description:保存意愿排班
/// Table:DHCINM.Arg.MgWishArrange
/// Input：表字段
/// Output:保存是否成功
/// Return:返回状态码 1:成功，0：失败
/// Other:
ClassMethod SaveWishArrange(parr As %String) As %String
{
	s tmp=""
	s $ZT="ERROR"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:tmp("PerDR")=0 "超级管理员无法申请"
	s userObj=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("PerDR"))
	q:'$IsObject(userObj) "Person表不存在对应人员,无法申请"
	s error=""
	//检测是否排班周期是否已提交，则不能申请
	s wishDate=tmp("WishDate")
	s wardId=$g(tmp("WardDR"))
	q:(wishDate="")||(wardId="") "参数为空，无法保存"
	s wishDate=$zdh(wishDate,3)
	s stDate="" f  s stDate=$O(^DHCINM.Arg.MgArrangeI("WardDate",wardId,stDate)) q:(stDate="")||(error'="")  d
	.q:(stDate>wishDate)
	.s endDate="" f  s endDate=$O(^DHCINM.Arg.MgArrangeI("WardDate",wardId,stDate,endDate)) q:(endDate="")||(error'="")  d
	..q:endDate<wishDate
	..s argId="" f  s argId=$O(^DHCINM.Arg.MgArrangeI("WardDate",wardId,stDate,endDate,argId)) q:(argId="")||(error'="")  d
	...s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argId)
	...q:'$IsObject(argObj)
	...s:(argObj.ArgStatus'="N")&&(argObj.ArgStatus'="S") error="排班非草稿或保存状态，不可申请排班"
	q:error'="" error
	if $g(tmp("rw"))=""{
		s obj=##class(DHCINM.Arg.MgWishArrange).%New()
	}else{
		s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(tmp("rw"))
		s:'$IsObject(obj) error="无对应数据请刷新重试"
		s:($IsObject(obj))&&(obj.Status'="N") error="非未提交状态，不可修改"
	}
	q:error'="" error
	s obj.PerDR=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("PerDR"))
	s obj.WardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("WardDR"))
	s obj.WishDate=$zdh(tmp("WishDate"),3)
	s obj.PostDR=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(tmp("PostDR"))
	s obj.Remark=$g(tmp("Remark"))
	s obj.Status=$g(tmp("Status"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
ERROR
	s $ZT=""
    s ErrorMsg=$ZE
    Quit "Error"_$SYSTEM.Status.DisplayError(ErrorMsg)
}

///   lulin
///  createdate: 2019-9-19
///  description: 排班界面显示已提交的意愿排班【专属于排班界面显示】
///  table: DHCINM.Arg.MgWishArrange
///  input:Id
///  output:
///  other:
ClassMethod getWishArrangeForArgSub(ward, date, perId) As %String
{
	q:(ward="")||(perId="")||(date="")
	s ret=""
	s id="" f  s id=$O(^DHCINM.Arg.MgWishArrangeI("WardPerDate",ward,perId,date,id)) q:id=""  d
	.s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.PostDR)
	.q:obj.Status'="S"
	.i ret="" s ret=obj.%Id()_"」"_obj.PostDR.PostDesc
	.e  s ret=ret_"「"_obj.%Id()_"」"_obj.PostDR.PostDesc
	q ret
}

/// Description: 获取意愿排班
/// Date: 2020-08-04
/// Creator: wangpf
/// Table: DHCINM.Arg.MgWishArrange
/// Input: id
/// Output: 意愿排班
/// Other: w ##class(web.INMSpecialComm).getWishArrange(1)
ClassMethod getWishArrange(id As %String = "") As %String
{
	q:id="" "传参失败请刷新重试"
	s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(id)
	s rw=obj.%Id()
	s WardDR="",WardDesc=""
	s:$IsObject(obj.WardDR) WardDR=obj.WardDR.%Id(),WardDesc=obj.WardDR.WardDesc
	s PerDR="",PerName=""
	s:$IsObject(obj.PerDR) PerDR=obj.PerDR.%Id(),PerName=obj.PerDR.PerName
	s WishDate=obj.WishDate
	s:WishDate'="" WishDate=##class(web.INMHISComm).DateLogicalToHtml(WishDate)
	s Remark=obj.Remark
	s Status=obj.Status
	s StatusDesc=$case(Status,"N":"未提交","S":"已提交","A":"已审核","B":"驳回",:"未提交")
	s Auditor=obj.Auditor,AuditorName=""
	i Auditor=0 s AuditorName="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(Auditor)
	.q:'$IsObject(userObj)
	.s AuditorName=userObj.UserName
	s AuditDate=obj.AuditDate
	s:AuditDate'="" AuditDate=##class(web.INMHISComm).DateLogicalToHtml(AuditDate)
	///班次日期返回到审核界面显示
	s PostDR="",PostDesc="",ArgTime=""
	i $IsObject(obj.PostDR) d
	.s PostDR=obj.PostDR.%Id(),PostDesc=obj.PostDR.PostDesc
	.s st1=obj.PostDR.PostStTime1
	.s end1=obj.PostDR.PostEndTime1
	.s ArgTime=st1_"-"_end1
	.s st2=obj.PostDR.PostStTime2
	.s end2=obj.PostDR.PostEndTime2
	.i st2'="" d
	..i ArgTime="" s ArgTime=st2_""_end2
	..e  s ArgTime=ArgTime_";"_st2_""_end2
	.s st3=obj.PostDR.PostStTime3
	.s end3=obj.PostDR.PostEndTime3
	.i st3'="" d
	..i ArgTime="" s ArgTime=st3_"-"_end3
	..e  s ArgTime=ArgTime_";"_st3_"-"_end3
	s ret="WardDR|"_WardDR_"^WardDesc|"_WardDesc_"^PerDR|"_PerDR_"^PerName|"_PerName_"^WishDate|"_WishDate
	_"^PostDR|"_PostDR_"^PostDesc|"_PostDesc_"^Remark|"_Remark_"^Status|"_Status_"^StatusDesc|"_StatusDesc
	_"^Auditor|"_Auditor_"^AuditorName|"_AuditorName_"^AuditDate|"_AuditDate
	_"^rw|"_rw_"^ArgTime|"_ArgTime
	q ret
}

/// Description：获取意愿排班列表
/// Date:2020-08-04
/// Creator:wangpf
/// Table:DHCINM.Arg.MgWishArrange
/// Input: 登录人Id^开始日期^结束日期
/// Output:意愿排班列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindWishArrangeList","",0)
Query FindWishArrangeList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWishArrangeListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s perId=$P(parr,"^",1)
	s stDate=$P(parr,"^",2)
	s endDate=$p(parr,"^",3)
	i stDate["-" s stDate=$zdh(stDate,3)
	i endDate["-" s endDate=$zdh(endDate,3)
	
	s:(nurseid="")&&(perId'="") nurseid=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i nurseid=0 s nursePer=0
	e  s nursePer=$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),5)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s wishPer="" f  s wishPer=$O(^DHCINM.Arg.MgWishArrangeI("PerDate",wishPer)) q:wishPer=""  d
	.q:(perId'="")&&(perId'=wishPer)
	.s date="" f  s date=$O(^DHCINM.Arg.MgWishArrangeI("PerDate",wishPer,date)) q:date=""  d
	..q:(stDate'="")&&(date<stDate)
	..q:(endDate'="")&&(date>endDate)
	..s id="" f  s id=$O(^DHCINM.Arg.MgWishArrangeI("PerDate",wishPer,date,id)) q:id=""  d
	...q:'$d(^DHCINM.Arg.MgWishArrangeD(id))
	...s glo=^DHCINM.Arg.MgWishArrangeD(id)
	...s wishWard=$lg(glo,2)
	...s wishPer=$lg(glo,3)
	...s wishStatus=$lg(glo,7)
	...q:(nursePer'=0)&&(nursePer'=wishPer)&&((wishStatus="N")||(wishStatus="B"))
	...q:(nursePer'=0)&&(wishStatus'="N")&&(wishStatus'="B")&&((isAll'=1)&&('$d(tmpWard(wishWard))))
	...s ret=..getWishArrange(id)
	...q:ret=""
	...d OutWishArg
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWishArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWishArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWishArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWishArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWishArrangeListExecute ]
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

/// Creator:lulin
/// CreateDate:2019-9-20
/// Description:审核或者驳回意愿排班
/// Table:DHCINM.Arg.MgWishArrange
/// Input：表字段
/// Output:保存是否成功
/// Return:返回状态码 1:成功；失败信息
/// Other:w ##class(web.INMArgComm).AuditWishArrange("13^120^A^1^6^301")
ClassMethod AuditWishArrange(parr As %String) As %String
{
	s id=$p(parr,"^",1)
	s auditor=$p(parr,"^",2)
	s status=$P(parr,"^",3)
	s type=$P(parr,"^",4)
	s argId=$P(parr,"^",5)
	s rowId=$P(parr,"^",6)
	q:(id="")||(auditor="")||(status="")||(type="") "传参失败，请刷新重试"
	s ret=""
	s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) "未获取到意愿排班数据，请刷新重试"
	q:'$IsObject(obj.PerDR) "未获取到意愿排班人员信息，请刷新重试"
	q:'$IsObject(obj.PostDR) "未获取到意愿排班班次数据，请联系工程师"
	q:'$IsObject(obj.WardDR) "未获取意愿排班病区数据，请联系工程师"
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argId)
	q:'$IsObject(argObj) "未获取到排班数据，请刷新界面"
	q:(argObj.ArgStatus'="N")&&(argObj.ArgStatus'="S") "排班非草稿或保存状态，不可审核意愿排班"
	s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowId)
	q:'$IsObject(rowObj) "未获取到行数据，请刷新"
	//检测重岗
	i status="A" d
	.i type=1 d
	..s checkStr="ArgStTime1|"_obj.PostDR.PostStTime1_"^ArgEndTime1|"_obj.PostDR.PostEndTime1
	..s checkStr=checkStr_"^ArgStTime2|"_obj.PostDR.PostStTime2_"^ArgEndTime2|"_obj.PostDR.PostEndTime2
	..s checkStr=checkStr_"^ArgStTime3|"_obj.PostDR.PostStTime3_"^ArgEndTime3|"_obj.PostDR.PostEndTime3
	..s checkStr=checkStr_"^ArgPerDR|"_obj.PerDR.%Id()_"^ArgDate|"_$zd(obj.WishDate,3)
	..s repeatFlag=..CheckRepeat(checkStr)
	..s ret=repeatFlag
	q:ret'="" ret
	s ret=1
	s obj.Status=status
	;s auditorObj=""
	;i auditor'=0 d
	;.s auditorObj=##class(CF.DHCINM.HR.Persons).%OpenId(auditor)
	;.s:'$IsObject(auditorObj) auditorObj=""
	;s obj.Auditor=auditorObj
	s obj.Auditor=auditor
	s obj.AuditDate=+$h
	TS
	s sc=obj.%Save()
	s:$$$ISERR(sc) ret="修改意愿排班状态失败"	
	//驳回状态
	if status'="A"{
		TC
		q ret	
	}
	//type=0；删除当天排班
	i ((type'=1)&&($IsObject(obj.WardDR))) d
	.//当天某人排班
	.s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("WardPerDate",obj.WardDR.%Id(),obj.PerDR.%Id(),obj.WishDate,id)) q:(id="")||(ret'=1)  d
	..s argobj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(argobj)
	..s sc=##class(DHCINM.Arg.MgArrangeSub).%DeleteId(id)
	..s:$$$ISERR(sc) ret="替换当天排班失败"
	if ret'=1{
		TRO
		q ret	
	}
	//添加本次排班
	s objArg=##class(DHCINM.Arg.MgArrangeSub).%New()
	s objArg.ArrangeDR=argObj
	s objArg.ArgRowDR=rowObj
	s objArg.ArgWardDR=obj.WardDR
	s objArg.ArgPerDR=obj.PerDR
	s objArg.ArgPostDR=obj.PostDR
	s objArg.ArgCategory=obj.PostDR.PostCategory
	s objArg.ArgDate=obj.WishDate
	s objArg.ArgStTime1=obj.PostDR.PostStTime1
	s objArg.ArgEndTime1=obj.PostDR.PostEndTime1
	s objArg.ArgStTime2=obj.PostDR.PostStTime2
	s objArg.ArgEndTime2=obj.PostDR.PostEndTime2
	s objArg.ArgStTime3=obj.PostDR.PostStTime3
	s objArg.ArgEndTime3=obj.PostDR.PostEndTime3
	s objArg.ArgRemark=obj.Remark
	s objArg.ArgEditUser=obj.Auditor
	s objArg.ArgEditDate=+$h
	s objArg.ArgEditTime=$P($h,",",2)
	s objArg.ArgType="P"
	s objArg.ArgWishDR=obj.%Id()
	s sc=objArg.%Save()
	if $$$ISOK(sc){
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:gzj
/// Date:2020-03-25
/// Description：获取意愿排班的记录状态
/// 
ClassMethod getWishArgStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.Status
	q status
}

/// Creator:gzj
/// Date:2020-03-25
/// Description:删除意愿排班记录
/// 
ClassMethod DeleteWishRec(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: wangpf
///  createdate: 2020-01-10
///  description:调整排班表行顺序
///  table: DHCINM.Arg.MgArrangeRow
///  input:开始行 结束行
///  output:
///  other:w ##class(web.INMArgComm).ChangeArgRowSort("22「15@14「16@15「17@16「18@17「19@18「20@19「21@20「22@21「14「-")
ClassMethod ChangeArgRowSort(parr As %String = "") As %String
{
	q:parr="" 0
	s rowList=$lfs(parr,"@")
	s ptr=0
	s flag=1
	ts
	while ($listnext(rowList,ptr,value))&&(flag=1)
	{
		q:value=""
		s rowId=$p(value,"「")
		s rowSort=$p(value,"「",2)
		s rowGroup=$p(value,"「",3)
		s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(rowId)
		q:'$IsObject(rowObj)
		s rowObj.ArgPerSort=rowSort
		i (rowGroup'="") d
		.s groupObj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(rowGroup)
		.i $IsObject(groupObj) s rowObj.ArgGroupDR=groupObj
		.e  s rowObj.ArgGroupDR=""
		s flag=rowObj.%Save()
	}
	i flag=1 tc
	e  tro
	q flag
}

/*
*---------------------------分割线----------------------------
*/
/// Description：获取护士某天排班
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 日期 护士Id
/// Output:护士某天排班
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","GetNurDayArgList","2020-07-02",1)
Query GetNurDayArgList(date As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetNurDayArgListExecute(ByRef qHandle As %Binary, date As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (date="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s:date["-" date=$zdh(date,3)
	
	s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurseid,date,subId)) q:subId=""  d
	.q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	.s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	.s ward=$lg(subGlo,4)
	.s wardPost=$lg(subGlo,7)
	.q:wardPost=""
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	.s wardPostDesc=$lg(wardPostGlo,2)
	.s ret="PostDesc|"_wardPostDesc_"^Ward|"_ward_"^rw|"_subId
	.d OutArgList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetNurDayArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurDayArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurDayArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurDayArgListExecute ]
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

/// Description: 保存改班申请
/// Date: 2020-06-29
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgChangeApp
/// Input: parr 登录人Id
/// Output: -1：时间交叉 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).SaveChangeApp("21^3^",1)
ClassMethod SaveChangeApp(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:'$d(^CF.DHCINM.HR.PersonsD(nurseid)) 0
	s source=$p(parr,"^")
	s argSubObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(source)
	q:'$IsObject(argSubObj) 0
	s post=$p(parr,"^",2)
	s wardPostObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(post)
	q:'$IsObject(wardPostObj) 0
	s rw=$p(parr,"^",3)
	
	s tmpParr="ArgPerDR|"_nurseid_"^ArgDate|"_argSubObj.ArgDate_"^ArgStTime1|"_wardPostObj.PostStTime1
	s tmpParr=tmpParr_"^ArgEndTime1|"_wardPostObj.PostEndTime1_"^ArgStTime2|"_wardPostObj.PostStTime2
	s tmpParr=tmpParr_"^ArgEndTime2|"_wardPostObj.PostEndTime2_"^ArgStTime3|"_wardPostObj.PostStTime3
	s tmpParr=tmpParr_"^ArgEndTime3|"_wardPostObj.PostEndTime3_"^ArgType|^rw|"_source
	s flag=..CheckRepeat(tmpParr)
	q:flag'="" -1
	
	i rw="" d
	.s changeObj=##class(DHCINM.Arg.MgArgChangeApp).%New()
	.d changeObj.ChangeNurseSetObjectId(nurseid)
	e  s changeObj=##class(DHCINM.Arg.MgArgChangeApp).%OpenId(rw)
	q:'$IsObject(changeObj) 0
	s changeObj.ChangeWard=argSubObj.ArgWardDR
	s changeObj.ChangeSource=argSubObj
	s changeObj.ChangeSourceDate=argSubObj.ArgDate
	s changeObj.ChangeFromPost=argSubObj.ArgPostDR
	s changeObj.ChangeToPost=wardPostObj
	s changeObj.ChangeStatus="Y"
	s sc=changeObj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取护士改班申请信息
/// Date: 2020-06-29
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgChangeApp
/// Input: id
/// Output: 护士改班申请信息
/// Other: w ##class(web.INMArgComm).GetChangeApp(1)
ClassMethod GetChangeApp(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgArgChangeAppD(id))) ""
	s changeGlo=^DHCINM.Arg.MgArgChangeAppD(id)
	
	s changeWard=$lg(changeGlo,2)
	s changeWardDesc=""
	i changeWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(changeWard))
	.s changeWardDesc=$lg(wardGlo,4)
	s changeNurse=$lg(changeGlo,3)
	s changeNurseName=""
	i changeNurse'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(changeNurse))
	.s changeNurseName=$lg(perGlo,2)
	s changeSource=$lg(changeGlo,4)
	s changeSourceDate=$lg(changeGlo,5)
	s:changeSourceDate'="" changeSourceDate=##class(INMHISComm).DateLogicalToHtml(changeSourceDate)
	s changeFromPost=$lg(changeGlo,6)
	s changeFromPostDesc=""
	i changeFromPost'="" d
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(changeFromPost))
	.s changeFromPostDesc=$lg(wardPostGlo,2)
	s changeToPost=$lg(changeGlo,7)
	s changeToPostDesc=""
	i changeToPost'="" d
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(changeToPost))
	.s changeToPostDesc=$lg(wardPostGlo,2)
	s changeStatus=$lg(changeGlo,8)
	s changeStatusDesc=$case(changeStatus,"B":"驳回","Y":"提交","A":"审核",:"")
	s createDate=$lg(changeGlo,9)
	s:createDate'="" createDate=##class(INMHISComm).DateLogicalToHtml(createDate)
	s createTime=$lg(changeGlo,10)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(changeGlo,11)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.;s perGlo=$g(^CF.DHCINM.HR.PersonsD(auditor))
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(changeGlo,12)
	s:auditDate'="" auditDate=##class(INMHISComm).DateLogicalToHtml(auditDate)
	s auditTime=$lg(changeGlo,13)
	s:auditTime'="" auditTime=$zt(auditTime)
	s auditOpinion=$lg(changeGlo,14)
	s ret="ChangeWard|"_changeWard_"^ChangeWardDesc|"_changeWardDesc_"^ChangeNurse|"_changeNurse_"^ChangeNurseName|"_changeNurseName_"^ChangeSource|"_changeSource
	s ret=ret_"^ChangeSourceDate|"_changeSourceDate_"^ChangeFromPost|"_changeFromPost_"^ChangeFromPostDesc|"_changeFromPostDesc_"^ChangeToPost|"_changeToPost
	s ret=ret_"^ChangeToPostDesc|"_changeToPostDesc_"^ChangeStatus|"_changeStatus_"^ChangeStatusDesc|"_changeStatusDesc_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime
	s ret=ret_"^AuditOpinion|"_auditOpinion_"^rw|"_id
	q ret
}

/// Description：查询护士改班列表
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArgChangeApp
/// Input: 病区Id^开始日期^结束日期 登录人Id 登录人角色
/// Output:护士改班列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgChangeList","1^2020-06-01^2020-06-30",0,0)
Query FindArgChangeList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgChangeListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.Arg.MgArgChangeAppD(id)) q:id=""  d
	.s changeGlo=^DHCINM.Arg.MgArgChangeAppD(id)
	.s changeWard=$lg(changeGlo,2)
	.q:((ward'="")&&(ward'=changeWard))||((isAll'=1)&&('$d(tmpWard(changeWard))))
	.s changeSourceDate=$lg(changeGlo,5)
	.q:((stDate'="")&&(stDate>changeSourceDate))||((endDate'="")&&(endDate<changeSourceDate))
	.s ret=..GetChangeApp(id)
	.d:ret'="" OutChangeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutChangeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgChangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgChangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgChangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgChangeListExecute ]
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

/// Description: 审核护士改班申请
/// Date: 2020-06-29
/// Creator: wangpf
/// Table:DHCINM.Arg.MgArgChangeApp
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).AuditChangeApp("A^^3",0)
ClassMethod AuditChangeApp(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	;q:(nurseid'=0)&&('$d(^CF.DHCINM.HR.PersonsD(nurseid))) 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.Arg.MgArgChangeApp).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.AuditOpinion=opinion
	s obj.ChangeStatus=status
	ts
	s sc=obj.%Save()
	i (status="A")&&($$$ISOK(sc)) d
	.s obj.ChangeSource.ArgPostDR=obj.ChangeToPost
	.s obj.ChangeSource.ArgCategory=obj.ChangeToPost.PostCategory
	.s obj.ChangeSource.ArgStTime1=obj.ChangeToPost.PostStTime1
	.s obj.ChangeSource.ArgEndTime1=obj.ChangeToPost.PostEndTime1
	.s obj.ChangeSource.ArgStTime2=obj.ChangeToPost.PostStTime2
	.s obj.ChangeSource.ArgEndTime2=obj.ChangeToPost.PostEndTime2
	.s obj.ChangeSource.ArgStTime3=obj.ChangeToPost.PostStTime3
	.s obj.ChangeSource.ArgEndTime3=obj.ChangeToPost.PostEndTime3
	.s obj.ChangeSource.ArgHolidayTime=""
	.;i nurseid'=0 d obj.ChangeSource.ArgEditUserSetObjectId(nurseid)
	.;e  s obj.ChangeSource.ArgEditUser=""
	.s obj.ChangeSource.ArgEditUser=nurseid
	.s now=$h
	.s obj.ChangeSource.ArgEditDate=+now
	.s obj.ChangeSource.ArgEditTime=$p(now,",",2)
	.s obj.ChangeSource.ArgSecStTime=""
	.s obj.ChangeSource.ArgSecEndTime=""
	.s obj.ChangeSource.ArgType=""
	.s obj.ChangeSource.ArgWishDR=""
	.s sc=obj.ChangeSource.%Save()
	i $$$ISOK(sc) tc  
	e  tro  q 0
	try{
		i ((obj.ChangeStatus="A")||(obj.ChangeStatus="B")) d
		.s ChangeStatusDesc=$case(obj.ChangeStatus,"A":"审核","B":"驳回") ;状态
		.s applicantId=$LG($g(^DHCINM.Arg.MgArgChangeAppD(rw)),3) ;创建人id
		.s applicant=""
		.s:applicantId'="" applicant=$LG($g(^CF.DHCINM.HR.PersonsD(applicantId)),2) ;创建人姓名
		.s changeFromPost1=$LG($g(^DHCINM.Arg.MgArgChangeAppD(rw)),6) ;申请班次描述
		.s changeFromPost=""
		.s:changeFromPost1'="" changeFromPost=$LG($g(^CF.DHCINM.DB.MgArgWardPostD(changeFromPost1)),2)
		.s changeToPost1=$LG($g(^DHCINM.Arg.MgArgChangeAppD(rw)),7)  ;改班班次描述 
		.s changeToPost=""
		.s:changeToPost1'="" changeToPost=$LG($g(^CF.DHCINM.DB.MgArgWardPostD(changeToPost1)),2)
		.s changeDate1=$LG($g(^DHCINM.Arg.MgArgChangeAppD(rw)),5) ;改班日期
		.s changeDate=""
		.s:changeDate1'="" changeDate=$zd(changeDate1,3) 
		.s applicantId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_applicantId,""))
		.s ret="【科室事务/改班申请】 "_ChangeStatusDesc_" "_applicant_" "_changeDate_" "_changeFromPost_"->"_changeToPost
		.d:applicantId'="" ##class(web.INMPlatform).SaveTrackMessage(applicantId,+$H,ret,"","DHCINM.Arg.MgArgChangeApp",rw)
	}catch{
		}
	q 1
}

/// Description: 删除护士改班申请
/// Date: 2020-06-29
/// Creator: wangpf
/// Table:DHCINM.Arg.MgArgChangeApp
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).DeleteChangeApp(1)
ClassMethod DeleteChangeApp(id As %String = "") As %String
{
	q:id="" 0
	
	s obj=##class(DHCINM.Arg.MgArgChangeApp).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(obj.ChangeStatus'="B") 0 ;&&(obj.ChangeStatus'="Y")
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：获取某天某病区有排班的护士
/// Date:2020-06-30
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 日期 病区Id
/// Output:某天某病区有排班的护士
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","GetDayArgNurseList","2020-07-02",1)
Query GetDayArgNurseList(date As %String = "", ward As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod GetDayArgNurseListExecute(ByRef qHandle As %Binary, date As %String = "", ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (date="")||(ward="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s:date["-" date=$zdh(date,3)
	
	k tmp
	s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",ward,date,subId)) q:subId=""  d
	.q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	.s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	.s per=$lg(subGlo,5)
	.q:per=""
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.s tmp($lg(subGlo,5))=perName
	
	s per="" f  s per=$o(tmp(per)) q:per=""  d
	.s ret="Per|"_per_"^PerName|"_tmp(per)
	.d OutNurseList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetDayArgNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDayArgNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDayArgNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDayArgNurseListExecute ]
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

/// Description: 保存换班申请
/// Date: 2020-06-30
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgExchangeApp
/// Input: parr
/// Output: -1：时间交叉 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).SaveExchangeApp("2020-07-02^1^21^2020-07-02^2^23^")
ClassMethod SaveExchangeApp(parr As %String = "") As %String
{
	q:parr="" 0
	
	s fromDate=$p(parr,"^")
	s:fromDate["-" fromDate=$zdh(fromDate,3)
	s fromNurse=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.HR.PersonsD(fromNurse)) 0
	s fromArg=$p(parr,"^",3)
	s fromArgObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(fromArg)
	q:'$IsObject(fromArgObj) 0
	s toDate=$p(parr,"^",4)
	s:toDate["-" toDate=$zdh(toDate,3)
	s toNurse=$p(parr,"^",5)
	q:'$d(^CF.DHCINM.HR.PersonsD(toNurse)) 0
	s toArg=$p(parr,"^",6)
	s toArgObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(toArg)
	q:'$IsObject(toArgObj) 0
	s rw=$p(parr,"^",7)
	
	s tmpParr="ArgPerDR|"_toNurse_"^ArgDate|"_fromArgObj.ArgDate_"^ArgStTime1|"_fromArgObj.ArgStTime1
	s tmpParr=tmpParr_"^ArgEndTime1|"_fromArgObj.ArgEndTime1_"^ArgStTime2|"_fromArgObj.ArgStTime2
	s tmpParr=tmpParr_"^ArgEndTime2|"_fromArgObj.ArgEndTime2_"^ArgStTime3|"_fromArgObj.ArgStTime3
	s tmpParr=tmpParr_"^ArgEndTime3|"_fromArgObj.ArgEndTime3_"^ArgType|^rw|"_toArg
	s flag=..CheckRepeat(tmpParr)
	q:flag'="" -1
	
	s tmpParr="ArgPerDR|"_fromNurse_"^ArgDate|"_toArgObj.ArgDate_"^ArgStTime1|"_toArgObj.ArgStTime1
	s tmpParr=tmpParr_"^ArgEndTime1|"_toArgObj.ArgEndTime1_"^ArgStTime2|"_toArgObj.ArgStTime2
	s tmpParr=tmpParr_"^ArgEndTime2|"_toArgObj.ArgEndTime2_"^ArgStTime3|"_toArgObj.ArgStTime3
	s tmpParr=tmpParr_"^ArgEndTime3|"_toArgObj.ArgEndTime3_"^ArgType|^rw|"_fromArg
	s flag=..CheckRepeat(tmpParr)
	q:flag'="" -1
	
	i rw="" d
	.s exchangeObj=##class(DHCINM.Arg.MgArgExchangeApp).%New()
	.d exchangeObj.ExchangeFromNurseSetObjectId(fromNurse)
	e  s exchangeObj=##class(DHCINM.Arg.MgArgExchangeApp).%OpenId(rw)
	q:'$IsObject(exchangeObj) 0
	s exchangeObj.ExchangeWard=fromArgObj.ArgWardDR
	s exchangeObj.ExchangeFromArg=fromArgObj
	s exchangeObj.ExchangeFromArgDate=fromDate
	d exchangeObj.ExchangeToNurseSetObjectId(toNurse)
	s exchangeObj.ExchangeToArg=toArgObj
	s exchangeObj.ExchangeToArgDate=toDate
	s exchangeObj.ExchangeStatus="Y"
	s sc=exchangeObj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取护士换班申请信息
/// Date: 2020-06-30
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgExchangeApp
/// Input: id
/// Output: 护士换班申请信息
/// Other: w ##class(web.INMArgComm).GetExchangeApp(1)
ClassMethod GetExchangeApp(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgArgExchangeAppD(id))) ""
	s exchangeGlo=^DHCINM.Arg.MgArgExchangeAppD(id)
	
	s exchangeWard=$lg(exchangeGlo,2)
	s exchangeWardDesc=""
	i exchangeWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(exchangeWard))
	.s exchangeWardDesc=$lg(wardGlo,4)
	s exchangeFromNurse=$lg(exchangeGlo,3)
	s exchangeFromNurseName=""
	i exchangeFromNurse'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(exchangeFromNurse))
	.s exchangeFromNurseName=$lg(perGlo,2)
	s exchangeFromArg=$lg(exchangeGlo,4)
	s exchangeFromArgDesc=""
	i exchangeFromArg'="" d
	.s argSubGlo=$g(^DHCINM.Arg.MgArrangeSubD(exchangeFromArg))
	.s wardPost=$lg(argSubGlo,7)
	.q:wardPost=""
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	.s exchangeFromArgDesc=$lg(wardPostGlo,2)
	s exchangeFromArgDate=$lg(exchangeGlo,5)
	s:exchangeFromArgDate'="" exchangeFromArgDate=$zd(exchangeFromArgDate,3)
	s exchangeToNurse=$lg(exchangeGlo,6)
	s exchangeToNurseName=""
	i exchangeToNurse'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(exchangeToNurse))
	.s exchangeToNurseName=$lg(perGlo,2)
	s exchangeToArg=$lg(exchangeGlo,7)
	s exchangeToArgDesc=""
	i exchangeToArg'="" d
	.s argSubGlo=$g(^DHCINM.Arg.MgArrangeSubD(exchangeToArg))
	.s wardPost=$lg(argSubGlo,7)
	.q:wardPost=""
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	.s exchangeToArgDesc=$lg(wardPostGlo,2)
	s exchangeToArgDate=$lg(exchangeGlo,8)
	s:exchangeToArgDate'="" exchangeToArgDate=$zd(exchangeToArgDate,3)
	s exchangeStatus=$lg(exchangeGlo,9)
	s exchangeStatusDesc=$case(exchangeStatus,"B":"驳回","Y":"提交","A":"审核",:"")
	s createDate=$lg(exchangeGlo,10)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(exchangeGlo,11)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(exchangeGlo,12)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.;s perGlo=$g(^CF.DHCINM.HR.PersonsD(auditor))
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(exchangeGlo,13)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(exchangeGlo,14)
	s:auditTime'="" auditTime=$zt(auditTime)
	s auditOpinion=$lg(exchangeGlo,15)
	s ret="ExchangeWard|"_exchangeWard_"^ExchangeWardDesc|"_exchangeWardDesc_"^ExchangeFromNurse|"_exchangeFromNurse_"^ExchangeFromNurseName|"_exchangeFromNurseName
	s ret=ret_"^ExchangeFromArg|"_exchangeFromArg_"^ExchangeFromArgDesc|"_exchangeFromArgDesc_"^ExchangeFromArgDate|"_exchangeFromArgDate_"^ExchangeToNurse|"_exchangeToNurse
	s ret=ret_"^ExchangeToNurseName|"_exchangeToNurseName_"^ExchangeToArg|"_exchangeToArg_"^ExchangeToArgDesc|"_exchangeToArgDesc_"^ExchangeToArgDate|"_exchangeToArgDate
	s ret=ret_"^ExchangeStatus|"_exchangeStatus_"^ExchangeStatusDesc|"_exchangeStatusDesc_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^Auditor|"_auditor
	s ret=ret_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion_"^rw|"_id
	q ret
}

/// Description：查询护士换班列表
/// Date:2020-06-30
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArgExchangeApp
/// Input: 病区Id^开始日期^结束日期 登录人Id 登录人角色
/// Output:护士换班列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgExchangeList","1^2020-06-01^2020-06-30",0,0)
Query FindArgExchangeList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgExchangeListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.Arg.MgArgExchangeAppD(id)) q:id=""  d
	.s exchangeGlo=^DHCINM.Arg.MgArgExchangeAppD(id)
	.s exchangeWard=$lg(exchangeGlo,2)
	.q:((ward'="")&&(ward'=exchangeWard))||((isAll'=1)&&('$d(tmpWard(exchangeWard))))
	.s exchangeFromArgDate=$lg(exchangeGlo,5)
	.s exchangeToArgDate=$lg(exchangeGlo,8)
	.s flag1=((stDate'="")&&(stDate>exchangeFromArgDate))||((endDate'="")&&(endDate<exchangeFromArgDate))
	.s flag2=((stDate'="")&&(stDate>exchangeToArgDate))||((endDate'="")&&(endDate<exchangeToArgDate))
	.q:flag1&&flag2
	.s ret=..GetExchangeApp(id)
	.d:ret'="" OutExchangeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutExchangeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgExchangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgExchangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgExchangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgExchangeListExecute ]
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

/// Description: 审核护士换班申请
/// Date: 2020-06-30
/// Creator: wangpf
/// Table:DHCINM.Arg.MgArgExChangeApp
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).AuditExchangeApp("A^^3",0)
ClassMethod AuditExchangeApp(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.Arg.MgArgExchangeApp).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.AuditOpinion=opinion
	s obj.ExchangeStatus=status
	ts
	s sc=obj.%Save()
	i (status="A")&&($$$ISOK(sc)) d
	.s tmpArrange=obj.ExchangeFromArg.ArrangeDR
	.s tmpArrangeRow=obj.ExchangeFromArg.ArgRowDR
	.s tmpArgPer=obj.ExchangeFromArg.ArgPerDR
	.s tmpArgDate=obj.ExchangeFromArg.ArgDate
	.s obj.ExchangeFromArg.ArrangeDR=obj.ExchangeToArg.ArrangeDR
	.s obj.ExchangeFromArg.ArgRowDR=obj.ExchangeToArg.ArgRowDR
	.s obj.ExchangeFromArg.ArgPerDR=obj.ExchangeToArg.ArgPerDR
	.s obj.ExchangeFromArg.ArgDate=obj.ExchangeToArg.ArgDate
	.s obj.ExchangeFromArg.ArgWishDR=""
	.s obj.ExchangeToArg.ArrangeDR=tmpArrange
	.s obj.ExchangeToArg.ArgRowDR=tmpArrangeRow
	.s obj.ExchangeToArg.ArgPerDR=tmpArgPer
	.s obj.ExchangeToArg.ArgDate=tmpArgDate
	.s obj.ExchangeToArg.ArgWishDR=""
	.s sc=obj.ExchangeFromArg.%Save()
	.s:$$$ISOK(sc) sc=obj.ExchangeToArg.%Save()
	i $$$ISOK(sc) tc 
	e  tro  q 0
	try{
		i ((obj.ExchangeStatus="A")||(obj.ExchangeStatus="B")) d
		.s ExchangeStatusDesc=$case(obj.ExchangeStatus,"A":"审核","B":"驳回") ;状态
		.s applicantId=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),3) ;创建人id
		.s applicant=""
		.s:applicantId'="" applicant=$LG($g(^CF.DHCINM.HR.PersonsD(applicantId)),2) ;创建人姓名
		.s appliDate1=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),10) ;申请日期
		.s appliDate=""
		.s:appliDate1'="" appliDate=$zd(appliDate1,3)
		.s ExchangeFromPost=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),4) ;申请班次
		.s FromPostDesc1=""
		.s:ExchangeFromPost'="" FromPostDesc1=$LG($g(^DHCINM.Arg.MgArrangeSubD(ExchangeFromPost)),7)
		.s FromPostDesc=""
		.s:FromPostDesc1'="" FromPostDesc=$LG($g(^CF.DHCINM.DB.MgArgWardPostD(FromPostDesc1)),2)
		.s ExchangeToPost=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),7)  ;换班班次
		.s ToPostDesc1=""
		.s:ExchangeToPost'="" ToPostDesc1=$LG($g(^DHCINM.Arg.MgArrangeSubD(ExchangeToPost)),7)
		.s ToPostDesc=""
		.s:ToPostDesc1'="" ToPostDesc=$LG($g(^CF.DHCINM.DB.MgArgWardPostD(ToPostDesc1)),2)
		.s ExchangeDate1=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),8) ;换班日期
		.s ExchangeDate=""
		.s:ExchangeDate1'="" ExchangeDate=$zd(ExchangeDate1,3) 
		.s ExchangePersonId=$LG($g(^DHCINM.Arg.MgArgExchangeAppD(rw)),6) ;换班对象
		.s ExchangePerson=""
		.s:ExchangePersonId'="" ExchangePerson=$LG($g(^CF.DHCINM.HR.PersonsD(ExchangePersonId)),2)
		.s applicantId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_applicantId,""))
		.s ExchangePersonId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_ExchangePersonId,""))
		.s ret="【科室事务/换班申请】 "_ExchangeStatusDesc_" "_applicant_" "_FromPostDesc_" "_appliDate_"->"_ExchangePerson_" "_ToPostDesc_" "_ExchangeDate
		.d:applicantId'="" ##class(web.INMPlatform).SaveTrackMessage(applicantId,+$H,ret,"","DHCINM.Arg.MgArgExChangeApp",rw)
		.d:ExchangePersonId'="" ##class(web.INMPlatform).SaveTrackMessage(ExchangePersonId,+$H,ret,"","DHCINM.Arg.MgArgExChangeApp",rw)
	}catch{
		}
	q 1
}

/// Description: 删除护士换班申请
/// Date: 2020-06-30
/// Creator: wangpf
/// Table:DHCINM.Arg.MgArgExchangeApp
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).DeleteExchangeApp(1)
ClassMethod DeleteExchangeApp(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.Arg.MgArgExchangeApp).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(obj.ExchangeStatus'="B") 0 ;&&(obj.ExchangeStatus'="Y")
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：查询护士排班次数列表
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期^姓名 登录人Id 登录人角色
/// Output:护士排班次数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgCountList","1^2020-06-01^2020-06-30^",0,0)
Query FindArgCountList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgCountListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate="" endDate=$o(^DHCINM.Arg.MgArrangeSubI("Date",""),-1)
	s input=$p(parr,"^",4)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s par=$o(^CT.DHCINM.Set.MgSysParamI("Code"," POSTTYPE",""))
	i par'="" d
	.k tmpType
	.s subCode="" f  s subCode=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode)) q:subCode=""  d
	..s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode,par,subId)) q:subId=""  d
	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(par,subId))
	...s tmpType($tr(subCode," ",""))=1
	
	s statusTmp(" NA")="NA",statusTmp(" ZA")="ZA",statusTmp(" HA")="HA"
	s leaveWard="" f  s leaveWard=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard)) q:leaveWard=""  d
	.q:((ward'="")&&(ward'=leaveWard))||((isAll'=1)&&('$d(tmpWard(leaveWard))))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leavePer="" f  s leavePer=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer)) q:leavePer=""  d
	..s tmpLeavePer=$tr(leavePer," ","")
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(tmpLeavePer))
	..s leavePerName=$lg(perGlo,2)
	..s leavePerId=$lg(perGlo,3)
	..q:(input'="")&&(leavePerName_leavePerId'[input)
	..s leaveStatus="" f  s leaveStatus=$o(statusTmp(leaveStatus)) q:leaveStatus=""  d
	...s leaveId="" f  s leaveId=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer,leaveStatus,leaveId)) q:leaveId=""  d
	....q:'$d(^DHCINM.Arg.MgLeaveAppD(leaveId))
	....s leaveGlo=^DHCINM.Arg.MgLeaveAppD(leaveId)
	....s leaveSource=$lg(leaveGlo,2)
	....q:(leaveSource="H")&&(leaveStatus'=" HA") // 护士长请假需护理部审核
	....s leaveStDate=$lg(leaveGlo,5)
	....s leaveEndDate=$lg(leaveGlo,7)
	....q:((stDate'="")&&(stDate>leaveEndDate))||((endDate'="")&&(endDate<leaveStDate))
	....s:(endDate'="")&&(endDate<leaveEndDate) leaveEndDate=endDate
	....s:(stDate'="")&&(stDate>leaveStDate) leaveStDate=stDate
	....s workDate=$lg(leaveGlo,29)
	....s time=leaveEndDate-leaveStDate+1
	....s time=time-$ll(workDate)
	....s leaveType=$lg(^CF.DHCINM.DB.MgArgPostD($lg(^CF.DHCINM.DB.MgArgWardPostD($lg(leaveGlo,4)),4)),24)
	....s tmp(leaveWard,leavePer,leaveType)=$g(tmp(leaveWard,leavePer,leaveType))+time
	....s tmpCount(leaveWard,leavePer)=$g(tmpCount(leaveWard,leavePer))+time
	
	s argWard="" f  s argWard=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard)) q:argWard=""  d
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(argWard))
	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer)) q:argPer=""  d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	..s argPerName=$lg(perGlo,2)
	..s argPerId=$lg(perGlo,3)
	..q:(input'="")&&(argPerName_argPerId'[input)
	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
	...q:$p(..IsPerAskLeavel3(argPer_"^"_argDate),"^",3)'=""
	...s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate,argId)) q:argId=""  d
	....q:'$d(^DHCINM.Arg.MgArrangeSubD(argId))
	....s argGlo=^DHCINM.Arg.MgArrangeSubD(argId)
	....s argParId=$lg(argGlo,2)
	....q:argParId=""
	....s argParGlo=$g(^DHCINM.Arg.MgArrangeD(argParId))
	....s argParStatus=$lg(argParGlo,7)
	....q:(argParStatus'="R")&&(argParStatus'="A")
	....s wardPostId=$lg(argGlo,7)
	....q:wardPostId=""
	....q:'$d(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	....s wardPostGlo=^CF.DHCINM.DB.MgArgWardPostD(wardPostId)
	....s argPostId=$lg(wardPostGlo,4)
	....q:'$d(^CF.DHCINM.DB.MgArgPostD(argPostId))
	....s argPostGlo=^CF.DHCINM.DB.MgArgPostD(argPostId)
	....s argType=$lg(argPostGlo,24)
	....s tmp(argWard,argPer,argType)=$g(tmp(argWard,argPer,argType))+1
	....s tmpCount(argWard,argPer)=$g(tmpCount(argWard,argPer))+1
	
	s outWard="" f  s outWard=$o(tmp(outWard)) q:outWard=""  d
	.s wardDesc=$lg(^CF.DHCINM.DB.MgWardD(outWard),4)
	.s outPer="" f  s outPer=$o(tmp(outWard,outPer)) q:outPer=""  d
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(outPer),2)
	..s perLevel=$p(##class(web.INMHRComm).GetNurseLevel(outPer,+$h),"^",2)
	..s ret="NumberNurse|"_outPer_"^NumberNurseName|"_perName_"^NumberNurseLevel|"_perLevel_"^NumberWard|"_outWard_"^NumberWardDesc|"_wardDesc
	..s outType="" f  s outType=$o(tmpType(outType)) q:outType=""  d
	...s ret=ret_"^"_outType_"|"_$fn($g(tmp(outWard,outPer,outType)),"",0)
	..s ret=ret_"^NumberTotalCount|"_$fn($g(tmpCount(outWard,outPer)),"",0)
	..d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgCountListExecute ]
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

/// Description：查询护士工时数列表
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期^姓名 登录人Id 登录人角色
/// Output:护士工时数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgHourList","1^2020-10-01^2020-11-30^",0)
Query FindArgHourList(parr As %String = "", nurseid As %String = "", outType As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgHourListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "", outType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s CountUnit=$lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),3)
	s argParamGlo=$g(^CT.DHCINM.Set.MgArgParamSetD(1))
	s nStTime=$lg(argParamGlo,5)
	s nEndTime=$lg(argParamGlo,6)
	i (nStTime="")||(nEndTime="") s nStTime=64800,nEndTime=28800
	i nEndTime<nStTime s nTimeList=$lb(nStTime_"^86400","0^"_nEndTime)
	e  s nTimeList=$lb(nStTime_"^"_nEndTime)
	
	s argWard="" f  s argWard=$o(^CF.DHCINM.DB.MgWardD(argWard)) q:argWard=""  d
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(argWard)
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.s wardTotal=0,wardDay=0,wardNight=0
	.s argWardDesc=$lg(wardGlo,4)
	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer)) q:argPer=""  d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	..s argPerName=$lg(perGlo,2)
	..s argPerId=$lg(perGlo,3)
	..q:(input'="")&&(argPerName_argPerId'[input)
	..s argPerLevel=$p(##class(web.INMHRComm).GetNurseLevel(argPer,+$h),"^",2)
	..s dayTotalTime=0,nightTotalTime=0,flag=0
	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
	...s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate,argId)) q:argId=""  d
	....q:'$d(^DHCINM.Arg.MgArrangeSubD(argId))
	....s flag=1
	....s argGlo=^DHCINM.Arg.MgArrangeSubD(argId)
	....s argParId=$lg(argGlo,2)
	....q:argParId=""
	....s argParGlo=$g(^DHCINM.Arg.MgArrangeD(argParId))
	....s argParStatus=$lg(argParGlo,7)
	....q:(argParStatus'="R")&&(argParStatus'="A")
	....s time=0,counter=0,argTimeList=$lb()
	....s sttime1=$lg(argGlo,8),endtime1=$lg(argGlo,9)
	....s sttime2=$lg(argGlo,10),endtime2=$lg(argGlo,11)
	....s sttime3=$lg(argGlo,12),endtime3=$lg(argGlo,13)
	....s sttime1=$replace(sttime1,"次日",""),endtime1=$replace(endtime1,"次日",""),sttime2=$replace(sttime2,"次日",""),endtime2=$replace(endtime2,"次日","")
	....s sttime3=$replace(sttime3,"次日",""),endtime3=$replace(endtime3,"次日","")
	....i (sttime1'="")&&(endtime1'="") d
	.....s sttime1=$zth(sttime1,2),endtime1=$zth(endtime1,2)
	.....i endtime1<sttime1 s counter=counter+1,$list(argTimeList,counter)=sttime1_"^86400",counter=counter+1,$list(argTimeList,counter)="0^"_endtime1
	.....e  s counter=counter+1,$list(argTimeList,counter)=sttime1_"^"_endtime1
	....i (sttime2'="")&&(endtime2'="") d
	.....s sttime2=$zth(sttime2,2),endtime2=$zth(endtime2,2)
	.....i endtime2<sttime2 s counter=counter+1,$list(argTimeList,counter)=sttime2_"^86400",counter=counter+1,$list(argTimeList,counter)="0^"_endtime2
	.....e  s counter=counter+1,$list(argTimeList,counter)=sttime2_"^"_endtime2
	....i (sttime3'="")&&(endtime3'="") d
	.....s sttime3=$zth(sttime3,2),endtime3=$zth(endtime3,2)
	.....i endtime3<sttime3 s counter=counter+1,$list(argTimeList,counter)=sttime3_"^86400",counter=counter+1,$list(argTimeList,counter)="0^"_endtime3
	.....e  s counter=counter+1,$list(argTimeList,counter)=sttime3_"^"_endtime3
	....f j=1:1:counter d
	.....s tArgStTime=$p($lg(argTimeList,j),"^")
	.....s tArgEndTime=$p($lg(argTimeList,j),"^",2)
	.....s argTotalTime=tArgEndTime-tArgStTime
	.....s TNTime=0
	.....f i=1:1:$ll(nTimeList) d
	......s tNStTime=$p($lg(nTimeList,i),"^")
	......s tNEndTime=$p($lg(nTimeList,i),"^",2)
	......s DTime=0,NTime=0
	......i tArgEndTime<=tNStTime s DTime=0
	......e  i tArgStTime>=tNEndTime s DTime=0
	......e  d
	.......i tNStTime<tArgStTime s tSt=tArgStTime
	.......e  s tSt=tNStTime
	.......i tNEndTime<tArgEndTime s tEnd=tNEndTime
	.......e  s tEnd=tArgEndTime
	.......s NTime=NTime+(tEnd-tSt)
	.......s DTime=0
	......s nightTotalTime=nightTotalTime+NTime
	......s TNTime=TNTime+NTime
	.....s dayTotalTime=dayTotalTime+argTotalTime-TNTime
	..q:flag'=1
	..s totalTime=dayTotalTime+nightTotalTime
	..s wardTotal=wardTotal+totalTime
	..s wardDay=wardDay+dayTotalTime
	..s wardNight=wardNight+nightTotalTime
	..q:outType=1
	..d Convert(.totalTime)
	..d Convert(.dayTotalTime)
	..d Convert(.nightTotalTime)
	..s ret="HourNurse|"_argPer_"^HourNurseName|"_argPerName_"^HourNurseLevel|"_argPerLevel_"^HourWard|"_argWard_"^HourWardDesc|"_argWardDesc
	..s ret=ret_"^HourDayTime|"_dayTotalTime_"^HourNightTime|"_nightTotalTime_"^HourTotalTime|"_totalTime
	..d OutHourList
	.q:outType'=1
	.d Convert(.wardTotal)
	.d Convert(.wardDay)
	.d Convert(.wardNight)
	.s ret="HourWard|"_argWard_"^HourWardDesc|"_argWardDesc_"^HourDayTime|"_wardDay_"^HourNightTime|"_wardNight_"^HourTotalTime|"_wardTotal
	.d OutHourList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHourList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
Convert(min)
	i CountUnit="H" d
	.s min=$fn(min/3600,"",2)_"小时"
	e  d
	.i min>=3600 s min=min\3600_"小时"_$fn(min#3600/60,"",0)_"分钟"
	.e  s min=$fn(min/60,"",0)_"分钟"
	q min
}

ClassMethod FindArgHourListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgHourListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgHourListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgHourListExecute ]
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

/// Description：查询护士改/换班数列表
/// Date:2020-06-30
/// Creator:wangpf
/// Table:DHCINM.Arg.MgChangeApp DHCINM.Arg.MgExchangeApp
/// Input: 病区^开始日期^结束日期^姓名 登录人Id 登录人角色
/// Output:护士改/换班数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindChangeCountList","1^2020-06-01^2020-06-30^",0,0)
Query FindChangeCountList(parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindChangeCountListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp,tmpWardOut,tmpAll
	s appId="" f  s appId=$o(^DHCINM.Arg.MgArgChangeAppI("Status"," A",appId)) q:appId=""  d
	.q:'$d(^DHCINM.Arg.MgArgChangeAppD(appId))
	.s appGlo=^DHCINM.Arg.MgArgChangeAppD(appId)
	.s changeWard=$lg(appGlo,2)
	.q:((ward'="")&&(ward'=changeWard))||((isAll'=1)&&('$d(tmpAll(changeWard))))
	.s changeDate=$lg(appGlo,5)
	.q:((stDate'="")&&(changeDate<stDate))||((endDate'="")&&(endDate<changeDate))
	.s per=$lg(appGlo,3)
	.q:per=""
	.q:(outPerId'="")&&(outPerId'=per)
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.s perGlo=^CF.DHCINM.HR.PersonsD(per)
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.q:(input'="")&&($zcvt($tr(perName_perID," ",""),"U")'[$zcvt($tr(input," ",""),"U"))
	.s fromPost=$lg(appGlo,6)
	.s fromPostDesc=""
	.i (fromPost'="")&&($d(^CF.DHCINM.DB.MgArgWardPostD(fromPost))) d
	..s postGlo=^CF.DHCINM.DB.MgArgWardPostD(fromPost)
	..s fromPostDesc=$lg(postGlo,2)
	.s toPost=$lg(appGlo,7)
	.s toPostDesc=""
	.i (toPost'="")&&($d(^CF.DHCINM.DB.MgArgWardPostD(toPost))) d
	..s postGlo=^CF.DHCINM.DB.MgArgWardPostD(toPost)
	..s toPostDesc=$lg(postGlo,2)
	.s tmp(per,"change")=$g(tmp(per,"change"))+1
	.s tmp(per,changeDate,"change",appId)=fromPostDesc_" -> "_toPostDesc
	.s tmpWardOut(changeWard,"change")=$g(tmpWardOut(changeWard,"change"))+1
	.s tmpAll("change")=$g(tmpAll("change"))+1
	
	s appId="" f  s appId=$o(^DHCINM.Arg.MgArgExchangeAppI("Status"," A",appId)) q:appId=""  d
	.q:'$d(^DHCINM.Arg.MgArgExchangeAppD(appId))
	.s appGlo=^DHCINM.Arg.MgArgExchangeAppD(appId)
	.s exchangeWard=$lg(appGlo,2)
	.q:((ward'="")&&(ward'=exchangeWard))||((isAll'=1)&&('$d(tmpAll(exchangeWard))))
	.s fromArg=$lg(appGlo,4)
	.s fromArgDesc=""
	.i (fromArg'="")&&($d(^DHCINM.Arg.MgArrangeSubD(fromArg))) d
	..s argGlo=^DHCINM.Arg.MgArrangeSubD(fromArg)
	..s postId=$lg(argGlo,7)
	..q:postId=""
	..q:'$d(^CF.DHCINM.DB.MgArgWardPostD(postId))
	..s postGlo=^CF.DHCINM.DB.MgArgWardPostD(postId)
	..s fromArgDesc=$lg(postGlo,2)
	.s toArg=$lg(appGlo,7)
	.s toArgDesc=""
	.i (toArg'="")&&($d(^DHCINM.Arg.MgArrangeSubD(toArg))) d
	..s argGlo=^DHCINM.Arg.MgArrangeSubD(toArg)
	..s postId=$lg(argGlo,7)
	..q:postId=""
	..q:'$d(^CF.DHCINM.DB.MgArgWardPostD(postId))
	..s postGlo=^CF.DHCINM.DB.MgArgWardPostD(postId)
	..s toArgDesc=$lg(postGlo,2)
	.s per=$lg(appGlo,3)
	.s perName="",perID=""
	.i (per'="")&&($d(^CF.DHCINM.HR.PersonsD(per))) d
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s perName=$lg(perGlo,2)
	..s perID=$lg(perGlo,3)
	.s flag1=(outPerId'="")&&(outPerId'=per)
	.s:'flag1 flag1=(input'="")&&($zcvt($tr(perName_perID," ",""),"U")'[$zcvt($tr(input," ",""),"U"))
	.s fromDate=$lg(appGlo,5)
	.s:'flag1 flag1=((stDate'="")&&(fromDate<stDate))||((endDate'="")&&(endDate<fromDate))
	.i 'flag1 d
	..s tmp(per,"exchange")=$g(tmp(per,"exchange"))+1
	..s tmp(per,fromDate,"exchange",appId)=fromArgDesc_" -> "_toArgDesc
	.s per=$lg(appGlo,6)
	.s perName="",perID=""
	.i (per'="")&&($d(^CF.DHCINM.HR.PersonsD(per))) d
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s perName=$lg(perGlo,2)
	..s perID=$lg(perGlo,3)
	.s flag2=(outPerId'="")&&(outPerId'=per)
	.s:'flag2 flag2=(input'="")&&($zcvt($tr(perName_perID," ",""),"U")'[$zcvt($tr(input," ",""),"U"))
	.s toDate=$lg(appGlo,8)
	.s flag2=((stDate'="")&&(toDate<stDate))||((endDate'="")&&(endDate<toDate))
	.i 'flag2 d
	..s tmp(per,"exchange")=$g(tmp(per,"exchange"))+1
	..s tmp(per,toDate,"exchange",appId)=toArgDesc_" -> "_fromArgDesc
	.s:('flag1)||('flag2) tmpWardOut(exchangeWard,"exchange")=$g(tmpWardOut(exchangeWard,"exchange"))+1,tmpAll("exchange")=$g(tmpAll("exchange"))+1
	
	i outType=1 d
	.s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	..q:((ward'="")&&(ward'=id))||((isAll'=1)&&('$d(tmpWard(id))))
	..s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	..s wardStDate=$lg(wardGlo,11)
	..s wardEndDate=$lg(wardGlo,12)
	..q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	..s wardDesc=$lg(wardGlo,4)
	..s ret="ChangeWard|"_id_"^ChangeWardDesc|"_wardDesc_"^ChangeCount|"_+$g(tmpWardOut(id,"change"))_"^ExchangeCount|"_+$g(tmpWardOut(id,"exchange"))
	..d OutCountList
	e  i outType=2 d
	.s ret="ChangeCount|"_+$g(tmpAll("change"))_"^ExchangeCount|"_+$g(tmpAll("exchange"))
	.d OutCountList
	e  d
	.s per="" f  s per=$o(tmp(per)) q:per=""  d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	..s perWard=$lg(perGlo,10)
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(perWard))
	..s wardDesc=$lg(wardGlo,4)
	..s perName=$lg(perGlo,2)
	..s perID=$lg(perGlo,3)
	..s perLevel=$p(##class(web.INMHRComm).GetNurseLevel(per,+$h),"^",2)
	..s baseRet="ChangeNurse|"_per_"^ChangeNurseName|"_perName_"^ChangeNurseLevel|"_perLevel_"^ChangeWard|"_perWard_"^ChangeWardDesc|"_wardDesc
	..i outType=3 d
	...s outDate="" f  s outDate=$o(tmp(per,outDate)) q:outDate=""  d
	....s type="" f  s type=$o(tmp(per,outDate,type)) q:type=""  d
	.....s appId="" f  s appId=$o(tmp(per,outDate,type,appId)) q:appId=""  d
	......s ret=baseRet
	......s ret=ret_"^Date|"_$zd(outDate,3)_"^Type|"_type_"^TypeDesc|"_$case(type,"change":"换班","exchange":"改班",:"")_"^Desc|"_tmp(per,outDate,type,appId)
	......d OutCountList
	..e  d
	...s changeCount=$fn($g(tmp(per,"change")),"",0)
	...s exchangeCount=$fn($g(tmp(per,"exchange")),"",0)
	...s totalCount=changeCount+exchangeCount
	...s ret=baseRet
	...s ret=ret_"^ChangeTotalCount|"_totalCount_"^ChangeCount|"_changeCount_"^ExchangeCount|"_exchangeCount
	...d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindChangeCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChangeCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindChangeCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChangeCountListExecute ]
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

/// Description: 保存初始化积假
/// Date: 2020-08-04
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgHour
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).SaveArgHour("",0)
ClassMethod SaveArgHour(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") "未获取有效数据,请刷新界面"
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "无用户信息,请刷新界面"
	
	s per=$p(parr,"^")
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) "未获取有效信息,请刷新界面"
	s date=$p(parr,"^",2)
	s:date'="" date=$zdh(date,3)
	s hour=$p(parr,"^",3)
	s rw=$p(parr,"^",4)
	
	s id=$o(^DHCINM.Arg.MgArgHourI("Per",per,date,""))
	q:(id'="")&&(id'=rw) "同一天不可重复添加"
	
	i rw="" d
	.s obj=##class(DHCINM.Arg.MgArgHour).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Arg.MgArgHour).%OpenId(rw)
	q:'$IsObject(obj) "保存失败"
	d obj.ArgPerSetObjectId(per)
	s obj.ArgDate=date
	s obj.ArgHour=hour
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1
	}else{
		q "保存失败"	
	}
}

/// Description: 获取初始化积假
/// Date: 2020-08-04
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgHour
/// Input: id
/// Output: 初始化积假
/// Other: w ##class(web.INMArgComm).GetArgHour(1)
ClassMethod GetArgHour(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgArgHourD(id))) ""
	
	s hourGlo=^DHCINM.Arg.MgArgHourD(id)
	
	s argPer=$lg(hourGlo,2)
	s argPerName=""
	i argPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	.s argPerName=$lg(perGlo,2)
	s argDate=$lg(hourGlo,3)
	s:argDate'="" argDate=$zd(argDate,3)
	s argHour=$lg(hourGlo,4)
	s argHour=$fn(argHour,"",1)
	s creator=$lg(hourGlo,5)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(hourGlo,6)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(hourGlo,7)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="ArgPer|"_argPer_"^ArgPerName|"_argPerName_"^ArgDate|"_argDate_"^ArgHour|"_argHour
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取初始化积假列表
/// Date:2020-08-04
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArgHour
/// Input: 病区Id^姓名^类型^认证单位^状态 登录人Id
/// Output:初始化积假列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindHourList","",0)
Query FindHourList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHourListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.Arg.MgArgHourD(id)) q:id=""  d
	.s hourGlo=^DHCINM.Arg.MgArgHourD(id)
	.s argPer=$lg(hourGlo,2)
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.q:(parr'="")&&(perName_perID'[parr)
	.s perCurWard=$lg(perGlo,10)
	.q:(isAll'=1)&&('$d(tmpWard(perCurWard)))
	.s ret=..GetArgHour(id)
	.d:ret'="" OutHourList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHourList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHourListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHourListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHourListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHourListExecute ]
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

/// Description: 删除初始化积假
/// Date: 2020-08-04
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArgHour
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteArgHour(1)
ClassMethod DeleteArgHour(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Arg.MgArgHour).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Other: w ##class(web.INMArgComm).SaveWardPostRatio("2^145^1^3",0)
ClassMethod SaveWardPostRatio(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") "未获取有效数据,请刷新重试"
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "未获取有效数据,请刷新重试"
	
	s ward=$p(parr,"^")
	q:(ward="")&&('$d(^CF.DHCINM.DB.MgWardD(ward))) "未获取有效数据,请刷新重试"
	s post=$p(parr,"^",2)
	q:(post="")&&('$d(^CF.DHCINM.DB.MgArgWardPostD(post))) "未获取有效数据,请刷新重试"
	s number=$p(parr,"^",3)
	q:number<=1 "数量应大于1"
	s rw=$p(parr,"^",4)
	s isExistFlag=0
	s oldRW="" f  s oldRW=$O(^DHCINM.Arg.MgWardPostRatioI("Ward",ward,oldRW)) q:((oldRW="")||(isExistFlag'=0))  d
	.s oldObj=##class(DHCINM.Arg.MgWardPostRatio).%OpenId(oldRW)
	.q:'$IsObject(oldObj)
	.q:'$IsObject(oldObj.RatioPost)
	.i ((oldObj.RatioPost.%Id()=post)&&(rw'=oldRW))  d
	..s isExistFlag=1
	q:isExistFlag'=0 "已存在此班次,不可重复添加"
	i rw="" d
	.s obj=##class(DHCINM.Arg.MgWardPostRatio).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Arg.MgWardPostRatio).%OpenId(rw)
	q:'$IsObject(obj) "未获取有效数据,请刷新重试"
	d obj.RatioWardSetObjectId(ward)
	d obj.RatioPostSetObjectId(post)
	s obj.RatioNumber=number
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Other: w ##class(web.INMArgComm).GetWardPostRatio(1)
ClassMethod GetWardPostRatio(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgWardPostRatioD(id))) ""
	
	s ratioGlo=^DHCINM.Arg.MgWardPostRatioD(id)
	s ratioWard=$lg(ratioGlo,2)
	s ratioWardDesc=""
	i ratioWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ratioWard))
	.s ratioWardDesc=$lg(wardGlo,4)
	s ratioPost=$lg(ratioGlo,3)
	s ratioPostDesc=""
	i ratioPost'="" d
	.s postGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(ratioPost))
	.s ratioPostDesc=$lg(postGlo,2)
	s ratioNumber=$lg(ratioGlo,4)
	s creator=$lg(ratioGlo,5)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(ratioGlo,6)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(ratioGlo,7)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="RatioWard|"_ratioWard_"^RatioWardDesc|"_ratioWardDesc_"^RatioPost|"_ratioPost_"^RatioPostDesc|"_ratioPostDesc_"^RatioNumber|"_ratioNumber
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindPostRtoList","^",0)
Query FindPostRtoList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPostRtoListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s ward=parr
	
	s wardId="" f  s wardId=$o(^DHCINM.Arg.MgWardPostRatioI("Ward",wardId)) q:wardId=""  d
	.q:((ward'="")&&(ward'=wardId))||((isAll'=1)&&('$d(tmpWard(wardId))))
	.s id="" f  s id=$o(^DHCINM.Arg.MgWardPostRatioI("Ward",wardId,id)) q:id=""  d
	..q:'$d(^DHCINM.Arg.MgWardPostRatioD(id))
	..s ret=..GetWardPostRatio(id)
	..d:ret'="" OutRatioList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRatioList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostRtoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostRtoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPostRtoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostRtoListExecute ]
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

/// Other: w ##class(web.INMArgComm).DeleteWardPostRatio(1)
ClassMethod DeleteWardPostRatio(id As %String = "") As %String
{
	q:id="" 0
	q:'$d(^DHCINM.Arg.MgWardPostRatioD(id)) 1
	
	s sc=##class(DHCINM.Arg.MgWardPostRatio).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Other: w ##class(web.INMArgComm).CheckWardPostRatio(2007)
ClassMethod CheckWardPostRatio(id As %String = "") As %String
{
	q:id="" 1
	q:'$d(^DHCINM.Arg.MgArrangeD(id)) 1
	
	s argGlo=^DHCINM.Arg.MgArrangeD(id)
	s ward=$lg(argGlo,3)
	q:'$d(^DHCINM.Arg.MgWardPostRatioI("Ward",ward)) 1
	s stDate=$lg(argGlo,4)
	s endDate=$lg(argGlo,5)
	
	k tmpArg
	s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("Arg",id,subId)) q:subId=""  d
	.q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	.s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	.s subDate=$lg(subGlo,6)
	.s subWardPost=$lg(subGlo,7)
	.q:subWardPost=""
	.s tmpArg(subDate,subWardPost)=$g(tmpArg(subDate,subWardPost))+1
	
	k tmpInvalid
	s flag=0
	s ratioId="" f  s ratioId=$o(^DHCINM.Arg.MgWardPostRatioI("Ward",ward,ratioId)) q:ratioId=""  d
	.q:'$d(^DHCINM.Arg.MgWardPostRatioD(ratioId))
	.s ratioGlo=^DHCINM.Arg.MgWardPostRatioD(ratioId)
	.s ratioPost=$lg(ratioGlo,3)
	.s ratioNumber=$lg(ratioGlo,4)
	.q:(ratioPost="")||(ratioNumber="")
	.f tDate=stDate:1:endDate d
	..i $g(tmpArg(tDate,ratioPost))<ratioNumber s tmpInvalid(tDate,ratioPost)=1,flag=1
	i flag'=0 {
		s postDescStr="",index=0
		s tDate="" f  s tDate=$o(tmpInvalid(tDate)) q:tDate=""  d
		.s postDescStr=postDescStr_$case(index,0:"",:",")_$zd(tDate,3)_":"
		.s index=index+1,counter=0
		.s post="" f  s post=$o(tmpInvalid(tDate,post)) q:post=""  d
		..s postGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(post))
		..s postDesc=$lg(postGlo,2)
		..s postDescStr=postDescStr_$case(counter,0:"",:"、")_postDesc
		..s counter=counter+1
		q postDescStr_"与设置的日常班次配置不符合，请检查！"
	}else {
		q 1
	}
}

/// creator: gyg
/// createdate: 2020-12-11
/// description: 检查本周班次
/// table: DHCINM.Arg.MgArrangeSub
/// input: 
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgCheckList","49",0)
Query FindArgCheckList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgCheckListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s ^TMP("FindArgLogList")=parr_"%"_nurseid
	s repid=$I(^CacheTemp)
	s ind=1
	s sargid=$p(parr,"^",1)
	i sargid="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s ret=""
	k tmpWard
	s tmpWard=""
	;s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("Arg",sargid,argid)) q:argid=""  d
	.s argObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(argObj)
	.s argDate=argObj.ArgDate 
	.q:'$IsObject(argObj.ArgPostDR)
	.q:'$IsObject(argObj.ArgPostDR.PostDR)
	.s argPost=argObj.ArgPostDR.PostDR.%Id()
	.s weekday=$SYSTEM.SQL.DAYOFWEEK(argDate)
	.s tmpWard(argPost,weekday)=$g(tmpWard(argPost,weekday))+1
	;取数据
	s postDR="" f  s postDR=$O(tmpWard(postDR)) q:postDR=""  d
	.s postObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(postDR)
	.q:'$IsObject(postObj)
	.s PostDesc=postObj.PostDesc
	.s ret="PostDesc|"_PostDesc
	.s dayweek="" f  s dayweek=$O(tmpWard(postDR,dayweek)) q:dayweek=""  d
	..s count=$g(tmpWard(postDR,dayweek))
	..s ret=ret_"^"_dayweek_"|"_count
	.d OutArgLogData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgLogData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgCheckListExecute ]
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

/// Creator:jyc
/// CreateDate:2020-12-25
/// Description:获取夜班费用明细
/// Table:
/// Input:
/// Output:
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindNightDetail","8","2020-05-01^2020-11-30")
Query FindNightDetail(ward As %String, month As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNightDetailExecute(ByRef qHandle As %Binary, ward As %String, month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindNightDetail")=ward_"%"_month
	;s stDate=$zdh((month_"-01"),3)
	;s year=$p(month,"-",1)
	;s mon=$p(month,"-",2)
	;i mon<12 s mon=mon+1
	;e  s mon=1,year=year+1
	
	;s endDate=$zdh(year_"-"_mon_"-01",3)-1
	s stDate=$zdh($P(month,"^",1),3)
	s endDate=$zdh($P(month,"^",2),3)
	s tmp=""
	
	s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",ward,date)) q:date=""  d
	.q:((date<stDate)!(date>endDate))
	.s RowID="" f  s RowID=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",ward,date,RowID)) q:RowID=""  d
	..s ArgObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(RowID)
	..q:'$IsObject(ArgObj)
	..q:ArgObj.ArrangeDR.ArgStatus'="R" //如果没有提交排班则不计算
	..q:ArgObj.ArgPostDR.PostDR.PostCategory'="N"
	..s TypeStore=##class(web.INMArgComm).GetNurseLevel(ArgObj.ArgDate,ArgObj.ArgPerDR.%Id())
	..s PerType=$p(TypeStore,"^",4) //获取人员类型
	..q:((PerType="P")!(PerType="S")) //获取人员类型
	..q:'$IsObject(ArgObj.ArgPostDR)
	..s PostType=ArgObj.ArgPostDR.PostDR.%Id()
	..//根据病区 人员类型 岗位类型 获取夜班单价
	..s NightPrice=..GetSysNightFactor(ward,PerType,PostType)
	..s num=1
	..s num=$case(ArgObj.ArgHolidayTime,"A":0.5,"P":0.5,"H":1,:1)
	..s tmp(ward,ArgObj.ArgPerDR.%Id(),ArgObj.ArgPostDR.PostDR.%Id())=$g(tmp(ward,ArgObj.ArgPerDR.%Id(),ArgObj.ArgPostDR.PostDR.%Id()))+num,tmp(ward,ArgObj.ArgPerDR.%Id(),ArgObj.ArgPostDR.PostDR.%Id(),"Money")=$g(tmp(ward,ArgObj.ArgPerDR.%Id(),ArgObj.ArgPostDR.PostDR.%Id(),"Money"))+(NightPrice*num)
	..s tmp(ward,ArgObj.ArgPerDR.%Id(),"Subtotal")=$g(tmp(ward,ArgObj.ArgPerDR.%Id(),"Subtotal"))+(NightPrice*num) 
	
	s TmpWard="" f  s TmpWard=$o(tmp(TmpWard)) q:TmpWard=""  d
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(TmpWard)
	.s WardDesc=wardObj.WardDesc
	.s TmpNur="" f  s TmpNur=$o(tmp(TmpWard,TmpNur)) q:TmpNur=""  d
	..s PerObj=##class(CF.DHCINM.HR.Persons).%OpenId(TmpNur)
	..q:'$IsObject(PerObj)
	..s NurseName=PerObj.PerName
	..;s NurseHire=..GetNurseHighHire(TmpNur)
	..s Subtotal=$g(tmp(TmpWard,TmpNur,"Subtotal"))
	..s ret="PerID|"_TmpNur_"^PerName|"_NurseName_"^PerId|"_PerObj.PerID_"^Subtotal|"_Subtotal_"^WardDesc|"_WardDesc
	..s TmpPost="" f  s TmpPost=$o(tmp(TmpWard,TmpNur,TmpPost)) q:TmpPost=""  d
	...q:TmpPost="Subtotal"
	...s ret=ret_"^Post"_TmpPost_"|"_tmp(TmpWard,TmpNur,TmpPost)_"(￥"_$G(tmp(TmpWard,TmpNur,TmpPost,"Money"))_")"
	..do OutputNightDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNightDetail
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightDetailExecute ]
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

ClassMethod FindNightDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:jyc
/// CreateDate:2020-11-18
/// Description:获取病区的夜班费用
/// Table:
/// Input:
/// Output: w ##class(web.INMArgComm).GetSysNightFactor("8","N","16")
/// Return:费用=系数*单价
ClassMethod GetSysNightFactor(ward As %String = "", type As %String, post As %String) As %String
{
	s ^TMP("GetSysNightFactor")=ward_"%"_type_"%"_post
	s price=0
	s rw=$o(^CF.DHCINM.Set.NightFeeFactorI("flag"," "_type," "_ward," "_post,""))
	q:rw="" price
	s obj=##class(CF.DHCINM.Set.NightFeeFactor).%OpenId(rw)
	q:'$IsObject(obj)
	s price=$fn((obj.Factor*obj.Price),"",2)

	q price
}

/// Creator:jyc
/// Description:夜班费统计
/// Date:2020-12-25
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindNightFee","96","2020-12-01^2020-12-30","0","0")
Query FindNightFee(ward As %String = "", month As %String = "", nurseId As %String = "", outType As %String = "", outPerId As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNightFeeExecute(ByRef qHandle As %Binary, ward As %String = "", month As %String = "", nurseId As %String = "", outType As %String = "", outPerId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseId,.tmpWard)
	
	s stDate=$p(month,"^",1)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(month,"^",2)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmp,tmpPer
	s Ward="" f  s Ward=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",Ward)) q:Ward=""  d
	.q:((ward'="")&&(ward'=Ward))||((isAll'=1)&&('$d(tmpWard(Ward))))
	.s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",Ward,date)) q:date=""  d
	..q:(date<stDate)||((endDate'="")&&(date>endDate))
	..s RowID="" f  s RowID=$o(^DHCINM.Arg.MgArrangeSubI("WardDate",Ward,date,RowID)) q:RowID=""  d
	...s ArgObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(RowID)
	...q:'$IsObject(ArgObj)
	...q:ArgObj.ArrangeDR.ArgStatus'="R" //如果没有提交排班则不计算
	...q:(ArgObj.ArgPostDR.PostDR.PostCategory'="N")&&(ArgObj.ArgPostDR.PostDR.PostDesc'["加班费")
	...q:(outPerId'="")&&(outPerId'=ArgObj.ArgPerDR.%Id())
	...//获取当天该护士的类型
	...s TypeStore=##class(web.INMArgComm).GetNurseLevel(date,ArgObj.ArgPerDR.%Id())
	...s PerType=$p(TypeStore,"^",4) //获取人员类型
	...q:((PerType="P")!(PerType="S"))
	...s PostType=ArgObj.ArgPostDR.PostDR.%Id()
	...//根据病区 人员类型 岗位类型 获取夜班单价
	...s NightPrice=..GetSysNightFactor(Ward,PerType,PostType)
	...;s NightPrice=$p(NightFactor,"^",2) //夜班单价
	...s num=1
	...s num=$case(ArgObj.ArgHolidayTime,"A":0.5,"P":0.5,"H":1,:1)
	...s tmp(Ward,"Post"_ArgObj.ArgPostDR.PostDR.%Id())=$G(tmp(Ward,"Post"_ArgObj.ArgPostDR.PostDR.%Id()))+num
	...s tmp(Ward,"Post"_ArgObj.ArgPostDR.PostDR.%Id(),"Money")=$G(tmp(Ward,"Post"_ArgObj.ArgPostDR.PostDR.%Id(),"Money"))+(NightPrice*num)
	...s tmp(Ward,"Subtotal")=$G(tmp(Ward,"Subtotal"))+(NightPrice*num)
	...s argPer=ArgObj.ArgPerDR.%Id()
	...s:'$d(tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id())) tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id(),"Desc")=ArgObj.ArgPostDR.PostDR.PostDesc
	...s tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id())=$G(tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id()))+num
	...s tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id(),"Money")=$G(tmpPer(argPer,"Post"_ArgObj.ArgPostDR.PostDR.%Id(),"Money"))+(NightPrice*num)
	...s tmpPer(argPer,"Subtotal")=$G(tmpPer(argPer,"Subtotal"))+(NightPrice*num)
	
	s ret=""
	i outType=1 d
	.s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	..q:((ward'="")&&(ward'=id))||((isAll'=1)&&('$d(tmpWard(id))))
	..s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	..s wardStDate=$lg(wardGlo,11)
	..s wardEndDate=$lg(wardGlo,12)
	..q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	..s wardDesc=$lg(wardGlo,4)
	..s ret="WardCode|"_id_"^WardDesc|"_wardDesc_"^Subtotal|"_$G(tmp(id,"Subtotal"))
	..s postID="" f  s postID=$O(tmp(id,postID)) q:postID=""   d
	...s ret=ret_"^"_postID_"|"_tmp(id,postID)_"(￥"_$G(tmp(id,postID,"Money"))_")"
	..d OutputNightFee
	e  i outType=2 d
	.s argPer="" f  s argPer=$o(tmpPer(argPer)) q:argPer=""  d
	..s ret="Per|"_argPer_"^PerName|"_$lg($g(^CF.DHCINM.HR.PersonsD(argPer)),2)_"^Subtotal|"_$G(tmpPer(argPer,"Subtotal"))
	..s postID="" f  s postID=$O(tmpPer(argPer,postID)) q:postID=""   d
	...s ret=ret_"^"_postID_"|"_tmpPer(argPer,postID)_"(￥"_$G(tmpPer(argPer,postID,"Money"))_")"
	..d OutputNightFee
	e  i outType=3 d
	.s argPer="" f  s argPer=$o(tmpPer(argPer)) q:argPer=""  d
	..s baseRet="Per|"_argPer_"^PerName|"_$lg($g(^CF.DHCINM.HR.PersonsD(argPer)),2)
	..s postID="" f  s postID=$O(tmpPer(argPer,postID)) q:postID=""   d
	...q:postID="Subtotal"
	...s ret=baseRet_"^Desc|"_tmpPer(argPer,postID)_"(￥"_$G(tmpPer(argPer,postID,"Money"))_")"
	...s ret=ret_"^Post|"_$replace(postID,"Post","")_"^PostDesc|"_tmpPer(argPer,postID,"Desc")_"^PostCount|"_tmpPer(argPer,postID)
	...s ret=ret_"^PostTotalMoney|"_tmpPer(argPer,postID,"Money")
	...d OutputNightFee
	e  d
	.s TmpWard="" f  s TmpWard=$o(tmp(TmpWard)) q:TmpWard=""  d
	..s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(TmpWard)
	..q:'$IsObject(WardObj)
	..s WardDesc=WardObj.WardDesc
	..s ret="WardCode|"_TmpWard_"^WardDesc|"_WardDesc_"^Subtotal|"_$G(tmp(TmpWard,"Subtotal"))
	..s postID="" f  s postID=$O(tmp(TmpWard,postID)) q:postID=""   d
	...s ret=ret_"^"_postID_"|"_tmp(TmpWard,postID)_"(￥"_$G(tmp(TmpWard,postID,"Money"))_")"
	..do OutputNightFee
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNightFee
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightFeeExecute ]
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

ClassMethod FindNightFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: 
/// createdate: 2021-01-09
/// description: 排班明细--自带颜色--仅显示使用
/// table: DHCINM.Arg.MgArrangeSub
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArrangeSubColorList","78^2021-01-18^2021-01-24","",0)
Query FindArrangeSubColorList(parr As %String = "", input As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArrangeSubColorListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s starttime= $p($H,",",2)
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i (ward="")!(stdate="")!(enddate="")!(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tmpHoliday="",tmpWorkDay=""
	s yearSt=$p($zd(stdate,3),"-",1)
	s yearEnd=$p($zd(enddate,3),"-",1)
	s sc=..setHolidayTmp(yearSt,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearSt,.tmpWorkDay,1)
	s sc=..setHolidayTmp(yearEnd,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearEnd,.tmpWorkDay,1)
	
	
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s row=1
	s PerSort=1
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s GrpDesc=""
	...s grpobj=""
	...i grptyp="G" d //分组行数据
	....i (+grp=0)||($d(^DHCINM.Arg.MgNurGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgNurGroup).%OpenId(grp)
	.....s bedCodes=""
	.....f i=1:1:grpobj.GroupResBeds.Count() d
	......s bedId=grpobj.GroupResBeds.GetAt(i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"__",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCINM.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(grp)
	.....s bedCodes=""
	.....f i=1:1:grpobj.GroupResBeds.Count() d
	......s bedId=grpobj.GroupResBeds.GetAt(i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"__",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...//护士行数据信息
	...s GrpSort=0
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s GrpSort=GrpSort+1
	.....s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	.....q:'$IsObject(perobj)
	.....s nurInfo=..GetNurseLevel(stdate,perdr) //珠海改进方法 2019-01-04 gzj新增
	.....s roledesc=""
	.....s roledesc=$p(nurInfo,"^",2)
	.....;s:$zcvt(perobj.PerTypeDR,"U")="P" roledesc="$" //珠海改进方法 2019-01-04 gzj注释
	.....;s:$zcvt(perobj.PerTypeDR,"U")="A" roledesc="§"	//珠海改进方法 2019-01-04 gzj注释
	.....;s:$zcvt(perobj.PerTypeDR,"U")="T" roledesc="¤"	//珠海改进方法 2019-01-04 gzj注释
	.....i perobj.PerTypeDR="S" s roledesc="◇"
	.....s:..IsPerOutTrain(perdr_"^"_stdate) roledesc="○" //进修标识
	.....s:(($IsObject(grpobj))&&($IsObject(grpobj.GroupMaster))&&(grpobj.GroupMaster.%Id()=perdr)) roledesc="★"
	.....s dutydesc=$p(##class(web.INMHRComm).GetNurseDuty(perdr,+$h),"^",2)
	.....s:dutydesc["护士长" roledesc="@"
	.....s argrowid=nurlist(ward,grptyp,grp,sort,perdr)
	.....s leveldesc=$P(nurInfo,"^",1)
	.....s ret="PerName|"_roledesc_perobj.PerName_perobj.PerID_"^PerID|"_perobj.PerID_"^ArgPerDR|"_perdr
	.....s ret=ret_"^ArgRowId|"_$case(argrowid,"-":"",:argrowid)_"^ArgPerSort|"_row
	.....s ret=ret_"^LevelDesc|"_leveldesc_"^GrpDesc|"_GrpDesc_"^GrpSort|"_GrpSort_"^PerSort|"_PerSort
	.....s PerSort=PerSort+1
	.....s PerPost=$p(##class(web.INMHRComm).GetNurseHireDuty(perdr,+$h),"^",2)
	.....s ret=ret_"^PerPost|"_PerPost
	.....s ret=ret_"^ArgGroupDR|"_grp
	.....s PerCode=perobj.PerPostName
	.....i ((argid'="")&&(+argrowid'=0)&&($d(^DHCINM.Arg.MgArrangeRowD(argrowid)))) d
	......s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	......q:'$IsObject(rowObj)
	......s:rowObj.ArrangeDR.ArgStatus'="N" PerCode=rowObj.ArgPerCode
	......s ret=ret_"^ArgWorkRemark|"_rowObj.ArgWorkRemark
	......s ret=ret_"^ArgPerBeds|"_rowObj.ArgPerBeds
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc=""
	.......s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	.......s isAskLeave=$p(tmpIsAskLeave,"^")
	.......i isAskLeave=1  d
	........s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	........s argWardPostId=$p(tmpIsAskLeave,"^",3)
	........s celldesc=askLeaveDesc_"」"_..GetWardPostColor(argWardPostId)
	.......s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.......s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||本病区护士在其他病区有排班...||护士长添加人员其他病区有排班
	.......i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)) d
	........s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	........s celldesc=curwardObj.WardDesc_"」」"
	.......e  d
	........s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.........q:+id=0
	.........s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.........q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	.........s PostDesc=""
	.........i obj.ArgType="Y" d
	..........s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  i obj.ArgType="N" d
	..........s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  s PostDesc=obj.ArgPostDR.PostDesc
	.........i $IsObject(obj.ArgPostDR) d
	..........s PostDesc=PostDesc_"」"_..GetWardPostColor(obj.ArgPostDR.%Id())
	.........e  s PostDesc=PostDesc_"」」"
	.........i celldesc="" s celldesc=PostDesc
	.........e  s celldesc=celldesc_"「"_PostDesc
	.........//请假处理
	.........s:obj.ArgPostDR.PostDR.PostType="H" isAskLeave=0
	.........q:obj.ArgPostDR.PostDR.PostType="H"
	.......s ret=ret_celldesc
	.....e  d
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc=""
	.......s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	.......;s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||非本病区排班且护士长添加
	.......i ((curward'="")&&(curward'=ward))||((tWard'="")&&(tWard'=ward)) d ;不是当前科室的
	........s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	........s celldesc=curwardObj.WardDesc_"」」"
	.......e  d
	........s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	........s isAskLeave=$p(tmpIsAskLeave,"^")
	........i isAskLeave=1  d
	.........s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	.........s argWardPostId=$p(tmpIsAskLeave,"^",3)
	.........s celldesc=askLeaveDesc_"」"_..GetWardPostColor(argWardPostId)
	.......s ret=ret_celldesc
	.....s:PerCode'="" PerCode=""
	.....s ret=ret_"^PerCode|"_PerCode
	.....d OutArrangeSub
	.....s row=row+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArrangeSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArrangeSubColorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeSubColorListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArrangeSubColorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeSubColorListExecute ]
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

ClassMethod GetWardPostColor(id)
{
	q:id="" "」"
	s fontColor="",bgColor=""
	s argWardPostLB=$G(^CF.DHCINM.DB.MgArgWardPostD(id))
	i argWardPostLB'="" d
	.s postDR=$LG(argWardPostLB,4)
	.i postDR'="" d
	..s argPostObj=$g(^CF.DHCINM.DB.MgArgPostD(postDR))
	..i argPostObj'="" d
	...s fontColor=$LG(argPostObj,15)
	...s bgColor=$LG(argPostObj,16)
	q fontColor_"」"_bgColor
}

/// Description：查询护士排班次数列表
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期^姓名 登录人Id 登录人角色
/// Output:护士排班次数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindWardArgList","1^2020-06-01^2020-06-30^",0,0)
Query FindWardArgList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardArgListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate="" endDate=$o(^DHCINM.Arg.MgArrangeSubI("Date",""),-1)
	s input=$p(parr,"^",4)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s par=$o(^CT.DHCINM.Set.MgSysParamI("Code"," POSTTYPE",""))
	i par'="" d
	.k tmpType
	.s subCode="" f  s subCode=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode)) q:subCode=""  d
	..s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode,par,subId)) q:subId=""  d
	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(par,subId))
	...s tmpType($tr(subCode," ",""))=1
	k tmpPost
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",ward,sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",ward,sort,id)) q:id=""  d
	..q:'$d(^CF.DHCINM.DB.MgArgWardPostD(id))
	..s wardPostGlo=^CF.DHCINM.DB.MgArgWardPostD(id)
	..s argPostId=$lg(wardPostGlo,4)
	..q:'$d(^CF.DHCINM.DB.MgArgPostD(argPostId))
	..s argPostGlo=^CF.DHCINM.DB.MgArgPostD(argPostId)
	..s PostStatus=$lg(argPostGlo,18)
	..q:PostStatus'="Y"		//启用状态
	..s PostType=$lg(argPostGlo,4)
	..q:PostType'="P"		//全局排班类型为值班
	..s tmpPost(id)=0
	
	
	s statusTmp(" NA")="NA",statusTmp(" ZA")="ZA",statusTmp(" HA")="HA"
	s leaveWard="" f  s leaveWard=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard)) q:leaveWard=""  d
	.q:((ward'="")&&(ward'=leaveWard))||((isAll'=1)&&('$d(tmpWard(leaveWard))))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leavePer="" f  s leavePer=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer)) q:leavePer=""  d
	..s tmpLeavePer=$tr(leavePer," ","")
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(tmpLeavePer))
	..s leavePerName=$lg(perGlo,2)
	..s leavePerId=$lg(perGlo,3)
	..q:(input'="")&&(leavePerName_leavePerId'[input)
	..s leaveStatus="" f  s leaveStatus=$o(statusTmp(leaveStatus)) q:leaveStatus=""  d
	...s leaveId="" f  s leaveId=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer,leaveStatus,leaveId)) q:leaveId=""  d
	....q:'$d(^DHCINM.Arg.MgLeaveAppD(leaveId))
	....s leaveGlo=^DHCINM.Arg.MgLeaveAppD(leaveId)
	....s leaveSource=$lg(leaveGlo,2)
	....q:(leaveSource="H")&&(leaveStatus'=" HA") // 护士长请假需护理部审核
	....s leaveStDate=$lg(leaveGlo,5)
	....s leaveEndDate=$lg(leaveGlo,7)
	....q:((stDate'="")&&(stDate>leaveEndDate))||((endDate'="")&&(endDate<leaveStDate))
	....s:(endDate'="")&&(endDate<leaveEndDate) leaveEndDate=endDate
	....s:(stDate'="")&&(stDate>leaveStDate) leaveStDate=stDate
	....s workDate=$lg(leaveGlo,29)
	....s time=leaveEndDate-leaveStDate+1
	....s time=time-$ll(workDate)
	....s leaveType=$lg(^CF.DHCINM.DB.MgArgPostD($lg(^CF.DHCINM.DB.MgArgWardPostD($lg(leaveGlo,4)),4)),24)
	....s tmp(leaveWard,leavePer,leaveType)=$g(tmp(leaveWard,leavePer,leaveType))+time
	....s tmpCount(leaveWard,leavePer)=$g(tmpCount(leaveWard,leavePer))+time
	
	s argWard="" f  s argWard=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard)) q:argWard=""  d
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(argWard))
	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer)) q:argPer=""  d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	..s argPerName=$lg(perGlo,2)
	..s argPerId=$lg(perGlo,3)
	..q:(input'="")&&(argPerName_argPerId'[input)
	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
	...q:$p(..IsPerAskLeavel3(argPer_"^"_argDate),"^",3)'=""
	...s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate,argId)) q:argId=""  d
	....q:'$d(^DHCINM.Arg.MgArrangeSubD(argId))
	....s argGlo=^DHCINM.Arg.MgArrangeSubD(argId)
	....s argParId=$lg(argGlo,2)
	....q:argParId=""
	....s argParGlo=$g(^DHCINM.Arg.MgArrangeD(argParId))
	....s argParStatus=$lg(argParGlo,7)
	....q:(argParStatus'="R")&&(argParStatus'="A")
	....s wardPostId=$lg(argGlo,7)
	....q:wardPostId=""
	....q:'$d(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	....s wardPostGlo=^CF.DHCINM.DB.MgArgWardPostD(wardPostId)
	....s argPostId=$lg(wardPostGlo,4)
	....;s PostDesc=$lg(wardPostGlo,2)
	....q:'$d(^CF.DHCINM.DB.MgArgPostD(argPostId))
	....s argPostGlo=^CF.DHCINM.DB.MgArgPostD(argPostId)
	....s argType=$lg(argPostGlo,24)
	....s tmp(argWard,argPer,argType)=$g(tmp(argWard,argPer,argType))+1
	....s tmpCount(argWard,argPer)=$g(tmpCount(argWard,argPer))+1
	....s tmp(argWard,argPer,"Post",wardPostId)=$g(tmp(argWard,argPer,"Post",wardPostId))+1
	
	s outWard="" f  s outWard=$o(tmp(outWard)) q:outWard=""  d
	.s wardDesc=$lg(^CF.DHCINM.DB.MgWardD(outWard),4)
	.s outPer="" f  s outPer=$o(tmp(outWard,outPer)) q:outPer=""  d
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(outPer),2)
	..s perLevel=$p(##class(web.INMHRComm).GetNurseLevel(outPer,+$h),"^",2)
	..s ret="NumberNurse|"_outPer_"^NumberNurseName|"_perName_"^NumberNurseLevel|"_perLevel_"^NumberWard|"_outWard_"^NumberWardDesc|"_wardDesc
	..s outType="" f  s outType=$o(tmpType(outType)) q:outType=""  d
	...s ret=ret_"^"_outType_"|"_$fn($g(tmp(outWard,outPer,outType)),"",0)
	..s ret=ret_"^NumberTotalCount|"_$fn($g(tmpCount(outWard,outPer)),"",0)
	..s outPost="" f  s outPost=$o(tmpPost(outPost)) q:outPost=""  d
	...s ret=ret_"^"_outPost_"|"_$fn($g(tmp(outWard,outPer,"Post",outPost)),"",0)
	..d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardArgListExecute ]
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

/// Description: 检测时间冲突
/// Date: 2021-09-23
/// Creator: wangpf
/// Table:
/// Input:
/// Output: -1：格式不正确 0：不冲突 1：冲突
/// Other: w ##class(web.INMArgComm).CheckTmpRepeat(.tmp)
ClassMethod CheckTmpRepeat(tmp) As %String
{
	k tmp2
	s index2=1,flag=0
	s index="" f  s index=$o(tmp(index)) q:(index="")||(flag'=0)  d
	.s time=tmp(index)
	.q:(time="")||(time="^")
	.i $l(time,"^")'=2 s flag=-1 q
	.i ($p(time,"^",1)="")||($p(time,"^",2)="") s flag=-1 q
	.i $p(time,"^",1)["次日" s $p(time,"^",1)=86400+$zth($replace($p(time,"^",1),"次日",""))
	.e  s $p(time,"^",1)=$zth($p(time,"^",1))
	.i $p(time,"^",2)["次日" s $p(time,"^",2)=86400+$zth($replace($p(time,"^",2),"次日",""))
	.e  s $p(time,"^",2)=$zth($p(time,"^",2))
	.s tmp2(index2)=time
	.s index2=index2+1
	
	k tmp3
	s index4=1
	s index2="" f  s index2=$o(tmp2(index2)) q:(index2="")||(flag'=0)  d
	.s time1=tmp2(index2)
	.s stTime1=$p(time1,"^")
	.s endTime1=$p(time1,"^",2)
	.s index3="" f  s index3=$o(tmp3(index3)) q:(index3="")||(flag'=0)  d
	..s time2=tmp3(index3)
	..s stTime2=$p(time2,"^")
	..s endTime2=$p(time2,"^",2)
	..i (stTime1'="")&&(endTime1'="")&&(stTime2'="")&&(endTime2'="")&&(stTime1<endTime2)&&(stTime2<endTime1) s flag=1
	.q:flag'=0
	.s tmp3(index4)=time1
	.s index4=index4+1
	
	q flag
}

/// Description: 保存班次模板套
/// Date: 2021-09-23
/// Creator: wangpf
/// Table: DHCINM.Arg.MgPostComb
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMArgComm).SaveComb("1^1^668,1746^2021-09-23^^",0)
ClassMethod SaveComb(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取编辑人员信息失败,请刷新重试"
	
	s desc=$p(parr,"^")
	s ward=$p(parr,"^",2)
	q:(ward="")||('$d(^CF.DHCINM.DB.MgWardD(ward)))
	s post=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	q:+stDate=0 "启用日期不正确"
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	q:(endDate'="")&&(+endDate=0) "停用日期不正确"
	s rw=$p(parr,"^",6)
	
	i rw="" d
	.s obj=##class(DHCINM.Arg.MgPostComb).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Arg.MgPostComb).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.CombDesc=desc
	d obj.CombWardSetObjectId(ward)
	d obj.CombPost.Clear()
	k tmp
	s index=1
	s len=$l(post)
	f i=1:1:len d
	.s postId=$p(post,",",i)
	.q:(postId="")||('$d(^CF.DHCINM.DB.MgArgWardPostD(postId)))
	.s postGlo=^CF.DHCINM.DB.MgArgWardPostD(postId)
	.s st1=$lg(postGlo,6)
	.s end1=$lg(postGlo,7)
	.s st2=$lg(postGlo,8)
	.s end2=$lg(postGlo,9)
	.s st3=$lg(postGlo,18)
	.s end3=$lg(postGlo,19)
	.s tmp(index)=st1_"^"_end1
	.s tmp(index+1)=st2_"^"_end2
	.s tmp(index+2)=st3_"^"_end3
	.s index=index+3
	.d obj.CombPost.Insert(postId)
	s flag=..CheckTmpRepeat(.tmp)
	q:flag'=0 "时间交叉"
	s obj.CombStDate=stDate
	s obj.CombEndDate=endDate
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q 0	
	}
}

/// Description: 获取班次模板套
/// Date: 2021-09-23
/// Creator: wangpf
/// Table: DHCINM.Arg.MgPostComb
/// Input: parr
/// Output: 
/// Other: w ##class(web.INMArgComm).GetComb(1)
ClassMethod GetComb(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgPostCombD(id))) ""
	
	s combGlo=^DHCINM.Arg.MgPostCombD(id)
	s combbDesc=$lg(combGlo,2)
	s combbWard=$lg(combGlo,3)
	s combbWardDesc=""
	i combbWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(combbWard))
	.s combbWardDesc=$lg(wardGlo,4)
	s combbPost=$lg(combGlo,4)
	s combbPostId=$lts(combbPost)
	s combbPostDesc=""
	s index=0
	s ptr=0 f  s status=$listnext(combbPost,ptr,post) q:status'=1  d
	.s postGlo=""
	.s:post'="" postGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(post))
	.s postDesc=$lg(postGlo,2)
	.i index=0 s combbPostDesc=postDesc
	.e  s combbPostDesc=combbPostDesc_","_postDesc
	.s index=index+1
	s combbStDate=$lg(combGlo,5)
	s combbEndDate=$lg(combGlo,6)
	s:combbStDate'="" combbStDate=$zd(combbStDate,3)
	s:combbEndDate'="" combbEndDate=$zd(combbEndDate,3)
	s creator=$lg(combGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(combGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(combGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="CombDesc|"_combbDesc_"^CombWard|"_combbWard_"^CombWardDesc|"_combbWardDesc_"^CombPost|"_combbPostId
	s ret=ret_"^CombPostDesc|"_combbPostDesc_"^CombStDate|"_combbStDate_"^CombEndDate|"_combbEndDate_"^Creator|"_creator
	s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description: 获取班次模板套列表
/// Date: 2021-09-23
/// Creator: wangpf
/// Table: DHCINM.Arg.MgPostComb
/// Input: parr
/// Output:班次模板套列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindCombList","1",1,0)
Query FindCombList(parr As %String = "", flag As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCombListExecute(ByRef qHandle As %Binary, parr As %String = "", flag As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s now=+$h
	s combWard="" f  s combWard=$o(^DHCINM.Arg.MgPostCombI("Ward",combWard)) q:combWard=""  d
	.q:((ward'="")&&(ward'=combWard))||((isAll'=1)&&('$d(tmpWard(combWard))))
	.s combId="" f  s combId=$o(^DHCINM.Arg.MgPostCombI("Ward",combWard,combId)) q:combId=""  d
	..q:'$d(^DHCINM.Arg.MgPostCombD(combId))
	..s combGlo=^DHCINM.Arg.MgPostCombD(combId)
	..s combStDate=$lg(combGlo,5)
	..s combEndDate=$lg(combGlo,6)
	..q:(flag=1)&&((combStDate>now)||((combEndDate'="")&&(combEndDate<now)))
	..s ret=..GetComb(combId)
	..d OutCombList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCombList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCombListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCombListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCombListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCombListExecute ]
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

/// Description: 班次模板套排班
/// Date: 2021-09-23
/// Creator: wangpf
/// Table: DHCINM.Arg.MgPostComb
/// Input: parr
/// Output: 
/// Other: w ##class(web.INMArgComm).ArrangeByComb("",0)
ClassMethod ArrangeByComb(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取编辑人员信息失败,请刷新重试"
	s combId=$p(parr,"^")
	q:(combId="")||('$d(^DHCINM.Arg.MgPostCombD(combId))) "班次模板套不存在"
	s ward=$p(parr,"^",2)
	s perdr=$p(parr,"^",3)
	s argid=$p(parr,"^",4)
	s rowid=$p(parr,"^",5)
	s date=$p(parr,"^",6)
	s:date["-" date=$zdh(date,3)
	q:(ward="")||(perdr="")||(argid="")||(rowid="")||(+date=0) "参数不正确"
	
	s combGlo=^DHCINM.Arg.MgPostCombD(combId)
	s combPost=$lg(combGlo,4)
	s flag=1
	ts
	s ptr=0 f  s status=$listnext(combPost,ptr,PostId) q:(status'=1)||(flag'=1)  d
	.q:PostId=""
	.s PostObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(PostId)
	.q:'$IsObject(PostObj)
	.s postParr="ArgStTime1|"_PostObj.PostStTime1_"^ArgEndTime1|"_PostObj.PostEndTime1_"^ArgStTime2|"_PostObj.PostStTime2
	.s postParr=postParr_"^ArgEndTime2|"_PostObj.PostEndTime2_"^ArgStTime3|"_PostObj.PostStTime3_"^ArgEndTime3|"_PostObj.PostEndTime3
	.s postParr=postParr_"^ArgType|P"_"^ArgPerDR|"_perdr_"^ArgDate|"_$zd(date,3)_"^rw|"
	.q:..CheckRepeat(postParr)'=""
	.s ArgSubObj=##class(DHCINM.Arg.MgArrangeSub).%New()
	.d ArgSubObj.ArrangeDRSetObjectId(argid)
	.d ArgSubObj.ArgRowDRSetObjectId(rowid)
	.d ArgSubObj.ArgWardDRSetObjectId(ward)
	.d ArgSubObj.ArgPerDRSetObjectId(perdr)
	.s ArgSubObj.ArgDate=date
	.s ArgSubObj.ArgPostDR=PostObj
	.s ArgSubObj.ArgStTime1=PostObj.PostStTime1
	.s ArgSubObj.ArgEndTime1=PostObj.PostEndTime1
	.s ArgSubObj.ArgStTime2=PostObj.PostStTime2
	.s ArgSubObj.ArgEndTime2=PostObj.PostEndTime2
	.s ArgSubObj.ArgStTime3=PostObj.PostStTime3
	.s ArgSubObj.ArgEndTime3=PostObj.PostEndTime3
	.s ArgSubObj.ArgEditUser=nurseid
	.s ArgSubObj.ArgEditDate=+$h
	.s ArgSubObj.ArgEditTime=$p($h,",",2)
	.s ArgSubObj.ArgCategory=PostObj.PostCategory
	.s sc=ArgSubObj.%Save()
	.s:$$$ISERR(sc) flag=0
	
	i flag'=1 tro  q 0
	e  tc  q 1
}

///  creator: wangpf
///  createdate: 2020-05-27
///  description:模板排班
///  table: DHCINM.Arg.MgArrange DHCINM.Arg.MgArrangeRow DHCINM.Arg.MgArrangeSub
///  input: DHCINM.Arg.MgArrange信息
///  output:
///  other:d ##class(web.INMArgComm).ArrangeByTemplate("ArgWardDR|1^ArgStDate|2021-01-18^ArgEndDate|2021-01-24^ArgCrtUser|0^ArgRemarks|^ArgStatus|^rw|^WardDesc|^",0)
ClassMethod ArrangeByTemplate(parr As %String = "", nurseid As %String = "") As %String
{
	
	//"ArgListNo|201708281^ArgWardDR|1^ArgStDate|2017-08-28^ArgEndDate|2017-09-03^ArgRemark|^ArgCrtUser|45"
	q:parr="" 0
	k tmp
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("ArgWardDR"))="")||($g(tmp("ArgStDate"))="")||($g(tmp("ArgEndDate"))="")||($g(tmp("ArgCrtUser"))="") 0
	s ward=tmp("ArgWardDR")
	s stDate=$zdh(tmp("ArgStDate"),3)
	s endDate=$zdh(tmp("ArgEndDate"),3)
	
	ts
	s argid=..SaveArrange(parr)
	i +argid=0 tro  q 0
	k nurlist,tmpgroup
	d ..GetWardNurse("",ward,tmp("ArgStDate"),tmp("ArgEndDate"),"",.nurlist,.tmpgroup)
	
	k tmpGrpRelate
	s tGrpSort="" f  s tGrpSort=$o(tmpgroup("G",tGrpSort)) q:tGrpSort=""  d
	.s i="" f  s i=$o(tmpgroup("G",tGrpSort,i)) q:i=""  d
	..q:+i<1
	..s nurGroupObj=##class(DHCINM.Arg.MgNurGroup).%OpenId(i)
	..q:'$IsObject(nurGroupObj)
	..s argGroupObj=##class(DHCINM.Arg.MgArrangeGroup).%New()
	..d argGroupObj.ArrangeDRSetObjectId(argid)
	..s argGroupObj.GroupBedGroup=nurGroupObj.GroupBedGroup
	..s argGroupObj.GroupCode=nurGroupObj.GroupDesc
	..s argGroupObj.GroupDesc=nurGroupObj.GroupDesc
	..s argGroupObj.GroupMaster=nurGroupObj.GroupMaster
	..s argGroupObj.GroupRemark=nurGroupObj.GroupRemark
	..s argGroupObj.GroupResBeds=nurGroupObj.GroupResBeds
	..d argGroupObj.%Save()
	..s tmpGrpRelate(i)=argGroupObj.%Id()

	
	s flag=1,tmpSort=1
	s grptyp="" f  s grptyp=$O(nurlist(ward,grptyp)) q:(grptyp="")||(flag'=1)  d
	.s grp="" f  s grp=$O(nurlist(ward,grptyp,grp)) q:(grp="")||(flag'=1)  d
	..s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:(sort="")||(flag'=1)  d
	...s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:(perdr="")||(flag'=1)  d
	....q:'$d(^CF.DHCINM.HR.PersonsD(perdr))
	....s ArgRowObj=##class(DHCINM.Arg.MgArrangeRow).%New()
	....d ArgRowObj.ArrangeDRSetObjectId(argid)
	....d ArgRowObj.ArgPerDRSetObjectId(perdr)
	....s ArgRowObj.ArgPerSort=tmpSort
	....d:(+$g(tmpGrpRelate(grp))'=0)&&($d(^DHCINM.Arg.MgArrangeGroupD($g(tmpGrpRelate(grp))))'=0) ArgRowObj.ArgGroupDRSetObjectId($g(tmpGrpRelate(grp)))
	....s ArgRowObj.ArgPerAddFlag="N"
	....s sc=ArgRowObj.%Save()
	....i $$$ISERR(sc) s flag=0 q
	....s tmpSort=tmpSort+1
	....s rowid=ArgRowObj.%Id()
	....f date=stDate:1:endDate q:flag'=1  d
	.....s TargetTemplateObj=""
	.....s TemplateStDate="" f  s TemplateStDate=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",ward,perdr,TemplateStDate)) q:TemplateStDate=""  d
	......s TemplateId="" f  s TemplateId=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",ward,perdr,TemplateStDate,TemplateId)) q:TemplateId=""  d
	.......s TemplateObj=##class(DHCINM.Arg.MgArgTemplate).%OpenId(TemplateId)
	.......q:'$IsObject(TemplateObj)
	.......q:(TemplateObj.TemplateStDate>date)||((TemplateObj.TemplateEndDate'="")&&(TemplateObj.TemplateEndDate<date))
	.......s TargetTemplateObj=TemplateObj
	.....q:TargetTemplateObj=""
	.....q:+TemplateObj.TemplateCycle<=0
	.....s Index=date-TemplateObj.TemplateStDate+1#TemplateObj.TemplateCycle
	.....s:Index=0 Index=TemplateObj.TemplateCycle
	.....s PostIds=TemplateObj.TemplatePost.GetAt(Index)
	.....s PostIds=$lfs(PostIds,"@")
	.....s ptr=0 f  s status=$listnext(PostIds,ptr,PostId) q:(status'=1)||(flag'=1)  d
	......s PostObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(PostId)
	......q:'$IsObject(PostObj)
	......s postParr="ArgStTime1|"_PostObj.PostStTime1_"^ArgEndTime1|"_PostObj.PostEndTime1_"^ArgStTime2|"_PostObj.PostStTime2
	......s postParr=postParr_"^ArgEndTime2|"_PostObj.PostEndTime2_"^ArgStTime3|"_PostObj.PostStTime3_"^ArgEndTime3|"_PostObj.PostEndTime3
	......s postParr=postParr_"^ArgType|P"_"^ArgPerDR|"_perdr_"^ArgDate|"_$zd(date,3)_"^rw|"
	......q:..CheckRepeat(postParr)'=""
	......s ArgSubObj=##class(DHCINM.Arg.MgArrangeSub).%New()
	......d ArgSubObj.ArrangeDRSetObjectId(argid)
	......d ArgSubObj.ArgRowDRSetObjectId(rowid)
	......d ArgSubObj.ArgWardDRSetObjectId(ward)
	......d ArgSubObj.ArgPerDRSetObjectId(perdr)
	......s ArgSubObj.ArgDate=date
	......s ArgSubObj.ArgPostDR=PostObj
	......s ArgSubObj.ArgStTime1=PostObj.PostStTime1
	......s ArgSubObj.ArgEndTime1=PostObj.PostEndTime1
	......s ArgSubObj.ArgStTime2=PostObj.PostStTime2
	......s ArgSubObj.ArgEndTime2=PostObj.PostEndTime2
	......s ArgSubObj.ArgStTime3=PostObj.PostStTime3
	......s ArgSubObj.ArgEndTime3=PostObj.PostEndTime3
	......s ArgSubObj.ArgEditUser=nurseid
	......s ArgSubObj.ArgEditDate=+$h
	......s ArgSubObj.ArgEditTime=$p($h,",",2)
	......s ArgSubObj.ArgCategory=PostObj.PostCategory
	......s sc=ArgSubObj.%Save()
	......s:$$$ISERR(sc) flag=0
	i flag'=1 tro  q 0
	e  tc  q argid
}

///  creator: wangpf
///  createdate: 2020-05-28
///  description:获取排班模板
///  table: DHCINM.Arg.MgArgTemplate
///  input:
///  output:
///  other:w ##class(web.INMArgComm).GetArgTemplate(1)
ClassMethod GetArgTemplate(id As %String = "") As %String
{
	q:id="" ""
	s Obj=##class(DHCINM.Arg.MgArgTemplate).%OpenId(id)
	q:'$IsObject(Obj) ""
	s perId="",perName="",stDate="",endDate=""
	i $IsObject(Obj.TemplatePerson) d
	.s perId=Obj.TemplatePerson.%Id()
	.s perName=Obj.TemplatePerson.PerName
	s:Obj.TemplateStDate'="" stDate=$zd(Obj.TemplateStDate,3)
	s:Obj.TemplateEndDate'="" endDate=$zd(Obj.TemplateEndDate,3)
	s cycle=Obj.TemplateCycle
	s post="",postDesc="",postToShow="",dayIndex=1
	s key="" f  s p=Obj.TemplatePost.GetNext(.key) q:key=""  d
	.s postList=$lfs(p,"@"),ppDesc=""
	.s ptr=0 f  s status=$listnext(postList,ptr,pp) q:status'=1  d
	..s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(pp)
	..q:'$IsObject(postObj)
	..i ppDesc="" s ppDesc=postObj.PostDesc
	..e  s ppDesc=ppDesc_"@"_postObj.PostDesc
	.i dayIndex=1 s post=p,postDesc=ppDesc,postToShow="第"_dayIndex_"天："_$tr(ppDesc,"@","、")
	.e  s post=post_","_p,postDesc=postDesc_","_ppDesc,postToShow=postToShow_"，第"_dayIndex_"天："_$tr(ppDesc,"@","、")
	.s dayIndex=dayIndex+1
	s ward="",wardDesc=""
	i $IsObject(Obj.TemplateWard) d
	.s ward=Obj.TemplateWard.%Id()
	.s wardDesc=Obj.TemplateWard.WardDesc
	s creator=Obj.TemplateCreator,creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s creatorObj=##class(CF.DHCINM.DB.MgUser).%OpenId(creator)
	.q:'$IsObject(creatorObj)
	.s creatorName=creatorObj.UserName
	s crtDate="",crtTime=""
	s:Obj.TemplateCreateDate'="" crtDate=$zd(Obj.TemplateCreateDate,3)
	s:Obj.TemplateCreateTime'="" crtTime=$zt(Obj.TemplateCreateTime)
	s ret="PerId|"_perId_"^PerName|"_perName_"^StDate|"_stDate_"^EndDate|"_endDate_"^Cycle|"_cycle_"^Post|"_post_"^PostDesc|"_postDesc
	s ret=ret_"^Ward|"_ward_"^WardDesc|"_wardDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_crtDate_"^CreateTime|"_crtTime
	s ret=ret_"^PostToShow|"_postToShow_"^rw|"_id
	q ret
}

///  creator: wangpf
///  createdate: 2020-05-28
///  description: 获取排班模板
///  table: DHCINM.Arg.MgArrangeSub
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgTemplateList","2020-01-06^2020-01-12")
Query FindArgTemplateList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgTemplateListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$P(parr,"^")
	s per=$p(parr,"^",2)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s wardId="" f  s wardId=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",wardId)) q:wardId=""  d
	.q:(ward'="")&&(ward'=wardId)
	.q:(isAll'=1)&&($d(tmpWard(wardId))=0)
	.s perId="" f  s perId=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",wardId,perId)) q:perId=""  d
	..q:(per'="")&&(per'=perId)
	..s stDate="" f  s stDate=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",wardId,perId,stDate)) q:stDate=""  d
	...s id="" f  s id=$o(^DHCINM.Arg.MgArgTemplateI("WardPerson",wardId,perId,stDate,id)) q:id=""  d
	....s ret=..GetArgTemplate(id)
	....d:ret'="" OutTemplate
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTemplate
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgTemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgTemplateListExecute ]
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

///  creator: wangpf
///  createdate: 2020-05-28
///  description:保存排班模板
///  table: DHCINM.Arg.MgArgTemplate
///  input:
///  output: -1:数据错误 0:保存失败 >0:id
///  other:d ##class(web.INMArgComm).SaveArgTemplate("6^5303^7^2020-05-01^^,785@786,787@788@789,,790@791@792@1234,,1766^",0)
ClassMethod SaveArgTemplate(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	s ward=$p(parr,"^")
	s per=$p(parr,"^",2)
	s cycle=$p(parr,"^",3)
	s sdDate=$p(parr,"^",4)
	s:sdDate["-" sdDate=$zdh(sdDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	s post=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) 0
	q:$l(post,",")'=cycle -1
	i rw="" d
	.s obj=##class(DHCINM.Arg.MgArgTemplate).%New()
	.s obj.TemplateCreator=nurseid
	e  s obj=##class(DHCINM.Arg.MgArgTemplate).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.TemplateWardSetObjectId(ward)
	d obj.TemplatePersonSetObjectId(per)
	s obj.TemplateCycle=cycle
	s obj.TemplateStDate=sdDate
	s obj.TemplateEndDate=endDate
	d obj.TemplatePost.Clear()
	s flag=1
	s post=$lfs(post,",")
	s ptr=0 f  s status=$listnext(post,ptr,value) q:(status'=1)||(flag'=1)  d
	.s day=$lfs(value,"@")
	.s dayPtr=0 f  s dayStatus=$listnext(day,dayPtr,dayValue) q:(dayStatus'=1)||(flag'=1)  d
	..s:'$d(^CF.DHCINM.DB.MgArgWardPostD(dayValue)) flag=0
	.q:flag'=1
	.d obj.TemplatePost.Insert(value)
	q:flag'=1 0
	s flag=obj.%Save()
	i $$$ISOK(flag) q obj.%Id()
	e  q 0
}

ClassMethod DelArgTemplate(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Arg.MgArgTemplate).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 排班组合排班
/// Date: 2021-10-08
/// Creator: lulin
/// Table: CF.DHCINM.DB.MgWardPostGroup
/// Input: parr
/// Output: 
/// Other:
ClassMethod SavePostGroup(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	s ^tmpSavePostGroup("parr1")=parr1,^tmpSavePostGroup("parr2")=parr2,^tmpSavePostGroup("parr3")=parr3
	q:(parr1="")!(parr2="")!(parr3="") "入参为空,请刷新重试"
	s argid=..SaveArrange(parr1)
	q:+argid=0 "保存排班失败"
	s argObj=##class(DHCINM.Arg.MgArrange).%OpenId(argid)
	s argrowid=..SaveArgRow(parr1,parr2)
	q:+argrowid=0 "保存行数据失败"
	s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(argrowid)
	s wardPostGroupID=$P(parr3,"^",1)
	s InitDate=$P(parr3,"^",2)
	s:InitDate["-" InitDate=$zdh(InitDate,3)
	q:(wardPostGroupID="")!(InitDate="") "入参为空,请刷新重试"
	s wardPostGroupObj=##class(CF.DHCINM.DB.MgWardPostGroup).%OpenId(wardPostGroupID)
	q:'$IsObject(wardPostGroupObj) "未获取到排班组,请检查是否已删除"
	//当天已排班过滤掉
	//存在时间交叉得过滤掉
#;	k tmpPost
#;	s tmpPost=""
#;	f i=1:1:wardPostGroupObj.GroupPost.Count()  d
#;	.s tDate=InitDate+i-1
#;	.q:tDate>argObj.ArgEndDate
#;	.s postID=wardPostGroupObj.GroupPost.GetAt(i)
#;	.q:postID=""
#;	.s tmpWardPost=##Class(CF.DHCINM.DB.MgArgWardPost).%OpenId(postID)
#;	.q:'$IsObject(tmpWardPost)
#;	.q:$d(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,tDate))
#;	.s checkStr="ArgStTime1|"_tmpWardPost.PostStTime1_"^ArgEndTime1|"_tmpWardPost.PostEndTime1
#;	.s checkStr=checkStr_"^ArgStTime2|"_tmpWardPost.PostStTime2_"^ArgEndTime2|"_tmpWardPost.PostEndTime2
#;	.s checkStr=checkStr_"^ArgStTime3|"_tmpWardPost.PostStTime3_"^ArgEndTime3|"_tmpWardPost.PostEndTime3
#;	.s checkStr=checkStr_"^ArgPerDR|"_rowObj.ArgPerDR.%Id()_"^ArgDate|"_tDate
#;	.s flag=..CheckRepeat(checkStr)
#;	.q:flag'=""
#;	.s tmpPost(postID)=tDate
	s sc=1
	TS
	f i=1:1:wardPostGroupObj.GroupPost.Count() q:sc'=1  d
	.s date=InitDate+i-1
	.q:$d(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,argrowid,date))
	.q:date>argObj.ArgEndDate
	.s postID=wardPostGroupObj.GroupPost.GetAt(i)
	.q:postID=""
	.s tmpWardPost=##Class(CF.DHCINM.DB.MgArgWardPost).%OpenId(postID)
	.q:'$IsObject(tmpWardPost)
	.s checkStr="ArgStTime1|"_tmpWardPost.PostStTime1_"^ArgEndTime1|"_tmpWardPost.PostEndTime1
	.s checkStr=checkStr_"^ArgStTime2|"_tmpWardPost.PostStTime2_"^ArgEndTime2|"_tmpWardPost.PostEndTime2
	.s checkStr=checkStr_"^ArgStTime3|"_tmpWardPost.PostStTime3_"^ArgEndTime3|"_tmpWardPost.PostEndTime3
	.s checkStr=checkStr_"^ArgPerDR|"_rowObj.ArgPerDR.%Id()_"^ArgDate|"_date
	.q:..CheckRepeat(checkStr)'=""
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%New()
	.s obj.ArrangeDR=argObj
	.s obj.ArgRowDR=rowObj
	.s obj.ArgWardDR=argObj.ArgWardDR
	.s obj.ArgPerDR=rowObj.ArgPerDR
	.s obj.ArgDate=date
	.s obj.ArgPostDR=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(postID)
	.i obj.ArgPostDR.PostDR.PostType="H" d
	..s obj.ArgHolidayTime=$case(obj.ArgPostDR.PostDR.HolidayTime,"H":"A","A":"H",:obj.ArgPostDR.PostDR.HolidayTime)
	.s obj.ArgStTime1=obj.ArgPostDR.PostStTime1
	.s obj.ArgEndTime1=obj.ArgPostDR.PostEndTime1
	.s obj.ArgStTime2=obj.ArgPostDR.PostStTime2
	.s obj.ArgEndTime2=obj.ArgPostDR.PostEndTime2
	.s obj.ArgStTime3=obj.ArgPostDR.PostStTime3
	.s obj.ArgEndTime3=obj.ArgPostDR.PostEndTime3
	.s obj.ArgRemark=""
	.s obj.ArgEditUser=obj.ArrangeDR.ArgCrtUser
	.s obj.ArgEditDate=+$h
	.s obj.ArgEditTime=$P($h,",",2)
	.s obj.ArgCategory=obj.ArgPostDR.PostCategory
	.s sc=$$$ISOK(obj.%Save())
	i sc{
		TC
		q 1
	}else {
		TRO
		q "保存失败"
	}
}

ClassMethod GetPerInfo(perdr, stdate) As %String
{
	s perobj=##class(CF.DHCINM.HR.Persons).%OpenId(perdr)
	q:'$IsObject(perobj) ""
	s PerWorkDate=perobj.PerWorkDate
	s WorlYear=""
	s:PerWorkDate'="" WorlYear=$P(##class(web.INMVueComm).CalAge($zd(PerWorkDate,3),$zd(+$H,3)),"Y",1)
	s nurInfo=..GetNurseLevel(stdate,perdr) //珠海改进方法 2019-01-04 gzj新增
	s roledesc=""
	s roledesc=$p(nurInfo,"^",2)
	i perobj.PerTypeDR="S" s roledesc="◇"
	s:..IsPerOutTrain(perdr_"^"_stdate) roledesc="○" //进修标识
	s dutydesc=$p(##class(web.INMHRComm).GetNurseDuty(perdr,+$h),"^",2)
	s:dutydesc["护士长" roledesc="@"
	s leveldesc=$P(nurInfo,"^",1)
	s showPerName=roledesc_perobj.PerName_perobj.PerID
	s ret="PerName|"_showPerName_"^PerID|"_perobj.PerID_"^WorlYear|"_WorlYear_"^ArgPerDR|"_perdr_"^ArgRowId|"
	s ret=ret_"^LevelDesc|"_leveldesc
	s PerPost=$p(##class(web.INMHRComm).GetNurseHireDuty(perdr,+$h),"^",2)
	s ret=ret_"^PerPost|"_PerPost	
	q ret
}

/// Creator:
/// Createdate:
/// Description: 
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 
/// Output:
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindExportArg","1","2021-10-04","2021-10-19")
Query FindExportArg(ward As %String, stDate As %String, endDate As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportArgExecute(ByRef qHandle As %Binary, ward As %String, stDate As %String, endDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i $l(stDate,"-")=3 s stDate=$zdh(stDate,3)
	e  s stDate=""
	i $l(endDate,"-")=3 s endDate=$zdh(endDate,3)
	e  s endDate=""
	if ((stDate="")!(endDate="")!(ward="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s tmpHoliday="",tmpWorkDay=""
	s year=$p($zd(stDate,3),"-",1)
	s year2=$p($zd(endDate,3),"-",1)
	s sc=..setHolidayTmp(year,.tmpHoliday,0)
	s sc=..setHolidayTmp(year,.tmpWorkDay,1)
	s sc=..setHolidayTmp(year2,.tmpHoliday,0)
	s sc=..setHolidayTmp(year2,.tmpWorkDay,1)
	k tmp
	s tmp=""
	s ArgEndDate=stDate f  s ArgEndDate=$O(^DHCINM.Arg.MgArrangeI("WardEndDate",ward,ArgEndDate)) q:((ArgEndDate="")||(ArgEndDate>(endDate+6)))  d
	.s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeI("WardEndDate",ward,ArgEndDate,argid)) q:argid=""  d
	..s ArgObjLB=$g(^DHCINM.Arg.MgArrangeD(argid))
	..q:ArgObjLB=""
	..s ArgStDate=$lg(ArgObjLB,4)
	..s argRowId="" f  s argRowId=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",argid,argRowId)) q:argRowId=""  d
	...s argRowObj=$g(^DHCINM.Arg.MgArrangeRowD(argRowId))
	...q:argRowId=""
	...s perID=$lg(argRowObj,3)
	...q:perID=""
	...s tmp(perID)=argRowId
	...f date=ArgStDate:1:ArgEndDate d
	....s tmp(perID,date)=argRowId
	s PerSort=1
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret=..GetPerInfo(tmpPer,stDate)
	.s ret=ret_"^PerSort|"_PerSort
	.s PerSort=PerSort+1
	.f date=stDate:1:endDate d
	..s rowObj=""
	..i $g(tmp(tmpPer,date))'="" d
	...s rowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(tmp(tmpPer,date))
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..s celldesc=""
	..s tmpIsAskLeave=..IsPerAskLeavel3(tmpPer_"^"_date)
	..s isAskLeave=$p(tmpIsAskLeave,"^")
	..s askLeaveDesc="%"_$p(tmpIsAskLeave,"^",2)
	..s curward=##class(web.INMHRComm).GetCurrentWard(tmpPer,date)
	..s secondWard=..GetPostForOther(tmpPer,date,curward)
	..s tWard=..GetPostForOther(tmpPer,date,ward)
	..;不在本病区且不是护士长添加||本病区护士在其他病区有排班||护士长添加人员其他病区有排班
	..i ((curward'="")&&(curward'=ward)&&('$IsObject(rowObj)||(rowObj.ArgPerAddFlag'="Y")))||((tWard'="")&&(tWard'=ward)) d
	...s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(tWard)
	...i tWard="" s curwardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curward)
	...s celldesc="」"_curwardObj.WardDesc
	..e  i isAskLeave=0 d
	...s Row="" f  s Row=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,Row)) q:Row=""  d
	....s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(Row)
	....q:'$IsObject(obj)
	....q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	....s PostDesc=""
	....i obj.ArgType="Y" d
	.....s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  i obj.ArgType="N" d
	.....s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  s PostDesc=obj.ArgPostDR.PostDesc
	....s workTime=""
	....s:obj.ArgStTime1'="" workTime=obj.ArgStTime1_"-"_obj.ArgEndTime1
	....s:obj.ArgStTime2'="" workTime=workTime_";"_obj.ArgStTime2_"-"_obj.ArgEndTime2
	....s:obj.ArgStTime3'="" workTime=workTime_";"_obj.ArgStTime3_"-"_obj.ArgEndTime3
	....i celldesc="" s celldesc=Row_"」"_PostDesc_obj.ArgRemark_"『"_workTime
	....e  s celldesc=celldesc_"「"_Row_"」"_PostDesc_obj.ArgRemark_"『"_workTime
	..s ret=ret_celldesc_askLeaveDesc
	.d OutNurseArgSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseArgSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportArgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportArgExecute ]
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

ClassMethod FindExportArgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportArgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description: 
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 
/// Output:
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindExportArgStyle","1","2021-10-04","2021-10-19")
Query FindExportArgStyle(ward As %String, stDate As %String, endDate As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportArgStyleExecute(ByRef qHandle As %Binary, ward As %String, stDate As %String, endDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i $l(stDate,"-")=3 s stDate=$zdh(stDate,3)
	e  s stDate=""
	i $l(endDate,"-")=3 s endDate=$zdh(endDate,3)
	e  s endDate=""
	if ((stDate="")!(endDate="")!(ward="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s tmpHoliday="",tmpWorkDay=""
	s year=$p($zd(stDate,3),"-",1)
	s year2=$p($zd(endDate,3),"-",1)
	s sc=..setHolidayTmp(year,.tmpHoliday,0)
	s sc=..setHolidayTmp(year,.tmpWorkDay,1)
	s sc=..setHolidayTmp(year2,.tmpHoliday,0)
	s sc=..setHolidayTmp(year2,.tmpWorkDay,1)
	k tmp
	s tmp=""
	s ArgEndDate=stDate f  s ArgEndDate=$O(^DHCINM.Arg.MgArrangeI("WardEndDate",ward,ArgEndDate)) q:((ArgEndDate="")||(ArgEndDate>(endDate+6)))  d
	.s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeI("WardEndDate",ward,ArgEndDate,argid)) q:argid=""  d
	..s ArgObjLB=$g(^DHCINM.Arg.MgArrangeD(argid))
	..q:ArgObjLB=""
	..s ArgStDate=$lg(ArgObjLB,4)
	..s argRowId="" f  s argRowId=$O(^DHCINM.Arg.MgArrangeRowI("Arrange",argid,argRowId)) q:argRowId=""  d
	...s argRowObj=$g(^DHCINM.Arg.MgArrangeRowD(argRowId))
	...q:argRowId=""
	...s perID=$lg(argRowObj,3)
	...q:perID=""
	...s tmp(perID)=argRowId
	...f date=ArgStDate:1:ArgEndDate d
	....s tmp(perID,date)=argRowId
	
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret=""
	.s ret="ArgPerDR|"_tmpPer
	.f date=stDate:1:endDate d
	..s cellstyle=""
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..s tmpIsAskLeave=..IsPerAskLeavel3(tmpPer_"^"_date)
	..i (($p(tmpIsAskLeave,"^",1)=1)&&($p(tmpIsAskLeave,"^",3)'="")) d
	...s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId($p(tmpIsAskLeave,"^",3))
	...s:$IsObject(postObj) cellstyle=postObj.PostDR.PostFontColor_"!"_postObj.PostDR.PostBgColor
	..s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,rw)) q:rw=""  d
	...s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	...q:'$IsObject(obj)
	...i ((obj.ArgType'="Y")&&(obj.ArgType'="N")) d
	....i cellstyle="" s cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	....e  s cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	..s ret=ret_cellstyle
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportArgStyleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportArgStyleExecute ]
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

ClassMethod FindExportArgStyleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportArgStyleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpengfei
/// Createdate:2021-11-10
/// Description: 关联床位管理上下移动
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 
/// Output:
/// Return:
/// Other:  w ##class(web.INMArgComm).MoveGroup(14,"U")
ClassMethod MoveGroup(id As %String = "", type As %String = "") As %String
{
	q:(id="")||(type="") 0
	
	s obj=##class(DHCINM.Arg.MgNurGroup).%OpenId(id)
	q:'$IsObject(obj) 0
	q:'$IsObject(obj.GroupWardDR) 0
	q:+obj.GroupSort=0 0
	s flag=1
	i type="D" d
	.s direction=1
	.s next=$o(^DHCINM.Arg.MgNurGroupI("Sort",obj.GroupWardDR.%Id(),obj.GroupSort))
	.s:next="" flag="已在底部"
	e  d
	.s direction=-1
	.s next=$o(^DHCINM.Arg.MgNurGroupI("Sort",obj.GroupWardDR.%Id(),obj.GroupSort),-1)
	.s:next="" flag="已在顶部"
	q:flag'=1 flag
	s nextId=$o(^DHCINM.Arg.MgNurGroupI("Sort",obj.GroupWardDR.%Id(),next,""))
	s nextObj=##class(DHCINM.Arg.MgNurGroup).%OpenId(nextId)
	q:'$IsObject(nextObj) 0
	s tSort=nextObj.GroupSort
	s nextObj.GroupSort=obj.GroupSort
	s obj.GroupSort=tSort
	ts
	s sc=obj.%Save()
	s:$$$ISOK(sc) sc=nextObj.%Save()
	i $$$ISOK(sc){
		tc
		q 1
	}else {
		tro
		q 0
	}
}

/// Description：获取护士某天排班
/// Date:2021-11-11
/// Creator:guoyb
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 日期 护士perId
/// Output:护士某天层级、排班名称、班次对应时间段信息 
/// Other:w ##class(web.INMArgComm).GetNurDayArg("2021-11-09",2019)
ClassMethod GetNurDayArg(date As %String = "", nurseid As %String = "") As %String
{
	
	
	q:(date="")||(nurseid="")
	s:date["-" date=$zdh(date,3)
	s NurseRow=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt($tr(nurseid," ",""),"U"),""))
	q:(NurseRow="")||('$d(^CF.DHCINM.HR.PersonsD(NurseRow)))
	s perLevel=$p(##class(web.INMHRComm).GetNurseLevel(NurseRow,+$h),"^",2)
	s ret=perLevel
	s postDesc="",postTime=""
	s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",NurseRow,date,subId)) q:subId=""  d
	
	.s ArgObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
	.q:'$IsObject(ArgObj)
	.q:ArgObj.ArrangeDR.ArgStatus'="R" //如果没有提交排班则不统计
	
	
	.q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	.s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	.s ward=$lg(subGlo,4)
	.s wardPost=$lg(subGlo,7)
	.q:wardPost=""
	.s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	.s wardPostDesc=$lg(wardPostGlo,2)
	.i postDesc="" s postDesc=wardPostDesc
	.e  s postDesc=postDesc_";"_wardPostDesc 
	.s retAll=""
	.s:$lg(wardPostGlo,6)'="" ret1=$lg(wardPostGlo,6)_"-"_$lg(wardPostGlo,7)
	.s:$lg(wardPostGlo,8)'="" ret2=$lg(wardPostGlo,8)_"-"_$lg(wardPostGlo,9)
	.s:$lg(wardPostGlo,18)'="" ret3=$lg(wardPostGlo,18)_"-"_$lg(wardPostGlo,19)
	.i ($lg(wardPostGlo,6)'="") d
	..s retAll=ret1
	.i (($lg(wardPostGlo,6)'="")&&($lg(wardPostGlo,8)'="")) d
	..s retAll=retAll_"@"_ret2
	.e  i ($lg(wardPostGlo,8)'="") s retAll=retAll_"^"_ret2
	.i ((($lg(wardPostGlo,6)'="")||($lg(wardPostGlo,8)'=""))&&($lg(wardPostGlo,18)'="")) d
	..s retAll=retAll_"@"_ret3
	.e  i ($lg(wardPostGlo,18)'="") s retAll=retAll_"^"_ret3
	.i postTime="" s postTime=retAll
	.e  s postTime=postTime_";"_retAll  
	i ((postDesc'="")&&(postTime'="")) s ret=ret_"^"_postDesc_"^"_postTime
	q ret
}

/// creator: liuning
/// createDate: 20210413
/// description: 获取未排班病区列表
/// table: DHCNMG.DB.MgWard
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMArgComm","FindUnArrangeWardList","2021-04-19^2021-04-25")
Query FindUnArrangeWardList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindUnArrangeWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpLocWard=""
	s stdate=$p(parr,"^",1)
	s enddate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	k nurTmp
	s nurTmp=""
	s postPer="" f  s postPer=$o(^CF.DHCINM.HR.PostDutyI("ssid",postPer)) q:(postPer="")  d
	.s postRw="" f  s postRw=$o(^CF.DHCINM.HR.PostDutyI("ssid",postPer,postRw)) q:(postRw="")  d
	..s postObj=##class(CF.DHCINM.HR.PostDuty).%OpenId(postRw)
	..q:'$IsObject(postObj)
	..q:postObj.PostPerDR.PerDepDR=""
	..q:postObj.PostStatus'="A"
	..q:(postObj.PostEndDate'="")&&(postObj.PostEndDate<+$h)
	..s PostDuty=##class(web.INMPersonComm).GetCommCode(postObj.PostDuty)
	..q:PostDuty'="护士长"
	..s nurTmp(postObj.PostPerDR.PerDepDR)=postObj.PostPerDR.PerName_"^"_postObj.PostPerDR.PerPhone
	s code="" f  s code=$o(^CF.DHCINM.DB.MgWardI("Code",code)) q:code=""  d
	.s id="" f  s id=$o(^CF.DHCINM.DB.MgWardI("Code",code,id)) q:id=""  d 
	..s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	..s wardDesc=wardobj.WardDesc
	..s wardText=##class(ext.util.String).ToChineseSpell(wardDesc)
	..s tmp(wardText)=id
	s wardText="" f  s wardText=$o(tmp(wardText)) q:wardText=""  d
	.s id=tmp(wardText)
	.s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	.s flag=0
	.s argid="" f  s argid=$o(^DHCINM.Arg.MgArrangeI("WardDate",id,stdate,enddate,argid)) q:argid=""  d
	..s flag=1
	.q:flag=1
	.s perName=$P($g(nurTmp(id)),"^",1),PerPhone=$P($g(nurTmp(id)),"^",2)
	.s ret="WardDesc|"_obj.WardDesc_"^PerName|"_perName_"^PerPhone|"_PerPhone
	.d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindUnArrangeWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUnArrangeWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUnArrangeWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUnArrangeWardListExecute ]
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

/// Description: 获取护士某日排班及当周工时、积假
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 日期
/// Output: 护士某日排班及当周工时、积假
/// Other: w ##class(web.INMArgComm).GetPerDayArgInfo(1,"2021-03-01",0,"")
ClassMethod GetPerDayArgInfo(perId As %String = "", date As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	s:date["-" date=$zdh(date,3)
	
	s subRet="",weekHours="",yearHours=""
	i (+perId>0)&&(+date>0) d
	.s tmpRet=""
	.i appFlag'=1 s subRet=..GetPerDayArg(perId,date,0)
	.e  s tmpRet=..GetPerDayArg(perId,date,1)
	.s weekday=$zd(date,10)
	.s weekFirstDate=date-weekday+1
	.s weekLastDate=weekFirstDate+6
	.s weekHours=$p(..GetPerHour(perId,weekFirstDate,weekLastDate,1),"|",2)
	.s yearSt=+$zd(weekFirstDate,3)
	.s yearEnd=+$zd(weekLastDate,3)
	.k tmpHoliday,tmpHoliday
	.d ..setHolidayTmp(yearSt,.tmpHoliday,0)
	.d ..setHolidayTmp(yearSt,.tmpWorkDay,1)
	.d ..setHolidayTmp(yearEnd,.tmpHoliday,0)
	.d ..setHolidayTmp(yearEnd,.tmpWorkDay,1)
	.s yearHours=$p(..GetPerProHour(perId,date),"|",2)
	.d appRet.SetAt(tmpRet,"Post")
	.d appRet.SetAt(weekHours,"WeekHours")
	.d appRet.SetAt(yearHours,"YearHours")
	
	s ret=subRet_"^WeekHours|"_weekHours_"^YearHours|"_yearHours
	q:appFlag=1 appRet
	q ret
}

/// Description: 获取护士某日排班
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 日期
/// Output: 护士某日排班
/// Other: w ##class(web.INMArgComm).GetPerDayArg(1,"2021-03-01",0,"")
ClassMethod GetPerDayArg(perId As %String = "", date As %String = "", appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s:date["-" date=$zdh(date,3)
	
	s subRet=""
	i (+perId>0)&&(+date>0) d
	.s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perId,date,subId)) q:subId=""  d
	..q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	..s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	..s wardPost=$lg(subGlo,7)
	..q:wardPost=""
	..s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	..s wardPostDesc=$lg(wardPostGlo,2)
	..s stTime1=$lg(subGlo,8)
	..s endTime1=$lg(subGlo,9)
	..s stTime2=$lg(subGlo,10)
	..s endTime2=$lg(subGlo,11)
	..s stTime3=$lg(subGlo,12)
	..s endTime3=$lg(subGlo,13)
	..s remark=$lg(subGlo,14)
	..s subRet=subRet_$case(subRet,"":"",:"」")_wardPostDesc_"「"_stTime1_"「"_endTime1_"「"_stTime2_"「"_endTime2_"「"_stTime3_"「"_endTime3_"「"_remark_"「"_subId
	..s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	..d tmpRetObj.SetAt(wardPostDesc,"PostDesc")
	..d tmpRetObj.SetAt(stTime1,"StTime1")
	..d tmpRetObj.SetAt(endTime1,"EndTime1")
	..d tmpRetObj.SetAt(stTime2,"StTime2")
	..d tmpRetObj.SetAt(endTime2,"EndTime2")
	..d tmpRetObj.SetAt(stTime3,"StTime3")
	..d tmpRetObj.SetAt(endTime3,"EndTime3")
	..d tmpRetObj.SetAt(remark,"Remark")
	..d tmpRetObj.SetAt(subId,"rw")
	..d appRet.Insert(tmpRetObj)
	
	s ret="Post|"_subRet
	q:appFlag=1 appRet
	q ret
}

/// Description: 获取护士工时数
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 开始日期 结束日期 是否计算加减班
/// Output: 护士工时数
/// Other: w ##class(web.INMArgComm).GetPerHour(1,"2021-03-01","2021-03-07",1,"")
ClassMethod GetPerHour(perId As %String = "", stDate As %String = "", endDate As %String = "", plusFlag As %String = "0", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	s hours=0
	i (+perId>0)&&(+stDate>0)&&(+endDate>0) d
	.f date=stDate:1:endDate d
	..s hours=hours+..CountMinutes(perId,date,"",0)+$select(plusFlag=1:..CountMinutesPlus(perId,date,"",0),1:0)
	.s hours=$fn($fn(hours/60,"",1),"O")
	.d appRet.SetAt(hours,"Hours")
	
	s ret="Hours|"_hours
	q:appFlag=1 appRet
	q ret
}

/// Description: 获取护士工截止某日积假
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 日期
/// Output: 护士工截止某日积假
/// Other: w ##class(web.INMArgComm).GetPerProHour(1,"2021-03-01",0,"")
ClassMethod GetPerProHour(perId As %String = "", date As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	s:date["-" date=$zdh(date,3)
	
	s hours=0
	i (+perId>0)&&(+date>0) d
	.s weekday=$zd(date,10)
	.s weekFirstDate=date-weekday+1
	.s weekLastDate=weekFirstDate+6
	.s yearSt=+$zd(weekFirstDate,3)
	.s yearEnd=+$zd(weekLastDate,3)
	.k tmpHoliday,tmpHoliday
	.d ..setHolidayTmp(yearSt,.tmpHoliday,0)
	.d ..setHolidayTmp(yearSt,.tmpWorkDay,1)
	.d ..setHolidayTmp(yearEnd,.tmpHoliday,0)
	.d ..setHolidayTmp(yearEnd,.tmpWorkDay,1)
	.s hours=$fn($p(..GetArgProductHour(weekFirstDate,date,perId,.tmpHoliday,.tmpWorkDay),"^",2),"O")
	.d appRet.SetAt(hours,"Hours")
	
	s ret="Hours|"_hours
	q:appFlag=1 appRet
	q ret
}

/// Description: 获取护士加减班工时数
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 开始日期 结束日期 加减班
/// Output: 护士加减班工时数
/// Other: w ##class(web.INMArgComm).GetPerPlusHour(1,"2021-03-01","2021-03-07",1,"")
ClassMethod GetPerPlusHour(perId As %String = "", stDate As %String = "", endDate As %String = "", plusType As %String = "0", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	s hours=0
	i (+perId>0)&&(+stDate>0)&&(+endDate>0) d
	.f date=stDate:1:endDate d
	..s hours=hours+..CountMinutesPlus(perId,date,"",0,$case(plusType,1:"N",:"Y"))
	.s hours=$fn($fn(hours/60,"",1),"O")
	.d appRet.SetAt(hours,"Hours")
	
	s ret="Hours|"_hours
	q:appFlag=1 appRet
	q ret
}

/// Description: 获取护士班次次数、时数
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 人员id 开始日期 结束日期
/// Output: 护士班次次数、时数
/// Other: w ##class(web.INMArgComm).GetPerArgCount(1,"2021-03-01","2021-03-07",0,"")
ClassMethod GetPerArgCount(perId As %String = "", stDate As %String = "", endDate As %String = "", appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmp
	i (+perId>0)&&(+stDate>0)&&(+endDate>0) d
	.f date=stDate:1:endDate d
	..s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",perId,date,subId)) q:subId=""  d
	...q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	...s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	...s postHours=..GetArgSubMinutes(subId)
	...s wardPost=$lg(subGlo,27)
	...s:wardPost="" wardPost=$lg(subGlo,7)
	...i '$d(tmp(wardPost)) d
	....i wardPost="Y" s wardPostDesc="加班"
	....e  i wardPost="N" s wardPostDesc="减班"
	....e  i ('$d(tmp(wardPost)))&&(+wardPost>0) d
	.....s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPost))
	.....s wardPostDesc=$lg(wardPostGlo,2)
	....s tmp(wardPost,"Desc")=wardPostDesc
	...s tmp(wardPost)=$g(tmp(wardPost))+1
	...s tmp(wardPost,"Hours")=$g(tmp(wardPost,"Hours"))+postHours
	
	w:appFlag'=1 "["
	s index=0
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.w:(appFlag'=1)&&(index>0) ","
	.s count=tmp(id)
	.s desc=tmp(id,"Desc")
	.s hours=$fn($fn(tmp(id,"Hours")/60,"",1),"O")
	.w:appFlag'=1 "{""PostId"":"""_id_""",""PostDesc"":"""_desc_""",""Count"":"""_count_""",""Hours"":"""_hours_"""}"
	.s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	.d tmpRetObj.SetAt(id,"PostId")
	.d tmpRetObj.SetAt(desc,"PostDesc")
	.d tmpRetObj.SetAt(count,"Count")
	.d tmpRetObj.SetAt(hours,"Hours")
	.d appRet.Insert(tmpRetObj)
	.s index=index+1
	
	w:appFlag'=1 "]"
	q:appFlag=1 appRet
	q ""
}

/// Description: 获取某班次时数
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: id
/// Output: 某班次时数
/// Other: w ##class(web.INMArgComm).GetArgSubMinutes(1)
ClassMethod GetArgSubMinutes(subId As %String = "") As %String
{
	s time=0
	i +subId>0 d
	.q:'$d(^DHCINM.Arg.MgArrangeSubD(subId))
	.s subGlo=^DHCINM.Arg.MgArrangeSubD(subId)
	.f position=8,10,12 d
	..s sttime=$lg(subGlo,position),endtime=$lg(subGlo,position+1)
	..q:(sttime="")||(endtime="")
	..i sttime["次日" s sttime=$zth($e(sttime,3,*),1)+86400
	..e  s sttime=$zth(sttime,1)
	..i endtime["次日" s endtime=$zth($e(endtime,3,*),1)+86400
	..e  s endtime=$zth(endtime,1)
	..s time=time+(endtime-sttime)
	
	q time/60
}

/// Description: 获取各班次分类次数
/// Date: 2022-03-02
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 病区id nurseid
/// Output: 各班次分类次数
/// Other: d ##class(web.INMArgComm).GetArgCatData(1,"2022-03-01","2022-03-31",0,.tmpType,.tmp)
ClassMethod GetArgCatData(ward As %String = "", stDate As %String = "", endDate As %String = "", nurseid As %String = "", withRole As %String = "", ByRef tmpCat As %String = "", ByRef tmpWardCat As %String = "", ByRef tmpPerCat As %String = "", ByRef tmpPost As %String = "", ByRef tmpWardPost As %String = "", ByRef tmpPerPost As %String = "", switch As %String = "1")
{
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=1
	s:withRole=1 isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s par=$o(^CT.DHCINM.Set.MgSysParamI("Code"," POSTTYPE",""))
	k tmpCat,tmpWardCat,tmpPerCat
	i (par'="")&&((switch=1)||(switch=3)) d
	.s subCode="" f  s subCode=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode)) q:subCode=""  d
	..s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode,par,subId)) q:subId=""  d
	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(par,subId))
	...s glo=^CT.DHCINM.Set.MgSysParamSubD(par,subId)
	...s subStDate=$lg(glo,8)
	...s subEndDate=$lg(glo,9)
	...q:(subStDate="")||(subStDate>+$h)||((subEndDate'="")&&(subEndDate<+$h))
	...s tCode=$tr(subCode," ","")
	...s tmpCat(tCode)=0
	...s tmpCat(tCode,"Desc")=$lg(glo,3)
	k tmpPost
	i (switch=2)||(switch=3) d
	.s id="" f  s id=$o(^CF.DHCINM.DB.MgArgPostD(id)) q:id=""  d
	..q:(ward'="")&&('$d(^CF.DHCINM.DB.MgArgWardPostI("WardPost",ward,id)))
	..s flag=$case(isAll,1:1,:0)
	..s tWard="" f  s tWard=$o(tmpWard(tWard)) q:(flag'=0)||(tWard="")  d
	...s:$d(^CF.DHCINM.DB.MgArgWardPostI("WardPost",tWard,id)) flag=1
	..q:flag=0
	..s argPostGlo=^CF.DHCINM.DB.MgArgPostD(id)
	..s postStatus=$lg(argPostGlo,18)
	..q:postStatus'="Y"
	..s tmpPost(id)=0
	..s tmpPost(id,"Desc")=$lg(argPostGlo,3)
	
	s statusTmp(" NA")="NA",statusTmp(" ZA")="ZA",statusTmp(" HA")="HA"
	s leaveWard="" f  s leaveWard=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard)) q:leaveWard=""  d
	.q:((ward'="")&&(ward'=leaveWard))||((isAll'=1)&&('$d(tmpWard(leaveWard))))
	.d:('$d(tmpWardCat(leaveWard)))&&((switch=1)||(switch=3)) init(.tmpWardCat,leaveWard)
	.d:('$d(tmpWardPost(leaveWard)))&&((switch=2)||(switch=3)) initPost(.tmpWardPost,leaveWard)
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leavePer="" f  s leavePer=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer)) q:leavePer=""  d
	..d:('$d(tmpPerCat(leavePer)))&&((switch=1)||(switch=3)) init(.tmpPerCat,leavePer)
	..d:('$d(tmpPerPost(leavePer)))&&((switch=2)||(switch=3)) initPost(.tmpPerPost,leavePer)
	..s leaveStatus="" f  s leaveStatus=$o(statusTmp(leaveStatus)) q:leaveStatus=""  d
	...s leaveId="" f  s leaveId=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer,leaveStatus,leaveId)) q:leaveId=""  d
	....q:'$d(^DHCINM.Arg.MgLeaveAppD(leaveId))
	....s leaveGlo=^DHCINM.Arg.MgLeaveAppD(leaveId)
	....s leaveSource=$lg(leaveGlo,2)
	....q:((leaveSource="N")&&(leaveStatus'["A"))||((leaveSource="H")&&(leaveStatus'=" HA"))
	....s leaveStDate=$lg(leaveGlo,5)
	....s leaveEndDate=$lg(leaveGlo,7)
	....s leaveWorkDate=$lg(leaveGlo,29)
	....s days=0
	....f date=leaveStDate:1:leaveEndDate d
	.....q:$lf(leaveWorkDate,date)
	.....q:(date<stDate)||((endDate'="")&&(date>endDate))
	.....s days=days+1
	....s wardPostId=$lg(leaveGlo,4)
	....q:wardPostId=""
	....s wardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	....i (switch=1)||(switch=3) d
	.....s wardPostCategory=$lg(wardPostGlo,20)
	.....q:wardPostCategory=""
	.....s tmpCat(wardPostCategory)=$g(tmpCat(wardPostCategory))+days
	.....s tmpWardCat(leaveWard,wardPostCategory)=$g(tmpWardCat(leaveWard,wardPostCategory))+days
	.....s tmpPerCat(leavePer,wardPostCategory)=$g(tmpPerCat(leavePer,wardPostCategory))+days
	....e  i (switch=2)||(switch=3) d
	.....s argPostId=$lg(wardPostGlo,4)
	.....q:argPostId=""
	.....s tmpPost(argPostId)=$g(tmpPost(argPostId))+days
	.....s tmpWardPost(leaveWard,argPostId)=$g(tmpWardPost(leaveWard,argPostId))+days
	.....s tmpPerPost(leavePer,argPostId)=$g(tmpPerPost(leavePer,argPostId))+days
	
	s argWard="" f  s argWard=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard)) q:argWard=""  d
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.d:('$d(tmpWardCat(argWard)))&&((switch=1)||(switch=3)) init(.tmpWardCat,argWard)
	.d:('$d(tmpWardPost(argWard)))&&((switch=2)||(switch=3)) initPost(.tmpWardPost,argWard)
	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer)) q:argPer=""  d
	..d:('$d(tmpPerCat(argPer)))&&((switch=1)||(switch=3)) init(.tmpPerCat,argPer)
	..d:('$d(tmpPerPost(argPer)))&&((switch=2)||(switch=3)) initPost(.tmpPerPost,argPer)
	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
	...q:$p(..IsPerAskLeavel3(argPer_"^"_argDate),"^",3)'=""
	...s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate,argId)) q:argId=""  d
	....q:'$d(^DHCINM.Arg.MgArrangeSubD(argId))
	....s argGlo=^DHCINM.Arg.MgArrangeSubD(argId)
	....s wardPostId=$lg(argGlo,7)
	....q:wardPostId=""
	....q:'$d(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	....s wardPostGlo=^CF.DHCINM.DB.MgArgWardPostD(wardPostId)
	....i (switch=1)||(switch=3) d
	.....s wardPostCategory=$lg(wardPostGlo,20)
	.....q:wardPostCategory=""
	.....s tmpCat(wardPostCategory)=$g(tmpCat(wardPostCategory))+1
	.....s tmpWardCat(argWard,wardPostCategory)=$g(tmpWardCat(argWard,wardPostCategory))+1
	.....s tmpPerCat(argPer,wardPostCategory)=$g(tmpPerCat(argPer,wardPostCategory))+1
	....e  i (switch=2)||(switch=3) d
	.....s argPostId=$lg(wardPostGlo,4)
	.....q:argPostId=""
	.....s tmpPost(argPostId)=$g(tmpPost(argPostId))+1
	.....s tmpWardPost(argWard,argPostId)=$g(tmpWardPost(argWard,argPostId))+1
	.....s tmpPerPost(argPer,argPostId)=$g(tmpPerPost(argPer,argPostId))+1
	
init(tmp,key)
	s cat="" f  s cat=$o(tmpCat(cat)) q:cat=""  d
	.s tmp(key,cat)=0
	q
initPost(tmp,key)
	s post="" f  s post=$o(tmpPost(post)) q:post=""  d
	.s tmp(key,post)=0
	q
}

/// Description：查询护士排班次数列表
/// Date:2022-03-02
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期^姓名 登录人Id
/// Output:护士排班次数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArgPostList","^2022-03-01^2022-03-31",0)
Query FindArgPostList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgPostListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	d ..GetArgCatData(ward,stDate,endDate,nurseid,1,,,,.tmpPost,,,2)
	
	s id="" f  s id=$o(tmpPost(id)) q:id=""  d
	.s ret="PostId|"_id_"^PostDesc|"_$g(tmpPost(id,"Desc"))_"^Count|"_tmpPost(id)
	.d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgPostListExecute ]
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

/// Description: 根据权限获取各班次分类次数
/// Date: 2022-03-02
/// Creator: wangpf
/// Table: DHCINM.Arg.MgArrangeSub
/// Input: 病区id nurseid
/// Output: 各班次分类次数
/// Other: w ##class(web.INMArgComm).GetArgCatCount("1^2022-03-01^2022-03-31",0)
ClassMethod GetArgCatCount(parr As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	d ..GetArgCatData(ward,stDate,endDate,nurseid,1,.tmpCat)
	
	w:appFlag'=1 "["
	s ret=""
	s index=0,cat="" f  s cat=$o(tmpCat(cat)) q:cat=""  d
	.s count=tmpCat(cat)
	.s desc=$g(tmpCat(cat,"Desc"))
	.w:(appFlag'=1)&&(index>0) ","
	.w:appFlag'=1 "{""Count"":"""_count_""",""Desc"":"""_desc_"""}"
	.s tmpRet=##class(%ArrayOfDataTypes).%New()
	.d tmpRet.SetAt(count,"Count")
	.d tmpRet.SetAt(desc,"Desc")
	.s index=index+1
	.d appRet.Insert(tmpRet)
	w:appFlag'=1 "]"
	
	q:appFlag=1 appRet
	q ret
}

/// Description：查询各病区班次分类时长列表
/// Date:2022-03-02
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期 登录人Id
/// Output:各病区班次分类时长列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindWardCatCountList","^2022-03-01^2022-03-31",0)
Query FindWardCatCountList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardCatCountListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	d ..GetArgCatData(ward,stDate,endDate,nurseid,0,.tmpCat,.tmpWardCat)
	
	s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	.q:((ward'="")&&(ward'=id))||((isAll'=1)&&('$d(tmpWard(id))))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	.s wardDesc=$lg(wardGlo,4)
	.s ret="Ward|"_id_"^WardDesc|"_wardDesc
	.s cat="" f  s cat=$o(tmpCat(cat)) q:cat=""  d
	..s ret=ret_"^"_cat_"|"_$g(tmpWardCat(id,cat))
	.d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardCatCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardCatCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardCatCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardCatCountListExecute ]
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

/// Description：查询各病区护士班次分类时长列表
/// Date:2022-03-02
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期 登录人Id
/// Output:各病区护士班次分类时长列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindPerCatCountList","1^2022-03-01^2022-03-31",0)
Query FindPerCatCountList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerCatCountListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	d ..GetArgCatData(ward,stDate,endDate,nurseid,0,,,.tmpPerCat)
	
	s per="" f  s per=$o(tmpPerCat(per)) q:per=""  d
	.s perName=$lg($g(^CF.DHCINM.HR.PersonsD(per)),2)
	.s ret="Per|"_per_"^PerName|"_perName
	.s cat="" f  s cat=$o(tmpPerCat(per,cat)) q:cat=""  d
	..s ret=ret_"^"_cat_"|"_$g(tmpPerCat(per,cat))
	.d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerCatCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerCatCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerCatCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerCatCountListExecute ]
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

/// Description：查询加减班时长列表
/// Date:2022-03-02
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期 登录人Id
/// Output:加减班时长列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindPlusList","1^2022-03-01^2022-03-31",0)
Query FindPlusList(parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlusListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpType,tmp
	s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	.q:((ward'="")&&(ward'=id))||((isAll'=1)&&('$d(tmpWard(id))))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	.s wardDesc=$lg(wardGlo,4)
	.s wardAdd=0,wardDe=0
	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",id,argPer)) q:argPer=""  d
	..q:(outPerId'="")&&(outPerId'=argPer)
	..s argPerName=$lg($g(^CF.DHCINM.HR.PersonsD(argPer)),2)
	..k tmpPlus
	..s perAdd=0,perDe=0
	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",id,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
	...q:$d(tmp(argPer,argDate))
	...s tmp(argPer,argDate)=1
	...s t1=..CountMinutesPlus(argPer,argDate,id,0,"Y",.tmpPlus),t2=..CountMinutesPlus(argPer,argDate,id,0,"N",.tmpPlus)
	...s perAdd=perAdd+t1
	...s perDe=perDe+t2
	...s wardAdd=wardAdd+t1,wardDe=wardDe+t2
	..i outType=1 d
	...s ret="Ward|"_id_"^WardDesc|"_wardDesc_"^Per|"_argPer_"^PerName|"_argPerName_"^Add|"_$fn($fn(perAdd/60,"O",1),"O")_"^Deduct|"_$fn($fn(perDe/60,"O",1),"O")
	...d OutCountList
	..e  i outType=2 d
	...s plusWard="" f  s plusWard=$o(tmpPlus(plusWard)) q:plusWard=""  d
	....s plusPer="" f  s plusPer=$o(tmpPlus(plusWard,plusPer)) q:plusPer=""  d
	.....s plusDate="" f  s plusDate=$o(tmpPlus(plusWard,plusPer,plusDate)) q:plusDate=""  d
	......s plusType="" f  s plusType=$o(tmpPlus(plusWard,plusPer,plusDate,plusType)) q:plusType=""  d
	.......s ret="Ward|"_id_"^WardDesc|"_wardDesc_"^Per|"_argPer_"^PerName|"_argPerName_"^Date|"_$zd(plusDate,3)
	.......s ret=ret_"^Type|"_plusType_"^TypeDesc|"_$case(plusType,"Y":"加班","N":"减班",:"")
	.......s ret=ret_"^Times|"_$fn($fn(tmpPlus(plusWard,plusPer,plusDate,plusType)/3600,"O",1),"O")
	.......d OutCountList
	.q:+outType>0
	.s ret="Ward|"_id_"^WardDesc|"_wardDesc_"^Add|"_$fn($fn(wardAdd/60,"O",1),"O")_"^Deduct|"_$fn($fn(wardDe/60,"O",1),"O")
	.d OutCountList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCountList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlusListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlusListExecute ]
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

/// creator: wanpf
/// createdate: 2022-04-12
/// description: 保存班次备注
/// table: DHCINM.Arg.MgArrangeSub
/// input:班次Id 备注
/// output:0:失败 1:成功
/// other:w ##class(web.INMArgComm).SaveArgSubRemark("5050「测试备注」5051「测试备注")
ClassMethod SaveArgSubRemark(parr As %String = "") As %String
{
	q:parr="" 0
	s argIdList=$lfs(parr,"」")
	s sc=1
	ts
	s ptr=0 f  s status=$listnext(argIdList,ptr,value) q:(status'=1)||(sc'=1)  d
	.s id=$p(value,"「")
	.s remark=$p(value,"「",2)
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(id)
	.i '$IsObject(obj) s sc=0 q
	.s obj.ArgRemark=remark
	.s sc=obj.%Save()
	i sc'=1 {
		tro
		q 0
	}else {
		tc
		q 1
	}
}

/// creator:wangpf
/// createdate:2022-04-12
/// description:App追加排班
/// table:DHCINM.Arg.MgArrangeSub
/// input:排班表Id 行Id 护士Id 日期 病区班次Id
/// output:0:失败 1:成功
/// other: w ##class(web.INMArgComm).SaveArgSubMultiple("168^2720^19^2022-04-19^3,85",0)
ClassMethod SaveArgSubMultiple(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="")||((nurseid'=0)&&($d(^CF.DHCINM.DB.MgUserD(nurseid))#2'=1)) 0
	s argId=$p(parr,"^")
	q:(argId="")||('$d(^DHCINM.Arg.MgArrangeD(argId))) 0
	s ward=$lg(^DHCINM.Arg.MgArrangeD(argId),3)
	q:ward="" 0
	s argRowId=$p(parr,"^",2)
	q:(argRowId="")||('$d(^DHCINM.Arg.MgArrangeRowD(argRowId))) 0
	s argPerId=$p(parr,"^",3)
	q:(argPerId="")||('$d(^CF.DHCINM.HR.PersonsD(argPerId))) 0
	s argDate=$p(parr,"^",4)
	s:argDate["-" argDate=$zdh(argDate,3)
	q:+argDate=0 0
	s wardPostId=$p(parr,"^",5)
	q:wardPostId="" 0
	s curward=##class(web.INMHRComm).GetCurrentWard(argPerId,argDate)
	q:(curward'=ward)&&($lg(^DHCINM.Arg.MgArrangeRowD(argRowId),8)'="Y") 0
	
	s wardPostList=$lfs(wardPostId)
	s sc=1
	ts
	s ptr=0 f  s status=$listnext(wardPostList,ptr,value) q:(status'=1)||(sc'=1)  d
	.i (value="")||('$d(^CF.DHCINM.DB.MgArgWardPostD(value))) s sc=0 q
	.s wardPostObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(value)
	.s tparr="rw|^ArgType|^ArgPerDR|"_argPerId_"^ArgDate|"_argDate_"^ArgStTime1|"_wardPostObj.PostStTime1_"^ArgEndTime1|"_wardPostObj.PostEndTime1
	.s tparr=tparr_"^ArgStTime2|"_wardPostObj.PostStTime2_"^ArgEndTime2|"_wardPostObj.PostEndTime2_"^ArgStTime3|"_wardPostObj.PostStTime3
	.s tparr=tparr_"^ArgEndTime3|"_wardPostObj.PostEndTime3
	.s result=..CheckRepeat(tparr)
	.i result'="" s sc=result q
	.s obj=##class(DHCINM.Arg.MgArrangeSub).%New()
	.d obj.ArrangeDRSetObjectId(argId)
	.d obj.ArgRowDRSetObjectId(argRowId)
	.d obj.ArgWardDRSetObjectId(ward)
	.d obj.ArgPerDRSetObjectId(argPerId)
	.d obj.ArgPostDRSetObjectId(value)
	.s obj.ArgCategory=wardPostObj.PostDR.PostCategory
	.s obj.ArgDate=argDate
	.s obj.ArgStTime1=wardPostObj.PostStTime1
	.s obj.ArgEndTime1=wardPostObj.PostEndTime1
	.s obj.ArgStTime2=wardPostObj.PostStTime2
	.s obj.ArgEndTime2=wardPostObj.PostEndTime2
	.s obj.ArgStTime3=wardPostObj.PostStTime3
	.s obj.ArgEndTime3=wardPostObj.PostEndTime3
	.i wardPostObj.PostDR.PostType="H" s obj.ArgHolidayTime="H"
	.e  s obj.ArgHolidayTime=""
	.s obj.ArgEditUser=nurseid
	.s obj.ArgEditDate=+$h
	.s obj.ArgEditTime=$P($h,",",2)
	.s sc=obj.%Save()
	i sc=1 {
		tc
		q 1
	}else {
		tro
		q sc
	}
}

/// Creator:liwenzhen
/// Createdate:2022-02-08 14:30:54
/// Description:
/// Input:
/// Output:
/// Other:
/// Test:d $classmethod("web.INMArgComm","GetArrangeLook","1^2022-05-01^2022-05-31")
ClassMethod GetArrangeLook(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %String
{
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	q:(ward="")!(stdate="")!(enddate="") ""
	//设置假期tmp、班tmp
	s stYear=$p($zd(stdate),"-",1)
	s endYear=$p($zd(enddate),"-",1)
	f year=stYear:1:endYear d
	.d ..setHolidayTmp(year,.tmpHoliday,0)
	.d ..setHolidayTmp(year,.tmpWorkDay,1)
	//每日标准工作时长
	s step=+$lg(^CT.DHCINM.Set.MgArgParamSetD(1),17)
	s:step=0 step=7
	//总应工作时长
	s standardHour=0
	f date=stdate:1:enddate d
	.s weekNum=$zd(date,10)
	.i (weekNum=6)||(weekNum=0) d
	..s:$g(tmpWorkDay(date))'="" standardHour=standardHour+step
	.e  d
	..s:$g(tmpHoliday(date))="" standardHour=standardHour+step
	
	s CountStatus="N,S,R,A,B" //统计状态
	;s CountStatus="R"
	s:CountStatus="R" countType=1
	s:CountStatus'="R" countType=0
	s CountStatus=$lfs(CountStatus,",")
	
	s CountOnlyCurWard=0 //是否只统计当前病区 0：否 1：是
	s:CountOnlyCurWard=0 countWard=""
	s:CountOnlyCurWard=1 countWard=ward

	
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCINM.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s BgColor="",FontColor=""
	k tmpPer,tmpHour
	s perdr="" f  s perdr=$O(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,perdr)) q:perdr=""  d
	.s perobj=$g(^CF.DHCINM.HR.PersonsD(perdr))
	.q:perobj=""
	.s isHasArg=0
	.f date=stdate:1:enddate d
	..s curward=""
	..i $d(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,perdr,date))=0 d
	...s curward=##class(web.INMHRComm).GetCurrentWard(perdr,date)
	...i ((curward'="")&&(curward'=ward)) d
	....s curwardObj=$g(^CF.DHCINM.DB.MgWardD(curward))
	....s wardDesc=$lg(curwardObj,4)
	....s tmpPer(perdr,date,curward,"PostDesc")=wardDesc
	....s tmpPer(perdr,date,curward,"Type")="W" //数据来源：转科病区
	..q:(curward'="")&&(curward'=ward) //优先显示病区
	..s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,perdr,date,id)) q:id=""  d
	...s obj=$g(^DHCINM.Arg.MgArrangeSubD(id))
	...s argStatus=$lg($g(^DHCINM.Arg.MgArrangeD($lg(obj,2))),7)
	...q:'$lf(CountStatus,argStatus)
	...s isHasArg=1 
	...s ArgPostDR=$lg(obj,7)
	...s ArgType=$lg(obj,27)
	...q:((ArgPostDR="")&&(ArgType'="Y")&&(ArgType'="N"))
	...//获取班次描述
	...i (ArgType="Y")||(ArgType="N") d //加减班
	....s ArgStTime1=$lg(obj,8)
	....s ArgEndTime1=$lg(obj,9)
	....s PostDesc=$fn(($zth(ArgEndTime1,1)-$zth(ArgStTime1,1))/3600,"",1)
	....s:ArgType="N" PostDesc="-"_PostDesc
	...e  d
	....s WardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(ArgPostDR))
	....s PostDesc=$lg(WardPostGlo,2)
	...s ArgRemark=$lg(obj,14)
	...s tmpPer(perdr,date,id,"PostDesc")=PostDesc_ArgRemark
	...//获取班次颜色
	...d GetPostInfo
	...s tmpPer(perdr,date,id,"BgColor")=BgColor
	...s tmpPer(perdr,date,id,"FontColor")=FontColor
	...s tmpPer(perdr,date,id,"Type")="A" //数据来源：排班表
	.k:isHasArg=0 tmpPer(perdr) //本周期内本病区无排班，不显示
	
	s perSort=0
	s list=##class(%ListOfDataTypes).%New()
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s grpobj=""
	...s groupDesc="未分组",bedCodes="",groupMaster="",groupBedGroup=""
	...s rowData=##class(%ArrayOfDataTypes).%New()
	...i grptyp="G" d //分组行数据
	....s nurGroupGlo=$g(^DHCINM.Arg.MgNurGroupD(grp))
	....i nurGroupGlo'="" d
	.....s groupDesc=$lg(nurGroupGlo,3)
	.....s groupBedGroup=$lg(nurGroupGlo,6)
	.....s groupMaster=$lg(nurGroupGlo,4)
	...i (grptyp="A") d
	....s argGroupGlo=$g(^DHCINM.Arg.MgArrangeGroupD(grp))
	....i argGroupGlo'="" d
	.....s groupDesc=$lg(argGroupGlo,4)
	.....s groupBedGroup=$lg(argGroupGlo,6)
	.....s groupMaster=$lg(argGroupGlo,5)
	...f i=1:1:$ll(groupBedGroup) d
	......s bedId=$lg(groupBedGroup,i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	...d rowData.SetAt(groupDesc,"PerName")
	...d rowData.SetAt(grp,"ArgGroupDR")
	...d rowData.SetAt(bedCodes,"BedCodes")
	...d list.Insert(rowData)
	...//护士行数据信息
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....;q:$d(tmpPer(perdr))=0 //本周期内本病区无排班，不显示
	.....d GetPerRow
	.....k tmpPer(perdr)

	/// 输出本病区之外的人
	s perdr="" f  s perdr=$o(tmpPer(perdr)) q:perdr=""  d GetPerRow
	w ##class(DHCINM.WebService.INMAppCommon).Encode(list)
	q ""

GetPostInfo
	s BgColor=""
	s FontColor=""
	q:WardPostGlo=""
	s argPostDR=$lg(WardPostGlo,4)
	s argPostGlo=$g(^CF.DHCINM.DB.MgArgPostD(argPostDR))
	s BgColor=$lg(argPostGlo,16)
	s FontColor=$lg(argPostGlo,15)
	q
GetPersonInfo
	s perGlo=$g(^CF.DHCINM.HR.PersonsD(perdr))
	q:perGlo=""
	s perWorkDate=$lg(perGlo,14)
	s workYear=""
	s:perWorkDate'="" workYear=$P(##class(web.INMVueComm).CalAge($zd(perWorkDate,3),$zd(+$H,3)),"Y",1)
	s nurInfo=..GetNurseLevel(stdate,perdr) 
	s roledesc=""
	s roledesc=$p(nurInfo,"^",2)
	i $lg(perGlo,25)="S" s roledesc="◇"
	s:..IsPerOutTrain(perdr_"^"_stdate) roledesc="○" //进修标识
	s:groupMaster=perdr roledesc="★"
	s dutydesc=$p(##class(web.INMHRComm).GetNurseDuty(perdr,+$h),"^",2)
	s:dutydesc["护士长" roledesc="@"
	s leveldesc=$P(nurInfo,"^",1) //层级
	s perPost=$p(##class(web.INMHRComm).GetNurseHireDuty(perdr,+$h),"^",2) //职称
	s perName=$lg(perGlo,2)
	s perID=$lg(perGlo,3)
	s showPerName=roledesc_perName_perID
	s perSort=perSort+1
	d rowData.SetAt(perSort,"PerSort")
	d rowData.SetAt(perdr,"ArgPerDR")
	d rowData.SetAt(showPerName,"PerName")
	d rowData.SetAt(perName,"RealPerName")
	d rowData.SetAt(perID,"PerID")
	d rowData.SetAt(workYear,"WorkYear")
	d rowData.SetAt(leveldesc,"LevelDesc")
	d rowData.SetAt(perPost,"PerPost")
	d rowData.SetAt(groupDesc,"GroupDesc")
	s totalMinute=$g(tmpHour(perdr,"TotalMinute"))
	s argProductHour=$fn(totalMinute/60-standardHour,"",1)
	s argTotalHour=(totalMinute\60)_"时"_(totalMinute#60)_"分"
	d rowData.SetAt(argTotalHour,"ArgTotalHour")
	d rowData.SetAt(argProductHour,"ArgProductHour")
	q
GetPerRow
	s rowData=##class(%ArrayOfDataTypes).%New()
	f date=stdate:1:enddate d
	.s dateList=##class(%ListOfDataTypes).%New()
	.//计算周期内工作时长
	.s tmpHour(perdr,"TotalMinute")=$g(tmpHour(perdr,"TotalMinute"))+..CountMinutes(perdr,date,countWard,countType)+..CountMinutesPlus(perdr,date,countWard,countType)
	.s argId="" f  s argId=$o(tmpPer(perdr,date,argId)) q:argId=""  d
	..s argArray=##class(%ArrayOfDataTypes).%New()
	..d argArray.SetAt(argId,"ArgId")
	..s prop="" f  s prop=$o(tmpPer(perdr,date,argId,prop)) q:prop=""  d
	...d argArray.SetAt($g(tmpPer(perdr,date,argId,prop)),prop)
	..d dateList.Insert(argArray)
	.//获取请假表
	.i dateList.Count()=0 d
	..s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	..s leaveFlag=$p(tmpIsAskLeave,"^",1)
	..s leavePostId=$p(tmpIsAskLeave,"^",3)
	..i leaveFlag=1 d
	...s color=..GetWardPostColor(leavePostId)
	...s FontColor=$p(color,"」",1)
	...s BgColor=$p(color,"」",2)
	...s PostDesc=$p(tmpIsAskLeave,"^",2)
	...s argArray=##class(%ArrayOfDataTypes).%New()
	...d argArray.SetAt(leavePostId,"ArgId")
	...d argArray.SetAt(FontColor,"FontColor")
	...d argArray.SetAt(BgColor,"BgColor")
	...d argArray.SetAt(PostDesc,"PostDesc")
	...d argArray.SetAt("L","Type")
	...d dateList.Insert(argArray)
	.d rowData.SetAt(dateList,"Date"_$zd(date,3))
	d GetPersonInfo
	d list.Insert(rowData)
	q
}

/// Creator:liwenzhen
/// Createdate:2022-05-15
/// Description:获取某人当天所有排班
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindArrangeDate","22^2022-05-31","",0)
Query FindArrangeDate(parr As %String = "", input As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindArrangeDateExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s perDR=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	
	s input=$zcvt(input,"U")
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s par=$o(^CT.DHCINM.Set.MgSysParamI("Code"," POSTTYPE",""))
	s tmpType=""
	i par'="" d
	.k tmpType
	.s subCode="" f  s subCode=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode)) q:subCode=""  d
	..s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",subCode,par,subId)) q:subId=""  d
	...s paramSubGlo=^CT.DHCINM.Set.MgSysParamSubD(par,subId)
	...q:paramSubGlo=""
	...s tmpType($lg(paramSubGlo,2))=$lg(paramSubGlo,3)
	
	s id="" f  s id=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perDR,date,id)) q:id=""  d 
	.s argSubGlo=$g(^DHCINM.Arg.MgArrangeSubD(id))
	.s wardDR=$lg(argSubGlo,4)
	.q:(isAll'=1)&&('$d(tmpWard(wardDR)))
	.s WardDesc=$lg(^CF.DHCINM.DB.MgWardD(wardDR),4)
	.s ArgCategory=$lg(argSubGlo,22) //排班明细班次分类
	.s ArgPostDR=$lg(argSubGlo,7)
	.s PostType=""
	.i (ArgCategory="")&&(ArgPostDR'="") d
	..s argPostGlo=$g(^CF.DHCINM.DB.MgArgPostD($lg(^CF.DHCINM.DB.MgArgWardPostD(ArgPostDR),4)))
	..s:argPostGlo'="" ArgCategory=$g(tmpType($lg(argPostGlo,4)))
	.s:ArgCategory'="" PostType=$g(tmpType(ArgCategory))
	.i ArgPostDR="" d
	..s ArgType=$lg(argSubGlo,27)
	..s:ArgType="Y" PostType="加班",PostDesc="加班"
	..s:ArgType="N" PostType="减班",PostDesc="减班"
	.e  d
	..s ArgPostDR=$lg(argSubGlo,7)
	..s WardPostGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(ArgPostDR))
	..s PostDesc=$lg(WardPostGlo,2)
	.s PostRemarks=$lg(argSubGlo,14)
	.s WorkTimeList=##class(%ListOfDataTypes).%New()
	.s WorkTime1=$lg(argSubGlo,8)_"-"_$lg(argSubGlo,9)
	.d:WorkTime1'="-" WorkTimeList.Insert(WorkTime1)
	.s WorkTime2=$lg(argSubGlo,10)_"-"_$lg(argSubGlo,11)
	.d:WorkTime2'="-" WorkTimeList.Insert(WorkTime2)
	.s WorkTime3=$lg(argSubGlo,12)_"-"_$lg(argSubGlo,13)
	.d:WorkTime3'="-" WorkTimeList.Insert(WorkTime3)
	.s WorkTime=""
	.s ArgHolidayTime=$lg(argSubGlo,18)
	.s ArgHolidayTime=$case(ArgHolidayTime,"A":"上午","P":"下午","H":"全天",:"全天")
	.s:ArgCategory="H" WorkTime=ArgHolidayTime
	.f i=1:1:WorkTimeList.Count() d
	..s WorkTime=$select(i>1:WorkTime_",",1:"")_WorkTimeList.GetAt(i)
	.s ret="WardDesc|"_WardDesc_"^PostType|"_PostType_"^PostDesc|"_PostDesc_"^PostRemarks|"_PostRemarks
	.s ret=ret_"^ArgSubId|"_id_"^WorkTime|"_WorkTime
	.d OutPost
	s tmpIsAskLeave=..IsPerAskLeavel3(perDR_"^"_date)
	s leaveFlag=$p(tmpIsAskLeave,"^",1)
	s leavePostId=$p(tmpIsAskLeave,"^",3)
	i leaveFlag=1 d
	.s leaveId=$p(tmpIsAskLeave,"^",4)
	.s (WardDesc,PostRemarks)=""
	.i leaveId'="" d
	..s leaveGlo=$g(^DHCINM.Arg.MgLeaveAppD(leaveId))
	..s WardDesc=$lg(^CF.DHCINM.DB.MgWardD($lg(leaveGlo,3)),4)
	..s PostRemarks=$lg(leaveGlo,9)
	.s PostType="进修"
	.s:leavePostId'="" PostType=$g(tmpType("H"))
	.s PostDesc=$p(tmpIsAskLeave,"^",2)
	.s WorkTime="全天"
	.s ret="WardDesc|"_WardDesc_"^PostType|"_PostType_"^PostDesc|"_PostDesc_"^PostRemarks|"_PostRemarks
	.s ret=ret_"^LeaveId|"_leaveId_"^WorkTime|"_WorkTime
	.d OutPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description：查询护士工作日周末工时数列表
/// Date:2022-04-22
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 病区^开始日期^结束日期^姓名 登录人Id
/// Output:护士工作日周末工时数列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMArgComm","FindWeekArgList","1^2020-06-01^2020-06-30^",0)
Query FindWeekArgList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWeekArgListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
 	s repid=$I(^CacheTemp)
 	s ind=1
 	
 	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s ward=$p(parr,"^")
 	s stDate=$p(parr,"^",2)
 	s:stDate["-" stDate=$zdh(stDate,3)
 	s:stDate="" stDate=$o(^DHCINM.Arg.MgArrangeSubI("Date",""))
 	s endDate=$p(parr,"^",3)
 	s:endDate["-" endDate=$zdh(endDate,3)
 	s:endDate="" endDate=$o(^DHCINM.Arg.MgArrangeSubI("Date",""),-1)
 	s input=$p(parr,"^",4)
 	
 	s yearSt=$p($zd(stDate,3),"-",1)
	s yearEnd=$p($zd(endDate,3),"-",1)
	s sc=..setHolidayTmp(yearSt,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearSt,.tmpWorkDay,1)
	s sc=..setHolidayTmp(yearEnd,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearEnd,.tmpWorkDay,1)
 	
 	k tmpWard
 	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
 	
 	k tmpDinner
 	s argWard="" f  s argWard=$o(^CF.DHCINM.DB.MgWardD(argWard)) q:argWard=""  d
 	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
 	.s wardGlo=^CF.DHCINM.DB.MgWardD(argWard)
 	.s wardStDate=$lg(wardGlo,11)
 	.s wardEndDate=$lg(wardGlo,12)
 	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
 	.s argWardDesc=$lg(wardGlo,4)
 	.s argPer="" f  s argPer=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer)) q:argPer=""  d
 	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
 	..s argPerName=$lg(perGlo,2)
 	..s argPerId=$lg(perGlo,3)
 	..q:(input'="")&&(argPerName_argPerId'[input)
 	..s argPerLevel=$p(##class(web.INMHRComm).GetNurseLevel(argPer,+$h),"^",2)
 	..s workDay=0,weekDay=0,dinner=0
 	..s argDate=stDate-1 f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",argWard,argPer,argDate)) q:(argDate="")||((endDate'="")&&(argDate>endDate))  d
 	...s hour=..GetPerHour(argPer,argDate,argDate,1) ;app中新加的方法 没有的话先更新app
 	...i $zd(argDate,10)#6<1 d
 	....s tHour=+$p(hour,"|",2)
 	....s weekDay=weekDay+tHour
 	....q:$d(tmpWorkDay(argDate))||$d(tmpDinner(argPer,argDate))||(tHour<=0)
 	....s dinner=dinner+1
 	....s tmpDinner(argPer,argDate)=1
 	...e  d
 	....s tHour=+$p(hour,"|",2)
 	....s workDay=workDay+tHour
 	....q:'$d(tmpHoliday(argDate))||$d(tmpDinner(argPer,argDate))||(tHour<=0)
 	....s dinner=dinner+1
 	....s tmpDinner(argPer,argDate)=1
 	..s ret="Nurse|"_argPer_"^NurseName|"_argPerName_"^NurseLevel|"_argPerLevel_"^Ward|"_argWard_"^WardDesc|"_argWardDesc
 	..s ret=ret_"^WorkDay|"_workDay_"^WeekDay|"_weekDay_"^Dinner|"_dinner
 	..d OutCountList
 	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutCountList
 	set Data=$lb(ret)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
  	q
}

ClassMethod FindWeekArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWeekArgListExecute ]
{
 	Set repid=$LIST(qHandle,2)
  	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindWeekArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWeekArgListExecute ]
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

/// Description：循环上下移人
/// Date:2022-04-08
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrange DHCINM.Arg.MgArrangeRow DHCINM.Arg.MgArrangeSub
/// Input: 排班表信息 排班行信息 移动人员 类型
/// Output:0:失败 1:成功
/// w ##class(web.INMArgComm).CirculateArgPer("")
ClassMethod CirculateArgPer(parr1 As %String = "", parr2 As %String = "", persons As %String = "", type As %String = "")
{
 	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
 	s length=$l(persons,",")
 	q:length<2 0
 	s argid=..SaveArrange(parr1)
 	q:+argid=0 0
 	s argrowid=..SaveArgRows(parr1,parr2)
 	q:+argrowid=0 0
 	s flag=1
 	s start=2,step=1,end=length,special=1
 	s:type="D" start=length-1,step=-1,end=1,special=length
 	s specialPer=$p(persons,",",special)
 	s specialRowId=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,specialPer,""))
 	q:specialRowId="" 0
 	s specialRowObj=##class(DHCINM.Arg.MgArrangeRow).%OpenId(specialRowId)
 	q:'$IsObject(specialRowObj) 0
 	s specialRowArray=##class(%ArrayOfDataTypes).%New()
 	s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeRow","a",p)) q:p=""  d
 	.q:p["%"
 	.q:p="ArgPerSort"
 	.q:p="ArgGroupDR"
 	.d specialRowArray.SetAt($ZOBJPROPERTY(specialRowObj,p),p)
 	s specialRowObj=""
 	k tmp
 	s perList=$lfs(persons),ptr=0 f  s status=$listnext(perList,ptr,perId) q:(status'=1)||(flag'=1)  d
 	.i perId="" s flag=0 q
 	.s perRowId=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perId,""))
 	.i perRowId="" s flag=0 q
 	.s tmp(perId)=perRowId
 	q:flag'=1 0
 	ts
 	f i=start:step:end q:flag'=1  d
 	.s perId1=$p(persons,",",i)
 	.i perId1="" s flag=0 q
 	.s id1=tmp(perId1)
 	.i id1="" s flag=0 q
 	.s obj1=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id1)
 	.i '$IsObject(obj1) s flag=0 q
 	.i '$IsObject(obj1.ArgPerDR) s flag=0 q
 	.s perId2=$p(persons,",",i-step)
 	.i perId2="" s flag=0 q
 	.s id2=tmp(perId2)
 	.i id2="" s flag=0 q
 	.s obj2=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id2)
 	.i '$IsObject(obj2) s flag=0 q
 	.i '$IsObject(obj2.ArgPerDR) s flag=0 q
 	.s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeRow","a",p)) q:p=""  d
 	..q:p["%"
 	..q:p="ArgPerSort"
 	..q:p="ArgGroupDR"
 	..s $ZOBJPROPERTY(obj2,p)=$ZOBJPROPERTY(obj1,p)
 	.s sc=obj2.%Save()
 	.s flag=$$$ISOK(sc)
 	.s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id2,date)) q:(date="")||(flag'=1)  d
 	..s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id2,date,subId)) q:(subId="")||(flag'=1)  d
 	...s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
 	...q:'$IsObject(subObj)
 	...q:'$IsObject(subObj.ArgPerDR)
 	...s ward=##class(web.INMHRComm).GetCurrentWard(perId1,date)
 	...s:(ward="")||('$IsObject(subObj.ArgWardDR))||(ward'=subObj.ArgWardDR.%Id()) flag=0
 	...q:flag'=1
 	...d subObj.ArgPerDRSetObjectId(perId1)
 	...s sc=subObj.%Save()
 	...s flag=$$$ISOK(sc)
 	.q:i'=end
 	.s p="" f  s p=$O(^oddCOM("DHCINM.Arg.MgArrangeRow","a",p)) q:p=""  d
 	..q:p["%"
 	..q:p="ArgPerSort"
 	..q:p="ArgGroupDR"
 	..s $ZOBJPROPERTY(obj1,p)=specialRowArray.GetAt(p)
 	..s sc=obj1.%Save()
 	..s flag=$$$ISOK(sc)
 	.s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id1,date)) q:(date="")||(flag'=1)  d
 	..s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id1,date,subId)) q:(subId="")||(flag'=1)  d
 	...s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
 	...q:'$IsObject(subObj)
 	...q:'$IsObject(subObj.ArgPerDR)
 	...s ward=##class(web.INMHRComm).GetCurrentWard(specialPer,date)
 	...s:(ward="")||('$IsObject(subObj.ArgWardDR))||(ward'=subObj.ArgWardDR.%Id()) flag=0
 	...q:flag'=1
 	...d subObj.ArgPerDRSetObjectId(specialPer)
 	...s sc=subObj.%Save()
 	...s flag=$$$ISOK(sc)
 	if flag=1{
 		tc	
 		q 1
 	}else {
 		tro
 		q 0
 	}
}

/// Description：循环上下移班
/// Date:2022-04-11
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 排班表信息 排班行信息 移动人员 类型
/// Output:0:失败 1:成功
/// w ##class(web.INMArgComm).CirculateArgPost("")
ClassMethod CirculateArgPost(parr1 As %String = "", parr2 As %String = "", persons As %String = "", type As %String = "")
{
 	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
 	s length=$l(persons,",")
 	q:length<2 0
 	s argid=..SaveArrange(parr1)
 	q:+argid=0 0
 	s argrowid=..SaveArgRows(parr1,parr2)
 	q:+argrowid=0 0
 	s flag=1
 	s start=2,step=1,end=length,special=1
 	s:type="D" start=length-1,step=-1,end=1,special=length
 	s specialPer=$p(persons,",",special)
 	s specialRowId=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,specialPer,""))
 	q:specialRowId="" 0
 	k tmp
 	s argDate="" f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,specialRowId,argDate)) q:argDate=""  d
 	.s argSubId="" f  s argSubId=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,specialRowId,argDate,argSubId)) q:argSubId=""  d
 	..s tmp(argSubId)=argDate
 	q:flag'=1 0
 	ts
 	f i=start:step:end q:flag'=1  d
 	.s perId1=$p(persons,",",i)
 	.i perId1="" s flag=0 q
 	.s id1=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perId1,""))
 	.i id1="" s flag=0 q
 	.s obj1=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id1)
 	.i '$IsObject(obj1) s flag=0 q
 	.i '$IsObject(obj1.ArgPerDR) s flag=0 q
 	.s perId2=$p(persons,",",i-step)
 	.i perId2="" s flag=0 q
 	.s id2=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argid,perId2,""))
 	.i id2="" s flag=0 q
 	.s obj2=##class(DHCINM.Arg.MgArrangeRow).%OpenId(id2)
 	.i '$IsObject(obj2) s flag=0 q
 	.i '$IsObject(obj2.ArgPerDR) s flag=0 q
 	.s date="" f  s date=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id1,date)) q:(date="")||(flag'=1)  d
 	..s subId="" f  s subId=$o(^DHCINM.Arg.MgArrangeSubI("Arrange",argid,id1,date,subId)) q:(subId="")||(flag'=1)  d
 	...s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
 	...q:'$IsObject(subObj)
 	...q:'$IsObject(subObj.ArgPerDR)
 	...s ward=##class(web.INMHRComm).GetCurrentWard(perId2,date)
 	...s:(ward="")||('$IsObject(subObj.ArgWardDR))||(ward'=subObj.ArgWardDR.%Id()) flag=0
 	...q:flag'=1
 	...d subObj.ArgRowDRSetObjectId(id2)
 	...d subObj.ArgPerDRSetObjectId(perId2)
 	...s sc=subObj.%Save()
 	...s flag=$$$ISOK(sc)
 	.q:i'=end
 	.s subId="" f  s subId=$o(tmp(subId)) q:(subId="")||(flag'=1)  d
 	..s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
 	..q:'$IsObject(subObj)
 	..q:'$IsObject(subObj.ArgPerDR)
 	..s ward=##class(web.INMHRComm).GetCurrentWard(perId1,subObj.ArgDate)
 	..s:(ward="")||('$IsObject(subObj.ArgWardDR))||(ward'=subObj.ArgWardDR.%Id()) flag=0
 	..q:flag'=1
 	..d subObj.ArgRowDRSetObjectId(id1)
 	..d subObj.ArgPerDRSetObjectId(perId1)
 	..s sc=subObj.%Save()
 	..s flag=$$$ISOK(sc)
 	if flag=1{
 		tc	
 		q 1
 	}else {
 		tro
 		q 0
 	}
}

/// Description：排版套删除
/// Date:2022-04-11
/// Creator:wangpf
/// Table:DHCINM.Arg.MgArrangeSub
/// Input:
/// Output:
ClassMethod DelComb(id As %String = "") As %String
{
 	q:id="" 0
 	s sc=##class(DHCINM.Arg.MgPostComb).%DeleteId(id)
 	q $$$ISOK(sc)
}

}
