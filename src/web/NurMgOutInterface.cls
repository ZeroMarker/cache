/// Description:护管对外接口类
/// Date:2018-04-11
/// Creator:gzj
Class web.NurMgOutInterface Extends %RegisteredObject
{

/// Description:提取患者信息接口【微信满意度】
/// Date:
/// Creator:
/// Table:
/// Input:患者登记号
/// Output:[{"adm":"0000000042","patname":"张三","patsex":"男","child":[{"locid":"00001","locdesc":"产科","wardid":"000011","warddesc":"产科一区","bed":"0100","respnurse":"冯红|id","officenurse":"周艳|id^马倩|id","mednurse":"周倩|id","treatnurse":"张倩|id","headnurse":"刘艳|id"},{"locid":"00001","locdesc":"产科","wardid":"000012","warddesc":"产科二区","bed":"0200","respnurse":"冯红|id","officenurse":"周艳|id","mednurse":"周倩|id","treatnurse":"张倩|id","headnurse":"刘艳|id"}]}]
/// Other:w ##class(web.NurMgOutInterface).GetPatientMessage("0000000042")
ClassMethod GetPatientMessage(PAPMIDR As %String) As %String
{
	s ret=""
	s PAPMIROWID=$O(^PAPERi("PAPMI_PatNo",PAPMIDR,""))
	q:PAPMIROWID="" ""
	s adm="",patname="",patsex="",child="[{}]"
	s PAADMRW="" f  s PAADMRW=$O(^PAPERdr(PAPMIROWID,"ADM","I",PAADMRW)) q:PAADMRW=""  d
	.q:$P(^PAADM(PAADMRW),"^",20)'="A" //不是在院状态的去掉
	.s adm=PAADMRW //就诊号
	.s patname=$P(^PAPER(PAPMIROWID,"ALL"),"^",1) //姓名
	.s patsex=$P(^PAPER(PAPMIROWID,"ALL"),"^",7) //性别
	.s ret="""adm"":"""_adm_""",""patname"":"""_patname_""",""patsex"":"""_patsex_""""
	.//取到患者的就诊ID
	.//根据就诊ID 循环获取患者本次住院期间的转科转床信息
	.s TransRowID=0 f  s TransRowID=$O(^PAADM(adm,"TRANS",TransRowID)) q:TransRowID=""  d
	..s BedDR=$P(^PAADM(adm,"TRANS",TransRowID),"^",8)
	..q:BedDR=""
	.s LocCodeDR=$P(^PAADM(PAADMRW),"^",4) //病人当前的住院科室
	.s child=..GetPatLoc(adm)
	.s child="[{"_child_"}]"
	s ret="""adm"":"""_adm_""",""patname"":"""_patname_""",""patsex"":"""_patsex_""",""child"":"_child
	s ret="[{"_ret_"}]"
	q ret
}

/// w ##class(web.NurMgOutInterface).GetPatLoc(1593804)
ClassMethod GetPatLoc(adm)
{
	s ret=""
	s TransRowID=0 f  s TransRowID=$O(^PAADM(adm,"TRANS",TransRowID)) q:TransRowID=""  d
	.s BedDR=$P(^PAADM(adm,"TRANS",TransRowID),"^",8) //床号
	.q:BedDR=""
	.s LocId=$P(^PAADM(adm,"TRANS",TransRowID),"^",6) //科室（ctloc）
	.q:LocId=""
	.s LocDesc=$P($P(^CTLOC(LocId),"^",2),"-",2) //科室描述
	.s WardId=$p(^PAADM(adm,"TRANS",TransRowID),"^",9) //病区（pacward）
	.//将pacward转换成护理管理的病区id 首先转换成ctlocid
	.s ctlocrw=$P(^PAWARD(WardId),"^",5) //ctlocrowid
	.s DBWardId=$p(..ConvertDBWard(ctlocrw),"^",1)
	.s DBWardDesc=$p(..ConvertDBWard(ctlocrw),"^",2)
	.s StDate=$p(^PAADM(adm,"TRANS",TransRowID),"^",1) //开始日期
	.s StTime=$P(^PAADM(adm,"TRANS",TransRowID),"^",2)  // 开始时间
	.s EndDate=$P(^PAADM(adm,"TRANS",TransRowID),"^",3) //结束日期
	.s EndTime=$P(^PAADM(adm,"TRANS",TransRowID),"^",4) //结束时间
	.s ret1=..GetPatTypeNurse(BedDR,DBWardId,StDate,StTime,EndDate,EndTime)
	.s ret="""locid"":"""_LocId_""",""locdesc"":"""_LocDesc_""",""wardid"":"""_DBWardId_""",""warddesc"":"""_DBWardDesc_""",""bed"":"""_BedDR_""","_ret1
	q ret
}

ClassMethod ConvertDBLoc(LocId)
{
}

/// 转换成护理管理的病区形式
ClassMethod ConvertDBWard(ctlocid)
{
	s ret=""
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgWardI("Spell",spell,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rw)
	..q:obj.CTLocDR=""
	..q:(obj.CTLocDR.%Id()'=ctlocid)
	..s ret=rw_"^"_obj.WardDesc
	q ret
}

ClassMethod GetPatTypeNurse(bedid, wardid, stdate, sttime, enddate, endtime)
{
	s ret=""
	//责护，办公室护士，换药室护士，治疗室护士，护士长
	s respnurse="",officenurse="",mednurse="",treatnurse="",headnurse=""
	q:wardid="" ""
	s EndDate="" f  s EndDate=$O(^DHCNMG.Arg.MgArrangeI("WardEndDate",wardid,EndDate)) q:EndDate=""  d
	.s ArgRowID="" f  s ArgRowID=$O(^DHCNMG.Arg.MgArrangeI("WardEndDate",wardid,EndDate,ArgRowID)) q:ArgRowID=""  d
	..q:(stdate>EndDate)
	..s ArgObj=##class(DHCNMG.Arg.MgArrange).%OpenId(ArgRowID)
	..q:((ArgObj.ArgStDate'="")&&(stdate<ArgObj.ArgStDate))
	..;q:ArgObj.ArgStatus'="R"
	..//Index Arrange On (ArrangeDR, ArgRowDR, ArgDate);
	..s RowDR="" f  s RowDR=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",ArgRowID,RowDR)) q:RowDR=""  d //获取到行记录
	...s RowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(RowDR) //打开行记录
	...i RowObj.ArgGroupDR'="" d //组不为空 可以获取床号list
	....s GroupID=RowObj.ArgGroupDR.%Id() //从行记录中获取组id
	....s BedList=RowObj.ArgGroupDR.GroupResBeds
	....s len=BedList.Count()
	....f i=1:1:len d
	.....s itm=BedList.GetAt(i)
	.....i itm'="" d
	......q:itm'=bedid
	......i RowObj.ArgPerCode'="" d
	.......s CodeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(RowObj.ArgPerCode)
	.......i CodeObj.SubDesc="责任护士" d
	........i respnurse="" s respnurse=..GetNurseName(RowObj.ArgPerDR.%Id())
	........e  s respnurse=respnurse_"^"_..GetNurseName(RowObj.ArgPerDR.%Id())
	.......e  i CodeObj.SubDesc="办公室护士" d
	........i officenurse="" s officenurse=..GetNurseName(RowObj.ArgPerDR.%Id())
	........e  s officenurse=officenurse_"^"_..GetNurseName(RowObj.ArgPerDR.%Id())
	.......e  i CodeObj.SubDesc="换药室护士" d
	........i mednurse="" s mednurse=..GetNurseName(RowObj.ArgPerDR.%Id())
	........e  s mednurse=mednurse_"^"_..GetNurseName(RowObj.ArgPerDR.%Id())
	.......e  i CodeObj.SubDesc="治疗室护士" d
	........i treatnurse="" s treatnurse=..GetNurseName(RowObj.ArgPerDR.%Id())
	........e  s treatnurse=treatnurse_"^"_..GetNurseName(RowObj.ArgPerDR.%Id())
	//获取科室护士长
	s headnurse=..GetNurseHead(wardid)
	s ret="""respnurse"":"""_respnurse_""",""officenurse"":"""_officenurse_""",""mednurse"":"""_mednurse_""",""treatnurse"":"""_treatnurse_""",""headnurse"":"""_headnurse_""""
	q ret
}

ClassMethod GetNurseHead(wardid)
{
	s nursename=""
	s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,RowID)) q:RowID=""  d
	.s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.s PostRow="" f  s PostRow=$O(^DHCNMG.HR.MgPostDutyI("ssid",RowID,PostRow)) q:PostRow=""  d
	..s PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostRow)
	..i PostObj.PostDuty'="" d
	...s CodeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(PostObj.PostDuty)
	...q:'$IsObject(CodeObj)
	...i CodeObj.SubDesc="护士长" d
	....i nursename="" s nursename=PerObj.PerName_"|"_RowID
	....e  s nursename=nursename_"^"_PerObj.PerName_"|"_RowID
	q nursename
}

