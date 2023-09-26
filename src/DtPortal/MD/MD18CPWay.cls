/// ClassName:    DtPortal.MD.MD18CPWay
/// Description:  临床路径服务
/// Creator：     chengpeng
/// CreatDate:    2014-09-29
Class DtPortal.MD.MD18CPWay Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description	:	MD18.01.03 查询某月全院临床路径数据
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD18CPWay","MD180103","2018-12-01","2018-12-31","")
Query MD180103(StarDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,LocDesc,DevelopNum,CompleteNum,DisNum,CompleteRadio,coverRadio")
{
}

ClassMethod MD180103Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String = "", HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^TMPPortalMD180103
	
	set NowDate=$zd(+$h,3)
	set NowMonth=$p(NowDate,"-",1)_"-"_$p(NowDate,"-",2)
	
	set startDate=$p(StarDate,"-",1)_"-"_$p(StarDate,"-",2)
	set endDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)

	s dateType="byMonth"	
	s filterRule=""
	s mode="H"
	s contract=""
	set:startDate=NowMonth dateType="currentMonth"			//可以查询当月数据
	//出院人数
	s kpiRule="SK0140:PatLoc"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit

		set locID=rs.Data("dimIdCol1")
		s HospID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospID
		}

		set value=rs.Data("kpiValueCol1")
		
		set ^TMPPortalMD180103(locID,"DisNum")=+$g(^TMPPortalMD180103(locID,"DisNum"))+value
	 	
	}
	
	//临床路径开展人数,临床路径完成人数
	s kpiRule="DtPortal0006,DtPortal0007"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit

		set locID=rs.Data("dimIdCol1")
		set CPWDesc=rs.Data("dimIdCol1")
		s HospID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospID
		}

		set value1=rs.Data("kpiValueCol1")		//开展人数
		set value2=rs.Data("kpiValueCol2")		//完成人数
		
		set ^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Develop")=+$g(^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Develop"))+value1
		set ^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Complete")=+$g(^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Complete"))+value2
	 	
	}
	
	set locID=""
	
	for
	{
		set locID=$o(^TMPPortalMD180103(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set DisNum=+$g(^TMPPortalMD180103(locID,"DisNum"))
		
		set CPWDesc=""
		for
		{
			set CPWDesc=$o(^TMPPortalMD180103(locID,"CPWDesc",CPWDesc))
			quit:CPWDesc=""
			
			set DevelopNum=+$g(^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Develop"))		//开展人数
			set CompleteNum=+$g(^TMPPortalMD180103(locID,"CPWDesc",CPWDesc,"Complete"))		//完成人数
			
			set CompleteRadio=0,coverRadio=0
			set:+DevelopNum'=0 CompleteRadio=$fn(CompleteNum/DevelopNum*100,"",2)			//完成率
			set:+DisNum'=0 coverRadio=$fn(CompleteNum/DisNum*100,"",2)						//出院病人覆盖率
			
			set CompleteRadio=CompleteRadio_"%"
			set coverRadio=coverRadio_"%"
			
			Set Data=$lb(ind,locID,LocDesc,DevelopNum,CompleteNum,DisNum,CompleteRadio,coverRadio)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
		
		
	
	Quit $$$OK
}

}
