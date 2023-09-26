Class web.DHCLabPanicReport Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：      huhm
/// CreatDate：    20120627
/// Description:： 判断是否有未阅读过包含警戒值或荒诞值结果的报告
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：       
ClassMethod ReportWarn(AdmNo As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s RtnValue=0
	//^DHCPanicReport(0,"ADM",76734,125641,1)	=	""
	s labno="" f  s labno=$o(^DHCPanicReport(0,"ADM",AdmNo,1,labno)) q:(labno="")!(RtnValue=1)  d
	.s ord=""  f  s ord=$o(^DHCPanicReport(0,"ADM",AdmNo,1,labno,ord)) q:(ord="")!(RtnValue=1)  d
	..//s TransOrd=+$o(^DHCPanicReport(labno,ord,"TR",""),-1)
	..//i TransOrd>40 q
	..s AdmType=$p(^PAADM(AdmNo),"^",2)
	..//需要增加急诊留观
	..i AdmType'="I" q
	..s stus=$p(^DHCPanicReport(1,labno,ord),"\",9)
	..i stus="C" s RtnValue=1
	Quit RtnValue
}

ClassMethod ReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReportListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s AdmNo=$g(EpisodeID)
	s ^TMPADM=AdmNo
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
    //
	s labno="" f  s labno=$o(^DHCPanicReport(0,"ADM",AdmNo,1,labno)) q:labno=""  d
	.s AdmType=$p(^PAADM(AdmNo),"^",2)
	.//需要增加急诊留观
	.i AdmType'="I" q
	.//
	.s OrdName="",ReqDate="",ReqTime="",CollInfo=""
	.s OrdId="" f  s OrdId=$o(^OEORD(0,"EpisNo",labno,OrdId)) q:OrdId=""  d
	..s OrdSub="" f  s OrdSub=$o(^OEORD(0,"EpisNo",labno,OrdId,OrdSub)) q:OrdSub=""  d
	...s ArcimId=$p(^OEORD(OrdId,"I",OrdSub,1),"^",2)
	...s ReqDate=$p($g(^OEORD(OrdId,"I",OrdSub,3)),"^",7)
	...s ReqTime=$p($g(^OEORD(OrdId,"I",OrdSub,1)),"^",17)
	...i '$l(CollInfo) s CollInfo=##Class(web.DHCLabReportControl).GetCollectionInfo(OrdId_"||"_OrdSub)
	...i '$l(ArcimId) q
	...s Arcim=$p(^ARCIM($P(ArcimId,"||",1),$P(ArcimId,"||",2),1),"^",2)
	...i $l(Arcim) s OrdName=OrdName_Arcim_"+"
	.s OrdName=$e(OrdName,1,$l(OrdName)-1)
	.i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
	.i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
	.s (SpecCode,SpecDesc)=""
	.i $l(CollInfo) d
	..s SpecCode=$p(CollInfo,"^",1)
	..s CollDT=$p(CollInfo,"^",2)
	.i $l(SpecCode),$d(^TTAB("SPEC",SpecCode))	s SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
	.s AuthDT="",RecDT="",StstusFlag=0
	.s ord="" f  s ord=$o(^DHCPanicReport(0,"ADM",AdmNo,1,labno,ord)) q:ord=""  d
	..s TransMemo=$p(^DHCPanicReport(1,labno,ord),"\",8)
    ..s TransMemoDr=$p($p(TransMemo,"{",2),"}",1)
    ..i $L(TransMemoDr),$d(^DHCTSTransComment(TransMemoDr)) s TransMemo=$p(^DHCTSTransComment(TransMemoDr),"\",1)
	..s Ststus=$p(^DHCPanicReport(1,labno,ord),"\",9)
	..i Ststus="C" s StstusFlag=StstusFlag+1 
	.i StstusFlag=0 q //完成审核
	.//
	.s ResFlag=""
	.//处理类型
	.s TransType=0
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(labno,OrdName,SpecDesc,TransMemo,ReqDate_" "_ReqTime,CollDT,RecDT,AuthDT,ResFlag,TransType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReportListExecute ]
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

/// Creator：      huhm
/// CreatDate：    20120627
/// Description:： 得到未阅读过的警戒值或荒诞值结果的报告列表
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query ReportList(EpisodeID As %String) As %Query(ROWSPEC = "LabEpis:%String,OrdDesc:%String,SpecDesc:%String,TransMemo:%String,ReqDateTime:%String,CollDateTime:%String,RecDateTime:%String,AuthDateTime:%String,ResultStatus:%String,TransType:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20120710
/// Description:： 根据医生工号得到医生名称
/// Table：       
/// Input：        医生工号
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetDocName(itmjs As %Library.String = "", itmjsex As %Library.String = "", DocCode As %Library.String = "") As %String
{
	If '$Length(DocCode) Quit ""
	Set DocId=$o(^SSU("SSUSR",0,"SSUSR_Initials",DocCode,""))
	If '$Length(DocId) Quit ""
	s RetValue=$p(^SSU("SSUSR",DocId),"^",2)
	Quit RetValue
}

ClassMethod CTLocLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CTLocLookUpExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_RowId
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :desc))
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
	.//
 	.Do OutputRow4	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTLocLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocLookUpExecute ]
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

/// Creator：      huhm
/// CreatDate：    20090704
/// Description:： 查询科室
/// Table：        ct_loc
/// Input：        科室名称
/// Output：       科室名称,科室代码
/// Return：       
/// Others
Query CTLocLookUp(desc As %String) As %Query(ROWSPEC = "ctloc:%String,ctlocid:%String")
{
}

}
