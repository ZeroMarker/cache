/// Descripition:护士长夜查房公共类
/// Date:2018-03-2-3
/// Creator:gzj
Class web.NurMgNightCheckComm Extends %RegisteredObject
{

/// Description:保存节假日设置
/// Date:2018-03-23
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveHolidaySet(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.DB.MgHolidaySet).%New()
	e  s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(id)
	s obj.HolidayYear=$g(tmp("HolidayYear"))
	i $g(tmp("HolidayCode"))'="" s obj.HolidayID=##class(DHCNMG.DB.MgSetCodeSub).%OpenId($g(tmp("HolidayCode")))
	e  s obj.HolidayCode=""
	s obj.HolidayDate=$g(tmp("HolidayDate"))
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// creator: gzj
/// createDate: 2018-03-26
/// description: 查询节假日列表数据
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindHolidayList","")
Query FindHolidayList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHolidayListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s year="" f  s year=$O(^DHCNMG.DB.MgHolidaySetI("code",year)) q:year=""  d
	.q:((parr'="")&&(year'=parr))
	.s code="" f  s code=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
	...s holidayyear=obj.HolidayYear
	...s holidaycode=obj.HolidayID.SubDesc
	...s holidaydate=$replace(obj.HolidayDate,",","--")
	...s ret="holidayyear|"_holidayyear_"^holidaycode|"_holidaycode_"^holidaydate|"_holidaydate_"^rowid|"_rowid
	...d OutHolidayList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHolidayList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHolidayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHolidayListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHolidayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHolidayListExecute ]
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

/// Description:
/// Creator:gzj
/// Date:2018-03-26
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetHolidayData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(id)
	q:'$IsObject(obj) ""
	s HolidayYear=obj.HolidayYear
	i obj.HolidayID'="" s HolidayID=obj.HolidayID.%Id()
	e  s HolidayID=""
	s HolidayDate=obj.HolidayDate
	s ret="HolidayYear|"_HolidayYear_"^HolidayCode|"_HolidayID_"^HolidayDate|"_HolidayDate_"^RowID|"_id
	q ret
}

/// Description:
/// Creator:gzj
/// Date:2018-03-26
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsExistCode1(parr As %String) As %String
{
	s ^TMP("IsExistCode")=parr
	s tmp=""
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",$g(tmp("HolidayYear")),$g(tmp("HolidayCode")),""))
	b ;01
	i id'=""
	{
		i rowid="" 
		{
			s flag=0
		}
		else
		{
			i rowid=id s flag=0
			e  s flag=1
		}
	}
	else //id空
	{
		i rowid=""
		{
			s flag=0
		}
		else
		{
			s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
			i obj.HolidayID.SubDesc="班" s flag=0
			e  s flag=1
		}
	}
	q flag
}

ClassMethod IsExistCode(parr As %String) As %String
{
	s ^TMP("IsExistCode")=parr
	//HolidayYear|2019^HolidayCode|15||8^HolidayDate|2019-09-29,2019-09-29^RowID|18
	s tmp=""
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",$g(tmp("HolidayYear")),$g(tmp("HolidayCode"))," "_$g(tmp("HolidayDate")),""))
	s isExist=0
	s dateStr="" f  s dateStr=$o(^DHCNMG.DB.MgHolidaySetI("flag",$g(tmp("HolidayYear")),$g(tmp("HolidayCode")),dateStr)) q:(dateStr=""||isExist=1)  d
	.b ;112
	.i (($tr(dateStr," ","")=$g(tmp("HolidayDate")))&&id="") s isExist=1
	.s startDate=$zdh($p($tr(dateStr," ",""),",",1),3)
	.s endDate=$zdh($p($tr(dateStr," ",""),",",2),3)
	.s inStart=$zdh($p($g(tmp("HolidayDate")),",",1),3)
	.s inEnd=$zdh($p($g(tmp("HolidayDate")),",",1),3)
	.b ;113
	.i ((((inStart>=startDate)&&(inStart<=endDate))||((inEnd>=startDate)&&(inEnd<=endDate)))&&(id="")) s isExist=1
	.
	b ;0001
	q isExist
}

ClassMethod CheckHoliday(date As %String) As %String
{
	q:date="" 0
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	s year=$p($zd(+$h,3),"-",1)
	f date1=startdate:1:enddate d
	.s outdate=date1,outcode="",flag=0
	.s code="" f  s code=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
	...i obj.HolidayDate'="" d
	....s stdate=$zdh($p(obj.HolidayDate,",",1),3)
	....s enddate=$zdh($p(obj.HolidayDate,",",2),3)
	....i (date1>=stdate)&&(date1<=enddate) d
	.....s outcode=obj.HolidayID.SubDesc
	.....s outdate=date1
	.....s flag=1
	.;i ret="" s ret="{""date"":"""_$zd(outdate,3)_""",""desc"":"""_outcode_"""}"
	.;e  s ret=ret_",{"""_"date"":"""_$zd(outdate,3)_""",""desc"":"""_outcode_"""}"
	.i ret="" s ret=""""_$zd(outdate,3)_""":"""_outcode_""""
	.e  s ret=ret_","""_$zd(outdate,3)_""":"""_outcode_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// creator: gzj
/// createDate: 2018-03-28
/// description: 
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","CheckIsHoliday","")
Query CheckIsHoliday(date As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod CheckIsHolidayExecute(ByRef qHandle As %Binary, date As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	q:date="" 0
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	s year=$p($zd(+$h,3),"-",1)
	f date1=startdate:1:enddate d
	.s outdate=date1,outcode="",flag=0
	.s code="" f  s code=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",year,code,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
	...i obj.HolidayDate'="" d
	....s stdate=$zdh($p(obj.HolidayDate,",",1),3)
	....s enddate=$zdh($p(obj.HolidayDate,",",2),3)
	....i (date1>=stdate)&&(date1<=enddate) d
	.....s outcode=obj.HolidayID.SubDesc
	.....s outdate=date1
	.....s flag=1
	.s ret="date|"_$zd(outdate,3)_"^desc|"_outcode
	.;e  s ret=ret_"^"_"date|"_$zd(outdate,3)_"^desc|"_outcode
	.d OutIsHoliday
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutIsHoliday
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CheckIsHolidayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckIsHolidayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckIsHolidayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckIsHolidayExecute ]
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

/// Creator: gzj
/// Date: 2018-04-09
/// Description: 保存夜查房排班数据
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod SaveSchduleRec(parr As %String, checktype As %String, sort As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s groups=..ComputeTaskNum1(tmp("CheckDate"),checktype,sort)
	i groups'=""
	{
		TS
		i id="" s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%New()
		e  s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(id)
		;s obj.CheckGroup=$g(tmp("CheckGroup"))
		s obj.CheckPerson=$g(tmp("CheckPerson"))
		s obj.CheckOPerson=$g(tmp("CheckPerson2"))
		s obj.CheckDate=$zdh($g(tmp("CheckDate")),3)
		s obj.CheckMonth=$p($g(tmp("CheckDate")),"-")_$p($g(tmp("CheckDate")),"-",2)
		s obj.CreateUser=$g(tmp("CreateUser"))
		s obj.CheckSpecialWard=$g(tmp("CheckWard"))
		s obj.CheckType=checktype
		s obj.CheckCount=sort
		d obj.CheckWards.Clear()
		s GroupType=$zcvt($g(tmp("GroupType")),"U")
		if GroupType'=""{
			s tgroups=0,isExist=0
			s GroupDesc="" f  s GroupDesc=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_checktype,GroupDesc)) q:((GroupDesc="")||(isExist=1))  d
			.q:$tr(GroupDesc," ","")=""
			.s tgroups=tgroups+1
			.i $tr(GroupDesc," ","")=GroupType d
			..s obj.TaskGroup=tgroups,isExist=1
			..s obj.CheckWardGroup=GroupType
			..s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_checktype," "_GroupType,sort)) q:sort=""  d
			...s checkWardId="" f  s checkWardId=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_checktype," "_GroupType,sort,checkWardId)) q:checkWardId=""  d
			....s checkWardObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(checkWardId)
			....q:'$IsObject(checkWardObj)
			....q:checkWardObj.WardID=""
			....d obj.CheckWards.Insert(checkWardObj.WardID)
		}
		s CheckTask=$g(tmp("CheckTask"))
		s CheckWork=""
		for i=1:1:$l(CheckTask,",")
		{
			s itm=$p(CheckTask,",",i)
			s CheckTaskObj=##class(DHCNMG.DB.MgQualItem).%OpenId(itm)
			i '$IsObject(CheckTaskObj) continue
			i CheckWork="" d
			.s CheckWork=CheckTaskObj.QualDesc_"^"_itm
			e  d
			.s CheckWork=CheckWork_","_CheckTaskObj.QualDesc_"^"_itm
			
		}
		s obj.CheckWork=CheckWork
		s sc=obj.%Save()
		s flag=$$$ISOK(sc)
		i flag'=1 {
			TRO
			q flag
		}
#;		f j=1:1:$l(obj.CheckWork,",") q:flag'=1  d
#;		.s qualItemId=$p(obj.CheckWork,",",j)
#;		.s qualItemId=$p(qualItemId,"^",2)
#;		.q:qualItemId=""
#;		.s itmsubId="" f  s itmsubId=$O(^DHCNMG.DB.MgQualItemSubD(qualItemId,itmsubId)) q:(itmsubId="")||(flag'=1)  d
#;		..s QualObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualItemId_"||"_itmsubId)
#;		..q:'$IsObject(QualObj)
#;		..s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%New()
#;		..s SubObj.Parref=obj
#;		..s SubObj.TaskItems=QualObj.SubDesc
#;		..s SubObj.TaskPar=QualObj.SubPar
#;		..s SubObj.TaskQual=qualItemId_"||"_itmsubId
#;		..s subsc=SubObj.%Save()
#;		..s flag=((flag)&&$$$ISOK(subsc))
		i flag=1
		{
			TC
		}
		else
		{
			TRollback
		}
		q flag
	}
	else
	{
		q ""
	}
}

/// Description:按照类型计算当前任务的检查科室个数及科室明细【未使用】
/// Date:2018-05-17
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod GetTaskTypeNum(groups, checkday, tasktype) As %String
{
	q:(groups=""||checkday=""||tasktype="") ""
	s month=$p(checkday,"-",1)_$p(checkday,"-",2)
	s RowID=$O(^DHCNMG.CHK.MgNurTaskGroupI("group",month,""))
	q:RowID="" "请先设置任务分组"
	s GroupObj=##class(DHCNMG.CHK.MgNurTaskGroup).%OpenId(RowID)
	s TaskNum=0
	i tasktype="N" s TaskNum=GroupObj.TaskGroup
	e  i tasktype="W" s TaskNum=GroupObj.TaskWGroup
	e  i tasktype="H" s TaskNum=GroupObj.TaskHGroup //组数
	//按照类型获取检查科室明细数目
	s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_tasktype,""),-1) //按照类型获取病区最大的sort值
	s wardAveNum=..Ceil(sort/TaskNum) //每组病区个数
	s tmp=""
	s group=1
	while(group<=TaskNum)
	{
		s n=1
		s j=(group-1)*wardAveNum+1
		for i=j:1:sort
		{
			i n>wardAveNum continue
			i $d(tmp(group,i))=0 s tmp(group,i)=i
			s n=n+1	
		}
		s group=group+1
	}
	s ret=""
	s order="" f  s order=$O(tmp(groups,order)) q:order=""  d
	.s rowid=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_tasktype,order,""))
	.q:rowid=""
	.s OrderObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(rowid)
	.i ret="" s ret=OrderObj.WardID
	.e  s ret=ret_"^"_OrderObj.WardID
	q ret
}

ClassMethod Ceil(num As %String) As %Integer
{
	i $l(num,".")=0 q num
	s Int=$p(num,".")
	s dec=$p(num,".",2)
	s fdec=$E(dec,1)
	i fdec>0 s Int=Int+1
	q Int
}

/// Creator: gzj【未使用】
/// Date: 2018-05-18
/// Description: 计算当天的任务为本月的组数 超过最大组数则返回提示 否则返回分组数
/// Table: 
/// Input:
/// Output:
/// Other:????????
ClassMethod ComputeTaskNum(checkday, tasktype) As %String
{
	s month=$p(checkday,"-",1)_$p(checkday,"-",2)
	//按照类型获取当月的任务分组数
	s GroupRow=$O(^DHCNMG.CHK.MgNurTaskGroupI("group",month,""))
	;q:GroupRow="" "请先设置本月的任务分组"
	q:GroupRow="" 1
	s groups=0
	s GrpObj=##class(DHCNMG.CHK.MgNurTaskGroup).%OpenId(GroupRow)
	i tasktype="N" s groups=GrpObj.TaskGroup
	e  i tasktype="W" s groups=GrpObj.TaskWGroup
	e  i tasktype="H" s groups=GrpObj.TaskHGroup
	;q:groups=0 "请设置当月任务分组数，最小为1"
	q:groups="" 1
	s monthdays=##class(web.NurMgVueComm).GetMonthDay(checkday) //计算当月天数
	s firstday=$P(checkday,"-",1)_"-"_$P(checkday,"-",2)_"-01" //当月第一天
	s lastday=$P(checkday,"-",1)_"-"_$P(checkday,"-",2)_"-"_monthdays
	s stdate=$zdh(firstday,3),enddate=$zdh(lastday,3)
	s tmp=""
	s date=stdate-1 f  s date=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date)) q:((date="")||((date'="")&&(date>enddate)))  d
	.s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,RowID)) q:RowID=""  d
	..s SchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..q:SchObj.CheckStatus="B"
	..q:SchObj.CheckType'=tasktype
	..i SchObj.TaskGroup'="" s tmp(SchObj.TaskGroup)=SchObj.TaskGroup
	s taskgroup=""
	if '$d(tmp) 
	{
		s taskgroup=1
	}
	else
	{
		f j=1:1:groups
		{		
			i $g(tmp(j))=j continue
			e  d
			.i taskgroup="" s taskgroup=j
			.e  continue
		}
	}
	i taskgroup=""
	{
		i tasktype="N" q "本月夜巡查排班已安排完毕"
		e  i tasktype="W" q "本月周末巡查排班已安排完毕"
		e  i tasktype="H" q "本月节假日巡查排班已安排完毕"
	}
	else
	{
		q taskgroup
	}
}

/// Creator: llin
/// Date: 2018-07-30
/// Description: 计算科室分组数
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod ComputeTaskNum1(checkday As %String, tasktype As %String, checkSort As %String) As %String
{
	s month=$p(checkday,"-",1)_$p(checkday,"-",2)
	s groups=0
	s GroupDesc="" f  s GroupDesc=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_tasktype,GroupDesc)) q:GroupDesc=""  d
	.q:$tr(GroupDesc," ","")=""
	.s groups=groups+1
	q:groups=0 "请设置科室分组"
	s monthdays=##class(web.NurMgVueComm).GetMonthDay(checkday) //计算当月天数
	s firstday=$P(checkday,"-",1)_"-"_$P(checkday,"-",2)_"-01" //当月第一天
	s lastday=$P(checkday,"-",1)_"-"_$P(checkday,"-",2)_"-"_monthdays
	s stdate=$zdh(firstday,3),enddate=$zdh(lastday,3)
	s tmp="",num=0
	;s date=stdate-1 f  s date=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date)) q:((date="")||((date'="")&&(date>enddate)))  d
	s date=stdate-1 f  s date=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date)) q:((date="")||((date'="")&&(date>enddate)))  d
	.;s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,RowID)) q:RowID=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date,checkSort,RowID)) q:RowID=""  d
	..s SchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..q:SchObj.CheckStatus="B"
	..q:SchObj.CheckType'=tasktype
	..;i SchObj.TaskGroup'="" s tmp(SchObj.TaskGroup)=SchObj.TaskGroup
	..i SchObj.TaskGroup'="" s num=SchObj.TaskGroup
	s num=num#groups
	q (num+1)
#;	s taskgroup=""
#;	if '$d(tmp) 
#;	{
#;		s taskgroup=1
#;	}
#;	else
#;	{
#;		f j=1:1:groups
#;		{		
#;			i $g(tmp(j))=j continue
#;			e  d
#;			.i taskgroup="" s taskgroup=j
#;			.e  continue
#;		}
#;	}
#;	i taskgroup=""
#;	{
#;		q 1
#;		i tasktype="N" q "本月夜巡查排班已安排完毕"
#;		e  i tasktype="W" q "本月周末巡查排班已安排完毕"
#;		e  i tasktype="H" q "本月节假日巡查排班已安排完毕"
#;	}
#;	else
#;	{
#;		q taskgroup
#;	}
}

/// Creator: gzj
/// Date: 2018-04-28
/// Description: 删除夜查房排班数据
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod DeleteDaySchdule(date As %String, role As %String, checkSort As %String) As %String
{
	q:date="" 0
	s isHLB=0
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s tRole=$tr($p(role,"^",i)," ","")
	.q:tRole=""
	.i tRole=0 s isHLB=1
	.q:isHLB=1
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(tRole)
	.s rolecode=RoleObj.RoleCode
	.i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")||(rolecode="manager")) d
	..s isHLB=1
	q:isHLB=0 "非护理部人员不可删除排班"
	s currentdate=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	;s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",currentdate,""))
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",currentdate,checkSort,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) ""
	;q:obj.CheckWork'="" "请先删除任务后再删除排班数据"
	s groupid=obj.CheckGroup
	;s obj.CheckStatus="B"
	s flag=1
	TS
	s flag=flag&&obj.%DeleteId(RowID)
	;s flag=flag&&obj.%Save()
	if flag'=1{
		TRO
		q 0	
	}
	s shiftId="" f  s shiftId=$O(^DHCNMG.CHK.MgNurCheckShiftI("date",currentdate,shiftId)) q:(shiftId="")||(flag'=1)  d
	.s shiftObj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(shiftId)
	.q:'$IsObject(shiftObj)
	.q:(shiftObj.ShiftStatus="HA")||(shiftObj.ShiftStatus="C")
	.s shiftObj.ShiftStatus="C"
	.s flag=flag&&shiftObj.%Save()
	if flag'=1{
		TRO
		q 0	
	}
	s shiftId="" f  s shiftId=$O(^DHCNMG.CHK.MgNurCheckShiftI("todate",currentdate,shiftId)) q:(shiftId="")||(flag'=1)  d
	.s shiftObj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(shiftId)
	.q:'$IsObject(shiftObj)
	.q:(shiftObj.ShiftStatus="HA")||(shiftObj.ShiftStatus="C")
	.s shiftObj.ShiftStatus="C"
	.s flag=flag&&shiftObj.%Save()
	i flag=1
	{
		TC
		q 1
	}else{
		TRO
		q 0	
	}
}

