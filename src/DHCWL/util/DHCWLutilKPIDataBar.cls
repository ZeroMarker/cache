/// 用于记录指标生成数据进度条中的关键数据
Class DHCWL.util.DHCWLutilKPIDataBar Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-07-09
/// Desc      : 开始记录进度条信息
/// Other     : do ##class(DHCWL.util.DHCWLutilKPIDataBar).Start()
ClassMethod Start(startDate, endDate)
{
	k ^TEMPDHCWL("KPI","CreatDate","progress","startDate")  //先清空用于记录数据的global
	k ^TEMPDHCWL("KPI","CreatDate","progress","endDate")
	k ^TEMPDHCWL("KPI","CreatDate","progress","start")
	k ^TEMPDHCWL("KPI","CreatDate","progress","end")
	k ^TEMPDHCWL("KPI","CreatDate","progress","intervalProgress")
	k ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")
	k ^TEMPDHCWL("KPI","CreatDate","progress","upperProgress")
	k ^TEMPDHCWL("KPI","CreatDate","progress","currentDetailTotal")
	k ^TEMPDHCWL("KPI","CreatDate","progress","errorMsg")
	k ^TEMPDHCWL("creatKpiDate","checkNumber")
	k ^TEMPDHCWL("KPI","CreatDate","progress","currentProgressForLog")
	
	s ^TEMPDHCWL("KPI","CreatDate","progress","startDate")=startDate
	s ^TEMPDHCWL("KPI","CreatDate","progress","endDate")=endDate
	s ^TEMPDHCWL("KPI","CreatDate","progress","start")=1
}

/// Creator   : wk
/// CreatDate : 2018-07-09
/// Desc      : 记录进度条的总配置信息
/// Other     : do ##class(DHCWL.util.DHCWLutilKPIDataBar).TotalProgressConfig()
ClassMethod TotalProgressConfig(currentDate)
{
	s startDate=^TEMPDHCWL("KPI","CreatDate","progress","startDate")
	s endDate=^TEMPDHCWL("KPI","CreatDate","progress","endDate")
	s ^TEMPDHCWL("KPI","CreatDate","progress","intervalProgress")=(1/(endDate-startDate+1))
	s ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")=((currentDate-startDate)/(endDate-startDate+1))
	s ^TEMPDHCWL("KPI","CreatDate","progress","upperProgress")=((currentDate-startDate+1)/(endDate-startDate+1))
}

/// Creator   : wk
/// CreatDate : 2018-07-09
/// Desc      : 记录每个日期下的monthID以及父区间的monthID下指标的总量
/// Other     : do ##class(DHCWL.util.DHCWLutilKPIDataBar).DetailTotal()
ClassMethod DetailTotal(ByRef data)
{
	s monID="",num=0
	for {
		s monID=$o(data(monID))
		q:monID=""
		s kpis=data(monID)
		s len=$l(kpis,",")
		s num=num+len
	}
	s ^TEMPDHCWL("KPI","CreatDate","progress","currentDetailTotal")=num
}

/// Creator   : wk
/// CreatDate : 2018-07-09
/// Desc      : 每执行完一个指标的生成数据操作,增加一次进度
/// Other     : do ##class(DHCWL.util.DHCWLutilKPIDataBar).IncreaseProgress()
ClassMethod IncreaseProgress()
{
	s currentProgress=^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")
	s intervalProgress=^TEMPDHCWL("KPI","CreatDate","progress","intervalProgress")
	s currentDetailTotal=^TEMPDHCWL("KPI","CreatDate","progress","currentDetailTotal")
	s newCurrentProgress=(currentProgress+(intervalProgress/currentDetailTotal))
	s upperProgress=^TEMPDHCWL("KPI","CreatDate","progress","upperProgress")
	if ((newCurrentProgress<upperProgress)&&((upperProgress-newCurrentProgress)>0)){
		s ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")=newCurrentProgress
	}
}

/// Creator   : wk
/// CreatDate : 2018-07-09
/// Desc      : 结束
/// Other     : do ##class(DHCWL.util.DHCWLutilKPIDataBar).end()
ClassMethod end(num As %String = 1)
{
	s ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")=num
	k ^TEMPDHCWL("KPI","CreatDate","progress","startDate")
	k ^TEMPDHCWL("KPI","CreatDate","progress","endDate")
	k ^TEMPDHCWL("KPI","CreatDate","progress","start")
	k ^TEMPDHCWL("KPI","CreatDate","progress","intervalProgress")
	k ^TEMPDHCWL("KPI","CreatDate","progress","upperProgress")
	k ^TEMPDHCWL("KPI","CreatDate","progress","currentDetailTotal")
	k ^TEMPDHCWL("creatKpiDate","checkNumber")
	k ^TEMPDHCWL("KPI","CreatDate","progress","currentProgressForLog")
}

}