ClassMethod GetNurseName(rowid)
{
	q:rowid="" ""
	s nursename=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:'$IsObject(obj) ""
	s nursename=obj.PerName_"|"_rowid
	q nursename
}

/// Description:接收护士满意度信息
/// Date:2018-04-19
/// Creator:
/// Table:DHCNMG.Work.MgNurSatisfy
/// Input:患者就诊号(adm) 满意度信息(infos)【年月(201804)~护士id|满意度信息^护士id|满意度信息】
/// Output: 0 成功 
/// Other:
ClassMethod GetNurseSatiInfo(adm, infos)
{
	//Index Date On(WorkAdm,WorkMonth,WorkNurse);
	
	q:adm="" ""
	s month=$O(^DHCNMG.Work.MgNurSatisfyI("Date"," "_adm,""))
	q:month'="" "已经填写过了！"
	s ret=0
	s info=$P(infos,"~",2)
	s len=$L(info,"^")
	for i=1:1:len
	{
		s itm=$P(info,"^",i)
		i itm="" continue
		s nurse=$P(itm,"|",1)
		s satify=$P(itm,"|",2)
		s obj=##class(DHCNMG.Work.MgNurSatisfy).%New()
		s obj.WorkAdm=adm
		s obj.WorkMonth=$P(infos,"~",1)
		s obj.WorkNurse=nurse
		s obj.WorkSatify=satify
		s ret=obj.%Save()
	}
	if $$$ISOK(ret)
	{
		q 0
	}
	else
	{
		q "保存失败"
	}
}

