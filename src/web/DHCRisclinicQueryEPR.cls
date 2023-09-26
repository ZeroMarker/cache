Import SQLUser

Class web.DHCRisclinicQueryEPR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 33582;

/// //////////////////////////////////////////////////////////////////////
/// 以下为电子病历所写的接口
/// 根据就诊号和起始时间查询病人检查医嘱列表
Query SelectPACSItemListByDate(paadmdr As %String, StDate As %String, EndDate As %String, ArcItemDRParm As %String) As %Query(ROWSPEC = "ItemName:%String,OrdCreateDate:%String,OrdCreateTime:%String,OEOrdItemDR:%String,RptRowID:%String,RrtDate:%String,RrtTime:%String,RptURL:%String,ImgURL:%String")
{
}

ClassMethod SelectPACSItemListByDateExecute(ByRef qHandle As %Binary, paadmdr As %String, StDate As %String, EndDate As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryEPR","SelectPACSItemListByDate","8","65003","65011")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	i $g(paadmdr)="" Quit $$$OK
 	
 	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
	
	If $g(ind)="" Set ind=1
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ReportRowID="",oeorditemdr=""
	s (RptURL,ImgURL)=""
	
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
 	
 	s drptdr="" f  s drptdr=$o(^DHCRBStudyi("Report-PAADMDR",paadmdr,drptdr)) q:(drptdr="")  d
	.s (studyNo,oeoRowid)=""
	.s studyNo=$p(^DHCRBStudy("Report",drptdr),"^")
	.q:studyNo=""
	.s reportStatus=$p(^DHCRBStudy("Report",drptdr),"^",4)
	.q:reportStatus'=5   // 没有发布则退出
	.s regdr="" f  s regdr=$o(^DHCPACRegInfoi("StudyNo",studyNo,regdr)) q:(regdr="")  d
	..s perOEORowid=$p(^DHCPACRegInfo(regdr),"^",11)
	..q:perOEORowid=""
	..s OrderRowid=$p(perOEORowid,"||",1)
	..s itemsub=$p(perOEORowid,"||",2)
	..s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	..s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
 	..s OrdCreateDate = $p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	..q:((OrdCreateDate<StDate)!(OrdCreateDate>EndDate))  //不满足时间条件
	..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s OrdCreateDate=$zd(OrdCreateDate,3)
	..s OrdCreateTime=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17)
	..s OrdCreateTime=$zt(OrdCreateTime,2)
	..s ReportRowID=drptdr
	..s ReportDate=$p(^DHCRBStudy("Report",ReportRowID),"^",12)
	..s ReportTime=$p(^DHCRBStudy("Report",ReportRowID),"^",13)
	..i (ReportDate'="")&(ReportTime'="") d
	...s ReportDate=$zd(ReportDate,3)
	...s ReportTime=$zt(ReportTime)
	..e  d
	...s ReportDate=$p(^DHCRBStudy("Report",ReportRowID),"^",9)
	...s ReportTime=$p(^DHCRBStudy("Report",ReportRowID),"^",10)
	...s ReportDate=$zd(ReportDate,3)
	...s ReportTime=$zt(ReportTime)
	..// 检查报告url获取地址由新产品组重新提供
	..// Input: RecLocID:检查科室ID,Params:登记号^检查号^医嘱ID,Model:1(报告)2(图像)
	..s locdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	..s RptURL=##class(web.DHCAPPInterface).GetPacsPortUrl(locdr,RegNo_"^"_studyNo_"^"_perOEORowid,1)
	..s ImgURL=##class(web.DHCAPPInterface).GetPacsPortUrl(locdr,RegNo_"^"_studyNo_"^"_perOEORowid,2)
	..d OutOEItemInfo
 	
	/*s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",ItemStatus="N",IsIll="N"
	.s resrowid=""
	.q:(itemsub'=+itemsub) // 20121025 wangwentao add fixed ^OEORD(633889,"I","152,633889","X",0)
	.q:($d(^OEORD(OrderRowid,"I",itemsub,1))=0) // 20121025 wangwentao add fixed <UNDEFINED>^OEORD(OrderRowid,"I",itemsub,1) 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.q:$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)'="S"  // 20110125 wangwentao add 去掉非检查项目
	.//modify by niucaicai 2013-05-02 查询并输出下医嘱日期和下医嘱时间 start
	.//s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.//i ((Date1<StDate)!(Date1>EndDate)) q
	.//s strDate=$zd(Date1,3)
	.//s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.//s strTime=$zt(Time1)
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
	.//b //ArcItemDR
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s ReportRowID=0
	..s RptRowId=""
	..s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId),-1)  	//<2013-06-08><guozongtao><取最后一次发布的报告ID>
	..s ReportRowID=RptRowId
	..if (RptRowId '= "") d											//<2013-06-08><guozongtao><只有发布的报告才查询出来医嘱信息>                                      	 	
	...s rptStatusDR=$p(^DHCRBStudy("Report",ReportRowID),"^",4)
	...s StatusCode=$p(^DHCRBCStatus("ReportStatus",rptStatusDR),"^",1)
	...i (StatusCode="S") d
	....s ReportDate=$p(^DHCRBStudy("Report",ReportRowID),"^",12)
	....s ReportTime=$p(^DHCRBStudy("Report",ReportRowID),"^",13)
	....i (ReportDate'="")&(ReportTime'="") d
	.....s ReportDate=$zd(ReportDate,3)
	.....s ReportTime=$zt(ReportTime)
	....e  d
	.....s ReportDate=$p(^DHCRBStudy("Report",ReportRowID),"^",9)
	.....s ReportTime=$p(^DHCRBStudy("Report",ReportRowID),"^",10)
	.....s ReportDate=$zd(ReportDate,3)
	.....s ReportTime=$zt(ReportTime)
	....// 检查报告url获取地址由新产品组重新提供
	....// Input: RecLocID:检查科室ID,Params:登记号^检查号^医嘱ID,Model:1(报告)2(图像)
	....s locdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	....s RptURL=##class(web.DHCAPPInterface).GetPacsPortUrl(locdr,RegNo_"^"_StudyNo_"^"_oeorditemdr,1)
	....s ImgURL=##class(web.DHCAPPInterface).GetPacsPortUrl(locdr,RegNo_"^"_StudyNo_"^"_oeorditemdr,2)
	....d OutOEItemInfo
	*/
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(strOrderName,OrdCreateDate,OrdCreateTime,perOEORowid,ReportRowID,ReportDate,ReportTime,RptURL,ImgURL)  //modify by niucaicai 2013-05-02 输出下医嘱日期和下医嘱时间
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPACSItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
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

