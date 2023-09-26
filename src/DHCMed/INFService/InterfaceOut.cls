/// 名称: DHCMed.INFService.InterfaceOut
/// 描述 外部提供的接口
/// 编写者：ChenJB
/// 编写日期: 2010-09-20
Class DHCMed.INFService.InterfaceOut Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//Ris 提供的接口 影像诊断意见描述等内容

//d ##class(%ResultSet).RunQuery("DHCMed.INFService.InterfaceOut","QueryReportByPaadmDR",51104)

Query QueryReportByPaadmDR(paadmdr As %String) As %Query(ROWSPEC = "TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String,TOtherParam:%String,TOrdCat:%String,ReportContent:%String,ReportResult:%String,strReportDate:%String,strReportTime:%String")
{
}

ClassMethod QueryReportByPaadmDRExecute(ByRef qHandle As %Binary, paadmdr As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryStudyByPaadmDR","969488","","","")
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
  	i $g(paadmdr)="" Set qHandle=$lb(0,repid,0)
    q:$g(paadmdr)="" $$$OK
  		
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName=""
	s RptNum = 0
	s OrderRowid=""
	s OtherParam=""
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
 	
 	//969195
 	
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName="",ExamResult="",ExamDesc=""
	.s replocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	.q:(replocdr="")
	.s ItemStatusCode=""
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:ItemStatusCode="D"

	.i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.i ClinicRowid="" q
	.s IsVerify="N"  ;没有审核
	.s resrowid="" 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ordCatId=$P($G(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)
	.s ordCatDr=""
	.i ordCatId'="" s ordCatDr=$P($G(^ARC("IC",ordCatId)),"^",8)
	.i ordCatDr'="" s TOrdCat=$P($G(^OEC("ORCAT",ordCatDr )),"^",2)
	.e  s TOrdCat=""
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.s strTime=$zt(Time1)
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s Memo=""
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)

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
	...s ExamDesc=$g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))
    ...s ExamResult=$g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))
    ...s ReportDate=$p(^DHCRBStudy("Report",RptRowId),"^",9)
    ...s strReportDate=$zd(ReportDate,3)
    ...s ReportTime=$p(^DHCRBStudy("Report",RptRowId),"^",10)
    ...s strReportTime=$zt(ReportTime)
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i ((StatusCode="S")!(StatusCode="V")) s ItemStatus="Y"
	....s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.....s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.....i FullFileName'="" d
	......s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	......s MediumName=$P(^DHCRBCServer("Medium",MediumDR),"^",2)
	..s RegRowID=0
	..s RegRowID=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowID))
	..s OtherParam = $p($g(^DHCPACRegInfo(RegRowID)),"^",22) //RAR_Note2用作西门子看图像存放的参数
	.Do OutStudy1
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutStudy1
    w "---------------"_ExamResult,!
    // 返回登记号， 检查号， 医嘱名称，医嘱日期， 医嘱状态，医嘱ROWID,IsIll,执行科室名称，执行科室名称ROWID, 是否有图像，介质名称，"Image","Shut","Report"，备注信息，其他调用参数，医嘱子类,检查所见,诊断意见,报告日期，报告时间
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,"Image","Shut","Report",Memo,OtherParam,TOrdCat,ExamDesc,ExamResult,strReportDate,strReportTime)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportByPaadmDRExecute ]
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

ClassMethod QueryReportByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-13
/// Description:  查询微生物检查结果病原体、抗菌药物信息
/// Table：       接口
/// Input：       报告ID ： 报告ID
/// output:       符合条件的项            
/// Return： 
///          
/// w ##class(DHCMed.INFService.InterfaceOut).GetGADataByLab("B000001192693||C001||1")
ClassMethod GetGADataByLab(TestSetRow As %String = "") As %String
{
     n (TestSetRow)
     s ret=""
     q:TestSetRow="" ret
     
     s Config=##Class(websys.Configuration).%OpenId(1)
     s MEDDATA=Config.DataNamespace
     s LABDATA=Config.LabDataNamespace
     s CurrentNS=$ZNSPACE
     d Config.%Close()
 
     s epis=$p(TestSetRow,"||",1)
     s ts=$p(TestSetRow,"||",2)
     s tscnt=$p(TestSetRow,"||",3)
     q:ts="" ret
     q:tscnt="" ret
     ;zn LABDATA
     q:'$d(^TEPI(epis,1,ts,tscnt)) ret
     s itmcode=""
     f  s itmcode=$o(^TEPI(epis,1,ts,tscnt,"DATA",itmcode)) q:itmcode=""  d
     .s type=$p($g(^TTAB("TC",itmcode)),"\",3)
     .q:type'="V"
     .s Res=$p(^TEPI(epis,1,ts,tscnt,"DATA",itmcode),"\",1)
     .s Comm=$P($g(^TTAB("BUG",Res)),"\",1)
     .s ant="" 
     .s antitStr=""
     .f  s ant=$o(^TEPI(epis,1,ts,tscnt,"DATA",itmcode,"ANT",ant)) q:ant=""  d
     ..s temstr=^(ant)     //???
     ..s antname=""
     ..i $d(^TTAB("ANT",ant)) s antname=$p(^TTAB("ANT",ant),"\",1)
     ..s temres1=$p(temstr,"\",1)
     ..s temres=""
     ..i $l(temres1),$d(^TTAB("SENS",temres1)) s temres=$p(^TTAB("SENS",temres1),"\",1)
     ..s temreport=$p(temstr,"\",2)
     ..s temmic=$p(temstr,"\",3)
     ..s temmm=$p(temstr,"\",4)
     ..s:antitStr'="" antitStr=antitStr_$c(2)_antname_"^"_temres
     ..s:antitStr="" antitStr=antname_"^"_temres
     .s row=Comm_$c(3)_antitStr
     .s ret=ret_$c(1)_row
     zn CurrentNS
     q ret
}

Storage Default
{
<Data name="InterfaceOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INFServ5C1.InterfaceOutD</DataLocation>
<DefaultData>InterfaceOutDefaultData</DefaultData>
<IdLocation>^DHCMed.INFServ5C1.InterfaceOutD</IdLocation>
<IndexLocation>^DHCMed.INFServ5C1.InterfaceOutI</IndexLocation>
<StreamLocation>^DHCMed.INFServ5C1.InterfaceOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
