Include webimport

IncludeGenerator webimport

Class web.DHCLISService Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatientID As %String, Search As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//i '$l(AuthFlag) s AuthFlag="N"
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	k ^TMP($zn,$j)
    s ^TMPEPIS=EpisodeID_","_PatientID_","_SearchCriteria
	i AuthFlag="N",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="Y",$l(PatientID) d
	.//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	.//s PAPERId=$o(^PAPERi("PAPMI_PatNo",CardID,""))
	.//i '$l(PAPERId) q
	.//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	.s PAPMIID=$o(^PAPERi("PAPMI_PatNo",PatientID,""))
	.s type="" f  s type=$o(^PAPERdr(PAPMIID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PAPMIID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	s date="" f  s date=$o(^TMP($zn,$j,date),-1) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,date,time),-1) q:time=""  d
	..s OrdId="" f  s OrdId=$o(^TMP($zn,$j,date,time,OrdId)) q:OrdId=""  d
	...s Data=$g(^TMP($zn,$j,date,time,OrdId))
	...d OutputRow
	//i '$l(EpisodeID)	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			i $l(ItmMastDr),##Class(web.DHCLabOrder).isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				//比较日期
				s flag="N"
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				//i flag="N",$l(
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//b 20
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm)=""
				s ReportFlag="N"  //预报告
				i flag="N"{
					i $l(LabTestSetRow){
						//b 100
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							//i ('$l(AuthFlag))!('((ReportStus="N")&(AuthFlag="Y")))
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//b 200
								//接收日期时间
								s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
								i $l(RecDate) s RecDate=$zd(RecDate,3)
								s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
								i $l(RecTime) s RecTime=$zt(RecTime*60,2)
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
								//危急提示
								s TransComm="" //##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)
					}
					//采集日期时间Collection
					s (SpecDate,SpecTime)=""
					s OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OrdRowId,""),-1)
					i $l(OrdExecId){
						s SpecDate=$p(^DHCOrdExec(OrdExecId),"^",13)
						i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
						s SpecTime=$p(^DHCOrdExec(OrdExecId),"^",14)
						i $l(SpecTime) s SpecTime=$zt(SpecTime,2)
					}
					set Data=$lb(OrdRowId,OrdName,SpecName,AuthDate,AuthTime) ///,ReportFlag,TransComm)
					s ^TMP($zn,$j,ReqDate,ReqTime,OrdRowId)=Data
				}
				//d OutputRow
			}
		}
	}
	q
	
OutputRow
	//set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
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
/// CreatDate：    20101101
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称,医嘱申请日期和时间,结果状态,检验号,
///                报告ID,标本,标本采集日期和时间,接收日期和时间
///                审核日期和时间,是否有预报告,危急提示
///                OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,
///                LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,
///                AuthDate,AuthTime,PreReport,WarnComm
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderList(EpisodeID As %String, PatientID As %String, Search As %String) As %Query(ROWSPEC = "医嘱ID:%String,医嘱名称:%String,标本:%String,报告日期:%String,报告时间:%String")
{
}

