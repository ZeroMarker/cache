/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：ban
/// 编写日期:2012-03-28
/// 
Class DHCWL.MKPIService.MKPIQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMutiMonKPIData",272,"16")

/// Creator：      ban
/// CreatDate：    2012-03-28
/// Description:： 按照区间和指标查找值
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       monIdStr:区间id串,","分隔,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 				  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query QueryMutiMonKPIData(monIdStr As %Text, kpiIdStr As %Text, filterRule As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMutiMonKPIDataExecute(ByRef qHandle As %Binary, monIdStr As %Text, kpiIdStr As %Text, filterRule As %Text = "") As %Status
{
	n (qHandle,monIdStr,kpiIdStr,filterRule)
 //QueryKpiByIdExecute(ByRef qHandle As %Binary, kpiIds As %Text, monthId As %Text, isRealData = "", filterRule As %Text = "") As %Status
	d ..QueryKpiByIdExecute(.qHandle,kpiIdStr,monIdStr,,filterRule)
	Quit $$$OK
}

ClassMethod QueryMutiMonKPIDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMutiMonKPIDataExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMutiMonKPIDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMutiMonKPIDataExecute ]
{
	n (qHandle,Row,AtEnd)
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

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMutiMonKPIDataByGen","2012-09-28","16")

/// Creator：      ban
/// CreatDate：    2012-07-05
/// Description:： 按照区间名称和指标代码查找值
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       monNameStr:区间名称串,","分隔,kpiCodeStr:指标代码串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 				  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总,传入参数为区间的名称,符合自然书写习惯,指标的代码,统一代码,方便报表制作的统一性
Query QueryMutiMonKPIDataByGen(monNameStr As %Text, kpiCodeStr As %Text, filterRule As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMutiMonKPIDataByGenExecute(ByRef qHandle As %Binary, monNameStr As %Text, kpiCodeStr As %Text, filterRule As %Text = "") As %Status
{
	n (qHandle,monNameStr,kpiCodeStr,filterRule)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:monNameStr="" 1
 	q:kpiCodeStr="" 1
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	d ..QueryKpiByIdExecute(.qHandle,kpiCodeStr,monIdStr,,filterRule)
	Quit $$$OK
}

ClassMethod QueryMutiMonKPIDataByGenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMutiMonKPIDataByGenExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryMutiMonKPIDataByGenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMutiMonKPIDataByGenExecute ]
{
	n (qHandle,Row,AtEnd)
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

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKPIDataByMultiDate","2012-09-28","2012-09-28","D","16")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKPIDataByMultiDate","2008-07","2008-09","M","22")

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 按照区间和指标查找值
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       startDate:开始区间,endDate:结束区间,type:区间类型,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 				  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query QueryKPIDataByMultiDate(startDate As %String, endDate As %String, type As %String, kpiIdStr As %Text, filterRule As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryKPIDataByMultiDateExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, kpiIdStr As %Text, filterRule As %Text = "") As %Status
{
	n (qHandle,startDate,endDate,type,kpiIdStr,filterRule)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
 	q:kpiIdStr="" $$$OK	
 	s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	i type="Q"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudQd(startDate,endDate)
	i type="Y"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudYear(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	q:monIdStr="" 1
	q:kpiIdStr="" 1
	d ..QueryKpiByIdExecute(.qHandle,kpiIdStr,monIdStr,,filterRule)
	Quit $$$OK
}

ClassMethod QueryKPIDataByMultiDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryKPIDataByMultiDateExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryKPIDataByMultiDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryKPIDataByMultiDateExecute ]
{
	n (qHandle,Row,AtEnd)
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

// Query QueryMKPIByDate(accessRule As %Text, startDate, endDate, choiceType = "freeDateChoice",mode) As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]

/// creator by lhh
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// 	可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// Input:  kpi:指标id或code；
///         startDate：统计的开始日期,endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02
///         isRealData：R代表为实时数据,非实时数据可以为空;S为汇总数据;C为区间升级模式;
///                     O为按照用户输入取数规则顺序来输出数据;P为支持多段日期查询;E为只输出区间维度属性
///         choiceType: freeDateChoice（任意区间范围）或空、byMonth（按月）、byQua（按季）、byYear（按年）。
/// 						还有torday（今天）、yesterday（昨天）、lastWeek（上周）、lastMonth（上月）、lastYear（去年）等，这些都不需要给定startDate和endDate，只有给出choiceType就可以了
/// 		filterRule: 过滤规则
/// 		dynParam: 模块与报表动态参数的替换，在使用模块或报表保存的过滤规则时，使用该字段保存的特殊字符对应的实际值来替换过滤规则中的特殊字符（详细使用方法见指标文档）
/// 		execParam:每个普通指标都有一个执行代码。执行代码一般有3个参数（数据保存到global的是2个）：开始日期，结束日期，存值数组。
/// 					 在有些情况下，有这3个参数不能满足执行代码取数的要求，所以添加参数execParam来控制执行代码内部的实现过程（详细使用方法见指标文档）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","KP1577:admid.P001^admid.P002^admid.P003^admid.P004^admid.P005^admid.P006^admid.P007^admid.P008^admid.P009^admid.P010^admid.P011^admid.P012^admid.P013^admid.P014^admid.P015^admid.P016^admid.P017^admid.P018^admid.P019^admid.P020^admid.P021^admid.P022^admid.P023^admid.P024^admid.P025^admid.P026^admid.P027^admid.P028","2022-01-01","2022-02-28","freeDateChoice","R")
/// Others：按照区间,指标,维汇总
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","22","2013-11-21","2013-11-21",,,"MRLocRyrs:([[[{Loc}>=20&&{Loc}<=30]&&{Doc}>=130]&&{Doc}<=160])")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","KP1240:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014,KP1241:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014,KP1242:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014,KP1243:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014,KP1244:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014,KP1245:ordLoc.LocDesc^ordLoc.LocHospid^ordDoc^arcimId.P002^arcimId.P024^arcimId.P009^arcimId.P013^arcimId.P014","2022-4-1","2022-5-1","freeDateChoice","C","KP1240:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull),KP1241:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull),KP1242:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull),KP1243:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull),KP1244:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull),KP1245:({ordLoc}EqualIgNull&&{ordLoc.LocHospid}EqualIgNull$hospid&&{ordDoc}EqualIgNull&&{arcimId.P002}=1&&{arcimId.P009}EqualIgNull)","","")
/// 只输出区间维度属性
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","lhcs0617:$D.week","2015-06-26","2015-06-26","freeDateChoice","E")
/// 查询日期可间断
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","lhcs0617","(2015-06-24~2015-06-26),2015-06-29","","freeDateChoice","P")
Query QueryMKPIByDate(kpi As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMKPIByDateExecute(ByRef qHandle As %Binary, kpi As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Status
{
	n (qHandle, startDate,endDate,choiceType,kpi,isRealData,filterRule,dynParam, execParam)
	tro
	s ^TEMPDHCWL("test","ByDate0519")=startDate_"@"_endDate_"@"_choiceType_"@"_kpi_"@"_isRealData_"@"_filterRule_"@"_dynParam
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//记录查询信息
	k ^||TEMPDHCWL("kpiError",$j)
	s gblFlag="G",^||TEMPDHCWL("kpiError",$j,"kpi")=$g(kpi),^||TEMPDHCWL("kpiError",$j,"callFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryMKPIByDate()",^||TEMPDHCWL("kpiError",$j,"paraKpiRule")="kpi："_$g(kpi)_"; choiceType："_$g(choiceType)_"; isRealData："_$g(isRealData)_"; execParam: "_$g(execParam),^||TEMPDHCWL("kpiError",$j,"paraFilterRule")=$g(filterRule),^||TEMPDHCWL("kpiError",$j,"paraDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)	
	
	//Query by dataSet addedby lhh@20140312
	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpi)
	if ($ISOBJECT(datasetObj)) {
		s kpi=datasetObj.DatasetRuleList
		if (filterRule=""){
			s filterRule=datasetObj.DatasetFilterList
		}
		s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
	}
	//解析过滤规则
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	//解析取数规则
	i isRealData=0 s isRealData="H"
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpi,isRealData,.resolve) //firstly resolve the param
 	
 	//解析取数规则：按照取数规则中维度的先后顺序来显示查询结果集。
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpi,.resovledRuleArr,isRealData)
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleMap(.resovledRuleArr,.mapRuleArr)

	i $g(endDate)="" s endDate=$g(startDate)
	//得到monthID串
	//s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(choiceType)) ;实际日期转换成连续的MonthId
	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(choiceType),$g(isRealData)) ;实际日期转换成连续的MonthId
	q:monthId="" $$$OK

	//清除global
	k ^TEMPDHCWLKPIDATA(gblFlag,$j)
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	
	//s st=##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData(monthId,kpi,isRealData,,filterRule)
	//根据取数规则，monthID,取数模式，生成一个数组。数据结构为：aryKpiConMon(kpiID,比对标识,monthid1)=monthid2
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resolve, monthId, "",.aryKpiConMon)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.resolve, monthId, "",.aryKpiConMon,isRealData)
	
	//得到计算指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree)
	//获取指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree,execParam)
	
	//输出指标数据
	d ..Output("",gblFlag,.resolve,.filterTree)


	// Added by JEFF @2013-11-13
	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
	s loginTypeDr=login("LoginTypeDr")
	s kpiID=""
	f {
		s kpiID=$o(aryKpiConMon(kpiID))	
		q:kpiID=""
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiID)
		q:(1'=shouldBeLogged)
		i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiID
		e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiID
	}

	
	
	i $d(login("MKPIIdList")){
	s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryMKPIByDate()"
	s login("Operator")=""
	s login("MKPIIdList")=$g(login("MKPIIdList"))
	s login("ParaKpiRule")="kpi："_kpi_"; choiceType："_$g(choiceType)_"; isRealData："_$g(isRealData)_"; execParam: "_execParam
	s login("ParaFilterRule")=$g(filterRule)
	s login("ParaDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
	s login("ParaOther")=""
	s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
	s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
	s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
	s status=loginService.LoginContent(jsonStr)
	s status=loginService.LoginEnd()
	}
	k ^||TEMPDHCWLKPIDATA("Login",$j)
	// Added by JEFF @2013-11-13
	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j),^||TEMPDHCWL("kpiError",$j)
	Quit $$$OK
}

