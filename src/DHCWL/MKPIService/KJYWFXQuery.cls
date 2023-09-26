/// 名称: DHCWL.MKPIService.KJYWFXQuery
/// 描述: 抗菌药物分析数据的查询
/// 编写者：lxc
/// 编写日期:2012-07-27
/// 
Class DHCWL.MKPIService.KJYWFXQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","KpiQueryGrideShow","2016-06","2016-06","byMonth","KPPDD150102A:Loc^phcdf,KPPDD150202B:Loc^phcdf,KPPDD150202C:Loc^phcdf","",,"")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","KpiQueryGrideShow","2016-11-3","2016-12-3",,"KP1577","","R","")
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","KpiQueryGrideShow","2012-11-1","2012-11-1",,"MZDocGhf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode,MZDocZcf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegDoc.DocCode","MZDocGhf:( {RegLoc} =137,242,203),MZDocZcf:(  {RegLoc} =137,242,203)")     "MZDocGhf:([[ [{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家] ]] || [ {RegType.Des} \[专家] ),MZDocZcf:([[[{RegLoc.Loc}\[血液科门诊]&&![{RegType.Des}\[专家]]] || [ {RegType.Des} \[专家])",,"PP")
Query KpiQueryGrideShow(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam As %Text = "", execParam As %Text = "") As %Query(ROWSPEC = "kpi:%String,contractTye:%String,month:%String,monthCol2:%String,monthCol3:%String,monthCol4:%String,monthCol5:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimIdCol17:%String,dimIdCol18:%String,dimIdCol19:%String,dimIdCol20:%String,dimIdCol21:%String,dimIdCol22:%String,dimIdCol23:%String,dimIdCol24:%String,dimIdCol25:%String,dimIdCol26:%String,dimIdCol27:%String,dimIdCol28:%String,dimIdCol29:%String,dimIdCol30:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,dimDesCol17:%String,dimDesCol18:%String,dimDesCol19:%String,dimDesCol20:%String,dimDesCol21:%String,dimDesCol22:%String,dimDesCol23:%String,dimDesCol24:%String,dimDesCol25:%String,dimDesCol26:%String,dimDesCol27:%String,dimDesCol28:%String,dimDesCol29:%String,dimDesCol30:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod KpiQueryGrideShowExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam As %Text = "", execParam As %Text = "") As %Status
{

 	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
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
	
	d ##class(DHCWL.MKPIService.MKPIQuery).OutputGrid(MAXKPIVALCOL)
	
	
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

// w ##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData("3,8,9","1,2",.list)

/// Creator：      ban
/// CreatDate：    2012-03-26
/// Description:： 获取DHCWL.MKPI.DeptKPIData表中科室指标数据
/// Table：       DHCWL_MKPI.DHCWLMKPIData
/// Input：       monIdStr:区间id指标串,用逗号分隔,如:"1,2,3",kpiId:kpi指标串,用逗号分隔.
/// Output：      data:返回各科,各指标的指标值,data(monId,monKPIId,loc),monKPIId:指标Id,loc:科室id,monId:区间Id
/// Return：      retStatus:成功则返回1,执行失败返回0 ;
/// Others：      根据指标id和区间id获取DHCWL.MKPI.DeptKPIData表中科室指标数据,以数组形式返回
ClassMethod GetMutiMonKPIData(monIdStr, KPIIdStr, ByRef data) As %Status
{
		
	n (monIdStr,KPIIdStr,data)
	q:monIdStr="" 1
	q:KPIIdStr="" 1
	s monIdLen=$l(monIdStr,",")
	s kpiIdLen=$l(KPIIdStr,",")
	f lenKPI=1:1:kpiIdLen d
	.s kpiId=$p(KPIIdStr,",",lenKPI)
	.q:kpiId=""
	.
	.f len=1:1:monIdLen d
	..s monId=$p(monIdStr,",",len)
	..q:monId=""
	..s monKPIId=0
	..f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,monKPIId)) q:monKPIId=""  d
	...s deptKPIId=0
	...f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:deptKPIId=""  d
	....s loc=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2)
	....s value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	....;s data(+loc)=$g(data(+loc))+value
	....s data(monId,kpiId,loc)=$g(data(monId,kpiId,loc))+value
 
	
	q 1
}

// d ##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1("753","287")

/// Creator：      lxc
/// CreatDate：    2012-12-13
/// Description:： 获取DHCWL.MKPI.DeptKPIData表中科室指标数据
/// Table：       DHCWL_MKPI.DHCWLMKPIData
/// Input：       monIdStr:区间id指标串,用逗号分隔,如:"1,2,3",kpiId:kpi指标串,用逗号分隔.
/// Output：      data:返回各科,各指标的指标值,data(monId,monKPIId,loc),monKPIId:指标Id,loc:科室id,monId:区间Id
/// Return：      retStatus:成功则返回1,执行失败返回0 ;, ByRef data
/// Others：      根据指标id和区间id获取DHCWL.MKPI.DeptKPIData表中科室指标数据,以Glob形式返回
/// 注释：        区别于GetMutiMonKPIData,用^Tempdata，因为碰到大数据量，数组会超上限。
ClassMethod GetMutiMonKPIData1(monIdStr, KPIIdStr) As %Status
{
		
	n (monIdStr,KPIIdStr)
	q:monIdStr="" 1
	q:KPIIdStr="" 1
	s monIdLen=$l(monIdStr,",")
	s kpiIdLen=$l(KPIIdStr,",")
	f lenKPI=1:1:kpiIdLen d
	.s kpiId=$p(KPIIdStr,",",lenKPI)
	.q:kpiId=""
	.f len=1:1:monIdLen d
	..s monId=$p(monIdStr,",",len)
	..q:monId=""
	..s monKPIId=0
	..f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,monKPIId)) q:monKPIId=""  d
	...s deptKPIId=0
	...f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:deptKPIId=""  d
	....s loc=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2)
	....s value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	....;s data(monId,kpiId,loc)=$g(data(monId,kpiId,loc))+value
	....s ^Tempdata($j,"DHCWLXC",monId,kpiId,loc)=$g(^Tempdata($j,"DHCWLXC",monId,kpiId,loc))+value
  
	
	q 1
}

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKJYWXh","2008-12","2008-12","","MzKjywXhe,ZyKjywXhe,MzKjywXhDDD,ZyKjywXhDDD'","","","M","gzfl")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKJYWXh","2012-12-01","2012-12-04","","MzKjywXhe,ZyKjywXhe,MzKjywXhDDD,ZyKjywXhDDD","","","D","1","")

// 数组存储改为global形式

/// Creator：      lxc
/// CreatDate：    2012-07-27
/// Description:： 按照区间和指标查找值
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       dept:科室id串,","分隔;kpiCodeStr:指标code串,","分隔;drug:药物id串,","分隔；
///               gzfl:管制分类id串,","分隔;type:日(D)、月(M)、季(Q)、年(Y)标志,","分隔;
///               rptID:标识不同报表的标志,不同标示,汇总值的条件不一样。
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%Float:值
/// Return：      
/// Others：      抗菌药物消耗情况统计
ClassMethod GetKJYWXhExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStr As %String, drug As %String, gzfl As %String, type As %String, rptID As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStr,drug,gzfl,type,rptID,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
	q:rptID="" $$$OK
    k ^TEMPDHCWL($j),^tempdep($j),^tempdrg($j),^tempgzfl($j),^Tempdata($j,"DHCWLXC") 
    
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
	q:kpiCodeStr="" 1
		
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStr) ;,.data)
	q:sc'=1 1
	;q:'$d(data) 1
    
    d SplitMulitData1(dept,,.deptData)
	d SplitMulitData1(kpiIdStr,,.kpiIdStrData)
	d SplitMulitData1(drug,,.drugData)
	d SplitMulitData1(gzfl,,.gzflData)
	d SplitMulitData1(hospid,,.hospidData)
	
	s monId=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId1=0
	..f  s dimId1=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId1)) q:dimId1=""  d
    ...s dimId=$p(dimId1,",",1) ;q:dimId=""
    ...s gzflId=$p(dimId1,",",4) 
    ...;s ylfl=$p(dimId1,",",5)
    ...s drgId=$p(dimId1,",",6) 
        
    ...;i $d(^PHCD(drgId)) s drgName=$P(^PHCD(drgId,1),"^",2)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	
	...//判断指标是否为所选指标
	...q:(kpiIdStr'="")&&(kpiId="")  
	...q:(kpiIdStr'="")&&('$d(kpiIdStrData(kpiId)))
	
	...//判断管制分类是否为所选分类
	...q:(gzfl'="")&&(gzflId="")  
	...q:(gzfl'="")&&('$d(gzflData(gzflId)))
    
    ...//判断抗菌药物是否为所选药物
	...q:(drgId="")&&(drug'="")
	...q:(drug'="")&&('$d(drugData(drgId)))
 	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId1)) 
	...i rptID="1" s ^TEMPDHCWL($j,kpiId,dimId,drgId)=$g(^TEMPDHCWL($j,kpiId,dimId,drgId))+value
	...i rptID="deppm" s ^tempdep($j,kpiId,dimId)=$g(^tempdep($j,kpiId,dimId))+value
	...i rptID="drgpm" s ^tempdrg($j,kpiId,drgId)=$g(^tempdrg($j,kpiId,drgId))+value
	...i rptID="gzfl" s ^tempgzfl($j,kpiId,gzflId)=$g(^tempgzfl($j,kpiId,gzflId))+value
	
	i rptID="1" d
    .s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,kpiId)) q:kpiId=""  d
    ..s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,kpiId,dimId)) q:dimId=""  d
    ...s drgId=0 f  s drgId=$o(^TEMPDHCWL($j,kpiId,dimId,drgId)) q:drgId=""  d
    ....s fee=$g(^TEMPDHCWL($j,kpiId,dimId,drgId)) 
    ....d OutPutRow1
    
    i rptID="deppm" d
    .s kpiId=0 f  s kpiId=$o(^tempdep($j,kpiId)) q:kpiId=""  d
    ..s dimId=0 f  s dimId=$o(^tempdep($j,kpiId,dimId)) q:dimId=""  d
    ...s fee=$g(^tempdep($j,kpiId,dimId)) 
    ...d OutPutRow1dep
    
    i rptID="drgpm" d
    .s kpiId=0 f  s kpiId=$o(^tempdrg($j,kpiId)) q:kpiId=""  d
    ..s drgId=0 f  s drgId=$o(^tempdrg($j,kpiId,drgId)) q:drgId=""  d
    ...s fee=$g(^tempdrg($j,kpiId,drgId)) 
    ...d OutPutRow1drg
    
    i rptID="gzfl" d
    .s kpiId=0 f  s kpiId=$o(^tempgzfl($j,kpiId)) q:kpiId=""  d
    ..s gzflId=0 f  s gzflId=$o(^tempgzfl($j,kpiId,gzflId)) q:gzflId=""  d
    ...s fee=$g(^tempgzfl($j,kpiId,gzflId)) 
    ...d OutPutRow1gzfl
    
    k ^TEMPDHCWL($j),^tempdep($j),^tempdrg($j),^tempgzfl($j)
	
	Quit $$$OK
OutPutRow1
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^PHCD(drgId)) s drgName=$P(^PHCD(drgId,1),"^",2)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimId)
    ;i hosp="" s hosp=$o(^CT("HOSP"),-1)
    q:'$d(^PHCD(drgId)) 
    s subcat=$p(^PHCD(+drgId,1),"^",3)  ;q:+subcat'=16  //抗菌素
    s child=$p(subcat,"||",2) q:child="" 
    q:'$d(^PHCC(+subcat,"SC",child))
    s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
       
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimId,dimDesc,subcatna,drgId,drgName,fee,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow1dep
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimId)
    i drug="" d
    .s drgId="",drgName="",subcatna=""
    e  d
    .s drgId=drug
    .s drgName=$P(^PHCD(drgId,1),"^",2)
    .q:'$d(^PHCD(drgId)) 
    .s subcat=$p(^PHCD(+drgId,1),"^",3)  ;q:+subcat'=16  //抗菌素
    .s child=$p(subcat,"||",2) q:child="" 
    .q:'$d(^PHCC(+subcat,"SC",child))
    .s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
    
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimId,dimDesc,subcatna,drgId,drgName,fee,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow1drg
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^PHCD(drgId)) s drgName=$P(^PHCD(drgId,1),"^",2)
    q:'$d(^PHCD(drgId)) 
    s subcat=$p(^PHCD(+drgId,1),"^",3)  ;q:+subcat'=16  //抗菌素
    s child=$p(subcat,"||",2) q:child="" 
    q:'$d(^PHCC(+subcat,"SC",child))
    s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
    i dept=""  d
    .s dimId="",dimDesc="" 
    e  d
    .s dimId=dept,dimDesc=$$GetDepDesc^DHCWLCommon(dept)
    
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimId,dimDesc,subcatna,drgId,drgName,fee,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow1gzfl
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
    
    s subcatna="",drgId="",drgName=""
    
	s Data=$lb(kpiId,kpiCode,kpiDesc,gzflId,gzfldesc,subcatna,drgId,drgName,fee,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q	
SplitMulitData1(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKJYWXhFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKJYWXhExecute ]
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

ClassMethod GetKJYWXhClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKJYWXhExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKJYWXh(startDate As %String, endDate As %String, dept As %Text, kpiCodeStr As %String, drug As %String, gzfl As %String, type As %String, rptID As %String, hospid As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,subcatna:%String,drgId:%String,drgName:%String,value:%Float,hospna:%String") [ SqlProc ]
{
}

// 抗菌药物使用统计

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatAntiDrugInfo","2013-03-01","2013-03-31","I","","")	

ClassMethod GetPatAntiDrugInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, pattype As %String, hospid As %String, deptid As %Text) As %Status
{
	n (qHandle,SDate,EDate,pattype,deptid,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:pattype="" $$$OK
    
    k ^TEMPDHCWL($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData2(deptid,,.deptidData)
	d SplitMulitData2(hospid,,.hospidData)
	
	f DisDate=SDate:1:EDate d
	.s ts="",PADRowid=0 
	.i pattype="I" d
	..f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	...s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADI(PADRowid),"^",5)  ;出院科室
    ...//判断科室是否为所选科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="")  
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ...s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9)  ;q:AntiFlag'=1 ;抗菌药物使用标志
    ...s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;q:OperHealLeve'=1 ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;q:OperPreTime'=1 ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;q:OperConTime'=1 ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ...s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ...s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    ...s ^TEMPDHCWL($j,"总人数",dept)=$g(^TEMPDHCWL($j,"总人数",dept))+1
    ...i (AntiFlag="1")  s ^TEMPDHCWL($j,"抗菌药物使用",dept)=$g(^TEMPDHCWL($j,"抗菌药物使用",dept))+1
    ...i ((AntiFlag="1") && (SpAntFlag="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物",dept))+1
    ...i ((AntiFlag="1") && (LimAntFlag="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物",dept))+1
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (SpMedAnti="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物治疗",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物治疗",dept))+1  ;2013-01-22 lxc add 
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (LimMedAnti="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物治疗",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物治疗",dept))+1 ;2013-01-22 lxc add 
    ...i (OperHealLeve="1") s ^TEMPDHCWL($j,"1类切口总",dept)=$g(^TEMPDHCWL($j,"1类切口总",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防",dept)=$g(^TEMPDHCWL($j,"1类切口预防",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",dept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",dept))+1   ;2013-01-22 lxc xiugai 
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",dept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-01-22 lxc xiugai   
    ...i ((AntiFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"同期使用抗菌药物总例数",dept)=$g(^TEMPDHCWL($j,"同期使用抗菌药物总例数",dept))+1
    ...i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimMedAnti="1")) s ^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",dept))+1
    
    ...s ^TEMPDHCWL($j,"DDD",dept)=$g(^TEMPDHCWL($j,"DDD",dept))+AntiDDD
    ...i ((AntiFlag="1") && (SpAntFlag="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物DDD",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物DDD",dept))+SpAntDDD
    ...s ts=DisDate-admdate
    ...s ^TEMPDHCWL($j,"人天数",dept)=$g(^TEMPDHCWL($j,"人天数",dept))+ts
	
	...i ((AntiFlag="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"预防使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"预防使用抗菌药物",dept))+1  ;2013-04-25 lxc add 潍坊项目
	...i ((AntiFlag="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"预防抗菌药物时间在0.5-2h内",dept)=$g(^TEMPDHCWL($j,"预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-04-25 lxc add 潍坊项目
	
	.e  d
	..f  s PADRowid=$o(^DHCWLPADI(0,"AdmDate",DisDate,PADRowid)) q:PADRowid=""  d
    ...s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADI(PADRowid),"^",5) ;出院科室
	...//判断科室是否为所选科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...;s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   

    ...s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9) ;抗菌药物使用标志
    ...s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ...s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ...s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    
    ...s ^TEMPDHCWL($j,"总人数",dept)=$g(^TEMPDHCWL($j,"总人数",dept))+1
    ...i (AntiFlag="1")  s ^TEMPDHCWL($j,"抗菌药物使用",dept)=$g(^TEMPDHCWL($j,"抗菌药物使用",dept))+1
    ...i ((AntiFlag="1") && (SpAntFlag="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物",dept))+1
    ...i ((AntiFlag="1") && (LimAntFlag="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物",dept))+1
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (SpMedAnti="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物治疗",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物治疗",dept))+1  ;2013-01-22 lxc add 
    ...i ((AntiFlag="1")  && (IsMedAnti="1") && (LimMedAnti="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物治疗",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物治疗",dept))+1 ;2013-01-22 lxc add 
    ...i (OperHealLeve="1") s ^TEMPDHCWL($j,"1类切口总",dept)=$g(^TEMPDHCWL($j,"1类切口总",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防",dept)=$g(^TEMPDHCWL($j,"1类切口预防",dept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",dept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",dept))+1   ;2013-01-22 lxc xiugai 
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",dept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-01-22 lxc xiugai   
    ...i ((AntiFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"同期使用抗菌药物总例数",dept)=$g(^TEMPDHCWL($j,"同期使用抗菌药物总例数",dept))+1
    ...i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",dept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimMedAnti="1")) s ^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",dept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",dept))+1
    
    ...s ^TEMPDHCWL($j,"DDD",dept)=$g(^TEMPDHCWL($j,"DDD",dept))+AntiDDD
    ...i ((AntiFlag="1") && (SpAntFlag="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物DDD",dept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物DDD",dept))+SpAntDDD
    ...s ts=DisDate-admdate
    ...s ^TEMPDHCWL($j,"人天数",dept)=$g(^TEMPDHCWL($j,"人天数",dept))+ts
    
    ...i ((AntiFlag="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"预防使用抗菌药物",dept)=$g(^TEMPDHCWL($j,"预防使用抗菌药物",dept))+1  ;2013-04-25 lxc add 潍坊项目
	...i ((AntiFlag="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"预防抗菌药物时间在0.5-2h内",dept)=$g(^TEMPDHCWL($j,"预防抗菌药物时间在0.5-2h内",dept))+1 ;2013-04-25 lxc add 潍坊项目
	   
    s type=0 f  s type=$o(^TEMPDHCWL($j,type)) q:type=""  d
    .s dept=0 f  s dept=$o(^TEMPDHCWL($j,type,dept)) q:dept=""  d
    ..s outdata=$g(^TEMPDHCWL($j,type,dept)) 
    ..d OutputRow2
    
    k ^TEMPDHCWL($j)
 	q $$$OK	
OutputRow2
    i $d(^CTLOC(dept)) d
    .s hos=$P($G(^CTLOC(dept)),"^",22)
    .s patdesc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    
    s Data=$lb(type,dept,patdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
SplitMulitData2(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 	
	q
}

ClassMethod GetPatAntiDrugInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoExecute ]
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

ClassMethod GetPatAntiDrugInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfo(SDate As %String, EDate As %String, pattype As %String, hospid As %String, deptid As %Text) As %Query(ROWSPEC = "type:%String,dept:%Integer,patdesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

// 科室指标,参数传输代码

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2013-04-12","2013-04-12","","RegLocOpNums","D","4")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2008-12","2008-12","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3","M","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2012-11-01","2012-11-10","","GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee","D","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2012-12-01","2012-12-03","","MRLocCyrs,GetCyLocFee,GetCyLocYLFee,GetCyLocYaoFee,GetCyLocKJYaoDDD,GetZyLocInjeCFJE,GetCyLocKJYaoFee,GetCyLocZYTS,MRKJLocCyrs,GetZyLocInjeRc,GetZyLocSyRc,GetZyKSYyTs","D","")

// 2014-12-08query屏蔽备份，zl

/*ClassMethod GetDepKPIExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    
    k ^TEMPDHCWL($j)
	
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data) 
	q:sc'=1 1  
	q:'$d(data) 1
	
	d SplitMulitData3(dept,,.deptData)
	d SplitMulitData3(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData3(hospid,,.hospidData)
    
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   

	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,kpiId,dimId)=$g(^TEMPDHCWL($j,kpiId,dimId))+value
	 
    s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,kpiId)) q:kpiId=""  d
    .s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,kpiId,dimId)) q:dimId=""  d
    ..s outdata=$g(^TEMPDHCWL($j,kpiId,dimId)) 
    ..d OutPutRow3
  
    k ^TEMPDHCWL($j)
	
	Quit $$$OK
OutPutRow3
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	;s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimId)
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimId,dimDesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData3(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepKPIExecute ]
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

ClassMethod GetDepKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepKPI(startDate As %String, endDate As %String, dept As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}
*/

// 科室指标,参数传输代码

// 细菌耐药GetXJNY改为取实时指标数据

// 2014-11-10  zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2012-12-01","2012-12-04","","GetXJNY","D","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2008-12","2008-12","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3","M","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2012-11","2012-11","","GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee","M","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPI","2012-12-01","2012-12-03","","MRLocCyrs,GetCyLocFee,GetCyLocYLFee,GetCyLocYaoFee,GetCyLocKJYaoDDD,GetZyLocInjeCFJE,GetCyLocKJYaoFee,GetCyLocZYTS,MRKJLocCyrs,GetZyLocInjeRc,GetZyLocSyRc,GetZyKSYyTs","D","")

ClassMethod GetDepKPIExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    
    k ^TEMPDHCWL("S",$j)
	
	s choiceType="C",isRealData=""
	i kpiCodeStrZb="GetXJNY" s isRealData="R"
	
	d SplitMulitData3(dept,,.deptData)
	d SplitMulitData3(kpiCodeStrZb,,.kpiCodeStrZbData)
	d SplitMulitData3(hospid,,.hospidData)
    
    	  
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpiCodeStrZb,startDate,endDate,choiceType,isRealData)
	
	While rs.Next(.sc) {
		s dimId=$g(rs.Data("dimId"))
		s dimdesc=$g(rs.Data("dimDesc")) 
		s kpiId=$g(rs.Data("kpiId"))
		s kpiCode=$g(rs.Data("kpiCode"))
		s kpiDesc=$g(rs.Data("kpiDesc"))
		s value=$g(rs.Data("value"))
		s dimIdLoc=$p(dimId,",",1)  
		i kpiCodeStrZb="GetXJNY" d
	    .s admId=$p(dimId,",",5)  
		.s dimIdLoc=$p(^PAADM(admId),"^",4) 
		//判断科室是否为所选科室
	 	continue:(dept'="")&&(dimIdLoc="") 
		continue:(dept'="")&&('$d(deptData(dimIdLoc)))
		//判断医院是否为所选医院
		s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
		i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
		continue:(hospid'="")&&(hosp="") 
		continue:(hospid'="")&&('$d(hospidData(hosp)))
		i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
		i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
		//判断指标是否为所选指标
		continue:(kpiCodeStrZb'="")&&(kpiCode="")  
		continue:(kpiCodeStrZb'="")&&('$d(kpiCodeStrZbData(kpiCode)))
		s ^TEMPDHCWL("S",$j,kpiId,dimId)=$g(^TEMPDHCWL("S",$j,kpiId,dimId))+value
	 }
    	s kpiId=0 f  s kpiId=$o(^TEMPDHCWL("S",$j,kpiId)) q:kpiId=""  d
    	.s dimId=0 f  s dimId=$o(^TEMPDHCWL("S",$j,kpiId,dimId)) q:dimId=""  d
    	..s outdata=$g(^TEMPDHCWL("S",$j,kpiId,dimId)) 
    	..d OutPutRow3
	
    	k ^TEMPDHCWL("S",$j)
	
		Quit $$$OK
OutPutRow3
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
    ;s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimId)
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimId,dimDesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData3(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepKPIExecute ]
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

ClassMethod GetDepKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepKPI(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataBJFX","2012","","","GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee","","1","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataBJFX","2012","375","","GetKJYWFee","","gzfl","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataBJFX","2012","","","MRLocCyrs,GetCyLocFee,GetCyLocYLFee,GetCyLocYaoFee,GetCyLocKJYaoDDD,GetZyLocInjeCFJE,GetCyLocKJYaoFee,GetCyLocZYTS,MRKJLocCyrs,GetZyLocInjeRc,GetZyLocSyRc,GetZyKSYyTs,GetZyLocSJBase,GetZyLocGJBase,GetZyLocKJInjeCFJE","I","1","")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析(病人科室收入分析用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataBJFX(year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimIdtype:%String,dimIdtypeNa:%String,dimId:%String,dimDesc:%String,dimIdDoc:%String,dimIdDocNa:%String,gzflId:%String,gzfldesc:%String,drgId:%String,arcdesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

ClassMethod GetKPIDataBJFXExecute(ByRef qHandle As %Binary, year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Status
{
	n (qHandle,year,mon,dept,kpiCodeStrZb,type,rptID,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:year="" $$$OK
	q:rptID="" $$$OK
	k ^TEMPDHCWL($j),^templdoc($j),^tempdrg($j),^tempgzfl($j),^tempdrgLocDoc($j)
	k ^templdocYear($j),^tempdrgYear($j),^tempgzflYear($j)
	k ^tempdrgLocDocYear($j),^tempYear($j)
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
    
    d SplitMulitData5(mon,,.monData)
	d SplitMulitData5(dept,,.deptData)
	d SplitMulitData5(type,,.typeData)
	d SplitMulitData5(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData5(hospid,,.hospidData)

	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.//判断科室是否为所选月份
	.q:(mon'="")&&(monId="") 
	.q:(mon'="")&&('$d(monData(monId)))
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...i $g(dimIdLoc)=""   s dimIdLoc="999999"  ;2013-04-10
	...s dimIdtype=$p(dimId,",",2)
	...;i dimIdtype="E" s dimIdtype="O"
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	
	...//判断类型是否为所选类型
	...q:(type'="")&&(dimIdtype="") 
	...q:(type'="")&&('$d(typeData(dimIdtype)))

	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype)=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype))+value
	...i mon="" d
	....s ^tempYear($j,kpiId,dimIdLoc,dimIdtype)=$g(^tempYear($j,kpiId,dimIdLoc,dimIdtype))+value
	...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee"  d 
	....s gzflId=$p(dimId,",",4)
	....s ylfl=$p(dimId,",",5)
	....s drgId=$p(dimId,",",6)
	....s dimIdDoc=$p(dimId,",",3) 
	....s ^templdoc($j,monId,kpiId,dimIdLoc,dimIdDoc,dimIdtype)=$g(^templdoc($j,monId,kpiId,dimIdLoc,dimIdDoc,dimIdtype))+value
	....s ^tempdrg($j,monId,kpiId,drgId,dimIdtype)=$g(^tempdrg($j,monId,kpiId,drgId,dimIdtype))+value
    ....s ^tempgzfl($j,monId,kpiId,gzflId,dimIdtype)=$g(^tempgzfl($j,monId,kpiId,gzflId,dimIdtype))+value
    ....s ^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)=$g(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype))+value
    ....i mon="" d
    .....s ^templdocYear($j,kpiId,dimIdLoc,dimIdDoc,dimIdtype)=$g(^templdocYear($j,kpiId,dimIdLoc,dimIdDoc,dimIdtype))+value
    .....s ^tempdrgYear($j,kpiId,drgId,dimIdtype)=$g(^tempdrgYear($j,kpiId,drgId,dimIdtype))+value
    .....s ^tempgzflYear($j,kpiId,gzflId,dimIdtype)=$g(^tempgzflYear($j,kpiId,gzflId,dimIdtype))+value
    .....s ^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)=$g(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype))+value
      
    i (rptID="1") d
	.s monId=0 f  s monId=$o(^TEMPDHCWL($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,monId,kpiId)) q:kpiId=""  d
    ...s dimIdLoc=0 f  s dimIdLoc=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ....s dimIdtype=0 f  s dimIdtype=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    .....s outdata=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype)) 
	.....d OutPutRow5
	
	i (rptID="Y1") d
    .s kpiId=0 f  s kpiId=$o(^tempYear($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^tempYear($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^tempYear($j,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    ....s outdata=$g(^tempYear($j,kpiId,dimIdLoc,dimIdtype)) 
	....d OutPutRow5Year
	
	i ((rptID="doc") & (mon'="")) d
    .s monId=0 f  s monId=$o(^templdoc($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^templdoc($j,monId,kpiId)) q:kpiId=""  d
    ...s dimIdLoc=0 f  s dimIdLoc=$o(^templdoc($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^templdoc($j,monId,kpiId,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    .....s dimIdtype=0 f  s dimIdtype=$o(^templdoc($j,monId,kpiId,dimIdLoc,dimIdDoc,dimIdtype)) q:dimIdtype=""  d
    ......s outdata=$g(^templdoc($j,monId,kpiId,dimIdLoc,dimIdDoc,dimIdtype)) 
	......d OutPutRow5Doc
	
	i ((rptID="doc") & (mon="")) d
    .s kpiId=0 f  s kpiId=$o(^templdocYear($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^templdocYear($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdDoc=0 f  s dimIdDoc=$o(^templdocYear($j,kpiId,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    ....s dimIdtype=0 f  s dimIdtype=$o(^templdocYear($j,kpiId,dimIdLoc,dimIdDoc,dimIdtype)) q:dimIdtype=""  d
    .....s outdata=$g(^templdocYear($j,kpiId,dimIdLoc,dimIdDoc,dimIdtype)) 
  	.....d OutPutRow5DocYear
	
	i ((rptID="drglocdoc") & (mon'="")) d
    .s monId=0 f  s monId=$o(^tempdrgLocDoc($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^tempdrgLocDoc($j,monId,kpiId)) q:kpiId=""  d
    ...s dimIdLoc=0 f  s dimIdLoc=$o(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    .....s gzflId=0 f  s gzflId=$o(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId)) q:gzflId=""  d
    ......s drgId=0 f  s drgId=$o(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId)) q:drgId=""  d
    .......s dimIdtype=0 f  s dimIdtype=$o(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)) q:dimIdtype=""  d
    ........s outdata=$g(^tempdrgLocDoc($j,monId,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)) 
	........d OutPutRow5DrgLocDoc

	i ((rptID="drglocdoc") & (mon="")) d
    .s kpiId=0 f  s kpiId=$o(^tempdrgLocDocYear($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^tempdrgLocDocYear($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdDoc=0 f  s dimIdDoc=$o(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    ....s gzflId=0 f  s gzflId=$o(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId)) q:gzflId=""  d
    .....s drgId=0 f  s drgId=$o(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId)) q:drgId=""  d
    ......s dimIdtype=0 f  s dimIdtype=$o(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)) q:dimIdtype=""  d
    .......s outdata=$g(^tempdrgLocDocYear($j,kpiId,dimIdLoc,dimIdDoc,gzflId,drgId,dimIdtype)) 
  	.......d OutPutRow5DrgLocDocYear
  	
	i ((rptID="drgpm") & (mon'="")) d
    .s monId=0 f  s monId=$o(^tempdrg($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^tempdrg($j,monId,kpiId)) q:kpiId=""  d
    ...s drgId=0 f  s drgId=$o(^tempdrg($j,monId,kpiId,drgId)) q:drgId=""  d
    ....s dimIdtype=0 f  s dimIdtype=$o(^tempdrg($j,monId,kpiId,drgId,dimIdtype)) q:dimIdtype=""  d
    .....s outdata=$g(^tempdrg($j,monId,kpiId,drgId,dimIdtype)) 
	.....d OutPutRow5drg
	
	i ((rptID="drgpm") & (mon="")) d
    .s kpiId=0 f  s kpiId=$o(^tempdrgYear($j,kpiId)) q:kpiId=""  d
    ..s drgId=0 f  s drgId=$o(^tempdrgYear($j,kpiId,drgId)) q:drgId=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^tempdrgYear($j,kpiId,drgId,dimIdtype)) q:dimIdtype=""  d
    ....s outdata=$g(^tempdrgYear($j,kpiId,drgId,dimIdtype)) 
	....d OutPutRow5drgYear
	
	i ((rptID="gzfl") & (mon'="")) d
    .s monId=0 f  s monId=$o(^tempgzfl($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^tempgzfl($j,monId,kpiId)) q:kpiId=""  d
    ...s gzflId=0 f  s gzflId=$o(^tempgzfl($j,monId,kpiId,gzflId)) q:gzflId=""  d
    ....s dimIdtype=0 f  s dimIdtype=$o(^tempgzfl($j,monId,kpiId,gzflId,dimIdtype)) q:dimIdtype=""  d
    .....s outdata=$g(^tempgzfl($j,monId,kpiId,gzflId,dimIdtype)) 
	.....d OutPutRow5gzfl
	
	i ((rptID="gzfl") & (mon="")) d
    .s kpiId=0 f  s kpiId=$o(^tempgzflYear($j,kpiId)) q:kpiId=""  d
    ..s gzflId=0 f  s gzflId=$o(^tempgzflYear($j,kpiId,gzflId)) q:gzflId=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^tempgzflYear($j,kpiId,gzflId,dimIdtype)) q:dimIdtype=""  d
    ....s outdata=$g(^tempgzflYear($j,kpiId,gzflId,dimIdtype)) 
	....d OutPutRow5gzflYear
	
	k ^TEMPDHCWL($j),^templdoc($j),^tempdrg($j),^tempgzfl($j),^tempdrgLocDoc($j)
	k ^templdocYear($j),^tempdrgYear($j),^tempgzflYear($j)
	k ^tempdrgLocDocYear($j),^tempYear($j)
	Quit $$$OK
OutPutRow5
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s drgId="",arcdesc="",gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5Year
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s drgId="",arcdesc="",gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5Doc
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    s drgId="",arcdesc="",gzflId="",gzfldesc=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5DocYear
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s drgId="",arcdesc="",gzflId="",gzfldesc=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5DrgLocDoc
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5DrgLocDocYear
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
	s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5drg
    i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    s dimIdLoc="",dimDesc="",gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5drgYear
    i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2)
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    s dimIdLoc="",dimDesc="",gzflId="",gzfldesc="",monId="",modDesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow5gzfl
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s drgId="",arcdesc="",dimIdLoc="",dimDesc="",dimIdDoc="",dimIdDocNa=""
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 
OutPutRow5gzflYear
	i type="" s dimIdtypeNa="全院"
	i type="I" s dimIdtypeNa="住院"
	i ((type="O") ! (type="E") ! (type="O,E") ! (type="E,O")) s dimIdtypeNa="门诊"
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
	s drgId="",arcdesc="",dimIdLoc="",dimDesc="",monId="",modDesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 
SplitMulitData5(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataBJFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataBJFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataBJFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataBJFXExecute ]
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

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataMZCFFX","2012","","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3","","Y1","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataMZCFFX","2012","","","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs,RegLocOpNums,MzKJYRc,MzInjeRc,MzSyRc","","1","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataMZCFFX","2012","","","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs","","1","")

/// Creator：      lxc
/// CreatDate：    2012-09-19	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析(门诊处方分析用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// 维度：处方类型（西药、成药、中草药）、处方科室、是否抗菌素处方、是否1类抗菌素处方、是否2类抗菌素处方、是否3类抗菌素处方、发药科室  
/// Return：  
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataMZCFFX(year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimIdtype:%String,dimIdtypeNa:%String,dimId:%String,dimDesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

ClassMethod GetKPIDataMZCFFXExecute(ByRef qHandle As %Binary, year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Status
{
	n (qHandle,year,mon,dept,kpiCodeStrZb,type,rptID,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:year="" $$$OK
	q:rptID="" $$$OK
	k ^TEMPDHCWL($j),^tempYear($j),^Tempdata($j,"DHCWLXC")   ;2013-04-10
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)  ;,.data)   ;2013-04-10
	q:sc'=1 1
	;q:'$d(data) 1
    
    d SplitMulitData6(mon,,.monData)
	d SplitMulitData6(dept,,.deptData)
	d SplitMulitData6(type,,.typeData)
	d SplitMulitData6(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData6(hospid,,.hospidData)


	s monId=""    
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.;w !,monId
	.//判断科室是否为所选月份
	.q:(mon'="")&&(monId="") 
	.q:(mon'="")&&('$d(monData(monId)))
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0 // 维度：处方类型（西药、成药、中草药）、处方科室、是否抗菌素处方、是否1类抗菌素处方、是否2类抗菌素处方、是否3类抗菌素处方、发药科室  
	..f  s dimId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdCflx=$p(dimId,",",1)
	...s dimIdLoc=$p(dimId,",",2) 
	...i $g(dimIdLoc)="" s dimIdLoc="999999"
	...s dimIdFyLoc=$p(dimId,",",3)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdCflx)=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdCflx))+value
	...;i mon="" d
	....;s ^tempYear($j,kpiId,dimIdLoc,dimIdCflx)=$g(^tempYear($j,kpiId,dimIdLoc,dimIdCflx))+value
	
    i (rptID="1") d
	.s monId=0 f  s monId=$o(^TEMPDHCWL($j,monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,monId,kpiId)) q:kpiId=""  d
    ...s dimIdLoc=0 f  s dimIdLoc=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ....s dimIdtype=0 f  s dimIdtype=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    .....s outdata=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdtype)) 
	.....d OutPutRow6
	/*
	i (rptID="Y1") d
    .s kpiId=0 f  s kpiId=$o(^tempYear($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^tempYear($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdtype=0 f  s dimIdtype=$o(^tempYear($j,kpiId,dimIdLoc,dimIdtype)) q:dimIdtype=""  d
    ....s outdata=$g(^tempYear($j,kpiId,dimIdLoc,dimIdtype)) 
	....d OutPutRow6Year
	*/
	k ^TEMPDHCWL($j),^tempYear($j),^Tempdata($j,"DHCWLXC")
	Quit $$$OK
OutPutRow6
	i $d(^ARCBG(dimIdtype)) s dimIdtypeNa=$p(^ARCBG(dimIdtype),"^",2)
	;i $d(^ARC("IC",dimIdtype)) s dimIdtypeNa=$p(^ARC("IC",dimIdtype),"^",2)
	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
 /* 	
OutPutRow6Year
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s drgId="",arcdesc="",gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdtype,dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
  */
SplitMulitData6(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataMZCFFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataMZCFFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataMZCFFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataMZCFFXExecute ]
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

// 科室指标,参数传输代码,科室抗菌处方排名分析用

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWCF","2012-11-01","2012-11-27","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3","D","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWCF","2012-06","2012-06","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3","D","3")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWCF","2012-06-01","2012-07-03","224","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs,RegLocOpNums,MzKJYRc,MzInjeRc,MzSyRc","D","","doc")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWCF","2012-06-01","2012-07-01","","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs,RegLocOpNums,MzKJYRc,MzInjeRc,MzSyRc,InjeCFJE,MzKJInjeRc,KJInjeCFJE","D","","doc")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWCF","2012-06-01","2012-07-01","","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs,RegLocOpNums,MzKJYRc,MzInjeRc,MzSyRc,InjeCFJE,MzKJInjeRc,KJInjeCFJE","M","","doc")

ClassMethod GetDepKPIKJYWCFExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,hospid,flag1)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)  ;,.data) 2012-12-19 lxc
	q:sc'=1 1
	;q:'$d(^Tempdata($j)) 1
	
	d SplitMulitData7(dept,,.deptData)
	d SplitMulitData7(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData7(hospid,,.hospidData)

	s monId=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId="",value=0,valueXy=0
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),2)
	..s dimIdnod=0,dimId="",doc=""
	..f  s dimIdnod=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod))                 
    ...i ((kpiDesc="RegLocOpNums") || (kpiDesc="MzKJYRc") || (kpiDesc="MzInjeRc") || (kpiDesc="MzSyRc") || (kpiDesc="JZRc") || (kpiDesc="JZKJRc") || (kpiDesc="JzCFRC")) d
    ....s dimId=$p(dimIdnod,",",1) 
    ....s doc=$p(dimIdnod,",",2)   i doc="" s doc="999999"
    ...i ((kpiDesc'="RegLocOpNums") && (kpiDesc'="MzKJYRc") && (kpiDesc'="MzInjeRc") && (kpiDesc'="MzSyRc") && (kpiDesc'="JZRc") && (kpiDesc'="JZKJRc") && (kpiDesc'="JzCFRC")) d
    ....s dimId=$p(dimIdnod,",",2)
    ....s Cftype=$p(dimIdnod,",",1) ;q:'$d(^ARCBG(Cftype))
    ....s fyLoc=$p(dimIdnod,",",3) 
    ....s doc=$p(dimIdnod,",",8) i doc="" s doc="999999"
    ....s Anti=$p(dimIdnod,",",4) ;抗菌标志
    ....s Inje=$p(dimIdnod,",",9) ;注射剂标志
    ...;i ($P(^ARCBG(Cftype),"^",2) [ "西药" ) s dimIdnodXy=Cftype_","_dimId_","_fyLoc,valueXy=+$g(data(monId,kpiId,dimIdnodXy))
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	...i (flag1="dep") d
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="RegLocOpNums")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"RegLocOpNums")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"RegLocOpNums"))+value //门诊人次	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKJYRc")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKJYRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKJYRc"))+value //门诊抗菌人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzInjeRc")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzInjeRc"))+value //门诊注射剂人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzSyRc")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzSyRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzSyRc"))+value //门诊静脉给药人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="InjeCFJE")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"InjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"InjeCFJE"))+value //门诊注射剂处方金额
	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZRc")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZRc"))+value //急诊人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZKJRc")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJRc"))+value //急诊抗菌人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZCFZS"))+value //急诊处方张数	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZCFJE"))+value //急诊处方金额 
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS") && (Anti=1)) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJCFZS"))+value //急诊使用抗菌药物处方数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") && (Anti=1)) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJCFJE"))+value //急诊使用抗菌药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS") && (Anti=1) && (Inje=1))  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJZSCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJZSCFZS"))+value //急诊抗菌药物注射剂使用处方数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") && (Anti=1) && (Inje=1))  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJZSCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JZKJZSCFJE"))+value //急诊抗菌药物注射剂使用处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JzCFRC")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"JzCFRC")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"JzCFRC"))+value //急诊处方人次  2013-05-09 lxc add 
	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFZS")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCnt"))+value //处方张数 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFee"))+value //处方金额 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCnt"))+value //处方药品数 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYyTs") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescfactor")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescfactor"))+value //处方用药天数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntXy"))+value //西药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeXy"))+value //西药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntXy"))+value //西药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntCy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntCy"))+value //草药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeCy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeCy"))+value //草药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntCy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntCy"))+value //草药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt"))+value	//抗菌药物处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee"))+value    //抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt"))+value	//抗菌药物处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJCFYyTs") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntifactor")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntifactor"))+value	//抗菌药物处方用药天数
	
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt1"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee1"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt1"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt2"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee2"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt2"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt3"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee3"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt3"))+value	//抗菌药物处处方药品数
	....;基本药物
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFZS") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFZS"))+value	//国家基本药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFJE") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFJE"))+value	//国家基本药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFYPZS") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFYPZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GJBaseCFYPZS"))+value	//国家基本药物处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFZS") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFZS"))+value	//省基本药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFJE") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFJE"))+value	//省基本药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFYPZS") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFYPZS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"SJBaseCFYPZS"))+value	//省基本药物处方药品数
    ....;抗菌药物注射剂
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKJInjeRc") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKJInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKJInjeRc"))+value	//抗菌药物注射剂人次
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJInjeCFJE") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"KJInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"KJInjeCFJE"))+value	//抗菌药物注射剂金额
    
    ...i (flag1="doc") d
    ....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="RegLocOpNums")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"RegLocOpNums")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"RegLocOpNums"))+value //门诊人次	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKJYRc")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"MzKJYRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MzKJYRc"))+value //门诊抗菌人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzInjeRc")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"MzInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MzInjeRc"))+value //门诊注射剂人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzSyRc")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"MzSyRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MzSyRc"))+value //门诊静脉给药人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="InjeCFJE")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"InjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"InjeCFJE"))+value //门诊注射剂处方金额
	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZRc")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZRc"))+value //急诊人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZKJRc")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJRc"))+value //急诊抗菌人次
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZCFZS"))+value //急诊处方张数	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZCFJE"))+value //急诊处方金额 
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS") && (Anti=1)) s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJCFZS"))+value //急诊使用抗菌药物处方数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") && (Anti=1)) s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJCFJE"))+value //急诊使用抗菌药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFZS") && (Anti=1) && (Inje=1))  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJZSCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJZSCFZS"))+value //急诊抗菌药物注射剂使用处方数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="JZCFJE") && (Anti=1) && (Inje=1))  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJZSCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JZKJZSCFJE"))+value //急诊抗菌药物注射剂使用处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="JzCFRC")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"JzCFRC")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"JzCFRC"))+value //急诊处方人次  2013-05-09 lxc add
	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFZS")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescCnt"))+value //处方张数	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescFee"))+value //处方金额 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCnt"))+value //处方药品数 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYyTs") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescfactor")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescfactor"))+value //处方用药天数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntXy"))+value //西药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeXy"))+value //西药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntXy"))+value //西药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntCy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntCy"))+value //草药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeCy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeCy"))+value //草药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntCy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntCy"))+value //草药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt"))+value	//抗菌药物处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee"))+value    //抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJCFYyTs") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntifactor")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntifactor"))+value	//抗菌药物处方用药天数
	
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt1"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee1"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt1"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt2"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee2"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt2"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt3"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee3"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt3"))+value	//抗菌药物处处方药品数
    ....;基本药物
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFZS") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFZS"))+value	//国家基本药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFJE") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFJE"))+value	//国家基本药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="GJBaseCFYPZS") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFYPZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GJBaseCFYPZS"))+value	//国家基本药物处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFZS") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFZS"))+value	//省基本药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFJE") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFJE"))+value	//省基本药物处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="SJBaseCFYPZS") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFYPZS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"SJBaseCFYPZS"))+value	//省基本药物处方药品数
    ....;抗菌药物注射剂
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKJInjeRc") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"MzKJInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MzKJInjeRc"))+value	//抗菌药物注射剂人次
    ....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJInjeCFJE") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"KJInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"KJInjeCFJE"))+value	//抗菌药物注射剂金额
    s dim=0 f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",dim)) q:dim=""  d
    .s MZRC=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"RegLocOpNums"))
    .s MZKJRC=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzKJYRc"))
    .s MZZSJRC=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzInjeRc"))
    .s MZSYRC=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzSyRc"))
    .s MZInjeCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"InjeCFJE"))
    
    .s CFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescCnt"))
    .s CFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescFee"))
    .s CFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescDrgCnt"))
    .s CFYyTs=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescfactor"))
    .s XyCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescCntXy"))
    .s XyCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescFeeXy"))
    .s XyCFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescDrgCntXy"))
    .s CyCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescCntCy"))
    .s CyCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescFeeCy"))
    .s CyCFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescDrgCntCy"))
    .s KJYWCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt"))
    .s KJYWCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee"))
    .s KJYWCFPZ=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt"))
    .s KJCFYyTs=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntifactor"))
    
    .s KJYWCFZS1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt1"))
    .s KJYWCFJE1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee1"))
    .s KJYWCFPZ1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt1"))
    .s KJYWCFZS2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt2"))
    .s KJYWCFJE2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee2"))
    .s KJYWCFPZ2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt2"))
    .s KJYWCFZS3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt3"))
    .s KJYWCFJE3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee3"))
    .s KJYWCFPZ3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt3"))
    .s GJBaseCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"GJBaseCFZS"))
    .s GJBaseCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"GJBaseCFJE"))
    .s GJBaseCFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"GJBaseCFYPZS"))
    .s SJBaseCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"SJBaseCFZS"))
    .s SJBaseCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"SJBaseCFJE"))
    .s SJBaseCFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"SJBaseCFYPZS"))
    .s BaseCFZS=GJBaseCFZS+SJBaseCFZS
    .s BaseCFJE=GJBaseCFJE+SJBaseCFJE
    .s BaseCFYPZS=GJBaseCFYPZS+SJBaseCFYPZS
    .s MzKJInjeRc=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzKJInjeRc"))
    .s KJInjeCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"KJInjeCFJE"))
    
    .s JZRc=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZRc"))
    .s JZKJRc=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZKJRc"))
    .s JZCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZCFZS"))
    .s JZCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZCFJE"))
    .s JZKJCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZKJCFZS"))
    .s JZKJCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZKJCFJE"))
    .s JZKJZSCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZKJZSCFZS"))
    .s JZKJZSCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JZKJZSCFJE"))
    .s JzCFRC=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"JzCFRC"))
    .d OutPutRow7
     
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
	Quit $$$OK
