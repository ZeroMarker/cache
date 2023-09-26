Import SQLUser

Class web.DHCRisclinicQueryOEItemDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 33581;

/*
/// 获取团体信息
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s id=$g(InString)
	
	i ""=id  d
	.s Data="0^"_Code
	e  d
	.s CurData=$g(^DHCPEST(id))
	.s STCode=$p(CurData,"^",1)
    .s STDesc=$p(CurData,"^",2)
    .s STPlace=$p(CurData,"^",3)
    .s STSequence=$p(CurData,"^",4)
    .s STActive=$p(CurData,"^",5)
	.
	.//		0
	.s Data=$g(id)_"^"_STCode_"^"_STDesc_"^"_STPlace_"^"_STSequence_"^"_STActive

	s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	&javascript<#(retval)#>
	q Data
}
*/
Query QueryVerifyExamItem(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Query(ROWSPEC = "Toeorditemrowid:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemTime:%String,TImgPath:%String")
{
}

ClassMethod QueryVerifyExamItemExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryStudyByPaadmDR","2298","1140","","")
  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	Quit:$g(paadmdr)="" $$$OK
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s OrderRowid=""
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s reploc=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(reploc'=LocDr)&(LocDr'="")
	.s IsVerify="N"  ;没有审核
	.s resrowid="" 
	.f  s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid)) q:(resrowid="")  d
	..s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
	..i ResStatDR="3" s IsVerify="N" ; 审核的报告
	.i IsVerify="N"  d 
	..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	..s strDate=$zd(Date1,3)
	..s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	..s strTime=$zt(Time1)
	..s oeorditemdr=OrderRowid_"||"_itemsub
	..s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	..s StudyNo=""
	..i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	..;b //RegDR
	..i StudyNo="" q
	..s RptRowID=0 f  s RptRowID=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowID)) q:(RptRowID="")  d
	...;b //RptRowID
	...s RptFileCID=0 f  s RptFileCID=$o(^DHCRBStudy(0,"ReportFiles",RptRowID,RptFileCID)) q:(RptFileCID="")  d
	....s ImgPath = $p(^DHCRBStudy(0,"ReportFiles",RptRowID,RptFileCID),"^",1)
	....i ImgPath '="" d     
	.....Do OutRow
 	Set qHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutRow
	set Data=$lb(oeorditemdr,$g(StudyNo),strOrderName,strDate,strTime,ImgPath)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryVerifyExamItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVerifyExamItemExecute ]
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

ClassMethod QueryVerifyExamItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVerifyExamItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryRptHtmlByStudyNo(StudyID As %String) As %Query(ROWSPEC = "FullFileName:%String,DWTName:%String,ImgName:%String,MediumName:%String")
{
}

ClassMethod QueryRptHtmlByStudyNoExecute(ByRef qHandle As %Binary, StudyID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryRptHtmlByStudyNo","1967-70^1967-42")
	Quit:$g(StudyID)="" $$$OK
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s countdown = 0
	s countdown = $LENGTH(StudyID,"^")
	s RARRowid=""
	s countup=1
	b //countdown
	FOR i=1:1:countdown  d
	.s strStudyNo=$P(StudyID,"^",i)
	.b //strStudyNo
	.s resInfo ="" s FullName = "" s DWTName = "" s ImgName = "" s MediumName=""
	.s RptRowID=0 f  s RptRowID=$o(^DHCRBStudyi("Report","StudyNo",strStudyNo,RptRowID)) q:(RptRowID="")  d
	..s rowSub=0 f  s rowSub=$o(^DHCRBStudy(0,"ReportFiles",RptRowID,rowSub)) q:(rowSub="")  d
	...s FullName = $p(^DHCRBStudy(0,"ReportFiles",RptRowID,rowSub),"^",1)
	...s DWTName = $p(^DHCRBStudy(0,"ReportFiles",RptRowID,rowSub),"^",2)
	...s ImgDR = $p(^DHCRBStudy(0,"ReportFiles",RptRowID,rowSub),"^",4)
	...i ImgDR'=""
	....s ImgName=$p(^DHCRBStudy(0,"StudyImages",ImgDR),"^",1)
	....s MediumDR = $p(^DHCRBStudy(0,"StudyImages",ImgDR),"^",6)
	....s MediumName = $p(^DHCRBCServer("Medium",MediumDR),"^",2)
	...Do OutRptHtml
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRptHtml
	set Data=$lb(FullName,DWTName,ImgName,MediumName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRptHtmlByStudyNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRptHtmlByStudyNoExecute ]
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

ClassMethod QueryRptHtmlByStudyNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRptHtmlByStudyNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFTPByStudyNo(StudyNo As %String) As %String
{
	//d ##class(web.DHCRisclinicQueryOEItemDo).GetFTPByStudyNo("U20120702-003")

	i StudyNo="" q ""
	s Imgrowid=0
	s IP="",Port="",User="",Pwd=""
	s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	.s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	.s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	.s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.i StatusCode="S" s ItemStatus="Y"
	.s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	..s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	..i FullFileName'="" d
	...s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	...i MediumDR'="" s ServerDR=$P(^DHCRBCServer("Medium",MediumDR),"^",1) q:(ServerDR="")
	...s IP = $P($g(^DHCRBCServer("Server",ServerDR)),"^",2)
	...s Port=$P($g(^DHCRBCServer("Server",ServerDR)),"^",3)
	...s User=$P($g(^DHCRBCServer("Server",ServerDR)),"^",5)
	...s Pwd =$P($g(^DHCRBCServer("Server",ServerDR)),"^",6)
	s ResInfo=IP_"^"_Port_"^"_User_"^"_Pwd
	b //ResInfo
	q ResInfo
}

Query QueryStudyByPaadmDR(paadmdr As %String, LocDr As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String")
{
}

ClassMethod QueryStudyByPaadmDRExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StDate As %String, EndDate As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryStudyByPaadmDR","1906","","","")
	//s paadmdr="2298"
	//s LocDr="1140"
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^PaInfo=paadmdr_"^"_LocDr
	s LocDr=$p(LocDr,$c(0))
	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
  	i $g(paadmdr)="" Set qHandle=$lb(0,repid,0)
    q:$g(paadmdr)="" $$$OK
  	
 	
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName=""
	s RptNum = 0
	s OrderRowid=""
	s ItemStatusCode=""
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName="",Report=""
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="")
	.i LocDr'="" q:(replocdr'=LocDr)
	.i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.i ClinicRowid="" q
	.s IsVerify="N"  ;没有审核
	.s resrowid="" 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.s strTime=$zt(Time1)
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s Memo=""
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	.q:(ServerMaterial'="S") ;不是检查项目的则退出
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.i ($g(^DHCRisVersion)="BJ_DT")&(replocdr="85") d ;地坛医院 心电科 做接口，如果医嘱状态为执行，则报告状态变为发布
	..i ItemStatusCode="E"  s ItemStatus="Y"
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s Imgrowid=0
	..s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	..i Imgrowid'="" s IshasImg="Y"
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	...s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i StatusCode="S" s ItemStatus="Y" s Report="Report"
	....s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.....s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.....i FullFileName'="" d
	......s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	......s MediumName=$P(^DHCRBCServer("Medium",MediumDR),"^",2)
	.;qzg 0515 add
	.s ItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(OrderRowid,itemsub)
	.Do OutStudy
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutStudy
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,"Image","Shut",$g(Report),Memo)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
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

