/// ClassName:    DtPortal.MD.MD33RecordQuality
/// Description:  病历质控相关服务
/// Creator：     chengpeng
/// CreatDate:    2017-08-30
Class DtPortal.MD.MD33RecordQuality Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// /// w ##Class(DtPortal.MD.MD33RecordQuality).getSXItem()
/// Desc:	获取时效性指标配置
/// Creator:Candyxu
ClassMethod getSXItem() As %String
{
	//取配置,取质控项目
	//质控项目配置 Sql查询:SELECT a.ID,b.Title FROM EPRmeta_Quality.QualityEntry a LEFT JOIN EPRmeta_Quality.QualityPool b ON a.PoolDR=b.ID
	set itemStr=##Class(DtPortal.Common.PublicService).getValueByCode("RECORDQUALITY")
	q itemStr
}

/// /// w ##Class(DtPortal.MD.MD33RecordQuality).getItemDesc("264^266^453^457^462^459")
ClassMethod getItemDesc(idStr) As %String
{
	set ret=""
	for a=1:1:$l(idStr)
	{
		set id=$p(idStr,"^",a)
		set EntryObj=##class(EPRmeta.Quality.QualityEntry).%OpenId(id)
	 	continue:'$IsObject(EntryObj)
	 	set PoolDR=EntryObj.PoolDR
	 	set PoolObj=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)
	 	continue:'$IsObject(PoolObj)
	 	set poolName=PoolObj.Title
		
		
		set:ret'="" ret=ret_"^"_poolName
 		set:ret="" ret=poolName
		
	}
	
	
	q ret
}

/// /获取所有配置的时效性质控项目的数据 服务号为：MD330100
/// /creator 赵丽
/// //do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD33RecordQuality","getQualityItemData")
Query getQualityItemData() As DtPortal.Query(ROWSPEC = "indexId,desc") [ SqlProc ]
{
}

ClassMethod getQualityItemDataExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set idStr=..getSXItem()
	for a=1:1:$l(idStr)
	{
		set id=$p(idStr,"^",a)
		set EntryObj=##class(EPRmeta.Quality.QualityEntry).%OpenId(id)
	 	continue:'$IsObject(EntryObj)
	 	set PoolDR=EntryObj.PoolDR
	 	set PoolObj=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)
	 	continue:'$IsObject(PoolObj)
	 	set poolName=PoolObj.Title
		
		s ^||CacheTemp(repid,ind)=$lb(id,poolName)
 	    s ind=ind+1
	
		
	}
	Quit $$$OK
}

/// Description	:	MD33.01.01 查询全院病历时限性指标扣分次数趋势图
/// Input		:	年份
/// Return		:	
/// 	改为指标出数据
/// 修改  赵丽 入参改为开始日期和结束日期
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD33RecordQuality","MD330101New","2019-01-01","2019-08-01",448,"")
Query MD330101(startDate As %String, endDate As %String, itemId As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "month:%String,monthStr:%String,num:%String") [ SqlProc ]
{
}

ClassMethod MD330101Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, itemId As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD330101
	k ^||TMPPortalMD330102
	
	set dateObj=##class(%ResultSet).%New("DtPortal.Common.PublicService:getItemDateDetail")
	d dateObj.Execute("month",startDate,endDate)
	f  Quit:'dateObj.Next()  d
	.set dateStr= dateObj.Data("dateStr")
	.set date= dateObj.Data("date")
	.set ^||TMPPortalMD330101(dateStr)=0
	.set ^||TMPPortalMD330102(dateStr)=date
			
	s dateType="byMonth"	
	s kpiRule="DtPortal0010"
	s filterRule=""
	s mode="H"
	s contract=""

		
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	
	set itemStr=""
	While rs.Next(.sc) {
		
		If $$$ISERR(sc) Quit
		set mDate=rs.Data("month")
		set locID=rs.Data("dimIdCol1")
		set type=rs.Data("dimIdCol2")
		set itemID=rs.Data("dimIdCol3")
		set ruleObj=##class(EPRmeta.Quality.QualityRule).%OpenId(type)
		continue:'$IsObject(ruleObj)
		set Code=ruleObj.Code
		continue:Code'="F"	//质控标准：F 自动任务在院质控；G 自动任务出院质控
		continue:itemID'=itemId	//筛选当前id的
		s HospitalIdID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospitalIdID
		}
		set value=rs.Data("kpiValueCol1")
	    set ^||TMPPortalMD330101(mDate)=+^||TMPPortalMD330101(mDate)+value		
	 	
	}
	
	set itemStr=""
	set itemID=""
	for
	{
		set itemID=$o(^||TMPPortalMD330101(itemID))
		quit:itemID=""
		set itemStr=$S(itemStr="":itemID,1:itemStr_"^"_itemID)
	}
	set monthStr=""
	for
	{
		set monthStr=$o(^||TMPPortalMD330101(monthStr))
		quit:monthStr=""
		
		set value=$g(^||TMPPortalMD330101(monthStr))
		set month=$g(^||TMPPortalMD330102(monthStr))
		s ^||CacheTemp(repid,ind)=$lb(month,monthStr,value)
	 	s ind=ind+1
		
	}
	k ^||TMPPortalMD330101
	k ^||TMPPortalMD330102
	Quit $$$OK
}