OutPutRow7
    i ((flag1="dep") && $d(^CTLOC(dim)))  d  
    .s dimDesc1=$P($G(^CTLOC(dim)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((flag1="doc") && $d(^CTPCP(dim))) d
    .s dimDesc=$$GetPatDoc^DHCWLCommon(dim)
    .e  s dimDesc="Null"
    
	s Data=$lb(dim,dimDesc,MZRC,MZKJRC,MZZSJRC,MZSYRC,MZInjeCFJE,CFZS,CFJE,CFYPZS,CFYyTs,XyCFZS,XyCFJE,XyCFYPZS,CyCFZS,CyCFJE,CyCFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3,GJBaseCFZS,GJBaseCFJE,GJBaseCFYPZS,SJBaseCFZS,SJBaseCFJE,SJBaseCFYPZS,BaseCFZS,BaseCFJE,BaseCFYPZS,MzKJInjeRc,KJInjeCFJE,JZRc,JZKJRc,JZCFZS,JZCFJE,JZKJCFZS,JZKJCFJE,JZKJZSCFZS,JZKJZSCFJE,hospna,JzCFRC)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData7(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepKPIKJYWCFFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepKPIKJYWCFExecute ]
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

ClassMethod GetDepKPIKJYWCFClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepKPIKJYWCFExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepKPIKJYWCF(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String) As %Query(ROWSPEC = "dim:%String,dimDesc:%String,MZRC:%Float,MZKJRC:%Float,MZZSJRC:%Float,MZSYRC:%Float,MZInjeCFJE:%Float,CFZS:%Float,CFJE:%Float,CFYPZS:%Float,CFYyTs:%Float,XyCFZS:%Float,XyCFJE:%Float,XyCFYPZS:%Float,CyCFZS:%Float,CyCFJE:%Float,CyCFYPZS:%Float,KJYWCFZS:%Float,KJYWCFJE:%Float,KJYWCFPZ:%Float,KJCFYyTs:%Float,KJYWCFZS1:%Float,KJYWCFJE1:%Float,KJYWCFPZ1:%Float,KJYWCFZS2:%Float,KJYWCFJE2:%Float,KJYWCFPZ2:%Float,KJYWCFZS3:%Float,KJYWCFJE3:%Float,KJYWCFPZ3:%Float,GJBaseCFZS:%Float,GJBaseCFJE:%Float,GJBaseCFYPZS:%Float,SJBaseCFZS:%Float,SJBaseCFJE:%Float,SJBaseCFYPZS:%Float,BaseCFZS:%Float,BaseCFJE:%Float,BaseCFYPZS:%Float,MzKJInjeRc:%Float,KJInjeCFJE:%Float,JZRc:%Float,JZKJRc:%Float,JZCFZS:%Float,JZCFJE:%Float,JZKJCFZS:%Float,JZKJCFJE:%Float,JZKJZSCFZS:%Float,JZKJZSCFJE:%Float,hospna:%String,JzCFRC:%Float") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetGhrcDataTBHB","2012","","")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:：门诊人次做年度月份的同比环比分析
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetGhrcDataTBHB(year As %String, dept As %Text, kpiCodeStrZb As %Text, hospid As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,dimIdSt:%String,dimIdStna:%String,dimIdDoc:%String,DocNa:%String,CzJbId:%String,CzJbNa:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

ClassMethod GetGhrcDataTBHBExecute(ByRef qHandle As %Binary, year As %String, dept As %Text, kpiCodeStrZb As %Text, hospid As %String) As %Status
{
	n (qHandle,year,dept,kpiCodeStrZb,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK

 	k ^TEMPDHCWL($j),^temp2($j)
	/*
	s RowidCz="",RowidCzsub="",RowidCzsubDetsub=""
    f  s RowidCz=$o(^DHCWLSTG("GRP",RowidCz)) q:RowidCz=""  d
    .q:RowidCz'=1   //完全定义的出诊级别组
    .s fl1Cz="czxm"
    .s fl2Cz=$p(^DHCWLSTG("GRP",RowidCz),"^",1) ;定义
    .s fl3Cz="czdat"
    .s fl4Cz="SUB"
    
    .i fl4Cz="SUB" d 
    ..s fl4Cznm="出诊级别"
    ..s fl2Cznm=fl2Cz_"["_fl4Cznm_"]"
    ..f  s RowidCzsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)) q:RowidCzsub=""  d
    ...q:RowidCzsub=0
    ...s CZName=$P($G(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)),"^",1)
    ...f  s RowidCzsubDetsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)) q:RowidCzsubDetsub=""  d
    ....q:RowidCzsubDetsub=0
    ....s Czid=$p($g(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)),"^",4)
    ....s ^temp2($j,Czid)=RowidCzsub_"^"_CZName
    */
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
 	S kpiCodeStrZb="RegLocStOpNums"
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData8(dept,,.deptData)
	d SplitMulitData8(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData8(hospid,,.hospidData)

	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdSt=$p(dimId,",",2)
	...s dimIdDoc=$p(dimId,",",3)
	...s dimIdRetype=$p(dimId,",",4)
	...s ^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype))+value
	
	s monId=0 f  s monId=$o(^TEMPDHCWL($j,monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,monId,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdSt=0 f  s dimIdSt=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt)) q:dimIdSt=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc)) q:dimIdDoc=""  d
    .....s dimIdRetype=0 f  s dimIdRetype=$o(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) q:dimIdRetype=""  d
    ......s outdata=$g(^TEMPDHCWL($j,monId,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) 
    ......d OutPutRow8
     
    k ^TEMPDHCWL($j),^temp2($j)
	
	Quit $$$OK
OutPutRow8
    s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s dimIdStna=$li($g(^DHCWL.MKPI.DayD(dimIdSt)),3)
	i $d(^CTPCP(dimIdDoc)) s DocNa=$$GetPatDoc^DHCWLCommon(dimIdDoc)
    e  s DocNa="Null"
	
	;i ^temp2($j,dimIdRetype) s CzJbId=$p(^temp2($j,dimIdRetype),"^",1),CzJbNa=$p(^temp2($j,dimIdRetype),"^",2)
    ;e  s CzJbNa="Null"
	s CzJbId="",CzJbNa=""
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData8(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetGhrcDataTBHBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGhrcDataTBHBExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetGhrcDataTBHBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGhrcDataTBHBExecute ]
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

// 挂号时间段-科室医生-出诊级别分析;flag 为排名报表调用标志  

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetRegStFx","2012-10-01","2012-12-31","","RegLocStOpNums","D","1")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetRegStFx","2012-07","2012-07","","RegLocStOpNums","M")

ClassMethod GetRegStFxExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, flag As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,flag,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
       
    k ^TEMPDHCWL($j),^temp2($j),^temppm($j)
	/*
	s RowidCz="",RowidCzsub="",RowidCzsubDetsub=""
    f  s RowidCz=$o(^DHCWLSTG("GRP",RowidCz)) q:RowidCz=""  d
    .q:RowidCz'=1  //完全定义的出诊级别组
    .s fl1Cz="czxm"
    .s fl2Cz=$p(^DHCWLSTG("GRP",RowidCz),"^",1) ;定义
    .s fl3Cz="czdat"
    .s fl4Cz="SUB"
    
    .i fl4Cz="SUB" d 
    ..s fl4Cznm="出诊级别"
    ..s fl2Cznm=fl2Cz_"["_fl4Cznm_"]"
    ..f  s RowidCzsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)) q:RowidCzsub=""  d
    ...q:RowidCzsub=0
    ...s CZName=$P($G(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub)),"^",1)
    ...f  s RowidCzsubDetsub=$o(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)) q:RowidCzsubDetsub=""  d
    ....q:RowidCzsubDetsub=0
    ....s Czid=$p($g(^DHCWLSTG("GRP",RowidCz,"SUB",RowidCzsub,"RT",RowidCzsubDetsub)),"^",4)
    ....s ^temp2($j,Czid)=RowidCzsub_"^"_CZName
	*/
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
 	S kpiCodeStrZb="RegLocStOpNums"
	;q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData9(dept,,.deptData)
	d SplitMulitData9(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData9(hospid,,.hospidData)

	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(data(monId,kpiId,dimId))
	...s dimIdLoc=$p(dimId,",",1)
	...s dimIdSt=$p(dimId,",",2)
	...s dimIdDoc=$p(dimId,",",3)
	...s dimIdRetype=$p(dimId,",",4)
	...s ^temppm($j,kpiId,dimIdLoc)=$g(^temppm($j,kpiId,dimIdLoc))+value
	...s ^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)=$g(^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype))+value

	i flag="" d
    .s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^TEMPDHCWL($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s dimIdSt=0 f  s dimIdSt=$o(^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt)) q:dimIdSt=""  d
    ....s dimIdDoc=0 f  s dimIdDoc=$o(^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc)) q:dimIdDoc=""  d
    .....s dimIdRetype=0 f  s dimIdRetype=$o(^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) q:dimIdRetype=""  d
    ......s outdata=$g(^TEMPDHCWL($j,kpiId,dimIdLoc,dimIdSt,dimIdDoc,dimIdRetype)) 
    ......d OutPutRow9
    
    i flag="1" d
	.s kpiId=0 f  s kpiId=$o(^temppm($j,kpiId)) q:kpiId=""  d
    ..s dimIdLoc=0 f  s dimIdLoc=$o(^temppm($j,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ...s outdata=$g(^temppm($j,kpiId,dimIdLoc)) 
    ...d OutPutRow9Pm
      
    k ^TEMPDHCWL($j),^temp2($j),^temppm($j)
	
	Quit $$$OK
OutPutRow9
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s dimIdStna=$li($g(^DHCWL.MKPI.DayD(dimIdSt)),3)
	i $d(^CTPCP(dimIdDoc)) s DocNa=$$GetPatDoc^DHCWLCommon(dimIdDoc)
    e  s DocNa="Null"
	
	;i ^temp2($j,dimIdRetype) s CzJbId=$p(^temp2($j,dimIdRetype),"^",1),CzJbNa=$p(^temp2($j,dimIdRetype),"^",2)
    ;e  s CzJbNa="Null"
    s CzJbId="",CzJbNa=""
	
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow9Pm
    ;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    ;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimIdLoc)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    s dimIdSt="",dimIdStna="",dimIdDoc="",DocNa=""
		
	s CzJbId="",CzJbNa=""
    e  s CzJbNa="Null"
	
	s Data=$lb(kpiId,kpiCode,kpiDesc,dimIdLoc,dimDesc,dimIdSt,dimIdStna,dimIdDoc,DocNa,CzJbId,CzJbNa,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
SplitMulitData9(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetRegStFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegStFxExecute ]
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

ClassMethod GetRegStFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegStFxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRegStFx(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, flag As %String, hospid As %String) As %Query(ROWSPEC = "kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,dimIdSt:%String,dimIdStna:%String,dimIdDoc:%String,DocNa:%String,CzJbId:%String,CzJbNa:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

// 科室指标,参数传输代码,科室抗菌收入排名分析用

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWSR","2013-04-16","2013-04-16","","GetLocFee,GetLocYLFee,GetLocYaoFee,GetLocXYaoFee,GetKJYWFee","D","I","","")

// 2013-04-17 lxc  修改  青医附院单独独立麻醉科开药情况

ClassMethod GetDepKPIKJYWSRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, pattype As %String, hospid As %String, kdstr As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,pattype,hospid,kdstr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    q:pattype="" $$$OK
    
    ;s kdstr="193,406,1040,1041,1042"
    
    k ^TEMPDHCWL($j)
	i pattype="I" s pattypeNa="住院"
	i $F(","_"O,E"_",",","_pattype_",")'=0   s pattypeNa="门诊"
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData10(dept,,.deptData)
	d SplitMulitData10(pattype,,.pattypeData)
	d SplitMulitData10(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData10(hospid,,.hospidData)
	d SplitMulitData10(kdstr,,.kdstrData)
	
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId="",value=0
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimIdnod=0
	..f  s dimIdnod=$o(data(monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))

	...s value=+$g(data(monId,kpiId,dimIdnod))
    ...s dimId=$p(dimIdnod,",",1)
    ...s jztype=$p(dimIdnod,",",2) 
    ...i $li(^DHCWL.MKPI.MKPID(kpiId),2)'="GetKJYWFee"  s kdloc=$p(dimIdnod,",",3)  ;2013-04-17
    ...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee"  s kdloc=$p(dimIdnod,",",7)  ;2013-04-17 
   	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断类型是否为所选类型
	...q:(pattype'="")&&(jztype="") 
	...q:(pattype'="")&&('$d(pattypeData(jztype)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   

	...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocFee" s ^TEMPDHCWL($j,dimId,"GetLocFee")=$g(^TEMPDHCWL($j,dimId,"GetLocFee"))+value 	//总收入
	...i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYLFee" s ^TEMPDHCWL($j,dimId,"GetLocYLFee")=$g(^TEMPDHCWL($j,dimId,"GetLocYLFee"))+value	//医疗收入
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^TEMPDHCWL($j,dimId,"GetLocYaoFee")=$g(^TEMPDHCWL($j,dimId,"GetLocYaoFee"))+value	//药品收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^TEMPDHCWL($j,dimId,"GetLocXYaoFee")=$g(^TEMPDHCWL($j,dimId,"GetLocXYaoFee"))+value //西药收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr="" && ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^TEMPDHCWL($j,dimId,"GetKJYWFee")=$g(^TEMPDHCWL($j,dimId,"GetKJYWFee"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单的不算
    ...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^TEMPDHCWL($j,dimId,"GetLocYaoFee")=$g(^TEMPDHCWL($j,dimId,"GetLocYaoFee"))+value	//药品收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^TEMPDHCWL($j,dimId,"GetLocXYaoFee")=$g(^TEMPDHCWL($j,dimId,"GetLocXYaoFee"))+value //西药收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^TEMPDHCWL($j,dimId,"GetKJYWFee")=$g(^TEMPDHCWL($j,dimId,"GetKJYWFee"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单的不算
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocYaoFee")) s ^TEMPDHCWL($j,dimId,"GetLocYaoFeeMZ")=$g(^TEMPDHCWL($j,dimId,"GetLocYaoFeeMZ"))+value	//药品收入  ;2013-04-17 麻醉科开单
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetLocXYaoFee"))  s ^TEMPDHCWL($j,dimId,"GetLocXYaoFeeMZ")=$g(^TEMPDHCWL($j,dimId,"GetLocXYaoFeeMZ"))+value //西药收入  ;2013-04-17 麻醉科开单
	...i (kdstr'="" && ($F(","_kdstr_",",","_kdloc_",")'=0) &&  ($li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee")) s ^TEMPDHCWL($j,dimId,"GetKJYWFeeMZ")=$g(^TEMPDHCWL($j,dimId,"GetKJYWFeeMZ"))+value //抗菌药物收入  ;2013-04-17 麻醉科开单


    s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,dimId)) q:dimId=""  d
    .s ZSR=$g(^TEMPDHCWL($j,dimId,"GetLocFee")) q:ZSR=0
    .s YLSR=$g(^TEMPDHCWL($j,dimId,"GetLocYLFee"))
    .s YPSR=$g(^TEMPDHCWL($j,dimId,"GetLocYaoFee"))
    .s XYSR=$g(^TEMPDHCWL($j,dimId,"GetLocXYaoFee"))
    .s KJYWSR=$g(^TEMPDHCWL($j,dimId,"GetKJYWFee"))
    .s MZYPSR=$g(^TEMPDHCWL($j,dimId,"GetLocYaoFeeMZ"))
    .s MZKJYWSR=$g(^TEMPDHCWL($j,dimId,"GetKJYWFeeMZ"))
    .d OutPutRow10
     
    k ^TEMPDHCWL($j)
	
	Quit $$$OK
OutPutRow10
    i $d(^CTLOC(dimId))  d  
    .s dimDesc1=$P($G(^CTLOC(dimId)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
	s Data=$lb(dimId,dimDesc,pattypeNa,ZSR,YLSR,YPSR,MZYPSR,XYSR,KJYWSR,MZKJYWSR,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData10(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepKPIKJYWSRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepKPIKJYWSRExecute ]
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

ClassMethod GetDepKPIKJYWSRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepKPIKJYWSRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepKPIKJYWSR(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, pattype As %String, hospid As %String, kdstr As %String) As %Query(ROWSPEC = "dimId:%String,dimDesc:%String,pattypeNa:%String,ZSR:%Float,YLSR:%Float,YPSR:%Float,MZYPSR:%Float,XYSR:%Float,KJYWSR:%Float,MZKJYWSR:%Float,hospna:%String") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDeptKPIDataBJFX","2012-06-01","2012-07-01","","GetKJYWFee","D","gzfl","","") 

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDeptKPIDataBJFX","2012-07","2012-07","919","MzywXhQty,MzywXhe","D","drglocdocFy1","","") 

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDeptKPIDataBJFX","2013-04-17","2013-04-17","","MzywXhQty,MzywXhe","D","drglocdocFy1","","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDeptKPIDataBJFX","2012-07-01","2012-08-01","913","MzKjywXhQty,MzKjywXhe","D","drglocdoc","","")

/// Creator：      lxc
/// CreatDate：    2012-08-07	
/// Description:： 按照年度和指标查找值,做一段周期的指标分析(病人科室收入分析用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// Return：      
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetDeptKPIDataBJFX(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, pattype As %String, hospid As %String) As %Query(ROWSPEC = "dimIdtypeNa:%String,dimId:%String,dimDesc:%String,dimIdDoc:%String,dimIdDocNa:%String,gzflId:%String,gzfldesc:%String,drgId:%String,arcdesc:%String,outdata:%Float,hospna:%String,outdataQty:%Float,uomdesc:%String,Guig:%String") [ SqlProc ]
{
}

ClassMethod GetDeptKPIDataBJFXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, pattype As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,rptID,pattype,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
	q:rptID="" $$$OK
	;q:pattype="" $$$OK

	k ^TEMPDHCWL($j),^templdoc($j),^tempdrg($j),^tempgzfl($j),^tempdrgLocDoc($j),^tempdrgHZ($j),^tempgzflHZ($j),^tempdrgLocDocFy($j)
    k ^Tempdata($j,"DHCWLXC")
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
	q:kpiCodeStrZb="" 1
	s value=""	
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)  ;,.data)
	q:sc'=1 1
	;q:'$d(data) 1
    s outdataQty=0,outdata=0  
	d SplitMulitData11(dept,,.deptData)
	d SplitMulitData11(pattype,,.pattypeData)
	d SplitMulitData11(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData11(hospid,,.hospidData)
    
    i pattype="I" s dimIdtypeNa="住院"
	i $F(","_"O,E"_",",","_pattype_",")'=0   s dimIdtypeNa="门诊"
	s monId="",value=0,outdataQty=0,outdata=0
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.;s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..;s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
	..s dimId=0
	..f  s dimId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1) 
	...i $g(dimIdLoc)="" s dimIdLoc="999999"
	...s dimIdtype=$p(dimId,",",2)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	...//判断科室是否为所选类型
	...q:(pattype'="")&&(dimIdtype="") 
	...q:(pattype'="")&&('$d(pattypeData(dimIdtype)))
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...;s dimDesc=##class(DHCWL.MKPIService.SetKPIData).GetDimDesc(kpiId,dimId)
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId))
	...;i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetKJYWFee"  d 
	...s gzflId=$p(dimId,",",4)
	...s ylfl=$p(dimId,",",5)
	...s drgId=$p(dimId,",",6)  
	...s dimIdDoc=$p(dimId,",",3) 
	...i $g(dimIdDoc)=""  s dimIdDoc="999999"    ;2012-04-10
	...;s pressno=$p(dimId,",",7) 
    ...i (rptID="doc") d
	....s ^templdoc($j,dimIdLoc,dimIdDoc)=$g(^templdoc($j,dimIdLoc,dimIdDoc))+value
	...i rptID="drglocdoc"  d 
	....s ^tempdrgLocDoc($j,dimIdLoc,dimIdDoc,gzflId,drgId)=$g(^tempdrgLocDoc($j,dimIdLoc,dimIdDoc,gzflId,drgId))+value
	...;i rptID="drglocdocFy"  d 
	...;.i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty") s ^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Qty")=$g(^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Qty"))+value
	...;.i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Fee")=$g(^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Fee"))+value
	...;.i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty") s ^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Qty")=$g(^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Qty"))+value
	...;.i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Fee")=$g(^tempdrgLocDocFy($j,dimIdLoc,dimIdDoc,gzflId,drgId,"Fee"))+value
	...i rptID="drglocdocFy"  d 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty") s ^tempdrgLocDocFy($j,drgId,"Qty")=$g(^tempdrgLocDocFy($j,drgId,"Qty"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^tempdrgLocDocFy($j,drgId,"Fee")=$g(^tempdrgLocDocFy($j,drgId,"Fee"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty") s ^tempdrgLocDocFy($j,drgId,"Qty")=$g(^tempdrgLocDocFy($j,drgId,"Qty"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^tempdrgLocDocFy($j,drgId,"Fee")=$g(^tempdrgLocDocFy($j,drgId,"Fee"))+value
	...i rptID="drglocdocFy1"  d 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty") s ^tempdrgLocDocFy($j,dimIdDoc,drgId,"Qty")=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Qty"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^tempdrgLocDocFy($j,dimIdDoc,drgId,"Fee")=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Fee"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty") s ^tempdrgLocDocFy($j,dimIdDoc,drgId,"Qty")=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Qty"))+value
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^tempdrgLocDocFy($j,dimIdDoc,drgId,"Fee")=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Fee"))+value
	
	...i dept'=""  d
	....s ^tempdrg($j,dimIdLoc,drgId)=$g(^tempdrg($j,dimIdLoc,drgId))+value
    ...i ((rptID="gzfl") & (dept'="")) d
    ....s ^tempgzfl($j,dimIdLoc,gzflId)=$g(^tempgzfl($j,dimIdLoc,gzflId))+value
    ...i ((rptID="drgpm") & (dept="")) d
    ....s ^tempdrgHZ($j,drgId)=$g(^tempdrgHZ($j,drgId))+value
    ...i ((rptID="gzfl") & (dept="")) d
    ....s ^tempgzflHZ($j,gzflId)=$g(^tempgzflHZ($j,gzflId))+value
    
	i (rptID="doc") d
    .s dimIdLoc=0 f  s dimIdLoc=$o(^templdoc($j,dimIdLoc)) q:dimIdLoc=""  d
    ..s dimIdDoc=0 f  s dimIdDoc=$o(^templdoc($j,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    ...s outdata=$g(^templdoc($j,dimIdLoc,dimIdDoc)) 
	...d OutPutRow11Doc
	
	i ((rptID="drgpm") & (dept'="")) d
	.s dimIdLoc=0 f  s dimIdLoc=$o(^tempdrg($j,dimIdLoc)) q:dimIdLoc=""  d
    ..s drgId=0 f  s drgId=$o(^tempdrg($j,dimIdLoc,drgId)) q:drgId=""  d
    ...s outdata=$g(^tempdrg($j,dimIdLoc,drgId)) 
	...d OutPutRow11drg
	
	i ((rptID="drgpm") & (dept="")) d
    .s drgId=0 f  s drgId=$o(^tempdrgHZ($j,drgId)) q:drgId=""  d
    ..s outdata=$g(^tempdrgHZ($j,drgId)) 
	..d OutPutRow11drgHZ
	
	i ((rptID="gzfl") & (dept'="")) d
    .s dimIdLoc=0 f  s dimIdLoc=$o(^tempgzfl($j,dimIdLoc)) q:dimIdLoc=""  d
    ..s gzflId="" f  s gzflId=$o(^tempgzfl($j,dimIdLoc,gzflId)) q:gzflId=""  d
    ...s outdata=$g(^tempgzfl($j,dimIdLoc,gzflId)) 
	...d OutPutRow11gzfl
	
	i ((rptID="gzfl") & (dept="")) d
    .s gzflId="" f  s gzflId=$o(^tempgzflHZ($j,gzflId)) q:gzflId=""  d
    ..s outdata=$g(^tempgzflHZ($j,gzflId)) 
	..d OutPutRow11gzflHZ
	
	i (rptID="drglocdoc") d
    .s dimIdLoc=0 f  s dimIdLoc=$o(^tempdrgLocDoc($j,dimIdLoc)) q:dimIdLoc=""  d
    ..s dimIdDoc=0 f  s dimIdDoc=$o(^tempdrgLocDoc($j,dimIdLoc,dimIdDoc)) q:dimIdDoc=""  d
    ...s gzflId="" f  s gzflId=$o(^tempdrgLocDoc($j,dimIdLoc,dimIdDoc,gzflId)) q:gzflId=""  d
    ....s drgId=0 f  s drgId=$o(^tempdrgLocDoc($j,dimIdLoc,dimIdDoc,gzflId,drgId)) q:drgId=""  d
    .....s outdata=$g(^tempdrgLocDoc($j,dimIdLoc,dimIdDoc,gzflId,drgId)) 
	.....d OutPutRow11DrgLocDoc

    i (rptID="drglocdocFy") d
    .s drgId=0 f  s drgId=$o(^tempdrgLocDocFy($j,drgId)) q:drgId=""  d
    ..s outdata=$g(^tempdrgLocDocFy($j,drgId,"Fee")) 
    ..s outdataQty=$g(^tempdrgLocDocFy($j,drgId,"Qty")) 
	..d OutPutRow11DrgLocDocFy
	
	i (rptID="drglocdocFy1") d
    .s dimIdDoc=0 f  s dimIdDoc=$o(^tempdrgLocDocFy($j,dimIdDoc)) q:dimIdDoc=""  d
    ..s drgId=0 f  s drgId=$o(^tempdrgLocDocFy($j,dimIdDoc,drgId)) q:drgId=""  d
    ...s outdata=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Fee")) 
    ...s outdataQty=$g(^tempdrgLocDocFy($j,dimIdDoc,drgId,"Qty")) 
	...d OutPutRow11DrgLocDocFy1
	
	k ^templdoc($j),^tempdrg($j),^tempgzfl($j),^tempdrgLocDoc($j),^tempdrgHZ($j),^tempgzflHZ($j),^tempdrgLocDocFy($j),^Tempdata($j,"DHCWLXC")
	Quit $$$OK
OutPutRow11Doc
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    s drgId="",arcdesc="",gzflId="",gzfldesc=""
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow11drg
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2) q:$g(ARCIMSub)=""   ;2013-04-10
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    s gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow11drgHZ
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2) q:$g(ARCIMSub)=""   ;2013-04-10
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    s dimIdLoc="",dimDesc="",gzflId="",gzfldesc="",dimIdDoc="",dimIdDocNa=""
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow11gzfl
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    s drgId="",arcdesc="",dimIdDoc="",dimIdDocNa=""
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 
OutPutRow11gzflHZ
    s dimIdLoc="",dimDesc="",drgId="",arcdesc="",dimIdDoc="",dimIdDocNa=""
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 
OutPutRow11DrgLocDoc
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)
    s ARCIMRowid=$P(drgId,"||",1)
    s ARCIMSub=$P(drgId,"||",2)   q:$g(ARCIMSub)=""   ;2013-04-10
    s arcdesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2) 
    s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow11DrgLocDocFy
    /*
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1*/
    ;i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)   
    ;i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2) 
    s arcdesc=$p(^PHCD(drgId,1),"^",2) 
	s uom=$p(^PHCD(drgId,"DF",1,2),"^",4) 
	i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2) ;基本单位   CT_UOM
	s drgId1=drgId_"||"_1
	s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(drgId1)
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna,outdataQty,uomdesc,Guig)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
OutPutRow11DrgLocDocFy1
    /*
    i $d(^CTLOC(dimIdLoc))  d  
    .s dimDesc1=$P($G(^CTLOC(dimIdLoc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1 */
    i $d(^CTPCP(dimIdDoc)) s dimIdDocNa=$p(^CTPCP(dimIdDoc,1),"^",2)
    ;i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2) 
    s arcdesc=$p(^PHCD(drgId,1),"^",2) 
	s uom=$p(^PHCD(drgId,"DF",1,2),"^",4) 
	i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2) ;基本单位   CT_UOM
	s drgId1=drgId_"||"_1
	s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(drgId1)
	s Data=$lb(dimIdtypeNa,dimIdLoc,dimDesc,dimIdDoc,dimIdDocNa,gzflId,gzfldesc,drgId,arcdesc,outdata,hospna,outdataQty,uomdesc,Guig)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q

SplitMulitData11(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDeptKPIDataBJFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptKPIDataBJFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDeptKPIDataBJFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptKPIDataBJFXExecute ]
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

// 科室医师开药统计

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocDrug","2012-12-01","2012-12-03","224","","","CFZS,CFJE,CFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,XyCFZS,XyCFJE,XyCFYPZS","D","","doc")

ClassMethod GetDepDocDrugExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, drug As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,drug,kpiCodeStrZb,type,hospid,flag1)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)  ;,.data) 2012-12-19 lxc
	q:sc'=1 1
	d SplitMulitData12(dept,,.deptData)
	d SplitMulitData12(doc,,.docData)
	d SplitMulitData12(dept,,.deptData)
	d SplitMulitData12(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData12(hospid,,.hospidData)
    
	s monId=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="",value=0,valueXy=0
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimIdnod=0
	..f  s dimIdnod=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod))
    ...s dimId=$p(dimIdnod,",",1)
    ...s doc=$p(dimIdnod,",",8)
    ...;i ($P(^ARCBG(Cftype),"^",2) [ "西药" ) s dimIdnodXy=Cftype_","_dimId_","_fyLoc,valueXy=+$g(data(monId,kpiId,dimIdnodXy))
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	
	...i (flag1="dep") d
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFZS")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCnt"))+value //处方张数	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFee"))+value //处方金额 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCnt"))+value //处方药品数 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYyTs") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescfactor")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescfactor"))+value //处方用药天数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescCntXy"))+value //西药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescFeeXy"))+value //西药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescDrgCntXy"))+value //西药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt"))+value	//抗菌药物处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee"))+value    //抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt1"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee1"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ1") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt1"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt2"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee2"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ2") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt2"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"antiPrescCnt3"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiFee3"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ3") && (flag1="dep")) s ^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"prescAntiDrgCnt3"))+value	//抗菌药物处处方药品数
    ...i (flag1="doc") d
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFZS")  s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescCnt"))+value //处方张数	
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescFee"))+value //处方金额 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCnt"))+value //处方药品数 
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="CFYyTs") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescfactor")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescfactor"))+value //处方用药天数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescCntXy"))+value //西药处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescFeeXy"))+value //西药处方金额
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="XyCFYPZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntXy")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescDrgCntXy"))+value //西药处方药品数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS") s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt"))+value	//抗菌药物处方张数
	....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE") s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee"))+value    //抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ")  && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt1"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee1"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ1") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt1")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt1"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt2"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee2"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ2") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt2")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt2"))+value	//抗菌药物处处方药品数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFZS3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"antiPrescCnt3"))+value	//抗菌药物处方张数
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFJE3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiFee3"))+value	//抗菌药物处处方金额
	....i (($li(^DHCWL.MKPI.MKPID(kpiId),2)="KJYWCFPZ3") && (flag1="doc")) s ^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt3")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"prescAntiDrgCnt3"))+value	//抗菌药物处处方药品数

    s dim=0 f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",dim)) q:dim=""  d
    .s CFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescCnt"))
    .s CFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescFee"))
    .s CFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescDrgCnt"))
    .s CFYyTs=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescfactor"))
    .s XyCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescCntXy"))
    .s XyCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescFeeXy"))
    .s XyCFYPZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescDrgCntXy"))
    .s KJYWCFZS=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt"))
    .s KJYWCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee"))
    .s KJYWCFPZ=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt"))
    .s KJYWCFZS1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt1"))
    .s KJYWCFJE1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee1"))
    .s KJYWCFPZ1=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt1"))
    .s KJYWCFZS2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt2"))
    .s KJYWCFJE2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee2"))
    .s KJYWCFPZ2=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt2"))
    .s KJYWCFZS3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"antiPrescCnt3"))
    .s KJYWCFJE3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiFee3"))
    .s KJYWCFPZ3=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"prescAntiDrgCnt3"))
    .d OutPutRow12
     
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
	Quit $$$OK