ClassMethod QueryStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///   QueryALLStudyByPaadmDR
Query QueryALLStudyByPaadmDR(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String, ALLFlag As %String = "N") As %Query(ROWSPEC = "TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String,ImageUrl:%String,Grade:%String,TIsModify:%String,TIsReaded:%String")
{
}

ClassMethod QueryALLStudyByPaadmDRExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String, ALLFlag As %String = "N") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryALLStudyByPaadmDR","769","","","")

  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
  	s ^dhcrisqasbpdrght=paadmdr
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LocDr=$p(LocDr,$c(0))
	s StDate=$p(StdDate,$c(0))
	s EndDate=$p(enddate,$c(0))
	s Memo="",ItemStatus="",StatusCode=""
	s RegNo="",StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="N",MediumDR=""
    s ^tmp("2015092801")=paadmdr_"^"_LocDr_"^"_StdDate_"^"_enddate
	s PAPMIDR = $p(^PAADM(paadmdr),"^",1)
	s PAType="" f  s PAType=$o(^PAPERdr(PAPMIDR,"ADM",PAType)) q:PAType=""  d
	.s PaadmdrOne=0 f  s PaadmdrOne=$o(^PAPERdr(PAPMIDR,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
	..q:(ALLFlag'="Y")&(paadmdr'=PaadmdrOne)
	..;w !,"PaadmdrOne="_PaadmdrOne
	..s RegNo="",StudyNo="",strOrderName="",ItemStatus="",IsIll="",ItemStatusCode=""
	..s RptNum = 0
	..s OrderRowid=""
 	..s OrderRowid=$o(^OEORD(0,"Adm",PaadmdrOne,OrderRowid)) 
 	..q:OrderRowid=""
 	..s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	..s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)
	..s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	...;不是检查项目的则退出  
	...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2) 
	...q:(arcimid="")
	...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	...q:(ServerMaterial'="S") 
	...s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	...q:(replocdr="")
	...q:(LocDr'="")&(replocdr'=LocDr)
	...;没有配置临床查看报告路径退出
	...s ClinicRowid=0
	...s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	...q:(ClinicRowid="")
	...i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	...;医嘱状态
	...s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...;医嘱日期和时间
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...s strDate=##class(websys.Conversions).DateLogicalToHtml(Date1) ;$zd(Date1,3)
	...s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	...s strTime=$zt(Time1)
	...s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OrderRowid_"||"_itemsub)
	...s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(OrderRowid_"||"_itemsub)    //申请单号
	...;这里取个巧 : 不管带不带部位,都可以走循环(无部位也走一次循环，就是部位为空)
	...f iBody=1:1:$L(bodydrList,"^")  d  
	....s bodypart=$p($g(bodydrList),"^",iBody)
	....s bodypartRowid=$p($g(bodypart),":",1) 
	....s bodypartDesc=$p($g(bodypart),":",2)
	....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	....if bodypartDesc'="" d
	.....s strOrderName=strOrderName_" ("_bodypartDesc_")"
	....s Memo=""
	....s StudyNo="",ItemStatus="N",IsIll="N"
	....s Image="",Shut="",Report="",ImageUrl="",Grade=""
	....s orderStatusInfo=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(OrderRowid_"||"_itemsub,bodypartRowid)
	....s ItemStatusCode=$p($g(orderStatusInfo),"^",1)
	....q:(ItemStatusCode'="V")&(ItemStatusCode'="E")	
	....s IsVerify="N"  ;没有审核
	....;s resrowid=""  
	....s oeorditemdr=OrderRowid_"||"_itemsub
	....s RegDR=##class(web.DHCRisResApptSchudleSystem).getRegRowid(oeorditemdr_"^"_bodypartRowid ) ;$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	....i $g(RegDR)'="" d
	.....s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.....s ImageUrl=$p(^DHCPACRegInfo(RegDR),"^",22)      ;存放外部传输过来的URL
	....s StatusCode=""
	....i StudyNo'="" d
	.....s Imgrowid=0
	.....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	.....i Imgrowid'="" s IshasImg="Y"
	.....s IshasImg=..GetImageStatus(StudyNo)
	.....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	......s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	......s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	......q:(StatusDR="")
	......s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	......s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	......s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	......i StatusCode="S" d
	.......s ItemStatus="Y"
	.......s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	........s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	........i FullFileName'="" s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	.....;医嘱结果状态（暂时无法考虑分部位的医嘱）
	.....s tmpItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(OrderRowid,itemsub)
	.....if StudyNo'="" d
	......s ItemStatus=$p(tmpItemStatus,"^",1)
	......s ItemCode=$p(tmpItemStatus,"^",2)
	....i StatusCode="S" d
	.....s Image="图像"
	.....;s Shut="关闭"
	.....s Report="报告"
	.....s Grade="评级"
	....s isModify=""
	....s isReaded=""
	....s IsModify=""
	....s IsReaded=""
	....i StudyNo'="" d
	.....s PortalRowId=0
	.....s PortalRowId=$o(^DHCRBCLINICCHECKRPTINFOi(oeorditemdr,StudyNo,PortalRowId))
	.....i PortalRowId'="" d
	......s myDocCode=%session.Get("LOGON.USERCODE")
	......s CMStatus=##class(RISService.TrakRISService).GetRPTCMStatus(oeorditemdr,StudyNo,myDocCode)
	......s isReaded=$p(CMStatus,"^",1)
	......s isModify=$p(CMStatus,"^",2)
	......i isModify="Y" d
	.......s IsModify="已修改"
	......e  d
	.......s IsModify=""
	......i isReaded="Y" d
	.......s IsReaded="已阅读"
	......e  d
	.......i Report="报告" d
	........s IsReaded="未阅读"
	.......e  d
	........s IsReaded=""
	....Do OutALLStudy
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutALLStudy
	//set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumDR,Memo)
	//set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,"Image","Shut","Report",Memo)
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,Image,Shut,Report,Memo,ImageUrl,Grade,IsModify,IsReaded)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryALLStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
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

