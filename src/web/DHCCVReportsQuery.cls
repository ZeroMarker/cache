Class web.DHCCVReportsQuery Extends (%RegisteredObject, %XML.Adaptor)
{

Query GetCVReportsQuery(SDate As %String, EDate As %String, HospId As %String = "") As %Query(ROWSPEC = "DPRPTypeName:%String,nums:%Double,EndComplete:%Double") [ SqlProc ]
{
}

ClassMethod GetCVReportsQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVReportsQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCCVReportsQuery","GetCVReportsQuery","2013-10-01","2014-02-13")

ClassMethod GetCVReportsQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Tmpwjzqp("WJZ",$J)
	s nums=0     //检验
	s nums2=0	  //病理
	s nums3=0     //心电
	s nums4=0     //超声
	s nums5=0     //内镜
	s nums6=0     //放射
	s total=0     //总数
	s DisDate=""  //日期
	s EndComplete=0 //完成数量
	if SDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s DPRPType=""
	.f  s DPRPType=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType)) q:DPRPType=""  d
	..s DPRPLabNo=""
	..f  s DPRPLabNo=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	...s DPRPOrder=""
	...f  s DPRPOrder=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	....q:$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9)="D"
	....s DPRPAdm=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",7) q:DPRPAdm=""
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....//if DPRPAdm=44 s AdmDepDR=132 //测试
	....q:(HospId>0)&&($p($g(^CTLOC(+AdmDepDR)),"^",22)'=HospId) ;院区过滤 20200217
	....s ^Tmpwjzqp("WJZ",$J,DPRPType,"nums")=$g(^Tmpwjzqp("WJZ",$J,DPRPType,"nums"))+1
	....s DPRPStatus=""
	....s DPRPStatus=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9) q:DPRPStatus=""
	....i DPRPStatus="F" d
	.....s ^Tmpwjzqp("WJZ",$J,DPRPType,"EndComplete")=$g(^Tmpwjzqp("WJZ",$J,DPRPType,"EndComplete"))+1
	
	
	s DPRPType="",nums=0,EndComplete=0,DPRPTypeName=""
	f  s DPRPType=$o(^Tmpwjzqp("WJZ",$J,DPRPType)) q:DPRPType=""  d
	.s DPRPTypeName=##Class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)
	.s nums=+$g(^Tmpwjzqp("WJZ",$J,DPRPType,"nums"))                          ///总数
	.s EndComplete=+$g(^Tmpwjzqp("WJZ",$J,DPRPType,"EndComplete"))    // 完成数量
	.d OutputAll1
	k ^Tmpwjzqp("WJZ",$J)
	
	///^DHCAntCVReport(0,"DATE",{DPRP_Date},{DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order})
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DHC_PanicReport.DPRP_Type},{DHC_PanicReport.DPRP_LabNo},{DHC_PanicReport.DPRP_Order},"TR",{DPRT_Order})
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAll1
	set Data=$lb(DPRPTypeName,nums,EndComplete)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVReportsQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVReportsQueryExecute ]
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

/// ==========================门诊============================================///
Query GetCVOReportsQuery(SDate As %String, EDate As %String, HospId As %String = "") As %Query(ROWSPEC = "DPRPTypeName:%String,nums:%Double,EndComplete:%Double") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCVReportsQuery","GetCVOReportsQuery","2013-10-01","2014-02-13")