OutPutRow12
    i ((flag1="dep") && $d(^CTLOC(dim)))  d  
    .s dimDesc1=$P($G(^CTLOC(dim)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((flag1="doc") && $d(^CTPCP(dim))) d
    .s dimDesc=$$GetPatDoc^DHCWLCommon(dim)
    .e  s dimDesc="Null"
    
	s Data=$lb(dim,dimDesc,CFZS,CFJE,CFYPZS,CFYyTs,XyCFZS,XyCFJE,XyCFYPZS,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJYWCFZS1,KJYWCFJE1,KJYWCFPZ1,KJYWCFZS2,KJYWCFJE2,KJYWCFPZ2,KJYWCFZS3,KJYWCFJE3,KJYWCFPZ3,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData12(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepDocDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocDrugExecute ]
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

ClassMethod GetDepDocDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocDrug(startDate As %String, endDate As %String, dept As %Text, doc As %Text, drug As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String) As %Query(ROWSPEC = "dim:%String,dimDesc:%String,CFZS:%Float,CFJE:%Float,CFYPZS:%Float,CFYyTs:%Float,XyCFZS:%Float,XyCFJE:%Float,XyCFYPZS:%Float,KJYWCFZS:%Float,KJYWCFJE:%Float,KJYWCFPZ:%Float,KJYWCFZS1:%Float,KJYWCFJE1:%Float,KJYWCFPZ1:%Float,KJYWCFZS2:%Float,KJYWCFJE2:%Float,KJYWCFPZ2:%Float,KJYWCFZS3:%Float,KJYWCFJE3:%Float,KJYWCFPZ3:%Float,hospna:%String") [ SqlProc ]
{
}

// 门诊医师用药监控明细:暂停用，速度慢。lxc20130222

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPENQuery","2012-12-01","2012-12-03","","","高血压","","1105")	

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPENQuery","2012-12-01","2012-12-03","","4121","高血压","1000","")

ClassMethod GetDISPENQueryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, money As %String, drgId As %Text) As %Status
{
	;n (startDate,endDate,dept,doc,diag,money,drgId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    q:startDate="" $$$OK
 	q:endDate="" $$$OK
 	
   	d SplitMulitData13(dept,,.deptData)
   	d SplitMulitData13(doc,,.docData)
   	d SplitMulitData13(diag,,.diagData)
   	d SplitMulitData13(drgId,,.drgIdData)
   	
    k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
    ;s mPLIST(num)=""_"^"_"医生姓名"_"^"_"处方号"_"^"_"诊断代码"_"^"_"诊断名称"_"^"_"就诊号"_"^"_"病人姓名"_"^"_"药品名称"_"^"_"药品规格"_"^"_"数量"_"^"_"药品单价"_"^"_"处方金额"
    s num=0,count1=0,price1=0,price=0,totalprice=0
    s sday=$zdh(startDate,3)
    s eday=$zdh(endDate,3)
   
    f pyday=sday:1:eday d
    .s phldr="" f  s phldr=$o(^DHCPHDISPi("FYDATE",pyday,phldr)) q:phldr=""  d
    ..s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("FYDATE",pyday,phldr,PHDROWID)) q:PHDROWID=""  d
    ...s PrescNo=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ...s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ....s PAYAMOUNT=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3)
    ....s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ....s oeordr=$p(OEORIDR,"||",1)
    ....s oeorsub=$p(OEORIDR,"||",2)
    ....s depdr=$p(^OEORD(oeordr,"I",oeorsub,1),"^",3)  
    ....//判断科室是否为所选科室
	....q:(dept'="")&&(depdr="") 
	....q:(dept'="")&&('$d(deptData(depdr)))
    ....s orddocdr=$p($g(^OEORD(oeordr,"I",oeorsub,1)),"^",11) ;开单医师
    ....//判断是否为所选医师
	....q:((doc'="") && (doc'="null"))&&(orddocdr="") 
	....q:((doc'="") && (doc'="null"))&&('$d(docData(orddocdr)))
    ....s admId=$p(^OEORD(oeordr),"^",1)
    ....;s ItmMastDR=$p(^OEORD(oeordr,"I",oeorsub,1),"^",2)
    ....;s ItmMastRowid=$P(ItmMastDR,"||",1),ItmMastDesc=$P($G(^ARCIM(ItmMastRowid,1,1)),"^",2)
    ....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf)))
    ....s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    ....s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) q:count1=0
    ....s ^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf,"Qty"))+count1
    ....s ^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf,"Fee"))+price1
    ....s ^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"HZ","CFJE")=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"HZ","CFJE"))+price1
    ....;i money'="" s ^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE"))+price1
       
    ;i money=""  d 
    s depdr="" f  s depdr=$o(^TEMPDHCWL($j,"DHCWLLXC",depdr))  q:depdr=""  d
    .s orddocdr="" f  s orddocdr=$o(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr))  q:orddocdr=""  d
    ..s admId="" f  s admId=$o(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId))  q:admId=""  d
    ...s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo))  q:PrescNo=""  d
    ....s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,phcdf))  q:phcdf=""  d
    .....s count=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,phcdf,"Qty"))  
    .....s price=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,phcdf,"Fee")) 
    .....s totalprice=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"HZ","CFJE"))
    .....d OutputRow13
    k ^TEMPDHCWL($j,"DHCWLLXC")
    /*i money'=""  d 
    .s depdr="" f  s depdr=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr))  q:depdr=""  d
    ..s orddocdr="" f  s orddocdr=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr))  q:orddocdr=""  d
    ...s admId="" f  s admId=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId))  q:admId=""  d
    ....s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo))  q:PrescNo=""  d
    .....s price=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE")) 
    .....s totalprice=price
    .....d OutputRow13CFJE
    k ^TEMPDHCWL1($j,"DHCWLLXC")
    */
    q $$$OK	
    
OutputRow13
    i $d(^CTLOC(depdr))  d  
    .s dimDesc1=$P($G(^CTLOC(depdr)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i ((orddocdr'="") && ($d(^CTPCP(orddocdr)))) s docname=$p(^CTPCP(orddocdr,1),"^",2)
    e  s docname="Null"
    
    s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    s diagcode=$p($g(diagna),"^",2)
    s diagdesc=$p($g(diagna),"^",3)
    ;//判断科室是否为所选诊断
	;q:(diag'="")&&(diagcode="") 
	;q:(diag'="")&&('$d(diagData(diagcode))) 
  	q:(diagdesc'[diag)
   
    s papmidr=$p(^PAADM(admId),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    
    i phcdf'="HZ" d
    .s ItmMastDesc=$p(^PHCD(+phcdf,1),"^",2)   
	.s UnitDR=$p(^PHCD(+phcdf,"DF",1,2),"^",4) 
	.i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    .s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(+phcdf_"||1")
    e  s ItmMastDesc="",unitdesc="",Guig=""
    s Data=$lb(depdr,deptna,orddocdr,docname,PrescNo,diagcode,diagdesc,admId,cPAPMIName,age,sex,+phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
OutputRow13CFJE
    i ((money'="") && ((drgId="") || (drgId="null"))) q:price<money
    i $d(^CTLOC(depdr))  d  
    .s dimDesc1=$P($G(^CTLOC(depdr)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i ((orddocdr'="") && ($d(^CTPCP(orddocdr)))) s docname=$p(^CTPCP(orddocdr,1),"^",2)
    e  s docname="Null"
    
    s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    s diagcode=$p($g(diagna),"^",2)
    s diagdesc=$p($g(diagna),"^",3)
    ;//判断科室是否为所选诊断
	;q:(diag'="")&&(diagcode="") 
	;q:(diag'="")&&('$d(diagData(diagcode))) 
  	q:(diagdesc'[diag)
   
    s papmidr=$p(^PAADM(admId),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    
    s ItmMastDesc=""   
	s unitdesc="" ;基本单位   CT_UOM
    s Guig="",count=""
    
    s Data=$lb(depdr,deptna,orddocdr,docname,PrescNo,diagcode,diagdesc,admId,cPAPMIName,age,sex,+phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData13(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q

CalAge(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDISPENQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDISPENQueryExecute ]
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

ClassMethod GetDISPENQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDISPENQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDISPENQuery(startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, money As %String, drgId As %Text) As %Query(ROWSPEC = "depdr:%String,deptna:%String,orddocdr:%String,docname:%String,PrescNo:%String,diagcode:%String,diagdesc:%String,admId:%String,cPAPMIName:%String,age:%String,sex:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float") [ SqlProc ]
{
}

// 门诊医师用药处方-药品限制   20130222 add 

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPEN","2012-12-01","2012-12-03","","","高血压","","1105")	

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPEN","2012-12-01","2012-12-03","","4121","","","")

ClassMethod GetDISPENExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, money As %String, drgId As %Text) As %Status
{
	n (startDate,endDate,dept,doc,diag,money,drgId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    q:startDate="" $$$OK
 	q:endDate="" $$$OK
 	
   	d SplitMulitData133(dept,,.deptData)
   	d SplitMulitData133(doc,,.docData)
   	d SplitMulitData133(diag,,.diagData)
   	d SplitMulitData133(drgId,,.drgIdData)
   	
    k ^TEMPDHCWL1($j,"DHCWLLXC")
    ;s mPLIST(num)=""_"^"_"医生姓名"_"^"_"处方号"_"^"_"诊断代码"_"^"_"诊断名称"_"^"_"就诊号"_"^"_"病人姓名"_"^"_"药品名称"_"^"_"药品规格"_"^"_"数量"_"^"_"药品单价"_"^"_"处方金额"
    s num=0,count1=0,price1=0,price=0,totalprice=0
    s sday=$zdh(startDate,3)
    s eday=$zdh(endDate,3)
   
    f pyday=sday:1:eday d
    .s phldr="" f  s phldr=$o(^DHCPHDISPi("FYDATE",pyday,phldr)) q:phldr=""  d
    ..s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("FYDATE",pyday,phldr,PHDROWID)) q:PHDROWID=""  d
    ...s PrescNo=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ...s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ....s PAYAMOUNT=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3)
    ....s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ....s oeordr=$p(OEORIDR,"||",1)
    ....s oeorsub=$p(OEORIDR,"||",2)
    ....s depdr=$p(^OEORD(oeordr,"I",oeorsub,1),"^",3)  
    ....//判断科室是否为所选科室
	....q:(dept'="")&&(depdr="") 
	....q:(dept'="")&&('$d(deptData(depdr)))
    ....s orddocdr=$p($g(^OEORD(oeordr,"I",oeorsub,1)),"^",11) ;开单医师
    ....//判断是否为所选医师
	....q:((doc'="") && (doc'="null"))&&(orddocdr="") 
	....q:((doc'="") && (doc'="null"))&&('$d(docData(orddocdr)))
    ....s admId=$p(^OEORD(oeordr),"^",1)
    ....s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    ....s diagcode=$p($g(diagna),"^",2)
    ....s diagdesc=$p($g(diagna),"^",3)
    ....//判断诊断是否包含所选诊断
	....q:(diag'="")&&(diagdesc="") 
	....q:(diag'="")&&(diagdesc'[diag)
    ....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf)))
    ....s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    ....s ^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE"))+price1
 
    s depdr="" f  s depdr=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr))  q:depdr=""  d
    .s orddocdr="" f  s orddocdr=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr))  q:orddocdr=""  d
    ..s admId="" f  s admId=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId))  q:admId=""  d
    ...s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo))  q:PrescNo=""  d
    ....s price=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE")) 
    ....s totalprice=price
    ....d OutputRow133
    k ^TEMPDHCWL1($j,"DHCWLLXC")
    
    q $$$OK	

OutputRow133
    i $d(^CTLOC(depdr))  d  
    .s dimDesc1=$P($G(^CTLOC(depdr)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i ((orddocdr'="") && ($d(^CTPCP(orddocdr)))) s docname=$p(^CTPCP(orddocdr,1),"^",2)
    e  s docname="Null"
      
    s papmidr=$p(^PAADM(admId),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge133(birth,+$h)
    s age=$p(age,"Y",1)
    
    s ItmMastDesc=""   
	s unitdesc="" ;基本单位   CT_UOM
    s Guig="",count=""
    
    s Data=$lb(depdr,deptna,orddocdr,docname,PrescNo,diagcode,diagdesc,admId,cPAPMIName,age,sex,+phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData133(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q

CalAge133(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDISPENFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDISPENExecute ]
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

ClassMethod GetDISPENClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDISPENExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDISPEN(startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, money As %String, drgId As %String) As %Query(ROWSPEC = "depdr:%String,deptna:%String,orddocdr:%String,docname:%String,PrescNo:%String,diagcode:%String,diagdesc:%String,admId:%String,cPAPMIName:%String,age:%String,sex:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float") [ SqlProc ]
{
}

// 科室医师患者诊断处方统计

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPress","2012-12-01","2012-12-03","","1895","","MzDocPress","D","")

// 2014-12-08query屏蔽备份，zl

/*ClassMethod GetDepDocPressExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %String, diag As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,diag,kpiCodeStrZb,type,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
 
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)

	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData14(dept,,.deptData)
	d SplitMulitData14(doc,,.docData)
	d SplitMulitData14(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData14(hospid,,.hospidData)
	
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.s kpiId="",value=0
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..s dimIdnod=0
	..f  s dimIdnod=$o(data(monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(data(monId,kpiId,dimIdnod))
    ...s dimId=$p(dimIdnod,",",1)
    ...s docId=$p(dimIdnod,",",2) 
    ...s admId=$p(dimIdnod,",",3)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断医师是否为所选医师
	...q:(doc'="")&&(docId="") 
	...q:(doc'="")&&('$d(docData(docId)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ...s diagcode=$p(dimIdnod,",",4)
    ...s diagdesc=$p(dimIdnod,",",5) 
    ...//判断诊断是否包含所选诊断
	...q:(diag'="")&&(diagdesc="") 
	...q:(diag'="")&&(diagdesc'[diag)
    ...s pressno=$p(dimIdnod,",",6) 
    ...d OutPutRow14
	
	Quit $$$OK
OutPutRow14
    i $d(^CTLOC(dimId))  d  
    .s dimDesc1=$P($G(^CTLOC(dimId)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docId'="") && ($d(^CTPCP(docId)))) s docname=$p(^CTPCP(docId,1),"^",2)
    e  s docname="Null"
   
    s papmidr=$p(^PAADM(admId),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge1(birth,+$h)
    s age=$p(age,"Y",1)
	s Data=$lb(dimId,dimDesc,docId,docname,diagcode,diagdesc,admId,cPAPMIName,sex,age,pressno,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData14(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge1(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressExecute ]
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

ClassMethod GetDepDocPressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPress(startDate As %String, endDate As %String, dept As %Text, doc As %String, diag As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Query(ROWSPEC = "depdr:%String,deptna:%String,orddocdr:%String,docname:%String,diagcode:%String,diagdesc:%String,admId:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,hospna:%String") [ SqlProc ]
{
}
*/

// 科室医师患者诊断处方统计

// 改为取指标实时数据 MzDocPress

// 2014-11-11  zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPress","2012-12-01","2012-12-01","","","","MzDocPress","D","")

ClassMethod GetDepDocPressExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,diag,kpiCodeStrZb,type,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
	   
 	s kpiCodeStrZb="MzDocPress"
	s choiceType="C"
	s isRealData="R"
	
	d SplitMulitData14(dept,,.deptData)
	d SplitMulitData14(doc,,.docData)
	d SplitMulitData14(hospid,,.hospidData)
	
		  
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpiCodeStrZb,startDate,endDate,choiceType,isRealData)
	
	While rs.Next(.sc) {
		s dimIdnod=$g(rs.Data("dimId"))
		s dimdesc=$g(rs.Data("dimDesc")) 
		s kpiId=$g(rs.Data("kpiId"))
		s kpiCode=$g(rs.Data("kpiCode"))
		s value=$g(rs.Data("value"))
		s dimId=$p(dimIdnod,",",1)
		//判断科室是否为所选科室
	 	continue:(dept'="")&&(dimId="") 
		continue:(dept'="")&&('$d(deptData(dimId)))
		//判断医院是否为所选医院
		s hosp=$P($G(^CTLOC(dimId)),"^",22)
	 	i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
		continue:(hospid'="")&&(hosp="") 
		continue:(hospid'="")&&('$d(hospidData(hosp)))
		i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    	i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    	s docId=$p(dimIdnod,",",2)
    	i docId="" s docId="999999"
    	//判断医师是否为所选医师
		continue:(doc'="")&&(docId="") 
		continue:(doc'="")&&('$d(docData(docId)))
    	s admId=$p(dimIdnod,",",3)
    	s diagcode=$p(dimIdnod,",",4) i diagcode="" s diagcode="999999"
    	s diagdesc=$p(dimIdnod,",",5) i diagdesc="" s diagdesc="Null"
    	//判断诊断是否包含所选诊断
		continue:(diag'="")&&(diagdesc="") 
		continue:(diag'="")&&(diagdesc'[diag)
		s pressno=$p(dimIdnod,",",6)
    	d OutPutRow14
	}
	
	Quit $$$OK
OutPutRow14
    i $d(^CTLOC(dimId))  d  
    .s dimDesc1=$P($G(^CTLOC(dimId)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docId'="") && ($d(^CTPCP(docId)))) s docname=$p(^CTPCP(docId,1),"^",2)
    e  s docname="Null"
   
    s papmidr=$p(^PAADM(admId),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge1(birth,+$h)
    s age=$p(age,"Y",1)
	s Data=$lb(dimId,dimDesc,docId,docname,diagcode,diagdesc,admId,cPAPMIName,sex,age,pressno,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData14(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge1(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressExecute ]
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

ClassMethod GetDepDocPressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPress(startDate As %String, endDate As %String, dept As %Text, doc As %Text, diag As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String) As %Query(ROWSPEC = "depdr:%String,deptna:%String,orddocdr:%String,docname:%String,diagcode:%String,diagdesc:%String,admId:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,hospna:%String") [ SqlProc ]
{
}

// 门诊医师用药监控明细-处方查明细

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPENQuery1","O12120331902","")	

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDISPENQuery1","O12120337768","")	

ClassMethod GetDISPENQuery1Execute(ByRef qHandle As %Binary, press As %String, money As %String) As %Status
{
	;n (press)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

  
    k ^TEMPDHCWL($j,"DHCWLLXC")
    ;s mPLIST(num)=""_"^"_"医生姓名"_"^"_"处方号"_"^"_"诊断代码"_"^"_"诊断名称"_"^"_"就诊号"_"^"_"病人姓名"_"^"_"药品名称"_"^"_"药品规格"_"^"_"数量"_"^"_"药品单价"_"^"_"处方金额"
    s num=0,count1=0,price1=0,totalprice=0,count=0,price=0

    s press1="" f  s press1=$o(^DHCPHDISPi("PRESCNO",press1)) q:press1=""  d
    .q:press1'=press 
    .s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("PRESCNO",press1,PHDROWID)) q:PHDROWID=""  d
    ..s PrescNo1=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ..s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ...s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ...s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)
    ...s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    ...s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) q:count1=0
    ...s totalprice=totalprice+price1
    ...s ^TEMPDHCWL($j,"DHCWLLXC",PrescNo1,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",PrescNo1,+phcdf1,"Qty"))+count1
    ...s ^TEMPDHCWL($j,"DHCWLLXC",PrescNo1,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",PrescNo1,+phcdf1,"Fee"))+price1
      
    s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL($j,"DHCWLLXC",PrescNo))  q:PrescNo=""  d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",PrescNo,phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL($j,"DHCWLLXC",PrescNo,phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL($j,"DHCWLLXC",PrescNo,phcdf,"Fee")) 
    ..d OutputRow15
 
    k ^TEMPDHCWL($j,"DHCWLLXC")
    q $$$OK	
    
OutputRow15
    i money'="" q:totalprice<money
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
  
    s Data=$lb(PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	
	q
SplitMulitData15(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	k multiData
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
    q
}

ClassMethod GetDISPENQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDISPENQuery1Execute ]
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

ClassMethod GetDISPENQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDISPENQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDISPENQuery1(press As %String, money As %String) As %Query(ROWSPEC = "PrescNo:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float") [ SqlProc ]
{
}

// 科室指标,参数传输代码,出院科室、医师指标排名分析用

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWSR2","2012-05-01","2012-05-01","","MRLocCyrs,GetCyLocFee,GetCyLocYLFee,GetCyLocYaoFee,GetCyLocKJYaoDDD,GetZyLocInjeCFJE,GetCyLocKJYaoFee,GetCyLocZYTS,MRKJLocCyrs,GetZyLocInjeRc,GetZyLocSyRc,GetZyKSYyTs,MRKjyw2Cnt,MRKjyw3Cnt,MRKjyw4Cnt","D","I","","dep")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepKPIKJYWSR2","2013-04-01","2013-04-08","","MRLocCyrs,MRKJLocCyrs","D","I","","dep")

ClassMethod GetDepKPIKJYWSR2Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, pattype As %String, hospid As %String, flag1 As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,kpiCodeStrZb,type,pattype,hospid,flag1)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    q:pattype="" $$$OK
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	i pattype="I" s pattypeNa="住院"
	i $F(","_"O,E"_",",","_pattype_",")'=0   s pattypeNa="门诊"
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
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb) ;,.data)
	q:sc'=1 1
	
	d SplitMulitData16(dept,,.deptData)
	d SplitMulitData16(pattype,,.pattypeData)
	d SplitMulitData16(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData16(hospid,,.hospidData)

	s monId="",value=0
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="",value=0
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimIdnod=0
	..f  s dimIdnod=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod))
    ...s dimId=$p(dimIdnod,",",1)  
    ...s jztype=$p(dimIdnod,",",2) 
    ...s doc=$p(dimIdnod,",",3) ;q:doc=""
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断类型是否为所选类型
	...q:(pattype'="")&&(jztype="") 
	...q:(pattype'="")&&('$d(pattypeData(jztype)))
	...//判断医院是否为所选医院
	...q:dimId=""
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
    ...i (flag1="dep") d              ;GetCyLocKJYaoFee
	....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRLocCyrs" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MRLocCyrs")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRLocCyrs"))+value 	//出院人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocZYTS" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocZYTS")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocZYTS"))+value 	//住院床日
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKJLocCyrs" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKJLocCyrs")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKJLocCyrs"))+value 	//使用抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocInjeRc" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeRc"))+value 	//使用注射药物人次
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocSyRc" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSyRc")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSyRc"))+value 	//静脉给药人次
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyKSYyTs" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyKSYyTs")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyKSYyTs"))+value 	//用药天数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocInjeCFJE" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeCFJE"))+value 	//注射剂收入
	....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocFee" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocFee"))+value 	//出院总收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocYLFee" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYLFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYLFee"))+value 	//出院医疗总收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocYaoFee" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYaoFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYaoFee"))+value 	//出院药品收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocKJYaoFee" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoFee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoFee"))+value 	  //出院抗菌药物收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocKJYaoDDD" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoDDD"))+value 	//出院抗菌药物DDD
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocGJBase" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocGJBase")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocGJBase"))+value 	//出院国家基本药物 
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocSJBase" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSJBase")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSJBase"))+value 	 //出院省基本药物
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocKJInjeCFJE" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocKJInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocKJInjeCFJE"))+value 	//出院抗菌注射剂收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw2Cnt" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw2Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw2Cnt"))+value 	//使用2联抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw3Cnt" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw3Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw3Cnt"))+value 	//使用3联抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw4Cnt" s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw4Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw4Cnt"))+value 	//使用4联抗菌药物人数
    ...i (flag1="doc") d
	....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRLocCyrs" s ^TEMPDHCWL($j,"DHCWLXC",doc,"MRLocCyrs")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MRLocCyrs"))+value 	//出院人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocZYTS" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocZYTS")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocZYTS"))+value 	//住院床日
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKJLocCyrs" s ^TEMPDHCWL($j,"DHCWLXC",doc,"MRKJLocCyrs")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MRKJLocCyrs"))+value 	//使用抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocInjeRc" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocInjeRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocInjeRc"))+value 	//使用注射药物人次
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocSyRc" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocSyRc")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocSyRc"))+value 	//静脉给药人次
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyKSYyTs" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyKSYyTs")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyKSYyTs"))+value 	//用药天数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocInjeCFJE" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocInjeCFJE"))+value 	//注射剂收入
	....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocFee" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocFee"))+value 	//出院总收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocYLFee" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocYLFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocYLFee"))+value 	//出院医疗总收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocYaoFee" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocYaoFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocYaoFee"))+value 	//出院药品收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocKJYaoFee" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocKJYaoFee")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocKJYaoFee"))+value 	//出院抗菌药物收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetCyLocKJYaoDDD" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocKJYaoDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetCyLocKJYaoDDD"))+value 	//出院抗菌药物DDD
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocGJBase" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocGJBase")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocGJBase"))+value 	//出院国家基本药物 
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocSJBase" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocSJBase")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocSJBase"))+value 	//出院省基本药物
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="GetZyLocKJInjeCFJE" s ^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocKJInjeCFJE")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"GetZyLocKJInjeCFJE"))+value 	//出院抗菌注射剂收入
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw2Cnt" s ^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw2Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw2Cnt"))+value 	//使用2联抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw3Cnt" s ^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw3Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw3Cnt"))+value 	//使用3联抗菌药物人数
    ....i $li(^DHCWL.MKPI.MKPID(kpiId),2)="MRKjyw4Cnt" s ^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw4Cnt")=$g(^TEMPDHCWL($j,"DHCWLXC",doc,"MRKjyw4Cnt"))+value 	//使用4联抗菌药物人数
    
    s (CYRC,CYZYCR,CYKJRC,CYZSJRC,CYPYRC,CYYYTS,CYZSJJE,CYZSR,CYYLSR,CYYPSR,CYKJYSR,CYKJYDDD,GetZyLocGJBase,GetZyLocSJBase,GetZyLocBase,GetZyLocKJInjeCFJE,CYKJ2RC,CYKJ3RC,CYKJ4RC)=0
    s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",dimId))  q:dimId=""  d
    .s CYRC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRLocCyrs"))
    .s CYZYCR=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocZYTS"))
    .s CYKJRC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKJLocCyrs"))
    .s CYZSJRC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeRc"))
    .s CYPYRC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSyRc"))
    .s CYYYTS=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyKSYyTs"))
    .s CYZSJJE=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocInjeCFJE"))
    .s CYZSR=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocFee"))   
    .s CYYLSR=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYLFee"))
    .s CYYPSR=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocYaoFee"))
    .s CYKJYSR=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoFee"))
    .s CYKJYDDD=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetCyLocKJYaoDDD"))
    .s GetZyLocGJBase=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocGJBase"))
    .s GetZyLocSJBase=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocSJBase"))
    .s GetZyLocBase=GetZyLocGJBase+GetZyLocSJBase
    .s GetZyLocKJInjeCFJE=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"GetZyLocKJInjeCFJE"))
    .s CYKJ2RC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw2Cnt"))
    .s CYKJ3RC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw3Cnt"))
    .s CYKJ4RC=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MRKjyw4Cnt"))
    .d OutPutRow16
	
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	Quit $$$OK
OutPutRow16
   	i (flag1="dep") d
    .i $d(^CTLOC(dimId))  d  
    ..s dimDesc1=$P($G(^CTLOC(dimId)),"^",2)  
    ..i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    ..e  s dimDesc=dimDesc1
    .e  s dimDesc="Null"
    
    i (flag1="doc") d
    .i $d(^CTPCP(dimId)) d
    ..s dimDesc=$$GetPatDoc^DHCWLCommon(dimId)
    .e  s dimDesc="Null"
	
	s Data=$lb(dimId,dimDesc,pattypeNa,CYRC,CYZYCR,CYKJRC,CYZSJRC,CYPYRC,CYYYTS,CYZSJJE,CYZSR,CYYLSR,CYYPSR,CYKJYSR,CYKJYDDD,GetZyLocGJBase,GetZyLocSJBase,GetZyLocBase,GetZyLocKJInjeCFJE,hospna,CYKJ2RC,CYKJ3RC,CYKJ4RC)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData16(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepKPIKJYWSR2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepKPIKJYWSR2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDepKPIKJYWSR2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepKPIKJYWSR2Execute ]
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