ClassMethod SelectPACSItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据 就诊号 和 ARCDR 查询病人检查列表
Query SelPACSItemListByARCDR(paadmdr As %String, ArcItemDRParm As %String) As %Query(ROWSPEC = "ItemName:%String,OEOrdItemDR:%String,RptRowID:%String")
{
}

ClassMethod SelPACSItemListByARCDRExecute(ByRef qHandle As %Binary, paadmdr As %String, ArcItemDRParm As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelPACSItemListByARCDR","139","9058||1")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	i $g(paadmdr)="" quit $$$OK
	
	If $g(ind)="" Set ind=1

	s RegNo="",strOrderName="",ReportRowID="",oeorditemdr=""
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s stdDate=0 f  s stdDate=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItemDRParm,stdDate))  q:(stdDate="")  d
	.s itemSub=0 f  s itemSub=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItemDRParm,stdDate,itemSub)) q:(itemSub="")  d
	..s arcimid=$p(^OEORD(OrderRowid,"I",itemSub,1),"^",2)   
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s oeorditemdr=OrderRowid_"||"_itemSub
	..s ReportRowId = 0
	..Do OutOEItemInfo2
	..s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	..i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	..i StudyNo'="" d
	...s ReportRowID=0
	...s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	....s ReportRowID=RptRowId
	....Do OutOEItemInfo2
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo2
	set Data=$lb(strOrderName,oeorditemdr,ReportRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelPACSItemListByARCDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelPACSItemListByARCDRExecute ]
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