ClassMethod GetCVOReportsQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Tmpwjzqp("WJZOut",$J)
	s nums=0     //检验
	s nums2=0	  //病理
	s nums3=0     //心电
	s nums4=0     //超声
	s nums5=0     //内镜
	s nums6=0     //放射
	s total=0     //总数
	s DisDate=""  //日期
	s EndComplete=0 //完成数量
	if SDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s DPRPType=""
	.f  s DPRPType=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType)) q:DPRPType=""  d
	..s DPRPLabNo=""
	..f  s DPRPLabNo=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	...s DPRPOrder=""
	...f  s DPRPOrder=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	....q:$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9)="D"
	....s DPRPAdm=""
	....s DPRPAdm=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",7) q:DPRPAdm=""
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....q:(HospId>0)&&($p($g(^CTLOC(+AdmDepDR)),"^",22)'=HospId) ;院区过滤 20200217
	....s AdmType=$p(^PAADM(DPRPAdm),"^",2)
	....q:AdmType'="O"
	....s ^Tmpwjzqp("WJZOut",$J,DPRPType,"nums")=$g(^Tmpwjzqp("WJZOut",$J,DPRPType,"nums"))+1
	....s DPRPStatus=""
	....s DPRPStatus=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9) q:DPRPStatus=""
	....i DPRPStatus="F" d
	.....s ^Tmpwjzqp("WJZOut",$J,DPRPType,"EndComplete")=$g(^Tmpwjzqp("WJZOut",$J,DPRPType,"EndComplete"))+1
	
	
	s DPRPType="",nums=0,EndComplete=0,DPRPTypeName=""
	f  s DPRPType=$o(^Tmpwjzqp("WJZOut",$J,DPRPType)) q:DPRPType=""  d
	.s DPRPTypeName=##Class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)
	.s nums=+$g(^Tmpwjzqp("WJZOut",$J,DPRPType,"nums"))                          ///总数
	.s EndComplete=+$g(^Tmpwjzqp("WJZOut",$J,DPRPType,"EndComplete"))    // 完成数量
	.d OutputAll2
	k ^Tmpwjzqp("WJZOut",$J)
		///^DHCAntCVReport(0,"DATE",{DPRP_Date},{DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order})
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DHC_PanicReport.DPRP_Type},{DHC_PanicReport.DPRP_LabNo},{DHC_PanicReport.DPRP_Order},"TR",{DPRT_Order})
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAll2
	set Data=$lb(DPRPTypeName,nums,EndComplete)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVOReportsQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVOReportsQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCVOReportsQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVOReportsQueryExecute ]
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

/// //===============================================急诊=========================
Query GetCVEReportsQuery(SDate As %String, EDate As %String, HospId As %String = "") As %Query(ROWSPEC = "DPRPTypeName:%String,nums:%Double,EndComplete:%Double") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCVReportsQuery","GetCVEReportsQuery","2013-10-01","2014-02-13")

ClassMethod GetCVEReportsQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Tmpwjzqp("WJZEJ",$J)
	s nums=0     //检验
	s nums2=0	  //病理
	s nums3=0     //心电
	s nums4=0     //超声
	s nums5=0     //内镜
	s nums6=0     //放射
	s total=0     //总数
	s DisDate=""  //日期
	s EndComplete=0 //完成数量
	if SDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s DPRPType=""
	.f  s DPRPType=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType)) q:DPRPType=""  d
	..s DPRPLabNo=""
	..f  s DPRPLabNo=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	...s DPRPOrder=""
	...f  s DPRPOrder=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	....q:$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9)="D"
	....s DPRPAdm=""
	....s DPRPAdm=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",7) q:DPRPAdm=""
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....q:(HospId>0)&&($p($g(^CTLOC(+AdmDepDR)),"^",22)'=HospId) ;院区过滤 20200217
	....s AdmType=$p(^PAADM(DPRPAdm),"^",2)
	....q:AdmType'="E"
	....s ^Tmpwjzqp("WJZEJ",$J,DPRPType,"nums")=$g(^Tmpwjzqp("WJZEJ",$J,DPRPType,"nums"))+1
	....s DPRPStatus=""
	....s DPRPStatus=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9) q:DPRPStatus=""
	....i DPRPStatus="F" d
	.....s ^Tmpwjzqp("WJZEJ",$J,DPRPType,"EndComplete")=$g(^Tmpwjzqp("WJZEJ",$J,DPRPType,"EndComplete"))+1
	
	
	s DPRPType="",nums=0,EndComplete=0,DPRPTypeName=""
	f  s DPRPType=$o(^Tmpwjzqp("WJZEJ",$J,DPRPType)) q:DPRPType=""  d
	.s DPRPTypeName=##Class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)
	.s nums=+$g(^Tmpwjzqp("WJZEJ",$J,DPRPType,"nums"))                          ///总数
	.s EndComplete=+$g(^Tmpwjzqp("WJZEJ",$J,DPRPType,"EndComplete"))    // 完成数量
	.d OutputAll3
	k ^Tmpwjzqp("WJZEJ",$J)
		///^DHCAntCVReport(0,"DATE",{DPRP_Date},{DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order})
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DHC_PanicReport.DPRP_Type},{DHC_PanicReport.DPRP_LabNo},{DHC_PanicReport.DPRP_Order},"TR",{DPRT_Order})
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAll3
	set Data=$lb(DPRPTypeName,nums,EndComplete)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVEReportsQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVEReportsQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCVEReportsQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVEReportsQueryExecute ]
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