Query GetDepKPIKJYWSR2(startDate As %String, endDate As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, pattype As %String, hospid As %String, flag1 As %String) As %Query(ROWSPEC = "dimId:%String,dimDesc:%String,pattypeNa:%String,CYRC:%Float,CYZYCR:%Float,CYKJRC:%Float,CYZSJRC:%Float,CYPYRC:%Float,CYYYTS:%Float,CYZSJJE:%Float,CYZSR:%Float,CYYLSR:%Float,CYYPSR:%Float,CYKJYSR:%Float,CYKJYDDD:%Float,GetZyLocGJBase:%Float,GetZyLocSJBase:%Float,GetZyLocBase:%Float,GetZyLocKJInjeCFJE:%Float,hospna:%String,CYKJ2RC:%Float,CYKJ3RC:%Float,CYKJ4RC:%Float") [ SqlProc ]
{
}

// 出院患者药品费用信息

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeXX","2012-12-01","2012-12-03","D","GetZyLocRcMx","","816","",1)	

/*ClassMethod GetPatYPFeeXXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %String, doc As %String, hospid As %String, base As %String) As %Status
{
	n (qHandle,startDate,endDate,type,kpiCodeStrZb,dept,doc,hospid,base)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
    s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
 	q:monIdStr="" 1
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData17(dept,,.deptData)
	d SplitMulitData17(doc,,.docData)
	d SplitMulitData17(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData17(hospid,,.hospidData)
    d SplitMulitData17(base,,.baseData)
    
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	...s dimIdDoc=$p(dimId,",",2) 
	...//判断医师是否为所选医师
	...q:(doc'="")&&(dimIdDoc="") 
	...q:(doc'="")&&('$d(docData(dimIdDoc)))
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s ADMRowID=$p(dimId,",",3)
	...q:ADMRowID="" 
	...s WLRowid=0,qty=0,Fee=0
	...f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
	....s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    ....q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    ....s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    ....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori)
    ....//判断科室是否为所选基本药物
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
    ....s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	....s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ....s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty"))+qty
    ....s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee"))+Fee
    ....s oeordId=$p(oeori,"||",1)
    ....s oeoriSub=$p(oeori,"||",2)
  	....s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
 	....s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
 	....q:((ststat'=1) && (ststat'=6))
	....s ^TEMPDHCWL1($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,ADMRowID,sttDate,"yyts")=1
    
    s loc=0 f  s loc=$o(^TEMPDHCWL1($j,"DHCWLXC",loc)) q:loc=""  d
    .s docId=0 f  s docId=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId)) q:docId=""  d
    ..s item=0 f  s item=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item)) q:item=""  d
    ...s adm=0 f  s adm=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm)) q:adm=""  d
    ....s stt=0 f  s stt=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt)) q:stt=""  d
    .....s yyts1=$g(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt,"yyts"))
    .....s ^temp2($j,"DHCWLXC",loc,docId,item,"yyts")=$g(^temp2($j,"DHCWLXC",loc,docId,item,"yyts"))+yyts1
    
    s locId=0 f  s locId=$o(^TEMPDHCWL($j,"DHCWLXC",locId)) q:locId=""  d
    .s dociId=0 f  s dociId=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId)) q:dociId=""  d
    ..s itemid=0 f  s itemid=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid)) q:itemid=""  d
    ...s Ypqty=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"qty")) 
    ...s Ypfee=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"fee")) 
    ...s Yyts=$g(^temp2($j,"DHCWLXC",locId,dociId,itemid,"yyts")) 
    ...d OutputRow17
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
 	q $$$OK	

OutputRow17
    i $d(^CTLOC(locId))  d  
    .s dimDesc1=$P($G(^CTLOC(locId)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i $d(^CTPCP(dociId)) d
    .s docna=$$GetPatDoc^DHCWLCommon(dociId)
    .e  s docna="Null"
   
    i $d(^DHCTARI(itemid)) d
    .s itmdesc=$p(^DHCTARI(itemid),"^",2)
    .s uom=$p(^DHCTARI(itemid),"^",3)
    .i $d(^CT("UOM",uom))  s danwei=$p(^CT("UOM",uom),"^",2)
           
    s Data=$lb(locId,deptna,dociId,docna,itemid,itmdesc,danwei,Ypqty,Ypfee,Yyts)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData17(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}
*/

// 出院患者药品费用信息

// 改为取指标实时数据	GetZyLocRcMx

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeXX","2012-12-01","2012-12-03","D","GetZyLocRcMx","","816","",1)	

/// 2014-12-08query屏蔽备份 zl
ClassMethod GetPatYPFeeXXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Status
{
	n (qHandle,startDate,endDate,type,kpiCodeStrZb,dept,doc,hospid,base)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s kpiCodeStrZb="GetZyLocRcMx"
	s choiceType="C"
	s isRealData="R"
	
    k ^TEMPDHCWL("S",$j),^TEMPDHCWL("Days",$j),^TEMPDHCWL("DAY",$j)
    
	d SplitMulitData17(dept,,.deptData)
	d SplitMulitData17(doc,,.docData)
	d SplitMulitData17(kpiCodeStrZb,,.kpiCodeStrZbData)
	d SplitMulitData17(hospid,,.hospidData)
    d SplitMulitData17(base,,.baseData)
    
    set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpiCodeStrZb,startDate,endDate,choiceType,isRealData)
    
    While rs.Next(.sc) {
		s dimId=$g(rs.Data("dimId"))
		s dimdesc=$g(rs.Data("dimDesc")) 
		s kpiId=$g(rs.Data("kpiId"))
		s kpiCode=$g(rs.Data("kpiCode"))
		s value=$g(rs.Data("value"))
		s dimIdLoc=$p(dimId,",",1)
	
	//判断科室是否为所选科室
	continue:(dept'="")&&(dimIdLoc="") 
	continue:(dept'="")&&('$d(deptData(dimIdLoc)))
	//判断医院是否为所选医院
	s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	continue:(hospid'="")&&(hosp="") 
	continue:(hospid'="")&&('$d(hospidData(hosp)))
	i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	s dimIdDoc=$p(dimId,",",2) 
	//判断医师是否为所选医师
	continue:(doc'="")&&(dimIdDoc="") 
	continue:(doc'="")&&('$d(docData(dimIdDoc)))
	//判断指标是否为所选指标
	continue:(kpiCodeStrZb'="")&&(kpiId="")  
	continue:(kpiCodeStrZb'="")&&('$d(kpiCodeStrZbData(kpiCode)))
	s ADMRowID=$p(dimId,",",3)
	continue:ADMRowID="" 
	s WLRowid=0,qty=0,Fee=0
	f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
	.s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    .q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    .s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    .s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori)
    .//判断科室是否为所选基本药物
	.q:(base'="")&&(baseflag="") 
	.q:(base'="")&&('$d(baseData(baseflag)))
    .s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	.s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    .s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .s ^TEMPDHCWL("S",$j,dimIdLoc,dimIdDoc,itm,"qty")=$g(^TEMPDHCWL("S",$j,dimIdLoc,dimIdDoc,itm,"qty"))+qty
    .s ^TEMPDHCWL("S",$j,dimIdLoc,dimIdDoc,itm,"fee")=$g(^TEMPDHCWL("S",$j,dimIdLoc,dimIdDoc,itm,"fee"))+Fee
    .s oeordId=$p(oeori,"||",1)
    .s oeoriSub=$p(oeori,"||",2)
  	.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
 	.s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
 	.q:((ststat'=1) && (ststat'=6))
	.s ^TEMPDHCWL("Days",$j,dimIdLoc,dimIdDoc,itm,ADMRowID,sttDate,"yyts")=1
    }
    s loc=0 f  s loc=$o(^TEMPDHCWL("Days",$j,loc)) q:loc=""  d
    .s docId=0 f  s docId=$o(^TEMPDHCWL("Days",$j,loc,docId)) q:docId=""  d
    ..s item=0 f  s item=$o(^TEMPDHCWL("Days",$j,loc,docId,item)) q:item=""  d
    ...s adm=0 f  s adm=$o(^TEMPDHCWL("Days",$j,loc,docId,item,adm)) q:adm=""  d
    ....s stt=0 f  s stt=$o(^TEMPDHCWL("Days",$j,loc,docId,item,adm,stt)) q:stt=""  d
    .....s yyts1=$g(^TEMPDHCWL("Days",$j,loc,docId,item,adm,stt,"yyts"))
    .....s ^TEMPDHCWL("DAY",$j,loc,docId,item,"yyts")=$g(^TEMPDHCWL("DAY",$j,loc,docId,item,"yyts"))+yyts1
    
    s locId=0 f  s locId=$o(^TEMPDHCWL("S",$j,locId)) q:locId=""  d
    .s dociId=0 f  s dociId=$o(^TEMPDHCWL("S",$j,locId,dociId)) q:dociId=""  d
    ..s itemid=0 f  s itemid=$o(^TEMPDHCWL("S",$j,locId,dociId,itemid)) q:itemid=""  d
    ...s Ypqty=$g(^TEMPDHCWL("S",$j,locId,dociId,itemid,"qty")) 
    ...s Ypfee=$g(^TEMPDHCWL("S",$j,locId,dociId,itemid,"fee")) 
    ...s Yyts=$g(^TEMPDHCWL("DAY",$j,locId,dociId,itemid,"yyts")) 
    ...d OutputRow17
    k ^TEMPDHCWL("S",$j),^TEMPDHCWL("Days",$j),^TEMPDHCWL("DAY",$j)
 	
 	q $$$OK	

OutputRow17
    i $d(^CTLOC(locId))  d  
    .s dimDesc1=$P($G(^CTLOC(locId)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i $d(^CTPCP(dociId)) d
    .s docna=$$GetPatDoc^DHCWLCommon(dociId)
    .e  s docna="Null"
   
    i $d(^DHCTARI(itemid)) d
    .s itmdesc=$p(^DHCTARI(itemid),"^",2)
    .s uom=$p(^DHCTARI(itemid),"^",3)
    .i $d(^CT("UOM",uom))  s danwei=$p(^CT("UOM",uom),"^",2)
           
    s Data=$lb(locId,deptna,dociId,docna,itemid,itmdesc,danwei,Ypqty,Ypfee,Yyts)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData17(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

/*ClassMethod GetPatYPFeeXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeXXExecute ]
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
*/
/// 2014-12-08query备份屏蔽，zl
ClassMethod GetPatYPFeeXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeXXExecute ]
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

ClassMethod GetPatYPFeeXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*Query GetPatYPFeeXX(startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %String, doc As %String, hospid As %String, base As %String) As %Query(ROWSPEC = "locId:%String,deptna:%String,dociId:%String,docna:%String,itemid:%String,itmdesc:%String,danwei:%String,Ypqty:%Float,Ypfee:%Float,Yyts:%Float") [ SqlProc ]
{
}*/
/// 2014-12-08 query备份屏蔽，zl
Query GetPatYPFeeXX(startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Query(ROWSPEC = "locId:%String,deptna:%String,dociId:%String,docna:%String,itemid:%String,itmdesc:%String,danwei:%String,Ypqty:%Float,Ypfee:%Float,Yyts:%Float") [ SqlProc ]
{
}

/*
// 新科室医师患者处方明细监控2013-05-30

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2012-12-01","2012-12-01","","","MzDocPress","D","","","","","yp","ALL","","","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2013-04-15","2013-04-15","","","MzDocPress","D","","","","","1","ALL","","","")

ClassMethod GetDepDocPressMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag,base,pattype,prcnt)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
	s sday=$zdh(startDate,3)
    s eday=$zdh(endDate,3)
  
    k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC"),^Tempdata($j,"DHCWLXC")
    
    d SplitMulitData18(dept,,.deptData)
	d SplitMulitData18(doc,,.docData)
	;d SplitMulitData18(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData18(hospid,,.hospidData)
	d SplitMulitData18(drgId,,.drgIdData)
	d SplitMulitData18(base,,.baseData)
	d SplitMulitData18(pattype,,.pattypeData)
    //门诊发药
    f pyday=sday:1:eday d
    .s phldr="" f  s phldr=$o(^DHCPHDISPi("FYDATE",pyday,phldr)) q:phldr=""  d
    ..s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("FYDATE",pyday,phldr,PHDROWID)) q:PHDROWID=""  d
    ...s press1=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ...s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ....s PAYAMOUNT=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3)
    ....s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ....s oeordr=$p(OEORIDR,"||",1)
    ....s oeorsub=$p(OEORIDR,"||",2)
    ....s dimId=$p(^OEORD(oeordr,"I",oeorsub,7),"^",2)  
    ....i dimId="" s dimId="999999"
    ....//判断科室是否为所选科室
	....q:(dept'="")&&(dimId="") 
	....q:(dept'="")&&('$d(deptData(dimId)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(dimId)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....s docId=$p($g(^OEORD(oeordr,"I",oeorsub,1)),"^",11) ;开单医师
    ....i docId="" s docId="999999"
    ....//判断医师是否为所选医师
	....q:(doc'="")&&(docId="") 
	....q:(doc'="")&&('$d(docData(docId)))
    ....s admId=$p(^OEORD(oeordr),"^",1)
 	....s admtype=$p(^PAADM(admId),"^",2) ;20130312 add
    ....//判断医师是否为所选患者类型;急诊、门诊
	....q:(pattype'="")&&(admtype="") 
	....q:(pattype'="")&&('$d(pattypeData(admtype)))
    ....s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    ....s diagcode=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    ....s diagdesc=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
    ....//判断诊断是否包含所选诊断
	....q:(diag'="")&&(diagdesc="") 
	....q:(diag'="")&&(diagdesc'[diag)
    ....q:'$d(^DHCPHDISPi("PRESCNO",press1))
    ....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)  ;q:phcdf1'=252
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
	....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(OEORIDR)
    ....//判断科室是否为所选基本药物类型
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
	....i kjflag="ALL" d
    .....s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    .....s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) ;q:count1=0 
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty"))+count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee"))+price1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE"))+price1
    ......//2013-04-26 lxc add
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty"))+count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee"))+price1
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty"))+count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee"))+price1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE"))+price1
    ....;抗菌药物统计
	....i kjflag="KJYW" d
	.....q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	.....s price11=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    .....s count11=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) ;q:count11=0 
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty"))+count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee"))+price11
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE"))+price11
    ......//2013-04-26 lxc add
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty"))+count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee"))+price11
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty"))+count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee"))+price11
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE"))+price11
        
    //门诊退药
    f date1=sday:1:eday d
	.s phLoc1="",wlRowid=""
	.f  s phLoc1=$o(^DHCPHRETi(date1,phLoc1)) q:phLoc1=""  d
	..s phrId1=0
	..f  s phrId1=$o(^DHCPHRETi(date1,phLoc1,phrId1)) q:phrId1=""  d
	...s phId1=$p(^DHCPHRET(phrId1),"^",6)
	...s phrItem1=""
	...f  s phrItem1=$o(^DHCPHRTI(phrId1,"RTI",phrItem1)) q:phrItem1=""  d
	....s oeori1=$p(^DHCPHRTI(phrId1,"RTI",phrItem1),"^",2)
	....s ord=+oeori1
	....s ordSub=$p(oeori1,"||",2)
	....s dimId=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	....//判断科室是否为所选科室
	....q:(dept'="")&&(dimId="") 
	....q:(dept'="")&&('$d(deptData(dimId)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(dimId)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....s docId=$p($g(^OEORD(ord,"I",ordSub,1)),"^",11) ;开单医师
    ....i docId="" s docId="999999"
    ....//判断医师是否为所选医师
	....q:(doc'="")&&(docId="") 
	....q:(doc'="")&&('$d(docData(docId)))
    ....s admId=$p(^OEORD(ord),"^",1)
 	....s admtype=$p(^PAADM(admId),"^",2) ;20130312 add
    ....//判断医师是否为所选患者类型;急诊、门诊
	....q:(pattype'="")&&(admtype="") 
	....q:(pattype'="")&&('$d(pattypeData(admtype)))
    ....s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    ....s diagcode=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    ....s diagdesc=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
    ....//判断诊断是否包含所选诊断
	....q:(diag'="")&&(diagdesc="") 
	....q:(diag'="")&&(diagdesc'[diag)
    ....q:'$d(^DHCPHDISPi("PRESCNO",press1))
    ....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori1)  ;q:phcdf1'=252
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
	....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori1)
    ....//判断科室是否为所选基本药物类型
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
	....i kjflag="ALL" d
    .....s price1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1) 
    .....s count1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3) ;q:count1=0 
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty"))-count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee"))-price1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE"))-price1
    ......//2013-04-26 lxc add
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty"))-count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee"))-price1
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty"))-count1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee"))-price1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE"))-price1
    ....;抗菌药物统计
	....i kjflag="KJYW" d
	.....q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	.....s price11=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1) 
    .....s count11=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)  ;q:count11=0 
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Qty"))-count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimId,docId,admId,press1,+phcdf1,"Fee"))-price11
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"CFJE"))-price11
    ......//2013-04-26 lxc add
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Qty"))-count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",+phcdf1,"Fee"))-price11
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Qty"))-count11
    ......s ^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",docId,+phcdf1,"Fee"))-price11
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",docId,"docJE"))-price11
        
    i flag="1" d
    .s totalprice=0  
    .s loc="" f  s loc=$o(^TEMPDHCWL($j,"DHCWLLXC",loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid))  q:docid=""  d
    ...s adm="" f  s adm=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm))  q:adm=""  d
    ....s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,PrescNo))  q:PrescNo=""  d
    .....s totalprice=$g(^TEMPDHCWL1($j,"DHCWLLXC",loc,docid,adm,PrescNo,"CFJE"))
    .....i money'="" q:totalprice<money
    .....//2013-04-26 lxc 
    .....s prntcount=$g(^TEMPDHCWL1($j,"DHCWLLXC",loc,docid,adm,PrescNo,"prnt"))
    .....i prcnt'="" q:prntcount<prcnt
    .....//2013-04-26 lxc 
    .....s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,PrescNo,phcdf))  q:phcdf=""  d
    ......s count=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,PrescNo,phcdf,"Qty"))  
    ......s price=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,PrescNo,phcdf,"Fee")) 
    ......d OutPutRow18
    
    i flag="yp" d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Fee")) 
    ..d OutPutRow18YP
    
    i flag="docyp" d
    .s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",docid))  q:docid=""  d
    ..s totalprice=$g(^TEMPDHCWL1($j,"DHCWLLXC",docid,"docJE"))
    ..s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf))  q:phcdf=""  d
    ...s count=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Qty"))  
    ...s price=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Fee")) 
    ...d OutPutRow18DOCYP
    
	k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC"),^Tempdata($j,"DHCWLXC")
	Quit $$$OK
OutPutRow18
    
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge18(birth,+$h)
    s age=$p(age,"Y",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    s diagstr=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    s diagco=$p($g(diagstr),"^",2) i diagco="" s diagco="999999"
    s diagna=$p($g(diagstr),"^",3) i diagna="" s diagna="Null"
    s diagco=$TR(diagco,",",".")
    s diagna=$TR(diagna,",",".")
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18YP
   
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18DOCYP
    
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge18(birth,+$h)
    s age=$p(age,"Y",1)
  
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitData18(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge18(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
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

ClassMethod GetDepDocPressMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPressMX(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}
*/

// 新科室医师患者处方明细监控2013-05-30

// 增加药品单次剂量及使用频次 2019-8-12 zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2012-12-01","2012-12-01","","","MzDocPress","D","","","","","yp","ALL","","","")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2019-09-1","2019-09-30","","","MzDocPress","D","","","","","1","ALL","","","")

ClassMethod GetDepDocPressMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag,base,pattype,prcnt)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
	s sday=$zdh(startDate,3)
    s eday=$zdh(endDate,3)
  
    k ^TEMPDHCWL($j,"Drug"),^TEMPDHCWL($j,"PRESS")
    
    d SplitMulitData18(dept,,.deptData)
	d SplitMulitData18(doc,,.docData)
	d SplitMulitData18(hospid,,.hospidData)
	d SplitMulitData18(drgId,,.drgIdData)
	d SplitMulitData18(base,,.baseData)
	d SplitMulitData18(pattype,,.pattypeData)
    //门诊发药
    f pyday=sday:1:eday d
    .s phldr="" f  s phldr=$o(^DHCPHDISPi("FYDATE",pyday,phldr)) q:phldr=""  d
    ..s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("FYDATE",pyday,phldr,PHDROWID)) q:PHDROWID=""  d
    ...s press1=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ...s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ....s PAYAMOUNT=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3)
    ....s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ....s oeordr=$p(OEORIDR,"||",1)
    ....s oeorsub=$p(OEORIDR,"||",2)
    ....s dimId=$p(^OEORD(oeordr,"I",oeorsub,7),"^",2)  
    ....i dimId="" s dimId="999999"
    ....//判断科室是否为所选科室
	....q:(dept'="")&&(dimId="") 
	....q:(dept'="")&&('$d(deptData(dimId)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(dimId)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....s docId=$p($g(^OEORD(oeordr,"I",oeorsub,1)),"^",11) ;开单医师
    ....i docId="" s docId="999999"
    ....//判断医师是否为所选医师
	....q:(doc'="")&&(docId="") 
	....q:(doc'="")&&('$d(docData(docId)))
    ....s admId=$p(^OEORD(oeordr),"^",1)
 	....s admtype=$p(^PAADM(admId),"^",2) ;20130312 add
    ....//判断医师是否为所选患者类型;急诊、门诊
	....q:(pattype'="")&&(admtype="") 
	....q:(pattype'="")&&('$d(pattypeData(admtype)))
    ....s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    ....s diagcode=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    ....s diagdesc=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
    ....//判断诊断是否包含所选诊断
	....q:(diag'="")&&(diagdesc="") 
	....q:(diag'="")&&(diagdesc'[diag)
    ....q:'$d(^DHCPHDISPi("PRESCNO",press1))
    ....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)  
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
	....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(OEORIDR)
    ....//判断科室是否为所选基本药物类型
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
	....s phchildsub=0
	....f  s phchildsub=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB,"INCLB",phchildsub)) q:phchildsub=""  d  ;DHC_PHDISITMCLB--门诊配/发药孙表
	.....s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB,"INCLB",phchildsub),"^",1)  ;发药数量
	.....s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB,"INCLB",phchildsub),"^",8)  ;售价金额
	.....i kjflag="ALL" d
	......i flag="1" d
    .......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Qty")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Fee")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Fee"))+price1
    .......s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE"))+price1
    .......i '$d(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,phcdf1,"prnt")) d
    ........s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt"))+1  
	........s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,phcdf1,"prnt")=""
    ......i flag="yp" d
    .......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Fee"))+price1
    ......i flag="docyp" d
    .......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee"))+price1
    .......s ^TEMPDHCWL($j,"PRESS",docId,"docJE")=$g(^TEMPDHCWL($j,"PRESS",docId,"docJE"))+price1
    .....;抗菌药物统计
	.....i kjflag="KJYW" d
	......q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	......i flag="1" d
    .......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Qty")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Fee")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,OEORIDR,"Fee"))+price1
    .......s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE"))+price1
    .......i '$d(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,phcdf1,"prnt")) d
    ........s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt"))+1  
	........s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,phcdf1,"prnt")="" 
    ......i flag="yp" d
    .......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Fee"))+price1
    ......i flag="docyp" d
    .......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty"))+count1
    .......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee"))+price1
    .......s ^TEMPDHCWL($j,"PRESS",docId,"docJE")=$g(^TEMPDHCWL($j,"PRESS",docId,"docJE"))+price1
        
    //门诊退药
    f date1=sday:1:eday d
	.s phLoc1="",wlRowid=""
	.f  s phLoc1=$o(^DHCPHRETi(date1,phLoc1)) q:phLoc1=""  d
	..s phrId1=0
	..f  s phrId1=$o(^DHCPHRETi(date1,phLoc1,phrId1)) q:phrId1=""  d
	...s phId1=$p(^DHCPHRET(phrId1),"^",6)
	...s press1=$p(^DHCPHDISP(phId1,2),"^",1)   ;处方号
	...s phrItem1=""
	...f  s phrItem1=$o(^DHCPHRTI(phrId1,"RTI",phrItem1)) q:phrItem1=""  d
	....s oeori1=$p(^DHCPHRTI(phrId1,"RTI",phrItem1),"^",2)
	....s ord=+oeori1
	....s ordSub=$p(oeori1,"||",2)
	....s dimId=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	....//判断科室是否为所选科室
	....q:(dept'="")&&(dimId="") 
	....q:(dept'="")&&('$d(deptData(dimId)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(dimId)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....s docId=$p($g(^OEORD(ord,"I",ordSub,1)),"^",11) ;开单医师
    ....i docId="" s docId="999999"
    ....//判断医师是否为所选医师
	....q:(doc'="")&&(docId="") 
	....q:(doc'="")&&('$d(docData(docId)))
    ....s admId=$p(^OEORD(ord),"^",1)
 	....s admtype=$p(^PAADM(admId),"^",2) ;20130312 add
    ....//判断医师是否为所选患者类型;急诊、门诊
	....q:(pattype'="")&&(admtype="") 
	....q:(pattype'="")&&('$d(pattypeData(admtype)))
    ....s diagna=$$getpatdiag^DHCWLBuildKPICommon(admId,"")  
    ....s diagcode=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    ....s diagdesc=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
    ....//判断诊断是否包含所选诊断
	....q:(diag'="")&&(diagdesc="") 
	....q:(diag'="")&&(diagdesc'[diag)
    ....q:'$d(^DHCPHDISPi("PRESCNO",press1))
    ....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori1)  ;q:phcdf1'=252
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
	....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori1)
    ....//判断科室是否为所选基本药物类型
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
	....s price=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1) 
    ....s count=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)
	....i kjflag="ALL" d
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Qty")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Fee")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Fee"))-price
    ......s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE"))-price
    ......//2013-04-26 lxc add
    ......;s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Fee"))-price
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee"))-price
    ......s ^TEMPDHCWL($j,"PRESS",docId,"docJE")=$g(^TEMPDHCWL($j,"PRESS",docId,"docJE"))-price
    ....;抗菌药物统计
	....i kjflag="KJYW" d
	.....q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	.....i flag="1" d
    ......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Qty")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Fee")=$g(^TEMPDHCWL($j,"Drug",dimId,docId,admId,press1,oeori1,"Fee"))-price
    ......s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"CFJE"))-price
    ......//2013-04-26 lxc add
    ......;s ^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt")=$g(^TEMPDHCWL($j,"PRESS",dimId,docId,admId,press1,"prnt"))+1  
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",+phcdf1,"Fee"))-price
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Qty"))-count
    ......s ^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"Drug",docId,+phcdf1,"Fee"))-price
    ......s ^TEMPDHCWL($j,"PRESS",docId,"docJE")=$g(^TEMPDHCWL($j,"PRESS",docId,"docJE"))-price
        
    i flag="1" d
    .s totalprice=0  
    .s loc="" f  s loc=$o(^TEMPDHCWL($j,"Drug",loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWL($j,"Drug",loc,docid))  q:docid=""  d
    ...s adm="" f  s adm=$o(^TEMPDHCWL($j,"Drug",loc,docid,adm))  q:adm=""  d
    ....s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL($j,"Drug",loc,docid,adm,PrescNo))  q:PrescNo=""  d
    .....s totalprice=$g(^TEMPDHCWL($j,"PRESS",loc,docid,adm,PrescNo,"CFJE"))
    .....i money'="" q:totalprice<money
    .....//2013-04-26 lxc 
    .....s prntcount=$g(^TEMPDHCWL($j,"PRESS",loc,docid,adm,PrescNo,"prnt"))
    .....i prcnt'="" q:prntcount<prcnt
    .....//2013-04-26 lxc 
    .....s oeori="" f  s oeori=$o(^TEMPDHCWL($j,"Drug",loc,docid,adm,PrescNo,oeori))  q:oeori=""  d
    ......s count=$g(^TEMPDHCWL($j,"Drug",loc,docid,adm,PrescNo,oeori,"Qty"))  
    ......s price=$g(^TEMPDHCWL($j,"Drug",loc,docid,adm,PrescNo,oeori,"Fee")) 
    ......d OutPutRow18
    
    i flag="yp" d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"Drug",phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL($j,"Drug",phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL($j,"Drug",phcdf,"Fee")) 
    ..d OutPutRow18YP
    
    i flag="docyp" d
    .s docid="" f  s docid=$o(^TEMPDHCWL($j,"Drug",docid))  q:docid=""  d
    ..s totalprice=$g(^TEMPDHCWL($j,"PRESS",docid,"docJE"))
    ..s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"Drug",docid,phcdf))  q:phcdf=""  d
    ...s count=$g(^TEMPDHCWL($j,"Drug",docid,phcdf,"Qty"))  
    ...s price=$g(^TEMPDHCWL($j,"Drug",docid,phcdf,"Fee")) 
    ...d OutPutRow18DOCYP
    
	k ^TEMPDHCWL($j,"Drug"),^TEMPDHCWL($j,"PRESS")
	Quit $$$OK