/// Description:按月获取护士工作量
/// Date:2018-04-19
/// Creator:
/// Table:
/// Input:护士工号【1437】 月份【201804】
/// Output: 白班数、夜班数、白班一级护理人数、白班特级护理人数、夜班一级护理人数、夜班特级护理人数
/// Other:w ##class(web.NurMgOutInterface).GetNurseWorkLoad(1272,201805)
ClassMethod GetNurseWorkLoad(nurseno, month)
{
	q:nurseno="" "工号不能为空"
	s RowID=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(nurseno," ",""),"U"),""))
	q:RowID="" "此护理人员不存在"
	s stdate=$zdh(month_"01",8) //月份的第一天
	s enddate=stdate+##class(web.NurMgVueComm).GetMonthDay($zd(stdate,3))-1 //月份最后一天
	s dayWork=0,dayZoneNum=0,dayOneNum=0,dayTwoNum=0
	s nightWork=0,nightZoneNum=0,nightOneNum=0,nightTwoNum=0
	s nowDate=+$h
	s argid="" f  s argid=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid)) q:argid=""  d
	.s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	.q:'$IsObject(argObj)
	.q:(argObj.ArgStatus'="R")&&(argObj.ArgStatus'="A")
	.s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid)) q:rowid=""  d
	..s date="" f  s date=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	...q:(stdate'="")&&(stdate>date)
	...q:(enddate'="")&&(enddate<date)
	...q:date>=nowDate
	...s rowobj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	...q:'$IsObject(rowobj)
	...q:'$IsObject(rowobj.ArgPerDR)
	...q:(RowID'=rowobj.ArgPerDR.%Id())
	...s perdr=rowobj.ArgPerDR.%Id()
	...s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:subid=""  d
	....s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(obj)
	....q:'$IsObject(obj.ArgWardDR)
	....;q:((ward'="")&&(ward'=obj.ArgWardDR.%Id()))
	....s subRet=##class(web.NurMgArgCount).getPostCount(subid)
	....i subRet'="" d
	.....s dayWork=dayWork+$p(subRet,"^",9)
	.....s dayZoneNum=dayZoneNum+$p(subRet,"^",10)
	.....s dayOneNum=dayOneNum+$p(subRet,"^",11)
	.....s dayTwoNum=dayTwoNum+$p(subRet,"^",12)
	.....s nightWork=nightWork+$p(subRet,"^",14)
	.....s nightZoneNum=nightZoneNum+$p(subRet,"^",15)
	.....s nightOneNum=nightOneNum+$p(subRet,"^",16)
	.....s nightTwoNum=nightTwoNum+$p(subRet,"^",17)
	q dayWork_"^"_nightWork_"^"_dayOneNum_"^"_dayZoneNum_"^"_nightOneNum_"^"_nightZoneNum
}

/// 生成护士（perdr）,某天（date）的相关数量（tmp）
ClassMethod ComputeDayNurseWork(perdr As %String, date As %String) As %String
{
	q:perdr="" "人员ID不能为空"
	q:date="" "日期不能为空"
	s daywork=0,dayworks=0,nightwork=0,nightworks=0,holiday=0,dayonelevel=0,dayspelevel=0,nightonelevel=0,nightspelevel=0
	s RowID=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,$zdh(date,3),""))
	q:RowID="" ""
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(RowID)
	s argPostDr=obj.ArgPostDR.%Id() //班次id
	s starttime1=obj.ArgStTime1 //第一时段开始时间
	s endtime1=obj.ArgEndTime1	//第一时段截止时间
	s starttime2=obj.ArgStTime2	//第二时段开始时间
	s endtime2=obj.ArgEndTime2	//第二时段截止时间
	s starttime3=obj.ArgStTime3	//第三时段开始时间
	s endtime3=obj.ArgEndTime3	//第三时段截止时间
	s postcategory=obj.ArgPostDR.PostCategory
	i postcategory="W" d //白班
	.s daywork=daywork+1 //白班数+1
	e  i postcategory="N" d //夜班
	.s nightwork=nightwork+1 //夜班数+1
	e  i postcategory="24" d // 24小时班
	.s daywork=daywork+1,nightwork=nightwork+1 //白班数+1 夜班数+1
	e  i postcategory="H" d //休假
	.s holiday=holiday+1 //休假数+1
	s ret="daywork|"_daywork_"^nightwork|"_nightwork_"^holiday|"_holiday
	//计算白班护理患者个数
	//首先获取护士的分组信息
	i obj.ArgRowDR'="" d //排班行记录不为空
	.s RowGroup=obj.ArgRowDR.ArgGroupDR //行记录中的分组ID
	.i RowGroup'="" d
	..s Beds=RowGroup.GroupResBeds //组中所关联的床位
	..s len=Beds.Count()
	..for i=1:1:len d
	...s itm=Beds.GetAt(i)
	...i itm'="" d //床位存在
	....s StartTime="",EndTime=""
	....i obj.ArgPostDR.PostCategory="W" d
	.....i starttime1'="" s StartTime=starttime1
	.....i endtime1'="" s EndTime=endtime1
	.....i ((starttime2'="")&&(starttime1'="")&&(starttime2<starttime1)) s StartTime=starttime2
	.....i ((endtime2'="")&&(endtime1'="")&&(endtime2>endtime1)) s EndTime=endtime2
	.....i StartTime="" s StartTime=starttime3
	.....e  i (starttime3'="")&&(StartTime>starttime3) s StartTime=starttime3
	.....i EndTime="" s EndTime=endtime3
	.....e  i ((endtime3'="")&&(EndTime<endtime3)) s EndTime=endtime3
	.....//查找日期时间段内的患者并且在组内所关联的床位上
	.....s adm="" f  s adm=$o(^PAADMi("TransBed",itm,adm)) q:adm=""  d
	......s tranid="" f  s tranid=$o(^PAADMi("TransBed",bedid,adm,tranid)) q:tranid=""  d
	.......s tran=^PAADM(adm,"TRANS",tranid)
	.......s tranStDate=$p(tran,"^",1),tranStTime=$p(tran,"^",2)
	.......s tranEndDate=$p(tran,"^",3),tranEndTime=$p(tran,"^",4)
	.......q:($o(^PAADM(adm,"TRANS",tranid))'="")&&(tranEndDate="")
	.......q:(tranStDate>$zdh(date,3))||((tranEndDate'="")&&(tranEndDate<$zdh(date,3)))
	.......q:(tranStDate=$zdh(date,3))&&(tranStTime>EndTime)
	.......q:(tranEndDate=$zdh(date,3))&&(tranEndTime<StartTime)
	.......s tmp("adm",adm)=adm
}

/// Descrption:获取护士每天的工作量 【暂未使用】
/// Date:2018-04-19
/// Table:
/// Input:护士人员表id  排班日期
/// Output:分管床位数 班次 工作时长 分管病人数 特级护理数 一级护理数 二级护理数 三级护理数
/// Other:
ClassMethod ComputDayWorkLoad(perdr As %String = "", date As %String = "") As %String
{
	
	
	q:(perdr="")||(date="") ""
	s per=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	q:'$IsObject(per) ""
	s minutes=##class(web.NurMgArgComm).CountMinutes(perdr,date)
	s:date["-" date=$zdh(date,3)
	s tmp=""
	d ..getTmpNurNowPat(perdr,date,.tmp)
	d ..getTmpNurNowPat(perdr,date-1,.tmp)
	s bedNum=+$g(tmp("data","bedNum"))
	s PerPost=$g(tmp("data","PerPost"))
	s patNum=0,carelevel0=0,carelevel1=0,carelevel2=0,carelevel3=0
	s adm="" f  s adm=$O(tmp("adm",adm)) q:adm=""  d
	.s patNum=patNum+1
	.s carelevel=##class(Nur.CommonInterface.Patient).getCareLevel(adm)
	.s:carelevel="特级" carelevel0=carelevel0+1
	.s:carelevel="一级" carelevel1=carelevel1+1
	.s:carelevel="二级" carelevel2=carelevel2+1
	.s:carelevel="三级" carelevel3=carelevel3+1
	s minutes=(minutes\60)_"小时"_(minutes#60)_"分钟"
	q bedNum_"^"_PerPost_"^"_minutes_"^"_patNum_"^"_carelevel0_"^"_carelevel1_"^"_carelevel2_"^"_carelevel3
}

/// 【暂未使用】
ClassMethod getTmpNurNowPat(per, date, tmp) As %String
{
	s nowDate=+$h
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",per,date,subid)) q:subid=""  d
	.s subobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	.q:'$IsObject(subobj)
	.q:('$IsObject(subobj.ArgRowDR))||('$IsObject(subobj.ArgRowDR.ArgGroupDR))
	.s beds=subobj.ArgRowDR.ArgGroupDR.GroupResBeds
	.s sttime1=subobj.ArgStTime1,endtime1=subobj.ArgEndTime1
	.s sttime2=subobj.ArgStTime2,endtime2=subobj.ArgEndTime2
	.s sttime3=subobj.ArgStTime3,endtime3=subobj.ArgEndTime3
	.;s:sttime1["次日" sttime1=""
	.;s:sttime2["次日" sttime2=""
	.;s:sttime3["次日" sttime3=""
	.i nowDate=date d
	..s:endtime1["次日" endtime1="23:59"
	..s:endtime2["次日" endtime2="23:59"
	..s:endtime3["次日" endtime3="23:59"
	.e  d
	..s:endtime1["次日" endtime1=$E(endtime1,3,$L(endtime1)),sttime1="00:00"
	..s:endtime2["次日" endtime2=$E(endtime2,3,$L(endtime2)),sttime2="00:00"
	..s:endtime3["次日" endtime3=$E(endtime3,3,$L(endtime3)),sttime3="00:00"
	.s sttime="",endtime=""
	.i (sttime1'="")&&(endtime1'="") d
	..s sttime1=$zth(sttime1,2),endtime1=$zth(endtime1,2)
	..s sttime=sttime1,endtime=endtime1
	.e  s sttime1="",endtime1=""
	.i (sttime2'="")&&(endtime2'="") d
	..s sttime2=$zth(sttime2,2),endtime2=$zth(endtime2,2)
	..s:(sttime="")||((sttime'="")&&(sttime2<sttime)) sttime=sttime2
	..s:(endtime="")||((endtime'="")&&(endtime2>endtime)) endtime=endtime2
	.e  s sttime2="",endtime2=""
	.i (sttime3'="")&&(endtime3'="") d
	..s sttime3=$zth(sttime3,2),endtime1=$zth(endtime3,2)
	..s:(sttime="")||((sttime'="")&&(sttime3<sttime)) sttime=sttime3
	..s:(endtime="")||((endtime'="")&&(endtime3>endtime)) endtime=endtime3
	.e  s sttime3="",endtime3=""
	.q:(sttime="")||(endtime="")
	.s bedNum=beds.Count()
	.s tmp("data","bedNum")=bedNum
	.s:$d(tmp("data","PerPost")) tmp("data","PerPost")=tmp("data","PerPost")_"\"_subobj.ArgPostDR.PostDesc
	.s:'$d(tmp("data","PerPost")) tmp("data","PerPost")=subobj.ArgPostDR.PostDesc
	.f i=1:1:bedNum  d
	..s bedid=beds.GetAt(i)
	..s adm="" f  s adm=$O(^PAADMi("TransBed",bedid,adm)) q:adm=""  d
	...s tranid="" f  s tranid=$O(^PAADMi("TransBed",bedid,adm,tranid)) q:tranid=""  d
	....s tran=^PAADM(adm,"TRANS",tranid)
	....s tranStDate=$p(tran,"^",1),tranStTime=$p(tran,"^",2)
	....s tranEndDate=$p(tran,"^",3),tranEndTime=$p(tran,"^",4)
	....q:(tranStDate>date)||((tranEndDate'="")&&(tranEndDate<date))
	....q:(tranStDate=date)&&(tranStTime>endtime)
	....q:(tranEndDate=date)&&(tranEndTime<sttime)
	....s tmp("adm",adm)=adm
	q 0
}

/// Creator:gzj
/// Description:获取不良事件类型
/// Date:2017-09-20
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindAdvNurType","")
Query FindAdvNurType(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAdvNurTypeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	S adrEvtCode=""
    S adrEvtDesc=""
	S AdrEvtID="" F  S AdrEvtID=$o(^DHCMEDADREVT(AdrEvtID)) Q:AdrEvtID=""  D
	.q:+AdrEvtID=0
	.S AdrEvtDesc=$p(^DHCMEDADREVT(AdrEvtID),"^",2)
	.S CH="" F  S CH=$o(^DHCMEDADREVTI(AdrEvtID,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(AdrEvtID,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(AdrEvtID,"MADREVI",CH),"^",2) //描述
	..q:(($tr(parr," ","")'="")&&(Desc'[$zcvt($tr(parr," ",""),"U")))
	..S Active=$p(^DHCMEDADREVTI(AdrEvtID,"MADREVI",CH),"^",3) //是否可用
	..;q:(adrEvtCode'="")&(Code'[adrEvtCode) //判断adrEvtCode是否为空，'[ 为包含的意思
	..;q:(adrEvtDesc'="")&(Desc'[adrEvtDesc)  //判断adrEvtDesc是否为空，'[ 为包含的意思
	..s ret="Code|"_Code_"^Par|"_AdrEvtID_"^rw|"_CH_"^Desc|"_Desc_"^Active|"_Active_"^AdrEvtDesc|"_AdrEvtDesc
	..d AdvTypeData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdvTypeData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdvNurTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdvNurTypeExecute ]
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

ClassMethod FindAdvNurTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdvNurTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:portal获取人员档案信息
/// Date:2019-01-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgOutInterface","FindNurList","")
Query FindNurList(PacWard As %String = "") As %Query(ROWSPEC = "NurseDepPacWardID:%String,NurseDepDesc:%String,NurseName:%String,PerSexDR:%String,PerAge:%String,PerWorkYear:%String,PerPostDuty:%String,PerStEducate:%String,PerEndEducate:%String,PerLevel:%String")
{
}

ClassMethod FindNurListExecute(ByRef qHandle As %Binary, PacWard As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=""
	i PacWard'="" d
	.s locId=$P($g(^PAWARD(PacWard)),"^",5)
	.s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locId,""))
	i (PacWard'="")&&(wardid="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s id="" f  s id=$O(^DHCNMG.DB.MgWardD(id)) q:id=""  d
	.q:(wardid'="")&&(id'=wardid)
	.s tWardObj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	.q:'$IsObject(tWardObj)
	.s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	..q:obj.PerTypeDR'="N"
	..q:obj.PerStatus'="17||1"
	..;病区ID(pac_ward表ID),病区描述,初始学历描述,最终学历描述
	..s NurseName=obj.PerName //姓名
	..s PerSexDR=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR) //性别
	..s PerAge="" //年龄
	..i obj.PerBirthday'="" d
	...s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	...s PerAge=$p(age,"Y",1)
	..s PerWorkYear="" //工作年限
	..s PerWorkDate=obj.PerWorkDate
	..s:PerWorkDate="" PerWorkDate=obj.PerComeDate
	..s:PerWorkDate'="" PerWorkYear=##class(web.NurMgVueComm).CalAge($zd(PerWorkDate,3),$zd(+$H,3))
	..s PerWorkYear=$p(PerWorkYear,"Y",1)
	..//获取层级信息
	..s PerLevel="",PerLevelDate=""
	..s LeaveId="" f  s LeaveId=$O(^DHCNMG.HR.MgLevelI("ssid",RowID,LeaveId)) q:LeaveId=""  d
	...s LeaveObj=##class(DHCNMG.HR.MgLevel).%OpenId(LeaveId)
	...q:'$IsObject(LeaveObj)
	...q:LeaveObj.LevelStatus'="A"
	...q:LeaveObj.LevelDate<PerLevelDate
	...q:LeaveObj.LevelDate>+$H
	...s PerLevel=##class(web.NurMgPersonComm).GetCommCode(LeaveObj.NurLevel)
	...s PerLevelDate=LeaveObj.LevelDate
	..;获取职务信息
	..s PerPostDuty=""
	..s PostRowID="" f  s PostRowID=$O(^DHCNMG.HR.MgPostDutyI("ssid",RowID,PostRowID)) q:PostRowID=""  d
	...s PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostRowID)
	...q:'$IsObject(PostObj)
	...q:PostObj.PostStatus'="A"
	...q:(PostObj.PostStDate'="")&&(PostObj.PostStDate>+$H)
	...q:(PostObj.PostEndDate'="")&&(PostObj.PostEndDate<+$H)
	...i PerPostDuty="" s PerPostDuty=##class(web.NurMgPersonComm).GetCommCode(PostObj.PostDuty)
	...e  s PerPostDuty=PerPostDuty_";"_PerPostDuty
	..s PerStEducate="",PerEndEducate="",PerEducateStDate="",PerEducateEndDate=""
	..s EduRowID="" f  s EduRowID=$O(^DHCNMG.HR.MgEducateI("ssid",RowID,EduRowID)) q:EduRowID=""  d
	...s EduObj=##class(DHCNMG.HR.MgEducate).%OpenId(EduRowID)
	...q:'$IsObject(EduObj)
	...q:EduObj.EduStatus'="A"
	...i ((PerStEducate="")||(EduObj.EduEndDate<PerEducateStDate))&&(EduObj.EduRadio="25||1") d
	....s PerStEducate=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduAcademic)
	....s EPerEducateStDate=EduObj.EduEndDate
	...i (PerEndEducate="")||(EduObj.EduEndDate>PerEducateEndDate) d
	....s PerEndEducate=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduAcademic)
	....s PerEducateEndDate=EduObj.EduEndDate
	..s NurseDepDesc="",NurseDepPacWardID=""
	..i $IsObject(tWardObj.CTLocDR) d
	...s loc=tWardObj.CTLocDR.%Id()
	...i loc'="" d
	....s NurseDepPacWardID=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	....s:NurseDepPacWardID'="" NurseDepDesc=$P(^PAWARD(NurseDepPacWardID),"^",2)
	..;s ret="PacWardID|"_NurseDepPacWardID_"^WardDesc|"_NurseDepDesc_"^NurName|"_NurseName_"^NurSex|"_PerSexDR
	..;s ret=ret_"^NurAge|"_PerAge_"^NurWorkYear|"_PerWorkYear_"^NurDuty|"_PerPostDuty_"^NurStEdu|"_PerStEducate
	..;s ret=ret_"^NurEndEdu|"_PerEndEducate_"^NurLevel|"_PerLevel
	..d OutPutNurData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutNurData
	set Data=$lb(NurseDepPacWardID,NurseDepDesc,NurseName,PerSexDR,PerAge,PerWorkYear,PerPostDuty,PerStEducate,PerEndEducate,PerLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurListExecute ]
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

ClassMethod FindNurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:计算当天所排班次的白班天数^夜班天数，。
/// Date:2019-01-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:目前计算当天排的班次,跨天也算入了，带完善应该分三种：当天、第二天、全部。
ClassMethod CaluArgHour(sttime, endtime, date) As %String
{
	q:(sttime="")||(endtime="")||(date="") "0^0"
	s time=0,night=0
	s obj1=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s monthday=$P($zd(date,3),"-",2)_$P($zd(date,3),"-",3)
	i (monthday<"1001")&&((monthday>"0501")||(monthday="0501")) d
	.s nsttime=obj1.NightStTime1,nendtime=obj1.NightEndTime1
	e  s nsttime=obj1.NightStTime2,nendtime=obj1.NightEndTime2 
	i nsttime="" s nsttime=$zth("16:00:00",1)
	i nendtime="" s nendtime=$zth("08:00:00",1)
	i endtime["次日" d
	.s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	..i sttime["次日" d
	...s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	..e  s sttime=$zth(sttime,1)
	.s nendtime=nendtime+86400
	.i (sttime>nendtime)||(endtime<nsttime) s night=0
	.e  i (sttime>nsttime)&&(endtime<nendtime) s night=endtime-sttime
	.e  i (endtime<nendtime) s night=endtime-nsttime
	.e  s night=nendtime-sttime
	e  d
	.s endtime=$zth(endtime,1),sttime=$zth(sttime,1)
	.i endtime<=nendtime s night=night+(endtime-sttime)
	.e  d
	..i (sttime<=nendtime) s time=time+(nendtime-sttime)
	..i (endtime>=nsttime) s time=time+(endtime-nsttime)
	s time=(endtime-sttime)
	q time_"^"_night
}

/// creator: lulin	
/// createdate:2019-01-12
/// description: 获取某人某天假描述
/// table: 
/// input: 护士id^date
/// output:
/// other: 
ClassMethod GetLeavelDesc(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") ""
		s:date["-" date=$zdh(date,3)
		s flag=0,ret=""
		s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:(id="")||(flag=1)  d
		.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
		.q:'$IsObject(obj)
		.q:obj.LeaveStatus'="NH"
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))
		.q:((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s retId=obj.LeaveType
		.q:retId=""
		.s wardPostObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(retId)
		.q:('$IsObject(wardPostObj))||('$IsObject(wardPostObj.PostDR))
		.s ret=wardPostObj.PostDR.PostDesc
		.s flag=1
		i flag=0 d
		.s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:(id="")||(flag=1)  d
		..s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
		..q:'$IsObject(obj2)
		..q:obj2.LeaveStatus'="HH"
		..q:((obj2.LeaveStDate'="")&&(obj2.LeaveStDate>date))
		..q:((obj2.LeaveEndDate'="")&&(obj2.LeaveEndDate<date))
		..s retId=obj2.LeaveType
		..q:retId=""
		..s wardPostObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(retId)
		..q:('$IsObject(wardPostObj))||('$IsObject(wardPostObj.PostDR))
		..s ret=wardPostObj.PostDR.PostDesc
		..s flag=1
		q ret
}

/// Creator:lulin
/// Description:portal获取工作量接口
/// Date:2019-01-12
/// Table:
/// Input:WardId(pac_ward表ID),date(日期,格式:2018-11)
/// Output：护士姓名,总排班数量,白班班次数量,夜班班次数量,工作量(小时),白班时长(小时),夜班时长(小时),事假数量,产假数量,病假数量,探亲假数量,其他请假数量Maternity leave, maternity leave, sick leave, family leave
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgOutInterface","FindWorkCountList","14","")
Query FindWorkCountList(PacWard As %String = "", date As %String = "") As %Query(ROWSPEC = "NurName:%String,ArgCount:%String,DayCount:%String,NightCount:%String,ArgHour:%String,DayHour:%String,NightHour:%String,CasualLeave:%String,MaternityLeave:%String,SickLeave:%String,FamilyLeave:%String,OtherLeave:%String,OvertimeCount:%String,OvertimeHour:%String,ReduceCount:%String")
{
}

ClassMethod FindWorkCountListExecute(ByRef qHandle As %Binary, PacWard As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=""
	i PacWard'="" d
	.s locId=$P($g(^PAWARD(PacWard)),"^",5)
	.s:locId'="" wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locId,""))
	i (PacWard="")||(wardid="")||(date="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s stdate=$zdh(date_"-01",3)
	s month=($P(date,"-",2)+1)
	s year=$P(date,"-")
	s:month>12 month="01",year=year+1
	s enddate=$zdh(year_"-"_month_"-01",3)-1
	//NurName,ArgCount,DayCount,NightCount,ArgHour,DayHour,NightHour,CasualLeave,MaternityLeave,SickLeave,FamilyLeave,OtherLeave
	s nurid="" f  s nurid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,nurid)) q:nurid=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurid)
	.q:'$IsObject(perObj)
	.s NurName=perObj.PerName,ArgCount=0,DayCount=0,NightCount=0,ArgHour=0,DayHour=0,NightHour=0,CasualLeave=0,MaternityLeave=0,SickLeave=0,FamilyLeave=0,OtherLeave=0
	.s OvertimeCount=0,OvertimeHour=0 //加班次数,加班小时数
	.s OverCount=0,ReduceCount=0
	.f tDate=stdate:1:enddate d
	..s Leave=..GetLeavelDesc(nurid_"^"_tDate)
	..i Leave'="" d
	...i Leave["事假" s CasualLeave=CasualLeave+1
	...e  i Leave["产假" s MaternityLeave=MaternityLeave+1
	...e  i Leave["病假"  s SickLeave=SickLeave+1
	...e  i Leave["探亲假"  s FamilyLeave=FamilyLeave+1
	...e  s OtherLeave=OtherLeave+1
	..e  d
	..s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurid,tDate,argid)) q:argid=""  d
	...s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	...q:'$IsObject(obj)
	...q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	...i (obj.ArgType="Y")||(obj.ArgType="N") d
	....s:obj.ArgType="Y" OverCount=OverCount+1,OvertimeCount=OvertimeCount+1
	....s:obj.ArgType="N" ReduceCount=ReduceCount+1
	....s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	....i (sttime1'="")&&(endtime1'="") d
	.....s endtime=$zth(endtime1,1)
	.....s sttime=$zth(sttime1,1)
	.....i obj.ArgType="Y" s OvertimeHour=OvertimeHour+(endtime-sttime)
	.....e  s OvertimeHour=OvertimeHour-(endtime-sttime)
	...q:'$IsObject(obj.ArgPostDR)
	...i obj.ArgPostDR.PostDR.PostType="H" d  ///排除休假
	....s Leave=obj.ArgPostDR.PostDR.PostDesc
	....s LeaveNum=1
	....s:obj.ArgHolidayTime'="H" LeaveNum=0.5
	....i Leave["事假" s CasualLeave=CasualLeave+LeaveNum
	....e  i Leave["产假" s MaternityLeave=MaternityLeave+LeaveNum
	....e  i Leave["病假"  s SickLeave=SickLeave+LeaveNum
	....e  i Leave["探亲假"  s FamilyLeave=FamilyLeave+LeaveNum
	....e  s OtherLeave=OtherLeave+1
	...q:obj.ArgPostDR.PostDR.PostType="H"
	...q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班)
	...s ArgCount=ArgCount+1
	...i obj.ArgPostDR.PostDR.PostCategory="N" s NightCount=NightCount+1
	...i obj.ArgPostDR.PostDR.PostCategory="W" s DayCount=DayCount+1
	...s count=..CaluArgHour(obj.ArgStTime1,obj.ArgEndTime1,tDate)
	...s ArgHour=ArgHour+$P(count,"^")
	...s NightHour=NightHour+$P(count,"^",2)
	...s count=..CaluArgHour(obj.ArgStTime2,obj.ArgEndTime2,tDate)
	...s ArgHour=ArgHour+$P(count,"^")
	...s NightHour=NightHour+$P(count,"^",2)
	...s count=..CaluArgHour(obj.ArgStTime3,obj.ArgEndTime3,tDate)
	...s ArgHour=ArgHour+$P(count,"^")
	...s NightHour=NightHour+$P(count,"^",2)
	.s ArgMinite=ArgHour
	.s ArgHour=$fn(ArgHour/3600,"",1),DayHour=$fn((ArgMinite-NightHour)/3600,"",1)
	.s NightHour=$fn(NightHour/3600,"",1)
	.s OvertimeHour=$fn(OvertimeHour/3600,"",1)
	.d OutPutWorkCountData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutWorkCountData
	set Data=$lb(NurName,ArgCount,DayCount,NightCount,ArgHour,DayHour,NightHour,CasualLeave,MaternityLeave,SickLeave,FamilyLeave,OtherLeave,OvertimeCount,OvertimeHour,ReduceCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkCountListExecute ]
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

ClassMethod FindWorkCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:portal新版护理排班接口,获取某一天某病区排班信息
/// Date:2019-01-12
/// Table:
/// Input:WardId(pac_ward表ID),date(格式:2018-11-15)
/// Output：护士姓名,班次名称,班次时间段,是否夜班
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgOutInterface","FindWardDateArgList","14","2018-12-17")
Query FindWardDateArgList(PacWard As %String = "", date As %String = "") As %Query(ROWSPEC = "NurName:%String,ArgPost:%String,ArgTime:%String,IsNight:%String,MaternityLeave:%String,SickLeave:%String,OtherLeave:%String")
{
}

ClassMethod FindWardDateArgListExecute(ByRef qHandle As %Binary, PacWard As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=""
	i PacWard'="" d
	.s locId=$P($g(^PAWARD(PacWard)),"^",5)
	.s:locId'="" wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locId,""))
	i (PacWard="")||(wardid="")||(date="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s date=$zdh(date,3)
	s nurid="" f  s nurid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,nurid)) q:nurid=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurid)
	.q:'$IsObject(perObj)
	.s NurName=perObj.PerName
	.s MaternityLeave=0,SickLeave=0,OtherLeave=0
	.s LeaveDesc=..GetLeavelDesc(nurid_"^"_date)
	.i LeaveDesc'="" d
	..i LeaveDesc["产假" s MaternityLeave=MaternityLeave+1
	..e  i LeaveDesc["病假" s SickLeave=SickLeave+1
	..e  s OtherLeave=OtherLeave+1
	.s ArgPost="",ArgTime="",IsNight=""
	.s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",wardid,nurid,date,argid)) q:argid=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	..q:'$IsObject(obj)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..q:'$IsObject(obj.ArgPostDR)
	..q:'$IsObject(obj.ArgPostDR.PostDR)
	..i obj.ArgPostDR.PostDR.PostType="H" d  ///休假
	...s Leave=obj.ArgPostDR.PostDR.PostDesc
	...s LeaveNum=1
	...s:obj.ArgHolidayTime'="H" LeaveNum=0.5
	...i Leave["产假" s MaternityLeave=MaternityLeave+LeaveNum
	...e  i Leave["病假"  s SickLeave=SickLeave+LeaveNum
	...e  s OtherLeave=OtherLeave+LeaveNum
	..q:obj.ArgPostDR.PostDR.PostType="H"
	..s tPost=obj.ArgPostDR.PostDR.PostDesc
	..s tTime=""
	..s tNight=0
	..s:obj.ArgPostDR.PostDR.PostCategory="N" tNight=1
	..i (obj.ArgStTime1'="")&&(obj.ArgEndTime1'="") s tTime=obj.ArgStTime1_"--"_obj.ArgEndTime1
	..i (obj.ArgStTime2'="")&&(obj.ArgEndTime2'="") d
	...i tTime="" s tTime=obj.ArgStTime2_"--"_obj.ArgEndTime2
	...e  s tTime=tTime_","_obj.ArgStTime2_"--"_obj.ArgEndTime2
	..i (obj.ArgStTime3'="")&&(obj.ArgEndTime3'="") d
	...i tTime="" s tTime=obj.ArgStTime3_"--"_obj.ArgEndTime3
	...e  s tTime=tTime_","_obj.ArgStTime3_"--"_obj.ArgEndTime3
	..i ArgPost="" s ArgPost=tPost,ArgTime=tTime,IsNight=tNight
	..e  d
	...s ArgPost=ArgPost_"「"_tPost,ArgTime=ArgTime_"「"_tTime,IsNight=IsNight_"「"_tNight
	.d OutPutArgData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutArgData
	set Data=$lb(NurName,ArgPost,ArgTime,IsNight,MaternityLeave,SickLeave,OtherLeave)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardDateArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardDateArgListExecute ]
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

ClassMethod FindWardDateArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardDateArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:人力资源获取排班接口
/// Date:2019-02-28
/// Table:
/// Input:起始日期  截至日期
/// Output： 工号 姓名  排班班次名称  排班日期  时长  类型【0：正常排休,1：请假】
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgOutInterface","FindArgList","2019-02-18","2019-02-24","")
Query FindArgList(stdate As %String = "", enddate As %String = "", PacWard As %String = "") As %Query(ROWSPEC = "NurID:%String,NurName:%String,ArgDate:%String,ArgPost:%String,ArgTime:%String,ArgType:%String")
{
}

ClassMethod FindArgListExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate As %String = "", PacWard As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=""
	i PacWard'="" d
	.s locId=$P($g(^PAWARD(PacWard)),"^",5)
	.s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locId,""))
	s wardid=1
	i stdate["-" s stdate=$zdh(stdate,3)
	i stdate'?1n.n s stdate=+$H
	i enddate["-" s enddate=$zdh(enddate,3)
	i enddate'?1n.n s enddate=+$H
	s nurid="" f  s nurid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,nurid)) q:nurid=""  d
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurid)
	.q:'$IsObject(perObj)
	.s NurName=perObj.PerName
	.s NurID=perObj.HISNO
	.f date=stdate:1:enddate  d
	..s curward=##class(web.NurMgHRComm).GetCurrentWard(nurid,date)
	..q:(wardid'="")&&(curward'=wardid)
	..s ArgDate=$zd(date,3)
	..s ArgPost=..GetLeavelDesc(nurid_"^"_date)
	..i ArgPost'="" d
	...s ArgPost=ArgPost_"$"_1
	...s ArgTime=""
	...s ArgType=1
	...d OutArgData
	..q:ArgPost'=""
	..s ArgTime=""
	..s ArgType=0
	..s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurid,date,argid)) q:argid=""  d
	...s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	...q:'$IsObject(obj)
	...q:'$IsObject(obj.ArrangeDR)
	...q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	...q:'$IsObject(obj.ArgPostDR)
	...q:'$IsObject(obj.ArgPostDR.PostDR)
	...i obj.ArgPostDR.PostDR.PostType="H" d  ///休假
	....s Leave=obj.ArgPostDR.PostDR.PostDesc
	....s LeaveNum=1
	....s:obj.ArgHolidayTime'="H" LeaveNum=0.5
	....i ArgPost="" s ArgPost=Leave_"$"_LeaveNum
	....e  s ArgPost=ArgPost_"「"_Leave_"$"_LeaveNum
	...q:obj.ArgPostDR.PostDR.PostType="H"
	...i ArgPost="" s ArgPost=obj.ArgPostDR.PostDR.PostDesc
	...e  s ArgPost=ArgPost_"「"_obj.ArgPostDR.PostDR.PostDesc
	...s count=..CaluArgHour(obj.ArgStTime1,obj.ArgEndTime1,date)
	...s ArgTime=ArgTime+$P(count,"^")
	...;s NightHour=NightHour+$P(count,"^",2)
	...s count=..CaluArgHour(obj.ArgStTime2,obj.ArgEndTime2,date)
	...s ArgTime=ArgTime+$P(count,"^")
	...;s NightHour=NightHour+$P(count,"^",2)
	...s count=..CaluArgHour(obj.ArgStTime3,obj.ArgEndTime3,date)
	...s ArgTime=ArgTime+$P(count,"^")
	..s:ArgTime'="" ArgTime=$fn(ArgTime/3600,"",1)
	..d OutArgData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutArgData
	set Data=$lb(NurID,NurName,ArgDate,ArgPost,ArgTime,ArgType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgListExecute ]
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

ClassMethod FindArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2019-09-18
/// Description:通过工号获取身份证号码
/// Table:DHCNMG.HR.MgPersons
/// Input:nurseNo:护士工号
/// Output:身份证号码^姓名
/// Return:
/// Other:
ClassMethod GetNurseCardId(nurseNo As %String) As %String
{
	q:nurseNo="" ""
	s ret=""
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(nurseNo," ",""),"U"),RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:obj.PerTypeDR'="N" //只取正式护士的身份证号码
	.s ret=obj.PerCardId_"^"_obj.PerName
	q ret
}

}