/// //===============================================住院=========================
Query GetCVIReportsQuery(SDate As %String, EDate As %String, HospId As %String = "") As %Query(ROWSPEC = "AdmLoc:%String,DPRPTypeName:%String,nums:%Double,EndComplete:%Double") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCVReportsQuery","GetCVIReportsQuery","2013-10-01","2014-02-13")

ClassMethod GetCVIReportsQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Tmpwjzqp("WJZI",$J)
	s nums=0     //检验
	s nums2=0	  //病理
	s nums3=0     //心电
	s nums4=0     //超声
	s nums5=0     //内镜
	s nums6=0     //放射
	s total=0     //总数
	s DisDate=""  //日期
	s EndComplete=0 //完成数量
	if SDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s DPRPType=""
	.f  s DPRPType=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType)) q:DPRPType=""  d
	..s DPRPLabNo=""
	..f  s DPRPLabNo=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	...s DPRPOrder=""
	...f  s DPRPOrder=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	....q:$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9)="D"
	....s DPRPAdm="",AdmDepDR="",AdmLoc=""
	....s DPRPAdm=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",7) q:DPRPAdm=""
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....q:(HospId>0)&&($p($g(^CTLOC(+AdmDepDR)),"^",22)'=HospId) ;院区过滤 20200217
	....s AdmType=$p(^PAADM(DPRPAdm),"^",2)
	....q:AdmType'="I"
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....s AdmLoc=$p(^CTLOC(AdmDepDR),"^",2)
	....s ^Tmpwjzqp("WJZI",$J,DPRPType,"nums")=$g(^Tmpwjzqp("WJZI",$J,DPRPType,"nums"))+1
	....s ^Tmpwjzqp("WJZI",$J,DPRPType,"AdmLoc")=AdmLoc
	....s DPRPStatus=""
	....s DPRPStatus=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9) q:DPRPStatus=""
	....i DPRPStatus="F" d
	.....s ^Tmpwjzqp("WJZI",$J,DPRPType,"EndComplete")=$g(^Tmpwjzqp("WJZI",$J,DPRPType,"EndComplete"))+1
	
	
	s DPRPType="",nums=0,EndComplete=0,DPRPTypeName=""
	f  s DPRPType=$o(^Tmpwjzqp("WJZI",$J,DPRPType)) q:DPRPType=""  d
	.s DPRPTypeName=##Class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)
	.s nums=+$g(^Tmpwjzqp("WJZI",$J,DPRPType,"nums"))                          ///总数
	.s EndComplete=+$g(^Tmpwjzqp("WJZI",$J,DPRPType,"EndComplete"))    // 完成数量
	.s AdmLoc = $g(^Tmpwjzqp("WJZIOE",$J,DPRPType,"AdmLoc"))
	.d OutputAll4
	k ^Tmpwjzqp("WJZI",$J)
		///^DHCAntCVReport(0,"DATE",{DPRP_Date},{DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order})
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DHC_PanicReport.DPRP_Type},{DHC_PanicReport.DPRP_LabNo},{DHC_PanicReport.DPRP_Order},"TR",{DPRT_Order})
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAll4
	set Data=$lb(AdmLoc,DPRPTypeName,nums,EndComplete)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVIReportsQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVIReportsQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCVIReportsQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVIReportsQueryExecute ]
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