OutPutRow18
    
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge18(birth,+$h)
    s age=$p(age,"Y",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori)
    s ItmMastDesc=$p(^PHCD(+phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(+phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(+phcdf_"||1")
    s diagstr=$$getpatdiag^DHCWLBuildKPICommon(adm,"")  
    s diagco=$p($g(diagstr),"^",2) i diagco="" s diagco="999999"
    s diagna=$p($g(diagstr),"^",3) i diagna="" s diagna="Null"
    s diagco=$TR(diagco,",",".")
    s diagna=$TR(diagna,",",".")
    s ord=+oeori
    s ordSub=$p(oeori,"||",2)
    s dosqty=$p($g(^OEORD(ord,"I",ordSub,2)),"^",1)	;单次剂量
	i dosqty="" s dosqty="Null"
	s phfreq=$p($g(^OEORD(ord,"I",ordSub,2)),"^",4)	;频次
	s freqDesc=""
	i phfreq'="" d
	.s freqDesc=$p($g(^PHCFR(phfreq)),"^",3)
	
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna,dosqty,freqDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18YP
   
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18DOCYP
    
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge18(birth,+$h)
    s age=$p(age,"Y",1)
  
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitData18(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge18(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
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

ClassMethod GetDepDocPressMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPressMX(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String,dosqty:%String,freqDesc:%String") [ SqlProc ]
{
}

/*
//新科室医师患者处方明细监控2014-11-10

//实时指标查询   MzDocPress

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2012-12-01","2012-12-01","","","MzDocPress","D","","","","","yp","ALL","","","")

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressMX","2013-04-15","2013-04-15","","","MzDocPress","D","","","","","1","ALL","","","")

ClassMethod GetDepDocPressMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag,base,pattype,prcnt)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK

    k ^TEMPDHCWL("S",$j),^TEMPDHCWL("Fee",$j)
    
    s kpiCodeStrZb="MzDocPress"
	s choiceType="C"
	s isRealData="R"
	
    d SplitMulitData18(dept,,.deptData)
	d SplitMulitData18(doc,,.docData)
	d SplitMulitData18(hospid,,.hospidData)
	d SplitMulitData18(drgId,,.drgIdData)
	d SplitMulitData18(base,,.baseData)
	d SplitMulitData18(pattype,,.pattypeData)
	  
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpiCodeStrZb,startDate,endDate,choiceType,isRealData)
	
	While rs.Next(.sc) {
		s dimIdnod=$g(rs.Data("dimId"))
		s dimdesc=$g(rs.Data("dimDesc")) 
		s kpiId=$g(rs.Data("kpiId"))
		s kpiCode=$g(rs.Data("kpiCode"))
		s value=$g(rs.Data("value"))
		s dimId=$p(dimIdnod,",",1)
		//判断科室是否为所选科室
	 	continue:(dept'="")&&(dimId="") 
		continue:(dept'="")&&('$d(deptData(dimId)))
		//判断医院是否为所选医院
		s hosp=$P($G(^CTLOC(dimId)),"^",22)
	 	i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
		continue:(hospid'="")&&(hosp="") 
		continue:(hospid'="")&&('$d(hospidData(hosp)))
		i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    	i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    	s docId=$p(dimIdnod,",",2)
    	i docId="" s docId="999999"
    	//判断医师是否为所选医师
		continue:(doc'="")&&(docId="") 
		continue:(doc'="")&&('$d(docData(docId)))
    	s admId=$p(dimIdnod,",",3)
    	s diagcode=$p(dimIdnod,",",4) i diagcode="" s diagcode="999999"
    	s diagdesc=$p(dimIdnod,",",5) i diagdesc="" s diagdesc="Null"
    	s admtype=$p(^PAADM(admId),"^",2) 
    	//判断医师是否为所选患者类型;急诊、门诊
		continue:(pattype'="")&&(admtype="") 
		continue:(pattype'="")&&('$d(pattypeData(admtype)))
    	//判断诊断是否包含所选诊断
		continue:(diag'="")&&(diagdesc="") 
		continue:(diag'="")&&(diagdesc'[diag)
		s press1=$p(dimIdnod,",",6)
		continue:'$d(^DHCPHDISPi("PRESCNO",press1))
    	s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("PRESCNO",press1,PHDROWID)) q:PHDROWID=""  d
		.s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    	..s oeori=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
       	..s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori)  ;q:phcdf1'=252
    	..//判断是否为所选药品
		..q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
		..q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
		..s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori)
    	..//判断科室是否为所选基本药物类型
		..q:(base'="")&&(baseflag="") 
		..q:(base'="")&&('$d(baseData(baseflag)))
		..i kjflag="ALL" d
    	...s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    	...s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) ;q:count1=0 
		...i flag="1" d
    	....s ^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Qty"))+count1
    	....s ^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Fee"))+price1
    	....s ^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"CFJE")=$g(^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"CFJE"))+price1
    	....//2013-04-26 lxc add
    	....s ^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"prnt")=$g(^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"prnt"))+1  
    	...i flag="yp" d
    	....s ^TEMPDHCWL("S",$j,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,+phcdf1,"Qty"))+count1
    	....s ^TEMPDHCWL("S",$j,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,+phcdf1,"Fee"))+price1
    	...i flag="docyp" d
    	....s ^TEMPDHCWL("S",$j,docId,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,docId,+phcdf1,"Qty"))+count1
    	....s ^TEMPDHCWL("S",$j,docId,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,docId,+phcdf1,"Fee"))+price1
    	....s ^TEMPDHCWL("Fee",$j,docId,"docJE")=$g(^TEMPDHCWL("Fee",$j,docId,"docJE"))+price1
    	..;抗菌药物统计
		..i kjflag="KJYW" d
		...q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
		...s price11=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    	...s count11=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) ;q:count11=0 
		...i flag="1" d
    	....s ^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Qty"))+count11
    	....s ^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,dimId,docId,diagcode,diagdesc,admId,press1,+phcdf1,"Fee"))+price11
    	....s ^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"CFJE")=$g(^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"CFJE"))+price11
    	....//2013-04-26 lxc add
    	....s ^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"prnt")=$g(^TEMPDHCWL("Fee",$j,dimId,docId,diagcode,diagdesc,admId,press1,"prnt"))+1  
    	...i flag="yp" d
    	....s ^TEMPDHCWL("S",$j,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,+phcdf1,"Qty"))+count11
    	....s ^TEMPDHCWL("S",$j,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,+phcdf1,"Fee"))+price11
    	...i flag="docyp" d
    	....s ^TEMPDHCWL("S",$j,docId,+phcdf1,"Qty")=$g(^TEMPDHCWL("S",$j,docId,+phcdf1,"Qty"))+count11
    	....s ^TEMPDHCWL("S",$j,docId,+phcdf1,"Fee")=$g(^TEMPDHCWL("S",$j,docId,+phcdf1,"Fee"))+price11
    	....s ^TEMPDHCWL("Fee",$j,docId,"docJE")=$g(^TEMPDHCWL("Fee",$j,docId,"docJE"))+price11
	}
    i flag="1" d
    .s totalprice=0  
    .s loc="" f  s loc=$o(^TEMPDHCWL("S",$j,loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWL("S",$j,loc,docid))  q:docid=""  d
    ...s diagco="" f  s diagco=$o(^TEMPDHCWL("S",$j,loc,docid,diagco))  q:diagco=""  d
    ....s diagna="" f  s diagna=$o(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna))  q:diagna=""  d
    .....s adm="" f  s adm=$o(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna,adm))  q:adm=""  d
    ......s PrescNo="" f  s PrescNo=$o(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna,adm,PrescNo))  q:PrescNo=""  d
    .......s totalprice=$g(^TEMPDHCWL("Fee",$j,loc,docid,diagco,diagna,adm,PrescNo,"CFJE"))
    .......i money'="" q:totalprice<money
    .......//2013-04-26 lxc 
    .......s prntcount=$g(^TEMPDHCWL("Fee",$j,loc,docid,diagco,diagna,adm,PrescNo,"prnt"))
    .......i prcnt'="" q:prntcount<prcnt
    .......//2013-04-26 lxc 
    .......s phcdf="" f  s phcdf=$o(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna,adm,PrescNo,phcdf))  q:phcdf=""  d
    ........s count=$g(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna,adm,PrescNo,phcdf,"Qty"))  
    ........s price=$g(^TEMPDHCWL("S",$j,loc,docid,diagco,diagna,adm,PrescNo,phcdf,"Fee")) 
    ........d OutPutRow18
    
    i flag="yp" d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL("S",$j,phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL("S",$j,phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL("S",$j,phcdf,"Fee")) 
    ..d OutPutRow18YP
    
    i flag="docyp" d
    .s docid="" f  s docid=$o(^TEMPDHCWL("S",$j,docid))  q:docid=""  d
    ..s totalprice=$g(^TEMPDHCWL("Fee",$j,docid,"docJE"))
    ..s phcdf="" f  s phcdf=$o(^TEMPDHCWL("S",$j,docid,phcdf))  q:phcdf=""  d
    ...s count=$g(^TEMPDHCWL("S",$j,docid,phcdf,"Qty"))  
    ...s price=$g(^TEMPDHCWL("S",$j,docid,phcdf,"Fee")) 
    ...d OutPutRow18DOCYP
    
	k ^TEMPDHCWL("S",$j),^TEMPDHCWL("Fee",$j)
	Quit $$$OK
OutPutRow18
    
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge18(birth,+$h)
    s age=$p(age,"Y",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18YP
   
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow18DOCYP
    

    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,sex,age,PrescNo,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitData18(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge18(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
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

ClassMethod GetDepDocPressMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPressMX(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, base As %String, pattype As %String, prcnt As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}

*/

// 出院患者药品费用信息GetZyLocRcMx

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeXX1","2012-12-01","2012-12-01","","","GetZyLocRcMx","D","","","334","","yp","ALL")

/*ClassMethod GetPatYPFeeXX1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %String, hospid As %String, flag As %String, kjflag As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
    s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
 	q:monIdStr="" 1
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1

    d SplitMulitData177(dept,,.deptData)
	d SplitMulitData177(doc,,.docData)
	d SplitMulitData177(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData177(hospid,,.hospidData)
	d SplitMulitData177(drgId,,.drgIdData)
	
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",1)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	...s dimIdDoc=$p(dimId,",",2) 
	...//判断医师是否为所选医师
	...q:(doc'="")&&(dimIdDoc="") 
	...q:(doc'="")&&('$d(docData(dimIdDoc)))
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s ADMRowID=$p(dimId,",",3)
	...q:ADMRowID="" 
	...s diagcode=$p(dimId,",",4) i diagcode="" s diagcode="999999"
    ...s diagdesc=$p(dimId,",",5) i diagdesc="" s diagdesc="Null"
    ...//判断诊断是否包含所选诊断
	...q:(diag'="")&&(diagdesc="") 
	...q:(diag'="")&&(diagdesc'[diag)
	...s WLRowid=0,qty=0,Fee=0
	...f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
	....s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    ....q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    ....s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    ....s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ....s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项 ;2013-04-24
	....s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)  ;q:phcdf'=334 ;2013-04-24
    ....//判断是否为所选药品项目
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf="")   ;2013-04-24
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf)))  ;2013-04-24
	....s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ....;s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty"))+qty
    ....;s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee"))+Fee
    ....;s oeordId=$p(oeori,"||",1)
    ....;s oeoriSub=$p(oeori,"||",2)
  	....;s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
 	....;s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
 	....;q:((ststat'=1) && (ststat'=6))
	....;s ^TEMPDHCWL1($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,ADMRowID,sttDate,"yyts")=1
    ....i kjflag="ALL" d
    .....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee"))+Fee
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,"CFJE"))+Fee
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee"))+Fee
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Fee"))+Fee
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimIdDoc,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimIdDoc,"docJE"))+Fee
    ....i kjflag="KJYW" d
    .....s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项
	.....s phcdf1=$$GetPHCDFByarcim^DHCWLBuildKPICommon(arcim)
    .....q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	.....s qty1=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty1=0 ;收费项目数量 
    .....s Fee1=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee"))+Fee1
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimIdLoc,dimIdDoc,diagcode,diagdesc,"CFJE"))+Fee1
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee"))+Fee1
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",dimIdDoc,itm,"Fee"))+Fee1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",dimIdDoc,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",dimIdDoc,"docJE"))+Fee1

    i flag="1" d
    .s totalprice=0  
    .s loc="" f  s loc=$o(^TEMPDHCWL($j,"DHCWLLXC",loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid))  q:docid=""  d
    ...s diagco="" f  s diagco=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco))  q:diagco=""  d
    ....s diagna="" f  s diagna=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco,diagna))  q:diagna=""  d
    .....s adm="" f  s adm=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco,diagna,adm))  q:adm=""  d
    ......s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco,diagna,adm,phcdf))  q:phcdf=""  d
    .......s count=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco,diagna,adm,phcdf,"Qty"))  
    .......s price=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,diagco,diagna,adm,phcdf,"Fee")) 
    .......d OutPutRow177
    
    i flag="yp" d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Fee")) 
    ..d OutPutRow177YP
    
    i flag="docyp" d
    .s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",docid))  q:docid=""  d
    ..s totalprice=$g(^TEMPDHCWL1($j,"DHCWLLXC",docid,"docJE"))
    ..s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf))  q:phcdf=""  d
    ...s count=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Qty"))  
    ...s price=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Fee")) 
    ...d OutPutRow177DOCYP
    
	k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
	Quit $$$OK
OutPutRow177
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s admtype=$p(^PAADM(adm),"^",2)
    s papmiNo=$$GetPapmiNo^DHCWLCommon(papmidr)   //登记号  2013-04-13  zyb  add
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge177(birth,+$h)
    s age=$p(age,"Y",1)
    
    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow177YP

    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    S (loc,dimDesc,docid,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow177DOCYP
 
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitData177(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
CalAge177(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}


ClassMethod GetPatYPFeeXX1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeXX1Execute ]
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

ClassMethod GetPatYPFeeXX1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeXX1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatYPFeeXX1(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %String, hospid As %String, flag As %String, kjflag As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,papmiNo:%String,sex:%String,age:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}
*/

// 阳光用药【出院科室医师患者诊断】调用指标标准Query  GetZyLocRcMx 

// 取实时指标数据  2014-11-3  zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeXX1","2012-12-01","2012-12-01","","","GetZyLocRcMx","D","","","","","yp","ALL")

/// 2014-12-08query屏蔽备份，zl
ClassMethod GetPatYPFeeXX1Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag,choiceType,isRealData)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	s kpiCodeStrZb="GetZyLocRcMx"
	s choiceType="C"
	s isRealData="R"
	k ^TEMPDHCWL($j,"YGYY"),^TEMPDHCWL($j,"YGYYDOC")
	
    d SplitMulitDataYGYY(dept,,.deptData)
	d SplitMulitDataYGYY(doc,,.docData)
	d SplitMulitDataYGYY(kpiCodeStrZb,,.kpiCodeStrZbData)
	d SplitMulitDataYGYY(hospid,,.hospidData)
	d SplitMulitDataYGYY(drgId,,.drgIdData)
		  
	set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	set sc=rs.Execute(kpiCodeStrZb,startDate,endDate,choiceType,isRealData)
	
	While rs.Next(.sc) {
		s dimId=$g(rs.Data("dimId"))
		s dimdesc=$g(rs.Data("dimDesc")) 
		s kpiId=$g(rs.Data("kpiId"))
		s kpiCode=$g(rs.Data("kpiCode"))
		s value=$g(rs.Data("value"))
		s dimIdLoc=$p(dimId,",",1)
		//判断科室是否为所选科室
	 	continue:(dept'="")&&(dimIdLoc="") 
		continue:(dept'="")&&('$d(deptData(dimIdLoc)))
		//判断医院是否为所选医院
		s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
		i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
		continue:(hospid'="")&&(hosp="") 
		continue:(hospid'="")&&('$d(hospidData(hosp)))
		i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
   		i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
		s dimIdDoc=$p(dimId,",",2) 
		//判断医师是否为所选医师
		continue:(doc'="")&&(dimIdDoc="") 
		continue:(doc'="")&&('$d(docData(dimIdDoc)))
		s ADMRowID=$p(dimId,",",3)
	continue:ADMRowID="" 
		s diagcode=$p(dimId,",",4) i diagcode="" s diagcode="999999"
   		s diagdesc=$p(dimId,",",5) i diagdesc="" s diagdesc="Null"
   		//判断诊断是否包含所选诊断
		continue:(diag'="")&&(diagdesc="") 
		continue:(diag'="")&&(diagdesc'[diag)
		s WLRowid=0,qty=0,Fee=0
		f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
		.s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    	.q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    	.s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    	.s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    	.s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项 ;2013-04-24
		.s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)  ;q:phcdf'=334 ;2013-04-24
		.;s itm=+phcdf
    	.//判断是否为所选药品项目
		.q:((drgId'="") && (drgId'="null"))&&(+phcdf="")   ;2013-04-24
		.q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf)))  ;2013-04-24
		.s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    	.s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
     	.i kjflag="ALL" d
   		..i flag="1" d
    	...s ^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty"))+qty
    	...s ^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee"))+Fee
    	..i flag="yp" d
    	...s ^TEMPDHCWL($j,"YGYY",itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",itm,"Qty"))+qty
    	...s ^TEMPDHCWL($j,"YGYY",itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",itm,"Fee"))+Fee
    	..i flag="docyp" d
    	...s ^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Qty"))+qty
    	...s ^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Fee"))+Fee
    	...s ^TEMPDHCWL($j,"YGYYDOC",dimIdDoc,"docJE")=$g(^TEMPDHCWL($j,"YGYYDOC",dimIdDoc,"docJE"))+Fee
    	
    	.i kjflag="KJYW" d
    	..s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项
		..s phcdf1=$$GetPHCDFByarcim^DHCWLBuildKPICommon(arcim)
    	..q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
		..s qty1=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty1=0 ;收费项目数量 
    	..s Fee1=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    	..i flag="1" d
    	...s ^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Qty"))+qty1
    	...s ^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",dimIdLoc,dimIdDoc,diagcode,diagdesc,ADMRowID,itm,"Fee"))+Fee1
    	..i flag="yp" d
    	...s ^TEMPDHCWL($j,"YGYY",itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",itm,"Qty"))+qty1
    	...s ^TEMPDHCWL($j,"YGYY",itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",itm,"Fee"))+Fee1
    	..i flag="docyp" d
    	...s ^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Qty"))+qty1
    	...s ^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"YGYY",dimIdDoc,itm,"Fee"))+Fee1
    	...s ^TEMPDHCWL($j,"YGYYDOC",dimIdDoc,"docJE")=$g(^TEMPDHCWL($j,"YGYYDOC",dimIdDoc,"docJE"))+Fee1
	}
    	i flag="1" d
    	.s totalprice=0  
    	.s loc="" f  s loc=$o(^TEMPDHCWL($j,"YGYY",loc))  q:loc=""  d
    	..s docid="" f  s docid=$o(^TEMPDHCWL($j,"YGYY",loc,docid))  q:docid=""  d
    	...s diagco="" f  s diagco=$o(^TEMPDHCWL($j,"YGYY",loc,docid,diagco))  q:diagco=""  d
    	....s diagna="" f  s diagna=$o(^TEMPDHCWL($j,"YGYY",loc,docid,diagco,diagna))  q:diagna=""  d
    	.....s adm="" f  s adm=$o(^TEMPDHCWL($j,"YGYY",loc,docid,diagco,diagna,adm))  q:adm=""  d
    	......s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"YGYY",loc,docid,diagco,diagna,adm,phcdf))  q:phcdf=""  d
    	.......s count=$g(^TEMPDHCWL($j,"YGYY",loc,docid,diagco,diagna,adm,phcdf,"Qty"))  
    	.......s price=$g(^TEMPDHCWL($j,"YGYY",loc,docid,diagco,diagna,adm,phcdf,"Fee")) 
    	.......d OutPutRowYGYY1

    	i flag="yp" d
    	.s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"YGYY",phcdf))  q:phcdf=""  d
    	..s count=$g(^TEMPDHCWL($j,"YGYY",phcdf,"Qty"))  
    	..s price=$g(^TEMPDHCWL($j,"YGYY",phcdf,"Fee")) 
    	..d OutPutRowYGYY2
    
    	i flag="docyp" d
    	.s docid="" f  s docid=$o(^TEMPDHCWL($j,"YGYY",docid))  q:docid=""  d
    	..s totalprice=$g(^TEMPDHCWL($j,"YGYYDOC",docid,"docJE"))
    	..s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"YGYY",docid,phcdf))  q:phcdf=""  d
    	...s count=$g(^TEMPDHCWL($j,"YGYY",docid,phcdf,"Qty"))  
    	...s price=$g(^TEMPDHCWL($j,"YGYY",docid,phcdf,"Fee")) 
    	...d OutPutRowYGYY3
    	
    	k ^TEMPDHCWL($j,"YGYY"),^TEMPDHCWL($j,"YGYYDOC")

	
		Quit $$$OK

	
OutPutRowYGYY1
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s admtype=$p(^PAADM(adm),"^",2)
    s papmiNo=$$GetPapmiNo^DHCWLCommon(papmidr)   //登记号  2013-04-13  zyb  add
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAgeYGYY(birth,+$h)
    s age=$p(age,"Y",1)

    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)

	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

OutPutRowYGYY2

    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
 
    S (loc,dimDesc,docid,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRowYGYY3
 
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"

    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
  
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitDataYGYY(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
CalAgeYGYY(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
    . s AgeMth=AgeMth-1
	. s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	. q:XToday'=2
	. s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
	s Data=$lb(date,dimid,dim,kpiPos,value) ;data1,data2,data3,data4,data5,data6,data7,data8,data9)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetPatYPFeeXX1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeXX1Execute ]
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

ClassMethod GetPatYPFeeXX1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeXX1Execute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatYPFeeXX1(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,papmiNo:%String,sex:%String,age:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}

// 药物消耗统计排名分析

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDrugXhTJFX","2012-12-01","2012-12-01","","","","","MzywXhQty,MzywXhe,ZyywXhQty,ZyywXhe,MzKjywXhQty,MzKjywXhe,MzKjywXhDDD,ZyKjywXhQty,ZyKjywXhe,ZyKjywXhDDD","D","","drug","KJYW")

ClassMethod GetDrugXhTJFXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String, doc As %String, drug As %String, gzfl As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String, kjflag As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,drug,gzfl,kpiCodeStrZb,type,hospid,flag1,kjflag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:type="" $$$OK
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
	s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
 	q:monIdStr="" 1
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)  ;,.data) 2012-12-19 lxc
	q:sc'=1 1
	d SplitMulitData19(dept,,.deptData)
	d SplitMulitData19(doc,,.docData)
	d SplitMulitData19(drug,,.drugData)
	d SplitMulitData19(gzfl,,.gzflData)
	d SplitMulitData19(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData19(hospid,,.hospidData)
   
	s monId="",value=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="",value=0,valueXy=0
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimIdnod=0
	..f  s dimIdnod=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod)) q:dimIdnod=""  d
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimIdnod)) 
    ...s dimId=$p(dimIdnod,",",1)
    ...s pattype=$p(dimIdnod,",",2)
    ...s docId=$p(dimIdnod,",",3)
    ...s drugid=$p(dimIdnod,",",6) 
    ...;s ylfl=$p(dimIdnod,",",5) 
    ...s gzflId=$p(dimIdnod,",",4)
    ...//判断科室是否为所选科室
	...q:(dept'="")&&(dimId="") 
	...q:(dept'="")&&('$d(deptData(dimId)))
	...//判断管制分类是否为所选分类
	...q:(gzfl'="")&&(gzflId="") 
	...q:(gzfl'="")&&('$d(gzflData(gzflId)))
	...//判断医生是否为所选医生
	...q:(doc'="")&&(docId="") 
	...q:(doc'="")&&('$d(docData(docId)))
	...//判断药品是否为所选药品
	...q:(drug'="")&&(drugid="") 
	...q:(drug'="")&&('$d(drugData(drugid)))
    ...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimId)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	...i kjflag="ALL" d 
	....i (flag1="drug") d
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe")  s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzywXhe"))+value //门诊药品消耗金额	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzywXhQty"))+value //门诊药品消耗数量 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhe") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyywXhe"))+value //住院药品消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyywXhQty"))+value //住院药品消耗数量
	....i (flag1="docdep") d     //zyb   add
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzywXhQty"))+value //门诊药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzywXhe"))+value //门诊药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyywXhQty"))+value //住院药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyywXhe"))+value //住院药物消耗金额
	....i (flag1="dep") d     //lxc 2013-05-09  add
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzywXhQty"))+value //门诊药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzywXhe"))+value //门诊药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyywXhQty"))+value //住院药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyywXhe"))+value //住院药物消耗金额
    ....i (flag1="doc") d
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",docId,"MzywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"MzywXhQty"))+value //门诊消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,"MzywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"MzywXhe"))+value //门诊消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",docId,"ZyywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"ZyywXhQty"))+value //住院消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,"ZyywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"ZyywXhe"))+value //住院消耗金额
	...i kjflag="KJYW" d 
	....i (flag1="drug") d
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",gzflId,drugid,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
	....i (flag1="mzdep") d
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
	....i (flag1="zydep") d
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....;i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
	....i (flag1="dep") d   ;lxc 2013-05-09 add
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
	....i (flag1="doc") d
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
	....i (flag1="docdep") d           //zyb     add
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",docId,dimId,drugid,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
    ;....i (flag1="gzfl") d
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhQty")  s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhQty"))+value //门诊抗菌药物消耗数量	
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhe"))+value //门诊抗菌药物消耗金额 
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="MzKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"MzKjywXhDDD"))+value //门诊抗菌药物消耗DDD
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhQty") s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhQty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhQty"))+value //住院抗菌药物消耗数量
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhe") s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhe")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhe"))+value //住院抗菌药物消耗金额
	;.....i ($li(^DHCWL.MKPI.MKPID(kpiId),2)="ZyKjywXhDDD") s ^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhDDD")=$g(^TEMPDHCWL($j,"DHCWLXC",dimId,docId,gzflId,drugid,"ZyKjywXhDDD"))+value //住院抗菌药物消耗DDD
      
	i kjflag="ALL" d 
	.i (flag1="drug") d
	..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0   
    ..s gzfli="" f  s gzfli=$o(^TEMPDHCWL($j,"DHCWLXC",gzfli)) q:gzfli=""  d
    ...s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim)) q:dim=""  d
    ....s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"MzywXhQty"))
    ....s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"MzywXhe")) 
    ....s mzddd=0
    ....s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"ZyywXhQty"))
    ....s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"ZyywXhe")) 
    ....s zyddd=0
    ....s qyqty=mzqty+zyqty
    ....s qyje=mzje+zyje
    ....s qyddd=0
    ....d OutPutRow19
    .i ((flag1="dep") || (flag1="doc")) d	    //lxc 2013-05-09 add
    ..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0
    ..s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",dim)) q:dim=""  d
    ...s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzywXhQty"))
    ...s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzywXhe"))
    ...s mzddd=0
    ...s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"ZyywXhQty"))
    ...s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"ZyywXhe"))
    ...s zyddd=0
    ...s qyqty=mzqty+zyqty
    ...s qyje=mzje+zyje
    ...s qyddd=0
    ...d OutPutRow19
    .i (flag1="docdep")  d	    //zyb    add
    ..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0
    ..s doci="" f  s doci=$o(^TEMPDHCWL($j,"DHCWLXC",doci)) q:doci=""  d
    ...s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",doci,dim)) q:dim=""  d
    ....s drugi="" f  s drugi=$o(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi)) q:drugi=""  d
    .....s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"MzywXhQty"))
    .....s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"MzywXhe"))
    .....s mzddd=0
    .....s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"ZyywXhQty"))
    .....s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"ZyywXhe"))
    .....s zyddd=0
    .....s qyqty=mzqty+zyqty
    .....s qyje=mzje+zyje
    .....s qyddd=0
    .....d OutPutRow19
           
    i kjflag="KJYW" d    
    .i (flag1="drug") d
    ..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0
    ..s gzfli="" f  s gzfli=$o(^TEMPDHCWL($j,"DHCWLXC",gzfli)) q:gzfli=""  d
    ...s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim)) q:dim=""  d
    ....s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"MzKjywXhQty"))
    ....s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"MzKjywXhe"))
    ....s mzddd=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"MzKjywXhDDD"))
    ....s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"ZyKjywXhQty"))
    ....s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"ZyKjywXhe"))
    ....s zyddd=$g(^TEMPDHCWL($j,"DHCWLXC",gzfli,dim,"ZyKjywXhDDD"))
    ....s qyqty=mzqty+zyqty
    ....s qyje=mzje+zyje
    ....s qyddd=mzddd+zyddd
    ....d OutPutRow19
    .e  i (flag1="docdep")  d	//zyb       add  "drugi"
    ..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0
    ..s doci="" f  s doci=$o(^TEMPDHCWL($j,"DHCWLXC",doci)) q:doci=""  d
    ...s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",doci,dim)) q:dim=""  d
    ....s drugi="" f  s drugi=$o(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi)) q:drugi=""  d
    .....s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"MzKjywXhQty"))
    .....s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"MzKjywXhe"))
    .....s mzddd=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"MzKjywXhDDD"))
    .....s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"ZyKjywXhQty"))
    .....s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"ZyKjywXhe"))
    .....s zyddd=$g(^TEMPDHCWL($j,"DHCWLXC",doci,dim,drugi,"ZyKjywXhDDD"))
    .....s qyqty=mzqty+zyqty
    .....s qyje=mzje+zyje
    .....s qyddd=mzddd+zyddd
    .....d OutPutRow19
    .e  d
    ..s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0
    ..s dim="" f  s dim=$o(^TEMPDHCWL($j,"DHCWLXC",dim)) q:dim=""  d
    ...s mzqty=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzKjywXhQty"))
    ...s mzje=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzKjywXhe"))
    ...s mzddd=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"MzKjywXhDDD"))
    ...s zyqty=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"ZyKjywXhQty"))
    ...s zyje=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"ZyKjywXhe"))
    ...s zyddd=$g(^TEMPDHCWL($j,"DHCWLXC",dim,"ZyKjywXhDDD"))
    ...s qyqty=mzqty+zyqty
    ...s qyje=mzje+zyje
    ...s qyddd=mzddd+zyddd
    ...d OutPutRow19
              
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
	Quit $$$OK
