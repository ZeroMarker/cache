/// Creator：		chenyi
/// CreatDate： 	2014-10-20
/// Description：	出入转2.0明细表query、及其需要使用的类方法
Class DHCWL.MRIPDay.MRIPDayDetailQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：		chenyi
/// CreatDate： 	2014-10-20
/// Description：	出入转明细表query
/// Table： 		Rpt、RptItem、	
/// Input： 		startDate：开始日期, endDate：结束日期, rptCode主报表code, dimId：出入转的归集条件Id, itemId：统计项Id, filterStr：业务类型
/// Output：		type：类型：locDesc：科室（病区）描述,admId：就诊号,colStr：明细统计项串
/// Return： 		
/// Others： 		dimID="" && itemId=""，表示返回默认报表配置；
/// 					dimID'="" && itemId'="" 表示返回（与dimID相关的）指定科室或病区且itemId所对应的业务类型（包括：入院，在院，出院，病重，退院，病危，转入，转出）报表
/// 					dimID'="" && (itemId="" || itemId所对应的业务类型是"other") 表示表示返回（与dimID相关的）指定科室或病区的默认报表
/// d ##class(%ResultSet).RunQuery("DHCWL.MRIPDay.MRIPDayDetailQuery","QueryMRIPIOTDetail","2013-10-01","KSCRZ","","","")
Query QueryMRIPIOTDetail(startDate As %String, endDate As %String, rptCode As %String, dimId As %String, itemId As %String, filterStr As %String) As %Query(ROWSPEC = "type:%String,locDesc:%String,admId:%String,col1:%String,col2:%String,col3:%String,col4:%String,col5:%String,col6:%String ,col7:%String ,col8:%String,col9:%String,col10:%String,col11:%String,col12:%String,col13:%String,col14:%String,col15:%String ") [ SqlProc ]
{
}