/// Creator: gzj
/// Date: 2018-04-09
/// Description: 根据职务类型查询人员名单
/// Table: 
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindNurseForType","护士长!科护士长^N","")
Query FindNurseForType(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurseForTypeExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s code=$p(parr,"^")
	s type=$P(parr,"^",2)
	
	s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," 职务",""))
	i par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s len=$l(code,"!")
	s item=""
	f i=1:1:len
	{
		s itm=$p(code,"!",i)
		q:itm=""
		s raw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_$zcvt($tr(itm," ",""),"U"),""))
		i item="" s item=par_"||"_raw
		e  s item=item_"^"_par_"||"_raw
	}
	i item="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	k tmp
	s tmp=""
	s depdr="" f  s depdr=$O(^DHCNMG.HR.MgPersonsI("DepID",depdr)) q:depdr=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID",depdr,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	..q:obj.PerCareType'="N"
	..q:obj.PerTypeDR'="N"
	..s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	..q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;在职
	..s PerName=obj.PerName
	..s PerID=obj.PerID
	..s shellName=##class(web.NurMgVueComm).ToChineseSpell(PerName)
	..q:(input'="")&&((PerName_PerID_shellName)'[$zcvt(input,"U"))
	..s flag=0
	..s PostDate="" f  s PostDate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",RowID,PostDate)) q:PostDate=""  d
	...s PostID="" f  s PostID=$O(^DHCNMG.HR.MgPostDutyI("PostDate",RowID,PostDate,PostID)) q:PostID=""  d
	....s PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostID)
	....q:'$IsObject(PostObj)
	....q:PostObj.PostStatus'="A"
	....s stDate=PostObj.PostStDate
	....s endDate=PostObj.PostEndDate
	....q:(stDate'="")&&(stDate>+$H)
	....q:(endDate'="")&&(endDate<+$H)
	....q:((PostObj.PostDuty'=$p(item,"^",1))&&(PostObj.PostDuty'=$p(item,"^",2)))
	....s flag=1
	..i flag=1 d
	...s currentWard=##class(web.NurMgHRComm).GetCurrentWard(RowID,+$h)
	...s NurseWard=""
	...s NurseWardObj=##class(DHCNMG.DB.MgWard).%OpenId(currentWard)
	...i $IsObject(NurseWardObj) s NurseWard=NurseWardObj.WardDesc
	...s ableflag=1,GroupName="",sort=1
	...i $d(^DHCNMG.CHK.MgNurCheckGroupI("Per"," "_type," "_RowID)) d
	....s ableflag=0,sort=2
	....s groupId=$O(^DHCNMG.CHK.MgNurCheckGroupI("Per"," "_type," "_RowID,""))
	....s groupObj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(groupId)
	....i $IsObject(groupObj) s GroupName=$case(groupObj.GroupCategory,"I":"大内科","O":"大外科",:"")
	...s tmp(sort,RowID)="NurseName|"_PerName_"^RowID|"_RowID_"^NurseWard|"_NurseWard_"^ableflag|"_ableflag_"^GroupName|"_GroupName
	s ret=""
	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	.s RowID="" f  s RowID=$O(tmp(sort,RowID)) q:RowID=""  d
	..s ret=tmp(sort,RowID)
	..d OutNurseList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseForTypeExecute ]
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

/// Creator: gzj
/// Date: 2018-04-09
/// Description: 保存夜查房分组
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod SaveGroupRec(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%New()
	e  s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	s sort=0
	s groupsort=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_tmp("GroupType"),""),-1)
	i groupsort="" s groupsort=0
	s sort=groupsort+1
	s obj.GroupType=$g(tmp("GroupType"))
	s obj.GroupCategory=$g(tmp("GroupCategory"))
	s obj.GroupPerson=$g(tmp("GroupPerson"))
	s obj.CreateUser=$g(tmp("CreateUser"))
	i id="" s obj.GroupSort=sort
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator: gzj
/// Date: 2018-04-09
/// Description: 查询分组数据
/// Table: 
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindCheckGroupList","")
Query FindCheckGroupList(type As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckGroupListExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurCheckGroupD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(RowID)
	.q:((type'="")&&(obj.GroupType'=type))
	.i obj.GroupType'="" d
	..s codeobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.GroupType)
	..q:'$IsObject(codeobj)
	..s groupType=codeobj.SubDesc
	.e  s groupType=""
	.s groupCategory=obj.GroupCategory
	.s perlist=obj.GroupPerson
	.s groupPerson=..GetUserInfo(perlist)
	.s createUser=""
	.i obj.CreateUser=0 s createUser="系统管理员"
	.e  d
	..s userobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CreateUser)
	..q:'$IsObject(userobj)
	..s createUser=userobj.PerName
	.s createDate=$zd(obj.CreateDate,3)
	.s createTime=$zt(obj.CreateTime,2)
	.s ret="groupType|"_groupType_"^groupCategory|"_groupCategory_"^groupPerson|"_groupPerson_"^createUser|"_createUser_"^createDate|"_createDate_"^createTime|"_createTime_"^RowID|"_RowID
	.d OutGroupList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckGroupListExecute ]
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

ClassMethod GetUserInfo(perlist As %String) As %String
{
	s ret=""
	s len=$L(perlist,",")
	f i=1:1:len
	{
		s itm=$P(perlist,",",i)
		i itm="" continue
		s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perobj)
		i ret="" s ret=perobj.PerName_"("_perobj.PerID_")"
		e  s ret=ret_","_perobj.PerName_"("_perobj.PerID_")"
	}
	q ret
}

/// Creator: gzj
/// Date: 2018-04-10
/// Description: 获取夜查房排班组数据
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod GetCheckGroupRec(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s GroupCategory=obj.GroupCategory
	s GroupPerson=obj.GroupPerson
	s GroupType=obj.GroupType
	s ret="GroupCategory|"_GroupCategory_"^GroupPerson|"_GroupPerson_"^GroupType|"_GroupType_"^RowID|"_id
	q ret
}

/// Creator: gzj
/// Date: 2018-04-11
/// Description: 按照类型获取夜查房排班组
/// Table: 
/// Input:
/// Output:
/// Other:
ClassMethod GetDaySchdule(parr As %String) As %String
{
	s Type=$p(parr,"^")
	s GroupType=$p(parr,"^",2)
	s date=$p(parr,"^",3)
	s:date["-" date=$zdh(date,3)
	s ret=""
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," 护士长夜查房类型",""))
	q:Par="" ""
	s Rw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par," "_Type,""))
	q:Rw="" ""
	s RowID=Par_"||"_Rw
	s rec="",currentsort=""
	s maxsort=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_RowID,""),-1) //获取该类型中最大的序号
	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_RowID,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_RowID,sort,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	..i obj.GroupStatus="Y" s rec=rowid,currentsort=obj.GroupSort //组已经使用过 获得该组的序号
	s nextsort=1
	i currentsort'="" d
	.i (currentsort+1)>maxsort s nextsort=1
	.e  s nextsort=(currentsort+1)
	s ret=..GetDaySchdule1(RowID,nextsort,Type,GroupType,date,nextsort)
	q ret
}

/// Creator: lulin
/// Date: 2018-08-27
/// Description: 获取夜查房排班组，如果和科室重复自动顺延到下一组,如果请假返回提示
/// Table: 
/// Input:检查组id，类型，检查科室组
/// Output:
/// Other:
ClassMethod GetDaySchdule1(rowid, sort, type, group, date, sSort) As %String
{
	s:date["-" date=$zdh(date,3)
	s ret=""
	s RecRowID=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_rowid,sort,""))
	s maxsort=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_rowid,""),-1) 
	s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(RecRowID)
	s nextSort=sort+1
	s:nextSort>maxsort nextSort=1
	q:nextSort=sSort ret
	d:'$IsObject(obj) ..GetDaySchdule1(rowid,nextSort,type,group,date,sSort)
	s persons=obj.GroupPerson
	k tmpWard,tmpPer
	s tmpWard="",tmpPer=""
	s len=$p(persons,",")
	s message=""
	f i=1:1:len 
	{
		s itm=$p(persons,",",i)
		i itm="" continue
		s tmpPer(itm)=itm
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perObj)
		s isLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(itm_"^"_date)
		i isLeave=1 d
		.i message="" s message=perObj.PerName_"已请假"
		.e  s message=perObj.PerName_","_message
	}
	s ret="groupid|"_obj.%Id()_"^groupperson|"_obj.GroupPerson_"^message|"_message
	;检查组人是否在某个科室检查组，存在则自动延下一组
	s flag=$D(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group))
	q:'flag ret
	s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitD(limitId)) q:limitId=""  d
	.s limitObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitId)
	.q:'$IsObject(limitObj)
	.i $d(tmpPer(limitObj.LimitNurse)) d
	..s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	...s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	...q:'$IsObject(limitSubObj)
	...q:limitSubObj.SubWard=""
	...q:$d(tmpWard(limitSubObj.SubWard))
	...s tmpWard(limitSubObj.SubWard)=limitSubObj.SubWard
	s flagGroup=0  
	i flag d
	.s groupSort="" f  s groupSort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,groupSort)) q:(groupSort="")||(flagGroup=1)  d
	..s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,groupSort,id)) q:(id="")||(flagGroup=1)  d
	...s checkGroupObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	...q:'$IsObject(checkGroupObj)
	...q:checkGroupObj.WardID=""
	...i $D(tmpWard(checkGroupObj.WardID)) s flagGroup=1
	q:flagGroup=1 ..GetDaySchdule1(rowid,nextSort,type,group,date,sSort)
	q:flagGroup=0 ret
}

/// Description：根据类型获取分组信息
/// Date:2018-04-24
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCheckGroups(type As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckGroupsExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s Par=$O(^DHCNMG.DB.MgSetCodeI("Code"," 护士长夜查房类型",""))
	i Par'="" d
	.s Rw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",Par," "_type,""))
	.i Rw'="" d
	..s RowID=Par_"||"_Rw
	..s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_RowID,sort)) q:sort=""  d
	...s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("sort"," "_RowID,sort,rowid)) q:rowid=""  d
	....s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	....s label=obj.GroupCategory
	....s id=rowid
	....s ret="id|"_id_"^label|"_label
	....d OutGroups
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroups
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckGroupsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckGroupsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckGroupsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckGroupsExecute ]
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