OutPutRow19
    i (flag1="drug") d 
    .s docrowid="",doccode="",docname="",gzfldesc=""
    .s drugy=dim
    .s gzflId=gzfli
    .i $d(^PHCPO(gzflId))  s gzfldesc=$P(^PHCPO(gzflId),"^",2)   //add  zyb
    .s drugDesc=$p(^PHCD(dim,1),"^",2)   
	.s UnitDR=$p(^PHCD(dim,"DF",1,2),"^",4) 
	.i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    .s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(dim_"||1")
    .s VenD=$$Intfacegys^DHCWLBuildKPICommon(dim_"||1")
    .s gys=$p(VenD,"^",1),scs=$p(VenD,"^",2)
    .;药理子分类
    .s subcat=$p(^PHCD(dim,1),"^",3)   
    .s child=$p(subcat,"||",2) q:child="" 
    .q:'$d(^PHCC(+subcat,"SC",child))
    .s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
       
    i ((flag1="mzdep") || (flag1="zydep") || (flag1="dep")) d 
    .s docrowid="",doccode="",docname="",drugy="",drugDesc="",unitdesc="",Guig="",subcatna=""
    .s loc=dim
    .i $d(^CTLOC(loc))  d  
    ..s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    ..i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    ..e  s deptna=dimDesc1
    
    i (flag1="doc") d 
    .s drugy="",drugDesc="",unitdesc="",Guig="",subcatna=""
    .s docrowid=dim
    .i ($d(^CTPCP(docrowid))) s doccode=$p(^CTPCP(docrowid,1),"^",1),docname=$p(^CTPCP(docrowid,1),"^",2)
    .e  s doccode="Null",docname="Null"
    
    i (flag1="docdep") d 
    .s drugy="",drugDesc="",unitdesc="",Guig="",subcatna=""
    .s loc=dim
    .i $d(^CTLOC(loc))  d  
    ..s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    ..i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    ..e  s deptna=dimDesc1
    .s docrowid=doci
    .i ($d(^CTPCP(docrowid))) s doccode=$p(^CTPCP(docrowid,1),"^",1),docname=$p(^CTPCP(docrowid,1),"^",2)
    .e  s doccode="Null",docname="Null"
    .s drugy=drugi	//zyb	add
    .s drugDesc=$p(^PHCD(drugi,1),"^",2)     	//zyb	add
    
    ;i (flag1="gzfl") d 
    ;.s docrowid="",doccode="",docname="",drugy="",drugDesc="",unitdesc="",Guig=""
    ;.s subcat=dim
    ;.;药理子分类
    ;.s child=$p(subcat,"||",2) q:child="" 
    ;.q:'$d(^PHCC(+subcat,"SC",child))
    ;.s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
         
	s Data=$lb(loc,deptna,docrowid,doccode,docname,drugy,drugDesc,gzfldesc,unitdesc,Guig,gys,scs,subcatna,mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData19(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDrugXhTJFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugXhTJFXExecute ]
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

ClassMethod GetDrugXhTJFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugXhTJFXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDrugXhTJFX(startDate As %String, endDate As %String, dept As %String, doc As %String, drug As %String, gzfl As %String, kpiCodeStrZb As %Text, type As %String, hospid As %String, flag1 As %String, kjflag As %String) As %Query(ROWSPEC = "loc:%String,deptna:%String,docrowid:%String,doccode:%String,docname:%String,drugy:%String,drugDesc:%String,gzfldesc:%String,unitdesc:%String,Guig:%String,gys:%String,scs:%String,subcatna:%String,mzqty:%Float,mzje:%Float,mzddd:%Float,zyqty:%Float,zyje:%Float,zyddd:%Float,qyqty:%Float,qyje:%Float,qyddd:%Float") [ SqlProc ]
{
}

// 药品加成比例排名

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetItmList","","","BASE")

ClassMethod GetItmListExecute(ByRef qHandle As %Binary, CatGrp As %String, HospID As %String, flag As %String) As %Status
{
	n (qHandle,CatGrp,HospID,flag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    d SplitMulitData20(flag,,.flagData)
    q:CatGrp="" $$$OK
    k ^TEMPDHCWL($j,"DHCWLXC","GetItmList")
	s incID="0",i=0
	f  s incID=$o(^INCI(incID)) q:+incID=0  d
	.S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(incID)
	.s CatGrpDesc=$p(CatGrpStr,"^",2)
	.q:(CatGrp'="")&(CatGrpDesc'[CatGrp)
	.s Base=$$Intfacegysbyinci^DHCWLBuildKPICommon(incID)
	.//判断类型是否为所选类型
	.q:(flag'="")&&(Base="") 
	.q:(flag'="")&&('$d(flagData(Base)))
	.s incCode=$p(^INCI(incID,1),"^",1)
	.s incDesc=$p(^INCI(incID,1),"^",2)
	.s puomID=$p(^INCI(incID,3),"^",6)
	.s buomID=$p(^INCI(incID,1),"^",10)
	.s Spec=##Class(web.DHCSTCOMINC).GetSpec(incID)
	.s Rp=0
	.s Rp=+##Class(web.DHCSTPRICE).GetInciBasicRp(incID,+$h,puomID,HospID) //入库单位的进价
	.i Rp=0 d
	..s Rp=##Class(web.DHCSTPRICE).GetInciLastRp(incID,puomID,HospID)
	.s Sp=##Class(web.DHCSTCOMMONSRV).GetPriceElse(incID,+$h,puomID,HospID)
	.s marg=""
	.i Rp'=0 d
	..s marg=Sp/Rp
	.s i=i+1
	.s ^TEMPDHCWL($j,"DHCWLXC","GetItmList",i)=Base_"^"_incCode_"^"_incDesc_"^"_Spec_"^"_Rp_"^"_Sp_"^"_marg
	
	s num=0 f  s num=$o(^TEMPDHCWL($j,"DHCWLXC","GetItmList",num)) q:num=""  d
    .s outdata=$g(^TEMPDHCWL($j,"DHCWLXC","GetItmList",num))
    .s BaseDrg=$p(outdata,"^",1)
    .s code=$p(outdata,"^",2)
    .s desc=$p(outdata,"^",3)
    .s guig=$p(outdata,"^",4)
    .s cbj=$p(outdata,"^",5) q:cbj=0
    .s sj=$p(outdata,"^",6) q:sj=0
    .s jc=$p(outdata,"^",7)
    .d OutPutRow20
    k ^TEMPDHCWL($j,"DHCWLXC","GetItmList")
	
	Quit $$$OK
OutPutRow20
    
	s Data=$lb(BaseDrg,code,desc,guig,cbj,sj,jc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
SplitMulitData20(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmListExecute ]
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

ClassMethod GetItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItmList(CatGrp As %String, HospID As %String, flag As %String) As %Query(ROWSPEC = "BaseDrg:%String,code:%String,desc:%String,guig:%String,cbj:%Float,sj:%Float,jc:%Float") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetBaseDrugXh","2012","","","ZyywXhe,ZyywXhQty","","1","")

/// Creator：      lxc
/// CreatDate：    2013-03-11	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析(基本药物消耗用)
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// 维度：科室_","_门诊/住院_","_医师_","_管制分类_","_药理子分类_","_药物_","_抗菌标志_","_基本药物标志_","_注射剂标志
/// 基本药物标志:1-国家基本药物;2-省基本药物;3-非基本药物;-1为非药品
/// Return：  
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetBaseDrugXh(year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,Basetype:%String,dimId:%String,dimDesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

ClassMethod GetBaseDrugXhExecute(ByRef qHandle As %Binary, year As %String, mon As %String, dept As %Text, kpiCodeStrZb As %Text, type As %String, rptID As %String, hospid As %String) As %Status
{
	n (qHandle,year,mon,dept,kpiCodeStrZb,type,rptID,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:year="" $$$OK
	q:rptID="" $$$OK
	k ^TEMPDHCWL($j,"DHCWLlxc"),^Tempdata($j,"DHCWLXC")
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	;s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb) 
	q:sc'=1 1

    d SplitMulitData21(mon,,.monData)
	d SplitMulitData21(dept,,.deptData)
	d SplitMulitData21(type,,.typeData)
	d SplitMulitData21(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData21(hospid,,.hospidData)

	s monId=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.//判断科室是否为所选月份
	.q:(mon'="")&&(monId="") 
	.q:(mon'="")&&('$d(monData(monId)))
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId=0  //维度：科室_","_门诊/住院_","_医师_","_管制分类_","_药理子分类_","_药物_","_抗菌标志_","_基本药物标志_","_注射剂标志  
	..f  s dimId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdtype=$p(dimId,",",2)
	...s dimIdLoc=$p(dimId,",",1) 
	...s dimIdBase=$p(dimId,",",8)   ;基本药物标志:1-国家基本药物;2-省基本药物;3-非基本药物;-1为非药品
	...;q:((dimIdBase'=1) && (dimIdBase'=2))
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId,dimIdLoc,dimIdBase)=$g(^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId,dimIdLoc,dimIdBase))+value

    i (rptID="1") d
   	.s monId=0 f  s monId=$o(^TEMPDHCWL($j,"DHCWLlxc",monId)) q:monId=""  d
    ..s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId)) q:kpiId=""  d
    ...s dimIdLoc=0 f  s dimIdLoc=$o(^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId,dimIdLoc)) q:dimIdLoc=""  d
    ....s Basetype=0 f  s Basetype=$o(^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId,dimIdLoc,Basetype)) q:Basetype=""  d
    .....s outdata=$g(^TEMPDHCWL($j,"DHCWLlxc",monId,kpiId,dimIdLoc,Basetype)) 
	.....d OutPutRow21
	k ^TEMPDHCWL($j,"DHCWLlxc"),^Tempdata($j,"DHCWLXC")
	Quit $$$OK
OutPutRow21

	s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=$$GetDepDesc^DHCWLBuildDimData(dimIdLoc)
    
	s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,Basetype,dimIdLoc,dimDesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
SplitMulitData21(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetBaseDrugXhClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaseDrugXhExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetBaseDrugXhFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaseDrugXhExecute ]
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

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataYearFX","2012","CFZS,CFJE,CFYPZS,CFYyTs,KJYWCFZS,KJYWCFJE,KJYWCFPZ,KJCFYyTs")

/// Creator：      lxc
/// CreatDate：    2012-09-19	
/// Description:： 按照年度和指标查找值,做年度月份的指标分析-【通用查询格式】
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       year:年度,kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// 例：维度：处方类型（西药、成药、中草药）、处方科室、是否抗菌素处方、是否1类抗菌素处方、是否2类抗菌素处方、是否3类抗菌素处方、发药科室  
/// Return：  
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataYearFX(year As %String, kpiCodeStrZb As %Text) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetKPIDataYearFXExecute(ByRef qHandle As %Binary, year As %String, kpiCodeStrZb As %Text) As %Status
{
	n (qHandle,year,kpiCodeStrZb)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:year="" $$$OK
	k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	
 	s startDate=year_"-01"
	s endDate=year_"-12"
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)
	q:sc'=1 1

	d SplitMulitData22(kpiIdStrZb,,.kpiIdStrZbData)
	s monId=""
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId=0
	..f  s dimId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d  
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))+value
	 
    s monId=0 f  s monId=$o(^TEMPDHCWL($j,"DHCWLXC",monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
    ..s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
    ...s outdata=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) 
    ...d OutPutRow22
  
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
    	
	Quit $$$OK
OutPutRow22
    s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=""
    s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
SplitMulitData22(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataYearFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataYearFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataYearFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataYearFXExecute ]
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

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataSEDateFX","2013-03-01","2013-03-31","MRIPCYRSPatDepZyts,MRIPCYRSPatDepDocFee,MRIPCYRSPatDepDocYlFee,MRIPCYRSPatDepDocYpFee,MRIPCYRSPatDepDocKJYpFee,MRIPCYRSPatDepDocKJYpDDD,MRIPCYRSPatDepDocKJYpQty")

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetKPIDataSEDateFX","2013-04-01","2013-04-01","RegLocOpNums")

/// Creator：      lxc
/// CreatDate：    2013-04-01	
/// Description:： 按照某段期间和指标查找值,做指标分析-【通用查询格式】
/// Table：       DHCWL_MKPI.DHCWLDeptKPIData,DHCWL_MKPI.DHCWLMKPIData
/// Input：       kpiIdStr:指标id串,","分隔
/// Output：      monId:%String:区间id,monDesc:%String:区间描述,kpiId:%String:指标id,kpiDesc:%String:指标描述
/// 			  dimId:%String:维id,dimDesc:%String:维描述,value:%String:值
/// 例：维度：处方类型（西药、成药、中草药）、处方科室、是否抗菌素处方、是否1类抗菌素处方、是否2类抗菌素处方、是否3类抗菌素处方、发药科室  
/// Return：  
/// Others：      按照区间和指标查找值,按照区间,指标,维汇总
Query GetKPIDataSEDateFX(startDate As %String, endDate As %String, kpiCodeStrZb As %Text) As %Query(ROWSPEC = "monId:%Integer,modDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,outdata:%Float") [ SqlProc ]
{
}

ClassMethod GetKPIDataSEDateFXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, kpiCodeStrZb As %Text) As %Status
{
	n (qHandle,startDate,endDate,kpiCodeStrZb)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
	k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
	

 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
	q:monIdStr="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData1(monIdStr,kpiIdStrZb)
	
	q:sc'=1 1

	d SplitMulitData23(kpiIdStrZb,,.kpiIdStrZbData)
	s monId=0
	f  s monId=$o(^Tempdata($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId=""
	.f  s kpiId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId=0
	..f  s dimId=$o(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d  
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s value=+$g(^Tempdata($j,"DHCWLXC",monId,kpiId,dimId))
	...s ^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))+value
	 
    s monId=0 f  s monId=$o(^TEMPDHCWL($j,"DHCWLXC",monId)) q:monId=""  d
    .s kpiId=0 f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
    ..s dimId=0 f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
    ...s outdata=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) 
    ...d OutPutRow23
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^Tempdata($j,"DHCWLXC")
    	
	Quit $$$OK
OutPutRow23
    s modDesc=$li(^DHCWL.MKPI.MonthsD(monId),5)
    s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)
    s kpiDesc=$li(^DHCWL.MKPI.MKPID(kpiId),3)
    s dimDesc=""
    s Data=$lb(monId,modDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,outdata)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
SplitMulitData23(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetKPIDataSEDateFXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIDataSEDateFXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIDataSEDateFXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIDataSEDateFXExecute ]
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

// 抗菌药物在科指标使用统计

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatAntiDrugInfoDep","2013-04-01","2013-04-01","I","","3")	

// 注释：DHCWLAntiPatLoad.mac中取的值恰恰是“1类切口预防抗菌药物时间>24h"的，所以以下值为>24h的，剩下的由报表前端进行了处理！！lxc0813

ClassMethod GetPatAntiDrugInfoDepExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, pattype As %String, deptid As %String, Patdeptid As %String, hospid As %String) As %Status
{
	n (qHandle,SDate,EDate,pattype,deptid,Patdeptid,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:pattype="" $$$OK
    
    k ^TEMPDHCWL($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData24(deptid,,.deptidData)
	d SplitMulitData24(Patdeptid,,.PatdeptidData)
	d SplitMulitData24(hospid,,.hospidData)
	
	f DisDate=SDate:1:EDate d
	.s PADRowid="",ts=""
	.i pattype="I" d
	..f  s PADRowid=$o(^DHCWLPADDEPI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	...s admdr=$p(^DHCWLPADDEPI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADDEPI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADDEPI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADDEPI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADDEPI(PADRowid),"^",5)  ;出院科室
    ...//判断科室是否为所选出院科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130402add
    ...s AntiFlag=$p(^DHCWLPADDEPI(PADRowid),"^",9) ;抗菌药物使用标志
    ...s AntiDDD=$p(^DHCWLPADDEPI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADDEPI(PADRowid),"^",26) ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADDEPI(PADRowid),"^",27) ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADDEPI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADDEPI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADDEPI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADDEPI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
    
    ...s LimMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志
    ...s LimAntFlag=$p(^DHCWLPADDEPI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADDEPI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADDEPI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    ...s Patdept=$p(^DHCWLPADDEPI(PADRowid),"^",36)  ;转科科室
    ...s PatdeptDays=$p(^DHCWLPADDEPI(PADRowid),"^",37)  ;患者在转科科室在科天数
    ...//判断科室是否为所选科室
    ...q:(Patdeptid'="")&&(Patdept="")  ;20130313add
	...q:(Patdeptid'="")&&('$d(PatdeptidData(Patdept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(Patdept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)  
    ...s ^TEMPDHCWL($j,"总人数",Patdept)=$g(^TEMPDHCWL($j,"总人数",Patdept))+1
    ...i (AntiFlag="1")  s ^TEMPDHCWL($j,"抗菌药物使用",Patdept)=$g(^TEMPDHCWL($j,"抗菌药物使用",Patdept))+1
    ...i ((AntiFlag="1") && (SpAntFlag="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物",Patdept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物",Patdept))+1
    ...i ((AntiFlag="1") && (LimAntFlag="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物",Patdept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物",Patdept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpMedAnti="1"))  s ^TEMPDHCWL($j,"特殊使用抗菌药物治疗",Patdept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物治疗",Patdept))+1  ;2013-01-22 lxc add 
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimMedAnti="1"))  s ^TEMPDHCWL($j,"限制使用抗菌药物治疗",Patdept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物治疗",Patdept))+1 ;2013-01-22 lxc add 
    ...i (OperHealLeve="1") s ^TEMPDHCWL($j,"1类切口总",Patdept)=$g(^TEMPDHCWL($j,"1类切口总",Patdept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防",Patdept)=$g(^TEMPDHCWL($j,"1类切口预防",Patdept))+1
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperConTime="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",Patdept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间≤24h",Patdept))+1   ;2013-01-22 lxc xiugai 
    ...i ((AntiFlag="1") && (OperHealLeve="1") && (OperPre2h="1") && (+OperPreTime'=0)) s ^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",Patdept)=$g(^TEMPDHCWL($j,"1类切口预防抗菌药物时间在0.5-2h内",Patdept))+1 ;2013-01-22 lxc xiugai   
    ...i ((AntiFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"同期使用抗菌药物总例数",Patdept)=$g(^TEMPDHCWL($j,"同期使用抗菌药物总例数",Patdept))+1
    ...i ((AntiFlag="1") && (EtiExaFlag="1") && (IsMedAnti="1")) s ^TEMPDHCWL($j,"病原学检查送检例数",Patdept)=$g(^TEMPDHCWL($j,"病原学检查送检例数",Patdept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (SpAntFlag="1") && (EtiExaFlag="1") && (SpMedAnti="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",Patdept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物患者病原学检查送检例数",Patdept))+1
    ...i ((AntiFlag="1") && (IsMedAnti="1") && (LimAntFlag="1") && (EtiExaFlag="1") && (LimMedAnti="1")) s ^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",Patdept)=$g(^TEMPDHCWL($j,"限制使用抗菌药物患者病原学检查送检例数",Patdept))+1
    
    ...s ^TEMPDHCWL($j,"DDD",Patdept)=$g(^TEMPDHCWL($j,"DDD",Patdept))+AntiDDD
    ...i ((AntiFlag="1") && (SpAntFlag="1")) s ^TEMPDHCWL($j,"特殊使用抗菌药物DDD",Patdept)=$g(^TEMPDHCWL($j,"特殊使用抗菌药物DDD",Patdept))+SpAntDDD
    ...s ^TEMPDHCWL($j,"人天数",Patdept)=$g(^TEMPDHCWL($j,"人天数",Patdept))+PatdeptDays

    s type=0 f  s type=$o(^TEMPDHCWL($j,type)) q:type=""  d
    .s Patdept=0 f  s Patdept=$o(^TEMPDHCWL($j,type,Patdept)) q:Patdept=""  d
    ..s outdata=$g(^TEMPDHCWL($j,type,Patdept)) 
    ..d OutputRow24
    
    k ^TEMPDHCWL($j)
 	q $$$OK	
OutputRow24
    i $d(^CTLOC(Patdept)) d
    .s hos=$P($G(^CTLOC(Patdept)),"^",22)
    .s patdesc1=$p(^CTLOC(Patdept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    
    s Data=$lb(type,Patdept,patdesc,outdata,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
SplitMulitData24(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 	
	q
}

ClassMethod GetPatAntiDrugInfoDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoDepExecute ]
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

ClassMethod GetPatAntiDrugInfoDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfoDep(SDate As %String, EDate As %String, pattype As %String, deptid As %Text, Patdeptid As %Text, hospid As %String) As %Query(ROWSPEC = "type:%String,Patdept:%Integer,patdesc:%String,outdata:%Float,hospna:%String") [ SqlProc ]
{
}

// 抗菌药物在科指标明细统计调查表

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatAntiDrugInfoDepMX","2013-04-01","2013-04-01","I","","","")	

// 注释：DHCWLAntiPatLoad.mac中取的值恰恰是“1类切口预防抗菌药物时间>24h"的，所以以下值为>24h的，剩下的由报表前端进行了处理！！lxc0813

ClassMethod GetPatAntiDrugInfoDepMXExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, pattype As %String, deptid As %Text, Patdeptid As %Text, hospid As %String) As %Status
{
	n (qHandle,SDate,EDate,pattype,deptid,Patdeptid,hospid)  
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:pattype="" $$$OK
    
    k ^TEMPDHCWL($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData25(deptid,,.deptidData)
	d SplitMulitData25(Patdeptid,,.PatdeptidData)
	d SplitMulitData25(hospid,,.hospidData)
	;d SplitTypeData(type)    ;20130412
	;s antiflag=$p(ret,"^",1)  ;20130412
	f DisDate=SDate:1:EDate d
	.s PADRowid="",ts=""
	.i pattype="I" d
	..f  s PADRowid=$o(^DHCWLPADDEPI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	...s admdr=$p(^DHCWLPADDEPI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADDEPI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADDEPI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADDEPI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADDEPI(PADRowid),"^",5)  ;出院科室
    ...//判断科室是否为所选出院科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130402add
    ...s AntiFlag=$p(^DHCWLPADDEPI(PADRowid),"^",9) ;抗菌药物使用标志
    ...//判断是否抗菌药物使用标志
    ...;q:(antiflag'="")&&(antiflag'=AntiFlag)  ;20130412
    ...s AntiDDD=$p(^DHCWLPADDEPI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADDEPI(PADRowid),"^",26) ;q:OperHealLeve'=1  ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADDEPI(PADRowid),"^",27) ;q:OperPreTime'=1 ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADDEPI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADDEPI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADDEPI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADDEPI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
 
    ...s LimMedAnti=$p(^DHCWLPADDEPI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志   
    ...s LimAntFlag=$p(^DHCWLPADDEPI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADDEPI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADDEPI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    ...s Patdept=$p(^DHCWLPADDEPI(PADRowid),"^",36)  ;转科科室
    ...s PatdeptDays=$p(^DHCWLPADDEPI(PADRowid),"^",37)  ;患者在转科科室在科天数
    ...//判断科室是否为所选科室
    ...q:(Patdeptid'="")&&(Patdept="")  ;20130313add
	...q:(Patdeptid'="")&&('$d(PatdeptidData(Patdept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(Patdept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2) 
    ...d OutputRow25
 
    k ^TEMPDHCWL($j)
 	q $$$OK	
OutputRow25
    s Papmi=$p(^PAADM(admdr),"^",1)
    s zyh=$$GetPapmiMedtare^DHCWLCommon(Papmi) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    s admreason=$$GetReason^DHCWLCommon(admdr) //病人类型
    s name=$$GetPapmiName^DHCWLCommon(Papmi)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    s ryrq=$zd(admdate,3),cyrq=$zd(DisDate,3)
    
    i $d(^CTLOC(dept)) d
    .s desc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i desc1 [ "-" s desc=$p(desc1,"-",2)
    .e  s desc=desc1
    
    i $d(^CTLOC(Patdept)) d
    .s patdesc1=$p(^CTLOC(Patdept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    
    s Data=$lb(admdr,zyh,name,sex,ryrq,cyrq,dept,desc,AntiFlag,AntiDDD,OperHealLeve,OperPreTime,OperConTime,EtiExaFlag,IsMedAnti,SpMedAnti,SpAntFlag,SpAntDDD,LimMedAnti,LimAntFlag,LimAntDDD,OperPre2h,Patdept,patdesc,PatdeptDays,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
SplitMulitData25(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
	q
}

ClassMethod GetPatAntiDrugInfoDepMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoDepMXExecute ]
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

ClassMethod GetPatAntiDrugInfoDepMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoDepMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfoDepMX(SDate As %String, EDate As %String, pattype As %String, deptid As %Text, Patdeptid As %Text, hospid As %String) As %Query(ROWSPEC = "admdr:%String,zyh:%String,name:%String,sex:%String,ryrq:%String,cyrq:%String,dept:%String,desc:%String,AntiFlag:%String,AntiDDD:%Float,OperHealLeve:%String,OperPreTime:%String,OperConTime:%String,EtiExaFlag:%String,IsMedAnti:%String,SpMedAnti:%String,SpAntFlag:%String,SpAntDDD:%Float,LimMedAnti:%String,LimAntFlag:%String,LimAntDDD:%Float,OperPre2h:%String,Patdept:%String,patdesc:%String,PatdeptDays:%Float,hospna:%String") [ SqlProc ]
{
}

// 抗菌药物在科指标明细统计调查表(无转科科室的情况)    20130413     ^DHCWLPADI    GetPatAntiDrugInfoMX

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatAntiDrugInfoMX","2012-12-01","2013-04-01","I","","")	

// 注释：DHCWLAntiPatLoad.mac中取的值恰恰是“1类切口预防抗菌药物时间>24h"的，所以以下值为>24h的，剩下的由报表前端进行了处理！！lxc0813

ClassMethod GetPatAntiDrugInfoMXExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, pattype As %String, deptid As %Text, hospid As %String) As %Status
{
	n (qHandle,SDate,EDate,pattype,deptid,hospid)  
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 	q:pattype="" $$$OK
    
    k ^TEMPDHCWL($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData26(deptid,,.deptidData)
	;d SplitMulitData26(Patdeptid,,.PatdeptidData)
	d SplitMulitData26(hospid,,.hospidData)
	;d SplitTypeData(type)    ;20130412
	;s antiflag=$p(ret,"^",1)  ;20130412
	f DisDate=SDate:1:EDate d
	.s PADRowid="",ts=""
	.i pattype="I" d
	..f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	...s admdr=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
    ...s admtype=$p(^DHCWLPADI(PADRowid),"^",2)    ;类型
    ...q:$F(","_pattype_",",","_admtype_",")=0  
    ...s admdate=$p(^DHCWLPADI(PADRowid),"^",3)  ;入院日期
    ...;s disdate=$p(^DHCWLPADI(PADRowid),"^",4) ;出院日期
    ...s dept=$p(^DHCWLPADI(PADRowid),"^",5)  ;出院科室
    ...//判断科室是否为所选出院科室
    ...q:(deptid'="")&&(dept="")  ;20130313add
	...q:(deptid'="")&&('$d(deptidData(dept))) ;20130402add
    ...s AntiFlag=$p(^DHCWLPADI(PADRowid),"^",9) ;抗菌药物使用标志
    ...//判断是否抗菌药物使用标志
    ...;q:(antiflag'="")&&(antiflag'=AntiFlag)  ;20130412
    ...s AntiDDD=$p(^DHCWLPADI(PADRowid),"^",12)  ;抗菌药物总DDD值
    ...s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;q:OperHealLeve'=1  ;主手术切口愈合等级
    ...s OperPreTime=$p(^DHCWLPADI(PADRowid),"^",27) ;q:OperPreTime'=1 ;术前预防使用抗菌药物时间
    ...s OperConTime=$p(^DHCWLPADI(PADRowid),"^",28) ;手术预防使用抗菌药物持续时间
    ...s EtiExaFlag=$p(^DHCWLPADI(PADRowid),"^",29) ;病原学检查标志
    ...s IsMedAnti=$p(^DHCWLPADI(PADRowid),"^",30)  ;基本治疗使用标志
    
    ...s SpMedAnti=$p(^DHCWLPADI(PADRowid),"^",32)  ;特殊抗菌药物治疗使用标志
    ...s SpAntFlag=$p(^DHCWLPADI(PADRowid),"^",17)  ;特殊抗菌药物使用标志
    ...s SpAntDDD=$p(^DHCWLPADI(PADRowid),"^",20)  ;特殊抗菌药物总DDD值
 
    ...s LimMedAnti=$p(^DHCWLPADI(PADRowid),"^",31)  ;限制抗菌药物治疗使用标志   
    ...s LimAntFlag=$p(^DHCWLPADI(PADRowid),"^",33)  ;限制抗菌药物使用标志
    ...s LimAntDDD=$p(^DHCWLPADI(PADRowid),"^",34)  ;限制抗菌药物总DDD值
    ...s OperPre2h=$p(^DHCWLPADI(PADRowid),"^",35)  ;I类切口手术预防使用抗菌药物在术前0.5-2h内给药
    ...;s Patdept=$p(^DHCWLPADI(PADRowid),"^",36)  ;转科科室
    ...;s PatdeptDays=$p(^DHCWLPADI(PADRowid),"^",37)  ;患者在转科科室在科天数
    ...//判断科室是否为所选科室
    ...;q:(Patdeptid'="")&&(Patdept="")  ;20130313add
	...;q:(Patdeptid'="")&&('$d(PatdeptidData(Patdept))) ;20130313add
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dept)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2) 
    ...d OutputRow26
 
    k ^TEMPDHCWL($j)
 	q $$$OK	
OutputRow26
    s Papmi=$p(^PAADM(admdr),"^",1)
    s zyh=$$GetPapmiMedtare^DHCWLCommon(Papmi) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    s admreason=$$GetReason^DHCWLCommon(admdr) //病人类型
    s name=$$GetPapmiName^DHCWLCommon(Papmi)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    s ryrq=$zd(admdate,3),cyrq=$zd(DisDate,3)
    
    i $d(^CTLOC(dept)) d
    .s desc1=$p(^CTLOC(dept),"^",2) ;病人科室desc
    .i desc1 [ "-" s desc=$p(desc1,"-",2)
    .e  s desc=desc1
    /*
    i $d(^CTLOC(Patdept)) d
    .s patdesc1=$p(^CTLOC(Patdept),"^",2) ;病人科室desc
    .i patdesc1 [ "-" s patdesc=$p(patdesc1,"-",2)
    .e  s patdesc=patdesc1
    */
    s Data=$lb(admdr,zyh,name,sex,ryrq,cyrq,dept,desc,AntiFlag,AntiDDD,OperHealLeve,OperPreTime,OperConTime,EtiExaFlag,IsMedAnti,SpMedAnti,SpAntFlag,SpAntDDD,LimMedAnti,LimAntFlag,LimAntDDD,OperPre2h,hospna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
SplitMulitData26(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
}

ClassMethod GetPatAntiDrugInfoMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAntiDrugInfoMXExecute ]
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

ClassMethod GetPatAntiDrugInfoMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAntiDrugInfoMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatAntiDrugInfoMX(SDate As %String, EDate As %String, pattype As %String, deptid As %Text, hospid As %String) As %Query(ROWSPEC = "admdr:%String,zyh:%String,name:%String,sex:%String,ryrq:%String,cyrq:%String,dept:%String,desc:%String,AntiFlag:%String,AntiDDD:%Float,OperHealLeve:%String,OperPreTime:%String,OperConTime:%String,EtiExaFlag:%String,IsMedAnti:%String,SpMedAnti:%String,SpAntFlag:%String,SpAntDDD:%Float,LimMedAnti:%String,LimAntFlag:%String,LimAntDDD:%Float,OperPre2h:%String,hospna:%String") [ SqlProc ]
{
}

// 使用抗菌药人数

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","FindInpatAntiDrug","2013-04-17","2013-04-17","","","")

ClassMethod FindInpatAntiDrugExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, UsePur As %String, admid As %String, opercut As %String) As %Status
{
	n (qHandle,SDate,EDate,UsePur,admid,opercut)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:SDate="" $$$OK
 	q:EDate="" $$$OK
 
    
    k ^TEMPDHCWL($j)
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	d SplitMulitData27(UsePur,,.UsePurData)
	d SplitMulitData27(admid,,.admidData)
	d SplitMulitData27(opercut,,.opercutData)
	f DisDate=SDate:1:EDate d
	.s PADRowid="" f  s PADRowid=$o(^DHCWLPADI(0,"DisDate",DisDate,PADRowid)) q:PADRowid=""  d
	..s OperHealLeve=$p(^DHCWLPADI(PADRowid),"^",26) ;手术切口
	..//判断手术切口
    ..q:(opercut'="")&&(OperHealLeve="")  
	..q:(opercut'="")&&('$d(opercutData(OperHealLeve))) 
	..s mAdm=$p(^DHCWLPADI(PADRowid),"^",1)    ;PAADMDR
	..//判断患者
    ..q:(admid'="")&&(mAdm="")  
	..q:(admid'="")&&('$d(admidData(mAdm))) 
	..s mPatType=$P(^PAADM(mAdm),"^",2)
	..q:mPatType'="I"
    ..s mOrd=0 f  s mOrd=$o(^OEORD(0,"Adm",mAdm,mOrd))  q:mOrd=""  d
    ...s mSub=0  f  s mSub=$O(^OEORD(mOrd,"I",mSub))  q:mSub=""  d 
    ....s arcrowid=$p($g(^OEORD(mOrd,"I",mSub,1)),"^",2)  q:arcrowid=""
    ....s arccatDr=$P(^ARCIM(+arcrowid,$P(arcrowid,"||",2),1),"^",10)
    ....s arccattype=$P(^ARC("IC",arccatDr),"^",7)
    ....q:arccattype'="R"
    ....s PriorityDR=$P(^OEORD(mOrd,"I",mSub,1),"^",8)
    ....s OrderItemStat=$P(^OEORD(mOrd,"I",mSub,1),"^",13)
 	....q:(((OrderItemStat=2)!(OrderItemStat=12))&(PriorityDR'=5))   //非长期医嘱过滤撤消 与作废
 	....q:((OrderItemStat=2)&(PriorityDR=5))   //长期医嘱过滤作废
    ....s arcdesc=$P(^ARCIM(+arcrowid,$P(arcrowid,"||",2),1),"^",2)
    ....S DrgId=$p(^ARCIM(+arcrowid,$P(arcrowid,"||",2),1),"^",12)   //药学项id
 	....;S AntibioticFlag=$P(^PHCD(+DrgId,"DF",$p(DrgId,"||",2),"DHC"),"^",8) ;抗菌药物标志
 	....;q:AntibioticFlag'="Y"
 	....q:$$IsAntiDrg^DHCWLBuildKPICommon(+DrgId)=0 ;2013-06-18 lxc add
  	....s mAntUseStr=$$GetAntUsePurpose(mOrd_"||"_mSub)
 	....s mAntUsePur=$P(mAntUseStr,"@",3)
 	....//判断预防用、治疗用
    ....q:(UsePur'="")&&(mAntUsePur="")  
	....q:(UsePur'="")&&('$d(UsePurData(mAntUsePur))) 
 	....s:mAntUsePur=1 mAntUsePurNa="预防用"
 	....s:mAntUsePur=2 mAntUsePurNa="治疗用"
 	....s OrderDate=$P(^OEORD(mOrd,"I",mSub,3),"^",7)
 	....s OrderTime=$P(^OEORD(mOrd,"I",mSub,1),"^",17)
 	....s orddepDr=$P(^OEORD(mOrd,"I",mSub,1),"^",3)
 	....s orderDep=$P(^CTLOC(orddepDr),"^",1)
 	....s orddocDr=$P(^OEORD(mOrd,"I",mSub,1),"^",11)
 	....s orderdoc=$P(^CTPCP(orddocDr,1),"^",2)
 	....s WLRowid="" f  s WLRowid=$o(^DHCWorkLoad(0,"OEORI",mOrd_"||"_mSub,WLRowid)) q:WLRowid=""  d    ;2013-04-12   添加项目数量和费用
 	.....s qty=$p(^DHCWorkLoad(WLRowid),"^",15) ;收费项目数量 
    .....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16) q:Fee=0   ;该医嘱发生的费用
	.....d OutputRow27
	k ^TEMPDHCWL($j)
 	q $$$OK	

OutputRow27

    s Papmi=$p(^PAADM(mAdm),"^",1)
    s PAPMINo=$p(^PAPER(Papmi,"PAT",1),"^",1)     //表PA_PatMas     /登记号
 	s PAPMIName=$p(^PAPER(Papmi,"ALL"),"^",1)     //表PA_PatMas     /姓名
 	;s PAADMDate=$p(^PAADM(mAdm),"^",6)
 	//新入院方式修正
 	s PAADMDate=$$GetAdmDate^DHCWLCommon(mAdm) 
 	s PAADMDepDr=$p(^PAADM(mAdm),"^",4)
 	s PAADMDep=$P(^CTLOC(PAADMDepDr),"^",1)
    s zyh=$$GetPapmiMedtare^DHCWLCommon(Papmi) //通过PA_PatMas.PAPMI_RowId得到病人住院号
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    s admreason=$$GetReason^DHCWLCommon(mAdm) //病人类型
    ;s name=$$GetPapmiName^DHCWLCommon(Papmi)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    s sex=$$GetSex^DHCWLCommon(Papmi) //病人性别
    ;s ryrq=$zd(admdate,3),
    s cyrq=$zd(DisDate,3)
    s sscut=OperHealLeve_"级"
    s Data=$lb(mAdm,Papmi,zyh,PAPMIName,sex,PAADMDate,cyrq,PAADMDep,sscut,mAntUsePurNa,arcdesc,$zd(OrderDate,3),$zt(OrderTime,1),orderDep,orderdoc,qty,Fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	//判断抗菌药物医嘱用途
	//1.预防用;2.治疗用
GetAntUsePurpose(oeitem)
	;n (oeitem)
	q:oeitem="" ""	
	s daupid=0,ret=""	
	f  s daupid=$o(^DAUP("OEORI",oeitem,daupid))  q:daupid=""   d
	.s insDr=$p($g(^DAUP("DAUP",daupid)),"^",10)   ;指征
	.s dtaupDr=$p($g(^DAUP("DAUP",daupid)),"^",20) ;使用目的
	.s dtaupCode=$p($g(^DTAUP("AUP",+dtaupDr)),"^",1) ;手术预防
	.s dtaupCat=$p($g(^DTAUP("AUP",+dtaupDr)),"^",3) ;使用目的		
	.s ret=daupid_"@"_dtaupCode_"@"_dtaupCat_"@"_insDr		
	q ret
SplitMulitData27(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
}

ClassMethod FindInpatAntiDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInpatAntiDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindInpatAntiDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInpatAntiDrugExecute ]
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

Query FindInpatAntiDrug(SDate As %String, EDate As %String, UsePur As %String, admid As %String, opercut As %String) As %Query(ROWSPEC = "mAdm:%String,Papmi:%String,zyh:%String,PAPMIName:%String,sex:%String,PAADMDate:%String,cyrq:%String,PAADMDep:%String,sscut:%String,mAntUsePurNa:%String,arcdesc:%String,OrderDate:%String,OrderTime:%String,orderDep:%String,orderdoc:%String,qty:%Integer,Fee:%Float") [ SqlProc ]
{
}

// 科室医师处方品种数明细监控

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPressPnt","2012-12-01","2012-12-04","","","","","5")

ClassMethod GetDepDocPressPntExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, drgId As %String, money As %String, prcnt As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,drgId,money,prcnt)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
	
	d SplitMulitData28(dept,,.deptData)
	d SplitMulitData28(doc,,.docData)
	d SplitMulitData28(drgId,,.drgIdData)
    
    k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	s Price=0,YLPrice=0,YaoPrice=0
	f pyday=SDate:1:EDate d
    .s phldr="" f  s phldr=$o(^DHCPHDISPi("FYDATE",pyday,phldr)) q:phldr=""  d
    ..s PHDROWID="" f  s PHDROWID=$o(^DHCPHDISPi("FYDATE",pyday,phldr,PHDROWID)) q:PHDROWID=""  d
    ...s PrescNo=$p(^DHCPHDISP(PHDROWID,2),"^",1)   ;处方号
    ...s PHDICHILDSUB="" f  s PHDICHILDSUB=$o(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB)) q:PHDICHILDSUB=""  d
    ....s OEORIDR=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",5)
    ....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(OEORIDR)  ;q:phcdf1'=252
    ....//判断是否为所选药品
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf1="") 
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf1)))
    ....s oeordr=$p(OEORIDR,"||",1)
    ....s oeorsub=$p(OEORIDR,"||",2)
    ....s depdr=$p(^OEORD(oeordr,"I",oeorsub,1),"^",3)  
    ....s orddocdr=$p($g(^OEORD(oeordr,"I",oeorsub,1)),"^",11) ;开单医师
    ....//判断科室是否为所选科室
	....q:(dept'="")&&(depdr="") 
	....q:(dept'="")&&('$d(deptData(depdr)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(orddocdr="") 
	....q:(doc'="")&&('$d(docData(orddocdr)))
    ....s admId=$p(^OEORD(oeordr),"^",1)
    ....s price1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",3) 
    ....s count1=$p(^DHCPHDI(PHDROWID,"PHDI",PHDICHILDSUB),"^",4) ;q:count1=0 
    ....s ^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf1,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf1,"Qty"))+count1
    ....s ^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf1,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,+phcdf1,"Fee"))+price1
    ....s ^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"CFJE"))+price1
    ....s ^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"prnt")=$g(^TEMPDHCWL1($j,"DHCWLLXC",depdr,orddocdr,admId,PrescNo,"prnt"))+1
    
    s totalprice=0,prntcount=0 
    s loc="" f  s loc=$o(^TEMPDHCWL($j,"DHCWLLXC",loc))  q:loc=""  d
    .s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid))  q:docid=""  d
    ..s adm="" f  s adm=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm))  q:adm=""  d
    ...s Presc="" f  s Presc=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,Presc))  q:Presc=""  d
    ....s totalprice=$g(^TEMPDHCWL1($j,"DHCWLLXC",loc,docid,adm,Presc,"CFJE"))
    ....i money'="" q:totalprice<money
    ....s prntcount=$g(^TEMPDHCWL1($j,"DHCWLLXC",loc,docid,adm,Presc,"prnt"))
    ....i prcnt'="" q:prntcount<prcnt
    ....s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,Presc,phcdf))  q:phcdf=""  d
    .....s count=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,Presc,phcdf,"Qty"))  
    .....s price=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,Presc,phcdf,"Fee")) 
    .....d OutPutRow28
    
	k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
	Quit $$$OK
OutPutRow28
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge28(birth,+$h)
    s age=$p(age,"Y",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s ItmMastDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    
	s Data=$lb(loc,dimDesc,docid,doccode,docname,adm,admtype,cPAPMIName,sex,age,Presc,phcdf,ItmMastDesc,unitdesc,Guig,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q

SplitMulitData28(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
 
CalAge28(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetDepDocPressPntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPressPntExecute ]
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

ClassMethod GetDepDocPressPntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPressPntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPressPnt(startDate As %String, endDate As %String, dept As %Text, doc As %Text, drgId As %String, money As %String, prcnt As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,adm:%String,admtype:%String,cPAPMIName:%String,sex:%String,age:%String,PrescNo:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,Guig:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}

// 出院患者药品费用信息

// 

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeYGYY","2012-12-01","2012-12-01","D","GetZyLocRcMx","","","",1)	

ClassMethod GetPatYPFeeYGYYExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Status
{
	n (qHandle,startDate,endDate,type,kpiCodeStrZb,dept,doc,hospid,base)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
	
	d SplitMulitData17YGYY(dept,,.deptData)
	d SplitMulitData17YGYY(doc,,.docData)
	d SplitMulitData17YGYY(hospid,,.hospidData)
    d SplitMulitData17YGYY(base,,.baseData)    
    s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
    f date=startDate:1:endDate d
 	.s mripid=0 f  s mripid=$o(^MRIPdaily("MRIP_DATE",date,mripid)) q:mripid=""  d
 	..s brloc=$p(^MRIPdaily(mripid),"^",7) q:brloc="" ;科室
 	..//判断科室是否为所选科室
	..q:(dept'="")&&(brloc="") 
	..q:(dept'="")&&('$d(deptData(brloc)))
	..//判断医院是否为所选医院
	..s hosp=$P($G(^CTLOC(brloc)),"^",22)
	..i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	..q:(hospid'="")&&(hosp="") 
	..q:(hospid'="")&&('$d(hospidData(hosp)))
 	..s admid="" f  s admid=$o(^DHCMRIPDetail(0,"IPDayDr",mripid,"Type","CYRS","Paadm",admid)) q:admid=""  d
 	...s patDoc=$p(^PAADM(admid),"^",9) ;主管医生
 	...i patDoc="" s patDoc="999999"
 	...//判断医师是否为所选医师
	...q:(doc'="")&&(patDoc="") 
	...q:(doc'="")&&('$d(docData(patDoc)))
	...s WLRowid=0,qty=0,Fee=0
	...f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",admid,WLRowid)) q:WLRowid=""  d
	....s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    ....q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    ....s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    ....s oeoid=+oeori
	....s oeosub=$p(oeori,"||",2)
	....s admid=$p(^OEORD(oeoid),"^",1)
	....s itemstaDR=$p(^OEORD(oeoid,"I",oeosub,1),"^",13)
	....;s ordSta=$p(^OEC("OSTAT",itemstaDR),"^",1)
	....;q:((ordSta="U")||(ordSta="D")) 		;医嘱未核实或停止
	....;s drugqty=$$GetQty^DHCWLBaseInforFunction(oeori)
	....;q:((drugqty<0)||(drugqty=0)) 		;发药数量小于退药数量
    ....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori)
    ....//判断科室是否为所选基本药物
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
    ....s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	....s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ....s ^TEMPDHCWL($j,"DHCWLXC",brloc,patDoc,itm,"qty")=$g(^TEMPDHCWL($j,"DHCWLXC",brloc,patDoc,itm,"qty"))+qty
    ....s ^TEMPDHCWL($j,"DHCWLXC",brloc,patDoc,itm,"fee")=$g(^TEMPDHCWL($j,"DHCWLXC",brloc,patDoc,itm,"fee"))+Fee
    ....s oeordId=$p(oeori,"||",1)
    ....s oeoriSub=$p(oeori,"||",2)
  	....s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
 	....;s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
 	....;q:((ststat'=1) && (ststat'=6))
	....s ^TEMPDHCWL1($j,"DHCWLXC",brloc,patDoc,itm,admid,sttDate,"yyts")=1
    
    s loc=0 f  s loc=$o(^TEMPDHCWL1($j,"DHCWLXC",loc)) q:loc=""  d
    .s docId=0 f  s docId=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId)) q:docId=""  d
    ..s item=0 f  s item=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item)) q:item=""  d
    ...s adm=0 f  s adm=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm)) q:adm=""  d
    ....s stt=0 f  s stt=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt)) q:stt=""  d
    .....s yyts1=$g(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt,"yyts"))
    .....s ^temp2($j,"DHCWLXC",loc,docId,item,"yyts")=$g(^temp2($j,"DHCWLXC",loc,docId,item,"yyts"))+yyts1
    
    s locId=0 f  s locId=$o(^TEMPDHCWL($j,"DHCWLXC",locId)) q:locId=""  d
    .s dociId=0 f  s dociId=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId)) q:dociId=""  d
    ..s itemid=0 f  s itemid=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid)) q:itemid=""  d
    ...s Ypqty=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"qty")) 
    ...s Ypfee=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"fee")) 
    ...s Yyts=$g(^temp2($j,"DHCWLXC",locId,dociId,itemid,"yyts")) 
    ...d OutputRow17YGYY
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
 	q $$$OK	

OutputRow17YGYY
    i $d(^CTLOC(locId))  d  
    .s dimDesc1=$P($G(^CTLOC(locId)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i $d(^CTPCP(dociId)) d
    .s docna=$$GetPatDoc^DHCWLCommon(dociId)
    .e  s docna="Null"
   
    i $d(^DHCTARI(itemid)) d
    .s itmdesc=$p(^DHCTARI(itemid),"^",2)
    .s uom=$p(^DHCTARI(itemid),"^",3)
    .i $d(^CT("UOM",uom))  s danwei=$p(^CT("UOM",uom),"^",2)
           
    s Data=$lb(locId,deptna,dociId,docna,itemid,itmdesc,danwei,Ypqty,Ypfee,Yyts)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData17YGYY(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetPatYPFeeYGYYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeYGYYExecute ]
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

ClassMethod GetPatYPFeeYGYYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeYGYYExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatYPFeeYGYY(startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Query(ROWSPEC = "locId:%String,deptna:%String,dociId:%String,docna:%String,itemid:%String,itmdesc:%String,danwei:%String,Ypqty:%Float,Ypfee:%Float,Yyts:%Float") [ SqlProc ]
{
}

/*
//出院患者药品费用信息

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeYGYY","2014-06-01","2014-06-01","D","GetZyLocRcMx","","","",1)	

ClassMethod GetPatYPFeeYGYYExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Status
{
	n (qHandle,startDate,endDate,type,kpiCodeStrZb,dept,doc,hospid,base)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
    s monIdStr=""
 	i type="D"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	i type="M"  d
	.s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudMonth(startDate,endDate)
	
	s monIdStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(monNameStr)
 	q:monIdStr="" 1
	q:kpiCodeStrZb="" 1
		
	s kpiIdStrZb=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStrZb)
	s sc=##class(DHCWL.MKPIService.KJYWFXQuery).GetMutiMonKPIData(monIdStr,kpiIdStrZb,.data)
	q:sc'=1 1
	q:'$d(data) 1
	
	d SplitMulitData17YGYY(dept,,.deptData)
	d SplitMulitData17YGYY(doc,,.docData)
	d SplitMulitData17YGYY(kpiIdStrZb,,.kpiIdStrZbData)
	d SplitMulitData17YGYY(hospid,,.hospidData)
    d SplitMulitData17YGYY(base,,.baseData)
    
	s monId=""
	f  s monId=$o(data(monId)) q:monId=""  d
	.s kpiId=""
	.f  s kpiId=$o(data(monId,kpiId)) q:kpiId=""  d
	..s dimId=0
	..f  s dimId=$o(data(monId,kpiId,dimId)) q:dimId=""  d
	...s dimIdLoc=$p(dimId,",",2)
	...//判断科室是否为所选科室
	...q:(dept'="")&&(dimIdLoc="") 
	...q:(dept'="")&&('$d(deptData(dimIdLoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(dimIdLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)=""))  s hospna=$P($G(^CT("HOSP",$g(hospid))),"^",2)   
	...s dimIdDoc=$p(dimId,",",3) 
	...//判断医师是否为所选医师
	...q:(doc'="")&&(dimIdDoc="") 
	...q:(doc'="")&&('$d(docData(dimIdDoc)))
	...//判断指标是否为所选指标
	...q:(kpiIdStrZb'="")&&(kpiId="")  
	...q:(kpiIdStrZb'="")&&('$d(kpiIdStrZbData(kpiId)))
	...s ADMRowID=$p(dimId,",",4)
	...q:ADMRowID="" 
	...s WLRowid=0,qty=0,Fee=0
	...f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",ADMRowID,WLRowid)) q:WLRowid=""  d
	....s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    ....q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    ....s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    ....s oeoid=+oeori
	....s oeosub=$p(oeori,"||",2)
	....s admid=$p(^OEORD(oeoid),"^",1)
	....s itemstaDR=$p(^OEORD(oeoid,"I",oeosub,1),"^",13)
	....s ordSta=$p(^OEC("OSTAT",itemstaDR),"^",1)
	....q:((ordSta="U")||(ordSta="D")) 		;医嘱未核实或停止
	....s drugqty=$$GetQty^DHCWLBaseInforFunction(oeori)
	....q:((drugqty<0)||(drugqty=0)) 		;发药数量小于退药数量
    ....s baseflag=$$IntfaceJB^DHCWLBuildKPICommon(oeori)
    ....//判断科室是否为所选基本药物
	....q:(base'="")&&(baseflag="") 
	....q:(base'="")&&('$d(baseData(baseflag)))
    ....s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
	....s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ....s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"qty"))+qty
    ....s ^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee")=$g(^TEMPDHCWL($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,"fee"))+Fee
    ....s oeordId=$p(oeori,"||",1)
    ....s oeoriSub=$p(oeori,"||",2)
  	....s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
 	....s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
 	....q:((ststat'=1) && (ststat'=6))
	....s ^TEMPDHCWL1($j,"DHCWLXC",dimIdLoc,dimIdDoc,itm,ADMRowID,sttDate,"yyts")=1
    
    s loc=0 f  s loc=$o(^TEMPDHCWL1($j,"DHCWLXC",loc)) q:loc=""  d
    .s docId=0 f  s docId=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId)) q:docId=""  d
    ..s item=0 f  s item=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item)) q:item=""  d
    ...s adm=0 f  s adm=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm)) q:adm=""  d
    ....s stt=0 f  s stt=$o(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt)) q:stt=""  d
    .....s yyts1=$g(^TEMPDHCWL1($j,"DHCWLXC",loc,docId,item,adm,stt,"yyts"))
    .....s ^temp2($j,"DHCWLXC",loc,docId,item,"yyts")=$g(^temp2($j,"DHCWLXC",loc,docId,item,"yyts"))+yyts1
    
    s locId=0 f  s locId=$o(^TEMPDHCWL($j,"DHCWLXC",locId)) q:locId=""  d
    .s dociId=0 f  s dociId=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId)) q:dociId=""  d
    ..s itemid=0 f  s itemid=$o(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid)) q:itemid=""  d
    ...s Ypqty=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"qty")) 
    ...s Ypfee=$g(^TEMPDHCWL($j,"DHCWLXC",locId,dociId,itemid,"fee")) 
    ...s Yyts=$g(^temp2($j,"DHCWLXC",locId,dociId,itemid,"yyts")) 
    ...d OutputRow17YGYY
    k ^TEMPDHCWL($j,"DHCWLXC"),^TEMPDHCWL1($j,"DHCWLXC"),^temp2($j,"DHCWLXC")
 	q $$$OK	

OutputRow17YGYY
    i $d(^CTLOC(locId))  d  
    .s dimDesc1=$P($G(^CTLOC(locId)),"^",2)  
    .i dimDesc1 [ "-" s deptna=$p(dimDesc1,"-",2)
    .e  s deptna=dimDesc1
    
    i $d(^CTPCP(dociId)) d
    .s docna=$$GetPatDoc^DHCWLCommon(dociId)
    .e  s docna="Null"
   
    i $d(^DHCTARI(itemid)) d
    .s itmdesc=$p(^DHCTARI(itemid),"^",2)
    .s uom=$p(^DHCTARI(itemid),"^",3)
    .i $d(^CT("UOM",uom))  s danwei=$p(^CT("UOM",uom),"^",2)
           
    s Data=$lb(locId,deptna,dociId,docna,itemid,itmdesc,danwei,Ypqty,Ypfee,Yyts)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData17YGYY(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetPatYPFeeYGYYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeYGYYExecute ]
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

ClassMethod GetPatYPFeeYGYYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeYGYYExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatYPFeeYGYY(startDate As %String, endDate As %String, type As %String, kpiCodeStrZb As %String, dept As %Text, doc As %Text, hospid As %String, base As %String) As %Query(ROWSPEC = "locId:%String,deptna:%String,dociId:%String,docna:%String,itemid:%String,itmdesc:%String,danwei:%String,Ypqty:%Float,Ypfee:%Float,Yyts:%Float") [ SqlProc ]
{
}

*/

// 全院科室医师患者用药明细   2013-11-25   zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPatMMMXXX","2015-03-07","2015-03-07","","","11511","ALL","3")

ClassMethod GetDepDocPatMMMXXXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %String, drugId As %String, kjflag As %String, hospid As %String, drgform As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,drugId,kjflag,hospid,drgform)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
 
	s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
  
    k ^TEMPDHCWLDATA("S",$j)

	d SplitMulitData1444(dept,,.deptData)
	d SplitMulitData1444(doc,,.docData)
	d SplitMulitData1444(drugId,,.drugIdData)
	d SplitMulitData1444(hospid,,.hospidData)
	;d SplitMulitData1444(drgform,,.drgformData)
	
	//门诊发药
	s IsAnti="",phDDD="",wlRowid=""
	f date=startDate:1:endDate d
	.s phLoc=0
	.f  s phLoc=$o(^DHCPHDISPi("FYDATE",date,phLoc)) q:phLoc=""  d
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phLoc,phId)) q:phId=""  d
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:(phSub="")  d
	....s oeori=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",5)
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s admId=$p(^OEORD(ord),"^",1)  ;20130312 add
	....s PAADMType=$p(^PAADM(admId),"^",2) ;20130312 add
	....s admLoc=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;开单科室
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;q:patdoc'=6119 ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"	
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori)
	....q:phcdf=""
	....//判断药品是否为所选药品
	....q:(drugId'="")&&(+phcdf="") 
	....q:(drugId'="")&&('$d(drugIdData(+phcdf)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc="") 
	....q:(dept'="")&&('$d(deptData(admLoc)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0 s IsAnti=0,phDDD=0 
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)'=0 s IsAnti=1,phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf)
    ....i +phDDD=0 s IsAnti=0
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzAnti")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzAnti"))+$num($p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",3),2) ;抗菌药金额  
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzDDD"))+$num(($p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",4)/$g(phDDD)),4) 	;抗菌DDDs
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzAntiqty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzAntiqty"))+$num($p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",4),2) ;抗菌药数量
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzQty"))+$num($p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",4),2) ;数量
    ....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzFee"))+$num($p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",3),2) ;金额
   
    //门诊退药
    f date1=startDate:1:endDate d
	.s phLoc1=0,wlRowid=""
	.f  s phLoc1=$o(^DHCPHRETi(date1,phLoc1)) q:phLoc1=""  d
	..s phrId1=0
	..f  s phrId1=$o(^DHCPHRETi(date1,phLoc1,phrId1)) q:phrId1=""  d
	...s phId1=$p(^DHCPHRET(phrId1),"^",6)
	...s phrItem1=""
	...f  s phrItem1=$o(^DHCPHRTI(phrId1,"RTI",phrItem1)) q:phrItem1=""  d
	....s oeori1=$p(^DHCPHRTI(phrId1,"RTI",phrItem1),"^",2)
	....s ord=+oeori1
	....s ordSub=$p(oeori1,"||",2)
	....s admId1=$p(^OEORD(ord),"^",1)  ;20130312 add
	....s PAADMType=$p(^PAADM(admId1),"^",2) ;20130312 add
	....s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;patdoc'=6119 ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"
	....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori1)	q:phcdf1=""
	....//判断药品是否为所选药品
	....q:(drugId'="")&&(+phcdf1="") 
	....q:(drugId'="")&&('$d(drugIdData(+phcdf1)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc1="") 
	....q:(dept'="")&&('$d(deptData(admLoc1)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc1)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0 s IsAnti=0,phDDD=0 
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)'=0 s IsAnti=1,phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf1) 
    ....i +phDDD=0 s IsAnti=0
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzAnti")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzAnti"))-$num($p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1),2)
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzDDD"))-$num(($p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)/$g(phDDD)),4)
	....i IsAnti=1 s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzAntiqty")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzAntiqty"))-$num(($p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)),2)  ;数量
	....s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzFee"))-$num($p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1),2)	;金额
	....s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzQty"))-$num(($p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)),2)  ;数量

	//住院发药
	f date=startDate:1:endDate d
	.s phaLoacId=0
	.f  s phaLoacId=$o(^DHCPHAC(0,"PHA",phaLoacId)) q:phaLoacId=""  d
	..s phaId=0
	..s admLoc=""
	..f  s phaId=$o(^DHCPHAC(0,"PHA",phaLoacId,"DATE",date,phaId)) q:phaId=""  d
	...s phaSubId=0
	...f  s phaSubId=$o(^DHCPHAC(phaId,"I",phaSubId)) q:phaSubId=""  d
	....s oeori=$p(^DHCPHAC(phaId,"I",phaSubId),"^",7)
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....q:'$d(^OEORD(ord,"I",ordSub,1))
	....s admid=$p(^OEORD(ord),"^",1)
	....s arcimid=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	....s OrdType=$p(^OEORD(ord,"I",ordSub,1),"^",8) 
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) q:phcdf=""
	....s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)  
	....i admLoc1'="" s admLoc=admLoc1   ;2012-11-22 lxc
	....i admLoc1="" s admLoc=$$GetAdmLocByOeoriAdm^DHCWLBuildKPICommon(oeori)  ;2012-11-22 lxc
	....q:phcdf=""
	....//判断药品是否为所选药品
	....q:(drugId'="")&&(+phcdf="") 
	....q:(drugId'="")&&('$d(drugIdData(+phcdf)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc="") 
	....q:(dept'="")&&('$d(deptData(admLoc)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
	....s qty=$p(^DHCPHAC(phaId,"I",phaSubId),"^",6) q:qty=0 
	....s unitPrice=$p(^DHCPHAC(phaId,"I",phaSubId),"^",9) q:unitPrice=0
	....;s nod=PAADMType_","_admLoc_","_patdoc_","_OrdType_","_arcimid
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty"))+qty ;药品数量
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee"))+$num(qty*unitPrice,2) ;金额   
    ....q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0 
    ....s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf) 
    ....q:+$G(phDDD)=0 
    ....s Antiqty=$p(^DHCPHAC(phaId,"I",phaSubId),"^",6) q:Antiqty=0 
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD"))+$num(Antiqty/$g(phDDD),4)  ;抗菌药DDDs	

    //住院退药
    f date=startDate:1:endDate d
	.s phaRetId=0
	.f  s phaRetId=$o(^PHARET(0,"DATE",date,phaRetId)) q:phaRetId=""  d
	..s oeori=$p(^PHARET(phaRetId),"^",5)
	..s ord=+oeori
	..s ordSub=$p(oeori,"||",2)
	..s admid=$p(^OEORD(ord),"^",1)
	..s arcimid=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	..s OrdType=$p(^OEORD(ord,"I",ordSub,1),"^",8)
	..s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub)  ;开单医师 ;2013-01-21 lxc
	..s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) ;q:+phcdf'=1713
	..s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub) 
	..i admLoc1'="" s admLoc=admLoc1   ;2012-11-22 lxc
	..i admLoc1="" s admLoc=$$GetAdmLocByOeoriAdm^DHCWLBuildKPICommon(oeori)  ;2012-11-22 lxc
	..q:phcdf=""
	..//判断药品是否为所选药品
	..q:(drugId'="")&&(+phcdf="") 
	..q:(drugId'="")&&('$d(drugIdData(+phcdf)))
 	..//判断科室是否为所选科室
	..q:(dept'="")&&(admLoc="") 
	..q:(dept'="")&&('$d(deptData(admLoc)))
	..//判断医师是否为所选医师
	..q:(doc'="")&&(patdoc="") 
	..q:(doc'="")&&('$d(docData(patdoc)))
	..//判断医院是否为所选医院
	..s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	..i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	..q:(hospid'="")&&(hosp="") 
	..q:(hospid'="")&&('$d(hospidData(hosp)))
	..i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ..i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
	..;s nod=PAADMType_","_admLoc_","_patdoc_","_OrdType_","_arcimid
	..s qty=$p(^PHARET(phaRetId),"^",12)
	..i qty="" s qty=0 
	..s fee=$p(^PHARET(phaRetId),"^",14)
	..i fee="" s fee=0
	..s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty"))-qty ;药品数量
	..s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee"))-fee ;药品金额
    ..q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0
    ..s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf)
    ..q:+$G(phDDD)=0  
    ..s Antiqty=$p(^PHARET(phaRetId),"^",12) q:Antiqty=0
	..s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD"))-$num(Antiqty/$g(phDDD),4)  ;抗菌DDD

	i kjflag="ALL" d  
	.s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0   
    .s loc="" f  s loc=$o(^TEMPDHCWLDATA("S",$j,loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWLDATA("S",$j,loc,docid))  q:docid=""  d
    ...s adm="" f  s adm=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm))  q:adm=""  d
    ....s phcdf="" f  s phcdf=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf))  q:phcdf=""  d
    .....s mzqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzQty"))
    .....s mzje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzFee"))
    .....s mzddd=0
    .....s zyqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyQty"))
    .....s zyje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyFee")) 
    .....s zyddd=0
    .....s qyqty=mzqty+zyqty
    .....s qyje=mzje+zyje
    .....s qyddd=0
    .....d OutPutRow1444
    
	i kjflag="KJYW" d
	.s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0  
    .s loc="" f  s loc=$o(^TEMPDHCWLDATA("S",$j,loc))  q:loc=""  d 
    ..s docid="" f  s docid=$o(^TEMPDHCWLDATA("S",$j,loc,docid))  q:docid=""  d
    ...s adm="" f  s adm=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm))  q:adm=""  d 	
    ....s phcdf="" f  s phcdf=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf))  q:phcdf=""  d
    .....s mzqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzAntiqty")) 
    .....s mzje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzAnti"))
    .....s mzddd=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzDDD"))
    .....s zyqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyAntiqty"))
    .....s zyje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyAnti")) 
    .....s zyddd=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyDDD"))
    .....s qyqty=mzqty+zyqty  
    .....s qyje=mzje+zyje
    .....s qyddd=mzddd+zyddd 
    .....d OutPutRow1444
	
 	k ^TEMPDHCWLDATA("S",$j)
 	
	Quit $$$OK
	