ClassMethod QueryALLStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetClinicSet(LocDr As %String)
{
	
	//d ##class(web.DHCRisclinicQueryOEItemDo).GetClinicSet("1140")
	s ResInfo=""
	s ClinicDr=0
	q:(LocDr="") ""
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",LocDr,ClinicDr)) q:(ClinicDr="")
	s ReportFullFil=$P(^DHCRBC("ClinicSet",ClinicDr),"^",2)
	s RhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",3)
	s RRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",4)
	s RhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",5)
	s RStuyParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",6)
	s RDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",7)
	s ImageFullFile=$P(^DHCRBC("ClinicSet",ClinicDr),"^",8)
	s IhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",9)
	s IRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",10)
	s IhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",11)
	s IStudyNoParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",12)
	s IDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",13)
	s RhasOParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",14)
	s ROtherParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",15)
	s IOtherParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",17)
	s IhasOther=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",16)
	
	s ResInfo = ReportFullFil_"^"_RhasReg_"^"_RRegParam_"^"_RhasStudyNo_"^"_RStuyParam_"^"_RDelim_"^"_ImageFullFile_"^"_IhasReg_"^"_IRegParam_"^"_IhasStudyNo_"^"_IStudyNoParam_"^"_IDelim_"^"_RhasOParam_"^"_ROtherParam_"^"_IOtherParam_"^"_IhasOther
	q ResInfo
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

/// //////////////////////////////////////////////////////////////////////
/// 以下为电子病历所写的接口
/// 根据就诊号和起始时间查询病人检查医嘱列表
Query SelectPACSItemListByDate(paadmdr As %String, StDate As %String, EndDate As %String, ArcItemDRParm As %String) As %Query(ROWSPEC = "ItemName:%String,OEOrdItemDR:%String,RptRowID:%String")
{
}

ClassMethod SelectPACSItemListByDateExecute(ByRef qHandle As %Binary, paadmdr As %String, StDate As %String, EndDate As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectPACSItemListByDate","389","61151","61181")
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
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.i ((Date1<StDate)!(Date1>EndDate)) q
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.s strTime=$zt(Time1)
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ArcItemDR=$p(^OEORD(OrderRowid,"I",itemsub,"1"),"^",1)
	.b //ArcItemDR
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s ReportRowID=0
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s ReportRowID=RptRowId
	..Do OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(strOrderName,oeorditemdr,ReportRowID)
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
	...i (TypeId=2)&&($g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "") d
	....s RptContent=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
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
	
	s ExamDesc="",strResult="",strOrderName=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)

	s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report-Oeorditm",OEItemRowID,RptRowId)) q:(RptRowId="")  d
	.i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" d
	..s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
    .i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" d
	..s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
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
	
	s ExamDesc="",strResult="",strOrderName=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)

	s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report-Oeorditm",OEItemRowID,RptRowId)) q:(RptRowId="")  d
	.i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" d
	..s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")
    .i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" d
	..s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
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

/// do ##class(web.DHCRisclinicQueryOEItemDo).SaveStudyGrade("20017||3860^20017-38604^1^1^600")
ClassMethod SaveStudyGrade(Info As %String) As %String
{
	s OeOrditemID=$p($g(Info),"^",1)
	s StudyNo=$p($g(Info),"^",2)
	s DoctorDR=$p($g(Info),"^",3)
	s RptGradeID=$p($g(Info),"^",4)
	s ImgGradeID=$p($g(Info),"^",5)
	s ReportDesc=..GetDecsbySelID(RptGradeID)
	s ImageDesc=..GetDecsbySelID(ImgGradeID)
	s Date=+$h
	s Time=$p($h,",",2)
	s ret="",SendMessage=""
	s SendMessage=OeOrditemID_"^"_ReportDesc_"^"_ImageDesc
	
	q:(OeOrditemID="") "-1"
	
	s rowid=""
 	&sql(select DRIG_Rowid into :rowid from DHCRBC_ReportImage_Grade where DRIG_OEOrdItem_DR =:OeOrditemID)
	i (rowid="") d
	 .&sql(insert into DHCRBC_ReportImage_Grade(DRIG_OEOrdItem_DR,DRIG_StudyNo,DRIG_Doctor_DR,DRIG_Grade_Date,DRIG_Grade_Time)
	      values(:OeOrditemID,:StudyNo,:DoctorDR,:Date,:Time))
	 .s srowid=$p(%ROWID,$c(1))
     .i srowid'="" d
     ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",3)=ReportDesc
     ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",4)=ImageDesc
     ..s ^DHCRISSTUDYGRADEID(srowid)=RptGradeID_"^"_ImgGradeID
     ..s ^DHCRISISGRADE(OeOrditemID)="Y"
      
	e  d
	.&sql(update DHCRBC_ReportImage_Grade(DRIG_OEOrdItem_DR,DRIG_StudyNo,DRIG_Doctor_DR,DRIG_Grade_Date,DRIG_Grade_Time)
	     values(:OeOrditemID,:StudyNo,:DoctorDR,:Date,:Time) where DRIG_Rowid=:rowid)
	.s srowid=$p($g(%ROWID),$c(1))
    .i srowid'="" d
    ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",3)=ReportDesc
    ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",4)=ImageDesc
    ..s ^DHCRISSTUDYGRADEID(srowid)=RptGradeID_"^"_ImgGradeID
    ..s ^DHCRISISGRADE(OeOrditemID)="Y"
    
    if (SQLCODE="0")
    {
	    ;s ret=..SendMessageInfo(SendMessage)
	}
    
	q SQLCODE_"^"_ret
}