/// Description：根据类型获取分组人员信息
/// Date:2018-04-24
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetGroupPersons(id) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s persons=obj.GroupPerson
	s len=$p(persons,",")
	f i=1:1:len 
	{
		s itm=$p(persons,",",i)
		i itm="" continue
		s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		s value=itm,label=perobj.PerName
		i ret="" s ret="{""value"":"""_value_""",""label"":"""_label_"""}"
		e  s ret=ret_",{""value"":"""_value_""",""label"":"""_label_"""}"
	}
	s ret="["_ret_"]"
	q ret
}

/// 
/// ???????
ClassMethod FindDaySchdule(date As %String) As %String
{
	q:date="" ""
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	f stdate=startdate:1:enddate d
	.s names=""
	.;s RowID=..GetSchduleIDByDate(stdate)
	.s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	.i RowID'="" d
	..s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..s checkdate=Obj.CheckDate
	..i checkdate=stdate d
	...s person=Obj.CheckPerson
	...s len=$l(person,",")
	...f i=1:1:len d
	....s itm=$p(person,",",i)
	....i itm'="" d
	.....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
	.....s name=perobj.PerName
	.....i names="" s names=name
	.....e  s names=names_","_name
	.i ret="" s ret=""""_$zd(stdate,3)_""":"""_names_""""
	.e  s ret=ret_","""_$zd(stdate,3)_""":"""_names_""""
	
	s ret="[{"_ret_"}]"
	q ret
}

/// 
/// ????????
ClassMethod GetDayFlag(date As %String, role As %String, nurseid As %String) As %String
{
	q:date="" ""
	s rolecode=""
	i role=0 s rolecode="admin"
	e  d
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	.q:'$IsObject(RoleObj)
	.s rolecode=RoleObj.RoleCode
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	f stdate=startdate:1:enddate d
	.s flag=0
	.s names=""
	.;s RowID=..GetSchduleIDByDate(stdate)
	.s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	.i RowID'="" d
	..s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..s personlist=Obj.CheckPerson
	..s len=$l(personlist,",")
	..f j=1:1:len d
	...s itm=$p(personlist,",",j)
	...i (((rolecode'="admin")&&(rolecode'="hlb")&&(rolecode'="hlbzr"))&&(itm=nurseid)) s flag=flag+1
	...e  i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")) s flag=flag+1
	.i ret="" s ret=""""_$zd(stdate,3)_""":"""_flag_""""
	.e  s ret=ret_","""_$zd(stdate,3)_""":"""_flag_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// Description:获取一天的排班任务flag
/// Date:2018-05-25
/// Creator:gzj
/// ?????????????
ClassMethod GetDayTaskFlag(date As %String, role As %String, nurseid As %String) As %String
{
	q:date="" 0
	s stdate=$zdh(date,3)
	s rolecode=""
	i role=0 s rolecode="admin"
	e  d
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	.q:'$IsObject(RoleObj)
	.s rolecode=RoleObj.RoleCode
	s ret=""
	s flag=0
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	q:RowID="" 0
	s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	s personlist=Obj.CheckPerson
	s len=$l(personlist,",")
	f j=1:1:len d
	.s itm=$p(personlist,",",j)
	.i (((rolecode'="admin")&&(rolecode'="hlb")&&(rolecode'="hlbzr"))&&(itm=nurseid)) s flag=flag+1
	.e  i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")) s flag=flag+1
	i ret="" s ret=""""_$zd(stdate,3)_""":"""_flag_""""
	e  s ret=ret_","""_$zd(stdate,3)_""":"""_flag_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// Description:获取一天的的任务时限
/// Date:2018-05-25
/// Creator:gzj
/// ???????
ClassMethod GetDayQualFlag(date As %String, role As %String, nurseid As %String) As %String
{
	q:date="" 0
	s currentdate=+$H
	s stdate=$zdh(date,3)
	s rolecode=""
	i role=0 s rolecode="admin"
	e  d
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	.q:'$IsObject(RoleObj)
	.s rolecode=RoleObj.RoleCode
	s ret=""
	s flag=0
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	q:RowID="" 0
	s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	s worklist=Obj.CheckWork
	i worklist'="" d
	.i ((rolecode'="admin"&&rolecode'="hlb"&&rolecode'="hlbzr")&&(stdate<=(currentdate+1))) s flag=1
	.e  i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")) s flag=1
	i ret="" s ret=""""_$zd(stdate,3)_""":"""_flag_""""
	e  s ret=ret_","""_$zd(stdate,3)_""":"""_flag_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// Description:获取检查任务
/// Date:2018-05-14
/// Creator:gzj
/// ???????????
ClassMethod FindDayTask(date As %String) As %String
{
	q:date="" ""
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	f stdate=startdate:1:enddate d
	.s desc=""
	.;s RowID=..GetSchduleIDByDate(stdate)
	.s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	.i RowID'="" d
	..s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..s work=obj.CheckWork
	..s len=$l(work,",")
	..f i=1:1:len d
	...s itm=$P($p(work,",",i),"^",1)
	...i itm'="" d
	....i desc="" s desc=itm
	....e  s desc=desc_","_itm
	.i ret="" s ret=""""_$zd(stdate,3)_""":"""_desc_""""
	.e  s ret=ret_","""_$zd(stdate,3)_""":"""_desc_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// Descriptions:设置检查者只有在前一天才能看到检查任务
/// Date:2018-05-25
/// Creator:gzj
/// ????????
ClassMethod SetShowTask(date As %String, role As %String, nurseid As %String) As %String
{
	q:date="" ""
	s currentdate=+$H
	i role="0" s rolecode="admin"
	e  d
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	.s rolecode=RoleObj.RoleCode
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	f stdate=startdate:1:enddate d
	.s flag=0,flag1=0
	.s names=""
	.;s RowID=..GetSchduleIDByDate(stdate)
	.s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	.i RowID'="" d
	..s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..s personlist=Obj.CheckPerson
	..s len=$l(personlist,",")
	..f j=1:1:len d
	...s itm=$p(personlist,",",j)
	...i (((rolecode'="admin")&&(rolecode'="hlb")&&(rolecode'="hlbzr"))&&(itm=nurseid)) s flag=flag+1
	...e  i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")) s flag=flag+1
	..s worklist=Obj.CheckWork
	..i worklist'="" d
	...i ((flag=1)&&((rolecode'="admin"&&rolecode'="hlb"&&rolecode'="hlbzr")&&(stdate<=(currentdate+1)))) s flag1=1
	...e  i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")) s flag1=1
	...e  s flag1=0
	.i ret="" s ret=""""_$zd(stdate,3)_""":"""_flag1_""""
	.e  s ret=ret_","""_$zd(stdate,3)_""":"""_flag1_""""
	s ret="[{"_ret_"}]"
	q ret
}

/// ????????????
ClassMethod GetOneDaySchdule(date As %String) As %String
{
	q:date="" ""
	s ret=""
	s stdate=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) ""
	s person=obj.CheckPerson
	s len=$l(person,",")
	f i=1:1:len
	{
		s itm=$p(person,",",i)
		i itm="" continue
		s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perobj)
		i ret="" s ret=perobj.PerName
		e  s ret=ret_","_perobj.PerName
	}
	q ret
}

/// ?????
ClassMethod GetOneDayTask(date As %String) As %String
{
	q:date="" ""
	s ret=""
	s stdate=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",stdate,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) ""
	s tasklist=obj.CheckWork
	s len=$l(tasklist,",")
	f i=1:1:len
	{
		s itm=$p(tasklist,",",i)
		i itm="" continue
		i ret="" s ret=$p(itm,"^",1)
		e  s ret=ret_","_$p(itm,"^",1)
	}
	q ret
}

/// Description：加载护士长夜查房项目列表
/// Date:2018-05-03
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindNightItems","2019","QUALTYPE","HOLIDAYCHECK")
Query FindNightItems(year As %String, type As %String, Code As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNightItemsExecute(ByRef qHandle As %Binary, year As %String, type As %String, Code As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i year="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Par=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(type," ",""),"U"),"")) //QUALTYPE
	i Par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Rw=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt($tr(Code," ",""),"U"),Par,""))  //NIGHTCHECK
	i Rw="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RowID=Par_"||"_Rw
	s SubID="" f  s SubID=$o(^DHCNMG.DB.MgQualItemI("Type",year,SubID)) q:SubID=""  d
	.s Row="" f  s Row=$O(^DHCNMG.DB.MgQualItemI("Type",year,SubID,Row)) q:Row=""  d
	..s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(Row)
	..s flag=0
	..s len=$l(obj.QualType,",")
	..f i=1:1:len d
	...s itm=$p(obj.QualType,",",i)
	...q:itm=""
	...i itm=RowID s flag=1
	..q:flag=0
	..s Itm="",Jan="",Feb="",Mar="",Apr="",May="",Jun="",Jul="",Aug="",Sep="",Oct="",Nov="",Dece=""
	..s Itm=obj.QualDesc
	..s ret="Itm|"_Itm_"^Jan|"_Jan_"^Feb|"_Feb_"^Mar|"_Mar_"^Apr|"_Apr_"^May|"_May_"^Jun|"_Jun_"^Jul|"_Jul_"^Aug|"_Aug_"^Sep|"_Sep_"^Oct|"_Oct_"^Nov|"_Nov_"^Dece|"_Dece_"^RowID|"_"^ItmID|"_Row
	..d OutNightItems
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNightItems
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNightItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightItemsExecute ]
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

ClassMethod SavePlanItems(year As %String, type As %String, parr As %String) As %String
{
	q:parr="" ""
	
	TS
	s flag=1
	s rowid=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",year," "_type,""))
	i rowid="" s ParObj=##class(DHCNMG.CHK.MgNurCheckPlan).%New()
	e  s ParObj=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(rowid)
	s ParObj.CheckYear=year
	s ParObj.CheckType=type
	s sc=ParObj.%Save()
	s par=ParObj.%Id()
	i $$$ISOK(sc)=1
	{
		s flag1=1
		s len=$l(parr,"「")
		f i=1:1:len
		{
			s str=$p(parr,"「",i)
			i str="" continue
			s tmp=""
			d ##class(web.NurMgVueComm).SplitStr(str,"^","|",.tmp)
			s id=$g(tmp("RowID"))
			i id="" d
			.s obj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%New()
			.s obj.Parref=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(par)
			e  s obj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId($tr(id,"__","||"))
			i $g(tmp("Itm"))'="" s obj.Itm=$tr($g(tmp("Itm"))," ","")
			e  s obj.Itm=""
			i $g(tmp("ItmID"))'="" s obj.ItmID=tmp("ItmID")
			e  s obj.ItmID=""
			i $g(tmp("Jan"))'="" s obj.Jan=tmp("Jan")
			e  s obj.Jan=""
			i $g(tmp("Feb"))'="" s obj.Feb=tmp("Feb")
			e  s obj.Feb=""
			i $g(tmp("Mar"))'="" s obj.Mar=tmp("Mar")
			e  s obj.Mar=""
			i $g(tmp("Apr"))'="" s obj.Apr=tmp("Apr")
			e  s obj.Apr=""
			i $g(tmp("May"))'="" s obj.May=tmp("May")
			e  s obj.May=""
			i $g(tmp("Jun"))'="" s obj.Jun=tmp("Jun")
			e  s obj.Jun=""
			i $g(tmp("Jul"))'="" s obj.Jul=tmp("Jul")
			e  s obj.Jul=""
			i $g(tmp("Aug"))'="" s obj.Aug=tmp("Aug")
			e  s obj.Aug=""
			i $g(tmp("Sep"))'="" s obj.Sep=tmp("Sep")
			e  s obj.Sep=""
			i $g(tmp("Oct"))'="" s obj.Oct=tmp("Oct")
			e  s obj.Oct=""
			i $g(tmp("Nov"))'="" s obj.Nov=tmp("Nov")
			e  s obj.Nov=""
			i $g(tmp("Dece"))'="" s obj.Dece=tmp("Dece")
			e  s obj.Dece=""
			;s p="" f  s p=$O(^oddCOM("DHCNMG.CHK.MgNurCheckPlanSub","a",p)) q:p=""  d
			;.q:p["%"
			;.i $D(tmp(p)) d
			;..i tmp(p)="false" s tmp(p)=""
			;..s $ZOBJPROPERTY(obj,p)=tmp(p)
			s scc=obj.%Save()
			s flag1=flag1&&$$$ISOK(scc)
		}
		i flag1=1 
		{
			TC
		}
		else
		{
			Trollback
		}
		s flag=(flag&&$$$ISOK(sc)&&flag1)
	}
	else
	{
		s flag=(flag&&$$$ISOK(sc))
		Trollback
	}
	
	q flag
}

/// Description：查询查房计划
/// Date:2018-05-03
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCheckPlanList(year As %String, type As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPlanListExecute(ByRef qHandle As %Binary, year As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s Year="" f  s Year=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",Year)) q:Year=""  d
	.s Type="" f  s Type=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",Year,Type)) q:Type=""  d
	..s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",Year,Type,RowID)) q:RowID=""  d
	...s Obj=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(RowID)
	...q:((year'="")&&(Obj.CheckYear'=year))
	...q:((type'="")&&(Obj.CheckType'=type))
	...s TaskYear=Obj.CheckYear
	...i Obj.CheckType="N" s TaskType="夜巡查"
	...e  i Obj.CheckType="W" s TaskType="周末巡查"
	...e  i Obj.CheckType="H" s TaskType="节假日巡查"
	...e  s TaskType=""
	...s ret="TaskYear|"_TaskYear_"^TaskType|"_TaskType_"^RowID|"_RowID_"^Type|"_Obj.CheckType
	...d OutPlanLists
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanLists
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPlanListExecute ]
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

/// Description：加载已保存的护士长夜查房项目
/// Date:2018-05-03
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindSaveItems(Par As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSaveItemsExecute(ByRef qHandle As %Binary, Par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s Obj=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(Par)
	i '$IsObject(Obj) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret="",tmp=""
	//获取质控类型
	s year=Obj.CheckYear
	s type="QUALTYPE",code=""
	i Obj.CheckType="N" s code="NIGHTCHECK"
	e  i Obj.CheckType="W"  s code="WEEKCHECK"
	e  i Obj.CheckType="H"  s code="HOLIDAYCHECK"
	i year="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ParID=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(type," ",""),"U"),"")) //QUALTYPE
	i ParID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RW=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt($tr(code," ",""),"U"),ParID,""))  //NIGHTCHECK
	i RW="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RowID=ParID_"||"_RW
	s Rw="" f  s Rw=$O(^DHCNMG.CHK.MgNurCheckPlanSubD(Par,Rw)) q:Rw=""  d
	.s Itm="",Jan="",Feb="",Mar="",Apr="",May="",Jun="",Jul="",Aug="",Sep="",Oct="",Nov="",Dece=""
	.s SubObj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId(Par_"||"_Rw)
	.q:'$IsObject(SubObj)
	.s itemObj=##class(DHCNMG.DB.MgQualItem).%OpenId(SubObj.ItmID)
	.q:itemObj.QualType'[RowID
	.s Itm=SubObj.Itm
	.s Jan=SubObj.Jan
	.s Feb=SubObj.Feb
	.s Mar=SubObj.Mar
	.s Apr=SubObj.Apr
	.s May=SubObj.May
	.s Jun=SubObj.Jun
	.s Jul=SubObj.Jul
	.s Aug=SubObj.Aug
	.s Sep=SubObj.Sep
	.s Oct=SubObj.Oct
	.s Nov=SubObj.Nov
	.s Dece=SubObj.Dece
	.s ItmID=SubObj.ItmID
	.s tmp(ItmID)=ItmID
	.s ret="Itm|"_Itm_"^Jan|"_Jan_"^Feb|"_Feb_"^Mar|"_Mar_"^Apr|"_Apr_"^May|"_May_"^Jun|"_Jun_"^Jul|"_Jul_"^Aug|"_Aug_"^Sep|"_Sep_"^Oct|"_Oct_"^Nov|"_Nov_"^Dece|"_Dece_"^RowID|"_Par_"__"_Rw_"^ItmID|"_ItmID
	.d OutNightItems
	
	;s Row="" f  s Row=$O(^DHCNMG.DB.MgQualItemI("Type",year," "_RowID,Row)) q:Row=""  d
	s TypeTmp="" f  s TypeTmp=$o(^DHCNMG.DB.MgQualItemI("Type",year,TypeTmp)) q:TypeTmp=""  d
	.q:(TypeTmp'[RowID)
	.s Row="" f  s Row=$O(^DHCNMG.DB.MgQualItemI("Type",year,TypeTmp,Row)) q:Row=""  d
	..q:$d(tmp(Row))
	..s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(Row)
	..s Itm="",Jan="",Feb="",Mar="",Apr="",May="",Jun="",Jul="",Aug="",Sep="",Oct="",Nov="",Dece=""
	..s Itm=obj.QualDesc
	..s ret="Itm|"_Itm_"^Jan|"_Jan_"^Feb|"_Feb_"^Mar|"_Mar_"^Apr|"_Apr_"^May|"_May_"^Jun|"_Jun_"^Jul|"_Jul_"^Aug|"_Aug_"^Sep|"_Sep_"^Oct|"_Oct_"^Nov|"_Nov_"^Dece|"_Dece_"^RowID|"_"^ItmID|"_Row
	..d OutNightItems
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNightItems
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSaveItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSaveItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSaveItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSaveItemsExecute ]
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

/// Description：夜查房查房检查病区系统病区
/// Date:2018-05-04
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCheckWardSet(type As %String, parr As %String = "", input As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckWardSetExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "", input As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	k tmp
	s tmp=""
	s wards=""
	i parr'="" d
	.s locID="" f  s locID=$o(^DHCNMG.DB.MgWardLocI("Area",parr,locID)) q:locID=""  d
	..s containWard="" f  s containWard=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",locID,containWard)) q:containWard=""  d
	...i wards="" s wards="^"_containWard_"^"
	...e  s wards=wards_containWard_"^"
	
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..q:'$IsObject(Obj)
	..;q:(parr'="")&&(('$IsObject(Obj.WardAreaDR))||(Obj.WardAreaDR.%Id()'=parr))
	..q:((parr'="")&&(wards'[("^"_RowID_"^")))
	..s sInput=Obj.WardSpell_Obj.WardCode_Obj.WardDesc
	..s sInput=$zcvt(sInput,"U")
	..q:((input'="")&&((sInput)'[$zcvt($tr(input," ",""),"U")))
	..s warddesc=Obj.WardDesc_Obj.WardRemark
	..i (type'="")&&($d(^DHCNMG.DB.MgNurCheckWardI("Type"," "_type," "_RowID))) d
	...s tmp(2,Sort,RowID)="warddesc|"_warddesc_"^wardid|"_RowID_"^flag|0"
	..e  s tmp(1,Sort,RowID)="warddesc|"_warddesc_"^wardid|"_RowID_"^flag|1"
	s flag="" f  s flag=$O(tmp(flag)) q:flag=""  d
	.s Sort="" f  s Sort=$O(tmp(flag,Sort)) q:Sort=""  d
	..s RowID="" f  s RowID=$O(tmp(flag,Sort,RowID)) q:RowID=""  d
	...s ret=tmp(flag,Sort,RowID)
	...d OutCheckWardSet
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckWardSet
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckWardSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckWardSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckWardSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckWardSetExecute ]
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

/// Description:保存检查病区
/// Date:2018-05-05
/// Creator:gzj
/// Table:DHCNMG.DB.MgNurCheckWard
/// Input:
/// Output:
/// return:
ClassMethod SaveCheckWard(type As %String, parr As %String) As %String
{
	s flag=1
	s len=$l(parr,"^")
	
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s RowID=$O(^DHCNMG.DB.MgNurCheckWardI("Type"," "_type," "_itm,""))
		i RowID=""
		{
			s obj=##class(DHCNMG.DB.MgNurCheckWard).%New()
			s obj.WardID=itm
			s obj.WardType=type
			s obj.WardSort=..GetWardSort(type)
			s sc=obj.%Save()
			s flag=flag&&$$$ISOK(sc)
		}
	}
	q flag
}

/// Description:保存检查病区分组
/// Date:2018-05-05
/// Creator:gzj
/// Table:DHCNMG.DB.MgNurCheckWard
/// Input:
/// Output:
/// return:
ClassMethod SaveCheckWardGroup(type As %String, grouptype As %String, parr As %String) As %String
{
	s flag=1
	s len=$l(parr,"^")
	
	f i=1:1:len
	{
		s id=$p(parr,"^",i)
		s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
		q:'$IsObject(obj)
		s obj.WardGroup=$zcvt($tr(grouptype," ",""),"U")
		s obj.WardGroupSort=..GetWardGroupSort(type,grouptype)
		s sc=obj.%Save()
		s flag=flag&&$$$ISOK(sc)
	}
	q flag
}

/// Description:删除检查病区
/// Date:2018-05-05
/// Creator:gzj
/// Table:DHCNMG.DB.MgNurCheckWard
/// Input:
/// Output:
/// return:
ClassMethod DeleteCheckWard(type As %String, parr As %String) As %String
{
	s flag=1
	s len=$l(parr,"^")
	Ts
	f i=1:1:len
	{
		s id=$p(parr,"^",i)
		s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
		q:'$IsObject(obj)
		s sc=obj.%DeleteId(id)
		s flag=flag&&$$$ISOK(sc)
	}
	q:flag'=1 0
	s tsort=1
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_type,Sort))  q:(Sort="")||(flag'=1)  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_type,Sort,id)) q:(id="")||(flag'=1)  d
	..s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	..q:'$IsObject(obj)
	..s obj.WardSort=tsort
	..s sc=obj.%Save()
	..s flag=flag&&$$$ISOK(sc)
	..q:flag'=1
	..s tsort=tsort+1
	if flag=1{
		TC
	}else{
		TRO	
	}
	q flag
}

/// Description:删除检查病情某一组
/// Date:2018-05-05
/// Creator:gzj
/// Table:DHCNMG.DB.MgNurCheckWard
/// Input:
/// Output:
/// return:
ClassMethod DeleteCheckGroup(type As %String, parr As %String) As %String
{
	s flag=1
	s len=$l(parr,"^")
	s parr=$zcvt($tr(parr," ",""),"U")
	q:type="" 0
	q:parr="" 1
	Ts
	s group="" f  s group=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type,group))  q:(group="")||(flag'=1)  d
	.q:(parr'=$zcvt($tr(group," ",""),"U"))
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type,group,sort))  q:(sort="")||(flag'=1)  d
	..s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type,group,sort,id)) q:(id="")||(flag'=1)  d
	...s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	...q:'$IsObject(obj)
	...s obj.WardGroup=""
	...s obj.WardGroupSort=""
	...s sc=obj.%Save()
	...s flag=flag&&$$$ISOK(sc)
	if flag=1{
		TC
	}else{
		TRO	
		s flag=0
	}
	q flag
}

/// Description:删除检查病区某组病区
/// Date:2018-05-05
/// Creator:gzj
/// Table:DHCNMG.DB.MgNurCheckWard
/// Input:
/// Output:
/// return:
ClassMethod DeleteCheckGroupWard(type As %String, parr As %String) As %String
{
	s flag=1
	s len=$l(parr,"^")
	s groupttype=""
	Ts
	f i=1:1:len
	{
		s id=$p(parr,"^",i)
		s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
		q:'$IsObject(obj)
		s:groupttype="" grouptype=obj.WardGroup
		s obj.WardGroup=""
		s obj.WardGroupSort=""
		s sc=obj.%Save()
		s flag=flag&&$$$ISOK(sc)
	}
	s grouptype=$zcvt($tr(grouptype," ",""),"U") 
	if (flag'=1)||(grouptype=""){
		TRO
		q 0	
	}
	s tsort=1
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_grouptype,Sort))  q:(Sort="")||(flag'=1)  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_grouptype,Sort,id)) q:(id="")||(flag'=1)  d
	..s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	..q:'$IsObject(obj)
	..s obj.WardGroupSort=tsort
	..s sc=obj.%Save()
	..s flag=flag&&$$$ISOK(sc)
	..q:flag'=1
	..s tsort=tsort+1
	if flag=1{
		TC
	}else{
		TRO	
	}
	q flag
}

/// Description：查询检查病区列表
/// Date:2018-05-05
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCheckWardList","N","","","0")
Query FindCheckWardList(type As %String, parr As %String = "", input As %String, flag As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckWardListExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "", input As %String, flag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	k tmp
	s tmp=""
	s wards=""
	i parr'="" d
	.s locID="" f  s locID=$o(^DHCNMG.DB.MgWardLocI("Area",parr,locID)) q:locID=""  d
	..s containWard="" f  s containWard=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",locID,containWard)) q:containWard=""  d
	...i wards="" s wards="^"_containWard_"^"
	...e  s wards=wards_containWard_"^"
	s Typ="" f  s Typ=$O(^DHCNMG.DB.MgNurCheckWardI("Sort",Typ)) q:Typ=""  d
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Sort",Typ,sort)) q:sort=""  d
	..s RowID="" f  s RowID=$O(^DHCNMG.DB.MgNurCheckWardI("Sort",Typ,sort,RowID)) q:RowID=""  d
	...s Obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(RowID)
	...q:((type'="")&&(Obj.WardType'=type))
	...s WardID=Obj.WardID
	...s WardType=""
	...i Obj.WardType="N" s WardType="夜巡查"
	...e  i Obj.WardType="Q" s WardType="质控检查"
	...e  i Obj.WardType="H" s WardType="节假日巡查"
	...e  i Obj.WardType="W" s WardType="周末巡查"
	...s WardSort=Obj.WardSort
	...s WardDesc="",WardInput=""
	...s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
	...;q:(parr'="")&&(('$IsObject(WardObj))||('$IsObject(WardObj.WardAreaDR))||(WardObj.WardAreaDR.%Id()'=parr))
	...q:((parr'="")&&(wards'[("^"_Obj.WardID_"^")))
	...s WardDesc=WardObj.WardDesc_WardObj.WardRemark
	...s WardInput=WardDesc_WardObj.WardSpell
	...q:((input'="")&&(WardInput'="")&&(WardInput'[$zcvt($tr(input," ",""),"U")))
	...s WardGroup=$zcvt(Obj.WardGroup,"U")
	...s WardGroupSort=Obj.WardGroupSort
	...s ableSelect=1
	...s:WardGroup'="" ableSelect=0
	...s ret="WardID|"_WardID_"^WardDesc|"_WardDesc_"^RowID|"_RowID_"^WardType|"_WardType_"^WardSort|"_WardSort
	...s ret=ret_"^WardGroup|"_WardGroup_"^WardGroupSort|"_WardGroupSort_"^ableSelect|"_ableSelect
	...i flag=0 d OutCheckWardList
	...e  d
	....i Obj.WardGroup="" s tmp(1,sort)=ret
	....e  s tmp(2,sort)=ret
	i flag'=0 d
	.s ret=""
	.s index="" f  s index=$O(tmp(index)) q:index=""  d
	..s sort="" f  s sort=$O(tmp(index,sort)) q:sort=""  d
	...s ret=tmp(index,sort)
	...d OutCheckWardList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckWardList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckWardListExecute ]
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

/// Description：查询检查病区分组病区列表
/// Date:2018-05-05
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCWGroupWardList(type As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCWGroupWardListExecute(ByRef qHandle As %Binary, type As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s areaid=$tr($p(parr,"^")," ","")
	s group=$zcvt($p(parr,"^",2),"U")
	s input=$p(parr,"^",3)
	i group="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s wards=""
	i areaid'="" d
	.s locID="" f  s locID=$o(^DHCNMG.DB.MgWardLocI("Area",areaid,locID)) q:locID=""  d
	..s containWard="" f  s containWard=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",locID,containWard)) q:containWard=""  d
	...i wards="" s wards="^"_containWard_"^"
	...e  s wards=wards_containWard_"^"
	s Typ="" f  s Typ=$O(^DHCNMG.DB.MgNurCheckWardI("Group",Typ)) q:Typ=""  d
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group",Typ," "_group,sort)) q:sort=""  d
	..s RowID="" f  s RowID=$O(^DHCNMG.DB.MgNurCheckWardI("Group",Typ," "_group,sort,RowID)) q:RowID=""  d
	...s Obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(RowID)
	...q:((type'="")&&(Obj.WardType'=type))
	...s WardID=Obj.WardID
	...s WardType=""
	...i Obj.WardType="N" s WardType="夜巡查"
	...e  i Obj.WardType="Q" s WardType="质控检查"
	...e  i Obj.WardType="H" s WardType="节假日巡查"
	...e  i Obj.WardType="W" s WardType="周末巡查"
	...s WardSort=Obj.WardSort
	...s WardDesc="",WardInput=""
	...s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
	...;q:(areaid'="")&&(('$IsObject(WardObj))||('$IsObject(WardObj.WardAreaDR))||(WardObj.WardAreaDR.%Id()'=areaid))
	...q:((areaid'="")&&(wards'[("^"_Obj.WardID_"^")))
	...i $IsObject(WardObj) d
	....s WardDesc=WardObj.WardDesc_WardObj.WardRemark
	....s WardInput=WardDesc_WardObj.WardSpell
	...q:((input'="")&&(WardInput'="")&&(WardInput'[$zcvt($tr(input," ",""),"U")))
	...s WardGroup=$zcvt(Obj.WardGroup,"U")
	...s WardGroupSort=Obj.WardGroupSort
	...s ableSelect=1
	...s:WardGroup'="" ableSelect=0
	...s ret="WardID|"_WardID_"^WardDesc|"_WardDesc_"^RowID|"_RowID_"^WardType|"_WardType_"^WardSort|"_WardSort
	...s ret=ret_"^WardGroup|"_WardGroup_"^WardGroupSort|"_WardGroupSort_"^ableSelect|"_ableSelect
	...d OutCWGroupWardData
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCWGroupWardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCWGroupWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCWGroupWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCWGroupWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCWGroupWardListExecute ]
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

/// Description：查询检查病区分组列表
/// Date:2018-05-05
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCWGroupList(type As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCWGroupListExecute(ByRef qHandle As %Binary, type As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s group="" f  s group=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type,group)) q:group=""  d
	.q:$tr(group," ","")=""
	.s ret="rw|"_$zcvt($tr(group," ",""),"U")_"^desc|"_$zcvt($tr(group," ",""),"U")
	.d OutCWGroupData
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCWGroupData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCWGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCWGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCWGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCWGroupListExecute ]
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

ClassMethod GetWardGroupSort(type, group) As %String
{
	s flag=1
	s Sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,""),-1)
	i Sort'="" s flag=Sort+1
	q flag
}

ClassMethod GetWardSort(type) As %String
{
	s flag=1
	s Sort=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_type,""),-1)
	i Sort'="" s flag=Sort+1
	q flag
}

/// Description:检查病区上移下移操作
/// Date:2018-05-05
/// Creator:gzj
/// w ##class(web.NurMgNightCheckComm).MoveRec("4,7,3","U")
ClassMethod MoveRec(type, parr) As %String
{
	q:parr="" 0
	s start=1,step=1,end=$L(parr,",")
	i type="D" s start=$L(parr,","),step=-1,end=1
	f i=start:step:end d
	.s rowid=$P(parr,",",i)
	.q:rowid=""
	.s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s WardType=obj.WardType
	.s WardSort=obj.WardSort
	.s nextSort=WardSort-step
	.s nextrowid=$O(^DHCNMG.DB.MgNurCheckWardI("Sort"," "_WardType,nextSort,""))
	.s nextObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(nextrowid)
	.s nextObj.WardSort=WardSort
	.d nextObj.%Save()
	.s obj.WardSort=nextSort
	.d obj.%Save()
	q 1
}

/// Description:检查病区上移下移操作
/// Date:2018-05-05
/// Creator:gzj
ClassMethod MoveGroupRec(type, parr) As %String
{
	q:parr="" 0
	s start=1,step=1,end=$L(parr,",")
	i type="D" s start=$L(parr,","),step=-1,end=1
	f i=start:step:end d
	.s rowid=$P(parr,",",i)
	.q:rowid=""
	.s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s WardType=obj.WardType
	.s WardGroup=$zcvt($tr(obj.WardGroup," ",""),"U")
	.s WardSort=obj.WardGroupSort
	.s nextSort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_WardType," "_WardGroup,WardSort),-step)
	.s nextrowid=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_WardType," "_WardGroup,nextSort,""))
	.s nextObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(nextrowid)
	.s nextObj.WardGroupSort=WardSort
	.d nextObj.%Save()
	.s obj.WardGroupSort=nextSort
	.d obj.%Save()
	q 1
}

/// Decription:获取查房分组数据【未使用】
/// Date:2018-05-05
/// Creator:gzj
ClassMethod GetTaskGroup(month As %String) As %String
{
	s TaskMonth=$tr(month,"-","")
	s TaskGroup=0
	
	s RowID=$O(^DHCNMG.CHK.MgNurTaskGroupI("group",TaskMonth,""))
	q:RowID="" 0
	s obj=##class(DHCNMG.CHK.MgNurTaskGroup).%OpenId(RowID)
	s TaskGroup=obj.TaskGroup
	s TaskWGroup=obj.TaskWGroup
	s TaskHGroup=obj.TaskHGroup
	q TaskGroup_"^"_TaskWGroup_"^"_TaskHGroup
}

/// Decription:保存查房分组数据
/// Date:2018-05-05
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Return
ClassMethod SaveTaskGroup(parr As %String) As %String
{
	s TaskMonth=$tr($p(parr,"^",1),"-","")
	s TaskGroup=$p(parr,"^",2)
	s TaskWGroup=$p(parr,"^",3)
	s TaskHGroup=$p(parr,"^",4)
	s RowID=$O(^DHCNMG.CHK.MgNurTaskGroupI("group",TaskMonth,""))
	i RowID="" s obj=##class(DHCNMG.CHK.MgNurTaskGroup).%New()
	e  s obj=##class(DHCNMG.CHK.MgNurTaskGroup).%OpenId(RowID)
	s obj.TaskGroup=TaskGroup
	s obj.TaskMonth=TaskMonth
	s obj.TaskWGroup=TaskWGroup
	s obj.TaskHGroup=TaskHGroup
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// ????
ClassMethod CheckSchdule(date) As %String
{
	q:date="" ""
	s flag=0
	s date=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,""))
	q:RowID="" 0
	s flag=1
	q flag
}

/// Description：根据日期获取排班ID
/// Date:2019-01-02
/// Creator:lulin
/// Table:
/// Input:
/// Output:
ClassMethod GetSchduleIDByDate(date) As %String
{
	q:date="" ""
	s flag=0
	s:date["-" date=$zdh(date,3)
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:obj.CheckStatus="B"
	.s ret=obj.%Id()
	q ret
}

/// Description：加载月份顺序表单
/// Date:2018-05-07
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindMonthOrderForm(type As %String, date As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMonthOrderFormExecute(ByRef qHandle As %Binary, type As %String, date As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	
	d OutMonthOrderForm
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMonthOrderForm
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMonthOrderFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMonthOrderFormExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMonthOrderFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMonthOrderFormExecute ]
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

ClassMethod GetMonthFormTree(type As %String, date As %String) As %String
{
	s year=$p(date,"-",1)
	s month=$p($zd($zdh(date,3),2)," ",2)
	i month="Dec" s month="Dece"
	s tmp="",ret=""
	////获取质控类型
	s typeName="QUALTYPE",code=""
	i type="N" s code="NIGHTCHECK"
	e  i type="W"  s code="WEEKCHECK"
	e  i type="H"  s code="HOLIDAYCHECK"
	i year="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ParID=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(typeName," ",""),"U"),"")) //QUALTYPE
	i ParID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RW=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt($tr(code," ",""),"U"),ParID,""))  //NIGHTCHECK
	i RW="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ID=ParID_"||"_RW
	s n=1
	s Par=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",year," "_type,""))
	q:Par="" ""
	s ParObj=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(Par)
	w "["
	s PlanMaxSort=..ComputeUsedPlanSort(Par,month,type)
	;s PlanMaxSort=..ComputePlanSort(Par,month)
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurCheckPlanSubD(Par,RowID)) q:RowID=""  d
	.s SubObj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId(Par_"||"_RowID)
	.q:'$IsObject(SubObj)
	.s itemObj=##class(DHCNMG.DB.MgQualItem).%OpenId(SubObj.ItmID)
	.q:'$IsObject(itemObj)
	.q:itemObj.QualType'[ID
	.s p="" f  s p=$O(^oddCOM("DHCNMG.CHK.MgNurCheckPlanSub","a",p)) q:p=""  d
	..q:p["%"
	..s tmp(p)=$ZOBJPROPERTY(SubObj,p)
	.q:((p'="Itm")&&(p'="ItmID")&&(tmp(month)=""))
	.s flag=0
	.w "{""lab"":"""_tmp("Itm")_"^"_tmp("ItmID")_""",""name"":"""_n_""""
	.s flag=..SetFormFlag(tmp("ItmID"))
	.i flag=1 d
	..w ",""cld"":"
	..d ..GetMonthFormChild(tmp("ItmID"))
	.e  w ",""cld"":[]"
	.i n=PlanMaxSort w "}"
	.e  w "},"
	.s n=n+1
	w "]"
	q ""
}

ClassMethod ComputePlanSort(Par, month) As %String
{
	s n=0,tmp=""
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurCheckPlanSubD(Par,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId(Par_"||"_RowID)
	.s p="" f  s p=$O(^oddCOM("DHCNMG.CHK.MgNurCheckPlanSub","a",p)) q:p=""  d
	..q:p["%"
	..q:p'=month
	..s tmp(p)=$ZOBJPROPERTY(obj,p)
	..i tmp(p)'="" s n=n+1
	q n
}

/// Description：获取夜查房排班有效检查任务数
/// Date:2019-09-18
/// Creator:dhh
/// Table:
/// Input:
/// Output:
/// Other:d ##class(web.NurMgNightCheckComm).ComputeUsedPlanSort(Par,month,type)
ClassMethod ComputeUsedPlanSort(Par, month, type) As %String
{
	
	s Obj=##class(DHCNMG.CHK.MgNurCheckPlan).%OpenId(Par)
	i '$IsObject(Obj) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s n=0,tmp=""
	s year=Obj.CheckYear
	s typeName="QUALTYPE",code=""
	i type="N" s code="NIGHTCHECK"
	e  i type="W"  s code="WEEKCHECK"
	e  i type="H"  s code="HOLIDAYCHECK"
	i year="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ParID=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(typeName," ",""),"U"),"")) //QUALTYPE
	i ParID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RW=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt($tr(code," ",""),"U"),ParID,""))  //NIGHTCHECK
	i RW="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ID=ParID_"||"_RW
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurCheckPlanSubD(Par,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId(Par_"||"_RowID)
	.s itemObj=##class(DHCNMG.DB.MgQualItem).%OpenId(obj.ItmID)
	.q:itemObj.QualType'[ID
	.s p="" f  s p=$O(^oddCOM("DHCNMG.CHK.MgNurCheckPlanSub","a",p)) q:p=""  d
	..q:p["%"
	..q:p'=month
	..s tmp(p)=$ZOBJPROPERTY(obj,p)
	..i tmp(p)'="" s n=n+1
	q n
}

ClassMethod SetFormFlag(par) As %String
{
	s flag=0
	s RowID=$O(^DHCNMG.DB.MgQualItemSubD(par,""))
	i RowID'="" s flag=1
	q flag
}

ClassMethod GetMonthFormChild(par) As %String
{
	s ret="",ret1=""
	w "["
	s maxsort=..ComputeMaxSort(par)
	s n=0
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgQualItemSubD(par,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_RowID)
	.q:obj.SubPar'=""
	.s citm=obj.SubDesc
	.s csort=obj.SubSort
	.s cid=par_"||"_RowID
	.s n=n+1
	.w "{""citm"":"""_citm_""",""cid"":"""_cid_""""
	.s flag=0
	.s flag=..SetItmFlag(cid)
	.i flag=1 d
	..w ",""cld"":"
	..d ..GetItmChildren(par,cid)
	.e  d
	..w ",""cld"":[]"
	.i n=maxsort w "}"
	.e  w "},"
	w "]"
	q ""
}

ClassMethod ComputeMaxSort(par) As %String
{
	s n=0
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rowid)
	.q:obj.SubPar'=""
	.s n=n+1
	q n
}

ClassMethod SetItmFlag(cid) As %String
{
	s flag=0
	s rowid=$O(^DHCNMG.DB.MgQualItemSubI("par"," "_cid,""))
	i rowid'="" s flag=1
	q flag
}

ClassMethod GetItmChildren(par, cid) As %String
{
	q:cid="" ""
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgQualItemSubD(par,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_RowID)
	.q:obj.SubPar'=cid
	.s citm=obj.SubDesc
	.s rid=par_"||"_RowID
	.s ret1=..GetItmChildren(par,rid)
	.i ret="" d
	..i ret1'="" s ret="{""citm"":"""_citm_""",""cid"":"""_rid_""",""cld"":"""_ret1_"""}"
	..e  s ret="{""citm"":"""_citm_""",""cid"":"""_rid_"""}"
	.e  d
	..i ret1'="" s ret=ret_",{""citm"":"""_citm_""",""cid"":"""_rid_""",""cld"":"""_ret1_"""}"
	..e  s ret=ret_",{""citm"":"""_citm_""",""cid"":"""_rid_"""}"
	i ret'="" w "["_ret_"]"
	q ""
}

ClassMethod SaveTaskItems(par, checkday, taskType) As %String
{
	s $ztrap="ErrorShow"
	q:(par="")||(checkday="") ""
	s len=$l(par,"ˇ")
	s flag=1,flag1=1
	TS
	f i=1:1:len
	{
		s itm=$p(par,"ˇ",i)
		i itm="" continue
		;s ParRowID=..GetSchduleIDByDate(checkday)
		s ParRowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",$zdh(checkday,3),""))
		s ParObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(ParRowID)
		s ParObj.CheckWork=ParObj.CheckWork_","_$p(itm,"「",1)_"^"_..GetTaskItemId($p(itm,"「",1),checkday,taskType)
		;s ParObj.CheckType=taskType
		s sc=ParObj.%Save()
		s itmlen=$l($P(itm,"「",2),"^")
		
		f j=1:1:itmlen
		{
			s itmsub=$p($P(itm,"「",2),"^",j)
			s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%New()
			s SubObj.Parref=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(ParObj.%Id())
			s QualObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(itmsub)
			s SubObj.TaskItems=QualObj.SubDesc
			s SubObj.TaskPar=QualObj.SubPar
			s SubObj.TaskQual=itmsub
			s subsc=SubObj.%Save()
			i $$$ISERR(subsc) 
			{
				S ^TEMPAAA=$System.Status.DisplayError(subsc)
			}
			s flag1=((flag1)&&$$$ISOK(subsc))
		}
	}
	i (flag&&flag1) TC
	e  d
	.TRollBack
	q (flag&&flag1)
ErrorShow
	s ^TMP("error1")=$ZE
	q ""
}

ClassMethod GetTaskItemId(itm, date, type) As %String
{
	s ret=""
	s Par=$O(^DHCNMG.CHK.MgNurCheckPlanI("Type",$p(date,"-",1)," "_type,""))
	q:Par="" ""
	s sub=$O(^DHCNMG.CHK.MgNurCheckPlanSubI("Itm",Par," "_$zcvt($tr(itm," ",""),"U"),""))
	s obj=##class(DHCNMG.CHK.MgNurCheckPlanSub).%OpenId(Par_"||"_sub)
	s ret=obj.ItmID
	q ret
}

/// ??????
ClassMethod DelDayTask(date As %String, checkSort As %String) As %String
{
	q:""
	q:date="" ""
	s currentdate=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",currentdate,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) ""
	TS
	s obj.CheckWork=""
	;s obj.TaskGroup=""
	s sc=obj.%Save()
	s flag=1
	i $$$ISOK(sc)=1
	{
		s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurNightTaskD(RowID,rowid)) q:rowid=""  d
		.s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(RowID_"||"_rowid)
		.s subsc=SubObj.%DeleteId(RowID_"||"_rowid)
		.s flag=(flag&&$$$ISOK(subsc))
		s subrowflag=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID,""))
		i subrowflag=""
		{
			i flag=1
			{
				TC
			}
			else
			{
				TRo
			}
		}
		else
		{
			i flag=1
			{
				
				s tasksubflag=1
				s TaskRow="" f  s TaskRow=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID,TaskRow)) q:TaskRow=""  d
				.s TaskSubRow="" f  s TaskSubRow=$O(^DHCNMG.CHK.MgNurNightCheckSubD(TaskRow,TaskSubRow)) q:TaskSubRow=""  d
				..s TaskSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(TaskRow_"||"_TaskSubRow)
				..s TaskSubSc=TaskSubObj.%DeleteId(TaskRow_"||"_TaskSubRow)
				..s tasksubflag=(tasksubflag&&$$$ISOK(TaskSubSc))
				i tasksubflag=1
				{
					s taskflag=1
					s TaskRow1="" f  s TaskRow1=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID,TaskRow1)) q:TaskRow1=""  d
					.s TaskObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(TaskRow1)
					.s TaskSc=TaskObj.%DeleteId(TaskRow1)
					.s taskflag=(taskflag&&$$$ISOK(TaskSc))
					i taskflag=1
					{
						Tc
					}
					else
					{
						Tro
					}
				}
				else
				{
					tro
				}
			}
			else
			{
				Trollback
			}	
		}
	}
	else
	{
		TRollback
	}
	q (flag&&$$$ISOK(sc))
}

ClassMethod CheckTaskGroups(checkday, tasktype) As %String
{
	s group=0
	s month=$p(checkday,"-",1)_$p(checkday,"-",2)
	s RowID=$O(^DHCNMG.CHK.MgNurTaskGroupI("group",month,""))
	q:RowID="" 0
	s obj=##class(DHCNMG.CHK.MgNurTaskGroup).%OpenId(RowID)
	q:'$IsObject(obj) 0
	i tasktype="N" s group=obj.TaskGroup
	e  i tasktype="W" s group=obj.TaskWGroup
	e  i tasktype="H" s group=obj.TaskHGroup
	q group
}

/// ????
ClassMethod GetCheckWards(date As %String) As %String
{
	q:date="" ""
	s day=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",day,""))
	q:RowID="" ""
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) ""
	w "["
	s len=obj.CheckWards.Count()
	f i=1:1:len
	{
		s itm=obj.CheckWards.GetAt(i)
		i itm="" continue
		s code=itm
		s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(code)
		s desc=wardobj.WardDesc
		i i<len w "{""desc"":"""_desc_""",""code"":"""_code_"""},"
		e  w "{""desc"":"""_desc_""",""code"":"""_code_"""}"
	}
	w "]"
	q ""
}

/// Descriptions:按照检查项目获取检查任务明细【未评分】
/// Date:2018-12-14
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetQualCheck(qualid, tmp) As %String
{
	q:qualid="" ""
	s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(qualid)
	q:'$IsObject(obj) ""
	s nowdate=+$H
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",qualid,rw1)) q:rw1=""  d
	.s tmp("rowspan",rw1)=0,tmp("twoRows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.s tmp("sort",$p(obj1.SubSort,"."))=rw1
	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),qualid)) d
	..s tmp("rowspan",rw1)=tmp("rowspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),qualid,rw2)) q:rw2=""  d
	...s tmp("rowspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid_"||"_rw2)
	...q:('$IsObject(obj2))
	...s sort=obj2.SubSort
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...s tmp("sort",$p(sort,"."),$p(sort,".",3))=rw2
	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),qualid)) d
	....s tmp("rowspan",rw1)=tmp("rowspan",rw1)+1,tmp("rowspan",rw2)=tmp("rowspan",rw2)+1
	...e  d
	....s tmp("twoRows",rw1)=tmp("twoRows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),qualid,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....s sort=obj3.SubSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))=rw3
	.....s tmp("rowspan",rw1)=tmp("rowspan",rw1)+1,tmp("rowspan",rw2)=tmp("rowspan",rw2)+1,showTree=1
	q showTree
	;2、循环输出，包含每一级的隐藏信息
#;	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",qualid,rw1)) q:rw1=""  d
#;	.s isShow1=1
#;	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid_"||"_rw1)
#;	.q:('$IsObject(obj1))
#;	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
#;	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
#;	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),qualid)) d
#;	..;无子集
#;	..s realscore=obj1.SubScore
#;	..s:obj.QualScoreType'=2 realscore=1
#;	..s sort=obj1.SubSort
#;	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1^oneIsShow|"_isShow1_"^onesort|"_obj1.SubSort
#;	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twoIsShow|1^twosort|"
#;	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
#;	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
#;	..s isShow1=0
#;	.e  d
#;	..;有子集
#;	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),qualid,rw2)) q:rw2=""  d
#;	...s isShow2=1
#;	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid_"||"_rw2)
#;	...q:('$IsObject(obj2))
#;	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
#;	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
#;	...s realscore=obj2.SubScore
#;	...s:obj.QualScoreType'=2 realscore=1
#;	...s sort=obj2.SubSort
#;	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),qualid)) d
#;	....;无子集
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmprowspan(rw1)_"^oneIsShow|"_isShow1_"^onesort|"_obj1.SubSort
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmprowspan(rw2)_"^twoIsShow|"_isShow2_"^twosort|"_obj2.SubSort
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmprowspan(rw1)_"^show|1"_"^showthree|"_showTree
#;	....s isShow1=0,isShow2=0
#;	...e  d
#;	....;有子集
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmprowspan(rw1)_"^oneIsShow|"_isShow1_"^onesort|"_obj1.SubSort
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmprowspan(rw2)_"^twoIsShow|"_isShow2_"^twosort|"_obj2.SubSort
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
#;	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmprowspan(rw1)_"^show|0"_"^showthree|"_showTree
#;	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),qualid,rw3)) q:rw3=""  d
#;	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid_"||"_rw3)
#;	.....q:('$IsObject(obj3))
#;	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
#;	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
#;	.....s realscore=obj3.SubScore
#;	.....s:obj.QualScoreType'=2 realscore=1
#;	.....s sort=obj3.SubSort
#;	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmprowspan(rw1)_"^oneIsShow|"_isShow1_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmprowspan(rw2)_"^twoIsShow|"_isShow2_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmprowspan(rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmprowspan(rw1)_"^show|1"_"^showthree|"_showTree
#;	.....s isShow1=0,isShow2=0
}

/// Descriptions:按照检查项目获取检查任务明细
/// Date:2018-05-22
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetCheckPanes(date As %String, flag As %String = "", checkSort As %String) As %String
{
	q:date="" ""
	s day=$zdh(date,3)
	;s Par=..GetSchduleIDByDate(date)
	s Par=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",day,checkSort,""))
	q:Par="" ""
	s ParObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(Par)
	q:'$IsObject(ParObj) ""
	s checkworks=ParObj.CheckWork
	s wardlen=ParObj.CheckWards.Count()
	w "{""wards"":["
	s m=0,tmpward=""
	f j=1:1:wardlen
	{
			s warditm=ParObj.CheckWards.GetAt(j)
			i warditm="" continue
			s m=m+1
			s code=warditm
			s descobj=##class(DHCNMG.DB.MgWard).%OpenId(code)
			s desc=descobj.WardDesc
			s showFlag=1
			i ParObj.CheckSpecialWard'="" d
			.s showFlag=0
			.i code=ParObj.CheckSpecialWard s showFlag=1
			i m<wardlen w "{"""_"code"_""":"""_code_""",""desc"":"""_desc_""",""showFlag"":"""_showFlag_"""},"
			e  w "{"""_"code"_""":"""_code_""",""desc"":"""_desc_""",""showFlag"":"""_showFlag_"""}"
			s tmpward(j)=code
	}
	w "],""basic"":["
	s tmpBasicData="病人总数^TaskPat,重病人数^TastSerPat,抢救人数急诊手术^TaskResPat,值班护士^TaskNightNur"
	s BasicLen=$l(tmpBasicData,",")
	s m=0,showTile=1
	f z=1:1:BasicLen
	{
		s desc=$p($p(tmpBasicData,",",z),"^")
		s p=$p($p(tmpBasicData,",",z),"^",2)
		s m=m+1
		w "{""item"":"""_desc_""",""rowspan"":"""_BasicLen_""",""showTitle"":"""_showTile_""",""proter"":"""_p_""""
		s wardsort="",showTile=0
		f  s wardsort=$O(tmpward(wardsort)) q:wardsort=""  d
		.s wardId=tmpward(wardsort)
		.w ",""b"_wardId_""":"""
		.s value=""
		.s basicId=$o(^DHCNMG.CHK.MgNurNightBasicI("Ward",Par," "_wardId,""))
		.s obj=##class(DHCNMG.CHK.MgNurNightBasic).%OpenId(basicId)
		.i $IsObject(obj) d
		..s value=$tr($ZOBJPROPERTY(obj,p)," ","")
		.w value_""""
		i m<BasicLen w "},"
		e  w "}"
		
	}
	s len=$l(checkworks,",")
	w "],""panel"":["
	s n=1
	f i=1:1:len
	{
		s itm=$p(checkworks,",",i)
		i itm="" continue
		s qualpar=$p(itm,"^",2)
		s qualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(qualpar)
		q:'$IsObject(qualObj)
		;s num=..ComputeItemSum(Par,qualpar) ;项的数量
		;排班下的第一个任务
		s checkRowID=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",Par,""))
		s checkObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(checkRowID)
		s checkDate="",checkPerson=""
		i $IsObject(checkObj) d
		.s checkDate=$zd(checkObj.TaskChkDate,3)
		.f j=1:1:$L(checkObj.TaskUser,",") d
		..s checkPerId=$P(checkObj.TaskUser,",",j)
		..s name=""
		..i checkPerId=0 s name="管理员"
		..e  d
		...s checPerObj=##class(DHCNMG.HR.MgPersons).%OpenId(checkPerId)
		...i $IsObject(checPerObj) s name=checPerObj.PerName
		..i checkPerson="" s checkPerson=name
		..e  s checkPerson=checkPerson_","_name
		w "{""title"":"""_$p(itm,"^",1)_""",""ScoreType"":"""_qualObj.QualScoreType_""",""name"":"""_(i-1)_""",""checkDate"":"""_checkDate_""",""checkPerson"":"""_checkPerson_""",""items"":["
		i '$d(^DHCNMG.CHK.MgNurNightCheckI("TaskID",Par)) d
		.k tmp
		.s tmp=""
		.s showThree=..GetQualCheck(qualpar,.tmp)
		.;第一层
		.s sort1="" f  s sort1=$O(tmp("sort",sort1))  q:sort1=""  d
		..s qualObj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualpar_"||"_tmp("sort",sort1))
		..s score=qualObj1.SubScore
		..s:qualObj.QualScoreType'=2 score=$case(flag,1:"√",:"")
		..s haschild=0,rowspan=tmp("rowspan",tmp("sort",sort1))
		..i $d(tmp("sort",sort1))=11 s haschild=1
		..s ret=""
		..s wardsort="" f  s wardsort=$O(tmpward(wardsort)) q:wardsort=""  d
		...s wardId=tmpward(wardsort)
		...i ret="" s ret="""c"_wardId_""":"""_score_""",""r"_wardId_""":"""""
		...e  s ret=ret_",""c"_wardId_""":"""_score_""",""r"_wardId_""":"""""
		..w "{""fatherShow"":""0"",""fahterDesc"":"""",""fahterrow"":""1"",""oValue"":"""_qualObj1.SubScore_""",""qualitm"":"""_qualObj1.SubDesc_""",""qualid"":"""_qualpar_"||"_tmp("sort",sort1)_""",""sort"":"""_qualObj1.SubSort_""",""rowspan"":"""_rowspan_""",""sub"":"""",""haschild"":"""_haschild_""","_ret_"},"
		..;第二层
		..s sort2="" f  s sort2=$O(tmp("sort",sort1,sort2)) q:sort2=""  d
		...s qualObj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualpar_"||"_tmp("sort",sort1,sort2))
		...s haschild=0,rowspan=tmp("rowspan",tmp("sort",sort1,sort2))
		...;i $d(tmp("sort",sort1,sort2))=11 s haschild=1
		...s score=qualObj2.SubScore
		...s:qualObj.QualScoreType'=2 score=$case(flag,1:"√",:"")
		...s ret=""
		...s wardsort="" f  s wardsort=$O(tmpward(wardsort)) q:wardsort=""  d
		....s wardId=tmpward(wardsort)
		....i ret="" s ret="""c"_wardId_""":"""_score_""",""r"_wardId_""":"""""
		....e  s ret=ret_",""c"_wardId_""":"""_score_""",""r"_wardId_""":"""""
		...s showFather=0
		...i $O(tmp("sort",sort1,sort2),-1)="" s showFather=1
		...w "{""fatherShow"":"""_showFather_""",""fahterDesc"":"""_qualObj1.SubDesc_""",""fahterrow"":"""_tmp("rowspan",tmp("sort",sort1))_""",""oValue"":"""_qualObj2.SubScore_""",""qualitm"":"""_qualObj2.SubDesc_""",""qualid"":"""_qualpar_"||"_tmp("sort",sort1,sort2)_""",""sort"":"""_qualObj2.SubSort_""",""rowspan"":"""_rowspan_""",""sub"":"""",""haschild"":"""_haschild_""","_ret_"},"
		.;护士签名
		.s ret=""
		.s wardsort="" f  s wardsort=$O(tmpward(wardsort)) q:wardsort=""  d
		..s wardId=tmpward(wardsort)
		..i ret="" s ret="""c"_wardId_""":"""",""r"_wardId_""":"""""
		..e  s ret=ret_",""c"_wardId_""":"""",""r"_wardId_""":"""""
		.w "{""qualitm"":""护士签名"",""qualid"":"""_""",""sort"":"""_""",""rowspan"":"""",""sub"":""headnur"",""haschild"":""0"","_ret_"}"
		e  d
		.k tmp
		.s tmp=""
		.s checkwardid="" f  s checkwardid=$O(^DHCNMG.CHK.MgNurNightCheckI("Ward",Par,qualpar,checkwardid)) q:checkwardid=""  d
		..s checkid="" f  s checkid=$O(^DHCNMG.CHK.MgNurNightCheckI("Ward",Par,qualpar,checkwardid,checkid)) q:checkid=""  d
		...s tCheckObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(checkid)
		...q:'$IsObject(tCheckObj)
		...s twardid=tCheckObj.TaskWard
		...s tmp("nur",twardid)=tCheckObj.TaskHeadNur
		...s checksubid="" f  s checksubid=$O(^DHCNMG.CHK.MgNurNightCheckSubD(checkid,checksubid)) q:checksubid=""  d
		....s checksubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(checkid_"||"_checksubid)
		....q:'$IsObject(checksubObj)
		....s sort=checksubObj.TaskSort
		....s haschild=0
		....s score=checksubObj.TaskResult
		....i (qualObj.QualScoreType'=2)&&(score="")&&(flag=1) s score="√"
		....i $D(^DHCNMG.CHK.MgNurNightCheckSubI("par"," "_checkid_"||"_checksubid)) s haschild=1
		....s fatherDesc="",fatherRow=1
		....s parId=checksubObj.TaskPar
		....s fatherObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(parId)
		....i $IsObject(fatherObj) s fatherDesc=fatherObj.TaskItems,fatherRow=fatherObj.TaskRowSpan
		....i $l(sort,".")=2 d
		.....s fatherShow=0
		.....i $O(tmp("sort",$P(sort,".")),-1)="" s fatherShow=1
		.....s tmp("sort",$P(sort,"."))="{""fatherShow"":"""_fatherShow_""",""fahterDesc"":"""_fatherDesc_""",""fahterrow"":"""_fatherRow_""",""oValue"":"""_checksubObj.TaskValue_""",""qualitm"":"""_checksubObj.TaskItems_""",""qualid"":"""_checksubObj.TaskQual_""",""sort"":"""_checksubObj.TaskSort_""",""rowspan"":"""_checksubObj.TaskRowSpan_""",""sub"":"""_checksubid_""",""haschild"":"""_haschild_""""
		.....s tmp("value1",$P(sort,"."),twardid)="""c"_twardid_""":"""_score_""",""r"_twardid_""":"""_checksubObj.TaskRemark_""""
		....e  i $L(sort,".")=3 d
		.....s fatherShow=0
		.....i $O(tmp("sort",$P(sort,"."),$P(sort,".",3)),-1)="" s fatherShow=1
		.....s tmp("sort",$P(sort,"."),$P(sort,".",3))="{""fatherShow"":"""_fatherShow_""",""fahterDesc"":"""_fatherDesc_""",""fahterrow"":"""_fatherRow_""",""oValue"":"""_checksubObj.TaskValue_""",""qualitm"":"""_checksubObj.TaskItems_""",""qualid"":"""_checksubObj.TaskQual_""",""sort"":"""_checksubObj.TaskSort_""",""rowspan"":"""_checksubObj.TaskRowSpan_""",""sub"":"""_checksubid_""",""haschild"":"""_haschild_""""
		.....s tmp("value2",$P(sort,"."),$P(sort,".",3),twardid)="""c"_twardid_""":"""_score_""",""r"_twardid_""":"""_checksubObj.TaskRemark_""""
		.s sort1="" f  s sort1=$O(tmp("sort",sort1))  q:sort1=""  d
		..w tmp("sort",sort1)
		..s twardid="" f  s twardid=$O(tmp("value1",sort1,twardid)) q:twardid=""  d
		...w ","_tmp("value1",sort1,twardid)
		..w "},"
		..s sort2="" f  s sort2=$O(tmp("sort",sort1,sort2)) q:sort2=""  d
		...w tmp("sort",sort1,sort2)
		...s twardid="" f  s twardid=$O(tmp("value2",sort1,sort2,twardid)) q:twardid=""  d
		....w ","_tmp("value2",sort1,sort2,twardid)
		...w "},"
		.s retSign=""
		.s twardid="" f  s twardid=$O(tmp("nur",twardid)) q:twardid=""  d
		..i retSign="" s retSign="""c"_twardid_""":"""_tmp("nur",twardid)_""",""r"_twardid_""":"""""
		..e  s retSign=retSign_",""c"_twardid_""":"""_tmp("nur",twardid)_""",""r"_twardid_""":"""""
		.w "{""qualitm"":""护士签名"",""qualid"":"""_""",""sort"":"""_""",""rowspan"":""1"",""sub"":""headnur"",""haschild"":""0"","_retSign_"}"
		i i<len w "]},"
		e  w "]}"
	}
	w "]}"
	q ""
}

/// Descriptions:判断节点是否有子节点
/// Date:2018-05-23
/// Creator:gzj
/// Table:
/// Input:Par:
/// Output:RowID:记录ID，TaskQual:对应的质控项目ID
/// Other:
ClassMethod HasChild(RowID, TaskQual) As %String
{
	s flag=0
	s Par=$p(RowID,"||",1)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurNightTaskD(Par,rowid)) q:rowid=""  d
	.q:((Par_"||"_rowid)=RowID)
	.s obj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(Par_"||"_rowid)
	.i obj.TaskPar=TaskQual s flag=1
	q flag
}

/// Descriptions:获取检查任务明细
/// Date:2018-05-21
/// Creator:gzj
/// ???????
ClassMethod GetCheckItems(date As %String) As %String
{
	q:date="" ""
	s day=$zdh(date,3)
	;s Par=..GetSchduleIDByDate(date)
	s Par=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",day,""))
	q:Par="" ""
	s ParObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(Par)
	q:'$IsObject(ParObj) ""
	w "["
	s len=ParObj.CheckWards.Count()
	s ret="",m=0
	w "{""wards"":["
	f i=1:1:len
	{
		s itm=ParObj.CheckWards.GetAt(i)
		i itm="" continue
		s m=m+1
		s code=itm
		s descobj=##class(DHCNMG.DB.MgWard).%OpenId(code)
		s desc=descobj.WardDesc
		i ret="" s ret="""c"_code_""":"""_""""
		e  s ret=ret_",""c"_code_""":"""_""""
		i m<len w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""},"
		e  w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""}"
	}
	w "]"
	w "},"
	w "{""items"":["
	s num=..ComputeItemSum(Par)
	s n=0
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurNightTaskD(Par,RowID)) q:RowID=""  d
	.s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(Par_"||"_RowID)
	.s n=n+1
	.s qualitm=SubObj.TaskItems
	.s taskqual=SubObj.TaskQual
	.s taskpar=SubObj.TaskPar
	.i n<num w "{""qualitm"":"""_qualitm_""",""taskqual"":"""_taskqual_""",""taskpar"":"""_taskpar_""","_ret_"},"
	.e  w "{""qualitm"":"""_qualitm_""",""taskqual"":"""_taskqual_""",""taskpar"":"""_taskpar_""","_ret_"}"
	w "]"
	w "}]"
	q ""
}

ClassMethod ComputeItemSum(Par, qualpar) As %String
{
	s num=0
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurNightTaskD(Par,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(Par_"||"_RowID)
	.q:((qualpar'="")&&($p(obj.TaskQual,"||",1)'=qualpar))
	.s num=num+1
	q num
}

/// Description：
/// Date:2018-05-21
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
Query FindCheckItems(date As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckItemsExecute(ByRef qHandle As %Binary, date As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i date=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s day=$zdh(date,3)
	;s Par=..GetSchduleIDByDate(date)
	s Par=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",day,""))
	i Par=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ParObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(Par)
	i '$IsObject(ParObj)  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurNightTaskD(Par,RowID)) q:RowID=""  d
	.s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(Par_"||"_RowID)
	.s content=SubObj.TaskItems
	.s taskqual=SubObj.TaskQual
	.s taskpar=SubObj.TaskPar
	.s ret="qualitem|"_content_"^taskqual|"_$tr(taskqual,"||","__")_"^taskpar|"_$tr(taskpar,"||","__")_"^rowid|"_Par_"__"_RowID
	.d OutCheckItems
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckItems
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckItemsExecute ]
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

/// Description：保存检查基本信息
/// Date:2018-09-09
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveCheckBasic(parr As %String, wardparr As %String, checkSort As %String) As %String
{
	s date=$p(wardparr,"^",2)
	s date=$zdh(date,3)
	s ward=$tr($p(wardparr,"^")," ","")
	s user=$p(wardparr,"^",3)
	s index=$p(wardparr,"^",4)
	;s SchduleRowID=..GetSchduleIDByDate(date)
	;s SchduleRowID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,""))
	s SchduleRowID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date,checkSort,""))
	s parObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(SchduleRowID)
	q:'$IsObject(parObj)="" 0
	s basciId=$O(^DHCNMG.CHK.MgNurNightBasicI("Ward",SchduleRowID," "_ward,""))
	i basciId="" d
	.s obj=##class(DHCNMG.CHK.MgNurNightBasic).%New()
	.s obj.TaskID=parObj
	.s obj.TaskDate=parObj.CheckDate
	.s obj.TaskWard=ward
	e  s obj=##class(DHCNMG.CHK.MgNurNightBasic).%OpenId(basciId)
	s obj.TaskChkDate=+$h
	s len=$l(parr,"^")
	f i=1:1:len d
	.s data=$p(parr,"^",i)
	.s p=$p(data,"|")
	.s value=$p(data,"|",2)
	.s $ZOBJPROPERTY(obj,p)=value
	s obj.TaskSort=checkSort
	s sc=obj.%Save()
	i $$$ISERR(sc) s index=0
	q index
}

/// Description：保存检查项目信息
/// Date:2018-09-09
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveCheckScore(parr As %String, wardparr As %String, checkSort As %String) As %String
{
	s flag=0
	s date=$p(wardparr,"^",2)
	s date=$zdh(date,3)
	s ward=$p(wardparr,"^",1)
	s user=$p(wardparr,"^",3)
	s title=$p(wardparr,"^",4)
	s index=$p(wardparr,"^",5)
	;s SchduleRowID=..GetSchduleIDByDate(date)
	;s SchduleRowID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,""))
	s SchduleRowID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date,checkSort,""))
	s SchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(SchduleRowID)
	q:'$IsObject(SchObj) 0
	
	s tasklen=$l(SchObj.CheckWork,",")
	s titleid=""
	f j=1:1:tasklen
	{
		s taskitm=$p(SchObj.CheckWork,",",j)
		i taskitm="" continue
		s tasktitle=$p(taskitm,"^",1)
		s taskid=$p(taskitm,"^",2)
		i tasktitle=title s titleid=taskid
	}
	q:titleid="" 0
	TS
	s CheckRowID=$O(^DHCNMG.CHK.MgNurNightCheckI("Ward",SchduleRowID,titleid," "_ward,""))
	i CheckRowID="" d
	.s CheckObj=##class(DHCNMG.CHK.MgNurNightCheck).%New()
	.s CheckObj.TaskID=SchObj
	.s CheckObj.TaskWard=ward
	.s CheckObj.TaskDate=SchObj.CheckDate
	.s CheckObj.TaskQualID=titleid
	e  s CheckObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(CheckRowID)
	s CheckObj.TaskUser=user
	s CheckObj.TaskChkDate=+$h
	s len=$l(parr,"ˇ")
	s headernur=$P($p(parr,"ˇ",len),"^",4) ;护士签名
	s CheckObj.TaskHeadNur=headernur
	s sc=CheckObj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		//parr=^16||1^4^^。打分子表id，质控id，合并行数，得分，备注
		s flag1=1
		f i=1:1:len-1
		{
			s itm=$p(parr,"ˇ",i)
			i itm="" continue
			s subid=$tr($p(itm,"^",1)," ","")
			s qualid=$tr($P(itm,"^",2)," ","")
			s rowspan=$P(itm,"^",3)
			s value=$p(itm,"^",4)
			s remark=$p(itm,"^",5)
			i subid="" d
			.s qualObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(qualid)
			.q:'$IsObject(qualObj)
			.s CheckSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%New()
			.s CheckSubObj.Parref=CheckObj
			.;s taskObj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(SchduleRowID_"||"_taskid)
			.s CheckSubObj.TaskItems=qualObj.SubDesc
			.s CheckSubObj.TaskQual=qualObj.%Id()
			.s CheckSubObj.TaskValue=qualObj.SubScore
			.s CheckSubObj.TaskRowSpan=rowspan
			.s CheckSubObj.TaskSort=qualObj.SubSort
			.s qualParId=qualObj.SubPar
			.i qualParId="" s CheckSubObj.TaskPar=""
			.e  d
			..s TaskPar=$O(^DHCNMG.CHK.MgNurNightCheckSubI("qual",CheckObj.%Id()," "_qualParId,""))
			..s:TaskPar'="" CheckSubObj.TaskPar=CheckObj.%Id()_"||"_TaskPar
			.;s CheckSubObj.TaskPar=taskObj.TaskPar
			.;s CheckSubObj.TaskRecID=taskObj.%Id()
			e  d
			.s tsubid=$O(^DHCNMG.CHK.MgNurNightCheckSubI("qual",CheckObj.%Id()," "_qualid,""))
			.s CheckSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(CheckObj.%Id()_"||"_tsubid)
			s CheckSubObj.TaskResult=value
			s CheckSubObj.TaskRemark=remark
			s csc=CheckSubObj.%Save()
			s flag1=flag1&&$$$ISOK(csc) 
		}
		s flag=flag&&flag1
	}
	i flag=1
	{
		TC
		q index
	}
	else
	{
		TRo
		q 0
	}
}

/// Description:检查排班人重复性
/// Date:2018-05-26
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod IsExistSchdule(parr As %String, checktype As %String) As %String
{
	s date=$p($p(parr,"^",5),"|",2)
	s scheduler=$p($p(parr,"^",2),"|",2) //预排班人【1078,1138】
	
	s MonthFirstDay=$zdh($E(date,1,8)_"01",3) //获取当月第一天
	s monthdays=##class(web.NurMgVueComm).GetMonthDay(date) //计算当月有多少天
	s MonthLastDay=MonthFirstDay+monthdays-1 //计算当月最后一天
	s ret=..IsExistSchduleLeave(scheduler_"^"_date)
	s schdate=MonthFirstDay f  s schdate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_checktype,schdate)) q:(schdate=""||(schdate>MonthLastDay))  d
	.s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_checktype,schdate,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..q:obj.CheckStatus="B"
	..s personlist=obj.CheckPerson
	..s len=$l(personlist,",")
	..f i=1:1:len d
	...s itm=$p(personlist,",",i)
	...q:itm=""
	...s slen=$l(scheduler,",")
	...f j=1:1:slen d
	....s sitm=$p(scheduler,",",j)
	....q:sitm=""
	....i itm=sitm d
	.....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
	.....q:'$IsObject(PerObj)
	.....i ret="" s ret=$zd(schdate,3)_":"_PerObj.PerName_"已排"
	.....e  s ret=ret_";"_$zd(schdate,3)_":"_PerObj.PerName_"已排"
	
	q ret
}

/// Description:检查排班人请假
/// Date:2018-08-30
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod IsExistSchduleLeave(parr As %String) As %String
{
	s date=$p(parr,"^",2)
	s scheduler=$p(parr,"^") //预排班人【1078,1138】
	s len=$p(scheduler,",")
	s ret=""
	f i=1:1:len 
	{
		s itm=$p(scheduler,",",i)
		i itm="" continue
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perObj)
		s isLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(itm_"^"_date)
		i isLeave=1 d
		.i ret="" s ret=perObj.PerName_"已请假"
		.e  s ret=perObj.PerName_","_message
	}
	q ret
}

/// Description:检查排班人在所辖病区
/// Date:2018-08-30
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod IsSchduleInGroup(parr As %String) As %String
{
	s persons=$p(parr,"^")
	s group=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	q:type="" "未获取夜查房类型"
	q:(persons="")||(group="") 1
	k tmpWard,tmpPer
	s tmpWard="",tmpPer=""
	s len=$p(persons,",")
	s ret=1
	f i=1:1:len 
	{
		s itm=$tr($p(persons,",",i)," ","")
		i itm="" continue
		s tmpPer(itm)=itm
	}
	;检查组人是否在某个科室检查组
	s flag=$D(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group))
	q:'flag 1
	s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitD(limitId)) q:limitId=""  d
	.s limitObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitId)
	.q:'$IsObject(limitObj)
	.i $d(tmpPer(limitObj.LimitNurse)) d
	..s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	...s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	...q:'$IsObject(limitSubObj)
	...q:limitSubObj.SubWard=""
	...q:$d(tmpWard(limitSubObj.SubWard))
	...s tmpWard(limitSubObj.SubWard)=limitSubObj.SubWard
	s flagGroup=0  
	s groupSort="" f  s groupSort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,groupSort)) q:(groupSort="")||(flagGroup=1)  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,groupSort,id)) q:(id="")||(flagGroup=1)  d
	..s checkGroupObj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	..q:'$IsObject(checkGroupObj)
	..q:checkGroupObj.WardID=""
	..i $D(tmpWard(checkGroupObj.WardID)) s flagGroup=1
	s ret=1
	i flagGroup=1 s ret="检查人员所辖病区与检查科室重合"
	q ret
}

ClassMethod GetSchdulePrintData(date As %String, sort As %String) As %String
{
	q:date="" ""
	s schduledate=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	;s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",schduledate,""))
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",schduledate,sort,""))
	q:RowID="" ""
	s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(Obj) ""
	w "["
	;s CheckWork=Obj.CheckWork
	s worklen=$l(Obj.CheckWork,",")
	s worktitle=""
	f i=1:1:worklen
	{
		s itm=$p(Obj.CheckWork,",",i)
		i itm="" continue
		i (i=(sort+1)) s worktitle=$p(itm,"^",1)
	}
	w "{""title"":"""_worktitle_""",""wards"":["
	s wardlen=Obj.CheckWards.Count()
	s wards=""
	s m=0
	s ret=""
	f j=1:1:wardlen
	{
		s warditm=Obj.CheckWards.GetAt(j)
		i warditm="" continue
		s m=m+1
		s code=warditm
		s descobj=##class(DHCNMG.DB.MgWard).%OpenId(code)
		q:'$IsObject(descobj)
		s desc=descobj.WardDesc
		i ret="" s ret="""c"_code_""":"""_""""
		e  s ret=ret_",""c"_code_""":"""_""""
		i m<wardlen w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""},"
		e  w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""}"
	}
	w "]}]"
	q ""
}

ClassMethod GetTest() As %String
{
	
	w "["
	s n=1
	f i=1:1:len
	{
		s itm=$p(checkworks,",",i)
		i itm="" continue
		s n=n+1
		s wardlen=ParObj.CheckWards.Count()
		s qualpar=$p(itm,"^",2)
		s num=..ComputeItemSum(Par,qualpar)
		
		w "{""title"":"""_$p(itm,"^",1)_""",""name"":"""_(i-1)_""",""wards"":["
		s m=0
		s ret=""
		f j=1:1:wardlen
		{
			s warditm=ParObj.CheckWards.GetAt(j)
			i warditm="" continue
			s m=m+1
			s code=warditm
			s descobj=##class(DHCNMG.DB.MgWard).%OpenId(code)
			s desc=descobj.WardDesc
			i ret="" s ret="""c"_code_""":"""_""""
			e  s ret=ret_",""c"_code_""":"""_""""
			i m<wardlen w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""},"
			e  w "{"""_"code"_""":"""_"c"_code_""",""desc"":"""_desc_"""}"
		}
		w "],"
		w """items"":["
		s k=1
		s RowID="" f  s RowID=$O(^DHCNMG.CHK.MgNurNightTaskD(Par,RowID)) q:RowID=""  d
		.s SubObj=##class(DHCNMG.CHK.MgNurNightTask).%OpenId(Par_"||"_RowID)
		.s qualitm=SubObj.TaskItems
		.s taskqual=SubObj.TaskQual
		.q:((qualpar'="")&&($P(SubObj.TaskQual,"||",1)'=qualpar))
		.s taskpar=SubObj.TaskPar
		.s haschild=..HasChild(Par_"||"_RowID,taskqual)
		.i k<num w "{""qualitm"":"""_qualitm_""",""taskqual"":"""_taskqual_""",""taskpar"":"""_taskpar_""",""par"":"""_Par_""",""sub"":"""_RowID_""",""taskflag"":"""_haschild_""","_ret_"},"
		.e  w "{""qualitm"":"""_qualitm_""",""taskqual"":"""_taskqual_""",""taskpar"":"""_taskpar_""",""par"":"""_Par_""",""sub"":"""_RowID_""",""taskflag"":"""_haschild_""","_ret_"}"
		.s k=k+1
		i n<len w "]},"
		e  w "]}"
	}
	w "]"
	q ""
}

/// Description：获取夜查房排班日历
/// Date:2018-09-07
/// Creator:lulin
/// Table:
/// Input:日历开始第一天日期
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCalendar","2019-02-25","0","0")
Query FindCalendar(date As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCalendarExecute(ByRef qHandle As %Binary, date As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i date="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s isOverSubmit=1 ;超过本月审核是日期
	s:$p($zd(+$h,3),"-",3)>=25 isOverSubmit=1
	s isHLB=0,nextDate=+$H+1,nowMonth=$p($zd(+$h,3),"-",2)
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s tRole=$tr($p(role,"^",i)," ","")
	.q:tRole=""
	.i tRole=0 s isHLB=1
	.q:isHLB=1
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(tRole)
	.s rolecode=RoleObj.RoleCode
	.i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")||(rolecode="manager")) d
	..s isHLB=1
	s ret=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	s year=$p($zd(+$h,3),"-",1)
	s year=$p(date,"-",1)
	f outdate=startdate:1:enddate d
	.s isHoliday="",dayschdule="",daytask="",daycheck="",flag=0,outMonth=$p($zd(outdate,3),"-",2),checkSort=0
	.s:nowMonth=12 outMonth=12+nowMonth
	.f tyear=year:1:(year+1) d
	..s code="" f  s code=$O(^DHCNMG.DB.MgHolidaySetI("code",tyear,code)) q:code=""  d
	...s rowid="" f  s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",tyear,code,rowid)) q:rowid=""  d
	....s holidayObj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
	....i holidayObj.HolidayDate'="" d
	.....s hstdate=$zdh($p(holidayObj.HolidayDate,",",1),3)
	.....s henddate=$zdh($p(holidayObj.HolidayDate,",",2),3)
	.....i (outdate>=hstdate)&&(outdate<=henddate) d
	......s isHoliday=holidayObj.HolidayID.SubDesc
	.;s RowID=..GetSchduleIDByDate(outdate)
	.s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",outdate,""))
	.s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	.i '$IsObject(Obj) d
	..s checkSort=""
	..f k=1:1:2 d
	...i checkSort="" s checkSort=k
	...e  s checkSort=checkSort_"%"_k
	..s ret="isHoliday|"_isHoliday_"^dayschdule|^daytask|^daygroup|^daycheck|^editFlag|0"_"^checkSort|"_checkSort
	..d OutCalendar
	.q:'$IsObject(Obj)
	.s checkdate=Obj.CheckDate,editFlag=0
	.i (isHLB=1) s editFlag=1
	.i checkdate=outdate d
	..s person=Obj.CheckPerson
	..s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(person)
	..s:$IsObject(perobj) dayschdule=perobj.PerName_"「"_person
	..s person2=Obj.CheckOPerson
	..i (person=nurseid)||(person2=nurseid) s editFlag=1
	..s perobj2=##class(DHCNMG.HR.MgPersons).%OpenId(person2)
	..i $IsObject(perobj2) d
	...i dayschdule="" s dayschdule=perobj2.PerName_"「"_person2
	...e  s dayschdule=dayschdule_","_perobj2.PerName_"「"_person2
	..q:((person'=nurseid)&&(person2'=nurseid))&&(isHLB'=1)
	..i isHLB=1 s flag=1
	..;e  i ((isHLB'=1)&&((person=nurseid)||(person2=nurseid))) d
	..e  i (isHLB'=1) d
	...i (outdate<=nextDate) s flag=1 ;小于当前日期可以看到全部
	...;如果日期为当前月，或本月已过提交日期且日期为下一月可看到排班
	...e  i (outMonth=nowMonth)||((isOverSubmit=1)&&(outMonth=(nowMonth+1))) s flag=2
	.s work=Obj.CheckWork
	.s len=$l(work,",")
	.f i=1:1:len d
	..s itm=$P($p(work,",",i),"^",1)
	..i itm'="" d
	...i daytask="" s daytask=itm
	...e  s daytask=daytask_","_itm
	.s checkRowID=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID,""))
	.s checkObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(checkRowID)
	.i $IsObject(checkObj) d
	..s daychecks=checkObj.TaskUser
	..f i=1:1:$L(daychecks,",") d
	...s checkPerId=$P(daychecks,",",i)
	...s name=""
	...i checkPerId=0 d
	....s name="管理员"
	...e  d
	....s checPerObj=##class(DHCNMG.HR.MgPersons).%OpenId(checkPerId)
	....i $IsObject(checPerObj) s name=checPerObj.PerName
	...i daycheck="" s daycheck=name
	...e  s daycheck=daycheck_","_name
	.s checkSort=""
	.s checkCount=Obj.CheckCount
	.i checkCount=1 s checkSort=checkCount_"%"
	.e  i checkCount=2 s checkSort="%"_checkCount
	.i flag=1 d
	..s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|"_daytask_"^daygroup|"_Obj.CheckWardGroup_"^daycheck|"_daycheck_"^checkSort|"_checkSort
	.e  i flag=2 d
	..s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort
	.e  d
	..s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort
	.s ret=ret_"^editFlag|"_editFlag
	.d OutCalendar
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCalendar
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCalendarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCalendarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCalendarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCalendarExecute ]
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

/// Description：获取夜查房排班日历
/// Date:2018-09-07
/// Creator:lulin
/// Table:
/// Input:日历开始第一天日期
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCalendar1","2019-02-25","0","0")
Query FindCalendar1(date As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCalendar1Execute(ByRef qHandle As %Binary, date As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i date="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s isOverSubmit=1 ;超过本月审核是日期
	s:$p($zd(+$h,3),"-",3)>=25 isOverSubmit=1
	s isHLB=0,nextDate=+$H+1,nowMonth=$p($zd(+$h,3),"-",2)
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s tRole=$tr($p(role,"^",i)," ","")
	.q:tRole=""
	.i tRole=0 s isHLB=1
	.q:isHLB=1
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(tRole)
	.s rolecode=RoleObj.RoleCode
	.i ((rolecode="admin")||(rolecode="hlb")||(rolecode="hlbzr")||(rolecode="manager")) d
	..s isHLB=1
	s ret="",tmp=""
	s startdate=$zdh(date,3),enddate=startdate+42-1
	s year=$p($zd(+$h,3),"-",1)
	s year=$p(date,"-",1)
	f outdate=startdate:1:enddate d
	.s isHoliday="",dayschdule="",daycheck="",flag=0,outMonth=$p($zd(outdate,3),"-",2),checkSort=0
	.s:nowMonth=12 outMonth=12+nowMonth
	.f tyear=year:1:(year+1) d
	..s code="" f  s code=$O(^DHCNMG.DB.MgHolidaySetI("code",tyear,code)) q:code=""  d
	...s rowid="" f  s rowid=$O(^DHCNMG.DB.MgHolidaySetI("code",tyear,code,rowid)) q:rowid=""  d
	....s holidayObj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rowid)
	....i holidayObj.HolidayDate'="" d
	.....s hstdate=$zdh($p(holidayObj.HolidayDate,",",1),3)
	.....s henddate=$zdh($p(holidayObj.HolidayDate,",",2),3)
	.....i (outdate>=hstdate)&&(outdate<=henddate) d
	......i isHoliday'="" s isHoliday=isHoliday_";"_holidayObj.HolidayID.SubDesc
	......e  s isHoliday=holidayObj.HolidayID.SubDesc
	.f k=1:1:2 d
	..s daytask="",daycheck=""
	..s RowID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",outdate,k,""))
	..s Obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	..i '$IsObject(Obj) d
	...s checkSort="1%2"
	...s sort=""
	...s tmp(outdate,k)="isHoliday|"_isHoliday_"^dayschdule|^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort_"^sort|"_sort_"^editFlag|0"
	...;d OutCalendar
	..q:'$IsObject(Obj)
	..s checkdate=Obj.CheckDate,editFlag=0
	..i (isHLB=1) s editFlag=1
	..i checkdate=outdate d
	...s person=Obj.CheckPerson
	...s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(person)
	...s:$IsObject(perobj) dayschdule=perobj.PerName_"「"_person
	...s person2=Obj.CheckOPerson
	...i (person=nurseid)||(person2=nurseid) s editFlag=1
	...s perobj2=##class(DHCNMG.HR.MgPersons).%OpenId(person2)
	...i $IsObject(perobj2) d
	....i dayschdule="" s dayschdule=perobj2.PerName_"「"_person2
	....e  s dayschdule=dayschdule_","_perobj2.PerName_"「"_person2
	...q:((person'=nurseid)&&(person2'=nurseid))&&(isHLB'=1)
	...i isHLB=1 s flag=1
	...;e  i ((isHLB'=1)&&((person=nurseid)||(person2=nurseid))) d
	...e  i (isHLB'=1) d
	....i (outdate<=nextDate) s flag=1 ;小于当前日期可以看到全部
	....;如果日期为当前月，或本月已过提交日期且日期为下一月可看到排班
	....e  i (outMonth=nowMonth)||((isOverSubmit=1)&&(outMonth=(nowMonth+1))) s flag=2
	..s work=Obj.CheckWork
	..s len=$l(work,",")
	..f i=1:1:len d
	...s itm=$P($p(work,",",i),"^",1)
	...i itm'="" d
	....i daytask="" s daytask=itm
	....e  s daytask=daytask_","_itm
	..s checkRowID=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID,""))
	..s checkObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(checkRowID)
	..i $IsObject(checkObj) d
	...s daychecks=checkObj.TaskUser
	...f i=1:1:$L(daychecks,",") d
	....s checkPerId=$P(daychecks,",",i)
	....s name=""
	....i checkPerId=0 d
	.....s name="管理员"
	....e  d
	.....s checPerObj=##class(DHCNMG.HR.MgPersons).%OpenId(checkPerId)
	.....i $IsObject(checPerObj) s name=checPerObj.PerName
	....i daycheck="" s daycheck=name
	....e  s daycheck=daycheck_","_name
	..s checkSort="1%2"
	..s checkCount=Obj.CheckCount
	..i flag=1 d
	...;s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|"_daytask_"^daygroup|"_Obj.CheckWardGroup_"^daycheck|"_daycheck_"^checkSort|"_checkSort_"^sort|"_checkCount
	...s tmp(outdate,k)="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|"_daytask_"^daygroup|"_Obj.CheckWardGroup_"^daycheck|"_daycheck_"^checkSort|"_checkSort_"^sort|"_checkCount_"^editFlag|"_editFlag
	..e  i flag=2 d
	...;s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort_"^sort|"_checkCount
	...s tmp(outdate,k)="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort_"^sort|"_checkCount_"^editFlag|"_editFlag
	..e  d
	...;s ret="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort_"^sort|"_checkCount
	...s tmp(outdate,k)="isHoliday|"_isHoliday_"^dayschdule|"_dayschdule_"^daytask|^daygroup|^daycheck|"_"^checkSort|"_checkSort_"^sort|"_checkCount_"^editFlag|"_editFlag
	..;s ret=ret_"^editFlag|"_editFlag
	..;d OutCalendar
	//tmp(65099,1)="isHoliday|^dayschdule|^daytask|^daygroup|^daycheck|^editFlag|0^checkSort|1%2^sort|"                                                               
	//tmp(65099,2)="isHoliday|^dayschdule|张晓梅「2^daytask|抢救车管理质量评价考核表^daygroup|组一^daycheck|^checkSort|1%2^sort|2^editFlag|1" 
	s tmpDate="" f  s tmpDate=$o(tmp(tmpDate)) q:tmpDate=""  d
	.s tmpIsHoliday="",tmpDaySchdule="",tmpDayTask="",tmpDayGroup="",tmpDayCheck="",tmpEditFlag="",tmpCheckSort="",tmpSort=""
	.s sort="" f  s sort=$o(tmp(tmpDate,sort)) q:sort=""  d
	..s tmpIsHoliday=$p($p(tmp(tmpDate,sort),"^",1),"|",2)
	..s tmpCheckSort=$p($p(tmp(tmpDate,sort),"^",6),"|",2)
	..i sort=1 d
	...s tmpDaySchdule=$p($p(tmp(tmpDate,sort),"^",2),"|",2)
	...s tmpDayTask=$p($p(tmp(tmpDate,sort),"^",3),"|",2)
	...s tmpDayGroup=$p($p(tmp(tmpDate,sort),"^",4),"|",2)
	...s tmpDayCheck=$p($p(tmp(tmpDate,sort),"^",5),"|",2)
	...s tmpEditFlag=$p($p(tmp(tmpDate,sort),"^",8),"|",2)
	...s tmpSort=$p($p(tmp(tmpDate,sort),"^",7),"|",2)
	..e  i sort=2 d
	...s tmpDaySchdule=tmpDaySchdule_"%"_$p($p(tmp(tmpDate,sort),"^",2),"|",2)
	...s tmpDayTask=tmpDayTask_"%"_$p($p(tmp(tmpDate,sort),"^",3),"|",2)
	...s tmpDayGroup=tmpDayGroup_"%"_$p($p(tmp(tmpDate,sort),"^",4),"|",2)
	...s tmpDayCheck=tmpDayCheck_"%"_$p($p(tmp(tmpDate,sort),"^",5),"|",2)
	...s tmpEditFlag=tmpEditFlag_"%"_$p($p(tmp(tmpDate,sort),"^",8),"|",2)
	...s tmpSort=tmpSort_"%"_$p($p(tmp(tmpDate,sort),"^",7),"|",2)
	.s ret="isHoliday|"_tmpIsHoliday_"^dayschdule|"_tmpDaySchdule_"^daytask|"_tmpDayTask_"^daygroup|"_tmpDayGroup_"^daycheck|"_tmpDayCheck_"^checkSort|"_tmpCheckSort_"^sort|"_tmpSort_"^editFlag|"_tmpEditFlag
 	.d OutCalendar
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCalendar
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCalendar1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCalendar1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCalendar1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCalendar1Execute ]
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

/// Description：某天日期对应排班是否已存在巡查记录
/// Date:2018-09-07
/// Creator:lulin
/// Table:
/// Input:日历开始日期
/// Output:
/// Other:w ##class(web.NurMgNightCheckComm).IsExsitNightCheck("2019-03-27","2")
ClassMethod IsExsitNightCheck(date As %String, sort As %String) As %String
{
	q:date="" "传值为空"
	s:date["-" date=$zdh(date,3)
	;s RowID=..GetSchduleIDByDate(date)
	s RowID=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date,sort,""))
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(RowID)
	q:'$IsObject(obj) "未找到排班"
	s ret=1
	i $d(^DHCNMG.CHK.MgNurNightCheckI("TaskID",RowID)) s ret="已进行巡查，不可删除"
	i $d(^DHCNMG.CHK.MgNurNightCheckBasicI("TaskID",RowID)) s ret="已进行巡查，不可删除"
	q ret
}

/// Creator: lulin
/// Date: 2018-10-18
/// Description: 查询夜查房护士长排班分组【安贞】
/// Table: 
/// Input:类型，parr9[组别^input]
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCheckPerGroupList","31||1","I^")
Query FindCheckPerGroupList(type As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPerGroupListExecute(ByRef qHandle As %Binary, type As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s Category=$tr($p(parr,"^")," ","")
	s input=$ZCVT($tr($p(parr,"^",2)," ",""),"U")
	s ret=""
	if (type="")||(Category=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_Category,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_Category,sort,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s PerDR=obj.GroupPerson
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerDR)
	..q:'$IsObject(perObj)
	..s PerName=perObj.PerName
	..s perID=perObj.PerID
	..s shellName=##class(web.NurMgVueComm).ToChineseSpell(PerName)
	..q:(input'="")&&((PerName_shellName_perID)'[input)
	..s currentWard=##class(web.NurMgHRComm).GetCurrentWard(PerDR,+$h)
	..s NurseWard=""
	..s NurseWardObj=##class(DHCNMG.DB.MgWard).%OpenId(currentWard)
	..i $IsObject(NurseWardObj) s NurseWard=NurseWardObj.WardDesc
 	..s ret="PerName|"_PerName_"^PerWard|"_NurseWard_"^PerSort|"_sort_"^PerDR|"_PerDR_"^RowID|"_rowid
 	..d OutPerGroupList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPerGroupList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPerGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPerGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPerGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPerGroupListExecute ]
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

/// Creator: lulin
/// Date: 2018-10-24
/// Description: 检测周末巡查下一个人来源
/// Table: 
/// Input:日期
/// Output:
/// Other:
ClassMethod getNextPerType(date, month) As %String
{
	s pertype="I"
	q:(date="")||(month="") pertype
	s beforDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," W",date),-1)
	q:beforDate="" pertype
	;s beforMonth=$p($zd(beforDate,3),"-")_$p($zd(beforDate,3),"-",2)
	;q:beforMonth'=month pertype
	;s beforId=..GetSchduleIDByDate(beforDate)
	s beforId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," W",beforDate,""))
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(beforId)
	q:'$IsObject(obj) ..getNextPerType(beforDate,month)
	s beforNurId=obj.CheckPerson
	s id=$O(^DHCNMG.CHK.MgNurCheckGroupI("Per"," W"," "_beforNurId,""))
	s groupObj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	q:'$IsObject(groupObj) ..getNextPerType(beforDate,month)
	i groupObj.GroupCategory="I" s pertype="O"
	q pertype
}

/// Creator: lulin
/// Date: 2018-11-16
/// Description: 获取下个人ID
/// Table: 
/// Input:日期
/// Output:
/// Other:
ClassMethod getNextPerID(date, checkType, type) As %String
{
	q:(date="") ""
	s beforDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_checkType,date),-1)
	q:beforDate="" ""
	;s beforMonth=$p($zd(beforDate,3),"-")_$p($zd(beforDate,3),"-",2)
	;q:beforMonth'=month pertype
	s beforId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_checkType,beforDate,""))
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(beforId)
	q:('$IsObject(obj)||(obj.CheckStatus="B")) ..getNextPerID(beforDate,checkType,type)
	s beforNurId=obj.CheckPerson
	i (type'="I")&&(checkType'="W") s beforNurId=obj.CheckOPerson ;大外科人员
	s id=$O(^DHCNMG.CHK.MgNurCheckGroupI("Per"," "_checkType," "_beforNurId,""))
	s groupObj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	q:'$IsObject(groupObj) ..getNextPerID(beforDate,checkType,type)
	q:groupObj.GroupCategory'=type ..getNextPerID(beforDate,checkType,type)
	s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_checkType," "_type,groupObj.GroupSort))
	s:sort="" sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_checkType," "_type,""))
	s nextId=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_checkType," "_type,sort,""))
	q:nextId="" ..getNextPerID(beforDate,checkType,type)
	q nextId
}

/// Creator: lulin
/// Date: 2018-11-16
/// Description: 获取前一个排版人的id
/// Table: 
/// Input:日期
/// Output:
/// Other:
ClassMethod getBerforPerID(date, checkType, type) As %String
{
	q:(date="") ""
	s beforDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_checkType,date),-1)
	q:beforDate="" ""
	s beforId=..GetSchduleIDByDate(beforDate)
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(beforId)
	q:('$IsObject(obj))||(obj.CheckStatus="B") ..getBerforPerID(beforDate,checkType,type) ;
	s beforNurId=obj.CheckPerson
	i (type'="I")&&(checkType'="W") s beforNurId=obj.CheckOPerson ;大外科人员
	q beforNurId
}

/// Description：获取护士长检查各质控分类次数累计
/// Date:2019-01-16
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod getPerAllCheckNum(perid, type) As %String
{
	q:perid="" 0
	s ret=0,tmpPerArg=""
	s month="" f  s month=$O(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_perid,month)) q:month=""  d
	.s ttype="" f  s ttype=$O(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_perid,month,ttype)) q:ttype=""  d 
	..s id="" f  s id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_perid,month,ttype,id)) q:id=""  d
	...s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(id)
	...q:('$IsObject(obj))||(obj.CheckStatus="B")
	...s ret=ret+1,tmpPerArg(id)=id
	s month="" f  s month=$O(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_perid,month)) q:month=""  d
	.s ttype="" f  s ttype=$O(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_perid,month,ttype)) q:ttype=""  d 
	..s id="" f  s id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_perid,month,ttype,id)) q:id=""  d
	...;q:$d(tmpPerArg(id))
	...s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(id)
	...q:('$IsObject(obj))||(obj.CheckStatus="B")
	...s ret=ret+1
	q ret
}

/// Creator: gzj
/// Date: 2019-03-19
/// Description: 护士长夜查房检查人选择列表数据【安贞专用】
/// Table: 
/// Input:类型,检查科室分组,组别【大内科，大外科】,日期
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCheckPersonList1","N","","I")
Query FindCheckPersonList1(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPersonList1Execute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type=$p(parr,"^")
	s wardtype=$p(parr,"^",2)
	s pertype=$p(parr,"^",3)
	s date=$p(parr,"^",4)
	s month=""
	i date["-" d
	.s month=$p(date,"-")_$p(date,"-",2)
	.s date=$zdh(date,3)
	e  s date=""
	if (type="")||(pertype="")||(date="")||(wardtype=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if type="W" d  ;周末巡查获取下一人从哪个地方获取人
	.s pertype=..getNextPerType(date,month)
	k tmp
	s tmp=""
	;s nextGroupID=..getNextPerID(date,type,pertype),isNextPer=0
	s flag=0 ;周末巡查是否已取人
	s BeforPerID=..getBerforPerID(date,type,pertype)
	s tAllNum=..getPerAllCheckNum(BeforPerID,type)
	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	..;i rowid=nextGroupID s isNextPer=1
	..q:'$IsObject(obj)
	..s PerDR=obj.GroupPerson
	..s isAskLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(PerDR_"^"_date) ;是否请假
	..q:isAskLeave=1
	..s isCheck=..IsCheckPerExist(type,month,PerDR) ;是否本月已检查
	..q:isCheck=1
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerDR)
	..q:'$IsObject(perObj)
	..s isPerInGroup=..IsPerWardInGroup(PerDR,date,wardtype,type) //是否检查自己病区
	..q:isPerInGroup=1
	..s PerName=perObj.PerName
	..s tPerCheckNum=..getPerAllCheckNum(PerDR,type)
	..s berforRet=9999
	..s:tPerCheckNum<tAllNum berforRet=0
	..s tmp(berforRet+obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
 	..;s ret="PerName|"_PerName_"^PerDR|"_PerDR
 	..;d OutCheckPersonList
 	..s flag=1
 	if (type="W")&&(flag=0){
	 	i pertype="I" s pertype="O"
	 	e  s pertype="I"
	 	;s nextGroupID=..getNextPerID(date,type,pertype),isNextPer=0
	 	s BeforPerID=..getBerforPerID(date,type,pertype)
		s tAllNum=..getPerAllCheckNum(BeforPerID,type)
	 	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort)) q:sort=""  d
		.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort,rowid)) q:rowid=""  d
		..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
		..;i rowid=nextGroupID s isNextPer=1
		..q:'$IsObject(obj)
		..s PerDR=obj.GroupPerson
		..s isAskLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(PerDR_"^"_date) ;是否请假
		..q:isAskLeave=1
		..s isCheck=..IsCheckPerExist(type,month,PerDR) ;是否本月已检查
		..q:isCheck=1
		..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerDR)
		..q:'$IsObject(perObj)
		..s isPerInGroup=..IsPerWardInGroup(PerDR,date,wardtype,type)
		..q:isPerInGroup=1
		..s PerName=perObj.PerName
		..s tPerCheckNum=..getPerAllCheckNum(obj.GroupPerson,type)
		..s berforRet=9999
		..s:tPerCheckNum<tAllNum berforRet=0
		..s tmp(berforRet+obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
 		..;s ret="PerName|"_PerName_"^PerDR|"_PerDR
 		..;d OutCheckPersonList
 	}
 	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
 	.s ret=tmp(sort)
 	.d OutCheckPersonList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckPersonList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPersonList1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonList1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPersonList1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonList1Execute ]
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

/// Creator: lulin
/// Date: 2018-10-18
/// Description: 护士长夜查房检查人选择列表数据
/// Table: 
/// Input:类型,检查科室分组,组别【大内科，大外科】,日期
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCheckPersonList","N^组一^O^2019-03-20")
Query FindCheckPersonList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPersonListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type=$p(parr,"^")
	s wardtype=$p(parr,"^",2)
	s pertype=$p(parr,"^",3)
	s date=$p(parr,"^",4)
	s month=""
	i date["-" d
	.s month=$p(date,"-")_$p(date,"-",2)
	.s date=$zdh(date,3)
	e  s date=""
	i ((type="")||(pertype="")||(date="")||(wardtype="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	if type'="W" d  ;周末巡查获取下一人从哪个地方获取人
	.s pertype=..getNextPerType(date,month)
	k tmp
	s tmp=""
	s nextGroupID=..getNextPerID(date,type,pertype),isNextPer=0
	s beforDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Type"," "_type,date),-1)
	s flag=0 ;周末巡查是否已取人
	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s PerDR=obj.GroupPerson
	..s isAskLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(PerDR_"^"_date) ;是否请假
	..q:isAskLeave=1
	..s isCheck=..IsCheckPerExist(type,month,PerDR) ;是否本月已检查
	..q:isCheck=1
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerDR)
	..q:'$IsObject(perObj)
	..s isPerInGroup=..IsPerWardInGroup(PerDR,date,wardtype,type)
	..q:isPerInGroup=1
	..s PerName=perObj.PerName
	..i rowid=nextGroupID s isNextPer=1
	..i isNextPer=0 s tmp(9999_obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
	..e  s tmp(obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
 	..s flag=1
 	i ((type'="W")&&(flag=0))
 	{
	 	i pertype="I" s pertype="O"
	 	e  s pertype="I"
	 	s nextGroupID=..getNextPerID(date,type,pertype),isNextPer=0
	 	s sort="" f  s sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort)) q:sort=""  d
		.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_pertype,sort,rowid)) q:rowid=""  d
		..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
		..q:'$IsObject(obj)
		..s PerDR=obj.GroupPerson
		..s isAskLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(PerDR_"^"_date) ;是否请假
		..q:isAskLeave=1
		..s isCheck=..IsCheckPerExist(type,month,PerDR) ;是否本月已检查 
		..q:isCheck=1 //如果已经参与检查 就要过滤掉  南通中医不用检查是否参与排班
		..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(PerDR)
		..q:'$IsObject(perObj)
		..s isPerInGroup=..IsPerWardInGroup(PerDR,date,wardtype,type)
		..q:isPerInGroup=1
		..s PerName=perObj.PerName
 		..i rowid=nextGroupID s isNextPer=1
		..i isNextPer=0 s tmp("+"_obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
		..e  s tmp(obj.GroupSort)="PerName|"_PerName_"^PerDR|"_PerDR
 	}
 	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
 	.s ret=tmp(sort)
 	.d OutCheckPersonList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckPersonList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPersonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPersonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonListExecute ]
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

/// Description：护士长排班分组右移【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod MoveRightPer(type, group, parr) As %String
{
	q:(type="")||(group="") 0 
	s flag=1
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		;s RowID=$O(^DHCNMG.CHK.MgNurCheckGroupI("Per"," "_type," "_itm,""))
		s RowID=$o(^DHCNMG.CHK.MgNurCheckGroupI("Nur"," "_type," "_group," "_itm,""))
		i RowID=""
		{
			s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%New()
			s obj.GroupPerson=itm
			s obj.GroupType=type
			s obj.GroupCategory=group
			s Sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_group,""),-1)
			i Sort'="" s Sort=Sort+1
			e  s Sort=1
			s obj.GroupSort=Sort
			s sc=obj.%Save()
			s flag=flag&&$$$ISOK(sc)
		}
	}
	q flag
}

/// Description：护士长排班分组左移【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod MoveLeftPer(type, group, parr) As %String
{
	q:(type="")||(group="") 0 
	s flag=1
	s len=$l(parr,"^")
	TS
	f i=1:1:len
	{
		s id=$p(parr,"^",i)
		i id="" continue
		s sc=##class(DHCNMG.CHK.MgNurCheckGroup).%DeleteId(id)
		s flag=flag&&$$$ISOK(sc)
	}
	q:flag'=1 0
	s tsort=1
	s Sort="" f  s Sort=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_group,Sort))  q:(Sort="")||(flag'=1)  d
	.s id="" f  s id=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_type," "_group,Sort,id)) q:(id="")||(flag'=1)  d
	..s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(id)
	..q:'$IsObject(obj)
	..s obj.GroupSort=tsort
	..s sc=obj.%Save()
	..s flag=flag&&$$$ISOK(sc)
	..q:flag'=1
	..s tsort=tsort+1
	if flag=1{
		TC
	}else{
		TRO	
	}
	q flag
}

/// Description：护士长排班分组成员上下移动【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod MovePerGroupRec(type, parr) As %String
{
	q:parr="" 0
	s start=1,step=1,end=$L(parr,",")
	i type="D" s start=$L(parr,","),step=-1,end=1
	f i=start:step:end d
	.s rowid=$P(parr,",",i)
	.q:rowid=""
	.s obj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s GroupType=obj.GroupType
	.s Category=obj.GroupCategory
	.s sort=obj.GroupSort
	.s nextSort=sort-step
	.s nextrowid=$O(^DHCNMG.CHK.MgNurCheckGroupI("TypeSort"," "_GroupType," "_Category,nextSort,""))
	.s nextObj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(nextrowid)
	.s nextObj.GroupSort=sort
	.d nextObj.%Save()
	.s obj.GroupSort=nextSort
	.d obj.%Save()
	q 1
}

/// Description：某人某月是否已检查某类型查房【安贞专用】
/// Date:2019-03-19
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsCheckPerExist1(type, month, id) As %String
{
	q:(type="")||(month="")||(id="") 1
	s flag=0
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Month",month,rowid)) q:(rowid="")||(flag=1)  d
	.s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.CheckStatus="B"
	.i obj.CheckPerson=id s flag=1
	.e  i obj.CheckOPerson=id s flag=1
	q flag
}

/// Description：某人某月是否已检查某类型查房【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsCheckPerExist(type, month, id) As %String
{
	q:(type="")||(month="")||(id="") 1
	s flag=0
	i $D(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_id,month)) s flag=1
	q:flag=1 flag
	i $D(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_id,month)) s flag=1
	q flag
}

/// Description：某人所在病区是否在检查病区组【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsPerWardInGroup(perid, date, group, type) As %String
{
	q:(perid="")||(date="")||(group="")||(type="") 1
	s flag=0
	i date["-" s date=$zdh(date,3)
	s currward=##class(web.NurMgHRComm).GetCurrentWard(perid,date)
	q:currward="" 1
	s id="" f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Type"," "_type," "_currward,id)) q:(id="")||(flag=1)  d
	.s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.WardGroup'=group
	.s flag=1
	q flag
}

/// Description：夜查房不允许查本系统内科室（例如大内系统内护士长不可以查大内系统的病区）,早交班可以查本系统不可以查本病区【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsPerGroupInArea(perid, group, type) As %String
{
	q:(perid="")||(date="")||(group="")||(type="") 1
	s NurCheckGroupId=$O(^DHCNMG.CHK.MgNurCheckGroupI("Per"," "_type," "_perid,""))
	s NurCheckGroupObj=##class(DHCNMG.CHK.MgNurCheckGroup).%OpenId(NurCheckGroupId)
	s NurCategory=""
	s:$IsObject(NurCheckGroupObj) NurCategory=NurCheckGroupObj.GroupCategory
	s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,sort)) q:(sort="")||(flag=1)  d
	.s id=""  f  s id=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,sort,id)) q:(id="")||(flag=1)  d
	..s obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(id)
	..q:'$IsObject(obj)
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.WardID)
	..q:'$IsObject(wardObj)
	..i ($IsObject(wardObj.WardAreaDR))&&(NurCategory'="")&&(((NurCategory="O")&&(wardObj.WardAreaDR.AreaDesc["大内科"))||((NurCategory="I")&&(wardObj.WardAreaDR.AreaDesc["妇"))) d
	...s flag=1
}

/// Description：检测是否可以保存
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:perdrs^group^type^date
/// Output:
/// Other:"46,16^测试三^N^2018-10-10"
ClassMethod IsAbleSave(parr As %String = "") As %String
{
	s perdrs=$p(parr,"^")
	s group=$p(parr,"^",2)
	s type=$P(parr,"^",3)
	s date=$p(parr,"^",4)
	i date["-" d
	.s month=$p(date,"-")_$p(date,"-",2)
	.s date=$zdh(date,3)
	e  s date=""
	q:(perdrs="")||(group="")||(type="")||(date="") "参数有空值，请刷新界面"
	s flag=0,ret=1
	f i=1:1:$L(perdrs,",") q:flag=1  d
	.s id=$p(perdrs,",",i)
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	.i '$IsObject(obj) s flag=1,ret="无检查人信息，请刷新界面重试"
	.q:flag=1
	.s flag=..IsCheckPerExist(type,month,id)
	.i flag=1  s ret=obj.PerName_"已检查"
	.q:flag=1
	.s flag=..IsPerWardInGroup(id, date, group, type)
	.i flag=1 s ret=obj.PerName_"所在病区与检查病区冲突"
	.q:flag=1
	.s flag=##class(web.NurMgArgComm).IsPerAskLeavel2(id_"^"_date) ;是否请假
	.i flag=1 s ret=obj.PerName_"已请假"
	.q:flag=1
	q ret
}

/// Description：获取护士长检查各质控分类次数按年累计【安贞专用】
/// Date:2019-03-19
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod getPerCheckNum1(parr) As %String
{
	s perid=$tr($p(parr,"^")," ","")
	s year=$p($p(parr,"^",2),"-")
	q:(perid="")||(year="") ""
	s ret=""
	s NNum=0,WNum=0,HNum=0
	s month="" f  s month=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Month",month)) q:month=""  d
	.q:$e(month,0,4)'=year
	.s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Month",month,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:obj.CheckStatus="B"
	..q:(obj.CheckPerson'=perid)&&(obj.CheckOPerson'=perid)
	..s tType=obj.CheckType
	..i tType="N" s NNum=NNum+1
	..e  i tType="W"  s WNum=WNum+1
	..e  i tType="H"  s HNum=HNum+1
	s ret="夜班:"_NNum_",周末班:"_WNum_",节日班:"_HNum
	q ret
}

/// Description：获取护士长检查各质控分类次数按年累计
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod getPerCheckNum(parr) As %String
{
	s perid=$tr($p(parr,"^")," ","")
	s year=$p($p(parr,"^",2),"-")
	q:(perid="")||(year="") ""
	s ret=""
	s NNum=0,WNum=0,HNum=0
	s month="" f  s month=$O(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_perid,month)) q:month=""  d
	.q:$e(month,0,4)'=year
	.s type="" f  s type=$O(^DHCNMG.CHK.MgNurHeadSchduleI("PerMonth"," "_perid,month,type)) q:type=""  d
	..s tType=$tr(type," ","")
	..i tType="N" s NNum=NNum+1
	..e  i tType="W"  s WNum=WNum+1
	..e  i tType="H"  s HNum=HNum+1
	s month="" f  s month=$O(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_perid,month)) q:month=""  d
	.q:$e(month,0,4)'=year
	.s type="" f  s type=$O(^DHCNMG.CHK.MgNurHeadSchduleI("OperMonth"," "_perid,month,type)) q:type=""  d
	..s tType=$tr(type," ","")
	..i tType="N" s NNum=NNum+1
	..e  i tType="W"  s WNum=WNum+1
	..e  i tType="H"  s HNum=HNum+1
	s ret="夜班:"_NNum_",周末班:"_WNum_",节日班:"_HNum
	q ret
}

/// Description：嵌入到his护管，验证密码
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetNursePassword(usercode As %String, password As %String) As %String
{
	;s %session.AppTimeout=60*1
	;s sc=%session.Login("_system","SYS",1)
	s retstr=0
	s hisno="",userpassword="",nurserw=""
	i usercode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	s nurseid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(usercode," ",""),"U"),""))
	q:nurseid="" "护管工号不存在"
	s userpassword=$p($G(^SSU("SSUSR",userId)),"^",3)
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(password)
	i pin="" s retstr="密码错误"
	e  d
	.i pin'=userpassword s retstr="密码错误"
	zn oldnamespace
	i retstr=0 s retstr=0_"^"_nurseid
	q retstr
}

/// Description：根据日期获取排班人
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetNightCheckPer(parr As %String, rw As %String = "", post As %String)
{
	s date=$p(parr,"^")
	s nurseid=$p(parr,"^",2)
	s flag=$p(parr,"^",3)
	i date["-" s date=$zdh(date,3)
	e  s date=""
	q:(date="")||(nurseid="") "0^入参错误"
	;s id=..GetSchduleIDByDate(date)
	;s id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",date,""))
	s id=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",date,post,""))
	q:id="" "0^未查找到排班"
	s isExist=..IsExistShiftRelation(date,rw,post)
	q:isExist=1 "0^存在关联此日期已提交换班"
	q:($d(^DHCNMG.CHK.MgNurNightCheckI("TaskID",id))||$d(^DHCNMG.CHK.MgNurNightCheckBasicI("TaskID",id))) "0^已检查不可选"
	s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(id)
	q:(obj.CheckOPerson'=nurseid)&&(obj.CheckPerson'=nurseid)&&(flag=1)&&(nurseid'=0) "0^登录者与排班人不一致"
	s perobj1=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CheckPerson)
	s ret=""
	s:$IsObject(perobj1) ret=perobj1.PerName
	s perobj2=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CheckOPerson)
	i $IsObject(perobj2) d
	.i ret="" s ret=perobj2.PerName
	.e  s ret=ret_","_perobj2.PerName
	q "1^"_ret
}

/// Description：是否存在已有申请
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsExistShiftRelation(date As %String, rw As %String, post As %String) As %String
{
	q:date="" 0
	i date["-" s date=$zdh(date,3)
	s flag=0
	s id="" f  s id=$O(^DHCNMG.CHK.MgNurCheckShiftD(id)) q:(id="")||(flag=1)  d
	.q:(rw'="")&&(rw=id)
	.s obj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(obj.ShiftStatus="A")||(obj.ShiftStatus="B")||(obj.ShiftStatus="C")||(obj.ShiftStatus="N")
	.q:(obj.ShiftToDate'=date)&&(obj.ShiftDate'=date)
	.;s fromSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",obj.ShiftDate,""))
	.s fromSchId=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",obj.ShiftDate,post,""))
	.s fromSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(fromSchId)
	.;s toSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",obj.ShiftToDate,""))
	.s toSchId=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",obj.ShiftToDate,post,""))
	.s toSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(toSchId)
	.q:('$IsObject(fromSchObj))!('$IsObject(toSchObj))
	.s flag=1
	q flag
}

/// Description：保存换班申请【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:w ##class(web.NurMgNightCheckComm).SaveCheckShift(^TMP("SaveCheckShift"),0)
ClassMethod SaveCheckShift(parr, nurseid) As %String
{
	s fromDate=$p(parr,"^")
	i fromDate["-" s fromDate=$zdh(fromDate,3)
	e  s fromDate=""
	s toDate=$p(parr,"^",2)
	i toDate["-" s toDate=$zdh(toDate,3)
	e  s toDate=""
	q:(fromDate="")||(toDate="") "传参错误，请刷新界面重试"
	s RowID=$p(parr,"^",3)
	s changePost=$p(parr,"^",5)
	s exChangePost=$p(parr,"^",6)
	s isExist=..IsExistShiftRelation(fromDate,RowID,changePost)
	q:isExist=1 "存在与换班日期有关的换班"
	s isExist2=..IsExistShiftRelation(toDate,RowID,exChangePost)
	q:isExist=1 "存在与交换日期有关的换班"
	;s fromSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",fromDate,""))
	s fromSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("sort",fromDate,changePost,""))
	s fromSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(fromSchId)
	q:'$IsObject(fromSchObj) "换班日期不存在排班"
#;	s isInLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(fromSchObj.CheckPerson_"^"_toDate)
#;	s isInLeave2=##class(web.NurMgArgComm).IsPerAskLeavel2(fromSchObj.CheckOPerson_"^"_toDate)
#;	q:(isInLeave=1)||(isInLeave2=1) "换班人员在交换日期请假"
	;s toSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",toDate,""))
	s toSchId=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",toDate,exChangePost,""))
	s toSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(toSchId)
	q:'$IsObject(toSchObj) "交换日期不存在排班"
	q:toSchObj.CheckType'=fromSchObj.CheckType "所交换排班不同类型"
#;	s isInLeave=##class(web.NurMgArgComm).IsPerAskLeavel2(toSchObj.CheckPerson_"^"_fromDate)
#;	s isInLeave2=##class(web.NurMgArgComm).IsPerAskLeavel2(toSchObj.CheckOPerson_"^"_fromDate)
#;	q:(isInLeave=1)||(isInLeave2=1) "交换人员在换班日期请假"
#;	s currward=##class(web.NurMgHRComm).GetCurrentWard(fromSchObj.CheckOPerson,toDate)
#;	s currward2=##class(web.NurMgHRComm).GetCurrentWard(fromSchObj.CheckPerson,toDate)
#;	s inWard=0
#;	f i=1:1:toSchObj.CheckWards.Count() q:inWard=1  d
#;	.i (toSchObj.CheckWards.GetAt(i)=currward)||(toSchObj.CheckWards.GetAt(i)=currward2) s inWard=1
#;	q:inWard=1 "换班人与交换日期排班科室冲突"
#;	s currward=##class(web.NurMgHRComm).GetCurrentWard(toSchObj.CheckPerson,fromDate)
#;	s currward2=##class(web.NurMgHRComm).GetCurrentWard(toSchObj.CheckPerson,fromDate)
#;	
#;	s inWard=0
#;	f i=1:1:fromSchObj.CheckWards.Count() q:inWard=1  d
#;	.i (fromSchObj.CheckWards.GetAt(i)=currward)||(fromSchObj.CheckWards.GetAt(i)=currward2) s inWard=1
#;	q:inWard=1 "交换人与换班日期排班科室冲突"
#;	s isCheck=0 
#;	s id="" f id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Per"," "_fromSchObj.CheckType,fromSchObj.CheckMonth," "_toSchObj.CheckPerson,id)) q:(id="")||(isCheck=1)  d
#;	.q:id=toSchObj.%Id()
#;	.s isCheck=1
#;	q:isCheck=1 "交换人员查房类型冲突"
#;	s id="" f id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Per"," "_fromSchObj.CheckType,fromSchObj.CheckMonth," "_toSchObj.CheckOPerson,id)) q:(id="")||(isCheck=1)  d
#;	.q:id=toSchObj.%Id()
#;	.s isCheck=1
#;	q:isCheck=1 "交换人员查房类型冲突"
#;	s id="" f id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Per"," "_toSchObj.CheckType,toSchObj.CheckMonth," "_fromSchObj.CheckOPerson,id)) q:(id="")||(isCheck=1)  d
#;	.q:id=fromSchObj.%Id()
#;	.s isCheck=1
#;	q:isCheck=1 "换班人员查房类型冲突"
#;	s id="" f id=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Per"," "_toSchObj.CheckType,toSchObj.CheckMonth," "_fromSchObj.CheckPerson,id)) q:(id="")||(isCheck=1)  d
#;	.q:id=fromSchObj.%Id()
#;	.s isCheck=1
#;	q:isCheck=1 "换班人员查房类型冲突"
	i RowID="" d
	.s obj=##class(DHCNMG.CHK.MgNurCheckShift).%New()
	e  s obj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(RowID)
	s obj.ShiftDate=fromDate
	s obj.ShiftStatus="S"
	s obj.ShiftToDate=toDate
	s obj.ShiftRemark=$p(parr,"",4)
	s obj.shiftCreator=nurseid
	s obj.ShiftPer=fromSchObj.CheckPerson_","_fromSchObj.CheckOPerson
	s obj.ShiftToPer=toSchObj.CheckPerson_","_toSchObj.CheckOPerson
	s obj.ShiftCreateDate=+$H
	s obj.ChangePost=changePost
	s obj.ExChangePost=exChangePost
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 2
}

/// Creator: lulin
/// Date: 2018-10-22
/// Description: 查询换班列表数据
/// Table: 
/// Input:rowid
/// Output:
/// Other: 
ClassMethod GetCheckShift(id) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(id)
	q:'$IsObject(obj) ""
	q:(obj.ShiftDate="")!(obj.ShiftToDate="")
	s ret=""
	s ShiftStatus=obj.ShiftStatus
	s ShiftStatusDesc=$case(ShiftStatus,"C":"作废","N":"未提交","S":"未审核","NA":"护士长已审核","HA":"护理部已审核","B":"驳回","":"未提交")
	s ret="ShiftStatus|"_ShiftStatus_"^ShiftStatusDesc|"_ShiftStatusDesc
	s ShiftDateFrom=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ShiftDate)
	s ret=ret_"^ShiftDateFrom|"_ShiftDateFrom
	s ShiftPerFrom=obj.ShiftPer
	s ShiftPerNameFrom=""
	f i=1:1:$l(ShiftPerFrom,",") d
	.s perid=$p(ShiftPerFrom,",",i)
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(perObj)
	.i ShiftPerNameFrom="" s ShiftPerNameFrom=perObj.PerName
	.e  s ShiftPerNameFrom=ShiftPerNameFrom_","_perObj.PerName
	s ret=ret_"^ShiftPerFrom|"_ShiftPerFrom_"^ShiftPerNameFrom|"_ShiftPerNameFrom
	s ShiftDateTo=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ShiftToDate)
	s ret=ret_"^ShiftDateTo|"_ShiftDateTo
	s ShiftPerTo=obj.ShiftToPer
	s ShiftPerNameTo=""
	f i=1:1:$l(ShiftPerTo,",") d
	.s perid=$p(ShiftPerTo,",",i)
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(perObj)
	.i ShiftPerNameTo="" s ShiftPerNameTo=perObj.PerName
	.e  s ShiftPerNameTo=ShiftPerNameTo_","_perObj.PerName
	s ret=ret_"^ShiftPerTo|"_ShiftPerTo_"^ShiftPerNameTo|"_ShiftPerNameTo
	s ShiftCreater=obj.shiftCreator,ShiftCreaterName=""
	i ShiftCreater=0 s ShiftCreaterName="管理员"
	e  d
	.s ShiftCreaterObj=##class(DHCNMG.HR.MgPersons).%OpenId(ShiftCreater)
	.i $IsObject(ShiftCreaterObj) s ShiftCreaterName=ShiftCreaterObj.PerName
	s ret=ret_"^ShiftCreater|"_ShiftCreater_"^ShiftCreaterName|"_ShiftCreaterName
	s ShiftUpdater=obj.shiftUpdator,ShiftUpdaterName=""
	i ShiftUpdater=0 s ShiftUpdaterName="管理员"
	e  d
	.s ShiftUpdaterObj=##class(DHCNMG.HR.MgPersons).%OpenId(ShiftUpdater)
	.i $IsObject(ShiftUpdaterObj) s ShiftUpdaterName=ShiftUpdaterObj.PerName
	s ret=ret_"^ShiftUpdater|"_ShiftUpdater_"^ShiftUpdaterName|"_ShiftUpdaterName
	s ShiftReason=obj.ShiftReason
	s ShiftRemark=obj.ShiftRemark
	s ret=ret_"^ShiftReason|"_ShiftReason_"^ShiftRemark|"_ShiftRemark
	s ret=ret_"^rw|"_id
	s ShiftCreateDate=$zd(obj.ShiftCreateDate,3)
	s ShiftUpdateDate=$zd(obj.ShiftUpdateDate,3)
	s ret=ret_"^ShiftCreateDate|"_ShiftCreateDate_"^ShiftUpdateDate|"_ShiftUpdateDate
	q ret
}

/// Creator: lulin
/// Date: 2018-10-22
/// Description: 查询换班列表数据
/// Table: 
/// Input:姓名、简拼、工号
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindCheckShiftList","N","","I")
Query FindCheckShiftList(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckShiftListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s fromDate=$p(parr,"^")
	i fromDate["-" s fromDate=$zdh(fromDate,3)
	.e  s fromDate=""
	s toDate=$p(parr,"^",2)
	i toDate["-" s toDate=$zdh(toDate,3)
	.e  s toDate=""
	k tmpWard
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id="" f  s id=$O(^DHCNMG.CHK.MgNurCheckShiftD(id)) q:id=""  d
	.s obj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(fromDate'="")&&(obj.ShiftToDate<fromDate)
	.q:(toDate'="")&&(obj.ShiftDate>toDate)
	.s fromPerId=obj.ShiftPer
	.s tmpWard=obj.ShiftToPer
	.s isExist=1
	.i isAll'=1 d
	..f i=1:1:$l(obj.ShiftPer,",") q:isExist=0  d
	...s perId=$p(obj.ShiftPer,",",i)
	...s currward=##class(web.NurMgHRComm).GetCurrentWard(perId,+$h)
	...i (currward'="")&&($d(tmpWard(currward))) s isExist=0
	..f i=1:1:$l(obj.ShiftToPer,",") q:isExist=0  d
	...s perId=$p(obj.ShiftToPer,",",i)
	...s currward=##class(web.NurMgHRComm).GetCurrentWard(perId,+$h)
	...i (currward'="")&&($d(tmpWard(currward))) s isExist=0
	.q:(isAll'=1)&&(isExist=1)
	.s ret=..GetCheckShift(id)
 	.d OutCheckShiftList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckShiftList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckShiftListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckShiftListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckShiftListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckShiftListExecute ]
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

/// Description：更新换班申请状态
/// Date:2018-10-22
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveShiftStatus(parr, nurseid, role) As %String
{
	s ids=$p(parr,"^")
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	q:(ids="")||(status="") 0
	s isHLB=0
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s trole=$p(role,"^",i)
	.q:trole=""
	.i trole'=0 d
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(trole)
	..i $IsObject(roleObj) d
	...s code=$zcvt(roleObj.RoleCode,"U")
	...i ((code="ADMIN")||(code="MANAGER")||(code="HLBZR")||(code="HLB")) s isHLB=1
	.e  s isHLB=1
	//护士长夜查房换班驳回操作与审核一样--李春圆
	/*s status="NA"
	s:isHLB=1 status="HA"
	*/
	s:(isHLB=0)&&(status="A") status="NA"
	s:(isHLB=1)&&(status="A") status="HA"
	TS
	s flag=1
	for i=1:1:$l(ids,",") q:flag=0  d
	.s id=$p(ids,",",i)
	.s obj=##class(DHCNMG.CHK.MgNurCheckShift).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(status="NA")&&((","_obj.ShiftToPer)'[(","_nurseid)) ;无权限审核
	.q:(obj.ShiftStatus="B")||(obj.ShiftStatus="HA")||(obj.ShiftStatus="C")  ;已驳回/护理部已审核/作废，不可驳回，不可审核
	.q:(obj.ShiftStatus="NA")&&(status="NA") ;护士长已审核，不可继续护士长审核
	.q:(obj.ShiftStatus'="NA")&&(status="HA") ;护士长未审核，护理部不可审核
	.;s fromSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",obj.ShiftDate,""))
	.s fromSchId=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",obj.ShiftDate,obj.ChangePost,""))
	.s fromSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(fromSchId)
	.;s toSchId=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",obj.ShiftToDate,""))
	.s toSchId=$o(^DHCNMG.CHK.MgNurHeadSchduleI("sort",obj.ShiftToDate,obj.ExChangePost,""))
	.s toSchObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(toSchId)
	.q:('$IsObject(fromSchObj))||('$IsObject(toSchObj))
	.s obj.ShiftReason=reason
	.s obj.ShiftStatus=status
	.s obj.ShiftUpdateDate=+$H
	.s obj.shiftUpdator=nurseid
	.s flag=flag&&$$$ISOK(obj.%Save())
	.q:flag=0
	.q:status'="HA"
	.q:isHLB'=1
	.s per=fromSchObj.CheckPerson
	.s per2=fromSchObj.CheckOPerson
	.s fromSchObj.CheckPerson=toSchObj.CheckPerson
	.s fromSchObj.CheckOPerson=toSchObj.CheckOPerson
	.s toSchObj.CheckPerson=per
	.s toSchObj.CheckOPerson=per2
	.s flag=flag&&$$$ISOK(fromSchObj.%Save())
	.s flag=flag&&$$$ISOK(toSchObj.%Save())
	i flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// Description：加载护士长夜查房项目列表
/// Date:2018-05-03
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsExistCheckPlan(parr) As %String
{
	s type=$p(parr,"^")
	s year=$p(parr,"^",2)
	q:(type="")||(year="") 2
	s flag=0
	i $d(^DHCNMG.CHK.MgNurCheckPlanI("Type",year," "_type)) s flag=1
	q flag
}

/// Description：下个月是否有排班
/// Date:2018-12-12
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsExistCheckNextMonth(parr) As %String
{
	;q:(parr="") 1
	;s flag=1
	;s flag=flag&&$d(^DHCNMG.CHK.MgNurHeadSchduleI("Month",parr))
	;q flag
	q:(parr="") 1
	s flag=0
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgNurHeadSchduleI("Month",parr,rowid)) q:(rowid="")||(flag=1)  d
	.s obj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.CheckStatus="B"
	.s flag=1
	q flag
}

/// Description：查询早教班病区选择项目
/// Date:2018-05-05
/// Creator:lulin
/// Table:
/// Input:date^group
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgNightCheckComm","FindSpecialWardList","N",^TMP("FindSpecialWardList"))
Query FindSpecialWardList(type As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSpecialWardListExecute(ByRef qHandle As %Binary, type As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s date=$P(parr,"^")
	s group=$zcvt($p(parr,"^",2),"U")
	s type=$zcvt($tr(type," ",""),"U")
	i date["-" s date=$zdh(date,3)
	e  s date=""
	if (group="")||(date="")||(type=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sort="" f  s sort=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,sort)) q:sort=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgNurCheckWardI("Group"," "_type," "_group,sort,RowID)) q:RowID=""  d
	..s Obj=##class(DHCNMG.DB.MgNurCheckWard).%OpenId(RowID)
	..q:'$IsObject(Obj)
	..s tmp("sort",sort,Obj.WardID)=sort
	..s tmp("ward",Obj.WardID)=Obj.WardID
	s flag=0,beforWard=""
	s date=""  f  s date=$O(^DHCNMG.CHK.MgNurHeadSchduleI("DateSpecial",date),-1) q:(date="")||(flag=1)  d
	.s tward="" f  s tward=$O(^DHCNMG.CHK.MgNurHeadSchduleI("DateSpecial",date,tward)) q:(tward="")||(flag=1)   d
	..s ttWard=$tr(tward," ","")
	..q:ttWard=""
	..i $D(tmp("ward",ttWard)) s flag=1,beforWard=ttWard
	s ref=999
	s sort="" f  s sort=$O(tmp("sort",sort)) q:sort=""  d
	.s wardid="" f  s wardid=$O(tmp("sort",sort,wardid)) q:wardid=""  d
	..s tsort=ref+sort
	..s tmpRet(tsort,wardid)=wardid
	..i wardid=beforWard s ref=0
	s sort="" f  s sort=$O(tmpRet(sort)) q:sort=""  d
	.s wardid="" f  s wardid=$O(tmpRet(sort,wardid)) q:wardid=""  d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	..q:'$IsObject(wardObj)
	..s ret="WardID|"_wardObj.%Id()_"^WardDesc|"_wardObj.WardDesc
	..d OutSpecialWardData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSpecialWardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSpecialWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecialWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSpecialWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecialWardListExecute ]
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

/// Description：更新前清楚一些夜查房更新数据【安贞】
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:d ##class(web.NurMgNightCheckComm).ClearNightCheckData()
ClassMethod ClearNightCheckData()
{
	;k ^DHCNMG.CHK.MgNurCheckGroupI
	;k ^DHCNMG.CHK.MgNurCheckGroupD
	k ^DHCNMG.CHK.MgNurNightBasicI
	k ^DHCNMG.CHK.MgNurNightBasicD
	;k ^DHCNMG.CHK.MgNurCheckPlanSubI
	;k ^DHCNMG.CHK.MgNurCheckPlanSubD
	;k ^DHCNMG.CHK.MgNurCheckPlanI
	;k ^DHCNMG.CHK.MgNurCheckPlanD
	k ^DHCNMG.CHK.MgNurNightCheckI
	k ^DHCNMG.CHK.MgNurNightCheckD
	k ^DHCNMG.CHK.MgNurNightCheckSubI
	k ^DHCNMG.CHK.MgNurNightCheckSubD
	k ^DHCNMG.CHK.MgNurNightTaskI
	k ^DHCNMG.CHK.MgNurNightTaskD
	k ^DHCNMG.CHK.MgNurHeadSchduleI
	k ^DHCNMG.CHK.MgNurHeadSchduleD
	k ^DHCNMG.CHK.MgNurTaskGroupI
	k ^DHCNMG.CHK.MgNurTaskGroupD
	q 0
}

}
