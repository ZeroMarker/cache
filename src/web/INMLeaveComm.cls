/// Creator:wangpf
/// Desctiptions:请假模块方法类
/// Date:2020-06-24
Class web.INMLeaveComm Extends %RegisteredObject
{

/// Description: 保存护士请假申请
/// Date: 2020-06-24
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: parr 登录人Id 来源
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMLeaveComm).SaveLeaveApp()
ClassMethod SaveLeaveApp(parr As %String = "", nurseid As %String = "", source As %String = "") As %String
{
	q:(parr="")||(nurseid="")||('$d(^CF.DHCINM.HR.PersonsD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s type=$p(parr,"^",2)
	;q:(type="")||('$d(^CT.DHCINM.DB.MgSetCodeSubD($p(type,"||"),$p(type,"||",2)))) 0
	q:(type="")||('$d(^CF.DHCINM.DB.MgArgWardPostD(type))) 0
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s stTime=$p(parr,"^",4)
	s:stTime[":" stTime=$zth(stTime)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	s endTime=$p(parr,"^",6)
	s:endTime[":" endTime=$zth(endTime)
	s reason=$p(parr,"^",7)
	s position=$p(parr,"^",8)
	s charger=$p(parr,"^",9)
	s chargertel=$p(parr,"^",10)
	s rw=$p(parr,"^",11)
	q:..CheckLeaveRepeat(rw,nurseid,stDate,endDate) "请假时间存在交叉"
	i rw="" s leaveObj=##class(DHCINM.Arg.MgLeaveApp).%New()
	e  s leaveObj=##class(DHCINM.Arg.MgLeaveApp).%OpenId(rw)
	q:'$IsObject(leaveObj) 0
	s leaveObj.LeaveSource=source
	d leaveObj.LeaveWardSetObjectId(ward)
	d leaveObj.LeaveTypeSetObjectId(type)
	s leaveObj.LeaveStDate=stDate
	s leaveObj.LeaveStTime=stTime
	s leaveObj.LeaveEndDate=endDate
	s leaveObj.LeaveEndTime=endTime
	s leaveObj.LeaveReason=reason
	s leaveObj.LeavePosition=position
	s leaveObj.LeaveCharger=charger
	s leaveObj.LeaveChargerTel=chargertel
	s leaveObj.LeaveStatus="Y"
	d leaveObj.CreatorSetObjectId(nurseid)
	s sc=leaveObj.%Save()
	q $$$ISOK(sc)
}

// w ##class(web.INMLeaveComm).CheckLeaveRepeat("",30,"2022-08-01","2022-08-02")

ClassMethod CheckLeaveRepeat(id As %String = "", perId As %String = "", stDate As %String = "", endDate As %String = "") As %String
{
       s:stDate["-" stDate=$zdh(stDate,3)
       s:endDate["-" endDate=$zdh(endDate,3)
       q:(perId="")||('$d(^CF.DHCINM.HR.PersonsD(perId)))||(+stDate=0)||(+endDate=0) 0
       
       k tmp
       s flag=0
       s appId="" f  s appId=$o(^DHCINM.Arg.MgLeaveAppI("Nurse",perId,appId)) q:(appId="")||(flag'=0)  d
       .q:id=appId
       .q:'$d(^DHCINM.Arg.MgLeaveAppD(appId))
       .s glo=^DHCINM.Arg.MgLeaveAppD(appId)
       .s leaveStDate=$lg(glo,5)
       .s leaveEndDate=$lg(glo,7)
       .s leaveWorkDate=$lg(glo,29)
       .f date=leaveStDate:1:leaveEndDate d
       ..q:$lf(leaveWorkDate,date)
       ..s tmp(date)=1
       .f date=stDate:1:endDate q:flag'=0  d
       ..s:$d(tmp(date)) flag=1
       
       q flag
}

/// Description: 获取护士请假申请信息
/// Date: 2020-06-24
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: id
/// Output: 护士请假申请信息
/// Other: w ##class(web.INMLeaveComm).GetLeaveApp(1)
ClassMethod GetLeaveApp(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Arg.MgLeaveAppD(id))) ""
	s leaveGlo=^DHCINM.Arg.MgLeaveAppD(id)
	s leaveSource=$lg(leaveGlo,2)
	s leaveWard=$lg(leaveGlo,3)
	s leaveWardDesc=""
	i leaveWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leaveWardDesc=$lg(wardGlo,4)
	s leaveType=$lg(leaveGlo,4)
	s leaveTypeDesc=""
	i leaveType'="" d
	.;s codeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD($p(leaveType,"||"),$p(leaveType,"||",2)))
	.;s leaveTypeDesc=$lg(codeGlo,3)
	.s codeGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(leaveType))
	.s leaveTypeDesc=$lg(codeGlo,2)
	s leaveStDate=$lg(leaveGlo,5)
	s leaveStTime=$lg(leaveGlo,6)
	s leaveEndDate=$lg(leaveGlo,7)
	s leaveEndTime=$lg(leaveGlo,8)
	s leaveTotal=""
	;i (leaveStDate'="")&&(leaveStTime'="")&&(leaveEndDate'="")&&(leaveEndTime'="") d
	;.s leaveTotal=(leaveEndDate*86400+leaveEndTime)-(leaveStDate*86400+leaveStTime)
	;.i leaveTotal>=86400 s leaveTotal=leaveTotal\86400_"天"_$fn(leaveTotal#86400/3600,"",0)_"小时"
	;.e  s leaveTotal=$fn(leaveTotal/3600,"",0)_"小时"
	s:(leaveStDate'="")&&(leaveEndDate'="") leaveTotal=leaveEndDate-leaveStDate+1
	s leaveTotal=leaveTotal-$ll($lg(leaveGlo,29))_"天"
	s:leaveStDate'="" leaveStDate=$zd(leaveStDate,3)
	s:leaveStTime'="" leaveStTime=$zt(leaveStTime,2)
	s:leaveEndDate'="" leaveEndDate=$zd(leaveEndDate,3)
	s:leaveEndTime'="" leaveEndTime=$zt(leaveEndTime,2)
	s leaveReason=$lg(leaveGlo,9)
	s leavePosition=$lg(leaveGlo,10)
	s leaveCharger=$lg(leaveGlo,11)
	s leaveChargerTel=$lg(leaveGlo,12)
	s leaveStatus=$lg(leaveGlo,13)
	s leaveStatusDesc=$case(leaveStatus,"B":"驳回","Y":"提交","NA":"护士长审核","ZA":"科护士长审核","HA":"护理部审核",:"")
	s:(leaveSource="N")&&(leaveStatus["A") leaveStatusDesc="审核"
	s creator=$lg(leaveGlo,14)
	s creatorName=""
	i creator'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(leaveGlo,15)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(leaveGlo,16)
	s:createTime'="" createTime=$zt(createTime)
	s auditor=$lg(leaveGlo,17)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(leaveGlo,18)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(leaveGlo,19)
	s:auditTime'="" auditTime=$zt(auditTime)
	s zauditor=$lg(leaveGlo,20)
	s zauditorName=""
	i zauditor=0 s zauditorName="管理员"
	e  i zauditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(zauditor))
	.s zauditorName=$lg(perGlo,2)
	s zauditDate=$lg(leaveGlo,21)
	s:zauditDate'="" zauditDate=$zd(zauditDate,3)
	s zauditTime=$lg(leaveGlo,22)
	s:zauditTime'="" zauditTime=$zt(zauditTime)
	s hauditor=$lg(leaveGlo,23)
	s hauditorName=""
	i hauditor=0 s hauditorName="管理员"
	e  i hauditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(hauditor))
	.s hauditorName=$lg(perGlo,2)
	s hauditDate=$lg(leaveGlo,24)
	s:hauditDate'="" hauditDate=$zd(hauditDate,3)
	s hauditTime=$lg(leaveGlo,25)
	s:hauditTime'="" hauditTime=$zt(hauditTime)
	s auditOpinion=$lg(leaveGlo,26)
	s zauditOpinion=$lg(leaveGlo,27)
	s hauditOpinion=$lg(leaveGlo,28)
	s workDates=$lg(leaveGlo,29)
	s workDate=""
	f i=1:1:$ll(workDates) d
	.s rowData=##class(web.INMHISComm).DateLogicalToHtml($lg(workDates,i))
	.s:workDate'="" workDate=workDate_","_rowData
	.s:workDate="" workDate=rowData
	s LeaveStEndDate=leaveStDate_"至"_leaveEndDate
	s ret="LeaveSource|"_leaveSource_"^LeaveWard|"_leaveWard_"^LeaveWardDesc|"_leaveWardDesc_"^LeaveType|"_$tr(leaveType,"|","_")_"^LeaveTypeDesc|"_leaveTypeDesc
	s ret=ret_"^LeaveStDate|"_leaveStDate_"^LeaveStTime|"_leaveStTime_"^LeaveEndDate|"_leaveEndDate_"^LeaveEndTime|"_leaveEndTime_"^LeaveTotal|"_leaveTotal
	s ret=ret_"^LeaveReason|"_leaveReason_"^LeavePosition|"_leavePosition_"^LeaveCharger|"_leaveCharger_"^LeaveChargerTel|"_leaveChargerTel_"^LeaveStatus|"_leaveStatus
	s ret=ret_"^LeaveReasonDesc|"_leaveStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^ZAuditor|"_zauditor_"^ZAuditorName|"_zauditorName
	s ret=ret_"^ZAuditDate|"_zauditDate_"^ZAuditTime|"_zauditTime_"^HAuditor|"_hauditor_"^HAuditorName|"_hauditorName_"^HAuditDate|"_hauditDate_"^HAuditTime|"_hauditTime
	s ret=ret_"^AuditOpinion|"_auditOpinion_"^ZAuditOpinion|"_zauditOpinion_"^HAuditOpinion|"_hauditOpinion_"^rw|"_id_"^WorkDate|"_workDate
	s ret=ret_"^LeaveStEndDate|"_LeaveStEndDate
	q ret
}

/// Description：查询护士请假列表
/// Date:2020-06-24
/// Creator:wangpf
/// Table:DHCINM.Arg.MgLeaveApp
/// Input: 病区Id
/// Output:护士请假列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMLeaveComm","FindNurLeaveList","^^^","H",0)
Query FindNurLeaveList(parr As %String = "", source As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurLeaveListExecute(ByRef qHandle As %Binary, parr As %String = "", source As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s status=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s isHead=0,isZHead=0,isHLB=0
	i nurseid'=0 d
	.s loginRoleIds=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	.s loginRoleIdList=$lfs(loginRoleIds,"^")
	.s ptr=0 f  s stat=$listnext(loginRoleIdList,ptr,role) q:stat'=1  d
	..q:role=""
	..s roleGlo=$g(^CT.DHCINM.Set.MgRolesD(role))
	..s roleCode=$zcvt($lg(roleGlo,2),"U")
	..i roleCode="NURHEAD" s isHead=1
	..e  i roleCode="ZNURHEAD" s isZHead=1
	..e  i roleCode="HLB" s isHLB=1
	
	s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	s perId=$lg(userGlo,5)
	
	s sou="" f  s sou=$o(^DHCINM.Arg.MgLeaveAppI("Source",sou)) q:sou=""  d
	.q:(source'="")&&(source'=$tr(sou," ",""))
	.s leaveId="" f  s leaveId=$o(^DHCINM.Arg.MgLeaveAppI("Source",sou,leaveId)) q:leaveId=""  d
	..q:'$d(^DHCINM.Arg.MgLeaveAppD(leaveId))
	..s leaveGlo=^DHCINM.Arg.MgLeaveAppD(leaveId)
	..s leaveWard=$lg(leaveGlo,3)
	..s creator=$lg(leaveGlo,14)
	..q:((isAll'=1)&&('$d(tmpWard(leaveWard)))&&(perId'=creator))
	..q:((ward'="")&&(ward'=leaveWard))
	..s leaveStatus=$lg(leaveGlo,13)
	..q:(status'="")&&(((status'="A")&&(status'=leaveStatus))||((status="A")&&(leaveStatus'["A")))
	..q:(nurseid'=0)&&(perId'=creator)&&(source="N")&&(leaveStatus="N")&&(isHead=0)&&(isHLB=0)
	..q:(nurseid'=0)&&(perId'=creator)&&(source="N")&&(leaveStatus'="N")&&((isHead'=1)&&(isHLB'=1))
	..q:(nurseid'=0)&&(perId'=creator)&&(source="H")&&(isZHead=0)&&(isHLB=0)
	..q:(nurseid'=0)&&(perId'=creator)&&(source="H")&&(isZHead'=1)&&(leaveStatus="Y")
	..q:(nurseid'=0)&&(perId'=creator)&&(source="H")&&((leaveStatus="ZA")||(leaveStatus="HA"))&&(isHLB'=1)
	..s leaveStDate=$lg(leaveGlo,5)
	..s leaveEndDate=$lg(leaveGlo,7)
	..q:((stDate'="")&&(stDate>leaveEndDate))||((endDate'="")&&(endDate<leaveStDate))
	..s ret=..GetLeaveApp(leaveId)
	..d:ret'="" OutLeaveList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLeaveList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurLeaveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurLeaveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurLeaveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurLeaveListExecute ]
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

/// Description: 审核护士请假申请
/// Date: 2020-06-24
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMLeaveComm).AuditLeaveApp("A^^3",0)
ClassMethod AuditLeaveApp(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reson=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.Arg.MgLeaveApp).%OpenId(rw)
	q:'$IsObject(obj) 0
	
	s isHead=0,isZHead=0,isHLB=0
	i nurseid=0 s isHead=1,isZHead=1,isHLB=1
	e  d
	.s loginRoleIds=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	.s loginRoleIdList=$lfs(loginRoleIds,"^")
	.s ptr=0 f  s stat=$listnext(loginRoleIdList,ptr,role) q:stat'=1  d
	..q:role=""
	..s roleGlo=$g(^CT.DHCINM.Set.MgRolesD(role))
	..s roleCode=$zcvt($lg(roleGlo,2),"U")
	..i roleCode="NURHEAD" s isHead=1
	..e  i roleCode="ZNURHEAD" s isZHead=1
	..e  i roleCode="HLB" s isHLB=1
	
	i status="A" d
	.i obj.LeaveSource="N" d
	..s:(isHead=1)||(isZHead=1) status="NA"
	..s:isHLB=1 status="HA"
	.e  i obj.LeaveSource="H" d
	..s:isZHead status="ZA"
	..s:isHLB status="HA"
	
	q:(status'="B")&&(status'="NA")&&(status'="ZA")&&(status'="HA") 0
	
	s obj.LeaveStatus=status
	s now=$h
	s nowDate=+$h
	s nowTime=$p(now,",",2)
	i status="NA" d
	.s obj.Auditor=nurseid
	.s obj.AuditDate=nowDate
	.s obj.AuditTime=nowTime
	.s obj.AuditOpinion=reson
	e  i status="ZA" d
	.s obj.ZAuditor=nurseid
	.s obj.ZAuditDate=nowDate
	.s obj.ZAuditTime=nowTime
	.s obj.ZAuditOpinion=reson
	e  i status="HA" d
	.s obj.HAuditor=nurseid
	.s obj.HAuditDate=nowDate
	.s obj.HAuditTime=nowTime
	.s obj.HAuditOpinion=reson
	ts
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i (flag=1)&&((status="HA")||((obj.LeaveSource="N")&&(status="NA"))) d
	.s stDateTime=obj.LeaveStDate*86400+obj.LeaveStTime
	.s endDateTime=obj.LeaveEndDate*86400+obj.LeaveEndTime
	.s stDate=obj.LeaveStDate-2,endDate=obj.LeaveEndDate
	.s argDate=stDate f  s argDate=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",obj.Creator.%Id(),argDate)) q:((argDate="")||(argDate>endDate)||(flag'=1))  d
	..s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",obj.Creator.%Id(),argDate,argId)) q:((argId="")||(flag'=1))  d
	...s argObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argId)
	...s nextDatFlag=0
	...s stTime1=argObj.ArgStTime1
	...s:stTime1'="" stTime1=$zth(stTime1,1)
	...s endTime1=argObj.ArgEndTime1
	...i endTime1["次日" s endTime1=86400+$zth($p(endTime1,"次日",2),1),nextDatFlag=1
	...e  i endTime1'="" s endTime1=$zth(endTime1,1)
	...s stTime2=argObj.ArgStTime2
	...i (nextDatFlag'=0)&&(stTime2'="") s stTime2=86400+$zth($replace(stTime2,"次日",""),1)
	...e  i stTime2["次日" s stTime2=$zth($p(stTime2,"次日",2),1),nextDatFlag=1
	...e  i stTime2'="" s stTime2=$zth(stTime2,1)
	...s endTime2=argObj.ArgEndTime2
	...i (nextDatFlag'=0)&&(endTime2'="") s endTime2=86400+$zth($replace(endTime2,"次日",""),1)
	...e  i endTime2["次日" s endTime2=86400+$zth($p(endTime2,"次日",2),1),nextDatFlag=1
	...e  i endTime2'=""  s endTime2=$zth(endTime2,1)
	...s stTime3=argObj.ArgStTime3
	...i (nextDatFlag'=0)&&(stTime3'="") s stTime3=86400+$zth($replace(stTime3,"次日",""),1)
	...e  i stTime3["次日" s stTime3=$zth($p(stTime3,"次日",2),1),nextDatFlag=1
	...e  i stTime3'="" s stTime3=$zth($p(stTime3,"次日",2),1)
	...s endTime3=argObj.ArgEndTime3
	...i (nextDatFlag'=0)&&(endTime3'="") s endTime3=86400+$zth($replace(endTime3,"次日",""),1)
	...e  i endTime3["次日" s endTime3=86400+$zth($p(endTime3,"次日",2),1)
	...e  i endTime3'="" s endTime3=$zth(endTime3,1)
	...s base=argDate*86400
	...s:stTime1'="" stTime1=base+stTime1
	...s:endTime1'="" endTime1=base+endTime1
	...s:stTime2'="" stTime2=base+stTime2
	...s:endTime2'="" endTime2=base+endTime2
	...s:stTime3'="" stTime3=base+stTime3
	...s:endTime3'="" endTime3=base+endTime3
	...s repeatFlag=0
	...i ((stTime1'="")&&(endTime1'="")&&(stDateTime<endTime1)&&(stTime1<endDateTime)) s repeatFlag=1
	...i ((stTime2'="")&&(endTime2'="")&&(stDateTime<endTime2)&&(stTime2<endDateTime)) s repeatFlag=1
	...i ((stTime3'="")&&(endTime3'="")&&(stDateTime<endTime3)&&(stTime3<endDateTime)) s repeatFlag=1
	...q:repeatFlag'=1
	...s sc=argObj.%DeleteId(argId)
	...s flag=$$$ISOK(sc)
	i flag'=1 tro  q 0
	e  tc 
	try{
		i ((obj.LeaveStatus["A")||(obj.LeaveStatus="B")) d
		.s LeaveStatusDesc=$case(obj.LeaveStatus,"NA":"护士长审核","HA":"护理部审核","ZA":"科护士长审核","B":"驳回")
		.s wardDesc=""
		.s wardId=$LG($g(^DHCINM.Arg.MgLeaveAppD(rw)),3) ;病区
		.s:wardId'="" wardDesc=$LG($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
		.s leaveType=""  ;请假类型
		.s leTypeId=$LG($g(^DHCINM.Arg.MgLeaveAppD(rw)),4)
		.s:leTypeId'="" leaveType=$LG($g(^CF.DHCINM.DB.MgArgWardPostD(leTypeId)),2)
		.s startDate1=$LG($g(^DHCINM.Arg.MgLeaveAppD(rw)),5) ;开始日期
		.s startDate=""
		.s:startDate1'="" startDate=$zd(startDate1,3)
		.s endDate1=$LG($g(^DHCINM.Arg.MgLeaveAppD(rw)),7) ;结束日期
		.s endDate=""
		.s:endDate1'="" endDate=$zd(endDate1,3)
		.s applicantId=$LG($g(^DHCINM.Arg.MgLeaveAppD(rw)),14) ;创建人id
		.s ret1="【请假申请】 "_LeaveStatusDesc_" "_wardDesc_" "_leaveType_" "_startDate_"至"_endDate
		.s ret2="【请假申请】 "_LeaveStatusDesc_" "_wardDesc_" "_leaveType_" "_startDate_"至"_endDate
		.s applicantId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_applicantId,""))
		.d ##class(web.INMPlatform).SaveTrackMessage(applicantId,+$H,ret1,"","DHCINM.Arg.MgLeaveApp",rw)
	}catch{
		}
	q 1
}

/// Description: 删除护士请假申请
/// Date: 2020-06-24
/// Creator: wangpf
/// Table: DHCINM.Arg.MgLeaveApp
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMLeaveComm).DeleteLeaveApp(1)
ClassMethod DeleteLeaveApp(id As %String = "") As %String
{
	q:id="" 0
	
	s obj=##class(DHCINM.Arg.MgLeaveApp).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(obj.LeaveStatus'="B") 0 ;&&(obj.LeaveStatus'="Y")
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：获取一段时间内请假时长
/// Date:2020-06-29
/// Creator:wangpf
/// Table:DHCINM.Arg.MgLeaveApp
/// Input: 病区Id
/// Output:请假时长
/// Other:d ##class(%ResultSet).RunQuery("web.INMLeaveComm","FindLeaveLongList","2^2021-06-01^2021-06-30^",0)
Query FindLeaveLongList(parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLeaveLongListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "", outType As %String = "", outPerId As %String = "") As %Status
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
	
	;新加统计排班排的休假
	k tmpLong
	s ArgWard="" f  s ArgWard=$o(^DHCINM.Arg.MgArrangeSubI("Ward",ArgWard)) q:ArgWard=""  d
	.q:((ward'="")&&(ward'=ArgWard))||((isAll'=1)&&('$d(tmpWard(ArgWard))))
	.s Argid="" f  s Argid=$o(^DHCINM.Arg.MgArrangeSubI("Ward",ArgWard,Argid)) q:Argid=""  d
	..q:'$d(^DHCINM.Arg.MgArrangeSubD(Argid))
	..s argGlo=$g(^DHCINM.Arg.MgArrangeSubD(Argid))
	..s argPer=$lg(argGlo,5) //护士id
	..q:(outPerId'="")&&(outPerId'=argPer)
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(argPer))
	..s perName=$lg(perGlo,2)
	..s perId=$lg(perGlo,3)
	..q:(input'="")&&(perName_perId'[input)
	..s argDate=$lg(argGlo,6) //排班日期
	..q:$p(##class(web.INMArgComm).IsPerAskLeavel3(argPer_"^"_argDate),"^",3)'=""
	..q:((stDate'="")&&(stDate>argDate))||((endDate'="")&&(endDate<argDate))
	..s argPost=$lg(argGlo,7)
	..q:argPost=""
	..q:'$d(^CF.DHCINM.DB.MgArgWardPostD(argPost))
	..s wardSubPostGlo=^CF.DHCINM.DB.MgArgWardPostD(argPost)
	..s argSubPostId=$lg(wardSubPostGlo,4)
	..q:argSubPostId=""
	..q:'$d(^CF.DHCINM.DB.MgArgPostD(argSubPostId))
	..s argSubPostGlo=^CF.DHCINM.DB.MgArgPostD(argSubPostId)
	..s argSubPostType=$lg(argSubPostGlo,4)
	..q:argSubPostType'="H"
	..s argHolidytimeType=$lg(argGlo,18)
	..s argHolidaytime=$case(argHolidytimeType,"H":1,"A":0.5,"P":0.5,:1)
	..s final=$case(outType,2:argSubPostId,:argPost)
	..s tmpLong(ArgWard,argPer,final)=$g(tmpLong(ArgWard,argPer,final))+argHolidaytime
	..s tmpLong(ArgWard,argPer,final,argDate)=$g(tmpLong(ArgWard,argPer,final,argDate))+argHolidaytime
	;新加统计排班的休假结束
	
	s statusTmp(" NA")="NA",statusTmp(" HA")="ZA",statusTmp(" HA")="HA"
	s leaveWard="" f  s leaveWard=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard)) q:leaveWard=""  d
	.q:((ward'="")&&(ward'=leaveWard))||((isAll'=1)&&('$d(tmpWard(leaveWard))))
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leaveWardDesc=$lg(wardGlo,4)
	.s leavePer="" f  s leavePer=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer)) q:leavePer=""  d
	..s tmpLeavePer=$tr(leavePer," ","")
	..q:(outPerId'="")&&(outPerId'=tmpLeavePer)
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(tmpLeavePer))
	..s leavePerName=$lg(perGlo,2)
	..s leavePerId=$lg(perGlo,3)
	..q:(input'="")&&(leavePerName_leavePerId'[input)
	..s leavePerLevel=$p(##class(web.INMHRComm).GetNurseLevel(tmpLeavePer,+$h),"^",2)
	..s leaveStatus="" f  s leaveStatus=$o(statusTmp(leaveStatus)) q:leaveStatus=""  d
	...s leaveId="" f  s leaveId=$o(^DHCINM.Arg.MgLeaveAppI("WardPer",leaveWard,leavePer,leaveStatus,leaveId)) q:leaveId=""  d
	....q:'$d(^DHCINM.Arg.MgLeaveAppD(leaveId))
	....s leaveGlo=^DHCINM.Arg.MgLeaveAppD(leaveId)
	....s leaveSource=$lg(leaveGlo,2)
	....q:(leaveSource="H")&&(leaveStatus'=" HA") // 护士长请假需护理部审核
	....s leaveStDate=$lg(leaveGlo,5)
	....s leaveStTime=$lg(leaveGlo,6)
	....s leaveEndDate=$lg(leaveGlo,7)
	....s leaveEndTime=$lg(leaveGlo,8)	
	....q:((stDate'="")&&(stDate>leaveEndDate))||((endDate'="")&&(endDate<leaveStDate))
	....s:(endDate'="")&&(endDate<leaveEndDate) leaveEndDate=endDate,leaveEndTime=0
	....s:(stDate'="")&&(stDate>leaveStDate) leaveStDate=stDate,leaveStTime=0
	....;s time=leaveEndDate*86400+leaveEndTime-(leaveStDate*86400+leaveStTime)
	....s time=leaveEndDate-leaveStDate+1
	....s workDate=$lg(leaveGlo,29)
	....s time=time-$ll(workDate)
	....s leaveType=$lg(leaveGlo,4)
	....q:leaveType=""
	....q:'$d(^CF.DHCINM.DB.MgArgWardPostD(leaveType))
	....s wardSubPostGlo=^CF.DHCINM.DB.MgArgWardPostD(leaveType)
	....s argSubPostId=$lg(wardSubPostGlo,4)
	....q:argSubPostId=""
	....s final=$case(outType,2:argSubPostId,:leaveType)
	....s tmpLong(leaveWard,tmpLeavePer,final)=$g(tmpLong(leaveWard,tmpLeavePer,final))+time
	....f leaveDate=leaveStDate:1:leaveEndDate d
	.....q:$lf(workDate,leaveDate)
	.....s tmpLong(leaveWard,tmpLeavePer,final,leaveDate)=$g(tmpLong(leaveWard,tmpLeavePer,final,leaveDate))+1
	
	;取数据
	s argWard="" f  s argWard=$o(^CF.DHCINM.DB.MgWardD(argWard)) q:argWard=""  d
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(argWard)
	.s wardStDate=$lg(wardGlo,11)
	.s wardEndDate=$lg(wardGlo,12)
	.q:(wardStDate="")||(wardStDate>+$h)||((wardEndDate'="")&&(wardEndDate<+$h))
	.q:((ward'="")&&(ward'=argWard))||((isAll'=1)&&('$d(tmpWard(argWard))))
	.k tmpType
	.d initType(.tmpType,argWard)
	.s wardTotal=0
	.s leaveWard=argWard
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(leaveWard))
	.s leaveWardDesc=$lg(wardGlo,4)
	.s tmpPer="" f  s tmpPer=$O(tmpLong(argWard,tmpPer)) q:tmpPer=""  d
	..s tmpLeavePer=$tr(tmpPer," ","")
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(tmpLeavePer))
	..s leavePerName=$lg(perGlo,2)
	..s leavePerId=$lg(perGlo,3)
	..;q:(input'="")&&(leavePerName_leavePerId'[input)
	..s leavePerLevel=$p(##class(web.INMHRComm).GetNurseLevel(tmpLeavePer,+$h),"^",2)
	..s ret="LeaveNurse|"_tmpLeavePer_"^LeaveNurseName|"_leavePerName_"^LeaveNurseLevel|"_leavePerLevel_"^LeaveWard|"_leaveWard_"^LeaveWardDesc|"_leaveWardDesc
	..s totalTime=0
	..s leaveType="" f  s leaveType=$o(tmpType(leaveType)) q:leaveType=""  d
	...s time=$g(tmpLong(leaveWard,tmpLeavePer,leaveType))
	...s totalTime=totalTime+time
	...;i time>=86400 s time=time\86400_"天"_$fn(time#86400/3600,"",0)_"小时"
	...;e  s time=$fn(time/3600,"",0)_"小时"
	...s time=$fn($fn(time,"O",1),"O")
	...s ret=ret_"^"_$tr(leaveType,"|","_")_"|"_time_"天"
	..;i totalTime>=86400 s totalTime=totalTime\86400_"天"_$fn(totalTime#86400/3600,"",0)_"小时"
	..;e  s totalTime=$fn(totalTime/3600,"",0)_"小时"
	..s wardTotal=wardTotal+totalTime
	..q:+outType>0
	..s totalTime=$fn($fn(totalTime,"O",1),"O")
	..s ret=ret_"^LeaveTotalTime|"_totalTime_"天"
	..d OutLongList
	.q:outType'=1
	.s wardTotal=$fn($fn(wardTotal,"O",1),"O")
	.s ret="LeaveWard|"_leaveWard_"^LeaveWardDesc|"_leaveWardDesc_"^LeaveTotalTime|"_wardTotal_"天"
	.d OutLongList
	
	i outType=2 d
	.s total=0
	.k tmp
	.s argWard="" f  s argWard=$o(tmpLong(argWard)) q:argWard=""  d
	..s argPer="" f  s argPer=$o(tmpLong(argWard,argPer)) q:argPer=""  d
	...s argPost="" f  s argPost=$o(tmpLong(argWard,argPer,argPost)) q:argPost=""  d
	....s tmp(argPost)=$g(tmp(argPost))+tmpLong(argWard,argPer,argPost)
	....s total=total+tmpLong(argWard,argPer,argPost)
	.s total=$fn($fn(total,"O",1),"O")
	.s ret="Count|"_total_"^Desc|总时长"
	.d OutLongList
	.s argPost="" f  s argPost=$o(tmp(argPost)) q:argPost=""  d
	..s time=$fn($fn(tmp(argPost),"O",1),"O")
	..s ret="Count|"_time_"^Desc|"_$g(tmpType(argPost))
	..d OutLongList
	
	i outType=3 d
	.k tmp
	.s argWard="" f  s argWard=$o(tmpLong(argWard)) q:argWard=""  d
	..s argPer="" f  s argPer=$o(tmpLong(argWard,argPer)) q:argPer=""  d
	...s argPost="" f  s argPost=$o(tmpLong(argWard,argPer,argPost)) q:argPost=""  d
	....s argDate="" f  s argDate=$o(tmpLong(argWard,argPer,argPost,argDate)) q:argDate=""  d
	.....s tmp(argWard,argPer,argDate)=$g(tmp(argWard,argPer,argDate))+tmpLong(argWard,argPer,argPost,argDate)
	.....s:'$d(tmp(argWard,argPer,argDate,argPost)) tmp(argWard,argPer,argDate,argPost,"Desc")=$lg($g(^CF.DHCINM.DB.MgArgWardPostD(argPost)),2)
	.....s tmp(argWard,argPer,argDate,argPost)=$g(tmp(argWard,argPer,argDate,argPost))+tmpLong(argWard,argPer,argPost,argDate)
	.s argWard="" f  s argWard=$o(tmp(argWard)) q:argWard=""  d
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(argWard))
	..s leaveWardDesc=$lg(wardGlo,4)
	..s argPer="" f  s argPer=$o(tmp(argWard,argPer)) q:argPer=""  d
	...s tmpLeavePer=$tr(argPer," ","")
	...s perGlo=$g(^CF.DHCINM.HR.PersonsD(tmpLeavePer))
	...s leavePerName=$lg(perGlo,2)
	...s argDate="" f  s argDate=$o(tmp(argWard,argPer,argDate)) q:argDate=""  d
	....s argPost="" f  s argPost=$o(tmp(argWard,argPer,argDate,argPost)) q:argPost=""  d
	.....s ret="LeaveNurse|"_argPer_"^LeaveNurseName|"_leavePerName_"^LeaveWard|"_argWard_"^LeaveWardDesc|"_leaveWardDesc
	.....s ret=ret_"^Date|"_$zd(argDate,3)_"^Desc|"_tmp(argWard,argPer,argDate,argPost,"Desc")_"^LeaveTotalTime|"_tmp(argWard,argPer,argDate,argPost)_"天"
	.....d OutLongList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLongList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
initType(tmpType,ward)
	s sort="" f  s sort=$o(^CF.DHCINM.DB.MgArgWardPostI("WardSort",ward,sort)) q:sort=""  d
	.s wardPostId="" f  s wardPostId=$o(^CF.DHCINM.DB.MgArgWardPostI("WardSort",ward,sort,wardPostId)) q:wardPostId=""  d
	..q:'$d(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	..s wardPostGlo=^CF.DHCINM.DB.MgArgWardPostD(wardPostId)
	..s argPostId=$lg(wardPostGlo,4)
	..q:argPostId=""
	..q:'$d(^CF.DHCINM.DB.MgArgPostD(argPostId))
	..s argPostGlo=^CF.DHCINM.DB.MgArgPostD(argPostId)
	..s argPostType=$lg(argPostGlo,4)
	..q:argPostType'="H"
	..s final=$case(outType,2:argPostId,:wardPostId)
	..s tmpType(final)=$lg(argPostGlo,3)
}

ClassMethod FindLeaveLongListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLeaveLongListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLeaveLongListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLeaveLongListExecute ]
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

/// Creator:liwenzhen
/// Createdate:2021-01-28
/// Description:保存实际工作日期
/// Input:
/// Output:
/// Other:
/// Test:w ##class(web.INMLeaveComm).SaveWorkDate("4","")
ClassMethod SaveWorkDate(rw As %String, workDate As %String) As %String
{
	s obj=##class(DHCINM.Arg.MgLeaveApp).%OpenId(rw)
	q:'$IsObject(obj) 0
	ts
	s flag=1
	i ((obj.LeaveStatus="HA")||((obj.LeaveSource="N")&&(obj.LeaveStatus="NA"))) d
	.s stDateTime=obj.LeaveStDate*86400+obj.LeaveStTime
	.s endDateTime=obj.LeaveEndDate*86400+obj.LeaveEndTime
	.s stDate=obj.LeaveStDate-2,endDate=obj.LeaveEndDate
	.f i=1:1:obj.WorkDate.Count() d
	..s argDate=obj.WorkDate.GetAt(i)
	..s argId="" f  s argId=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",obj.Creator.%Id(),argDate,argId)) q:(argId="")||(flag'=1)  d
	...s argObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argId)
	...s nextDatFlag=0
	...s stTime1=argObj.ArgStTime1
	...s:stTime1'="" stTime1=$zth(stTime1,1)
	...s endTime1=argObj.ArgEndTime1
	...i endTime1["次日" s endTime1=86400+$zth($p(endTime1,"次日",2),1),nextDatFlag=1
	...e  i ((endTime1'="")&&(endTime1'["次日")) s endTime1=$zth(endTime1,1)
	...s stTime2=argObj.ArgStTime2
	...i (nextDatFlag'=0)&&(stTime2'="") s stTime2=86400+$zth(stTime2,1)
	...e  i stTime2'="" s stTime2=$zth(stTime2,1)
	...s endTime2=argObj.ArgEndTime2
	...i (nextDatFlag'=0)&&(endTime2'="")&&(endTime2'["次日") s endTime2=86400+$zth(endTime2,1)
	...e  i endTime2["次日" s endTime2=86400+$zth($p(endTime2,"次日",2),1),nextDatFlag=1
	...e  i ((endTime2'="")&&(endTime2'["次日"))  s endTime2=$zth(endTime2,1)
	...s stTime3=argObj.ArgStTime3
	...i (nextDatFlag'=0)&&(stTime3'="") s stTime3=86400+$zth(stTime3,1)
	...e  i stTime3'="" s stTime3=$zth(stTime3,1)
	...s endTime3=argObj.ArgEndTime3
	...i (nextDatFlag'=0)&&(endTime3'="")&&(endTime3'["次日") s endTime3=86400+$zth(endTime3,1)
	...e  i endTime3["次日" s endTime3=86400+$zth($p(endTime3,"次日",2),1)
	...e  i ((endTime3'="")&&(endTime3'["次日")) s endTime3=$zth(endTime3,1)
	...s base=argDate*86400
	...s:stTime1'="" stTime1=base+stTime1
	...s:endTime1'="" endTime1=base+endTime1
	...s:stTime2'="" stTime2=base+stTime2
	...s:endTime2'="" endTime2=base+endTime2
	...s:stTime3'="" stTime3=base+stTime3
	...s:endTime3'="" endTime3=base+endTime3
	...s repeatFlag=0
	...i ((stTime1'="")&&(endTime1'="")&&(stDateTime<endTime1)&&(stTime1<endDateTime)) s repeatFlag=1
	...i ((stTime2'="")&&(endTime2'="")&&(stDateTime<endTime2)&&(stTime2<endDateTime)) s repeatFlag=1
	...i ((stTime3'="")&&(endTime3'="")&&(stDateTime<endTime3)&&(stTime3<endDateTime)) s repeatFlag=1
	...;q:repeatFlag'=1
	...s sc=argObj.%DeleteId(argId)
	...s flag=$$$ISOK(sc)
	i flag=1 d
	.d obj.WorkDate.Clear()
	.f i=1:1:$l(workDate,",") d
	..s wDate=$p(workDate,",",i)
	..q:wDate=""
	..d obj.WorkDate.Insert($zdh(wDate,3))
	.s sc=obj.%Save()
	.s flag=$$$ISOK(sc)
	i flag'=1 tro  q 0
	e  tc  q 1
}

}