/// do ##class(web.DHCRisclinicQueryOEItemDo).GetGradeInfo("68238||526")
ClassMethod GetGradeInfo(oeorditemdr As %String) As %String
{
	s (ArcItemDesc,ReportDesc,ImageDesc,Date,Time,DoctorDR,DoctorDesc,arcimid)=""
	s (OrderRowid,arcimid,DRIGRowid,StudyNo,Info,SelRptID,SelImgID,RptImgInfo)=""
	q:(oeorditemdr="") "^^^^^^^^"
	
	s OrderRowid=$p(oeorditemdr,"||",1)
	s itemsub=$p(oeorditemdr,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    i arcimid'=""
    {
      s ArcItemDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    }
    
    s DRIGRowid=$o(^DHCRBCRIGi("OeOrdItemID-Grade",oeorditemdr,0))
    i DRIGRowid'=""
    {
	  s ReportDesc=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",3)
	  s ImageDesc=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",4)
	  s DoctorDR=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",5)
	  i DoctorDR'="" s DoctorDesc=$p($g(^SSU("SSUSR",DoctorDR)),"^",2)
	  s Date=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",6)
	  i Date'="" s Date=$zd(Date,3) 
	  s Time=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",7)
	  i Time'="" s Time=$zt(Time,1) 
	  s RptImgInfo=$g(^DHCRISSTUDYGRADEID(DRIGRowid))
	  i (RptImgInfo'="")
	  {
		  s SelRptID=$p(RptImgInfo,"^",1)
		  s SelImgID=$p(RptImgInfo,"^",2)
	  }
	  
	}
	
	s StudyNo=..GetStudyNo(oeorditemdr)
	
	s Info=StudyNo_"^"_ArcItemDesc_"^"_ReportDesc_"^"_ImageDesc_"^"_DoctorDesc_"^"_Date_"^"_Time_"^"_SelRptID_"^"_SelImgID
	
	q Info
}

/// w ##class(web.DHCRisWriteReport).GetStudyNo("55918||1711")
ClassMethod GetStudyNo(OrdItemID As %String) As %String
{
	q:(OrdItemID="") ""
	s StudyNo=""
	
	s Rowid=$o(^DHCPACRegInfoi("OEORI",OrdItemID,0))
	i Rowid'="" d
	.s StudyNo=$p($g(^DHCPACRegInfo(Rowid)),"^",2)
	q StudyNo
}

/// w ##class(web.DHCRisclinicQueryOEItemDo).IsGrade("20017||3860")
ClassMethod IsGrade(OrdItemID As %String)
{
	 s IsSave="N"
	 
	 i ($d(^DHCRISISGRADE(OrdItemID)))
	 {
		 s IsSave=$g(^DHCRISISGRADE(OrdItemID))
	 }
	 
	 q IsSave
}

/// do ##class(web.DHCRisclinicQueryOEItemDo).GetUseList()
ClassMethod GetUseList() As %String
{
	s ret=""
	s retA="1"_$C(1)_"优-1"
	s retB="2"_$C(1)_"良-2"
	s retC="3"_$C(1)_"差-3"
	s ret=retA_"^"_retB_"^"_retC
	q ret
}

ClassMethod GetDecsbySelID(SelID As %String) As %String
{
	s Desc=""
	if (SelID="1")
	{
		s Desc="优"
	}
	elseif(SelID="2")
	{
		s Desc="良"
	}else
	{
		s Desc="差"
	}
	
	q Desc
}

// 医嘱号^评价标识(1:影像&2:报告)^评价结果(影响评价&报告评价)

ClassMethod SendMessageInfo(Info As %String) As %String
{
	s (OeOrditemID,ReportDesc,ImageDesc,MessageInfo)=""
	s (ReportFlag,ImgFlag,ret,value)=""
	
    s OeOrditemID=$p(Info,"^",1)
    s ReportDesc=$p(Info,"^",2)
    s ImageDesc=$p(Info,"^",3)
    
    i ReportDesc'="" d
    .s ReportFlag="2"
    i ImageDesc'="" d
    .s ImgFlag="1"
    
    s MessageInfo=OeOrditemID_"^"_ImgFlag_"&"_ReportFlag_"^"_ImageDesc_"&"_ReportDesc
    s value=##class(web.DHCENS.EnsHISService).SendReportEvaluate(MessageInfo)
    i (value'="")
    {
	    s ret=$p(value,"^",1)
	}
	
	q ret
}

/// w ##class(web.DHCRisclinicQueryOEItemDo).IsHasRpt("77244")
ClassMethod IsHasRpt(paadmdr As %String) As %String
{
		
	s RegNo="",StudyNo="",ItemStatus="",oeorditemdr=""
	s RptNum = 0
	s OrderRowid=""
	s ItemStatusCode="",IsExit="N"
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	q:(OrderRowid)=""
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",oeorditemdr=""
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="") 
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.q:(ClinicRowid="")
	.s resrowid="" 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	.q:(ServerMaterial'="S") ;不是检查项目的则退出
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:(ItemStatusCode="D")
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i StatusCode="S" s IsExit="Y"
	....i IsExit="Y"  BREAK:IsExit
	
	q IsExit
}

// w ##class(web.DHCRisclinicQueryOEItemDo).ClinicRecordSet(^DHCRISTMP("AllInfo"),^DHCRISTMP("Code"))

ClassMethod ClinicRecordSet(AllInfo As %String, Code As %String) As %String
{
	s ^DHCRISTMP("AllInfo")=AllInfo
	s ^DHCRISTMP("Code")=Code
	s RecLocDR=$p($g(AllInfo),"^",1)
	s LoginLocDR=$p($g(AllInfo),"^",2)
	s RegNo=$p($g(AllInfo),"^",3)
	s StudyNo=$p($g(AllInfo),"^",4)
	s Date=+$h
	s Time=$p($h,",",2)
	s UserDR=$p($g(AllInfo),"^",5)
	s OrditemDR=$p($g(AllInfo),"^",6)
	
	s SQLCODE=0
	q:(StudyNo="") SQLCODE
	
	s Rowid=""
	s Rowid=$o(^DHCRBDOCRECORDi("StudyNo",StudyNo,Rowid))
	i (Rowid'="")
	{
		s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",1)=RecLocDR
		s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",2)=LoginLocDR
		s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",3)=RegNo
		s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",4)=StudyNo
		s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",13)=OrditemDR
		
		i (Code="R")
		{
		  d ..ReturnCheckOfClinicRpt(StudyNo,UserDR)    //guanhantian,2015-01-16
		  s (patlvlinfo,patmasdr,EncryptLevel)=""
       	  s patmasdr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),patmasdr))
       	  b //patmasdr
  	      s patlvlinfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patmasdr,.ErrMsg)   //7.2以下老库没有此函数
   	      i patlvlinfo'="" d
          .s EncryptLevel=$p(patlvlinfo,"^",4)

          d ##class(web.DHCRisApplicationBill).InvokeHISLog("DHCPACSCHECKRPT",OrditemDR,EncryptLevel)
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",5)=Date
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",6)=Time
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",7)=UserDR
		}
		elseif(Code="I")
		{
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",9)=Date
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",10)=Time
		  s $p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",11)=UserDR
		}
	}
	else
	{
		i (Code="R")
		{
			d ..ReturnCheckOfClinicRpt(StudyNo,UserDR)    //guanhantian,2015-01-16
			s (patlvlinfo,patmasdr,EncryptLevel)=""
       	    s patmasdr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),patmasdr))
  	        b //patmasdr 2
  	        s patlvlinfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patmasdr,.ErrMsg)   //7.2以下老库没有此函数
   	        i patlvlinfo'="" d
            .s EncryptLevel=$p(patlvlinfo,"^",4)
	      
            d ##class(web.DHCRisApplicationBill).InvokeHISLog("DHCPACSCHECKRPT",OrditemDR,EncryptLevel)
			&sql(insert into  DHCRB_DOCTORRECORD(DDR_Loc_DR,DDR_LoginLoc_DR,DDR_PatientID,DDR_StudyNo,DDR_DATE,DDR_TIME,DDR_User_DR,DDR_Orditem_DR) 
	    								values (:RecLocDR,:LoginLocDR,:RegNo,:StudyNo,:Date,:Time,:UserDR,:OrditemDR))
		}
		elseif(Code="I")
		{
			&sql(insert into  DHCRB_DOCTORRECORD(DDR_Loc_DR,DDR_LoginLoc_DR,DDR_PatientID,DDR_StudyNo,DDR_IDATE,DDR_ITIME,DDR_IUser_DR,DDR_Orditem_DR) 
	    								values (:RecLocDR,:LoginLocDR,:RegNo,:StudyNo,:Date,:Time,:UserDR,:OrditemDR))
		}
	}
	
	q SQLCODE
}

