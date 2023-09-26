Import sqluser

Class web.DHCEMCheck Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description: 检查结果查询
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-07
/// Table: 		 PA_Adm  OE_Order OE_OrdItem等等等
/// Input:  	 就诊id
/// Return： 	 
/// Others:		 w ##class(web.DHCEMCheck).ListCheckResult(0,6,"91","","64311","66221","Y")
ClassMethod ListCheckResult(offset = 0, limit = 10, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String, ALLFlag As %String, arci As %String, ItmArcCatDr As %String)
{
	;s ^joe("data")=paadmdr_"!"_LocDr_"!"_StdDate_"!"_enddate_"!"_ALLFlag_"!"_ItmArcCatDr
	S End = offset+limit
	S Start = offset+1
    S count=0
	S jsonObj=##class(web.DHCAPPJsonObject).%New()	
	
	s StdDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StdDate) //hxy 2017-03-01
    s enddate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(enddate) //hxy 2017-03-01
	;i StdDate["-" s StdDate=$zdh(StdDate,3)
 	;i StdDate["/" s StdDate=$zdh(StdDate,4)
 	i StdDate="" s StdDate=""
	;i enddate["-"  s enddate=$zdh(enddate,3)
	;i enddate["/"  s enddate=$zdh(enddate,4)
	i enddate=""  s enddate=""

	w "{""rows"":["
  	;if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
 	;Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LocDr=$p(LocDr,$c(0))
	s StDate=$p(StdDate,$c(0))
	s EndDate=$p(enddate,$c(0))
	s Memo="",ItemStatus="",StatusCode=""
	s RegNo="",StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="N",MediumDR="",MediumName=""
	s PAPMIDR = $p(^PAADM(paadmdr),"^",1)
	s PAType="" f  s PAType=$o(^PAPERdr(PAPMIDR,"ADM",PAType)) q:PAType=""  d
	.s PaadmdrOne=0 f  s PaadmdrOne=$o(^PAPERdr(PAPMIDR,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
	..q:(ALLFlag'="Y")&(paadmdr'=PaadmdrOne) 
	..s RegNo="",StudyNo="",strOrderName="",ItemStatus="",IsIll=""
	..s RptNum = 0
	..s OrderRowid=""
 	..s OrderRowid=$o(^OEORD(0,"Adm",PaadmdrOne,OrderRowid)) 
 	..q:OrderRowid=""
	..s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	...s Memo=""
	...s RegNo="",StudyNo="",strOrderName="",ItemStatus="N",IsIll="N"
	...s Image="",Shut="",Report="",ImageUrl="",Grade="",ItemStatusCode=""
	...s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	...q:(replocdr="")
	...s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...q:(ItemStatusCode'="V")&(ItemStatusCode'="E")  //V：核实，E：执行
	...q:(LocDr'="")&(replocdr'=LocDr)
	...s ClinicRowid=0
	...s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	...q:(ClinicRowid="")
	...i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	...s IsVerify="N"  ;没有审核
	...s resrowid="" 
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
	...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	...q:(ServerMaterial'="S") ;不是检查项目的则退出  
	...q:(arci'="")&(arci'=arcimid)
	...s ItmArcCat=""
	...s:ItmArcCatDr'="" ItmArcCat=$p(^DHCAPARCCA(ItmArcCatDr),"^",1)_"^"_$p($g(^DHCAPARCCA(ItmArcCatDr)),"^",2)
	...s itmArc=""
	...s itmArc = ##class(web.DHCEMPatCheOutNew).GetSortByArci(arcimid)     //该医嘱项的检查分类
	...q:(ItmArcCatDr'="")&(itmArc'[ItmArcCat) 							//QQA 2017-02-23
	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...;s strDate=$zd(Date1,3) //hxy 2017-03-01
	...s strDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date1) //hxy 2017-03-01
	...s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	...s strTime=$zt(Time1)
	...s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	...s oeorditemdr=OrderRowid_"||"_itemsub
	...;i ($g(^DHCRisVersion)="BJ_DT")&(replocdr="85") d ;地坛医院 心电科 做接口，如果医嘱状态为执行，则报告状态变为发布
	...;.i ItemStatusCode="E"  s ItemStatus="Y"
	...;i replocdr=85 s ItemStatus="Y"
	...s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,"")) //空 的下个节点的 rowID
	...i $g(RegDR)'="" d
	....s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)  //检查号
	....s ImageUrl=$p(^DHCPACRegInfo(RegDR),"^",22)      ;存放外部传输过来的URL
	...s StatusCode=""
	...i StudyNo'="" d
	....s Imgrowid=0
	....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	....i Imgrowid'="" s IshasImg="Y"
	....;s IshasImg=..GetImageStatu(StudyNo)
	....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	.....s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	.....s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.....q:(StatusDR="")
	.....s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	.....s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	.....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.....i StatusCode="S" d
	......s ItemStatus="Y"
	......s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.......s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.......i FullFileName'="" D
	........s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	........s MediumName=$P(^DHCRBCServer("Medium",MediumDR),"^",2)
	...s tmpItemStatus=##CLASS(web.DHCEMCheck).GetOEOrdStatus(OrderRowid,itemsub)
	...s ItemStatus=$p(tmpItemStatus,"^",1)
	...s ItemCode=$p(tmpItemStatus,"^",2)
	...i StatusCode="S" d
	....s Image="图像"
	....;s Shut="关闭"
	....s Report="报告"
	....s Grade="评级"
	...s isModify=""
	...s isReaded=""
	...s IsModify=""
	...s IsReaded=""
	...i StudyNo'="" d
	....s PortalRowId=0
	....s PortalRowId=$o(^DHCRBCLINICCHECKRPTINFOi(oeorditemdr,StudyNo,PortalRowId))
	....i PortalRowId'="" d
	.....s myDocCode=%session.Get("LOGON.USERCODE")
	.....s CMStatus=##class(RISService.TrakRISService).GetRPTCMStatus(oeorditemdr,StudyNo,myDocCode)
	.....s isReaded=$p(CMStatus,"^",1)
	.....s isModify=$p(CMStatus,"^",2)
	.....i isModify="Y" d
	......s IsModify="已修改"
	.....e  d
	......s IsModify=""
	.....i isReaded="Y" d
	......s IsReaded="已阅读"
	.....e  d
	......i Report="报告" d
	.......s IsReaded="未阅读"
	......e  d
	.......s IsReaded=""
	......
	.....
	....
	...S TempStr=RegNo_"^"_StudyNo_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_IsReaded_"^"_IsModify_"^"_Report_"^"_IsIll_"^"_LocName_"^"_IshasImg_"^"_MediumName_"^"_Memo_"^"_oeorditemdr_"^"_replocdr

	...S count=count+1

	...Q:count<Start
	...Q:count>End
	
    ...W $case(count,Start:"",:",") 
	...W ##class(web.DHCAPPJsonCommon).getJsonData("RegNo^StudyNo^ItemName^ItemDate^ItemStatus^IsReaded^IsModify^OpenRpt^IsIll^LocName^IshasImg^MediumName^Memo^OEOrderDr^replocdr^ImageUrl^Grade",TempStr)
	W "],""total"":"_count_"}"
	Q ""
}

ClassMethod GetImageStatu(StudyNo As %String) As %String
{
	s HasImge="N",ImageCount=0
	s CurrSpace=$ZNSPACE
	zn "DHC-PACS"
	s strStudyNo=" "_StudyNo
	s id=$o(^User.STUDYINFOI("STUDYINFOPK",strStudyNo,0))
	i id'="" s ImageCount=$LISTGET(^User.STUDYINFOD(id),35)
	i ImageCount>0 d
	.s HasImge="Y"
	zn CurrSpace
	Q HasImge
}

/// 返回医嘱的报告及图像状态
/// qzg 20090515
/// Status="SC"	RIS 登记,安排检查时间 (Scheduled)
/// Status="IP"	RIS 检查开始 (In Process)
/// Status="CM"	RIS 检查完成 (Order is Complete)
/// Status="BK" RIS预约
/// Status="IM" RIS有图像
/// Status="RP" RIS已写报告
/// Status="V"  RIS审核报告
ClassMethod GetOEOrdStatus(OrderRowid As %String, itemsub As %String) As %String
{
	s StatusDesc="",StatusCode1=""
	s StatusCode1 = $p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",5)
	i StatusCode1 = "" q ""
	&sql(SELECT RESST_Desc INTO :StatusDesc FROM OEC_ResultStatus WHERE RESST_Code=:StatusCode1)
	
	q StatusDesc_"^"_StatusCode1
}

Storage Default
{
<Data name="DHCEMCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMCheckD</DataLocation>
<DefaultData>DHCEMCheckDefaultData</DefaultData>
<IdLocation>^web.DHCEMCheckD</IdLocation>
<IndexLocation>^web.DHCEMCheckI</IndexLocation>
<StreamLocation>^web.DHCEMCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