ClassMethod QueryOrderResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderResultExecute(ByRef qHandle As %Binary, OrderID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	//S ^TMPLABREPORT=OrderID
	If $g(ind)="" Set ind=1
	If '$l(OrderID) Quit 0
	Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	If '$l(TestSetRow) Quit 0
 	Set labno=$Piece(TestSetRow,"||",1)
 	Set ts=$Piece(TestSetRow,"||",2)
 	Set tscnt=$Piece(TestSetRow,"||",3)
 	i $p(^TEPI(labno,1,ts,tscnt),"\",31)'="A" q 0
 	Set isSen="N"
 	k ^TMP($zn,$j)
 	Set tc="" For  Set tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
 	.Set resStr=$Piece(^(tc),"\",1)
 	.Set RecDate=$P(^TEPI(labno,1,ts,tscnt),"\",21)
 	.Set temres=##Class(web.DHCLabTestCode).GetTestCodeResult(labno,tc,resStr,RecDate)
 	.//s ^TMPORDRES(labno,tc)=temres
 	.Set tcDesc=$Piece(temres,$Char(2),2)
 	.Set tcSyn=$Piece(temres,$Char(2),7)
 	.Set tcResult=$Piece(temres,$Char(2),3)
 	.Set tcUnit=$Piece(temres,$Char(2),4)
 	.Set tcFlag=$Piece(temres,$Char(2),5)
 	.Set tcRanges=$Piece(temres,$Char(2),6)
 	.Set WarnFlag=$Piece(temres,$Char(2),8)
 	.Set isSen="无"
 	.If $d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) Set isSen="有"
 	.i '$d(^TTAB("TC",tc,1,ts)) q
 	.Set Order1=$p(^TTAB("TC",tc,1,ts),"\",1)
 	.Set LayOrder=$p(^TTAB("TC",tc,1,ts),"\",2)
 	.Set Order=$p(^TTAB("TS",ts,LayOrder,Order1),"\",15)
 	.s ^TMP($zn,$j,"Order",Order)=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen) ///,WarnFlag)
	
	//排序
	s ord="" f  s ord=$o(^TMP($zn,$j,"Order",ord)) q:ord=""  d
	.s DataStr=^(ord)
	.Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
 	Set ^CacheTemp(repid,ind)=DataStr //Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryOrderResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderResultExecute ]
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
/// CreatDate：    20090514
/// Description:： 根据报告ID得到报告结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID
/// Output：       项目代码,项目名称,缩写,结果,单位,标志,参考范围
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderResult(OrderID As %String) As %Query(ROWSPEC = "项目代码:%String,项目名称:%String,英文缩写:%String,结果:%String,单位:%String,异常标志:%String,参考范围:%String,药敏结果:%String")
{
}

ClassMethod QueryResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultSenExecute(ByRef qHandle As %Binary, OrderID As %String, TC As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i '$l(OrderID) q ""
	s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	i '$l(TSId) q ""
	s epis=$p(TSId,"||",1)
	s ts=$p(TSId,"||",2)
	s tscnt=$p(TSId,"||",3)
	i $p(^TEPI(epis,1,ts,tscnt),"\",31)'="A" q ""
	s ant="" 
	f {
		s ant=$o(^TEPI(epis,1,ts,tscnt,"DATA",TC,"ANT",ant)) 
		q:ant=""
		s temStr=^(ant)
		s antName=""
		i $d(^TTAB("ANT",ant)) s antName=$p(^TTAB("ANT",ant),"\",1)
		///Antibiotics Extra Information 20081121
		s (engName,senResDesc,mic,mm,dosage,surem)=""
		i $d(^DHCANTIBIOTICS(ant)){
			s engName=$p(^DHCANTIBIOTICS(ant),"\",1)
			s dosage=$p(^DHCANTIBIOTICS(ant),"\",4)
			s surem=$p(^DHCANTIBIOTICS(ant),"\",5)
		}
		s senResDr=$p(temStr,"\",1)
		i $l(senResDr),$d(^TTAB("SENS",senResDr)){
			s senResDesc=$p(^TTAB("SENS",senResDr),"\",1)
		}
		s report=$p(temStr,"\",2)
		i report="Y"{
			s mic=$p(temStr,"\",3)
			s mm=$p(temStr,"\",4)
			i $e(mic,1)="." s mic="0"_mic
			i $e(mm,1)="." s mm="0"_mm
			Do OutPutSen
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutSen
	Set Data=$lb(ant,antName,engName,senResDesc,mic,mm) //,dosage,surem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultSenExecute ]
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
/// CreatDate：    20101101
/// Description:： 根据报告ID和项目得到药敏结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID和项目代码
/// Output：       抗生物代码,抗生素名称,抗生素英文名称,药敏结果,mic,mm,用法,尿液浓度用法
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultSen(OrderID As %String, TC As %String) As %Query(ROWSPEC = "抗生素代码:%String,抗生素名称:%String,抗生素缩写:%String,药敏结果:%String,MIC值:%String,mm值:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20101101
/// Description:： 根据报告基本信息
/// Table：        EP_VisitNumber,EP_VisitTestSet
/// Input：        医嘱id
/// Output：       
/// Return：         
/// Others：       
ClassMethod GetReportInfo(OrderID As %String) As %String
{
	i '$l(OrderID) q ""
	s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	i '$l(TSId) q ""
	s epis=$p(TSId,"||",1)
	s ts=$p(TSId,"||",2)
	s tscnt=$p(TSId,"||",3)
	i '$l(epis) q ""
	i '$d(^TEPI(epis)) q ""
	i '$d(^TEPI(epis,1,ts,tscnt)) q ""
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	//SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始 20090305
	s RetStr=""
	s Debtor=$p(^TEPI(epis),"\",18)
	s RetStr="登记号@"_Debtor
	s Doctor=##Class(web.DHCLabCommon).GetReqDoctor(TSId)
	s RetStr=RetStr_"^申请医生@"_Doctor
	s RequestDate=$p(^TEPI(epis),"\",12) 
	If $l(RequestDate) s RequestDate=$zd(RequestDate,3) 
	s RetStr=RetStr_"^申请日期@"_RequestDate
	s PatName=##Class(web.DHCLabCommon).GetPatName(epis)
	s RetStr=RetStr_"^姓名@"_PatName
 	//申请科室
    Set LocCode=$p(^TEPI(epis),"\",36)
    Set PatLoc="" 
    If LocCode'="",$d(^TTAB("USLOC",LocCode)) s PatLoc=$p($g(^TTAB("USLOC",LocCode)),"\",1)
    Set PatLoc1=$p(PatLoc,"-",1),PatLoc2=$p(PatLoc,"-",2)
    If $l(PatLoc2)  d
    .s PatLoc=PatLoc2
    e  d
    .s PatLoc=PatLoc1
    s RetStr=RetStr_"^申请科室@"_PatLoc
 	//采样时间
    Set CollDate=$p(^TEPI(epis,1,ts,tscnt),"\",44)
    If $l(CollDate) Set CollDate=$zd(CollDate,3)
    Set CollTime=$p(^TEPI(epis,1,ts,tscnt),"\",45)
    If $l(CollTime) s CollTime=$zt(CollTime,2)
    s RetStr=RetStr_"^采样时间@"_CollDate_" "_CollTime	
 	//性别
 	s RetStr=RetStr_"^性别@"_##Class(web.DHCLabCommon).GetSpecies(epis)
  	//病区
    Set WardDr=$p(^TEPI(epis),"\",20)
    Set WardName=""
    If $l(WardDr),$d(^TTAB("RH",WardDr)) s WardName=$p(^TTAB("RH",WardDr),"\",1)
 	s RetStr=RetStr_"^申请病区@"_WardName
 	//接收时间
    Set RecDate=$p(^TEPI(epis,1,ts,tscnt),"\",21)
    If $l(RecDate) Set RecDate=$zd(RecDate,3)
    Set RecTime=$p(^TEPI(epis,1,ts,tscnt),"\",22)
    If $l(RecTime) s RecTime=$zt(RecTime*60,2)
 	s RetStr=RetStr_"^接收时间@"_RecDate_" "_RecTime
  	//出生日期
 	Set Value=$p(^TEPI(epis),"\",4)
 	If $l(Value) Set Value=$zd(Value,3)
 	s RetStr=RetStr_"^出生日期@"_Value
 	s RetStr=RetStr_"^检验号@"_epis
 	//报告时间
    Set AuthDate=$p(^TEPI(epis,1,ts,tscnt),"\",4)
    If $l(AuthDate) Set AuthDate=$zd(AuthDate,3)
    Set AuthTime=$p(^TEPI(epis,1,ts,tscnt),"\",5)
    If $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
 	s RetStr=RetStr_"^报告时间@"_AuthDate_" "_AuthTime
	s RetStr=RetStr_"^年龄@"_##Class(web.DHCLabCommon).GetPatAge(TSId,OrderID)
 	//标本
 	Set SpecCode=$p(^TEPI(epis,1,ts,tscnt),"\",46) ;标本类型
 	Set Specimen=""
 	If $l(SpecCode),$d(^TTAB("SPEC",SpecCode)) s Specimen=$p(^TTAB("SPEC",SpecCode),"\",1)
	s RetStr=RetStr_"^标本@"_Specimen
 	//审核人
 	s AuthUser=$p(^TEPI(epis,1,ts,tscnt),"\",6)
 	i $l(AuthUser),$d(^[LABDATA]SSU("SSUSR",1,AuthUser)) s AuthUser=$p(^[LABDATA]SSU("SSUSR",1,AuthUser),"^",2) 
	s RetStr=RetStr_"^报告者@"_AuthUser
 	//病案号
	s RetStr=RetStr_"^病案号@"_$p(^TEPI(epis),"\",6)
 	//医嘱
	s RetStr=RetStr_"^医嘱名称@"_$p(^TTAB("TS",ts),"\",1)
    q RetStr
    
ErrorHandle
	q ""
}

}