/// do ##class(web.DHCRisclinicQueryOEItemDo).IsRptView("20017||3862","R")
ClassMethod IsRptView(OrditemDR As %String, Code As %String) As %String
{
	s IsView="N",Rowid="",Date=""
	q:(OrditemDR="") "Y"
	
	s Rowid=$o(^DHCRBDOCRECORDi("OrdItem",OrditemDR,Rowid))
	i (Rowid'="")
	{
		if (Code="R")
		{
			s Date=$p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",5)
			i Date'="" s IsView="Y"
		}
		elseif (Code="I")
		{
			s Date=$p(^DHCRBDOCRECORD("DOCTOR-RECORD",Rowid),"^",9)
			i Date'="" s IsView="Y"
		}

	}
	
	q IsView
}

/// w ##class(web.DHCRisclinicQueryOEItemDo).IsUnRptView("77244","R")
ClassMethod IsUnRptView(paadmdr As %String, Code As %String) As %String
{
	s RegNo="",StudyNo="",ItemStatus="",oeorditemdr=""
	s RptNum = 0
	s OrderRowid=""
	s ItemStatusCode="",UnView="",IsExit="N"
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	q:(OrderRowid)=""
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",oeorditemdr=""
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="") 
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.q:(ClinicRowid="")
	.s resrowid="" 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	.q:(ServerMaterial'="S") ;不是检查项目的则退出
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:(ItemStatusCode="D")
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i StatusCode="S" s UnView=..IsRptView(oeorditemdr,Code)
	....i UnView="N" s IsExit="Y" BREAK:IsExit
	
	q IsExit
}

// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryListByAdmDate","0000123749","","2008-10-01","2014-01-01")

Query QueryListByAdmDate(RegNo As %String, Inpaadmdr As %String = "", StDate As %String, EndDate As %String) As %Query(ROWSPEC = "admdate:%String,paadmdr:%String,admTime:%String,admNo:%String")
{
}

ClassMethod QueryListByAdmDateExecute(ByRef qHandle As %Binary, RegNo As %String, Inpaadmdr As %String = "", StDate As %String, EndDate As %String) As %Status
{
	i $g(RegNo)="" Set qHandle=$lb(0,repid,0)
  	Quit:$g(RegNo)="" $$$OK
	
 	s StDate=$p(StDate,$c(0))
 	i (StDate'="")
 	{
	 	s StDate=$zdh(StDate,"3")
	}else
	{
	    s StDate=$zd($h,"3")
	}
 	
	s EndDate=$p(EndDate,$c(0))
	
	i (EndDate'="")
	{ 
	    s EndDate=$zdh(EndDate,"3")
	}else
	{
		s EndDate=$zd($h,"3")
	}
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	
	s PatmasRowid=""
	s PatmasRowid=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),PatmasRowid))

	for date=StDate:1:EndDate d
	.s paadmdr=0 f  s paadmdr=$o(^PAADMi("PAADM_AdmDate",date,paadmdr)) q:paadmdr=""  d 
	..q:((Inpaadmdr'="")&(Inpaadmdr'=paadmdr))
	..s GetPatmasRowid=""
	..s GetPatmasRowid=$p($g(^PAADM(paadmdr)),"^",1)
	..q:((GetPatmasRowid'="")&(GetPatmasRowid'=PatmasRowid))
	..s admNo="",admdate="",admTime=""
	..s admdate=$p($g(^PAADM(paadmdr)),"^",6)
	..i admdate'="" s admdate=$zd(admdate,"3")
	..s admTime=$p($g(^PAADM(paadmdr)),"^",7)
	..i admTime'="" s admTime=$ZT(admTime,"1")
	..s admNo=$p($g(^PAADM(paadmdr)),"^",81)
	..Do OutAdmInfo
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutAdmInfo
	set Data=$lb(admdate,paadmdr,admTime,admNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryListByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListByAdmDateExecute ]
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

ClassMethod QueryListByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListByAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryAllStudy","20019","","","")
Query QueryAllStudy(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Query(ROWSPEC = "RegNo:%String,StudyNo:%String,OrderName:%String,Date:%String,ItemStatus:%String,oeorditemdr:%String,IsIll:%String,LocName:%String,LocDR:%String,IshasImg:%String,MediumName:%String,Image:%String,Shut:%String,Report:%String,Memo:%String,ImageUrl:%String,Grade:%String")
{
}

ClassMethod QueryAllStudyExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Status
{
	
  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LocDr=$p(LocDr,$c(0))
	s StDate=$p(StdDate,$c(0))
	s EndDate=$p(enddate,$c(0))
	s Memo="",ItemStatus=""
	s RegNo="",StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="N",MediumDR=""

	s PAPMIDR = $p(^PAADM(paadmdr),"^",1)
	s PAType="" f  s PAType=$o(^PAPERdr(PAPMIDR,"ADM",PAType)) q:PAType=""  d
	.s PaadmdrOne=0 f  s PaadmdrOne=$o(^PAPERdr(PAPMIDR,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
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
	...q:(ItemStatusCode'="V")&(ItemStatusCode'="E")
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
	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...s strDate=$zd(Date1,3)
	...s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	...s strTime=$zt(Time1)
	...s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	...s oeorditemdr=OrderRowid_"||"_itemsub
	...s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	...i $g(RegDR)'="" d
	....s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	....s ImageUrl=$p(^DHCPACRegInfo(RegDR),"^",22)      ;存放外部传输过来的URL
	...i StudyNo'="" d
	....s Imgrowid=0
	....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	....i Imgrowid'="" s IshasImg="Y"
	....i IshasImg="Y" s Image="图像"
	....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	.....s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	.....s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.....s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	.....s Memo="" ;$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	.....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.....i StatusCode="S" d
	......s ItemStatus="Y"
	......i ItemStatus="Y" s Report="报告" //s Grade="评级"
	......s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.......s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.......i FullFileName'="" s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	...;qzg 0515 add
	...;s tmpItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(OrderRowid,itemsub)
	...;s ItemStatus=$p(tmpItemStatus,"^",1)
	...;s ItemCode=$p(tmpItemStatus,"^",2)
	...;i ((ItemCode="RE")!(ItemCode="RP")!(ItemCode="V")) d
	....;s Image="图像"
	....;s Shut="关闭"
	....;s Report="报告"
	....;s Grade="评级"
	...Do OutALL
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutALL
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,Image,Shut,Report,Memo,ImageUrl,Grade)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAllStudyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllStudyExecute ]
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

ClassMethod QueryAllStudyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllStudyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryStudybyAdm","20019","","","")
Query QueryStudybyAdm(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Query(ROWSPEC = "RegNo:%String,StudyNo:%String,OrderName:%String,Date:%String,ItemStatus:%String,oeorditemdr:%String,IsIll:%String,LocName:%String,LocDR:%String,IshasImg:%String,MediumName:%String,Image:%String,Shut:%String,Report:%String,Memo:%String,ImageUrl:%String,Grade:%String")
{
}

ClassMethod QueryStudybyAdmExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Status
{
	
  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^PaInfo=paadmdr_"^"_LocDr
	s LocDr=$p($g(LocDr),$c(0))
	s StDate=$p($g(StDate),$c(0))
	s EndDate=$p($g(EndDate),$c(0))
  	i $g(paadmdr)="" Set qHandle=$lb(0,repid,0)
    q:$g(paadmdr)="" $$$OK
  	
 	
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",MediumName="",Image=""
	s RptNum = 0
	s OrderRowid=""
	s ItemStatusCode=""
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr=""
	.s IsIll="",LocName="",IshasImg="",MediumName="",Report="",Memo="",Image=""
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="")
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	.q:(ServerMaterial'="S") ;不是检查项目的则退出
	.i LocDr'="" q:(replocdr'=LocDr)
	.i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.i ClinicRowid="" q
	.s IsVerify="N"  ;没有审核
	.s resrowid="" 
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.s strTime=$zt(Time1)
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:(ItemStatusCode'="V")&(ItemStatusCode'="E")
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s Imgrowid=0
	..s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	..i Imgrowid'="" s IshasImg="Y"
	..i IshasImg="Y" s Image="图像"
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	...s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i StatusCode="S" s ItemStatus="Y" s Report="报告"
	....s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.....s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.....i FullFileName'="" d
	......s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	......s MediumName=$P(^DHCRBCServer("Medium",MediumDR),"^",2)
	.Do OutStudybyAdm
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutStudybyAdm
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,$g(IshasImg),MediumName,$g(Image),$g(Shut),$g(Report),$g(Memo),ImageUrl,$g(Grade))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudybyAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudybyAdmExecute ]
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

ClassMethod QueryStudybyAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudybyAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryCurrentAdmList","20019","","","")
Query QueryCurrentAdmList(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Query(ROWSPEC = "Name:%String,Sex:%String,Age:%String,RegNo:%String,StudyNo:%String,strOrderName:%String,PatientStatus:%String,Type:%String,LocName:%String,strDate:%String,strTime:%String,BKDate:%String,BKTime:%String,RegDate:%String,RegTime:%String,oeorditemdr:%String,replocdr:%String")
{
}

ClassMethod QueryCurrentAdmListExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String) As %Status
{
	
  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^PaInfo=paadmdr_"^"_LocDr
	s LocDr=$p($g(LocDr),$c(0))
	s StDate=$p($g(StDate),$c(0))
	s EndDate=$p($g(EndDate),$c(0))
  	i $g(paadmdr)="" Set qHandle=$lb(0,repid,0)
    q:$g(paadmdr)="" $$$OK
  		
	s (Name,Sex,Age,RegNo,StudyNo,strOrderName,Type,LocName,strDate,strTime,BookedDate,BookedTime,RegDate,RegTime,oeorditemdr,replocdr)=""
	s OrderRowid=""
	s ItemStatusCode=""
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s (Name,Sex,Age,RegNo,StudyNo,strOrderName,Type,LocName,strDate,strTime,BookedDate,BookedTime,RegDate,RegTime,oeorditemdr,replocdr,arcimid)=""
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="")
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	.q:(ServerMaterial'="S") ;不是检查项目的则退出
	.i LocDr'="" q:(replocdr'=LocDr)
	.i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	.s ItemStatusCode=""
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:(ItemStatusCode'="V")&(ItemStatusCode'="E")
	.s GetPatientStatusCode="A"  ;申请
	.s admInfo=""
	.s admInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	.s RegNo=$p($g(admInfo),"^",1)
	.s Name=$p($g(admInfo),"^",2)
	.s Sex=$p($g(admInfo),"^",5)
	.s Age=$p($g(admInfo),"^",4)
	.s Type=$p($g(admInfo),"^",7)
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s strDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
	.s strDate=$zd(strDate,3)
	.s strTime=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) 
	.s strTime=$zt(strTime)
	.s GetRejDR="",Rowid="",regrowid="",CancelFlag=""
	.s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	.i GetRejDR="" s GetPatientStatusCode="RJ"
	.s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid)) //预约
	.i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7)
	.i ((Rowid'="")&(CancelFlag'="Cancel")) d
	..s GetPatientStatusCode="B"
	..s ResSchduleID="",ResouceId="",Date="",StartTime=""
	..s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",Rowid),"^",2)
	..i ResSchduleID'="" d
	...s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	...s ResourceDesc=""
	...i ResouceId'="" d
	....s EqId=$p(^RB("RES",ResouceId),"^",3)
	....s CareProvId=$p(^RB("RES",ResouceId),"^",2)
	....i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	...s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	...i Date'="" s BookedDate=$zd(Date,3)
	...s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
	...i StartTime'="" s BookedTime=$zt(StartTime)
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的
    .i regrowid'="" d
    ..s GetPatientStatusCode="I" 
    ..s StudyNo=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
    ..s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
    ..i RegDate'="" s RegDate=$zd(RegDate,3)
    ..s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	..i RegTime'="" s RegTime=$zt(RegTime,1)
	.q:(((Rowid="")!(CancelFlag="Cancel"))&(regrowid=""))
    .i StudyNo'="" d
    ..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imrowid)) q:Imrowid=""  d
    ...s GetPatientStatusCode="E"    ;正在检查
    ...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    ....s GetReportStatusCode="I"             ;图象已经采集
    ....s HaveImage="是"
    ..s sReportStuatCode="VS"
    ..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    ..i Rptrowid'="" d
    ...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    ...s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    ...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    ...i GetRptStatusDR'="" d
    ....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ....i sReportStuatCode[GetReportStatusCode d
    .....s GetPatientStatusCode="O"
    ....e  d
    .....s GetPatientStatusCode="E"
    .s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .Do OutCurrentAdmList
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutCurrentAdmList
	set Data=$lb(Name,Sex,Age,RegNo,StudyNo,strOrderName,PatientStatus,Type,LocName,strDate,strTime,BookedDate,BookedTime,RegDate,RegTime,oeorditemdr,replocdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCurrentAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrentAdmListExecute ]
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

ClassMethod QueryCurrentAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrentAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetImageStatus(StudyNo As %String) As %String
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

/// guanhantian,2015-01-15
/// 返回4.0临床查看报告事件
ClassMethod ReturnCheckOfClinicRpt(studyno As %String, userid As %String)
{
	q:studyno="" -1 
	s usercode=""
	i userid'="" s usercode=$p(^SSU("SSUSR",userid),"^",1)
	zn "DHC-PACS"
	d ##Class(PACS.RISInterface).InsertCheckOfClinicRpt(studyno,usercode)
	zn "DHC-APP"
	q 0
}

/// do ##class(web.DHCRisclinicQueryOEItemDo).GetPaadmdr("1085295||36")
ClassMethod GetPaadmdr(oeorditemdr As %String)
{
	
    s OrderRowid=$p(oeorditemdr,"||",1)
    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
    w paadmdr
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryExamOrderList","796","","","421","","")
Query QueryExamOrderList(EpisodeID As %String, OrderItemRowid As %String, PatientID As %String, ExamType As %String, StdDate As %String, EndDate As %String) As %Query(ROWSPEC = "TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String,ImageUrl:%String,Grade:%String,TIsModify:%String,TIsReaded:%String")
{
}

ClassMethod QueryExamOrderListExecute(ByRef qHandle As %Binary, EpisodeID As %String, OrderItemRowid As %String, PatientID As %String, ExamType As %String, StdDate As %String, EndDate As %String) As %Status
{
	n (EpisodeID,OrderItemRowid,PatientID,ExamType,StdDate,EndDate,qHandle,%session)
  	
  	s ^DHCRisTemp("QueryExamOrderList")=EpisodeID_"^"_OrderItemRowid_"^"_PatientID_"^"_ExamType_"^"_StdDate_"^"_EndDate
  	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	;b //01
	s StdDate=##class(websys.Conversions).DateHtmlToLogical(StdDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	//w EpisodeID_"^"_OrderItemRowid_"^"_PatientID_"^"_ExamType_"^"_StdDate_"^"_EndDate
	if (OrderItemRowid'="")
	{
		s OrderRowid=$p(OrderItemRowid,"1")
		s itemsub=$p(OrderItemRowid,"2")
		s EpisodeID=$p(^OEORD(OrderRowid),"^",1)
		do OutOrderItem
	}
	elseif (EpisodeID'="")
	{
		s OrderRowid=""	 f  s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,OrderRowid))  q:(OrderRowid="")  d
		.s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
		..s OrderItemRowid=OrderRowid_"||"_itemsub
		..;w !,OrderItemRowid
		..q:('$d(^OEORD(OrderRowid,"I",itemsub,3)))
		..s OrderDate=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
		..;w !,StdDate_"^"_OrderDate_"^"_EndDate
		..q:((StdDate'="")&&(EndDate'="")&&((OrderDate>EndDate)||(OrderDate<StdDate)))
		..do OutOrderItem
	}
	elseif (PatientID'="")
	{
		s PatMasRowid=PatientID   ;$o(^PAPERi("PAPMI_PatNo",$zcvt(PatientId,"U"),""))
		if PatMasRowid'="" d
		.s PAType="" f  s PAType=$o(^PAPERdr(PatMasRowid,"ADM",PAType)) q:PAType=""  d
		..s EpisodeID=0 f  s EpisodeID=$o(^PAPERdr(PatMasRowid,"ADM",PAType,EpisodeID)) q:(EpisodeID="")  d
		...s OrderRowid=""	 f  s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,OrderRowid))  q:(OrderRowid="")  d
		....s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
		.....s OrderItemRowid=OrderRowid_"||"_itemsub
		.....;判断日期
		.....;w !,OrderItemRowid
		.....q:('$d(^OEORD(OrderRowid,"I",itemsub,3)))
		.....s OrderDate=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
		.....;w !,StdDate_"^"_OrderDate_"^"_EndDate
		.....q:((StdDate'="")&&(EndDate'="")&&((OrderDate>EndDate)||(OrderDate<StdDate)))
		.....;w !,"123"
		.....do OutOrderItem
		
	}
	;b //02
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

OutOrderItem
	
	s PatMasRowid=$p(^PAADM(EpisodeID),"^",1)
	s RegNo=$p(^PAPER(PatMasRowid,"PAT",1),"^",1) 
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	q:(arcimid="")
	s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	q:(ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
	;检查分组过滤
	s itmCatRowid=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)	
	s itmArcCatID=$o(^DHCAPARCCA(0,"O",itmCatRowid,""))
	if (itmArcCatID'="")
	{
		//Q:(HospID'="")&($p(^DHCAPARCCA(itmArcCatID),"^",4)'=HospID) ""
		s examTypeRowid=$p(^DHCAPARCCA(itmArcCatID),"^",1)  	/// 检查分类代码
		s examTypeDescGet=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	}

	////s examTypeRowid=$o(^DHCAPARCCA(0,"Cat",itmCatRowid,0))
	//if (examTypeRowid'="")
	//{
	//	s examTypeDescGet=$p(^DHCAPARCCA(examTypeRowid),"^",2)
	//}
	q:((ExamType'="")&&($g(examTypeDescGet)'=ExamType))
	s recLocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	i recLocDr'="" s recLocName=$p(^CTLOC(recLocDr),"^",2)
	s ClinicRowid=$o(^DHCRBCi("LocClinicSet",recLocDr,0))
	;s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	;i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	;q:((ItemStatusCode="D")||(ItemStatusCode="U")||(ItemStatusCode="C"))   ;停止、撤销的医嘱退出
	s OrderDate=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	s strOrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
	s OrderTime=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",15) 
	s strOrderTime=$zt(OrderTime)
	s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OrderItemRowid)
	for iBody=1:1:$L(bodydrList,"^") 
	{
		s (StudyNo,ImageUrl,IshasImg,IsIll,Memo)=""
		s (Image,Report,Grade)=""
		s (isModify,isReaded,IsReaded)=""
		s bodypart=$p($g(bodydrList),"^",iBody)
		s bodypartRowid=$p($g(bodypart),":",1) 
		s bodypartDesc=$p($g(bodypart),":",2)
		s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
		if bodypartDesc'=""  s strOrderName=strOrderName_" ("_bodypartDesc_")"
		s orderStatusInfo=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(OrderItemRowid,bodypartRowid)
		s ItemStatusCode=$p($g(orderStatusInfo),"^",1)
		;w !,ItemStatusCode
		if ((ItemStatusCode="U")||(ItemStatusCode="D")||(ItemStatusCode="C"))
		{
			;非执行和核实状态退出,进入下次循环
			continue
		}
	
		s examStatus="A"   ;默认状态为申请
		s RegRowid=##class(web.DHCRisResApptSchudleSystem).getRegRowid(OrderItemRowid_"^"_bodypartRowid )
		if (RegRowid'="")
		{
			s examStatus="SC"  ;登记
			
			s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
			s ImageUrl=$p(^DHCPACRegInfo(RegRowid),"^",22)      ;存放外部传输过来的URL
			i (StudyNo'="") 
			{
				s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
				s IshasImg=..GetImageStatus(StudyNo)
				i Imgrowid'="" s IshasImg="Y"
				if (IshasImg="Y")
				{
					s examStatus="IM"   ;有图像
				}
				s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
				if (RptRowId'="")
				{
					s examStatus="RP"  ;已写报告
					s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
					s StatusCode=""
					i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
					s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
					s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
					if (StatusCode="S")      ;((StatusCode="V")||(StatusCode="S"))  ;发布后 检查完成
					{
						s examStatus="CM"
					}
				}

			}
			
		}
		else
		{
			s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(OrderItemRowid_"^"_bodypartRowid)
			if (BookedRowid'="")
			{
				s examStatus="BK"   ;预约
			}
		}
		
		if ( ClinicRowid'="")  ;配置了临床查看报告路径才能显示链接
		{
			;默认检查完成后才能查看报告和图像
			i (examStatus="CM")
			{
				s Image="图像"
				;s Shut="关闭"
				s Report="报告"
				s Grade="评级"
			}
			i ($g(StudyNo)'="")
			{
				s PortalRowId=$o(^DHCRBCLINICCHECKRPTINFOi(OrderItemRowid,StudyNo,0))
				if (PortalRowId'="")
				{
					s myDocCode=..GetSession("LOGON.USERCODE")    ;%session.Get("LOGON.USERCODE")
					s CMStatus=##class(RISService.TrakRISService).GetRPTCMStatus(OrderItemRowid,StudyNo,myDocCode)
					s isReaded=$p(CMStatus,"^",1)
					s isModify=$p(CMStatus,"^",2)
					if (isModify="Y") 
					{
						s IsModify="已修改"
					}
					else  
					{
						s IsModify=""
					}
					if (isReaded="Y")
					{
						s IsReaded="已阅读"
					}
					else
					{
						i Report="报告" s IsReaded="未阅读"
						e  s IsReaded=""
					}
				}

			}	

		}
		s ItemStatus=..GetResultStatus(examStatus)
		Do OutExamOrderList
	}  
	
	q
	
OutExamOrderList

	set Data=$lb(RegNo,StudyNo,strOrderName,strOrderDate,ItemStatus,OrderItemRowid,IsIll,recLocName,recLocDr,IshasImg,$g(MediumName),Image,Shut,Report,Memo,ImageUrl,Grade,IsModify,IsReaded)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryExamOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamOrderListExecute ]
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

ClassMethod QueryExamOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetResultStatus(statusCode As %String) As %String
{
	q:(statusCode="") ""
	s StatusDesc=""
	&sql(SELECT RESST_Desc INTO :StatusDesc FROM OEC_ResultStatus WHERE RESST_Code=:statusCode)
	if (StatusDesc="Awaiting")  s StatusDesc="申请"
	q StatusDesc
}

// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryEpisodeListByPatId","0000000260")

// PatientID 为 Patmas表rowid

Query QueryEpisodeListByPatId(PatientID As %String) As %Query(ROWSPEC = "EpisodeDesc:%String,PaadmRowid:%String")
{
}

ClassMethod QueryEpisodeListByPatIdExecute(ByRef qHandle As %Binary, PatientID As %String) As %Status
{
	
	//Quit:$g(patNo)="" $$$OK
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ( PatientID'="" )
	{
		s PatMasRowid=PatientID  ;$o(^PAPERi("PAPMI_PatNo",$zcvt(PatientId,"U"),""))
	}
	if ($g(PatMasRowid)="")
	{
		Set qHandle=$lb(0,repid,0)
 		Quit $$$OK
	}
    
    set ^CacheTemp(repid,1)=$lb("全部就诊","")
    set ind=ind+1

	;s patMasRowid=patNo
	s type=""
	for 
	{
		s type=$o(^PAPERdr(PatMasRowid,"ADM",type))
		;w !,type
		q:(type="")
		if (type="I")
		{
			s typeDesc="住院"
		}
		elseif(type="O")
		{
			s typeDesc="门诊"
		}
		elseif(type="E")
		{
			s typeDesc="急诊"
		}
		else
		{
			s typeDesc="其他"_type
		}
		s paadmRowid=""
		for
		{
			s paadmRowid=$o(^PAPERdr(PatMasRowid,"ADM",type,paadmRowid))
			q:(paadmRowid="")
			s date=$p(^PAADM(paadmRowid),"^",6)
			if (date'="")
			{
				s strDate=##class(websys.Conversions).DateLogicalToHtml(date)    ;$zd(date,3)
			}
			
			s depLoc=$p(^PAADM(paadmRowid),"^",4)
			if (depLoc'="")
			{
				s depLocDesc=$p(^CTLOC(depLoc),"^",2)
			}
			s episodeDesc=$g(depLocDesc)_" ("_$g(strDate)_") "_$g(typeDesc)
			Do OutEpisodeList
		}
	}
	Do DoOut
	k episodeList
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutEpisodeList
	set Data=$lb(episodeDesc,paadmRowid)
	s episodeList(date,paadmRowid)=Data
 	;Set ^CacheTemp(repid,ind)=Data
 	;Set ind=ind+1
	quit
	
DoOut
	s dateFind="" f  s dateFind=$o(episodeList(dateFind),-1) q:(dateFind="")  d
	.s admGet="" f  s admGet=$o(episodeList(dateFind,admGet)) q:(admGet="")  d
	..Set ^CacheTemp(repid,ind)=episodeList(dateFind,admGet)
 	..Set ind=ind+1
 	quit
}

ClassMethod QueryEpisodeListByPatIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEpisodeListByPatIdExecute ]
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

ClassMethod QueryEpisodeListByPatIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEpisodeListByPatIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryExamTypeList")

Query QueryExamTypeList() As %Query(ROWSPEC = "TypeDesc:%String,TypeCode:%String,TypeRowid:%String")
{
}

ClassMethod QueryExamTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	
	//Quit:$g(patNo)="" $$$OK
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	//User.DHCAppArcCat   DHC_AppArcCat表
	s arcCaRowid=0
	for 
	{
		s arcCaRowid=$o(^DHCAPARCCA(arcCaRowid))
		q:(arcCaRowid="")
		s typeDesc=$p(^DHCAPARCCA(arcCaRowid),"^",2)
		s typeCode=$p(^DHCAPARCCA(arcCaRowid),"^",1)
		Do outExamTypeList
		
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
outExamTypeList
	set Data=$lb(typeDesc,typeCode,arcCaRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryExamTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamTypeListExecute ]
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

ClassMethod QueryExamTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSession(Name As %Library.String) As %String
{
    s val=""
    q:(Name="") val
    Set $ZT="ERROR"	
	if $Get(%session.Data(Name))=""
	{
		s val=""
	}
	else
	{
		s val=%session.Get(Name)
	}  
	q val
ERROR	
	Set ErrorMsg=$ZE 
 	Quit ""
}

ClassMethod getEpisodeDesc(episodeId As %String) As %String
{
	q:(episodeId="") "全部就诊"
	s type=$p($g(^PAADM(episodeId)),"^",2)
	if (type="I")
	{
		s typeDesc="住院"
	}
	elseif(type="O")
	{
		s typeDesc="门诊"
	}
	elseif(type="E")
	{
		s typeDesc="急诊"
	}
	else
	{
		s typeDesc="其他"_type
	}
	s date=$p($g(^PAADM(episodeId)),"^",6)
	if (date'="")
	{
		s strDate=##class(websys.Conversions).DateLogicalToHtml(date)      ;$zd(date,3)
	}
	
	s depLoc=$p($g(^PAADM(episodeId)),"^",4)
	if (depLoc'="")
	{
		s depLocDesc=$p($g(^CTLOC(depLoc)),"^",2)
	}
	s episodeDesc=$g(depLocDesc)_" ("_$g(strDate)_") "_$g(typeDesc)
	q episodeDesc
}

// w ##class(web.DHCRisclinicQueryOEItemDo).getReportPath("331||30")

ClassMethod getReportPath(OrderItemRowid As %String) As %String
{
	s reportPath=""
	q:(OrderItemRowid="") ""
	//d ##class(web.DHCRisclinicQueryOEItemDo).GetClinicSet("1140")
	s OrderRowid=$p(OrderItemRowid,"||",1)
	s OrderSubRowid=$p(OrderItemRowid,"||",2)
	s recLocRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",6)
	q:(recLocRowid="") ""
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",recLocRowid,0)) 
	q:(ClinicDr="") ""
	
	s paadmRowid=$p(^OEORD(OrderRowid),"^",1)
	s patMastRowid=$p(^PAADM(paadmRowid),"^",1)
	s RegNo=$p(^PAPER(patMastRowid,"PAT",1),"^",1) 
	
	s studyNo=""
	s oneReport="Y"
	s regInfoRowid=""
	s statusReport="CM"
	for
	{
		s regInfoRowid=$o(^DHCPACRegInfoi("OEORI",OrderItemRowid,regInfoRowid))
		q:(regInfoRowid="")
		s StudyNoGet=$p(^DHCPACRegInfo(regInfoRowid),"^",2)
		s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNoGet,""),"-1")

		s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
		s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
		if (StatusCode'="S")      ;((StatusCode="V")||(StatusCode="S"))  ;发布后 检查完成
		{
			s statusReport=""
		}

		if (studyNo="")
		{
			s studyNo=StudyNoGet
		}
		else
		{
			if (studyNo'=StudyNoGet)
			{
				s oneReport="N"
			}
		}
	}
	q:(studyNo="") ""
	q:(statusReport'="CM") ""
	q:(oneReport="N") ""
	
	
	
	s ReportFullFile=$P(^DHCRBC("ClinicSet",ClinicDr),"^",2)
	s RhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",3)
	s RRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",4)
	s RhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",5)
	s RStuyParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",6)
	s RDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",7)
	s RhasOParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",14)
	s ROtherParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",15)
	s RhasOrderItemRowid=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",18)
	s ROrderRowidParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",19)
	
	s reportParam=""
	if (RhasOParam="Y")
	{
		if (ROtherParam="DHCC")
		{
			s reportParam="&LID="_recLocRowid_"&SID="_studyNo_"&OID="_OrderItemRowid_"&USERID="_..GetSession("LOGON.USERID")
		}
	}
	else
	{		
		if (RhasReg="Y")
		{
			s reportParam=RDelim_RRegParam_RegNo
		}
		if (RhasStudyNo="Y")
		{			
			s reportParam=reportParam_RDelim_RStuyParam_studyNo
		}
		if (RhasOrderItemRowid="Y")
		{
			s reportParam=reportParam_RDelim_ROrderRowidParam_OrderItemRowid
		}
	}
	
	s reportPath=ReportFullFile_reportParam
	q reportPath
	/*
	s ImageFullFile=$P(^DHCRBC("ClinicSet",ClinicDr),"^",8)
	s IhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",9)
	s IRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",10)
	s IhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",11)
	s IStudyNoParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",12)
	s IDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",13)
	
	s IOtherParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",17)
	s IhasOther=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",16)
	*/
}

}
