/// Creator:gzj
/// Date:2018-11-06
/// Description:护士统计公共类扩展
Class web.MgNurArgStaticComm Extends %RegisteredObject
{

/// Creator:
/// Description:查询护士个人班次统计
/// Date:2018-11-06
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.MgNurArgStaticComm","FindNurseWork","109","2018-12-01^2019-01-18")
Query FindNurseWork(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseWorkExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindNurseWork")=ward_"^"_parr //109^2018-12-01^2019-02-28
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret="",ret1=""
	s tmp="",day="",holiday=""
	s stdate=$zdh($p(parr,"^",1),3)
	s enddate=$zdh($p(parr,"^",2),3)
	s StandHour=0,workDays=0
	f date=stdate:1:enddate
	{
		//6!0(周六或周日)判断周六日
		s weekDay=$zd(date,10)
		i ((weekDay=0)!(weekDay=6)) d //该天为周日或者六
		.//判断是否为“班” 1 班 0 不是班
		.s workflag=..GetWorkdayFlag($zd(date,3))
		.i workflag=1 d //为班
		..s workDays=workDays+1
		e  d
		.s holidayFlag=..GetHolidayFlag($zd(date,3))
		.i holidayFlag=0 d //该不是假期
		..s workDays=workDays+1
		s StandardTime=0
		s setRow=$O(^DHCNMG.Set.MgArgParamSetD(""))
		i setRow'="" d
		.s SetObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(setRow)
		.q:'$IsObject(SetObj)
		.s StandardTime=+(SetObj.ArgStandardTime)
		s StandHour=workDays*StandardTime
		
	}
	f date1=(stdate-1):1:enddate
	{
		s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",ward,date1,RowID)) q:RowID=""  d
		.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(RowID)
		.q:'$IsObject(obj)
		.q:obj.ArrangeDR.ArgStatus'="R"
		.;q:obj.ArgPostDR.PostDR.PostLevel'="一线班"
		.i obj.ArgPostDR.PostDR.PostLevel="一线班" d
		..s tmp(obj.ArgPerDR.%Id(),date1,RowID)=obj.ArgPostDR.%Id()_"^"_obj.ArgStTime1_"^"_obj.ArgEndTime1_"^"_obj.ArgStTime2_"^"_obj.ArgEndTime2_"^"_obj.ArgStTime3_"^"_obj.ArgEndTime3
		..i (obj.ArgPostDR.PostCategory="W")!(obj.ArgPostDR.PostCategory="N") s day(obj.ArgPerDR.%Id(),date1)=1
		.i obj.ArgPostDR.PostCategory="H" s holiday(obj.ArgPerDR.%Id(),date1)=1
		.//此处还需要从休假申请中提取休假的数据计算
	}
	s maxScore=0,nurse=""
	s perDr="" f  s perDr=$o(tmp(perDr)) q:perDr=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perDr)
	.q:'$IsObject(perObj)
	.q:((perObj.PerTypeDR'="N")&&(perObj.PerTypeDR'="A")&&(perObj.PerTypeDR'="T"))
	.s NurseName=perObj.PerName
	.s NurseLevel=$p(..GetNurseLevel(perDr,enddate),"^",1)
	.s levelFactor=$p(..GetNurseLevel(perDr,enddate),"^",2)
	.s NurseHire=..GetNurseHire(perDr,enddate)
	.s NurseWorkYear=""
	.i perObj.PerWorkDate'="" d
	..s year=##class(web.NurMgVueComm).CalAge($zd(perObj.PerWorkDate,3),$zd(+$h,3))
	..s NurseWorkYear=$p(year,"Y",1)
	.//上班天数		休假天数	上班时数 应上班时数（标准工时） 出勤系数（上班时数/标准工时）
	.s NurseWorkDay=0,NurseHoliday=0,NurseWorkHour=0,WorkFactor=0
	.//白班个数 P班个数	N班个数	卡班个数 上夜个数	下夜个数 班种系数  班种分数
	.s DayWork=0,PWork=0,NWork=0,KWork=0,FNight=0,SNight=0,PostFactor=0,PostScore=0,NurseScore=0
	.s NurseScore=0
	.//计算工作天数
	.s dayDate="" f  s dayDate=$o(day(perDr,dayDate)) q:dayDate=""  d
	..i dayDate>stdate s NurseWorkDay=NurseWorkDay+1
	.//计算休假天数 此处代码注释 【计算公式为全月的总天数-上班天数】
	.;s holidayDate="" f  s holidayDate=$o(holiday(perDr,holidayDate)) q:holidayDate=""  d
	..;i holidayDate>stdate s NurseHoliday=NurseHoliday+1
	.s NurseHoliday=(enddate-stdate)-NurseWorkDay+1
	.s postDate="" f  s postDate=$o(tmp(perDr,postDate)) q:postDate=""  d
	..s rw="" f  s rw=$o(tmp(perDr,postDate,rw)) q:rw=""  d
	...s list=tmp(perDr,postDate,rw)
	...s argPostDr=$p(list,"^",1)
	...s postStTime1=$p(list,"^",2)
	...s postEndTime1=$p(list,"^",3)
	...s postStTime2=$p(list,"^",4)
	...s postEndTime2=$p(list,"^",5)
	...s postStTime3=$p(list,"^",6)
	...s postEndTime3=$p(list,"^",7)
	...s argObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(argPostDr)
	...q:'$IsObject(argObj)
	...s NurseWorkHour=NurseWorkHour+..CalculationTime(stdate,enddate,postDate,postStTime1,postEndTime1)+..CalculationTime(stdate,enddate,postDate,postStTime2,postEndTime2)+..CalculationTime(stdate,enddate,postDate,postStTime3,postEndTime3)
	...//计算白班个数 根据班次维护中的类型计算
	...s PostScore=$fn(PostScore+(+(argObj.PostFactor)),"",2)
	...i argObj.PostCategory="W" d
	....i postDate>stdate s DayWork=DayWork+1
	...e  i argObj.PostCategory="N" d
	....i ((argObj.PostDesc["P")&&(postDate>=stdate)) s PWork=PWork+1
	....e  i ((argObj.PostDesc["N")&&(postDate>=stdate)) s NWork=NWork+1
	....e  i ((argObj.PostDesc["K")&&(postDate>=stdate)) s KWork=KWork+1
	....e  i ((argObj.PostDesc="上夜")&&(postDate>=stdate)) s FNight=FNight+1
	....e  i ((argObj.PostDesc="下夜")&&(postDate>=stdate)) s SNight=SNight+1
	.//计算出勤系数（上班时数/应上班时数）
	.s WorkFactor=$fn(NurseWorkHour/StandHour,"",2)
	.//计算个人分值（班种系数*层级系数）
	.s NurseScore=$fn(PostScore*levelFactor,"",2)
	.i NurseScore>maxScore s maxScore=NurseScore
	.s ret1="NurseName|"_NurseName_"^NurseLevel|"_NurseLevel_"^NurseHire|"_NurseHire_"^NurseWorkYear|"_NurseWorkYear_"^NurseWorkDay|"_NurseWorkDay_"^NurseHoliday|"_NurseHoliday_"^NurseWorkHour|"_NurseWorkHour_"^StandHour|"_StandHour_"^WorkFactor|"_WorkFactor
	.s ret1=ret1_"^DayWork|"_DayWork_"^PWork|"_PWork_"^NWork|"_NWork_"^KWork|"_KWork_"^FNight|"_FNight_"^SNight|"_SNight_"^PostScore|"_PostScore_"^LevelFactor|"_levelFactor_"^NurseScore|"_NurseScore
	.s nurse(perDr,NurseScore)=ret1
	s retRw="" f  s retRw=$o(nurse(retRw)) q:retRw=""  d
	.s score=0
	.s score1="" f  s score1=$o(nurse(retRw,score1)) q:score1=""  d
	..i maxScore'=0 d
	...s score=$fn(score1*(60/maxScore),"",2)
	..s ret=nurse(retRw,score1)_"^Score|"_score
	..do OutputNurseWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurseWork
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseWorkExecute ]
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

ClassMethod FindNurseWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-24
/// Description:根据日期获取护士层级及系数
/// 
ClassMethod GetNurseLevel(nurse As %String, date As %String) As %String
{
	s ^TMP("GetNurseLevel")=nurse_"%"_date
	q:((nurse="")!(date="")) ""
	s levelFactor=0,level=""
	s flag=0
	s stDate="" f  s stDate=$o(^DHCNMG.HR.MgLevelI("date",stDate),-1) q:(stDate=""!flag=1)  d
	.q:stDate>date
	.i stDate<=date d
	..
	..s rowId="" f  s rowId=$o(^DHCNMG.HR.MgLevelI("date",stDate,nurse,rowId),-1) q:(rowId=""!flag=1)  d
	...s obj=##class(DHCNMG.HR.MgLevel).%OpenId(rowId)
	...q:'$IsObject(obj)
	...q:obj.LevelStatus'="A"
	...//获取层级名称
	...s level=##class(web.NurMgPersonComm).GetCommCode(obj.NurLevel)
	...s levelFactor=obj.LevelFactor //获取层级系数
	...q:levelFactor=""
	...s flag=1
	q level_"^"_levelFactor
}

/// Creator:gzj
/// Date:2018-11-24
/// Description:根据日期获取护士职称
/// 
ClassMethod GetNurseHire(nurse As %String, date As %String) As %String
{
	q:((nurse="")!(date="")) ""
	s hire=""
	s flag=0
	s stDate="" f  s stDate=$o(^DHCNMG.HR.MgHireDutyI("date",stDate),-1) q:(stDate=""!flag=1)  d
	.q:stDate>date
	.i stDate<=date d
	..s rowId="" f  s rowId=$o(^DHCNMG.HR.MgHireDutyI("date",stDate,nurse,rowId),-1) q:(rowId=""!flag=1)  d
	...s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rowId)
	...q:'$IsObject(obj)
	...q:obj.HireStatus'="A"
	...//获取层级名称
	...s hire=##class(web.NurMgPersonComm).GetCommCode(obj.HireDuty)
	...s flag=1
	q hire
}

/// Creator:gzj
/// Date:2018-11-07
/// Description:计算时长
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod CalculationTime(stdate, enddate, postDate, stTime As %String, endTime As %String) As %String
{
	q:((stTime="")!(endTime="")) 0
	q:((endTime'["次日")&&($zth(stTime,2)>$zth(endTime,2))) 0
	//当日时长
	s daytime=0,protime=0,nexttime=0
	i postDate<stdate d
	.i endTime["次日" d
	..s protime=$zth($p(endTime,"日",2),2)-$zth("00:00",2)
	..s daytime=daytime+protime
	e  i ((postDate>=stdate)&&(postDate<enddate)) d
	.i endTime["次日" d
	..s first=$zth("23:59:59",2)-$zth(stTime,2)
	..//次日时长
	..s second=$zth($p(endTime,"日",2),2)-$zth("00:00",2)
	..s daytime=daytime+first+second
	.e  d
	..s daytime=daytime+$zth(endTime,2)-$zth(stTime,2)
	e  i postDate=enddate d
	.i endTime["次日" d
	..s nexttime=$zth("23:59:59",2)-$zth(stTime,2)
	..s daytime=daytime+nexttime
	.e  d
	..s daytime=daytime+$zth(endTime,2)-$zth(stTime,2)
	s daytime=$fn(daytime/3600,"",1)
	q daytime
}

/// Creator:gzj
/// Date:2018-11-07
/// Description:判断该天是否为假期
/// Table:
/// Input:
/// Output:
/// Return:1 为假期 0 不是假期
/// Other:
ClassMethod GetHolidayFlag(date As %String) As %String
{
	q:date="" 0
	s year=$p(date,"-",1)
	s flag=0
	s HolidayID="" f  s HolidayID=$o(^DHCNMG.DB.MgHolidaySetI("code",year,HolidayID)) q:HolidayID=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgHolidaySetI("code",year,HolidayID,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(RowID)
	..q:'$IsObject(obj)
	..q:($IsObject(obj.HolidayID)&&(obj.HolidayID.SubDesc="班"))
	..s holidayDate=obj.HolidayDate
	..s stDate=$zdh($p(holidayDate,",",1),3)
	..s endDate=$zdh($p(holidayDate,",",2),3)
	..i ($zdh(date,3)>=stDate)&&($zdh(date,3)<=endDate) s flag=1
	..
	q flag
}

/// Creator:gzj
/// Date:2018-11-07
/// Description:判断该天是否为正常班
/// Table:
/// Input:
/// Output:
/// Return: 1 为班 0 不是班
/// Other:
ClassMethod GetWorkdayFlag(date As %String) As %String
{
	q:date="" 0
	s year=$p(date,"-",1)
	s flag=0
	s HolidayID="" f  s HolidayID=$o(^DHCNMG.DB.MgHolidaySetI("code",year,HolidayID)) q:HolidayID=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgHolidaySetI("code",year,HolidayID,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(RowID)
	..q:'$IsObject(obj)
	..q:($IsObject(obj.HolidayID)&&(obj.HolidayID.SubDesc'="班"))
	..s holidayDate=obj.HolidayDate
	..s stDate=$zdh($p(holidayDate,",",1),3)
	..s endDate=$zdh($p(holidayDate,",",2),3)
	..i ($zdh(date,3)>=stDate)&&($zdh(date,3)<=endDate) s flag=1
	q flag
}

/// Creator:gzj
/// Description:夜班费统计
/// Date:2019-2-2
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.MgNurArgStaticComm","FindNightFee","","2019-02")
Query FindNightFee(ward As %String, month As %String, role As %String, nurseId As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNightFeeExecute(ByRef qHandle As %Binary, ward As %String, month As %String, role As %String, nurseId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindNightFee")=ward_"%"_month_"%"_role_"%"_nurseId
	s stDate=$zdh((month_"-01"),3)
	s year=$p(month,"-",1)
	s mon=$p(month,"-",2)
	i mon<12 s mon=mon+1
	e  s mon=1,year=year+1
	
	s endDate=$zdh(year_"-"_mon_"-01",3)-1
	
	s tmp=""
	s Ward="" f  s Ward=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",Ward)) q:Ward=""  d
	.s PCount=0,NCount=0,KCount=0,LNCount=0,RNCount=0,ANCount=0,Subtotal=0 //P班个数  N班个数 K班个数 上夜个数 下夜个数 全夜个数 小计
	.s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",Ward,date)) q:date=""  d
	..q:((date<stDate)!(date>endDate))
	..s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",Ward,date,RowID)) q:RowID=""  d
	...s ArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(RowID)
	...q:'$IsObject(ArgObj)
	...q:ArgObj.ArrangeDR.ArgStatus'="R" //如果没有提交排班则不计算
	...//获取当天该护士的类型
	...s TypeStore=##class(web.NurMgArgComm).GetNurseLevel(date,ArgObj.ArgPerDR.%Id())
	...s PerType=$p(TypeStore,"^",4) //获取人员类型
	...q:((PerType="P")!(PerType="S"))
	...s PostType=""
	...i ArgObj.ArgPostDR.PostDR.PostDesc["P" s PostType="P"
	...e  i ArgObj.ArgPostDR.PostDR.PostDesc["N" s PostType="N"
	...e  i ArgObj.ArgPostDR.PostDR.PostDesc["K" s PostType="K"
	...e  i ArgObj.ArgPostDR.PostDR.PostDesc["上夜" s PostType="LN"
	...e  i ArgObj.ArgPostDR.PostDR.PostDesc["下夜" s PostType="RN"
	...e  i ArgObj.ArgPostDR.PostDR.PostDesc["全夜" s PostType="AN"
	...q:(PostType'="P")&&(PostType'="N")&&(PostType'="K")&&(PostType'="LN")&&(PostType'="RN")&&(PostType'="AN")
	...//根据病区 人员类型 岗位类型 获取夜班单价
	...s NightFactor=..GetSysNightFactor(Ward,PerType,PostType)
	...s NightPrice=$p(NightFactor,"^",2) //夜班单价
	...i PostType="P" s PCount=PCount+1,Subtotal=Subtotal+NightPrice
	...e  i PostType="N" s NCount=NCount+1,Subtotal=Subtotal+NightPrice
	...e  i PostType="K" s KCount=KCount+1,Subtotal=Subtotal+NightPrice
	...e  i PostType="LN" s LNCount=LNCount+1,Subtotal=Subtotal+NightPrice
	...e  i PostType="RN" s RNCount=RNCount+1,Subtotal=Subtotal+NightPrice
	...e  i PostType="AN" s ANCount=ANCount+1,Subtotal=Subtotal+NightPrice
	...s tmp(Ward)=PCount_"^"_NCount_"^"_KCount_"^"_LNCount_"^"_RNCount_"^"_ANCount_"^"_Subtotal
	
	s ret=""
	s TmpWard="" f  s TmpWard=$o(tmp(TmpWard)) q:TmpWard=""  d
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(TmpWard)
	.q:'$IsObject(WardObj)
	.s flag=..IsRoleWard(role,nurseId,TmpWard)
	.q:flag=0
	.q:((ward'="")&&(TmpWard'=ward))
	.s WardDesc=WardObj.WardDesc
	.s PCount=$p(tmp(TmpWard),"^",1)
	.s NCount=$p(tmp(TmpWard),"^",2)
	.s KCount=$p(tmp(TmpWard),"^",3)
	.s LNCount=$p(tmp(TmpWard),"^",4)
	.s RNCount=$p(tmp(TmpWard),"^",5)
	.s ANCount=$p(tmp(TmpWard),"^",6)
	.s Subtotal=$p(tmp(TmpWard),"^",7)
	.s ret="WardCode|"_TmpWard_"^WardDesc|"_WardDesc_"^PCount|"_PCount_"^NCount|"_NCount_"^KCount|"_KCount_"^LNCount|"_LNCount_"^RNCount|"_RNCount_"^ANCount|"_ANCount_"^Subtotal|"_Subtotal_"^Month|"_month
	.
	.do OutputNightFee
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

/// Creator:gzj
/// CreateDate:2019-02-23
/// Description:判断角色下护士是否所辖病区
/// Table:
/// Input:
/// Output:
/// Return:
/// Others:
ClassMethod IsRoleWard(roles As %String, nurseId As %String, ward As %String) As %String
{
	s ^TMP("IsRoleWard")=roles_"%"_nurseId_"%"_ward
	q:((roles="")!(nurseId="")!(ward="")) 0
	q:roles=0 1
	s flag=0
	b ;01
	f i=1:1:$l(roles,"^")
	{
		s role=$p(roles,"^",i)
		i role="" continue
		b ;02
		s par=$o(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurseId,""))
		b ;04
		i par="" continue
		b ;03
		s rw="" f  s rw=$o(^DHCNMG.DB.MgDataLimitSubD(par,rw)) q:rw=""  d
		.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(obj)
		.s SubWard=obj.SubWard
		.i SubWard=ward s flag=1
		
	}
	q flag
}

/// Creator:gzj
/// CreateDate:2019-02-19
/// Description:获取系统的夜班费用及夜班系数（有单病区的标准）
/// Table:
/// Input:
/// Output:
/// Return:系数^单价
ClassMethod GetSysNightFactor(ward As %String = "", type As %String, post As %String) As %String
{
	s ^TMP("GetSysNightFactor")=ward_"%"_type_"%"_post
	s factor=0.00,price=0.00
	i $g(^DHCNMG.Set.MgNightFeeFactorI("flag"," "_type," "_ward," "_post))'="" d
	.s rw=$o(^DHCNMG.Set.MgNightFeeFactorI("flag"," "_type," "_ward," "_post,""))
	.s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(rw)
	.q:'$IsObject(obj)
	.s factor=$fn(obj.Factor,"",2)
	.s price=$fn(obj.Price,"",2)
	e  d 
	.s rw=$o(^DHCNMG.Set.MgNightFeeFactorI("flag"," "_type," "," "_post,""))
	.s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(rw)
	.q:'$IsObject(obj)
	.s factor=$fn(obj.Factor,"",2)
	.s price=$fn(obj.Price,"",2)
	q factor_"^"_price
}

/// Creator:gzj
/// CreateDate:2019-02-25
/// Description:获取夜班费用明细
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
Query FindNightDetail(ward As %String, month As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNightDetailExecute(ByRef qHandle As %Binary, ward As %String, month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindNightDetail")=ward_"%"_month
	s stDate=$zdh((month_"-01"),3)
	s year=$p(month,"-",1)
	s mon=$p(month,"-",2)
	i mon<12 s mon=mon+1
	e  s mon=1,year=year+1
	
	s endDate=$zdh(year_"-"_mon_"-01",3)-1
	s tmp=""
	
	s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",ward,date)) q:date=""  d
	.q:((date<stDate)!(date>endDate))
	.s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",ward,date,RowID)) q:RowID=""  d
	..s ArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(RowID)
	..q:'$IsObject(ArgObj)
	..q:ArgObj.ArrangeDR.ArgStatus'="R" //如果没有提交排班则不计算
	..s TypeStore=##class(web.NurMgArgComm).GetNurseLevel(ArgObj.ArgDate,ArgObj.ArgPerDR.%Id())
	..s PerType=$p(TypeStore,"^",4) //获取人员类型
	..q:((PerType="P")!(PerType="S")) //获取人员类型
	..q:((PerType="P")!(PerType="S"))
	..q:'$IsObject(ArgObj.ArgPostDR)
	..s tmp(ward,ArgObj.ArgPerDR.%Id(),ArgObj.ArgPostDR.%Id(),RowID)=1
	
	s TmpWard="" f  s TmpWard=$o(tmp(TmpWard)) q:TmpWard=""  d
	.s TmpNur="" f  s TmpNur=$o(tmp(TmpWard,TmpNur)) q:TmpNur=""  d
	..s PCount=0,NCount=0,KCount=0,LNCount=0,RNCount=0,ANCount=0,Subtotal=0 //P班个数  N班个数 K班个数 上夜个数 下夜个数 全夜个数 小计
	..s TmpPost="" f  s TmpPost=$o(tmp(TmpWard,TmpNur,TmpPost)) q:TmpPost=""  d
	...s TmpID="" f  s TmpID=$o(tmp(TmpWard,TmpNur,TmpPost,TmpID)) q:TmpID=""  d
	....s TmpArgObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(TmpID)
	....q:'$IsObject(TmpArgObj)
	....//获取当天该护士的类型
	....s TypeStore=##class(web.NurMgArgComm).GetNurseLevel(TmpArgObj.ArgDate,TmpArgObj.ArgPerDR.%Id())
	....s PerType=$p(TypeStore,"^",4) //获取人员类型
	....s PostType=""
	....i TmpArgObj.ArgPostDR.PostDR.PostDesc["P" s PostType="P"
	....e  i TmpArgObj.ArgPostDR.PostDR.PostDesc["N" s PostType="N"
	....e  i TmpArgObj.ArgPostDR.PostDR.PostDesc["K" s PostType="K"
	....e  i TmpArgObj.ArgPostDR.PostDR.PostDesc["上夜" s PostType="LN"
	....e  i TmpArgObj.ArgPostDR.PostDR.PostDesc["下夜" s PostType="RN"
	....e  i TmpArgObj.ArgPostDR.PostDR.PostDesc["全夜" s PostType="AN"
	....q:((PostType'="P")&&(PostType'="N")&&(PostType'="K")&&(PostType'="LN")&&(PostType'="RN")&&(PostType'="AN"))
	....//根据病区 人员类型 岗位类型 获取夜班单价
	....s NightFactor=..GetSysNightFactor(TmpWard,PerType,PostType)
	....s NightPrice=$p(NightFactor,"^",2) //夜班单价
	....i PostType="P" s PCount=PCount+1,Subtotal=Subtotal+NightPrice
	....e  i PostType="N" s NCount=NCount+1,Subtotal=Subtotal+NightPrice
	....e  i PostType="K" s KCount=KCount+1,Subtotal=Subtotal+NightPrice
	....e  i PostType="LN" s LNCount=LNCount+1,Subtotal=Subtotal+NightPrice
	....e  i PostType="RN" s RNCount=RNCount+1,Subtotal=Subtotal+NightPrice
	....e  i PostType="AN" s ANCount=ANCount+1,Subtotal=Subtotal+NightPrice
	..s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(TmpNur)
	..q:'$IsObject(PerObj)
	..s NurseName=PerObj.PerName
	..s NurseHire=..GetNurseHighHire(TmpNur)
	..s ret="PCount|"_PCount_"^NCount|"_NCount_"^KCount|"_KCount_"^LNCount|"_LNCount_"^RNCount|"_RNCount_"^ANCount|"_ANCount_"^Subtotal|"_Subtotal_"^PerID|"_TmpNur_"^PerName|"_NurseName_"^NurseHire|"_NurseHire
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

/// Creator:gzj
/// CreateDate:2019-02-28
/// Description:获取护士最高职称
/// Table:
/// Input:
/// Output:
/// Other:
/// Return:
ClassMethod GetNurseHighHire(nurse As %String) As %String
{
	q:nurse="" ""
	s ret=""
	s flag=0
	s date="" f  s date=$o(^DHCNMG.HR.MgHireDutyI("HireDate",nurse,date),-1) q:((date="")!(flag=1))  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgHireDutyI("HireDate",nurse,date,RowID),-1) q:((RowID="")!(flag=1))  d
	..s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s ret=##class(web.NurMgPersonComm).GetCommCode(obj.HireDuty)
	q ret
}

/// Creator:gzj
/// Date:2019-05-08
/// Description:根据病区获取班次岗位列属性【包钢需求】
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod GetWardPostColumn(ward As %String) As %String
{
	q:ward="" "[]"
	w "["
	s n=1
	s sort="" f  s sort=$o(^DHCNMG.DB.MgArgWardPostI("WardSort",ward,sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgArgWardPostI("WardSort",ward,sort,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(RowID)
	..q:'$IsObject(obj)
	..q:obj.PostDR.PostLevel'="一线班"
	..s PostDesc=obj.PostDR.PostDesc
	..s PostCode="Post"_obj.PostDR.%Id()
	..s PostID=obj.PostDR.%Id()
	..i n=1 w "{""PostDesc"":"""_PostDesc_""",""PostCode"":"""_PostCode_""",""PostID"":"""_PostID_"""}"
	..e  w ",{""PostDesc"":"""_PostDesc_""",""PostCode"":"""_PostCode_""",""PostID"":"""_PostID_"""}"
	..s n=n+1
	w "]"
	q ""
}

/// Creator:gzj
/// Date:2019-05-17
/// Description:获取班次工作量列属性，取班次分类信息 夜和24小时班不计入统计范围【包钢需求】
/// 
ClassMethod GetPostTypeColumn() As %String
{
	w "["
	
	s Par=$o(^DHCNMG.Set.MgSysParamI("Code"," POSTTYPE",""))
	i Par'=""
	{
		s n=1
		s sort="" f  s sort=$o(^DHCNMG.Set.MgSysParamSubI("Sort",Par,sort)) q:sort=""  d
		.s rw="" f  s rw=$o(^DHCNMG.Set.MgSysParamSubI("Sort",Par,sort,rw)) q:rw=""  d
		..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(Par_"||"_rw)
		..q:'$IsObject(obj)
		..q:((obj.SubCode="N")!(obj.SubCode="24")!(obj.SubCode="H"))
		..s code=obj.SubCode
		..s desc=obj.SubDesc
		..i n=1 w "{""prop"":"""_"Post"_code_""",""label"":"""_desc_"""}"
		..e  w ",{""prop"":"""_"Post"_code_""",""label"":"""_desc_"""}"
		..s n=n+1
	}
	w "]"
	q ""
}

/// Creator:
/// Description:查询护士个人班次统计(包钢医院班次工作量统计)
/// Date:2018-11-06
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.MgNurArgStaticComm","FindWorkScore","109","2018-12-01^2019-01-18")
Query FindWorkScore(ward As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWorkScoreExecute(ByRef qHandle As %Binary, ward As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindWorkScore")=ward_"^"_parr //109^2018-12-01^2019-02-28
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret="",ret1=""
	s tmp="",day="",holiday=""
	s stdate=$zdh($p(parr,"^",1),3)
	s enddate=$zdh($p(parr,"^",2),3)
	s StandHour=0,workDays=0
	f date=stdate:1:enddate
	{
		//6!0(周六或周日)判断周六日
		s weekDay=$zd(date,10)
		i ((weekDay=0)!(weekDay=6)) d //该天为周日或者六
		.//判断是否为“班” 1 班 0 不是班
		.s workflag=..GetWorkdayFlag($zd(date,3))
		.i workflag=1 d //为班
		..s workDays=workDays+1
		e  d
		.s holidayFlag=..GetHolidayFlag($zd(date,3))
		.i holidayFlag=0 d //该不是假期
		..s workDays=workDays+1
		s StandardTime=0
		s setRow=$O(^DHCNMG.Set.MgArgParamSetD(""))
		i setRow'="" d
		.s SetObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(setRow)
		.q:'$IsObject(SetObj)
		.s StandardTime=+(SetObj.ArgStandardTime)
		s StandHour=workDays*StandardTime
		
	}
	f date1=(stdate-1):1:enddate
	{
		s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArrangeSubI("WardDate",ward,date1,RowID)) q:RowID=""  d
		.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(RowID)
		.q:'$IsObject(obj)
		.q:obj.ArrangeDR.ArgStatus'="R"
		.;q:obj.ArgPostDR.PostDR.PostLevel'="一线班"
		.i obj.ArgPostDR.PostDR.PostLevel="一线班" d
		..s tmp(obj.ArgPerDR.%Id(),date1,RowID)=obj.ArgPostDR.%Id()_"^"_obj.ArgStTime1_"^"_obj.ArgEndTime1_"^"_obj.ArgStTime2_"^"_obj.ArgEndTime2_"^"_obj.ArgStTime3_"^"_obj.ArgEndTime3
		..i (obj.ArgPostDR.PostCategory="W")!(obj.ArgPostDR.PostCategory="N") s day(obj.ArgPerDR.%Id(),date1)=1
		.i obj.ArgPostDR.PostCategory="H" s holiday(obj.ArgPerDR.%Id(),date1)=1
		.//此处还需要从休假申请中提取休假的数据计算
	}
	s maxScore=0,nurse=""
	s perDr="" f  s perDr=$o(tmp(perDr)) q:perDr=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perDr)
	.q:'$IsObject(perObj)
	.q:((perObj.PerTypeDR'="N")&&(perObj.PerTypeDR'="A")&&(perObj.PerTypeDR'="T"))
	.s NurseName=perObj.PerName
	.s NurseLevel=$p(..GetNurseLevel(perDr,enddate),"^",1)
	.s levelFactor=$p(..GetNurseLevel(perDr,enddate),"^",2)
	.s NurseHire=..GetNurseHire(perDr,enddate)
	.s NurseWorkYear=""
	.i perObj.PerWorkDate'="" d
	..s year=##class(web.NurMgVueComm).CalAge($zd(perObj.PerWorkDate,3),$zd(+$h,3))
	..s NurseWorkYear=$p(year,"Y",1)
	.//上班天数		休假天数	上班时数 应上班时数（标准工时） 出勤系数（上班时数/标准工时）
	.s NurseWorkDay=0,NurseHoliday=0,NurseWorkHour=0,WorkFactor=0
	.//白班个数 P班个数	N班个数	卡班个数 上夜个数	下夜个数 班种系数  班种分数
	.s DayWork=0,PWork=0,NWork=0,KWork=0,FNight=0,SNight=0,PostFactor=0,PostScore=0,NurseScore=0
	.s PostW=0,PostL=0,PostS=0,PostE=0,PostT=0,PostX=0,PostD=0
	.s NurseScore=0
	.//计算工作天数
	.s dayDate="" f  s dayDate=$o(day(perDr,dayDate)) q:dayDate=""  d
	..i dayDate>stdate s NurseWorkDay=NurseWorkDay+1
	.//计算休假天数 此处代码注释 【计算公式为全月的总天数-上班天数】
	.;s holidayDate="" f  s holidayDate=$o(holiday(perDr,holidayDate)) q:holidayDate=""  d
	..;i holidayDate>stdate s NurseHoliday=NurseHoliday+1
	.s NurseHoliday=(enddate-stdate)-NurseWorkDay+1
	.s postDate="" f  s postDate=$o(tmp(perDr,postDate)) q:postDate=""  d
	..s rw="" f  s rw=$o(tmp(perDr,postDate,rw)) q:rw=""  d
	...s list=tmp(perDr,postDate,rw)
	...s argPostDr=$p(list,"^",1)
	...s postStTime1=$p(list,"^",2)
	...s postEndTime1=$p(list,"^",3)
	...s postStTime2=$p(list,"^",4)
	...s postEndTime2=$p(list,"^",5)
	...s postStTime3=$p(list,"^",6)
	...s postEndTime3=$p(list,"^",7)
	...s argObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(argPostDr)
	...q:'$IsObject(argObj)
	...s NurseWorkHour=NurseWorkHour+..CalculationTime(stdate,enddate,postDate,postStTime1,postEndTime1)+..CalculationTime(stdate,enddate,postDate,postStTime2,postEndTime2)+..CalculationTime(stdate,enddate,postDate,postStTime3,postEndTime3)
	...//计算白班个数 根据班次维护中的类型计算
	...s PostScore=$fn(PostScore+(+(argObj.PostFactor)),"",2)
	...i argObj.PostCategory="W" d
	....i postDate>stdate s DayWork=DayWork+1
	...e  i argObj.PostCategory="N" d
	....i ((argObj.PostDesc["P")&&(postDate>=stdate)) s PWork=PWork+1
	....e  i ((argObj.PostDesc["N")&&(postDate>=stdate)) s NWork=NWork+1
	....e  i ((argObj.PostDesc["K")&&(postDate>=stdate)) s KWork=KWork+1
	....e  i ((argObj.PostDesc="上夜")&&(postDate>=stdate)) s FNight=FNight+1
	....e  i ((argObj.PostDesc="下夜")&&(postDate>=stdate)) s SNight=SNight+1
	...i argObj.PostCategory="W" s PostW=PostW+1
	...e  i argObj.PostCategory="L" s PostL=PostL+1
	...e  i argObj.PostCategory="S" s PostS=PostS+1
	...e  i argObj.PostCategory="E" s PostE=PostE+1
	...e  i argObj.PostCategory="T" s PostT=PostT+1
	...e  i argObj.PostCategory="X" s PostX=PostX+1
	...e  i argObj.PostCategory="D" s PostD=PostD+1
	.//计算出勤系数（上班时数/应上班时数）
	.s WorkFactor=$fn(NurseWorkHour/StandHour,"",2)
	.//计算个人分值（班种系数*层级系数）
	.s NurseScore=$fn(PostScore*levelFactor,"",2)
	.i NurseScore>maxScore s maxScore=NurseScore
	.s ret1="NurseName|"_NurseName_"^NurseLevel|"_NurseLevel_"^NurseHire|"_NurseHire_"^NurseWorkYear|"_NurseWorkYear_"^NurseWorkDay|"_NurseWorkDay_"^NurseHoliday|"_NurseHoliday_"^NurseWorkHour|"_NurseWorkHour_"^StandHour|"_StandHour_"^WorkFactor|"_WorkFactor
	.s ret1=ret1_"^DayWork|"_DayWork_"^PWork|"_PWork_"^NWork|"_NWork_"^KWork|"_KWork_"^FNight|"_FNight_"^SNight|"_SNight_"^PostScore|"_PostScore_"^LevelFactor|"_levelFactor_"^NurseScore|"_NurseScore
	.s ret1=ret1_"^PostW|"_PostW_"^PostL|"_PostL_"^PostS|"_PostS_"^PostE|"_PostE_"^PostT|"_PostT_"^PostX|"_PostX_"^PostD|"_PostD
	.s nurse(perDr,NurseScore)=ret1
	s retRw="" f  s retRw=$o(nurse(retRw)) q:retRw=""  d
	.s score=0
	.s score1="" f  s score1=$o(nurse(retRw,score1)) q:score1=""  d
	..i maxScore'=0 d
	...s score=$fn(score1*(60/maxScore),"",2)
	..s ret=nurse(retRw,score1)_"^Score|"_score
	..do OutputNurseWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurseWork
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkScoreExecute ]
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

ClassMethod FindWorkScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