ClassMethod QueryMKPIByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMKPIByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// creator by lhh
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// Input:  kpiId:指标id或code；monthId指标日期id；isRealData：0或1代表是否为实时数据
/// 可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKpiById","16","854",,"MZDocGhf:([ {RegLoc.Loc}\[ 内科)")
/// Others：按照区间,指标,维汇总
Query QueryKpiById(kpiId As %Text, monthId As %Text, isRealData = "", filterRule As %Text = "", execParam As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryKpiByIdExecute(ByRef qHandle As %Binary, kpiIds As %Text, monthId As %Text, isRealData = "", filterRule As %Text = "", execParam As %Text = "") As %Status
{
	n (qHandle,kpiIds,monthId,isRealData,filterRule,execParam)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(monthId="")||(kpiIds="") 1
 	//Query by dataSet addedby lhh@20140312
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpiIds)
 	if ($ISOBJECT(datasetObj)) {
		 s kpiIds=datasetObj.DatasetRuleList
 	}
 	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
 	;若传过来的为code则转换kpiCode到kpiId
 	;s firstKPI=$p(kpiIds,",",1)	//修改kpi是id还是code的判断规则，取第一个分隔，判断在主索引中是否存在。edit by ban@201300206
 	;i '$d(^DHCWL.MKPI.MKPID(firstKPI)) s kpiIds=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiIds)
 	k ^TEMPDHCWLKPIDATA("G",$j)
 	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiIds,,.resolve) //firstly resolve the param
	s st=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monthId,kpiIds,isRealData,,filterRule,execParam)
 	q:st'=1 $$$OK 
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.i monId=0 s monCode="",monDesc=""
 	.e  s monCode=$li(^DHCWL.MKPI.MonthsD(monId),5),monDesc=$li(^DHCWL.MKPI.MonthsD(monId),3) 
 	.s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId)) q:kpiId=""  d
 	..s ^TEMPDHCWLKPIDATA("Login",$j,kpiId)=""		;Added by JEFF @2013-11-13
 	..i monId=0 d
 	...s monDesc="",monCode=""
 	..e  d
 	...if $d(resolve("KPISECPRO",kpiId)) d
 	....s monDesc=""
 	....s secResProValue="",monCode=$li(^DHCWL.MKPI.MonthsD(monId),5)
 	....s secProId="" f  s secProId=$o(resolve("KPISECPRO",kpiId,secProId)) q:secProId=""  d
 	.....s secId=$o(resolve("KPISECPRO",kpiId,secProId,""))
	.....i secProId=0 d
 	......s monDesc=$li(^DHCWL.MKPI.MonthsD(monId),3),monCode=$li(^DHCWL.MKPI.MonthsD(monId),5)
 	.....e  d
 	......s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
 	......q:proExcStr=""
 	......s proExcStr="s secResProValue=$$"_proExcStr_"("""_monId_""")"
 	......x proExcStr
 	.....i $g(monDesc)="" s monDesc=secResProValue
 	.....e  s:secResProValue'="" monDesc=monDesc_","_secResProValue
 	...e  s monDesc=$li(^DHCWL.MKPI.MonthsD(monId),3),monCode=$li(^DHCWL.MKPI.MonthsD(monId),5)
 	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2),kpiDes=$lg(^DHCWL.MKPI.MKPID(kpiId),3)
 	..s locId="" f  s locId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,locId)) q:locId=""  d
 	...s pos=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,locId,""))
 	...s locDes=##class(DHCWL.MKPIService.SetKPIData).ResolveDim(kpiId,pos,.resolve,locId,.proValueArr) ;##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,locId)
 	...s value=^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,locId)
 	...//resolved dimValue combo
 	...i $d(proValueArr("OK"))'=0 d
 	....s deliInd="" f  s deliInd=$o(proValueArr("OK",deliInd)) q:deliInd=""  d
 	.....s oneCombineResult=""
 	.....s order="" f  s order=$o(proValueArr("OK",deliInd,order)) q:order=""  d
 	......s $p(locDes,",",order)=proValueArr("OK",deliInd,order)
 	......s $p(oneCombineResult,",",order)=proValueArr("OK",deliInd,order)
 	.....i ('$d(filterTree(kpiCode))) d outputRowId
 	.....else  d
 	......s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.......q:+filterInd=0
 	.......;老query在分隔后不再支持进一步对分隔后数据的过滤
 	.......if (1||(##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",oneCombineResult,filterTree(kpiCode,filterInd),1))) d
 	........d outputRowId
 	...e  d outputRowId
 	
 	// Added by JEFF @2013-11-13
 	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 	s loginTypeDr=login("LoginTypeDr")
 	s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("Login",$j,kpiId)) q:kpiId=""  d
 	.s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiId)
 	.q:(1'=shouldBeLogged)
 	.i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiId
 	.e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiId
	
	i $d(login("MKPIIdList")){
 		s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryKpiById()"
		
		//add by wz.2014-12-23
		s loginOperator=""
 		i $d(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator")) s loginOperator=$g(^TEMPDHCWLKPIDATA("Login-OtherInfos",$j,"Operator"))
 		s login("Operator")=loginOperator

 		s login("MKPIIdList")=$g(login("MKPIIdList"))
 		s login("ParaKpiRule")="isRealData："_$g(isRealData)
 		s login("ParaFilterRule")=$g(filterRule)
 		s login("ParaDateScope")=""
 		s login("ParaOther")="monthId："_$g(monthId)
 
 		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
	}
 	k ^TEMPDHCWLKPIDATA("Login",$j)
 	// Added by JEFF @2013-11-13
 	
 	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit $$$OK
outputRowId 
	s row=$listbuild(monId,monDesc,kpiId,kpiCode,kpiDes,locId,locDes,value)
	s ^CacheTemp(repid,ind)=row
 	s ind=ind+1
	q
}

ClassMethod QueryKpiByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryKpiByIdExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryKpiByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryKpiByIdExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// creator by lhh
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// 	可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// Input:  kpi:          指标id或code；
///         startDate：   统计的开始日期,endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02
///         mode：        R代表为实时数据,非实时数据可以为空;S为汇总数据;C为区间升级模式;
///                          O为按照用户输入取数规则顺序来输出数据;P为支持多段日期查询;E为只输出区间维度属性
///         dateType:  	  空、byMonth（按月）、byQua（按季）、byYear（按年）。
/// 						     还有torday（今天）、yesterday（昨天）、lastWeek（上周）、lastMonth（上月）、lastYear（去年）等，这些都不需要给定startDate和endDate，只有给出choiceType就可以了
/// 		contractType: 规定了如何获取该日期相对应的日期下的指标数据，例如目前日期为2013-9-6则上期是2013-9-5，同期是2012-9-6；2013-9上期是2013-8，同期是2012-9等等。指标实现中目前支持的日期对比规则包括：PP，SL等
/// 		filterRule:   过滤规则
/// 		dynParam:     模块与报表动态参数的替换，在使用模块或报表保存的过滤规则时，使用该字段保存的特殊字符对应的实际值来替换过滤规则中的特殊字符（详细使用方法见指标文档）
/// 		execParam:    每个普通指标都有一个执行代码。执行代码一般有3个参数（数据保存到global的是2个）：开始日期，结束日期，存值数组。
/// 					         在有些情况下，有这3个参数不能满足执行代码取数的要求，所以添加参数execParam来控制执行代码内部的实现过程（详细使用方法见指标文档）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKpiWithContract","3508","2015-06-25","2015-06-25","freeDateChoice","R",,"test1026:([{PatDoc.Doc} = 毛羽])")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKpiWithContract","16:Doc.Doc,16:Dep","2012-11-10","2012-11-10",,,"PP")
/// 只显示区间维度属性
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKpiWithContract","lhcs0617:$D.week","2015-06-26","2015-06-26","","E")
/// 多时间段数据查询
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryKpiWithContract","lhcs0617:$D.week","(2015-06-24~2015-06-26),2015-06-29","","","P")
Query QueryKpiWithContract(kpi As %Text, startDate As %String, endDate As %String, dateType As %String = "", mode = "", contractType As %String = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Query(ROWSPEC = "monthId:%String,contractTye:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryKpiWithContractExecute(ByRef qHandle As %Binary, kpi As %Text, startDate As %String, endDate As %String, dateType As %String = "", mode = "", contractType As %String = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Status
{
	n (qHandle,kpi,startDate,endDate,dateType,mode,contractType,filterRule,dynParam,execParam)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Query by dataSet addedby lhh@20140312
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpi)
 	if ($ISOBJECT(datasetObj)) {
		 s kpi=datasetObj.DatasetRuleList
 		 if (filterRule=""){
		 s filterRule=datasetObj.DatasetFilterList
		 }
	     s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
	}
	
	//记录查询信息
	k ^||TEMPDHCWL("kpiError",$j)
	s ^||TEMPDHCWL("kpiError",$j,"kpi")=$g(kpi),^||TEMPDHCWL("kpiError",$j,"callFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryKpiWithContract()",^||TEMPDHCWL("kpiError",$j,"paraKpiRule")="kpi："_$g(kpi)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; execParam: "_$g(execParam)_"; contractType: "_$g(contractType),^||TEMPDHCWL("kpiError",$j,"paraFilterRule")=$g(filterRule),^||TEMPDHCWL("kpiError",$j,"paraDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
	
	//解析过滤规则
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	//解析取数规则
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpi,mode,.resolve) //firstly resolve the param
 	
 	//解析取数规则：按照取数规则中维度的先后顺序来显示查询结果集。
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpi,.resovledRuleArr,mode)
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleMap(.resovledRuleArr,.mapRuleArr)

	//得到monthID串,支持间断时间的查询，但是不支持间断时间的同期、上期查询
	i $g(endDate)="" s endDate=$g(startDate)
	//s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType)) ;实际日期转换成连续的MonthId
	q:(mode["P")&((contractType["PP")||(contractType["SL")) $$$OK
	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(dateType),$g(mode)) ;实际日期转换成连续的MonthId
	q:monthId="" $$$OK

	s gblFlag="G"
	//清除global
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j),^TEMPDHCWLKPIDATA(gblFlag,$j)
	
	//s st=##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData(monthId,kpi,isRealData,,filterRule)
	//根据取数规则，monthID,取数模式，生成一个数组。数据结构为：aryKpiConMon(kpiID,比对标识,monthid1)=monthid2
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resolve, monthId,contractType,.aryKpiConMon)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.resolve, monthId,contractType,.aryKpiConMon,mode)

	//得到计算指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree)
	
	//获取指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree,execParam)

	//输出指标数据
	d ..Output(.aryKpiConMon,gblFlag,.resolve,.filterTree,"isConTypeMethod")

 	// Added by JEFF @2013-11-13
 	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 	s loginTypeDr=login("LoginTypeDr")
	s kpiID=""
	f {
		s kpiID=$o(aryKpiConMon(kpiID))	
		q:kpiID=""
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiID)
		q:(1'=shouldBeLogged)
		i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiID
		e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiID
	}
 	
 	i $d(login("MKPIIdList")){
 		s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 		s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryKpiWithContract()"
 		s login("Operator")=""
 		s login("MKPIIdList")=$g(login("MKPIIdList"))
 		s login("ParaKpiRule")="kpi："_$g(kpi)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; contractType："_$g(contractType)_"; execParam: "_execParam
 		s login("ParaFilterRule")=$g(filterRule)
 		s login("ParaDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 		;s login("ParaOther")="monthId："_$g(monthId)
 		s login("ParaOther")=""
 		
 		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
 
 	k ^||TEMPDHCWLKPIDATA("Login",$j),^||TEMPDHCWL("kpiError",$j)
 	
 	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
 	Quit $$$OK
}

ClassMethod QueryKpiWithContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryKpiWithContractExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryKpiWithContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryKpiWithContractExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// creator：wk
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// 	可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// Input:  kpi:          指标id或code；
///         startDate：   统计的开始日期,endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02
///         mode：        R代表为实时数据,非实时数据可以为空;S为汇总数据;C为区间升级模式;
///                          O为按照用户输入取数规则顺序来输出数据;P为支持多段日期查询
///         dateType:  	  空、byMonth（按月）、byQua（按季）、byYear（按年）。
/// 						     还有torday（今天）、yesterday（昨天）、lastWeek（上周）、lastMonth（上月）、lastYear（去年）等，这些都不需要给定startDate和endDate，只有给出choiceType就可以了
/// 		contractType: 规定了如何获取该日期相对应的日期下的指标数据，例如目前日期为2013-9-6则上期是2013-9-5，同期是2012-9-6；2013-9上期是2013-8，同期是2012-9等等。指标实现中目前支持的日期对比规则包括：PP，SL等
/// 		filterRule:   过滤规则
/// 		dynParam:     模块与报表动态参数的替换，在使用模块或报表保存的过滤规则时，使用该字段保存的特殊字符对应的实际值来替换过滤规则中的特殊字符（详细使用方法见指标文档）
/// 		execParam:    每个普通指标都有一个执行代码。执行代码一般有3个参数（数据保存到global的是2个）：开始日期，结束日期，存值数组。
/// 					         在有些情况下，有这3个参数不能满足执行代码取数的要求，所以添加参数execParam来控制执行代码内部的实现过程（详细使用方法见指标文档）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewQueryKpiWithContract","16:Doc.Doc,16:Dep","2012-11-10","2012-11-10",,,"PP")
/// 多时间段数据查询
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewQueryKpiWithContract","lhcs0617:$D.week","(2015-06-24~2015-06-26),2015-06-29","","","P")
Query NewQueryKpiWithContract(kpi As %Text, startDate As %String, endDate As %String, dateType As %String = "", mode = "", contractType As %String = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Query(ROWSPEC = "monthId:%String,contractTye:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod NewQueryKpiWithContractExecute(ByRef qHandle As %Binary, kpi As %Text, startDate As %String, endDate As %String, dateType As %String = "", mode = "", contractType As %String = "", filterRule As %Text = "", dynParam As %Text = "", execParam As %Text = "") As %Status
{
	n (qHandle,kpi,startDate,endDate,dateType,mode,contractType,filterRule,dynParam,execParam)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//删除global数据
 	k ^||TEMPDHCWLMKPI("SUM",$j)
	//记录查询信息
	k ^||TEMPDHCWL("kpiError",$j)
	s ^||TEMPDHCWL("kpiError",$j,"kpi")=$g(kpi),^||TEMPDHCWL("kpiError",$j,"callFunction")="class(DHCWL.MKPIService.MKPIQuery).NewQueryKpiWithContract()",^||TEMPDHCWL("kpiError",$j,"paraKpiRule")="kpi："_$g(kpi)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; execParam: "_$g(execParam)_"; contractType: "_$g(contractType),^||TEMPDHCWL("kpiError",$j,"paraFilterRule")=$g(filterRule),^||TEMPDHCWL("kpiError",$j,"paraDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 	
 	//Query by dataSet addedby lhh@20140312
 	s $ET="d ##class(DHCWL.MKPIService.SetKPIData).RunError()"
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpi)
 	if ($ISOBJECT(datasetObj)) {
		 s kpi=datasetObj.DatasetRuleList
 		 if (filterRule=""){
		 	s filterRule=datasetObj.DatasetFilterList
		 }
 	}
 	 s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
 	//提前获取取数规则各个属性位置
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition(kpi,.resolveKpiRuleMap)
	
	//解析过滤规则
	;d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	
	//解析取数规则
	if '(mode [ "E") s mode=mode_"E"
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpi,mode,.resolve) //firstly resolve the param
 	
 	//得到monthID串
	i $g(endDate)="" s endDate=$g(startDate)
	//s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType)) ;实际日期转换成连续的MonthId
	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(dateType),$g(mode)) ;实际日期转换成连续的MonthId
	q:monthId="" $$$OK
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resolve, monthId,contractType,.aryKpiConMon)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.resolve, monthId,contractType,.aryKpiConMon,mode)
	
	//将信息放入list传入数据处理方法
	;s kpi=##class(DHCWL.MKPIService.MKPIQuery).HandleKpiRule(.resolveKpiRuleMap,kpi,contractType)
	s parameters("startDate")=startDate
	s parameters("endDate")=endDate
	s parameters("dateType")=dateType
	s parameters("queryRule")=kpi
	s parameters("filterRule")=filterRule
	s parameters("queryModel")=mode
	s parameters("contract")=contractType
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).majorKpiDimGlobalData(.parameters,execParam)
	
	//将指标数据处理后放入数据集
	d ..OutPutData(.resolveKpiRuleMap,.resolve,mode,repid,ind)

 	// Added by JEFF @2013-11-13
 	s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 	s loginTypeDr=login("LoginTypeDr")
	s kpiID=""
	f {
		s kpiID=$o(aryKpiConMon(kpiID))	
		q:kpiID=""
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiID)
		q:(1'=shouldBeLogged)
		i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiID
		e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiID
	}
 	
 	i $d(login("MKPIIdList")){
 		s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 		s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryMKPIWithContract()"
 		s login("Operator")=""
 		s login("MKPIIdList")=$g(login("MKPIIdList"))
 		s login("ParaKpiRule")="kpi："_$g(kpi)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; contractType："_$g(contractType)_"; execParam: "_execParam
 		s login("ParaFilterRule")=$g(filterRule)
 		s login("ParaDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 		;s login("ParaOther")="monthId："_$g(monthId)
 		s login("ParaOther")=""
 		
 		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
 
 	k ^||TEMPDHCWLKPIDATA("Login",$j),^||TEMPDHCWL("kpiError",$j)
 	// Added by JEFF @2013-11-13
 	
 	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^||TEMPDHCWLMKPI("SUMKPIDIM",$j)
 	Quit $$$OK
}

ClassMethod NewQueryKpiWithContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryKpiWithContractExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQueryKpiWithContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryKpiWithContractExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// creator by lhh
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// 	可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// Input:  kpiRule:      指标id或code；
///         startDate：   统计的开始日期,endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02
///         mode：        R代表为实时数据,非实时数据可以为空;S为汇总数据;C为区间升级模式;
///                          O为按照用户输入取数规则顺序来输出数据;P为支持多段日期查询;E为只输出区间维度属性
///         dateType:  	  空、byMonth（按月）、byQua（按季）、byYear（按年）。
/// 						     还有torday（今天）、yesterday（昨天）、lastWeek（上周）、lastMonth（上月）、lastYear（去年）等，这些都不需要给定startDate和endDate，只有给出choiceType就可以了
/// 		contract:     规定了如何获取该日期相对应的日期下的指标数据，例如目前日期为2013-9-6则上期是2013-9-5，同期是2012-9-6；2013-9上期是2013-8，同期是2012-9等等。指标实现中目前支持的日期对比规则包括：PP，SL等
/// 		filterRule:   过滤规则
/// 		dynParam:     模块与报表动态参数的替换，在使用模块或报表保存的过滤规则时，使用该字段保存的特殊字符对应的实际值来替换过滤规则中的特殊字符（详细使用方法见指标文档）
/// 		execParam:    每个普通指标都有一个执行代码。执行代码一般有3个参数（数据保存到global的是2个）：开始日期，结束日期，存值数组。
/// 					         在有些情况下，有这3个参数不能满足执行代码取数的要求，所以添加参数execParam来控制执行代码内部的实现过程（详细使用方法见指标文档）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2012-11-3","2012-11-3",,"MZDocGhf,MZDocZcf","MZDocGhf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc}\[ 内科),MZDocZcf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc} \[ 内科)",,"PP")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2012-11-1","2012-11-1",,"MZDocGhf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode,MZDocZcf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode","MZDocGhf:( {RegLoc} =137,242,203),MZDocZcf:(  {RegLoc} =137,242,203)")     "MZDocGhf:([[ [{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家] ]] || [ {RegType.Des} \[专家] ),MZDocZcf:([[[{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家]]] || [ {RegType.Des} \[专家])",,"PP")
/// 只显示区间维度属性
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","2015-06-26","2015-06-26",,"lhcs0617:$D.week",,"E")
/// 多时间段数据查询
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","KpiQueryGrideShow","(2015-06-24~2015-06-26),2015-06-29","",,"lhcs0617:$D.week",,"P")
Query KpiQueryGrideShow(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Query(ROWSPEC = "kpi:%String,contractTye:%String,month:%String,monthCol2:%String,monthCol3:%String,monthCol4:%String,monthCol5:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod KpiQueryGrideShowExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Status
{

 	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//tro	
	s KPIINFOMAXCOL=1,MAXMONTHCOL=5,MAXDIMDESCOL=16,MAXDIMIDCOL=16,MAXKPIVALCOL=30,MONDELI=";",KPIDELI=";"
	s secStartInd=KPIINFOMAXCOL+1,dimIdStartInd=secStartInd+MAXMONTHCOL,dimDesStartInd=dimIdStartInd+MAXDIMIDCOL,kpiValueStartInd=dimDesStartInd+MAXDIMDESCOL

	s ^TEMPDHCWL("wk","test1")=startDate_"^"_endDate_"^"_dateType_"^"_kpiRule_"^"_filterRule_"^"_mode_"^"_contract_"^"_dynParam_"^"_execParam
	
 	//Query by dataSet addedby lhh@20140312
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpiRule)
 	if ($ISOBJECT(datasetObj)) {
		 s kpiRule=datasetObj.DatasetRuleList
 		 if (filterRule=""){
		 	s filterRule=datasetObj.DatasetFilterList
		 }
		 s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
	}
	//记录查询信息
	k ^||TEMPDHCWL("kpiError",$j)
	s ^||TEMPDHCWL("kpiError",$j,"kpi")=$g(kpiRule),^||TEMPDHCWL("kpiError",$j,"callFunction")="class(DHCWL.MKPIService.MKPIQuery).KpiQueryGrideShow()",^||TEMPDHCWL("kpiError",$j,"paraKpiRule")="kpi："_$g(kpiRule)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; execParam: "_$g(execParam)_"; contractType: "_$g(contract),^||TEMPDHCWL("kpiError",$j,"paraFilterRule")=$g(filterRule),^||TEMPDHCWL("kpiError",$j,"paraDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)

	//解析过滤规则
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	//解析取数规则
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resolve) //firstly resolve the param
 	
 	//解析取数规则：按照取数规则中维度的先后顺序来显示查询结果集。
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule,.resovledRuleArr,mode)

 	//将日期装换为相应的monthId
 	i $g(endDate)="" s endDate=$g(startDate)
 	//s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(dateType),$g(mode)) ;实际日期转换成连续的MonthId
 	q:monthId="" $$$OK
	
	s gblFlag="TEMPKPIDATA"
	//清除global
	k ^TEMPDHCWLKPIDATA(gblFlag,$j)
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	
	//根据取数规则，monthID,取数模式，生成一个数组。数据结构为：aryKpiConMon(kpiID,比对标识,monthid1)=monthid2
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resolve, monthId,contract,.aryKpiConMon)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.resolve, monthId,contract,.aryKpiConMon,mode)

	//获取指标数据
	d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree)
    d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree,execParam)
	
	k ^||TEMPDHCWLKPIDATA("G",$j)
	//把数据由^TEMPDHCWLKPIDATA("TEMPKPIDATA")节点转换到^TEMPDHCWLKPIDATA("G"),并交换kpiID和dimIDs的节点位置
	d ..ExchangeNodePos()
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	s gblFlag="G"
	
	//解析维度、维度属性以及区间维度属性
	d ..AdjustOutputPos(.resovledRuleArr)
	
	//将数据记录处理后放入数据集
	d ..OutputGrid(MAXKPIVALCOL)
	
	
 	// Added by JEFF @2013-11-13
	s kpiID=""
	f {
		s kpiID=$o(aryKpiConMon(kpiID))	
		q:kpiID=""
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiID)
		q:(1'=shouldBeLogged)
		i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiID
		e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiID
	}
 	
 	i $d(login("MKPIIdList")){
 		s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 		s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).KpiQueryGrideShow()"
 		s login("Operator")=""
 		s login("MKPIIdList")=$g(login("MKPIIdList"))
 		s login("ParaKpiRule")="kpi："_$g(kpiRule)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; contractType："_$g(contract)_"; execParam: "_execParam
 		s login("ParaFilterRule")=$g(filterRule)
 		s login("ParaDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 		;s login("ParaOther")="monthId："_$g(monthId)
 		s login("ParaOther")=""
 		
 		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
 
 	k ^TEMPDHCWLKPIDATA("Login",$j)
 	
 	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)	
	
	Quit $$$OK
}

ClassMethod KpiQueryGrideShowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KpiQueryGrideShowExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod KpiQueryGrideShowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KpiQueryGrideShowExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// creator by wk
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// 	可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// Input:  kpiRule:      指标id或code；
///         startDate：   统计的开始日期,endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02
///         mode：        R代表为实时数据,非实时数据可以为空;S为汇总数据;C为区间升级模式;
///                          O为按照用户输入取数规则顺序来输出数据;P为支持多段日期查询
///         dateType:  	  空、byMonth（按月）、byQua（按季）、byYear（按年）。
/// 						     还有torday（今天）、yesterday（昨天）、lastWeek（上周）、lastMonth（上月）、lastYear（去年）等，这些都不需要给定startDate和endDate，只有给出choiceType就可以了
/// 		contract: 	  规定了如何获取该日期相对应的日期下的指标数据，例如目前日期为2013-9-6则上期是2013-9-5，同期是2012-9-6；2013-9上期是2013-8，同期是2012-9等等。指标实现中目前支持的日期对比规则包括：PP，SL等
/// 		filterRule:   过滤规则
/// 		dynParam:     模块与报表动态参数的替换，在使用模块或报表保存的过滤规则时，使用该字段保存的特殊字符对应的实际值来替换过滤规则中的特殊字符（详细使用方法见指标文档）
/// 		execParam:    每个普通指标都有一个执行代码。执行代码一般有3个参数（数据保存到global的是2个）：开始日期，结束日期，存值数组。
/// 					         在有些情况下，有这3个参数不能满足执行代码取数的要求，所以添加参数execParam来控制执行代码内部的实现过程（详细使用方法见指标文档）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewKpiQueryGrideShow","2012-11-3","2012-11-3",,"MZDocGhf,MZDocZcf","MZDocGhf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc}\[ 内科),MZDocZcf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc} \[ 内科)",,"PP")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewKpiQueryGrideShow","2012-11-1","2012-11-1",,"MZDocGhf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode,MZDocZcf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode","MZDocGhf:( {RegLoc} =137,242,203),MZDocZcf:(  {RegLoc} =137,242,203)")     "MZDocGhf:([[ [{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家] ]] || [ {RegType.Des} \[专家] ),MZDocZcf:([[[{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家]]] || [ {RegType.Des} \[专家])",,"PP")
/// 多时间段数据查询
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewKpiQueryGrideShow","(2015-06-24~2015-06-26),2015-06-29","",,"lhcs0617:$D.week",,"P")
Query NewKpiQueryGrideShow(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Query(ROWSPEC = "kpi:%String,contractTye:%String,month:%String,monthCol2:%String,monthCol3:%String,monthCol4:%String,monthCol5:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod NewKpiQueryGrideShowExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Status
{

 	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//清空global数据
 	k ^||TEMPDHCWLMKPI("SUM",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	k ^||TEMPDHCWL("kpiError",$j)
	s ^||TEMPDHCWL("kpiError",$j,"kpi")=$g(kpiRule),^||TEMPDHCWL("kpiError",$j,"callFunction")="class(DHCWL.MKPIService.MKPIQuery).NewKpiQueryGrideShowExecute()",^||TEMPDHCWL("kpiError",$j,"paraKpiRule")="kpi："_$g(kpiRule)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; execParam: "_$g(execParam)_"; contractType: "_$g(contractType),^||TEMPDHCWL("kpiError",$j,"paraFilterRule")=$g(filterRule),^||TEMPDHCWL("kpiError",$j,"paraDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 		
	s KPIINFOMAXCOL=1,MAXMONTHCOL=5,MAXDIMDESCOL=16,MAXDIMIDCOL=16,MAXKPIVALCOL=30,MONDELI=";",KPIDELI=";"
	s secStartInd=KPIINFOMAXCOL+1,dimIdStartInd=secStartInd+MAXMONTHCOL,dimDesStartInd=dimIdStartInd+MAXDIMIDCOL,kpiValueStartInd=dimDesStartInd+MAXDIMDESCOL

 	//Query by dataSet addedby lhh@20140312
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpiRule)
 	if ($ISOBJECT(datasetObj)) {
		 s kpiRule=datasetObj.DatasetRuleList
 		 if (filterRule=""){
		 	s filterRule=datasetObj.DatasetFilterList
		 }
	}
	s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
	//根据日期获取相应monthId
	k resolveRule,aryKpiRuleMon,resolveRuleMap,resovledRuleArr
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(dateType),$g(mode)) ;实际日期转换成连续的MonthId
 	q:monthId="" $$$OK
 	
 	//解析取数规则
 	if '(mode [ "E") s mode=mode_"E"
 	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resolveRule)
 	
 	//将monthID解析后放入list
 	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.resolveRule, monthId,contract,.aryKpiConMon,mode)
	
	//解析指标取数规则各个属性的位置
 	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition(kpiRule,.resolveRuleMap)
 	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule,.resovledRuleArr,mode)
 	//d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPositionForNewQuery(kpiRule,.resovledRuleArr)
	
	//将信息放入list，传入指标数据处理函数
	s parameters("startDate")=startDate
	s parameters("endDate")=endDate
	s parameters("dateType")=dateType
	s parameters("queryRule")=kpiRule
	s parameters("filterRule")=filterRule
	s parameters("queryModel")=mode
	s parameters("contract")=contract
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).majorKpiDimGlobalData(.parameters,execParam)
	
	//更换global的节点
	d ..ExchangeGlobal(.resolveRuleMap,.resovledRuleArr)
	
	//将指标数据放入Query数据集
	d ..OutputGrid(MAXKPIVALCOL)
	
	s kpiID=""
	f {
		s kpiID=$o(aryKpiRuleMon(kpiID))	
		q:kpiID=""
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDataQuery",kpiID)
		q:(1'=shouldBeLogged)
		i '$d(login("MKPIIdList")) s login("MKPIIdList")=kpiID
		e  s login("MKPIIdList")=login("MKPIIdList")_","_kpiID
	}
 	
 	i $d(login("MKPIIdList")){
 		s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 		s login("CalledFunction")="class(DHCWL.MKPIService.MKPIQuery).QueryMKPIGrideShow()"
 		s login("Operator")=""
 		s login("MKPIIdList")=$g(login("MKPIIdList"))
 		s login("ParaKpiRule")="kpi："_$g(kpiRule)_"; dateType："_$g(dateType)_"; mode："_$g(mode)_"; contractType："_$g(contract)_"; execParam: "_execParam
 		s login("ParaFilterRule")=$g(filterRule)
 		s login("ParaDateScope")="fromDate："_$g(startDate)_"; toDate："_$g(endDate)
 		;s login("ParaOther")="monthId："_$g(monthId)
 		s login("ParaOther")=""
 		
 		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
 		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
 		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
 		s status=loginService.LoginContent(jsonStr)
 		s status=loginService.LoginEnd()
 	}
 
 	k ^||TEMPDHCWLKPIDATA("Login",$j),^||TEMPDHCWL("kpiError",$j)
 	
 	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^||TEMPDHCWLMKPI("SUMKPIDIM",$j)	
	
	Quit $$$OK
}

ClassMethod NewKpiQueryGrideShowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KpiQueryGrideShowExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewKpiQueryGrideShowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KpiQueryGrideShowExecute ]
{
	n (AtEnd,qHandle,Row)
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

ClassMethod HandleKpiRule(ByRef HandleSecMap, kpiRules, contractType, queryModle)
{
	n (HandleSecMap,kpiRules,contractType,queryModle)
	k sectionCodeList
	s sectionId=""
	for{
		s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
		q:sectionId=""
		s sectionCode=""
		s sectionCode=$lg(^DHCWL.MKPI.SectionD(sectionId),2,"")
		s sectionCodeList(sectionCode)=""
	}
	q:kpiRules="" ""
	q:(contractType="")&&((queryModle["S")'=1) kpiRules
	s kpiRuleLen=$l(kpiRules,",")
	for i=1:1:kpiRuleLen{
		s sign=0
		s kpiRule=$p(kpiRules,",",i)
		continue:kpiRule=""
		s kpiId=$p(kpiRule,":",1)
		s kpiProRules=$p(kpiRule,":",2)
		continue:kpiProRules=""
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
		continue:kpiCode=""
		if ($d(HandleSecMap(kpiCode,"DimPro-Sec"))=0){
			continue
		}
		s pos=""
		s sectionInfor=""
		for{
			s pos=$o(HandleSecMap(kpiCode,"DimPro-Sec",pos))
			q:pos=""
			s sectionCode=""
			s sectionCode=$o(HandleSecMap(kpiCode,"DimPro-Sec",pos,sectionCode))
			if (sectionInfor=""){
				s sectionInfor=sectionCode
			}
			if ($d(sectionCodeList(sectionCode))=1){
				s sign=1
				q
			}
		}
		if sign=0{
			s secCode=$p(sectionInfor,".",1)
			s kpiRule=kpiRule_"^"_"$"_secCode
			s $p(kpiRules,",",i)=kpiRule
		}	
		}
		q kpiRules
}

ClassMethod ExchangeGlobal(ByRef resolveRuleMap, ByRef resovledRuleArr)
{
	n (resolveRuleMap,resovledRuleArr)
	k ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
	k DimPosList
	k sectionCodeList
	k datePosList
	s sectionId=""
	for{
		s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
		q:sectionId=""
		s sectionCode=""
		s sectionCode=$lg(^DHCWL.MKPI.SectionD(sectionId),2,"")
		s sectionCodeList(sectionCode)=""
	} 
	s kpiCode=""
	for{
		s kpiCode=$o(resolveRuleMap(kpiCode))
		q:kpiCode=""
		s sectionDimPos=""
		for{
			s sectionDimPos=$o(resolveRuleMap(kpiCode,"DimPro",sectionDimPos))
			q:sectionDimPos=""
			s kpiDim=$o(resolveRuleMap(kpiCode,"DimPro",sectionDimPos,""))
			s dimArray=resolveRuleMap(kpiCode,"DimPro",sectionDimPos,kpiDim)
			s kpiDimId=$p(dimArray,"^",1)
			s dimProId=$p(dimArray,"^",2)
			;s dimOrder=$p(dimArray,"^",3)
			s DimPosList(kpiDimId,dimProId)=sectionDimPos
		}
	}
	s kpiCode=""
	for{
		s number=1
		s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
		q:kpiCode=""
		s dataTops=""
		if ($d(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR"))=0){
			continue
		}
		s dataTops=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")
		for{
			s dataTop=$lg(dataTops,number)
			q:dataTop=""
			if ($d(sectionCodeList(dataTop))=1){
				s datePosList(kpiCode)=number
				q
			}
			s number=number+1
		}
		
	}
	s kpiCode=""
	//s sectionList=$lb()
	s dimResolveList=$lb()
	s dimOrgList=$lb()
	//s sign=1
	for{
		s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
		q:kpiCode=""
		//modify by wk~20170321~数据以ID区分
		//s dimList=""
		//for{
			//s dimList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimList))
			//q:dimList=""
			//s origDimList=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimList,"IDS")
			//s contractFlag=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimList,"ISC")
			//s value=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimList)
		s origDimList=""
		for{
			s origDimList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",origDimList))
			q:origDimList=""
			s dimList=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",origDimList,"IDS")
			s contractFlag=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",origDimList,"ISC")
			s value=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",origDimList)
			s pos=$g(datePosList(kpiCode))
			if (pos=""){
				s date=""
			}else{
				s date=$lg(dimList,pos,"")
			}
			//s $li(sectionList,1)=date
			s sectionList=$lb(date,,,,)
			s num=2
			s sectionDimPos=""
			for{
				s sectionDimPos=$o(resolveRuleMap(kpiCode,"DimPro-Sec",sectionDimPos))
				q:sectionDimPos=""
				s sectionDim=""
				s sectionDim=$o(resolveRuleMap(kpiCode,"DimPro-Sec",sectionDimPos,sectionDim))
				if ($d(sectionCodeList(sectionDim))=1){
					s monthId=$lg(origDimList,sectionDimPos,"")
					if (monthId=0){
						s sectionInfor=""
					}else{
						s sectionInfor=$li(^DHCWL.MKPI.MonthsD(monthId),3)
					}
				}else{
					s sectionInfor=$lg(dimList,sectionDimPos,"")
				}
				s $li(sectionList,num)=sectionInfor
				s num=num+1
			}
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			s dimPos1=""
			s dimResolveList=""
			s dimOrgList=""
			//s num1=1
			for{
				s dimPos1=$o(resovledRuleArr("COL",kpiId,dimPos1))
				q:dimPos1=""
				s proId=$o(resovledRuleArr("COL",kpiId,dimPos1,""))
	 			s kpiDimId=resovledRuleArr("COL",kpiId,dimPos1,proId)
	            s dimPos=DimPosList(kpiDimId,proId)
				s dimInfor=$lg(dimList,dimPos)
				s dimOrgInfor=$lg(origDimList,dimPos)
				s $li(dimResolveList,dimPos1)=dimInfor
				s $li(dimOrgList,dimPos1)=dimOrgInfor
				//s num1=num1+1
			}
			//s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			if (contractFlag="STDT"){
				s contractCode=""
			}else{
				;s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
				s contractCode=contractFlag
			}
			if ((dimOrgList="")&(dimResolveList="")){
				s $li(dimOrgList,1)=""
				s $li(dimResolveList,1)=""
			}
			s sign=$g(resovledRuleArr("COL",kpiId))
			if (sign=""){
				s sign=$g(resovledRuleArr("COLSEC",kpiId))
			}
			s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,sectionList)=contractCode
			//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,sectionList,dimResolveList,kpiId)=value
			//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,sectionList,dimResolveList,kpiId,sign)=dimOrgList
			s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,sectionList,dimOrgList,kpiId)=value
			s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,sectionList,dimOrgList,kpiId,sign)=dimResolveList
			//s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,
		}
		//s sign=sign+1
	}
	k ^||TEMPDHCWLMKPI("SUM",$j)
}

/// s tab=##class(DHCWL.MKPIService.MKPIQuery).QueryKpiObjByDate("2013-10-2","2013-10-3","","K0005:CTLOC.LocDesc As alias1,K0008:CTLOC.LocDesc As alias1","","S")
ClassMethod QueryKpiObjByDate(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", execParam As %Text = "") As %ListOfObjects
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,execParam)
	s MONDELI=";",KPIDELI=";"
	//s contract = ""
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resovled)

 	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition2(kpiRule,.resovledRuleArr)
 	i $g(endDate)="" s endDate=$g(startDate)
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	q:monthId="" null
 	k ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s kpiIdList=$g(resovledRuleArr("KPILIST"))
 	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monthId,kpiIdList,mode,contract,filterRule,execParam) ;..GetSrcKPIData(monthId,kpiIdList,mode,contract)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId)) q:kpiId=""  d
 	..s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)) q:dimsId=""  d
 	...s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)=^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)
 	k ^TEMPDHCWLKPIDATA("G",$j)
 	s noFilterFlag=1
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId)) q:dimsId=""  d
 	..s kpiIdList=""
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...s filterFlag=$d(filterTree(kpiCode))
 	...i ((0)&&(filterFlag'=0)) d
 	....s noFilterFlag=0
 	....s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.....q:+filterInd=0
 	.....s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dimsId,filterTree(kpiCode,filterInd))
 	.....if filterResultFlag d
 	......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.......s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.......s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)=dimsId,^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	...e  d
 	....s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.....s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.....s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)=dimsId,^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	k ^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s monId2=$p(monId,"||",1),conType=$p(monId,"||",2),contractTypeCode=""
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId)) q:dimsId=""  d
 	..s dimCol="",dimDesCol="",kpiValCol="",excDimValue=""
 	..s dimIdList=$lb(),dimDesList=$lb(),kpiValList=$lb(),secProList=$lb()
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s secResProValue="",kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...i 1 d			
 	....s dimIdList=$lb(),dimDesList=$lb()		;清空维度数据.2014-11-21
 	...k needCombProValArr
 	...i (($d(resovledRuleArr("KPISECDIM",kpiId)))&&(monId2'=0)) d
 	....if ($d(^DHCWL.MKPI.MonthsD(monId2))) s monSec=$lg(^DHCWL.MKPI.MonthsD(monId2),11)
 	....else  s monSec=0
 	....s secResProValue=""
 	....s secProPos="" f  s secProPos=$o(resovledRuleArr("KPISECDIM",kpiId,secProPos)) q:secProPos=""  d
 	.....s secProId=$O(resovledRuleArr("KPISECDIM",kpiId,secProPos,""))
 	.....s secId=resovledRuleArr("KPISECDIM",kpiId,secProPos,secProId)
 	.....if ((secProId=0)||(monSec'=secId)) d
 	......if (monSec=secId) s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	......else  s secResProValue=""
 	......i conType'="" d
 	.......s contractTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4),contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)  ;$case(tempConType,"PP":" 上期","SL":" 同期","CM":" 本月累计","CY":" 本年累计",:"")
 	.......s secResProValue=secResProValue_contractTypeName
 	.....else  d
 	......s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
 	......q:proExcStr=""
 	......s proExcStr="s secResProValue=$$"_proExcStr_"(monId2)"
 	......x proExcStr
 	.....s $li(secProList,secProPos)=secResProValue
 	...e  d
 	....i monId2=0 d
 	.....s secResProValue="0"
 	....e  d
 	.....s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	....i conType'="" d
 	.....s contractTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4),contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)  ;$case(tempConType,"PP":" 上期","SL":" 同期","CM":" 本月累计","CY":" 本年累计",:"")
 	.....s secResProValue=secResProValue_contractTypeName
 	....s $li(secProList,1)=secResProValue
 	...s splitProFlag=0
 	...s canOutputFlag=0,colInd="" f  s colInd=$o(resovledRuleArr("COL",kpiId,colInd)) q:colInd=""  d
 	....s canOutputFlag=1
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proId=$o(resovledRuleArr("COL",kpiId,colInd,""))
 	....s kpiDimId=resovledRuleArr("COL",kpiId,colInd,proId)
 	....s dimOrder=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"ORDER")
 	....s dimDeli=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"DELI")
 	....s needDimId=$p(dimsId,dimDeli,dimOrder)
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proExcCode=$lg(^DHCWL.MKPI.DimPropertyD(proId),6)
 	....s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(proId),8,"")
 	....s excDimValue="" ;..ExcuteCode(proExcCode,needDimId)
 	....s proExcCode="s excDimValue=$$"_proExcCode_"(needDimId)"
 	....x proExcCode
 	....i ((proValueDeli'="")&&(proValueDeli'=$c(0))) d
 	.....s $li(dimIdList,colInd)=needDimId
 	.....s splitProFlag=1
 	.....s needCombProValArr(colInd)=excDimValue,needCombProValArr(colInd,"Deli")=proValueDeli,needCombProValArr(colInd,"ProId")=proId,needCombProValArr(colInd,"KpiDim")=kpiDimId
 	....e  d
 	.....s $li(dimIdList,colInd)=needDimId,$li(dimDesList,colInd)=excDimValue	//写入维度和维度属性
 	.....s $p(dimDesCol,dimDeli,colInd)=excDimValue
 	...q:(canOutputFlag=0)
 	...d:splitProFlag ##class(DHCWL.MKPIService.KpiRuleUtil).Combine(.needCombProValArr,.needCombProValArrResult)
 	...if (splitProFlag)  d
 	....s onlyResovledProValue=""
 	....s needComProValInd="" f  s needComProValInd=$o(needCombProValArrResult(needComProValInd)) q:needComProValInd=""  d
 	.....s needComProValColInd="" f  s needComProValColInd=$o(needCombProValArrResult(needComProValInd,needComProValColInd)) q:needComProValColInd=""  d
 	......s theDeliedProVal=needCombProValArrResult(needComProValInd,needComProValColInd)
 	......s $p(dimDesCol,",",needComProValColInd)=theDeliedProVal
 	......s $li(dimDesList,needComProValColInd)=theDeliedProVal
 	......s columnProId=needCombProValArr(needComProValColInd,"ProId"),columnKpiDim=needCombProValArr(needComProValColInd,"KpiDim")
 	......s columnDimorder=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"ORDER"),columnDimDeli=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"DELI")
 	......s $p(onlyResovledProValue,columnDimDeli,columnDimorder)=theDeliedProVal
 	.....s filterFlag=$d(filterTree(kpiCode))
 	.....i filterFlag'=0 d
 	......s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.......q:+filterInd=0
 	.......s kpiResPos=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId,""))
 	.......s allDimIds=^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId,kpiResPos)
 	.......if (##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,allDimIds,onlyResovledProValue,filterTree(kpiCode,filterInd),1)) d
 	........s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList
 	........s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	.....e  d
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	...e  d
 	....s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)

	s kpiLstObj=##Class(%ListOfObjects).%New()

 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s contractCode=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)
 	.s dimDesCol="" f  s dimDesCol=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol)) q:dimDesCol=""  d
 	..s kpiIdList="",dimIdlList="",kpiValueList=$lb() ;,dimDesList=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol)
 	..s dimDesList=dimDesCol
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)) q:kpiId=""  d
 	...i kpiIdList="" s kpiIdList=kpiId
 	...e  s kpiIdList=kpiIdList_KPIDELI_kpiId
 	...;s kpiCols=kpiCols+1
 	...s kpiPos=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,""))
 	...s $li(kpiValueList,kpiPos)=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)
 	...s dimIdlList=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,kpiPos)

 	..;生成指标对象
 	..s rec=##Class(%ArrayOfObjects).%New()
 	..d ##class(DHCWL.MKPIService.SetKPIData).SetKpiRecObj(.resovledRuleArr,kpiIdList,contractCode,monId,dimIdlList,dimDesList,kpiValueList,.rec)
 	..d kpiLstObj.Insert(rec)
	
	
	
 	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit kpiLstObj
}

Query QueryCombineKpiByDate(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Query(ROWSPEC = "kpi:%String,contractTye:%String,month:%String,monthCol2:%String,monthCol3:%String,monthCol4:%String,monthCol5:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod QueryCombineKpiByDateExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	s KPIINFOMAXCOL=1,MAXMONTHCOL=5,MAXDIMDESCOL=16,MAXDIMIDCOL=16,MAXKPIVALCOL=30,MONDELI=";",KPIDELI=";"
	s secStartInd=KPIINFOMAXCOL+1,dimIdStartInd=secStartInd+MAXMONTHCOL,dimDesStartInd=dimIdStartInd+MAXDIMIDCOL,kpiValueStartInd=dimDesStartInd+MAXDIMDESCOL

	s MONDELI=";",KPIDELI=";"
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resovled)

 	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition2(kpiRule,.resovledRuleArr)
 	i $g(endDate)="" s endDate=$g(startDate)
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	q:monthId="" null
 	k ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s kpiIdList=$g(resovledRuleArr("KPILIST"))
 	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monthId,kpiIdList,mode,contract,filterRule) ;..GetSrcKPIData(monthId,kpiIdList,mode,contract)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId)) q:kpiId=""  d
 	..s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)) q:dimsId=""  d
 	...s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)=^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)
 	k ^TEMPDHCWLKPIDATA("G",$j)
 	s noFilterFlag=1
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId)) q:dimsId=""  d
 	..s kpiIdList=""
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...s filterFlag=$d(filterTree(kpiCode))
 	...i ((0)&&(filterFlag'=0)) d
 	....s noFilterFlag=0
 	....s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.....q:+filterInd=0
 	.....s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dimsId,filterTree(kpiCode,filterInd))
 	.....if filterResultFlag d
 	......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.......s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.......s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)=dimsId,^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	...e  d
 	....s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.....s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.....s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)=dimsId,^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	k ^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s monId2=$p(monId,"||",1),conType=$p(monId,"||",2),contractTypeCode=""
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId)) q:dimsId=""  d
 	..s dimCol="",dimDesCol="",kpiValCol="",excDimValue=""
 	..s dimIdList=$lb(),dimDesList=$lb(),kpiValList=$lb(),secProList=$lb()
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s secResProValue="",kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...i 1 d			
 	....s dimIdList=$lb(),dimDesList=$lb()		;清空维度数据.2014-11-21
 	...k needCombProValArr
 	...i (($d(resovledRuleArr("KPISECDIM",kpiId)))&&(monId2'=0)) d
 	....if ($d(^DHCWL.MKPI.MonthsD(monId2))) s monSec=$lg(^DHCWL.MKPI.MonthsD(monId2),11)
 	....else  s monSec=0
 	....s secResProValue=""
 	....s secProPos="" f  s secProPos=$o(resovledRuleArr("KPISECDIM",kpiId,secProPos)) q:secProPos=""  d
 	.....s secProId=$O(resovledRuleArr("KPISECDIM",kpiId,secProPos,""))
 	.....s secId=resovledRuleArr("KPISECDIM",kpiId,secProPos,secProId)
 	.....if ((secProId=0)||(monSec'=secId)) d
 	......if (monSec=secId) s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	......else  s secResProValue=""
 	......i conType'="" d
 	.......s contractTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4),contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)  ;$case(tempConType,"PP":" 上期","SL":" 同期","CM":" 本月累计","CY":" 本年累计",:"")
 	.......s secResProValue=secResProValue_contractTypeName
 	.....else  d
 	......s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
 	......q:proExcStr=""
 	......s proExcStr="s secResProValue=$$"_proExcStr_"(monId2)"
 	......x proExcStr
 	.....s $li(secProList,secProPos)=secResProValue
 	...e  d
 	....i monId2=0 d
 	.....s secResProValue="0"
 	....e  d
 	.....s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	....i conType'="" d
 	.....s contractTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4),contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)  ;$case(tempConType,"PP":" 上期","SL":" 同期","CM":" 本月累计","CY":" 本年累计",:"")
 	.....s secResProValue=secResProValue_contractTypeName
 	....s $li(secProList,1)=secResProValue
 	...s splitProFlag=0
 	...s canOutputFlag=0,colInd="" f  s colInd=$o(resovledRuleArr("COL",kpiId,colInd)) q:colInd=""  d
 	....s canOutputFlag=1
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proId=$o(resovledRuleArr("COL",kpiId,colInd,""))
 	....s kpiDimId=resovledRuleArr("COL",kpiId,colInd,proId)
 	....s dimOrder=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"ORDER")
 	....s dimDeli=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"DELI")
 	....s needDimId=$p(dimsId,dimDeli,dimOrder)
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proExcCode=$lg(^DHCWL.MKPI.DimPropertyD(proId),6)
 	....s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(proId),8,"")
 	....s excDimValue="" ;..ExcuteCode(proExcCode,needDimId)
 	....s proExcCode="s excDimValue=$$"_proExcCode_"(needDimId)"
 	....x proExcCode
 	....i ((proValueDeli'="")&&(proValueDeli'=$c(0))) d
 	.....s $li(dimIdList,colInd)=needDimId
 	.....s splitProFlag=1
 	.....s needCombProValArr(colInd)=excDimValue,needCombProValArr(colInd,"Deli")=proValueDeli,needCombProValArr(colInd,"ProId")=proId,needCombProValArr(colInd,"KpiDim")=kpiDimId
 	....e  d
 	.....s $li(dimIdList,colInd)=needDimId,$li(dimDesList,colInd)=excDimValue	//写入维度和维度属性
 	.....s $p(dimDesCol,dimDeli,colInd)=excDimValue
 	...q:(canOutputFlag=0)
 	...d:splitProFlag ##class(DHCWL.MKPIService.KpiRuleUtil).Combine(.needCombProValArr,.needCombProValArrResult)
 	...if (splitProFlag)  d
 	....s onlyResovledProValue=""
 	....s needComProValInd="" f  s needComProValInd=$o(needCombProValArrResult(needComProValInd)) q:needComProValInd=""  d
 	.....s needComProValColInd="" f  s needComProValColInd=$o(needCombProValArrResult(needComProValInd,needComProValColInd)) q:needComProValColInd=""  d
 	......s theDeliedProVal=needCombProValArrResult(needComProValInd,needComProValColInd)
 	......s $p(dimDesCol,",",needComProValColInd)=theDeliedProVal
 	......s $li(dimDesList,needComProValColInd)=theDeliedProVal
 	......s columnProId=needCombProValArr(needComProValColInd,"ProId"),columnKpiDim=needCombProValArr(needComProValColInd,"KpiDim")
 	......s columnDimorder=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"ORDER"),columnDimDeli=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"DELI")
 	......s $p(onlyResovledProValue,columnDimDeli,columnDimorder)=theDeliedProVal
 	.....s filterFlag=$d(filterTree(kpiCode))
 	.....i filterFlag'=0 d
 	......s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.......q:+filterInd=0
 	.......s kpiResPos=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId,""))
 	.......s allDimIds=^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId,kpiResPos)
 	.......if (##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,allDimIds,onlyResovledProValue,filterTree(kpiCode,filterInd),1)) d
 	........s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList
 	........s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	.....e  d
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	...e  d
 	....s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList)=contractTypeCode,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId,kpiPos)=dimIdList,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,secProList,dimDesList,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)

 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s contractCode=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)
 	.s dimDesCol="" f  s dimDesCol=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol)) q:dimDesCol=""  d
 	..s kpiIdList="",dimIdlList="",kpiValueList=$lb() ;,dimDesList=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol)
 	..s dimDesList=dimDesCol
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)) q:kpiId=""  d
 	...i kpiIdList="" s kpiIdList=kpiId
 	...e  s kpiIdList=kpiIdList_KPIDELI_kpiId
 	...;s kpiCols=kpiCols+1
 	...s kpiPos=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,""))
 	...s $li(kpiValueList,kpiPos)=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)
 	...s dimIdlList=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,kpiPos)
 	..s tempResovleColList=$lb(kpiIdList,contractCode)
 	..s tempResovleColList=$$MergeList2(tempResovleColList,secStartInd,monId)
 	..s tempResovleColList=$$MergeList2(tempResovleColList,dimIdStartInd,dimIdlList)
 	..s tempResovleColList=$$MergeList2(tempResovleColList,dimDesStartInd,dimDesList)
 	..s tempResovleColList=$$MergeList2(tempResovleColList,kpiValueStartInd,kpiValueList)
 	..s ^CacheTemp(repid,ind)=tempResovleColList
 	..s ind=ind+1
 	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit $$$OK
	//将listB从listA的位置startA处合并为一个list
MergeList2(listA,startA,listB)
	s listLen=$ll(listB)
	f listIndex=1:1:listLen {
		s $li(listA,listIndex+startA)=$lg(listB,listIndex)
	}
	q listA
}

ClassMethod QueryCombineKpiByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCombineKpiByDateExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCombineKpiByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCombineKpiByDateExecute ]
{
	n (AtEnd,qHandle,Row)
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

ClassMethod OutPutData(ByRef resolveKpiRuleMap, ByRef resolved, mode, repid, ind)
{
	n (resolveKpiRuleMap,resolved,mode,repid,ind)
	
	k sectionCodeList
	k DimPosList
	k datePosList
	k dimProPosList
	s sectionId=""
	for{
		s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
		q:sectionId=""
		s sectionCode=""
		s sectionCode=$lg(^DHCWL.MKPI.SectionD(sectionId),2,"")
		s sectionCodeList(sectionCode)=""
	} 
	s kpiCode=""
	for{
		s kpiCode=$o(resolveKpiRuleMap(kpiCode))
		q:kpiCode=""
		s sectionDimPos=""
		for{
			s sectionDimPos=$o(resolveKpiRuleMap(kpiCode,"DimPro",sectionDimPos))
			q:sectionDimPos=""
			;s kpiDim=$o(resolveKpiRuleMap(kpiCode,"DimPro",sectionDimPos,""))
			;s dimArray=resolveKpiRuleMap(kpiCode,"DimPro",sectionDimPos,kpiDim)
			;s dimOrder=$p(dimArray,"^",3)
			s DimPosList(kpiCode,sectionDimPos)=""
		}
	}
	s kpiCode=""
	for{
		s kpiCode=$o(resolveKpiRuleMap(kpiCode))
		q:kpiCode=""
		s dimProPos=""
		for{
			s dimProPos=$o(resolveKpiRuleMap(kpiCode,"AllDim",dimProPos))
			q:dimProPos=""
			s dimProCode=""
			s dimProCode=$o(resolveKpiRuleMap(kpiCode,"AllDim",dimProPos,dimProCode))
			s dimProPosList(kpiCode,dimProCode)=""
		}
	}
	s kpiCode=""
	for{
		s number=1
		s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
		q:kpiCode=""
		s dataTops=""
		if ($d(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR"))=0){
			continue
		}
		s dataTops=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")
		for{
			s dataTop=$lg(dataTops,number)
			q:dataTop=""
			if ($d(sectionCodeList(dataTop))=1){
				s datePosList(kpiCode)=number
				q
			}
			s number=number+1
		}
		
	}
	s kpiCode=""
	for{
		s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
		q:kpiCode=""
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		s kpiDimDimId=""
		s kpiDimDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,kpiDimDimId))
		s tempKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,kpiDimDimId,""))
		q:tempKpiDimId=""
		s kpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(tempKpiDimId),7,",")
		s kpiDes=$lg(^DHCWL.MKPI.MKPID(kpiId),3)
		//modify by wk~20170321~指标数据按照ID汇总
		//s dimDesList=""
		s dimIdList=""
		s dataInforList=""
		for{
			//s dimDesList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimDesList))
			//q:dimDesList=""
			//s dimIdList=""
			//s dimIdList=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimDesList,"IDS")
			s dimIdList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimIdList))
			q:dimIdList=""
			s dimDesList=""
			s dimDesList=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimIdList,"IDS")
			s contractFlag=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimIdList,"ISC")
			s dataInforList=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")
			s datePos=$g(datePosList(kpiCode))
			s pos=""
			s monthDes="",monthId=""
			if (datePos'=""){
				;s pos=$o(resolveKpiRuleMap(kpiCode,"DimPro-Sec",pos))
				;q:pos=""
				;s monthId=$lg(dimIdList,pos,"")
				;s monthDes=$li(^DHCWL.MKPI.MonthsD(monthId),3)
			;}else{
				s monthDes=$lg(dimDesList,datePos,"")
				s monthId=$lg(dimIdList,datePos,"")
			}
			s monthId1=monthId
			if (monthId=0)&&(contractFlag'="STDT"){
				s monthId=""
			}
			s contractId=""
			if (contractFlag'="STDT"){
				s contractId=$o(^DHCWL.MKPI.APPLibraryI("CodeI",contractFlag,contractId))
				s monthId=monthId_"||"_contractId
				s contractId=contractFlag
			}
			s dimPos=""
			;s dimReaPos=""
			s dimDesList1=""
			;s dimDesList2=""
			s dimIdList1=""
			s num=1
			for{
				s dimPos=$o(DimPosList(kpiCode,dimPos))
				q:dimPos=""
				s dimCode=$lg(dimIdList,dimPos,"")
				if (dimIdList1="")&&(num=1){
					s dimIdList1=dimCode
				}else{
					;s dimIdList1=dimIdList1_","_dimCode
					s dimIdList1=dimIdList1_kpiDimDeli_dimCode
				}
				s num=num+1
			}
				s dimPos=""
				s dimDesLen=$LL(dimDesList)
				for dimPos=1:1:(dimDesLen-1){
					
					/*s dimPos=$o(DimPosList(kpiCode,dimPos))
					q:dimPos=""
					s dimRealPos=""
					s dimRealPos=$o(DimPosList(kpiCode,dimPos,dimRealPos))
					s dimInfor=$lg(dimDesList,dimPos,"")*/
					s dimInfor=$lg(dimDesList,dimPos,"")
					s dimProCode=$lg(dataInforList,dimPos,"")
					if ($d(dimProPosList(kpiCode,dimProCode))=0){
						continue
					}
					if ($d(sectionCodeList(dimProCode))=1){
						s dimProId=$lg(dimIdList,dimPos,"")
						if (dimProId=0){
							s dimInfor=""
						}else{
							s dimInfor=$li(^DHCWL.MKPI.MonthsD(dimProId),3)
						}
					}
					if (dimDesList1="")&&(dimPos=1){
						s dimDesList1=dimInfor
					}else{
						;s dimDesList1=dimDesList1_","_dimInfor
						s dimDesList1=dimDesList1_kpiDimDeli_dimInfor
					}
				}
				/*s dimPos=""
				for{
					s dimPos=$o(dimProPosList(kpiCode,dimPos))
					q:dimPos=""
					s dimInfor=$lg(dimDesList,dimPos,"")
					s dimProCode=$lg(dataInforList,dimPos,"")
					if ($d(sectionCodeList(dimProCode))=1){
						s dimProId=$lg(dimIdList,dimPos,"")
						if (dimProId=0){
							s dimInfor=""
						}else{
							s dimInfor=$li(^DHCWL.MKPI.MonthsD(dimProId),3)
						}
					}
					if (dimDesList1=""){
						s dimDesList1=dimInfor
					}else{
						s dimDesList1=dimDesList1_","_dimInfor
					}
				}*/
			//s value=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimDesList)
			s value=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimIdList)
			s row=$listbuild(monthId,contractId,monthDes,kpiId,kpiCode,kpiDes,dimIdList1,dimDesList1,value)
			s ^CacheTemp(repid,ind)=row
			s ind=ind+1
		}
	}
}

ClassMethod Output(ByRef aryKpiConMon, gblFlag As %String, ByRef resolve, ByRef filterTree, enableConType As %String = "")
{
	s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType))
		q:conType=""

		if conType'="STDT" {
			s conTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4)
		}
		s monID=""
		f {
		 	s monID=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID))
		 	q:monID=""
		 	
		 	if monID="T" {		//合计
			 	s monDesc="合计",kpiID="",kpiCode="",kpiDes="",dimList="",resolvedDimList=""

			 	s value=$g(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID))
			 	if enableConType="" {
				 	do outputRowBD102
			 	}else{
			 		s originMonID="T",originMonDesc="合计"
			 		do outputRowBD103 	
				 }
			 	continue
			 	
		 	}elseif monID=0 {	//汇总
			 	s monDesc=""
		 	}else{
		 		s monDesc=$li(^DHCWL.MKPI.MonthsD(monID),3)
		 	}
		 	s kpiID=""
		 	f {
			 	s kpiID=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID))	
			 	q:kpiID=""
			 	//add by wk.2016-02-24
				s kpiDimDimId=""
				s kpiDimDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiID,kpiDimDimId))
				s tempKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiID,kpiDimDimId,""))
				q:tempKpiDimId=""
				s kpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(tempKpiDimId),7,",")
				
				
				if $g(enableConType)="" {
				
				}else{
					if monID'=0 {
						//resolved(kpiID,libId,conMonthid)=monthID
						s originMonID=aryKpiConMon(kpiID,conType,monID)
						if originMonID'="" {
							s originMonDesc=$li(^DHCWL.MKPI.MonthsD(originMonID),3)
						}else{
							s febMonDesc=$lg(^DHCWL.MKPI.MonthsD(monID),5)
							s febMonDesc=$p(febMonDesc,"-",2,$l(febMonDesc,"-"))
							if febMonDesc="02-29" s originMonDesc=$lg(^DHCWL.MKPI.MonthsD(monID),3)_"-"
						}
					}else{
						s originMonID=""
						s originMonDesc=""
					}
					
				}		 	
		 	
		 	
		 		s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
		 		s kpiDes=$lg(^DHCWL.MKPI.MKPID(kpiID),3)
			 	s dimList=""
			 	f {
				 	s dimList=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList))	
				 	q:dimList=""
				 	s pos=1	//固定写为1。在一个取数规则中，相同的指标编码是否允许出现多次还需要讨论。
					s resolvedDimList=##class(DHCWL.MKPIService.SetKPIData).ResolveDim(kpiID,pos,.resolve,dimList,.proValueArr)
				 	i $d(proValueArr("OK"))'=0 {
					 	s deliInd="" 
					 	f  {
						 	s deliInd=$o(proValueArr("OK",deliInd)) 
						 	q:deliInd=""  
				 			s tempProDeliId=""
				 			s oneCombineResult=""
				 			s order="" 
				 			f  {
					 			s order=$o(proValueArr("OK",deliInd,order))
					 			q:order=""
				 				s tempProDeliId=$o(proValueArr("OK",deliInd,order,""))
				 				s theDeliedProVal=proValueArr("OK",deliInd,order)
				 				s $p(resolvedDimList,",",order)=theDeliedProVal
				 				s $p(oneCombineResult,",",order)=theDeliedProVal
				 			}
		 			
		 					s oldDimList=resolvedDimList
				 			i ('$d(filterTree(kpiCode))) {
					 			s secDimPro=""
							 	f {
								 	s secDimPro=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro))
								 	q:secDimPro=""
								 	s value=^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro)
								 	//modify by wk.2016-02-24
								 	//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_","_secDimPro
								 	//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
								 	if ((secDimPro'="NOTEXIST")&(resolvedDimList'="")){
							 			s resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
						 			}elseif(secDimPro'="NOTEXIST"){
							 			s resolvedDimList=secDimPro
						 			}
								 	if enableConType="" {
									 	do outputRowBD102
								 	}else{
										do outputRowBD103 	
									}
									s resolvedDimList=oldDimList
							 	}
				 			}else {
					 			s filterInd="" 
					 			f {
						 			s filterInd=$o(filterTree(kpiCode,filterInd)) 
						 			q:+filterInd=0
						 			;老query在分隔后不再支持进一步对分隔后数据的过滤
						 			if ((##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",oneCombineResult,filterTree(kpiCode,filterInd),1))) {
					 					
							 			s secDimPro=""
									 	f {
										 	s secDimPro=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro))
										 	q:secDimPro=""
										 	s value=^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro)
											//modify by wk.2016-02-24
											//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_","_secDimPro
											//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
										 	if ((secDimPro'="NOTEXIST")&(resolvedDimList'="")){
							 					s resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
						 					}elseif(secDimPro'="NOTEXIST"){
							 					s resolvedDimList=secDimPro
						 					}
										 	if enableConType="" {
											 	do outputRowBD102
										 	}else{
												do outputRowBD103 	
											}
											s resolvedDimList=oldDimList
									 	}						 			
						 			}
					 			}
				 			}
					 	}
				 	}else{
					 	s oldDimList=resolvedDimList
			 			s secDimPro=""
					 	f {
						 	s secDimPro=$o(^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro))
						 	q:secDimPro=""
						 	s value=^||TEMPDHCWLKPIDATA(gblFlag,$j,conType,monID,kpiID,dimList,secDimPro)
						 	//mmodify by wk.2016-02-24
						 	//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_","_secDimPro
						 	//s:secDimPro'="NOTEXIST" resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
						 	if ((secDimPro'="NOTEXIST")&(resolvedDimList'="")){
							 	s resolvedDimList=resolvedDimList_kpiDimDeli_secDimPro
						 	}elseif(secDimPro'="NOTEXIST"){
							 	s resolvedDimList=secDimPro
						 	}
						 	if enableConType="" {
							 	do outputRowBD102
						 	}else{
								do outputRowBD103 	
							}
							s resolvedDimList=oldDimList
					 	}						 			
			 	
				 	}
			 	
			 	}
		 	
		 	}

		}
	}
	q

outputRowBD102
	if resolve("$ShowByRulerOrder") {
		d ##class(DHCWL.MKPIService.KpiRuleUtil).transDimPos(kpiID,dimList,resolvedDimList,pos,.resolve,.mapRuleArr,.dimIDList,.dimDescList)
		s row=$listbuild(monID,monDesc,kpiID,kpiCode,kpiDes,dimIDList,dimDescList,value)
	}else{
		s row=$listbuild(monID,monDesc,kpiID,kpiCode,kpiDes,dimList,resolvedDimList,value)
	}
	s ^CacheTemp(repid,ind)=row
	s ind=ind+1
	q
	
outputRowBD103
	//add by wz . 2015-5-8. patch4.1.10.
	i conType'="STDT" {
		s outMonDesc=originMonDesc_conTypeName
		s outMonID=originMonID_"||"_conType
		s outConType=conType
	}else{
		s outMonDesc=monDesc
		s outMonID=monID
		s outConType=""
	}
	if resolve("$ShowByRulerOrder") {
		d ##class(DHCWL.MKPIService.KpiRuleUtil).transDimPos(kpiID,dimList,resolvedDimList,pos,.resolve,.mapRuleArr,.dimIDList,.dimDescList)
		s row=$listbuild(outMonID,outConType,outMonDesc,kpiID,kpiCode,kpiDes,dimIDList,dimDescList,value)
	}else{
		s row=$listbuild(outMonID,outConType,outMonDesc,kpiID,kpiCode,kpiDes,dimList,resolvedDimList,value)
	} 	
	s ^CacheTemp(repid,ind)=row
	s ind=ind+1
	q
}

ClassMethod ExchangeNodePos()
{
	//s ^TEMPDHCWLKPIDATA(gblFlag,$j,contractType,monID,kpiID,resDim,secdimPro)
	//s originMonID=aryKpiConMon(kpiID,conType,monID)

	s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType))
		q:conType=""
		
		s monID=""
		f {
			s monID=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID))	
			q:monID=""
			if monID="T" {		//合计
				s ^||TEMPDHCWLKPIDATA("G",$j,conType,monID)=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID)
				continue
			}
			s kpiID=""
			f {
				s kpiID=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID,kpiID))
				q:kpiID=""
				s dimsID=""
				f {
					s dimsID=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID,kpiID,dimsID))	
					q:dimsID=""
					s secDimPro=""
					f {
						s secDimPro=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID,kpiID,dimsID,secDimPro))
						q:secDimPro=""
						s ^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID,kpiID,dimsID,secDimPro)
						s position=1	//先固定写1
						s ^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro,position)=dimsID
					}
				}		
			}
		}
	}
}

ClassMethod AdjustOutputPos(ByRef resovledRuleArr, enableConType As %String = "1")
{
	//s ^TEMPDHCWLKPIDATA(gblFlag,$j,contractType,monID,kpiID,resDim,secdimPro)
	//s originMonID=aryKpiConMon(kpiID,conType,monID)
	//s ^TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monID,kpiID,dimsID,secDimPro)
	k ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
	s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("G",$j,conType))
		q:conType=""
		
		s conTypeName=""
		s contractTypeCode=""
		if conType'="STDT" {
			s conTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4)
			s contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)
		}
		
		s monID=""
		f {
			s monID=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID))	
			q:monID=""
			
		 	if monID="T" {		//合计
			 	s monDesc="合计" //,kpiID="",kpiCode="",kpiDes="",dimList="",resolvedDimList=""

			 	s value=$g(^||TEMPDHCWLKPIDATA("G",$j,conType,monID))
			 	s dimDesList=$lb(),kpiID=$lb(),kpiPos=1,dimIDList=$lb()
			 	if conTypeName="" {			//无对比类型
			 		s monDescList=$lb(monDesc)
			 	}else{						//同比或环比合计
			 		s monDesc=monDesc_conTypeName
			 		s monDescList=$lb(monDesc)	
				}
				s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList)=contractTypeCode 
				s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID,kpiPos)=dimIDList 
				s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID)=value
				//d ..setConMonDimKpiData(conType,monDescList,dimDesList,kpiID,kpiPos,contractTypeCode,dimIDList,monID,"")				 
			 	continue
			 	
		 	}elseif monID=0 {	//汇总
			 	s monDesc=0
		 	}else{
		 		s monDesc=$li(^DHCWL.MKPI.MonthsD(monID),3)
		 		
		 	}
		 	if conTypeName'="" {
			 	s monDesc=monDesc_conTypeName	
		 	}

			
			
			s dimsID=""
			f {
				s dimsID=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID)) 
				q:dimsID=""
				//b:dimsID="144,1"
				//
				s dimCol="",dimDesCol="",kpiValCol="",excDimValue=""
				//
				s dimIDList=$lb(),dimDesList=$lb(),kpiValList=$lb(),secProList=$lb()
				s kpiID=""
				f {
					s kpiID=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID))
					q:kpiID=""

					s secResProValue=""
					s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
				
					k needCombProValArr
					
					s secDimPro=""
					s secDimPro=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro))	
					q:secDimPro=""
					
				 	if ((conTypeName'="") && (+monID'=0)) {
					 	//s monDesc=monDesc_"||"_conTypeName	
					 	s conMonID=aryKpiConMon(kpiID,conType,monID)
					 	if conMonID'=""{
					 		s monDesc=$li(^DHCWL.MKPI.MonthsD(conMonID),3)
					 	}else{
						 	s febMonDesc=$lg(^DHCWL.MKPI.MonthsD(monID),5)
							s febMonDesc=$p(febMonDesc,"-",2,$l(febMonDesc,"-"))
							if febMonDesc="02-29" s monDesc=$lg(^DHCWL.MKPI.MonthsD(monID),3)_"-"
					 	}
					 	s monDesc=monDesc_conTypeName	
				 	}					
					s monDescList=$lb(monDesc,,,,)
					//区间维度属性处理，值保存到secProList里面
					if secDimPro'="NOTEXIST" {	//区间维度存在
						//b:secDimPro="周六,是"
						s secProList=$lfs(secDimPro,",")
						s $li(monDescList,2,2)=secProList
					}
	 				s splitProFlag=0
	 				s canOutputFlag=0
	 				//b:kpiID=1663
	 				s kpiPos=""
	 				s colInd="" 
	 				f {
		 				s colInd=$o(resovledRuleArr("COL",kpiID,colInd)) 
		 				q:colInd=""
 				
						s canOutputFlag=1
	 					s kpiPos=resovledRuleArr("COL",kpiID)
	 					s proId=$o(resovledRuleArr("COL",kpiID,colInd,""))
	 					s kpiDimId=resovledRuleArr("COL",kpiID,colInd,proId)
	 					s dimOrder=resovledRuleArr("KPIDIM",kpiID,kpiDimId,"ORDER")
	 					s dimDeli=resovledRuleArr("KPIDIM",kpiID,kpiDimId,"DELI")
	 					s needDimId=$p(dimsID,dimDeli,dimOrder)
	 					s kpiPos=resovledRuleArr("COL",kpiID)
	 					s proExcCode=$lg(^DHCWL.MKPI.DimPropertyD(proId),6)
	 					s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(proId),8,"")
	 					s excDimValue="" ;..ExcuteCode(proExcCode,needDimId)
	 					s proExcCode1=proExcCode
	 					//s proExcCode="s excDimValue=$$"_proExcCode_"(needDimId)"
	 					//x proExcCode
	 					s excDimValue=##class(DHCWL.MKPIService.SetKPIData).ExcuteDim("$$"_proExcCode,needDimId)
	 					i ((proValueDeli'="")&&(proValueDeli'=$c(0))) {
	 						s $li(dimIDList,colInd)=needDimId
	 						s splitProFlag=1
	 						s needCombProValArr(colInd)=excDimValue
	 						s needCombProValArr(colInd,"Deli")=proValueDeli
	 						s needCombProValArr(colInd,"ProId")=proId
	 						s needCombProValArr(colInd,"KpiDim")=kpiDimId
	 					}else{
	 						s $li(dimIDList,colInd)=needDimId,$li(dimDesList,colInd)=excDimValue
	 						s $p(dimDesCol,dimDeli,colInd)=excDimValue
	 					}
 				
	 				} 
	 				
	 				
	 				/*
	 				s lastColInd=$o(resovledRuleArr("COL",kpiID,""),-1) 
					
					//把区间描述加到维度描述后面
					s listLen=$ll(secProList)
					f listIndex=1:1:listLen {
						s $li(dimDesList,listIndex+lastColInd)=$lg(secProList,listIndex)
					}
					*/

					if (kpiPos=""){
						s kpiPos=resovledRuleArr("COLSEC",kpiID)
					}
	 				//q:(canOutputFlag=0)
	 				d:splitProFlag ##class(DHCWL.MKPIService.KpiRuleUtil).Combine(.needCombProValArr,.needCombProValArrResult)
				
	 				if (splitProFlag)  {
	 					s onlyResovledProValue=""
	 					s needComProValInd="" 
	 					f {
		 					s needComProValInd=$o(needCombProValArrResult(needComProValInd)) 
		 					q:needComProValInd=""
	 						s needComProValColInd="" 
	 						f {
		 						s needComProValColInd=$o(needCombProValArrResult(needComProValInd,needComProValColInd)) 
		 						q:needComProValColInd=""
	 							s theDeliedProVal=needCombProValArrResult(needComProValInd,needComProValColInd)
	 							s $p(dimDesCol,",",needComProValColInd)=theDeliedProVal
	 							s $li(dimDesList,needComProValColInd)=theDeliedProVal
	 							s columnProId=needCombProValArr(needComProValColInd,"ProId")
	 							s columnKpiDim=needCombProValArr(needComProValColInd,"KpiDim")
	 							s columnDimorder=resovledRuleArr("KPIDIM",kpiID,columnKpiDim,"ORDER")
	 							s columnDimDeli=resovledRuleArr("KPIDIM",kpiID,columnKpiDim,"DELI")
	 							s $p(onlyResovledProValue,columnDimDeli,columnDimorder)=theDeliedProVal
	 						}
	 						s filterFlag=$d(filterTree(kpiCode))
	 						i filterFlag'=0 {
	 							s filterInd="" 
	 							f {
		 							s filterInd=$o(filterTree(kpiCode,filterInd)) 
		 							q:+filterInd=0  
									
									s onceCode=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,""))
	 								s kpiResPos=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,onceCode,""))
	 								s allDimIds=^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,onceCode,kpiResPos)
	 								if (##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,allDimIds,onlyResovledProValue,filterTree(kpiCode,filterInd),1)) {
	 									d ..setConMonDimKpiData(conType,monDescList,dimDesList,kpiID,kpiPos,contractTypeCode,dimIDList,monID,dimsID)
	 									/*
	 									s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList)=contractTypeCode
	 									s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID,kpiPos)=dimIDList
	 									s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID))+^TEMPDHCWLKPIDATA("G",$j,conType,monId,dimsId,kpiID)
	 									*/
	 								}
	 							}
	 						}else{
		 						d ..setConMonDimKpiData(conType,monDescList,dimDesList,kpiID,kpiPos,contractTypeCode,dimIDList,monID,dimsID)
								/*
	 							s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList)=contractTypeCode
	 							s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID,kpiPos)=dimIDList
	 							s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID))+^TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)
	 							*/
	 						}
	 					}
	 				}else{
		 				d ..setConMonDimKpiData(conType,monDescList,dimDesList,kpiID,kpiPos,contractTypeCode,dimIDList,monID,dimsID)
						/*
						s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList)=contractTypeCode 
						s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID,kpiPos)=dimIDList 
						s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID))+^TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)
	 					*/
	 				}
				}
			}
		
		
		}
	}
}

ClassMethod OutputGrid(dimValMaxNum)
{
	/*s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType))
		q:conType=""
		s monId="" 
		f {
			s monId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)) 
			q:monId=""  
			s contractCode=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)
			s dimDesCol="" 
			f {
				s dimDesCol=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimDesCol)) 
				q:dimDesCol="" 
				s kpiIdList="",dimIdlList="",kpiValueList=$lb() 
				s dimDesList=dimDesCol
				s kpiId="" 
				f {
					s kpiId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimDesCol,kpiId)) 
					q:kpiId=""
					i kpiIdList="" {
						s kpiIdList=kpiId
					}else{
	 					s kpiIdList=kpiIdList_KPIDELI_kpiId
					}

					s kpiPos=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimDesCol,kpiId,""))
				
	 				s $li(kpiValueList,kpiPos)=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimDesCol,kpiId)
	 				s dimIdlList=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimDesCol,kpiId,kpiPos)
				}

	 			s tempResovleColList=$lb(kpiIdList,contractCode)

	 			s tempResovleColList=$$MergeList104(tempResovleColList,secStartInd,monId)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,dimIdStartInd,dimIdlList)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,dimDesStartInd,dimDesList)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,kpiValueStartInd,kpiValueList)
	 			s ^CacheTemp(repid,ind)=tempResovleColList
	 			s ind=ind+1
			}
		}
	}
	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit
	//将listB从listA的位置startA处合并为一个list
MergeList104(listA,startA,listB)
	s listLen=$ll(listB)
	f listIndex=1:1:listLen {
	s $li(listA,listIndex+startA)=$lg(listB,listIndex)
	}
	q listA*/
	/*s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType))
		q:conType=""
		s monId="" 
		f {
			s monId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)) 
			q:monId=""  
			s contractCode=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)
			s dimIdList2=""
			for{
				s dimIdList2=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2))
				q:dimIdList2=""
				s dimDesCol="" 
				f {
					s dimDesCol=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2,dimDesCol)) 
					q:dimDesCol="" 
					s kpiIdList="",dimIdlList="",kpiValueList=$lb() 
					s dimDesList=dimDesCol
					s kpiId="" 
					f {
						s kpiId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2,dimDesCol,kpiId)) 
						q:kpiId=""
						i kpiIdList="" {
							s kpiIdList=kpiId
						}else{
	 						s kpiIdList=kpiIdList_KPIDELI_kpiId
						}

						s kpiPos=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2,dimDesCol,kpiId,""))
				
	 					s $li(kpiValueList,kpiPos)=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2,dimDesCol,kpiId)
	 					s dimIdlList=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList2,dimDesCol,kpiId,kpiPos)
					}

	 				s tempResovleColList=$lb(kpiIdList,contractCode)

	 				s tempResovleColList=$$MergeList104(tempResovleColList,secStartInd,monId)
	 				s tempResovleColList=$$MergeList104(tempResovleColList,dimIdStartInd,dimIdlList)
	 				s tempResovleColList=$$MergeList104(tempResovleColList,dimDesStartInd,dimDesList)
	 				s tempResovleColList=$$MergeList104(tempResovleColList,kpiValueStartInd,kpiValueList)
	 				s ^CacheTemp(repid,ind)=tempResovleColList
	 				s ind=ind+1
				}
			}
		}
	}
	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit
	//将listB从listA的位置startA处合并为一个list
MergeList104(listA,startA,listB)
	s listLen=$ll(listB)
	f listIndex=1:1:listLen {
	s $li(listA,listIndex+startA)=$lg(listB,listIndex)
	}
	q listA*/
	s conType=""
	f {
		s conType=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType))
		q:conType=""
		s monId="" 
		f {
			s monId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)) 
			q:monId=""  
			s contractCode=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId)
			s dimIdList=""
			for{
				s dimIdList=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList))
				q:dimIdList=""
				s kpiIdList="",kpiValueList=$lb() 
				s kpiId="" 
				f {
					s kpiId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList,kpiId)) 
					q:kpiId=""
					i kpiIdList="" {
						s kpiIdList=kpiId
					}else{
	 					s kpiIdList=kpiIdList_KPIDELI_kpiId
					}

					s kpiPos=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList,kpiId,""))
				
	 				s $li(kpiValueList,kpiPos)=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList,kpiId)
	 				s dimDesList=^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monId,dimIdList,kpiId,kpiPos)
				}

	 			s tempResovleColList=$lb(kpiIdList,contractCode)
	 			for i=($ll(kpiValueList)+1):1:dimValMaxNum{
	 				s $list(kpiValueList,i)=0
	 			}
	 			

	 			s tempResovleColList=$$MergeList104(tempResovleColList,secStartInd,monId)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,dimIdStartInd,dimIdList)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,dimDesStartInd,dimDesList)
	 			s tempResovleColList=$$MergeList104(tempResovleColList,kpiValueStartInd,kpiValueList)
	 			s ^CacheTemp(repid,ind)=tempResovleColList
	 			s ind=ind+1 

			}
		}
	}
	k ^||TEMPDHCWLKPIDATA("G",$j),^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j),^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	Quit
	//将listB从listA的位置startA处合并为一个list
MergeList104(listA,startA,listB)
	s listLen=$ll(listB)
	f listIndex=1:1:listLen {
	s $li(listA,listIndex+startA)=$lg(listB,listIndex)
	}
	q listA
	//s $li(listA,startA+1,startA+1)=listB
	//q listA
}

ClassMethod setConMonDimKpiData(conType, monDescList, dimDesList, kpiID, kpiPos, contractTypeCode, dimIDList, monID, dimsID)
{
	s secDimPro=""
	f {
		
		s secDimPro=$o(^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro))	
		q:secDimPro=""

		if ((conTypeName'="") && (+monID'=0)) {
		 	//s monDesc=monDesc_"||"_conTypeName
		 	s conMonID=aryKpiConMon(kpiID,conType,monID)
		 	if (conMonID'=""){
			 	s monDesc=$li(^DHCWL.MKPI.MonthsD(conMonID),3)
		 	}else{
				s febMonDesc=$lg(^DHCWL.MKPI.MonthsD(monID),5)
				s febMonDesc=$p(febMonDesc,"-",2,$l(febMonDesc,"-"))
				if febMonDesc="02-29" s monDesc=$lg(^DHCWL.MKPI.MonthsD(monID),3)_"-"
			}
		 	s monDesc=monDesc_conTypeName	
		}					
		s monDescList=$lb(monDesc,,,,)
		//区间维度属性处理，值保存到secProList里面
		if secDimPro'="NOTEXIST" {	//区间维度存在
			//b:secDimPro="周六,是"
			s secProList=$lfs(secDimPro,",")
			s $li(monDescList,2,2)=secProList
		}	
	
		s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList)=contractTypeCode 
		//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID,kpiPos)=dimIDList 
		//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID)=$g(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimDesList,kpiID))+^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)
		//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,dimDesList,kpiID,kpiPos)=dimIDList 
		//s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,dimDesList,kpiID)=$g(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,dimDesList,kpiID))+^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)
		s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,kpiID,kpiPos)=dimDesList 
		s ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,kpiID)=$g(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,conType,monDescList,dimIDList,kpiID))+^||TEMPDHCWLKPIDATA("G",$j,conType,monID,dimsID,kpiID,secDimPro)


		
	}
}

}