OutPutRow1444
 i $d(^CTLOC(loc))  d  
    .s locDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i locDesc1 [ "-" s locDesc=$p(locDesc1,"-",2)
    .e  s locDesc=locDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    s papmidr=$p(^PAADM(adm),"^",1)
    s diagna=$$getpatdiag^DHCWLBuildKPICommon(adm,"")
    s code=$p($g(diagna),"^",2), diagcode=$TR(code,",",".")
    s desc=$p($g(diagna),"^",3), diagdesc=$TR(desc,",",".")
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s admtype=$p(^PAADM(adm),"^",2)
    ;s papmiNo=$$GetPapmiNo^DHCWLCommon(papmidr)   //登记号  2013-04-13  zyb  add
 	s medicareNo=$$GetPapmiMedtare^DHCWLCommon(papmidr) //通过PA_PatMas.PAPMI_RowId得到病人病案号
   	s admDate=$p(^PAADM(adm),"^",6)   //西丽增加就诊日期    zyb 2015-01-14
    s drugDesc=$p(^PHCD(phcdf,1),"^",2)
    s drugCode=$p(^PHCD(phcdf,1),"^",1)
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
 	s ARCIMDr=0
 	s InciId=0
 	s ARCIMDr=$O(^ARCIM(0,"PHCDF",phcdf_"||1",ARCIMDr)) q:ARCIMDr="" ""
 	s drugForm=$$GetDrugForm^DHCWLBulidDimDataYGYY001(ARCIMDr)   //剂型
 	//判断是否为所选剂型
	q:(drgform'="")&&(drugForm="") 
	i drgform'="" q:drugForm'=drgform
 	s apcvmName=$$GetDrugapc^DHCWLBulidDimDataYGYY001(ARCIMDr)    //供应商
 	s phmnfName=$$GetDrugphm^DHCWLBulidDimDataYGYY001(ARCIMDr)     //生产商
	s InciId=$O(^INCI(0,"ARCIM_DR",ARCIMDr,InciId)) q:InciId="" ""
	s TmpImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImportFlag(InciId)	;进口标志
 	s PurUomId=$p(^INCI(InciId,3),"^",6)
 	s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,"","")
 	i Rp="" s Rp=0
	
	s Data=$lb(loc,locDesc,docid,doccode,docname,adm,admtype,cPAPMIName,$zd(admDate,3),medicareNo,phcdf,drugCode,drugDesc,drugForm,unitdesc,Guig,apcvmName,phmnfName,TmpImpFlag,diagcode,diagdesc,Rp,mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	

SplitMulitData1444(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepDocPatMMMXXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPatMMMXXXExecute ]
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

ClassMethod GetDepDocPatMMMXXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPatMMMXXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPatMMMXXX(startDate As %String, endDate As %String, dept As %Text, doc As %String, drugId As %String, kjflag As %String, hospid As %String, drgform As %String) As %Query(ROWSPEC = "loc:%String,locDesc:%String,docid:%String,doccode:%String,docname:%String,adm:%String,admtype:%String,cPAPMIName:%String,admDate:%String,medicareNo:%String,phcdf:%String,drugCode:%String,drugDesc:%String,drugForm:%String,unitdesc:%String,Guig:%String,apcvmName:%String,phmnfName:%String,TmpImpFlag:%String,diagcode:%String,diagdesc:%String,Rp:%Float,mzqty:%Float,mzje:%Float,mzddd:%Float,zyqty:%Float,zyje:%Float,zyddd:%Float,qyqty:%Float,qyje:%Float,qyddd:%Float") [ SqlProc ]
{
}

Query QueryDetail(StartDate As %String, EndDate As %String, LocId As %String, RetFlag As %String, Others As %String, StartTime As %String, EndTime As %String, hospid As %String) As %Query(ROWSPEC = "No:%String,InvNo:%String,Date:%String,InciCode:%String,InciDesc:%String,UomDesc:%String,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Vendor:%String,BatNo:%String,Expire:%String,Manf:%String,StkBin:%String,InvDate:%String,SpType:%String,PbFlag:%String,PbLevel:%String,OfficeCode:%String,Type:%String,StkGrpDesc:%String,incscdesc:%String,TmpBaFlag:%String,Gene:%String,Spec:%String,Form:%String,ManfDesc:%String,MinCatDesc:%String,InvoCount:%Integer,RecInvCount:%Integer,TmpImpFlag:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","QueryDetail","2015-11-01","2015-11-27","1303","1","2^^^^^^^^^^^^^^^^^^^^^^0^0^","","")
ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String, RetFlag As %String, Others As %String, StartTime As %String, EndTime As %String, hospid As %String) As %Status
{
	//n (qHandle,StartDate,EndDate,LocId,RetFlag,Others,StartTime,EndTime)
	//s ^yunhaibao("QueryDetail")=StartDate_","_EndDate_","_LocId_","_RetFlag_","_Others_","_StartTime_","_EndTime
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	k ^TMP("INVNO")
	q:StartDate="" $$$OK			//必选条件
	q:EndDate="" $$$OK
	d SplitMulitData1441(LocId,,.LocIdData)
	d SplitMulitData1441(hospid,,.hospidData)
	;q:LocId="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s qPid=""
	i StartTime[":" s StartTime=$zth(StartTime)
    i EndTime[":" s EndTime=$zth(EndTime)
    s loc=0 f  s loc=$o(^CTLOC(loc)) q:loc=""  d
	.q:(LocId'="")&&(loc="")  
	.q:(LocId'="")&&('$d(idData(loc)))
	.//判断医院是否为所选医院
	.s hosp=$P($G(^CTLOC(loc)),"^",22)
	.i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	.q:(hospid'="")&&(hosp="") 
	.q:(hospid'="")&&('$d(hospidData(hosp)))
	.i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    .i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)
	.//s ^zxdd("query2")=StartTime_","_EndTime
	.//统计入库
	.s qPid=##class(web.DHCST.DHCINGdRecStat).GetImportDetail(StartDate,EndDate,loc,Others,StartTime,EndTime)
	.i qPid'="" d
	..d OutputRowImp
	..//s ^zxdd("query2")=StartDate_","_EndDate_","_LocId_","_RetFlag_","_Others_","_StartTime_","_EndTime
	.s qPid=""
	.i RetFlag=1  d
	..//统计退货
	..s qPid=##class(web.DHCST.DHCINGdRecStat).GetReturnDetail(StartDate,EndDate,loc,Others,StartTime,EndTime) 
	.i qPid'="" d
	..d OutputRowRet
	..
	;
	Quit $$$OK

OutputRowImp   
	s num=0
	f  s num=$o(^TMPDHCINSTAT(qPid,"INDETAIL",num))  q:num=""  d
	.s data=^TMPDHCINSTAT(qPid,"INDETAIL",num)
	.s IngrNo=$p(data,"^",1)
	.s InvNo=$p(data,"^",2)
	.s IngrDate=$p(data,"^",3)
	.s InciCode=$p(data,"^",4)
	.s InciDesc=$p(data,"^",5)
	.//i $f(InciDesc,"-") d
	.//.s InciDesc=$p(InciDesc,"-",2)
	.s RecUomDesc=$p(data,"^",6)
	.s RecQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.i $f(Vendor,"-") d
	..s Vendor=$p(Vendor,"-",2)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.;i $f(Manf,"-") d
	.;.s Manf=$p(Manf,"-",2)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s StkGrpDesc=$p(data,"^",27)
	.s incscdesc=$p(data,"^",28)
	.s Gene=$p(data,"^",29)
	.s Spec=$p(data,"^",30)
	.s Form=$p(data,"^",31)
	.s ManfDesc=$p(data,"^",32)
	.s MinCatDesc=$p(data,"^",33)
	.s TmpImpFlag=$p(data,"^",34)
	.s Type="G"
	.i InvNo="" d
	..s invocount=0
	..s recinvcount=0
	.e  d
	..i $d(^TMP("INVNO",InvNo)) s invocount=0
	..e  d
	...s ^TMP("INVNO",InvNo)=""
	...s invocount=1
	..s recinvcount=1
	.s Data=$lb(IngrNo,InvNo,IngrDate,InciCode,InciDesc,RecUomDesc,RecQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type,StkGrpDesc,incscdesc,TmpBaFlag,Gene,Spec,Form,ManfDesc,MinCatDesc,invocount,recinvcount,TmpImpFlag)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	.
	k ^TMPDHCINSTAT(qPid,"INDETAIL")
	q
	
OutputRowRet   
	s num=0
	f  s num=$o(^TMPDHCINSTAT(qPid,"INDETAIL",num))  q:num=""  d
	.s data=^TMPDHCINSTAT(qPid,"INDETAIL",num)
	.s RetNo=$p(data,"^",1)
	.s InvNo=$p(data,"^",2)
	.s IngdDate=$p(data,"^",3)
	.s InciCode=$p(data,"^",4)
	.s InciDesc=$p(data,"^",5)
	.//i $f(InciDesc,"-") d
	.//.s InciDesc=$p(InciDesc,"-",2)
	.s RetUomDesc=$p(data,"^",6)
	.s RetQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.i $f(Vendor,"-") d
	..s Vendor=$p(Vendor,"-",2)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.i $f(Manf,"-") d
	..s Manf=$p(Manf,"-",2)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s StkGrpDesc=$p(data,"^",27)
	.s incscdesc=$p(data,"^",28)
	.s Gene=$p(data,"^",29)
	.s Spec=$p(data,"^",30)
	.s Form=$p(data,"^",31)
	.s ManfDesc=$p(data,"^",32)
	.s MinCatDesc=$p(data,"^",33)
	.s Type="R"
	.i InvNo="" d
	..s invocount=0
	..s recinvcount=0
	.e  d
	..i $d(^TMP("INVNO",InvNo)) s invocount=0
	..e  d
	...s ^TMP("INVNO",InvNo)=""
	...s invocount=1
	..s recinvcount=1
	.s Data=$lb(RetNo,InvNo,IngdDate,InciCode,InciDesc,RetUomDesc,RetQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type,StkGrpDesc,incscdesc,TmpBaFlag,Gene,Spec,Form,ManfDesc,MinCatDesc,invocount,recinvcount)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.
	k ^TMPDHCINSTAT(qPid,"INDETAIL")
	q

SplitMulitData1441(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod QueryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
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

// 出院患者药品费用信息YGYY  

// 抗菌药物判断方式与病人基本信息表中相同 1.医嘱有效未停止 2.发药数量大于退药数量 3.抗菌药物使用目的有效（存表） 4.医嘱不为出院带药

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetPatYPFeeXXYGYY","2012-12-01","2012-12-01","","","GetZyLocRcMx","D","","","","","yp","ALL")

ClassMethod GetPatYPFeeXXYGYYExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, cydy As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,kpiCodeStrZb,type,diag,money,drgId,hospid,flag,kjflag,cydy)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    	q:startDate="" $$$OK			//必选条件
	q:endDate="" $$$OK
    k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
    d SplitMulitData177YGYY(dept,,.deptData)
	d SplitMulitData177YGYY(doc,,.docData)
	d SplitMulitData177YGYY(hospid,,.hospidData)
	d SplitMulitData177YGYY(drgId,,.drgIdData)
	
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
 	.s mripid=0 f  s mripid=$o(^MRIPdaily("MRIP_DATE",date,mripid)) q:mripid=""  d
 	..s brloc=$p(^MRIPdaily(mripid),"^",7) q:brloc="" ;科室
 	..//判断科室是否为所选科室
	..q:(dept'="")&&(brloc="") 
	..q:(dept'="")&&('$d(deptData(brloc)))
	..//判断医院是否为所选医院
	..s hosp=$P($G(^CTLOC(brloc)),"^",22)
	..i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	..q:(hospid'="")&&(hosp="") 
	..q:(hospid'="")&&('$d(hospidData(hosp)))
 	..s admid="" f  s admid=$o(^DHCMRIPDetail(0,"IPDayDr",mripid,"Type","CYRS","Paadm",admid)) q:admid=""  d
 	...s patDoc=$p(^PAADM(admid),"^",9) ;主管医生
 	...i patDoc="" s patDoc="999999"
 	...//判断医师是否为所选医师
	...q:(doc'="")&&(patDoc="") 
	...q:(doc'="")&&('$d(docData(patDoc)))
	...s diagna=$$getpatdiag^DHCWLBuildKPICommon(admid,"")  
    ...s diagcode=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    ...s diagdesc=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
 	...s diagcode=$TR(diagcode,",",".") 
 	...s diagdesc=$TR(diagdesc,",",".") 
    ...//判断诊断是否包含所选诊断
	...q:(diag'="")&&(diagdesc="") 
	...q:(diag'="")&&(diagdesc'[diag)
	...s WLRowid=0,qty=0,Fee=0
	...f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",admid,WLRowid)) q:WLRowid=""  d
	....s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类	
    ....q:'$d(^ARC("IC",0,"OrderType","R",TarCate)) 
    ....s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
    ....s itm=$p(^DHCWorkLoad(WLRowid),"^",22)  ;收费项目
    ....s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项 ;2013-04-24
	....s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)  ;q:phcdf'=334 ;2013-04-24
    ....//判断是否为所选药品项目
	....q:((drgId'="") && (drgId'="null"))&&(+phcdf="")   ;2013-04-24
	....q:((drgId'="") && (drgId'="null"))&&('$d(drgIdData(+phcdf)))  ;2013-04-24
	....s qty=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty=0 ;收费项目数量 
    ....s Fee=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    ....i kjflag="ALL" d
    .....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Fee"))+Fee
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",brloc,patDoc,diagcode,diagdesc,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",brloc,patDoc,diagcode,diagdesc,"CFJE"))+Fee
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee"))+Fee
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Qty"))+qty
    ......s ^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Fee"))+Fee
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",patDoc,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",patDoc,"docJE"))+Fee
    ....i kjflag="KJYW" d
    .....s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项
	.....s phcdf1=$$GetPHCDFByarcim^DHCWLBuildKPICommon(arcim)
    .....;q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0
	.....s oeoid=+oeori
	.....s oeosub=$p(oeori,"||",2)
	.....s itemstaDR=$p(^OEORD(oeoid,"I",oeosub,1),"^",13)
	.....s ordSta=$p(^OEC("OSTAT",itemstaDR),"^",1)
	.....q:(ordSta="U")		;医嘱未核实或停止
	.....s priority=$p($G(^OEORD(oeoid,"I",oeosub,1)),"^",8)
	.....q:+$G(priority)=0 
	.....s pricode=$p($g(^OECPR(priority)),"^",1)
	.....s cydyflag=0 
	.....i pricode="OUT" s cydyflag=1
	.....;q:(cydy'="")&&(cydy'=cydyflag)	;出院带药
	.....q:(cydy'="")&&($find(","_cydy_",",","_cydyflag_",")=0)	;出院带药				
	.....s kjqty=$$GetQty^DHCWLBaseInforFunction(oeori)
	.....q:((kjqty<0)||(kjqty=0)) 		;发药数量小于退药数量
    .....q:$$ComIsAntiDrug^DHCANTQryKPICommon(oeori)=0
	.....s qty1=$p(^DHCWorkLoad(WLRowid),"^",15)  q:qty1=0 ;收费项目数量 
    .....s Fee1=$p(^DHCWorkLoad(WLRowid),"^",16)    ;该医嘱发生的费用
    .....i flag="1" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",brloc,patDoc,admid,itm,"Fee"))+Fee1
    ......;s ^TEMPDHCWL1($j,"DHCWLLXC",brloc,patDoc,diagcode,diagdesc,"CFJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",brloc,patDoc,diagcode,diagdesc,"CFJE"))+Fee1
    .....i flag="yp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",itm,"Fee"))+Fee1
    .....i flag="docyp" d
    ......s ^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Qty")=$g(^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Qty"))+qty1
    ......s ^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Fee")=$g(^TEMPDHCWL($j,"DHCWLLXC",patDoc,itm,"Fee"))+Fee1
    ......s ^TEMPDHCWL1($j,"DHCWLLXC",patDoc,"docJE")=$g(^TEMPDHCWL1($j,"DHCWLLXC",patDoc,"docJE"))+Fee1

    i flag="1" d
    .s totalprice=0  
    .s loc="" f  s loc=$o(^TEMPDHCWL($j,"DHCWLLXC",loc))  q:loc=""  d
    ..s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid))  q:docid=""  d
    ...s adm="" f  s adm=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm))  q:adm=""  d
    ....s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,phcdf))  q:phcdf=""  d
    .....s count=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,phcdf,"Qty"))  
    .....s price=$g(^TEMPDHCWL($j,"DHCWLLXC",loc,docid,adm,phcdf,"Fee")) 
    .....d OutPutRow177YGYY
    
    i flag="yp" d
    .s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",phcdf))  q:phcdf=""  d
    ..s count=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Qty"))  
    ..s price=$g(^TEMPDHCWL($j,"DHCWLLXC",phcdf,"Fee")) 
    ..d OutPutRow177YPYGYY
    
    i flag="docyp" d
    .s docid="" f  s docid=$o(^TEMPDHCWL($j,"DHCWLLXC",docid))  q:docid=""  d
    ..s totalprice=$g(^TEMPDHCWL1($j,"DHCWLLXC",docid,"docJE"))
    ..s phcdf="" f  s phcdf=$o(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf))  q:phcdf=""  d
    ...s count=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Qty"))  
    ...s price=$g(^TEMPDHCWL($j,"DHCWLLXC",docid,phcdf,"Fee")) 
    ...d OutPutRow177DOCYPYGYY
    
	k ^TEMPDHCWL($j,"DHCWLLXC"),^TEMPDHCWL1($j,"DHCWLLXC")
	Quit $$$OK
