Class web.DHCEkg.GXYDE.EkgQueryInfo Extends %RegisteredObject
{

/// 函数： 		QueryEkgRptInfo
/// 描述：		广西医大二院，获取心电检查结果和报告
/// 入参：		医嘱号，多条以^分隔
/// 	返回值：	医嘱id,报告id,报告结果描述,诊断描述,报告人,审核人,报告阳性标识,报告图片链接地址
/// 作者： 		yangyali
/// 日期： 		2018-12-13
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.GXYDE.EkgQueryInfo","QueryEkgRptInfo","370||122^41||85^10||220^451||105")
Query QueryEkgRptInfo(OrdIds As %String) As %Query(ROWSPEC = "OrdId,RptId,RptStatus,ExamDesc,Diagnose,Reporter,Arbiter,NegtivePositive,ReportUrl")
{
}

ClassMethod QueryEkgRptInfoExecute(ByRef qHandle As %Binary, OrdIds As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//医嘱id,报告id,报告结果描述,诊断描述,报告人,审核人,报告阳性标识,报告图片链接地址
	s (OrdId,RptId,RptStatus,ExamDesc,Diagnose,Reporter,Arbiter,NegtivePositive,ReportUrl)=""
	
	f i=1:1:$l(OrdIds,"^") d
	.s (reqId,examId,examInfo,rptUsrId,rptUsrInfo,arbUsrId,arbUsrInfo,fileId,fileInfo,volId,volInfo)=""
	.s OrdId=$p(OrdIds,"^",i)
	.q:(OrdId="")
	.s rtnRptInfo=..GetRptInfo(OrdId)
	.s RptId=$p(rtnRptInfo,"^",1)
	.s RptStatus=$p(rtnRptInfo,"^",2)
	.s ExamDesc=$p(rtnRptInfo,"^",3)
	.s Diagnose=$p(rtnRptInfo,"^",4)
	.s Reporter=$p(rtnRptInfo,"^",5)
	.s Arbiter=$p(rtnRptInfo,"^",6)
	.s NegtivePositive=$p(rtnRptInfo,"^",7)
	.s ReportUrl=$p(rtnRptInfo,"^",8)
	.d OutEkgRptInfoRow
	
 	s qHandle=$lb(0,repid,0)
	q $$$OK

OutEkgRptInfoRow	
	s Data=$lb(OrdId,RptId,RptStatus,ExamDesc,Diagnose,Reporter,Arbiter,NegtivePositive,ReportUrl)
 	S ^CacheTemp(repid,ind)=Data 	
 	S ind=ind+1
 	b ;000
	q
}

ClassMethod QueryEkgRptInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
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

ClassMethod QueryEkgRptInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 入参：		医嘱号
/// 返回值：	医嘱id,报告id,报告结果描述,诊断描述,报告人,审核人,报告阳性标识,报告图片链接地址
/// w ##class(web.DHCEkg.GXYDE.EkgQueryInfo).GetRptInfo("41||85")
ClassMethod GetRptInfo(OrdId) As %String
{
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	
	s (RptId,RptStatus,ExamDesc,Diagnose,Reporter,Arbiter,NegtivePositive,ReportUrl)=""
	s (reqId,examId,examInfo,rptUsrId,rptUsrInfo,arbUsrId,arbUsrInfo,fileId,fileInfo,volId,volInfo)=""
	
	s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,reqId))
	i (reqId'="") d
	.s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
	.q:(examId="")
	.s RptId=examId
	.s examInfo=$g(^dbo.tblExaminationD(examId))
	.q:(examInfo="")
	.s statusCode=$listget(examInfo,20,"")
	.i (statusCode="15")!(statusCode="17") s RptStatus="Y"
	.e  s RptStatus="N"
	.s Diagnose=$listget(examInfo,11,"")
	.i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) ;2015-08-13
	.s D=""
	.f i=1:1:$l( Diagnose,$c(10)) d
	..s tmpD=$p(Diagnose,$c(10),i)
	..i (tmpD'="") d
	...i (D="") s D=tmpD
	...e  s D=D_","_tmpD
	.s Diagnose=D
	.s ExamDesc=D
	.s rptUsrId=$listget(examInfo,18,"")
	.i (rptUsrId'="")&&(rptUsrId'="0") d
	..s rptUsrInfo=$g(^dbo.tblUserD(rptUsrId))
	..q:(rptUsrInfo="")
	..s Reporter=$listget(rptUsrInfo,11,"")
	.s arbUsrId=$listget(examInfo,7,"")
	.i (arbUsrId'="")&&(arbUsrId'="0") d
	..s arbUsrInfo=$g(^dbo.tblUserD(arbUsrId))
	..q:(arbUsrInfo="")
	..s Arbiter=$listget(arbUsrInfo,11,"")
	.f  s fileId=$o(^dbo.tblFilePathI("idxExaminationID",examId,fileId)) q:(fileId="")  d
	..s fileInfo=$g(^dbo.tblFilePathD(fileId))
	..q:(fileInfo="")
	..s pdfPath=$listget(fileInfo,6,"")
	..q:(pdfPath="")
	..s volCode=$listget(fileInfo,7,"")
	..q:(volCode="")
	.;b ; w volCode_","_pdfPath
	.s volId=$o(^dbo.tblDictVolumnI("idxCode"," "_volCode,volId))
	.q:(volId="")
	.s volInfo=$g(^dbo.tblDictVolumnD(volId))
	.q:(volInfo="")
	.s ftpPath=$listget(volInfo,5,"")
	.q:(ftpPath="")
	.s ReportUrl=ftpPath_pdfPath	
	
	zn CurrSpace
	s rtnRptInfo=RptId_"^"_RptStatus_"^"_ExamDesc_"^"_Diagnose_"^"_Reporter_"^"_Arbiter_"^"_NegtivePositive_"^"_ReportUrl
	q rtnRptInfo
}

}