ClassMethod QueryMRIPIOTDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, rptCode As %String, dimId As %String, itemId As %String, filterStr As %String) As %Status
{
 	n (qHandle,startDate,endDate,rptCode,dimId,itemId,filterStr)
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i ($g(rptCode)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
 	s sd=$zdh(startDate,3)
 	s ed=$zdh(endDate,3)
 	i sd>ed Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	
	s aryTypeDesc("RYRS")="入院"
	s aryTypeDesc("ZYRS")="在院"
	s aryTypeDesc("ZRKS")="转入"
	s aryTypeDesc("ZCKS")="转出"
	s aryTypeDesc("CYRS")="出院"
	s aryTypeDesc("SWRS")="死亡"
	s aryTypeDesc("TYRS")="退院"
	s aryTypeDesc("BZRS")="病重"
	s aryTypeDesc("BWRS")="病危"
	s aryTypeDesc("BEDRS")="在床"
	s aryTypeDesc("HLRS1")="一级护理人数"
	s aryTypeDesc("HLRS2")="二级护理人数"
	s aryTypeDesc("HLRS3")="三级护理人数"
	s aryTypeDesc("TJHLRS")="特级护理人数"
	s aryTypeDesc("DQJ")="大抢救"
	s aryTypeDesc("ZQJ")="中抢救"
	s aryTypeDesc("XQJ")="小抢救"
 	s sDate=$zdh(startDate,3)
 	s eDate=$zdh(endDate,3)
 	
 	k ^TEMPDHCWL($j)
 	
 	s rptId=$o(^DHCWL.MRIPDay.RptI("RptCodeIndex",rptCode,""))		;获取报表ID
 	s rptType=$li(^DHCWL.MRIPDay.RptD(rptId),6)						;报表类型
	;b
	//1、获取明细报表ID
 	i $g(itemId)="" d		
 	.s rptDetailId=$o(^DHCWL.MRIPDay.DetailRptI("RptOPTLItem",rptId,-100000000000000,"")) //默认明细报表ID
 	e  d
 	.s rptDetailId=$o(^DHCWL.MRIPDay.DetailRptI("RptOPTLItem",rptId,itemId,""))  	//关联明细统计表ID
	.i $g(rptDetailId)="" d
	..s rptDetailId=$o(^DHCWL.MRIPDay.DetailRptI("RptOPTLItem",rptId,-100000000000000,"")) //没有找到关联的，就取默认的
	
	Quit:$g(rptDetailId)="" $$$OK
 	
 	s detailItemStr=$li(^DHCWL.MRIPDay.DetailRptD(rptDetailId),6)					;明细统计项串
 	
 	//2、做明细表表头
 	s title=""										//这个地方要初始化，否则在润乾调用这段代码时，title还保留了上次的值。
 	f i=1:1:$l(detailItemStr,",") d
	.s detailItemId=$p(detailItemStr,",",i)
	.s detailItemDesc=$li(^DHCWL.MRIPDay.OPTLDetailItemD(detailItemId),3)
	.i $g(title)="" s title=detailItemDesc
	.e  s title=$g(title)_","_detailItemDesc
	s type="类型",locDesc="归组条件",admId="就诊号",colStr=title
 	d OutRow
 
 	
 	//3、获取业务类型及时间敏感区间的对应关系
 	s sc=##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetTypeAndDateSec(rptId, itemId, .data)
 	i sc=0 W !,"ERROR:获取业务类型、时间区间错误！"
 	q:sc=0 $$$OK
 	
 	//起止区间
 	i $d(data("StartToEnd")) {
	 	s type="",locDesc="",admId=""
 		f date=sDate:1:eDate d
		.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
		..s mrLoc=""
		..s mrWard=""
		..s mrLoc=$p(^MRIPdaily(mrId),"^",7) //科室
		..s mrWard=$p(^MRIPdaily(mrId),"^",19)   //病区
		..q:($g(mrLoc)="")&&(rptType="CTLOC")
		..q:($g(mrWard)="")&&(rptType="WARD")
		..i $g(mrLoc)'="" d
		...s locDesc=$p(^CTLOC(mrLoc),"^",2)
		...i locDesc["-" s locDesc=$p(locDesc,"-",2)
		..i $g(mrWard)'="" d
		...s locDesc=$p(^PAWARD(mrWard),"^",2)
		..i $g(mrLoc)'="" s mDimId=mrLoc
		..e  s mDimId=mrWard
		..q:($g(dimId)'="")&&(dimId'=mDimId)
		..s rowid=0 f  s rowid=$o(^DHCMRIPDetail(0,"IPDay",mrId,rowid)) q:rowid=""  d
		...s admId=$p(^DHCMRIPDetail(rowid),"^",1)
 		...s type=$p(^DHCMRIPDetail(rowid),"^",2)
 		...q:'$d(data("StartToEnd",type))
 		...s colStr=##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetDimProStr(rowid, detailItemStr)
  		...q:$g(colStr)=""
 		...s type=aryTypeDesc(type)
  		...d OutRow
 	
 	}
 	
 	//开始区间
 	i $d(data("Start")) {
	 	s type="",locDesc="",admId=""
		s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",sDate,mrId)) q:mrId=""  d
		.s mrLoc=""
		.s mrWard=""
		.s mrLoc=$p(^MRIPdaily(mrId),"^",7) //科室
		.s mrWard=$p(^MRIPdaily(mrId),"^",19)   //病区
		.q:($g(mrLoc)="")&&(rptType="CTLOC")
		.q:($g(mrWard)="")&&(rptType="WARD")
		.i $g(mrLoc)'="" d
		..s locDesc=$p(^CTLOC(mrLoc),"^",2)
		..i locDesc["-" s locDesc=$p(locDesc,"-",2)
		.i $g(mrWard)'="" d
		..s locDesc=$p(^PAWARD(mrWard),"^",2)
		.i $g(mrLoc)'="" s mDimId=mrLoc
		.e  s mDimId=mrWard
		.q:($g(dimId)'="")&&(dimId'=mDimId)
		.s rowid=0 f  s rowid=$o(^DHCMRIPDetail(0,"IPDay",mrId,rowid)) q:rowid=""  d
		..s admId=$p(^DHCMRIPDetail(rowid),"^",1)
 		..s type=$p(^DHCMRIPDetail(rowid),"^",2)
 		..q:'$d(data("Start",type))
 		..s colStr=##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetDimProStr(rowid, detailItemStr)
 		..q:$g(colStr)=""
 		..s type=aryTypeDesc(type)
  		..d OutRow				
 	}
 	
 	//结束区间
 	i $d(data("End")) {
	 	s type="",locDesc="",admId=""
		s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",eDate,mrId)) q:mrId=""  d
		.s mrLoc=""
		.s mrWard=""
		.s mrLoc=$p(^MRIPdaily(mrId),"^",7) //科室
		.s mrWard=$p(^MRIPdaily(mrId),"^",19)   //病区
		.q:($g(mrLoc)="")&&(rptType="CTLOC")
		.q:($g(mrWard)="")&&(rptType="WARD")
		.i $g(mrLoc)'="" d
		..s locDesc=$p(^CTLOC(mrLoc),"^",2)
		..i locDesc["-" s locDesc=$p(locDesc,"-",2)
		.i $g(mrWard)'="" d
		..s locDesc=$p(^PAWARD(mrWard),"^",2)
		.i $g(mrLoc)'="" s mDimId=mrLoc
		.e  s mDimId=mrWard
		.q:($g(dimId)'="")&&(dimId'=mDimId)
		.s rowid=0 f  s rowid=$o(^DHCMRIPDetail(0,"IPDay",mrId,rowid)) q:rowid=""  d
		..s admId=$p(^DHCMRIPDetail(rowid),"^",1)
 		..s type=$p(^DHCMRIPDetail(rowid),"^",2)
 		..q:'$d(data("End",type))
 		..s colStr=##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetDimProStr(rowid, detailItemStr)
 		..q:$g(colStr)=""
 		..s type=aryTypeDesc(type)
 		..d OutRow				
 	}
	 
 	Quit $$$OK

	
OutRow
	s DataSub=$lb(type,locDesc,admId)		;type,locDesc,admId：固定输出，colStr：维度属性输出、个数不定
   	s Data=$$MergeList(DataSub,3,colStr)
   	/*调试用
   	s testcnt=$o(^TEMPDHCWL("wztest",""),-1)
   	s testcnt=+$G(testcnt)+1
   	s ^TEMPDHCWL("wztest",testcnt)=Data
   	*/
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	//chenyi
	//将一个字符串融合进一个list中
MergeList(list,listStart,str)
	s listLen=$l(str,",")
	f listIndex=1:1:listLen {
		s $li(list,listIndex+listStart)=$p(str,",",listIndex)
	}
	q list
}

ClassMethod QueryMRIPIOTDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRIPIOTDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRIPIOTDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRIPIOTDetailExecute ]
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
/// CreatDate：    	2014-10-20
/// Description:：	根据传入的统计项id和报表id，确定业务类型和时间区间，将其以输出的形式返回
/// Table：       	Rpt、RptItem、OPTLItem、KPIItem
/// Input：       	rptId：主报表ID，itemId：被点击的统计项id
/// Output：      	data
/// Return：      	num:统计项数量
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetTypeAndDateSec(rptId, itemId, .data)
ClassMethod GetTypeAndDateSec(rptId, itemId, ByRef data) As %String
{
	n (rptId, itemId, data)
	K data		//这个地方要K，否则在润乾调用这段代码时，data还保留了上次的值。
	s num=0
	s rptType=$li(^DHCWL.MRIPDay.RptD(rptId),6)						;报表类型
	i $g(itemId)'="" d
	.s kpiItemRowId="" f  s kpiItemRowId=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemDRIndex",itemId,kpiItemRowId)) q:(kpiItemRowId="")||(num'=0)  d
	..s kpiType=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),5)		;指标统计项类型
	..q:kpiType'=rptType
	..s detailType=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),7)		;业务类型
	..s dateSec=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),8)		;时间区间
	..i dateSec="begin" s data("Start",detailType)=dateSec
	..i dateSec="all" s data("StartToEnd",detailType)=dateSec
	..i dateSec="end" s data("End",detailType)=dateSec
	..s num=num+1
	e  d
	.s rptItemRowId="" f  s rptItemRowId=$o(^DHCWL.MRIPDay.RptItemI("RptItemRptDRIndex",rptId,rptItemRowId)) q:rptItemRowId=""  d
	..s mOPTLitemId=$li(^DHCWL.MRIPDay.RptItemD(rptItemRowId),5)
	..s mOPTLItemType=$li(^DHCWL.MRIPDay.OPTLItemD(mOPTLitemId),4)
	..q:mOPTLItemType'="KPIItem"									;只有指标类型的统计项
	..s kpiItemRowId="" f  s kpiItemRowId=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemDRIndex",mOPTLitemId,kpiItemRowId)) q:kpiItemRowId=""  d
	...s kpiType=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),5)		;指标统计项类型
	...q:kpiType'=rptType
	...s detailType=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),7)	;业务类型
	...s dateSec=$li(^DHCWL.MRIPDay.KPIItemD(kpiItemRowId),8)		;时间区间
	...i dateSec="begin" s data("Start",detailType)=dateSec
	...i dateSec="all" s data("StartToEnd",detailType)=dateSec
	...i dateSec="end" s data("End",detailType)=dateSec
	...s num=num+1
	
	q $g(num)
}