ClassMethod SelPACSItemListByARCDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelPACSItemListByARCDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据 就诊号、ARCDR、TypdId 查询结构化检查报告的对应部分
Query SelPACSRptByARCDR(paadmdr As %String, ArcItemDRParm As %String, TypeId As %String) As %Query(ROWSPEC = "ItemName:%String,OEOrdItemDR:%String,RptRowID:%String,RptContent:%String")
{
}

ClassMethod SelPACSRptByARCDRExecute(ByRef qHandle As %Binary, paadmdr As %String, ArcItemDRParm As %String, TypeId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelPACSRptByARCDR","139","10945||1","1")
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	i $g(paadmdr)="" Set qHandle=$lb(0,repid,0)
  	Quit:$g(paadmdr)="" $$$OK

 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s strOrderName="",ReportRowID="",oeorditemdr="",RptContent=""
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s stdDate=0 f  s stdDate=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItemDRParm,stdDate))  q:(stdDate="")  d
	.s itemSub=0 f  s itemSub=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItemDRParm,stdDate,itemSub)) q:(itemSub="")  d
	..s arcimid=$p(^OEORD(OrderRowid,"I",itemSub,1),"^",2)   
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s oeorditemdr=OrderRowid_"||"_itemSub
	..s ReportRowID=0
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report-Oeorditm",oeorditemdr,RptRowId)) q:(RptRowId="")  d
	...s ReportRowID=RptRowId
	...i (TypeId=1)&&($g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "") d
	....s RptContent=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
	....s:(RptContent'="") RptContent = ..ConvertRptContent(RptContent)  //处理协和项目 平台组特殊字符
	...i (TypeId=2)&&($g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "") d
	....s RptContent=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
	....s:(RptContent'="") RptContent = ..ConvertRptContent(RptContent)  //处理协和项目 平台组特殊字符
	...i TypeId=3 d
	....s RptContent=strOrderName
	..Do OutOEItemInfo3
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo3
	set Data=$lb(strOrderName,oeorditemdr,ReportRowID,RptContent)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelPACSRptByARCDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelPACSRptByARCDRExecute ]
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

ClassMethod SelPACSRptByARCDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelPACSRptByARCDRExecute ]
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
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectReportByOeordID","124||89")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
  	Quit:$g(OEItemRowID)="" $$$OK
	
	If $g(ind)="" Set ind=1
	
	s ExamDesc="未回报",strResult="未回报",strOrderName="",RptRowId=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",OEItemRowID,0))
    i RegRowid'="" d
    .s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    .s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    i RptRowId'="" d
	.;s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report-Oeorditm",OEItemRowID,RptRowId)) q:(RptRowId="")  d
	.i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" d
	..s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
	..s:(ExamDesc'="") ExamDesc = ..ConvertRptContent(ExamDesc)  //处理协和项目 平台组特殊字符
    .i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" d
	..s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
	..s:(strResult'="") strResult = ..ConvertRptContent(strResult)  //处理协和项目 平台组特殊字符
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

Query SelectPACSArcCateList() As %Query(ROWSPEC = "CatItemDR:%String,CatDesc:%String")
{
}

ClassMethod SelectPACSArcCateListExecute(ByRef qHandle As %Binary) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectPACSArcCateList")

 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ItmCat=""
    s CatRowid=0 f  s CatRowid=$O(^OEC("ORCAT",CatRowid)) q:(CatRowid="")  d
    .s Desc=$p(^OEC("ORCAT",CatRowid),"^",2)
    .i Desc["检查" d
    ..s Rowid="" f  s Rowid=$O(^ARC("IC",0,"OrdCat",CatRowid,Rowid)) q:(Rowid="")  d
    ...s ItmCat=$p(^ARC("IC",Rowid),"^",2)
	...Do OutCatList
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutCatList
	set Data=$lb(Rowid,ItmCat)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPACSArcCateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSArcCateListExecute ]
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

ClassMethod SelectPACSArcCateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSArcCateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query SelectPACSArcItemList(ArcCateID As %String) As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String")
{
}

ClassMethod SelectPACSArcItemListExecute(ByRef qHandle As %Binary, ArcCateID As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectPACSArcItemList",166) 
 s ind=1 
 Set repid=$I(^CacheTemp)
 i ArcCateID'="" d
 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",ArcCateID,Subscrip)) q:(Subscrip="")  d
 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",ArcCateID,Subscrip,Version)) q:(Version="")  d
 ...s ItemRowid=Subscrip_"||"_Version
 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
 ...if $p(^ARCIM(Subscrip,Version,7),"^",6)="S" Do OutItmMast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItmMast
 set Data=$lb(ItemRowid,ItemDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod SelectPACSArcItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSArcItemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod SelectPACSArcItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSArcItemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SelectPACSItemIndicators(OEItemRowID As %String, TypeID As %String) As %Query(ROWSPEC = "retContent:%String")
{
}

ClassMethod SelectPACSItemIndicatorsExecute(ByRef qHandle As %Binary, OEItemRowID As %String, TypeID As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectPACSItemIndicators","386||1")
	i $g(OEItemRowID)="" Set qHandle=$lb(0,repid,0)
  	Quit:$g(OEItemRowID)="" $$$OK
  	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	//s ExamDesc="",strResult="",strOrderName=""
    s ExamDesc="未回报",strResult="未回报",strOrderName=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)

	s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report-Oeorditm",OEItemRowID,RptRowId)) q:(RptRowId="")  d
	.i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" d
	..s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
	..s:(ExamDesc'="") ExamDesc = ..ConvertRptContent(ExamDesc)  //处理协和项目 平台组特殊字符
    .i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" d
	..s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
	..s:(strResult'="") strResult = ..ConvertRptContent(strResult)  //处理协和项目 平台组特殊字符
	s retContent=""
	i TypeID="1"   s retContent=ExamDesc
	i TypeID="2"   s retContent=strResult
	i TypeID="3"   s retContent=strOrderName
	Do OutRptIndicators
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptIndicators
	set Data=$lb(retContent)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPACSItemIndicatorsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSItemIndicatorsExecute ]
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

ClassMethod SelectPACSItemIndicatorsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSItemIndicatorsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query SelectRptStructure() As %Query(ROWSPEC = "TypeID:%String,TypeDesc:%String")
{
}

ClassMethod SelectRptStructureExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s typeID=1
	s typeDesc="检查所见"
	Do OutRptStructure
	
	s typeID=2
	s typeDesc="诊断意见"
	Do OutRptStructure
	
	s typeID=3
	s typeDesc="检查方法"
	Do OutRptStructure
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptStructure
	set Data=$lb(typeID,typeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectRptStructureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRptStructureExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SelectRptStructureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRptStructureExecute ]
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

/// ##Class(web.DHCRisclinicQueryEPR).ConvertRptContent(AString)
ClassMethod ConvertRptContent(AString As %String, AHospital As %String = "") As %String
{
	q:($d(AString)=0)||(AString="") ""
	
	s (Result,tmpResult)=""
	s (delimstr,delimcount,num,delim,resultstr,resultcount,numsub,result)=""

	//处理协和项目 替换报告中的平台组特殊字符
	s Result = $tr(AString,"@")
	
	//替换报告中的空格符
	s Result = $tr(Result," ")
	
	//替换报告中的回车符
	//s delimstr="_$c(13,10)_^_$c_"
	s delimstr="_$c(13,10)_^_$c_^"_$c(13,10)_""
	s delimcount=$l(delimstr,"^")
		
	for num=1:1:delimcount {
		
		s delim = $p(delimstr,"^",num)
		
		s resultstr=Result
		s resultcount=$l(resultstr,delim)
		
		for numsub=1:1:resultcount {
			
			s result = $p(resultstr,delim,numsub)
			s tmpResult = tmpResult_result
		}
		//完成一个分隔符替换
		s Result=tmpResult,tmpResult=""
	}
	
	
	q Result
}

}