/// //===============================================科室 + 类型=========================
Query GetCVIOEReportsQuery(SDate As %String, EDate As %String, HospId As %String = "") As %Query(ROWSPEC = "AdmLoc:%String,DPRPTypeName:%String,nums:%Double,EndComplete:%Double") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCVReportsQuery","GetCVIOEReportsQuery","2013-10-01","2014-02-13")

ClassMethod GetCVIOEReportsQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Tmpwjzqp("WJZIOE",$J)
	s nums=0     //检验
	s nums2=0	  //病理
	s nums3=0     //心电
	s nums4=0     //超声
	s nums5=0     //内镜
	s nums6=0     //放射
	s total=0     //总数
	s DisDate=""  //日期
	s EndComplete=0 //完成数量
	if SDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 	if EDate="" Set qHandle=$lb(0,repid,0) q $$$OK
 
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	f DisDate=SDate:1:EDate d
	.s DPRPType=""
	.f  s DPRPType=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType)) q:DPRPType=""  d
	..s DPRPLabNo=""
	..f  s DPRPLabNo=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	...s DPRPOrder=""
	...f  s DPRPOrder=$o(^DHCAntCVReport(0,"DATE",DisDate,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	....q:$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9)="D"
	....s DPRPAdm="",AdmDepDR="",AdmLoc=""
	....s DPRPAdm=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",7) q:DPRPAdm=""
	....s AdmType=$p(^PAADM(DPRPAdm),"^",2)
	....s AdmDepDR=$p(^PAADM(DPRPAdm),"^",4)
	....q:(HospId>0)&&($p($g(^CTLOC(+AdmDepDR)),"^",22)'=HospId) ;院区过滤 20200217
	....s AdmLoc=$p(^CTLOC(AdmDepDR),"^",2)
	....s ^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"nums")=$g(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"nums"))+1
	....;s ^Tmpwjzqp("WJZIOE",$J,DPRPType,"AdmLoc")=AdmLoc
	....s DPRPStatus=""
	....s DPRPStatus=$p($g(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder)),"\",9) q:DPRPStatus=""
	....i DPRPStatus="F" d
	.....s ^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"EndComplete")=$g(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"EndComplete"))+1
	
	s DPRPType="",nums=0,EndComplete=0,DPRPTypeName="",AdmLoc="",AdmDepDR=""
	f  s DPRPType=$o(^Tmpwjzqp("WJZIOE",$J,DPRPType)) q:DPRPType=""  d
	.f  s AdmDepDR=$o(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR)) q:AdmDepDR=""  d
	..s AdmLoc=$p(^CTLOC(AdmDepDR),"^",2)
	..s DPRPTypeName=##Class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)
	..s nums=+$g(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"nums"))                          ///总数
	..s EndComplete=+$g(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmDepDR,"EndComplete"))    // 完成数量
	..;s AdmLoc = $g(^Tmpwjzqp("WJZIOE",$J,DPRPType,AdmLoc))
	..d OutputAll4
	k ^Tmpwjzqp("WJZIOE",$J)
		///^DHCAntCVReport(0,"DATE",{DPRP_Date},{DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order})
	/// ^DHCAntCVReport({DPRP_Type},{DPRP_LabNo},{DPRP_Order}) 
	/// ^DHCAntCVReport({DHC_PanicReport.DPRP_Type},{DHC_PanicReport.DPRP_LabNo},{DHC_PanicReport.DPRP_Order},"TR",{DPRT_Order})
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAll4
	set Data=$lb(AdmLoc,DPRPTypeName,nums,EndComplete)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVIOEReportsQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVIOEReportsQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCVIOEReportsQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVIOEReportsQueryExecute ]
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