/// Creator：      	chenyi
/// CreatDate：    	2014-10-15
/// Description:：	根据明细统计项串，获取统计项描述串。
/// Table：       	DetailRpt、
/// Input：       	rptId：主报表ID
/// Output：      	^TEMPDHCWL($j)
/// Return：      	num:统计项数量
/// Others：      	d ##class(DHCWL.MRIPDay.MRIPDayDetailQuery).GetDimProStr(detailRowId, detailItemStr)
ClassMethod GetDimProStr(detailRowId, detailItemStr) As %String
{
	n (detailRowId, detailItemStr)
	s deli=","
	f i=1:1:$l(detailItemStr,",") d
	.s detailItemId=$p(detailItemStr,",",i)
	.i $d(^DHCWL.MRIPDay.KPIDetailItemI("KPIDtlItemOPTLDtlItemDRIndex",detailItemId)) d
	..s detailKpiItemId=$o(^DHCWL.MRIPDay.KPIDetailItemI("KPIDtlItemOPTLDtlItemDRIndex",detailItemId,""))   	;指标类明细统计项
	..s dimProId=$li(^DHCWL.MRIPDay.KPIDetailItemD(detailKpiItemId),3)
	.q:$d(^DHCWL.MRIPDay.CustomDetai91D1I("CustomDetailItemOPTLDetailItemDRIndex",detailItemId)) 	;自定义类明细统计项暂未使用 
	.s excCode=$li(^DHCWL.MKPI.DimPropertyD(dimProId),6)
	.s excStr="s col=$$"_excCode_"("_detailRowId_")"
	.x excStr
	.i $g(colStr)="" s colStr=col
	.e  s colStr=colStr_deli_col
	
	q $g(colStr)
}

}
