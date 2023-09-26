/// Creator：		chenyi
/// CreatDate： 	2014-10-15
/// Description：	出入转2.0主表query、及其需要使用的类方法
Class DHCWL.MRIPDay.MRIPDayQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：		chenyi
/// CreatDate： 	2014-10-15
/// Description：	出入转主表query
/// Table： 		Rpt、RptItem、DimProperty、MKPIDimType
/// Input： 		开始时间 结束时间 配置报表code 
/// Output：		itemId:统计项id, itemDesc:统计项描述,dimId:维度id,dimDesc1:维度属性1,dimDesc2:维度属性2,dimDesc3:维度属性3,
/// 				itemOrder:统计项顺序,filterStr:业务类型,value:值
/// Return： 		
/// Others： 		
/// d ##class(%ResultSet).RunQuery("DHCWL.MRIPDay.MRIPDayQuery","QueryMRIPIOT","2017-11-01","2017-11-01","KSCRZ")
Query QueryMRIPIOT(startDate As %String, endDate As %String, rptCode As %String) As %Query(ROWSPEC = "itemId:%String, itemDesc:%String,dimId:%String,dimDesc1:%String,dimDesc2:%String,dimDesc3:%String,itemOrder:%String,filterStr:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMRIPIOTExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, rptCode As %String) As %Status
{
	n (qHandle,startDate,endDate,rptCode) 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(rptCode)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
 	s sd=$zdh(startDate,3)
 	s ed=$zdh(endDate,3)
 	i sd>ed Set qHandle=$lb(0,repid,0) Quit $$$OK
 	k ^TEMPDHCWL($j)

 	s rptId=$o(^DHCWL.MRIPDay.RptI("RptCodeIndex",rptCode,""))		;获取报表ID
 	s rptDimProCode=$li(^DHCWL.MRIPDay.RptD(rptId),8)				;维度属性code
 	;s rptDimProId=$li(^DHCWL.MRIPDay.RptD(rptId),7)				;维度属性id
 	s rptType=$li(^DHCWL.MRIPDay.RptD(rptId),6)						;报表类型(维度属性code)
 	s rptDimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(rptType,"U"),""))
	
 	d ..GetDimPro(rptDimId,rptDimProCode,.aryDimProID,.aryDimProParam)
 	
 	s rptMMgrCode=$li(^DHCWL.MRIPDay.RptD(rptId),4)					;模块与报表code
 	s rptMMgrCode="root.CRZZBB:"_rptMMgrCode						;约定为："CRZZBB" 2014-10-22根据界面存入的内容修改
 	s sc=..GetOPTLItemInfo(rptId)
 	;i $g(sc)=0 s ^MRIPDay("ERROR",+$h,1)="无统计项或统计项分类出错！"
 	i $g(sc)=0 w !,"ERROR:无统计项或统计项分类出错！"
 	q:$g(sc)=0 $$$OK
 	
 	
 	//将统计项数据保存到约束格式的临时global中:^TEMPDHCWL($j,"MRIPITEM",itemID,dimID)=value
 	//《指标类》
 	;s sc=..GetKPIItemData(startDate,endDate,rptMMgrCode)
 	s sc=..GetKPIItemDataByMMgrCode(startDate,endDate,rptMMgrCode)
 	i $g(sc)'=1 w !,"ERROR:指标类统计项获取数据错误！"
 	
 	//《自定义类》
 	s itemRowId=""
 	f  s itemRowId=$o(^TEMPDHCWL($j,"CustomItem",itemRowId)) q:itemRowId=""  d
 	.s sc=..GetCustomItemData(startDate,endDate,itemRowId)
 	.i $g(sc)'=1 w !,"ERROR:自定义类统计项获取数据错误！"_"统计项ID："_itemRowId
 	

 	//《计算类》
 	s itemRowId=""
 	f  s itemRowId=$o(^TEMPDHCWL($j,"CalItem",itemRowId)) q:itemRowId=""  d
 	.s sc=..GetCalItemData(startDate,endDate,itemRowId,rptType)
 	.i $g(sc)'=1 w !,"ERROR:计算类统计项取数错误！"
 	
 	
 	//输出循环^TEMPDHCWL($j,"MRIPITEM",itemID,dimID)
 	/*
 	s itemId=""
 	f  s itemId=$o(^TEMPDHCWL($j,"MRIPITEM",itemId)) q:itemId=""  d
 	.s rptItemId=$g(^TEMPDHCWL($j,"rptItemId",itemId))				;有统计项Id,取得报表统计项配置ID
 	.q:$g(rptItemId)=""												;未配置的不显示
 	.B:rptItemId=9
 	.s itemDesc=$li(^DHCWL.MRIPDay.RptItemD(rptItemId),3)			;报表配置统计项desc
	.s itemOrder=$li(^DHCWL.MRIPDay.RptItemD(rptItemId),6)			;报表配置统计项顺序
	.s filterStr=""  												;初始化业务类型
	.i $d(^TEMPDHCWL($j,"KPIItem","itemId",itemId)) d
	..s exKpiItemId=$g(^TEMPDHCWL($j,"KPIItem","itemId",itemId))
 	..s filterStr=$li(^DHCWL.MRIPDay.KPIItemD(exKpiItemId),7)		;业务类型，传给明细表使用
 	.s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId)) q:dimId=""  d
 	..s value=+$g(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId))
 	..;q:value=0
 	..s proInx=""
 	..;b
 	..f  s proInx=$o(aryDimProID(proInx)) q:proInx=""  d
 	...s proParam=""
 	...s proDimId=aryDimProID(proInx)
 	...s excCode=$li(^DHCWL.MKPI.DimPropertyD(proDimId),6)
 	...i $d(aryDimProParam(proDimId))=0 s proParam=""
 	...e  s proParam=aryDimProParam(proDimId)
 	...i $g(proParam)'="" s proParam=dimId_"~"_proParam
 	...e  s proParam=dimId
 	...s excString="s dimDesc"_proInx_"=$$"_excCode_"("""_proParam_""")"
 	...x excString
 	..d OutRow
 	.;合计
 	.s dimId="Total"
 	.s dimDesc1="合计",dimDesc2="",dimDesc3=""
 	.s value=+$g(^TEMPDHCWL($j,"MRIPITEM",itemId))
 	.d OutRow
 	*/
 	
 	s itemId=""
 	f  s itemId=$o(^TEMPDHCWL($j,"rptItemId",itemId)) q:itemId=""  d
 	.s rptItemId=$g(^TEMPDHCWL($j,"rptItemId",itemId))
 	.s itemDesc=$li(^DHCWL.MRIPDay.RptItemD(rptItemId),3)			;报表配置统计项desc
	.s itemOrder=$li(^DHCWL.MRIPDay.RptItemD(rptItemId),6)			;报表配置统计项顺序
 	.s filterStr=""  												;初始化业务类型
 	.i $d(^TEMPDHCWL($j,"MRIPITEM",itemId)) d						;有数据
 	..;
	..i $d(^TEMPDHCWL($j,"KPIItem","itemId",itemId)) d
	...s exKpiItemId=$g(^TEMPDHCWL($j,"KPIItem","itemId",itemId))
 	...s filterStr=$li(^DHCWL.MRIPDay.KPIItemD(exKpiItemId),7)		;业务类型，传给明细表使用
 	..s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId)) q:dimId=""  d
 	...s value=+$g(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId))
 	...;q:value=0
 	...s proInx=""
 	...;b
 	...f  s proInx=$o(aryDimProID(proInx)) q:proInx=""  d
 	....s proParam=""
 	....s proDimId=aryDimProID(proInx)
 	....s excCode=$li(^DHCWL.MKPI.DimPropertyD(proDimId),6)
 	....i $d(aryDimProParam(proDimId))=0 s proParam=""
 	....e  s proParam=aryDimProParam(proDimId)
 	....i $g(proParam)'="" s proParam=dimId_"~"_proParam
 	....e  s proParam=dimId
 	....s excString="s dimDesc"_proInx_"=$$"_excCode_"("""_proParam_""")"
 	....x excString
 	...d OutRow
 	..;合计
 	..s dimId="Total"
 	..s dimDesc1="合计",dimDesc2="",dimDesc3=""
 	..s value=+$g(^TEMPDHCWL($j,"MRIPITEM",itemId))
 	..d OutRow 	 	
 	.e  d																	;没数据
 	..s dimId=""
 	..s value=""
 	..d OutRow
 	..s dimId="Total"
 	..s dimDesc1="合计",dimDesc2="",dimDesc3=""
 	..s value=""
 	..d OutRow 	 	


 	k ^TEMPDHCWL($j)
 	Quit $$$OK

	
OutRow
	s Data=$lb(itemId,itemDesc,dimId,$g(dimDesc1),$g(dimDesc2),$g(dimDesc3),itemOrder,$g(filterStr),value)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryMRIPIOTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRIPIOTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRIPIOTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRIPIOTExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/**************************************  类方法  ******************************************************/
/// Creator：      	chenyi
/// CreatDate：    	2014-10-15
/// Description:：	根据主报表ID，获取统计项ID，并将有用信息保存在临时global里面
/// Table：       	Rpt、RptItem、OPTLItem、KPIItem、CustomItem、CalItem
/// Input：       	rptId：主报表ID
/// Output：      	^TEMPDHCWL($j)
/// Return：      	num:统计项数量
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetOPTLItemInfo(rptId)
ClassMethod GetOPTLItemInfo(rptId) As %String
{
	n (rptId)
	;++ by wz.2014-11-2;the following 3 row
	s aryDs("begin")="ds1"
	s aryDs("end")="ds2"
	s aryDs("all")="ds3"
	s num=0
	s rptType=$li(^DHCWL.MRIPDay.RptD(rptId),6)							;报表类型
	s rptItemRowId=""
	f  s rptItemRowId=$o(^DHCWL.MRIPDay.RptItemI("RptItemRptDRIndex",rptId,rptItemRowId)) q:rptItemRowId=""  d
	.s itemId=$li(^DHCWL.MRIPDay.RptItemD(rptItemRowId),5)				;统计项ID
	.s itemType=$li(^DHCWL.MRIPDay.OPTLItemD(itemId),4)					;统计项类型
	.s ^TEMPDHCWL($j,"rptItemId",itemId)=rptItemRowId					;此过程不能反向，故统计项id和报表配置ID需做个关联。由配置报表统计项表的id可以得到统计项ID，反之则不行。
	.
	.;*********************** 指标类 *******************************
	.i $g(itemType)="KPIItem" d					
	..s exKPIRowId="" f  s exKPIRowId=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemDRIndex",itemId,exKPIRowId)) q:exKPIRowId=""  d   
	...s mKPIItemType=$li(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),5)		;指标统计项的类型（科室、病区）
	...q:mKPIItemType'=rptType											;
	...s mKPICode=$li(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),4)			;指标code
	...s ^TEMPDHCWL($j,"KPIItem","itemId",itemId)=exKPIRowId			;报表配置统计项和扩展统计项绑定:方便输出时取业务类型
	...;s ^TEMPDHCWL($j,"KPIItem","KPICode",mKPICode)=itemId			;.--by wz.2014-11-2	;指标code和统计项绑定：指标类型取数，获取统计项id
	...;the following 3 row .++by wz.2014-11-2
	...s dateSec=$lg(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),8)
	...s ds=aryDs(dateSec)
	...s ^TEMPDHCWL($j,"KPIItem","KPICode",mKPICode,ds)=itemId		
	
	.
	.;********************** 自定义类 *******************************
	.i $g(itemType)="CustomItem" d				
	..s exCusRowId="" f  s exCusRowId=$o(^DHCWL.MRIPDay.CustomItemI("CustomItemOPTLItemDRIndex",itemId,exCusRowId)) q:exCusRowId=""  d
	...s mCusItemType=$li(^DHCWL.MRIPDay.CustomItemD(exCusRowId),3)	
	...q:mCusItemType'=rptType
	...s cusFun=$li(^DHCWL.MRIPDay.CustomItemD(exCusRowId),4)
	...s ^TEMPDHCWL($j,"CustomItem",itemId)=cusFun						;保存执行方法code	
	.
	.;********************* 计算类 **********************************
	.i $g(itemType)="CalItem" d					
	..s exCalRowId="" f  s exCalRowId=$o(^DHCWL.MRIPDay.CalItemI("CalItemOPTLItemDRIndex",itemId,exCalRowId)) q:exCalRowId=""  d
	...s calExp=$li(^DHCWL.MRIPDay.CalItemD(exCalRowId),4)
	...s ^TEMPDHCWL($j,"CalItem",itemId)=calExp							;保存计算公式
	...i $d(^DHCWL.MRIPDay.CalItemD(exCalRowId)) s calType=+$li($g(^DHCWL.MRIPDay.CalItemD(exCalRowId)),5)
	...e  s calType=0
	...s ^TEMPDHCWL($j,"CalItemCalType",itemId)=+$g(calType)							;保存计算类型										
	.s num=num+1
	
	q $g(num)
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-15
/// Description:：	获取指标统计项数据
/// 				^TEMPDHCWL($j,"MRIPITEM",itemID,dimID)=value
/// Table：       	
/// Input：       	开始时间、结束时间；flag="rptMMgr"时，表示rptMMgrCode是模块与报表的code串，flag="kpi"时，表示rptMMgrCode是指标code
/// Output：      	^TEMPDHCWL($j)
/// Return：      	1：成功
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetKPIItemData(,,"root.GDJY.JYYZB!YZB!ds1")
/// 				ds1:开始区间，ds2:结束区间，ds3：起止区间
ClassMethod GetKPIItemData(startDate, endDate, rptMMgrCode, flag = "rptMMgr") As %String
{
	n (startDate,endDate,rptMMgrCode,flag)
	k ^TEMPDHCWL($j,"DHCWLXC")
	//《模块与报表》
	if (flag="rptMMgr") {
	//开始区间
		s kpis=""
		s rptMMgrCode1=rptMMgrCode_"!ds1"
		s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(rptMMgrCode1)
 		if ($ISOBJECT(datasetObj)) {
			s kpis=datasetObj.DatasetRuleList
			f i=1:1:$l(kpis,",") d  	;去除过滤规则
			.s mkpi=$p(kpis,",",i)
			.i mkpi[":" s mkpi=$p(mkpi,":",1) 
			.i $g(kpis1)="" s kpis1=mkpi
			.e  s kpis1=kpis1_","_mkpi
		
 		}
		i $g(kpis1)'="" s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(startDate,startDate,kpis1,"ds1") 
	//结束区间
		s kpis=""
		s rptMMgrCode2=rptMMgrCode_"!ds2"
		s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(rptMMgrCode2)
 		if ($ISOBJECT(datasetObj)) {
			s kpis=datasetObj.DatasetRuleList
			f i=1:1:$l(kpis,",") d  	;去除过滤规则
			.s mkpi=$p(kpis,",",i)
			.i mkpi[":" s mkpi=$p(mkpi,":",1) 
			.i $g(kpis2)="" s kpis2=mkpi
			.e  s kpis2=kpis2_","_mkpi
 		}
		i $g(kpis2)'="" s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(endDate,endDate,kpis2,"ds2") 
	//起止区间
		s kpis=""
		s rptMMgrCode3=rptMMgrCode_"!ds3"
		s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(rptMMgrCode3)
 		if ($ISOBJECT(datasetObj)) {
			s kpis=datasetObj.DatasetRuleList
			f i=1:1:$l(kpis,",") d  	;去除过滤规则
			.s mkpi=$p(kpis,",",i)
			.i mkpi[":" s mkpi=$p(mkpi,":",1) 
			.i $g(kpis3)="" s kpis3=mkpi
			.e  s kpis3=kpis3_","_mkpi
 		}
		i $g(kpis3)'="" s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(startDate,endDate,kpis3,"ds3") 
	}
	
	//《单个指标》：计算类公式使用了未配置的指标统计项时，调用该方法，走这里。
	;--by wz.2014-11-2 .the following 4 row
	/*
	i (flag="kpi") {
		b:rptMMgrCode="K0008"
		s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(startDate,endDate,rptMMgrCode)
	}
	*/
	//对以上三个时间区间存入^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,loc)的数据进行汇总
	s monId="",value=0
	f  s monId=$o(^TEMPDHCWL($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s ds="" f  s ds=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId,ds)) q:ds=""  d
	....;s value=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))		;--by wz.2014-11-2
	....s value=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId,ds))
	....s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)					;指标code
	....s itemId=$g(^TEMPDHCWL($j,"KPIItem","KPICode",kpiCode,ds))		;此global来自类方法GetOPTLItemInfo,计算来自计算类调用接口前
   	....;q:$g(value)=0												;值为0的，不计入
   	....s ^TEMPDHCWL($j,"MRIPITEM",itemId,dimId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId))+value
   	....s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId))+value	;合计
	
	k ^TEMPDHCWL($j,"DHCWLXC")
	q 1
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-15
/// Description:：	获取自定义统计项数据
/// 				^TEMPDHCWL($j,"MRIPITEM",itemID,dimID)=value
/// Table：       	
/// Input：       	开始时间，结束时间，统计项id
/// Output：      	^TEMPDHCWL($j)
/// Return：      	1：成功
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetCustomItemData(startDate,endDate,itemId)
ClassMethod GetCustomItemData(startDate, endDate, itemId) As %String
{
	n (startDate,endDate,itemId)
	s startDate=$zdh(startDate,3)
 	s endDate=$zdh(endDate,3)			;日期转换本是放在M函数段里面的，但是在拼引号的过程中，遇到问题
	s cusFun=$g(^TEMPDHCWL($j,"CustomItem",itemId))
 	q:$g(cusFun)="" 0
 	;s exeStr="d "_cusFun_"("_startDate_","_endDate_","_itemId_")"   ;chenyi.2015-06-23 优化自定取数方法代码，所做修改。
 	s exeStr="d "_cusFun_"("_startDate_","_endDate_")"
 	x exeStr
 	
 	s itemCode=$li(^DHCWL.MRIPDay.OPTLItemD(itemId),2)
 	
 	;优化代码：将原先在取数M中完成的工作，放到下面来。add by chenyi。2015-06-23
 	;^TEMPDHCWL($j,"CUSITEM",dimId)=$g(^TEMPDHCWL($j,"CUSITEM",dimId))+1  将取数M的这个global转换成下面的两个global
 	s mDimId=""
 	f  s mDimId=$o(^TEMPDHCWL($j,"CUSITEM",mDimId)) q:mDimId=""  d
 	.s ^TEMPDHCWL($j,"MRIPITEM",itemId,mDimId)=$g(^TEMPDHCWL($j,"CUSITEM",mDimId))
	.i itemCode'="TJSD" s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId))+$g(^TEMPDHCWL($j,"CUSITEM",mDimId))	;合计
 	.e  s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"CUSITEM",mDimId)) //,^cy($j,$h)=$g(^TEMPDHCWL($j,"CUSITEM",mDimId))
	q 1
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-15
/// Description:：	计算类统计项计算模板：根据计算统计项的计算公式，将各维度的该统计项值保存在约定格式的临时global里面：
/// 				^TEMPDHCWL（$j,“MRIPITEM”,itemID,dimID）=value
/// Table：       	
/// Input：       	calFun：计算公式、itemId：统计项id
/// Output：      	^TEMPDHCWL($j)
/// Return：      	1：成功
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetOPTLItemInfo(1,(<code1>+<code2>)/<code3>)
/// 					fun的约定格式为：(<code1>+<code2>)/<code3>
ClassMethod GetCalItemData(startDate, endDate, itemId, rptType) As %String
{
	n (startDate,endDate,itemId,rptType)
	k ^TEMPDHCWL($j,"CallDimId")
	
	s calFun=$g(^TEMPDHCWL($j,"CalItem",itemId))		;calFun:	
 	q:$g(calFun)="" 0
 	s calFunStr=calFun
 	
	s sc=..SplitCalString(calFun,.itemCodeList)
	i sc=0 w !,"ERROR:无计算公式，或格式不对！"
	q:sc'=1 0
	s calItemCode="" f  s calItemCode=$o(itemCodeList(calItemCode)) q:calItemCode=""  d
	.s calItemId=$g(itemCodeList(calItemCode))
	.s calItemId=$o(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",calItemCode,""))
	.i $d(^TEMPDHCWL($j,"MRIPITEM",calItemId))=0 d
	..s itemType=$li(^DHCWL.MRIPDay.OPTLItemD(calItemId),4)					;统计项类型
	..i itemType="KPIItem" d
	...s dateSec=""
	...s exKPIRowId="" f  s exKPIRowId=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemDRIndex",calItemId,exKPIRowId)) q:(exKPIRowId="")||($g(mKPICode)'="")  d   
	....;s dimCode=$li(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),6)			;指标的维度code
	....s mKPIItemType=$li(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),5)		;指标统计项的类型（科室、病区）
	....q:mKPIItemType'=rptType											;类型过滤，获取科室或病区之一
	....s mKPICode=$li(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),4)			;指标code
	....s ^TEMPDHCWL($j,"KPIItem","KPICode",mKPICode)=calItemId
	....s dateSec=$lg(^DHCWL.MRIPDay.KPIItemD(exKPIRowId),8)
	...q:(($g(mKPICode)="")||(dateSec=""))
	...s rtKPI=..GetKPIItemDataByKPICode(startDate,endDate,mKPICode,dateSec)
	...s mKPICode=""
	...i $g(rtKPI)'=1 w !,"ERROR:计算统计项调用指标取数错误！"
	..
	..i itemType="CustomItem" d
	...s customID=$o(^DHCWL.MRIPDay.CustomItemI("CustomItemOPTLItemDRTypeIndex",calItemId,rptType,""))
	...q:$g(customID)=""
	...s cusFun=$lg(^DHCWL.MRIPDay.CustomItemD(customID),4)
	...s ^TEMPDHCWL($j,"CustomItem",calItemId)=cusFun
	...s rtCus=..GetCustomItemData(startDate,endDate,calItemId)
	...i $g(rtCus)'=1 w !,"ERROR:计算统计项调用自定义取数错误！"
	.s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"MRIPITEM",calItemId,dimId)) q:dimId=""  d
	..s ^TEMPDHCWL($j,"CallDimId",dimId,calItemId)=$g(^TEMPDHCWL($j,"MRIPITEM",calItemId,dimId))
	.
	.;合计
	.;s calCode=$li(^DHCWL.MRIPDay.OPTLItemD(calItemId),2)   	;被调用的统计现象code
	.;s pre=$p(calFunStr,calCode,1)
	.;s pre=$e(pre,1,$l(pre)-1)									;截去<
	.;s last=$p(calFunStr,calCode,2)
	.;s last=$e(last,2,$l(last))									;截去>
	.;s calFunStr=pre_$g(^TEMPDHCWL($j,"MRIPITEM",calItemId))_last
	.;s calType=$li(^DHCWL.MRIPDay.CalItemD(exCalRowId),5)
	.s calType=+$g(^TEMPDHCWL($j,"CalItemCalType",itemId))							;保存计算类型
	.i calType=0 d			;合计也按照计算公式来算
	..s calCode=$li(^DHCWL.MRIPDay.OPTLItemD(calItemId),2)  
	..s calCode="<"_calCode_">"
	..s calCodeValue=$g(^TEMPDHCWL($j,"MRIPITEM",calItemId))
	..;s calFunStr=$REPLACE(calFunStr,calCode,calCodeValue)
	..s calFunStr=##class(DHCWL.util.StringUtil).ReplaceStr(calFunStr,calCode,calCodeValue)

	
	s value=..GetFormulaData(calFunStr)  ;chenyichenyi
	//i $g(value)=-1 s value=0									;合计计算错误 ，置为0
	i $g(value)="error" s value=0
	s ^TEMPDHCWL($j,"MRIPITEM",itemId)=value
	
	//将不存在的计算调用global置0
	//添加此循环原因：并不是每个维度的所有调用global都存在，如果缺少一个，在下面的循环中将无法替换code
	s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"CallDimId",dimId)) q:dimId=""  d
	.s calItemCode="" f  s calItemCode=$o(itemCodeList(calItemCode)) q:calItemCode=""  d
	..s calItemId=$g(itemCodeList(calItemCode))
	..i '$d(^TEMPDHCWL($j,"CallDimId",dimId,calItemId)) d
	...s ^TEMPDHCWL($j,"CallDimId",dimId,calItemId)=0

	s dim="" f  s dim=$o(^TEMPDHCWL($j,"CallDimId",dim)) q:dim=""  d
	.s calFunStr=calFun										;每个维度计算之前初始
	.s calId="" f  s calId=$o(^TEMPDHCWL($j,"CallDimId",dim,calId)) q:calId=""  d
	..s calCode=$li(^DHCWL.MRIPDay.OPTLItemD(calId),2)   	;被调用的统计现象code
	..;s pre=$p(calFunStr,calCode,1)
	..;s pre=$e(pre,1,$l(pre)-1)								;截去<
	..;s last=$p(calFunStr,calCode,2)
	..;s last=$e(last,2,$l(last))							;截去>
	..;s calFunStr=pre_$g(^TEMPDHCWL($j,"CallDimId",dim,calId))_last
	..s calCode="<"_calCode_">"
	..s calCodeValue=$g(^TEMPDHCWL($j,"CallDimId",dim,calId))
	..s calFunStr=$REPLACE(calFunStr,calCode,calCodeValue)	
	
	
	.s value=..GetFormulaData(calFunStr)
	.;q:$g(value)=-1
	.q:$g(value)="error"
	.q:+$g(value)=0											;值为0的，不计入
	.s ^TEMPDHCWL($j,"MRIPITEM",itemId,dim)=value
	
	.i calType=1 d		;合计按各科室（病区）汇总算
	..s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId))+value
	
	k ^TEMPDHCWL($j,"CallDimId")
	q 1
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-24
/// Description:：	执行计算公式获取计算值
/// Table：       	
/// Input：       	calFun：计算公式
/// Output：      	data
/// Return：      	-1：表示计算发生错误；
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetFormulaData(calFun)
/// 1.除数为0，发生错误；
ClassMethod GetFormulaData(calFun) As %String
{
	n (calFun)
	q:$g(calFun)="" "error"		
	s $zt="ErrorReturn"
	s excStr="s value="_calFun
	x excStr
	q $g(value)
	
ErrorReturn
	;抓取计算公式取数错误！
	w !,"ERROR:计算公式取数错误"_" 公式："_calFun
	q "error"
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-16
/// Description:：	拆分计算类计算公式串，存在临时数组中。
/// Table：       	
/// Input：       	calString：计算公式
/// Output：      	data
/// Return：      	1：成功
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayQuery).SplitCalString("(<code1>+<code2>)/<code3>",.data)
/// 					fun的约定格式为：(<code1>+<code2>)/<code3>
ClassMethod SplitCalString(calString, ByRef data) As %String
{
	n (calString,data)
	q:$g(calString)="" 0
	f i=1:1:$l(calString,">") d
	.s mStr=$p(calString,">",i)
	.q:$g(mStr)=""
	.s str(i)=mStr
	q:'$d(str) 0
	s calFlag=0
	s j=0 f  s j=$o(str(j)) q:j=""  d
	.s code=$p($g(str(j)),"<",2)
	.i $g(code)'="" d
	..s id=$o(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",code,""))
	..s data(code)=id
	.;2014-10-27 确定为界面上无法使用计算类型配置
	.;s itemType=$li(^DHCWL.MRIPDay.OPTLItemD(id),4)
	.;i $g(itemType)="CalItem" s calFlag=1	;若存在计算类统计项，则标志置为1 2014-10-24界面上无法使用计算类型配置
	;q:calFlag=1 2    						;目前版本不支持计算公式中包含另一个计算类统计项的code
	
	q 1
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-01
/// Description:： 	获取DHCWL.MKPI.DeptKPIData表中科室指标数据
/// Table：       	DHCWL_MKPI.DHCWLMKPIData
/// Input：       	开始时间、结束时间、报表与模块串
/// Output：      	data:返回各科,各指标的指标值,data(monId,monKPIId,loc),monKPIId:指标Id,loc:科室id,monId:区间Id
/// Return：      	retStatus:成功则返回1,执行失败返回0 ;
/// Others：      	根据指标id和区间id获取DHCWL.MKPI.DeptKPIData表中科室指标数据,以Glob形式返回
/// 注释：        	区别于GetMutiMonKPIData,用^Tempdata，因为碰到大数据量，数组会超上限。
/// d ##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ("2013-10-01","2014-10-31","K0008")
ClassMethod GetMutiMonKPIDataForCRZ(startDate, endDate, mKPICodeStr) As %Status
{
	n (startDate, endDate, mKPICodeStr)
	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(mKPICodeStr)
 	if ($ISOBJECT(datasetObj)) {
		 s mKPICodeStr=datasetObj.DatasetRuleList
 	}
 
	s rs=##class(DHCWL.Interface.MkpiData).GetKpiData(startDate,endDate,"",mKPICodeStr)
	

	While rs.Next() {
		//d rs.%Print()
		s dimId=$g(rs.Data("dimId")) 
		s kpiId=$g(rs.Data("kpiId"))
		s value=$g(rs.Data("value"))
		s monId=$g(rs.Data("monthId"))
		//w !,"monID="_monID
		;continue:value=0
		s ^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))+value	
	}
	d rs.Close()
	
	q 1
}

ClassMethod GetKPIItemDataByMMgrCode(startDate, endDate, rptMMgrCode) As %String
{
	n (startDate,endDate,rptMMgrCode)
	//开始区间
	d ..GetKPIItemDataByDs(startDate, startDate, rptMMgrCode,"ds1")
	//结束区间
	d ..GetKPIItemDataByDs(endDate, endDate, rptMMgrCode,"ds2")
	//起止区间
	d ..GetKPIItemDataByDs(startDate, endDate, rptMMgrCode,"ds3")

	q 1
}

ClassMethod GetKPIItemDataByDs(startDate, endDate, DSCode, ds) As %String
{
	n (startDate,endDate,DSCode,ds)
	k ^TEMPDHCWL($j,"DHCWLXC")
	//《模块与报表》
	s kpis=""
	

	s rulerStr=DSCode_":"_ds
	s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(startDate,endDate,rulerStr)
	s monId="",value=0
	f  s monId=$o(^TEMPDHCWL($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s value=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))		;--by wz.2014-11-2
	...s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)					;指标code
	...s itemId=$g(^TEMPDHCWL($j,"KPIItem","KPICode",kpiCode,ds))		;此global来自类方法GetOPTLItemInfo,计算来自计算类调用接口前
   	...q:$g(value)=0	
   	...s ^TEMPDHCWL($j,"MRIPITEM",itemId,dimId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId))+value
   	...s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId))+value	;合计
	k ^TEMPDHCWL($j,"DHCWLXC")
	q 1
}

ClassMethod GetKPIItemDataByKPICode(startDate, endDate, mKPICode, dateSec)
{
	n (startDate,endDate,mKPICode,dateSec)
	k ^TEMPDHCWL($j,"DHCWLXC")
	
	s sDate="",eDate=""
	i dateSec="begin" {
		s sDate=startDate
		s eDate=startDate
	}elseif dateSec="end" {
		s sDate=endDate
		s eDate=endDate	
	}elseif dateSec="all" {
		s sDate=startDate
		s eDate=endDate	
	}
	
	s datasetObj=##class(DHCWL.Interface.Module).GetDatasetObj(mKPICode)
 	if ($ISOBJECT(datasetObj)) {
		 s mKPICode=datasetObj.DatasetRuleList
 	}
	
			
	i $g(mKPICode)'="" s sc=##class(DHCWL.MRIPDay.MRIPDayQuery).GetMutiMonKPIDataForCRZ(sDate,eDate,mKPICode)

	s monId="",value=0
	f  s monId=$o(^TEMPDHCWL($j,"DHCWLXC",monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId)) q:kpiId=""  d
	..s dimId="" f  s dimId=$o(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId)) q:dimId=""  d
	...s value=$g(^TEMPDHCWL($j,"DHCWLXC",monId,kpiId,dimId))		;--by wz.2014-11-2
	...s kpiCode=$li(^DHCWL.MKPI.MKPID(kpiId),2)					;指标code
	...s itemId=$g(^TEMPDHCWL($j,"KPIItem","KPICode",kpiCode))		;此global来自类方法GetOPTLItemInfo,计算来自计算类调用接口前
   	...;q:$g(value)=0												;值为0的，不计入
   	...s ^TEMPDHCWL($j,"MRIPITEM",itemId,dimId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId,dimId))+value
   	...s ^TEMPDHCWL($j,"MRIPITEM",itemId)=$g(^TEMPDHCWL($j,"MRIPITEM",itemId))+value	;合计
	k ^TEMPDHCWL($j,"DHCWLXC")
	q 1
}

ClassMethod GetDimPro(rptDimId, rptDimProCode, ByRef aryDimProID, ByRef aryDimProParam)
{
	n (rptDimId,rptDimProCode,aryDimProID,aryDimProParam)
	s pos=1
	s inx=1
	k aryDimProID
	k aryDimProParam
	
	f {
		s dimProCode=$p(rptDimProCode,";",pos)
		q:$g(dimProCode)=""
		s proParam=$p(dimProCode,"(",2)
		s dimProCode=$p(dimProCode,"(",1)
	 	s proDimId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",rptDimId,$ZCVT(dimProCode,"U"),""))
		s aryDimProID(inx)=proDimId
		

		if $g(proParam)'="" {
			s proParam=$p(proParam,")",1)
			s aryDimProParam(proDimId)=proParam
		}
		s pos=pos+1
		s inx=inx+1
		//b	//w aryDimProID,aryDimProParam
	}
}

/// Creator：		chenyi
/// CreatDate： 	2014-12-01
/// Description：	出入转主表query
/// Table： 		Rpt、RptItem、DimProperty、MKPIDimType
/// Input： 		开始时间 结束时间 配置报表code 
/// Output：		itemId:统计项id, itemDesc:统计项描述,dimId:维度id,dimDesc1:维度属性1,dimDesc2:维度属性2,dimDesc3:维度属性3,
/// 				itemOrder:统计项顺序,filterStr:业务类型,value:值
/// Return： 		
/// Others： 		
/// d ##class(%ResultSet).RunQuery("DHCWL.MRIPDay.MRIPDayQuery","QueryMRIPRptDim","KSCRZ")
Query QueryMRIPRptDim(rptCode As %String) As %Query(ROWSPEC = "dimName1:%String,dimName2:%String,dimName3:%String") [ SqlProc ]
{
}

ClassMethod QueryMRIPRptDimExecute(ByRef qHandle As %Binary, rptCode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1

 	i ($g(rptCode)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
 	k ^TEMPDHCWL($j)
 	b 	//^DHCWL.MRIPDay.RptI
 	s rptRowID=$o(^DHCWL.MRIPDay.RptI("RptCodeIndex",rptCode,""))
 	s rptType=$lg(^DHCWL.MRIPDay.RptD(rptRowID),6)
 	s rptDimProCodes=$lg(^DHCWL.MRIPDay.RptD(rptRowID),8)
 	
 	//^DHCWL.MKPI.MKPIDimTypeI
 	s rptType=$SYSTEM.SQL.ALPHAUP(rptType)
 	s dimRowID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",rptType,""))
 	s len=$l(rptDimProCodes,";")
 	//^DHCWL.MKPI.DimPropertyI
 	s proDesc=""
 	f i=1:1:len d
	.s proCode=$p(rptDimProCodes,";",i)
 	.q:$g(proCode)=""
 	.s proCode=$SYSTEM.SQL.ALPHAUP(proCode)
 	.s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimRowID,proCode,""))
 	.s desc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
 	.s proDesc(i)=desc
 	d OutRow2
 	

 	k ^TEMPDHCWL($j)
 	Quit $$$OK

	
OutRow2
	s Data=$lb($g(proDesc(1)),$g(proDesc(2)),$g(proDesc(3)))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryMRIPRptDimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRIPRptDimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRIPRptDimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRIPRptDimExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
