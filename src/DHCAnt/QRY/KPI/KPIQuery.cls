/// CTOR:QP
/// DATE:2017-05-05
/// DESC:扩展综合查询模块标准Query,以及放置优化或新增的功能
Class DHCAnt.QRY.KPI.KPIQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
	
	AdjustOutputPos
	OutputGrid
	setConMonDimKpiData
	ExchangeNodePos
*/
/// QP ADD 2016-12-16
/// d ##class(%ResultSet).RunQuery("DHCAnt.QRY.KPIQuery","KpiQueryGrideShow","2012-11-3","2012-11-3",,"MZDocGhf,MZDocZcf","MZDocGhf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc}\[ 内科),MZDocZcf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc} \[ 内科)",,"PP")
/// d ##class(%ResultSet).RunQuery("DHCAnt.QRY.KPIQuery","KpiQueryGrideShow","2016-09-01","2016-09-01",,"MZDocGhf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode,MZDocZcf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode","MZDocGhf:( {RegLoc} =137,242,203),MZDocZcf:(  {RegLoc} =137,242,203)")     "MZDocGhf:([[ [{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家] ]] || [ {RegType.Des} \[专家] ),MZDocZcf:([[[{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家]]] || [ {RegType.Des} \[专家])",,"PP")
/// Para:startDate、endDate、dateType、kpiRule
/// 		filterRule、mode
/// Desc:扩展标准Query维度支持到30，以后凡是报表中维度超过16的，不要在引用之前的，需要引用本Query【指标系统4.3】
Query KpiQueryGrideShow(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Query(ROWSPEC = "kpi:%String,contractTye:%String,month:%String,monthCol2:%String,monthCol3:%String,monthCol4:%String,monthCol5:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimIdCol17:%String,dimIdCol18:%String,dimIdCol19:%String,dimIdCol20:%String,dimIdCol21:%String,dimIdCol22:%String,dimIdCol23:%String,dimIdCol24:%String,dimIdCol25:%String,dimIdCol26:%String,dimIdCol27:%String,dimIdCol28:%String,dimIdCol29:%String,dimIdCol30:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,dimDesCol17:%String,dimDesCol18:%String,dimDesCol19:%String,dimDesCol20:%String,dimDesCol21:%String,dimDesCol22:%String,dimDesCol23:%String,dimDesCol24:%String,dimDesCol25:%String,dimDesCol26:%String,dimDesCol27:%String,dimDesCol28:%String,dimDesCol29:%String,dimDesCol30:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod KpiQueryGrideShowExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Status
{

 	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
 	;调试时候打开注释 QP
 	;s ^TEMP("QP",1)=filterRule
 	;s ^TEMP("QP",2)=dateType_"!"_kpiRule_"!"_mode_"!"_contract_"!"_dynParam_"!"_execParam
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 		
	s KPIINFOMAXCOL=1,MAXMONTHCOL=5,MAXDIMDESCOL=30,MAXDIMIDCOL=30,MAXKPIVALCOL=30,MONDELI=";",KPIDELI=";"
	s secStartInd=KPIINFOMAXCOL+1,dimIdStartInd=secStartInd+MAXMONTHCOL,dimDesStartInd=dimIdStartInd+MAXDIMIDCOL,kpiValueStartInd=dimDesStartInd+MAXDIMDESCOL
 	//Query by dataSet addedby lhh@20140312
 	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(kpiRule)
 	if ($ISOBJECT(datasetObj)) {
		 s kpiRule=datasetObj.DatasetRuleList
 		 if (filterRule=""){
		 	s filterRule=datasetObj.DatasetFilterList
		 }
		 s filterRule=##class(DHCWL.MKPIService.KpiFilter).handleFilterParam(filterRule,dynParam)
	}
	//解析过滤规则
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	//解析取数规则
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resolve) //firstly resolve the param
 	
 	//解析取数规则：按照取数规则中维度的先后顺序来显示查询结果集。
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule,.resovledRuleArr)

 	i $g(endDate)="" s endDate=$g(startDate)
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	q:monthId="" $$$OK
	
	s gblFlag="TEMPKPIDATA"
	//清除global
	k ^TEMPDHCWLKPIDATA(gblFlag,$j)
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	//根据取数规则，monthID,取数模式，生成一个数组。数据结构为：aryKpiConMon(kpiID,比对标识,monthid1)=monthid2
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.resolve, monthId,contract,.aryKpiConMon)
	//获取指标数据
	//s kpiIdList=$g(resovledRuleArr("KPILIST"))
	
	d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree)

	
	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData2(gblFlag,.aryKpiConMon,.resolve,.filterTree,execParam)
	
	//
	k ^||TEMPDHCWLKPIDATA("G",$j)
	//把数据由^TEMPDHCWLKPIDATA("TEMPKPIDATA")节点转换到^TEMPDHCWLKPIDATA("G"),并交换kpiID和dimIDs的节点位置
	d ##class(DHCWL.MKPIService.MKPIQuery).ExchangeNodePos()
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	s gblFlag="G"
	
	d ##class(DHCWL.MKPIService.MKPIQuery).AdjustOutputPos(.resovledRuleArr)
	
	d ##class(DHCWL.MKPIService.MKPIQuery).OutputGrid()
	
	
 	// Added by JEFF @2013-11-13
 	//s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
 	//s loginTypeDr=login("LoginTypeDr")
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
 		s login("CalledFunction")="class(DHCAnt.QRY.KPI.KPIQuery).KpiQueryGrideShow()"
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
 	// Added by JEFF @2013-11-13
 	
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

}