/// Description	:	MD33.01.02 查询一段时间内各病历扣分项目科室分布
/// Input		:	年份
/// Return		:	
/// 	改为指标出数据
/// 修改 赵丽 入参为开始日期和结束日期，增加指标项id的入参，只获取某一个指标项的数据
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD33RecordQuality","MD330102New","2019-01-01","2019-08-01","428","")
Query MD330102(startDate As %String, endDate As %String, itemId As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locID,locDesc,num") [ SqlProc ]
{
}

ClassMethod MD330102Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, itemId As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD330102
	
	set role=""
	;set:TabType=1 role=6
	;set:TabType=2 role=7
	
		
	s dateType="byMonth"	
	s kpiRule="DtPortal0010:PatLoc.LocDesc"
	s filterRule="DtPortal0010:(constant="_itemId_")"
	s mode="H"
	s contract=""
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		
		set locID=rs.Data("dimIdCol1")
		set locDesc=rs.Data("dimDesCol1")
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		s HospitalIdID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospitalIdID
		}
		
		set ^||TMPPortalMD330102(locID)=+$g(^||TMPPortalMD330102(locID))+rs.Data("kpiValueCol1")
	}
	
	set locID=""
	for
	{
		set locID=$o(^||TMPPortalMD330102(locID))
		quit:locID=""
		
		set locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		set num=+$g(^||TMPPortalMD330102(locID))
		s ^||CacheTemp(repid,ind)=$lb(locID,locDesc,num)
	 	s ind=ind+1
	}

	k ^||TMPPortalMD330102
	Quit $$$OK
}

/// Description	:	MD33.02.01 查询一段时间内终末病历质控扣分项目前十统计
/// Input		:	年份
/// Return		:	
/// 	改为指标出数据
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD33RecordQuality","MD330201New","2019-01-01","2019-06-25","")
Query MD330201(startDate As %String, endDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "itemID:%String,value:%String,poolName:%String") [ SqlProc ]
{
}

ClassMethod MD330201Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||MD330201
		
	s dateType="byMonth"	
	s kpiRule="DtPortal0010"
	s filterRule=""
	s mode="H"
	s contract=""
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	
	set itemStr=""
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set mDate=rs.Data("month")
		set locID=rs.Data("dimIdCol1")
		set type=rs.Data("dimIdCol2")
		set ruleObj=##class(EPRmeta.Quality.QualityRule).%OpenId(type)
		continue:'$IsObject(ruleObj)
		set Code=ruleObj.Code
		continue:Code'="G"	//质控标准：F 自动任务在院质控；G 自动任务出院质控
		s HospitalIdID=$P($g(^CTLOC(locID)),"^",22)
		if HospitalId'=""
		{
			continue:HospitalId'=HospitalIdID
		}
		set mounth=$p($p(mDate,"年",2),"月",1)
		if mounth<10 s mounth=$p(mounth,"0",2)
		set itemID=rs.Data("dimIdCol3")
		set value=rs.Data("kpiValueCol1")
		
		set ^||MD330201("data",itemID)=$g(^||MD330201("data",itemID))+value
		
		
	 	
	}
	set itemID=""
	for 
	{
		set itemID=$o(^||MD330201("data",itemID))
		quit:itemID=""
		
		set value=^||MD330201("data",itemID)
		
		set ^||MD330201("paixu",value,itemID)=""
	}
	
	set index=0
	set value=""
	for
	{
		set value=$o(^||MD330201("paixu",value),-1)
		quit:value=""
		quit:index=5
		set itemID=""
		for
		{
			set itemID=$o(^||MD330201("paixu",value,itemID))
			quit:itemID=""
			quit:index=5
			set EntryObj=##class(EPRmeta.Quality.QualityEntry).%OpenId(itemID)
		 	continue:'$IsObject(EntryObj)
		 	set PoolDR=EntryObj.PoolDR
		 	set PoolObj=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)
		 	continue:'$IsObject(PoolObj)
		 	set poolName=PoolObj.Title
			s ^||CacheTemp(repid,ind)=$lb(itemID,value,poolName)
	 		s ind=ind+1
	 		s index=index+1
		}
		
	}
	k ^||MD330201
	Quit $$$OK
}

}