OutPutRow177YGYY
    i $d(^CTLOC(loc))  d  
    .s dimDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i dimDesc1 [ "-" s dimDesc=$p(dimDesc1,"-",2)
    .e  s dimDesc=dimDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s admtype=$p(^PAADM(adm),"^",2)
    s papmiNo=$$GetPapmiNo^DHCWLCommon(papmidr)   //登记号  2013-04-13  zyb  add
    s sex=$$GetSex^DHCWLCommon(papmidr) //病人性别
    s birth=$p($g(^PAPER(papmidr,"ALL")),"^",6)
    s age=$$CalAge177YGYY(birth,+$h)
    s age=$p(age,"Y",1)
    
    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    s diagna=$$getpatdiag^DHCWLBuildKPICommon(adm,"")  
    s diagco=$p($g(diagna),"^",2) i diagcode="" s diagcode="999999"
    s diagna=$p($g(diagna),"^",3) i diagdesc="" s diagdesc="Null"
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow177YPYGYY

    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    S (loc,dimDesc,docid,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,totalprice)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
OutPutRow177DOCYPYGYY
 
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
    
    i $d(^DHCTARI(phcdf)) d
    .s ItmMastDesc=$p(^DHCTARI(phcdf),"^",2)
    .s uom=$p(^DHCTARI(phcdf),"^",3)
    .i $d(^CT("UOM",uom))  s unitdesc=$p(^CT("UOM",uom),"^",2)
    S (loc,dimDesc,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age)=""
	s Data=$lb(loc,dimDesc,docid,doccode,docname,diagco,diagna,adm,admtype,cPAPMIName,papmiNo,sex,age,phcdf,ItmMastDesc,unitdesc,count,price,totalprice,hospna)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	
SplitMulitData177YGYY(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
CalAge177YGYY(IBirth,IToday)/// 根据出生日计算年龄
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetPatYPFeeXXYGYYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatYPFeeXXYGYYExecute ]
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

ClassMethod GetPatYPFeeXXYGYYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatYPFeeXXYGYYExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatYPFeeXXYGYY(startDate As %String, endDate As %String, dept As %Text, doc As %Text, kpiCodeStrZb As %Text, type As %String, diag As %String, money As %String, drgId As %Text, hospid As %String, flag As %String, kjflag As %String, cydy As %String) As %Query(ROWSPEC = "loc:%String,dimDesc:%String,docid:%String,doccode:%String,docname:%String,diagco:%String,diagna:%String,adm:%String,admtype:%String,cPAPMIName:%String,papmiNo:%String,sex:%String,age:%String,phcdf:%String,ItmMastDesc:%String,unitdesc:%String,count:%Float,price:%Float,totalprice:%Float,hospna:%String") [ SqlProc ]
{
}

// 全院科室医师患者用药明细   2013-11-25   zyb

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQuery","GetDepDocPatMX","2016-03-8","2016-03-8","","","","","","I","","","")

ClassMethod GetDepDocPatMXExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dept As %String, doc As %String, phcpo As %String, drugform As %String, ordertype As %String, admtype As %String, drugname As %String, oeorder As %String, hospid As %String) As %Status
{
	n (qHandle,startDate,endDate,dept,doc,phcpo,drugform,ordertype,admtype,drugname,oeorder,hospid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	q:startDate="" $$$OK
	q:endDate="" $$$OK
 
	s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
  
    k ^TEMPDHCWLDATA("S",$j)

	d SplitMulitData144(dept,,.deptData)
	d SplitMulitData144(doc,,.docData)
	d SplitMulitData144(phcpo,,.phcpoData)
	d SplitMulitData144(drugform,,.drugformData)
	d SplitMulitData144(oeorder,,.oeorderData)
	d SplitMulitData144(admtype,,.admtypeData)
	d SplitMulitData144(ordertype,,.ordertypeData)
	d SplitMulitData144(hospid,,.hospidData)
	;d SplitMulitData144(phccat,,.phccatData)
	
	//门诊发药
	s IsAnti="",phDDD="",wlRowid=""
	f date=startDate:1:endDate d
	.s phLoc=0
	.f  s phLoc=$o(^DHCPHDISPi("FYDATE",date,phLoc)) q:phLoc=""  d
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phLoc,phId)) q:phId=""  d
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:(phSub="")  d
	....s oeori=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",5)
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s admId=$p(^OEORD(ord),"^",1)  
	....s PAADMType=$p(^PAADM(admId),"^",2) 
	....s admLoc=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;开单科室
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;q:patdoc'=6119 ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"	
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori)
	....q:phcdf="" 
	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	....s poison=$$Getphcpoid^DHCWLBulidDimDataYGYY001(arcim)	;管制分类
	....//判断管制分类是否为所选管制分类
	....q:(phcpo'="")&&(poison="") 
	....q:(phcpo'="")&&('$d(phcpoData(poison)))
	....s drgform=$$GetDrugForm^DHCWLBulidDimDataYGYY001(arcim)	;剂型
	....//判断剂型是否为所选剂型
	....q:(drugform'="")&&(drgform="") 
	....q:(drugform'="")&&('$d(drugformData(drgform)))
	....s mOEOrdCat=$$GetOEOrderType^DHCWLBulidDimDataYGYY001(arcim)	;医嘱子类
	....//判断医嘱子类是否为所选子类
	....q:(oeorder'="")&&(mOEOrdCat="") 
	....q:(oeorder'="")&&('$d(oeorderData(mOEOrdCat)))
	....s admType=$p(^PAADM(admId),"^",2)	;就诊类型
	....//判断就诊类型是否为所选类型
	....q:(admtype'="")&&(admType="") 
	....q:(admtype'="")&&('$d(admtypeData(admType)))
	....//判断药品是否为所选药品
	....s drgName=$p(^PHCD(+phcdf,1),"^",2)
	....s drgName=$TR(drgName,"[","(")
	....s drgName=$TR(drgName,"]",")")
	....s drgName=$TR(drgName,"%","÷")
	....q:(drugname'="")&&(drugname'=drgName)
	....;s cat=$$GetPharma^DHCWLBulidDimDataYGYY001(arcim)	;药学大类
	....;//判断药学大类是否为所选药学大类
	....;q:(phccat'="")&&(cat="") 
	....;q:(phccat'="")&&('$d(phccatData(cat)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc="") 
	....q:(dept'="")&&('$d(deptData(admLoc)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	....s price=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",3) ;发药金额
	....s qty=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",4) ;发药数量
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0 s phDDD=0 
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)'=0 s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf)
   	....i +phDDD'=0 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzDDD"))+$num(qty/$g(phDDD),4)	;抗菌DDDs
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzQty"))+qty ;数量
    ....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admId,+phcdf,"mzFee"))+price ;金额
   
    //门诊退药
    f date1=startDate:1:endDate d
	.s phLoc1=0,wlRowid=""
	.f  s phLoc1=$o(^DHCPHRETi(date1,phLoc1)) q:phLoc1=""  d
	..s phrId1=0
	..f  s phrId1=$o(^DHCPHRETi(date1,phLoc1,phrId1)) q:phrId1=""  d
	...s phId1=$p(^DHCPHRET(phrId1),"^",6)
	...s phrItem1=""
	...f  s phrItem1=$o(^DHCPHRTI(phrId1,"RTI",phrItem1)) q:phrItem1=""  d
	....s oeori1=$p(^DHCPHRTI(phrId1,"RTI",phrItem1),"^",2)
	....s ord=+oeori1
	....s ordSub=$p(oeori1,"||",2)
	....s admId1=$p(^OEORD(ord),"^",1)  ;20130312 add
	....s PAADMType=$p(^PAADM(admId1),"^",2) ;20130312 add
	....s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;patdoc'=6119 ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"
	....s phcdf1=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori1)	q:phcdf1=""
	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	....s poison=$$Getphcpoid^DHCWLBulidDimDataYGYY001(arcim)	;管制分类
	....//判断管制分类是否为所选管制分类
	....q:(phcpo'="")&&(poison="") 
	....q:(phcpo'="")&&('$d(phcpoData(poison)))
	....s drgform=$$GetDrugForm^DHCWLBulidDimDataYGYY001(arcim)	;剂型
	....//判断剂型是否为所选剂型
	....q:(drugform'="")&&(drgform="") 
	....q:(drugform'="")&&('$d(drugformData(drgform)))
	....q:(drugform'="")&&('$d(drugIdData(drgform)))
	....s mOEOrdCat=$$GetOEOrderType^DHCWLBulidDimDataYGYY001(arcim)	;医嘱子类
	....//判断医嘱子类是否为所选子类
	....q:(oeorder'="")&&(mOEOrdCat="") 
	....q:(oeorder'="")&&('$d(oeorderData(mOEOrdCat)))
	....s admType=$p(^PAADM(admId1),"^",2)	;就诊类型
	....//判断就诊类型是否为所选类型
	....q:(admtype'="")&&(admType="") 
	....q:(admtype'="")&&('$d(admtypeData(admType)))
	....//判断药品是否为所选药品
	....s drgName=$p(^PHCD(+phcdf1,1),"^",2)
	....q:(drugname'="")&&(drugname'=drgName)
	....s drgName=$TR(drgName,"[","(")
	....s drgName=$TR(drgName,"]",")")
	....s drgName=$TR(drgName,"%","÷")
	....;s cat=$$GetPharma^DHCWLBulidDimDataYGYY001(arcim)	;药学大类
	....;//判断药学大类是否为所选药学大类
	....;q:(phccat'="")&&(cat="") 
	....;q:(phccat'="")&&('$d(phccatData(cat)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc1="") 
	....q:(dept'="")&&('$d(deptData(admLoc1)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc1)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	....s price1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1)  ;退药金额
	....s qty1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)  ;退药数量
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)=0 s phDDD=0 
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf1)'=0 s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf1) 
	....i +phDDD'=0 s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzDDD"))-$num(qty1/$g(phDDD1),4)
	....s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzFee"))-price1	;金额
	....s ^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc1,patdoc,admId1,+phcdf1,"mzQty"))-qty1  ;数量

	//住院发药
	f date=startDate:1:endDate d
	.s phaLoacId=0
	.f  s phaLoacId=$o(^DHCPHAC(0,"PHA",phaLoacId)) q:phaLoacId=""  d
	..s phaId=0
	..s admLoc="",wlRowid=""
	..f  s phaId=$o(^DHCPHAC(0,"PHA",phaLoacId,"DATE",date,phaId)) q:phaId=""  d
	...s phaSubId=0
	...f  s phaSubId=$o(^DHCPHAC(phaId,"I",phaSubId)) q:phaSubId=""  d
	....s oeori=$p(^DHCPHAC(phaId,"I",phaSubId),"^",7)  
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2) 
	....s admid=$p(^OEORD(ord),"^",1) 
	....s oeordtype=$p(^OEORD(ord,"I",ordSub,1),"^",8)
	....s OrdType=$$GetOrdType^DHCWLBulidDimDataYGYY001(oeordtype)
	....//判断是否为出院带药
	....q:(ordertype'="")&&(OrdType="")
	....q:(ordertype'="")&&('$d(ordertypeData(OrdType)))
	....s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;开单医师 ;2013-01-21 lxc
	....i patdoc="" s patdoc="999999"
	....s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori) q:phcdf=""
	....s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	....i admLoc1'="" s admLoc=admLoc1   ;2012-11-22 lxc
	....i admLoc1="" s admLoc=$$GetAdmLocByOeoriAdm^DHCWLBuildKPICommon(oeori)  ;2012-11-22 lxc
	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	....s poison=$$Getphcpoid^DHCWLBulidDimDataYGYY001(arcim)	;管制分类
	....//判断管制分类是否为所选管制分类
	....q:(phcpo'="")&&(poison="") 
	....q:(phcpo'="")&&('$d(phcpoData(poison)))
	....s drgform=$$GetDrugForm^DHCWLBulidDimDataYGYY001(arcim)	;剂型
	....//判断剂型是否为所选剂型
	....q:(drugform'="")&&(drgform="") 
	....q:(drugform'="")&&('$d(drugformData(drgform)))
	....s mOEOrdCat=$$GetOEOrderType^DHCWLBulidDimDataYGYY001(arcim)	;医嘱子类
	....//判断医嘱子类是否为所选子类
	....q:(oeorder'="")&&(mOEOrdCat="") 
	....q:(oeorder'="")&&('$d(oeorderData(mOEOrdCat)))
	....s admType=$p(^PAADM(admid),"^",2)	;就诊类型
	....//判断就诊类型是否为所选类型
	....q:(admtype'="")&&(admType="") 
	....q:(admtype'="")&&('$d(admtypeData(admType)))
	....//判断药品是否为所选药品
	....s drgName=$p(^PHCD(+phcdf,1),"^",2)
	....s drgName=$TR(drgName,"[","(")
	....s drgName=$TR(drgName,"]",")")
	....s drgName=$TR(drgName,"%","÷")
	....q:(drugname'="")&&(drugname'=drgName)
	....;s cat=$$GetPharma^DHCWLBulidDimDataYGYY001(arcim)	;药学大类
	....;//判断药学大类是否为所选药学大类
	....;q:(phccat'="")&&(cat="") 
	....;q:(phccat'="")&&('$d(phccatData(cat)))
 	....//判断科室是否为所选科室
	....q:(dept'="")&&(admLoc="") 
	....q:(dept'="")&&('$d(deptData(admLoc)))
	....//判断医师是否为所选医师
	....q:(doc'="")&&(patdoc="") 
	....q:(doc'="")&&('$d(docData(patdoc)))
	....//判断医院是否为所选医院
	....s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	....i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	....q:(hospid'="")&&(hosp="") 
	....q:(hospid'="")&&('$d(hospidData(hosp)))
	....i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ....i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	....s qty=$p(^DHCPHAC(phaId,"I",phaSubId),"^",6) q:qty=0 
	....s unitPrice=$p(^DHCPHAC(phaId,"I",phaSubId),"^",9) q:unitPrice=0
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0 s phDDD=0 
    ....i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)'=0 s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf) 
   	....i +phDDD'=0 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD"))+$num(qty/$g(phDDD),4)   ;抗菌药DDD
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee"))+$num(qty*unitPrice,2) ;金额
	....s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty"))+qty ;数量

    //住院退药
    f date=startDate:1:endDate d
	.s phaRetId=0
	.f  s phaRetId=$o(^PHARET(0,"DATE",date,phaRetId)) q:phaRetId=""  d
	..s phaRetIdsub="" f  s phaRetIdsub=$o(^PHARET(phaRetId,"I",phaRetIdsub)) q:phaRetIdsub=""  d
	...s oeori1=$p(^PHARET(phaRetId,"I",phaRetIdsub),"^",1)
	...s ord=+oeori1
	...s ordSub=$p(oeori1,"||",2)
	...s admid=$p(^OEORD(ord),"^",1)
	...s oeordtype=$p(^OEORD(ord,"I",ordSub,1),"^",8)
	...s OrdType=$$GetOrdType^DHCWLBulidDimDataYGYY001(oeordtype)
	...//判断是否为出院带药
	...q:(ordertype'="")&&(OrdType="")
	...q:(ordertype'="")&&('$d(ordertypeData(OrdType)))
	...s patdoc=$$GetPatDocByOeori^DHCWLBuildKPICommon(ord,ordSub) ;开单医师 ;2013-01-21 lxc
	...i patdoc="" s patdoc="999999"
	...s phcdf=$$GetPHCDFByOeori^DHCWLBuildKPICommon(oeori1) ;q:+phcdf'=1713
	...s admLoc1=$$GetAdmLocByOeori^DHCWLBuildKPICommon(ord,ordSub)
	...i admLoc1'="" s admLoc=admLoc1   ;2012-11-22 lxc
	...i admLoc1="" s admLoc=$$GetAdmLocByOeoriAdm^DHCWLBuildKPICommon(oeori1)  ;2012-11-22 lxc
	...s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	...s poison=$$Getphcpoid^DHCWLBulidDimDataYGYY001(arcim)	;管制分类
	...//判断管制分类是否为所选管制分类
	...q:(phcpo'="")&&(poison="") 
	...q:(phcpo'="")&&('$d(phcpoData(poison)))
	...s drgform=$$GetDrugForm^DHCWLBulidDimDataYGYY001(arcim)	;剂型
	...//判断剂型是否为所选剂型
	...q:(drugform'="")&&(drgform="") 
	...q:(drugform'="")&&('$d(drugformData(drgform)))
	...s mOEOrdCat=$$GetOEOrderType^DHCWLBulidDimDataYGYY001(arcim)	;医嘱子类
	...//判断医嘱子类是否为所选子类
	...q:(oeorder'="")&&(mOEOrdCat="") 
	...q:(oeorder'="")&&('$d(oeorderData(mOEOrdCat)))
	...s admType=$p(^PAADM(admid),"^",2)	;就诊类型
	...//判断就诊类型是否为所选类型
	...q:(admtype'="")&&(admType="") 
	...q:(admtype'="")&&('$d(admtypeData(admType)))
	...//判断药品是否为所选药品
	...s drgName=$p(^PHCD(+phcdf,1),"^",2)
	...s drgName=$TR(drgName,"[","(")
	...s drgName=$TR(drgName,"]",")")
	...s drgName=$TR(drgName,"%","÷")
	...q:(drugname'="")&&(drugname'=drgName)
	...;s cat=$$GetPharma^DHCWLBulidDimDataYGYY001(arcim)	;药学大类
	...;//判断药学大类是否为所选药学大类
	...;q:(phccat'="")&&(cat="") 
	...;q:(phccat'="")&&('$d(phccatData(cat)))
 	...//判断科室是否为所选科室
	...q:(dept'="")&&(admLoc="") 
	...q:(dept'="")&&('$d(deptData(admLoc)))
	...//判断医师是否为所选医师
	...q:(doc'="")&&(patdoc="") 
	...q:(doc'="")&&('$d(docData(patdoc)))
	...//判断医院是否为所选医院
	...s hosp=$P($G(^CTLOC(admLoc)),"^",22)
	...i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	...q:(hospid'="")&&(hosp="") 
	...q:(hospid'="")&&('$d(hospidData(hosp)))
	...i ((hospid="") || ($p(hospid,",",2)'="")) s hospna="全院"
    ...i ((hospid'="") && ($p(hospid,",",2)="")) s hospna=$P($G(^CT("HOSP",hospid)),"^",2)   
	...i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0 s phDDD=0 
    ...i $$IsAntiDrg^DHCWLBuildKPICommon(phcdf)'=0 s phDDD=$$GetDDD^DHCWLBuildKPICommon(phcdf) 
	...s qty=$p(^PHARET(phaRetId,"I",phaRetIdsub),"^",2)
	...i qty="" s qty=0
	...s fee=$p(^PHARET(phaRetId,"I",phaRetIdsub),"^",5) 
	...i fee="" s fee=0
 	...i +phDDD'=0 s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyDDD"))-$num(qty/$g(phDDD),4) ;抗菌DDDs
    ...s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyFee"))-fee	;金额
    ...s ^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty")=$g(^TEMPDHCWLDATA("S",$j,admLoc,patdoc,admid,+phcdf,"zyQty"))-qty ;数量
	
	s (mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)=0  
    s loc="" f  s loc=$o(^TEMPDHCWLDATA("S",$j,loc))  q:loc=""  d 
    .s docid="" f  s docid=$o(^TEMPDHCWLDATA("S",$j,loc,docid))  q:docid=""  d
    ..s adm="" f  s adm=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm))  q:adm=""  d 	
    ...s phcdf="" f  s phcdf=$o(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf))  q:phcdf=""  d
    ....s mzqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzQty")) 
    ....s mzje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzFee"))
    ....s mzddd=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"mzDDD"))
    ....s zyqty=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyQty"))
    ....s zyje=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyFee")) 
    ....s zyddd=$g(^TEMPDHCWLDATA("S",$j,loc,docid,adm,phcdf,"zyDDD"))
    ....s qyqty=mzqty+zyqty  
    ....s qyje=mzje+zyje
    ....s qyddd=mzddd+zyddd 
    ....d OutPutRow144
	
 	k ^TEMPDHCWLDATA("S",$j)
 	
	Quit $$$OK
	
OutPutRow144
 i $d(^CTLOC(loc))  d  
    .s locDesc1=$P($G(^CTLOC(loc)),"^",2)  
    .i locDesc1 [ "-" s locDesc=$p(locDesc1,"-",2)
    .e  s locDesc=locDesc1
    
    i ((docid'="") && ($d(^CTPCP(docid)))) s doccode=$p(^CTPCP(docid,1),"^",1),docname=$p(^CTPCP(docid,1),"^",2)
    e  s doccode="Null",docname="Null"
   
    s papmidr=$p(^PAADM(adm),"^",1)
    s cPAPMIName=$$GetPapmiName^DHCWLCommon(papmidr)
    s admtype=$p(^PAADM(adm),"^",2)
    s papmiNo=$p(^PAPER(papmidr,"PAT",1),"^",1)		   //登记号  2013-04-13  zyb  add
 	s medicareNo=$$GetPapmiMedtare^DHCWLCommon(papmidr) //通过PA_PatMas.PAPMI_RowId得到病人病案号
   	s admDate=$p(^PAADM(adm),"^",6)   //西丽增加就诊日期    zyb 2015-01-14
    s drugDesc=$p(^PHCD(phcdf,1),"^",2)   
	s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
	
	s Data=$lb(loc,locDesc,docid,doccode,docname,adm,admtype,cPAPMIName,$zd(admDate,3),papmiNo,medicareNo,phcdf,drugDesc,unitdesc,Guig,mzqty,mzje,mzddd,zyqty,zyje,zyddd,qyqty,qyje,qyddd)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
	

SplitMulitData144(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDepDocPatMXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDocPatMXExecute ]
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

ClassMethod GetDepDocPatMXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDocPatMXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepDocPatMX(startDate As %String, endDate As %String, dept As %String, doc As %String, phcpo As %String, drugform As %String, ordertype As %String, admtype As %String, drugname As %String, oeorder As %String, hospid As %String) As %Query(ROWSPEC = "loc:%String,locDesc:%String,docid:%String,doccode:%String,docname:%String,adm:%String,admtype:%String,cPAPMIName:%String,admDate:%String,papmiNo:%String,medicareNo:%String,phcdf:%String,drugDesc:%String,unitdesc:%String,Guig:%String,mzqty:%Float,mzje:%Float,mzddd:%Float,zyqty:%Float,zyje:%Float,zyddd:%Float,qyqty:%Float,qyje:%Float,qyddd:%Float") [ SqlProc ]
{
}

}
