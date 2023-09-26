/// 
/// 优良事件公共类
Class web.MgNurExcellentComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.MgNurExcellentComm","FindWardData","")
Query FindWardData(parr As %String, input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardDataExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "", role As %String, nurseid As %String) As %Status
{
	s ^TMP("FindWardData")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	
	do OutputWardData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardDataExecute ]
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

ClassMethod FindWardDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getWardPatients(wardID As %String) As %String
{
	s ^TMP("getWardPatients")=wardID
	q:wardID="" "[]"
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(wardID)
	q:'$IsObject(wardobj) "[]"
	q:wardobj.CTLocDR="" "[]"
	s ctLocID=wardobj.CTLocDR.%Id()
	s pacWardID=$o(^PAWARD(0,"WARD_LocationDR",ctLocID,""))
	q:pacWardID="" "[]"
	w "["
	s n=0
	s roomId=0 f  s roomId=$o(^PAADMi("CurrWard",pacWardID,roomId)) q:roomId=""  d
	.s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",pacWardID,roomId,episodeID)) q:episodeID=""  d
	..s pavisit=$p($g(^PAADM(episodeID)),"^",20)
	..i pavisit'="A" q
	..s admType=$p(^PAADM(episodeID),"^",2)
	..q:admType'="I"
	..s bedSub=$p($g(^PAADM(episodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
	..q:bedCode=""
	..s paPatMasID=$P($g(^PAADM(episodeID)),"^",1)
	..s patName=$p($g(^PAPER(paPatMasID,"ALL")),"^",1) //病人姓名
	..s patMedical=$p($g(^PAPER(paPatMasID,"PAT",1)),"^",22) //住院号
	..s n=n+1
	..i n=1 w "{""patName"":"""_patName_""",""patMedical"":"""_patMedical_""",""episodeID"":"""_episodeID_"""}"
	..e  w ",{""patName"":"""_patName_""",""patMedical"":"""_patMedical_""",""episodeID"":"""_episodeID_"""}"
	w "]"
	q ""
}

ClassMethod GetLevel(roleId As %String) As %String
{
	q:roleId="" ""
	s level="",result=""
	f i=1:1:$l(roleId,",") d
	.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($p(roleId,",",i))
	.q:'$IsObject(roleObj)
	.i level="" s level=roleObj.RoleLevel
	.e  i roleObj.RoleLevel<level s level=roleObj.RoleLevel
	s tmp=$lb("nurse","nurhead","znurhead","hlb"),ptr=0
	while($listnext(tmp,ptr,value))
	{
		s roleid=$o(^DHCNMG.Set.MgRolesI("code"," Y"," "_$zcvt(value,"U"),""))
		i roleid="" s tmpLevel(value)=""
		e  d
		.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
		.i '$IsObject(roleObj) s tmpLevel(value)="" q
		.s tmpLevel(value)=roleObj.RoleLevel
	}
	i level<=tmpLevel("hlb") s result=3
	e  i level<=tmpLevel("znurhead") s result=2
	e  i level<=tmpLevel("nurhead") s result=1
	e  i level<=tmpLevel("nurse") s result=0
	q result
}

ClassMethod GetHighRoleId(nurseid As %String) As %String
{
	q:nurseid="" ""
	s level="",result=""
	s nurseObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	q:'$IsObject(nurseObj) ""
	q:##class(web.NurMgPersonComm).GetCommCode(nurseObj.PerStatus)'["在职" ""
	s roleId="" f  s roleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId)) q:roleId=""  d
	.s nurRoleId="" f  s nurRoleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId,nurRoleId)) q:nurRoleId=""  d
	..s nurRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRoleId)
	..q:('$IsObject(nurRoleObj))||(nurRoleObj.RoleStDate="")||(nurRoleObj.RoleStDate>+$h)||((nurRoleObj.RoleEndDate'="")&&(nurRoleObj.RoleEndDate<+$h))
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($tr(roleId," ",""))
	..q:('$IsObject(roleObj))||(roleObj.RoleStatus'="Y")
	..i level="" s level=roleObj.RoleLevel,result=roleObj.%Id()
	..e  i roleObj.RoleLevel<level s level=roleObj.RoleLevel,result=roleObj.%Id()
	q result
}

ClassMethod SaveExcellent(parr As %String, CreateUser As %String, type As %String) As %String
{
	s ^TMP("SaveExcellent")=parr
	q:(CreateUser="")||(type="") 0
	s correct=$lb("N","Y")
	q:$lf(correct,type)=0 0
	s parr=$replace(parr,$c(10),"")
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	;s level=..GetLevel($g(tmp("roles")))
	s level=..GetLevel(..GetHighRoleId(CreateUser))
	q:level="" 0
	//护士长 科护士长 护理部提交数据自动置本级审核(A)状态
	s:(level>0)&&(type="Y") type="A"
	s id=$g(tmp("RowID"))
	i id=""
	{
		s obj=##class(DHCNMG.Event.MgExcellent).%New()
		q:'$IsObject(obj) 0
	}
	else
	{
		s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
		q:'$IsObject(obj) 0	
		//修改提交操作 只能修改提交自己创建的 保存或驳回状态的
		q:((type'="N")&&(type'="Y"))||(CreateUser'=obj.ExcellentUser)||((obj.Status'="N")&&(obj.Status'="O")) 0
	}
	i $g(tmp("excellentDate"))'="" s obj.ExcellentDate=$zdh($p($g(tmp("excellentDate"))," ",1),3)
	i $p($g(tmp("excellentDate"))," ",2)'="" s obj.ExcellentTime=$zth($p($g(tmp("excellentDate"))," ",2),1)
	s obj.ExcellentNurse=$g(tmp("excellentNurse"))
	s obj.ExcellentWard=$g(tmp("excellentWard"))
	s obj.ExcellentUser=CreateUser
	s obj.ExcellentPat=$g(tmp("excellentPat"))
	s obj.ExcellentProcess=$g(tmp("excellentProcess"))
	s obj.ExcellentGrade=$g(tmp("excellentGrade"))
	i $g(tmp("GradeDate"))'="" s obj.GradeDate=$zdh(tmp("GradeDate"),3)
	e  s obj.GradeDate=""
	s obj.Opinion=$g(tmp("Opinion"))
	s obj.Status=type
	s obj.ExcellentHandle=level
	s obj.ExcellentPatNo=$g(tmp("excellentPatNo"))
	s obj.ExcellentSolve=$g(tmp("excellentSolve"))
	s obj.ExcellentIntro=$g(tmp("excellentIntro"))
	s obj.ExcellentTitle=$g(tmp("excellentTitle"))
	s obj.ExcellentHandle=level
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.MgNurExcellentComm","FindExcellentList","")
Query FindExcellentList(parr As %String, input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindExcellentListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "", role As %String, nurseid As %String) As %Status
{
	s ^TMP("FindExcellentList")=parr //2018-07-31^2018-07-31^N
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret="",ret1=""
	s stdate=$p(parr,"^",1)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",2)
	i enddate'="" s enddate=$zdh(enddate,3)
	s Status=$p(parr,"^",3)
	s wardIdIn=$p(parr,"^",4)
	s len=$l(role,"^")
	i role=0
	{
		s status="" f  s status=$o(^DHCNMG.Event.MgExcellentI("status",status)) q:status=""  d
		.q:(Status'="")&&($tr(status," ","")'=Status)
		.s ward="" f  s ward=$O(^DHCNMG.Event.MgExcellentI("status",status,ward)) q:ward=""  d
		..q:(wardIdIn'="")&&(wardIdIn'=$tr(ward," ",""))
		..s rowid="" f  s rowid=$O(^DHCNMG.Event.MgExcellentI("status",status,ward,rowid)) q:rowid=""  d
		...s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
		...q:'$IsObject(obj)
		...d travelExcData
	}
	else
	{
		f i=1:1:len
		{
			s roleitm=$p(role,"^",i)
			i roleitm="" continue
			s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleitm)
			q:'$IsObject(RoleObj)
			s rolecode=RoleObj.RoleCode
			i rolecode="nurse"
			{
				d travelSelfExcData
			}
			elseif (rolecode="nurhead")||(rolecode="znurhead")
			{
				s par="" f  s par=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,par)) q:par=""  d
				.s limSubId="" f  s limSubId=$O(^DHCNMG.DB.MgDataLimitSubD(par,limSubId)) q:limSubId=""  d
				..s limitobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(par_"||"_limSubId)
				..q:('$IsObject(limitobj))||((wardIdIn'="")&&(wardIdIn'=limitobj.SubWard))
				..;护士长查看护士(0)提交(Y) 科护士长查看护士长(1)审核(A)
				..s level=..GetLevel(roleitm)
				..q:level=""
				..s level=level-1
				..s rowid="" f  s rowid=$o(^DHCNMG.Event.MgExcellentI("level"," "_level,rowid)) q:rowid=""  d
				...s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
				...q:('$IsObject(obj))||((obj.Status'="Y")&&(rolecode="nurhead"))||((obj.Status'="A")&&(rolecode="znurhead"))
				...d travelExcData
				..;自己创建的数据
				..d travelSelfExcData
			}
			elseif((rolecode="hlb")||(rolecode="hlbzr"))
			{
				;已到护理部处理流程的数据:(一)护理部(3)提交(Y)审核(A)的数据 (二)科护士长(2)审核(A)的数据
				;(一)
				s level=..GetLevel(roleitm)
				q:level=""
				s rowid="" f  s rowid=$o(^DHCNMG.Event.MgExcellentI("level"," "_level,rowid)) q:rowid=""  d
				.s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
				.q:('$IsObject(obj))||((obj.Status'="A")&&(obj.Status'="Y"))
				.d travelExcData
				;(二)
				s level=level-1
				s rowid="" f  s rowid=$o(^DHCNMG.Event.MgExcellentI("level"," "_level,rowid)) q:rowid=""  d
				.s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
				.q:('$IsObject(obj))||(obj.Status'="A")
				.d travelExcData
				;自己创建的数据
				d travelSelfExcData
			}
			elseif (rolecode="manager")||(rolecode="admin")
			{
				s status="" f  s status=$o(^DHCNMG.Event.MgExcellentI("status",status)) q:status=""  d
				.q:(Status'="")&&($tr(status," ","")'=Status)
				.s ward="" f  s ward=$O(^DHCNMG.Event.MgExcellentI("status",status,ward)) q:ward=""  d
				..q:(wardIdIn'="")&&(wardIdIn'=$tr(ward," ",""))
				..s rowid="" f  s rowid=$O(^DHCNMG.Event.MgExcellentI("status",status,ward,rowid)) q:rowid=""  d
				...s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
				...q:('$IsObject(obj))
				...d travelExcData
			}
		}
	}
	s row="" f  s row=$o(tmp(row)) q:row=""  d
	.s ret=tmp(row)
	.d OutputExcellentData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputExcellentData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
travelExcData
	q:(Status'="")&&(Status'=obj.Status)
	q:(wardIdIn'="")&&(wardIdIn'=obj.ExcellentWard)
	s ExcellentWard=""
	i obj.ExcellentWard'="" d
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ExcellentWard)
	.q:'$IsObject(wardobj)
	.s ExcellentWard=wardobj.WardDesc
	s ExcellentDate=""
	i obj.ExcellentDate'="" s ExcellentDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ExcellentDate)
	q:((stdate'="")&&(obj.ExcellentDate'="")&&(obj.ExcellentDate<stdate))
	q:((enddate'="")&&(obj.ExcellentDate'="")&&(obj.ExcellentDate>enddate))
	s ExcellentTime=""
	i obj.ExcellentTime'="" s ExcellentTime=$zt(obj.ExcellentTime,1)
	s ExcellentNurse=""
	i obj.ExcellentNurse'="" d
	.s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ExcellentNurse)
	.q:'$IsObject(nurseobj)
	.s ExcellentNurse=nurseobj.PerName
	s ExcellentUser=""
	i ((obj.ExcellentUser'="")&&(obj.ExcellentUser=0)) s ExcellentUser="管理员"
	e  i (obj.ExcellentUser'="")&&(obj.ExcellentUser'=0) d
	.s nurobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ExcellentUser)
	.q:'$IsObject(nurobj)
	.s ExcellentUser=nurobj.PerName
	s ExcellentPat="",ExcellentPatNo=""
	i obj.ExcellentPat'="" d
	.s PAADMPAPMIDR=$p($g(^PAADM(obj.ExcellentPat)),"^",1) //获取病人基本信息表ID
	.s ExcellentPat=$P($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",1) //病人姓名
	.s ExcellentPatNo=$p($g(^PAPER(PAADMPAPMIDR,"PAT",1)),"^",22) //病人住院号
	s ExcellentStatus=""
	i obj.Status="O" s ExcellentStatus="驳回"
	e  i obj.Status="N" s ExcellentStatus="保存"
	e  i obj.Status="Y" s ExcellentStatus="提交"
	e  i obj.Status="A" s ExcellentStatus="审核"
	s excellentTitle=obj.ExcellentTitle
	s excellentHandle=$s(obj.Status="O":"驳回",obj.Status="A":$case(obj.ExcellentHandle,1:"护士长审核",2:"科护士长审核",3:"护理部审核",:""),obj.Status'="Y":"未提交",1:"提交")
	s ret1="excellentWard|"_ExcellentWard_"^excellentDate|"_ExcellentDate_"^excellentTime|"_ExcellentTime_"^excellentNurse|"_ExcellentNurse_"^excellentUser|"_ExcellentUser_"^excellentPat|"_ExcellentPat_"^excellentPatNo|"_ExcellentPatNo_"^RowID|"_rowid_"^Status|"_ExcellentStatus_"^excellentTitle|"_excellentTitle_"^excellentHandle|"_excellentHandle
	s tmp(rowid)=ret1
	q
travelSelfExcData
	s rowid="" f  s rowid=$o(^DHCNMG.Event.MgExcellentI("creator"," "_nurseid,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(rowid)
	.q:('$IsObject(obj))
	.d travelExcData
	q
}

ClassMethod FindExcellentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExcellentListExecute ]
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

ClassMethod FindExcellentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExcellentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExcellentData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj)
	s ExcellentWard=obj.ExcellentWard
	s ExcellentWardDesc=""
	i obj.ExcellentWard'="" d
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ExcellentWard)
	.q:'$IsObject(wardobj)
	.s ExcellentWardDesc=wardobj.WardDesc
	i obj.ExcellentDate'="" s ExcellentDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ExcellentDate)
	e  s ExcellentDate=""
	i obj.ExcellentTime'="" s ExcellentTime=$zt(obj.ExcellentTime,1)
	e  s ExcellentTime=""
	s ExcellentNurse=obj.ExcellentNurse
	s ExcellentNurseDesc=""
	i obj.ExcellentNurse'="" d
	.s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ExcellentNurse)
	.q:'$IsObject(nurseobj)
	.s ExcellentNurseDesc=nurseobj.PerName
	s ExcellentPat=obj.ExcellentPat
	s ExcellentProcess=obj.ExcellentProcess
	s ExcellentGrade=obj.ExcellentGrade
	i obj.GradeDate'="" s GradeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GradeDate)
	e  s GradeDate=""
	s Opinion=obj.Opinion
	s ExcellentPatNo=obj.ExcellentPatNo
	s ExcellentSolve=obj.ExcellentSolve
	s ExcellentIntro=obj.ExcellentIntro
	s ExcellentTitle=obj.ExcellentTitle
	s ExcellentUser=obj.ExcellentUser
	s ExcellentStatus=obj.Status
	s ret="excellentWard|"_ExcellentWard_"^excellentDate|"_ExcellentDate_" "_ExcellentTime_"^excellentNurse|"_ExcellentNurse_"^excellentPat|"_ExcellentPat_"^excellentProcess|"_ExcellentProcess_"^excellentGrade|"_ExcellentGrade_"^GradeDate|"_GradeDate_"^Opinion|"_Opinion_"^excellentPatNo|"_ExcellentPatNo_"^RowID|"_id_"^excellentSolve|"_ExcellentSolve_"^excellentIntro|"_ExcellentIntro_"^excellentTitle|"_ExcellentTitle_"^excellentStatus|"_ExcellentStatus_"^excellentUser|"_ExcellentUser_"^excellentWardDesc|"_ExcellentWardDesc_"^excellentNurseDesc|"_ExcellentNurseDesc
	q ret
}

ClassMethod DelExcellent(id As %String, nurseid As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(obj.Status'="O")&&(obj.Status'="N") 2
	q:obj.ExcellentUser'=nurseid 3
	;s obj.Status=type
	;s sc=obj.%Save()
	s sc=##class(DHCNMG.Event.MgExcellent).%DeleteId(id)
	q $$$ISOK(sc)
}

ClassMethod AuditExcellent(id As %String, nurseid As %String) As %String
{
	q:id="" 0
	s level=..GetLevel(..GetHighRoleId(nurseid))
	q:level="" 0
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj) 0
	//不能重复审核
	q:level=obj.ExcellentHandle 2
	//不能越级审核
	q:level'=(obj.ExcellentHandle+1) 3
	s obj.ExcellentHandle=level
	s obj.Status="A"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod RejectExcellent(id As %String, nurseid As %String) As %String
{
	q:id="" 0
	s level=..GetLevel(..GetHighRoleId(nurseid))
	q:level="" 0
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj) 0
	//不能驳回已驳回的
	q:(obj.Status'="Y")&&(obj.Status'="A") 0
	//不能越级驳回
	q:level'=(obj.ExcellentHandle+1) 0
	s level2=..GetLevel(..GetHighRoleId(obj.ExcellentUser))
	q:level2="" 0
	s obj.ExcellentHandle=level2
	s obj.Status="O"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetExcellentStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.Status
	q flag
}

/// 获取优良事件的 JSON数据
/// 2018-08-27
ClassMethod GetJsonExcellent(id As %String) As %String
{
	q:id="" "[]"
	s obj=##class(DHCNMG.Event.MgExcellent).%OpenId(id)
	q:'$IsObject(obj) "[]"
	w "["
	s ExcellentWard=""
	i obj.ExcellentWard'="" d
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ExcellentWard)
	.q:'$IsObject(WardObj)
	.s ExcellentWard=WardObj.WardDesc
	s ExcellentDate=""
	i obj.ExcellentDate'="" d
	.s ExcellentDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ExcellentDate)
	s ExcellentTime=""
	i obj.ExcellentTime'="" d
	.s ExcellentTime=$zt(obj.ExcellentTime,1)
	s ExcellentDateTime=ExcellentDate_" "_ExcellentTime
	s ExcellentNurse=""
	i obj.ExcellentNurse'="" d
	.s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ExcellentNurse)
	.q:'$IsObject(PerObj)
	.s ExcellentNurse=PerObj.PerName
	s ExcellentPat=""
	i obj.ExcellentPat'="" d
	.s PAPMIDR=$p(^PAADM(obj.ExcellentPat),"^",1)
	.s ExcellentPat=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	s ExcellentProcess=obj.ExcellentProcess
	s ExcellentGrade=""
	i obj.ExcellentGrade="true" s ExcellentGrade="是"
	e  i obj.ExcellentGrade="false" s ExcellentGrade="否"
	s GradeDate=""
	i obj.GradeDate'="" d
	.s GradeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GradeDate)
	s Opinion=obj.Opinion
	w "{""ExcellentWard"":"""_ExcellentWard_""",""ExcellentDateTime"":"""_ExcellentDateTime_""",""ExcellentNurse"":"""
	_ExcellentNurse_""",""ExcellentPat"":"""_ExcellentPat_""",""ExcellentProcess"":"""_ExcellentProcess_""",""ExcellentGrade"":"""_ExcellentGrade_""",""GradeDate"":"""
	_GradeDate_""",""Opinion"":"""_Opinion_"""}"
	w "]"
	q ""
}

}
