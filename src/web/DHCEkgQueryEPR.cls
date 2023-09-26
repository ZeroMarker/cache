Class web.DHCEkgQueryEPR Extends %RegisteredObject
{

/// //////////////////////////////////////////////////////////////////////
/// 根据就诊号和起始时间查询病人检查医嘱列表
/// d ##class(%ResultSet).RunQuery("web.DHCEkgQueryEPR","SelectEKGItemListByDate","706","64284","64849")
Query SelectEKGItemListByDate(paadmdr As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "ItemName:%String,OrdCreateDate:%String,OrdCreateTime:%String,OEOrdItemDR:%String,RptRowID:%String,RrtDate:%String,RrtTime:%String")
{
}

ClassMethod SelectEKGItemListByDateExecute(ByRef qHandle As %Binary, paadmdr As %String, StDate As %String, EndDate As %String) As %Status
{
   new $namespace
	//d ##class(%ResultSet).RunQuery("web.DHCEkgQueryEPR","SelectEKGItemListByDate","706","64284","64849")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	i $g(paadmdr)="" Quit $$$OK
 	
 	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
	
	If $g(ind)="" Set ind=1
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ReportRowID="",oeorditemdr=""
	
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",ItemStatus="N",IsIll="N"
	.s resrowid=""
	.q:(itemsub'=+itemsub)
	.q:($d(^OEORD(OrderRowid,"I",itemsub,1))=0)
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.q:$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)'="S"  //去掉非检查项目
	.s OrdCreateDate = $p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.i ((OrdCreateDate<StDate)!(OrdCreateDate>EndDate)) q
	.s OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17)
	.s OrdCreateTime=$zt(OrdCreateTime,2)
	.//modify by niucaicai 2013-05-02 查询并输出下医嘱日期和下医嘱时间 end
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ArcItemDR=$p(^OEORD(OrderRowid,"I",itemsub,"1"),"^",1)
	.s CurrentSpace=$znSpace
	.zn "dhc-ekg-gxyd"	
	.s (reqId,examInfo)=""
	.s reqId=$o(^dbo.tblRequestI("idxExamCode"," "_oeorditemdr,reqId))
	.i (reqId="")!(reqId="0") zn CurrentSpace
	.q:(reqId="")!(reqId="0") 
	.s ReportRowID=$o(^dbo.tblExaminationI("idxRequestID",reqId,ReportRowID))
	.i (ReportRowID'="")&&(ReportRowID'="0") d
	..s examInfo=^dbo.tblExaminationD(ReportRowID)
	..i (examInfo'="") d
	...s statusCode=$listget(examInfo,20,"")
	...i ("15,17"[statusCode) d ;已发布报告
	....s arbiterTime=$listget(examInfo,6,"")
	....i (arbiterTime'="")&&(arbiterTime'["9999") d
	.....s ReportDate=$p(arbiterTime," ",1) 
	.....s ReportTime=$p(arbiterTime," ",2)
	.zn CurrentSpace
	.d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(strOrderName,OrdCreateDate,OrdCreateTime,oeorditemdr,ReportRowID,ReportDate,ReportTime)  //modify by niucaicai 2013-05-02 输出下医嘱日期和下医嘱时间
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectEKGItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		//added on 2010-01-03 by houj -- 解决%XML.DataSet调用自定义查询无法执行Close方法
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectEKGItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据 就诊号 和 检查医嘱rowid 查询结构化检查报告
Query SelectReportByOeordID(OEItemRowID As %String) As %Query(ROWSPEC = "ExamDesc:%String,strResult:%String,strOrderName:%String")
{
}

ClassMethod SelectReportByOeordIDExecute(ByRef qHandle As %Binary, OEItemRowID As %String) As %Status
{
   	new $namespace
	//d ##class(%ResultSet).RunQuery("web.DHCEkgQueryEPR","SelectReportByOeordID","699||140")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
  	Quit:$g(OEItemRowID)="" $$$OK
	
	If $g(ind)="" Set ind=1
	
	s ExamDesc="未回报",strResult="未回报",strOrderName=""
    s CurrentSpace=$znSpace
	zn "dhc-ekg-gxyd"	
	s (reqId,reqInfo,examItemCode,examItemID,examItemInfo,ReportRowID)=""
	s reqId=$o(^dbo.tblRequestI("idxExamCode"," "_OEItemRowID,reqId))
	i (reqId'="")&&(reqId'="0") d
	.s reqInfo=^dbo.tblRequestD(reqId)
	.i (reqInfo'="") d
	..s examItemCode=$listget(reqInfo,10,"")
	..i (examItemCode'="") d
	...s examItemID=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_examItemCode,examItemID))
	...i (examItemID'="")&&(examItemID'="0") d
	....s examItemInfo=^dbo.tblDictExamItemD(examItemID)
	....i (examItemInfo'="") d
	.....s strOrderName=$li(examItemInfo,6)
	.s ReportRowID=$o(^dbo.tblExaminationI("idxRequestID",reqId,ReportRowID))
	.i (ReportRowID'="")&&(ReportRowID'="0") d
	..s examInfo=^dbo.tblExaminationD(ReportRowID)
	..i (examInfo'="") d
	...s statusCode=$listget(examInfo,20,"")
	...i ("15,17"[statusCode) d ;已发布报告
	....s Diagnose=$listget(examInfo,11,"")
	....i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) ;2015-08-13
	....s D=""
	....f i=1:1:$l(Diagnose,$c(10)) d
	.....s tmpD=$p(Diagnose,$c(10),i)
	.....i (tmpD'="") d
	......i (D="") s D=tmpD
	......e  s D=D_","_tmpD
	....s Diagnose=D
	....s ExamDesc=Diagnose
	....s strResult=Diagnose
	zn CurrentSpace
    
   
	Do OutRptInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptInfo
	set Data=$lb(ExamDesc,strResult,strOrderName)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectReportByOeordIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		//added on 2010-01-13 by houj -- 解决%XML.DataSet调用自定义查询无法执行Close方法
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectReportByOeordIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
